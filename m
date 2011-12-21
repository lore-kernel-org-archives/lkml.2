Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1LUBBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:01:55 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:51566 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab1LUBB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:01:26 -0500
From: Minchan Kim <minchan@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan@redhat.com>
Subject: [PATCH 4/6] virtio-blk: implement ->make_request
Date: Wed, 21 Dec 2011 10:00:52 +0900
Message-Id: <1324429254-28383-5-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1324429254-28383-1-git-send-email-minchan@kernel.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change I/O path from request-based to bio-based for virtio-blk.

This is required for high IOPs devices which get slowed down to 1/5th of
the native speed by all the locking, memory allocation and other overhead
in the request based I/O path.

But it still supports request-based IO path for scsi ioctl but it's just
used for ioctl, not file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Minchan Kim <minchan@redhat.com>
---
 drivers/block/virtio_blk.c |  303 ++++++++++++++++++++++++++++++++++++--------
 1 files changed, 247 insertions(+), 56 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 26d4443..4e476d6 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -12,6 +12,7 @@
 #include <linux/idr.h>
 
 #define PART_BITS 4
+static int use_make_request = 1;
 
 static int major;
 static DEFINE_IDA(vd_index_ida);
@@ -24,6 +25,7 @@ struct virtio_blk
 
 	struct virtio_device *vdev;
 	struct virtqueue *vq;
+	wait_queue_head_t queue_wait;
 
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
@@ -38,61 +40,124 @@ struct virtio_blk
 
 	/* Ida index - used to track minor number allocations. */
 	int index;
-
-	/* Scatterlist: can be too big for stack. */
-	struct scatterlist sg[/*sg_elems*/];
 };
 
 struct virtblk_req
 {
-	struct request *req;
+	void *private;
+	struct virtblk_req *next;
+
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
+	u8 kind;
+#define VIRTIO_BLK_REQUEST	0x00
+#define VIRTIO_BLK_BIO		0x01
 	u8 status;
+
+	struct scatterlist sg[];
 };
 
+static struct virtblk_req *alloc_virtblk_req(struct virtio_blk *vblk,
+		gfp_t gfp_mask)
+{
+	struct virtblk_req *vbr;
+
+	vbr = mempool_alloc(vblk->pool, gfp_mask);
+	if (vbr)
+		sg_init_table(vbr->sg, vblk->sg_elems);
+
+	return vbr;
+}
+
+static inline int virtblk_result(struct virtblk_req *vbr)
+{
+	switch (vbr->status) {
+	case VIRTIO_BLK_S_OK:
+		return 0;
+	case VIRTIO_BLK_S_UNSUPP:
+		return -ENOTTY;
+	default:
+		return -EIO;
+	}
+}
+
+static void virtblk_request_done(struct virtio_blk *vblk,
+		struct virtblk_req *vbr)
+{
+	struct request *req = vbr->private;
+	int error = virtblk_result(vbr);
+
+	if (req->cmd_type == REQ_TYPE_BLOCK_PC) {
+		req->resid_len = vbr->in_hdr.residual;
+		req->sense_len = vbr->in_hdr.sense_len;
+		req->errors = vbr->in_hdr.errors;
+	}
+	else if (req->cmd_type == REQ_TYPE_SPECIAL) {
+		printk("REQ_TYPE_SPECIAL done\n");
+		req->errors = (error != 0);
+	}
+
+	__blk_end_request_all(req, error);
+	mempool_free(vbr, vblk->pool);
+}
+
+static void virtblk_bio_done(struct virtio_blk *vblk,
+		struct virtblk_req *vbr)
+{
+	bio_endio(vbr->private, virtblk_result(vbr));
+	mempool_free(vbr, vblk->pool);
+}
+
 static void blk_done(struct virtqueue *vq)
 {
 	struct virtio_blk *vblk = vq->vdev->priv;
-	struct virtblk_req *vbr;
+	struct virtblk_req *vbr, *head = NULL, *tail = NULL;
 	unsigned int len;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vblk->lock, flags);
 	while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
