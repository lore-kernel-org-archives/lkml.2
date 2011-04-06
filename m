Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab1DFVs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:48:58 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:41485
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932230Ab1DFVr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:47:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 19/22] Staging: hv: Get rid of the forward declaration for blkvsc_request()
Date: Wed,  6 Apr 2011 14:35:17 -0700
Message-Id: <1302125720-10808-19-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125720-10808-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
 <1302125720-10808-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration for blkvsc_request() by moving the code
around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   86 +++++++++++++++++++-------------------
 1 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 66590f6..55ba9de 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -1170,9 +1170,51 @@ static int blkvsc_do_pending_reqs(struct block_device_context *blkdev)
 	return ret;
 }
 
+
+static void blkvsc_request(struct request_queue *queue)
+{
+	struct block_device_context *blkdev = NULL;
+	struct request *req;
+	int ret = 0;
+
+	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
+	while ((req = blk_peek_request(queue)) != NULL) {
+		DPRINT_DBG(BLKVSC_DRV, "- req %p\n", req);
+
+		blkdev = req->rq_disk->private_data;
+		if (blkdev->shutting_down || req->cmd_type != REQ_TYPE_FS ||
+		    blkdev->media_not_present) {
+			__blk_end_request_cur(req, 0);
+			continue;
+		}
+
+		ret = blkvsc_do_pending_reqs(blkdev);
+
+		if (ret != 0) {
+			DPRINT_DBG(BLKVSC_DRV,
+				   "- stop queue - pending_list not empty\n");
+			blk_stop_queue(queue);
+			break;
+		}
+
+		blk_start_request(req);
+
+		ret = blkvsc_do_request(blkdev, req);
+		if (ret > 0) {
+			DPRINT_DBG(BLKVSC_DRV, "- stop queue - no room\n");
+			blk_stop_queue(queue);
+			break;
+		} else if (ret < 0) {
+			DPRINT_DBG(BLKVSC_DRV, "- stop queue - no mem\n");
+			blk_requeue_request(queue, req);
+			blk_stop_queue(queue);
+			break;
+		}
+	}
+}
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
-static void blkvsc_request(struct request_queue *queue);
 
 static int blkvsc_ringbuffer_size = BLKVSC_RING_BUFFER_SIZE;
 module_param(blkvsc_ringbuffer_size, int, S_IRUGO);
@@ -1500,48 +1542,6 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 	spin_unlock_irqrestore(&blkdev->lock, flags);
 }
 
-static void blkvsc_request(struct request_queue *queue)
-{
-	struct block_device_context *blkdev = NULL;
-	struct request *req;
-	int ret = 0;
-
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
-	while ((req = blk_peek_request(queue)) != NULL) {
-		DPRINT_DBG(BLKVSC_DRV, "- req %p\n", req);
-
-		blkdev = req->rq_disk->private_data;
-		if (blkdev->shutting_down || req->cmd_type != REQ_TYPE_FS ||
-		    blkdev->media_not_present) {
-			__blk_end_request_cur(req, 0);
-			continue;
-		}
-
-		ret = blkvsc_do_pending_reqs(blkdev);
-
-		if (ret != 0) {
-			DPRINT_DBG(BLKVSC_DRV,
-				   "- stop queue - pending_list not empty\n");
-			blk_stop_queue(queue);
-			break;
-		}
-
-		blk_start_request(req);
-
-		ret = blkvsc_do_request(blkdev, req);
-		if (ret > 0) {
-			DPRINT_DBG(BLKVSC_DRV, "- stop queue - no room\n");
-			blk_stop_queue(queue);
-			break;
-		} else if (ret < 0) {
-			DPRINT_DBG(BLKVSC_DRV, "- stop queue - no mem\n");
-			blk_requeue_request(queue, req);
-			blk_stop_queue(queue);
-			break;
-		}
-	}
-}
-
 static int __init blkvsc_init(void)
 {
 	int ret;
-- 
1.7.4.1

