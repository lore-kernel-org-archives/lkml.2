Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1C1QuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:50:17 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60584
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754790Ab1C1QuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:50:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 07/22] Staging: hv: Get rid of the forward declaration of blkvsc_cmd_completion()
Date: Mon, 28 Mar 2011 10:00:38 -0700
Message-Id: <1301331653-26265-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301331653-26265-1-git-send-email-kys@microsoft.com>
References: <1301331615-26226-1-git-send-email-kys@microsoft.com>
 <1301331653-26265-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of blkvsc_cmd_completion() by moving the
code  around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   48 +++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 30a37a2..8e575d9 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -439,6 +439,30 @@ static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
 	return ret;
 }
 
+static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
+{
+	struct blkvsc_request *blkvsc_req =
+			(struct blkvsc_request *)request->context;
+	struct block_device_context *blkdev =
+			(struct block_device_context *)blkvsc_req->dev;
+	struct scsi_sense_hdr sense_hdr;
+	struct vmscsi_request *vm_srb;
+
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cmd_completion() - req %p\n",
+		   blkvsc_req);
+
+	vm_srb = &blkvsc_req->request.vstor_packet.vm_srb;
+	blkdev->num_outstanding_reqs--;
+
+	if (vm_srb->scsi_status)
+		if (scsi_normalize_sense(blkvsc_req->sense_buffer,
+					 SCSI_SENSE_BUFFERSIZE, &sense_hdr))
+			scsi_print_sense_hdr("blkvsc", &sense_hdr);
+
+	complete(&blkvsc_req->request.wait_event);
+}
+
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
 static int blkvsc_remove(struct device *device);
@@ -450,7 +474,6 @@ static void blkvsc_request(struct request_queue *queue);
 static void blkvsc_request_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_request(struct block_device_context *blkdev,
 			     struct request *req);
-static void blkvsc_cmd_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_inquiry(struct block_device_context *blkdev);
 static int blkvsc_do_read_capacity(struct block_device_context *blkdev);
 static int blkvsc_do_read_capacity16(struct block_device_context *blkdev);
@@ -1253,29 +1276,6 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 	return pending;
 }
 
-static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
-{
-	struct blkvsc_request *blkvsc_req =
-			(struct blkvsc_request *)request->context;
-	struct block_device_context *blkdev =
-			(struct block_device_context *)blkvsc_req->dev;
-	struct scsi_sense_hdr sense_hdr;
-	struct vmscsi_request *vm_srb;
-
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cmd_completion() - req %p\n",
-		   blkvsc_req);
-
-	vm_srb = &blkvsc_req->request.vstor_packet.vm_srb;
-	blkdev->num_outstanding_reqs--;
-
-	if (vm_srb->scsi_status)
-		if (scsi_normalize_sense(blkvsc_req->sense_buffer,
-					 SCSI_SENSE_BUFFERSIZE, &sense_hdr))
-			scsi_print_sense_hdr("blkvsc", &sense_hdr);
-
-	complete(&blkvsc_req->request.wait_event);
-}
-
 static void blkvsc_request_completion(struct hv_storvsc_request *request)
 {
 	struct blkvsc_request *blkvsc_req =
-- 
1.7.4.1

