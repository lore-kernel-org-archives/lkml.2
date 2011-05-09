Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab1EIWBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:01:34 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54183
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754908Ab1EIVor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:47 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 055/206] Staging: hv: Move the function storvsc_commmand_completion() to earlier in the file
Date: Mon,  9 May 2011 14:55:37 -0700
Message-Id: <1304978288-22999-55-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |  115 +++++++++++++++++++-------------------
 1 files changed, 58 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 0d9ce56..d10e533 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -539,6 +539,64 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	return ret;
 }
 
+
+/*
+ * storvsc_commmand_completion - Command completion processing
+ */
+static void storvsc_commmand_completion(struct hv_storvsc_request *request)
+{
+	struct storvsc_cmd_request *cmd_request =
+		(struct storvsc_cmd_request *)request->context;
+	struct scsi_cmnd *scmnd = cmd_request->cmd;
+	struct hv_host_device *host_dev =
+		(struct hv_host_device *)scmnd->device->host->hostdata;
+	void (*scsi_done_fn)(struct scsi_cmnd *);
+	struct scsi_sense_hdr sense_hdr;
+	struct vmscsi_request *vm_srb;
+
+	/* ASSERT(request == &cmd_request->request); */
+	/* ASSERT(scmnd); */
+	/* ASSERT((unsigned long)scmnd->host_scribble == */
+	/*        (unsigned long)cmd_request); */
+	/* ASSERT(scmnd->scsi_done); */
+
+	if (cmd_request->bounce_sgl_count) {
+		/* using bounce buffer */
+		/* printk("copy_from_bounce_buffer\n"); */
+
+		/* FIXME: We can optimize on writes by just skipping this */
+		copy_from_bounce_buffer(scsi_sglist(scmnd),
+					cmd_request->bounce_sgl,
+					scsi_sg_count(scmnd));
+		destroy_bounce_buffer(cmd_request->bounce_sgl,
+				      cmd_request->bounce_sgl_count);
+	}
+
+	vm_srb = &request->vstor_packet.vm_srb;
+	scmnd->result = vm_srb->scsi_status;
+
+	if (scmnd->result) {
+		if (scsi_normalize_sense(scmnd->sense_buffer,
+				SCSI_SENSE_BUFFERSIZE, &sense_hdr))
+			scsi_print_sense_hdr("storvsc", &sense_hdr);
+	}
+
+	/* ASSERT(request->BytesXfer <= request->data_buffer.Length); */
+	scsi_set_resid(scmnd,
+		request->data_buffer.len -
+		vm_srb->data_transfer_length);
+
+	scsi_done_fn = scmnd->scsi_done;
+
+	scmnd->host_scribble = NULL;
+	scmnd->scsi_done = NULL;
+
+	/* !!DO NOT MODIFY the scmnd after this call */
+	scsi_done_fn(scmnd);
+
+	kmem_cache_free(host_dev->request_pool, cmd_request);
+}
+
 /* Static decl */
 static int storvsc_probe(struct hv_device *dev);
 static int storvsc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd);
@@ -719,63 +777,6 @@ static int storvsc_probe(struct hv_device *device)
 }
 
 /*
- * storvsc_commmand_completion - Command completion processing
- */
-static void storvsc_commmand_completion(struct hv_storvsc_request *request)
-{
-	struct storvsc_cmd_request *cmd_request =
-		(struct storvsc_cmd_request *)request->context;
-	struct scsi_cmnd *scmnd = cmd_request->cmd;
-	struct hv_host_device *host_dev =
-		(struct hv_host_device *)scmnd->device->host->hostdata;
-	void (*scsi_done_fn)(struct scsi_cmnd *);
-	struct scsi_sense_hdr sense_hdr;
-	struct vmscsi_request *vm_srb;
-
-	/* ASSERT(request == &cmd_request->request); */
-	/* ASSERT(scmnd); */
-	/* ASSERT((unsigned long)scmnd->host_scribble == */
-	/*        (unsigned long)cmd_request); */
-	/* ASSERT(scmnd->scsi_done); */
-
-	if (cmd_request->bounce_sgl_count) {
-		/* using bounce buffer */
-		/* printk("copy_from_bounce_buffer\n"); */
-
-		/* FIXME: We can optimize on writes by just skipping this */
-		copy_from_bounce_buffer(scsi_sglist(scmnd),
-					cmd_request->bounce_sgl,
-					scsi_sg_count(scmnd));
-		destroy_bounce_buffer(cmd_request->bounce_sgl,
-				      cmd_request->bounce_sgl_count);
-	}
-
-	vm_srb = &request->vstor_packet.vm_srb;
-	scmnd->result = vm_srb->scsi_status;
-
-	if (scmnd->result) {
-		if (scsi_normalize_sense(scmnd->sense_buffer,
-				SCSI_SENSE_BUFFERSIZE, &sense_hdr))
-			scsi_print_sense_hdr("storvsc", &sense_hdr);
-	}
-
-	/* ASSERT(request->BytesXfer <= request->data_buffer.Length); */
-	scsi_set_resid(scmnd,
-		request->data_buffer.len -
-		vm_srb->data_transfer_length);
-
-	scsi_done_fn = scmnd->scsi_done;
-
-	scmnd->host_scribble = NULL;
-	scmnd->scsi_done = NULL;
-
-	/* !!DO NOT MODIFY the scmnd after this call */
-	scsi_done_fn(scmnd);
-
-	kmem_cache_free(host_dev->request_pool, cmd_request);
-}
-
-/*
  * storvsc_queuecommand - Initiate command processing
  */
 static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
-- 
1.7.4.1

