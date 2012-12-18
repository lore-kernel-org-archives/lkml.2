Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2LRMdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:33:20 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:61747 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2LRMdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:33:18 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gaowanlong@cn.fujitsu.com, hutao@cn.fujitsu.com,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        mst@redhat.com, rusty@rustcorp.com.au, asias@redhat.com,
        stefanha@redhat.com, nab@linux-iscsi.org
Subject: [PATCH v2 2/5] virtio-scsi: use functions for piecewise composition of buffers
Date: Tue, 18 Dec 2012 13:32:49 +0100
Message-Id: <1355833972-20319-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the new virtio_scsi_add_sg function lets us simplify the queueing
path.  In particular, all data protected by the tgt_lock is just gone
(multiqueue will find a new use for the lock).

The speedup is relatively small (2-4%) but it is worthwhile because of
the code simplification---both in this patches and in the next ones.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: new

 drivers/scsi/virtio_scsi.c |   94 +++++++++++++++++++------------------------
 1 files changed, 42 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 74ab67a..2b93b6e 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -59,11 +59,8 @@ struct virtio_scsi_vq {
 
 /* Per-target queue state */
 struct virtio_scsi_target_state {
-	/* Protects sg.  Lock hierarchy is tgt_lock -> vq_lock.  */
+	/* Never held at the same time as vq_lock.  */
 	spinlock_t tgt_lock;
-
-	/* For sglist construction when adding commands to the virtqueue.  */
-	struct scatterlist sg[];
 };
 
 /* Driver instance state */
@@ -351,57 +348,58 @@ static void virtscsi_event_done(struct virtqueue *vq)
 	spin_unlock_irqrestore(&vscsi->event_vq.vq_lock, flags);
 };
 
-static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
-			     struct scsi_data_buffer *sdb)
-{
-	struct sg_table *table = &sdb->table;
-	struct scatterlist *sg_elem;
-	unsigned int idx = *p_idx;
-	int i;
-
-	for_each_sg(table->sgl, sg_elem, table->nents, i)
-		sg[idx++] = *sg_elem;
-
-	*p_idx = idx;
-}
-
 /**
- * virtscsi_map_cmd - map a scsi_cmd to a virtqueue scatterlist
+ * virtscsi_add_cmd - add a virtio_scsi_cmd to a virtqueue
  * @vscsi	: virtio_scsi state
  * @cmd		: command structure
- * @out_num	: number of read-only elements
- * @in_num	: number of write-only elements
  * @req_size	: size of the request buffer
  * @resp_size	: size of the response buffer
- *
- * Called with tgt_lock held.
+ * @gfp	: flags to use for memory allocations
  */
-static void virtscsi_map_cmd(struct virtio_scsi_target_state *tgt,
-			     struct virtio_scsi_cmd *cmd,
-			     unsigned *out_num, unsigned *in_num,
-			     size_t req_size, size_t resp_size)
+static int virtscsi_add_cmd(struct virtqueue *vq,
+			    struct virtio_scsi_cmd *cmd,
+			    size_t req_size, size_t resp_size, gfp_t gfp)
 {
 	struct scsi_cmnd *sc = cmd->sc;
-	struct scatterlist *sg = tgt->sg;
-	unsigned int idx = 0;
+	struct scatterlist sg;
+	unsigned int count, count_sg;
+	struct sg_table *out, *in;
+	struct virtqueue_buf buf;
+	int ret;
+
+	out = in = NULL;
+
+	if (sc && sc->sc_data_direction != DMA_NONE) {
+		if (sc->sc_data_direction != DMA_FROM_DEVICE)
+			out = &scsi_out(sc)->table;
+		if (sc->sc_data_direction != DMA_TO_DEVICE)
+			in = &scsi_in(sc)->table;
+	}
+
+	count_sg = 2 + (out ? 1 : 0)          + (in ? 1 : 0);
+	count    = 2 + (out ? out->nents : 0) + (in ? in->nents : 0);
+	ret = virtqueue_start_buf(vq, &buf, cmd, count, count_sg, gfp);
+	if (ret < 0)
+		return ret;
 
 	/* Request header.  */
-	sg_set_buf(&sg[idx++], &cmd->req, req_size);
+	sg_init_one(&sg, &cmd->req, req_size);
+	virtqueue_add_sg(&buf, &sg, 1, DMA_TO_DEVICE);
 
 	/* Data-out buffer.  */
-	if (sc && sc->sc_data_direction != DMA_FROM_DEVICE)
-		virtscsi_map_sgl(sg, &idx, scsi_out(sc));
-
-	*out_num = idx;
+	if (out)
+		virtqueue_add_sg(&buf, out->sgl, out->nents, DMA_TO_DEVICE);
 
 	/* Response header.  */
-	sg_set_buf(&sg[idx++], &cmd->resp, resp_size);
+	sg_init_one(&sg, &cmd->resp, resp_size);
+	virtqueue_add_sg(&buf, &sg, 1, DMA_FROM_DEVICE);
 
 	/* Data-in buffer */
-	if (sc && sc->sc_data_direction != DMA_TO_DEVICE)
-		virtscsi_map_sgl(sg, &idx, scsi_in(sc));
+	if (in)
+		virtqueue_add_sg(&buf, in->sgl, in->nents, DMA_FROM_DEVICE);
 
-	*in_num = idx - *out_num;
+	virtqueue_end_buf(&buf);
+	return 0;
 }
 
 static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
@@ -409,25 +407,20 @@ static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
 			     struct virtio_scsi_cmd *cmd,
 			     size_t req_size, size_t resp_size, gfp_t gfp)
 {
-	unsigned int out_num, in_num;
 	unsigned long flags;
-	int err;
+	int ret;
 	bool needs_kick = false;
 
-	spin_lock_irqsave(&tgt->tgt_lock, flags);
-	virtscsi_map_cmd(tgt, cmd, &out_num, &in_num, req_size, resp_size);
-
-	spin_lock(&vq->vq_lock);
-	err = virtqueue_add_buf(vq->vq, tgt->sg, out_num, in_num, cmd, gfp);
-	spin_unlock(&tgt->tgt_lock);
-	if (!err)
+	spin_lock_irqsave(&vq->vq_lock, flags);
+	ret = virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size, gfp);
+	if (!ret)
 		needs_kick = virtqueue_kick_prepare(vq->vq);
 
 	spin_unlock_irqrestore(&vq->vq_lock, flags);
 
 	if (needs_kick)
 		virtqueue_notify(vq->vq);
-	return err;
+	return ret;
 }
 
 static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
@@ -592,14 +585,11 @@ static struct virtio_scsi_target_state *virtscsi_alloc_tgt(
 	gfp_t gfp_mask = GFP_KERNEL;
 
 	/* We need extra sg elements at head and tail.  */
-	tgt = kmalloc(sizeof(*tgt) + sizeof(tgt->sg[0]) * (sg_elems + 2),
-		      gfp_mask);
-
+	tgt = kmalloc(sizeof(*tgt), gfp_mask);
 	if (!tgt)
 		return NULL;
 
 	spin_lock_init(&tgt->tgt_lock);
-	sg_init_table(tgt->sg, sg_elems + 2);
 	return tgt;
 }
 
-- 
1.7.1


