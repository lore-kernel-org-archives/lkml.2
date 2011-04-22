Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1DVVBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:01:41 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60336
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756407Ab1DVVBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:01:20 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 08/18] Staging: hv:  Get rid of the forward declaration for blkvsc_release()
Date: Fri, 22 Apr 2011 14:13:29 -0700
Message-Id: <1303506819-1913-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303506819-1913-1-git-send-email-kys@microsoft.com>
References: <1303506780-1872-1-git-send-email-kys@microsoft.com>
 <1303506819-1913-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration for blkvsc_release() by moving the code
around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   45 +++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 15304d4..d863dbd 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -671,9 +671,30 @@ static void blkvsc_shutdown(struct device *device)
 	spin_unlock_irqrestore(&blkdev->lock, flags);
 }
 
+static int blkvsc_release(struct gendisk *disk, fmode_t mode)
+{
+	struct block_device_context *blkdev = disk->private_data;
+
+	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
+		   blkdev->gd->disk_name);
+
+	mutex_lock(&blkvsc_mutex);
+	spin_lock(&blkdev->lock);
+	if (blkdev->users == 1) {
+		spin_unlock(&blkdev->lock);
+		blkvsc_do_flush(blkdev);
+		spin_lock(&blkdev->lock);
+	}
+
+	blkdev->users--;
+
+	spin_unlock(&blkdev->lock);
+	mutex_unlock(&blkvsc_mutex);
+	return 0;
+}
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
-static int blkvsc_release(struct gendisk *disk, fmode_t mode);
 static int blkvsc_revalidate_disk(struct gendisk *gd);
 static void blkvsc_request(struct request_queue *queue);
 static void blkvsc_request_completion(struct hv_storvsc_request *request);
@@ -1483,28 +1504,6 @@ static void blkvsc_request(struct request_queue *queue)
 	}
 }
 
-static int blkvsc_release(struct gendisk *disk, fmode_t mode)
-{
-	struct block_device_context *blkdev = disk->private_data;
-
-	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
-		   blkdev->gd->disk_name);
-
-	mutex_lock(&blkvsc_mutex);
-	spin_lock(&blkdev->lock);
-	if (blkdev->users == 1) {
-		spin_unlock(&blkdev->lock);
-		blkvsc_do_flush(blkdev);
-		spin_lock(&blkdev->lock);
-	}
-
-	blkdev->users--;
-
-	spin_unlock(&blkdev->lock);
-	mutex_unlock(&blkvsc_mutex);
-	return 0;
-}
-
 static int blkvsc_revalidate_disk(struct gendisk *gd)
 {
 	struct block_device_context *blkdev = gd->private_data;
-- 
1.7.4.1

