Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab1F1Phh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:37:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758542Ab1F1PfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:35:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Cc: andrea@betterlinux.com, vgoyal@redhat.com
Subject: [PATCH 6/8] blk-throttle: core logic to throttle task while dirtying pages
Date: Tue, 28 Jun 2011 11:35:07 -0400
Message-Id: <1309275309-12889-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the core logic which enables throttling logic to also
throttle tasks while dirtying pages. I basically create the
infrastructure where a wait queue is maintained per group
and if task exceeds its rate limit, task is put to sleep on
wait queue and woken up later.

Though currently we throttle tasks for WRITE requests and
not for READ requests, I have built the logic to support
task throttling for both direction (similar to bio throttling).
This will allow us to do any task READ throttling also easily,
if needed in future.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |  399 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 358 insertions(+), 41 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ec41f6d..be3b4b4 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -32,6 +32,12 @@ struct throtl_rb_root {
 	unsigned long min_disptime;
 };
 
+/* Whether to dispatch a bio or task in next round of a dispatch from a group */
+enum dispatch_type {
+	DISPATCH_BIO,
+	DISPATCH_TASK,
+};
+
 #define THROTL_RB_ROOT	(struct throtl_rb_root) { .rb = RB_ROOT, .left = NULL, \
 			.count = 0, .min_disptime = 0}
 
@@ -59,7 +65,10 @@ struct throtl_grp {
 	struct bio_list bio_lists[2];
 
 	/* Number of queued bios on READ and WRITE lists */
-	unsigned int nr_queued[2];
+	unsigned int nr_queued_bio[2];
+
+	/* Number of queued tasks */
+	unsigned int nr_queued_tsk[2];
 
 	/* bytes per second rate limits */
 	uint64_t bps[2];
@@ -80,6 +89,21 @@ struct throtl_grp {
 	int limits_changed;
 
 	struct rcu_head rcu_head;
+
+	/* READ and WRITE wait lists for task throttle */
+	wait_queue_head_t wait[2];
+
+	/* Number of unaccounted dirty pages in this group */
+	unsigned int unaccounted_dirty;
+
+	/* The number of pages to be charged to first task on wait queue */
+	unsigned int active_task_charge[2];
+
+	/*
+	 * Keeps track of whether we will dispatch a bio or task in next
+	 * round of dispatch (for each dir)
+	 */
+	enum dispatch_type active_dispatch[2];
 };
 
 struct throtl_data
@@ -94,7 +118,10 @@ struct throtl_data
 	struct request_queue *queue;
 
 	/* Total Number of queued bios on READ and WRITE lists */
-	unsigned int nr_queued[2];
+	unsigned int nr_queued_bio[2];
+
+	/* Total Number of queued tasks on READ and WRITE lists */
+	unsigned int nr_queued_tsk[2];
 
 	/*
 	 * number of total undestroyed groups
@@ -142,9 +169,19 @@ static inline struct throtl_grp *tg_of_blkg(struct blkio_group *blkg)
 	return NULL;
 }
 
+static inline int total_queued_bios(struct throtl_data *td)
+{
+	return td->nr_queued_bio[0] + td->nr_queued_bio[1];
+}
+
+static inline int total_queued_tasks(struct throtl_data *td)
+{
+	return td->nr_queued_tsk[0] + td->nr_queued_tsk[1];
+}
+
 static inline unsigned int total_nr_queued(struct throtl_data *td)
 {
-	return td->nr_queued[0] + td->nr_queued[1];
+	return total_queued_bios(td) + total_queued_tasks(td);
 }
 
 static inline struct throtl_grp *throtl_ref_get_tg(struct throtl_grp *tg)
@@ -192,6 +229,9 @@ static void throtl_init_group(struct throtl_grp *tg)
 	tg->bps[0] = tg->bps[1] = -1;
 	tg->iops[0] = tg->iops[1] = -1;
 
+	init_waitqueue_head(&tg->wait[READ]);
+	init_waitqueue_head(&tg->wait[WRITE]);
+
 	/*
 	 * Take the initial reference that will be released on destroy
 	 * This can be thought of a joint reference by cgroup and
@@ -727,6 +767,14 @@ static void throtl_charge_io(struct throtl_grp *tg, bool rw, unsigned int sz,
 	blkiocg_update_dispatch_stats(&tg->blkg, sz, nr_ios, rw, sync);
 }
 
+static void throtl_charge_dirty_io(struct throtl_grp *tg, bool rw,
+		unsigned int sz, unsigned int nr_ios, bool sync)
+{
+	tg->unaccounted_dirty -= nr_ios;
+	BUG_ON(tg->unaccounted_dirty < 0);
+	throtl_charge_io(tg, rw, sz, nr_ios, sync);
+}
+
 static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
 			struct bio *bio)
 {
@@ -735,21 +783,38 @@ static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
 	bio_list_add(&tg->bio_lists[rw], bio);
 	/* Take a bio reference on tg */
 	throtl_ref_get_tg(tg);
-	tg->nr_queued[rw]++;
-	td->nr_queued[rw]++;
+	tg->nr_queued_bio[rw]++;
+	td->nr_queued_bio[rw]++;
 	throtl_enqueue_tg(td, tg);
 }
 
