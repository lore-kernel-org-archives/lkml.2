Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab1DEN5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:57:12 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42436
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752933Ab1DENxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:53:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 15/22] Staging: hv: Move sense_buffer field
Date: Tue,  5 Apr 2011 07:04:59 -0700
Message-Id: <1302012306-21277-15-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302012306-21277-1-git-send-email-kys@microsoft.com>
References: <1302012261-21236-1-git-send-email-kys@microsoft.com>
 <1302012306-21277-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for consolidating all I/O request state,
move sense_buffer field from struct hv_storvsc_request
to struct storvsc_request_extension.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc.c     |    2 +-
 drivers/staging/hv/storvsc_api.h |    4 ++--
 drivers/staging/hv/storvsc_drv.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 04117be..be7fae5 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -950,7 +950,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 
 	memcpy(vm_srb->cdb, blkvsc_req->cmnd, vm_srb->cdb_length);
 
-	storvsc_req->sense_buffer = blkvsc_req->sense_buffer;
+	storvsc_req->extension.sense_buffer = blkvsc_req->sense_buffer;
 
 	ret = storvsc_drv_obj->on_io_request(blkdev->device_ctx,
 					   &blkvsc_req->request);
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index e12a760..e0d635f 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -314,7 +314,7 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 				    "valid - len %d\n", request_ext,
 				    vstor_packet->vm_srb.sense_info_length);
 
-			memcpy(request->sense_buffer,
+			memcpy(request->extension.sense_buffer,
 			       vstor_packet->vm_srb.sense_data,
 			       vstor_packet->vm_srb.sense_info_length);
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 3eccc27..fd9165f 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -62,6 +62,8 @@ struct storvsc_request_extension {
 	/* Synchronize the request/response if needed */
 	struct completion wait_event;
 
+	unsigned char *sense_buffer;
+
 	struct vstor_packet vstor_packet;
 };
 
@@ -69,8 +71,6 @@ struct hv_storvsc_request {
 	u32 status;
 	u32 bytes_xfer;
 
-	unsigned char *sense_buffer;
-
 	void *context;
 
 	void (*on_io_completion)(struct hv_storvsc_request *request);
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 22709a2..df98476 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -784,7 +784,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 	memcpy(vm_srb->cdb, scmnd->cmnd, vm_srb->cdb_length);
 
-	request->sense_buffer = scmnd->sense_buffer;
+	request->extension.sense_buffer = scmnd->sense_buffer;
 
 
 	request->data_buffer.len = scsi_bufflen(scmnd);
-- 
1.7.4.1

