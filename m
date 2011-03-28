Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1C1QsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:48:16 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58289
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752978Ab1C1QsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:48:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 17/20] Staging: hv: Get rid of the status field from struct hv_storvsc_request
Date: Mon, 28 Mar 2011 09:33:42 -0700
Message-Id: <1301330025-25542-17-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301330025-25542-1-git-send-email-kys@microsoft.com>
References: <1301329950-25490-1-git-send-email-kys@microsoft.com>
 <1301330025-25542-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of consolidating all I/O request state,
get rid of the  status field from struct hv_storvsc_request
and instead use the state in the struct vmscsi_request directly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |   23 ++++++++++++++++++-----
 drivers/staging/hv/storvsc.c     |    8 +++-----
 drivers/staging/hv/storvsc_api.h |    3 ---
 drivers/staging/hv/storvsc_drv.c |    6 ++++--
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 0e3b193..c05a242 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -631,6 +631,7 @@ static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
 	struct page *page_buf;
 	unsigned char *buf;
 	struct scsi_sense_hdr sense_hdr;
+	struct vmscsi_request *vm_srb;
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity()\n");
 
@@ -649,6 +650,7 @@ static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
 		return -ENOMEM;
 	}
 
+	vm_srb = &blkvsc_req->request.extension.vstor_packet.vm_srb;
 	init_waitqueue_head(&blkvsc_req->wevent);
 	blkvsc_req->dev = blkdev;
 	blkvsc_req->req = NULL;
@@ -675,7 +677,7 @@ static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
 	wait_event_interruptible(blkvsc_req->wevent, blkvsc_req->cond);
 
 	/* check error */
