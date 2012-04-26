Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab2DZOHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:07:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34153 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2DZOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:07:43 -0400
Subject: Re: many rx packets dropped since 2.6.37
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris <xchris89x@googlemail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
In-Reply-To: <CAOFJUkhF1205=2sO_a4gT+it42h_1rZU365N-Rb5LVJZa8zvhw@mail.gmail.com>
References: <CAOFJUkhi6NoECFGcz=rq8-uVXFc90V4SuH=A1+sWdvYDDhO8Ow@mail.gmail.com>
	 <1335353427.3274.103.camel@edumazet-glaptop>
	 <CAOFJUkj27aF6diDjcZFTyBaTdDdU8URkj+1vr3ECoozbzqDVBg@mail.gmail.com>
	 <1335357975.3274.187.camel@edumazet-glaptop>
	 <CAOFJUki3Jg+fAWWY70nDUCdxVs5A5VGfwkwUn01a4BX+N5nm-A@mail.gmail.com>
	 <1335375781.5951.2.camel@edumazet-glaptop>
	 <CAOFJUkhF1205=2sO_a4gT+it42h_1rZU365N-Rb5LVJZa8zvhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Apr 2012 16:07:34 +0200
Message-ID: <1335449254.2775.45.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 15:53 +0200, Chris wrote:
> 2012/4/25 Eric Dumazet <eric.dumazet@gmail.com>:
> > On Wed, 2012-04-25 at 16:38 +0200, Chris wrote:
> >> 2012/4/25 Eric Dumazet <eric.dumazet@gmail.com>:
> >> >> Why do we see dropped packets only in virtual environments and bonded
> >> >> network interfaces and not on real network interfaces?
> >> >
> >> > This has to be investigated, eventually.
> >>
> >> Do you have the opportunity to test it? Just install fedora 16 (linux
> >> 3.3) or ubuntu 12.04 (linux 3.2) as guest under kvm and use as virtual
> >> network card virtio_net or e1000.
> >>
> >> You will see many lost rx packets and i have no idea why???
> >
> >
> > You can use drop_monitor / dropwatch to figure out
> >
> > https://fedorahosted.org/dropwatch/
> >
> > http://prefetch.net/blog/index.php/2011/07/11/using-netstat-and-dropwatch-to-observe-packet-loss-on-linux-servers/
> 
> Hello Eric,
> 
> Okay this is a Fedora-16 VM under KVM with 4 minutes uptime only and dropwatch!
> 
> 349 dropped packets in 4 minutes uptime??
> 

yes, apparently.

Mostely because of : 

610 with invalid addresses
71 dropped because of missing route
and IPReversePathFilter: 82

It seems you have some work to do on your network config

> [root@test ~]# uname -r
> 3.3.2-6.fc16.x86_64
> [root@test ~]# dropwatch -l kas
> Initalizing kallsyms db
> dropwatch> start
> Enabling monitoring...
> Kernel monitoring activated.
> Issue Ctrl-C to stop monitoring
> 1 drops at netlink_unicast+1bc

this is a false positive, bugfix here :
http://git.kernel.org/?p=linux/kernel/git/davem/net-next.git;a=commitdiff;h=bfb253c9b277acd9f85b1886ff82b1dd5fbff2ae

> 3 drops at ip_rcv_finish+f0
> 1 drops at __netif_receive_skb+583
> 1 drops at ip_rcv+d3
> 9 drops at ip_rcv_finish+f0
> 9 drops at ip_rcv_finish+f0
> 1 drops at __netif_receive_skb+583
> 6 drops at ip_rcv_finish+f0
> 1 drops at nf_hook_slow+12b

do you have drops at iptables level ?

