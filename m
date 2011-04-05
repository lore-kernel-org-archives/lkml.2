Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1DEN5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:57:10 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42445
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752927Ab1DENxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:53:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 20/22] Staging: hv: Move the data_buffer field from struct hv_storvsc_request
Date: Tue,  5 Apr 2011 07:05:04 -0700
Message-Id: <1302012306-21277-20-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302012306-21277-1-git-send-email-kys@microsoft.com>
References: <1302012261-21236-1-git-send-email-kys@microsoft.com>
 <1302012306-21277-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of consolidating all I/O request state,
move the data_buffer field from struct hv_storvsc_request
struct storvsc_request_extension.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |   46 ++++++++++++++++++++-----------------
 drivers/staging/hv/storvsc.c     |   10 +++++---
 drivers/staging/hv/storvsc_api.h |    2 +-
 drivers/staging/hv/storvsc_drv.c |   13 +++++-----
 4 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index c05a242..782441d 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -520,9 +520,9 @@ static int blkvsc_do_flush(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.data_buffer.pfn_array[0] = 0;
-	blkvsc_req->request.data_buffer.offset = 0;
-	blkvsc_req->request.data_buffer.len = 0;
+	blkvsc_req->request.extension.data_buffer.pfn_array[0] = 0;
+	blkvsc_req->request.extension.data_buffer.offset = 0;
+	blkvsc_req->request.extension.data_buffer.len = 0;
 
 	blkvsc_req->cmnd[0] = SYNCHRONIZE_CACHE;
 	blkvsc_req->cmd_len = 10;
@@ -567,9 +567,10 @@ static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.data_buffer.pfn_array[0] = page_to_pfn(page_buf);
-	blkvsc_req->request.data_buffer.offset = 0;
-	blkvsc_req->request.data_buffer.len = 64;
+	blkvsc_req->request.extension.data_buffer.pfn_array[0] =
+	page_to_pfn(page_buf);
+	blkvsc_req->request.extension.data_buffer.offset = 0;
+	blkvsc_req->request.extension.data_buffer.len = 64;
 
 	blkvsc_req->cmnd[0] = INQUIRY;
 	blkvsc_req->cmnd[1] = 0x1;		/* Get product data */
@@ -656,9 +657,10 @@ static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.data_buffer.pfn_array[0] = page_to_pfn(page_buf);
-	blkvsc_req->request.data_buffer.offset = 0;
-	blkvsc_req->request.data_buffer.len = 8;
+	blkvsc_req->request.extension.data_buffer.pfn_array[0] =
+	page_to_pfn(page_buf);
+	blkvsc_req->request.extension.data_buffer.offset = 0;
+	blkvsc_req->request.extension.data_buffer.len = 8;
 
 	blkvsc_req->cmnd[0] = READ_CAPACITY;
 	blkvsc_req->cmd_len = 16;
@@ -735,9 +737,10 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.data_buffer.pfn_array[0] = page_to_pfn(page_buf);
-	blkvsc_req->request.data_buffer.offset = 0;
-	blkvsc_req->request.data_buffer.len = 12;
+	blkvsc_req->request.extension.data_buffer.pfn_array[0] =
+	page_to_pfn(page_buf);
+	blkvsc_req->request.extension.data_buffer.offset = 0;
+	blkvsc_req->request.extension.data_buffer.len = 12;
 
 	blkvsc_req->cmnd[0] = 0x9E; /* READ_CAPACITY16; */
 	blkvsc_req->cmd_len = 16;
@@ -926,8 +929,8 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long) blkvsc_req->sector_start,
 		   blkvsc_req->sector_count,
-		   blkvsc_req->request.data_buffer.offset,
-		   blkvsc_req->request.data_buffer.len);
+		   blkvsc_req->request.extension.data_buffer.offset,
+		   blkvsc_req->request.extension.data_buffer.len);
 #if 0
 	for (i = 0; i < (blkvsc_req->request.data_buffer.len >> 12); i++) {
 		DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
@@ -1054,10 +1057,11 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 
 					blkvsc_req->dev = blkdev;
 					blkvsc_req->req = req;
-					blkvsc_req->request.data_buffer.offset
-						= bvec->bv_offset;
-					blkvsc_req->request.data_buffer.len
-						= 0;
+					blkvsc_req->request.extension.
+					data_buffer.offset
+					= bvec->bv_offset;
+					blkvsc_req->request.extension.
+					data_buffer.len = 0;
 
 					/* Add to the group */
 					blkvsc_req->group = group;
@@ -1071,10 +1075,10 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 				}
 
 				/* Add the curr bvec/segment to the curr blkvsc_req */
