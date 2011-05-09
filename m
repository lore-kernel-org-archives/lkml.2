Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab1EIV7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:59:37 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47484
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754926Ab1EIVos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 056/206] Staging: hv: Get rid of the forward declaration of storvsc_queuecommand()
Date: Mon,  9 May 2011 14:55:38 -0700
Message-Id: <1304978288-22999-56-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration by moving the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |  338 +++++++++++++++++++-------------------
 1 files changed, 169 insertions(+), 169 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index d10e533..4d4226a 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -597,9 +597,177 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 	kmem_cache_free(host_dev->request_pool, cmd_request);
 }
 
+
+/*
+ * storvsc_queuecommand - Initiate command processing
+ */
+static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
+				void (*done)(struct scsi_cmnd *))
+{
+	int ret;
+	struct hv_host_device *host_dev =
+		(struct hv_host_device *)scmnd->device->host->hostdata;
+	struct hv_device *dev = host_dev->dev;
+	struct storvsc_driver *storvsc_drv_obj =
+		drv_to_stordrv(dev->device.driver);
+	struct hv_storvsc_request *request;
+	struct storvsc_cmd_request *cmd_request;
+	unsigned int request_size = 0;
+	int i;
+	struct scatterlist *sgl;
+	unsigned int sg_count = 0;
+	struct vmscsi_request *vm_srb;
+
+
+	/* If retrying, no need to prep the cmd */
+	if (scmnd->host_scribble) {
+		/* ASSERT(scmnd->scsi_done != NULL); */
+
+		cmd_request =
+			(struct storvsc_cmd_request *)scmnd->host_scribble;
+		DPRINT_INFO(STORVSC_DRV, "retrying scmnd %p cmd_request %p",
+			    scmnd, cmd_request);
+
+		goto retry_request;
+	}
+
+	/* ASSERT(scmnd->scsi_done == NULL); */
+	/* ASSERT(scmnd->host_scribble == NULL); */
+
+	scmnd->scsi_done = done;
+
+	request_size = sizeof(struct storvsc_cmd_request);
+
+	cmd_request = kmem_cache_zalloc(host_dev->request_pool,
+				       GFP_ATOMIC);
+	if (!cmd_request) {
+		scmnd->scsi_done = NULL;
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+	}
+
+	/* Setup the cmd request */
+	cmd_request->bounce_sgl_count = 0;
+	cmd_request->bounce_sgl = NULL;
+	cmd_request->cmd = scmnd;
+
+	scmnd->host_scribble = (unsigned char *)cmd_request;
+
+	request = &cmd_request->request;
+	vm_srb = &request->vstor_packet.vm_srb;
+
+
+	/* Build the SRB */
+	switch (scmnd->sc_data_direction) {
+	case DMA_TO_DEVICE:
+		vm_srb->data_in = WRITE_TYPE;
+		break;
+	case DMA_FROM_DEVICE:
+		vm_srb->data_in = READ_TYPE;
+		break;
+	default:
+		vm_srb->data_in = UNKNOWN_TYPE;
+		break;
+	}
+
+	request->on_io_completion = storvsc_commmand_completion;
+	request->context = cmd_request;/* scmnd; */
+
+	/* request->PortId = scmnd->device->channel; */
+	vm_srb->port_number = host_dev->port;
+	vm_srb->path_id = scmnd->device->channel;
+	vm_srb->target_id = scmnd->device->id;
+	vm_srb->lun = scmnd->device->lun;
+
+	/* ASSERT(scmnd->cmd_len <= 16); */
+	vm_srb->cdb_length = scmnd->cmd_len;
+
+	memcpy(vm_srb->cdb, scmnd->cmnd, vm_srb->cdb_length);
+
+	request->sense_buffer = scmnd->sense_buffer;
+
+
+	request->data_buffer.len = scsi_bufflen(scmnd);
+	if (scsi_sg_count(scmnd)) {
+		sgl = (struct scatterlist *)scsi_sglist(scmnd);
+		sg_count = scsi_sg_count(scmnd);
+
+		/* check if we need to bounce the sgl */
+		if (do_bounce_buffer(sgl, scsi_sg_count(scmnd)) != -1) {
+			cmd_request->bounce_sgl =
+				create_bounce_buffer(sgl, scsi_sg_count(scmnd),
+						     scsi_bufflen(scmnd));
+			if (!cmd_request->bounce_sgl) {
+				scmnd->scsi_done = NULL;
+				scmnd->host_scribble = NULL;
+				kmem_cache_free(host_dev->request_pool,
+						cmd_request);
+
+				return SCSI_MLQUEUE_HOST_BUSY;
+			}
+
+			cmd_request->bounce_sgl_count =
+				ALIGN(scsi_bufflen(scmnd), PAGE_SIZE) >>
+					PAGE_SHIFT;
+
+			/*
+			 * FIXME: We can optimize on reads by just skipping
+			 * this
+			 */
+			copy_to_bounce_buffer(sgl, cmd_request->bounce_sgl,
+					      scsi_sg_count(scmnd));
+
+			sgl = cmd_request->bounce_sgl;
+			sg_count = cmd_request->bounce_sgl_count;
+		}
+
+		request->data_buffer.offset = sgl[0].offset;
+
+		for (i = 0; i < sg_count; i++)
+			request->data_buffer.pfn_array[i] =
+				page_to_pfn(sg_page((&sgl[i])));
+
+	} else if (scsi_sglist(scmnd)) {
+		/* ASSERT(scsi_bufflen(scmnd) <= PAGE_SIZE); */
+		request->data_buffer.offset =
+			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
+		request->data_buffer.pfn_array[0] =
+			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
+	}
+
+retry_request:
+	/* Invokes the vsc to start an IO */
+	ret = storvsc_drv_obj->on_io_request(dev,
+					   &cmd_request->request);
+	if (ret == -1) {
+		/* no more space */
+
+		if (cmd_request->bounce_sgl_count) {
+			/*
+			 * FIXME: We can optimize on writes by just skipping
+			 * this
+			 */
+			copy_from_bounce_buffer(scsi_sglist(scmnd),
+						cmd_request->bounce_sgl,
+						scsi_sg_count(scmnd));
+			destroy_bounce_buffer(cmd_request->bounce_sgl,
+					      cmd_request->bounce_sgl_count);
+		}
+
+		kmem_cache_free(host_dev->request_pool, cmd_request);
+
+		scmnd->scsi_done = NULL;
+		scmnd->host_scribble = NULL;
+
+		ret = SCSI_MLQUEUE_DEVICE_BUSY;
+	}
+
+	return ret;
+}
+
+static DEF_SCSI_QCMD(storvsc_queuecommand)
+
 /* Static decl */
 static int storvsc_probe(struct hv_device *dev);
