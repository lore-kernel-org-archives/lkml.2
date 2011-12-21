Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1LUBCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:02:00 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44470 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab1LUBBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:01:30 -0500
From: Minchan Kim <minchan@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan@kernel.org>, Minchan Kim <minchan@redhat.com>
Subject: [PATCH 5/6] virtio-blk: Support batch I/O for enhancing sequential IO
Date: Wed, 21 Dec 2011 10:00:53 +0900
Message-Id: <1324429254-28383-6-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1324429254-28383-1-git-send-email-minchan@kernel.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BIO-based path has a disadvantage which it's not good to sequential
stream because it cannot merge BIO while reuqest can do it.

This patch makes per-cpu BIO for batch I/O.
If this request is contiguous with previous's one, this request would
be merged with previous one on batch queue.
If non-contiguous I/O issue or pass 1ms, batch queue would be drained.

Signed-off-by: Minchan Kim <minchan@redhat.com>
---
 drivers/block/virtio_blk.c |  366 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 331 insertions(+), 35 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 4e476d6..e32c69e 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -19,6 +19,28 @@ static DEFINE_IDA(vd_index_ida);
 
 struct workqueue_struct *virtblk_wq;
 
+#define BIO_QUEUE_MAX	32
+
+struct per_cpu_bio
+{
+	struct bio *bios[BIO_QUEUE_MAX];
+	int idx;			/* current index */
+	struct virtio_blk *vblk;
+	struct request_queue *q;
+	struct delayed_work dwork;
+	unsigned int segments; 		/* the number of accumulated segement */
+	bool seq_mode;			/* sequential mode */
+	sector_t next_offset;		/*
+					 * next expected sector offset
+					 * for becoming sequential mode
+					 */
+};
+
+struct bio_queue
+{
+	struct per_cpu_bio __percpu *pcbio;
+};
+
 struct virtio_blk
 {
 	spinlock_t lock;
@@ -38,6 +60,9 @@ struct virtio_blk
 	/* What host tells us, plus 2 for header & tailer. */
 	unsigned int sg_elems;
 
+	/* bio queue for batch IO */
+	struct bio_queue bq;
+
 	/* Ida index - used to track minor number allocations. */
 	int index;
 };
@@ -57,6 +82,8 @@ struct virtblk_req
 	struct scatterlist sg[];
 };
 
