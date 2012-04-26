Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab2DZO3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:29:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42240 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2DZO3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <1335449254.2775.45.camel@edumazet-glaptop>
References: <CAOFJUkhi6NoECFGcz=rq8-uVXFc90V4SuH=A1+sWdvYDDhO8Ow@mail.gmail.com>
	<1335353427.3274.103.camel@edumazet-glaptop>
	<CAOFJUkj27aF6diDjcZFTyBaTdDdU8URkj+1vr3ECoozbzqDVBg@mail.gmail.com>
	<1335357975.3274.187.camel@edumazet-glaptop>
	<CAOFJUki3Jg+fAWWY70nDUCdxVs5A5VGfwkwUn01a4BX+N5nm-A@mail.gmail.com>
	<1335375781.5951.2.camel@edumazet-glaptop>
	<CAOFJUkhF1205=2sO_a4gT+it42h_1rZU365N-Rb5LVJZa8zvhw@mail.gmail.com>
	<1335449254.2775.45.camel@edumazet-glaptop>
Date: Thu, 26 Apr 2012 16:29:34 +0200
Message-ID: <CAOFJUkhNnD2VVKAuNjU7yW8jh+XZMuzt5N_Qk6oiV21CNK6auQ@mail.gmail.com>
Subject: Re: many rx packets dropped since 2.6.37
From: Chris <xchris89x@googlemail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/26 Eric Dumazet <eric.dumazet@gmail.com>:
>> Okay this is a Fedora-16 VM under KVM with 4 minutes uptime only and dropwatch!
>>
>> 349 dropped packets in 4 minutes uptime??
>>
>
> yes, apparently.
>
> Mostely because of :
>
> 610 with invalid addresses
> 71 dropped because of missing route
> and IPReversePathFilter: 82
>
> It seems you have some work to do on your network config

What do you mean exactly?

This is netstat -s on the hostsystem with 24 days uptime. KVM guests
are connected via bridged networking.

# netstat -s
Ip:
    14750606 total packets received
    4394457 with invalid addresses
    0 forwarded
    0 incoming packets discarded
    5461822 incoming packets delivered
    5149263 requests sent out
Icmp:
    136871 ICMP messages received
    22 input ICMP message failed.
    ICMP input histogram:
        destination unreachable: 30
        timeout in transit: 5
        echo requests: 136809
        echo replies: 27
    149082 ICMP messages sent
    0 ICMP messages failed
    ICMP output histogram:
        destination unreachable: 12269
        echo request: 4
        echo replies: 136809
IcmpMsg:
        InType0: 27
        InType3: 30
        InType8: 136809
        InType11: 5
        OutType0: 136809
        OutType3: 12269
        OutType8: 4
Tcp:
    430 active connections openings
    32123 passive connection openings
    117 failed connection attempts
    39 connection resets received
    2 connections established
    5250012 segments received
    4916354 segments send out
    8781 segments retransmited
    0 bad segments received.
    70 resets sent
Udp:
    74938 packets received
    0 packets to unknown port received.
    0 packet receive errors
    75044 packets sent
UdpLite:
TcpExt:
    2 invalid SYN cookies received
    117 resets received for embryonic SYN_RECV sockets
    809 TCP sockets finished time wait in fast timer
    1 time wait sockets recycled by time stamp
    2400 packets rejects in established connections because of timestamp
    101608 delayed acks sent
    978 delayed acks further delayed because of locked socket
    Quick ack mode was activated 2993 times
    36910 packets directly queued to recvmsg prequeue.
    13392680 packets directly received from backlog
    169 packets directly received from prequeue
    4493014 packets header predicted
    2027 packets header predicted and directly queued to user
    109135 acknowledgments not containing data received
    2686390 predicted acknowledgments
    46 times recovered from packet loss due to SACK data
    TCPDSACKUndo: 16
    613 congestion windows recovered after partial ack
    5 TCP data loss events
    696 timeouts after SACK recovery
    18 timeouts in loss state
    46 fast retransmits
    9 forward retransmits
    193 retransmits in slow start
    6614 other TCP timeouts
    1 sack retransmits failed
    3000 DSACKs sent for old packets
    2091 DSACKs received
    11 connections reset due to unexpected data
    24 connections reset due to early user close
    26 connections aborted due to timeout
    TCPDSACKIgnoredOld: 1333
    TCPDSACKIgnoredNoUndo: 407
    TCPSackShifted: 28
    TCPSackMerged: 93
    TCPSackShiftFallback: 443
IpExt:
    InMcastPkts: 952759
    OutMcastPkts: 20
    InBcastPkts: 887543
    InOctets: 19724020920
    OutOctets: 918687039
    InMcastOctets: 73525673
    OutMcastOctets: 4004
    InBcastOctets: 139495386

>
>> [root@test ~]# uname -r
>> 3.3.2-6.fc16.x86_64
>> [root@test ~]# dropwatch -l kas
>> Initalizing kallsyms db
>> dropwatch> start
>> Enabling monitoring...
>> Kernel monitoring activated.
>> Issue Ctrl-C to stop monitoring
>> 1 drops at netlink_unicast+1bc
>
> this is a false positive, bugfix here :
> http://git.kernel.org/?p=linux/kernel/git/davem/net-next.git;a=commitdiff;h=bfb253c9b277acd9f85b1886ff82b1dd5fbff2ae

Okay :)

>> 3 drops at ip_rcv_finish+f0
>> 1 drops at __netif_receive_skb+583
>> 1 drops at ip_rcv+d3
>> 9 drops at ip_rcv_finish+f0
>> 9 drops at ip_rcv_finish+f0
>> 1 drops at __netif_receive_skb+583
>> 6 drops at ip_rcv_finish+f0
>> 1 drops at nf_hook_slow+12b
>
> do you have drops at iptables level ?

I do not know. Should i turn off iptables for testing?

--
Chris
