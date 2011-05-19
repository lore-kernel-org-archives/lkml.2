Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138Ab1ESSJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:09:22 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58798 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934115Ab1ESSJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:17 -0400
X-Sasl-enc: ZewZMzQ5vnECOCxExZT4Gt03qx/h5N8S4OvjJAFBs6lT 1305828556
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:59 2011
Message-Id: <20110519180559.722522150@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: [57/71] block: rescan partitions on invalidated devices on -ENOMEDIA too
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 02e352287a40bd456eb78df705bf888bc3161d3f upstream.

__blkdev_get() doesn't rescan partitions if disk->fops->open() fails,
which leads to ghost partition devices lingering after medimum removal
is known to both the kernel and userland.  The behavior also creates a
subtle inconsistency where O_NONBLOCK open, which doesn't fail even if
there's no medium, clears the ghots partitions, which is exploited to
work around the problem from userland.

Fix it by updating __blkdev_get() to issue partition rescan after
-ENOMEDIA too.

This was reported in the following bz.

 https://bugzilla.kernel.org/show_bug.cgi?id=13029

Stable: 2.6.38

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Zeuthen <zeuthen@gmail.com>
Reported-by: Martin Pitt <martin.pitt@ubuntu.com>
Reported-by: Kay Sievers <kay.sievers@vrfy.org>
Tested-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/block_dev.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1099,6 +1099,7 @@ static int __blkdev_get(struct block_dev
 			if (!bdev->bd_part)
 				goto out_clear;
 
+			ret = 0;
 			if (disk->fops->open) {
 				ret = disk->fops->open(bdev, mode);
 				if (ret == -ERESTARTSYS) {
@@ -1114,9 +1115,18 @@ static int __blkdev_get(struct block_dev
 					mutex_unlock(&bdev->bd_mutex);
 					goto restart;
 				}
-				if (ret)
-					goto out_clear;
 			}
+			/*
+			 * If the device is invalidated, rescan partition
+			 * if open succeeded or failed with -ENOMEDIUM.
+			 * The latter is necessary to prevent ghost
+			 * partitions on a removed medium.
+			 */
+			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
+				rescan_partitions(disk, bdev);
+			if (ret)
+				goto out_clear;
+
 			if (!bdev->bd_openers) {
 				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
 				bdi = blk_get_backing_dev_info(bdev);
@@ -1124,8 +1134,6 @@ static int __blkdev_get(struct block_dev
 					bdi = &default_backing_dev_info;
 				bdev_inode_switch_bdi(bdev->bd_inode, bdi);
 			}
-			if (bdev->bd_invalidated)
-				rescan_partitions(disk, bdev);
 		} else {
 			struct block_device *whole;
 			whole = bdget_disk(disk, 0);
@@ -1152,13 +1160,14 @@ static int __blkdev_get(struct block_dev
 		put_disk(disk);
 		disk = NULL;
 		if (bdev->bd_contains == bdev) {
-			if (bdev->bd_disk->fops->open) {
+			ret = 0;
+			if (bdev->bd_disk->fops->open)
 				ret = bdev->bd_disk->fops->open(bdev, mode);
-				if (ret)
-					goto out_unlock_bdev;
-			}
-			if (bdev->bd_invalidated)
+			/* the same as first opener case, read comment there */
+			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
 				rescan_partitions(bdev->bd_disk, bdev);
+			if (ret)
+				goto out_unlock_bdev;
 		}
 	}
 	bdev->bd_openers++;


