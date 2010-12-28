Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0L1Rao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:30:44 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:44628 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0L1R3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:29:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=uRbkSZVetQQbU4lLkRnwNUT7yyJUD4dh7wXOcR8zGsNia+JmFIyYZzyvXAGjLv2pgJ
         8trc1WXyDcqGCtK5KhSoRkegPIguDfzi9oWQwjHQQ9IucFN+jqfterMEoj0xs12pFUf0
         nrbtUMatLj4NXvJyoqgW5mjwDwHbdUE0jY5fY=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: [PATCH 12/16] i2o_block: convert to bdops->check_events()
Date: Tue, 28 Dec 2010 18:29:08 +0100
Message-Id: <1293557352-10592-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293557352-10592-1-git-send-email-tj@kernel.org>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
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
index f87a9d4..729d3b6 100644
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