-				blkvsc_req->request.data_buffer.
+				blkvsc_req->request.extension.data_buffer.
 					pfn_array[databuf_idx]
 						= page_to_pfn(bvec->bv_page);
-				blkvsc_req->request.data_buffer.len
+				blkvsc_req->request.extension.data_buffer.len
 					+= bvec->bv_len;
 
 				prev_bvec = bvec;
@@ -1180,7 +1184,7 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long)blkvsc_req->sector_start,
 		   blkvsc_req->sector_count,
-		   blkvsc_req->request.data_buffer.len,
+		   blkvsc_req->request.extension.data_buffer.len,
 		   blkvsc_req->group->outstanding,
 		   blkdev->num_outstanding_reqs);
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index c71481f..374de74 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -537,7 +537,7 @@ int stor_vsc_on_io_request(struct hv_device *device,
 		   request_extension);
 
 	DPRINT_DBG(STORVSC, "req %p len %d",
-		   request, request->data_buffer.len);
+		   request, request->extension.data_buffer.len);
 
 	if (!stor_device) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
@@ -558,7 +558,8 @@ int stor_vsc_on_io_request(struct hv_device *device,
 	vstor_packet->vm_srb.sense_info_length = SENSE_BUFFER_SIZE;
 
 
-	vstor_packet->vm_srb.data_transfer_length = request->data_buffer.len;
+	vstor_packet->vm_srb.data_transfer_length =
+	request->extension.data_buffer.len;
 
 	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
 
@@ -572,9 +573,10 @@ int stor_vsc_on_io_request(struct hv_device *device,
 		   vstor_packet->vm_srb.sense_info_length,
 		   vstor_packet->vm_srb.cdb_length);
 
-	if (request_extension->request->data_buffer.len) {
+	if (request_extension->request->extension.data_buffer.len) {
 		ret = vmbus_sendpacket_multipagebuffer(device->channel,
-				&request_extension->request->data_buffer,
+				&request_extension->request->extension.
+				data_buffer,
 				vstor_packet,
 				sizeof(struct vstor_packet),
 				(unsigned long)request_extension);
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 738627c..0c0bbf6 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -65,6 +65,7 @@ struct storvsc_request_extension {
 	unsigned char *sense_buffer;
 	void *context;
 	void (*on_io_completion)(struct hv_storvsc_request *request);
+	struct hv_multipage_buffer data_buffer;
 
 	struct vstor_packet vstor_packet;
 };
@@ -72,7 +73,6 @@ struct storvsc_request_extension {
 struct hv_storvsc_request {
 	struct storvsc_request_extension extension;
 
-	struct hv_multipage_buffer data_buffer;
 };
 
 /* Represents the block vsc driver */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index fbeec70..e7005d9 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -485,7 +485,8 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 
 	/* ASSERT(request->BytesXfer <= request->data_buffer.Length); */
 	scsi_set_resid(scmnd,
-		request->data_buffer.len - vm_srb->data_transfer_length);
+		request->extension.data_buffer.len -
+		vm_srb->data_transfer_length);
 
 	scsi_done_fn = scmnd->scsi_done;
 
@@ -789,7 +790,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	request->extension.sense_buffer = scmnd->sense_buffer;
 
 
-	request->data_buffer.len = scsi_bufflen(scmnd);
+	request->extension.data_buffer.len = scsi_bufflen(scmnd);
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
 		sg_count = scsi_sg_count(scmnd);
@@ -830,19 +831,19 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 			sg_count = cmd_request->bounce_sgl_count;
 		}
 
-		request->data_buffer.offset = sgl[0].offset;
+		request->extension.data_buffer.offset = sgl[0].offset;
 
 		for (i = 0; i < sg_count; i++) {
 			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
 				   i, sgl[i].length, sgl[i].offset);
-			request->data_buffer.pfn_array[i] =
+			request->extension.data_buffer.pfn_array[i] =
 				page_to_pfn(sg_page((&sgl[i])));
 		}
 	} else if (scsi_sglist(scmnd)) {
 		/* ASSERT(scsi_bufflen(scmnd) <= PAGE_SIZE); */
-		request->data_buffer.offset =
+		request->extension.data_buffer.offset =
 			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
-		request->data_buffer.pfn_array[0] =
+		request->extension.data_buffer.pfn_array[0] =
 			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
 	}
 
-- 
1.7.4.1

