Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325Ab0GWPGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:06:09 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52437 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760169Ab0GWPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:06:00 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv4 10/14] writeback: move bdi threads exiting logic to the forker thread
Date: Fri, 23 Jul 2010 18:05:50 +0300
Message-Id: <1279897554-1526-11-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
References: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 23 Jul 2010 15:05:51.0225 (UTC) FILETIME=[8A240690:01CB2A78]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Currently, bdi threads can decide to exit if there were no useful activities
for 5 minutes. However, this causes nasty races: we can easily oops in the
'bdi_queue_work()' if the bdi thread decides to exit while we are waking it up.

And even if we do not oops, but the bdi tread exits immediately after we wake
it up, we'd lose the wake-up event and have an unnecessary delay (up to 5 secs)
in the bdi work processing.

This patch makes the forker thread to be the central place which not only
creates bdi threads, but also kills them if they were inactive long enough.
This better design-wise.

Another reason why this change was done is to prepare for the further changes
which will prevent the bdi threads from waking up every 5 sec and wasting
power. Indeed, when the task does not wake up periodically anymore, it won't be
able to exit either.

This patch also moves the the 'wake_up_bit()' call from the bdi thread to the
forker thread as well. So now the forker thread sets the BDI_pending bit, then
forks the task or kills it, then clears the bit and wakes up the waiting
process.

The only process which may wain on the bit is 'bdi_wb_shutdown()'. This
function was changes as well - now it first removes the bdi from the
'bdi_list', then waits on the 'BDI_pending' bit. Once it wakes up, it is
guaranteed that the forker thread won't race with it, because the bdi is not
visible. Note, the forker thread sets the 'BDI_pending' bit under the
'bdi_lock' which is essential.

Also, I had to add memory barriers to make sure that 'bdi_wb_shutdown()' does
see the 'bdi->wb.task' change.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |   54 +++++++-------------------------
 mm/backing-dev.c  |   87 ++++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 81 insertions(+), 60 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 53e1028..b9e5ba0 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -78,21 +78,17 @@ static void bdi_queue_work(struct backing_dev_info *bdi,
 
 	spin_lock(&bdi->wb_lock);
 	list_add_tail(&work->list, &bdi->work_list);
-	spin_unlock(&bdi->wb_lock);
-
-	/*
-	 * If the default thread isn't there, make sure we add it. When
-	 * it gets created and wakes up, we'll run this work.
-	 */
-	if (unlikely(!bdi->wb.task)) {
+	if (bdi->wb.task) {
+		wake_up_process(bdi->wb.task);
+	} else {
+		/*
+		 * The bdi thread isn't there, wake up the forker thread which
+		 * will create and run it.
+		 */
 		trace_writeback_nothread(bdi, work);
 		wake_up_process(default_backing_dev_info.wb.task);
-	} else {
-		struct bdi_writeback *wb = &bdi->wb;
-
-		if (wb->task)
-			wake_up_process(wb->task);
 	}
+	spin_unlock(&bdi->wb_lock);
 }
 
 static void
@@ -800,7 +796,6 @@ int bdi_writeback_thread(void *data)
 {
 	struct bdi_writeback *wb = data;
 	struct backing_dev_info *bdi = wb->bdi;
-	unsigned long wait_jiffies = -1UL;
 	long pages_written;
 
 	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
@@ -812,13 +807,6 @@ int bdi_writeback_thread(void *data)
 	 */
 	set_user_nice(current, 0);
 
-	/*
-	 * Clear pending bit and wakeup anybody waiting to tear us down
-	 */
-	clear_bit(BDI_pending, &bdi->state);
-	smp_mb__after_clear_bit();
-	wake_up_bit(&bdi->state, BDI_pending);
-
 	trace_writeback_thread_start(bdi);
 
 	while (!kthread_should_stop()) {
@@ -828,18 +816,6 @@ int bdi_writeback_thread(void *data)
 
 		if (pages_written)
 			wb->last_active = jiffies;
-		else if (wait_jiffies != -1UL) {
-			unsigned long max_idle;
-
-			/*
-			 * Longest period of inactivity that we tolerate. If we
-			 * see dirty data again later, the thread will get
-			 * recreated automatically.
-			 */
-			max_idle = max(5UL * 60 * HZ, wait_jiffies);
-			if (time_after(jiffies, max_idle + wb->last_active))
-				break;
-		}
 
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!list_empty(&bdi->work_list)) {
@@ -847,21 +823,15 @@ int bdi_writeback_thread(void *data)
 			continue;
 		}
 
-		if (dirty_writeback_interval) {
-			wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
-			schedule_timeout(wait_jiffies);
-		} else
+		if (dirty_writeback_interval)
+			schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
+		else
 			schedule();
 
 		try_to_freeze();
 	}
 
-	wb->task = NULL;
-
-	/*
-	 * Flush any work that raced with us exiting. No new work
-	 * will be added, since this bdi isn't discoverable anymore.
-	 */
+	/* Flush any work that raced with us exiting */
 	if (!list_empty(&bdi->work_list))
 		wb_do_writeback(wb, 1);
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index b788b8e..92e812f 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -316,6 +316,18 @@ static void sync_supers_timer_fn(unsigned long unused)
 	bdi_arm_supers_timer();
 }
 