-		int error;
-
-		switch (vbr->status) {
-		case VIRTIO_BLK_S_OK:
-			error = 0;
+		switch (vbr->kind) {
+		case VIRTIO_BLK_REQUEST:
+			virtblk_request_done(vblk, vbr);
+			/*
+			 * In case queue is stopped waiting
+			 * for more buffers.
+			 */
+        		blk_start_queue(vblk->disk->queue);
 			break;
-		case VIRTIO_BLK_S_UNSUPP:
-			error = -ENOTTY;
+		case VIRTIO_BLK_BIO:
+			if (head) {
+				tail->next = vbr;
+				tail = vbr;
+			} else {
+				tail = head = vbr;
+			}
 			break;
 		default:
-			error = -EIO;
-			break;
+			BUG();
 		}
 
-		switch (vbr->req->cmd_type) {
-		case REQ_TYPE_BLOCK_PC:
-			vbr->req->resid_len = vbr->in_hdr.residual;
-			vbr->req->sense_len = vbr->in_hdr.sense_len;
-			vbr->req->errors = vbr->in_hdr.errors;
-			break;
-		case REQ_TYPE_SPECIAL:
-			vbr->req->errors = (error != 0);
+	}
+
+	spin_unlock_irqrestore(&vblk->lock, flags);
+	wake_up(&vblk->queue_wait);
+	/*
+	 * Process completions after freeing up space in the virtqueue and
+	 * dropping the lock.
+	 */
+	while (head) {
+		vbr = head;
+		head = head->next;
+
+		switch (vbr->kind) {
+		case VIRTIO_BLK_BIO:
+			virtblk_bio_done(vblk, vbr);
 			break;
 		default:
-			break;
+			BUG();
 		}
-
-		__blk_end_request_all(vbr->req, error);
-		mempool_free(vbr, vblk->pool);
 	}
-	/* In case queue is stopped waiting for more buffers. */
-	blk_start_queue(vblk->disk->queue);
-	spin_unlock_irqrestore(&vblk->lock, flags);
 }
 
 static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
@@ -101,33 +166,29 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 	unsigned long num, out = 0, in = 0;
 	struct virtblk_req *vbr;
 
-	vbr = mempool_alloc(vblk->pool, GFP_ATOMIC);
+	vbr = alloc_virtblk_req(vblk, GFP_ATOMIC);
 	if (!vbr)
-		/* When another request finishes we'll try again. */
 		return false;
 
-	vbr->req = req;
+	vbr->private = req;
+	vbr->next = NULL;
+	vbr->kind = VIRTIO_BLK_REQUEST;
 
 	if (req->cmd_flags & REQ_FLUSH) {
 		vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
 		vbr->out_hdr.sector = 0;
-		vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+		vbr->out_hdr.ioprio = req_get_ioprio(req);
 	} else {
 		switch (req->cmd_type) {
-		case REQ_TYPE_FS:
-			vbr->out_hdr.type = 0;
-			vbr->out_hdr.sector = blk_rq_pos(vbr->req);
-			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
-			break;
 		case REQ_TYPE_BLOCK_PC:
 			vbr->out_hdr.type = VIRTIO_BLK_T_SCSI_CMD;
 			vbr->out_hdr.sector = 0;
-			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+			vbr->out_hdr.ioprio = req_get_ioprio(req);
 			break;
 		case REQ_TYPE_SPECIAL:
 			vbr->out_hdr.type = VIRTIO_BLK_T_GET_ID;
 			vbr->out_hdr.sector = 0;
-			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+			vbr->out_hdr.ioprio = req_get_ioprio(req);
 			break;
 		default:
 			/* We don't put anything else in the queue. */
@@ -135,7 +196,7 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		}
 	}
 
