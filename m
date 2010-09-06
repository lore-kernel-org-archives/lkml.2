Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0IFMq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:46:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:50753 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab0IFMqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:46:38 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@lst.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] backing-dev: replace private thread pool with workqueue
Date: Mon,  6 Sep 2010 14:46:20 +0200
Message-Id: <1283777182-11426-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283777182-11426-1-git-send-email-tj@kernel.org>
References: <1283777182-11426-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Sep 2010 12:46:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bdi writeback has been using a private thread pool.  Now that
workqueue can provide flexible concurrency, drop the dedicated thread
pool and use workqueue instead.

bdi_writeback->task and ->wakeup_timer are replaced with ->work and
->timer.  A separate timer is used instead of delayed_work because
mixing immediate and delayed queueing doesn't work too well with
delayed_work.

bdi_wq is added to execute bdi_writeback->work.  It's an unbound
freezeable workqueue w/ a rescuer.  As the thread pool is now managed
by the workqueue code, the special forker thread is no longer
necessary and removed along with bdi_forker_thread().

The work function for bdi_writeback->work is bdi_work_fn() and mostly
equivalent to a single iteration of bdi_writeback_thread() - IOW, it
calls wb_do_writeback() until bdi->work_list is exhausted and
reschedules itself if there is dirty data to write out.

One special provision is that the writeback work doesn't run
bdi->worklist if it's being executed from the rescuer.  Instead, it
just calls bdi_flush_io() and reschedules itself if necessary.  This
basically is the same behavior as bdi_forker_thread()'s when it failed
to create a thread for a pending bdi.  Writebacks are issued but not
waited upon so that other bdi's have a chance to clean and free
memory.

Trace points which make sense without change are preserved.  The next
patch will fix up the rest.

bdi_wakeup_thread_delayed() is renamed to bdi_delayed_writeback().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fs-writeback.c           |   91 ++--------------
 include/linux/backing-dev.h |   17 +--
 mm/backing-dev.c            |  249 ++++++++++---------------------------------
 3 files changed, 72 insertions(+), 285 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 7d9d06b..1e9b807 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -78,16 +78,7 @@ static void bdi_queue_work(struct backing_dev_info *bdi,
 
 	spin_lock_bh(&bdi->wb_lock);
 	list_add_tail(&work->list, &bdi->work_list);
-	if (bdi->wb.task) {
-		wake_up_process(bdi->wb.task);
-	} else {
-		/*
-		 * The bdi thread isn't there, wake up the forker thread which
-		 * will create and run it.
-		 */
-		trace_writeback_nothread(bdi, work);
-		wake_up_process(default_backing_dev_info.wb.task);
-	}
+	queue_work(bdi_wq, &bdi->wb.work);
 	spin_unlock_bh(&bdi->wb_lock);
 }
 
@@ -99,14 +90,12 @@ __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
 
 	/*
 	 * This is WB_SYNC_NONE writeback, so if allocation fails just
-	 * wakeup the thread for old dirty data writeback
+	 * queue the work for old dirty data writeback.
 	 */
 	work = kzalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work) {
-		if (bdi->wb.task) {
-			trace_writeback_nowork(bdi);
-			wake_up_process(bdi->wb.task);
-		}
+		trace_writeback_nowork(bdi);
+		queue_work(bdi_wq, &bdi->wb.work);
 		return;
 	}
 
