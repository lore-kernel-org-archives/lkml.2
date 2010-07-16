Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965476Ab0GPMta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:49:30 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54042 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965397Ab0GPMtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:11 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 03/16] writeback: harmonize writeback threads naming
Date: Fri, 16 Jul 2010 15:44:59 +0300
Message-Id: <1279284312-2411-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:49:01.0149 (UTC) FILETIME=[43A998D0:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The write-back code mixes words "thread" and "task" for the
same things - this is not a problem, but this is still an
inconsistency which makes it a bit difficult to read the code.

hch: a convention I tend to use and I've seen in various places
is to always use _task for the storage of the task_struct pointer,
and thread everywhere else.  This especially helps with having
foo_thread for the actual thread and foo_task for a global
variable keeping the task_struct pointer

This patch renames:

'bdi_add_default_flusher_task()' -> 'bdi_add_default_flusher_thread()'
'bdi_forker_task()' -> 'bdi_forker_thread()'

This is just more consistent, because the per-bdi flushers are
'bdi_writeback_thread()'.

This patch also amends commentaries and makes them refer the forker
thread and the write-back threads as "thread", not "task".

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c           |    2 +-
 include/linux/backing-dev.h |    2 +-
 mm/backing-dev.c            |   26 +++++++++++++-------------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index bf10cbf..5e6b7fc 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -840,7 +840,7 @@ int bdi_writeback_thread(void *data)
 
 			/*
 			 * Longest period of inactivity that we tolerate. If we
-			 * see dirty data again later, the task will get
+			 * see dirty data again later, the thread will get
 			 * recreated automatically.
 			 */
 			max_idle = max(5UL * 60 * HZ, wait_jiffies);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index e536f3a..f0936f5 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -50,7 +50,7 @@ struct bdi_writeback {
 
 	unsigned long last_old_flush;		/* last old data flush */
 
-	struct task_struct	*task;		/* writeback task */
+	struct task_struct	*task;		/* writeback thread */
 	struct list_head	b_dirty;	/* dirty inodes */
 	struct list_head	b_io;		/* parked for writeback */
 	struct list_head	b_more_io;	/* parked for more writeback */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0fad60d..b34c12a 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -50,7 +50,7 @@ static struct timer_list sync_supers_timer;
 static int bdi_sync_supers(void *);
 static void sync_supers_timer_fn(unsigned long);
 
-static void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
+static void bdi_add_default_flusher_thread(struct backing_dev_info *bdi);
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -279,10 +279,10 @@ static void bdi_flush_io(struct backing_dev_info *bdi)
 }
 
 /*
- * kupdated() used to do this. We cannot do it from the bdi_forker_task()
+ * kupdated() used to do this. We cannot do it from the bdi_forker_thread()
  * or we risk deadlocking on ->s_umount. The longer term solution would be
  * to implement sync_supers_bdi() or similar and simply do it from the
- * bdi writeback tasks individually.
+ * bdi writeback thread individually.
  */
 static int bdi_sync_supers(void *unused)
 {
@@ -318,7 +318,7 @@ static void sync_supers_timer_fn(unsigned long unused)
 	bdi_arm_supers_timer();
 }
 
-static int bdi_forker_task(void *ptr)
+static int bdi_forker_thread(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
 
@@ -354,7 +354,7 @@ static int bdi_forker_task(void *ptr)
 			    !bdi_has_dirty_io(bdi))
 				continue;
 
-			bdi_add_default_flusher_task(bdi);
+			bdi_add_default_flusher_thread(bdi);
 		}
 
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -376,7 +376,7 @@ static int bdi_forker_task(void *ptr)
 
 		/*
 		 * This is our real job - check for pending entries in
-		 * bdi_pending_list, and create the tasks that got added
+		 * bdi_pending_list, and create the threads that got added
 		 */
 		bdi = list_entry(bdi_pending_list.next, struct backing_dev_info,
 				 bdi_list);
@@ -387,7 +387,7 @@ static int bdi_forker_task(void *ptr)
 		wb->task = kthread_run(bdi_writeback_thread, wb, "flush-%s",
 					dev_name(bdi->dev));
 		/*
-		 * If task creation fails, then readd the bdi to
+		 * If thread creation fails, then readd the bdi to
 		 * the pending list and force writeout of the bdi
 		 * from this forker thread. That will free some memory
 		 * and we can try again.
@@ -423,10 +423,10 @@ static void bdi_add_to_pending(struct rcu_head *head)
 }
 
 /*
- * Add the default flusher task that gets created for any bdi
+ * Add the default flusher thread that gets created for any bdi
  * that has dirty data pending writeout
  */
-void static bdi_add_default_flusher_task(struct backing_dev_info *bdi)
+void static bdi_add_default_flusher_thread(struct backing_dev_info *bdi)
 {
 	if (!bdi_cap_writeback_dirty(bdi))
 		return;
@@ -438,10 +438,10 @@ void static bdi_add_default_flusher_task(struct backing_dev_info *bdi)
 	}
 
 	/*
-	 * Check with the helper whether to proceed adding a task. Will only
+	 * Check with the helper whether to proceed adding a thread. Will only
 	 * abort if we two or more simultanous calls to
-	 * bdi_add_default_flusher_task() occured, further additions will block
-	 * waiting for previous additions to finish.
+	 * bdi_add_default_flusher_thread() occured, further additions will
+	 * block waiting for previous additions to finish.
 	 */
 	if (!test_and_set_bit(BDI_pending, &bdi->state)) {
 		list_del_rcu(&bdi->bdi_list);
@@ -499,7 +499,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 	if (bdi_cap_flush_forker(bdi)) {
 		struct bdi_writeback *wb = &bdi->wb;
 
-		wb->task = kthread_run(bdi_forker_task, wb, "bdi-%s",
+		wb->task = kthread_run(bdi_forker_thread, wb, "bdi-%s",
 						dev_name(dev));
 		if (IS_ERR(wb->task)) {
 			wb->task = NULL;
-- 
1.7.1.1

