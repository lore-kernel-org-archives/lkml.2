Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1KULzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:55:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab1KULzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:55:50 -0500
Date: Mon, 21 Nov 2011 13:57:04 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 5 of 5] virtio: expose added descriptors immediately
Message-ID: <20111121115702.GA27580@redhat.com>
References: <patchbomb.1320306168@localhost6.localdomain6>
 <f3831c1617c86a51d875.1320306173@localhost6.localdomain6>
 <20111113210256.GA31621@redhat.com>
 <20111114065606.GA3779@redhat.com>
 <871ut8q5mh.fsf@rustcorp.com.au>
 <20111116071838.GE5433@redhat.com>
 <8739dib5z6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8739dib5z6.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 12:18:45PM +1030, Rusty Russell wrote:
> On Wed, 16 Nov 2011 09:18:38 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > My unlocked kick patches will trip this warning: they make
> > virtio-net do add + get without kick.
> 
> Heh, it's a good sign if they do, since that means you're running really
> well :)

They don't in fact, in my testing :(. But I think they can with luck.

> > I think block with unlocked kick can trip it too:
> > add, lock is dropped and then an interrupt can get.
> > 
> > We also don't need a kick each num - each 2^15 is enough.
> > Why don't we do this at start of add_buf:
> > if (vq->num_added >= 0x7fff)
> > 	return -ENOSPC;
> 
> The warning was there in case a driver is never doing a kick, and
> getting away with it (mostly) because the device is polling.  Let's not
> penalize good drivers to catch bad ones.
> 
> How about we do this properly, like so:

Absolutely. But I think we also need to handle num_added
overflow of a 15 bit counter, no? Otherwise the
vring_need_event logic might give us false negatives ....
I'm guessing we can just assume we need a kick in that case.

> From: Rusty Russell <rusty@rustcorp.com.au>
> Subject: virtio: add debugging if driver doesn't kick.
> 
> Under the existing #ifdef DEBUG, check that they don't have more than
> 1/10 of a second between an add_buf() and a
> virtqueue_notify()/virtqueue_kick_prepare() call.
> 
> We could get false positives on a really busy system, but good for
> development.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/virtio/virtio_ring.c |   31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -22,6 +22,7 @@
>  #include <linux/device.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> +#include <linux/hrtimer.h>
>  
>  /* virtio guest is communicating with a virtual "device" that actually runs on
>   * a host processor.  Memory barriers are used to control SMP effects. */
> @@ -102,6 +103,10 @@ struct vring_virtqueue
>  #ifdef DEBUG
>  	/* They're supposed to lock for us. */
>  	unsigned int in_use;
> +
> +	/* Figure out if their kicks are too delayed. */
> +	bool last_add_time_valid;
> +	ktime_t last_add_time;
>  #endif
>  
>  	/* Tokens for callbacks. */
> @@ -192,6 +197,19 @@ int virtqueue_add_buf(struct virtqueue *
>  
>  	BUG_ON(data == NULL);
>  
> +#ifdef DEBUG
> +	{
> +		ktime_t now = ktime_get();
> +
> +		/* No kick or get, with .1 second between?  Warn. */
> +		if (vq->last_add_time_valid)
> +			WARN_ON(ktime_to_ms(ktime_sub(now, vq->last_add_time))
> +					    > 100);
> +		vq->last_add_time = now;
> +		vq->last_add_time_valid = true;
> +	}
> +#endif
> +
>  	/* If the host supports indirect descriptor tables, and we have multiple
>  	 * buffers, then go indirect. FIXME: tune this threshold */
>  	if (vq->indirect && (out + in) > 1 && vq->num_free) {
> @@ -291,6 +309,14 @@ bool virtqueue_kick_prepare(struct virtq
>  	new = vq->vring.avail->idx;
>  	vq->num_added = 0;
>  
> +#ifdef DEBUG
> +	if (vq->last_add_time_valid) {
> +		WARN_ON(ktime_to_ms(ktime_sub(ktime_get(),
> +					      vq->last_add_time)) > 100);
> +	}
> +	vq->last_add_time_valid = false;
> +#endif
> +
>  	if (vq->event) {
>  		needs_kick = vring_need_event(vring_avail_event(&vq->vring),
>  					      new, old);
> @@ -428,6 +454,10 @@ void *virtqueue_get_buf(struct virtqueue
>  		virtio_mb();
>  	}
>  
> +#ifdef DEBUG
> +	vq->last_add_time_valid = false;
> +#endif
> +
>  	END_USE(vq);
>  	return ret;
>  }
> @@ -611,6 +641,7 @@ struct virtqueue *vring_new_virtqueue(un
>  	list_add_tail(&vq->vq.list, &vdev->vqs);
>  #ifdef DEBUG
>  	vq->in_use = false;
> +	vq->last_add_time_valid = false;
>  #endif
>  
>  	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC);
