Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1DVVYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:24:03 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:56239
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756628Ab1DVVXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:23:37 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 05/18] Staging: hv: Get rid of the forward declaration of blkvsc_cancel_pending_reqs()
Date: Fri, 22 Apr 2011 14:13:26 -0700
Message-Id: <1303506819-1913-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303506819-1913-1-git-send-email-kys@microsoft.com>
References: <1303506780-1872-1-git-send-email-kys@microsoft.com>
 <1303506819-1913-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of blkvsc_cancel_pending_reqs() by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |  159 +++++++++++++++++++--------------------
 1 files changed, 79 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 1ca84b5..cab317c 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -493,6 +493,85 @@ static int blkvsc_do_flush(struct block_device_context *blkdev)
 }
 
 
+static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
+{
+	struct blkvsc_request *pend_req, *tmp;
+	struct blkvsc_request *comp_req, *tmp2;
+	struct vmscsi_request *vm_srb;
+
+	int ret = 0;
+
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cancel_pending_reqs()");
+
+	/* Flush the pending list first */
+	list_for_each_entry_safe(pend_req, tmp, &blkdev->pending_list,
+				 pend_entry) {
+		/*
+		 * The pend_req could be part of a partially completed
+		 * request. If so, complete those req first until we
+		 * hit the pend_req
+		 */
+		list_for_each_entry_safe(comp_req, tmp2,
+					 &pend_req->group->blkvsc_req_list,
+					 req_entry) {
+			DPRINT_DBG(BLKVSC_DRV, "completing blkvsc_req %p "
+				   "sect_start %lu sect_count %ld\n",
+				   comp_req,
+				   (unsigned long) comp_req->sector_start,
+				   comp_req->sector_count);
+
+			if (comp_req == pend_req)
+				break;
+
+			list_del(&comp_req->req_entry);
+
+			if (comp_req->req) {
+				vm_srb =
+				&comp_req->request.vstor_packet.
+				vm_srb;
+				ret = __blk_end_request(comp_req->req,
+					(!vm_srb->scsi_status ? 0 : -EIO),
+					comp_req->sector_count *
+					blkdev->sector_size);
+
+				/* FIXME: shouldn't this do more than return? */
+				if (ret)
+					goto out;
+			}
+
+			kmem_cache_free(blkdev->request_pool, comp_req);
+		}
+
+		DPRINT_DBG(BLKVSC_DRV, "cancelling pending request - %p\n",
+			   pend_req);
+
+		list_del(&pend_req->pend_entry);
+
+		list_del(&pend_req->req_entry);
+
+		if (comp_req->req) {
+			if (!__blk_end_request(pend_req->req, -EIO,
+					       pend_req->sector_count *
+					       blkdev->sector_size)) {
+				/*
+				 * All the sectors have been xferred ie the
+				 * request is done
+				 */
+				DPRINT_DBG(BLKVSC_DRV,
+					   "blkvsc_cancel_pending_reqs() - "
+					   "req %p COMPLETED\n", pend_req->req);
+				kmem_cache_free(blkdev->request_pool,
+						pend_req->group);
+			}
+		}
+
+		kmem_cache_free(blkdev->request_pool, pend_req);
+	}
+
+out:
+	return ret;
+}
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
 static int blkvsc_remove(struct device *device);
@@ -507,7 +586,6 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 static int blkvsc_do_inquiry(struct block_device_context *blkdev);
 static int blkvsc_do_read_capacity(struct block_device_context *blkdev);
 static int blkvsc_do_read_capacity16(struct block_device_context *blkdev);
-static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev);
 static int blkvsc_do_pending_reqs(struct block_device_context *blkdev);
 
 static int blkvsc_ringbuffer_size = BLKVSC_RING_BUFFER_SIZE;
@@ -1343,85 +1421,6 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 	spin_unlock_irqrestore(&blkdev->lock, flags);
 }
 
-static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
-{
-	struct blkvsc_request *pend_req, *tmp;
-	struct blkvsc_request *comp_req, *tmp2;
-	struct vmscsi_request *vm_srb;
-
-	int ret = 0;
-
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cancel_pending_reqs()");
-
-	/* Flush the pending list first */
-	list_for_each_entry_safe(pend_req, tmp, &blkdev->pending_list,
-				 pend_entry) {
-		/*
-		 * The pend_req could be part of a partially completed
-		 * request. If so, complete those req first until we
-		 * hit the pend_req
-		 */
-		list_for_each_entry_safe(comp_req, tmp2,
-					 &pend_req->group->blkvsc_req_list,
-					 req_entry) {
-			DPRINT_DBG(BLKVSC_DRV, "completing blkvsc_req %p "
-				   "sect_start %lu sect_count %ld\n",
-				   comp_req,
-				   (unsigned long) comp_req->sector_start,
-				   comp_req->sector_count);
-
-			if (comp_req == pend_req)
-				break;
-
-			list_del(&comp_req->req_entry);
-
-			if (comp_req->req) {
-				vm_srb =
-				&comp_req->request.vstor_packet.
-				vm_srb;
-				ret = __blk_end_request(comp_req->req,
-					(!vm_srb->scsi_status ? 0 : -EIO),
-					comp_req->sector_count *
-					blkdev->sector_size);
-
-				/* FIXME: shouldn't this do more than return? */
-				if (ret)
-					goto out;
-			}
-
-			kmem_cache_free(blkdev->request_pool, comp_req);
-		}
-
-		DPRINT_DBG(BLKVSC_DRV, "cancelling pending request - %p\n",
-			   pend_req);
-
-		list_del(&pend_req->pend_entry);
-
-		list_del(&pend_req->req_entry);
-
-		if (comp_req->req) {
-			if (!__blk_end_request(pend_req->req, -EIO,
-					       pend_req->sector_count *
-					       blkdev->sector_size)) {
-				/*
-				 * All the sectors have been xferred ie the
-				 * request is done
-				 */
-				DPRINT_DBG(BLKVSC_DRV,
-					   "blkvsc_cancel_pending_reqs() - "
-					   "req %p COMPLETED\n", pend_req->req);
-				kmem_cache_free(blkdev->request_pool,
-						pend_req->group);
-			}
-		}
-
-		kmem_cache_free(blkdev->request_pool, pend_req);
-	}
-
-out:
-	return ret;
-}
-
 static int blkvsc_do_pending_reqs(struct block_device_context *blkdev)
 {
 	struct blkvsc_request *pend_req, *tmp;
-- 
1.7.4.1

