Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946525Ab2CPXo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:44:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38586 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946398Ab2CPXlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:41:04 -0400
Message-Id: <20120316233813.184459935@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Huajun Li <huajun.li.lee@gmail.com>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 29/41] block: Fix NULL pointer dereference in sd_revalidate_disk
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

commit fe316bf2d5847bc5dd975668671a7b1067603bc7 upstream.

Since 2.6.39 (1196f8b), when a driver returns -ENOMEDIUM for open(),
__blkdev_get() calls rescan_partitions() to remove
in-kernel partition structures and raise KOBJ_CHANGE uevent.

However it ends up calling driver's revalidate_disk without open
and could cause oops.

In the case of SCSI:

  process A                  process B
  ----------------------------------------------
  sys_open
    __blkdev_get
      sd_open
        returns -ENOMEDIUM
                             scsi_remove_device
                               <scsi_device torn down>
      rescan_partitions
        sd_revalidate_disk
          <oops>
Oopses are reported here:
http://marc.info/?l=linux-scsi&m=132388619710052

This patch separates the partition invalidation from rescan_partitions()
and use it for -ENOMEDIUM case.

Reported-by: Huajun Li <huajun.li.lee@gmail.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/block_dev.c        |   16 ++++++++++++----
 fs/partitions/check.c |   48 ++++++++++++++++++++++++++++++++++++++++--------
 include/linux/genhd.h |    1 +
 3 files changed, 53 insertions(+), 12 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1159,8 +1159,12 @@ static int __blkdev_get(struct block_dev
 			 * The latter is necessary to prevent ghost
 			 * partitions on a removed medium.
 			 */
-			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
-				rescan_partitions(disk, bdev);
+			if (bdev->bd_invalidated) {
+				if (!ret)
+					rescan_partitions(disk, bdev);
+				else if (ret == -ENOMEDIUM)
+					invalidate_partitions(disk, bdev);
+			}
 			if (ret)
 				goto out_clear;
 		} else {
@@ -1190,8 +1194,12 @@ static int __blkdev_get(struct block_dev
 			if (bdev->bd_disk->fops->open)
 				ret = bdev->bd_disk->fops->open(bdev, mode);
 			/* the same as first opener case, read comment there */
-			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
-				rescan_partitions(bdev->bd_disk, bdev);
+			if (bdev->bd_invalidated) {
+				if (!ret)
+					rescan_partitions(bdev->bd_disk, bdev);
+				else if (ret == -ENOMEDIUM)
+					invalidate_partitions(bdev->bd_disk, bdev);
+			}
 			if (ret)
 				goto out_unlock_bdev;
 		}
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -539,17 +539,11 @@ static bool disk_unlock_native_capacity(
 	}
 }
 
-int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
+static int drop_partitions(struct gendisk *disk, struct block_device *bdev)
 {
-	struct parsed_partitions *state = NULL;
 	struct disk_part_iter piter;
 	struct hd_struct *part;
-	int p, highest, res;
-rescan:
-	if (state && !IS_ERR(state)) {
-		kfree(state);
-		state = NULL;
-	}
+	int res;
 
 	if (bdev->bd_part_count)
 		return -EBUSY;
@@ -562,6 +556,24 @@ rescan:
 		delete_partition(disk, part->partno);
 	disk_part_iter_exit(&piter);
 
+	return 0;
+}
+
+int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
+{
+	struct parsed_partitions *state = NULL;
+	struct hd_struct *part;
+	int p, highest, res;
+rescan:
+	if (state && !IS_ERR(state)) {
+		kfree(state);
+		state = NULL;
+	}
+
+	res = drop_partitions(disk, bdev);
+	if (res)
+		return res;
+
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
 	check_disk_size_change(disk, bdev);
@@ -665,6 +677,26 @@ rescan:
 	return 0;
 }
 
+int invalidate_partitions(struct gendisk *disk, struct block_device *bdev)
+{
+	int res;
+
+	if (!bdev->bd_invalidated)
+		return 0;
+
+	res = drop_partitions(disk, bdev);
+	if (res)
+		return res;
+
+	set_capacity(disk, 0);
+	check_disk_size_change(disk, bdev);
+	bdev->bd_invalidated = 0;
+	/* tell userspace that the media / partition table may have changed */
+	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
+
+	return 0;
+}
+
 unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
 {
 	struct address_space *mapping = bdev->bd_inode->i_mapping;
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -596,6 +596,7 @@ extern char *disk_name (struct gendisk *
 
 extern int disk_expand_part_tbl(struct gendisk *disk, int target);
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
+extern int invalidate_partitions(struct gendisk *disk, struct block_device *bdev);
 extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
 						     int partno, sector_t start,
 						     sector_t len, int flags,


