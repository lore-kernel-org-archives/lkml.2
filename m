Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1DENyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:54:05 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42421
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752904Ab1DENxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:53:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 11/22] Staging: hv: Get rid of lun_id from struct hv_storvsc_request 
Date: Tue,  5 Apr 2011 07:04:55 -0700
Message-Id: <1302012306-21277-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302012306-21277-1-git-send-email-kys@microsoft.com>
References: <1302012261-21236-1-git-send-email-kys@microsoft.com>
 <1302012306-21277-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for consolidating all I/O request state, get rid of the
lun_id field from struct hv_storvsc_request and instead use the
equivalent  state in struct vmscsi_request - lun field.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc.c     |    5 ++---
 drivers/staging/hv/storvsc_api.h |    1 -
 drivers/staging/hv/storvsc_drv.c |    2 +-
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index ec01662..f440734 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -944,7 +944,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	vm_srb->port_number = blkdev->port;
 	vm_srb->path_id = blkdev->path;
 	vm_srb->target_id = blkdev->target;
-	storvsc_req->lun_id = 0;	 /* this is not really used at all */
+	vm_srb->lun = 0;	 /* this is not really used at all */
 
 	storvsc_req->cdb_len = blkvsc_req->cmd_len;
 	storvsc_req->cdb = blkvsc_req->cmnd;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 6083cdb..c7d0620 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -531,9 +531,9 @@ int stor_vsc_on_io_request(struct hv_device *device,
 		   "Extension %p", device, stor_device, request,
 		   request_extension);
 
-	DPRINT_DBG(STORVSC, "req %p len %d lun %d cdblen %d",
+	DPRINT_DBG(STORVSC, "req %p len %d cdblen %d",
 		   request, request->data_buffer.len,
-		   request->lun_id, request->cdb_len);
+		   request->cdb_len);
 
 	if (!stor_device) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
@@ -550,7 +550,6 @@ int stor_vsc_on_io_request(struct hv_device *device,
 
 	vstor_packet->vm_srb.length = sizeof(struct vmscsi_request);
 
-	vstor_packet->vm_srb.lun = request->lun_id;
 
 	vstor_packet->vm_srb.sense_info_length = SENSE_BUFFER_SIZE;
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 54690ad..940cf98 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -66,7 +66,6 @@ struct storvsc_request_extension {
 };
 
 struct hv_storvsc_request {
-	u32 lun_id;
 	u8 *cdb;
 	u32 cdb_len;
 	u32 status;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index aa8496c..1340b13 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -777,7 +777,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	vm_srb->port_number = host_device_ctx->port;
 	vm_srb->path_id = scmnd->device->channel;
 	vm_srb->target_id = scmnd->device->id;
-	request->lun_id = scmnd->device->lun;
+	vm_srb->lun = scmnd->device->lun;
 
 	/* ASSERT(scmnd->cmd_len <= 16); */
 	request->cdb_len = scmnd->cmd_len;
-- 
1.7.4.1

