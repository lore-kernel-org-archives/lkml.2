Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1EWLT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:19:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab1EWLTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:19:54 -0400
Date: Mon, 23 May 2011 14:19:00 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCHv2 10/14] virtio_net: limit xmit polling
Message-ID: <20110523111900.GB27212@redhat.com>
References: <cover.1305846412.git.mst@redhat.com>
 <aced8619c07018b5495f9ceb2c02d4fbf897a098.1305846412.git.mst@redhat.com>
 <877h9kvlps.fsf@rustcorp.com.au>
 <20110522121008.GA12155@redhat.com>
 <87boyutbjg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87boyutbjg.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 11:37:15AM +0930, Rusty Russell wrote:
> On Sun, 22 May 2011 15:10:08 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Sat, May 21, 2011 at 11:49:59AM +0930, Rusty Russell wrote:
> > > On Fri, 20 May 2011 02:11:56 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > Current code might introduce a lot of latency variation
> > > > if there are many pending bufs at the time we
> > > > attempt to transmit a new one. This is bad for
> > > > real-time applications and can't be good for TCP either.
> > > 
> > > Do we have more than speculation to back that up, BTW?
> > 
> > Need to dig this up: I thought we saw some reports of this on the list?
> 
> I think so too, but a reference needs to be here too.
> 
> It helps to have exact benchmarks on what's being tested, otherwise we
> risk unexpected interaction with the other optimization patches.
> 
> > > >  	struct sk_buff *skb;
> > > >  	unsigned int len;
> > > > -
> > > > -	while ((skb = virtqueue_get_buf(vi->svq, &len)) != NULL) {
> > > > +	bool c;
> > > > +	int n;
> > > > +
> > > > +	/* We try to free up at least 2 skbs per one sent, so that we'll get
> > > > +	 * all of the memory back if they are used fast enough. */
> > > > +	for (n = 0;
> > > > +	     ((c = virtqueue_get_capacity(vi->svq) < capacity) || n < 2) &&
> > > > +	     ((skb = virtqueue_get_buf(vi->svq, &len)));
> > > > +	     ++n) {
> > > >  		pr_debug("Sent skb %p\n", skb);
> > > >  		vi->dev->stats.tx_bytes += skb->len;
> > > >  		vi->dev->stats.tx_packets++;
> > > >  		dev_kfree_skb_any(skb);
> > > >  	}
> > > > +	return !c;
> > > 
> > > This is for() abuse :)
> > > 
> > > Why is the capacity check in there at all?  Surely it's simpler to try
> > > to free 2 skbs each time around?
> > 
> > This is in case we can't use indirect: we want to free up
> > enough buffers for the following add_buf to succeed.
> 
> Sure, or we could just count the frags of the skb we're taking out,
> which would be accurate for both cases and far more intuitive.
> 
> ie. always try to free up twice as much as we're about to put in.
> 
> Can we hit problems with OOM?  Sure, but no worse than now...
> The problem is that this "virtqueue_get_capacity()" returns the worst
> case, not the normal case.  So using it is deceptive.
> 

Maybe just document this?

I still believe capacity really needs to be decided
at the virtqueue level, not in the driver.
E.g. with indirect each skb uses a single entry: freeing
1 small skb is always enough to have space for a large one.

I do understand how it seems a waste to leave direct space
in the ring while we might in practice have space
due to indirect. Didn't come up with a nice way to
solve this yet - but 'no worse than now :)'

> > I just wanted to localize the 2+MAX_SKB_FRAGS logic that tries to make
> > sure we have enough space in the buffer. Another way to do
> > that is with a define :).
> 
> To do this properly, we should really be using the actual number of sg
> elements needed, but we'd have to do most of xmit_skb beforehand so we
> know how many.
> 
> Cheers,
> Rusty.

Maybe I'm confused here.  The problem isn't the failing
add_buf for the given skb IIUC.  What we are trying to do here is stop
the queue *before xmit_skb fails*. We can't look at the
number of fragments in the current skb - the next one can be
much larger.  That's why we check capacity after xmit_skb,
not before it, right?

-- 
MST
