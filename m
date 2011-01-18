Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1ARBIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 20:08:54 -0500
Received: from ozlabs.org ([203.10.76.45]:56459 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab1ARBIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 20:08:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio_blk: allow re-reading config space at runtime
Date: Tue, 18 Jan 2011 11:38:50 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20110114160137.GA18721@lst.de>
In-Reply-To: <20110114160137.GA18721@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101181138.50421.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Jan 2011 02:31:37 am Christoph Hellwig wrote:
> Wire up the virtio_driver config_changed method to get notified about
> config changes raised by the host.  For now we just re-read the device
> size to support online resizing of devices, but once we add more
> attributes that might be changeable they could be added as well.
> 
> Note that the config_changed method is called from irq context, so
> we'll have to use the workqueue infrastructure to provide us a proper
> user context for our changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/drivers/block/virtio_blk.c
> ===================================================================
> --- xfs.orig/drivers/block/virtio_blk.c	2011-01-13 18:17:23.730254665 +0100
> +++ xfs/drivers/block/virtio_blk.c	2011-01-14 16:57:50.572032906 +0100
> @@ -6,10 +6,12 @@
>  #include <linux/virtio.h>
>  #include <linux/virtio_blk.h>
>  #include <linux/scatterlist.h>
> +#include <linux/string_helpers.h>
>  
>  #define PART_BITS 4
>  
>  static int major, index;
> +struct workqueue_struct *virtblk_wq;
>  
>  struct virtio_blk
>  {
> @@ -42,6 +44,11 @@ struct virtblk_req
>  	u8 status;
>  };
>  
> +struct virtblk_config_change {
> +	struct virtio_device *vdev;
> +	struct work_struct work;
> +};
> +
>  static void blk_done(struct virtqueue *vq)
>  {
>  	struct virtio_blk *vblk = vq->vdev->priv;
> @@ -291,6 +298,57 @@ static ssize_t virtblk_serial_show(struc
>  }
>  DEVICE_ATTR(serial, S_IRUGO, virtblk_serial_show, NULL);
>  
> +static void virtblk_config_changed_work(struct work_struct *work)
> +{
> +	struct virtblk_config_change *cfg =
> +		container_of(work, struct virtblk_config_change, work);
> +	struct virtio_device *vdev = cfg->vdev;
> +	struct virtio_blk *vblk = vdev->priv;
> +	struct request_queue *q = vblk->disk->queue;
> +	char cap_str_2[10], cap_str_10[10];
> +	u64 capacity, size;
> +
> +	/* Host must always specify the capacity. */
> +	vdev->config->get(vdev, offsetof(struct virtio_blk_config, capacity),
> +			  &capacity, sizeof(capacity));
> +
> +	/* If capacity is too big, truncate with warning. */
> +	if ((sector_t)capacity != capacity) {
> +		dev_warn(&vdev->dev, "Capacity %llu too large: truncating\n",
> +			 (unsigned long long)capacity);
> +		capacity = (sector_t)-1;
> +	}
> +
> +	size = capacity * queue_logical_block_size(q);
> +	string_get_size(size, STRING_UNITS_2, cap_str_2, sizeof(cap_str_2));
> +	string_get_size(size, STRING_UNITS_10, cap_str_10, sizeof(cap_str_10));
> +
> +	dev_notice(&vdev->dev,
> +		  "new size: %llu %d-byte logical blocks (%s/%s)\n",
> +		  (unsigned long long)capacity,
> +		  queue_logical_block_size(q),
> +		  cap_str_10, cap_str_2);
> +
> +	set_capacity(vblk->disk, capacity);
> +
> +}
> +
> +static void virtblk_config_changed(struct virtio_device *vdev)
> +{
> +	struct virtblk_config_change *cfg;
> +
> +	cfg = kmalloc(sizeof(*cfg), GFP_ATOMIC);
> +	if (!cfg) {
> +		dev_info(&vdev->dev, "skipping config change\n");
> +		return;
> +	}

I think we need to do better than this.  What would it take?

Rusty.
