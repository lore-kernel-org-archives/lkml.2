Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1DEN5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:57:03 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:55465
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752949Ab1DENxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:53:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 21/22] Staging: hv: Rename struct storvsc_request_extension
Date: Tue,  5 Apr 2011 07:05:05 -0700
Message-Id: <1302012306-21277-21-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302012306-21277-1-git-send-email-kys@microsoft.com>
References: <1302012261-21236-1-git-send-email-kys@microsoft.com>
 <1302012306-21277-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all duplicate state has been eliminated from
struct hv_storvsc_request and all needed state has been moved
to struct storvsc_request_extension, get rid of
struct hv_storvsc_request and rename struct storvsc_request_extension
as struct hv_storvsc_request. Cleanup and consolidation
of I/O request state is now complete.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |   60 +++++++++++++++++++-------------------
 drivers/staging/hv/storvsc.c     |   51 ++++++++++++++------------------
 drivers/staging/hv/storvsc_api.h |   11 ++-----
 drivers/staging/hv/storvsc_drv.c |   31 +++++++++----------
 4 files changed, 70 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 782441d..86e0506 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -520,9 +520,9 @@ static int blkvsc_do_flush(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.extension.data_buffer.pfn_array[0] = 0;
-	blkvsc_req->request.extension.data_buffer.offset = 0;
-	blkvsc_req->request.extension.data_buffer.len = 0;
+	blkvsc_req->request.data_buffer.pfn_array[0] = 0;
+	blkvsc_req->request.data_buffer.offset = 0;
+	blkvsc_req->request.data_buffer.len = 0;
 
 	blkvsc_req->cmnd[0] = SYNCHRONIZE_CACHE;
 	blkvsc_req->cmd_len = 10;
@@ -567,10 +567,10 @@ static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.extension.data_buffer.pfn_array[0] =
+	blkvsc_req->request.data_buffer.pfn_array[0] =
 	page_to_pfn(page_buf);
-	blkvsc_req->request.extension.data_buffer.offset = 0;
-	blkvsc_req->request.extension.data_buffer.len = 64;
+	blkvsc_req->request.data_buffer.offset = 0;
+	blkvsc_req->request.data_buffer.len = 64;
 
 	blkvsc_req->cmnd[0] = INQUIRY;
 	blkvsc_req->cmnd[1] = 0x1;		/* Get product data */
@@ -651,16 +651,16 @@ static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
 		return -ENOMEM;
 	}
 
-	vm_srb = &blkvsc_req->request.extension.vstor_packet.vm_srb;
+	vm_srb = &blkvsc_req->request.vstor_packet.vm_srb;
 	init_waitqueue_head(&blkvsc_req->wevent);
 	blkvsc_req->dev = blkdev;
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.extension.data_buffer.pfn_array[0] =
+	blkvsc_req->request.data_buffer.pfn_array[0] =
 	page_to_pfn(page_buf);
-	blkvsc_req->request.extension.data_buffer.offset = 0;
-	blkvsc_req->request.extension.data_buffer.len = 8;
+	blkvsc_req->request.data_buffer.offset = 0;
+	blkvsc_req->request.data_buffer.len = 8;
 
 	blkvsc_req->cmnd[0] = READ_CAPACITY;
 	blkvsc_req->cmd_len = 16;
@@ -725,7 +725,7 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 		return -ENOMEM;
 
 	memset(blkvsc_req, 0, sizeof(struct blkvsc_request));
-	vm_srb = &blkvsc_req->request.extension.vstor_packet.vm_srb;
+	vm_srb = &blkvsc_req->request.vstor_packet.vm_srb;
 	page_buf = alloc_page(GFP_KERNEL);
 	if (!page_buf) {
 		kmem_cache_free(blkvsc_req->dev->request_pool, blkvsc_req);
@@ -737,10 +737,10 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.extension.data_buffer.pfn_array[0] =
+	blkvsc_req->request.data_buffer.pfn_array[0] =
 	page_to_pfn(page_buf);
-	blkvsc_req->request.extension.data_buffer.offset = 0;
-	blkvsc_req->request.extension.data_buffer.len = 12;
+	blkvsc_req->request.data_buffer.offset = 0;
+	blkvsc_req->request.data_buffer.len = 12;
 
 	blkvsc_req->cmnd[0] = 0x9E; /* READ_CAPACITY16; */
 	blkvsc_req->cmd_len = 16;
@@ -929,8 +929,8 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long) blkvsc_req->sector_start,
 		   blkvsc_req->sector_count,