-static void tg_update_disptime(struct throtl_data *td, struct throtl_grp *tg)
+/*
+ * Returns the wait time of first bio or task in the specified direction. If
+ * nothing is queued then wait time is -1.
+ */
+static unsigned long
+tg_active_wait_time(struct throtl_data *td, struct throtl_grp *tg, bool rw)
 {
-	unsigned long read_wait = -1, write_wait = -1, min_wait = -1, disptime;
 	struct bio *bio;
+	unsigned long sz;
 
-	if ((bio = bio_list_peek(&tg->bio_lists[READ])))
-		read_wait = tg_wait_dispatch(td, tg, READ, bio->bi_size, 1);
+	bio = bio_list_peek(&tg->bio_lists[rw]);
+	if (bio && tg->active_dispatch[rw] == DISPATCH_BIO)
+		return tg_wait_dispatch(td, tg, rw, bio->bi_size, 1);
 
-	if ((bio = bio_list_peek(&tg->bio_lists[WRITE])))
-		write_wait = tg_wait_dispatch(td, tg, WRITE, bio->bi_size, 1);
+	if (!waitqueue_active(&tg->wait[rw]))
+		return -1;
+
+	sz = tg->active_task_charge[rw] << PAGE_SHIFT;
+	return tg_wait_dispatch(td, tg, rw, sz, tg->active_task_charge[rw]);
+}
+
+static void tg_update_disptime(struct throtl_data *td, struct throtl_grp *tg)
+{
+	unsigned long read_wait, write_wait, min_wait, disptime;
+
+	read_wait = tg_active_wait_time(td, tg, READ);
+	write_wait = tg_active_wait_time(td, tg, WRITE);
 
 	min_wait = min(read_wait, write_wait);
 	disptime = jiffies + min_wait;
@@ -760,18 +825,39 @@ static void tg_update_disptime(struct throtl_data *td, struct throtl_grp *tg)
 	throtl_enqueue_tg(td, tg);
 }
 
