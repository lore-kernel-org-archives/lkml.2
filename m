Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1LGKfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:35:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab1LGKfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:35:22 -0500
Date: Wed, 7 Dec 2011 12:37:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/12] virtio: blk: Add freeze, restore handlers to
 support S4
Message-ID: <20111207103701.GD8326@redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
 <e66570ecae66535fbb5c060f6572b94e8c9db85e.1323199985.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e66570ecae66535fbb5c060f6572b94e8c9db85e.1323199985.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 01:18:44AM +0530, Amit Shah wrote:
> Delete the vq and flush any pending requests from the block queue on the
> freeze callback to prepare for hibernation.
> 
> Re-create the vq in the restore callback to resume normal function.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> ---
>  drivers/block/virtio_blk.c |   38 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 467f218..a9147a6 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -568,6 +568,40 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
>  	ida_simple_remove(&vd_index_ida, index);
>  }
>  
> +#ifdef CONFIG_PM
> +static int virtblk_freeze(struct virtio_device *vdev)
> +{
> +	struct virtio_blk *vblk = vdev->priv;
> +
> +	/* Ensure we don't receive any more interrupts */
> +	vdev->config->reset(vdev);
> +
> +	flush_work(&vblk->config_work);

It bothers me that config work can be running
after reset here. If it does, it will not get sane
values from reading config.


Also, can there be stuff in the reqs list?
If yes is this a problem?

> +
> +	spin_lock_irq(vblk->disk->queue->queue_lock);
> +	blk_stop_queue(vblk->disk->queue);
> +	spin_unlock_irq(vblk->disk->queue->queue_lock);
> +	blk_sync_queue(vblk->disk->queue);
> +
> +	vdev->config->del_vqs(vdev);
> +	return 0;
> +}
> +

Thinking about it, looks like there's a bug in
virtblk_remove: if we get a config change after
flush_work we schedule another work.
That's a problem for sure as structure is removed.


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
> @@ -593,6 +627,10 @@ static struct virtio_driver __refdata virtio_blk = {
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
> 1.7.7.3
