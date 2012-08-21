Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2HUI2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:28:13 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:55879 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab2HUI2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:28:09 -0400
From: Cong Meng <mc@linux.vnet.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com, zwanp@cn.ibm.com,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, Cong Meng <mc@linux.vnet.ibm.com>
Subject: [PATCH v1] virtio-scsi: get and set the queue limits for sg device
Date: Tue, 21 Aug 2012 16:26:49 +0800
Message-Id: <1345537609-21676-1-git-send-email-mc@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
x-cbid: 12082108-0342-0000-0000-0000029E23A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each virtio scsi HBA has global request queue limits. But the passthrough
LUNs (scsi-generic) come from different host HBAs may have different request
queue limits. If the guest sends commands that exceed the host limits, the
commands will be rejected by host HAB. 

This patch addresses this issue by getting the per-LUN queue limits via the the
newly added virtio control request, then setting them properly.

Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
---
 drivers/scsi/virtio_scsi.c  |  113 +++++++++++++++++++++++++++++++++++++------
 include/linux/virtio_scsi.h |   18 +++++++
 2 files changed, 116 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 173cb39..ec5066f 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -35,12 +35,14 @@ struct virtio_scsi_cmd {
 		struct virtio_scsi_cmd_req       cmd;
 		struct virtio_scsi_ctrl_tmf_req  tmf;
 		struct virtio_scsi_ctrl_an_req   an;
+		struct virtio_scsi_ctrl_lq_req   lq;
 	} req;
 	union {
 		struct virtio_scsi_cmd_resp      cmd;
 		struct virtio_scsi_ctrl_tmf_resp tmf;
 		struct virtio_scsi_ctrl_an_resp  an;
 		struct virtio_scsi_event         evt;
+		struct virtio_scsi_ctrl_lq_resp  lq;
 	} resp;
 } ____cacheline_aligned_in_smp;
 
@@ -469,6 +471,46 @@ out:
 	return ret;
 }
 
+static u32 virtscsi_lun_query(struct scsi_device *sdev, u32 *value, u32 subtype)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct virtio_scsi *vscsi = shost_priv(shost);
+	DECLARE_COMPLETION_ONSTACK(comp);
+	struct virtio_scsi_cmd *cmd;
+	struct virtio_scsi_target_state *tgt = vscsi->tgt[sdev->id];
+	unsigned int ret = VIRTIO_SCSI_S_FAILURE;
+
+	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_ATOMIC);
+	if (!cmd)
+		goto out;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->comp = &comp;
+	cmd->req.lq = (struct virtio_scsi_ctrl_lq_req){
+		.type = VIRTIO_SCSI_T_LUN_QUERY,
+		.subtype = subtype,
+		.lun[0] = 1,
+		.lun[1] = sdev->id,
+		.lun[2] = (sdev->lun >> 8) | 0x40,
+		.lun[3] = sdev->lun & 0xff,
+	};
+
+	if (virtscsi_kick_cmd(tgt, &vscsi->ctrl_vq, cmd, sizeof cmd->req.lq,
+				sizeof cmd->resp.lq, GFP_NOIO) < 0) {
+		goto out;
+	}
+
+	wait_for_completion(&comp);
+
+	ret = cmd->resp.lq.response;
+	if (ret == VIRTIO_SCSI_S_OK) {
+		*value = cmd->resp.lq.value;
+	}
+out:
+	mempool_free(cmd, virtscsi_cmd_pool);
+	return ret;
+}
+
 static int virtscsi_device_reset(struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
@@ -516,20 +558,6 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 	return virtscsi_tmf(vscsi, cmd);
 }
 
-static struct scsi_host_template virtscsi_host_template = {
-	.module = THIS_MODULE,
-	.name = "Virtio SCSI HBA",
-	.proc_name = "virtio_scsi",
-	.queuecommand = virtscsi_queuecommand,
-	.this_id = -1,
-	.eh_abort_handler = virtscsi_abort,
-	.eh_device_reset_handler = virtscsi_device_reset,
-
-	.can_queue = 1024,
-	.dma_boundary = UINT_MAX,
-	.use_clustering = ENABLE_CLUSTERING,
-};
-
 #define virtscsi_config_get(vdev, fld) \
 	({ \
 		typeof(((struct virtio_scsi_config *)0)->fld) __val; \
@@ -547,6 +575,60 @@ static struct scsi_host_template virtscsi_host_template = {
 				  &__val, sizeof(__val)); \
 	})
 
