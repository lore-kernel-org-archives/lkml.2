Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1KNGy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 01:54:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab1KNGy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 01:54:58 -0500
Date: Mon, 14 Nov 2011 08:56:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 5 of 5] virtio: expose added descriptors immediately
Message-ID: <20111114065606.GA3779@redhat.com>
References: <patchbomb.1320306168@localhost6.localdomain6>
 <f3831c1617c86a51d875.1320306173@localhost6.localdomain6>
 <20111113210256.GA31621@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111113210256.GA31621@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 11:03:13PM +0200, Michael S. Tsirkin wrote:
> On Thu, Nov 03, 2011 at 06:12:53PM +1030, Rusty Russell wrote:
> > A virtio driver does virtqueue_add_buf() multiple times before finally
> > calling virtqueue_kick(); previously we only exposed the added buffers
> > in the virtqueue_kick() call.  This means we don't need a memory
> > barrier in virtqueue_add_buf(), but it reduces concurrency as the
> > device (ie. host) can't see the buffers until the kick.
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> In the past I played with a patch like this, but I didn't see a
> performance gain either way. Do you see any gain?
> 
> I'm a bit concerned that with this patch, a buggy driver that
> adds more than 2^16 descriptors without a kick
> would seem to work sometimes. Let's add WARN_ON(vq->num_added > (1 << 16))?

Thinking about it more - it might be tricky for drivers
to ensure this. add used to fail when vq is full, but now
driver might do get between add and notify:
	lock
	add_buf * N
	prep
	unlock
	lock
	get_buf * N
	unlock
	lock
	add_buf
	prep
	unlock
	notify

and since add was followed by get, this doesn't fail.

So the right thing to do I think is to either ignore indexes and assume
a kick is needed, something like:
if vq->num_added >= (1 << 15))
	needs_kick = true
(note: maybe it's 1<<16, and maybe >, but 1<<15 is plenty anyway)

Or alternatively, fail add when num_added is too large.

> > ---
> >  drivers/virtio/virtio_ring.c |   37 ++++++++++++++++++++++---------------
> >  1 file changed, 22 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -227,9 +227,15 @@ add_head:
> >  
> >  	/* Put entry in available array (but don't update avail->idx until they
> >  	 * do sync). */
> > -	avail = ((vq->vring.avail->idx + vq->num_added++) & (vq->vring.num-1));
> > +	avail = (vq->vring.avail->idx & (vq->vring.num-1));
> >  	vq->vring.avail->ring[avail] = head;
> >  
> > +	/* Descriptors and available array need to be set before we expose the
> > +	 * new available array entries. */
> > +	virtio_wmb();
> > +	vq->vring.avail->idx++;
> > +	vq->num_added++;
> > +
> >  	pr_debug("Added buffer head %i to %p\n", head, vq);
> >  	END_USE(vq);
> >  
> > @@ -248,13 +254,10 @@ bool virtqueue_kick_prepare(struct virtq
> >  	 * new available array entries. */
> >  	virtio_wmb();
> >  
> > -	old = vq->vring.avail->idx;
> > -	new = vq->vring.avail->idx = old + vq->num_added;
> > +	old = vq->vring.avail->idx - vq->num_added;
> > +	new = vq->vring.avail->idx;
> >  	vq->num_added = 0;
> >  
> > -	/* Need to update avail index before checking if we should notify */
> > -	virtio_mb();
> > -
> >  	if (vq->event) {
> >  		needs_kick = vring_need_event(vring_avail_event(&vq->vring),
> >  					      new, old);
> > 
> > 
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
