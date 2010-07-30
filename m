Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0G3Ih1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 04:37:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43287 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab0G3IhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 04:37:24 -0400
Subject: [PATCH] block: move register_disk() from fs/partitions/check.c to
 genhd.c and unexport it
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 10:37:31 +0200
Message-ID: <1280479051.1446.4.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: block: move register_disk() from fs/partitions/check.c to genhd.c and unexport it

Disk code belongs into genhd, not in the partition code.
Follow-up patches will need to re-shuffle some code, which
needs to be in one file, to fix bad sysfs attribute creation
timing.

Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---
 block/genhd.c          |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/partitions/check.c  |   59 -------------------------------------------------
 include/linux/blkdev.h |    1 
 3 files changed, 58 insertions(+), 60 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -504,6 +504,64 @@ static int exact_lock(dev_t devt, void *
 	return 0;
 }
 
+static void register_disk(struct gendisk *disk)
+{
+	struct device *ddev = disk_to_dev(disk);
+	struct block_device *bdev;
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+	int err;
+
+	ddev->parent = disk->driverfs_dev;
+
+	dev_set_name(ddev, disk->disk_name);
+
+	/* delay uevents, until we scanned partition table */
+	dev_set_uevent_suppress(ddev, 1);
+
+	if (device_add(ddev))
+		return;
+#ifndef CONFIG_SYSFS_DEPRECATED
+	err = sysfs_create_link(block_depr, &ddev->kobj,
+				kobject_name(&ddev->kobj));
+	if (err) {
+		device_del(ddev);
+		return;
+	}
+#endif
+	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
+	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
+
+	/* No minors to use for partitions */
+	if (!disk_partitionable(disk))
+		goto exit;
+
+	/* No such device (e.g., media were just removed) */
+	if (!get_capacity(disk))
+		goto exit;
+
+	bdev = bdget_disk(disk, 0);
+	if (!bdev)
+		goto exit;
+
+	bdev->bd_invalidated = 1;
+	err = blkdev_get(bdev, FMODE_READ);
+	if (err < 0)
+		goto exit;
+	blkdev_put(bdev, FMODE_READ);
+
+exit:
+	/* announce disk after possible partitions are created */
+	dev_set_uevent_suppress(ddev, 0);
+	kobject_uevent(&ddev->kobj, KOBJ_ADD);
+
+	/* announce possible partitions */
+	disk_part_iter_init(&piter, disk, 0);
+	while ((part = disk_part_iter_next(&piter)))
+		kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
+	disk_part_iter_exit(&piter);
+}
+
 /**
  * add_disk - add partitioning information to kernel list
  * @disk: per-device partitioning information
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -482,65 +482,6 @@ out_put:
 	return ERR_PTR(err);
 }
 
-/* Not exported, helper to add_disk(). */
-void register_disk(struct gendisk *disk)
-{
-	struct device *ddev = disk_to_dev(disk);
-	struct block_device *bdev;
-	struct disk_part_iter piter;
-	struct hd_struct *part;
-	int err;
-
-	ddev->parent = disk->driverfs_dev;
-
-	dev_set_name(ddev, disk->disk_name);
-
-	/* delay uevents, until we scanned partition table */
-	dev_set_uevent_suppress(ddev, 1);
-
-	if (device_add(ddev))
-		return;
-#ifndef CONFIG_SYSFS_DEPRECATED
-	err = sysfs_create_link(block_depr, &ddev->kobj,
-				kobject_name(&ddev->kobj));
-	if (err) {
-		device_del(ddev);
-		return;
-	}
-#endif
-	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
-	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
-
-	/* No minors to use for partitions */
-	if (!disk_partitionable(disk))
-		goto exit;
-
-	/* No such device (e.g., media were just removed) */
-	if (!get_capacity(disk))
-		goto exit;
-
-	bdev = bdget_disk(disk, 0);
-	if (!bdev)
-		goto exit;
-
-	bdev->bd_invalidated = 1;
-	err = blkdev_get(bdev, FMODE_READ);
-	if (err < 0)
-		goto exit;
-	blkdev_put(bdev, FMODE_READ);
-
-exit:
-	/* announce disk after possible partitions are created */
-	dev_set_uevent_suppress(ddev, 0);
-	kobject_uevent(&ddev->kobj, KOBJ_ADD);
-
-	/* announce possible partitions */
-	disk_part_iter_init(&piter, disk, 0);
-	while ((part = disk_part_iter_next(&piter)))
-		kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
-	disk_part_iter_exit(&piter);
-}
-
 static bool disk_unlock_native_capacity(struct gendisk *disk)
 {
 	const struct block_device_operations *bdops = disk->fops;
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -771,7 +771,6 @@ static inline void rq_flush_dcache_pages
 
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
-extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);


