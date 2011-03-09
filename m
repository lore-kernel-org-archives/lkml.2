Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab1CIJPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:15:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42814 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab1CIJOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:14:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=tg95JbM1U7vXhW9h6KjTMMBFeTe5vG4Qw4gmMnDub/2fzqZMtMpGGNtNJskbOROXqK
         kALSTZOo5Lbu7cmeUi9os5FCLV42GUP713KkYLNvOt363Jusclgm+QCbjNp95N2FOOzz
         JeJLvxOgx/bOkcNyrQ7qDXo/AzCMUXaE3Wh1o=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>, Laurent Vivier <laurent@lvivier.info>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 09/16] swim[3]: Convert to bdops->check_events()
Date: Wed,  9 Mar 2011 10:13:29 +0100
Message-Id: <1299662016-7721-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from ->media_changed() to ->check_events().

Both swim and swim3 buffer media changed state and clear it on
revalidation.  They will behave correctly with kernel event polling.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Laurent Vivier <laurent@lvivier.info>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/block/swim.c  |    8 +++++---
 drivers/block/swim3.c |   11 +++++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 75333d0..24a482f 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -741,11 +741,12 @@ static int floppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static int floppy_check_change(struct gendisk *disk)
+static unsigned int floppy_check_events(struct gendisk *disk,
+					unsigned int clearing)
 {
 	struct floppy_state *fs = disk->private_data;
 
-	return fs->ejected;
+	return fs->ejected ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
 static int floppy_revalidate(struct gendisk *disk)
@@ -772,7 +773,7 @@ static const struct block_device_operations floppy_fops = {
 	.release	 = floppy_release,
 	.ioctl		 = floppy_ioctl,
 	.getgeo		 = floppy_getgeo,
-	.media_changed	 = floppy_check_change,
+	.check_events	 = floppy_check_events,
 	.revalidate_disk = floppy_revalidate,
 };
 
@@ -857,6 +858,7 @@ static int __devinit swim_floppy_init(struct swim_priv *swd)
 		swd->unit[drive].disk->first_minor = drive;
 		sprintf(swd->unit[drive].disk->disk_name, "fd%d", drive);
 		swd->unit[drive].disk->fops = &floppy_fops;
+		swd->unit[drive].disk->events = DISK_EVENT_MEDIA_CHANGE;
 		swd->unit[drive].disk->private_data = &swd->unit[drive];
 		swd->unit[drive].disk->queue = swd->queue;
 		set_capacity(swd->unit[drive].disk, 2880);
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index bf3a5b8..4c10f56 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -250,7 +250,8 @@ static int floppy_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long param);
 static int floppy_open(struct block_device *bdev, fmode_t mode);
 static int floppy_release(struct gendisk *disk, fmode_t mode);
-static int floppy_check_change(struct gendisk *disk);
+static unsigned int floppy_check_events(struct gendisk *disk,
+					unsigned int clearing);
 static int floppy_revalidate(struct gendisk *disk);
 
 static bool swim3_end_request(int err, unsigned int nr_bytes)
@@ -975,10 +976,11 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
-static int floppy_check_change(struct gendisk *disk)
+static unsigned int floppy_check_events(struct gendisk *disk,
+					unsigned int clearing)
 {
 	struct floppy_state *fs = disk->private_data;
-	return fs->ejected;
+	return fs->ejected ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
 static int floppy_revalidate(struct gendisk *disk)
@@ -1025,7 +1027,7 @@ static const struct block_device_operations floppy_fops = {
 	.open		= floppy_unlocked_open,
 	.release	= floppy_release,
 	.ioctl		= floppy_ioctl,
-	.media_changed	= floppy_check_change,
+	.check_events	= floppy_check_events,
 	.revalidate_disk= floppy_revalidate,
 };
 
@@ -1161,6 +1163,7 @@ static int __devinit swim3_attach(struct macio_dev *mdev, const struct of_device
 	disk->major = FLOPPY_MAJOR;
 	disk->first_minor = i;
 	disk->fops = &floppy_fops;
+	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	disk->private_data = &floppy_states[i];
 	disk->queue = swim3_queue;
 	disk->flags |= GENHD_FL_REMOVABLE;
-- 
1.7.1

