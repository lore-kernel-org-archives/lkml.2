Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2FRGws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:52:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922Ab2FRGwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:52:44 -0400
From: Asias He <asias@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Asias He <asias@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
Date: Mon, 18 Jun 2012 14:53:10 +0800
Message-Id: <1340002390-3950-4-git-send-email-asias@redhat.com>
In-Reply-To: <1340002390-3950-1-git-send-email-asias@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces bio-based IO path for virtio-blk.

Compared to request-based IO path, bio-based IO path uses driver
provided ->make_request_fn() method to bypasses the IO scheduler. It
handles the bio to device directly without allocating a request in block
layer. This reduces the IO path in guest kernel to achieve high IOPS
and lower latency. The downside is that guest can not use the IO
scheduler to merge and sort requests. However, this is not a big problem
if the backend disk in host side uses faster disk device.

When the bio-based IO path is not enabled, virtio-blk still uses the
original request-based IO path, no performance difference is observed.

Performance evaluation:
-----------------------------
Fio test is performed in a 8 vcpu guest with ramdisk based guest using
kvm tool.

Short version:
 With bio-based IO path, sequential read/write, random read/write
 IOPS boost         : 28%, 24%, 21%, 16%
 Latency improvement: 32%, 17%, 21%, 16%

Long version:
 With bio-based IO path:
  seq-read  : io=2048.0MB, bw=116996KB/s, iops=233991 , runt= 17925msec
  seq-write : io=2048.0MB, bw=100829KB/s, iops=201658 , runt= 20799msec
  rand-read : io=3095.7MB, bw=112134KB/s, iops=224268 , runt= 28269msec
  rand-write: io=3095.7MB, bw=96198KB/s,  iops=192396 , runt= 32952msec
    clat (usec): min=0 , max=2631.6K, avg=58716.99, stdev=191377.30
    clat (usec): min=0 , max=1753.2K, avg=66423.25, stdev=81774.35
    clat (usec): min=0 , max=2915.5K, avg=61685.70, stdev=120598.39
    clat (usec): min=0 , max=1933.4K, avg=76935.12, stdev=96603.45
  cpu : usr=74.08%, sys=703.84%, ctx=29661403, majf=21354, minf=22460954
  cpu : usr=70.92%, sys=702.81%, ctx=77219828, majf=13980, minf=27713137
  cpu : usr=72.23%, sys=695.37%, ctx=88081059, majf=18475, minf=28177648
  cpu : usr=69.69%, sys=654.13%, ctx=145476035, majf=15867, minf=26176375
 With request-based IO path:
  seq-read  : io=2048.0MB, bw=91074KB/s, iops=182147 , runt= 23027msec
  seq-write : io=2048.0MB, bw=80725KB/s, iops=161449 , runt= 25979msec
  rand-read : io=3095.7MB, bw=92106KB/s, iops=184211 , runt= 34416msec
  rand-write: io=3095.7MB, bw=82815KB/s, iops=165630 , runt= 38277msec
    clat (usec): min=0 , max=1932.4K, avg=77824.17, stdev=170339.49
    clat (usec): min=0 , max=2510.2K, avg=78023.96, stdev=146949.15
    clat (usec): min=0 , max=3037.2K, avg=74746.53, stdev=128498.27
    clat (usec): min=0 , max=1363.4K, avg=89830.75, stdev=114279.68
  cpu : usr=53.28%, sys=724.19%, ctx=37988895, majf=17531, minf=23577622
  cpu : usr=49.03%, sys=633.20%, ctx=205935380, majf=18197, minf=27288959
  cpu : usr=55.78%, sys=722.40%, ctx=101525058, majf=19273, minf=28067082
  cpu : usr=56.55%, sys=690.83%, ctx=228205022, majf=18039, minf=26551985

How to use:
-----------------------------
Add 'virtio_blk.use_bio=1' to kernel cmdline or 'modprobe virtio_blk
use_bio=1' to enable ->make_request_fn() based I/O path.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Asias He <asias@redhat.com>
---
 drivers/block/virtio_blk.c |  203 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 163 insertions(+), 40 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 774c31d..b2d5002 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -14,6 +14,9 @@
 
 #define PART_BITS 4
 
