Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab0EOSKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 14:10:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:40246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab0EOSKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 14:10:08 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net,
       bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/8] block: restart partition scan after resizing a device
Date: Sat, 15 May 2010 20:09:28 +0200
Message-Id: <1273946974-29131-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273946974-29131-1-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 15 May 2010 18:09:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device resize via ->set_capacity() can reveal new partitions (e.g. in
chained partition table formats such as dos extended parts).  Restart
partition scan from the beginning after resizing a device.  This
change also makes libata always revalidate the disk after resize which
makes lower layer native capacity unlocking implementation simpler and
more robust as resize can be handled in the usual path.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/partitions/check.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e238ab2..8f01df3 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -544,7 +544,7 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	struct hd_struct *part;
 	struct parsed_partitions *state;
 	int p, highest, res;
-
+rescan:
 	if (bdev->bd_part_count)
 		return -EBUSY;
 	res = invalidate_partition(disk, 0);
@@ -581,7 +581,7 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	/* add partitions */
 	for (p = 1; p < state->limit; p++) {
 		sector_t size, from;
-try_scan:
+
 		size = state->parts[p].size;
 		if (!size)
 			continue;
@@ -596,7 +596,6 @@ try_scan:
 
 		if (from + size > get_capacity(disk)) {
 			const struct block_device_operations *bdops = disk->fops;
-			unsigned long long capacity;
 
 			printk(KERN_WARNING
 			       "%s: p%d size %llu exceeds device capacity, ",
@@ -605,14 +604,11 @@ try_scan:
 			if (bdops->set_capacity &&
 			    (disk->flags & GENHD_FL_NATIVE_CAPACITY) == 0) {
 				printk(KERN_CONT "enabling native capacity\n");
-				capacity = bdops->set_capacity(disk, ~0ULL);
+				bdops->set_capacity(disk, ~0ULL);
 				disk->flags |= GENHD_FL_NATIVE_CAPACITY;
-				if (capacity > get_capacity(disk)) {
-					set_capacity(disk, capacity);
-					check_disk_size_change(disk, bdev);
-					bdev->bd_invalidated = 0;
-				}
-				goto try_scan;
+				/* free state and restart */
+				kfree(state);
+				goto rescan;
 			} else {
 				/*
 				 * we can not ignore partitions of broken tables
-- 
1.6.4.2

