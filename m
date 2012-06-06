Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2FFQRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:17:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab2FFQRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:17:20 -0400
Date: Wed, 6 Jun 2012 19:17:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
Message-ID: <20120606161715.GA17575@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
 <1338972341.2760.3944.camel@edumazet-glaptop>
 <20120606111357.GA15070@redhat.com>
 <1338988210.2760.4485.camel@edumazet-glaptop>
 <20120606144941.GA17092@redhat.com>
 <1338995944.26966.6.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338995944.26966.6.camel@edumazet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 05:19:04PM +0200, Eric Dumazet wrote:
> On Wed, 2012-06-06 at 17:49 +0300, Michael S. Tsirkin wrote:
> > On Wed, Jun 06, 2012 at 03:10:10PM +0200, Eric Dumazet wrote:
> > > On Wed, 2012-06-06 at 14:13 +0300, Michael S. Tsirkin wrote:
> > > 
> > > > We currently do all stats either on napi callback or from
> > > > start_xmit callback.
> > > > This makes them safe, yes?
> > > 
> > > Hmm, then _bh() variant is needed in virtnet_stats(), as explained in
> > > include/linux/u64_stats_sync.h section 6)
> > > 
> > >  * 6) If counter might be written by an interrupt, readers should block interrupts.
> > >  *    (On UP, there is no seqcount_t protection, a reader allowing interrupts could
> > >  *     read partial values)
> > > 
> > > Yes, its tricky...
> > 
> > Sounds good, but I have a question: this realies on counters
> > being atomic on 64 bit.
> > Would not it be better to always use a seqlock even on 64 bit?
> > This way counters would actually be correct and in sync.
> > As it is if we want e.g. average packet size,
> > we can not rely e.g. on it being bytes/packets.
> 
> When this stuff was discussed, we chose to have a nop on 64bits.
> 
> Your point has little to do with 64bit stats, it was already like that
> with 'long int' counters.

Yes, of course.

> Consider average driver doing :
> 
> dev->stats.rx_bytes += skb->len;
> dev->stats.rx_packets++;
> 
> A concurrent reader can read an updated rx_bytes and a 'previous'
> rx_packets one.
> 
> 'fixing' this requires a lot of work and memory barriers (in all
> drivers), for a very litle gain (at most one packet error)
> u64_stats_sync was really meant to be 0-cost on 64bit arches.
> 
> 

I understand, and not arguing about that.

But why do you say at most 1 packet?

Consider get_stats doing:
               u64_stats_update_begin(&stats->syncp);
               stats->tx_bytes += skb->len;

on 64 bit at this point
tx_packets might get incremented any number of times, no?

                stats->tx_packets++;
                u64_stats_update_end(&stats->syncp);

now tx_bytes and tx_packets are out of sync by more than 1.



