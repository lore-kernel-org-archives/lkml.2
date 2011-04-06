Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab1DFJTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:19:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52855 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab1DFJTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QdyMuZOlGlzy179e1plQ18PtuCJLHHdqFzykn8PnOC4liKAcYHPchJoLOKHBvPDI1L
         wqteDSokDO0gIRP24ZDOqiErKink5VqLh4t3Yt6ux581AxXGYjXdg1Fb778ykvmntJxV
         aIa3JGpgNqVy8Ar6M1e+WgtRN4KWyH0XGGeec=
Date: Wed, 6 Apr 2011 02:19:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, kay.sievers@vrfy.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: don't block events on excl write for non-optical
 devices
Message-ID: <20110406091940.GB32058@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disk event code automatically blocks events on excl write.  This is
primarily to avoid issuing polling commands while burning is in
progress.  This behavior doesn't fit other types of devices with
removeable media where polling commands don't have adverse side
effects and door locking usually doesn't exist.

This patch introduces new genhd flag which controls the auto-blocking
behavior and uses it to enable auto-blocking only on optical devices.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Kay Sievers <kay.sievers@vrfy.org>
---
Jens, can you please queue this for v2.6.39?  Thanks.

 drivers/block/paride/pcd.c |    1 +
 drivers/cdrom/viocd.c      |    3 ++-
 drivers/ide/ide-cd.c       |    2 +-
 drivers/scsi/sr.c          |    2 +-
 fs/block_dev.c             |   17 ++++++++++-------
 include/linux/genhd.h      |    1 +
 6 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 2f2ccf6..a0aabd9 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -320,6 +320,7 @@ static void pcd_init_units(void)
 		disk->first_minor = unit;
 		strcpy(disk->disk_name, cd->name);	/* umm... */
 		disk->fops = &pcd_bdops;
+		disk->flags = GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
 		disk->events = DISK_EVENT_MEDIA_CHANGE;
 	}
 }
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 4e874c5..ae15a4d 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -625,7 +625,8 @@ static int viocd_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	blk_queue_max_hw_sectors(q, 4096 / 512);
 	gendisk->queue = q;
 	gendisk->fops = &viocd_fops;
-	gendisk->flags = GENHD_FL_CD|GENHD_FL_REMOVABLE;
+	gendisk->flags = GENHD_FL_CD | GENHD_FL_REMOVABLE |
+			 GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
 	gendisk->events = DISK_EVENT_MEDIA_CHANGE;
 	set_capacity(gendisk, 0);
 	gendisk->private_data = d;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index fd1e117..6e5123b 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1781,7 +1781,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 
 	ide_cd_read_toc(drive, &sense);
 	g->fops = &idecd_ops;
-	g->flags |= GENHD_FL_REMOVABLE;
+	g->flags |= GENHD_FL_REMOVABLE | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
 	g->events = DISK_EVENT_MEDIA_CHANGE;
 	add_disk(g);
 	return 0;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index aefadc6..464ee7b 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -636,7 +636,7 @@ static int sr_probe(struct device *dev)
 	disk->first_minor = minor;
 	sprintf(disk->disk_name, "sr%d", minor);
 	disk->fops = &sr_bdops;
-	disk->flags = GENHD_FL_CD;
+	disk->flags = GENHD_FL_CD | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
 	disk->events = DISK_EVENT_MEDIA_CHANGE | DISK_EVENT_EJECT_REQUEST;
 
 	blk_queue_rq_timeout(sdev->request_queue, SR_TIMEOUT);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index c1511c6..b55a145 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1228,6 +1228,8 @@ int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
 	res = __blkdev_get(bdev, mode, 0);
 
 	if (whole) {
+		struct gendisk *disk = whole->bd_disk;
+
 		/* finish claiming */
 		mutex_lock(&bdev->bd_mutex);
 		spin_lock(&bdev_lock);
@@ -1254,15 +1256,16 @@ int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
 		spin_unlock(&bdev_lock);
 
 		/*
-		 * Block event polling for write claims.  Any write
-		 * holder makes the write_holder state stick until all
-		 * are released.  This is good enough and tracking
-		 * individual writeable reference is too fragile given
-		 * the way @mode is used in blkdev_get/put().
+		 * Block event polling for write claims if requested.  Any
+		 * write holder makes the write_holder state stick until
+		 * all are released.  This is good enough and tracking
+		 * individual writeable reference is too fragile given the
+		 * way @mode is used in blkdev_get/put().
 		 */
-		if (!res && (mode & FMODE_WRITE) && !bdev->bd_write_holder) {
+		if ((disk->flags & GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE) &&
+		    !res && (mode & FMODE_WRITE) && !bdev->bd_write_holder) {
 			bdev->bd_write_holder = true;
-			disk_block_events(bdev->bd_disk);
+			disk_block_events(disk);
 		}
 
 		mutex_unlock(&bdev->bd_mutex);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index d764a42..300d758 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -127,6 +127,7 @@ struct hd_struct {
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
 #define GENHD_FL_EXT_DEVT			64 /* allow extended devt */
 #define GENHD_FL_NATIVE_CAPACITY		128
+#define GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE	256
 
 enum {
 	DISK_EVENT_MEDIA_CHANGE			= 1 << 0, /* media changed */
