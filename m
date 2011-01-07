Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1AGC3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:29:24 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2424 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab1AGC3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:29:23 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Date: Thu, 6 Jan 2011 18:29:12 -0800
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
cc: "Jesse Gross" <jesse@nicira.com>,
        "Matthew Carlson" <mcarlson@broadcom.com>,
        "Michael Leun" <lkml20101129@newton.leun.net>,
        "Michael Chan" <mchan@broadcom.com>,
        "David Miller" <davem@davemloft.net>,
        "Ben Greear" <greearb@candelatech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when vid
 not used
Message-ID: <20110107022912.GA17757@mcarlson.broadcom.com>
References: <AANLkTinLMCzKz7n45HdeAwNxsWjCADAkgfK+MjXVcFqh@mail.gmail.com>
 <20101213224510.GB17400@mcarlson.broadcom.com>
 <AANLkTi=9BYt=vkNkAiTBxnfnCjCX7AqCG=ML6coc4vdZ@mail.gmail.com>
 <20101214191500.GD19951@mcarlson.broadcom.com>
 <1293901393.2535.49.camel@edumazet-laptop>
 <AANLkTinq9ABi0prxe0m1Ma6rno4UnAOzuW-b5L362ij9@mail.gmail.com>
 <1293984348.2535.101.camel@edumazet-laptop>
 <AANLkTincX-wPQE9gs16v53E4=Skivzc4ZSJS43oNBLD_@mail.gmail.com>
 <1294356887.2704.13.camel@edumazet-laptop>
 <1294363201.2704.19.camel@edumazet-laptop>
MIME-Version: 1.0
In-Reply-To: <1294363201.2704.19.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 6138A5361VG1372656-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 05:20:01PM -0800, Eric Dumazet wrote:
> Le vendredi 07 janvier 2011 ?? 00:34 +0100, Eric Dumazet a ??crit :
> > Le jeudi 06 janvier 2011 ?? 16:01 -0500, Jesse Gross a ??crit :
> > 
> > > Hmm, I thought that it might be some interaction with a corner case in
> > > the networking core but now it seems less likely.  There weren't too
> > > many vlan changes between the working and non-working states.  Plus,
> > > since the rx counter isn't increasing, the packets probably aren't
> > > making it anywhere.
> > > 
> > > I see that tg3 increases the drop counter in one place, which also
> > > happens to be checking for vlan errors (at tg3.c:4753).  That seems
> > > suspicious - maybe the NIC is only partially configured for vlan
> > > offloading.  If we can confirm that is where the drop counter is being
> > > incremented and what the error code is maybe it would shed some light.
> > > 
> > 
> > Hmm... I am pretty sure the drop counter is the dev rx_dropped (core
> > network handled, not tg3 one) incremented at the end of
> > __netif_receive_skb() : We found no suitable handler for packets.
> > 
> > atomic_long_inc(&skb->dev->rx_dropped);
> > 
> > But thats a guess, I'll have to check
> > 
> 
> wrong guess. Its really the tg3 which drops frames
> 
> increasing rx_missed_errors  (get_stat64(&hw_stats->rx_discards)
> 
> ip -s -s link show dev eth2
> 5: eth2: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq
> master bond0 state UP qlen 1000
>     link/ether 00:1e:0b:92:78:50 brd ff:ff:ff:ff:ff:ff
>     RX: bytes  packets  errors  dropped overrun mcast   
>     11627      167      0       0       0       2      
>     RX errors: length  crc     frame   fifo    missed
>                0        0       0       0       2713   
>     TX: bytes  packets  errors  dropped carrier collsns 
>     2274       31       0       0       0       0      
>     TX errors: aborted fifo    window  heartbeat
>                0        0       0       0      
> 
> 
> 
> It would be nice Broadcom guys could help a bit ?

Hi Eric.  Sorry for the delay.  I was under the impression that your
problems were software related and that you just needed a revised
version of these VLAN patches I was sending to Michael.  Is this not
true?

Having a hardware stat increment suggests this is a new problem.
Maybe I missed it, but I didn't see what hardware you are working
with and whether or not management firmware was enabled.  Could you tell
me that info?

