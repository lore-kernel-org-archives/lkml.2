Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab0GCVsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 17:48:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab0GCVrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 17:47:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/6] block: remove BKL from partition code
Date: Sat,  3 Jul 2010 23:47:19 +0200
Message-Id: <1278193640-24223-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278193640-24223-1-git-send-email-arnd@arndb.de>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/R9EHT5P71RgiqxlCj9TbxARAQ71amMKy9qdd
 Lz8pwkKWzSFZk9CgeqTSdBkFAkiKZWnwCSEQKYFct49wpZ24l1
 JWI+uKD+8A9/XOh8PTkGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see any reason why we need the BKL here.
The functions blkdev_get, blkdev_put, blkpg_ioctl
and blkdev_reread_part are the only remaining users
of the big kernel lock in the block layer, and they
all access the same fields of the bdev and gendisk
structures, yet they always do so under the protection
of bdev->bd_mutex.

The open and close block_device_operations have all
been converted to grab the BKL themselves, where
necessary, so as far I can tell it should be safe
to remove.

If it is not, please explain why we still need it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/ioctl.c  |    4 ----
 fs/block_dev.c |   10 ++--------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 60f477c..09fd7f1 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -296,14 +296,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			bd_release(bdev);
 		return ret;
 	case BLKPG:
-		lock_kernel();
 		ret = blkpg_ioctl(bdev, (struct blkpg_ioctl_arg __user *) arg);
-		unlock_kernel();
 		break;
 	case BLKRRPART:
-		lock_kernel();
 		ret = blkdev_reread_part(bdev);
-		unlock_kernel();
 		break;
 	case BLKGETSIZE:
 		size = bdev->bd_inode->i_size;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 99d6af8..693c2bf 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1345,13 +1345,12 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		return ret;
 	}
 
-	lock_kernel();
  restart:
 
 	ret = -ENXIO;
 	disk = get_gendisk(bdev->bd_dev, &partno);
 	if (!disk)
-		goto out_unlock_kernel;
+		goto out;
 
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
@@ -1431,7 +1430,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	if (for_part)
 		bdev->bd_part_count++;
 	mutex_unlock(&bdev->bd_mutex);
-	unlock_kernel();
 	return 0;
 
  out_clear:
@@ -1444,9 +1442,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	bdev->bd_contains = NULL;
  out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
- out_unlock_kernel:
-	unlock_kernel();
-
+ out:
 	if (disk)
 		module_put(disk->fops->owner);
 	put_disk(disk);
@@ -1515,7 +1511,6 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 	struct block_device *victim = NULL;
 
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
-	lock_kernel();
 	if (for_part)
 		bdev->bd_part_count--;
 
@@ -1540,7 +1535,6 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;
 	}
-	unlock_kernel();
 	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
 	if (victim)
-- 
1.7.1

