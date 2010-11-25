Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab0KYO1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:27:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45263 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0KYO1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:27:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XopIIYLh//N8nFswbDLqDE+NMvsqfLKHroKVN1CW8uctc+60/vjXd6cEySZm+NNmb9
         eworAhW8AFRYnwwuX0j3F3VW6rCR7MoJLC7+aui6NbnuF5wtOrKLoSPLhBEcuKoK7eIi
         bzxd2/DbAf76fgIdjAisVWhkVq3a0lyvhVm1o=
Subject: Re: TCP_MAXSEG vs TCP/generic segmentation offload (tso/gso)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Niels =?ISO-8859-1?Q?M=F6ller?= <nisse@lysator.liu.se>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <nny68hqzzn.fsf@stalhein.lysator.liu.se>
References: <nny68hqzzn.fsf@stalhein.lysator.liu.se>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 15:27:33 +0100
Message-ID: <1290695253.2858.336.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 25 novembre 2010 à 14:44 +0100, Niels Möller a écrit :
> [ This is a slightly updated repost of a an October 21 mail to the
>   linux-net list. Any hints or advice appreciated. /Niels ]
> 

CC netdev

> I have been observing large ethernet packets when generating TCP traffic
> over a local ethernet, up to a bit over 20000 bytes, even though the
> interface MTU is 1500 bytes.
> 
> Furthermore, I tried to use setsockopt with TCP_MAXSEG to limit the TCP
> segment size further, to 1000 bytes, and that didn't have any effect.
> 
> When bugreporting a related problem to the debian kernel maintainers, I
> was told that the behaviour may be linked to the use of TCP segmentation
> offload (see http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=600286).
> 
> Disabling TSO and GSO using ethtool solves both problems: Generated
> packets now are limited in size by both the interface MTU and the
> segment size set with setsockopt. (Except the atl1c driver, where
> ethtool -K eth0 tso off only results in a "Cannot set device tcp
> segmentation offload settings: Operation not supported").
> 
> Before I try to write proper bug reports on specific network drivers (I
> have seen problems with several network drivers on different machines,
> unfortunately using different linux versions), I would like to know:
> 
> 1. Is TCP_MAXSEG supposed to work at all with network drivers that do
>    tcp segmentation offload?
> 
> 2. If it is supposed to work, can someone give a rough sketch on how the
>    per-socket segment size, set with setsockopt(... TCP_MAXSEG,...), is
>    passed down to the driver and to the network hardware? I suspect it
>    ought to be passed with each "pseudo-packet" to be transmitted.
> 
> I have spent some time searching the documentation and the net for
> answers, without result, hence I'm posting to this list. I'm not
> subscribed, so please cc any replies.
> 
> (Regarding packets larger than the interface MTU, that seems clearly
> buggy to me, and I think I already know enough to be able to file proper
> bug reports. And in the atl1c driver, it appears to have been fixed
> between 1.0.0.1-NAPI and 1.0.1.0-NAPI).

GSO is a software technique. Same for GRO.

Physical frames are indeed 1500 bytes (on regular ethernet links)

tcpdump gives you the high level view, before segmentation done in lower
levels (by NIC itself or in linux stack) in Transmit path.

We also have GRO in receive path, able to coalesce several 1500 bytes
frames into a single one (if same tcp flow), so that overhead in stacks
is lowered (netfilter, IP stack, tcp stack, bridge, routing ...)

So... there is no 'bug', unless you trust too much tcpdump output.