-		   blkvsc_req->request.extension.data_buffer.offset,
-		   blkvsc_req->request.extension.data_buffer.len);
+		   blkvsc_req->request.data_buffer.offset,
+		   blkvsc_req->request.data_buffer.len);
 #if 0
 	for (i = 0; i < (blkvsc_req->request.data_buffer.len >> 12); i++) {
 		DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
@@ -941,12 +941,12 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 #endif
 
 	storvsc_req = &blkvsc_req->request;
-	vm_srb = &storvsc_req->extension.vstor_packet.vm_srb;
+	vm_srb = &storvsc_req->vstor_packet.vm_srb;
 
 	vm_srb->data_in = blkvsc_req->write ? WRITE_TYPE : READ_TYPE;
 
-	storvsc_req->extension.on_io_completion = request_completion;
-	storvsc_req->extension.context = blkvsc_req;
+	storvsc_req->on_io_completion = request_completion;
+	storvsc_req->context = blkvsc_req;
 
 	vm_srb->port_number = blkdev->port;
 	vm_srb->path_id = blkdev->path;
@@ -957,7 +957,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 
 	memcpy(vm_srb->cdb, blkvsc_req->cmnd, vm_srb->cdb_length);
 
-	storvsc_req->extension.sense_buffer = blkvsc_req->sense_buffer;
+	storvsc_req->sense_buffer = blkvsc_req->sense_buffer;
 
 	ret = storvsc_drv_obj->on_io_request(blkdev->device_ctx,
 					   &blkvsc_req->request);
@@ -1057,10 +1057,10 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 
 					blkvsc_req->dev = blkdev;
 					blkvsc_req->req = req;
-					blkvsc_req->request.extension.
+					blkvsc_req->request.
 					data_buffer.offset
 					= bvec->bv_offset;
-					blkvsc_req->request.extension.
+					blkvsc_req->request.
 					data_buffer.len = 0;
 
 					/* Add to the group */
@@ -1075,10 +1075,10 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 				}
 
 				/* Add the curr bvec/segment to the curr blkvsc_req */
-				blkvsc_req->request.extension.data_buffer.
+				blkvsc_req->request.data_buffer.
 					pfn_array[databuf_idx]
 						= page_to_pfn(bvec->bv_page);
-				blkvsc_req->request.extension.data_buffer.len
+				blkvsc_req->request.data_buffer.len
 					+= bvec->bv_len;
 
 				prev_bvec = bvec;
@@ -1144,7 +1144,7 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 {
 	struct blkvsc_request *blkvsc_req =
-			(struct blkvsc_request *)request->extension.context;
+			(struct blkvsc_request *)request->context;
 	struct block_device_context *blkdev =
 			(struct block_device_context *)blkvsc_req->dev;
 	struct scsi_sense_hdr sense_hdr;
@@ -1153,7 +1153,7 @@ static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cmd_completion() - req %p\n",
 		   blkvsc_req);
 
-	vm_srb = &blkvsc_req->request.extension.vstor_packet.vm_srb;
+	vm_srb = &blkvsc_req->request.vstor_packet.vm_srb;
 	blkdev->num_outstanding_reqs--;
 
 	if (vm_srb->scsi_status)
@@ -1168,7 +1168,7 @@ static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 static void blkvsc_request_completion(struct hv_storvsc_request *request)
 {
 	struct blkvsc_request *blkvsc_req =
-			(struct blkvsc_request *)request->extension.context;
+			(struct blkvsc_request *)request->context;
 	struct block_device_context *blkdev =
 			(struct block_device_context *)blkvsc_req->dev;
 	unsigned long flags;
@@ -1184,7 +1184,7 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long)blkvsc_req->sector_start,
 		   blkvsc_req->sector_count,
-		   blkvsc_req->request.extension.data_buffer.len,
+		   blkvsc_req->request.data_buffer.len,
 		   blkvsc_req->group->outstanding,
 		   blkdev->num_outstanding_reqs);
 
