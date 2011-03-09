Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab1CIJOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:14:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49380 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab1CIJN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dzji7zHhtDocyTfVQ5f2LkZsd8Dv4qPAIk1/lIqPMKTTm1OM39fUwCL5Ykgk0ubSPH
         FVasiQWJmfkrt9z30Bm0K6Ycrmvavjk7HL2aHnQDj25upyS7PnogIiHQ/GnQzJ3g5EoA
         Ymmy3+xIPucAwdanYBgrb8KKvbamiFIPWIDTk=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/16] dac960: Convert to bdops->check_events()
Date: Wed,  9 Mar 2011 10:13:28 +0100
Message-Id: <1299662016-7721-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from ->media_changed() to ->check_events().

DAC960 media change notification seems to be one way (once set, never
cleared) and will generate spurious events when polled once the
condition triggers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/block/DAC960.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 1f286ab..7988210 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -140,13 +140,14 @@ static int DAC960_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static int DAC960_media_changed(struct gendisk *disk)
+static unsigned int DAC960_check_events(struct gendisk *disk,
+					unsigned int clearing)
 {
 	DAC960_Controller_T *p = disk->queue->queuedata;
 	int drive_nr = (long)disk->private_data;
 
 	if (!p->LogicalDriveInitiallyAccessible[drive_nr])
-		return 1;
+		return DISK_EVENT_MEDIA_CHANGE;
 	return 0;
 }
 
@@ -163,7 +164,7 @@ static const struct block_device_operations DAC960_BlockDeviceOperations = {
 	.owner			= THIS_MODULE,
 	.open			= DAC960_open,
 	.getgeo			= DAC960_getgeo,
-	.media_changed		= DAC960_media_changed,
+	.check_events		= DAC960_check_events,
 	.revalidate_disk	= DAC960_revalidate_disk,
 };
 
@@ -2546,6 +2547,7 @@ static bool DAC960_RegisterBlockDevice(DAC960_Controller_T *Controller)
 	disk->major = MajorNumber;
 	disk->first_minor = n << DAC960_MaxPartitionsBits;
 	disk->fops = &DAC960_BlockDeviceOperations;
+	disk->events = DISK_EVENT_MEDIA_CHANGE;
    }
   /*
     Indicate the Block Device Registration completed successfully,
-- 
1.7.1

