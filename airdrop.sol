// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Airdrop is Ownable {
    IERC20 public token;

    event Airdrop(address indexed to, uint256 amount);

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    function setToken(address _tokenAddress) external onlyOwner {
        token = IERC20(_tokenAddress);
    }

    function executeAirdrop(address[] memory recipients, uint256[] memory amounts) external onlyOwner {
        require(recipients.length == amounts.length, "Invalid input length");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            require(amounts[i] > 0, "Invalid amount");

            _transferTokens(recipients[i], amounts[i]);
            emit Airdrop(recipients[i], amounts[i]);
        }
    }

    function modifyAirdropAmount(address recipient, uint256 newAmount) external onlyOwner {
        require(recipient != address(0), "Invalid recipient address");
        require(newAmount > 0, "Invalid amount");

        _transferTokens(recipient, newAmount);
        emit Airdrop(recipient, newAmount);
    }

    function _transferTokens(address to, uint256 amount) internal {
        require(token.transfer(to, amount), "Token transfer failed");
    }
}
