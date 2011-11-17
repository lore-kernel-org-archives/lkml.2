Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1KQM1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:27:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092Ab1KQM1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:27:01 -0500
Date: Thu, 17 Nov 2011 14:28:26 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        levinsasha928@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/11] virtio: blk: Add freeze, restore handlers to
 support S4
Message-ID: <20111117122825.GC19682@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
 <81e98fc00370152ded2eef20f0953f19fad6f0f5.1321530505.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81e98fc00370152ded2eef20f0953f19fad6f0f5.1321530505.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 05:27:37PM +0530, Amit Shah wrote:
> Delete the vq and flush any pending requests from the block queue on the
> freeze callback to prepare for hibernation.
> 
> Re-create the vq in the restore callback to resume normal function.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> ---
>  drivers/block/virtio_blk.c |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 467f218..f73fb2d 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -568,6 +568,38 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
>  	ida_simple_remove(&vd_index_ida, index);
>  }
>  
> +#ifdef CONFIG_PM
> +static int virtblk_freeze(struct virtio_device *vdev)
> +{
> +	struct virtio_blk *vblk = vdev->priv;
> +
> +	flush_work(&vblk->config_work);

What if a new config_work is scheduled after this point?
The right thing to do seems to be to flush after disabling interrupts.

> +	spin_lock_irq(vblk->disk->queue->queue_lock);
> +	blk_stop_queue(vblk->disk->queue);
> +	spin_unlock_irq(vblk->disk->queue->queue_lock);
> +	blk_sync_queue(vblk->disk->queue);
> +
> +	/* Stop all the virtqueues. */
> +	vdev->config->reset(vdev);
> +	vdev->config->del_vqs(vdev);

I think del_vqs should be followed by reset:
del_vqs assumes the device in a state find put it in.

> +	return 0;
> +}
> +
> +static int virtblk_restore(struct virtio_device *vdev)
> +{
> +	struct virtio_blk *vblk = vdev->priv;
> +	int ret;
> +
> +	ret = init_vq(vdev->priv);
> +	if (!ret) {
> +		spin_lock_irq(vblk->disk->queue->queue_lock);
> +		blk_start_queue(vblk->disk->queue);
> +		spin_unlock_irq(vblk->disk->queue->queue_lock);
> +	}
> +	return ret;
> +}
> +#endif
> +
>  static const struct virtio_device_id id_table[] = {
>  	{ VIRTIO_ID_BLOCK, VIRTIO_DEV_ANY_ID },
>  	{ 0 },
> @@ -593,6 +625,10 @@ static struct virtio_driver __refdata virtio_blk = {
>  	.probe			= virtblk_probe,
>  	.remove			= __devexit_p(virtblk_remove),
>  	.config_changed		= virtblk_config_changed,
> +#ifdef CONFIG_PM
> +	.freeze			= virtblk_freeze,
> +	.restore		= virtblk_restore,
> +#endif
>  };
>  
>  static int __init init(void)
> -- 
> 1.7.7.1
