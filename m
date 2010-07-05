Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0GETcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 15:32:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49597 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab0GETcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 15:32:09 -0400
Date: Mon, 5 Jul 2010 15:32:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending()
Message-ID: <20100705193200.GA2917@infradead.org>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
 <20100705085550.GA26775@elte.hu>
 <20100705164022.GA26995@infradead.org>
 <20100705171125.GB26202@elte.hu>
 <20100705171420.GA29697@elte.hu>
 <20100705182003.GA12332@infradead.org>
 <4C323177.3070606@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C323177.3070606@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 09:24:39PM +0200, Jens Axboe wrote:
> The oops itself looks like a recurrence of the missing RCU grace or
> too early stack wakeup, which should be a 1-2 liner once it's found.

See the previous thread.  There's at least two issues:

 - wb_do_writeback checks work->state after it's been freed when we do
   the second test_bit for WS_ONSTACK
 - bdi_work_free accesses work->state after waking up the caller doing
   bdi_wait_on_work_done, which might have re-used the stack space
   allocated for the work item.

The fix for that is to get rid of the fragile work->state stuff and the
bit wakeups by just using a completion and using that as indicator
for the stack wait.  That's the main change the above patch does.  In
addition it also merges the two structures used for the writeback
requests.  Onl doing the completion and earlier list removal would
be something like the untested patch below:


Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-07-05 11:41:51.459003854 -0700
+++ linux-2.6/fs/fs-writeback.c	2010-07-05 11:48:05.542046598 -0700
@@ -52,29 +52,10 @@ struct wb_writeback_args {
  */
 struct bdi_work {
 	struct list_head list;		/* pending work list */
-	struct rcu_head rcu_head;	/* for RCU free/clear of work */
-
-	unsigned long seen;		/* threads that have seen this work */
-	atomic_t pending;		/* number of threads still to do work */
-
 	struct wb_writeback_args args;	/* writeback arguments */
-
-	unsigned long state;		/* flag bits, see WS_* */
+	struct completion *done;	/* set if the caller waits */
 };
 
-enum {
-	WS_INPROGRESS = 0,
-	WS_ONSTACK,
-};
-
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
@@ -87,49 +68,10 @@ int writeback_in_progress(struct backing
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
 static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
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
@@ -146,16 +88,6 @@ static void bdi_queue_work(struct backin
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
 static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
 				 struct wb_writeback_args *args)
 {
@@ -167,7 +99,7 @@ static void bdi_alloc_queue_work(struct
 	 */
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (work) {
-		bdi_work_init(work, args);
+		work->args = *args;
 		bdi_queue_work(bdi, work);
 	} else {
 		struct bdi_writeback *wb = &bdi->wb;
@@ -188,13 +120,14 @@ static void bdi_alloc_queue_work(struct
  */
 static void bdi_queue_work_onstack(struct wb_writeback_args *args)
 {
+	DECLARE_COMPLETION_ONSTACK(done);
 	struct bdi_work work;
 
-	bdi_work_init(&work, args);
-	__set_bit(WS_ONSTACK, &work.state);
+	work.args = *args;
+	work.done = &done;
 
 	bdi_queue_work(args->sb->s_bdi, &work);
-	bdi_wait_on_work_done(&work);
+	wait_for_completion(&done);
 }
 
 /**
@@ -791,21 +724,17 @@ static long wb_writeback(struct bdi_writ
 static struct bdi_work *get_next_work_item(struct backing_dev_info *bdi,
 					   struct bdi_writeback *wb)
 {
-	struct bdi_work *work, *ret = NULL;
-
-	rcu_read_lock();
+	struct bdi_work *work = NULL;
 
-	list_for_each_entry_rcu(work, &bdi->work_list, list) {
-		if (!test_bit(wb->nr, &work->seen))
-			continue;
-		clear_bit(wb->nr, &work->seen);
-
-		ret = work;
-		break;
+	spin_lock(&bdi->wb_lock);
+	if (!list_empty(&bdi->work_list)) {
+		work = list_entry(bdi->work_list.next,
+				  struct bdi_work, list);
+		list_del_init(&work->list);
 	}
+	spin_unlock(&bdi->wb_lock);
 
-	rcu_read_unlock();
-	return ret;
+	return work;
 }
 
 static long wb_check_old_data_flush(struct bdi_writeback *wb)
@@ -861,21 +790,12 @@ long wb_do_writeback(struct bdi_writebac
 		if (force_wait)
 			work->args.sync_mode = args.sync_mode = WB_SYNC_ALL;
 
-		/*
-		 * If this isn't a data integrity operation, just notify
-		 * that we have seen this work and we are now starting it.
-		 */
-		if (!test_bit(WS_ONSTACK, &work->state))
-			wb_clear_pending(wb, work);
-
 		wrote += wb_writeback(wb, &args);
 
-		/*
-		 * This is a data integrity writeback, so only do the
-		 * notification when we have completed the work.
-		 */
-		if (test_bit(WS_ONSTACK, &work->state))
-			wb_clear_pending(wb, work);
+		if (work->done)
+			complete(work->done);
+		else
+			kfree(work);
 	}
 
 	/*
Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h	2010-07-05 11:45:45.610003714 -0700
+++ linux-2.6/include/linux/backing-dev.h	2010-07-05 11:45:48.802084661 -0700
@@ -82,8 +82,6 @@ struct backing_dev_info {
 	struct bdi_writeback wb;  /* default writeback info for this bdi */
 	spinlock_t wb_lock;	  /* protects update side of wb_list */
 	struct list_head wb_list; /* the flusher threads hanging off this bdi */
-	unsigned long wb_mask;	  /* bitmask of registered tasks */
-	unsigned int wb_cnt;	  /* number of registered tasks */
 
 	struct list_head work_list;
 
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c	2010-07-05 11:45:52.458023339 -0700
+++ linux-2.6/mm/backing-dev.c	2010-07-05 11:46:22.145302078 -0700
@@ -104,15 +104,13 @@ static int bdi_debug_stats_show(struct s
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
@@ -675,12 +673,6 @@ int bdi_init(struct backing_dev_info *bd
 
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
