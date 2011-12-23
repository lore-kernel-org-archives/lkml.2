Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1LWJmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:42:11 -0500
Received: from yuna.grokhost.net ([87.117.228.63]:59535 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab1LWJmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:42:07 -0500
Message-ID: <4EF44CEE.5020704@bootc.net>
Date: Fri, 23 Dec 2011 09:42:06 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: igb + balance-rr + bridge + IPv6 = no go without promiscuous mode
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

As per Eric Dumazet and Dave Miller, I'm opening up a separate thread on 
this issue.

I have two identical servers in a cluster for running KVM virtual 
machines. They each have a single connection to the Internet (irrelevant 
for this) and two gigabit connections between each other for cluster 
replication, etc... These two connections are in a balance-rr bonded 
connection, which is itself member of a bridge that the VMs attach to. 
I'm running v3.2-rc6-140-gb9e26df on Debian Wheezy.

When the bridge is brought up, IPv4 works fine but IPv6 does not. I can 
use neither the automatic link-local on the bridge nor the static global 
address I assign. Neither machine can perform neighbour discovery over 
the link until I put the bond members (eth0 and eth1) into promiscuous 
mode.  I can do this either with tcpdump or 'ip link set dev ethX 
promisc on' and this is enough to make the link spring to life.

This cluster is not currently live so I can easily test patches and 
various configurations.

The relevant parts of /etc/network/interfaces:

iface bond0 inet manual
         slaves eth0 eth1
         bond-mode balance-rr
         bond-miimon 100
         bond-downdelay 200
         bond-updelay 200

iface br0 inet static
         address [snip]
         netmask 255.255.255.224
         bridge_ports bond0
         bridge_stp off
         bridge_fd 0
         bridge_maxwait 5
iface br0 inet6 static
         address [snip]
         netmask 64

lspci:
02:00.0 Ethernet controller [0200]: Intel Corporation I350 Gigabit 
Network Connection [8086:1521] (rev 01)
02:00.1 Ethernet controller [0200]: Intel Corporation I350 Gigabit 
Network Connection [8086:1521] (rev 01)

These use the 'igb' driver.

Thanks,
Chris

-- 
Chris Boot
bootc@bootc.net

