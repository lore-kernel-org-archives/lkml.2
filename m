Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab1ISEsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 00:48:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40124 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1ISEsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 00:48:17 -0400
Subject: Re: [PATCHv5] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Wagner <david.wagner@free-electrons.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 19 Sep 2011 07:50:52 +0300
In-Reply-To: <1315821061-14819-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1315821061-14819-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1316407859.24366.48.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

some review below.

> +/**
> + * ubiblk_release - close a UBI volume (close the volume descriptor)
> + *
> + * @gd: the disk that was previously opened
> + * @mode: don't care
> + */
> +static int ubiblk_release(struct gendisk *gd, fmode_t mode)
> +{
> +	struct ubiblk_dev *dev = gd->private_data;
> +
> +	mutex_lock(&dev->vol_lock);
> +
> +	dev->refcnt--;
> +	if (dev->refcnt == 0) {
> +		kfree(dev->vi);
> +		dev->vi = NULL;
> +
> +		ubi_close_volume(dev->desc);
> +		dev->desc = NULL;
> +	}
> +
> +	dev_dbg(disk_to_dev(dev->gd), "released, mode=%d\n", mode);
> +
> +	mutex_unlock(&dev->vol_lock);
> +	return 0;
> +}

Looks buggy. I'd expect this function to  remove the device from the
list as well as free it, as well as hold the devlist_mutex...


...

> +/**
> + * ubiblk_create - create a ubiblk device proxying a UBI volume
> + *
> + * @vi: the UBI volume information data structure
> + *
> + * An UBI volume has been created ; create a corresponding ubiblk device:
> + * Initialize the locks, the structure, the block layer infos and start a
> + * req_task.
> + */
> +static int ubiblk_create(struct ubi_volume_info *vi)
> +{
> +	struct ubiblk_dev *dev;
> +	struct gendisk *gd;
> +	int ret = 0;
> +
> +	mutex_lock(&devlist_lock);
> +	/* Check that the volume isn't already proxyfied */
> +	if (ubiblk_find_dev(vi)) {
> +		ret = -EEXIST;
> +		goto out_devlist;
> +	}
> +
> +	dev = kzalloc(sizeof(struct ubiblk_dev), GFP_KERNEL);
> +	if (!dev) {
> +		ret = -ENOMEM;
> +		goto out_devlist;
> +	}
> +
> +	list_add(&dev->list, &ubiblk_devs);
> +
> +	mutex_init(&dev->vol_lock);
> +	mutex_lock(&dev->vol_lock);

I think upi do not need to take vol_lock. You are creating the volume,
and no one can open it anyway because you have 'devlist_lock' now. 
...

> +	set_capacity(gd,
> +		     (dev->vi->size *
> +		      dev->vi->usable_leb_size) >> 9);

A temporary variable would be neater.

> +	set_disk_ro(gd, 1);
> +	dev->gd = gd;
> +
> +	spin_lock_init(&dev->queue_lock);
> +	dev->rq = blk_init_queue(ubi_ubiblk_request, &dev->queue_lock);
> +	if (!dev->rq) {
> +		pr_err("blk_init_queue failed\n");
> +		ret = -ENODEV;
> +		goto out_queue;
> +	}
> +	dev->rq->queuedata = dev;
> +	blk_queue_logical_block_size(dev->rq, BLK_SIZE);
> +	dev->gd->queue = dev->rq;
> +
> +	/* Stolen from mtd_blkdevs.c */

s/Stolen/borrowed/ ?
...


> +/**
> + * ubiblk_remove - destroy a ubiblk device
> + *
> + * @vi: the UBI volume information data structure
> + *
> + * A UBI volume has been removed or we are requested to unproxify a volume ;
> + * destroy the corresponding ubiblk device
> + */
> +static int ubiblk_remove(struct ubi_volume_info *vi)
> +{
> +	struct ubiblk_dev *dev = NULL;
> +
> +	mutex_lock(&devlist_lock);
> +
> +	dev = ubiblk_find_dev(vi);
> +
> +	if (!dev) {
> +		mutex_unlock(&devlist_lock);
> +		pr_warn("trying to remove %s, but it isn't handled\n",
> +			vi->name);
> +		return -ENODEV;
> +	}
> +
> +	if (dev->desc) {
> +		mutex_unlock(&devlist_lock);
> +		return -EBUSY;
> +	}

Racy. Your dev->desc is protected by the "vol_lock", here you did not
take it, but you should. And then you can release it after
"list_del(&dev->list)".

> +
> +	del_gendisk(dev->gd);
> +	blk_cleanup_queue(dev->rq);
> +	kthread_stop(dev->req_task);
> +	put_disk(dev->gd);
> +
> +	kfree(dev->vi);
> +
> +	list_del(&dev->list);
> +	kfree(dev);
> +
> +	mutex_unlock(&devlist_lock);
> +	pr_info("unproxyfied %s\n", vi->name);
> +	return 0;
> +}

...

> +#ifdef CONFIG_COMPAT
> +static long ubiblk_ctrl_compat_ioctl(struct file *file, unsigned int cmd,
> +				     unsigned long arg)
> +{
> +	unsigned long translated_arg = (unsigned long)compat_ptr(arg);
> +
> +	return ubiblk_ctrl_ioctl(file, cmd, translated_arg);
> +}
> +#endif
> +
> +/* ubiblk control device (receives ioctls) */
> +static const struct file_operations ubiblk_ctrl_ops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = ubiblk_ctrl_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl = ubiblk_ctrl_compat_ioctl,
> +#endif
> +	.llseek = no_llseek,
> +};

