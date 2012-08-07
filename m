Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab2HGIpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:45:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab2HGIpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:45:31 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        Shaohua Li <shli@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH V6 2/2] virtio-blk: Add REQ_FLUSH and REQ_FUA support to bio path
Date: Tue,  7 Aug 2012 16:47:15 +0800
Message-Id: <1344329235-17449-3-git-send-email-asias@redhat.com>
In-Reply-To: <1344329235-17449-1-git-send-email-asias@redhat.com>
References: <1344329235-17449-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to support both REQ_FLUSH and REQ_FUA for bio based path since
it does not get the sequencing of REQ_FUA into REQ_FLUSH that request
based drivers can request.

REQ_FLUSH is emulated by:
A) If the bio has no data to write:
1. Send VIRTIO_BLK_T_FLUSH to device,
2. In the flush I/O completion handler, finish the bio

B) If the bio has data to write:
1. Send VIRTIO_BLK_T_FLUSH to device
2. In the flush I/O completion handler, send the actual write data to device
3. In the write I/O completion handler, finish the bio

REQ_FUA is emulated by:
1. Send the actual write data to device
2. In the write I/O completion handler, send VIRTIO_BLK_T_FLUSH to device
3. In the flush I/O completion handler, finish the bio

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Asias He <asias@redhat.com>
---
 drivers/block/virtio_blk.c | 259 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 183 insertions(+), 76 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 95cfeed..d33ea48 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -58,6 +58,12 @@ struct virtblk_req
 	struct bio *bio;
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
+	struct work_struct work;
+	struct virtio_blk *vblk;
+	bool is_flush;
+	bool req_flush;
+	bool req_data;
+	bool req_fua;
 	u8 status;
 	struct scatterlist sg[];
 };
@@ -74,6 +80,128 @@ static inline int virtblk_result(struct virtblk_req *vbr)
 	}
 }
 