@@ -773,70 +762,6 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 }
 
 /*
- * Handle writeback of dirty data for the device backed by this bdi. Also
- * wakes up periodically and does kupdated style flushing.
- */
-int bdi_writeback_thread(void *data)
-{
-	struct bdi_writeback *wb = data;
-	struct backing_dev_info *bdi = wb->bdi;
-	long pages_written;
-
-	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
-	set_freezable();
-	wb->last_active = jiffies;
-
-	/*
-	 * Our parent may run at a different priority, just set us to normal
-	 */
-	set_user_nice(current, 0);
-
-	trace_writeback_thread_start(bdi);
-
-	while (!kthread_should_stop()) {
-		/*
-		 * Remove own delayed wake-up timer, since we are already awake
-		 * and we'll take care of the preriodic write-back.
-		 */
-		del_timer(&wb->wakeup_timer);
-
-		pages_written = wb_do_writeback(wb, 0);
-
-		trace_writeback_pages_written(pages_written);
-
-		if (pages_written)
-			wb->last_active = jiffies;
-
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (!list_empty(&bdi->work_list)) {
-			__set_current_state(TASK_RUNNING);
-			continue;
-		}
-
-		if (wb_has_dirty_io(wb) && dirty_writeback_interval)
-			schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
-		else {
-			/*
-			 * We have nothing to do, so can go sleep without any
-			 * timeout and save power. When a work is queued or
-			 * something is made dirty - we will be woken up.
-			 */
-			schedule();
-		}
-
-		try_to_freeze();
-	}
-
-	/* Flush any work that raced with us exiting */
-	if (!list_empty(&bdi->work_list))
-		wb_do_writeback(wb, 1);
-
-	trace_writeback_thread_stop(bdi);
-	return 0;
-}
-
-
-/*
  * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
  * the whole world.
  */
@@ -911,7 +836,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct super_block *sb = inode->i_sb;
 	struct backing_dev_info *bdi = NULL;
-	bool wakeup_bdi = false;
+	bool delayed_wb = false;
 
 	/*
 	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
@@ -978,7 +903,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 				 * write-back happens later.
 				 */
 				if (!wb_has_dirty_io(&bdi->wb))
-					wakeup_bdi = true;
+					delayed_wb = true;
 			}
 
 			inode->dirtied_when = jiffies;
@@ -988,8 +913,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 out:
 	spin_unlock(&inode_lock);
 
-	if (wakeup_bdi)
-		bdi_wakeup_thread_delayed(bdi);
+	if (delayed_wb)
+		bdi_delayed_writeback(bdi);
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 97842ab..ebeed5b 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -13,8 +13,8 @@
 #include <linux/proportions.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
+#include <linux/workqueue.h>
 #include <linux/writeback.h>
 #include <asm/atomic.h>
 
@@ -26,7 +26,6 @@ struct dentry;
  * Bits in backing_dev_info.state
  */
 enum bdi_state {
-	BDI_pending,		/* On its way to being activated */
 	BDI_wb_alloc,		/* Default embedded wb allocated */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
@@ -49,10 +48,9 @@ struct bdi_writeback {
 	struct backing_dev_info *bdi;	/* our parent bdi */
 
 	unsigned long last_old_flush;	/* last old data flush */
-	unsigned long last_active;	/* last time bdi thread was active */
 
-	struct task_struct *task;	/* writeback thread */
-	struct timer_list wakeup_timer; /* used for delayed bdi thread wakeup */
+	struct work_struct work;	/* writeback work */
+	struct timer_list timer;	/* used for delayed bdi execution */
 	struct list_head b_dirty;	/* dirty inodes */
 	struct list_head b_io;		/* parked for writeback */
 	struct list_head b_more_io;	/* parked for more writeback */
@@ -103,13 +101,13 @@ void bdi_unregister(struct backing_dev_info *bdi);
 int bdi_setup_and_register(struct backing_dev_info *, char *, unsigned int);
 void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages);
 void bdi_start_background_writeback(struct backing_dev_info *bdi);
-int bdi_writeback_thread(void *data);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 void bdi_arm_supers_timer(void);
-void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi);
+void bdi_delayed_writeback(struct backing_dev_info *bdi);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
+extern struct workqueue_struct *bdi_wq;
 
 static inline int wb_has_dirty_io(struct bdi_writeback *wb)
 {
@@ -308,11 +306,6 @@ static inline bool bdi_cap_swap_backed(struct backing_dev_info *bdi)
 	return bdi->capabilities & BDI_CAP_SWAP_BACKED;
 }
 
