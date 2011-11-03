Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1KCGps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:45:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50380 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1KCGpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:45:47 -0400
Date: Thu, 3 Nov 2011 15:45:32 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] virtio: support unlocked queue kick
Message-ID: <20111103064532.GA18059@barrios-laptop.redhat.com>
References: <20111005195403.407628164@bombadil.infradead.org>
 <20111005195529.964397366@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005195529.964397366@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Wed, Oct 05, 2011 at 03:54:05PM -0400, Christoph Hellwig wrote:
> Split virtqueue_kick to be able to do the actual notification outside the
> lock protecting the virtqueue.  This patch was originally done by

Nitpick:

Until now, virtqueue_kick is called under lock, still so description
confuses me. It would be better to be [5/5].

> Stefan Hajnoczi, but I can't find the original one anymore and had to
> recreated it from memory.  Pointers to the original or corrections for
> the commit message are welcome.
> 
> Index: linux-2.6/drivers/virtio/virtio_ring.c
> ===================================================================
> --- linux-2.6.orig/drivers/virtio/virtio_ring.c	2011-09-15 15:28:55.891347016 +0200
> +++ linux-2.6/drivers/virtio/virtio_ring.c	2011-10-03 18:45:32.492738431 +0200
> @@ -237,9 +237,11 @@ add_head:
>  }
>  EXPORT_SYMBOL_GPL(virtqueue_add_buf_gfp);
>  
> -void virtqueue_kick(struct virtqueue *_vq)
> +bool virtqueue_kick_prepare(struct virtqueue *_vq)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
> +	bool need_kick = false;
> +
>  	u16 new, old;
>  	START_USE(vq);
>  	/* Descriptors and available array need to be set before we expose the
> @@ -253,15 +255,32 @@ void virtqueue_kick(struct virtqueue *_v
>  	/* Need to update avail index before checking if we should notify */
>  	virtio_mb();
>  
> -	if (vq->event ?
> -	    vring_need_event(vring_avail_event(&vq->vring), new, old) :
> -	    !(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY))
> -		/* Prod other side to tell it about changes. */
> -		vq->notify(&vq->vq);
> -
> +	if (vq->event) {
> +		if (vring_need_event(vring_avail_event(&vq->vring), new, old))
> +			need_kick = true;
> +	} else {
> +		if (!(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY))
> +			need_kick = true;
> +	}
>  	END_USE(vq);
> +	return need_kick;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_kick_prepare);
> +
> +void virtqueue_notify(struct virtqueue *_vq)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	/* Prod other side to tell it about changes. */
> +	vq->notify(_vq);
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_notify);
> +
> +void virtqueue_kick(struct virtqueue *vq)
> +{
> +	if (virtqueue_kick_prepare(vq))
> +		virtqueue_notify(vq);
>  }
> -EXPORT_SYMBOL_GPL(virtqueue_kick);

It should be exported for using other modules.

-- 
Kind regards,
Minchan Kim