-	if (blkvsc_req->request.status) {
+	if (vm_srb->scsi_status) {
 		scsi_normalize_sense(blkvsc_req->sense_buffer,
 				     SCSI_SENSE_BUFFERSIZE, &sense_hdr);
 
@@ -708,6 +710,7 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 	struct page *page_buf;
 	unsigned char *buf;
 	struct scsi_sense_hdr sense_hdr;
+	struct vmscsi_request *vm_srb;
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity16()\n");
 
@@ -720,6 +723,7 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 		return -ENOMEM;
 
 	memset(blkvsc_req, 0, sizeof(struct blkvsc_request));
+	vm_srb = &blkvsc_req->request.extension.vstor_packet.vm_srb;
 	page_buf = alloc_page(GFP_KERNEL);
 	if (!page_buf) {
 		kmem_cache_free(blkvsc_req->dev->request_pool, blkvsc_req);
@@ -752,7 +756,7 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 	wait_event_interruptible(blkvsc_req->wevent, blkvsc_req->cond);
 
 	/* check error */
-	if (blkvsc_req->request.status) {
+	if (vm_srb->scsi_status) {
 		scsi_normalize_sense(blkvsc_req->sense_buffer,
 				     SCSI_SENSE_BUFFERSIZE, &sense_hdr);
 		if (sense_hdr.asc == 0x3A) {
@@ -1140,13 +1144,15 @@ static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 	struct block_device_context *blkdev =
 			(struct block_device_context *)blkvsc_req->dev;
 	struct scsi_sense_hdr sense_hdr;
+	struct vmscsi_request *vm_srb;
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cmd_completion() - req %p\n",
 		   blkvsc_req);
 
+	vm_srb = &blkvsc_req->request.extension.vstor_packet.vm_srb;
 	blkdev->num_outstanding_reqs--;
 
-	if (blkvsc_req->request.status)
+	if (vm_srb->scsi_status)
 		if (scsi_normalize_sense(blkvsc_req->sense_buffer,
 					 SCSI_SENSE_BUFFERSIZE, &sense_hdr))
 			scsi_print_sense_hdr("blkvsc", &sense_hdr);
@@ -1163,6 +1169,7 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 			(struct block_device_context *)blkvsc_req->dev;
 	unsigned long flags;
 	struct blkvsc_request *comp_req, *tmp;
+	struct vmscsi_request *vm_srb;
 
 	/* ASSERT(blkvsc_req->group); */
 
@@ -1199,8 +1206,10 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 
 			list_del(&comp_req->req_entry);
 
+			vm_srb =
+			&comp_req->request.extension.vstor_packet.vm_srb;
 			if (!__blk_end_request(comp_req->req,
-				(!comp_req->request.status ? 0 : -EIO),
+				(!vm_srb->scsi_status ? 0 : -EIO),
 				comp_req->sector_count * blkdev->sector_size)) {
 				/*
 				 * All the sectors have been xferred ie the
@@ -1229,6 +1238,7 @@ static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
 {
 	struct blkvsc_request *pend_req, *tmp;
 	struct blkvsc_request *comp_req, *tmp2;
+	struct vmscsi_request *vm_srb;
 
 	int ret = 0;
 
@@ -1257,8 +1267,11 @@ static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
 			list_del(&comp_req->req_entry);
 
 			if (comp_req->req) {
+				vm_srb =
+				&comp_req->request.extension.vstor_packet.
+				vm_srb;
 				ret = __blk_end_request(comp_req->req,
-					(!comp_req->request.status ? 0 : -EIO),
+					(!vm_srb->scsi_status ? 0 : -EIO),
 					comp_req->sector_count *
 					blkdev->sector_size);
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index d444cc9..6a45d57 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -296,9 +296,9 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 
 
 	/* Copy over the status...etc */
-	request->status = vstor_packet->vm_srb.scsi_status;
 
-	if (request->status != 0 || vstor_packet->vm_srb.srb_status != 1) {
+	if (vstor_packet->vm_srb.scsi_status != 0 ||
+		vstor_packet->vm_srb.srb_status != 1) {
 		DPRINT_WARN(STORVSC,
 			    "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
 			    vstor_packet->vm_srb.cdb[0],
@@ -306,7 +306,7 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 			    vstor_packet->vm_srb.srb_status);
 	}
 
-	if ((request->status & 0xFF) == 0x02) {
+	if ((vstor_packet->vm_srb.scsi_status & 0xFF) == 0x02) {
 		/* CHECK_CONDITION */
 		if (vstor_packet->vm_srb.srb_status & 0x80) {
 			/* autosense data available */
@@ -321,8 +321,6 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 		}
 	}
 
-	/* TODO: */
-	request->bytes_xfer = vstor_packet->vm_srb.data_transfer_length;
 
 	request->extension.on_io_completion(request);
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 89fa155..1705b9f 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -70,9 +70,6 @@ struct storvsc_request_extension {
 };
 
 struct hv_storvsc_request {
-	u32 status;
-	u32 bytes_xfer;
-
 
 	struct storvsc_request_extension extension;
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index e3e0486..a2faaef 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -454,6 +454,7 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 		(struct host_device_context *)scmnd->device->host->hostdata;
 	void (*scsi_done_fn)(struct scsi_cmnd *);
 	struct scsi_sense_hdr sense_hdr;
+	struct vmscsi_request *vm_srb;
 
 	/* ASSERT(request == &cmd_request->request); */
 	/* ASSERT(scmnd); */
@@ -473,7 +474,8 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 				      cmd_request->bounce_sgl_count);
 	}
 
-	scmnd->result = request->status;
+	vm_srb = &request->extension.vstor_packet.vm_srb;
+	scmnd->result = vm_srb->scsi_status;
 
 	if (scmnd->result) {
 		if (scsi_normalize_sense(scmnd->sense_buffer,
@@ -483,7 +485,7 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 
 	/* ASSERT(request->BytesXfer <= request->data_buffer.Length); */
 	scsi_set_resid(scmnd,
-		request->data_buffer.len - request->bytes_xfer);
+		request->data_buffer.len - vm_srb->data_transfer_length);
 
 	scsi_done_fn = scmnd->scsi_done;
 
-- 
1.7.4.1

