Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1K3Nzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:55:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab1K3Nzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:55:36 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH 2/2] virtio-scsi: add error handling
Date: Wed, 30 Nov 2011 14:54:59 +0100
Message-Id: <1322661299-28855-3-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1322661299-28855-1-git-send-email-pbonzini@redhat.com>
References: <1322661299-28855-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds basic error handling to the virtio-scsi
HBA device.  Task management functions are sent synchronously
via the control virtqueue.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |   75 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 74 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index cf8732f..35ab0ef 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -36,6 +36,7 @@ static void dbg(const char *fmt, ...)
 /* Command queue element */
 struct virtio_scsi_cmd {
 	struct scsi_cmnd *sc;
+	struct completion *comp;
 	union {
 		struct virtio_scsi_cmd_req       cmd;
 		struct virtio_scsi_ctrl_tmf_req  tmf;
@@ -172,11 +173,12 @@ static void virtscsi_cmd_done(struct virtqueue *vq)
 	virtscsi_vq_done(vq, virtscsi_complete_cmd);
 };
 
-/* These are still stubs.  */
 static void virtscsi_complete_free(void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
 
+	if (cmd->comp)
+		complete_all(cmd->comp);
 	kmem_cache_free(virtscsi_cmd_cache, cmd);
 }
 
@@ -306,12 +308,83 @@ out:
 	return ret;
 }
 
+static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
+{
+	DECLARE_COMPLETION_ONSTACK(comp);
+	int ret;
+
+	cmd->comp = &comp;
+	ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd);
+	if (ret < 0)
+		return FAILED;
+
+	wait_for_completion(&comp);
+	if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
+	    cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
+		return FAILED;
+
+	return SUCCESS;
+}
+
+static int virtscsi_device_reset(struct scsi_cmnd *sc)
+{
+	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
+	struct virtio_scsi_cmd *cmd;
+
+	dbg("%s %d:%d:%d:%d got device reset", __func__,
+		sc->device->host->host_no, sc->device->id,
+		sc->device->channel, sc->device->lun);
+
+	cmd = kmem_cache_zalloc(virtscsi_cmd_cache, GFP_ATOMIC);
+	if (!cmd)
+		return FAILED;
+
+	cmd->sc = sc;
+	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
+		.type = VIRTIO_SCSI_T_TMF,
+		.subtype = VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET,
+		.lun[0] = 1,
+		.lun[1] = sc->device->id,
+		.lun[2] = (sc->device->lun >> 8) | 0x40,
+		.lun[3] = sc->device->lun & 0xff,
+	};
+	return virtscsi_tmf(vscsi, cmd);
+}
+
+static int virtscsi_abort(struct scsi_cmnd *sc)
+{
+	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
+	struct virtio_scsi_cmd *cmd;
+
+	dbg("%s %d:%d:%d:%d got abort", __func__,
+		sc->device->host->host_no, sc->device->id,
+		sc->device->channel, sc->device->lun);
+
+	cmd = kmem_cache_zalloc(virtscsi_cmd_cache, GFP_ATOMIC);
+	if (!cmd)
+		return FAILED;
+
+	cmd->sc = sc;
+	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
+		.type = VIRTIO_SCSI_T_TMF,
+		.subtype = VIRTIO_SCSI_T_TMF_ABORT_TASK,
+		.lun[0] = 1,
+		.lun[1] = sc->device->id,
+		.lun[2] = (sc->device->lun >> 8) | 0x40,
+		.lun[3] = sc->device->lun & 0xff,
+		.tag = (__u64)sc,
+	};
+	return virtscsi_tmf(vscsi, cmd);
+}
+
 static struct scsi_host_template virtscsi_host_template = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
 	.proc_name = "virtio_scsi",
 	.queuecommand = virtscsi_queuecommand,
 	.this_id = -1,
+	.eh_abort_handler               = virtscsi_abort,
+	.eh_device_reset_handler        = virtscsi_device_reset,
 
 	.can_queue = 1024,
 	.max_sectors = 0xFFFF,
-- 
1.7.7.1

