Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab1CIJTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:19:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47848 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab1CIJOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:14:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cyCPXTGAWmrjm3SsTDnziDQjZ0HHXX3Fd1Z4OqSt0utkhSn31/B+mQtBNcpfCuWecp
         0fD4S6FzKX+9SK/pJYfLlX2rkpKT/YMDrp+jtyOTT4qoAPSUYctbDNgZpsSAVGPg8xIO
         /0r4pIq5fOtSs0oCbAYe/F8sWlshg+g0YAqAo=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: [PATCH 12/16] i2o_block: Convert to bdops->check_events()
Date: Wed,  9 Mar 2011 10:13:32 +0100
Message-Id: <1299662016-7721-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from ->media_changed() to ->check_events().

i2o_block buffers media changed state and clears it after reporting.
It will behave correctly with kernel event polling.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
---
 drivers/message/i2o/i2o_block.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index ae7cad1..f81c25d 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -695,20 +695,22 @@ static int i2o_block_ioctl(struct block_device *bdev, fmode_t mode,
 };
 
 /**
- *	i2o_block_media_changed - Have we seen a media change?
+ *	i2o_block_check_events - Have we seen a media change?
  *	@disk: gendisk which should be verified
+ *	@clearing: events being cleared
  *
  *	Verifies if the media has changed.
  *
  *	Returns 1 if the media was changed or 0 otherwise.
  */
-static int i2o_block_media_changed(struct gendisk *disk)
+static unsigned int i2o_block_check_events(struct gendisk *disk,
+					   unsigned int clearing)
 {
 	struct i2o_block_device *p = disk->private_data;
 
 	if (p->media_change_flag) {
 		p->media_change_flag = 0;
-		return 1;
+		return DISK_EVENT_MEDIA_CHANGE;
 	}
 	return 0;
 }
@@ -950,7 +952,7 @@ static const struct block_device_operations i2o_block_fops = {
 	.ioctl = i2o_block_ioctl,
 	.compat_ioctl = i2o_block_ioctl,
 	.getgeo = i2o_block_getgeo,
-	.media_changed = i2o_block_media_changed
+	.check_events = i2o_block_check_events,
 };
 
 /**
@@ -1002,6 +1004,7 @@ static struct i2o_block_device *i2o_block_device_alloc(void)
 	gd->major = I2O_MAJOR;
 	gd->queue = queue;
 	gd->fops = &i2o_block_fops;
+	gd->events = DISK_EVENT_MEDIA_CHANGE;
 	gd->private_data = dev;
 
 	dev->gd = gd;
-- 
1.7.1

