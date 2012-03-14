Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab2CNPnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:43:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab2CNPnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:43:43 -0400
Date: Wed, 14 Mar 2012 11:43:40 -0400
From: Dave Jones <davej@redhat.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Getting oops with 3.2.10 when removing a SD card
Message-ID: <20120314154339.GB25000@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Francis Moreau <francis.moro@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAC9WiBiZ9oOaDaYjow-ZryZ8i=7uLixTAfm48YKVpbwQfLfayQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC9WiBiZ9oOaDaYjow-ZryZ8i=7uLixTAfm48YKVpbwQfLfayQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 04:38:04PM +0100, Francis Moreau wrote:
 > Hi,
 > 
 > I'm getting this oops (pretty often) after writing to a SD card and
 > removing the card.
 > 
 > Could anyone have a look please ?

Should be fixed by this patch that has been around for a while now.

	Dave

--- linux/fs/partitions/check.c~	2012-02-20 18:32:55.314253719 -0500
+++ linux/fs/partitions/check.c	2012-02-20 18:34:46.509859745 -0500
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
--- linux/include/linux/genhd.h~	2012-02-20 18:35:02.777802107 -0500
+++ linux/include/linux/genhd.h	2012-02-20 18:35:13.873762792 -0500
@@ -596,6 +596,7 @@ extern char *disk_name (struct gendisk *
 
 extern int disk_expand_part_tbl(struct gendisk *disk, int target);
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
+extern int invalidate_partitions(struct gendisk *disk, struct block_device *bdev);
 extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
 						     int partno, sector_t start,
 						     sector_t len, int flags,
--- linux/fs/block_dev.c~	2012-02-20 18:35:24.890723757 -0500
+++ linux/fs/block_dev.c	2012-02-20 18:36:25.166510197 -0500
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
