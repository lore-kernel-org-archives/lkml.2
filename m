Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab1CIJPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:15:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65410 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086Ab1CIJPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:15:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=R3Pcv+hv7MEsjLD0Ztg69elBGR9GreYuvhb/ISPKGsdLN9ZkQt4hrQymWw/IGXBBfx
         OCBOPOKWMpaEe5UUdpwKBsZuLJ8vo0ntWttiGvSnR2J+lTk+7RHJzYYpACKGp6kmNyUR
         mXyKA8kBpD2zZ7FMcbIw6pyNZc4VyEBiomSQ0=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/16] staging: Convert to bdops->check_events()
Date: Wed,  9 Mar 2011 10:13:36 +0100
Message-Id: <1299662016-7721-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert two staging drivers - blkvsc_drv and cyasblkdev_block - from
->media_changed() to ->check_events().  The former always indicated
media changed while the latter always indicated media not changed.
Not sure what the drivers are trying to achieve but keep the original
behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/staging/hv/blkvsc_drv.c                    |   11 +++++++----
 .../westbridge/astoria/block/cyasblkdev_block.c    |   11 +++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 4fb8094..1ecd7e1 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -131,7 +131,8 @@ static void blkvsc_shutdown(struct device *device);
 
 static int blkvsc_open(struct block_device *bdev,  fmode_t mode);
 static int blkvsc_release(struct gendisk *disk, fmode_t mode);
-static int blkvsc_media_changed(struct gendisk *gd);
+static unsigned int blkvsc_check_events(struct gendisk *gd,
+					unsigned int clearing);
 static int blkvsc_revalidate_disk(struct gendisk *gd);
 static int blkvsc_getgeo(struct block_device *bd, struct hd_geometry *hg);
 static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
@@ -162,7 +163,7 @@ static const struct block_device_operations block_ops = {
 	.owner = THIS_MODULE,
 	.open = blkvsc_open,
 	.release = blkvsc_release,
-	.media_changed = blkvsc_media_changed,
+	.check_events = blkvsc_check_events,
 	.revalidate_disk = blkvsc_revalidate_disk,
 	.getgeo = blkvsc_getgeo,
 	.ioctl  = blkvsc_ioctl,
@@ -367,6 +368,7 @@ static int blkvsc_probe(struct device *device)
 	else
 		blkdev->gd->first_minor = 0;
 	blkdev->gd->fops = &block_ops;
+	blkdev->gd->events = DISK_EVENT_MEDIA_CHANGE;
 	blkdev->gd->private_data = blkdev;
 	blkdev->gd->driverfs_dev = &(blkdev->device_ctx->device);
 	sprintf(blkdev->gd->disk_name, "hd%c", 'a' + devnum);
@@ -1352,10 +1354,11 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
-static int blkvsc_media_changed(struct gendisk *gd)
+static unsigned int blkvsc_check_events(struct gendisk *gd,
+					unsigned int clearing)
 {
 	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
-	return 1;
+	return DISK_EVENT_MEDIA_CHANGE;
 }
 
 static int blkvsc_revalidate_disk(struct gendisk *gd)
diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
index e1851f0..842cd92 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
@@ -381,10 +381,10 @@ static int cyasblkdev_blk_ioctl(
 	return -ENOTTY;
 }
 
-/* Media_changed block_device opp
+/* check_events block_device opp
  * this one is called by kernel to confirm if the media really changed
  * as we indicated by issuing check_disk_change() call */
-int cyasblkdev_media_changed(struct gendisk *gd)
+unsigned int cyasblkdev_check_events(struct gendisk *gd, unsigned int clearing)
 {
 	struct cyasblkdev_blk_data *bd;
 
@@ -402,7 +402,7 @@ int cyasblkdev_media_changed(struct gendisk *gd)
 		#endif
 	}
 
-	/* return media change state "1" yes, 0 no */
+	/* return media change state - DISK_EVENT_MEDIA_CHANGE yes, 0 no */
 	return 0;
 }
 
@@ -432,7 +432,7 @@ static struct block_device_operations cyasblkdev_bdops = {
 	.ioctl			= cyasblkdev_blk_ioctl,
 	/* .getgeo		= cyasblkdev_blk_getgeo, */
 	/* added to support media removal( real and simulated) media */
-	.media_changed  = cyasblkdev_media_changed,
+	.check_events		= cyasblkdev_check_events,
 	/* added to support media removal( real and simulated) media */
 	.revalidate_disk = cyasblkdev_revalidate_disk,
 	.owner			= THIS_MODULE,
@@ -1090,6 +1090,7 @@ static int cyasblkdev_add_disks(int bus_num,
 		bd->user_disk_0->first_minor = devidx << CYASBLKDEV_SHIFT;
 		bd->user_disk_0->minors = 8;
 		bd->user_disk_0->fops = &cyasblkdev_bdops;
+		bd->user_disk_0->events = DISK_EVENT_MEDIA_CHANGE;
 		bd->user_disk_0->private_data = bd;
 		bd->user_disk_0->queue = bd->queue.queue;
 		bd->dbgprn_flags = DBGPRN_RD_RQ;
@@ -1190,6 +1191,7 @@ static int cyasblkdev_add_disks(int bus_num,
 		bd->user_disk_1->first_minor = (devidx + 1) << CYASBLKDEV_SHIFT;
 		bd->user_disk_1->minors = 8;
 		bd->user_disk_1->fops = &cyasblkdev_bdops;
+		bd->user_disk_0->events = DISK_EVENT_MEDIA_CHANGE;
 		bd->user_disk_1->private_data = bd;
 		bd->user_disk_1->queue = bd->queue.queue;
 		bd->dbgprn_flags = DBGPRN_RD_RQ;
@@ -1278,6 +1280,7 @@ static int cyasblkdev_add_disks(int bus_num,
 				(devidx + 2) << CYASBLKDEV_SHIFT;
 			bd->system_disk->minors = 8;
 			bd->system_disk->fops = &cyasblkdev_bdops;
+			bd->system_disk->events = DISK_EVENT_MEDIA_CHANGE;
 			bd->system_disk->private_data = bd;
 			bd->system_disk->queue = bd->queue.queue;
 			/* don't search for vfat
-- 
1.7.1