+static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
+						    gfp_t gfp_mask)
+{
+	struct virtblk_req *vbr;
+
+	vbr = mempool_alloc(vblk->pool, gfp_mask);
+	if (vbr && use_bio)
+		sg_init_table(vbr->sg, vblk->sg_elems);
+
+	return vbr;
+}
+
+static void virtblk_add_buf_wait(struct virtio_blk *vblk,
+				 struct virtblk_req *vbr,
+				 unsigned long out,
+				 unsigned long in)
+{
+	DEFINE_WAIT(wait);
+
+	for (;;) {
+		prepare_to_wait_exclusive(&vblk->queue_wait, &wait,
+					  TASK_UNINTERRUPTIBLE);
+
+		spin_lock_irq(vblk->disk->queue->queue_lock);
+		if (virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
+				      GFP_ATOMIC) < 0) {
+			spin_unlock_irq(vblk->disk->queue->queue_lock);
+			io_schedule();
+		} else {
+			virtqueue_kick(vblk->vq);
+			spin_unlock_irq(vblk->disk->queue->queue_lock);
+			break;
+		}
+
+	}
+
+	finish_wait(&vblk->queue_wait, &wait);
+}
+
+static inline void virtblk_add_req(struct virtio_blk *vblk,
+				   struct virtblk_req *vbr,
+				   unsigned int out, unsigned int in)
+{
+	spin_lock_irq(vblk->disk->queue->queue_lock);
+	if (unlikely(virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
+					GFP_ATOMIC) < 0)) {
+		spin_unlock_irq(vblk->disk->queue->queue_lock);
+		virtblk_add_buf_wait(vblk, vbr, out, in);
+		return;
+	}
+	virtqueue_kick(vblk->vq);
+	spin_unlock_irq(vblk->disk->queue->queue_lock);
+}
+
+static int virtblk_bio_send_flush(struct virtio_blk *vblk,
+				  struct virtblk_req *vbr)
+{
+	unsigned int out = 0, in = 0;
+
+	vbr->is_flush = true;
+	vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
+	vbr->out_hdr.sector = 0;
+	vbr->out_hdr.ioprio = 0;
+	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
+	sg_set_buf(&vbr->sg[out + in++], &vbr->status, sizeof(vbr->status));
+
+	virtblk_add_req(vblk, vbr, out, in);
+
+	return 0;
+}
+
+static int virtblk_bio_send_data(struct virtio_blk *vblk,
+				 struct virtblk_req *vbr)
+{
+	unsigned int num, out = 0, in = 0;
+	struct bio *bio = vbr->bio;
+
+	vbr->is_flush = false;
+	vbr->out_hdr.type = 0;
+	vbr->out_hdr.sector = bio->bi_sector;
+	vbr->out_hdr.ioprio = bio_prio(bio);
+
+	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
+
+	num = blk_bio_map_sg(vblk->disk->queue, bio, vbr->sg + out);
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
+	virtblk_add_req(vblk, vbr, out, in);
+
+	return 0;
+}
+
+static void virtblk_bio_send_data_work(struct work_struct *work)
+{
+	struct virtblk_req *vbr;
+
+	vbr = container_of(work, struct virtblk_req, work);
+
+	virtblk_bio_send_data(vbr->vblk, vbr);
+}
+
+static void virtblk_bio_send_flush_work(struct work_struct *work)
+{
+	struct virtblk_req *vbr;
+
+	vbr = container_of(work, struct virtblk_req, work);
+
+	virtblk_bio_send_flush(vbr->vblk, vbr);
+}
+
 static inline void virtblk_request_done(struct virtio_blk *vblk,
 					struct virtblk_req *vbr)
 {
@@ -92,13 +220,53 @@ static inline void virtblk_request_done(struct virtio_blk *vblk,
 	mempool_free(vbr, vblk->pool);
 }
 
-static inline void virtblk_bio_done(struct virtio_blk *vblk,
-				    struct virtblk_req *vbr)
+static inline void virtblk_bio_done_flush(struct virtio_blk *vblk,
+					  struct virtblk_req *vbr)
 {
-	bio_endio(vbr->bio, virtblk_result(vbr));
+	if (vbr->req_data) {
+		/* Send out the actual write data */
+		struct virtblk_req *_vbr;
+		_vbr = virtblk_alloc_req(vblk, GFP_NOIO);
+		if (!_vbr) {
+			bio_endio(vbr->bio, -ENOMEM);
+			goto out;
+		}
+		_vbr->req_fua = vbr->req_fua;
+		_vbr->bio = vbr->bio;
+		_vbr->vblk = vblk;
+		INIT_WORK(&_vbr->work, virtblk_bio_send_data_work);
+		queue_work(virtblk_wq, &_vbr->work);
+	} else {
+		bio_endio(vbr->bio, virtblk_result(vbr));
+	}
+out:
 	mempool_free(vbr, vblk->pool);
 }
 
+static inline void virtblk_bio_done_data(struct virtio_blk *vblk,
+					 struct virtblk_req *vbr)
+{
+	if (unlikely(vbr->req_fua)) {
+		/* Send out a flush before end the bio */
+		struct virtblk_req *_vbr;
+		_vbr = virtblk_alloc_req(vblk, GFP_NOIO);
+		if (!_vbr) {
+			bio_endio(vbr->bio, -ENOMEM);
+			goto out;
+		}
+		_vbr->req_data = false;
+		_vbr->bio = vbr->bio;
+		_vbr->vblk = vblk;
+		INIT_WORK(&_vbr->work, virtblk_bio_send_flush_work);
+		queue_work(virtblk_wq, &_vbr->work);
+	} else {
+		bio_endio(vbr->bio, virtblk_result(vbr));
+	}
+out:
+	mempool_free(vbr, vblk->pool);
+}
+
+
 static void virtblk_done(struct virtqueue *vq)
 {
 	struct virtio_blk *vblk = vq->vdev->priv;
@@ -110,7 +278,10 @@ static void virtblk_done(struct virtqueue *vq)
 	spin_lock_irqsave(vblk->disk->queue->queue_lock, flags);
 	while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
 		if (vbr->bio) {
-			virtblk_bio_done(vblk, vbr);
+			if (unlikely(vbr->is_flush))
+				virtblk_bio_done_flush(vblk, vbr);
+			else
+				virtblk_bio_done_data(vblk, vbr);
 			bio_done++;
 		} else {
 			virtblk_request_done(vblk, vbr);
@@ -126,18 +297,6 @@ static void virtblk_done(struct virtqueue *vq)
 		wake_up(&vblk->queue_wait);
 }
 
-static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
-						    gfp_t gfp_mask)
-{
-	struct virtblk_req *vbr;
-
-	vbr = mempool_alloc(vblk->pool, gfp_mask);
-	if (vbr && use_bio)
-		sg_init_table(vbr->sg, vblk->sg_elems);
-
-	return vbr;
-}
-
 static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		   struct request *req)
 {
@@ -242,41 +401,12 @@ static void virtblk_request(struct request_queue *q)
 		virtqueue_kick(vblk->vq);
 }
 
