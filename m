Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab1EIWLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:11:11 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47350
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751976Ab1EIVoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:44 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 023/206] Staging: hv: Cleanup blkvsc_remove()
Date: Mon,  9 May 2011 14:55:05 -0700
Message-Id: <1304978288-22999-23-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function storvsc_dev_remove() already deals with draining of 
the outstanding I/O. Cleanup blkvsc_remove() keeping this in mind.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 457d0bb..217676a 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -538,11 +538,6 @@ static int blkvsc_remove(struct hv_device *dev)
 	struct block_device_context *blkdev = dev_get_drvdata(&dev->device);
 	unsigned long flags;
 
-	/*
-	 * Call to the vsc driver to let it know that the device is being
-	 * removed
-	 */
-	storvsc_dev_remove(dev);
 
 	/* Get to a known state */
 	spin_lock_irqsave(&blkdev->lock, flags);
@@ -555,17 +550,16 @@ static int blkvsc_remove(struct hv_device *dev)
 
 	spin_unlock_irqrestore(&blkdev->lock, flags);
 
-	while (blkdev->num_outstanding_reqs) {
-		DPRINT_INFO(STORVSC, "waiting for %d requests to complete...",
-			    blkdev->num_outstanding_reqs);
-		udelay(100);
-	}
-
-
 	blkvsc_do_operation(blkdev, DO_FLUSH);
 
 	blk_cleanup_queue(blkdev->gd->queue);
 
+	/*
+	 * Call to the vsc driver to let it know that the device is being
+	 * removed
+	 */
+	storvsc_dev_remove(dev);
+
 	del_gendisk(blkdev->gd);
 
 	kmem_cache_destroy(blkdev->request_pool);
-- 
1.7.4.1

