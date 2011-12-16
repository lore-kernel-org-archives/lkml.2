Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964859Ab1LPUER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:04:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41503 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab1LPTur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:47 -0500
Message-ID: <1324065042.2621.27.camel@edumazet-laptop>
Subject: Re: [PATCH net-next v1 5/6] tg3: implementation of a non-NAPI mode
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Decotigny <decot@googlers.com>
Cc: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Robin Getz <rgetz@blackfin.uclinux.org>,
        Matt Mackall <mpm@selenic.com>, Tom Herbert <therbert@google.com>
Date: Fri, 16 Dec 2011 20:50:42 +0100
In-Reply-To: <6d55ce25f5f237a4538f6a2fcd2609b877669297.1324059527.git.decot@googlers.com>
References: <cover.1324059527.git.decot@googlers.com>
	 <6d55ce25f5f237a4538f6a2fcd2609b877669297.1324059527.git.decot@googlers.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 16 décembre 2011 à 10:19 -0800, David Decotigny a écrit :
> From: Tom Herbert <therbert@google.com>
> 
> The tg3 NIC has a hard limit of 511 descriptors for the receive ring.
> Under heavy load of small packets, this device receive queue may not
> be serviced fast enough to prevent packets drops.  This could be due
> to a variety of reasons such as lengthy processing delays of packets
> in the stack, softirqs being disabled too long, etc. If the driver is
> run in non-NAPI mode, the RX queue is serviced in the device
> interrupt, which is much less likely to be deferred for a substantial
> period of time.
> 
> There are some effects in not using NAPI that need to be considered.
> It does increase the chance of live-lock in interrupt handler,
> although since the tg3 does interrupt coalescing this is very unlikely
> to occur.  Also, more code is being run with interrupts disabled
> potentially deferring other hardware interrupts.  The amount of time
> spent in the interrupt handler should be minimized by dequeuing
> packets of the device queue and queuing them to a host queue as
> quickly as possible.
> 
> The default mode of operation remains NAPI and its performances are
> kept unchanged (code unchanged). Non-NAPI mode is enabled by
> commenting-out CONFIG_TIGON3_NAPI Kconfig parameter.
> 
> 

Oh well, thats ugly :(

I suspect this was only used with RPS/RFS ?

Or interrupts stick on a given cpu ?

Because with a default setup, and IRQ serviced by multiple cpus, you
endup with possible packet reorderings.

Packet1,2,3,4 handled by CPU0 : queued on netif_rx() queue.
EndOfInterrupt
Packet4,5,6,7 handled by CPU1 : queued on netif_rx() queue.
EndOfInterrupt

CPU0/CPU1 happily merge packets...



