Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1C1QZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:25:46 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47419
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754778Ab1C1QXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:23:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 16/20] Staging: hv: Move on_io_completion() from struct hv_storvsc_request
Date: Mon, 28 Mar 2011 09:33:41 -0700
Message-Id: <1301330025-25542-16-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301330025-25542-1-git-send-email-kys@microsoft.com>
References: <1301329950-25490-1-git-send-email-kys@microsoft.com>
 <1301330025-25542-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of consolidating all I/O request state, move
the on_io_completion() field from struct hv_storvsc_request to
struct storvsc_request_extension.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc.c     |    2 +-
 drivers/staging/hv/storvsc_api.h |    2 +-
 drivers/staging/hv/storvsc_drv.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 83c4ba3..0e3b193 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -938,7 +938,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 
 	vm_srb->data_in = blkvsc_req->write ? WRITE_TYPE : READ_TYPE;
 
-	storvsc_req->on_io_completion = request_completion;
+	storvsc_req->extension.on_io_completion = request_completion;
 	storvsc_req->extension.context = blkvsc_req;
 
 	vm_srb->port_number = blkdev->port;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 33943ed..d444cc9 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -324,7 +324,7 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 	/* TODO: */
 	request->bytes_xfer = vstor_packet->vm_srb.data_transfer_length;
 
-	request->on_io_completion(request);
+	request->extension.on_io_completion(request);
 
 	atomic_dec(&stor_device->num_outstanding_req);
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 68c5036..89fa155 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -64,6 +64,7 @@ struct storvsc_request_extension {
 
 	unsigned char *sense_buffer;
 	void *context;
+	void (*on_io_completion)(struct hv_storvsc_request *request);
 
 	struct vstor_packet vstor_packet;
 };
@@ -72,7 +73,6 @@ struct hv_storvsc_request {
 	u32 status;
 	u32 bytes_xfer;
 
-	void (*on_io_completion)(struct hv_storvsc_request *request);
 
 	struct storvsc_request_extension extension;
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 65e03e6..e3e0486 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -770,7 +770,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 		break;
 	}
 
-	request->on_io_completion = storvsc_commmand_completion;
+	request->extension.on_io_completion = storvsc_commmand_completion;
 	request->extension.context = cmd_request;/* scmnd; */
 
 	/* request->PortId = scmnd->device->channel; */
-- 
1.7.4.1

