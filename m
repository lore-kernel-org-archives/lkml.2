Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1DENx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:53:59 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42404
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752870Ab1DENxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:53:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 07/22] Staging: hv: Get rid of the type field from struct hv_storvsc_request
Date: Tue,  5 Apr 2011 07:04:51 -0700
Message-Id: <1302012306-21277-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302012306-21277-1-git-send-email-kys@microsoft.com>
References: <1302012261-21236-1-git-send-email-kys@microsoft.com>
 <1302012306-21277-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for consolidating all I/O request state, get rid of the
type field from struct hv_storvsc_request and instead use the
equivalent  state in struct vmscsi_request - data_in field.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    4 +++-
 drivers/staging/hv/storvsc.c     |    1 -
 drivers/staging/hv/storvsc_api.h |    1 -
 drivers/staging/hv/storvsc_drv.c |    8 +++++---
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 2661356..00bc226 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
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
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index e02622d..c1faf46 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -561,7 +561,6 @@ int stor_vsc_on_io_request(struct hv_device *device,
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
index fd1416d..9df723c 100644
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

