Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab1DVVBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:01:39 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60359
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756413Ab1DVVBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:01:21 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 07/18] Staging: hv: Get rid of the forward declaration of blkvsc_shutdown()
Date: Fri, 22 Apr 2011 14:13:28 -0700
Message-Id: <1303506819-1913-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303506819-1913-1-git-send-email-kys@microsoft.com>
References: <1303506780-1872-1-git-send-email-kys@microsoft.com>
 <1303506819-1913-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of blkvsc_shutdown() by moving the
code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   70 +++++++++++++++++++--------------------
 1 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 0669b84..15304d4 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -637,10 +637,42 @@ static int blkvsc_remove(struct device *device)
 	return ret;
 }
 
+static void blkvsc_shutdown(struct device *device)
+{
+	struct block_device_context *blkdev = dev_get_drvdata(device);
+	unsigned long flags;
+
+	if (!blkdev)
+		return;
+
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_shutdown - users %d disk %s\n",
+		   blkdev->users, blkdev->gd->disk_name);
+
+	spin_lock_irqsave(&blkdev->lock, flags);
+
+	blkdev->shutting_down = 1;
+
+	blk_stop_queue(blkdev->gd->queue);
+
+	spin_unlock_irqrestore(&blkdev->lock, flags);
+
+	while (blkdev->num_outstanding_reqs) {
+		DPRINT_INFO(STORVSC, "waiting for %d requests to complete...",
+			    blkdev->num_outstanding_reqs);
+		udelay(100);
+	}
+
+	blkvsc_do_flush(blkdev);
+
+	spin_lock_irqsave(&blkdev->lock, flags);
+
+	blkvsc_cancel_pending_reqs(blkdev);
+
+	spin_unlock_irqrestore(&blkdev->lock, flags);
+}
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
-static void blkvsc_shutdown(struct device *device);
-
 static int blkvsc_release(struct gendisk *disk, fmode_t mode);
 static int blkvsc_revalidate_disk(struct gendisk *gd);
 static void blkvsc_request(struct request_queue *queue);
@@ -904,40 +936,6 @@ Cleanup:
 	return ret;
 }
 
-static void blkvsc_shutdown(struct device *device)
-{
-	struct block_device_context *blkdev = dev_get_drvdata(device);
-	unsigned long flags;
-
-	if (!blkdev)
-		return;
-
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_shutdown - users %d disk %s\n",
-		   blkdev->users, blkdev->gd->disk_name);
-
-	spin_lock_irqsave(&blkdev->lock, flags);
-
-	blkdev->shutting_down = 1;
-
-	blk_stop_queue(blkdev->gd->queue);
-
-	spin_unlock_irqrestore(&blkdev->lock, flags);
-
-	while (blkdev->num_outstanding_reqs) {
-		DPRINT_INFO(STORVSC, "waiting for %d requests to complete...",
-			    blkdev->num_outstanding_reqs);
-		udelay(100);
-	}
-
-	blkvsc_do_flush(blkdev);
-
-	spin_lock_irqsave(&blkdev->lock, flags);
-
-	blkvsc_cancel_pending_reqs(blkdev);
-
-	spin_unlock_irqrestore(&blkdev->lock, flags);
-}
-
 /* Do a scsi INQUIRY cmd here to get the device type (ie disk or dvd) */
 static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 {
-- 
1.7.4.1

