Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab1C1QsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:48:15 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:58075
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752979Ab1C1QsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:48:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 06/20] Staging: hv: Get rid of the type field from struct hv_storvsc_request
Date: Mon, 28 Mar 2011 09:33:31 -0700
Message-Id: <1301330025-25542-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301330025-25542-1-git-send-email-kys@microsoft.com>
References: <1301329950-25490-1-git-send-email-kys@microsoft.com>
 <1301330025-25542-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for consolidating all I/O request state, get rid of the
type field from struct hv_storvsc_request and instead use the
equivalent  state in struct vmscsi_request - data_in field.
In the current code there is a call to zero out the struct vstor_packet in
stor_vsc_on_io_request(). So, to be able to directly set the state in the
vstor_packet in blkvsc_drv.c and storvsc_drv.c, get rid of the call to
zero out the packet in stor_vsc_on_io_request() and instead allocate the 
request structure that has been zeroed out. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |   18 +++++++++++-------
 drivers/staging/hv/storvsc.c     |    3 ---
 drivers/staging/hv/storvsc_api.h |    1 -
 drivers/staging/hv/storvsc_drv.c |    8 +++++---
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 1e5320e..00bc226 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -510,7 +510,7 @@ static int blkvsc_do_flush(struct block_device_context *blkdev)
 	if (blkdev->device_type != HARDDISK_TYPE)
 		return 0;
 
-	blkvsc_req = kmem_cache_alloc(blkdev->request_pool, GFP_KERNEL);
+	blkvsc_req = kmem_cache_zalloc(blkdev->request_pool, GFP_KERNEL);
 	if (!blkvsc_req)
 		return -ENOMEM;
 
@@ -551,7 +551,7 @@ static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_inquiry()\n");
 
-	blkvsc_req = kmem_cache_alloc(blkdev->request_pool, GFP_KERNEL);
+	blkvsc_req = kmem_cache_zalloc(blkdev->request_pool, GFP_KERNEL);
 	if (!blkvsc_req)
 		return -ENOMEM;
 
@@ -638,7 +638,7 @@ static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
 	blkdev->capacity = 0;
 	blkdev->media_not_present = 0; /* assume a disk is present */
 
-	blkvsc_req = kmem_cache_alloc(blkdev->request_pool, GFP_KERNEL);
+	blkvsc_req = kmem_cache_zalloc(blkdev->request_pool, GFP_KERNEL);
 	if (!blkvsc_req)
 		return -ENOMEM;
 
@@ -715,7 +715,7 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 	blkdev->capacity = 0;
 	blkdev->media_not_present = 0; /* assume a disk is present */
 
-	blkvsc_req = kmem_cache_alloc(blkdev->request_pool, GFP_KERNEL);
+	blkvsc_req = kmem_cache_zalloc(blkdev->request_pool, GFP_KERNEL);
 	if (!blkvsc_req)
 		return -ENOMEM;
 
@@ -913,6 +913,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	struct storvsc_driver_object *storvsc_drv_obj =
 			drv->priv;
 	struct hv_storvsc_request *storvsc_req;
+	struct vmscsi_request *vm_srb;
 	int ret;
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
@@ -933,8 +934,9 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 #endif
 
 	storvsc_req = &blkvsc_req->request;
+	vm_srb = &storvsc_req->extension.vstor_packet.vm_srb;
 
-	storvsc_req->type = blkvsc_req->write ? WRITE_TYPE : READ_TYPE;
+	vm_srb->data_in = blkvsc_req->write ? WRITE_TYPE : READ_TYPE;
 
 	storvsc_req->on_io_completion = request_completion;
 	storvsc_req->context = blkvsc_req;
@@ -983,7 +985,7 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 		  (unsigned long)blk_rq_pos(req));
 
 	/* Create a group to tie req to list of blkvsc_reqs */
-	group = kmem_cache_alloc(blkdev->request_pool, GFP_ATOMIC);
+	group = kmem_cache_zalloc(blkdev->request_pool, GFP_ATOMIC);
 	if (!group)
 		return -ENOMEM;
 
@@ -1026,7 +1028,9 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 					 * Create new blkvsc_req to represent
 					 * the current bvec
 					 */
-					blkvsc_req = kmem_cache_alloc(blkdev->request_pool, GFP_ATOMIC);
+					blkvsc_req =
+					kmem_cache_zalloc(
+					blkdev->request_pool, GFP_ATOMIC);
 					if (!blkvsc_req) {
 						/* free up everything */
 						list_for_each_entry_safe(
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 8dc17b9..b580c30 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -545,8 +545,6 @@ int stor_vsc_on_io_request(struct hv_device *device,
 	request_extension->request = request;
 	request_extension->device  = device;
 
-	memset(vstor_packet, 0 , sizeof(struct vstor_packet));
-
 	vstor_packet->flags |= REQUEST_COMPLETION_FLAG;
 
 	vstor_packet->vm_srb.length = sizeof(struct vmscsi_request);
@@ -562,7 +560,6 @@ int stor_vsc_on_io_request(struct hv_device *device,
 	vstor_packet->vm_srb.cdb_length = request->cdb_len;
 	memcpy(&vstor_packet->vm_srb.cdb, request->cdb, request->cdb_len);
 
-	vstor_packet->vm_srb.data_in = request->type;
 	vstor_packet->vm_srb.data_transfer_length = request->data_buffer.len;
 
 	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index cdef1c7..27781f4 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -66,7 +66,6 @@ struct storvsc_request_extension {
 };
 
 struct hv_storvsc_request {
-	enum storvsc_request_type type;
 	u32 host;
 	u32 bus;
 	u32 target_id;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index c2a3a5b..b08423b 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -709,6 +709,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	int i;
 	struct scatterlist *sgl;
 	unsigned int sg_count = 0;
+	struct vmscsi_request *vm_srb;
 
 	DPRINT_DBG(STORVSC_DRV, "scmnd %p dir %d, use_sg %d buf %p len %d "
 		   "queue depth %d tagged %d", scmnd, scmnd->sc_data_direction,
@@ -752,19 +753,20 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	scmnd->host_scribble = (unsigned char *)cmd_request;
 
 	request = &cmd_request->request;
+	vm_srb = &request->extension.vstor_packet.vm_srb;
 
 	DPRINT_DBG(STORVSC_DRV, "req %p size %d", request, request_size);
 
 	/* Build the SRB */
 	switch (scmnd->sc_data_direction) {
 	case DMA_TO_DEVICE:
-		request->type = WRITE_TYPE;
+		vm_srb->data_in = WRITE_TYPE;
 		break;
 	case DMA_FROM_DEVICE:
-		request->type = READ_TYPE;
+		vm_srb->data_in = READ_TYPE;
 		break;
 	default:
-		request->type = UNKNOWN_TYPE;
+		vm_srb->data_in = UNKNOWN_TYPE;
 		break;
 	}
 
-- 
1.7.4.1

