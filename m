Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1H2XZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:25:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:45603 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab1H2XXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:23:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43424143"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andi Kleen <ak@linux.intel.com>,
        axboe@kernel.dk
Subject: [PATCH 10/11] VFS: Cache request_queue in struct block_device
Date: Mon, 29 Aug 2011 16:23:21 -0700
Message-Id: <1314660202-661-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314660202-661-1-git-send-email-andi@firstfloor.org>
References: <1314660202-661-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This makes it possible to get from the inode to the request_queue
with one less cache miss. Used in followon optimization.

The livetime of the pointer is the same as the gendisk.

This assumes that the queue will always stay the same in the
gendisk while it's visible to block_devices. I think that's safe correct?

Cc: axboe@kernel.dk
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/block_dev.c     |    3 +++
 include/linux/fs.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index ff77262..f9899d5 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1115,6 +1115,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
+		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
 		if (!partno) {
 			struct backing_dev_info *bdi;
@@ -1135,6 +1136,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					disk_put_part(bdev->bd_part);
 					bdev->bd_part = NULL;
 					bdev->bd_disk = NULL;
+					bdev->bd_queue = NULL;
 					mutex_unlock(&bdev->bd_mutex);
 					disk_unblock_events(disk);
 					module_put(disk->fops->owner);
@@ -1208,6 +1210,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	disk_put_part(bdev->bd_part);
 	bdev->bd_disk = NULL;
 	bdev->bd_part = NULL;
+	bdev->bd_queue = NULL;
 	bdev_inode_switch_bdi(bdev->bd_inode, &default_backing_dev_info);
 	if (bdev != bdev->bd_contains)
 		__blkdev_put(bdev->bd_contains, mode, 1);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 178cdb4..7d8c1f9 100644
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

