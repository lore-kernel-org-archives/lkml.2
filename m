Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1C1QYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:24:55 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47494
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754790Ab1C1QXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:23:05 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 02/20] Staging: hv: Embed struct storvsc_request_extension into hv_storvsc_request
Date: Mon, 28 Mar 2011 09:33:27 -0700
Message-Id: <1301330025-25542-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301330025-25542-1-git-send-email-kys@microsoft.com>
References: <1301329950-25490-1-git-send-email-kys@microsoft.com>
 <1301330025-25542-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Embed struct storvsc_request_extension into hv_storvsc_request.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    8 --------
 drivers/staging/hv/storvsc.c     |    3 +--
 drivers/staging/hv/storvsc_api.h |    3 +--
 drivers/staging/hv/storvsc_drv.c |    6 ------
 4 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 824080d..9ceaa99 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -84,12 +84,6 @@ struct blkvsc_request {
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 
 	struct hv_storvsc_request request;
-	/*
-	 * !!!DO NOT ADD ANYTHING BELOW HERE!!! Otherwise, memory can overlap,
-	 * because - The extension buffer falls right here and is pointed to by
-	 * request.Extension;
-	 * Which sounds like a horrible idea, who designed this?
-	 */
 };
 
 /* Per device structure */
@@ -942,8 +936,6 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 #endif
 
 	storvsc_req = &blkvsc_req->request;
-	storvsc_req->extension = (void *)((unsigned long)blkvsc_req +
-					  sizeof(struct blkvsc_request));
 
 	storvsc_req->type = blkvsc_req->write ? WRITE_TYPE : READ_TYPE;
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 6801e37..5cea331 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -533,8 +533,7 @@ int stor_vsc_on_io_request(struct hv_device *device,
 	struct vstor_packet *vstor_packet;
 	int ret = 0;
 
-	request_extension =
-		(struct storvsc_request_extension *)request->extension;
+	request_extension = &request->extension;
 	vstor_packet = &request_extension->vstor_packet;
 	stor_device = get_stor_device(device);
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 800ebbf..e41b68b 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -83,8 +83,7 @@ struct hv_storvsc_request {
 
 	void (*on_io_completion)(struct hv_storvsc_request *request);
 
-	/* This points to the memory after DataBuffer */
-	void *extension;
+	struct storvsc_request_extension extension;
 
 	struct hv_multipage_buffer data_buffer;
 };
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 127d122..58d12e0 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -69,10 +69,6 @@ struct storvsc_cmd_request {
 	struct scatterlist *bounce_sgl;
 
 	struct hv_storvsc_request request;
-	/* !!!DO NOT ADD ANYTHING BELOW HERE!!! */
-	/* The extension buffer falls right here and is pointed to by
-	 * request.Extension;
-	 * Which sounds like a very bad design... */
 };
 
 
@@ -763,8 +759,6 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 	request = &cmd_request->request;
 
-	request->extension =
-		(void *)((unsigned long)cmd_request + request_size);
 	DPRINT_DBG(STORVSC_DRV, "req %p size %d ext %d", request, request_size,
 		   storvsc_drv_obj->request_ext_size);
 
-- 
1.7.4.1

