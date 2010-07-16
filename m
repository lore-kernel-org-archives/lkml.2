Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532Ab0GPMwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:52:24 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54084 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965302Ab0GPMt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:27 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 14/16] writeback: move bdi threads exiting logic to the forker thread
Date: Fri, 16 Jul 2010 15:45:10 +0300
Message-Id: <1279284312-2411-15-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:49:17.0836 (UTC) FILETIME=[4D9BD4C0:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Currently, bdi threads can decide to exit if there was no useful
activity for 5 minutes. However, this introduces races. Namely,
in the 'bdi_queue_work()' we can easily oops if the thread decided
to exit while we are waking it up.

And even if we do not oops, but the bdi tread exits immediately
after we wake it up, we'll have to way up to 5 seconds for the
bdi forker thread to wake up, find a bdi without a thread, and
create it. This introduces unwanted delays in bdi jobs handling.

So, to fix this we just make the forker thread to be the central
place which not only creates bdi threads, but also kills them when
it is necessary. This is conceptually better as well, IMO.

Note, I tried to fix this a simpler way, e.g. by protecting
'bdi->wb.task' by 'bdi->wb_lock' in bdi treads, but this does not
solve the issue of possible delays in bdi works handling which
was indicated above.

Another reason why this change was done is to prepare for the
further changes which will prevent the bdi threads from waking
up every 5 s. and wasting power. Indeed, when the task does not
wake up periodically anymore, it won't be able to exit either.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |   34 +++++++---------------
 mm/backing-dev.c  |   81 +++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 71 insertions(+), 44 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 968dc8e..559092d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -74,24 +74,25 @@ int writeback_in_progress(struct backing_dev_info *bdi)
 static void bdi_queue_work(struct backing_dev_info *bdi,
 		struct wb_writeback_work *work)
 {
+	bool wakeup_default = false;
+
 	trace_writeback_queue(bdi, work);
 
 	spin_lock(&bdi->wb_lock);
 	list_add_tail(&work->list, &bdi->work_list);
-	spin_unlock(&bdi->wb_lock);
-
 	/*
 	 * If the default thread isn't there, make sure we add it. When
 	 * it gets created and wakes up, we'll run this work.
 	 */
-	if (unlikely(!bdi->wb.task)) {
+	if (unlikely(!bdi->wb.task))
+		wakeup_default = true;
+	else
+		wake_up_process(bdi->wb.task);
+	spin_unlock(&bdi->wb_lock);
+
+	if (wakeup_default) {
 		trace_writeback_nothread(bdi, work);
 		wake_up_process(default_backing_dev_info.wb.task);
-	} else {
-		struct bdi_writeback *wb = &bdi->wb;
-
-		if (wb->task)
-			wake_up_process(wb->task);
 	}
 }
 
@@ -800,7 +801,6 @@ int bdi_writeback_thread(void *data)
 {
 	struct bdi_writeback *wb = data;
 	struct backing_dev_info *bdi = wb->bdi;
-	unsigned long wait_jiffies = -1UL;
 	long pages_written;
 
 	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
@@ -821,18 +821,6 @@ int bdi_writeback_thread(void *data)
 
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
@@ -841,6 +829,8 @@ int bdi_writeback_thread(void *data)
 		}
 
 		if (dirty_writeback_interval) {
+			unsigned long wait_jiffies;
+
 			wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
 			schedule_timeout(wait_jiffies);
 		} else
@@ -849,8 +839,6 @@ int bdi_writeback_thread(void *data)
 		try_to_freeze();
 	}
 
-	wb->task = NULL;
-
 	/*
 	 * Flush any work that raced with us exiting. No new work
 	 * will be added, since this bdi isn't discoverable anymore.
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 18d7c22..65cb88a 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -317,6 +317,18 @@ static void sync_supers_timer_fn(unsigned long unused)
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
+	return max(5UL * 60 * HZ, wait_jiffies);
+}
+
 static int bdi_forker_thread(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
@@ -330,9 +342,9 @@ static int bdi_forker_thread(void *ptr)
 	set_user_nice(current, 0);
 
 	for (;;) {
-		bool fork = false;
+		bool fork = false, kill = false;
 		struct backing_dev_info *bdi, *tmp;
-		struct task_struct *task;
+		struct task_struct *uninitialized_var(task);
 
 		if (bdi_has_dirty_io(me->bdi))
 			wb_do_writeback(me, 0);
@@ -357,6 +369,25 @@ static int bdi_forker_thread(void *ptr)
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
+			if (bdi->wb.task && !bdi_has_dirty_io(bdi) &&
+			    time_after(jiffies, bdi->wb.last_active +
+						bdi_longest_inactive())) {
+				task = bdi->wb.task;
+				bdi->wb.task = NULL;
+				list_del_rcu(&bdi->bdi_list);
+				spin_unlock(&bdi->wb_lock);
+				kill = true;
+				break;
+			}
+			spin_unlock(&bdi->wb_lock);
 		}
 		spin_unlock_bh(&bdi_lock);
 
@@ -364,7 +395,7 @@ static int bdi_forker_thread(void *ptr)
 		if (!list_empty(&me->bdi->work_list))
 			__set_current_state(TASK_RUNNING);
 
-		if (!fork) {
+		if (!fork && !kill) {
 			unsigned long wait;
 
 			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
@@ -387,24 +418,32 @@ static int bdi_forker_thread(void *ptr)
 		/* Make sure no one uses the picked bdi */
 		synchronize_rcu();
 
-		task = kthread_run(bdi_writeback_thread, &bdi->wb, "flush-%s",
- 					dev_name(bdi->dev));
+		if (fork) {
+			task = kthread_run(bdi_writeback_thread, &bdi->wb, "flush-%s",
+						dev_name(bdi->dev));
 
-		spin_lock_bh(&bdi_lock);
-		list_add_tail(&bdi->bdi_list, &bdi_list);
-		spin_unlock_bh(&bdi_lock);
+			spin_lock_bh(&bdi_lock);
+			list_add_tail(&bdi->bdi_list, &bdi_list);
+			spin_unlock_bh(&bdi_lock);
 
-		if (IS_ERR(task)) {
-			/*
-			 * If thread creation fails, then readd the bdi back to
-			 * the list and force writeout of the bdi from this
-			 * forker thread. That will free some memory and we can
-			 * try again. The bdi was added to the tail so we'll
-			 * get a chance to flush other bdi's to free memory.
-			 */
-			bdi_flush_io(bdi);
-		} else
-			bdi->wb.task = task;
+			if (IS_ERR(task)) {
+				/*
+				 * If thread creation fails, then readd the bdi back to
+				 * the list and force writeout of the bdi from this
+				 * forker thread. That will free some memory and we can
+				 * try again. The bdi was added to the tail so we'll
+				 * get a chance to flush other bdi's to free memory.
+				 */
+				bdi_flush_io(bdi);
+			} else
+				bdi->wb.task = task;
+		} else {
+			kthread_stop(task);
+
+			spin_lock_bh(&bdi_lock);
+			list_add_tail(&bdi->bdi_list, &bdi_list);
+			spin_unlock_bh(&bdi_lock);
+		}
 
 		/*
 		 * Clear pending bit and wakeup anybody waiting to tear us
-- 
1.7.1.1