-static int storvsc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd);
 
 /* The one and only one */
 static struct storvsc_driver g_storvsc_drv;
@@ -776,174 +944,6 @@ static int storvsc_probe(struct hv_device *device)
 	return ret;
 }
 
-/*
- * storvsc_queuecommand - Initiate command processing
- */
-static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
-				void (*done)(struct scsi_cmnd *))
-{
-	int ret;
-	struct hv_host_device *host_dev =
-		(struct hv_host_device *)scmnd->device->host->hostdata;
-	struct hv_device *dev = host_dev->dev;
-	struct storvsc_driver *storvsc_drv_obj =
-		drv_to_stordrv(dev->device.driver);
-	struct hv_storvsc_request *request;
-	struct storvsc_cmd_request *cmd_request;
-	unsigned int request_size = 0;
-	int i;
-	struct scatterlist *sgl;
-	unsigned int sg_count = 0;
-	struct vmscsi_request *vm_srb;
-
-
-	/* If retrying, no need to prep the cmd */
-	if (scmnd->host_scribble) {
-		/* ASSERT(scmnd->scsi_done != NULL); */
-
-		cmd_request =
-			(struct storvsc_cmd_request *)scmnd->host_scribble;
-		DPRINT_INFO(STORVSC_DRV, "retrying scmnd %p cmd_request %p",
-			    scmnd, cmd_request);
-
-		goto retry_request;
-	}
-
-	/* ASSERT(scmnd->scsi_done == NULL); */
-	/* ASSERT(scmnd->host_scribble == NULL); */
-
-	scmnd->scsi_done = done;
-
-	request_size = sizeof(struct storvsc_cmd_request);
-
-	cmd_request = kmem_cache_zalloc(host_dev->request_pool,
-				       GFP_ATOMIC);
-	if (!cmd_request) {
-		scmnd->scsi_done = NULL;
-		return SCSI_MLQUEUE_DEVICE_BUSY;
-	}
-
-	/* Setup the cmd request */
-	cmd_request->bounce_sgl_count = 0;
-	cmd_request->bounce_sgl = NULL;
-	cmd_request->cmd = scmnd;
-
-	scmnd->host_scribble = (unsigned char *)cmd_request;
-
-	request = &cmd_request->request;
-	vm_srb = &request->vstor_packet.vm_srb;
-
-
-	/* Build the SRB */
-	switch (scmnd->sc_data_direction) {
-	case DMA_TO_DEVICE:
-		vm_srb->data_in = WRITE_TYPE;
-		break;
-	case DMA_FROM_DEVICE:
-		vm_srb->data_in = READ_TYPE;
-		break;
-	default:
-		vm_srb->data_in = UNKNOWN_TYPE;
-		break;
-	}
-
-	request->on_io_completion = storvsc_commmand_completion;
-	request->context = cmd_request;/* scmnd; */
-
-	/* request->PortId = scmnd->device->channel; */
-	vm_srb->port_number = host_dev->port;
-	vm_srb->path_id = scmnd->device->channel;
-	vm_srb->target_id = scmnd->device->id;
-	vm_srb->lun = scmnd->device->lun;
-
-	/* ASSERT(scmnd->cmd_len <= 16); */
-	vm_srb->cdb_length = scmnd->cmd_len;
-
-	memcpy(vm_srb->cdb, scmnd->cmnd, vm_srb->cdb_length);
-
-	request->sense_buffer = scmnd->sense_buffer;
-
-
-	request->data_buffer.len = scsi_bufflen(scmnd);
-	if (scsi_sg_count(scmnd)) {
-		sgl = (struct scatterlist *)scsi_sglist(scmnd);
-		sg_count = scsi_sg_count(scmnd);
-
-		/* check if we need to bounce the sgl */
-		if (do_bounce_buffer(sgl, scsi_sg_count(scmnd)) != -1) {
-			cmd_request->bounce_sgl =
-				create_bounce_buffer(sgl, scsi_sg_count(scmnd),
-						     scsi_bufflen(scmnd));
-			if (!cmd_request->bounce_sgl) {
-				scmnd->scsi_done = NULL;
-				scmnd->host_scribble = NULL;
-				kmem_cache_free(host_dev->request_pool,
-						cmd_request);
-
-				return SCSI_MLQUEUE_HOST_BUSY;
-			}
-
-			cmd_request->bounce_sgl_count =
-				ALIGN(scsi_bufflen(scmnd), PAGE_SIZE) >>
-					PAGE_SHIFT;
-
-			/*
-			 * FIXME: We can optimize on reads by just skipping
-			 * this
-			 */
-			copy_to_bounce_buffer(sgl, cmd_request->bounce_sgl,
-					      scsi_sg_count(scmnd));
-
-			sgl = cmd_request->bounce_sgl;
-			sg_count = cmd_request->bounce_sgl_count;
-		}
-
-		request->data_buffer.offset = sgl[0].offset;
-
-		for (i = 0; i < sg_count; i++)
-			request->data_buffer.pfn_array[i] =
-				page_to_pfn(sg_page((&sgl[i])));
-
-	} else if (scsi_sglist(scmnd)) {
-		/* ASSERT(scsi_bufflen(scmnd) <= PAGE_SIZE); */
-		request->data_buffer.offset =
-			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
-		request->data_buffer.pfn_array[0] =
-			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
-	}
-
-retry_request:
-	/* Invokes the vsc to start an IO */
-	ret = storvsc_drv_obj->on_io_request(dev,
-					   &cmd_request->request);
-	if (ret == -1) {
-		/* no more space */
-
-		if (cmd_request->bounce_sgl_count) {
-			/*
-			 * FIXME: We can optimize on writes by just skipping
-			 * this
-			 */
-			copy_from_bounce_buffer(scsi_sglist(scmnd),
-						cmd_request->bounce_sgl,
-						scsi_sg_count(scmnd));
-			destroy_bounce_buffer(cmd_request->bounce_sgl,
-					      cmd_request->bounce_sgl_count);
-		}
-
-		kmem_cache_free(host_dev->request_pool, cmd_request);
-
-		scmnd->scsi_done = NULL;
-		scmnd->host_scribble = NULL;
-
-		ret = SCSI_MLQUEUE_DEVICE_BUSY;
-	}
-
-	return ret;
-}
-
-static DEF_SCSI_QCMD(storvsc_queuecommand)
-
 static int __init storvsc_init(void)
 {
 	int ret;
-- 
1.7.4.1

