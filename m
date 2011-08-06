Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab1HFAMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:12:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353Ab1HFAMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:12:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:15 2011
Message-Id: <20110806000415.821216533@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:04:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <jaxboe@fusionio.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [42/50] Revert "block: rescan partitions on invalidated devices on -ENOMEDIA
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
 too"

This reverts commit 6f31747bfeb8c74e6d0a10ecef0abe2a04c5a6cb (commit
02e352287a40bd456eb78df705bf888bc3161d3f upstream)

This should have only been commited on .38 and newer, not older kernels
like this one, sorry.

Cc: Tejun Heo <tj@kernel.org>
Cc: David Zeuthen <zeuthen@gmail.com>
Cc: Martin Pitt <martin.pitt@ubuntu.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/block_dev.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1211,7 +1211,6 @@ static int __blkdev_get(struct block_dev
 			if (!bdev->bd_part)
 				goto out_clear;
 
-			ret = 0;
 			if (disk->fops->open) {
 				ret = disk->fops->open(bdev, mode);
 				if (ret == -ERESTARTSYS) {
@@ -1227,18 +1226,9 @@ static int __blkdev_get(struct block_dev
 					mutex_unlock(&bdev->bd_mutex);
 					goto restart;
 				}
+				if (ret)
+					goto out_clear;
 			}
-			/*
-			 * If the device is invalidated, rescan partition
-			 * if open succeeded or failed with -ENOMEDIUM.
-			 * The latter is necessary to prevent ghost
-			 * partitions on a removed medium.
-			 */
-			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
-				rescan_partitions(disk, bdev);
-			if (ret)
-				goto out_clear;
-
 			if (!bdev->bd_openers) {
 				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
 				bdi = blk_get_backing_dev_info(bdev);
@@ -1246,6 +1236,8 @@ static int __blkdev_get(struct block_dev
 					bdi = &default_backing_dev_info;
 				bdev->bd_inode->i_data.backing_dev_info = bdi;
 			}
+			if (bdev->bd_invalidated)
+				rescan_partitions(disk, bdev);
 		} else {
 			struct block_device *whole;
 			whole = bdget_disk(disk, 0);
@@ -1272,14 +1264,13 @@ static int __blkdev_get(struct block_dev
 		put_disk(disk);
 		disk = NULL;
 		if (bdev->bd_contains == bdev) {
-			ret = 0;
-			if (bdev->bd_disk->fops->open)
+			if (bdev->bd_disk->fops->open) {
 				ret = bdev->bd_disk->fops->open(bdev, mode);
-			/* the same as first opener case, read comment there */
-			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
+				if (ret)
+					goto out_unlock_bdev;
+			}
+			if (bdev->bd_invalidated)
 				rescan_partitions(bdev->bd_disk, bdev);
-			if (ret)
-				goto out_unlock_bdev;
 		}
 	}
 	bdev->bd_openers++;


