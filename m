Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab1AVBTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:19:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:45789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab1AVBRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:17:36 -0500
From: Jens Axboe <jaxboe@fusionio.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH 04/10] block: initial patch for on-stack per-task plugging
Date: Sat, 22 Jan 2011 01:17:23 +0000
Message-Id: <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 01:17:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 block/blk-core.c          |  357 ++++++++++++++++++++++++++++++++------------
 block/elevator.c          |    6 +-
 include/linux/blk_types.h |    2 +
 include/linux/blkdev.h    |   30 ++++
 include/linux/elevator.h  |    1 +
 include/linux/sched.h     |    6 +
 kernel/exit.c             |    1 +
 kernel/fork.c             |    3 +
 kernel/sched.c            |   11 ++-
 9 files changed, 317 insertions(+), 100 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 960f12c..42dbfcc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -27,6 +27,7 @@
 #include <linux/writeback.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/fault-inject.h>
+#include <linux/list_sort.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/block.h>
@@ -213,7 +214,7 @@ static void blk_delay_work(struct work_struct *work)
 
 	q = container_of(work, struct request_queue, delay_work.work);
 	spin_lock_irq(q->queue_lock);
-	q->request_fn(q);
+	__blk_run_queue(q);
 	spin_unlock_irq(q->queue_lock);
 }
 
@@ -694,6 +695,8 @@ int blk_get_queue(struct request_queue *q)
 
 static inline void blk_free_request(struct request_queue *q, struct request *rq)
 {
+	BUG_ON(rq->cmd_flags & REQ_ON_PLUG);
+
 	if (rq->cmd_flags & REQ_ELVPRIV)
 		elv_put_request(q, rq);
 	mempool_free(rq, q->rq.rq_pool);
@@ -1038,6 +1041,13 @@ void blk_requeue_request(struct request_queue *q, struct request *rq)
 }
 EXPORT_SYMBOL(blk_requeue_request);
 