-	sg_set_buf(&vblk->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
+	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
 
 	/*
 	 * If this is a packet command we need a couple of additional headers.
@@ -143,22 +204,23 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 	 * block, and before the normal inhdr we put the sense data and the
 	 * inhdr with additional status information before the normal inhdr.
 	 */
-	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC)
-		sg_set_buf(&vblk->sg[out++], vbr->req->cmd, vbr->req->cmd_len);
+	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
+		sg_set_buf(&vbr->sg[out++], req->cmd, req->cmd_len);
 
-	num = blk_rq_map_sg(q, vbr->req, vblk->sg + out);
+	num = blk_rq_map_sg(q, req, vbr->sg + out);
 
-	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC) {
-		sg_set_buf(&vblk->sg[num + out + in++], vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
-		sg_set_buf(&vblk->sg[num + out + in++], &vbr->in_hdr,
+	if (req->cmd_type == REQ_TYPE_BLOCK_PC) {
+		sg_set_buf(&vbr->sg[num + out + in++], req->sense,
+			   SCSI_SENSE_BUFFERSIZE);
+		sg_set_buf(&vbr->sg[num + out + in++], &vbr->in_hdr,
 			   sizeof(vbr->in_hdr));
 	}
 
-	sg_set_buf(&vblk->sg[num + out + in++], &vbr->status,
+	sg_set_buf(&vbr->sg[num + out + in++], &vbr->status,
 		   sizeof(vbr->status));
 
 	if (num) {
-		if (rq_data_dir(vbr->req) == WRITE) {
+		if (rq_data_dir(req) == WRITE) {
 			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
 			out += num;
 		} else {
@@ -167,7 +229,7 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		}
 	}
 
-	if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr) < 0) {
+	if (virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr) < 0) {
 		mempool_free(vbr, vblk->pool);
 		return false;
 	}
@@ -198,6 +260,133 @@ static void do_virtblk_request(struct request_queue *q)
 		virtqueue_kick(vblk->vq);
 }
 
+struct virtblk_plug_cb {
+	struct blk_plug_cb cb;
+	struct virtio_blk *vblk;
+};
+
+static void virtblk_unplug(struct blk_plug_cb *bcb)
+{
+	struct virtblk_plug_cb *cb =
+		container_of(bcb, struct virtblk_plug_cb, cb);
+
+	virtqueue_notify(cb->vblk->vq);
+	kfree(cb);
+}
+
+static bool virtblk_plugged(struct virtio_blk *vblk)
+{
+	struct blk_plug *plug = current->plug;
+	struct virtblk_plug_cb *cb;
+
+	if (!plug)
+		return false;
+
+	list_for_each_entry(cb, &plug->cb_list, cb.list) {
+		if (cb->cb.callback == virtblk_unplug && cb->vblk == vblk)
+			return true;
+	}
+
+	/* Not currently on the callback list */
+	cb = kmalloc(sizeof(*cb), GFP_ATOMIC);
+	if (!cb)
+		return false;
+
+	cb->vblk = vblk;
+	cb->cb.callback = virtblk_unplug;
+	list_add(&cb->cb.list, &plug->cb_list);
+	return true;
+}
+
+static void virtblk_add_buf_wait(struct virtio_blk *vblk,
+	struct virtblk_req *vbr, unsigned long out, unsigned long in)
+{
+	DEFINE_WAIT(wait);
+	bool retry, notify;
+
+	for (;;) {
+		prepare_to_wait(&vblk->queue_wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+
+		spin_lock_irq(&vblk->lock);
+		if (virtqueue_add_buf(vblk->vq, vbr->sg,
+			out, in, vbr) < 0) {
+			retry = true;
+		} else {
+			retry = false;
+		}
+		notify = virtqueue_kick_prepare(vblk->vq);
+		spin_unlock_irq(&vblk->lock);
+
+		if (notify)
+			virtqueue_notify(vblk->vq);
+
+		if (!retry)
+			break;
+		schedule();
+	}
+	finish_wait(&vblk->queue_wait, &wait);
+}
+
+static void virtblk_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct virtio_blk *vblk = q->queuedata;
+	unsigned long num, out = 0, in = 0;
+	struct virtblk_req *vbr;
+	bool retry, notify;
+
+	BUG_ON(bio->bi_phys_segments + 2 > vblk->sg_elems);
+	BUG_ON(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
+
+	vbr = alloc_virtblk_req(vblk, GFP_NOIO);
+	if (!vbr) {
+		bio_endio(bio, -ENOMEM);
+		return;
+	}
+
+	vbr->private = bio;
+	vbr->next = NULL;
+	vbr->kind = VIRTIO_BLK_BIO;
+
+	vbr->out_hdr.type = 0;
+	vbr->out_hdr.sector = bio->bi_sector;
+	vbr->out_hdr.ioprio = bio_prio(bio);
+
+	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
+
+	num = bio_map_sg(q, bio, vbr->sg + out);
+
+	sg_set_buf(&vbr->sg[num + out + in++], &vbr->status,
+		   sizeof(vbr->status));
+
+	if (num) {
+		if (bio->bi_rw & REQ_WRITE) {
+			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
+			out += num;
+		} else {
+			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
+			in += num;
+		}
+	}
+
+	spin_lock_irq(&vblk->lock);
+	if (virtqueue_add_buf(vblk->vq, vbr->sg,
+		out, in, vbr) < 0) {
+		retry = true;
+	} else {
+		retry = false;
+	}
+
+	notify = virtqueue_kick_prepare(vblk->vq);
+	spin_unlock_irq(&vblk->lock);
+
+	if (notify && !virtblk_plugged(vblk))
+		virtqueue_notify(vblk->vq);
+
+	if (retry)
+		virtblk_add_buf_wait(vblk, vbr, out, in);
+}
+
 /* return id (s/n) string for *disk to *id_str
  */
 static int virtblk_get_id(struct gendisk *disk, char *id_str)
@@ -208,7 +397,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	int err;
 
 	bio = bio_map_kern(vblk->disk->queue, id_str, VIRTIO_BLK_ID_BYTES,
-			   GFP_KERNEL);
+			GFP_KERNEL);
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
@@ -370,17 +559,16 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 
 	/* We need an extra sg elements at head and tail. */
 	sg_elems += 2;
-	vdev->priv = vblk = kmalloc(sizeof(*vblk) +
-				    sizeof(vblk->sg[0]) * sg_elems, GFP_KERNEL);
+	vdev->priv = vblk = kmalloc(sizeof(*vblk), GFP_KERNEL);
 	if (!vblk) {
 		err = -ENOMEM;
 		goto out_free_index;
 	}
 
+	init_waitqueue_head(&vblk->queue_wait);
 	spin_lock_init(&vblk->lock);
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
-	sg_init_table(vblk->sg, vblk->sg_elems);
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 
 	/* We expect one virtqueue, for output. */
@@ -390,7 +578,9 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 		goto out_free_vblk;
 	}
 
-	vblk->pool = mempool_create_kmalloc_pool(1,sizeof(struct virtblk_req));
+	vblk->pool = mempool_create_kmalloc_pool(1,
+		sizeof(struct virtblk_req) +
+		sizeof(struct scatterlist) * sg_elems);
 	if (!vblk->pool) {
 		err = -ENOMEM;
 		goto out_free_vq;
@@ -409,6 +599,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 		goto out_put_disk;
 	}
 
+	blk_queue_make_request(q, virtblk_make_request);
 	q->queuedata = vblk;
 
 	if (index < 26) {
@@ -432,7 +623,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->index = index;
 
 	/* configure queue flush support */
-	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH) && !use_make_request)
 		blk_queue_flush(q, REQ_FLUSH);
 
 	/* If disk is read-only in the host, the guest should obey */
-- 
1.7.6.4