You do not need compat ioctl. This is needed only for old code which
does nasty things like using pointers in ioctl data structures. The idea
is that new code uses proper ioctl data structures instead. Please, kill
this. 

...

> +static int __init ubi_ubiblk_init(void)
> +{
> +	int ret = 0;
> +
> +	ret = register_blkdev(0, "ubiblk");
> +	if (ret <= 0)
> +		return ret;

Error code "0" means success, so if you return 0 here, you'll confuse
the upper layers.

...

> +static void __exit ubi_ubiblk_exit(void)
> +{
> +	struct list_head *list_ptr, *next;
> +	struct ubiblk_dev *dev;
> +
> +	ubi_unregister_volume_notifier(&ubiblk_notifier);
> +	misc_deregister(&ctrl_dev);
> +
> +	list_for_each_safe(list_ptr, next, &ubiblk_devs) {
> +		dev = list_entry(list_ptr, struct ubiblk_dev, list);
> +
> +		/* TODO: it shouldn't happen, right ? */
> +		if (dev->desc)
> +			ubi_close_volume(dev->desc);

Since you are using mutexes now, can you remove the TODO line? If you
think "if (dev->desc)" is still needed, then please, add WARN_ON() in
the "else" part, or just kill the "if" part.

> +
> +		del_gendisk(dev->gd);
> +		blk_cleanup_queue(dev->rq);
> +		kthread_stop(dev->req_task);
> +		put_disk(dev->gd);
> +
> +		kfree(dev->vi);
> +		list_del(&dev->list); /* really needed ? */

Good question, I think we should not have comments like this in the
final driver.

> +		kfree(dev);
> +	}
> +
> +	unregister_blkdev(ubiblk_major, "ubiblk");
> +	pr_info("end of life\n");

This funny but let's remove it please.

> +}
> +
> +module_init(ubi_ubiblk_init);
> +module_exit(ubi_ubiblk_exit);
> +MODULE_DESCRIPTION("Read-only block transition layer on top of UBI");
> +MODULE_AUTHOR("David Wagner");
> +MODULE_LICENSE("GPL");

....

> +/**
> + * ubiblk_ctrl_req - additional ioctl data structure
> + * @ubi_num: UBI device number
> + * @vol_id: UBI volume identifier
    * @padding: reserved for future, must contain zeroes
> + */
> +struct ubiblk_ctrl_req {
> +	__s32 ubi_num;
> +	__s32 vol_id;
          __u8[8] padding;
> +} __packed;

Please, add paddings as suggested above.

-- 
Best Regards,
Artem Bityutskiy

