Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935324Ab1JETzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:55:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55667
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935302Ab1JETzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:55:46 -0400
Message-Id: <20111005195530.558142038@bombadil.infradead.org>
User-Agent: quilt/0.48-1
Date: Wed, 05 Oct 2011 15:54:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] virtio-blk: implement ->make_request
References: <20111005195403.407628164@bombadil.infradead.org>
Content-Disposition: inline; filename=virtio-blk-add-make_request-support
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an alternate I/O path that implements ->make_request for virtio-blk.
This is required for high IOPs devices which get slowed down to 1/5th of
the native speed by all the locking, memory allocation and other overhead
in the request based I/O path.

This patch is not quite merge ready due to two issues:

 - it doesn't implement FUA and FLUSH requests yet
 - it hardcodes which I/O path to chose

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2011-10-05 10:36:42.883913334 -0400
+++ linux-2.6/drivers/block/virtio_blk.c	2011-10-05 15:29:35.591405323 -0400
@@ -11,6 +11,8 @@
 
 #define PART_BITS 4
 
+static int use_make_request = 1;
+
 static int major, index;
 struct workqueue_struct *virtblk_wq;
 
@@ -20,6 +22,7 @@ struct virtio_blk
 
 	struct virtio_device *vdev;
 	struct virtqueue *vq;
+	wait_queue_head_t queue_wait;
 
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
@@ -39,11 +42,13 @@ struct virtio_blk
 struct virtblk_req
 {
 	void *private;
+	struct virtblk_req *next;
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
 	u8 kind;
 #define VIRTIO_BLK_REQUEST	0x00
-#define VIRTIO_BLK_INTERNAL	0x01
+#define VIRTIO_BLK_BIO		0x01
+#define VIRTIO_BLK_INTERNAL	0x02
 	u8 status;
 };
 
@@ -74,10 +79,17 @@ static void virtblk_request_done(struct
 	mempool_free(vbr, vblk->pool);
 }
 
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
 
@@ -88,15 +100,47 @@ static void blk_done(struct virtqueue *v
 			virtblk_request_done(vblk, vbr);
 			break;
 		case VIRTIO_BLK_INTERNAL:
-			complete(vbr->private);
+		case VIRTIO_BLK_BIO:
+			if (head) {
+				tail->next = vbr;
+				tail = vbr;
+			} else {
+				tail = head = vbr;
+			}
 			break;
 		default:
 			BUG();
 		}
 	}
-	/* In case queue is stopped waiting for more buffers. */
-	blk_start_queue(vblk->disk->queue);
+
+	if (!use_make_request) {
+		/* In case queue is stopped waiting for more buffers. */
+		blk_start_queue(vblk->disk->queue);
+	}
 	spin_unlock_irqrestore(&vblk->lock, flags);
+
+	wake_up(&vblk->queue_wait);
+
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
+			break;
+		case VIRTIO_BLK_INTERNAL:
+			complete(vbr->private);
+			break;
+		default:
+			BUG();
+		}
+
+	}
 }
 
 static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
@@ -111,6 +155,7 @@ static bool do_req(struct request_queue
 		return false;
 
 	vbr->private = req;
+	vbr->next = NULL;
 	vbr->kind = VIRTIO_BLK_REQUEST;
 
 	if (req->cmd_flags & REQ_FLUSH) {
@@ -199,6 +244,128 @@ static void do_virtblk_request(struct re
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
+		if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr) < 0) {
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
+static int virtblk_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct virtio_blk *vblk = q->queuedata;
+	unsigned long num, out = 0, in = 0;
+	struct virtblk_req *vbr;
+	bool retry, notify;
+
+	BUG_ON(bio->bi_phys_segments + 2 > vblk->sg_elems);
+	BUG_ON(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
+
+	vbr = mempool_alloc(vblk->pool, GFP_NOIO);
+
+	vbr->private = bio;
+	vbr->next = NULL;
+	vbr->kind = VIRTIO_BLK_BIO;
+
+	vbr->out_hdr.type = 0;
+	vbr->out_hdr.sector = bio->bi_sector;
+	vbr->out_hdr.ioprio = bio_prio(bio);
+
+	sg_set_buf(&vblk->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
+
+	num = bio_map_sg(q, bio, vblk->sg + out);
+
+	sg_set_buf(&vblk->sg[num + out + in++], &vbr->status,
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
+	if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr) < 0) {
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
+	return 0;
+}
+
 /* return id (s/n) string for *disk to *id_str
  */
 static int virtblk_get_id(struct gendisk *disk, char *id_str)
@@ -212,6 +379,7 @@ static int virtblk_get_id(struct gendisk
 	if (!vbr)
 		return -ENOMEM;
 	vbr->private = &done;
+	vbr->next = NULL;
 	vbr->kind = VIRTIO_BLK_INTERNAL;
 
 	vbr->out_hdr.type = VIRTIO_BLK_T_GET_ID | VIRTIO_BLK_T_IN;
@@ -248,7 +416,8 @@ static int virtblk_ioctl(struct block_de
 	/*
 	 * Only allow the generic SCSI ioctls if the host can support it.
 	 */
-	if (!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_SCSI))
+	if (!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_SCSI) &&
+	    !use_make_request)
 		return -ENOTTY;
 
 	return scsi_cmd_ioctl(disk->queue, disk, mode, cmd,
@@ -383,6 +552,7 @@ static int __devinit virtblk_probe(struc
 		goto out;
 	}
 
+	init_waitqueue_head(&vblk->queue_wait);
 	spin_lock_init(&vblk->lock);
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
@@ -409,10 +579,20 @@ static int __devinit virtblk_probe(struc
 		goto out_mempool;
 	}
 
-	q = vblk->disk->queue = blk_init_queue(do_virtblk_request, &vblk->lock);
-	if (!q) {
-		err = -ENOMEM;
-		goto out_put_disk;
+	if (use_make_request) {
+		q = vblk->disk->queue = blk_alloc_queue(GFP_KERNEL);
+		if (!q) {
+			err = -ENOMEM;
+			goto out_put_disk;
+		}
+		blk_queue_make_request(q, virtblk_make_request);
+		printk("virtio-blk: using bios directly\n");
+	} else {
+		q = vblk->disk->queue = blk_init_queue(do_virtblk_request, &vblk->lock);
+		if (!q) {
+			err = -ENOMEM;
+			goto out_put_disk;
+		}
 	}
 
 	q->queuedata = vblk;
@@ -438,7 +618,7 @@ static int __devinit virtblk_probe(struc
 	index++;
 
 	/* configure queue flush support */
-	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH) && !use_make_request)
 		blk_queue_flush(q, REQ_FLUSH);
 
 	/* If disk is read-only in the host, the guest should obey */

