Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1DFWyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:54:16 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:52174
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756602Ab1DFWyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:54:04 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 07/22] Staging: hv: Get rid of the function blkvsc_do_flush()
Date: Wed,  6 Apr 2011 16:05:07 -0700
Message-Id: <1302131122-15530-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302131122-15530-1-git-send-email-kys@microsoft.com>
References: <1302131006-15411-1-git-send-email-kys@microsoft.com>
 <1302131122-15530-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the function blkvsc_do_flush() and instead use the common function
to force a device flush.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   52 ++++++++++----------------------------
 1 files changed, 14 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 7fab3c7..a7ae437 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -49,6 +49,7 @@ enum blkvsc_device_type {
 enum blkvsc_op_type {
 	DO_INQUIRY,
 	DO_CAPACITY,
+	DO_FLUSH,
 };
 
 /*
@@ -451,6 +452,13 @@ static int blkvsc_do_operation(struct block_device_context *blkdev,
 		blkvsc_req->cmd_len = 16;
 		blkvsc_req->request.data_buffer.len = 8;
 		break;
+
+	case DO_FLUSH:
+		blkvsc_req->cmnd[0] = SYNCHRONIZE_CACHE;
+		blkvsc_req->cmd_len = 10;
+		blkvsc_req->request.data_buffer.pfn_array[0] = 0;
+		blkvsc_req->request.data_buffer.len = 0;
+		break;
 	default:
 		ret = -EINVAL;
 		goto cleanup;
@@ -502,6 +510,9 @@ static int blkvsc_do_operation(struct block_device_context *blkdev,
 		(buf[4] << 24) | (buf[5] << 16) |
 		(buf[6] << 8) | buf[7];
 		break;
+	default:
+		break;
+
 	}
 
 cleanup:
@@ -515,41 +526,6 @@ cleanup:
 	return ret;
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
 
 static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
 {
@@ -676,7 +652,7 @@ static int blkvsc_remove(struct device *device)
 		udelay(100);
 	}
 
-	blkvsc_do_flush(blkdev);
+	blkvsc_do_operation(blkdev, DO_FLUSH);
 
 	spin_lock_irqsave(&blkdev->lock, flags);
 
@@ -720,7 +696,7 @@ static void blkvsc_shutdown(struct device *device)
 		udelay(100);
 	}
 
-	blkvsc_do_flush(blkdev);
+	blkvsc_do_operation(blkdev, DO_FLUSH);
 
 	spin_lock_irqsave(&blkdev->lock, flags);
 
@@ -740,7 +716,7 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 	spin_lock(&blkdev->lock);
 	if (blkdev->users == 1) {
 		spin_unlock(&blkdev->lock);
-		blkvsc_do_flush(blkdev);
+		blkvsc_do_operation(blkdev, DO_FLUSH);
 		spin_lock(&blkdev->lock);
 	}
 
-- 
1.7.4.1

