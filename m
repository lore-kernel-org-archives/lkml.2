Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab2FFSn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:43:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab2FFSn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:43:56 -0400
Date: Wed, 6 Jun 2012 21:43:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
Message-ID: <20120606184351.GA20380@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
 <1338972341.2760.3944.camel@edumazet-glaptop>
 <20120606111357.GA15070@redhat.com>
 <1338988210.2760.4485.camel@edumazet-glaptop>
 <20120606144941.GA17092@redhat.com>
 <1338995944.26966.6.camel@edumazet-glaptop>
 <20120606161715.GA17575@redhat.com>
 <1339002782.26966.22.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339002782.26966.22.camel@edumazet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 07:13:02PM +0200, Eric Dumazet wrote:
> On Wed, 2012-06-06 at 19:17 +0300, Michael S. Tsirkin wrote:
> 
> > But why do you say at most 1 packet?
> > 
> > Consider get_stats doing:
> >                u64_stats_update_begin(&stats->syncp);
> >                stats->tx_bytes += skb->len;
> > 
> > on 64 bit at this point
> > tx_packets might get incremented any number of times, no?
> > 
> >                 stats->tx_packets++;
> >                 u64_stats_update_end(&stats->syncp);
> > 
> > now tx_bytes and tx_packets are out of sync by more than 1.
> 
> You lost me there.
> 
> No idea of what you are thinking about.

Sorry about that. This is not a bug. I am saying two things:

1. We are trying to look at counters for purposes of tuning the device.
E.g. if ethtool reports packets and bytes, we'd like to calculate
average packet size by bytes/packets.

If both counters are read atomically the metric becomes more exact.
Not a must but nice to have.

2. 32 bit systems have some overhead because of the seqlock.
virtio could instead simply keep tx counters in the queue structure, and
get the tx lock when they are read.


-- 
MST
