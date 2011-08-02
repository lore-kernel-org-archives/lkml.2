Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1HBEjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 00:39:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:34948 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab1HBEiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 00:38:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,305,1309762800"; 
   d="scan'208";a="33165479"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/11] VFS: Cache request_queue in struct block_device
Date: Mon,  1 Aug 2011 21:38:12 -0700
Message-Id: <1312259893-4548-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This makes it possible to get from the inode to the request_queue
with one less cache miss. Used in followon optimization.

The livetime of the pointer is the same as the gendisk.

This assumes that the queue will always stay the same in the
gendisk while it's visible to block_devices. I think that's safe correct?

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/block_dev.c     |    3 +++
 include/linux/fs.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index f55aad4..5e07536 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1110,6 +1110,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
+		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
 		if (!partno) {
 			struct backing_dev_info *bdi;
@@ -1130,6 +1131,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					disk_put_part(bdev->bd_part);
 					bdev->bd_part = NULL;
 					bdev->bd_disk = NULL;
+					bdev->bd_queue = NULL;
 					mutex_unlock(&bdev->bd_mutex);
 					disk_unblock_events(disk);
 					module_put(disk->fops->owner);
@@ -1203,6 +1205,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	disk_put_part(bdev->bd_part);
 	bdev->bd_disk = NULL;
 	bdev->bd_part = NULL;
+	bdev->bd_queue = NULL;
 	bdev_inode_switch_bdi(bdev->bd_inode, &default_backing_dev_info);
 	if (bdev != bdev->bd_contains)
 		__blkdev_put(bdev->bd_contains, mode, 1);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f23bcb7..ea5cb4d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -657,6 +657,7 @@ struct address_space {
 	 * must be enforced here for CRIS, to let the least significant bit
 	 * of struct page's "mapping" pointer be used for PAGE_MAPPING_ANON.
 	 */
+struct request_queue;
 
 struct block_device {
 	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
@@ -679,6 +680,7 @@ struct block_device {
 	unsigned		bd_part_count;
 	int			bd_invalidated;
 	struct gendisk *	bd_disk;
+	struct request_queue *  bd_queue;
 	struct list_head	bd_list;
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
-- 
1.7.4.4