+/*
+ * Calculate the longest interval (jiffies) bdi threads are allowed to be
+ * inactive.
+ */
+static unsigned long bdi_longest_inactive(void)
+{
+	unsigned long interval;
+
+	interval = msecs_to_jiffies(dirty_writeback_interval * 10);
+	return max(5UL * 60 * HZ, interval);
+}
+
 static int bdi_forker_thread(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
@@ -329,8 +341,8 @@ static int bdi_forker_thread(void *ptr)
 	set_user_nice(current, 0);
 
 	for (;;) {
-		bool fork = false;
-		struct task_struct *task;
+		bool fork = false, kill = false;
+		struct task_struct *task = NULL;
 		struct backing_dev_info *bdi;
 
 		/*
@@ -343,10 +355,6 @@ static int bdi_forker_thread(void *ptr)
 		spin_lock_bh(&bdi_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
 
-		/*
-		 * Check if any existing bdi's have dirty data without
-		 * a thread registered. If so, set that up.
-		 */
 		list_for_each_entry(bdi, &bdi_list, bdi_list) {
 			bool have_dirty_io;
 
@@ -373,6 +381,25 @@ static int bdi_forker_thread(void *ptr)
 				fork = true;
 				break;
 			}
+
+			spin_lock(&bdi->wb_lock);
+			/*
+			 * If there is no work to do and the bdi thread was
+			 * inactive long enough - kill it. The wb_lock is taken
+			 * to make sure no-one adds more work to this bdi and
+			 * wakes the bdi thread up.
+			 */
+			if (bdi->wb.task && !have_dirty_io &&
+			    time_after(jiffies, bdi->wb.last_active +
+						bdi_longest_inactive())) {
+				task = bdi->wb.task;
+				bdi->wb.task = NULL;
+				spin_unlock(&bdi->wb_lock);
+				set_bit(BDI_pending, &bdi->state);
+				kill = true;
+				break;
+			}
+			spin_unlock(&bdi->wb_lock);
 		}
 		spin_unlock_bh(&bdi_lock);
 
@@ -380,7 +407,7 @@ static int bdi_forker_thread(void *ptr)
 		if (!list_empty(&me->bdi->work_list))
 			__set_current_state(TASK_RUNNING);
 
-		if (!fork) {
+		if (!fork && !kill) {
 			unsigned long wait;
 
 			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
@@ -394,16 +421,34 @@ static int bdi_forker_thread(void *ptr)
 
 		__set_current_state(TASK_RUNNING);
 
-		task = kthread_run(bdi_writeback_thread, &bdi->wb, "flush-%s",
-				   dev_name(bdi->dev));
-		if (IS_ERR(task)) {
-			/*
-			 * If thread creation fails, force writeout of the bdi
-			 * from the thread.
-			 */
-			bdi_flush_io(bdi);
+		if (fork) {
+			task = kthread_run(bdi_writeback_thread, &bdi->wb,
+					   "flush-%s", dev_name(bdi->dev));
+			if (IS_ERR(task)) {
+				/*
+				 * If thread creation fails, force writeout of
+				 * the bdi from the thread.
+				 */
+				bdi_flush_io(bdi);
+			} else {
+				bdi->wb.task = task;
+				/*
+				 * Make sure 'bdi->wb.task' assignment is seen
+				 * to other CPUs before the follwoing
+				 * 'BDI_pending' bit change. See the paired
+				 * read memory barrier in 'bdi_wb_shutdown()'.
+				 */
+				smp_wmb();
+			}
 		} else
-			bdi->wb.task = task;
+			kthread_stop(task);
+
+		/*
+		 * Clear pending bit and wakeup anybody waiting to tear us down.
+		 */
+		clear_bit(BDI_pending, &bdi->state);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&bdi->state, BDI_pending);
 	}
 
 	return 0;
@@ -487,15 +532,21 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 		return;
 
 	/*
+	 * Make sure nobody finds us on the bdi_list anymore
+	 */
+	bdi_remove_from_list(bdi);
+
+	/*
 	 * If setup is pending, wait for that to complete first
 	 */
 	wait_on_bit(&bdi->state, BDI_pending, bdi_sched_wait,
 			TASK_UNINTERRUPTIBLE);
 
 	/*
-	 * Make sure nobody finds us on the bdi_list anymore
+	 * Make sure we the 'bdi->wb.task' assigment made by the forker thread
+	 * is visible to us.
 	 */
-	bdi_remove_from_list(bdi);
+	smp_rmb();
 
 	/*
 	 * Finally, kill the kernel thread. We don't need to be RCU
-- 
1.7.1.1

