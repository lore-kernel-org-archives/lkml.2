Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0GERLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:11:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41320 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab0GERLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:11:50 -0400
Date: Mon, 5 Jul 2010 19:11:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending() (was: Linux 2.6.35-rc4)
Message-ID: <20100705171125.GB26202@elte.hu>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
 <20100705085550.GA26775@elte.hu>
 <20100705164022.GA26995@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705164022.GA26995@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> We had a thread about it a few days ago.  The following commit from
> Jens' 2.6.36 tree needs to go into 2.6.35 to sort the issues with the
> fragile wakeup mechanism which only got worse by the patches out:
> 	
> 	http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=79338d2a78ab78efdc1698f1309766a039addf9d

I've attached it below - in case someone wants to apply it before it hits 
upstream.

Scary big patch btw. - is there no smaller fix?

	Ingo

------------------------>
>From 79338d2a78ab78efdc1698f1309766a039addf9d Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sat, 19 Jun 2010 23:07:56 +0200
Subject: [PATCH] writeback: simplify the write back thread queue

First remove items from work_list as soon as we start working on them.  This
means we don't have to track any pending or visited state and can get
rid of all the RCU magic freeing the work items - we can simply free
them once the operation has finished.  Second use a real completion for
tracking synchronous requests - if the caller sets the completion pointer
we complete it, otherwise use it as a boolean indicator that we can free
the work item directly.  Third unify struct wb_writeback_args and struct
bdi_work into a single data structure, wb_writeback_work.  Previous we
set all parameters into a struct wb_writeback_args, copied it into
struct bdi_work, copied it again on the stack to use it there.  Instead
of just allocate one structure dynamically or on the stack and use it
all the way through the stack.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 fs/fs-writeback.c           |  253 ++++++++++++-------------------------------
 include/linux/backing-dev.h |    2 -
 mm/backing-dev.c            |   14 +--
 3 files changed, 72 insertions(+), 197 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5455009..d5be169 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -38,43 +38,18 @@ int nr_pdflush_threads;
 /*
  * Passed into wb_writeback(), essentially a subset of writeback_control
  */
-struct wb_writeback_args {
+struct wb_writeback_work {
 	long nr_pages;
 	struct super_block *sb;
 	enum writeback_sync_modes sync_mode;
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
-};
 
-/*
- * Work items for the bdi_writeback threads
- */
-struct bdi_work {
 	struct list_head list;		/* pending work list */
-	struct rcu_head rcu_head;	/* for RCU free/clear of work */
-
-	unsigned long seen;		/* threads that have seen this work */
-	atomic_t pending;		/* number of threads still to do work */
-
-	struct wb_writeback_args args;	/* writeback arguments */
-
-	unsigned long state;		/* flag bits, see WS_* */
-};
-
-enum {
-	WS_INPROGRESS = 0,
-	WS_ONSTACK,
+	struct completion *done;	/* set if the caller waits */
 };
 
-static inline void bdi_work_init(struct bdi_work *work,
-				 struct wb_writeback_args *args)
-{
-	INIT_RCU_HEAD(&work->rcu_head);
-	work->args = *args;
-	__set_bit(WS_INPROGRESS, &work->state);
-}
-
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
@@ -87,49 +62,11 @@ int writeback_in_progress(struct backing_dev_info *bdi)
 	return !list_empty(&bdi->work_list);
 }
 