+static bool use_bio;
+module_param(use_bio, bool, S_IRUGO);
+
 static int major;
 static DEFINE_IDA(vd_index_ida);
 
@@ -23,6 +26,7 @@ struct virtio_blk
 {
 	struct virtio_device *vdev;
 	struct virtqueue *vq;
+	wait_queue_head_t queue_wait;
 
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
@@ -51,53 +55,87 @@ struct virtio_blk
 struct virtblk_req
 {
 	struct request *req;
+	struct bio *bio;
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
 	u8 status;
+	struct scatterlist sg[];
 };
 
-static void blk_done(struct virtqueue *vq)
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
+static inline void virtblk_request_done(struct virtio_blk *vblk,
+					struct virtblk_req *vbr)
+{
+	struct request *req = vbr->req;
+	int error = virtblk_result(vbr);
+
+	if (req->cmd_type == REQ_TYPE_BLOCK_PC) {
+		req->resid_len = vbr->in_hdr.residual;
+		req->sense_len = vbr->in_hdr.sense_len;
+		req->errors = vbr->in_hdr.errors;
+	} else if (req->cmd_type == REQ_TYPE_SPECIAL) {
+		req->errors = (error != 0);
+	}
+
+	__blk_end_request_all(req, error);
+	mempool_free(vbr, vblk->pool);
+}
+
+static inline void virtblk_bio_done(struct virtio_blk *vblk,
+				    struct virtblk_req *vbr)
+{
+	bio_endio(vbr->bio, virtblk_result(vbr));
+	mempool_free(vbr, vblk->pool);
+}
+
+static void virtblk_done(struct virtqueue *vq)
 {
 	struct virtio_blk *vblk = vq->vdev->priv;
+	unsigned long bio_done = 0, req_done = 0;
 	struct virtblk_req *vbr;
-	unsigned int len;
 	unsigned long flags;
+	unsigned int len;
 
 	spin_lock_irqsave(vblk->disk->queue->queue_lock, flags);
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
-			break;
-		case REQ_TYPE_SPECIAL:
-			vbr->req->errors = (error != 0);
-			break;
-		default:
-			break;
+		if (vbr->bio) {
+			virtblk_bio_done(vblk, vbr);
+			bio_done++;
+		} else {
+			virtblk_request_done(vblk, vbr);
+			req_done++;
 		}
-
-		__blk_end_request_all(vbr->req, error);
-		mempool_free(vbr, vblk->pool);
 	}
 	/* In case queue is stopped waiting for more buffers. */
-	blk_start_queue(vblk->disk->queue);
+	if (req_done)
+		blk_start_queue(vblk->disk->queue);
 	spin_unlock_irqrestore(vblk->disk->queue->queue_lock, flags);
+
+	if (bio_done)
+		wake_up(&vblk->queue_wait);
+}
+
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
 }
 
 static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
@@ -106,13 +144,13 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 	unsigned long num, out = 0, in = 0;
 	struct virtblk_req *vbr;
 
-	vbr = mempool_alloc(vblk->pool, GFP_ATOMIC);
+	vbr = virtblk_alloc_req(vblk, GFP_ATOMIC);
 	if (!vbr)
 		/* When another request finishes we'll try again. */
 		return false;
 
 	vbr->req = req;
-
+	vbr->bio = NULL;
 	if (req->cmd_flags & REQ_FLUSH) {
 		vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
 		vbr->out_hdr.sector = 0;
@@ -172,7 +210,8 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		}
 	}
 
-	if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr, GFP_ATOMIC)<0) {
+	if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr,
+			      GFP_ATOMIC) < 0) {
 		mempool_free(vbr, vblk->pool);
 		return false;
 	}
@@ -180,7 +219,7 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 	return true;
 }
 