-static void virtblk_add_buf_wait(struct virtio_blk *vblk,
-				 struct virtblk_req *vbr,
-				 unsigned long out,
-				 unsigned long in)
-{
-	DEFINE_WAIT(wait);
-
-	for (;;) {
-		prepare_to_wait_exclusive(&vblk->queue_wait, &wait,
-					  TASK_UNINTERRUPTIBLE);
-
-		spin_lock_irq(vblk->disk->queue->queue_lock);
-		if (virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
-				      GFP_ATOMIC) < 0) {
-			spin_unlock_irq(vblk->disk->queue->queue_lock);
-			io_schedule();
-		} else {
-			virtqueue_kick(vblk->vq);
-			spin_unlock_irq(vblk->disk->queue->queue_lock);
-			break;
-		}
-
-	}
-
-	finish_wait(&vblk->queue_wait, &wait);
-}
-
 static void virtblk_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct virtio_blk *vblk = q->queuedata;
-	unsigned int num, out = 0, in = 0;
 	struct virtblk_req *vbr;
 
 	BUG_ON(bio->bi_phys_segments + 2 > vblk->sg_elems);
-	BUG_ON(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 
 	vbr = virtblk_alloc_req(vblk, GFP_NOIO);
 	if (!vbr) {
@@ -284,38 +414,15 @@ static void virtblk_make_request(struct request_queue *q, struct bio *bio)
 		return;
 	}
 
+	vbr->req_flush = !!(bio->bi_rw & REQ_FLUSH);
+	vbr->req_fua = !!(bio->bi_rw & REQ_FUA);
+	vbr->req_data = !!(bio->bi_size);
 	vbr->bio = bio;
-	vbr->req = NULL;
-	vbr->out_hdr.type = 0;
-	vbr->out_hdr.sector = bio->bi_sector;
-	vbr->out_hdr.ioprio = bio_prio(bio);
-
-	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
-
-	num = blk_bio_map_sg(q, bio, vbr->sg + out);
 
-	sg_set_buf(&vbr->sg[num + out + in++], &vbr->status,
-		   sizeof(vbr->status));
-
-	if (num) {
-		if (bio->bi_rw & REQ_WRITE) {
-			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
-			out += num;
-		} else {
-			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
-			in += num;
-		}
-	}
-
-	spin_lock_irq(vblk->disk->queue->queue_lock);
-	if (unlikely(virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
-				       GFP_ATOMIC) < 0)) {
-		spin_unlock_irq(vblk->disk->queue->queue_lock);
-		virtblk_add_buf_wait(vblk, vbr, out, in);
-		return;
-	}
-	virtqueue_kick(vblk->vq);
-	spin_unlock_irq(vblk->disk->queue->queue_lock);
+	if (unlikely(vbr->req_flush))
+		virtblk_bio_send_flush(vblk, vbr);
+	else
+		virtblk_bio_send_data(vblk, vbr);
 }
 
 /* return id (s/n) string for *disk to *id_str
@@ -529,7 +636,7 @@ static void virtblk_update_cache_mode(struct virtio_device *vdev)
 	u8 writeback = virtblk_get_cache_mode(vdev);
 	struct virtio_blk *vblk = vdev->priv;
 
-	if (writeback && !use_bio)
+	if (writeback)
 		blk_queue_flush(vblk->disk->queue, REQ_FLUSH);
 	else
 		blk_queue_flush(vblk->disk->queue, 0);
-- 
1.7.11.2

