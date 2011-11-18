Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab1KRMAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 07:00:13 -0500
Received: from katapult.uhulinux.hu ([195.228.155.101]:51596 "EHLO
	katapult.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1KRMAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 07:00:11 -0500
Message-ID: <4EC648C9.8080405@uhulinux.hu>
Date: Fri, 18 Nov 2011 13:00:09 +0100
From: =?ISO-8859-1?Q?Pozs=E1r_Bal=E1zs?= <pozsy@uhulinux.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100515 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: =?ISO-8859-1?Q?Tam=E1si_J=E1nos?= <janusz@uhulinux.hu>
Subject: routing bug?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have been struggling with this not easily reproducible issue since a 
while. I am using linux kernel v3.1.0, and sometimes routing to a few IP 
addresses does not work. What seems to happen is that instead of sending 
the packet to the gateway, the kernel treats the destination address as 
local, and tries to gets its MAC address via ARP.

For example, now my current IP address is 172.16.1.104/24, the gateway 
is 172.16.1.254:

|# ifconfig eth0 eth0      Link encap:Ethernet  HWaddr 00:1B:63:97:FC:DC
           inet addr:172.16.1.104  Bcast:172.16.1.255  Mask:255.255.255.0
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:230772 errors:0 dropped:0 overruns:0 frame:0
           TX packets:171013 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:191879370 (182.9 Mb)  TX bytes:47173253 (44.9 Mb)
           Interrupt:17

# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         172.16.1.254    0.0.0.0         UG    0      0        0 eth0
172.16.1.0      0.0.0.0         255.255.255.0   U     1      0        0 eth0
|

I can ping a few addresses, but not 172.16.0.59:

|# ping -c1 172.16.1.254
PING 172.16.1.254 (172.16.1.254) 56(84) bytes of data.
64 bytes from 172.16.1.254: icmp_seq=1 ttl=64 time=0.383 ms

--- 172.16.1.254 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.383/0.383/0.383/0.000 ms
root@pozsybook:~# ping -c1 172.16.0.1
PING 172.16.0.1 (172.16.0.1) 56(84) bytes of data.
64 bytes from 172.16.0.1: icmp_seq=1 ttl=63 time=5.54 ms

--- 172.16.0.1 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 5.545/5.545/5.545/0.000 ms
root@pozsybook:~# ping -c1 172.16.0.2
PING 172.16.0.2 (172.16.0.2) 56(84) bytes of data.
64 bytes from 172.16.0.2: icmp_seq=1 ttl=62 time=7.92 ms

--- 172.16.0.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 7.925/7.925/7.925/0.000 ms
root@pozsybook:~# ping -c1 172.16.0.59
PING 172.16.0.59 (172.16.0.59) 56(84) bytes of data.
 From 172.16.1.104 icmp_seq=1 Destination Host Unreachable

--- 172.16.0.59 ping statistics ---
1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms
|

When trying to ping 172.16.0.59, I can see in tcpdump that an ARP req 
was sent:

|# tcpdump -n -i eth0|grep ARP
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
15:25:16.671217 ARP, Request who-has 172.16.0.59 tell 172.16.1.104, length 28
|

and /proc/net/arp has an incomplete entry for 172.16.0.59:

|# grep 172.16.0.59 /proc/net/arp

172.16.0.59      0x1         0x0         00:00:00:00:00:00     *        eth0
|

Please note, that 172.16.0.59 /is/ accessible from this LAN from other 
computers.


Does anyone have any idea of what's going on? Thanks,


Balazs Pozsar

ps: I think it is related to this one: https://lkml.org/lkml/2011/11/16/292