-static inline bool bdi_cap_flush_forker(struct backing_dev_info *bdi)
-{
-	return bdi == &default_backing_dev_info;
-}
-
 static inline bool mapping_cap_writeback_dirty(struct address_space *mapping)
 {
 	return bdi_cap_writeback_dirty(mapping->backing_dev_info);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index eaa4a5b..e874916 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -43,6 +43,7 @@ static struct class *bdi_class;
 DEFINE_SPINLOCK(bdi_lock);
 LIST_HEAD(bdi_list);
 LIST_HEAD(bdi_pending_list);
+struct workqueue_struct *bdi_wq;
 
 static struct task_struct *sync_supers_tsk;
 static struct timer_list sync_supers_timer;
@@ -234,6 +235,10 @@ static int __init default_bdi_init(void)
 {
 	int err;
 
+	bdi_wq = alloc_workqueue("bdi",
+				 WQ_UNBOUND | WQ_FREEZEABLE | WQ_RESCUER, 0);
+	BUG_ON(!bdi_wq);
+
 	sync_supers_tsk = kthread_run(bdi_sync_supers, NULL, "sync_supers");
 	BUG_ON(IS_ERR(sync_supers_tsk));
 
@@ -305,24 +310,11 @@ static void sync_supers_timer_fn(unsigned long unused)
 	bdi_arm_supers_timer();
 }
 
-static void wakeup_timer_fn(unsigned long data)
+static void bdi_timer_fn(unsigned long data)
 {
 	struct backing_dev_info *bdi = (struct backing_dev_info *)data;
 
-	spin_lock_bh(&bdi->wb_lock);
-	if (bdi->wb.task) {
-		trace_writeback_wake_thread(bdi);
-		wake_up_process(bdi->wb.task);
-	} else {
-		/*
-		 * When bdi tasks are inactive for long time, they are killed.
-		 * In this case we have to wake-up the forker thread which
-		 * should create and run the bdi thread.
-		 */
-		trace_writeback_wake_forker_thread(bdi);
-		wake_up_process(default_backing_dev_info.wb.task);
-	}
-	spin_unlock_bh(&bdi->wb_lock);
+	queue_work(bdi_wq, &bdi->wb.work);
 }
 
 /*
@@ -336,165 +328,56 @@ static void wakeup_timer_fn(unsigned long data)
  * fast-path (used by '__mark_inode_dirty()'), so we save few context switches
  * by delaying the wake-up.
  */
-void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
+void bdi_delayed_writeback(struct backing_dev_info *bdi)
 {
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	mod_timer(&bdi->wb.wakeup_timer, jiffies + timeout);
+	mod_timer(&bdi->wb.timer, jiffies + timeout);
 }
 
 /*
- * Calculate the longest interval (jiffies) bdi threads are allowed to be
- * inactive.
+ * Handles writeback of dirty data for the device backed by this bdi.
+ * Also schedules itself periodically for kupdated style flushing.
  */
-static unsigned long bdi_longest_inactive(void)
+static void bdi_work_fn(struct work_struct *work)
 {
-	unsigned long interval;
+	struct bdi_writeback *wb =
+		container_of(work, struct bdi_writeback, work);
+	struct backing_dev_info *bdi = wb->bdi;
+	long pages_written;
 
-	interval = msecs_to_jiffies(dirty_writeback_interval * 10);
-	return max(5UL * 60 * HZ, interval);
-}
+	WARN(!test_bit(BDI_registered, &bdi->state),
+	     "bdi %p/%s is not registered!\n", bdi, bdi->name);
 
-static int bdi_forker_thread(void *ptr)
-{
-	struct bdi_writeback *me = ptr;
+	/*
+	 * Remove own delayed timer, since we are already running and
+	 * we'll take care of the periodic write-back.
+	 */
+	del_timer(&wb->timer);
 
 	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
-	set_freezable();
 
 	/*
-	 * Our parent may run at a different priority, just set us to normal
+	 * Writeback works might block and we don't want to hog the
+	 * rescuer.  If we are running off the rescuer, skip works,
+	 * fire off writebacks and yield to other bdi's.
 	 */
-	set_user_nice(current, 0);
-
-	for (;;) {
-		struct task_struct *task = NULL;
-		struct backing_dev_info *bdi;
-		enum {
-			NO_ACTION,   /* Nothing to do */
-			FORK_THREAD, /* Fork bdi thread */
-			KILL_THREAD, /* Kill inactive bdi thread */
-		} action = NO_ACTION;
-
-		/*
-		 * Temporary measure, we want to make sure we don't see
-		 * dirty data on the default backing_dev_info
-		 */
-		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list)) {
-			del_timer(&me->wakeup_timer);
-			wb_do_writeback(me, 0);
-		}
-
-		spin_lock_bh(&bdi_lock);
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		list_for_each_entry(bdi, &bdi_list, bdi_list) {
-			bool have_dirty_io;
-
-			if (!bdi_cap_writeback_dirty(bdi) ||
-			     bdi_cap_flush_forker(bdi))
-				continue;
-
-			WARN(!test_bit(BDI_registered, &bdi->state),
-			     "bdi %p/%s is not registered!\n", bdi, bdi->name);
-
-			have_dirty_io = !list_empty(&bdi->work_list) ||
-					wb_has_dirty_io(&bdi->wb);
-
-			/*
-			 * If the bdi has work to do, but the thread does not
-			 * exist - create it.
-			 */
-			if (!bdi->wb.task && have_dirty_io) {
-				/*
-				 * Set the pending bit - if someone will try to
-				 * unregister this bdi - it'll wait on this bit.
-				 */
-				set_bit(BDI_pending, &bdi->state);
-				action = FORK_THREAD;
-				break;
-			}
-
-			spin_lock(&bdi->wb_lock);
-
-			/*
-			 * If there is no work to do and the bdi thread was
-			 * inactive long enough - kill it. The wb_lock is taken
-			 * to make sure no-one adds more work to this bdi and
-			 * wakes the bdi thread up.
-			 */
-			if (bdi->wb.task && !have_dirty_io &&
-			    time_after(jiffies, bdi->wb.last_active +
-						bdi_longest_inactive())) {
-				task = bdi->wb.task;
-				bdi->wb.task = NULL;
-				spin_unlock(&bdi->wb_lock);
-				set_bit(BDI_pending, &bdi->state);
-				action = KILL_THREAD;
-				break;
-			}
-			spin_unlock(&bdi->wb_lock);
-		}
-		spin_unlock_bh(&bdi_lock);
-
-		/* Keep working if default bdi still has things to do */
-		if (!list_empty(&me->bdi->work_list))
-			__set_current_state(TASK_RUNNING);
-
-		switch (action) {
-		case FORK_THREAD:
-			__set_current_state(TASK_RUNNING);
-			task = kthread_run(bdi_writeback_thread, &bdi->wb, "flush-%s",
-					   dev_name(bdi->dev));
-			if (IS_ERR(task)) {
-				/*
-				 * If thread creation fails, force writeout of
-				 * the bdi from the thread.
-				 */
-				bdi_flush_io(bdi);
-			} else {
-				/*
-				 * The spinlock makes sure we do not lose
-				 * wake-ups when racing with 'bdi_queue_work()'.
-				 */
-				spin_lock_bh(&bdi->wb_lock);
-				bdi->wb.task = task;
-				spin_unlock_bh(&bdi->wb_lock);
-			}
-			break;
-
-		case KILL_THREAD:
-			__set_current_state(TASK_RUNNING);
-			kthread_stop(task);
-			break;
-
-		case NO_ACTION:
-			if (!wb_has_dirty_io(me) || !dirty_writeback_interval)
-				/*
-				 * There are no dirty data. The only thing we
-				 * should now care about is checking for
-				 * inactive bdi threads and killing them. Thus,
-				 * let's sleep for longer time, save energy and
-				 * be friendly for battery-driven devices.
-				 */
-				schedule_timeout(bdi_longest_inactive());
-			else
-				schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
-			try_to_freeze();
-			/* Back to the main loop */
-			continue;
-		}
-
-		/*
-		 * Clear pending bit and wakeup anybody waiting to tear us down.
-		 */
-		clear_bit(BDI_pending, &bdi->state);
-		smp_mb__after_clear_bit();
-		wake_up_bit(&bdi->state, BDI_pending);
+	if (likely(!workqueue_on_rescuer(bdi_wq))) {
+		do {
+			pages_written = wb_do_writeback(wb, 0);
+			trace_writeback_pages_written(pages_written);
+		} while (!list_empty(&bdi->work_list));
+	} else {
+		bdi_flush_io(bdi);
+		if (!list_empty(&bdi->work_list))
+			queue_work(bdi_wq, work);
 	}
 
-	return 0;
+	if (wb_has_dirty_io(wb) && dirty_writeback_interval)
+		bdi_delayed_writeback(bdi);
+
+	current->flags &= ~(PF_FLUSHER | PF_SWAPWRITE);
 }
 
 /*
@@ -526,20 +409,6 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 
 	bdi->dev = dev;
 
-	/*
-	 * Just start the forker thread for our default backing_dev_info,
-	 * and add other bdi's to the list. They will get a thread created
-	 * on-demand when they need it.
-	 */
-	if (bdi_cap_flush_forker(bdi)) {
-		struct bdi_writeback *wb = &bdi->wb;
-
-		wb->task = kthread_run(bdi_forker_thread, wb, "bdi-%s",
-						dev_name(dev));
-		if (IS_ERR(wb->task))
-			return PTR_ERR(wb->task);
-	}
-
 	bdi_debug_register(bdi, dev_name(dev));
 	set_bit(BDI_registered, &bdi->state);
 
