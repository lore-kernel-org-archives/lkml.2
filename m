Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1DFVYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:24:07 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:60512
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756876Ab1DFVYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:24:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 08/22] Staging: hv: Get rid of the forward declaration of blkvsc_do_flush()
Date: Wed,  6 Apr 2011 14:35:06 -0700
Message-Id: <1302125720-10808-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125720-10808-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
 <1302125720-10808-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of blkvsc_do_flush() by moving the code
around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   71 +++++++++++++++++++--------------------
 1 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 068daee..94f090e 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -465,6 +465,41 @@ static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 	complete(&blkvsc_req->request.wait_event);
 }
 
+static int blkvsc_do_flush(struct block_device_context *blkdev)
+{
+	struct blkvsc_request *blkvsc_req;
+
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_flush()\n");
+
+	if (blkdev->device_type != HARDDISK_TYPE)
+		return 0;
+
+	blkvsc_req = kmem_cache_zalloc(blkdev->request_pool, GFP_KERNEL);
+	if (!blkvsc_req)
+		return -ENOMEM;
+
+	memset(blkvsc_req, 0, sizeof(struct blkvsc_request));
+	init_completion(&blkvsc_req->request.wait_event);
+	blkvsc_req->dev = blkdev;
+	blkvsc_req->req = NULL;
+	blkvsc_req->write = 0;
+
+	blkvsc_req->request.data_buffer.pfn_array[0] = 0;
+	blkvsc_req->request.data_buffer.offset = 0;
+	blkvsc_req->request.data_buffer.len = 0;
+
+	blkvsc_req->cmnd[0] = SYNCHRONIZE_CACHE;
+	blkvsc_req->cmd_len = 10;
+
+	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
+
+	wait_for_completion_interruptible(&blkvsc_req->request.wait_event);
+
+	kmem_cache_free(blkvsc_req->dev->request_pool, blkvsc_req);
+
+	return 0;
+}
+
 
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
@@ -480,7 +515,6 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 static int blkvsc_do_inquiry(struct block_device_context *blkdev);
 static int blkvsc_do_read_capacity(struct block_device_context *blkdev);
 static int blkvsc_do_read_capacity16(struct block_device_context *blkdev);
-static int blkvsc_do_flush(struct block_device_context *blkdev);
 static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev);
 static int blkvsc_do_pending_reqs(struct block_device_context *blkdev);
 
@@ -771,41 +805,6 @@ static void blkvsc_shutdown(struct device *device)
 	spin_unlock_irqrestore(&blkdev->lock, flags);
 }
 
-static int blkvsc_do_flush(struct block_device_context *blkdev)
-{
-	struct blkvsc_request *blkvsc_req;
-
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_flush()\n");
-
-	if (blkdev->device_type != HARDDISK_TYPE)
-		return 0;
-
-	blkvsc_req = kmem_cache_zalloc(blkdev->request_pool, GFP_KERNEL);
-	if (!blkvsc_req)
-		return -ENOMEM;
-
-	memset(blkvsc_req, 0, sizeof(struct blkvsc_request));
-	init_completion(&blkvsc_req->request.wait_event);
-	blkvsc_req->dev = blkdev;
-	blkvsc_req->req = NULL;
-	blkvsc_req->write = 0;
-
-	blkvsc_req->request.data_buffer.pfn_array[0] = 0;
-	blkvsc_req->request.data_buffer.offset = 0;
-	blkvsc_req->request.data_buffer.len = 0;
-
-	blkvsc_req->cmnd[0] = SYNCHRONIZE_CACHE;
-	blkvsc_req->cmd_len = 10;
-
-	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
-
-	wait_for_completion_interruptible(&blkvsc_req->request.wait_event);
-
-	kmem_cache_free(blkvsc_req->dev->request_pool, blkvsc_req);
-
-	return 0;
-}
-
 /* Do a scsi INQUIRY cmd here to get the device type (ie disk or dvd) */
 static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 {
-- 
1.7.4.1

