Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700Ab2FDOnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:43:04 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:37522 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab2FDOnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:43:02 -0400
From: Tao Guo <glorioustao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tao Guo <glorioustao@gmail.com>, Tao Guo <Tao.Guo@emc.com>,
        Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>,
        <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] block: Move general unplug callback function from md/raid to blk-core
Date: Mon,  4 Jun 2012 10:41:50 -0400
Message-Id: <1338820911-4733-1-git-send-email-glorioustao@gmail.com>
X-Mailer: git-send-email 1.7.7.6
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other components may also require an unplug callback, so move this
function from md/raid to block generic layer.

Signed-off-by: Tao Guo <Tao.Guo@emc.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
---
 block/blk-core.c       |   36 ++++++++++++++++++++++++++++++++-
 block/blk-settings.c   |    1 +
 block/blk.h            |    1 -
 drivers/md/md.c        |   51 ++++-------------------------------------------
 drivers/md/md.h        |    3 --
 drivers/md/raid1.c     |    2 +-
 drivers/md/raid5.c     |    4 +-
 include/linux/blkdev.h |    8 ++++++-
 8 files changed, 51 insertions(+), 55 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3c923a7..5639a3d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2840,6 +2840,39 @@ void blk_start_plug(struct blk_plug *plug)
 }
 EXPORT_SYMBOL(blk_start_plug);
 
+/* Check that an unplug wakeup will come shortly.
+ */
+bool blk_check_plugged(struct request_queue *q, plug_cb_fn cb_fn)
+{
+	struct blk_plug *plug = current->plug;
+	struct blk_plug_cb *cb;
+
+	if (!plug)
+		return false;
+
+	list_for_each_entry(cb, &plug->cb_list, list) {
+		if (cb->cb_fn == cb_fn && cb->q == q) {
+			/* Already on the list, move to top */
+			if (cb != list_first_entry(&plug->cb_list,
+						    struct blk_plug_cb,
+						    list))
+				list_move(&cb->list, &plug->cb_list);
+			return true;
+		}
+	}
+	/* Not currently on the callback list */
+	cb = kmalloc(sizeof(*cb), GFP_ATOMIC);
+	if (!cb)
+		return false;
+
+	cb->q = q;
+	cb->cb_fn = cb_fn;
+	atomic_inc(&q->plug_cnt);
+	list_add(&cb->list, &plug->cb_list);
+	return true;
+}
+EXPORT_SYMBOL(blk_check_plugged);
+
 static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
 {
 	struct request *rqa = container_of(a, struct request, queuelist);
@@ -2897,7 +2930,8 @@ static void flush_plug_callbacks(struct blk_plug *plug)
 							  struct blk_plug_cb,
 							  list);
 		list_del(&cb->list);
-		cb->callback(cb);
+		cb->cb_fn(cb);
+		kfree(cb);
 	}
 }
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index d3234fc..c54d603 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -181,6 +181,7 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
 	q->nr_batching = BLK_BATCH_REQ;
+	atomic_set(&q->plug_cnt, 0);
 
 	blk_set_default_limits(&q->limits);
 
diff --git a/block/blk.h b/block/blk.h
index 85f6ae4..a62195b 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -33,7 +33,6 @@ bool __blk_end_bidi_request(struct request *rq, int error,
 void blk_rq_timed_out_timer(unsigned long data);
 void blk_delete_timer(struct request *);
 void blk_add_timer(struct request *);
-void __generic_unplug_device(struct request_queue *);
 
 /*
  * Internal atomic flags for request handling
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1c2f904..08b64ef 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -498,25 +498,11 @@ void md_flush_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_flush_request);
 
-/* Support for plugging.
- * This mirrors the plugging support in request_queue, but does not
- * require having a whole queue or request structures.
- * We allocate an md_plug_cb for each md device and each thread it gets
- * plugged on.  This links tot the private plug_handle structure in the
- * personality data where we keep a count of the number of outstanding
- * plugs so other code can see if a plug is active.
- */
-struct md_plug_cb {
-	struct blk_plug_cb cb;
-	struct mddev *mddev;
-};
-
-static void plugger_unplug(struct blk_plug_cb *cb)
+static void mddev_unplug(struct blk_plug_cb *cb)
 {
-	struct md_plug_cb *mdcb = container_of(cb, struct md_plug_cb, cb);
-	if (atomic_dec_and_test(&mdcb->mddev->plug_cnt))
-		md_wakeup_thread(mdcb->mddev->thread);
-	kfree(mdcb);
+	struct mddev *mddev = cb->q->queuedata;
+	if (atomic_dec_and_test(&cb->q->plug_cnt))
+		md_wakeup_thread(mddev->thread);
 }
 
 /* Check that an unplug wakeup will come shortly.
@@ -524,33 +510,7 @@ static void plugger_unplug(struct blk_plug_cb *cb)
  */
 int mddev_check_plugged(struct mddev *mddev)
 {
-	struct blk_plug *plug = current->plug;
-	struct md_plug_cb *mdcb;
-
-	if (!plug)
-		return 0;
-
-	list_for_each_entry(mdcb, &plug->cb_list, cb.list) {
-		if (mdcb->cb.callback == plugger_unplug &&
-		    mdcb->mddev == mddev) {
-			/* Already on the list, move to top */
-			if (mdcb != list_first_entry(&plug->cb_list,
-						    struct md_plug_cb,
-						    cb.list))
-				list_move(&mdcb->cb.list, &plug->cb_list);
-			return 1;
-		}
-	}
-	/* Not currently on the callback list */
-	mdcb = kmalloc(sizeof(*mdcb), GFP_ATOMIC);
-	if (!mdcb)
-		return 0;
-
-	mdcb->mddev = mddev;
-	mdcb->cb.callback = plugger_unplug;
-	atomic_inc(&mddev->plug_cnt);
-	list_add(&mdcb->cb.list, &plug->cb_list);
-	return 1;
+	return blk_check_plugged(mddev->queue, mddev_unplug);
 }
 EXPORT_SYMBOL_GPL(mddev_check_plugged);
 
@@ -602,7 +562,6 @@ void mddev_init(struct mddev *mddev)
 	atomic_set(&mddev->active, 1);
 	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->active_io, 0);