-static void bdi_work_free(struct rcu_head *head)
-{
-	struct bdi_work *work = container_of(head, struct bdi_work, rcu_head);
-
-	clear_bit(WS_INPROGRESS, &work->state);
-	smp_mb__after_clear_bit();
-	wake_up_bit(&work->state, WS_INPROGRESS);
-
-	if (!test_bit(WS_ONSTACK, &work->state))
-		kfree(work);
-}
-
-static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
-{
-	/*
-	 * The caller has retrieved the work arguments from this work,
-	 * drop our reference. If this is the last ref, delete and free it
-	 */
-	if (atomic_dec_and_test(&work->pending)) {
-		struct backing_dev_info *bdi = wb->bdi;
-
-		spin_lock(&bdi->wb_lock);
-		list_del_rcu(&work->list);
-		spin_unlock(&bdi->wb_lock);
-
-		call_rcu(&work->rcu_head, bdi_work_free);
-	}
-}
-
-static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
+static void bdi_queue_work(struct backing_dev_info *bdi,
+		struct wb_writeback_work *work)
 {
-	work->seen = bdi->wb_mask;
-	BUG_ON(!work->seen);
-	atomic_set(&work->pending, bdi->wb_cnt);
-	BUG_ON(!bdi->wb_cnt);
-
-	/*
-	 * list_add_tail_rcu() contains the necessary barriers to
-	 * make sure the above stores are seen before the item is
-	 * noticed on the list
-	 */
 	spin_lock(&bdi->wb_lock);
-	list_add_tail_rcu(&work->list, &bdi->work_list);
+	list_add_tail(&work->list, &bdi->work_list);
 	spin_unlock(&bdi->wb_lock);
 
 	/*
@@ -146,55 +83,29 @@ static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
 	}
 }
 
-/*
- * Used for on-stack allocated work items. The caller needs to wait until
- * the wb threads have acked the work before it's safe to continue.
- */
-static void bdi_wait_on_work_done(struct bdi_work *work)
-{
-	wait_on_bit(&work->state, WS_INPROGRESS, bdi_sched_wait,
-		    TASK_UNINTERRUPTIBLE);
-}
-
-static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
-				 struct wb_writeback_args *args)
+static void
+__bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
+		bool range_cyclic, bool for_background)
 {
-	struct bdi_work *work;
+	struct wb_writeback_work *work;
 
 	/*
 	 * This is WB_SYNC_NONE writeback, so if allocation fails just
 	 * wakeup the thread for old dirty data writeback
 	 */
-	work = kmalloc(sizeof(*work), GFP_ATOMIC);
-	if (work) {
-		bdi_work_init(work, args);
-		bdi_queue_work(bdi, work);
-	} else {
-		struct bdi_writeback *wb = &bdi->wb;
-
-		if (wb->task)
-			wake_up_process(wb->task);
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work) {
+		if (bdi->wb.task)
+			wake_up_process(bdi->wb.task);
+		return;
 	}
-}
 
