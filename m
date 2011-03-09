Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab1CIJO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:14:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49380 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab1CIJNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:13:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=GTMfdbyY2cxArbJ9U13k1kIomSMJx2unRLn3v1WgER7wo94fS4h/iQskwLSUaXQkEi
         3ifQ00PagW+9wz85sC1BT0ny1OwxF+ltBaQzvogFJvXGWP9ixurTPowjXxz7w+ezmdFZ
         LhdEra+KQHxI2VA76/c7VUEJ4JD82lH5L2bXg=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/16] gdrom,viocd: Convert to bdops->check_events()
Date: Wed,  9 Mar 2011 10:13:26 +0100
Message-Id: <1299662016-7721-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert gdrom and viocd from ->media_changed() to ->check_events().

It's unclear how the conditions are cleared and it's possible that it
may generate spurious events when polled.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/cdrom/gdrom.c |   16 ++++++++++------
 drivers/cdrom/viocd.c |   17 ++++++++++-------
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 64a2146..b2b034f 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -395,10 +395,12 @@ static int gdrom_drivestatus(struct cdrom_device_info *cd_info, int ignore)
 	return CDS_NO_INFO;
 }
 
-static int gdrom_mediachanged(struct cdrom_device_info *cd_info, int ignore)
+static unsigned int gdrom_check_events(struct cdrom_device_info *cd_info,
+				       unsigned int clearing, int ignore)
 {
 	/* check the sense key */
-	return (__raw_readb(GDROM_ERROR_REG) & 0xF0) == 0x60;
+	return (__raw_readb(GDROM_ERROR_REG) & 0xF0) == 0x60 ?
+		DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
 /* reset the G1 bus */
@@ -483,7 +485,7 @@ static struct cdrom_device_ops gdrom_ops = {
 	.open			= gdrom_open,
 	.release		= gdrom_release,
 	.drive_status		= gdrom_drivestatus,
-	.media_changed		= gdrom_mediachanged,
+	.check_events		= gdrom_check_events,
 	.get_last_session	= gdrom_get_last_session,
 	.reset			= gdrom_hardreset,
 	.audio_ioctl		= gdrom_audio_ioctl,
@@ -509,9 +511,10 @@ static int gdrom_bdops_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
-static int gdrom_bdops_mediachanged(struct gendisk *disk)
+static unsigned int gdrom_bdops_check_events(struct gendisk *disk,
+					     unsigned int clearing)
 {
-	return cdrom_media_changed(gd.cd_info);
+	return cdrom_check_events(gd.cd_info, clearing);
 }
 
 static int gdrom_bdops_ioctl(struct block_device *bdev, fmode_t mode,
@@ -530,7 +533,7 @@ static const struct block_device_operations gdrom_bdops = {
 	.owner			= THIS_MODULE,
 	.open			= gdrom_bdops_open,
 	.release		= gdrom_bdops_release,
-	.media_changed		= gdrom_bdops_mediachanged,
+	.check_events		= gdrom_bdops_check_events,
 	.ioctl			= gdrom_bdops_ioctl,
 };
 
@@ -800,6 +803,7 @@ static int __devinit probe_gdrom(struct platform_device *devptr)
 		goto probe_fail_cdrom_register;
 	}
 	gd.disk->fops = &gdrom_bdops;
+	gd.disk->events = DISK_EVENT_MEDIA_CHANGE;
 	/* latch on to the interrupt */
 	err = gdrom_set_interrupt_handlers();
 	if (err)
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index be73a9b..4e874c5 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -186,10 +186,11 @@ static int viocd_blk_ioctl(struct block_device *bdev, fmode_t mode,
 	return ret;
 }
 
-static int viocd_blk_media_changed(struct gendisk *disk)
+static unsigned int viocd_blk_check_events(struct gendisk *disk,
+					   unsigned int clearing)
 {
 	struct disk_info *di = disk->private_data;
-	return cdrom_media_changed(&di->viocd_info);
+	return cdrom_check_events(&di->viocd_info, clearing);
 }
 
 static const struct block_device_operations viocd_fops = {
@@ -197,7 +198,7 @@ static const struct block_device_operations viocd_fops = {
 	.open =			viocd_blk_open,
 	.release =		viocd_blk_release,
 	.ioctl =		viocd_blk_ioctl,
-	.media_changed =	viocd_blk_media_changed,
+	.check_events =		viocd_blk_check_events,
 };
 
 static int viocd_open(struct cdrom_device_info *cdi, int purpose)
@@ -320,7 +321,8 @@ static void do_viocd_request(struct request_queue *q)
 	}
 }
 
-static int viocd_media_changed(struct cdrom_device_info *cdi, int disc_nr)
+static unsigned int viocd_check_events(struct cdrom_device_info *cdi,
+				       unsigned int clearing, int disc_nr)
 {
 	struct viocd_waitevent we;
 	HvLpEvent_Rc hvrc;
@@ -340,7 +342,7 @@ static int viocd_media_changed(struct cdrom_device_info *cdi, int disc_nr)
 	if (hvrc != 0) {
 		pr_warning("bad rc on HvCallEvent_signalLpEventFast %d\n",
 			   (int)hvrc);
-		return -EIO;
+		return 0;
 	}
 
 	wait_for_completion(&we.com);
@@ -354,7 +356,7 @@ static int viocd_media_changed(struct cdrom_device_info *cdi, int disc_nr)
 		return 0;
 	}
 
-	return we.changed;
+	return we.changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
 static int viocd_lock_door(struct cdrom_device_info *cdi, int locking)
@@ -550,7 +552,7 @@ static int viocd_audio_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
 static struct cdrom_device_ops viocd_dops = {
 	.open = viocd_open,
 	.release = viocd_release,
-	.media_changed = viocd_media_changed,
+	.check_events = viocd_check_events,
 	.lock_door = viocd_lock_door,
 	.generic_packet = viocd_packet,
 	.audio_ioctl = viocd_audio_ioctl,
@@ -624,6 +626,7 @@ static int viocd_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	gendisk->queue = q;
 	gendisk->fops = &viocd_fops;
 	gendisk->flags = GENHD_FL_CD|GENHD_FL_REMOVABLE;
+	gendisk->events = DISK_EVENT_MEDIA_CHANGE;
 	set_capacity(gendisk, 0);
 	gendisk->private_data = d;
 	d->viocd_disk = gendisk;
-- 
1.7.1

