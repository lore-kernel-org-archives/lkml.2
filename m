Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1CIJOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:14:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63889 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab1CIJOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:14:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=c5QWCxjo6e5i5pSJYq+B4olULiCPkXRv8MKNBz1celKfxSuf2+XebIIQOiYj61G2Xu
         xUKM+oO52yd5Bvp6dqfhF15AjGn/KmTDk7oqAmreE5CiUrz40aUkUIwodN2DL+pOajr2
         WRb4zHMjIJ9qbRxenxfa20vsMfPEnmWkej2zU=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>, Pete Zaitcev <zaitcev@redhat.com>
Subject: [PATCH 10/16] ub: Convert to bdops->check_events()
Date: Wed,  9 Mar 2011 10:13:30 +0100
Message-Id: <1299662016-7721-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from ->media_changed() to ->check_events().

ub buffers media changed state and clears it on revalidation.  It will
behave correctly with kernel event polling.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>
---
 drivers/block/ub.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 9ae3bb7..68b9430 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -1788,7 +1788,8 @@ static int ub_bd_revalidate(struct gendisk *disk)
  *
  * The return code is bool!
  */
-static int ub_bd_media_changed(struct gendisk *disk)
+static unsigned int ub_bd_check_events(struct gendisk *disk,
+				       unsigned int clearing)
 {
 	struct ub_lun *lun = disk->private_data;
 
@@ -1806,10 +1807,10 @@ static int ub_bd_media_changed(struct gendisk *disk)
 	 */
 	if (ub_sync_tur(lun->udev, lun) != 0) {
 		lun->changed = 1;
-		return 1;
+		return DISK_EVENT_MEDIA_CHANGE;
 	}
 
-	return lun->changed;
+	return lun->changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
 static const struct block_device_operations ub_bd_fops = {
@@ -1817,7 +1818,7 @@ static const struct block_device_operations ub_bd_fops = {
 	.open		= ub_bd_unlocked_open,
 	.release	= ub_bd_release,
 	.ioctl		= ub_bd_ioctl,
-	.media_changed	= ub_bd_media_changed,
+	.check_events	= ub_bd_check_events,
 	.revalidate_disk = ub_bd_revalidate,
 };
 
@@ -2333,6 +2334,7 @@ static int ub_probe_lun(struct ub_dev *sc, int lnum)
 	disk->major = UB_MAJOR;
 	disk->first_minor = lun->id * UB_PARTS_PER_LUN;
 	disk->fops = &ub_bd_fops;
+	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	disk->private_data = lun;
 	disk->driverfs_dev = &sc->intf->dev;
 
-- 
1.7.1

