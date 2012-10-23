Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2JWCBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:01:03 -0400
Received: from ozlabs.org ([203.10.76.45]:44787 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab2JWCA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:00:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: sjur.brandeland@stericsson.com, Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: Re: [PATCHv7 4/4] virtio_console: Add support for remoteproc serial
In-Reply-To: <1350287856-5284-5-git-send-email-sjur.brandeland@stericsson.com>
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com> <1350287856-5284-5-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 23 Oct 2012 12:17:49 +1030
Message-ID: <878vayhsca.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sjur.brandeland@stericsson.com writes:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Add a simple serial connection driver called
> VIRTIO_ID_RPROC_SERIAL (11) for communicating with a
> remote processor in an asymmetric multi-processing
> configuration.
>
> This implementation reuses the existing virtio_console
> implementation, and adds support for DMA allocation
> of data buffers and disables use of tty console and
> the virtio control queue.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

The free-outside-interrupt issue is usually dealt with by offloading to
a wq, but your variant works (and isn't too ugly).

> +		/* dma_free_coherent requires interrupts to be enabled. */
> +		if (!can_sleep) {
> +			/* queue up dma-buffers to be freed later */
> +			spin_lock_irqsave(&dma_bufs_lock, flags);
> +			list_add_tail(&buf->list, &pending_free_dma_bufs);
> +			spin_unlock_irqrestore(&dma_bufs_lock, flags);
> +			return;
> +		}
> +		dma_free_coherent(buf->dev, buf->size, buf->buf, buf->dma);
> +
> +		/* Release device refcnt and allow it to be freed */
> +		put_device(buf->dev);

...

> +static void reclaim_dma_bufs(void)
> +{
> +	unsigned long flags;
> +	struct port_buffer *buf, *tmp;
> +	LIST_HEAD(tmp_list);
> +
> +	if (list_empty(&pending_free_dma_bufs))
> +		return;
> +
> +	/* Create a copy of the pending_free_dma_bufs while holding the lock */
> +	spin_lock_irqsave(&dma_bufs_lock, flags);
> +	list_cut_position(&tmp_list, &pending_free_dma_bufs,
> +			  pending_free_dma_bufs.prev);
> +	spin_unlock_irqrestore(&dma_bufs_lock, flags);
> +
> +	/* Release the dma buffers, without irqs enabled */
> +	list_for_each_entry_safe(buf, tmp, &tmp_list, list) {
> +		list_del(&buf->list);
> +		free_buf(buf, true);
> +	}
> +}

Looks like this should be an easy noop even if !is_rproc_serial.

> +
>  static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
>  				     int pages)
>  {
>  	struct port_buffer *buf;
>  
> +	if (is_rproc_serial(vq->vdev))
> +		reclaim_dma_bufs();
> +

...

> @@ -904,6 +1000,8 @@ static int port_fops_release(struct inode *inode, struct file *filp)
>  	reclaim_consumed_buffers(port);
>  	spin_unlock_irq(&port->outvq_lock);
>  
> +	if (is_rproc_serial(port->portdev->vdev))
> +		reclaim_dma_bufs();

So these are redundant.

> @@ -1415,7 +1524,16 @@ static void remove_port_data(struct port *port)
>  
>  	/* Remove buffers we queued up for the Host to send us data in. */
>  	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
> -		free_buf(buf);
> +		free_buf(buf, true);
> +
> +	/*
> +	 * Remove buffers from out queue for rproc-serial. We cannot afford
> +	 * to leak any DMA mem, so reclaim this memory even if this might be
> +	 * racy for the remote processor.
> +	 */
> +	if (is_rproc_serial(port->portdev->vdev))
> +		while ((buf = virtqueue_detach_unused_buf(port->out_vq)))
> +			free_buf(buf, true);
>  }

This seems wrong; either this is needed even if !is_rproc_serial(), or
it's not necessary as the out_vq is empty.

Every path I can see has the device reset (in which case the queues
should not be active), or we got a VIRTIO_CONSOLE_PORT_REMOVE event (in
which case, the same).

I think we can have non-blocking writes which could leave buffers in
out_vq: Amit?
>  static void __exit fini(void)
>  {
> +	reclaim_dma_bufs();

Hmm, you didn't protect it here anyway...

Cheers,
Rusty.