-/**
- * bdi_queue_work_onstack - start and wait for writeback
- * @sb: write inodes from this super_block
- *
- * Description:
- *   This function initiates writeback and waits for the operation to
- *   complete. Callers must hold the sb s_umount semaphore for
- *   reading, to avoid having the super disappear before we are done.
- */
-static void bdi_queue_work_onstack(struct wb_writeback_args *args)
-{
-	struct bdi_work work;
+	work->sync_mode	= WB_SYNC_NONE;
+	work->nr_pages	= nr_pages;
+	work->range_cyclic = range_cyclic;
+	work->for_background = for_background;
 
-	bdi_work_init(&work, args);
-	__set_bit(WS_ONSTACK, &work.state);
-
-	bdi_queue_work(args->sb->s_bdi, &work);
-	bdi_wait_on_work_done(&work);
+	bdi_queue_work(bdi, work);
 }
 
 /**
@@ -210,13 +121,7 @@ static void bdi_queue_work_onstack(struct wb_writeback_args *args)
  */
 void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages)
 {
-	struct wb_writeback_args args = {
-		.sync_mode	= WB_SYNC_NONE,
-		.nr_pages	= nr_pages,
-		.range_cyclic	= 1,
-	};
-
-	bdi_alloc_queue_work(bdi, &args);
+	__bdi_start_writeback(bdi, nr_pages, true, false);
 }
 
 /**
@@ -230,13 +135,7 @@ void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages)
  */
 void bdi_start_background_writeback(struct backing_dev_info *bdi)
 {
-	struct wb_writeback_args args = {
-		.sync_mode	= WB_SYNC_NONE,
-		.nr_pages	= LONG_MAX,
-		.for_background = 1,
-		.range_cyclic	= 1,
-	};
-	bdi_alloc_queue_work(bdi, &args);
+	__bdi_start_writeback(bdi, LONG_MAX, true, true);
 }
 
 /*
@@ -703,14 +602,14 @@ static inline bool over_bground_thresh(void)
  * all dirty pages if they are all attached to "old" mappings.
  */
 static long wb_writeback(struct bdi_writeback *wb,
-			 struct wb_writeback_args *args)
+			 struct wb_writeback_work *work)
 {
 	struct writeback_control wbc = {
-		.sync_mode		= args->sync_mode,
+		.sync_mode		= work->sync_mode,
 		.older_than_this	= NULL,
-		.for_kupdate		= args->for_kupdate,
-		.for_background		= args->for_background,
-		.range_cyclic		= args->range_cyclic,
+		.for_kupdate		= work->for_kupdate,
+		.for_background		= work->for_background,
+		.range_cyclic		= work->range_cyclic,
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
@@ -730,24 +629,24 @@ static long wb_writeback(struct bdi_writeback *wb,
 		/*
 		 * Stop writeback when nr_pages has been consumed
 		 */
-		if (args->nr_pages <= 0)
+		if (work->nr_pages <= 0)
 			break;
 
 		/*
 		 * For background writeout, stop when we are below the
 		 * background dirty threshold
 		 */
-		if (args->for_background && !over_bground_thresh())
+		if (work->for_background && !over_bground_thresh())
 			break;
 
 		wbc.more_io = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
-		if (args->sb)
-			__writeback_inodes_sb(args->sb, wb, &wbc);
+		if (work->sb)
+			__writeback_inodes_sb(work->sb, wb, &wbc);
 		else
 			writeback_inodes_wb(wb, &wbc);
-		args->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		work->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 
 		/*
@@ -783,31 +682,21 @@ static long wb_writeback(struct bdi_writeback *wb,
 }
 
 /*
- * Return the next bdi_work struct that hasn't been processed by this
- * wb thread yet. ->seen is initially set for each thread that exists
- * for this device, when a thread first notices a piece of work it
- * clears its bit. Depending on writeback type, the thread will notify
- * completion on either receiving the work (WB_SYNC_NONE) or after
- * it is done (WB_SYNC_ALL).
+ * Return the next wb_writeback_work struct that hasn't been processed yet.
  */
-static struct bdi_work *get_next_work_item(struct backing_dev_info *bdi,
-					   struct bdi_writeback *wb)
+static struct wb_writeback_work *
+get_next_work_item(struct backing_dev_info *bdi, struct bdi_writeback *wb)
 {
-	struct bdi_work *work, *ret = NULL;
-
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(work, &bdi->work_list, list) {
-		if (!test_bit(wb->nr, &work->seen))
-			continue;
-		clear_bit(wb->nr, &work->seen);
+	struct wb_writeback_work *work = NULL;
 
-		ret = work;
-		break;
+	spin_lock(&bdi->wb_lock);
+	if (!list_empty(&bdi->work_list)) {
+		work = list_entry(bdi->work_list.next,
+				  struct wb_writeback_work, list);
+		list_del_init(&work->list);
 	}
-
-	rcu_read_unlock();
-	return ret;
+	spin_unlock(&bdi->wb_lock);
+	return work;
 }
 
 static long wb_check_old_data_flush(struct bdi_writeback *wb)
@@ -832,14 +721,14 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 
 	if (nr_pages) {
-		struct wb_writeback_args args = {
+		struct wb_writeback_work work = {
 			.nr_pages	= nr_pages,
 			.sync_mode	= WB_SYNC_NONE,
 			.for_kupdate	= 1,
 			.range_cyclic	= 1,
 		};
 
-		return wb_writeback(wb, &args);
+		return wb_writeback(wb, &work);
 	}
 
 	return 0;
@@ -851,33 +740,27 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 {
 	struct backing_dev_info *bdi = wb->bdi;
-	struct bdi_work *work;
+	struct wb_writeback_work *work;
 	long wrote = 0;
 
 	while ((work = get_next_work_item(bdi, wb)) != NULL) {
-		struct wb_writeback_args args = work->args;
-
 		/*
 		 * Override sync mode, in case we must wait for completion
+		 * because this thread is exiting now.
 		 */
 		if (force_wait)
-			work->args.sync_mode = args.sync_mode = WB_SYNC_ALL;
+			work->sync_mode = WB_SYNC_ALL;
 
-		/*
-		 * If this isn't a data integrity operation, just notify
-		 * that we have seen this work and we are now starting it.
-		 */
-		if (!test_bit(WS_ONSTACK, &work->state))
-			wb_clear_pending(wb, work);
-
-		wrote += wb_writeback(wb, &args);
+		wrote += wb_writeback(wb, work);
 
 		/*
-		 * This is a data integrity writeback, so only do the
-		 * notification when we have completed the work.
+		 * Notify the caller of completion if this is a synchronous
+		 * work item, otherwise just free it.
 		 */
-		if (test_bit(WS_ONSTACK, &work->state))
-			wb_clear_pending(wb, work);
+		if (work->done)
+			complete(work->done);
+		else
+			kfree(work);
 	}
 
 	/*
@@ -940,14 +823,9 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 void wakeup_flusher_threads(long nr_pages)
 {
 	struct backing_dev_info *bdi;
-	struct wb_writeback_args args = {
-		.sync_mode	= WB_SYNC_NONE,
-	};
 
-	if (nr_pages) {
-		args.nr_pages = nr_pages;
-	} else {
-		args.nr_pages = global_page_state(NR_FILE_DIRTY) +
+	if (!nr_pages) {
+		nr_pages = global_page_state(NR_FILE_DIRTY) +
 				global_page_state(NR_UNSTABLE_NFS);
 	}
 
@@ -955,7 +833,7 @@ void wakeup_flusher_threads(long nr_pages)
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		if (!bdi_has_dirty_io(bdi))
 			continue;
-		bdi_alloc_queue_work(bdi, &args);
+		__bdi_start_writeback(bdi, nr_pages, false, false);
 	}
 	rcu_read_unlock();
 }
@@ -1164,17 +1042,20 @@ void writeback_inodes_sb(struct super_block *sb)
 {
 	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
 	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
-	struct wb_writeback_args args = {
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_NONE,
+		.done		= &done,
 	};
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	args.nr_pages = nr_dirty + nr_unstable +
+	work.nr_pages = nr_dirty + nr_unstable +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 
-	bdi_queue_work_onstack(&args);
+	bdi_queue_work(sb->s_bdi, &work);
+	wait_for_completion(&done);
 }
 EXPORT_SYMBOL(writeback_inodes_sb);
 
@@ -1206,16 +1087,20 @@ EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
  */
 void sync_inodes_sb(struct super_block *sb)
 {
-	struct wb_writeback_args args = {
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_ALL,
 		.nr_pages	= LONG_MAX,
 		.range_cyclic	= 0,
+		.done		= &done,
 	};
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	bdi_queue_work_onstack(&args);
+	bdi_queue_work(sb->s_bdi, &work);
+	wait_for_completion(&done);
+
 	wait_sb_inodes(sb);
 }
 EXPORT_SYMBOL(sync_inodes_sb);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 9ae2889..e9aec0d 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -82,8 +82,6 @@ struct backing_dev_info {
 	struct bdi_writeback wb;  /* default writeback info for this bdi */
 	spinlock_t wb_lock;	  /* protects update side of wb_list */
 	struct list_head wb_list; /* the flusher threads hanging off this bdi */
-	unsigned long wb_mask;	  /* bitmask of registered tasks */
-	unsigned int wb_cnt;	  /* number of registered tasks */
 
 	struct list_head work_list;
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 6e0b09a..123bcef 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -104,15 +104,13 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   "b_more_io:        %8lu\n"
 		   "bdi_list:         %8u\n"
 		   "state:            %8lx\n"
-		   "wb_mask:          %8lx\n"
-		   "wb_list:          %8u\n"
-		   "wb_cnt:           %8u\n",
+		   "wb_list:          %8u\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
 		   K(bdi_thresh), K(dirty_thresh),
 		   K(background_thresh), nr_wb, nr_dirty, nr_io, nr_more_io,
-		   !list_empty(&bdi->bdi_list), bdi->state, bdi->wb_mask,
-		   !list_empty(&bdi->wb_list), bdi->wb_cnt);
+		   !list_empty(&bdi->bdi_list), bdi->state,
+		   !list_empty(&bdi->wb_list));
 #undef K
 
 	return 0;
@@ -674,12 +672,6 @@ int bdi_init(struct backing_dev_info *bdi)
 
 	bdi_wb_init(&bdi->wb, bdi);
 
-	/*
-	 * Just one thread support for now, hard code mask and count
-	 */
-	bdi->wb_mask = 1;
-	bdi->wb_cnt = 1;
-
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init(&bdi->bdi_stat[i], 0);
 		if (err)
