Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab0GVN4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:56:46 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37124 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439Ab0GVN4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:56:42 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 10/14] writeback: move bdi threads exiting logic to the forker thread
Date: Thu, 22 Jul 2010 16:56:24 +0300
Message-Id: <1279806988-14100-11-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279806988-14100-1-git-send-email-dedekind1@gmail.com>
References: <1279806988-14100-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 22 Jul 2010 13:56:37.0168 (UTC) FILETIME=[B3B77B00:01CB29A5]
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

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c |   47 ++++++++++-----------------------------
 mm/backing-dev.c  |   62 +++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 58 insertions(+), 51 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 53e1028..b834715 100644
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
@@ -828,18 +823,6 @@ int bdi_writeback_thread(void *data)
 
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
@@ -847,21 +830,15 @@ int bdi_writeback_thread(void *data)
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
index b788b8e..8609701 100644
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
@@ -394,16 +421,19 @@ static int bdi_forker_thread(void *ptr)
 
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
+			} else
+				bdi->wb.task = task;
 		} else
-			bdi->wb.task = task;
+			kthread_stop(task);
 	}
 
 	return 0;
-- 
1.7.1.1

