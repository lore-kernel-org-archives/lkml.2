Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab0GYIb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:31:59 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49925 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab0GYI3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:29:55 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHv5 12/15] writeback: optimize periodic bdi thread wakeups
Date: Sun, 25 Jul 2010 11:29:38 +0300
Message-Id: <1280046581-23623-13-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
References: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 Jul 2010 08:29:47.0507 (UTC) FILETIME=[8AAFEC30:01CB2BD3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Whe the first inode for a bdi is marked dirty, we wake up the bdi thread which
should take care of the periodic background write-out. However, the write-out
will actually start only 'dirty_writeback_interval' centisecs later, so we can
delay the wake-up.

This change was requested by Nick Piggin who pointed out that if we delay the
wake-up, we weed out 2 unnecessary contex switches, which matters because
'__mark_inode_dirty()' is a hot-path function.

This patch introduces a new function - 'bdi_wakeup_thread_delayed()', which
sets up a timer to wake-up the bdi thread and returns. So the wake-up is
delayed.

We also delete the timer in bdi threads just before writing-back. And
synchronously delete it when unregistering bdi. At the unregister point the bdi
does not have any users, so no one can arm it again.

This patch also moves the 'bdi_wb_init()' function down in the file to avoid
forward-declaration of 'bdi_wakeup_thread_delayed()'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c           |   28 ++++--------------
 include/linux/backing-dev.h |    2 +
 mm/backing-dev.c            |   65 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 62 insertions(+), 33 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6814502..b837cae 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -810,6 +810,12 @@ int bdi_writeback_thread(void *data)
 	trace_writeback_thread_start(bdi);
 
 	while (!kthread_should_stop()) {
+		/*
+		 * Remove own delayed wake-up timer, since we are already awake
+		 * and we'll take care of the preriodic write-back.
+		 */
+		del_timer(&wb->wakeup_timer);
+
 		pages_written = wb_do_writeback(wb, 0);
 
 		trace_writeback_pages_written(pages_written);
@@ -868,26 +874,6 @@ void wakeup_flusher_threads(long nr_pages)
 	rcu_read_unlock();
 }
 
-/*
- * This function is used when the first inode for this bdi is marked dirty. It
- * wakes-up the corresponding bdi thread which should then take care of the
- * periodic background write-out of dirty inodes.
- */
-static void wakeup_bdi_thread(struct backing_dev_info *bdi)
-{
-	spin_lock(&bdi->wb_lock);
-	if (bdi->wb.task)
-		wake_up_process(bdi->wb.task);
-	else
-		/*
-		 * When bdi tasks are inactive for long time, they are killed.
-		 * In this case we have to wake-up the forker thread which
-		 * should create and run the bdi thread.
-		 */
-		wake_up_process(default_backing_dev_info.wb.task);
-	spin_unlock(&bdi->wb_lock);
-}
-
 static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 {
 	if (inode->i_ino || strcmp(inode->i_sb->s_id, "bdev")) {
@@ -1019,7 +1005,7 @@ out:
 	spin_unlock(&inode_lock);
 
 	if (wakeup_bdi)
-		wakeup_bdi_thread(bdi);
+		bdi_wakeup_thread_delayed(bdi);
 
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 71b6223..7628219 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -52,6 +52,7 @@ struct bdi_writeback {
 	unsigned long last_active;	/* last time bdi thread was active */
 
 	struct task_struct *task;	/* writeback thread */
+	struct timer_list wakeup_timer; /* used for delayed bdi thread wakeup */
 	struct list_head b_dirty;	/* dirty inodes */
 	struct list_head b_io;		/* parked for writeback */
 	struct list_head b_more_io;	/* parked for more writeback */
@@ -105,6 +106,7 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi);
 int bdi_writeback_thread(void *data);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 void bdi_arm_supers_timer(void);
+void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 7039966..c2def00 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -248,17 +248,6 @@ static int __init default_bdi_init(void)
 }
 subsys_initcall(default_bdi_init);
 
-static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
-{
-	memset(wb, 0, sizeof(*wb));
-
-	wb->bdi = bdi;
-	wb->last_old_flush = jiffies;
-	INIT_LIST_HEAD(&wb->b_dirty);
-	INIT_LIST_HEAD(&wb->b_io);
-	INIT_LIST_HEAD(&wb->b_more_io);
-}
-
 int bdi_has_dirty_io(struct backing_dev_info *bdi)
 {
 	return wb_has_dirty_io(&bdi->wb);
@@ -316,6 +305,43 @@ static void sync_supers_timer_fn(unsigned long unused)
 	bdi_arm_supers_timer();
 }
 
+static void wakeup_timer_fn(unsigned long data)
+{
+	struct backing_dev_info *bdi = (struct backing_dev_info *)data;
+
+	spin_lock(&bdi->wb_lock);
+	if (bdi->wb.task) {
+		wake_up_process(bdi->wb.task);
+	} else {
+		/*
+		 * When bdi tasks are inactive for long time, they are killed.
+		 * In this case we have to wake-up the forker thread which
+		 * should create and run the bdi thread.
+		 */
+		wake_up_process(default_backing_dev_info.wb.task);
+	}
+	spin_unlock(&bdi->wb_lock);
+}
+
+/*
+ * This function is used when the first inode for this bdi is marked dirty. It
+ * wakes-up the corresponding bdi thread which should then take care of the
+ * periodic background write-out of dirty inodes. Since the write-out would
+ * starts only 'dirty_writeback_interval' centisecs from now anyway, we just
+ * set up a timer which wakes the bdi thread up later.
+ *
+ * Note, we wouldn't bother setting up the timer, but this function is on the
+ * fast-path (used by '__mark_inode_dirty()'), so we save few context switches
+ * by delaying the wake-up.
+ */
+void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
+{
+	unsigned long timeout;
+
+	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
+	mod_timer(&bdi->wb.wakeup_timer, jiffies + timeout);
+}
+
 /*
  * Calculate the longest interval (jiffies) bdi threads are allowed to be
  * inactive.
@@ -353,8 +379,10 @@ static int bdi_forker_thread(void *ptr)
 		 * Temporary measure, we want to make sure we don't see
 		 * dirty data on the default backing_dev_info
 		 */
-		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
+		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list)) {
+			del_timer(&me->wakeup_timer);
 			wb_do_writeback(me, 0);
+		}
 
 		spin_lock_bh(&bdi_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -586,6 +614,7 @@ void bdi_unregister(struct backing_dev_info *bdi)
 	if (bdi->dev) {
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
+		del_timer_sync(&bdi->wb.wakeup_timer);
 
 		if (!bdi_cap_flush_forker(bdi))
 			bdi_wb_shutdown(bdi);
@@ -596,6 +625,18 @@ void bdi_unregister(struct backing_dev_info *bdi)
 }
 EXPORT_SYMBOL(bdi_unregister);
 
+static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
+{
+	memset(wb, 0, sizeof(*wb));
+
+	wb->bdi = bdi;
+	wb->last_old_flush = jiffies;
+	INIT_LIST_HEAD(&wb->b_dirty);
+	INIT_LIST_HEAD(&wb->b_io);
+	INIT_LIST_HEAD(&wb->b_more_io);
+	setup_timer(&wb->wakeup_timer, wakeup_timer_fn, (unsigned long)bdi);
+}
+
 int bdi_init(struct backing_dev_info *bdi)
 {
 	int i, err;
-- 
1.7.1.1