+/* Calculate how many pages must be charged to a task at this point of time. */
+static unsigned int tg_calc_charge_pages(struct throtl_grp *tg, bool rw)
+{
+	unsigned int nr_pages;
+
+	/* Divide unaccounted number of pages among queued tasks */
+	nr_pages = tg->unaccounted_dirty/tg->nr_queued_tsk[rw];
+
+	return max_t(unsigned int, nr_pages, 1);
+}
+
+/* set the active task charge for the first task in the queue */
+static void tg_set_active_task_charge(struct throtl_grp *tg, bool rw)
+{
+	/* If there are more tasks queued, calculate the charge */
+	if (tg->nr_queued_tsk[rw])
+		tg->active_task_charge[rw] = tg_calc_charge_pages(tg, rw);
+	else
+		tg->active_task_charge[rw] = 0;
+}
+
 static void tg_dispatch_one_bio(struct throtl_data *td, struct throtl_grp *tg,
 				bool rw, struct bio_list *bl)
 {
 	struct bio *bio;
 
 	bio = bio_list_pop(&tg->bio_lists[rw]);
-	tg->nr_queued[rw]--;
+	tg->nr_queued_bio[rw]--;
 	/* Drop bio reference on tg */
 	throtl_put_tg(tg);
 
-	BUG_ON(td->nr_queued[rw] <= 0);
-	td->nr_queued[rw]--;
+	BUG_ON(td->nr_queued_bio[rw] <= 0);
+	td->nr_queued_bio[rw]--;
 
 	throtl_charge_io(tg, rw, bio->bi_size, 1, bio->bi_rw & REQ_SYNC);
 	bio_list_add(bl, bio);
@@ -780,39 +866,137 @@ static void tg_dispatch_one_bio(struct throtl_data *td, struct throtl_grp *tg,
 	throtl_trim_slice(td, tg, rw);
 }
 
-static int throtl_dispatch_tg(struct throtl_data *td, struct throtl_grp *tg,
-				struct bio_list *bl)
+static int throtl_dispatch_tg_bio(struct throtl_data *td, struct throtl_grp *tg,
+			bool rw, struct bio_list *bl, unsigned int max_disp)
 {
-	unsigned int nr_reads = 0, nr_writes = 0;
-	unsigned int max_nr_reads = throtl_grp_quantum*3/4;
-	unsigned int max_nr_writes = throtl_grp_quantum - max_nr_reads;
 	struct bio *bio;
+	unsigned int nr_disp = 0;
 
-	/* Try to dispatch 75% READS and 25% WRITES */
-
-	while ((bio = bio_list_peek(&tg->bio_lists[READ]))
-		&& !tg_wait_dispatch(td, tg, READ, bio->bi_size, 1)) {
+	while ((bio = bio_list_peek(&tg->bio_lists[rw]))
+		&& !tg_wait_dispatch(td, tg, rw, bio->bi_size, 1)) {
 
 		tg_dispatch_one_bio(td, tg, bio_data_dir(bio), bl);
-		nr_reads++;
+		nr_disp++;
 
-		if (nr_reads >= max_nr_reads)
+		if (nr_disp >= max_disp)
 			break;
 	}
 
-	while ((bio = bio_list_peek(&tg->bio_lists[WRITE]))
-		&& !tg_wait_dispatch(td, tg, WRITE, bio->bi_size, 1)) {
+	return nr_disp;
+}
 
-		tg_dispatch_one_bio(td, tg, bio_data_dir(bio), bl);
-		nr_writes++;
+static void throtl_dispatch_tg_task(struct throtl_data *td,
+		struct throtl_grp *tg, bool rw, unsigned int max_disp)
+{
+	unsigned int sz;
 
-		if (nr_writes >= max_nr_writes)
-			break;
+	if (!waitqueue_active(&tg->wait[rw]))
+		return;
+
+	/* Wake up a task */
+	wake_up(&tg->wait[rw]);
+
+	tg->nr_queued_tsk[rw]--;
+	td->nr_queued_tsk[rw]--;
+
+	/* Charge the woken up task for IO */
+	sz = tg->active_task_charge[rw] << PAGE_SHIFT;
+	throtl_charge_dirty_io(tg, rw, sz, tg->active_task_charge[rw], false);
+	throtl_trim_slice(td, tg, rw);
+
+	/*
+	 * We dispatched one task. Set the charge for other queued tasks,
+	 * if any.
+	 */
+	tg_set_active_task_charge(tg, rw);
+	throtl_log_tg(td, tg, "[%c] Wake up a task. bdisp=%u sz=%u bps=%llu"
+			" iodisp=%u iops=%u bioq=%d/%d taskq=%d/%d",
+			rw == READ ? 'R' : 'W', tg->bytes_disp[rw], sz,
+			tg->bps[rw], tg->io_disp[rw], tg->iops[rw],
+			tg->nr_queued_bio[READ], tg->nr_queued_bio[WRITE],
+			tg->nr_queued_tsk[READ], tg->nr_queued_tsk[WRITE]);
+}
+
+static void tg_switch_active_dispatch(struct throtl_data *td,
+			struct throtl_grp *tg, bool rw)
+{
+	unsigned int nr_tasks = tg->nr_queued_tsk[rw];
+	unsigned int nr_bios = tg->nr_queued_bio[rw];
+	enum dispatch_type curr_dispatch = tg->active_dispatch[rw];
+
+	/* Nothing queued. Whoever gets queued next first, sets dispatch type */
+	if (!nr_bios && !nr_tasks)
+		return;
+
+	if (curr_dispatch == DISPATCH_BIO && nr_tasks) {
+		tg->active_dispatch[rw] = DISPATCH_TASK;
+		return;
+	}
+
+	if (curr_dispatch == DISPATCH_TASK && nr_bios)
+		tg->active_dispatch[rw] = DISPATCH_BIO;
+}
+
+static void tg_update_active_dispatch(struct throtl_data *td,
+			struct throtl_grp *tg, bool rw)
+{
+	unsigned int nr_tasks = tg->nr_queued_tsk[rw];
+	unsigned int nr_bios = tg->nr_queued_bio[rw];
+	enum dispatch_type curr_dispatch = tg->active_dispatch[rw];
+
+	BUG_ON(nr_bios < 0 || nr_tasks < 0);
+
+	if (curr_dispatch == DISPATCH_BIO && !nr_bios) {
+		tg->active_dispatch[rw] = DISPATCH_TASK;
+		return;
 	}
 
+	if (curr_dispatch == DISPATCH_TASK && !nr_tasks)
+		tg->active_dispatch[rw] = DISPATCH_BIO;
+}
+
+static int throtl_dispatch_tg_rw(struct throtl_data *td, struct throtl_grp *tg,
+			bool rw, struct bio_list *bl, unsigned int max)
+{
+	unsigned int nr_disp = 0;
+
+	if (tg->active_dispatch[rw] == DISPATCH_BIO)
+		nr_disp = throtl_dispatch_tg_bio(td, tg, rw, bl, max);
+	else
+		/* Only number of bios dispatched is kept track of here */
+		throtl_dispatch_tg_task(td, tg, rw, max);
+
+	tg_switch_active_dispatch(td, tg, rw);
+	return nr_disp;
+}
+
+static int throtl_dispatch_tg(struct throtl_data *td, struct throtl_grp *tg,
+				struct bio_list *bl)
+{
+	/* Try to dispatch 75% READS and 25% WRITES */
+	unsigned int nr_reads = 0, nr_writes = 0;
+	unsigned int max_nr_reads = throtl_grp_quantum*3/4;
+	unsigned int max_nr_writes = throtl_grp_quantum - max_nr_reads;
+
+	nr_reads = throtl_dispatch_tg_rw(td, tg, READ, bl, max_nr_reads);
+	nr_writes = throtl_dispatch_tg_rw(td, tg, WRITE, bl, max_nr_writes);
+
 	return nr_reads + nr_writes;
 }
 
+static bool tg_should_requeue(struct throtl_grp *tg)
+{
+	/* If there are queued bios, requeue */
+	if (tg->nr_queued_bio[0] || tg->nr_queued_bio[1])
+		return 1;
+
+	/* If there are queued tasks reueue */
+	if (tg->nr_queued_tsk[0] || tg->nr_queued_tsk[1])
+		return 1;
+
+	return 0;
+}
+
 static int throtl_select_dispatch(struct throtl_data *td, struct bio_list *bl)
 {
 	unsigned int nr_disp = 0;
@@ -832,7 +1016,7 @@ static int throtl_select_dispatch(struct throtl_data *td, struct bio_list *bl)
 
 		nr_disp += throtl_dispatch_tg(td, tg, bl);
 
-		if (tg->nr_queued[0] || tg->nr_queued[1]) {
+		if (tg_should_requeue(tg)) {
 			tg_update_disptime(td, tg);
 			throtl_enqueue_tg(td, tg);
 		}
@@ -899,9 +1083,9 @@ static int throtl_dispatch(struct request_queue *q)
 
 	bio_list_init(&bio_list_on_stack);
 
-	throtl_log(td, "dispatch nr_queued=%u read=%u write=%u",
-			total_nr_queued(td), td->nr_queued[READ],
-			td->nr_queued[WRITE]);
+	throtl_log(td, "dispatch bioq=%u/%u tskq=%u/%u",
+			td->nr_queued_bio[READ], td->nr_queued_bio[WRITE],
+			td->nr_queued_tsk[READ], td->nr_queued_tsk[WRITE]);
 
 	nr_disp = throtl_select_dispatch(td, &bio_list_on_stack);
 
@@ -1122,7 +1306,7 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 
 		if (tg_no_rule_group(tg, rw)) {
 			blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size,
-					rw, bio->bi_rw & REQ_SYNC);
+					1, rw, bio->bi_rw & REQ_SYNC);
 			rcu_read_unlock();
 			return 0;
 		}
@@ -1146,14 +1330,14 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 		}
 	}
 
-	if (tg->nr_queued[rw]) {
+	/* If there are already queued bio or task in same dir, queue bio */
+	if (tg->nr_queued_bio[rw] || tg->nr_queued_tsk[rw]) {
 		/*
-		 * There is already another bio queued in same dir. No
+		 * There is already another bio/task queued in same dir. No
 		 * need to update dispatch time.
 		 */
 		update_disptime = false;
 		goto queue_bio;
-
 	}
 
 	/* Bio is with-in rate limit of group */
@@ -1178,16 +1362,18 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 
 queue_bio:
 	throtl_log_tg(td, tg, "[%c] bio. bdisp=%llu sz=%u bps=%llu"
-			" iodisp=%u iops=%u queued=%d/%d",
+			" iodisp=%u iops=%u bioq=%u/%u taskq=%u/%u",
 			rw == READ ? 'R' : 'W',
 			tg->bytes_disp[rw], bio->bi_size, tg->bps[rw],
 			tg->io_disp[rw], tg->iops[rw],
-			tg->nr_queued[READ], tg->nr_queued[WRITE]);
+			tg->nr_queued_bio[READ], tg->nr_queued_bio[WRITE],
+			tg->nr_queued_tsk[READ], tg->nr_queued_tsk[WRITE]);
 
 	throtl_add_bio_tg(q->td, tg, bio);
 	*biop = NULL;
 
 	if (update_disptime) {
+		tg_update_active_dispatch(td, tg, rw);
 		tg_update_disptime(td, tg);
 		throtl_schedule_next_dispatch(td);
 	}
@@ -1197,6 +1383,137 @@ out:
 	return 0;
 }
 
