#!/bin/bash

echo "updating the centos"
sudo yum -y update

echo "installing wget"
sudo yum -y install wget

echo "installing oracle java"

cd /opt

wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.rpm"

rpm -ivh jdk-8u201-linux-x64.rpm

cd ..
echo "installing the tomcat"
wget https://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.16/bin/apache-tomcat-9.0.16.tar.gz
tar -xvf apache-tomcat-9.0.16.tar.gz
mv apache-tomcat-9.0.16 /opt/tomcat

sudo useradd tomcat
sudo groupadd tomcatusers

chown -R tomcat:tomcatusers /opt/tomcat
touch /etc/systemd/system/tomcat.service

echo -e "[Unit] \nDescription = Tomcat9 \nAfter=syslog.target network.target" >> /etc/systemd/system/tomcat.service
echo -e "\n[Service] \nType = forking \nUser=tomcat \nGroup=tomcatusers" >> /etc/systemd/system/tomcat.service
echo -e "\nExecStart=/opt/tomcat/bin/startup.sh \nExecStop=/opt/tomcat/bin/shutdown.sh" >> /etc/systemd/system/tomcat.service
echo -e "\n[Install] \nWantedBy=multi-user.target" >> /etc/systemd/system/tomcat.service

sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

cd 
wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
sudo rpm –ivh mysql57-community-release-el7-9.noarch.rpm
sudo yum -y update
sudo yum -y install mysql-server
sudo systemctl start mysqld
