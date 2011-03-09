Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab1CIJO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:14:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42814 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab1CIJOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:14:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=H9bpnu0mxNyyPj+Qm9DUzb2Hr70DhgC6QsvJkuD2F4hq3tczdcOk7CxVtPjeoDbGBE
         /22CejucCRjdAtWqyAlVtHL+M9e4u5ee9w4H9c8I21B6Lln1JNT5AEuGXQuCA9fXUmj0
         HPr1TmInjPTv6Lb/ZKwMTgGNwISRxUpvVE4tw=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/16] floppy,{ami|ata}flop: Convert to bdops->check_events()
Date: Wed,  9 Mar 2011 10:13:25 +0100
Message-Id: <1299662016-7721-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the floppy drivers from ->media_changed() to ->check_events().
Both floppy and ataflop buffer media changed state bit and clear them
on revalidation and will behave correctly with kernel event polling.

I can't tell how amiflop clears its event and it's possible that it
may generate spurious events when polled.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/block/amiflop.c |    9 +++++----
 drivers/block/ataflop.c |   14 ++++++++------
 drivers/block/floppy.c  |   10 ++++++----
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 7888501..5e7d3fe 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1658,12 +1658,12 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 }
 
 /*
- * floppy-change is never called from an interrupt, so we can relax a bit
+ * check_events is never called from an interrupt, so we can relax a bit
  * here, sleep etc. Note that floppy-on tries to set current_DOR to point
  * to the desired drive, but it will probably not survive the sleep if
  * several floppies are used at the same time: thus the loop.
  */
-static int amiga_floppy_change(struct gendisk *disk)
+static unsigned amiga_check_events(struct gendisk *disk, unsigned int clearing)
 {
 	struct amiga_floppy_struct *p = disk->private_data;
 	int drive = p - unit;
@@ -1686,7 +1686,7 @@ static int amiga_floppy_change(struct gendisk *disk)
 		p->dirty = 0;
 		writepending = 0; /* if this was true before, too bad! */
 		writefromint = 0;
-		return 1;
+		return DISK_EVENT_MEDIA_CHANGE;
 	}
 	return 0;
 }
@@ -1697,7 +1697,7 @@ static const struct block_device_operations floppy_fops = {
 	.release	= floppy_release,
 	.ioctl		= fd_ioctl,
 	.getgeo		= fd_getgeo,
-	.media_changed	= amiga_floppy_change,
+	.check_events	= amiga_check_events,
 };
 
 static int __init fd_probe_drives(void)
@@ -1736,6 +1736,7 @@ static int __init fd_probe_drives(void)
 		disk->major = FLOPPY_MAJOR;
 		disk->first_minor = drive;
 		disk->fops = &floppy_fops;
+		disk->events = DISK_EVENT_MEDIA_CHANGE;
 		sprintf(disk->disk_name, "fd%d", drive);
 		disk->private_data = &unit[drive];
 		set_capacity(disk, 880*2);
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 605a67e..c871eae 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1324,23 +1324,24 @@ static void finish_fdc_done( int dummy )
  * due to unrecognised disk changes.
  */
 
-static int check_floppy_change(struct gendisk *disk)
+static unsigned int floppy_check_events(struct gendisk *disk,
+					unsigned int clearing)
 {
 	struct atari_floppy_struct *p = disk->private_data;
 	unsigned int drive = p - unit;
 	if (test_bit (drive, &fake_change)) {
 		/* simulated change (e.g. after formatting) */
-		return 1;
+		return DISK_EVENT_MEDIA_CHANGE;
 	}
 	if (test_bit (drive, &changed_floppies)) {
 		/* surely changed (the WP signal changed at least once) */
-		return 1;
+		return DISK_EVENT_MEDIA_CHANGE;
 	}
 	if (UD.wpstat) {
 		/* WP is on -> could be changed: to be sure, buffers should be
 		 * invalidated...
 		 */
-		return 1;
+		return DISK_EVENT_MEDIA_CHANGE;
 	}
 
 	return 0;
@@ -1570,7 +1571,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 		 * or the next access will revalidate - and clear UDT :-(
 		 */
 
-		if (check_floppy_change(disk))
+		if (floppy_check_events(disk, 0))
 		        floppy_revalidate(disk);
 
 		if (UD.flags & FTD_MSG)
@@ -1904,7 +1905,7 @@ static const struct block_device_operations floppy_fops = {
 	.open		= floppy_unlocked_open,
 	.release	= floppy_release,
 	.ioctl		= fd_ioctl,
-	.media_changed	= check_floppy_change,
+	.check_events	= floppy_check_events,
 	.revalidate_disk= floppy_revalidate,
 };
 
@@ -1963,6 +1964,7 @@ static int __init atari_floppy_init (void)
 		unit[i].disk->first_minor = i;
 		sprintf(unit[i].disk->disk_name, "fd%d", i);
 		unit[i].disk->fops = &floppy_fops;
+		unit[i].disk->events = DISK_EVENT_MEDIA_CHANGE;
 		unit[i].disk->private_data = &unit[i];
 		unit[i].disk->queue = blk_init_queue(do_fd_request,
 					&ataflop_lock);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 77fc76f..3851dbc 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3770,13 +3770,14 @@ out2:
 /*
  * Check if the disk has been changed or if a change has been faked.
  */
-static int check_floppy_change(struct gendisk *disk)
+static unsigned int floppy_check_events(struct gendisk *disk,
+					unsigned int clearing)
 {
 	int drive = (long)disk->private_data;
 
 	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 	    test_bit(FD_VERIFY_BIT, &UDRS->flags))
-		return 1;
+		return DISK_EVENT_MEDIA_CHANGE;
 
 	if (time_after(jiffies, UDRS->last_checked + UDP->checkfreq)) {
 		lock_fdc(drive, false);
@@ -3788,7 +3789,7 @@ static int check_floppy_change(struct gendisk *disk)
 	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
 	    test_bit(drive, &fake_change) ||
 	    drive_no_geom(drive))
-		return 1;
+		return DISK_EVENT_MEDIA_CHANGE;
 	return 0;
 }
 
@@ -3898,7 +3899,7 @@ static const struct block_device_operations floppy_fops = {
 	.release		= floppy_release,
 	.ioctl			= fd_ioctl,
 	.getgeo			= fd_getgeo,
-	.media_changed		= check_floppy_change,
+	.check_events		= floppy_check_events,
 	.revalidate_disk	= floppy_revalidate,
 };
 
@@ -4205,6 +4206,7 @@ static int __init floppy_init(void)
 		disks[dr]->major = FLOPPY_MAJOR;
 		disks[dr]->first_minor = TOMINOR(dr);
 		disks[dr]->fops = &floppy_fops;
+		disks[dr]->events = DISK_EVENT_MEDIA_CHANGE;
 		sprintf(disks[dr]->disk_name, "fd%d", dr);
 
 		init_timer(&motor_off_timer[dr]);
-- 
1.7.1

