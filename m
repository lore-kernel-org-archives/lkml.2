Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1G2Hdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:33:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47537 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1G2Hde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:33:34 -0400
Subject: Re: IP forwarding regression since 3.0-rc6
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephan Seitz <stse+lkml@fsing.rootsland.net>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20110729T091342.GA.06bf4.stse@fsing.rootsland.net>
References: <20110725T141145.GA.2ae38.stse@fsing.rootsland.net>
	 <201107281546.33227.maciej.rutecki@gmail.com>
	 <20110729T091342.GA.06bf4.stse@fsing.rootsland.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 09:33:29 +0200
Message-ID: <1311924809.7845.29.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 juillet 2011 à 09:15 +0200, Stephan Seitz a écrit :
> On Thu, Jul 28, 2011 at 03:46:33PM +0200, Maciej Rutecki wrote:
> >I created a Bugzilla entry at
> >https://bugzilla.kernel.org/show_bug.cgi?id=40282
> >for your bug report, please add your address to the CC list in there, thanks!
> 
> Thank you for creating a bug report for me. I have added my address to 
> the CC list.
> 

CC netdev

I suspect your configuration is too complex, and maybe the only way to
track the bug is to perform a git bisection.

Your initial message was :

Since 3.0-rc6 I see that my Linux router is losing packets. I can see 
them tracing the internal interface, but I don’t see them on the external 
interface. I can reproduce the problem while using tin with 
news.individual.de. At the startup when tin checks every newsgroup from 
the server, many packets are suddenly not routed anymore but are dropped, 
so tin hangs until it quits with a NNTP error.
All kernels until 3.0-rc5 are working.

Hardware:
- 2x Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit 
   Ethernet controller

Sofware:
- Debian Testing, 64bit, with Xen 4.1.0

System:
Dom0 (Debian Testing, 64bit) is my working system. The two NICs have each 
their own bridge interface. One bridge interface (A) has an internal IP 
address (IPv4 and IPv6) of my internal network. The other bridge (B) 
doesn’t have a IP address in Dom0. The DomU is connected to the two 
bridges.
DomU (Debian Testing, 64bit) is my iptables firewall system with Bind, 
Squid, and other services. The interface connected to bridge A has an 
internal IP addresses (gateway for my internal network). The interface 
connected to bridge B is used for PPPoE (the NIC is directly connected to 
my DSL modem).

Kernels:
Dom0 has had all kernel versions from 3.0-rcX and is running 3.0 at the 
moment.
DomU has had the same kernel versions but is running 3.0-rc5 at the 
moment because of the network problems in newer kernels.

Long problem description:
 From Dom0 I use tin to read different newsserver. One of them is 
news.individual.de. The first time after DomU switched kernel to -rc6 
I started tin (connecting to the mentioned news server) and tin hung 
while reading groups from the newsrc and stopped with a NNTP connection 
error.
Since the problem didn’t vanish, I wrote a mail to the support team of 
the news server. They told me that I was the only one with a connection 
problem and asked me to try the connection from another client. I tried 
it from my vServer, and it worked. So the problem had to be in my setup.

I traced in Dom0 (bridge A), DomU (bridge A) und DomU (ppp0) and noticed 
that all packets generated in Dom0 were visible in DomU bridge A. But not 
all of the packets were visisble at the ppp0 interface. So my DomU was 
dropping packets and the connection between tin in Dom0 and the news 
server failed.

So I tried older kernels and noticed that 3.0-rc5 in DomU was working, 
but rc6 and newer were not. The kernel configuration was the same for all 
3.0 kernels.

Since I don’t know which maintainer I should contact with my problem, 
I’ll write directly to lkml.

Thanks for your help.

Shade and sweet water!

        Stephan


