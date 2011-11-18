Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab1KRNjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:39:00 -0500
Received: from katapult.uhulinux.hu ([195.228.155.101]:56833 "EHLO
	katapult.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab1KRNi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:38:59 -0500
Message-ID: <4EC65FF1.9010601@uhulinux.hu>
Date: Fri, 18 Nov 2011 14:38:57 +0100
From: =?UTF-8?B?UG96c8OhciBCYWzDoXpz?= <pozsy@uhulinux.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100515 Thunderbird/3.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Sven-Haegar Koch <haegar@sdinet.de>,
        Linux-Kernel-Mailinglist <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VGFtw6FzaSBKw6Fub3M=?= <janusz@uhulinux.hu>,
        netdev@vger.kernel.org
Subject: Re: routing bug?
References: <4EC648C9.8080405@uhulinux.hu>		 <alpine.DEB.2.02.1111181346480.17023@aurora>	 <1321621796.3277.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <4EC65C4B.6050505@uhulinux.hu> <1321623207.3277.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1321623207.3277.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-18 14:33, Eric Dumazet wrote:
> Le vendredi 18 novembre 2011 à 14:23 +0100, Pozsár Balázs a écrit :
>    
>> On 2011-11-18 14:09, Eric Dumazet wrote:
>>      
>>> Le vendredi 18 novembre 2011 à 13:48 +0100, Sven-Haegar Koch a écrit :
>>>
>>>        
>>>> Added netdev list to CC:, there you should have a higher chance of a
>>>> usefull answer.
>>>>
>>>> On Fri, 18 Nov 2011, Pozsár Balázs wrote:
>>>>
>>>>
>>>>          
>>>>> Hi all,
>>>>>
>>>>> I have been struggling with this not easily reproducible issue since a while.
>>>>> I am using linux kernel v3.1.0, and sometimes routing to a few IP addresses
>>>>> does not work. What seems to happen is that instead of sending the packet to
>>>>> the gateway, the kernel treats the destination address as local, and tries to
>>>>> gets its MAC address via ARP.
>>>>>
>>>>> For example, now my current IP address is 172.16.1.104/24, the gateway is
>>>>> 172.16.1.254:
>>>>>
>>>>> |# ifconfig eth0 eth0      Link encap:Ethernet  HWaddr 00:1B:63:97:FC:DC
>>>>>             inet addr:172.16.1.104  Bcast:172.16.1.255  Mask:255.255.255.0
>>>>>             UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>>>>             RX packets:230772 errors:0 dropped:0 overruns:0 frame:0
>>>>>             TX packets:171013 errors:0 dropped:0 overruns:0 carrier:0
>>>>>             collisions:0 txqueuelen:1000
>>>>>             RX bytes:191879370 (182.9 Mb)  TX bytes:47173253 (44.9 Mb)
>>>>>             Interrupt:17
>>>>>
>>>>> # route -n
>>>>> Kernel IP routing table
>>>>> Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
>>>>> 0.0.0.0         172.16.1.254    0.0.0.0         UG    0      0        0 eth0
>>>>> 172.16.1.0      0.0.0.0         255.255.255.0   U     1      0        0 eth0
>>>>> |
>>>>>
>>>>> I can ping a few addresses, but not 172.16.0.59:
>>>>>
>>>>> |# ping -c1 172.16.1.254
>>>>> PING 172.16.1.254 (172.16.1.254) 56(84) bytes of data.
>>>>> 64 bytes from 172.16.1.254: icmp_seq=1 ttl=64 time=0.383 ms
>>>>>
>>>>> --- 172.16.1.254 ping statistics ---
>>>>> 1 packets transmitted, 1 received, 0% packet loss, time 0ms
>>>>> rtt min/avg/max/mdev = 0.383/0.383/0.383/0.000 ms
>>>>> root@pozsybook:~# ping -c1 172.16.0.1
>>>>> PING 172.16.0.1 (172.16.0.1) 56(84) bytes of data.
>>>>> 64 bytes from 172.16.0.1: icmp_seq=1 ttl=63 time=5.54 ms
>>>>>
>>>>> --- 172.16.0.1 ping statistics ---
>>>>> 1 packets transmitted, 1 received, 0% packet loss, time 0ms
>>>>> rtt min/avg/max/mdev = 5.545/5.545/5.545/0.000 ms
>>>>> root@pozsybook:~# ping -c1 172.16.0.2
>>>>> PING 172.16.0.2 (172.16.0.2) 56(84) bytes of data.
>>>>> 64 bytes from 172.16.0.2: icmp_seq=1 ttl=62 time=7.92 ms
>>>>>
>>>>> --- 172.16.0.2 ping statistics ---
>>>>> 1 packets transmitted, 1 received, 0% packet loss, time 0ms
>>>>> rtt min/avg/max/mdev = 7.925/7.925/7.925/0.000 ms
>>>>> root@pozsybook:~# ping -c1 172.16.0.59
>>>>> PING 172.16.0.59 (172.16.0.59) 56(84) bytes of data.
>>>>>   From 172.16.1.104 icmp_seq=1 Destination Host Unreachable
>>>>>
>>>>> --- 172.16.0.59 ping statistics ---
>>>>> 1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms
>>>>> |
>>>>>
>>>>> When trying to ping 172.16.0.59, I can see in tcpdump that an ARP req was
>>>>> sent:
>>>>>
>>>>> |# tcpdump -n -i eth0|grep ARP
>>>>> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
>>>>> listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
>>>>> 15:25:16.671217 ARP, Request who-has 172.16.0.59 tell 172.16.1.104, length 28
>>>>> |
>>>>>
>>>>> and /proc/net/arp has an incomplete entry for 172.16.0.59:
>>>>>
>>>>> |# grep 172.16.0.59 /proc/net/arp
>>>>>
>>>>> 172.16.0.59      0x1         0x0         00:00:00:00:00:00     *        eth0
>>>>> |
>>>>>
>>>>> Please note, that 172.16.0.59 /is/ accessible from this LAN from other
>>>>> computers.
>>>>>
>>>>>
>>>>> Does anyone have any idea of what's going on? Thanks,
>>>>>
>>>>>
>>>>> Balazs Pozsar
>>>>>
>>>>> ps: I think it is related to this one: https://lkml.org/lkml/2011/11/16/292
>>>>>
>>>>> --
>>>>>
>>>>>            
>>> Could you send us result of :
>>>
>>> ip route get 172.16.0.59
>>> ip route list cache match 172.16.0.59
>>>
>>>        
>> I did not tell you in my first mail, that some times different hosts are
>> reachable and unreachable. I will try to not confuse you :)
>> As of now, 172.16.0.59 is OK, and 172.16.0.37 is NOT OK.
>> Also, 172.16.0.64 is OK now, and 172.16.0.42 is NOT OK now.
>>
>> The two commands you have requested give the following output for these
>> IP addresses:
>>
>> These are OK:
>>
>> # ip route get 172.16.0.64
>> 172.16.0.64 via 172.16.1.254 dev eth0  src 172.16.1.22
>>       cache
>> # ip route get 172.16.0.59
>> 172.16.0.59 via 172.16.1.254 dev eth0  src 172.16.1.22
>>       cache
>>
>> These are NOT OK:
>>
>> # ip route get 172.16.0.37
>> 172.16.0.37 dev eth0  src 172.16.1.22
>>       cache<redirected>   ipid 0x97a4
>> # ip route get 172.16.0.42
>> 172.16.0.42 dev eth0  src 172.16.1.22
>>       cache<redirected>   ipid 0x0d21
>>
>> These are OK:
>>
>> # ip route list cache match 172.16.0.59
>> 172.16.0.59 via 172.16.1.254 dev eth0  src 172.16.1.22
>>       cache
>> # ip route list cache match 172.16.0.64
>> 172.16.0.64 via 172.16.1.254 dev eth0  src 172.16.1.22
>>       cache
>>
>> These are NOT OK:
>>
>> # ip route list cache match 172.16.0.37
>> 172.16.0.37 dev eth0  src 172.16.1.22
>>       cache<redirected>   ipid 0x97a4
>> 172.16.0.37 from 172.16.1.22 dev eth0
>>       cache<redirected>   ipid 0x97a4
>> 172.16.0.37 from 172.16.1.22 dev eth0
>>       cache<redirected>   ipid 0x97a4
>> # ip route list cache match 172.16.0.42
>> 172.16.0.42 dev eth0  src 172.16.1.22
>>       cache<redirected>   ipid 0x0d21
>> 172.16.0.42 from 172.16.1.22 dev eth0
>>       cache<redirected>   ipid 0x0d21
>>
>>
>> How can I fix this?
>>
>> Thanks!
>>      
> We are working on it (see threads in netdev)
>
> You can in the meantime
>
> echo 0>/proc/sys/net/ipv4/conf/eth0/accept_redirects
>    

Unfortunately it does not solve the problem for me, I have have these 
"cache <redirected>" entries even after that echo command.

