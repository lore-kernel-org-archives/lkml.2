Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1DFVYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:24:04 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:60501
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756867Ab1DFVYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:24:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 03/22] Staging: hv: Get rid of the forward declaration of blkvsc_open()
Date: Wed,  6 Apr 2011 14:35:01 -0700
Message-Id: <1302125720-10808-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125720-10808-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
 <1302125720-10808-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of blkvsc_open() by moving the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   49 +++++++++++++++++++--------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 4452700..173abe3 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -106,6 +106,7 @@ struct block_device_context {
 	int users;
 };
 
+static DEFINE_MUTEX(blkvsc_mutex);
 
 static const char *g_blk_driver_name = "blkvsc";
 
@@ -251,13 +252,34 @@ static unsigned int blkvsc_check_events(struct gendisk *gd,
 }
 
 
+static int blkvsc_open(struct block_device *bdev, fmode_t mode)
+{
+	struct block_device_context *blkdev = bdev->bd_disk->private_data;
+
+	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
+		   blkdev->gd->disk_name);
+
+	mutex_lock(&blkvsc_mutex);
+	spin_lock(&blkdev->lock);
+
+	if (!blkdev->users && blkdev->device_type == DVD_TYPE) {
+		spin_unlock(&blkdev->lock);
+		check_disk_change(bdev);
+		spin_lock(&blkdev->lock);
+	}
+
+	blkdev->users++;
+
+	spin_unlock(&blkdev->lock);
+	mutex_unlock(&blkvsc_mutex);
+	return 0;
+}
+
 /* Static decl */
-static DEFINE_MUTEX(blkvsc_mutex);
 static int blkvsc_probe(struct device *dev);
 static int blkvsc_remove(struct device *device);
 static void blkvsc_shutdown(struct device *device);
 
-static int blkvsc_open(struct block_device *bdev,  fmode_t mode);
 static int blkvsc_release(struct gendisk *disk, fmode_t mode);
 static int blkvsc_revalidate_disk(struct gendisk *gd);
 static int blkvsc_getgeo(struct block_device *bd, struct hd_geometry *hg);
@@ -1368,29 +1390,6 @@ static void blkvsc_request(struct request_queue *queue)
 	}
 }
 
-static int blkvsc_open(struct block_device *bdev, fmode_t mode)
-{
-	struct block_device_context *blkdev = bdev->bd_disk->private_data;
-
-	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
-		   blkdev->gd->disk_name);
-
-	mutex_lock(&blkvsc_mutex);
-	spin_lock(&blkdev->lock);
-
-	if (!blkdev->users && blkdev->device_type == DVD_TYPE) {
-		spin_unlock(&blkdev->lock);
-		check_disk_change(bdev);
-		spin_lock(&blkdev->lock);
-	}
-
-	blkdev->users++;
-
-	spin_unlock(&blkdev->lock);
-	mutex_unlock(&blkvsc_mutex);
-	return 0;
-}
-
 static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 {
 	struct block_device_context *blkdev = disk->private_data;
-- 
1.7.4.1