-static void do_virtblk_request(struct request_queue *q)
+static void virtblk_request(struct request_queue *q)
 {
 	struct virtio_blk *vblk = q->queuedata;
 	struct request *req;
@@ -203,6 +242,82 @@ static void do_virtblk_request(struct request_queue *q)
 		virtqueue_kick(vblk->vq);
 }
 
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
+static void virtblk_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct virtio_blk *vblk = q->queuedata;
+	unsigned int num, out = 0, in = 0;
+	struct virtblk_req *vbr;
+
+	BUG_ON(bio->bi_phys_segments + 2 > vblk->sg_elems);
+	BUG_ON(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
+
+	vbr = virtblk_alloc_req(vblk, GFP_NOIO);
+	if (!vbr) {
+		bio_endio(bio, -ENOMEM);
+		return;
+	}
+
+	vbr->bio = bio;
+	vbr->req = NULL;
+	vbr->out_hdr.type = 0;
+	vbr->out_hdr.sector = bio->bi_sector;
+	vbr->out_hdr.ioprio = bio_prio(bio);
+
+	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
+
+	num = blk_bio_map_sg(q, bio, vbr->sg + out);
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
+	spin_lock_irq(vblk->disk->queue->queue_lock);
+	if (virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
+			      GFP_ATOMIC) < 0) {
+		spin_unlock_irq(vblk->disk->queue->queue_lock);
+		virtblk_add_buf_wait(vblk, vbr, out, in);
+	} else {
+		virtqueue_kick(vblk->vq);
+		spin_unlock_irq(vblk->disk->queue->queue_lock);
+	}
+}
+
 /* return id (s/n) string for *disk to *id_str
  */
 static int virtblk_get_id(struct gendisk *disk, char *id_str)
@@ -360,7 +475,7 @@ static int init_vq(struct virtio_blk *vblk)
 	int err = 0;
 
 	/* We expect one virtqueue, for output. */
-	vblk->vq = virtio_find_single_vq(vblk->vdev, blk_done, "requests");
+	vblk->vq = virtio_find_single_vq(vblk->vdev, virtblk_done, "requests");
 	if (IS_ERR(vblk->vq))
 		err = PTR_ERR(vblk->vq);
 
@@ -400,6 +515,8 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	struct virtio_blk *vblk;
 	struct request_queue *q;
 	int err, index;
+	int pool_size;
+
 	u64 cap;
 	u32 v, blk_size, sg_elems, opt_io_size;
 	u16 min_io_size;
@@ -429,10 +546,12 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 		goto out_free_index;
 	}
 
+	init_waitqueue_head(&vblk->queue_wait);
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
 	sg_init_table(vblk->sg, vblk->sg_elems);
 	mutex_init(&vblk->config_lock);
+
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 	vblk->config_enable = true;
 
@@ -440,7 +559,10 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	if (err)
 		goto out_free_vblk;
 
-	vblk->pool = mempool_create_kmalloc_pool(1,sizeof(struct virtblk_req));
+	pool_size = sizeof(struct virtblk_req);
+	if (use_bio)
+		pool_size += sizeof(struct scatterlist) * sg_elems;
+	vblk->pool = mempool_create_kmalloc_pool(1, pool_size);
 	if (!vblk->pool) {
 		err = -ENOMEM;
 		goto out_free_vq;
@@ -453,12 +575,14 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 		goto out_mempool;
 	}
 
-	q = vblk->disk->queue = blk_init_queue(do_virtblk_request, NULL);
+	q = vblk->disk->queue = blk_init_queue(virtblk_request, NULL);
 	if (!q) {
 		err = -ENOMEM;
 		goto out_put_disk;
 	}
 
+	if (use_bio)
+		blk_queue_make_request(q, virtblk_make_request);
 	q->queuedata = vblk;
 
 	virtblk_name_format("vd", index, vblk->disk->disk_name, DISK_NAME_LEN);
@@ -471,7 +595,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->index = index;
 
 	/* configure queue flush support */
-	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH) && !use_bio)
 		blk_queue_flush(q, REQ_FLUSH);
 
 	/* If disk is read-only in the host, the guest should obey */
@@ -544,7 +668,6 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	if (!err && opt_io_size)
 		blk_queue_io_opt(q, blk_size * opt_io_size);
 
-
 	add_disk(vblk->disk);
 	err = device_create_file(disk_to_dev(vblk->disk), &dev_attr_serial);
 	if (err)
-- 
1.7.10.2

