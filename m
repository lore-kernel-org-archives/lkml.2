Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935332Ab1JET4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:56:37 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55663
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935268Ab1JETzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:55:42 -0400
Message-Id: <20111005195530.373761466@bombadil.infradead.org>
User-Agent: quilt/0.48-1
Date: Wed, 05 Oct 2011 15:54:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] virtio-blk: reimplement the serial attribute without using requests
References: <20111005195403.407628164@bombadil.infradead.org>
Content-Disposition: inline; filename=virtio-blk-reimplement-serial
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want to do bio-based I/O in virtio-blk we have to implement reading
the serial attribute ourselves.  Do that and also prepare struct virtblk_req
for dealing with different types of requests.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2011-10-03 20:32:12.997713070 +0200
+++ linux-2.6/drivers/block/virtio_blk.c	2011-10-03 20:37:28.836714193 +0200
@@ -38,12 +38,42 @@ struct virtio_blk
 
 struct virtblk_req
 {
-	struct request *req;
+	void *private;
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
+	u8 kind;
+#define VIRTIO_BLK_REQUEST	0x00
+#define VIRTIO_BLK_INTERNAL	0x01
 	u8 status;
 };
 
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
+
+	if (req->cmd_type == REQ_TYPE_BLOCK_PC) {
+		req->resid_len = vbr->in_hdr.residual;
+		req->sense_len = vbr->in_hdr.sense_len;
+		req->errors = vbr->in_hdr.errors;
+	}
+
+	__blk_end_request_all(req, virtblk_result(vbr));
+	mempool_free(vbr, vblk->pool);
+}
+
 static void blk_done(struct virtqueue *vq)
 {
 	struct virtio_blk *vblk = vq->vdev->priv;
@@ -53,35 +83,16 @@ static void blk_done(struct virtqueue *v
 
 	spin_lock_irqsave(&vblk->lock, flags);
 	while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
-		int error;
-
-		switch (vbr->status) {
-		case VIRTIO_BLK_S_OK:
-			error = 0;
-			break;
-		case VIRTIO_BLK_S_UNSUPP:
-			error = -ENOTTY;
-			break;
-		default:
-			error = -EIO;
-			break;
-		}
-
-		switch (vbr->req->cmd_type) {
-		case REQ_TYPE_BLOCK_PC:
-			vbr->req->resid_len = vbr->in_hdr.residual;
-			vbr->req->sense_len = vbr->in_hdr.sense_len;
-			vbr->req->errors = vbr->in_hdr.errors;
+		switch (vbr->kind) {
+		case VIRTIO_BLK_REQUEST:
+			virtblk_request_done(vblk, vbr);
 			break;
-		case REQ_TYPE_SPECIAL:
-			vbr->req->errors = (error != 0);
+		case VIRTIO_BLK_INTERNAL:
+			complete(vbr->private);
 			break;
 		default:
-			break;
+			BUG();
 		}
-
-		__blk_end_request_all(vbr->req, error);
-		mempool_free(vbr, vblk->pool);
 	}
 	/* In case queue is stopped waiting for more buffers. */
 	blk_start_queue(vblk->disk->queue);
@@ -99,28 +110,24 @@ static bool do_req(struct request_queue
 		/* When another request finishes we'll try again. */
 		return false;
 
-	vbr->req = req;
+	vbr->private = req;
+	vbr->kind = VIRTIO_BLK_REQUEST;
 
 	if (req->cmd_flags & REQ_FLUSH) {
 		vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
 		vbr->out_hdr.sector = 0;
-		vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+		vbr->out_hdr.ioprio = req_get_ioprio(req);
 	} else {
 		switch (req->cmd_type) {
 		case REQ_TYPE_FS:
 			vbr->out_hdr.type = 0;
-			vbr->out_hdr.sector = blk_rq_pos(vbr->req);
-			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+			vbr->out_hdr.sector = blk_rq_pos(req);
+			vbr->out_hdr.ioprio = req_get_ioprio(req);
 			break;
 		case REQ_TYPE_BLOCK_PC:
 			vbr->out_hdr.type = VIRTIO_BLK_T_SCSI_CMD;
 			vbr->out_hdr.sector = 0;
-			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
-			break;
-		case REQ_TYPE_SPECIAL:
-			vbr->out_hdr.type = VIRTIO_BLK_T_GET_ID;
-			vbr->out_hdr.sector = 0;
-			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+			vbr->out_hdr.ioprio = req_get_ioprio(req);
 			break;
 		default:
 			/* We don't put anything else in the queue. */
@@ -136,13 +143,14 @@ static bool do_req(struct request_queue
 	 * block, and before the normal inhdr we put the sense data and the
 	 * inhdr with additional status information before the normal inhdr.
 	 */
-	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC)
-		sg_set_buf(&vblk->sg[out++], vbr->req->cmd, vbr->req->cmd_len);
+	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
+		sg_set_buf(&vblk->sg[out++], req->cmd, req->cmd_len);
 
-	num = blk_rq_map_sg(q, vbr->req, vblk->sg + out);
+	num = blk_rq_map_sg(q, req, vblk->sg + out);
 
-	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC) {
-		sg_set_buf(&vblk->sg[num + out + in++], vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
+	if (req->cmd_type == REQ_TYPE_BLOCK_PC) {
+		sg_set_buf(&vblk->sg[num + out + in++], req->sense,
+			   SCSI_SENSE_BUFFERSIZE);
 		sg_set_buf(&vblk->sg[num + out + in++], &vbr->in_hdr,
 			   sizeof(vbr->in_hdr));
 	}
@@ -151,7 +159,7 @@ static bool do_req(struct request_queue
 		   sizeof(vbr->status));
 
 	if (num) {
-		if (rq_data_dir(vbr->req) == WRITE) {
+		if (rq_data_dir(req) == WRITE) {
 			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
 			out += num;
 		} else {
@@ -196,26 +204,39 @@ static void do_virtblk_request(struct re
 static int virtblk_get_id(struct gendisk *disk, char *id_str)
 {
 	struct virtio_blk *vblk = disk->private_data;
-	struct request *req;
-	struct bio *bio;
-	int err;
-
-	bio = bio_map_kern(vblk->disk->queue, id_str, VIRTIO_BLK_ID_BYTES,
-			   GFP_KERNEL);
-	if (IS_ERR(bio))
-		return PTR_ERR(bio);
-
-	req = blk_make_request(vblk->disk->queue, bio, GFP_KERNEL);
-	if (IS_ERR(req)) {
-		bio_put(bio);
-		return PTR_ERR(req);
-	}
-
-	req->cmd_type = REQ_TYPE_SPECIAL;
-	err = blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
-	blk_put_request(req);
+	struct virtblk_req *vbr;
+	DECLARE_COMPLETION_ONSTACK(done);
+	int error;
 
-	return err;
+	vbr = kmalloc(sizeof(*vbr), GFP_KERNEL);
+	if (!vbr)
+		return -ENOMEM;
+	vbr->private = &done;
+	vbr->kind = VIRTIO_BLK_INTERNAL;
+
+	vbr->out_hdr.type = VIRTIO_BLK_T_GET_ID | VIRTIO_BLK_T_IN;
+	vbr->out_hdr.sector = 0;
+	vbr->out_hdr.ioprio = 0;
+
+	sg_set_buf(&vblk->sg[0], &vbr->out_hdr, sizeof(vbr->out_hdr));
+	sg_set_buf(&vblk->sg[1], id_str, VIRTIO_BLK_ID_BYTES);
+	sg_set_buf(&vblk->sg[2], &vbr->status, sizeof(vbr->status));
+
+	spin_lock_irq(&vblk->lock);
+	if (virtqueue_add_buf(vblk->vq, vblk->sg, 1, 2, vbr) < 0) {
+		spin_unlock_irq(&vblk->lock);
+		/* XXX: eventuall wait for free space */
+		error = -EBUSY;
+		goto out_free;
+	}
+	virtqueue_kick(vblk->vq);
+	spin_unlock_irq(&vblk->lock);
+
+	wait_for_completion(&done);
+	error = virtblk_result(vbr);
+out_free:
+	kfree(vbr);
+	return error;
 }
 
 static int virtblk_ioctl(struct block_device *bdev, fmode_t mode,

