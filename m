Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab2JSD00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:26:26 -0400
Received: from condef007-v.nifty.com ([210.131.4.244]:34327 "EHLO
	condef007-v.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825Ab2JSD0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:26:23 -0400
X-Nifty-SrcIP: [61.204.25.121]
From: MITSUNARI Shigeo <herumi@nifty.com>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, MITSUNARI Shigeo <herumi@nifty.com>
Subject: [PATCH 2/2] block: fs: move 'bdev->bd_invalidated = 0' into check_disk_size_change() instead of putting the code every time after check_disk_size_change().
Date: Fri, 19 Oct 2012 12:16:42 +0900
Message-Id: <1350616602-6892-3-git-send-email-herumi@nifty.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350616602-6892-1-git-send-email-herumi@nifty.com>
References: <1350616602-6892-1-git-send-email-herumi@nifty.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following code appeares in invalidate_partitions(), rescan_partitions() and revalidate_disk().

>check_disk_size_change(disk, bdev);
>bdev->bd_invalidted = 0;

check_disk_size_change() is called from only those three functions.
so how about setting bdev->bd_invalidated = 0 in check_disk_size_change()?

Signed-off-by: MITSUNARI Shigeo <herumi@nifty.com>
---
 block/partition-generic.c |    2 --
 fs/block_dev.c            |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index f1d1451..6a65169 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -429,7 +429,6 @@ rescan:
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
 	check_disk_size_change(disk, bdev);
-	bdev->bd_invalidated = 0;
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
 	if (IS_ERR(state)) {
@@ -542,7 +541,6 @@ int invalidate_partitions(struct gendisk *disk, struct block_device *bdev)
 
 	set_capacity(disk, 0);
 	check_disk_size_change(disk, bdev);
-	bdev->bd_invalidated = 0;
 	/* tell userspace that the media / partition table may have changed */
 	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2577cf4..ef0189b 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1022,6 +1022,7 @@ void check_disk_size_change(struct gendisk *disk, struct block_device *bdev)
 		i_size_write(bdev->bd_inode, disk_size);
 		flush_disk(bdev, false);
 	}
+	bdev->bd_invalidated = 0;
 }
 EXPORT_SYMBOL(check_disk_size_change);
 
@@ -1047,7 +1048,6 @@ int revalidate_disk(struct gendisk *disk)
 
 	mutex_lock(&bdev->bd_mutex);
 	check_disk_size_change(disk, bdev);
-	bdev->bd_invalidated = 0;
 	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
 	return ret;
-- 
1.7.9.5

