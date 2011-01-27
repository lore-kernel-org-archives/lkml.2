Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab1A0Pcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:32:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1A0Pcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:32:46 -0500
Date: Thu, 27 Jan 2011 17:32:21 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.osdl.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: allow re-reading config space at runtime
Message-ID: <20110127153220.GB4898@redhat.com>
References: <20110114160137.GA18721@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114160137.GA18721@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 05:01:37PM +0100, Christoph Hellwig wrote:
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
> +
> +	cfg->vdev = vdev;
> +	INIT_WORK(&cfg->work, virtblk_config_changed_work);
> +	queue_work(virtblk_wq, &cfg->work);

This needs to be flushed on device removal, I think,
otherwise the vdev pointer will go stale.

> +}
> +
> +

Two empty lines :)

>  static int __devinit virtblk_probe(struct virtio_device *vdev)
>  {
>  	struct virtio_blk *vblk;
> @@ -508,27 +566,47 @@ static unsigned int features[] = {
>   * Use __refdata to avoid this warning.
>   */
>  static struct virtio_driver __refdata virtio_blk = {
> -	.feature_table = features,
> -	.feature_table_size = ARRAY_SIZE(features),
> -	.driver.name =	KBUILD_MODNAME,
> -	.driver.owner =	THIS_MODULE,
> -	.id_table =	id_table,
> -	.probe =	virtblk_probe,
> -	.remove =	__devexit_p(virtblk_remove),
> +	.feature_table		= features,
> +	.feature_table_size	= ARRAY_SIZE(features),
> +	.driver.name		= KBUILD_MODNAME,
> +	.driver.owner		= THIS_MODULE,
> +	.id_table		= id_table,
> +	.probe			= virtblk_probe,
> +	.remove			= __devexit_p(virtblk_remove),
> +	.config_changed		= virtblk_config_changed,
>  };
>  
>  static int __init init(void)
>  {
> +	int error;
> +
> +	virtblk_wq = alloc_workqueue("md_misc", 0, 0);
> +	if (!virtblk_wq)
> +		return -ENOMEM;
> +
>  	major = register_blkdev(0, "virtblk");
> -	if (major < 0)
> -		return major;
> -	return register_virtio_driver(&virtio_blk);
> +	if (major < 0) {
> +		error = major;
> +		goto out_destroy_workqueue;
> +	}
> +
> +	error = register_virtio_driver(&virtio_blk);
> +	if (error)
> +		goto out_unregister_blkdev;
> +	return 0;
> +
> +out_unregister_blkdev:
> +	unregister_blkdev(major, "virtblk");
> +out_destroy_workqueue:
> +	destroy_workqueue(virtblk_wq);
> +	return error;
>  }
>  
>  static void __exit fini(void)
>  {
>  	unregister_blkdev(major, "virtblk");
>  	unregister_virtio_driver(&virtio_blk);
> +	destroy_workqueue(virtblk_wq);
>  }
>  module_init(init);
>  module_exit(fini);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