@@ -1211,7 +1211,7 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 			list_del(&comp_req->req_entry);
 
 			vm_srb =
-			&comp_req->request.extension.vstor_packet.vm_srb;
+			&comp_req->request.vstor_packet.vm_srb;
 			if (!__blk_end_request(comp_req->req,
 				(!vm_srb->scsi_status ? 0 : -EIO),
 				comp_req->sector_count * blkdev->sector_size)) {
@@ -1272,7 +1272,7 @@ static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
 
 			if (comp_req->req) {
 				vm_srb =
-				&comp_req->request.extension.vstor_packet.
+				&comp_req->request.vstor_packet.
 				vm_srb;
 				ret = __blk_end_request(comp_req->req,
 					(!vm_srb->scsi_status ? 0 : -EIO),
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 374de74..d7ce393 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -105,7 +105,7 @@ static inline struct storvsc_device *final_release_stor_device(
 static int stor_vsc_channel_init(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
-	struct storvsc_request_extension *request;
+	struct hv_storvsc_request *request;
 	struct vstor_packet *vstor_packet;
 	int ret, t;
 
@@ -123,7 +123,7 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	 * Now, initiate the vsc/vsp initialization protocol on the open
 	 * channel
 	 */
-	memset(request, 0, sizeof(struct storvsc_request_extension));
+	memset(request, 0, sizeof(struct hv_storvsc_request));
 	init_completion(&request->wait_event);
 	vstor_packet->operation = VSTOR_OPERATION_BEGIN_INITIALIZATION;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
@@ -276,9 +276,8 @@ cleanup:
 
 static void stor_vsc_on_io_completion(struct hv_device *device,
 				  struct vstor_packet *vstor_packet,
-				  struct storvsc_request_extension *request_ext)
+				  struct hv_storvsc_request *request)
 {
-	struct hv_storvsc_request *request;
 	struct storvsc_device *stor_device;
 	struct vstor_packet *stor_pkt;
 
@@ -289,12 +288,11 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 		return;
 	}
 
-	DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION - request extension %p "
-		   "completed bytes xfer %u", request_ext,
+	DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION - request %p "
+		   "completed bytes xfer %u", request,
 		   vstor_packet->vm_srb.data_transfer_length);
 
-	request = request_ext->request;
-	stor_pkt = &request_ext->vstor_packet;
+	stor_pkt = &request->vstor_packet;
 
 
 	/* Copy over the status...etc */
@@ -317,10 +315,10 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 		if (vstor_packet->vm_srb.srb_status & 0x80) {
 			/* autosense data available */
 			DPRINT_WARN(STORVSC, "storvsc pkt %p autosense data "
-				    "valid - len %d\n", request_ext,
+				    "valid - len %d\n", request,
 				    vstor_packet->vm_srb.sense_info_length);
 
-			memcpy(request->extension.sense_buffer,
+			memcpy(request->sense_buffer,
 			       vstor_packet->vm_srb.sense_data,
 			       vstor_packet->vm_srb.sense_info_length);
 
@@ -330,7 +328,7 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 	stor_pkt->vm_srb.data_transfer_length =
 	vstor_packet->vm_srb.data_transfer_length;
 
-	request->extension.on_io_completion(request);
+	request->on_io_completion(request);
 
 	atomic_dec(&stor_device->num_outstanding_req);
 
@@ -339,12 +337,12 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 
 static void stor_vsc_on_receive(struct hv_device *device,
 			     struct vstor_packet *vstor_packet,
-			     struct storvsc_request_extension *request_ext)
+			     struct hv_storvsc_request *request)
 {
 	switch (vstor_packet->operation) {
 	case VSTOR_OPERATION_COMPLETE_IO:
 		DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION");
-		stor_vsc_on_io_completion(device, vstor_packet, request_ext);
+		stor_vsc_on_io_completion(device, vstor_packet, request);
 		break;
 	case VSTOR_OPERATION_REMOVE_DEVICE:
 		DPRINT_INFO(STORVSC, "REMOVE_DEVICE_OPERATION");
@@ -365,7 +363,7 @@ static void stor_vsc_on_channel_callback(void *context)
 	u32 bytes_recvd;
 	u64 request_id;
 	unsigned char packet[ALIGN(sizeof(struct vstor_packet), 8)];
-	struct storvsc_request_extension *request;
+	struct hv_storvsc_request *request;
 	int ret;
 
 
@@ -385,7 +383,7 @@ static void stor_vsc_on_channel_callback(void *context)
 				   bytes_recvd, request_id);
 
 
-			request = (struct storvsc_request_extension *)
+			request = (struct hv_storvsc_request *)
 					(unsigned long)request_id;
 
 			if ((request == &stor_device->init_request) ||
@@ -524,20 +522,17 @@ int stor_vsc_on_io_request(struct hv_device *device,
 			      struct hv_storvsc_request *request)
 {
 	struct storvsc_device *stor_device;
-	struct storvsc_request_extension *request_extension;
 	struct vstor_packet *vstor_packet;
 	int ret = 0;
 
-	request_extension = &request->extension;
-	vstor_packet = &request_extension->vstor_packet;
+	vstor_packet = &request->vstor_packet;
 	stor_device = get_stor_device(device);
 
 	DPRINT_DBG(STORVSC, "enter - Device %p, DeviceExt %p, Request %p, "
-		   "Extension %p", device, stor_device, request,
-		   request_extension);
+		   , device, stor_device, request);
 
 	DPRINT_DBG(STORVSC, "req %p len %d",
-		   request, request->extension.data_buffer.len);
+		   request, request->data_buffer.len);
 
 	if (!stor_device) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
@@ -546,8 +541,7 @@ int stor_vsc_on_io_request(struct hv_device *device,
 	}
 
 
-	request_extension->request = request;
-	request_extension->device  = device;
+	request->device  = device;
 
 
 	vstor_packet->flags |= REQUEST_COMPLETION_FLAG;
@@ -559,7 +553,7 @@ int stor_vsc_on_io_request(struct hv_device *device,
 
 
 	vstor_packet->vm_srb.data_transfer_length =
-	request->extension.data_buffer.len;
+	request->data_buffer.len;
 
 	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
 
@@ -573,17 +567,16 @@ int stor_vsc_on_io_request(struct hv_device *device,
 		   vstor_packet->vm_srb.sense_info_length,
 		   vstor_packet->vm_srb.cdb_length);
 
-	if (request_extension->request->extension.data_buffer.len) {
+	if (request->data_buffer.len) {
 		ret = vmbus_sendpacket_multipagebuffer(device->channel,
-				&request_extension->request->extension.
-				data_buffer,
+				&request->data_buffer,
 				vstor_packet,
 				sizeof(struct vstor_packet),
-				(unsigned long)request_extension);
+				(unsigned long)request);
 	} else {
 		ret = vmbus_sendpacket(device->channel, vstor_packet,
 				       sizeof(struct vstor_packet),
-				       (unsigned long)request_extension,
+				       (unsigned long)request,
 				       VM_PKT_DATA_INBAND,
 				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	}
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 0c0bbf6..f6b7cde 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -55,7 +55,7 @@ enum storvsc_request_type{
 };
 
 
-struct storvsc_request_extension {
+struct hv_storvsc_request {
 	struct hv_storvsc_request *request;
 	struct hv_device *device;
 
@@ -70,11 +70,6 @@ struct storvsc_request_extension {
 	struct vstor_packet vstor_packet;
 };
 
-struct hv_storvsc_request {
-	struct storvsc_request_extension extension;
-
-};
-
 /* Represents the block vsc driver */
 struct storvsc_driver_object {
 	struct hv_driver base;
@@ -115,8 +110,8 @@ struct storvsc_device {
 	unsigned char target_id;
 
 	/* Used for vsc/vsp channel reset process */
-	struct storvsc_request_extension init_request;
-	struct storvsc_request_extension reset_request;
+	struct hv_storvsc_request init_request;
+	struct hv_storvsc_request reset_request;
 };
 
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index e7005d9..ae61735 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -81,12 +81,11 @@ static int stor_vsc_initialize(struct hv_driver *driver)
 
 	stor_driver = hvdr_to_stordr(driver);
 
-	DPRINT_DBG(STORVSC, "sizeof(STORVSC_REQUEST)=%zd "
-		   "sizeof(struct storvsc_request_extension)=%zd "
+	DPRINT_DBG(STORVSC,
+		   "sizeof(struct hv_storvsc_request)=%zd "
 		   "sizeof(struct vstor_packet)=%zd, "
 		   "sizeof(struct vmscsi_request)=%zd",
 		   sizeof(struct hv_storvsc_request),
-		   sizeof(struct storvsc_request_extension),
 		   sizeof(struct vstor_packet),
 		   sizeof(struct vmscsi_request));
 
@@ -229,7 +228,7 @@ static int storvsc_drv_init(void)
 static int stor_vsc_on_host_reset(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
-	struct storvsc_request_extension *request;
+	struct hv_storvsc_request *request;
 	struct vstor_packet *vstor_packet;
 	int ret, t;
 
@@ -448,7 +447,7 @@ static int storvsc_remove(struct device *device)
 static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 {
 	struct storvsc_cmd_request *cmd_request =
-		(struct storvsc_cmd_request *)request->extension.context;
+		(struct storvsc_cmd_request *)request->context;
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
 	struct host_device_context *host_device_ctx =
 		(struct host_device_context *)scmnd->device->host->hostdata;
@@ -474,7 +473,7 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 				      cmd_request->bounce_sgl_count);
 	}
 
-	vm_srb = &request->extension.vstor_packet.vm_srb;
+	vm_srb = &request->vstor_packet.vm_srb;
 	scmnd->result = vm_srb->scsi_status;
 
 	if (scmnd->result) {
@@ -485,7 +484,7 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 
 	/* ASSERT(request->BytesXfer <= request->data_buffer.Length); */
 	scsi_set_resid(scmnd,
-		request->extension.data_buffer.len -
+		request->data_buffer.len -
 		vm_srb->data_transfer_length);
 
 	scsi_done_fn = scmnd->scsi_done;
@@ -756,7 +755,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	scmnd->host_scribble = (unsigned char *)cmd_request;
 
 	request = &cmd_request->request;
-	vm_srb = &request->extension.vstor_packet.vm_srb;
+	vm_srb = &request->vstor_packet.vm_srb;
 
 	DPRINT_DBG(STORVSC_DRV, "req %p size %d", request, request_size);
 
@@ -773,8 +772,8 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 		break;
 	}
 
-	request->extension.on_io_completion = storvsc_commmand_completion;
-	request->extension.context = cmd_request;/* scmnd; */
+	request->on_io_completion = storvsc_commmand_completion;
+	request->context = cmd_request;/* scmnd; */
 
 	/* request->PortId = scmnd->device->channel; */
 	vm_srb->port_number = host_device_ctx->port;
@@ -787,10 +786,10 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 	memcpy(vm_srb->cdb, scmnd->cmnd, vm_srb->cdb_length);
 
-	request->extension.sense_buffer = scmnd->sense_buffer;
+	request->sense_buffer = scmnd->sense_buffer;
 
 
-	request->extension.data_buffer.len = scsi_bufflen(scmnd);
+	request->data_buffer.len = scsi_bufflen(scmnd);
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
 		sg_count = scsi_sg_count(scmnd);
@@ -831,19 +830,19 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 			sg_count = cmd_request->bounce_sgl_count;
 		}
 
-		request->extension.data_buffer.offset = sgl[0].offset;
+		request->data_buffer.offset = sgl[0].offset;
 
 		for (i = 0; i < sg_count; i++) {
 			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
 				   i, sgl[i].length, sgl[i].offset);
-			request->extension.data_buffer.pfn_array[i] =
+			request->data_buffer.pfn_array[i] =
 				page_to_pfn(sg_page((&sgl[i])));
 		}
 	} else if (scsi_sglist(scmnd)) {
 		/* ASSERT(scsi_bufflen(scmnd) <= PAGE_SIZE); */
-		request->extension.data_buffer.offset =
+		request->data_buffer.offset =
 			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
-		request->extension.data_buffer.pfn_array[0] =
+		request->data_buffer.pfn_array[0] =
 			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
 	}
 
-- 
1.7.4.1

