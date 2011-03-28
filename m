Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1C1QXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:23:09 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:55153
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754077Ab1C1QXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:23:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 12/20] Staging: hv: Get rid of cdb from struct hv_storvsc_request
Date: Mon, 28 Mar 2011 09:33:37 -0700
Message-Id: <1301330025-25542-12-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301330025-25542-1-git-send-email-kys@microsoft.com>
References: <1301329950-25490-1-git-send-email-kys@microsoft.com>
 <1301330025-25542-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for consolidating all I/O request state, get rid of the
cdb field from struct hv_storvsc_request and instead
directly copy the command into struct vmscsi_request.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    3 ++-
 drivers/staging/hv/storvsc.c     |    6 ++----
 drivers/staging/hv/storvsc_api.h |    1 -
 drivers/staging/hv/storvsc_drv.c |    3 ++-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 3db622d..a156930 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -947,7 +947,8 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	vm_srb->lun = 0;	 /* this is not really used at all */
 
 	vm_srb->cdb_length = blkvsc_req->cmd_len;
-	storvsc_req->cdb = blkvsc_req->cmnd;
+
+	memcpy(vm_srb->cdb, blkvsc_req->cmnd, vm_srb->cdb_length);
 
 	storvsc_req->sense_buffer = blkvsc_req->sense_buffer;
 	storvsc_req->sense_buffer_size = SCSI_SENSE_BUFFERSIZE;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 5a5065c..ca41c05 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -301,7 +301,8 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 	if (request->status != 0 || vstor_packet->vm_srb.srb_status != 1) {
 		DPRINT_WARN(STORVSC,
 			    "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
-			    request->cdb[0], vstor_packet->vm_srb.scsi_status,
+			    vstor_packet->vm_srb.cdb[0],
+			    vstor_packet->vm_srb.scsi_status,
 			    vstor_packet->vm_srb.srb_status);
 	}
 
@@ -551,9 +552,6 @@ int stor_vsc_on_io_request(struct hv_device *device,
 
 	vstor_packet->vm_srb.sense_info_length = SENSE_BUFFER_SIZE;
 
-	/* Copy over the scsi command descriptor block */
-	memcpy(&vstor_packet->vm_srb.cdb, request->cdb,
-		 vstor_packet->vm_srb.cdb_length);
 
 	vstor_packet->vm_srb.data_transfer_length = request->data_buffer.len;
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index fd3af2b..55c5cc6 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -66,7 +66,6 @@ struct storvsc_request_extension {
 };
 
 struct hv_storvsc_request {
-	u8 *cdb;
 	u32 status;
 	u32 bytes_xfer;
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index c0ccae2..08c2df4 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -781,7 +781,8 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 	/* ASSERT(scmnd->cmd_len <= 16); */
 	vm_srb->cdb_length = scmnd->cmd_len;
-	request->cdb = scmnd->cmnd;
+
+	memcpy(vm_srb->cdb, scmnd->cmnd, vm_srb->cdb_length);
 
 	request->sense_buffer = scmnd->sense_buffer;
 	request->sense_buffer_size = SCSI_SENSE_BUFFERSIZE;
-- 
1.7.4.1