-	atomic_set(&mddev->plug_cnt, 0);
 	spin_lock_init(&mddev->write_lock);
 	atomic_set(&mddev->flush_pending, 0);
 	init_waitqueue_head(&mddev->sb_wait);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7b4a3c3..91786c4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -266,9 +266,6 @@ struct mddev {
 	int				new_chunk_sectors;
 	int				reshape_backwards;
 
-	atomic_t			plug_cnt;	/* If device is expecting
-							 * more bios soon.
-							 */
 	struct md_thread		*thread;	/* management thread */
 	struct md_thread		*sync_thread;	/* doing resync or reconstruct */
 	sector_t			curr_resync;	/* last block scheduled */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 835de71..6e6d65f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2170,7 +2170,7 @@ static void raid1d(struct mddev *mddev)
 	blk_start_plug(&plug);
 	for (;;) {
 
-		if (atomic_read(&mddev->plug_cnt) == 0)
+		if (atomic_read(&mddev->queue->plug_cnt) == 0)
 			flush_pending_writes(conf);
 
 		spin_lock_irqsave(&conf->device_lock, flags);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d267672..e98bf00 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4521,7 +4521,7 @@ static void raid5d(struct mddev *mddev)
 	while (1) {
 		struct bio *bio;
 
-		if (atomic_read(&mddev->plug_cnt) == 0 &&
+		if (atomic_read(&mddev->queue->plug_cnt) == 0 &&
 		    !list_empty(&conf->bitmap_list)) {
 			/* Now is a good time to flush some bitmap updates */
 			conf->seq_flush++;
@@ -4531,7 +4531,7 @@ static void raid5d(struct mddev *mddev)
 			conf->seq_write = conf->seq_flush;
 			activate_bit_delay(conf);
 		}
-		if (atomic_read(&mddev->plug_cnt) == 0)
+		if (atomic_read(&mddev->queue->plug_cnt) == 0)
 			raid5_activate_delayed(conf);
 
 		while ((bio = remove_bio_from_retry(conf))) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba43f40..69945e4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -316,6 +316,9 @@ struct request_queue {
 	 * ll_rw_blk doesn't touch it.
 	 */
 	void			*queuedata;
+	atomic_t		plug_cnt;	/* If device is expecting
+						 * more bios soon.
+						 */
 
 	/*
 	 * various queue flags, see QUEUE_* below
@@ -914,12 +917,15 @@ struct blk_plug {
 
 struct blk_plug_cb {
 	struct list_head list;
-	void (*callback)(struct blk_plug_cb *);
+	struct request_queue *q;
+	void (*cb_fn)(struct blk_plug_cb *);
 };
+typedef void (plug_cb_fn) (struct blk_plug_cb *cb);
 
 extern void blk_start_plug(struct blk_plug *);
 extern void blk_finish_plug(struct blk_plug *);
 extern void blk_flush_plug_list(struct blk_plug *, bool);
+extern bool blk_check_plugged(struct request_queue *q, plug_cb_fn cb_fn);
 
 static inline void blk_flush_plug(struct task_struct *tsk)
 {
-- 
1.7.7.6

