Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab0HDCGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:06:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34082 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044Ab0HDCGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:06:19 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Will Drewry <wad@chromium.org>
Subject: [PATCH v2 1/3] block, partition: add partition_meta_info to hd_struct
Date: Tue,  3 Aug 2010 21:04:41 -0500
Message-Id: <1280887483-2979-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com>
References: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes adds a partition_meta_info struct which itself contains a
union of structures that provide partition table specific metadata.

This change leaves the union empty. The subsequent patch includes an
implementation for CONFIG_EFI_PARTITION-based metadata.

Signed-off-by: Will Drewry <wad@chromium.org>

v2: move assignment of p->info after copy
---
 block/genhd.c         |    1 +
 block/ioctl.c         |    2 +-
 fs/partitions/check.c |   22 +++++++++++++++++++---
 fs/partitions/check.h |    2 ++
 include/linux/genhd.h |   32 ++++++++++++++++++++++++++++++--
 5 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 59a2db6..c8da120 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1004,6 +1004,7 @@ static void disk_release(struct device *dev)
 	kfree(disk->random);
 	disk_replace_part_tbl(disk, NULL);
 	free_part_stats(&disk->part0);
+	free_part_info(&disk->part0);
 	kfree(disk);
 }
 struct class block_class = {
diff --git a/block/ioctl.c b/block/ioctl.c
index e8eb679..f8e4bfe 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -62,7 +62,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 
 			/* all seems OK */
 			part = add_partition(disk, partno, start, length,
-					     ADDPART_FLAG_NONE);
+					     ADDPART_FLAG_NONE, NULL);
 			mutex_unlock(&bdev->bd_mutex);
 			return IS_ERR(part) ? PTR_ERR(part) : 0;
 		case BLKPG_DEL_PARTITION:
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 5dcd4b0..b616da8 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -196,6 +196,8 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 		printk(" unknown partition table\n");
 	else if (warn_no_part)
 		printk(" unable to read partition table\n");
+	for (i = 0; i < DISK_MAX_PARTS; ++i)
+		kfree(state->parts[i].info);
 	kfree(state);
 	return ERR_PTR(res);
 }
@@ -338,6 +340,7 @@ static void part_release(struct device *dev)
 {
 	struct hd_struct *p = dev_to_part(dev);
 	free_part_stats(p);
+	free_part_info(p);
 	kfree(p);
 }
 
@@ -387,7 +390,8 @@ static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
 		   whole_disk_show, NULL);
 
 struct hd_struct *add_partition(struct gendisk *disk, int partno,
-				sector_t start, sector_t len, int flags)
+				sector_t start, sector_t len, int flags,
+				struct partition_meta_info *info)
 {
 	struct hd_struct *p;
 	dev_t devt = MKDEV(0, 0);
@@ -424,6 +428,14 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	p->partno = partno;
 	p->policy = get_disk_ro(disk);
 
+	if (info) {
+		struct partition_meta_info *pinfo = alloc_part_info(disk);
+		if (!pinfo)
+			goto out_free_stats;
+		memcpy(pinfo, info, sizeof(*info));
+		p->info = pinfo;
+	}
+
 	dname = dev_name(ddev);
 	if (isdigit(dname[strlen(dname) - 1]))
 		dev_set_name(pdev, "%sp%d", dname, partno);
@@ -437,7 +449,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 
 	err = blk_alloc_devt(p, &devt);
 	if (err)
-		goto out_free_stats;
+		goto out_free_info;
 	pdev->devt = devt;
 
 	/* delay uevent until 'holders' subdir is created */
@@ -468,6 +480,8 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 
 	return p;
 
+out_free_info:
+	free_part_info(p);
 out_free_stats:
 	free_part_stats(p);
 out_free:
@@ -663,7 +677,9 @@ rescan:
 			}
 		}
 		part = add_partition(disk, p, from, size,
-				     state->parts[p].flags);
+				     state->parts[p].flags,
+				     state->parts[p].info);
+		kfree(state->parts[p].info);
 		if (IS_ERR(part)) {
 			printk(KERN_ERR " %s: p%d could not be added: %ld\n",
 			       disk->disk_name, p, -PTR_ERR(part));
diff --git a/fs/partitions/check.h b/fs/partitions/check.h
index 52f8bd3..8c724a7 100644
--- a/fs/partitions/check.h
+++ b/fs/partitions/check.h
@@ -1,6 +1,7 @@
 #include <linux/pagemap.h>
 #include <linux/blkdev.h>
 
+struct partition_meta_info;
 /*
  * add_gd_partition adds a partitions details to the devices partition
  * description.
@@ -12,6 +13,7 @@ struct parsed_partitions {
 		sector_t from;
 		sector_t size;
 		int flags;
+		struct partition_meta_info *info;
 	} parts[DISK_MAX_PARTS];
 	int next;
 	int limit;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5f2f4c4..7b6644a 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/kdev_t.h>
 #include <linux/rcupdate.h>
+#include <linux/slab.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -86,7 +87,18 @@ struct disk_stats {
 	unsigned long io_ticks;
 	unsigned long time_in_queue;
 };
-	
+
+enum partition_meta_info_format_t {
+	/* Partition info format */
+	PARTITION_META_INFO_FORMAT_NONE = 0,
+};
+
+struct partition_meta_info {
+	enum partition_meta_info_format_t format;
+	union {
+	};
+};
+
 struct hd_struct {
 	sector_t start_sect;
 	sector_t nr_sects;
@@ -95,6 +107,7 @@ struct hd_struct {
 	struct device __dev;
 	struct kobject *holder_dir;
 	int policy, partno;
+	struct partition_meta_info *info;
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	int make_it_fail;
 #endif
@@ -342,6 +355,19 @@ static inline int part_in_flight(struct hd_struct *part)
 	return part->in_flight[0] + part->in_flight[1];
 }
 
+static inline struct partition_meta_info *alloc_part_info(struct gendisk *disk)
+{
+	if (disk)
+		return kzalloc_node(sizeof(struct partition_meta_info),
+				    GFP_KERNEL, disk->node_id);
+	return kzalloc(sizeof(struct partition_meta_info), GFP_KERNEL);
+}
+
+static inline void free_part_info(struct hd_struct *part)
+{
+	kfree(part->info);
+}
+
 /* block/blk-core.c */
 extern void part_round_stats(int cpu, struct hd_struct *part);
 
@@ -533,7 +559,9 @@ extern int disk_expand_part_tbl(struct gendisk *disk, int target);
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
 extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
 						     int partno, sector_t start,
-						     sector_t len, int flags);
+						     sector_t len, int flags,
+						     struct partition_meta_info
+						       *info);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
 
-- 
1.7.0.4

