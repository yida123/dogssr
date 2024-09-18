#!/bin/bash

# 检查是否以 root 用户运行
if [ "$EUID" -ne 0 ]; then
  echo "请以 root 用户运行此脚本"
  exit 1
fi

# 定义公钥 URL
PUBLIC_KEY_URL="https://raw.githubusercontent.com/yida123/dogssr/main/dogssr.pub"

# 创建 ~/.ssh 目录并设置权限
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# 将公钥添加到 authorized_keys 文件中
curl -s "$PUBLIC_KEY_URL" >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# 备份原始的 sshd_config 文件
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# 编辑 sshd_config 文件以禁止密码登录
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# 重启 SSH 服务
systemctl restart sshd

echo "SSH 配置已完成，现在仅允许使用 SSH 密钥登录。"
