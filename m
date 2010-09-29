Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0I2Vp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 17:45:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62710 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0I2Vp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 17:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hlAoIS6q5q+fDQhBm0wNX9k3Jl+VcFeRXEvvxB5sk59JgRYT1ZHwzu1ycYbjLAUMH8
         rLEDBdYW3PD40CK1PlOPJrdgQaGho5JV3Cgny91atVS18WFIPQ01ZL+cpMLUwpYMxutT
         aFHncc0UXwIkijo5eH7UaW9lBhBkh+qMvxLcw=
Subject: Re: Packet time delays on multi-core systems
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Vlasov <renton@renton.name>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20100929191851.GC86786@beaver.vrungel.ru>
References: <20100929191851.GC86786@beaver.vrungel.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 23:45:21 +0200
Message-ID: <1285796721.5211.156.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 29 septembre 2010 à 23:18 +0400, Alexey Vlasov a écrit : 
> Hi.
> 
> I'm not sure actually that I should write here, may be I should ask in
> netfilter maillist, but if is something wrong please correct me.
> 

CC netdev


> I've got rather large linux shared hosting, and on my new servers I
> noticed some strange singularity, that this simple rule:
> 
> # iptables -A OUTPUT -p tcp -m tcp --dport 80 --tcp-flags
> FIN,SYN,RST,ACK SYN -j LOG --log-prefix "ipsec:SYN-OUTPUT "
> --log-uid
> 
> gives essential time delays simply at ping from the adjacent server
> on a local area network. I don't know precisely what's wrong whether the
> reason is in the bad support by a kernel of new hardware, or it concerns
> generally the new kernel, but now it leads to the situation that even at simple
> DDOS attacks to client sites, it becomes difficult to make something, and in
> general all works only worse.
> 
> It seems to me that with the increase of CPU cores' amount, it only becomes
> worse and worse, and, obviously, iptables uses resources of only one processor,
> which resources to it for any reason doesn't suffice.
> 

Its not true. iptables can run on all cpus in //

> newbox # iptables -F
> otherbox # ping -c 100 newbox
> ...
> 100 packets transmitted, 100 received, 0% packet loss, time 100044ms
> rtt min/avg/max/mdev = 0.133/2.637/17.172/3.736 ms
> 
> OK.
> 
> newbox # iptables -A OUTPUT -p tcp -m tcp --dport 80 --tcp-flags FIN,SYN,RST,ACK SYN
> -j LOG --log-prefix "ipsec:SYN-OUTPUT " --log-uid
> otherbox # ping -c 100 newbox
> ...
> 64 bytes from (newbox): icmp_seq=3 ttl=64 time=1.58 ms
> 64 bytes from (newbox): icmp_seq=4 ttl=64 time=98.7 ms
> 64 bytes from (newbox): icmp_seq=5 ttl=64 time=18.2 ms
> 64 bytes from (newbox): icmp_seq=6 ttl=64 time=6.13 ms
> 64 bytes from (newbox): icmp_seq=7 ttl=64 time=108 ms
> ...
> 64 bytes from (newbox): icmp_seq=55 ttl=64 time=2.30 ms
> 64 bytes from (newbox): icmp_seq=56 ttl=64 time=59.9 ms
> 64 bytes from (newbox): icmp_seq=57 ttl=64 time=0.155 ms
> ...
> 64 bytes from (newbox): icmp_seq=61 ttl=64 time=13.4 ms
> 64 bytes from (newbox): icmp_seq=62 ttl=64 time=55.0 ms
> 64 bytes from (newbox): icmp_seq=63 ttl=64 time=0.233 ms
> ...
> 100 packets transmitted, 100 received, 0% packet loss, time 99957ms
> rtt min/avg/max/mdev = 0.111/7.519/108.061/18.478 ms
> 
> newbox # iptables -L -v -n
> Chain INPUT (policy ACCEPT 346K packets, 213M bytes)
>  pkts bytes target     prot opt in     out     source               destination
> 
> Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
>  pkts bytes target     prot opt in     out     source               destination
> 
> Chain OUTPUT (policy ACCEPT 296K packets, 290M bytes)
>  pkts bytes target     prot opt in     out     source               destination
>   234 14040 LOG        tcp  --  *      *       0.0.0.0/0            0.0.0.0/0    
> tcp dpt:80 flags:0x17/0x02 LOG flags 8 level 4 prefix `ipsec:SYN-OUTPUT- '
> 
> My old server: Intel SR1500, Xeon 5430, kernel 2.6.24 - 2.6.28
> Newbox: SR1620UR, 5650, kernel 2.6.32
> 
> Thanks in advance.
> 

Seems strange indeed, since the LOG you add should not slowdown icmp
trafic that much.

But if you send SYN packets in the same time, (logged), this might slow
down the reception (and answers) of ICMP frames. LOG target can be quite
expensive... 

Is using other rules gives same problem ?

iptables -A OUTPUT -p tcp -m tcp --dport 80 --tcp-flags FIN,SYN,RST,ACK SYN
iptables -A OUTPUT -p tcp -m tcp --dport 80 --tcp-flags FIN,SYN,RST,ACK SYN
iptables -A OUTPUT -p tcp -m tcp --dport 80 --tcp-flags FIN,SYN,RST,ACK SYN
iptables -A OUTPUT -p tcp -m tcp --dport 80 --tcp-flags FIN,SYN,RST,ACK SYN





