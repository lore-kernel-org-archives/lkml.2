Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab0G3JjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 05:39:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58373 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0G3JjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 05:39:01 -0400
Subject: [PATCH] block: move del_gendisk() from fs/partitions/check.c to
 block/genhd.c
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 11:39:01 +0200
Message-ID: <1280482741.1851.3.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: block: move del_gendisk() from fs/partitions/check.c to block/genhd.c

Disk code belongs into genhd, not into the partition scanner code.

Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---
 block/genhd.c         |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/partitions/check.c |   51 -------------------------------------------------
 2 files changed, 52 insertions(+), 51 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1344,3 +1344,55 @@ int invalidate_partition(struct gendisk
 }
 
 EXPORT_SYMBOL(invalidate_partition);
+
+void del_gendisk(struct gendisk *disk)
+{
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+
+	/* invalidate stuff */
+	disk_part_iter_init(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	while ((part = disk_part_iter_next(&piter))) {
+		invalidate_partition(disk, part->partno);
+		delete_partition(disk, part->partno);
+	}
+	disk_part_iter_exit(&piter);
+
+	invalidate_partition(disk, 0);
+	blk_free_devt(disk_to_dev(disk)->devt);
+	set_capacity(disk, 0);
+	disk->flags &= ~GENHD_FL_UP;
+	unlink_gendisk(disk);
+	part_stat_set_all(&disk->part0, 0);
+	disk->part0.stamp = 0;
+
+	kobject_put(disk->part0.holder_dir);
+	kobject_put(disk->slave_dir);
+	disk->driverfs_dev = NULL;
+#ifndef CONFIG_SYSFS_DEPRECATED
+	sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
+#endif
+	device_del(disk_to_dev(disk));
+}
+
+unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
+{
+	struct address_space *mapping = bdev->bd_inode->i_mapping;
+	struct page *page;
+
+	page = read_mapping_page(mapping, (pgoff_t)(n >> (PAGE_CACHE_SHIFT-9)),
+				 NULL);
+	if (!IS_ERR(page)) {
+		if (PageError(page))
+			goto fail;
+		p->v = page;
+		return (unsigned char *)page_address(page) +  ((n & ((1 << (PAGE_CACHE_SHIFT - 9)) - 1)) << 9);
+fail:
+		page_cache_release(page);
+	}
+	p->v = NULL;
+	return NULL;
+}
+
+EXPORT_SYMBOL(read_dev_sector);
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -619,54 +619,3 @@ rescan:
 	return 0;
 }
 
-unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
-{
-	struct address_space *mapping = bdev->bd_inode->i_mapping;
-	struct page *page;
-
-	page = read_mapping_page(mapping, (pgoff_t)(n >> (PAGE_CACHE_SHIFT-9)),
-				 NULL);
-	if (!IS_ERR(page)) {
-		if (PageError(page))
-			goto fail;
-		p->v = page;
-		return (unsigned char *)page_address(page) +  ((n & ((1 << (PAGE_CACHE_SHIFT - 9)) - 1)) << 9);
-fail:
-		page_cache_release(page);
-	}
-	p->v = NULL;
-	return NULL;
-}
-
-EXPORT_SYMBOL(read_dev_sector);
-
-void del_gendisk(struct gendisk *disk)
-{
-	struct disk_part_iter piter;
-	struct hd_struct *part;
-
-	/* invalidate stuff */
-	disk_part_iter_init(&piter, disk,
-			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
-	while ((part = disk_part_iter_next(&piter))) {
-		invalidate_partition(disk, part->partno);
-		delete_partition(disk, part->partno);
-	}
-	disk_part_iter_exit(&piter);
-
-	invalidate_partition(disk, 0);
-	blk_free_devt(disk_to_dev(disk)->devt);
-	set_capacity(disk, 0);
-	disk->flags &= ~GENHD_FL_UP;
-	unlink_gendisk(disk);
-	part_stat_set_all(&disk->part0, 0);
-	disk->part0.stamp = 0;
-
-	kobject_put(disk->part0.holder_dir);
-	kobject_put(disk->slave_dir);
-	disk->driverfs_dev = NULL;
-#ifndef CONFIG_SYSFS_DEPRECATED
-	sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
-#endif
-	device_del(disk_to_dev(disk));
-}


