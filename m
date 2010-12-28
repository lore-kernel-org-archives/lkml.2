Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0L1R3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:29:32 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:44628 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0L1R31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:29:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=WhZ8YOn4P8ejDSqJ9LzwKpgxTVjlMWFbOcFr9nDOQAEIwTclBm2oRw5pryPk4zxKtx
         WSyP5R861G2rB4X6rT3XhJDok9mvx7KNTtEK6yG1g+lFC0DOubTpNzAMN+243nwqKH9X
         WNPZmEASzF3YWHIX7t+vl7OUzV53kBMIRFAfU=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        linux-ide@vger.kernel.org
Subject: [PATCH 04/16] ide: convert to bdops->check_events()
Date: Tue, 28 Dec 2010 18:29:00 +0100
Message-Id: <1293557352-10592-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293557352-10592-1-git-send-email-tj@kernel.org>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ->media_changed() to the new ->check_events() method.  The
conversion is mostly mechanical.  The only notable change is that
cdrom now doesn't generate any event if @slot_nr isn't CDSL_CURRENT.
It used to return -EINVAL which would be treated as media changed.  As
media changer isn't supported anyway, this doesn't make any
difference.

This makes ide emit the standard disk events and allows kernel event
polling.  Currently, only MEDIA_CHANGE event is implemented.  Adding
support for EJECT_REQUEST shouldn't be difficult; however, given that
ide driver is already deprecated, it probably is best to leave it
alone.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org
---
 drivers/ide/ide-cd.c       |   10 ++++++----
 drivers/ide/ide-cd.h       |    3 ++-
 drivers/ide/ide-cd_ioctl.c |    8 ++++----
 drivers/ide/ide-gd.c       |   14 ++++++++------
 4 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 0c73fe3..a2e2909 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1177,7 +1177,7 @@ static struct cdrom_device_ops ide_cdrom_dops = {
 	.open			= ide_cdrom_open_real,
 	.release		= ide_cdrom_release_real,
 	.drive_status		= ide_cdrom_drive_status,
-	.media_changed		= ide_cdrom_check_media_change_real,
+	.check_events		= ide_cdrom_check_events_real,
 	.tray_move		= ide_cdrom_tray_move,
 	.lock_door		= ide_cdrom_lock_door,
 	.select_speed		= ide_cdrom_select_speed,
@@ -1702,10 +1702,11 @@ static int idecd_ioctl(struct block_device *bdev, fmode_t mode,
 }
 
 
-static int idecd_media_changed(struct gendisk *disk)
+static unsigned int idecd_check_events(struct gendisk *disk,
+				       unsigned int clearing)
 {
 	struct cdrom_info *info = ide_drv_g(disk, cdrom_info);
-	return cdrom_media_changed(&info->devinfo);
+	return cdrom_check_events(&info->devinfo, clearing);
 }
 
 static int idecd_revalidate_disk(struct gendisk *disk)
@@ -1723,7 +1724,7 @@ static const struct block_device_operations idecd_ops = {
 	.open			= idecd_open,
 	.release		= idecd_release,
 	.ioctl			= idecd_ioctl,
-	.media_changed		= idecd_media_changed,
+	.check_events		= idecd_check_events,
 	.revalidate_disk	= idecd_revalidate_disk
 };
 
@@ -1790,6 +1791,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 	ide_cd_read_toc(drive, &sense);
 	g->fops = &idecd_ops;
 	g->flags |= GENHD_FL_REMOVABLE;
+	g->events = DISK_EVENT_MEDIA_CHANGE;
 	add_disk(g);
 	return 0;
 
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 93a3cf1..1efc936 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -111,7 +111,8 @@ int cdrom_check_status(ide_drive_t *, struct request_sense *);
 int ide_cdrom_open_real(struct cdrom_device_info *, int);
 void ide_cdrom_release_real(struct cdrom_device_info *);
 int ide_cdrom_drive_status(struct cdrom_device_info *, int);
-int ide_cdrom_check_media_change_real(struct cdrom_device_info *, int);
+unsigned int ide_cdrom_check_events_real(struct cdrom_device_info *,
+					 unsigned int clearing, int slot_nr);
 int ide_cdrom_tray_move(struct cdrom_device_info *, int);
 int ide_cdrom_lock_door(struct cdrom_device_info *, int);
 int ide_cdrom_select_speed(struct cdrom_device_info *, int);
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 766b3de..2a6bc50 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -79,8 +79,8 @@ int ide_cdrom_drive_status(struct cdrom_device_info *cdi, int slot_nr)
 	return CDS_DRIVE_NOT_READY;
 }
 
-int ide_cdrom_check_media_change_real(struct cdrom_device_info *cdi,
-				       int slot_nr)
+unsigned int ide_cdrom_check_events_real(struct cdrom_device_info *cdi,
+					 unsigned int clearing, int slot_nr)
 {
 	ide_drive_t *drive = cdi->handle;
 	int retval;
@@ -89,9 +89,9 @@ int ide_cdrom_check_media_change_real(struct cdrom_device_info *cdi,
 		(void) cdrom_check_status(drive, NULL);
 		retval = (drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED) ? 1 : 0;
 		drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
-		return retval;
+		return retval ? DISK_EVENT_MEDIA_CHANGE : 0;
 	} else {
-		return -EINVAL;
+		return 0;
 	}
 }
 
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 35c4b43..c4ffd48 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -285,11 +285,12 @@ static int ide_gd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static int ide_gd_media_changed(struct gendisk *disk)
+static unsigned int ide_gd_check_events(struct gendisk *disk,
+					unsigned int clearing)
 {
 	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
-	int ret;
+	bool ret;
 
 	/* do not scan partitions twice if this is a removable device */
 	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
@@ -297,10 +298,10 @@ static int ide_gd_media_changed(struct gendisk *disk)
 		return 0;
 	}
 
-	ret = !!(drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED);
+	ret = drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED;
 	drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
 
-	return ret;
+	return ret ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
 static void ide_gd_unlock_native_capacity(struct gendisk *disk)
@@ -318,7 +319,7 @@ static int ide_gd_revalidate_disk(struct gendisk *disk)
 	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
 
-	if (ide_gd_media_changed(disk))
+	if (ide_gd_check_events(disk, 0))
 		drive->disk_ops->get_capacity(drive);
 
 	set_capacity(disk, ide_gd_capacity(drive));
@@ -340,7 +341,7 @@ static const struct block_device_operations ide_gd_ops = {
 	.release		= ide_gd_release,
 	.ioctl			= ide_gd_ioctl,
 	.getgeo			= ide_gd_getgeo,
-	.media_changed		= ide_gd_media_changed,
+	.check_events		= ide_gd_check_events,
 	.unlock_native_capacity	= ide_gd_unlock_native_capacity,
 	.revalidate_disk	= ide_gd_revalidate_disk
 };
@@ -412,6 +413,7 @@ static int ide_gd_probe(ide_drive_t *drive)
 	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
 		g->flags = GENHD_FL_REMOVABLE;
 	g->fops = &ide_gd_ops;
+	g->events = DISK_EVENT_MEDIA_CHANGE;
 	add_disk(g);
 	return 0;
 
-- 
1.7.1

