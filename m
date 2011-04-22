Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab1DVVDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:03:02 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33327
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755935Ab1DVVBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:01:20 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 14/18] Staging: hv: Get rid of the forward declaration for blkvsc_do_pending_reqs()
Date: Fri, 22 Apr 2011 14:13:35 -0700
Message-Id: <1303506819-1913-14-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303506819-1913-1-git-send-email-kys@microsoft.com>
References: <1303506780-1872-1-git-send-email-kys@microsoft.com>
 <1303506819-1913-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration for blkvsc_do_pending_reqs() by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   45 +++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 0b5622e..5252948 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -1140,10 +1140,31 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 	return pending;
 }
 
+static int blkvsc_do_pending_reqs(struct block_device_context *blkdev)
+{
+	struct blkvsc_request *pend_req, *tmp;
+	int ret = 0;
+
+	/* Flush the pending list first */
+	list_for_each_entry_safe(pend_req, tmp, &blkdev->pending_list,
+				 pend_entry) {
+		DPRINT_DBG(BLKVSC_DRV, "working off pending_list - %p\n",
+			   pend_req);
+
+		ret = blkvsc_submit_request(pend_req,
+					    blkvsc_request_completion);
+		if (ret != 0)
+			break;
+		else
+			list_del(&pend_req->pend_entry);
+	}
+
+	return ret;
+}
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
 static void blkvsc_request(struct request_queue *queue);
-static int blkvsc_do_pending_reqs(struct block_device_context *blkdev);
 
 static int blkvsc_ringbuffer_size = BLKVSC_RING_BUFFER_SIZE;
 module_param(blkvsc_ringbuffer_size, int, S_IRUGO);
@@ -1470,28 +1491,6 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 	spin_unlock_irqrestore(&blkdev->lock, flags);
 }
 
-static int blkvsc_do_pending_reqs(struct block_device_context *blkdev)
-{
-	struct blkvsc_request *pend_req, *tmp;
-	int ret = 0;
-
-	/* Flush the pending list first */
-	list_for_each_entry_safe(pend_req, tmp, &blkdev->pending_list,
-				 pend_entry) {
-		DPRINT_DBG(BLKVSC_DRV, "working off pending_list - %p\n",
-			   pend_req);
-
-		ret = blkvsc_submit_request(pend_req,
-					    blkvsc_request_completion);
-		if (ret != 0)
-			break;
-		else
-			list_del(&pend_req->pend_entry);
-	}
-
-	return ret;
-}
-
 static void blkvsc_request(struct request_queue *queue)
 {
 	struct block_device_context *blkdev = NULL;
-- 
1.7.4.1

