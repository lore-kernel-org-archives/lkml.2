Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1DFVZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:25:56 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:60582
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756867Ab1DFVYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:24:04 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 01/22] Staging: hv: Get rid of the forward declaration of  blkvsc_submit_request()
Date: Wed,  6 Apr 2011 14:34:59 -0700
Message-Id: <1302125720-10808-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125655-10741-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of  blkvsc_submit_request() by moving the
code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |  117 ++++++++++++++++++++-------------------
 1 files changed, 59 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index d1ecd60..efcc916 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -184,6 +184,65 @@ static int blk_vsc_initialize(struct hv_driver *driver)
 	return ret;
 }
 
+
+static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
+			void (*request_completion)(struct hv_storvsc_request *))
+{
+	struct block_device_context *blkdev = blkvsc_req->dev;
+	struct hv_device *device_ctx = blkdev->device_ctx;
+	struct hv_driver *drv =
+			drv_to_hv_drv(device_ctx->device.driver);
+	struct storvsc_driver_object *storvsc_drv_obj =
+			drv->priv;
+	struct hv_storvsc_request *storvsc_req;
+	struct vmscsi_request *vm_srb;
+	int ret;
+
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
+		   "req %p type %s start_sector %lu count %ld offset %d "
+		   "len %d\n", blkvsc_req,
+		   (blkvsc_req->write) ? "WRITE" : "READ",
+		   (unsigned long) blkvsc_req->sector_start,
+		   blkvsc_req->sector_count,
+		   blkvsc_req->request.data_buffer.offset,
+		   blkvsc_req->request.data_buffer.len);
+#if 0
+	for (i = 0; i < (blkvsc_req->request.data_buffer.len >> 12); i++) {
+		DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
+			   "req %p pfn[%d] %llx\n",
+			   blkvsc_req, i,
+			   blkvsc_req->request.data_buffer.pfn_array[i]);
+	}
+#endif
+
+	storvsc_req = &blkvsc_req->request;
+	vm_srb = &storvsc_req->vstor_packet.vm_srb;
+
+	vm_srb->data_in = blkvsc_req->write ? WRITE_TYPE : READ_TYPE;
+
+	storvsc_req->on_io_completion = request_completion;
+	storvsc_req->context = blkvsc_req;
+
+	vm_srb->port_number = blkdev->port;
+	vm_srb->path_id = blkdev->path;
+	vm_srb->target_id = blkdev->target;
+	vm_srb->lun = 0;	 /* this is not really used at all */
+
+	vm_srb->cdb_length = blkvsc_req->cmd_len;
+
+	memcpy(vm_srb->cdb, blkvsc_req->cmnd, vm_srb->cdb_length);
+
+	storvsc_req->sense_buffer = blkvsc_req->sense_buffer;
+
+	ret = storvsc_drv_obj->on_io_request(blkdev->device_ctx,
+					   &blkvsc_req->request);
+	if (ret == 0)
+		blkdev->num_outstanding_reqs++;
+
+	return ret;
+}
+
+
 /* Static decl */
 static DEFINE_MUTEX(blkvsc_mutex);
 static int blkvsc_probe(struct device *dev);
@@ -202,8 +261,6 @@ static void blkvsc_request(struct request_queue *queue);
 static void blkvsc_request_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_request(struct block_device_context *blkdev,
 			     struct request *req);
-static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
-		void (*request_completion)(struct hv_storvsc_request *));
 static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req);
 static void blkvsc_cmd_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_inquiry(struct block_device_context *blkdev);
@@ -891,62 +948,6 @@ static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req)
 	}
 }
 
-static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
-			void (*request_completion)(struct hv_storvsc_request *))
-{
-	struct block_device_context *blkdev = blkvsc_req->dev;
-	struct hv_device *device_ctx = blkdev->device_ctx;
-	struct hv_driver *drv =
-			drv_to_hv_drv(device_ctx->device.driver);
-	struct storvsc_driver_object *storvsc_drv_obj =
-			drv->priv;
-	struct hv_storvsc_request *storvsc_req;
-	struct vmscsi_request *vm_srb;
-	int ret;
-
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
-		   "req %p type %s start_sector %lu count %ld offset %d "
-		   "len %d\n", blkvsc_req,
-		   (blkvsc_req->write) ? "WRITE" : "READ",
-		   (unsigned long) blkvsc_req->sector_start,
-		   blkvsc_req->sector_count,
-		   blkvsc_req->request.data_buffer.offset,
-		   blkvsc_req->request.data_buffer.len);
-#if 0
-	for (i = 0; i < (blkvsc_req->request.data_buffer.len >> 12); i++) {
-		DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
-			   "req %p pfn[%d] %llx\n",
-			   blkvsc_req, i,
-			   blkvsc_req->request.data_buffer.pfn_array[i]);
-	}
-#endif
-
-	storvsc_req = &blkvsc_req->request;
-	vm_srb = &storvsc_req->vstor_packet.vm_srb;
-
-	vm_srb->data_in = blkvsc_req->write ? WRITE_TYPE : READ_TYPE;
-
-	storvsc_req->on_io_completion = request_completion;
-	storvsc_req->context = blkvsc_req;
-
-	vm_srb->port_number = blkdev->port;
-	vm_srb->path_id = blkdev->path;
-	vm_srb->target_id = blkdev->target;
-	vm_srb->lun = 0;	 /* this is not really used at all */
-
-	vm_srb->cdb_length = blkvsc_req->cmd_len;
-
-	memcpy(vm_srb->cdb, blkvsc_req->cmnd, vm_srb->cdb_length);
-
-	storvsc_req->sense_buffer = blkvsc_req->sense_buffer;
-
-	ret = storvsc_drv_obj->on_io_request(blkdev->device_ctx,
-					   &blkvsc_req->request);
-	if (ret == 0)
-		blkdev->num_outstanding_reqs++;
-
-	return ret;
-}
 
 /*
  * We break the request into 1 or more blkvsc_requests and submit
-- 
1.7.4.1

