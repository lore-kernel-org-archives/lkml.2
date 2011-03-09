Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab1CIJO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:14:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49380 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756908Ab1CIJOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:14:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dMCcJULfznL1jCZvOArIeBWBwCpErhka4eg82T4lGnl3P7L+3s8OBYRT5X8vrF5Tcw
         PTBQW0pThMUmGzzicsCwW79dgdaHU6vzcBXdmyLz+YaEtrbdbmTCZfTJEIZBsV+I3aFr
         lK7T4wCBxF8IqpLYprFGia+Kvwcvyk0gvz8/0=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 13/16] s390/tape_block: Convert to bdops->check_events()
Date: Wed,  9 Mar 2011 10:13:33 +0100
Message-Id: <1299662016-7721-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from ->media_changed() to ->check_events().

s390/tape_block buffers media changed state and clears it on
revalidation.  It will behave correctly with kernel event polling.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/s390/char/tape_block.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index 55d2d0f..ad84316 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -48,14 +48,14 @@
 static DEFINE_MUTEX(tape_block_mutex);
 static int tapeblock_open(struct block_device *, fmode_t);
 static int tapeblock_release(struct gendisk *, fmode_t);
-static int tapeblock_medium_changed(struct gendisk *);
+static unsigned int tapeblock_check_events(struct gendisk *, unsigned int);
 static int tapeblock_revalidate_disk(struct gendisk *);
 
 static const struct block_device_operations tapeblock_fops = {
 	.owner		 = THIS_MODULE,
 	.open		 = tapeblock_open,
 	.release	 = tapeblock_release,
-	.media_changed   = tapeblock_medium_changed,
+	.check_events	 = tapeblock_check_events,
 	.revalidate_disk = tapeblock_revalidate_disk,
 };
 
@@ -237,6 +237,7 @@ tapeblock_setup_device(struct tape_device * device)
 	disk->major = tapeblock_major;
 	disk->first_minor = device->first_minor;
 	disk->fops = &tapeblock_fops;
+	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	disk->private_data = tape_get_device(device);
 	disk->queue = blkdat->request_queue;
 	set_capacity(disk, 0);
@@ -340,8 +341,8 @@ tapeblock_revalidate_disk(struct gendisk *disk)
 	return 0;
 }
 
-static int
-tapeblock_medium_changed(struct gendisk *disk)
+static unsigned int
+tapeblock_check_events(struct gendisk *disk, unsigned int clearing)
 {
 	struct tape_device *device;
 
@@ -349,7 +350,7 @@ tapeblock_medium_changed(struct gendisk *disk)
 	DBF_LH(6, "tapeblock_medium_changed(%p) = %d\n",
 		device, device->blk_data.medium_changed);
 
-	return device->blk_data.medium_changed;
+	return device->blk_data.medium_changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
 /*
-- 
1.7.1

