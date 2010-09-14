Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0INX1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:27:31 -0400
Received: from verein.lst.de ([213.95.11.210]:47409 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab0INX1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:27:31 -0400
Date: Wed, 15 Sep 2010 01:27:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: rusty@rustcorp.com.au
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: [PATCH] virtio_blk: remove BKL leftovers
Message-ID: <20100914232723.GA14175@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the BKL usage added in "block: push down BKL into .locked_ioctl".
Virtio-blk doesn't use the BKL for anything, and doesn't implement any
ioctl command by itself, but only uses the generic scsi_cmd_ioctl
which is fine without the BKL.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2010-09-09 18:13:25.171253781 -0300
+++ linux-2.6/drivers/block/virtio_blk.c	2010-09-09 18:14:48.154266565 -0300
@@ -2,7 +2,6 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
-#include <linux/smp_lock.h>
 #include <linux/hdreg.h>
 #include <linux/virtio.h>
 #include <linux/virtio_blk.h>
@@ -218,8 +217,8 @@ static int virtblk_get_id(struct gendisk
 	return blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
 }
 
-static int virtblk_locked_ioctl(struct block_device *bdev, fmode_t mode,
-			 unsigned cmd, unsigned long data)
+static int virtblk_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long data)
 {
 	struct gendisk *disk = bdev->bd_disk;
 	struct virtio_blk *vblk = disk->private_data;
@@ -234,18 +233,6 @@ static int virtblk_locked_ioctl(struct b
 			      (void __user *)data);
 }
 
-static int virtblk_ioctl(struct block_device *bdev, fmode_t mode,
-			     unsigned int cmd, unsigned long param)
-{
-	int ret;
-
-	lock_kernel();
-	ret = virtblk_locked_ioctl(bdev, mode, cmd, param);
-	unlock_kernel();
-
-	return ret;
-}
-
 /* We provide getgeo only to please some old bootloader/partitioning tools */
 static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
 {