+static void add_acct_request(struct request_queue *q, struct request *rq,
+			     int where)
+{
+	drive_stat_acct(rq, 1);
+	__elv_add_request(q, rq, where, 0);
+}
+
 /**
  * blk_insert_request - insert a special request into a request queue
  * @q:		request queue where request should be inserted
@@ -1080,8 +1090,7 @@ void blk_insert_request(struct request_queue *q, struct request *rq,
 	if (blk_rq_tagged(rq))
 		blk_queue_end_tag(q, rq);
 
-	drive_stat_acct(rq, 1);
-	__elv_add_request(q, rq, where, 0);
+	add_acct_request(q, rq, where);
 	__blk_run_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
@@ -1202,6 +1211,113 @@ void blk_add_request_payload(struct request *rq, struct page *page,
 }
 EXPORT_SYMBOL_GPL(blk_add_request_payload);
 
+static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
+				   struct bio *bio)
+{
+	const int ff = bio->bi_rw & REQ_FAILFAST_MASK;
+
+	/*
+	 * Debug stuff, kill later
+	 */
+	if (!rq_mergeable(req)) {
+		blk_dump_rq_flags(req, "back");
+		return false;
+	}
+
+	if (!ll_back_merge_fn(q, req, bio))
+		return false;
+
+	trace_block_bio_backmerge(q, bio);
+
+	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
+		blk_rq_set_mixed_merge(req);
+
+	req->biotail->bi_next = bio;
+	req->biotail = bio;
+	req->__data_len += bio->bi_size;
+	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
+
+	drive_stat_acct(req, 0);
+	return true;
+}
+
+static bool bio_attempt_front_merge(struct request_queue *q,
+				    struct request *req, struct bio *bio)
+{
+	const int ff = bio->bi_rw & REQ_FAILFAST_MASK;
+	sector_t sector;
+
+	/*
+	 * Debug stuff, kill later
+	 */
+	if (!rq_mergeable(req)) {
+		blk_dump_rq_flags(req, "front");
+		return false;
+	}
+
+	if (!ll_front_merge_fn(q, req, bio))
+		return false;
+
+	trace_block_bio_frontmerge(q, bio);
+
+	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
+		blk_rq_set_mixed_merge(req);
+
+	sector = bio->bi_sector;
+
+	bio->bi_next = req->bio;
+	req->bio = bio;
+
+	/*
+	 * may not be valid. if the low level driver said
+	 * it didn't need a bounce buffer then it better
+	 * not touch req->buffer either...
+	 */
+	req->buffer = bio_data(bio);
+	req->__sector = bio->bi_sector;
+	req->__data_len += bio->bi_size;
+	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
+
+	drive_stat_acct(req, 0);
+	return true;
+}
+
+/*
+ * Attempts to merge with the plugged list in the current process. Returns
+ * true if merge was succesful, otherwise false.
+ */
+static bool check_plug_merge(struct task_struct *tsk, struct request_queue *q,
+			     struct bio *bio)
+{
+	struct blk_plug *plug;
+	struct request *rq;
+	bool ret = false;
+
+	plug = tsk->plug;
+	if (!plug)
+		goto out;
+
+	list_for_each_entry_reverse(rq, &plug->list, queuelist) {
+		int el_ret;
+
+		if (rq->q != q)
+			continue;
+
+		el_ret = elv_try_merge(rq, bio);
+		if (el_ret == ELEVATOR_BACK_MERGE) {
+			ret = bio_attempt_back_merge(q, rq, bio);
+			if (ret)
+				break;
+		} else if (el_ret == ELEVATOR_FRONT_MERGE) {
+			ret = bio_attempt_front_merge(q, rq, bio);
+			if (ret)
+				break;
+		}
+	}
+out:
+	return ret;
+}
+
 void init_request_from_bio(struct request *req, struct bio *bio)
 {
 	req->cpu = bio->bi_comp_cpu;
@@ -1217,26 +1333,12 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
-/*
- * Only disabling plugging for non-rotational devices if it does tagging
- * as well, otherwise we do need the proper merging
- */
-static inline bool queue_should_plug(struct request_queue *q)
-{
-	return !(blk_queue_nonrot(q) && blk_queue_tagged(q));
-}
-
 static int __make_request(struct request_queue *q, struct bio *bio)
 {
-	struct request *req;
-	int el_ret;
-	unsigned int bytes = bio->bi_size;
-	const unsigned short prio = bio_prio(bio);
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
-	const bool unplug = !!(bio->bi_rw & REQ_UNPLUG);
-	const unsigned long ff = bio->bi_rw & REQ_FAILFAST_MASK;
-	int where = ELEVATOR_INSERT_SORT;
-	int rw_flags;
+	struct blk_plug *plug;
+	int el_ret, rw_flags, where = ELEVATOR_INSERT_SORT;
+	struct request *req;
 
 	/*
 	 * low level driver can indicate that it wants pages above a
@@ -1245,78 +1347,36 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	 */
 	blk_queue_bounce(q, &bio);
 
-	spin_lock_irq(q->queue_lock);
-
 	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
+		spin_lock_irq(q->queue_lock);
 		where = ELEVATOR_INSERT_FRONT;
 		goto get_rq;
 	}
 
-	if (elv_queue_empty(q))
-		goto get_rq;
-
-	el_ret = elv_merge(q, &req, bio);
-	switch (el_ret) {
-	case ELEVATOR_BACK_MERGE:
-		BUG_ON(!rq_mergeable(req));
-
-		if (!ll_back_merge_fn(q, req, bio))
-			break;
-
-		trace_block_bio_backmerge(q, bio);
-
-		if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
-			blk_rq_set_mixed_merge(req);
-
-		req->biotail->bi_next = bio;
-		req->biotail = bio;
-		req->__data_len += bytes;
-		req->ioprio = ioprio_best(req->ioprio, prio);
-		if (!blk_rq_cpu_valid(req))
-			req->cpu = bio->bi_comp_cpu;
-		drive_stat_acct(req, 0);
-		elv_bio_merged(q, req, bio);
-		if (!attempt_back_merge(q, req))
-			elv_merged_request(q, req, el_ret);
+	/*
+	 * Check if we can merge with the plugged list before grabbing
+	 * any locks.
+	 */
+	if (check_plug_merge(current, q, bio))
 		goto out;
 
-	case ELEVATOR_FRONT_MERGE:
-		BUG_ON(!rq_mergeable(req));
-
-		if (!ll_front_merge_fn(q, req, bio))
-			break;
-
-		trace_block_bio_frontmerge(q, bio);
+	spin_lock_irq(q->queue_lock);
 
-		if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff) {
-			blk_rq_set_mixed_merge(req);
-			req->cmd_flags &= ~REQ_FAILFAST_MASK;
-			req->cmd_flags |= ff;
+	el_ret = elv_merge(q, &req, bio);
+	if (el_ret == ELEVATOR_BACK_MERGE) {
+		BUG_ON(req->cmd_flags & REQ_ON_PLUG);
+		if (bio_attempt_back_merge(q, req, bio)) {
+			if (!attempt_back_merge(q, req))
+				elv_merged_request(q, req, el_ret);
+			goto out_unlock;
+		}
+	} else if (el_ret == ELEVATOR_FRONT_MERGE) {
+		BUG_ON(req->cmd_flags & REQ_ON_PLUG);
+		if (bio_attempt_front_merge(q, req, bio)) {
+			if (!attempt_front_merge(q, req))
+				elv_merged_request(q, req, el_ret);
+			goto out_unlock;
 		}
-
-		bio->bi_next = req->bio;
-		req->bio = bio;
-
-		/*
-		 * may not be valid. if the low level driver said
-		 * it didn't need a bounce buffer then it better
-		 * not touch req->buffer either...
-		 */
-		req->buffer = bio_data(bio);
-		req->__sector = bio->bi_sector;
-		req->__data_len += bytes;
-		req->ioprio = ioprio_best(req->ioprio, prio);
-		if (!blk_rq_cpu_valid(req))
-			req->cpu = bio->bi_comp_cpu;
-		drive_stat_acct(req, 0);
-		elv_bio_merged(q, req, bio);
-		if (!attempt_front_merge(q, req))
-			elv_merged_request(q, req, el_ret);
-		goto out;
-
-	/* ELV_NO_MERGE: elevator says don't/can't merge. */
-	default:
-		;
 	}
 
 get_rq:
@@ -1343,20 +1403,35 @@ get_rq:
 	 */
 	init_request_from_bio(req, bio);
 
-	spin_lock_irq(q->queue_lock);
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
-	    bio_flagged(bio, BIO_CPU_AFFINE))
-		req->cpu = blk_cpu_to_group(smp_processor_id());
-	if (queue_should_plug(q) && elv_queue_empty(q))
-		blk_plug_device(q);
-
-	/* insert the request into the elevator */
-	drive_stat_acct(req, 1);
-	__elv_add_request(q, req, where, 0);
+	    bio_flagged(bio, BIO_CPU_AFFINE)) {
+		req->cpu = blk_cpu_to_group(get_cpu());
+		put_cpu();
+	}
+
+	plug = current->plug;
+	if (plug && !sync) {
+		if (!plug->should_sort && !list_empty(&plug->list)) {
+			struct request *__rq;
+
+			__rq = list_entry_rq(plug->list.prev);
+			if (__rq->q != q)
+				plug->should_sort = 1;
+		}
+		/*
+		 * Debug flag, kill later
+		 */
+		req->cmd_flags |= REQ_ON_PLUG;
+		list_add_tail(&req->queuelist, &plug->list);
+		drive_stat_acct(req, 1);
+	} else {
+		spin_lock_irq(q->queue_lock);
+		add_acct_request(q, req, where);
+		__blk_run_queue(q);
+out_unlock:
+		spin_unlock_irq(q->queue_lock);
+	}
 out:
