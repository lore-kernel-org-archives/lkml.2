Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab0GUJeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 05:34:25 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25450 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab0GUJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 05:32:05 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 06/11] writeback: simplify bdi code a little
Date: Wed, 21 Jul 2010 12:31:41 +0300
Message-Id: <1279704706-1267-7-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 21 Jul 2010 09:31:48.0518 (UTC) FILETIME=[8AEE2460:01CB28B7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch simplifies bdi code a little by removing the 'pending_list' which is
redundant. Indeed, currently the forker thread ('bdi_forker_thread()') is
working like this:

1. In a loop, fetch all bdi's which have works but have no writeback thread and
   move them to the 'pending_list'.
2. If the list is empty, sleep for 5 sec.
3. Otherwise, take one bdi from the list, fork the writeback thread for this
   bdi, and repeat the loop.

IOW, it first moves everything to the 'pending_list', then process only one
element, and so on. This patch simplifies the algorithm, which is now as
follows.

1. Find the first bdi which has a work and remove it from the global list of
   bdi's (bdi_list).
2. If there was not such bdi, sleep 5 sec.
3. Fork the writeback thread for this bdi and repeat the loop.

IOW, now we find the first bdi to process, process it, and so on. This is
simpler and involves less lists.

The bonus now is that we can get rid of a couple of functions, as well as
remove complications which involve 'rcu_call()' and 'bdi->rcu_head'.

This patch also makes sure we use 'list_add_tail_rcu()', instead of plain
'list_add_tail()', but this piece of code is going to be removed in the next
patch anyway.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/linux/backing-dev.h |    1 -
 mm/backing-dev.c            |   82 +++++++++---------------------------------
 2 files changed, 18 insertions(+), 65 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index f0936f5..95ecb2b 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -58,7 +58,6 @@ struct bdi_writeback {
 
 struct backing_dev_info {
 	struct list_head bdi_list;
-	struct rcu_head rcu_head;
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
 	unsigned int capabilities; /* Device capabilities */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index ae44417..dbc6681 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -50,8 +50,6 @@ static struct timer_list sync_supers_timer;
 static int bdi_sync_supers(void *);
 static void sync_supers_timer_fn(unsigned long);
 
-static void bdi_add_default_flusher_thread(struct backing_dev_info *bdi);
-
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
@@ -331,6 +329,7 @@ static int bdi_forker_thread(void *ptr)
 	set_user_nice(current, 0);
 
 	for (;;) {
+		bool fork = false;
 		struct task_struct *task;
 		struct backing_dev_info *bdi, *tmp;
 
@@ -349,23 +348,30 @@ static int bdi_forker_thread(void *ptr)
 		 * a thread registered. If so, set that up.
 		 */
 		list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
+			if (!bdi_cap_writeback_dirty(bdi))
+				continue;
 			if (bdi->wb.task)
 				continue;
 			if (list_empty(&bdi->work_list) &&
 			    !bdi_has_dirty_io(bdi))
 				continue;
 
-			bdi_add_default_flusher_thread(bdi);
+			WARN(!test_bit(BDI_registered, &bdi->state),
+			     "bdi %p/%s is not registered!\n", bdi, bdi->name);
+
+			list_del_rcu(&bdi->bdi_list);
+			fork = true;
+			break;
 		}
+		spin_unlock_bh(&bdi_lock);
 
 		/* Keep working if default bdi still has things to do */
 		if (!list_empty(&me->bdi->work_list))
 			__set_current_state(TASK_RUNNING);
 
-		if (list_empty(&bdi_pending_list)) {
+		if (!fork) {
 			unsigned long wait;
 
-			spin_unlock_bh(&bdi_lock);
 			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
 			if (wait)
 				schedule_timeout(wait);
@@ -378,13 +384,13 @@ static int bdi_forker_thread(void *ptr)
 		__set_current_state(TASK_RUNNING);
 
 		/*
-		 * This is our real job - check for pending entries in
-		 * bdi_pending_list, and create the threads that got added
+		 * Set the pending bit - if someone will try to unregister this
+		 * bdi - it'll wait on this bit.
 		 */
-		bdi = list_entry(bdi_pending_list.next, struct backing_dev_info,
-				 bdi_list);
-		list_del_init(&bdi->bdi_list);
-		spin_unlock_bh(&bdi_lock);
+		set_bit(BDI_pending, &bdi->state);
+
+		/* Make sure no one uses the picked bdi */
+		synchronize_rcu();
 
 		task = kthread_run(bdi_writeback_thread, &bdi->wb, "flush-%s",
 				   dev_name(bdi->dev));
@@ -397,7 +403,7 @@ static int bdi_forker_thread(void *ptr)
 			 * flush other bdi's to free memory.
 			 */
 			spin_lock_bh(&bdi_lock);
-			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
+			list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
 			spin_unlock_bh(&bdi_lock);
 
 			bdi_flush_io(bdi);
@@ -408,57 +414,6 @@ static int bdi_forker_thread(void *ptr)
 	return 0;
 }
 
-static void bdi_add_to_pending(struct rcu_head *head)
-{
-	struct backing_dev_info *bdi;
-
-	bdi = container_of(head, struct backing_dev_info, rcu_head);
-	INIT_LIST_HEAD(&bdi->bdi_list);
-
-	spin_lock(&bdi_lock);
-	list_add_tail(&bdi->bdi_list, &bdi_pending_list);
-	spin_unlock(&bdi_lock);
-
-	/*
-	 * We are now on the pending list, wake up bdi_forker_task()
-	 * to finish the job and add us back to the active bdi_list
-	 */
-	wake_up_process(default_backing_dev_info.wb.task);
-}
-
-/*
- * Add the default flusher thread that gets created for any bdi
- * that has dirty data pending writeout
- */
-void static bdi_add_default_flusher_thread(struct backing_dev_info *bdi)
-{
-	if (!bdi_cap_writeback_dirty(bdi))
-		return;
-
-	if (WARN_ON(!test_bit(BDI_registered, &bdi->state))) {
-		printk(KERN_ERR "bdi %p/%s is not registered!\n",
-							bdi, bdi->name);
-		return;
-	}
-
-	/*
-	 * Check with the helper whether to proceed adding a thread. Will only
-	 * abort if we two or more simultanous calls to
-	 * bdi_add_default_flusher_thread() occured, further additions will
-	 * block waiting for previous additions to finish.
-	 */
-	if (!test_and_set_bit(BDI_pending, &bdi->state)) {
-		list_del_rcu(&bdi->bdi_list);
-
-		/*
-		 * We must wait for the current RCU period to end before
-		 * moving to the pending list. So schedule that operation
-		 * from an RCU callback.
-		 */
-		call_rcu(&bdi->rcu_head, bdi_add_to_pending);
-	}
-}
-
 /*
  * Remove bdi from bdi_list, and ensure that it is no longer visible
  */
@@ -599,7 +554,6 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
 	spin_lock_init(&bdi->wb_lock);
-	INIT_RCU_HEAD(&bdi->rcu_head);
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->work_list);
 
-- 
1.7.1.1

