Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab2JAJxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:53:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab2JAJxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:53:14 -0400
Date: Mon, 1 Oct 2012 15:22:57 +0530
From: Amit Shah <amit.shah@redhat.com>
To: sjur.brandeland@stericsson.com
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjurbren@stericsson.com, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv5 2/3] virtio_console: Add support for remoteproc serial
Message-ID: <20121001095257.GF9810@amit.redhat.com>
References: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com>
 <1348580837-10919-3-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348580837-10919-3-git-send-email-sjur.brandeland@stericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 25 Sep 2012 [15:47:16], sjur.brandeland@stericsson.com wrote:

> +static DEFINE_SPINLOCK(dma_bufs_lock);
> +static LIST_HEAD(pending_free_dma_bufs);
> +
>  static void free_buf(struct port_buffer *buf)
>  {
>  	int i;
> +	unsigned long flags;
>  
> -	kfree(buf->buf);
> +	if (!buf->dev)
> +		kfree(buf->buf);

Doesn't hurt to just kfree a NULL pointer; so check is not needed.

> -	if (buf->sgpages)
> +	if (buf->sgpages) {
>  		for (i = 0; i < buf->sgpages; i++) {
>  			struct page *page = sg_page(&buf->sg[i]);
>  			if (!page)
>  				break;
>  			put_page(page);
>  		}
> +		return;
> +	}

No kfree(buf)?

> +	if (buf->dev && is_rproc_enabled) {
> +
> +		/* dma_free_coherent requires interrupts to be enabled. */
> +		if (irqs_disabled()) {
> +			/* queue up dma-buffers to be freed later */
> +			spin_lock_irqsave(&dma_bufs_lock, flags);
> +			list_add_tail(&buf->list, &pending_free_dma_bufs);
> +			spin_unlock_irqrestore(&dma_bufs_lock, flags);
> +			return;
> +		}
> +		dma_free_coherent(buf->dev, buf->size, buf->buf, buf->dma);
> +
> +		/* Release device refcnt and allow it to be freed */
> +		might_sleep();
> +		put_device(buf->dev);
> +	}
>  
>  	kfree(buf);
>  }
>  
> +static void reclaim_dma_bufs(void)
> +{
> +	unsigned long flags;
> +	struct port_buffer *buf, *tmp;
> +	LIST_HEAD(tmp_list);
> +
> +	WARN_ON(irqs_disabled());
> +	if (list_empty(&pending_free_dma_bufs))
> +		return;
> +
> +	BUG_ON(!is_rproc_enabled);
> +
> +	/* Create a copy of the pending_free_dma_bufs while holding the lock*/
> +	spin_lock_irqsave(&dma_bufs_lock, flags);
> +	list_cut_position(&tmp_list, &pending_free_dma_bufs,
> +			  pending_free_dma_bufs.prev);
> +	spin_unlock_irqrestore(&dma_bufs_lock, flags);
> +
> +	/* Release the dma buffers, without irqs enabled */
> +	list_for_each_entry_safe(buf, tmp, &tmp_list, list) {
> +		list_del(&buf->list);
> +		free_buf(buf);
> +	}
> +}
> +
>  static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
>  				     int nrbufs)
>  {
>  	struct port_buffer *buf;
>  	size_t alloc_size;
>  
> +	if (is_rproc_serial(vq->vdev) && !irqs_disabled())
> +		reclaim_dma_bufs();
> +
>  	/* Allocate buffer and the scatter list */
>  	alloc_size = sizeof(*buf) + sizeof(struct scatterlist) * nrbufs;
> -	buf = kmalloc(alloc_size, GFP_ATOMIC);
> +	buf = kzalloc(alloc_size, GFP_ATOMIC);

Why change from kmalloc to kzalloc?  It's better to split out such
changes into separate patch for easier review.

>  	if (!buf)
>  		goto fail;
>  
> @@ -374,11 +444,30 @@ static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
>  	if (nrbufs > 0)
>  		return buf;
>  
> -	buf->buf = kmalloc(buf_size, GFP_ATOMIC);
> +	if (is_rproc_serial(vq->vdev)) {
> +		/*
> +		 * Allocate DMA memory from ancestor. When a virtio
> +		 * device is created by remoteproc, the DMA memory is
> +		 * associated with the grandparent device:
> +		 * vdev => rproc => platform-dev.
> +		 * The code here would have been less quirky if
> +		 * DMA_MEMORY_INCLUDES_CHILDREN had been supported
> +		 * in dma-coherent.c
> +		 */
> +		if (!vq->vdev->dev.parent || !vq->vdev->dev.parent->parent)
> +			goto free_buf;
> +		buf->dev = vq->vdev->dev.parent->parent;
> +
> +		/* Increase device refcnt to avoid freeing it*/

missing space before */

> +		get_device(buf->dev);
> +		buf->buf = dma_alloc_coherent(buf->dev, buf_size, &buf->dma,
> +					      GFP_ATOMIC);
> +	} else {
> +		buf->buf = kmalloc(buf_size, GFP_ATOMIC);
> +	}
> +
>  	if (!buf->buf)
>  		goto free_buf;
> -	buf->len = 0;
> -	buf->offset = 0;

As noted in a comment to previous patch, please use kmalloc and
explicit initialisation of variables.

>  	buf->size = buf_size;
>  
>  	/* Prepare scatter buffer for sending */
> @@ -838,6 +927,10 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
>  		.u.data = &sgl,
>  	};
>  
> +	/* rproc_serial does not support splice */
> +	if (is_rproc_serial(port->out_vq->vdev))
> +		return -EINVAL;

Will something break if this is not done?


		Amit