-	if (unplug || !queue_should_plug(q))
-		__generic_unplug_device(q);
-	spin_unlock_irq(q->queue_lock);
 	return 0;
 }
 
@@ -1759,9 +1834,7 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	 */
 	BUG_ON(blk_queued_rq(rq));
 
-	drive_stat_acct(rq, 1);
-	__elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 0);
-
+	add_acct_request(q, rq, ELEVATOR_INSERT_BACK);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	return 0;
@@ -2646,6 +2719,94 @@ int kblockd_schedule_delayed_work(struct request_queue *q,
 }
 EXPORT_SYMBOL(kblockd_schedule_delayed_work);
 
+#define PLUG_MAGIC	0x91827364
+
+void blk_start_plug(struct blk_plug *plug)
+{
+	struct task_struct *tsk = current;
+
+	plug->magic = PLUG_MAGIC;
+	INIT_LIST_HEAD(&plug->list);
+	plug->should_sort = 0;
+
+	/*
+	 * Store ordering should not be needed here, since a potential
+	 * preempt will imply a full memory barrier
+	 */
+	tsk->plug = plug;
+}
+EXPORT_SYMBOL(blk_start_plug);
+
+static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct request *rqa = container_of(a, struct request, queuelist);
+	struct request *rqb = container_of(b, struct request, queuelist);
+
+	return !(rqa->q == rqb->q);
+}
+
+static void __blk_finish_plug(struct task_struct *tsk, struct blk_plug *plug)
+{
+	struct request_queue *q = NULL;
+	unsigned long flags;
+	struct request *rq;
+
+	local_irq_save(flags);
+
+	if (!list_empty(&plug->list) && plug != tsk->plug)
+		BUG();
+	if (plug == tsk->plug)
+		tsk->plug = NULL;
+
+	BUG_ON(plug->magic != PLUG_MAGIC);
+
+	if (plug->should_sort)
+		list_sort(NULL, &plug->list, plug_rq_cmp);
+
+	while (!list_empty(&plug->list)) {
+		rq = list_entry_rq(plug->list.next);
+		list_del_init(&rq->queuelist);
+		BUG_ON(!(rq->cmd_flags & REQ_ON_PLUG));
+		BUG_ON(!rq->q);
+		if (rq->q != q) {
+			if (q) {
+				__blk_run_queue(q);
+				spin_unlock(q->queue_lock);
+			}
+			q = rq->q;
+			spin_lock(q->queue_lock);
+		}
+		rq->cmd_flags &= ~REQ_ON_PLUG;
+
+		/*
+		 * rq is already accounted, so use raw insert
+		 */
+		__elv_add_request(q, rq, ELEVATOR_INSERT_SORT, 0);
+	}
+
+	if (q) {
+		__blk_run_queue(q);
+		spin_unlock(q->queue_lock);
+	}
+
+	BUG_ON(!list_empty(&plug->list));
+	local_irq_restore(flags);
+}
+
+void blk_finish_plug(struct blk_plug *plug)
+{
+	if (plug)
+		__blk_finish_plug(current, plug);
+}
+EXPORT_SYMBOL(blk_finish_plug);
+
+void __blk_flush_plug(struct task_struct *tsk, struct blk_plug *plug)
+{
+	__blk_finish_plug(tsk, plug);
+	tsk->plug = plug;
+}
+EXPORT_SYMBOL(__blk_flush_plug);
+
 int __init blk_dev_init(void)
 {
 	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
diff --git a/block/elevator.c b/block/elevator.c
index 2569512..a9fe237 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -113,7 +113,7 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 }
 EXPORT_SYMBOL(elv_rq_merge_ok);
 
