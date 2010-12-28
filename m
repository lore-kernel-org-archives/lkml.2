Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0L1R3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:29:53 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:44628 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab0L1R3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:29:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=sVCCOxHviSJq43XnACzTN3prwgC8L/2R8p2y5/LfG5tNgUI/5hLG44VshsIRVPgqiR
         NS9HxSHv48IOqZoLqyWXavZubVYrg3awjs3JFYXaUn6a8/NJ8vscnEBKfdbptUgbSuyd
         cUc+10XnVQvH2qCeCEHGO2PIGUeQIwgiU+yLY=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/16] staging: convert to bdops->check_events()
Date: Tue, 28 Dec 2010 18:29:12 +0100
Message-Id: <1293557352-10592-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293557352-10592-1-git-send-email-tj@kernel.org>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert two staging drivers - blkvsc_drv and cyasblkdev_block - from
->media_changed() to ->check_events().  The former always indicated
media changed while the latter always indicated media not changed.
Not sure what the drivers are trying to achieve but keep the original
behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/hv/blkvsc_drv.c                    |   11 +++++++----
 .../westbridge/astoria/block/cyasblkdev_block.c    |   11 +++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 3f81ca5..9944385 100644
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
 	sprintf(blkdev->gd->disk_name, "hd%c", 'a' + devnum);
 
@@ -1346,10 +1348,11 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
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

