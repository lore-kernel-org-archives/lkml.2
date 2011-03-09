Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab1CIJRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:17:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab1CIJRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:17:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Xu8iZKvkzjPfkr0IcWTHCi8/PqvwB7nxkaa+PpbTPP6KX+KWVUsIKe/VriZoUiScZ8
         TrkYPrsLFqehMBVC5i2JgHbCW47tVV3Ag8SMcAzmbzoVT117fqU5uiQ4bSPxFqH9AnUQ
         na6rI1Tb7WW9vBfsRZCmlQ8d/aYFh7s2Uzz/0=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>, Peter Osterlund <petero2@telia.com>
Subject: [PATCH 15/16] pktcdvd: Convert to bdops->check_events()
Date: Wed,  9 Mar 2011 10:13:35 +0100
Message-Id: <1299662016-7721-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from ->media_changed() to ->check_events().

pktcdvd needs to forward all event related operations to the
underlying device.  Forward ->check_events() instead of
->media_changed() and inherit disk->[async_]events.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Peter Osterlund <petero2@telia.com>
---
 drivers/block/pktcdvd.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 77d70ee..a077db2 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2796,7 +2796,8 @@ static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	return ret;
 }
 
-static int pkt_media_changed(struct gendisk *disk)
+static unsigned int pkt_check_events(struct gendisk *disk,
+				     unsigned int clearing)
 {
 	struct pktcdvd_device *pd = disk->private_data;
 	struct gendisk *attached_disk;
@@ -2806,9 +2807,9 @@ static int pkt_media_changed(struct gendisk *disk)
 	if (!pd->bdev)
 		return 0;
 	attached_disk = pd->bdev->bd_disk;
-	if (!attached_disk)
+	if (!attached_disk || !attached_disk->fops->check_events)
 		return 0;
-	return attached_disk->fops->media_changed(attached_disk);
+	return attached_disk->fops->check_events(attached_disk, clearing);
 }
 
 static const struct block_device_operations pktcdvd_ops = {
@@ -2816,7 +2817,7 @@ static const struct block_device_operations pktcdvd_ops = {
 	.open =			pkt_open,
 	.release =		pkt_close,
 	.ioctl =		pkt_ioctl,
-	.media_changed =	pkt_media_changed,
+	.check_events =		pkt_check_events,
 };
 
 static char *pktcdvd_devnode(struct gendisk *gd, mode_t *mode)
@@ -2889,6 +2890,10 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 	if (ret)
 		goto out_new_dev;
 
+	/* inherit events of the host device */
+	disk->events = pd->bdev->bd_disk->events;
+	disk->async_events = pd->bdev->bd_disk->async_events;
+
 	add_disk(disk);
 
 	pkt_sysfs_dev_new(pd);
-- 
1.7.1