@@ -563,30 +432,25 @@ EXPORT_SYMBOL(bdi_register_dev);
  */
 static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 {
+	unsigned int saved_flags = current->flags & (PF_FLUSHER | PF_SWAPWRITE);
+
 	if (!bdi_cap_writeback_dirty(bdi))
 		return;
 
 	/*
-	 * Make sure nobody finds us on the bdi_list anymore
+	 * Make sure nobody finds us on the bdi_list anymore and
+	 * writeback work isn't running.
 	 */
 	bdi_remove_from_list(bdi);
+	cancel_work_sync(&bdi->wb.work);
 
-	/*
-	 * If setup is pending, wait for that to complete first
-	 */
-	wait_on_bit(&bdi->state, BDI_pending, bdi_sched_wait,
-			TASK_UNINTERRUPTIBLE);
+	/* Flush any work that raced with shutdown */
+	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
 
-	/*
-	 * Finally, kill the kernel thread. We don't need to be RCU
-	 * safe anymore, since the bdi is gone from visibility. Force
-	 * unfreeze of the thread before calling kthread_stop(), otherwise
-	 * it would never exet if it is currently stuck in the refrigerator.
-	 */
-	if (bdi->wb.task) {
-		thaw_process(bdi->wb.task);
-		kthread_stop(bdi->wb.task);
-	}
+	wb_do_writeback(&bdi->wb, 1);
+
+	current->flags &= ~(PF_FLUSHER | PF_SWAPWRITE);
+	current->flags |= saved_flags;
 }
 
 /*
@@ -609,10 +473,9 @@ void bdi_unregister(struct backing_dev_info *bdi)
 	if (bdi->dev) {
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
-		del_timer_sync(&bdi->wb.wakeup_timer);
+		del_timer_sync(&bdi->wb.timer);
 
-		if (!bdi_cap_flush_forker(bdi))
-			bdi_wb_shutdown(bdi);
+		bdi_wb_shutdown(bdi);
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
 		bdi->dev = NULL;
@@ -629,7 +492,13 @@ static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
-	setup_timer(&wb->wakeup_timer, wakeup_timer_fn, (unsigned long)bdi);
+	/*
+	 * work and separate timer are used instead of delayed_work
+	 * because mixing immediate and delayed queueing doesn't work
+	 * too well with delayed_work.
+	 */
+	INIT_WORK(&wb->work, bdi_work_fn);
+	setup_timer(&wb->timer, bdi_timer_fn, (unsigned long)bdi);
 }
 
 int bdi_init(struct backing_dev_info *bdi)
-- 
1.7.1