> 4 drops at ip_rcv_finish+f0
> 1 drops at __netif_receive_skb+583
> 4 drops at ip_rcv_finish+f0
> 1 drops at nf_hook_slow+12b
> 3 drops at ip_rcv_finish+f0
> 3 drops at nf_hook_slow+12b
> 2 drops at __netif_receive_skb+583
> 1 drops at ip6_mc_input+1f6
> 7 drops at ip_rcv_finish+f0
> 1 drops at ip_rcv_finish+f0
> 1 drops at netlink_unicast+1bc
> 1 drops at skb_queue_purge+20
> 2 drops at __netif_receive_skb+583
> 1 drops at ip_rcv_finish+f0
> 1 drops at nf_hook_slow+12b
> 1 drops at ip_rcv_finish+f0
> 1 drops at __netif_receive_skb+583
> 19 drops at ip_rcv+d3
> 2 drops at ip_rcv_finish+f0
> 37 drops at ip_rcv+d3
> 2 drops at __netif_receive_skb+583
> 43 drops at ip_rcv+d3
> 5 drops at ip_rcv_finish+f0
> 1 drops at __netif_receive_skb+583
> 1 drops at nf_hook_slow+12b
> 1 drops at ip6_mc_input+1f6
> 7 drops at ip_rcv_finish+f0
> 39 drops at ip_rcv+d3
> 2 drops at ip6_mc_input+1f6
> 1 drops at netlink_unicast+1bc
> 1 drops at skb_queue_purge+20
> 29 drops at ip_rcv+d3
> 7 drops at ip_rcv_finish+f0
> 2 drops at __netif_receive_skb+583
> 2 drops at ip6_mc_input+1f6
> 54 drops at ip_rcv+d3
> 3 drops at __netif_receive_skb+583
> 2 drops at nf_hook_slow+12b
> 3 drops at ip_rcv_finish+f0
> 1 drops at ip6_mc_input+1f6
> 36 drops at ip_rcv+d3
> 6 drops at ip_rcv_finish+f0
> 2 drops at __netif_receive_skb+583
> 1 drops at nf_hook_slow+12b
> 1 drops at icmpv6_rcv+305
> 37 drops at ip_rcv+d3
> 1 drops at __netif_receive_skb+583
> 2 drops at ip_rcv_finish+f0
> 4 drops at ip_rcv_finish+f0
> 39 drops at ip_rcv+d3
> 2 drops at __netif_receive_skb+583
> 1 drops at netlink_unicast+1bc
> 1 drops at skb_queue_purge+20
> 1 drops at nf_hook_slow+12b
> 38 drops at ip_rcv+d3
> 3 drops at __netif_receive_skb+583
> 2 drops at ip6_mc_input+1f6
> 1 drops at ip_rcv_finish+f0
> 46 drops at ip_rcv+d3
> 1 drops at __netif_receive_skb+583
> 1 drops at ip_rcv_finish+f0
> ^CGot a stop message
> dropwatch> exit
> Shutting down ...
> [root@test ~]# ifconfig | grep dropped
>           RX packets:161562 errors:0 dropped:349 overruns:0 frame:0
>           TX packets:2140 errors:0 dropped:0 overruns:0 carrier:0
>           RX packets:4 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:4 errors:0 dropped:0 overruns:0 carrier:0
> [root@test ~]# uptime
>  15:47:00 up 4 min,  3 users,  load average: 0.01, 0.04, 0.03
> [root@test ~]# netstat -s
> Ip:
>     1553 total packets received
>     610 with invalid addresses
>     0 forwarded
>     0 incoming packets discarded
>     345 incoming packets delivered
>     478 requests sent out
>     71 dropped because of missing route
> Icmp:
>     4 ICMP messages received
>     0 input ICMP message failed.
>     ICMP input histogram:
>         echo requests: 2
>         echo replies: 2
>     4 ICMP messages sent
>     0 ICMP messages failed
>     ICMP output histogram:
>         echo request: 2
>         echo replies: 2
> IcmpMsg:
>         InType0: 2
>         InType8: 2
>         OutType0: 2
>         OutType8: 2
> Tcp:
>     1 active connections openings
>     2 passive connection openings
>     0 failed connection attempts
>     0 connection resets received
>     2 connections established
>     2353 segments received
>     2096 segments send out
>     0 segments retransmited
>     0 bad segments received.
>     0 resets sent
> Udp:
>     51 packets received
>     0 packets to unknown port received.
>     0 packet receive errors
>     51 packets sent
>     0 receive buffer errors
>     0 send buffer errors
> UdpLite:
> TcpExt:
>     1 TCP sockets finished time wait in fast timer
>     3 delayed acks sent
>     2 packets directly queued to recvmsg prequeue.
>     2 packets directly received from prequeue
>     2009 packets header predicted
>     165 acknowledgments not containing data received
>     IPReversePathFilter: 82
> IpExt:
>     InMcastPkts: 13
>     InBcastPkts: 60
>     InOctets: 146431
>     OutOctets: 63310
>     InMcastOctets: 416
>     InBcastOctets: 12060
> 
> --
> Chris


