Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab1FFWow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:44:52 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58018
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758167Ab1FFWe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 19/49] Staging: hv: blkvsc: Fix bugs in the module unload path
Date: Mon,  6 Jun 2011 15:49:43 -0700
Message-Id: <1307400613-13234-19-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bugs in the module unload path for the blkvsc driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   40 ++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index bcf562f..a44fc76 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -518,22 +518,18 @@ static int blkvsc_remove(struct hv_device *dev)
 
 	blkvsc_do_operation(blkdev, DO_FLUSH);
 
-	blk_cleanup_queue(blkdev->gd->queue);
+	if (blkdev->users == 0) {
+		del_gendisk(blkdev->gd);
+		put_disk(blkdev->gd);
+		blk_cleanup_queue(blkdev->gd->queue);
 
-	/*
-	 * Call to the vsc driver to let it know that the device is being
-	 * removed
-	 */
-	storvsc_dev_remove(dev);
-
-	del_gendisk(blkdev->gd);
+		storvsc_dev_remove(blkdev->device_ctx);
 
-	kmem_cache_destroy(blkdev->request_pool);
-
-	kfree(blkdev);
+		kmem_cache_destroy(blkdev->request_pool);
+		kfree(blkdev);
+	}
 
 	return 0;
-
 }
 
 static void blkvsc_shutdown(struct hv_device *dev)
@@ -568,13 +564,23 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 	struct block_device_context *blkdev = disk->private_data;
 	unsigned long flags;
 
-	if (blkdev->users == 1) {
+	spin_lock_irqsave(&blkdev->lock, flags);
+
+	if ((--blkdev->users == 0) && (blkdev->shutting_down)) {
+		blk_stop_queue(blkdev->gd->queue);
+		spin_unlock_irqrestore(&blkdev->lock, flags);
+
 		blkvsc_do_operation(blkdev, DO_FLUSH);
-	}
+		del_gendisk(blkdev->gd);
+		put_disk(blkdev->gd);
+		blk_cleanup_queue(blkdev->gd->queue);
 
-	spin_lock_irqsave(&blkdev->lock, flags);
-	blkdev->users--;
-	spin_unlock_irqrestore(&blkdev->lock, flags);
+		storvsc_dev_remove(blkdev->device_ctx);
+
+		kmem_cache_destroy(blkdev->request_pool);
+		kfree(blkdev);
+	} else
+		spin_unlock_irqrestore(&blkdev->lock, flags);
 
 	return 0;
 }
-- 
1.7.4.1