+static void
+__blk_throtl_dirty_pages(struct request_queue *q, unsigned long nr_dirty)
+{
+	struct throtl_data *td = q->td;
+	struct throtl_grp *tg;
+	struct blkio_cgroup *blkcg;
+	bool rw = WRITE, update_disptime = true, first_task = false;
+	unsigned int sz = nr_dirty << PAGE_SHIFT;
+	DEFINE_WAIT(wait);
+
+	/*
+	 * A throtl_grp pointer retrieved under rcu can be used to access
+	 * basic fields like stats and io rates. If a group has no rules,
+	 * just update the dispatch stats in lockless manner and return.
+	 */
+
+	rcu_read_lock();
+	blkcg = task_blkio_cgroup(current);
+	tg = throtl_find_tg(td, blkcg);
+	if (tg) {
+		throtl_tg_fill_dev_details(td, tg);
+
+		if (tg_no_rule_group(tg, rw)) {
+			blkiocg_update_dispatch_stats(&tg->blkg, sz, nr_dirty,
+							rw, 0);
+			rcu_read_unlock();
+			return;
+		}
+	}
+	rcu_read_unlock();
+
+	spin_lock_irq(q->queue_lock);
+
+	tg = throtl_get_tg(td);
+
+	/*  Queue is gone. No queue lock held here. */
+	if (IS_ERR(tg))
+		return;
+
+	tg->unaccounted_dirty += nr_dirty;
+
+	/* If there are already queued task, put this task also on waitq */
+	if (tg->nr_queued_tsk[rw]) {
+		update_disptime = false;
+		goto queue_task;
+	} else
+		first_task = true;
+
+	/* If there are bios already throttled in same dir, queue task */
+	if (!bio_list_empty(&tg->bio_lists[rw])) {
+		update_disptime = false;
+		goto queue_task;
+	}
+
+	/*
+	 * Task is with-in rate limit of group.
+	 *
+	 * Note: How many IOPS we should charge for this operation. For
+	 * the time being I am sticking to number of pages as number of
+	 * IOPS.
+	 */
+	if (!tg_wait_dispatch(td, tg, rw, sz, nr_dirty)) {
+		throtl_charge_dirty_io(tg, rw, sz, nr_dirty, 0);
+		throtl_trim_slice(td, tg, rw);
+		goto out;
+	}
+
+queue_task:
+	throtl_log_tg(td, tg, "[%c] task. bdisp=%u sz=%u bps=%llu"
+			" iodisp=%u iops=%u bioq=%d/%d taskq=%d/%d",
+			rw == READ ? 'R' : 'W',
+			tg->bytes_disp[rw], sz, tg->bps[rw],
+			tg->io_disp[rw], tg->iops[rw],
+			tg->nr_queued_bio[READ], tg->nr_queued_bio[WRITE],
+			tg->nr_queued_tsk[READ], tg->nr_queued_tsk[WRITE]);
+
+	/* Take a task reference on tg */
+	throtl_ref_get_tg(tg);
+	tg->nr_queued_tsk[rw]++;
+	td->nr_queued_tsk[rw]++;
+	prepare_to_wait_exclusive(&tg->wait[rw], &wait, TASK_UNINTERRUPTIBLE);
+
+	if (first_task)
+		tg_set_active_task_charge(tg, rw);
+
+	if (update_disptime) {
+		tg_update_active_dispatch(td, tg, rw);
+		tg_update_disptime(td, tg);
+		throtl_schedule_next_dispatch(td);
+	} else
+		throtl_enqueue_tg(td, tg);
+
+	spin_unlock_irq(q->queue_lock);
+
+	/* Task has been put on a wait queue */
+	io_schedule();
+
+	/*
+	 * Task has woken up. Finish wait, drop reference to the group.
+	 */
+	spin_lock_irq(q->queue_lock);
+	finish_wait(&tg->wait[rw], &wait);
+
+	/* Drop task reference on group */
+	throtl_put_tg(tg);
+out:
+	spin_unlock_irq(q->queue_lock);
+	return;
+}
+
+void
+blk_throtl_dirty_pages(struct address_space *mapping, unsigned long nr_dirty)
+{
+	struct request_queue *q;
+	struct block_device *bdev;
+
+	bdev = mapping->host->i_sb->s_bdev;
+	if (!bdev)
+		return;
+	q = bdev_get_queue(bdev);
+
+	if (unlikely(!q))
+		return;
+
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		return;
+
+	__blk_throtl_dirty_pages(q, nr_dirty);
+}
+
+
 int blk_throtl_init(struct request_queue *q)
 {
 	struct throtl_data *td;
-- 
1.7.4.4