+static void wait_virtq_flush(struct virtio_blk *vblk);
+
 static struct virtblk_req *alloc_virtblk_req(struct virtio_blk *vblk,
 		gfp_t gfp_mask)
 {
@@ -93,7 +120,6 @@ static void virtblk_request_done(struct virtio_blk *vblk,
 		req->errors = vbr->in_hdr.errors;
 	}
 	else if (req->cmd_type == REQ_TYPE_SPECIAL) {
-		printk("REQ_TYPE_SPECIAL done\n");
 		req->errors = (error != 0);
 	}
 
@@ -104,7 +130,15 @@ static void virtblk_request_done(struct virtio_blk *vblk,
 static void virtblk_bio_done(struct virtio_blk *vblk,
 		struct virtblk_req *vbr)
 {
-	bio_endio(vbr->private, virtblk_result(vbr));
+	struct bio *bio;
+	bio = vbr->private;
+
+	while(bio) {
+		struct bio *free_bio = bio;
+		bio = bio->bi_next;
+		bio_endio(free_bio, virtblk_result(vbr));
+	}
+
 	mempool_free(vbr, vblk->pool);
 }
 
@@ -298,52 +332,220 @@ static bool virtblk_plugged(struct virtio_blk *vblk)
 	return true;
 }
 
-static void virtblk_add_buf_wait(struct virtio_blk *vblk,
-	struct virtblk_req *vbr, unsigned long out, unsigned long in)
+bool seq_bio(struct bio *bio, struct per_cpu_bio __percpu *pcbio)
 {
-	DEFINE_WAIT(wait);
-	bool retry, notify;
+	struct bio *last_bio;
+	int index = pcbio->idx - 1;
 
-	for (;;) {
-		prepare_to_wait(&vblk->queue_wait, &wait,
-				TASK_UNINTERRUPTIBLE);
+	BUG_ON(index < 0 || index > BIO_QUEUE_MAX);
+	last_bio = pcbio->bios[index];
+
+	if (last_bio->bi_rw != bio->bi_rw)
+		return false;
+
+	if ((last_bio->bi_sector + (last_bio->bi_size >> 9)) ==
+				bio->bi_sector)
+		return true;
+
+	return false;
+}
+
+int add_pcbio_to_vq(struct per_cpu_bio __percpu *pcbio,
+		struct virtio_blk *vblk, struct request_queue *q,
+		int *notify)
+{
+	int i;
+	unsigned long num = 0, out = 0, in = 0;
+	bool retry;
+	struct virtblk_req *vbr;
+	struct bio *bio;
+
+	vbr = alloc_virtblk_req(vblk, GFP_ATOMIC);
+	if (!vbr)
+		return 1;
+
+	vbr->private = NULL;
+	vbr->next = NULL;
+	vbr->kind = VIRTIO_BLK_BIO;
+
+	bio = pcbio->bios[0];
+	BUG_ON(!bio);
+
+	vbr->out_hdr.type = 0;
+	vbr->out_hdr.sector = bio->bi_sector;
+	vbr->out_hdr.ioprio = bio_prio(bio);
+
+	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
 
-		spin_lock_irq(&vblk->lock);
-		if (virtqueue_add_buf(vblk->vq, vbr->sg,
-			out, in, vbr) < 0) {
-			retry = true;
+	for ( i = 0; i < pcbio->idx; i++) {
+		struct bio *prev;
+		bio = pcbio->bios[i];
+
+		BUG_ON(!bio);
+		num += bio_map_sg(q, bio, vbr->sg + out + num);
+		BUG_ON(num > (vblk->sg_elems - 2));
+
+		prev = vbr->private;
+		if (prev)
+			bio->bi_next = prev;
+		vbr->private = bio;
+	}
+
+	sg_set_buf(&vbr->sg[num + out + in++], &vbr->status,
+		   sizeof(vbr->status));
+
+	if (num) {
+		if (bio->bi_rw & REQ_WRITE) {
+			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
+			out += num;
 		} else {
-			retry = false;
+			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
+			in += num;
 		}
-		notify = virtqueue_kick_prepare(vblk->vq);
-		spin_unlock_irq(&vblk->lock);
+	}
+
+	spin_lock_irq(&vblk->lock);
+	if (virtqueue_add_buf(vblk->vq, vbr->sg,
+		out, in, vbr) < 0) {
+		struct bio *bio, *next_bio;
 
-		if (notify)
-			virtqueue_notify(vblk->vq);
+		retry = true;
 
-		if (!retry)
-			break;
-		schedule();
+		bio = vbr->private;
+		while(bio) {
+			next_bio = bio->bi_next;
+			bio->bi_next = NULL;
+			bio = next_bio;
+		}
+
+		mempool_free(vbr, vblk->pool);
+
+	} else {
+
+		for ( i = 0; i < pcbio->idx; i++) {
+			pcbio->bios[i] = NULL;
+		}
+
+		pcbio->idx = 0;
+		pcbio->segments = 0;
+
+		retry = false;
 	}
-	finish_wait(&vblk->queue_wait, &wait);
+
+	*notify |= virtqueue_kick_prepare(vblk->vq);
+	spin_unlock_irq(&vblk->lock);
+
+	return retry;
 }
 
-static void virtblk_make_request(struct request_queue *q, struct bio *bio)
+/*
+ * Return 0 if it is successful flush
+ * This function might be able to don't flush so caller
+ * should retry it.
+ */
+int try_flush_pcb(struct per_cpu_bio __percpu *pcbio)
 {
-	struct virtio_blk *vblk = q->queuedata;
-	unsigned long num, out = 0, in = 0;
-	struct virtblk_req *vbr;
-	bool retry, notify;
+	int notify = 0;
 
-	BUG_ON(bio->bi_phys_segments + 2 > vblk->sg_elems);
-	BUG_ON(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
+	if (!pcbio->idx)
+		return 0;
 
-	vbr = alloc_virtblk_req(vblk, GFP_NOIO);
-	if (!vbr) {
-		bio_endio(bio, -ENOMEM);
-		return;
+	if (add_pcbio_to_vq(pcbio, pcbio->vblk, pcbio->q, &notify)) {
+		virtqueue_notify(pcbio->vblk->vq);
+		return 1;
 	}
 
+	if (notify && !virtblk_plugged(pcbio->vblk))
+		virtqueue_notify(pcbio->vblk->vq);
+
+	return 0;
+}
+
+static void virtblk_delay_q_flush(struct work_struct *work)
+{
+	struct per_cpu_bio __percpu *pcbio =
+		container_of(work, struct per_cpu_bio, dwork.work);
+
+	while(try_flush_pcb(pcbio))
+		wait_virtq_flush(pcbio->vblk);
+}
+
+void wait_virtq_flush(struct virtio_blk *vblk)
+{
+	DEFINE_WAIT(wait);
+
+	prepare_to_wait(&vblk->queue_wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+	schedule();
+	finish_wait(&vblk->queue_wait, &wait);
+}
+
+void add_bio_to_pcbio(struct bio *bio, struct per_cpu_bio __percpu *pcbio)
+{
+	BUG_ON(pcbio->idx >= BIO_QUEUE_MAX);
+
+	pcbio->bios[pcbio->idx++] = bio;
+	pcbio->segments += bio->bi_phys_segments;
+	/*
+	 * If this bio is first bio on queue, start timer to flush
+	 * bio within 1ms.
+	 */
+	if (pcbio->idx == 1)
+		queue_delayed_work_on(smp_processor_id(),
+			virtblk_wq, &pcbio->dwork,
+			msecs_to_jiffies(1));
+}
+
+static void virtblk_add_buf_wait(struct virtio_blk *vblk,
+        struct virtblk_req *vbr, unsigned long out, unsigned long in)
+{
+        DEFINE_WAIT(wait);
+        bool retry, notify;
+
+        for (;;) {
+                prepare_to_wait(&vblk->queue_wait, &wait,
+                                TASK_UNINTERRUPTIBLE);
+
+                spin_lock_irq(&vblk->lock);
+                if (virtqueue_add_buf(vblk->vq, vbr->sg,
+                        out, in, vbr) < 0) {
+                        retry = true;
+                } else {
+                        retry = false;
+                }
+                notify = virtqueue_kick_prepare(vblk->vq);
+                spin_unlock_irq(&vblk->lock);
+
+                if (notify)
+                        virtqueue_notify(vblk->vq);
+
+                if (!retry)
+                        break;
+                schedule();
+        }
+        finish_wait(&vblk->queue_wait, &wait);
+}
+
+bool full_segment(struct per_cpu_bio __percpu *pcbio, struct bio *bio,
+		unsigned int max)
+{
+	bool full;
+	full = (pcbio->segments + bio->bi_phys_segments) > max;
+
+	return full;
+}
+
+int add_bio_to_vq(struct bio *bio, struct virtio_blk *vblk,
+		struct request_queue *q)
+{
+	int notify;
+	bool retry;
+	unsigned long num, out = 0, in = 0;
+	struct virtblk_req *vbr = alloc_virtblk_req(vblk, GFP_KERNEL);
+
+	if (!vbr)
+		return 1;
+
 	vbr->private = bio;
 	vbr->next = NULL;
 	vbr->kind = VIRTIO_BLK_BIO;
@@ -357,7 +559,7 @@ static void virtblk_make_request(struct request_queue *q, struct bio *bio)
 	num = bio_map_sg(q, bio, vbr->sg + out);
 
 	sg_set_buf(&vbr->sg[num + out + in++], &vbr->status,
-		   sizeof(vbr->status));
+			sizeof(vbr->status));
 
 	if (num) {
 		if (bio->bi_rw & REQ_WRITE) {
@@ -371,7 +573,7 @@ static void virtblk_make_request(struct request_queue *q, struct bio *bio)
 
 	spin_lock_irq(&vblk->lock);
 	if (virtqueue_add_buf(vblk->vq, vbr->sg,
-		out, in, vbr) < 0) {
+				out, in, vbr) < 0) {
 		retry = true;
 	} else {
 		retry = false;
@@ -385,6 +587,75 @@ static void virtblk_make_request(struct request_queue *q, struct bio *bio)
 
 	if (retry)
 		virtblk_add_buf_wait(vblk, vbr, out, in);
+	return 0;
+}
+
+bool seq_mode(struct per_cpu_bio __percpu *pcbio, struct bio *bio)
+{
+	if (pcbio->seq_mode == false)
+		return false;
+
+	if (pcbio->idx == 0)
+		return true;
+
+	return seq_bio(bio, pcbio);
+}
+
+void reset_seq_mode(struct per_cpu_bio __percpu *pcbio, struct bio *bio)
+{
+	if (bio->bi_sector == pcbio->next_offset)
+		pcbio->seq_mode = true;
+	else
+		pcbio->seq_mode = false;
+
+	pcbio->next_offset = bio->bi_sector + (bio->bi_size >> 9);
+}
+
+
+static void virtblk_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct virtio_blk *vblk = q->queuedata;
+	struct per_cpu_bio __percpu *pcbio;
+
+	BUG_ON(bio->bi_phys_segments + 2 > vblk->sg_elems);
+	BUG_ON(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
+retry:
+	preempt_disable();
+	pcbio = this_cpu_ptr(vblk->bq.pcbio);
+
+	if (seq_mode(pcbio, bio)) {
+		if (pcbio->idx >= BIO_QUEUE_MAX ||
+			full_segment(pcbio, bio, vblk->sg_elems -2)) {
+			if (try_flush_pcb(pcbio)) {
+				preempt_enable();
+				wait_virtq_flush(pcbio->vblk);
+				goto retry;
+			}
+
+			cancel_delayed_work(&pcbio->dwork);
+		}
+
+		add_bio_to_pcbio(bio, pcbio);
+	}
+	else {
+		while(try_flush_pcb(pcbio)) {
+			preempt_enable();
+			wait_virtq_flush(pcbio->vblk);
+			preempt_disable();
+			pcbio = this_cpu_ptr(vblk->bq.pcbio);
+		}
+
+		cancel_delayed_work(&pcbio->dwork);
+		reset_seq_mode(pcbio, bio);
+		preempt_enable();
+
+		while (add_bio_to_vq(bio, vblk, q))
+			wait_virtq_flush(pcbio->vblk);
+
+		preempt_disable();
+	}
+
+	preempt_enable();
 }
 
 /* return id (s/n) string for *disk to *id_str
@@ -532,6 +803,26 @@ static void virtblk_config_changed(struct virtio_device *vdev)
 	queue_work(virtblk_wq, &vblk->config_work);
 }
 
+void setup_per_cpu_bio(struct virtio_blk *vblk, struct request_queue *q)
+{
+	int cpu;
+
+	struct bio_queue *bq = &vblk->bq;
+	bq->pcbio = alloc_percpu(struct per_cpu_bio);
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_bio __percpu *pcbio =
+					per_cpu_ptr(bq->pcbio, cpu);
+		pcbio->q = q;
+		pcbio->vblk = vblk;
+		pcbio->idx = 0;
+		pcbio->segments = 0;
+		pcbio->seq_mode = false;
+		pcbio->next_offset = 0;
+		memset(pcbio->bios, 0, BIO_QUEUE_MAX);
+		INIT_DELAYED_WORK(&pcbio->dwork, virtblk_delay_q_flush);
+	}
+}
+
 static int __devinit virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
@@ -571,6 +862,8 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->sg_elems = sg_elems;
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 
+	memset(&vblk->bq, 0, sizeof(struct bio_queue));
+
 	/* We expect one virtqueue, for output. */
 	vblk->vq = virtio_find_single_vq(vdev, blk_done, "requests");
 	if (IS_ERR(vblk->vq)) {
@@ -602,6 +895,8 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	blk_queue_make_request(q, virtblk_make_request);
 	q->queuedata = vblk;
 
+	setup_per_cpu_bio(vblk, q);
+
 	if (index < 26) {
 		sprintf(vblk->disk->disk_name, "vd%c", 'a' + index % 26);
 	} else if (index < (26 + 1) * 26) {
@@ -736,6 +1031,7 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 	put_disk(vblk->disk);
 	mempool_destroy(vblk->pool);
 	vdev->config->del_vqs(vdev);
+	free_percpu(vblk->bq.pcbio);
 	kfree(vblk);
 	ida_simple_remove(&vd_index_ida, index);
 }
-- 
1.7.6.4

