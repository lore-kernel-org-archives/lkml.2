Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab1DFMWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:22:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58642 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab1DFMWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:22:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=elcvYxxENvBJGYNMQiM98Dr4r8fZM4E0zkAYlwzeTUXZsl0HjdIcp3w7UWYIL73ELV
         y3OheJ9klFarembOgCoifV3TbIbo3QizS92weW1cbYgadgp4VKyHQIcAEPGs58nGPpWs
         CYzE3HPqJsObjh08E4CofdUDj5HlngWrHsVgw=
Date: Wed, 6 Apr 2011 05:22:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] block: rescan partitions on invalidated devices on
 -ENOMEDIA too
Message-ID: <20110406122244.GD4142@mtj.dyndns.org>
References: <20110406121920.GC4142@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406121920.GC4142@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Zeuthen <zeuthen@gmail.com>
Reported-by: Martin Pitt <martin.pitt@ubuntu.com>
Reported-by: Kay Sievers <kay.sievers@vrfy.org>
Tested-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 fs/block_dev.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c1511c6..a926ad4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1102,6 +1102,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			if (!bdev->bd_part)
 				goto out_clear;
 
+			ret = 0;
 			if (disk->fops->open) {
 				ret = disk->fops->open(bdev, mode);
 				if (ret == -ERESTARTSYS) {
@@ -1118,9 +1119,18 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					put_disk(disk);
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
@@ -1128,8 +1138,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					bdi = &default_backing_dev_info;
 				bdev_inode_switch_bdi(bdev->bd_inode, bdi);
 			}
-			if (bdev->bd_invalidated)
-				rescan_partitions(disk, bdev);
 		} else {
 			struct block_device *whole;
 			whole = bdget_disk(disk, 0);
@@ -1153,13 +1161,14 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		}
 	} else {
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
 		/* only one opener holds refs to the module and disk */
 		module_put(disk->fops->owner);