-static inline int elv_try_merge(struct request *__rq, struct bio *bio)
+int elv_try_merge(struct request *__rq, struct bio *bio)
 {
 	int ret = ELEVATOR_NO_MERGE;
 
@@ -421,6 +421,8 @@ void elv_dispatch_sort(struct request_queue *q, struct request *rq)
 	struct list_head *entry;
 	int stop_flags;
 
+	BUG_ON(rq->cmd_flags & REQ_ON_PLUG);
+
 	if (q->last_merge == rq)
 		q->last_merge = NULL;
 
@@ -691,6 +693,8 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 void __elv_add_request(struct request_queue *q, struct request *rq, int where,
 		       int plug)
 {
+	BUG_ON(rq->cmd_flags & REQ_ON_PLUG);
+
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
 		if (rq->cmd_type == REQ_TYPE_FS ||
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 46ad519..a755762 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -151,6 +151,7 @@ enum rq_flag_bits {
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
+	__REQ_ON_PLUG,		/* on plug list */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -191,5 +192,6 @@ enum rq_flag_bits {
 #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 #define REQ_SECURE		(1 << __REQ_SECURE)
+#define REQ_ON_PLUG		(1 << __REQ_ON_PLUG)
 
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b4812f9..3d246a9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -864,6 +864,24 @@ struct request_queue *blk_alloc_queue(gfp_t);
 struct request_queue *blk_alloc_queue_node(gfp_t, int);
 extern void blk_put_queue(struct request_queue *);
 
+struct blk_plug {
+	unsigned long magic;
+	struct list_head list;
+	unsigned int should_sort;
+};
+
+extern void blk_start_plug(struct blk_plug *);
+extern void blk_finish_plug(struct blk_plug *);
+extern void __blk_flush_plug(struct task_struct *, struct blk_plug *);
+
+static inline void blk_flush_plug(struct task_struct *tsk)
+{
+	struct blk_plug *plug = tsk->plug;
+
+	if (unlikely(plug))
+		__blk_flush_plug(tsk, plug);
+}
+
 /*
  * tag stuff
  */
@@ -1287,6 +1305,18 @@ static inline long nr_blockdev_pages(void)
 	return 0;
 }
 
+static inline void blk_start_plug(struct list_head *list)
+{
+}
+
+static inline void blk_finish_plug(struct list_head *list)
+{
+}
+
+static inline void blk_flush_plug(struct task_struct *tsk)
+{
+}
+
 #endif /* CONFIG_BLOCK */
 
 #endif
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 4d85797..ac2b7a0 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -105,6 +105,7 @@ extern void elv_add_request(struct request_queue *, struct request *, int, int);
 extern void __elv_add_request(struct request_queue *, struct request *, int, int);
 extern void elv_insert(struct request_queue *, struct request *, int);
 extern int elv_merge(struct request_queue *, struct request **, struct bio *);
+extern int elv_try_merge(struct request *, struct bio *);
 extern void elv_merge_requests(struct request_queue *, struct request *,
 			       struct request *);
 extern void elv_merged_request(struct request_queue *, struct request *, int);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..ed74f1d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -99,6 +99,7 @@ struct robust_list_head;
 struct bio_list;
 struct fs_struct;
 struct perf_event_context;
+struct blk_plug;
 
 /*
  * List of flags we want to share for kernel threads,
@@ -1429,6 +1430,11 @@ struct task_struct {
 /* stacked block device info */
 	struct bio_list *bio_list;
 
+#ifdef CONFIG_BLOCK
+/* stack plugging */
+	struct blk_plug *plug;
+#endif
+
 /* VM state */
 	struct reclaim_state *reclaim_state;
 
diff --git a/kernel/exit.c b/kernel/exit.c
index f9a45eb..360f0f3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -908,6 +908,7 @@ NORET_TYPE void do_exit(long code)
 	profile_task_exit(tsk);
 
 	WARN_ON(atomic_read(&tsk->fs_excl));
+	WARN_ON(tsk->plug && !list_empty(&tsk->plug->list));
 
 	if (unlikely(in_interrupt()))
 		panic("Aiee, killing interrupt handler!");
diff --git a/kernel/fork.c b/kernel/fork.c
index 25e4291..027c80e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1204,6 +1204,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * Clear TID on mm_release()?
 	 */
 	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? child_tidptr: NULL;
+#ifdef CONFIG_BLOCK
+	p->plug = NULL;
+#endif
 #ifdef CONFIG_FUTEX
 	p->robust_list = NULL;
 #ifdef CONFIG_COMPAT
diff --git a/kernel/sched.c b/kernel/sched.c
index ea3e5ef..0d15f78 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3947,7 +3947,6 @@ need_resched:
 
 	release_kernel_lock(prev);
 need_resched_nonpreemptible:
-
 	schedule_debug(prev);
 
 	if (sched_feat(HRTICK))
@@ -3973,6 +3972,14 @@ need_resched_nonpreemptible:
 				if (to_wakeup)
 					try_to_wake_up_local(to_wakeup);
 			}
+			/*
+			 * If this task has IO plugged, make sure it
+			 * gets flushed out to the devices before we go
+			 * to sleep
+			 */
+			blk_flush_plug(prev);
+			BUG_ON(prev->plug && !list_empty(&prev->plug->list));
+
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 		}
 		switch_count = &prev->nvcsw;
@@ -5332,6 +5339,7 @@ void __sched io_schedule(void)
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	blk_flush_plug(current);
 	current->in_iowait = 1;
 	schedule();
 	current->in_iowait = 0;
@@ -5347,6 +5355,7 @@ long __sched io_schedule_timeout(long timeout)
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	blk_flush_plug(current);
 	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
 	current->in_iowait = 0;
-- 
1.7.3.2.146.gca209

