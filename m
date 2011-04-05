Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1DENyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:54:06 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42429
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752909Ab1DENxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:53:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 16/22] Staging: hv: Move the context field from struct hv_storvsc_request
Date: Tue,  5 Apr 2011 07:05:00 -0700
Message-Id: <1302012306-21277-16-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302012306-21277-1-git-send-email-kys@microsoft.com>
References: <1302012261-21236-1-git-send-email-kys@microsoft.com>
 <1302012306-21277-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of consolidating all I/O request state, move
the context field from struct hv_storvsc_request to
struct storvsc_request_extension.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    6 +++---
 drivers/staging/hv/storvsc_api.h |    3 +--
 drivers/staging/hv/storvsc_drv.c |    4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index be7fae5..83c4ba3 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -939,7 +939,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	vm_srb->data_in = blkvsc_req->write ? WRITE_TYPE : READ_TYPE;
 
 	storvsc_req->on_io_completion = request_completion;
-	storvsc_req->context = blkvsc_req;
+	storvsc_req->extension.context = blkvsc_req;
 
 	vm_srb->port_number = blkdev->port;
 	vm_srb->path_id = blkdev->path;
@@ -1136,7 +1136,7 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 {
 	struct blkvsc_request *blkvsc_req =
-			(struct blkvsc_request *)request->context;
+			(struct blkvsc_request *)request->extension.context;
 	struct block_device_context *blkdev =
 			(struct block_device_context *)blkvsc_req->dev;
 	struct scsi_sense_hdr sense_hdr;
@@ -1158,7 +1158,7 @@ static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 static void blkvsc_request_completion(struct hv_storvsc_request *request)
 {
 	struct blkvsc_request *blkvsc_req =
-			(struct blkvsc_request *)request->context;
+			(struct blkvsc_request *)request->extension.context;
 	struct block_device_context *blkdev =
 			(struct block_device_context *)blkvsc_req->dev;
 	unsigned long flags;
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index fd9165f..68c5036 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -63,6 +63,7 @@ struct storvsc_request_extension {
 	struct completion wait_event;
 
 	unsigned char *sense_buffer;
+	void *context;
 
 	struct vstor_packet vstor_packet;
 };
@@ -71,8 +72,6 @@ struct hv_storvsc_request {
 	u32 status;
 	u32 bytes_xfer;
 
-	void *context;
-
 	void (*on_io_completion)(struct hv_storvsc_request *request);
 
 	struct storvsc_request_extension extension;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index df98476..e0e349e 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -448,7 +448,7 @@ static int storvsc_remove(struct device *device)
 static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 {
 	struct storvsc_cmd_request *cmd_request =
-		(struct storvsc_cmd_request *)request->context;
+		(struct storvsc_cmd_request *)request->extension.context;
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
 	struct host_device_context *host_device_ctx =
 		(struct host_device_context *)scmnd->device->host->hostdata;
@@ -771,7 +771,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	}
 
 	request->on_io_completion = storvsc_commmand_completion;
-	request->context = cmd_request;/* scmnd; */
+	request->extension.context = cmd_request;/* scmnd; */
 
 	/* request->PortId = scmnd->device->channel; */
 	vm_srb->port_number = host_device_ctx->port;
-- 
1.7.4.1

