Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1C1QXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:23:07 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:55145
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752761Ab1C1QXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:23:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 11/20] Staging: hv: Get rid of the cdb_len from struct hv_storvsc_request
Date: Mon, 28 Mar 2011 09:33:36 -0700
Message-Id: <1301330025-25542-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301330025-25542-1-git-send-email-kys@microsoft.com>
References: <1301329950-25490-1-git-send-email-kys@microsoft.com>
 <1301330025-25542-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for consolidating all I/O request state, get rid of the
cdb_len field from struct hv_storvsc_request and instead use the
equivalent  state in struct vmscsi_request - cdb_length field.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc.c     |    9 ++++-----
 drivers/staging/hv/storvsc_api.h |    1 -
 drivers/staging/hv/storvsc_drv.c |    2 +-
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index f440734..3db622d 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -946,7 +946,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	vm_srb->target_id = blkdev->target;
 	vm_srb->lun = 0;	 /* this is not really used at all */
 
-	storvsc_req->cdb_len = blkvsc_req->cmd_len;
+	vm_srb->cdb_length = blkvsc_req->cmd_len;
 	storvsc_req->cdb = blkvsc_req->cmnd;
 
 	storvsc_req->sense_buffer = blkvsc_req->sense_buffer;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 849b467..5a5065c 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -531,9 +531,8 @@ int stor_vsc_on_io_request(struct hv_device *device,
 		   "Extension %p", device, stor_device, request,
 		   request_extension);
 
-	DPRINT_DBG(STORVSC, "req %p len %d cdblen %d",
-		   request, request->data_buffer.len,
-		   request->cdb_len);
+	DPRINT_DBG(STORVSC, "req %p len %d",
+		   request, request->data_buffer.len);
 
 	if (!stor_device) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
@@ -553,8 +552,8 @@ int stor_vsc_on_io_request(struct hv_device *device,
 	vstor_packet->vm_srb.sense_info_length = SENSE_BUFFER_SIZE;
 
 	/* Copy over the scsi command descriptor block */
-	vstor_packet->vm_srb.cdb_length = request->cdb_len;
-	memcpy(&vstor_packet->vm_srb.cdb, request->cdb, request->cdb_len);
+	memcpy(&vstor_packet->vm_srb.cdb, request->cdb,
+		 vstor_packet->vm_srb.cdb_length);
 
 	vstor_packet->vm_srb.data_transfer_length = request->data_buffer.len;
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 940cf98..fd3af2b 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -67,7 +67,6 @@ struct storvsc_request_extension {
 
 struct hv_storvsc_request {
 	u8 *cdb;
-	u32 cdb_len;
 	u32 status;
 	u32 bytes_xfer;
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index d30d745..c0ccae2 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -780,7 +780,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	vm_srb->lun = scmnd->device->lun;
 
 	/* ASSERT(scmnd->cmd_len <= 16); */
-	request->cdb_len = scmnd->cmd_len;
+	vm_srb->cdb_length = scmnd->cmd_len;
 	request->cdb = scmnd->cmnd;
 
 	request->sense_buffer = scmnd->sense_buffer;
-- 
1.7.4.1

