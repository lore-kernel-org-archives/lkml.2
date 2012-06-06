Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2FFPTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:19:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44394 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab2FFPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:19:15 -0400
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20120606144941.GA17092@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
	 <1338972341.2760.3944.camel@edumazet-glaptop>
	 <20120606111357.GA15070@redhat.com>
	 <1338988210.2760.4485.camel@edumazet-glaptop>
	 <20120606144941.GA17092@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 17:19:04 +0200
Message-ID: <1338995944.26966.6.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 17:49 +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 06, 2012 at 03:10:10PM +0200, Eric Dumazet wrote:
> > On Wed, 2012-06-06 at 14:13 +0300, Michael S. Tsirkin wrote:
> > 
> > > We currently do all stats either on napi callback or from
> > > start_xmit callback.
> > > This makes them safe, yes?
> > 
> > Hmm, then _bh() variant is needed in virtnet_stats(), as explained in
> > include/linux/u64_stats_sync.h section 6)
> > 
> >  * 6) If counter might be written by an interrupt, readers should block interrupts.
> >  *    (On UP, there is no seqcount_t protection, a reader allowing interrupts could
> >  *     read partial values)
> > 
> > Yes, its tricky...
> 
> Sounds good, but I have a question: this realies on counters
> being atomic on 64 bit.
> Would not it be better to always use a seqlock even on 64 bit?
> This way counters would actually be correct and in sync.
> As it is if we want e.g. average packet size,
> we can not rely e.g. on it being bytes/packets.

When this stuff was discussed, we chose to have a nop on 64bits.

Your point has little to do with 64bit stats, it was already like that
with 'long int' counters.

Consider average driver doing :

dev->stats.rx_bytes += skb->len;
dev->stats.rx_packets++;

A concurrent reader can read an updated rx_bytes and a 'previous'
rx_packets one.

'fixing' this requires a lot of work and memory barriers (in all
drivers), for a very litle gain (at most one packet error)

u64_stats_sync was really meant to be 0-cost on 64bit arches.



