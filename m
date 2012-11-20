Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2KTWre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:47:34 -0500
Received: from mail-gh0-f179.google.com ([209.85.160.179]:39577 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2KTWrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:47:32 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2012 17:47:32 EST
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>
Cc: Tim Bird <tim.bird@am.sony.com>, dwmw2@infradead.org,
        michael.opdenacker@free-electrons.com,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: [RFC/PATCH 1/1] ubi: Add ubiblock driver
Date: Tue, 20 Nov 2012 19:39:43 -0300
Message-Id: <1353451183-18807-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block device emulation on top of ubi volumes with read/write support.
Block devices get automatically created for each ubi volume present.

Each ubiblock is fairly cheap since it's based on workqueues
and not on threads.

Read/write access is expected to work fairly well because the
request queue at block elevator orders block transfers to be space-effective.
In other words, it's expected that reads and writes gets ordered
to point to the same LEB.

To help this and reduce access to the UBI volume, a 1-LEB size
write-back cache has been implemented.
Every read and every write, goes through this cache and the write is
only done when a request arrives to read or write to a different LEB
or when the device is released, when the last file handle is closed.

This cache is 1-LEB bytes, vmalloced at open() and freed at release().

Cc: Artem Bityutskiy <dedekind1@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/mtd/ubi/Kconfig    |   12 +
 drivers/mtd/ubi/Makefile   |    1 +
 drivers/mtd/ubi/ubiblock.c |  673 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 686 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/ubi/ubiblock.c

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 36663af..aa6c592 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -87,4 +87,16 @@ config MTD_UBI_GLUEBI
 	   work on top of UBI. Do not enable this unless you use legacy
 	   software.
 
+config MTD_UBI_BLOCK
+	tristate "Caching block device access to UBI volumes"
+	help
+	   Since UBI already takes care of eraseblock wear leveling
+	   and bad block handling, it's possible to implement a block
+	   device on top of it and therefore mount regular filesystems
+	   (i.e. not flash-oriented, as ext4).
+
+	   In other words, this is a software flash translation layer.
+
+	   If in doubt, say "N".
+
 endif # MTD_UBI
diff --git a/drivers/mtd/ubi/Makefile b/drivers/mtd/ubi/Makefile
index b46b0c97..1578733 100644
--- a/drivers/mtd/ubi/Makefile
+++ b/drivers/mtd/ubi/Makefile
@@ -5,3 +5,4 @@ ubi-y += misc.o debug.o
 ubi-$(CONFIG_MTD_UBI_FASTMAP) += fastmap.o
 
 obj-$(CONFIG_MTD_UBI_GLUEBI) += gluebi.o
+obj-$(CONFIG_MTD_UBI_BLOCK) += ubiblock.o
diff --git a/drivers/mtd/ubi/ubiblock.c b/drivers/mtd/ubi/ubiblock.c
new file mode 100644
index 0000000..97655c1
--- /dev/null
+++ b/drivers/mtd/ubi/ubiblock.c
@@ -0,0 +1,673 @@
+/*
+ * Copyright (c) 2012 Ezequiel Garcia
+ * Copyright (c) 2011 Free Electrons
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ */
+
+/*#define DEBUG*/
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/mtd/ubi.h>
+#include <linux/workqueue.h>
+#include <linux/blkdev.h>
+
+#include "ubi-media.h"
+
+struct ubiblock {
+	struct ubi_volume_desc *desc;
+	struct ubi_volume_info *vi;
+	int ubi_num;
+	int vol_id;
+	int refcnt;
+
+	struct gendisk *gd;
+	struct request_queue *rq;
+
+	struct workqueue_struct *wq;
+	struct work_struct work;
+
+	struct mutex vol_mutex;
+	spinlock_t queue_lock;
+	struct list_head list;
+
+	enum { STATE_EMPTY, STATE_CLEAN, STATE_DIRTY } cache_state;
+	void *cache;
+	int cache_leb_num;
+	int leb_size;
+
+#ifdef DEBUG
+	/*
+	 * TODO: Output this information through a debugfs file.
+	 * We can re-use ubi debugfs directories.
+	 */
+	unsigned cache_read_hit, cache_read_miss;
+	unsigned cache_write_hit, cache_write_miss;
+#endif
+};
+
+/* Linked list of all ubiblock instances */
+static LIST_HEAD(ubiblock_devices);
+static DEFINE_MUTEX(devices_mutex);
+static int ubiblock_major;
+
+static struct ubiblock *find_dev_nolock(int ubi_num, int vol_id)
+{
+	struct ubiblock *dev;
+
+	list_for_each_entry(dev, &ubiblock_devices, list)
+		if (dev->ubi_num == ubi_num && dev->vol_id == vol_id)
+			return dev;
+	return NULL;
+}
+
+static bool leb_on_cache(struct ubiblock *dev, int leb_num)
+{
+	return dev->cache_leb_num == leb_num;
+}
+
+static int ubiblock_fill_cache(struct ubiblock *dev, int leb_num)
+{
+	int ret;
+
+	/* Warn if we fill cache while being dirty */
+	WARN_ON(dev->cache_state == STATE_DIRTY);
+
+	dev->cache_leb_num = leb_num;
+	dev->cache_state = STATE_CLEAN;
+
+	ret = ubi_read(dev->desc, leb_num, dev->cache, 0, dev->leb_size);
+	if (ret) {
+		dev_err(disk_to_dev(dev->gd), "ubi_read error %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int ubiblock_flush(struct ubiblock *dev, bool sync)
+{
+	int ret = 0;
+
+	if (dev->cache_state != STATE_DIRTY)
+		return 0;
+
+	/*
+	 * TODO: mtdblock sets STATE_EMPTY, arguing that it prevents the
+	 * underlying media to get changed without notice.
+	 * I'm not fully convinced, so I just put STATE_CLEAN.
+	 */
+	dev->cache_state = STATE_CLEAN;
+
+	/* Atomically change leb with buffer contents */
+	ret = ubi_leb_change(dev->desc, dev->cache_leb_num,
+			     dev->cache, dev->leb_size);
+	if (ret) {
+		dev_err(disk_to_dev(dev->gd), "ubi_leb_change error %d\n", ret);
+		return ret;
+	}
+
+	/* Sync ubi device when device is released and on block flush ioctl */
+	if (sync)
+		ret = ubi_sync(dev->ubi_num);
+
+	return ret;
+}
+
+static int ubiblock_read(struct ubiblock *dev, char *buffer,
+			 int pos, int len)
+{
+	int leb, offset, ret;
+	int bytes_left = len;
+	int to_read = len;
+	bool cached;
+
+	/* Get leb:offset address to read from */
+	leb = pos / dev->leb_size;
+	offset = pos % dev->leb_size;
+
+	while (bytes_left) {
+
+		/*
+		 * We can only read one leb at a time.
+		 * Therefore if the read length is larger than
+		 * one leb size, we split the operation.
+		 */
+		if (offset + to_read > dev->leb_size)
+			to_read = dev->leb_size - offset;
+
+		/*
+		 * If leb is not cached, we flush current cached leb to disk
+		 * and read new leb to cache. Then we read from cache to buffer.
+		 * This means we share the cache between reads and writes.
+		 *
+		 * Might this be suboptimal, it's possible to:
+		 * 1. Split caches, though this looks overly complicated.
+		 * 2. Don't read always from cache, but rather from cache only
+		 *    if the leb is cached, and from disk otherwise.
+		 */
+		cached = leb_on_cache(dev, leb);
+		if (!cached) {
+			ret = ubiblock_flush(dev, false);
+			if (ret)
+				return ret;
+
+			ret = ubiblock_fill_cache(dev, leb);
+			if (ret)
+				return ret;
+		}
+		memcpy(buffer, dev->cache + offset, to_read);
+
+		buffer += to_read;
+		bytes_left -= to_read;
+		to_read = bytes_left;
+		leb++;
+		offset = 0;
+#ifdef DEBUG
+		if (cached)
+			dev->cache_read_hit++;
+		else
+			dev->cache_read_miss++;
+#endif
+	}
+	return 0;
+}
+
+static int ubiblock_write(struct ubiblock *dev, const char *buffer,
+			 int pos, int len)
+{
+	int leb, offset, ret;
+	int bytes_left = len;
+	int to_write = len;
+	bool cached;
+
+	/* Get (leb:offset) address to write */
+	leb = pos / dev->leb_size;
+	offset = pos % dev->leb_size;
+
+	while (bytes_left) {
+		/*
+		 * We can only write one leb at a time.
+		 * Therefore if the write length is larger than
+		 * one leb size, we split the operation.
+		 */
+		if (offset + to_write > dev->leb_size)
+			to_write = dev->leb_size - offset;
+
+		/*
+		 * If leb is not cached, we flush current cached leb to disk
+		 * and read new leb to cache. Then we write to cached buffer.
+		 */
+		cached = leb_on_cache(dev, leb);
+		if (!cached) {
+			ret = ubiblock_flush(dev, false);
+			if (ret)
+				return ret;
+
+			ret = ubiblock_fill_cache(dev, leb);
+			if (ret)
+				return ret;
+		}
+
+		/* Write to local cache */
+		memcpy(dev->cache + offset, buffer, to_write);
+
+		/* This is the only place where we dirt the cache */
+		dev->cache_state = STATE_DIRTY;
+
+		buffer += to_write;
+		bytes_left -= to_write;
+		to_write = bytes_left;
+		offset = 0;
+		leb++;
+#ifdef DEBUG
+		if (cached)
+			dev->cache_write_hit++;
+		else
+			dev->cache_write_miss++;
+#endif
+	}
+	return 0;
+}
+
+static int do_ubiblock_request(struct ubiblock *dev, struct request *req)
+{
+	int pos, len;
+
+	if (req->cmd_type != REQ_TYPE_FS)
+		return -EIO;
+
+	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
+	    get_capacity(req->rq_disk))
+		return -EIO;
+
+	pos = blk_rq_pos(req) << 9;
+	len = blk_rq_cur_bytes(req);
+
+	switch (rq_data_dir(req)) {
+	case READ:
+		return ubiblock_read(dev, req->buffer, pos, len);
+	case WRITE:
+		return ubiblock_write(dev, req->buffer, pos, len);
+	default:
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void ubiblock_do_work(struct work_struct *work)
+{
+	struct ubiblock *dev =
+		container_of(work, struct ubiblock, work);
+	struct request_queue *rq = dev->rq;
+	struct request *req;
+	int res;
+
+	spin_lock_irq(rq->queue_lock);
+
+	req = blk_fetch_request(rq);
+	while (req) {
+
+		spin_unlock_irq(rq->queue_lock);
+
+		mutex_lock(&dev->vol_mutex);
+		res = do_ubiblock_request(dev, req);
+		mutex_unlock(&dev->vol_mutex);
+
+		spin_lock_irq(rq->queue_lock);
+
+		/*
+		 * If we're done with this request,
+		 * we need to fetch a new one
+		 */
+		if (!__blk_end_request_cur(req, res))
+			req = blk_fetch_request(rq);
+	}
+
+	spin_unlock_irq(rq->queue_lock);
+}
+
+static void ubiblock_request(struct request_queue *rq)
+{
+	struct ubiblock *dev;
+	struct request *req;
+
+	dev = rq->queuedata;
+
+	if (!dev)
+		while ((req = blk_fetch_request(rq)) != NULL)
+			__blk_end_request_all(req, -ENODEV);
+	else
+		queue_work(dev->wq, &dev->work);
+}
+
+static int ubiblock_open(struct block_device *bdev, fmode_t mode)
+{
+	struct ubiblock *dev = bdev->bd_disk->private_data;
+	int ubi_mode = UBI_READONLY;
+	int ret;
+
+	mutex_lock(&dev->vol_mutex);
+	if (dev->refcnt > 0) {
+		/*
+		 * The volume is already opened,
+		 * just increase the reference counter
+		 */
+		dev->refcnt++;
+		mutex_unlock(&dev->vol_mutex);
+		return 0;
+	}
+
+	if (mode & FMODE_WRITE)
+		ubi_mode = UBI_READWRITE;
+
+	dev->desc = ubi_open_volume(dev->ubi_num, dev->vol_id, ubi_mode);
+	if (IS_ERR(dev->desc)) {
+		dev_err(disk_to_dev(dev->gd),
+			"failed to open ubi volume %d_%d\n",
+			dev->ubi_num, dev->vol_id);
+
+		ret = PTR_ERR(dev->desc);
+		dev->desc = NULL;
+		goto out_unlock;
+	}
+
+	dev->vi = kzalloc(sizeof(struct ubi_volume_info), GFP_KERNEL);
+	if (!dev->vi) {
+		ret = -ENOMEM;
+		goto out_close;
+	}
+	ubi_get_volume_info(dev->desc, dev->vi);
+
+	/* Allocate cache buffer, mtdblock uses vmalloc and we do too */
+	dev->leb_size = dev->vi->usable_leb_size;
+	dev->cache_leb_num = -1;
+	dev->cache = vmalloc(dev->leb_size);
+	if (!dev->cache) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	dev->refcnt++;
+	mutex_unlock(&dev->vol_mutex);
+	return 0;
+
+out_free:
+	kfree(dev->vi);
+out_close:
+	ubi_close_volume(dev->desc);
+	dev->desc = NULL;
+out_unlock:
+	mutex_unlock(&dev->vol_mutex);
+	return ret;
+}
+
+static int ubiblock_release(struct gendisk *gd, fmode_t mode)
+{
+	struct ubiblock *dev = gd->private_data;
+
+	mutex_lock(&dev->vol_mutex);
+
+	dev->refcnt--;
+	if (dev->refcnt == 0) {
+		ubiblock_flush(dev, true);
+
+		vfree(dev->cache);
+		dev->cache_leb_num = -1;
+		dev->cache_state = STATE_EMPTY;
+
+		kfree(dev->vi);
+		ubi_close_volume(dev->desc);
+
+		dev->vi = NULL;
+		dev->desc = NULL;
+	}
+
+	mutex_unlock(&dev->vol_mutex);
+	return 0;
+}
+
+static int ubiblock_ioctl(struct block_device *bdev, fmode_t mode,
+			      unsigned int cmd, unsigned long arg)
+{
+	struct ubiblock *dev = bdev->bd_disk->private_data;
+	int ret = -ENXIO;
+
+	if (!dev)
+		return ret;
+
+	mutex_lock(&dev->vol_mutex);
+
+	/* I can't get this to get called. What's going on? */
+	switch (cmd) {
+	case BLKFLSBUF:
+		ret = ubiblock_flush(dev, true);
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+
+	mutex_unlock(&dev->vol_mutex);
+	return ret;
+}
+
+static const struct block_device_operations ubiblock_ops = {
+	.owner = THIS_MODULE,
+	.open = ubiblock_open,
+	.release = ubiblock_release,
+	.ioctl = ubiblock_ioctl,
+};
+
+static int ubiblock_add(struct ubi_volume_info *vi)
+{
+	struct ubiblock *dev;
+	struct gendisk *gd;
+	int disk_capacity;
+	int ret;
+
+	/* Check that the volume isn't already handled */
+	mutex_lock(&devices_mutex);
+	if (find_dev_nolock(vi->ubi_num, vi->vol_id)) {
+		mutex_unlock(&devices_mutex);
+		return -EEXIST;
+	}
+	mutex_unlock(&devices_mutex);
+
+	dev = kzalloc(sizeof(struct ubiblock), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	mutex_init(&dev->vol_mutex);
+
+	dev->ubi_num = vi->ubi_num;
+	dev->vol_id = vi->vol_id;
+
+	/* Initialize the gendisk of this ubiblock device */
+	gd = alloc_disk(1);
+	if (!gd) {
+		pr_err("alloc_disk failed\n");
+		ret = -ENODEV;
+		goto out_free_dev;
+	}
+
+	gd->fops = &ubiblock_ops;
+	gd->major = ubiblock_major;
+	gd->first_minor = dev->ubi_num * UBI_MAX_VOLUMES + dev->vol_id;
+	gd->private_data = dev;
+	sprintf(gd->disk_name, "ubiblock%d_%d", dev->ubi_num, dev->vol_id);
+	disk_capacity = (vi->size * vi->usable_leb_size) >> 9;
+	set_capacity(gd, disk_capacity);
+	dev->gd = gd;
+
+	spin_lock_init(&dev->queue_lock);
+	dev->rq = blk_init_queue(ubiblock_request, &dev->queue_lock);
+	if (!dev->rq) {
+		pr_err("blk_init_queue failed\n");
+		ret = -ENODEV;
+		goto out_put_disk;
+	}
+
+	dev->rq->queuedata = dev;
+	dev->gd->queue = dev->rq;
+
+	/* TODO: Is performance better or worse with this flag? */
+	/* queue_flag_set_unlocked(QUEUE_FLAG_NONROT, dev->rq);*/
+
+	/*
+	 * Create one workqueue per volume (per registered block device).
+	 * Rembember workqueues are cheap, they're not threads.
+	 */
+	dev->wq = alloc_workqueue(gd->disk_name, 0, 0);
+	if (!dev->wq)
+		goto out_free_queue;
+	INIT_WORK(&dev->work, ubiblock_do_work);
+
+	mutex_lock(&devices_mutex);
+	list_add_tail(&dev->list, &ubiblock_devices);
+	mutex_unlock(&devices_mutex);
+
+	/* Must be the last step: anyone can call file ops from now on */
+	add_disk(dev->gd);
+
+	dev_info(disk_to_dev(dev->gd), "created from ubi%d:%d(%s)\n",
+		 dev->ubi_num, dev->vol_id, vi->name);
+
+	return 0;
+
+out_free_queue:
+	blk_cleanup_queue(dev->rq);
+out_put_disk:
+	put_disk(dev->gd);
+out_free_dev:
+	kfree(dev);
+
+	return ret;
+}
+
+static void ubiblock_cleanup(struct ubiblock *dev)
+{
+#ifdef DEBUG
+	pr_debug("%s: read hit/miss %d/%d, write hit/miss %d/%d\n",
+		dev->gd->disk_name,
+		dev->cache_read_hit, dev->cache_read_miss,
+		dev->cache_write_hit, dev->cache_write_miss);
+#endif
+	del_gendisk(dev->gd);
+	blk_cleanup_queue(dev->rq);
+	put_disk(dev->gd);
+}
+
+static int ubiblock_del(struct ubi_volume_info *vi)
+{
+	struct ubiblock *dev;
+
+	mutex_lock(&devices_mutex);
+	dev = find_dev_nolock(vi->ubi_num, vi->vol_id);
+	if (!dev) {
+		mutex_unlock(&devices_mutex);
+		pr_warn("trying to remove %s, but it isn't handled\n",
+			vi->name);
+		return -ENODEV;
+	}
+	/* Remove from device list */
+	list_del(&dev->list);
+	mutex_unlock(&devices_mutex);
+
+	/* Flush pending work and stop this workqueue */
+	destroy_workqueue(dev->wq);
+
+	mutex_lock(&dev->vol_mutex);
+
+	/*
+	 * This means that ubiblock device is opened and in usage.
+	 * However, this shouldn't happen, since we have
+	 * called ubi_open_volume() at open() time, thus preventing
+	 * volume removal.
+	 */
+	WARN_ON(dev->desc);
+	ubiblock_cleanup(dev);
+
+	mutex_unlock(&dev->vol_mutex);
+
+	kfree(dev);
+
+	return 0;
+}
+
+static int ubiblock_resize(struct ubi_volume_info *vi)
+{
+	struct ubiblock *dev;
+	int disk_capacity;
+
+	/*
+	 * We don't touch the list, but we better lock it: it could be that the
+	 * device gets removed between the time the device has been found and
+	 * the time we access dev->gd
+	 */
+	mutex_lock(&devices_mutex);
+	dev = find_dev_nolock(vi->ubi_num, vi->vol_id);
+	if (!dev) {
+		mutex_unlock(&devices_mutex);
+		pr_warn("trying to resize %s, which isn't handled\n",
+			vi->name);
+		return -ENODEV;
+	}
+	mutex_unlock(&devices_mutex);
+
+	mutex_lock(&dev->vol_mutex);
+	disk_capacity = (vi->size * vi->usable_leb_size) >> 9;
+	set_capacity(dev->gd, disk_capacity);
+	dev_dbg(disk_to_dev(dev->gd), "resized to %d LEBs\n", vi->size);
+	mutex_unlock(&dev->vol_mutex);
+
+	return 0;
+}
+
+static int ubiblock_notify(struct notifier_block *nb,
+			 unsigned long notification_type, void *ns_ptr)
+{
+	struct ubi_notification *nt = ns_ptr;
+
+	switch (notification_type) {
+	case UBI_VOLUME_ADDED:
+		ubiblock_add(&nt->vi);
+		break;
+	case UBI_VOLUME_REMOVED:
+		ubiblock_del(&nt->vi);
+		break;
+	case UBI_VOLUME_RESIZED:
+		ubiblock_resize(&nt->vi);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block ubiblock_notifier = {
+	.notifier_call = ubiblock_notify,
+};
+
+static int __init ubiblock_init(void)
+{
+	ubiblock_major = register_blkdev(0, "ubiblock");
+	if (ubiblock_major < 0)
+		return ubiblock_major;
+
+	/*
+	 * Blocks will get registered dynamically.
+	 * Each ubi volume will get a corresponding block device.
+	 */
+	return ubi_register_volume_notifier(&ubiblock_notifier, 0);
+}
+
+static void __exit ubiblock_exit(void)
+{
+	struct ubiblock *next;
+	struct ubiblock *dev;
+
+	ubi_unregister_volume_notifier(&ubiblock_notifier);
+
+	list_for_each_entry_safe(dev, next, &ubiblock_devices, list) {
+
+		/* Flush pending work and stop workqueue */
+		destroy_workqueue(dev->wq);
+
+		/* The module is being forcefully removed */
+		WARN_ON(dev->desc);
+
+		/* Remove from device list */
+		list_del(&dev->list);
+
+		ubiblock_cleanup(dev);
+
+		kfree(dev);
+	}
+
+	unregister_blkdev(ubiblock_major, "ubiblock");
+}
+
+module_init(ubiblock_init);
+module_exit(ubiblock_exit);
+
+MODULE_DESCRIPTION("Block device emulation access to UBI volumes");
+MODULE_AUTHOR("David Wagner");
+MODULE_AUTHOR("Ezequiel Garcia <elezegarcia@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.8.6