+static u32 virtscsi_max_sectors(struct scsi_device *sdev, u32 *value)
+{
+	return virtscsi_lun_query(sdev, value, VIRTIO_SCSI_T_LQ_MAX_SECTORS);
+}
+
+static u32 virtscsi_max_segments(struct scsi_device *sdev, u32 *value)
+{
+	return virtscsi_lun_query(sdev, value, VIRTIO_SCSI_T_LQ_MAX_SEGMENTS);
+}
+
+static u32 virtscsi_max_segment_size(struct scsi_device *sdev, u32 *value)
+{
+	return virtscsi_lun_query(sdev, value, VIRTIO_SCSI_T_LQ_MAX_SEGMENT_SIZE);
+}
+
+static int virtscsi_slave_alloc(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct virtio_scsi *vscsi = shost_priv(shost);
+	struct virtio_device *vdev = vscsi->vdev;
+	struct request_queue *q = sdev->request_queue;
+	unsigned int max_sectors, max_segments, max_segment_size;
+
+	if (!virtio_has_feature(vdev, VIRTIO_SCSI_F_LUN_QUERY))
+		goto out;
+
+	if (virtscsi_max_sectors(sdev, &max_sectors) ||
+	    virtscsi_max_segments(sdev, &max_segments) ||
+	    virtscsi_max_segment_size(sdev, &max_segment_size)) {
+		goto out;
+	}
+
+	blk_queue_max_hw_sectors(q, max_sectors);
+	blk_queue_max_segments(q, max_segments - 2);
+	blk_queue_max_segment_size(q, max_segment_size);
+out:
+	return 0;
+}
+
+static struct scsi_host_template virtscsi_host_template = {
+	.module = THIS_MODULE,
+	.name = "Virtio SCSI HBA",
+	.proc_name = "virtio_scsi",
+	.queuecommand = virtscsi_queuecommand,
+	.slave_alloc = virtscsi_slave_alloc,
+	.this_id = -1,
+	.eh_abort_handler = virtscsi_abort,
+	.eh_device_reset_handler = virtscsi_device_reset,
+
+	.can_queue = 1024,
+	.dma_boundary = UINT_MAX,
+	.use_clustering = ENABLE_CLUSTERING,
+};
+
 static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
 			     struct virtqueue *vq)
 {
@@ -728,7 +810,8 @@ static struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
-	VIRTIO_SCSI_F_HOTPLUG
+	VIRTIO_SCSI_F_HOTPLUG,
+	VIRTIO_SCSI_F_LUN_QUERY
 };
 
 static struct virtio_driver virtio_scsi_driver = {
diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index dc8d305..c14c3ee 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -50,6 +50,17 @@ struct virtio_scsi_ctrl_an_resp {
 	u8 response;
 } __packed;
 
+struct virtio_scsi_ctrl_lq_req {
+	u32 type;
+	u8 lun[8];
+	u32 subtype;
+} __packed;
+
+struct virtio_scsi_ctrl_lq_resp {
+	u32 response;
+	u32 value;
+} __packed;
+
 struct virtio_scsi_event {
 	u32 event;
 	u8 lun[8];
@@ -72,6 +83,7 @@ struct virtio_scsi_config {
 /* Feature Bits */
 #define VIRTIO_SCSI_F_INOUT                    0
 #define VIRTIO_SCSI_F_HOTPLUG                  1
+#define VIRTIO_SCSI_F_LUN_QUERY                3
 
 /* Response codes */
 #define VIRTIO_SCSI_S_OK                       0
@@ -92,6 +104,7 @@ struct virtio_scsi_config {
 #define VIRTIO_SCSI_T_TMF                      0
 #define VIRTIO_SCSI_T_AN_QUERY                 1
 #define VIRTIO_SCSI_T_AN_SUBSCRIBE             2
+#define VIRTIO_SCSI_T_LUN_QUERY                3
 
 /* Valid TMF subtypes.  */
 #define VIRTIO_SCSI_T_TMF_ABORT_TASK           0
@@ -103,6 +116,11 @@ struct virtio_scsi_config {
 #define VIRTIO_SCSI_T_TMF_QUERY_TASK           6
 #define VIRTIO_SCSI_T_TMF_QUERY_TASK_SET       7
 
+/* LUN Query */
+#define VIRTIO_SCSI_T_LQ_MAX_SECTORS           0
+#define VIRTIO_SCSI_T_LQ_MAX_SEGMENTS          1
+#define VIRTIO_SCSI_T_LQ_MAX_SEGMENT_SIZE      2
+
 /* Events.  */
 #define VIRTIO_SCSI_T_EVENTS_MISSED            0x80000000
 #define VIRTIO_SCSI_T_NO_EVENT                 0
-- 
1.7.7.6

