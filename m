Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0FNVjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:39:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:46893 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab0FNVjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:14 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/30] workqueue: separate out process_one_work()
Date: Mon, 14 Jun 2010 23:37:24 +0200
Message-Id: <1276551467-21246-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out process_one_work() out of run_workqueue().  This patch
doesn't cause any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  100 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 61 insertions(+), 39 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5c49d76..8e3082b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -402,51 +402,73 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
+/**
+ * process_one_work - process single work
+ * @cwq: cwq to process work for
+ * @work: work to process
+ *
+ * Process @work.  This function contains all the logics necessary to
+ * process a single work including synchronization against and
+ * interaction with other workers on the same cpu, queueing and
+ * flushing.  As long as context requirement is met, any worker can
+ * call this function to process a work.
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock) which is released and regrabbed.
+ */
+static void process_one_work(struct cpu_workqueue_struct *cwq,
+			     struct work_struct *work)
+{
+	work_func_t f = work->func;
+#ifdef CONFIG_LOCKDEP
+	/*
+	 * It is permissible to free the struct work_struct from
+	 * inside the function that is called from it, this we need to
+	 * take into account for lockdep too.  To avoid bogus "held
+	 * lock freed" warnings as well as problems when looking into
+	 * work->lockdep_map, make a copy and use that here.
+	 */
+	struct lockdep_map lockdep_map = work->lockdep_map;
+#endif
+	/* claim and process */
+	trace_workqueue_execution(cwq->thread, work);
+	debug_work_deactivate(work);
+	cwq->current_work = work;
+	list_del_init(&work->entry);
+
+	spin_unlock_irq(&cwq->lock);
+
+	BUG_ON(get_wq_data(work) != cwq);
+	work_clear_pending(work);
+	lock_map_acquire(&cwq->wq->lockdep_map);
+	lock_map_acquire(&lockdep_map);
+	f(work);
+	lock_map_release(&lockdep_map);
+	lock_map_release(&cwq->wq->lockdep_map);
+
+	if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
+		printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
+		       "%s/0x%08x/%d\n",
+		       current->comm, preempt_count(), task_pid_nr(current));
+		printk(KERN_ERR "    last function: ");
+		print_symbol("%s\n", (unsigned long)f);
+		debug_show_held_locks(current);
+		dump_stack();
+	}
+
+	spin_lock_irq(&cwq->lock);
+
+	/* we're done with it, release */
+	cwq->current_work = NULL;
+}
+
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	spin_lock_irq(&cwq->lock);
 	while (!list_empty(&cwq->worklist)) {
 		struct work_struct *work = list_entry(cwq->worklist.next,
 						struct work_struct, entry);
-		work_func_t f = work->func;
-#ifdef CONFIG_LOCKDEP
-		/*
-		 * It is permissible to free the struct work_struct
-		 * from inside the function that is called from it,
-		 * this we need to take into account for lockdep too.
-		 * To avoid bogus "held lock freed" warnings as well
-		 * as problems when looking into work->lockdep_map,
-		 * make a copy and use that here.
-		 */
-		struct lockdep_map lockdep_map = work->lockdep_map;
-#endif
-		trace_workqueue_execution(cwq->thread, work);
-		debug_work_deactivate(work);
-		cwq->current_work = work;
-		list_del_init(cwq->worklist.next);
-		spin_unlock_irq(&cwq->lock);
-
-		BUG_ON(get_wq_data(work) != cwq);
-		work_clear_pending(work);
-		lock_map_acquire(&cwq->wq->lockdep_map);
-		lock_map_acquire(&lockdep_map);
-		f(work);
-		lock_map_release(&lockdep_map);
-		lock_map_release(&cwq->wq->lockdep_map);
-
-		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
-			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
-					"%s/0x%08x/%d\n",
-					current->comm, preempt_count(),
-				       	task_pid_nr(current));
-			printk(KERN_ERR "    last function: ");
-			print_symbol("%s\n", (unsigned long)f);
-			debug_show_held_locks(current);
-			dump_stack();
-		}
-
-		spin_lock_irq(&cwq->lock);
-		cwq->current_work = NULL;
+		process_one_work(cwq, work);
 	}
 	spin_unlock_irq(&cwq->lock);
 }
-- 
1.6.4.2

