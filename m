Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2HBGYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:24:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab2HBGYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:24:46 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        Shaohua Li <shli@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH V5 4/4] virtio-blk: Add REQ_FLUSH and REQ_FUA support to bio path
Date: Thu,  2 Aug 2012 14:25:56 +0800
Message-Id: <1343888757-25723-5-git-send-email-asias@redhat.com>
In-Reply-To: <1343888757-25723-1-git-send-email-asias@redhat.com>
References: <1343888757-25723-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to support both REQ_FLUSH and REQ_FUA for bio based path since
it does not get the sequencing of REQ_FUA into REQ_FLUSH that request
based drivers can request.

REQ_FLUSH is emulated by:
1. Send VIRTIO_BLK_T_FLUSH to device
2. Wait until the flush is finished

REQ_FUA is emulated by:
1. Send the actual write
2. Wait until the actual write is finished
3. Send VIRTIO_BLK_T_FLUSH to device
4. Wait until the flush is finished
5. Signal the end of the write to upper layer

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
 drivers/block/virtio_blk.c | 104 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 91 insertions(+), 13 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 95cfeed..9ebaea7 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -54,6 +54,8 @@ struct virtio_blk
 
 struct virtblk_req
 {
+	struct completion *flush_done;
+	struct completion *bio_done;
 	struct request *req;
 	struct bio *bio;
 	struct virtio_blk_outhdr out_hdr;
@@ -95,14 +97,25 @@ static inline void virtblk_request_done(struct virtio_blk *vblk,
 static inline void virtblk_bio_done(struct virtio_blk *vblk,
 				    struct virtblk_req *vbr)
 {
+	if (unlikely(vbr->bio_done)) {
+		complete(vbr->bio_done);
+		return;
+	}
 	bio_endio(vbr->bio, virtblk_result(vbr));
 	mempool_free(vbr, vblk->pool);
 }
 
+static inline void virtblk_flush_done(struct virtio_blk *vblk,
+				    struct virtblk_req *vbr)
+{
+	complete(vbr->flush_done);
+	mempool_free(vbr, vblk->pool);
+}
+
 static void virtblk_done(struct virtqueue *vq)
 {
+	unsigned long flush_done = 0, bio_done = 0, req_done = 0;
 	struct virtio_blk *vblk = vq->vdev->priv;
-	unsigned long bio_done = 0, req_done = 0;
 	struct virtblk_req *vbr;
 	unsigned long flags;
 	unsigned int len;
@@ -112,9 +125,12 @@ static void virtblk_done(struct virtqueue *vq)
 		if (vbr->bio) {
 			virtblk_bio_done(vblk, vbr);
 			bio_done++;
-		} else {
+		} else if (vbr->req) {
 			virtblk_request_done(vblk, vbr);
 			req_done++;
+		} else if (vbr->flush_done) {
+			virtblk_flush_done(vblk, vbr);
+			flush_done++;
 		}
 	}
 	/* In case queue is stopped waiting for more buffers. */
@@ -122,7 +138,7 @@ static void virtblk_done(struct virtqueue *vq)
 		blk_start_queue(vblk->disk->queue);
 	spin_unlock_irqrestore(vblk->disk->queue->queue_lock, flags);
 
-	if (bio_done)
+	if (bio_done || flush_done)
 		wake_up(&vblk->queue_wait);
 }
 
@@ -269,14 +285,65 @@ static void virtblk_add_buf_wait(struct virtio_blk *vblk,
 	finish_wait(&vblk->queue_wait, &wait);
 }
 
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
+static int virtblk_flush(struct virtio_blk *vblk)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+	unsigned int out = 0, in = 0;
+	struct virtblk_req *vbr;
+
+	vbr = virtblk_alloc_req(vblk, GFP_NOIO);
+	if (!vbr)
+		return -ENOMEM;
+
+	vbr->flush_done = &done;
+	vbr->bio = NULL;
+	vbr->req = NULL;
+	vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
+	vbr->out_hdr.sector = 0;
+	vbr->out_hdr.ioprio = 0;
+	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
+	sg_set_buf(&vbr->sg[out + in++], &vbr->status, sizeof(vbr->status));
+
+	virtblk_add_req(vblk, vbr, out, in);
+
+	wait_for_completion(&done);
+
+	return 0;
+}
+
 static void virtblk_make_request(struct request_queue *q, struct bio *bio)
 {
+	bool req_flush = false, req_fua = false;
 	struct virtio_blk *vblk = q->queuedata;
 	unsigned int num, out = 0, in = 0;
+	DECLARE_COMPLETION_ONSTACK(done);
 	struct virtblk_req *vbr;
 
 	BUG_ON(bio->bi_phys_segments + 2 > vblk->sg_elems);
-	BUG_ON(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
+
+	if (bio->bi_rw & REQ_FLUSH)
+		req_flush = true;
+	if (bio->bi_rw & REQ_FUA)
+		req_fua = true;
+
+	/* Execute a flush & wait until it finishes */
+	if (unlikely(req_flush))
+		virtblk_flush(vblk);
 
 	vbr = virtblk_alloc_req(vblk, GFP_NOIO);
 	if (!vbr) {
@@ -290,6 +357,11 @@ static void virtblk_make_request(struct request_queue *q, struct bio *bio)
 	vbr->out_hdr.sector = bio->bi_sector;
 	vbr->out_hdr.ioprio = bio_prio(bio);
 
+	if (unlikely(req_fua))
+		vbr->bio_done = &done;
+	else
+		vbr->bio_done = NULL;
+
 	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
 
 	num = blk_bio_map_sg(q, bio, vbr->sg + out);
@@ -307,15 +379,21 @@ static void virtblk_make_request(struct request_queue *q, struct bio *bio)
 		}
 	}
 
-	spin_lock_irq(vblk->disk->queue->queue_lock);
-	if (unlikely(virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
-				       GFP_ATOMIC) < 0)) {
-		spin_unlock_irq(vblk->disk->queue->queue_lock);
-		virtblk_add_buf_wait(vblk, vbr, out, in);
-		return;
+	virtblk_add_req(vblk, vbr, out, in);
+
+	if (unlikely(req_fua)) {
+		/*
+		 * We emulate the REQ_FUA here:
+		 *
+		 * 1. Wait until the bio is finished
+		 * 2. Execute a flush & wait until it finishes
+		 * 3. Signal the end of the bio & free the vbr
+		 */
+		wait_for_completion(vbr->bio_done);
+		virtblk_flush(vblk);
+		bio_endio(vbr->bio, virtblk_result(vbr));
+		mempool_free(vbr, vblk->pool);
 	}
-	virtqueue_kick(vblk->vq);
-	spin_unlock_irq(vblk->disk->queue->queue_lock);
 }
 
 /* return id (s/n) string for *disk to *id_str
@@ -529,7 +607,7 @@ static void virtblk_update_cache_mode(struct virtio_device *vdev)
 	u8 writeback = virtblk_get_cache_mode(vdev);
 	struct virtio_blk *vblk = vdev->priv;
 
-	if (writeback && !use_bio)
+	if (writeback)
 		blk_queue_flush(vblk->disk->queue, REQ_FLUSH);
 	else
 		blk_queue_flush(vblk->disk->queue, 0);
-- 
1.7.11.2

