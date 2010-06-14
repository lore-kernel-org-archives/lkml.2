Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab0FNVkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:40:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:46950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734Ab0FNVjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:25 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 26/30] workqueue: add system_wq, system_long_wq and system_nrt_wq
Date: Mon, 14 Jun 2010 23:37:43 +0200
Message-Id: <1276551467-21246-27-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename keventd_wq to system_wq and export it.  Also add system_long_wq
and system_nrt_wq.  The former is to host long running works
separately (so that flush_scheduled_work() dosen't take so long) and
the latter guarantees any queued work item is never executed in
parallel by multiple CPUs.  These workqueues will be used by future
patches to update workqueue users.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   19 +++++++++++++++++++
 kernel/workqueue.c        |   30 +++++++++++++++++++-----------
 2 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 33e24e7..e8c3410 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -232,6 +232,25 @@ enum {
 	WQ_DFL_ACTIVE		= WQ_MAX_ACTIVE / 2,
 };
 
+/*
+ * System-wide workqueues which are always present.
+ *
+ * system_wq is the one used by schedule[_delayed]_work[_on]().
+ * Multi-CPU multi-threaded.  There are users which expect relatively
+ * short queue flush time.  Don't queue works which can run for too
+ * long.
+ *
+ * system_long_wq is similar to system_wq but may host long running
+ * works.  Queue flushing might take relatively long.
+ *
+ * system_nrt_wq is non-reentrant and guarantees that any given work
+ * item is never executed in parallel by multiple CPUs.  Queue
+ * flushing might take relatively long.
+ */
+extern struct workqueue_struct *system_wq;
+extern struct workqueue_struct *system_long_wq;
+extern struct workqueue_struct *system_nrt_wq;
+
 extern struct workqueue_struct *
 __create_workqueue_key(const char *name, unsigned int flags, int max_active,
 		       struct lock_class_key *key, const char *lock_name);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9f22dbd..b829ddb 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -210,6 +210,13 @@ struct workqueue_struct {
 #endif
 };
 
+struct workqueue_struct *system_wq __read_mostly;
+struct workqueue_struct *system_long_wq __read_mostly;
+struct workqueue_struct *system_nrt_wq __read_mostly;
+EXPORT_SYMBOL_GPL(system_wq);
+EXPORT_SYMBOL_GPL(system_long_wq);
+EXPORT_SYMBOL_GPL(system_nrt_wq);
+
 #define for_each_busy_worker(worker, i, pos, gcwq)			\
 	for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)			\
 		hlist_for_each_entry(worker, pos, &gcwq->busy_hash[i], hentry)
@@ -2251,8 +2258,6 @@ int cancel_delayed_work_sync(struct delayed_work *dwork)
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
-static struct workqueue_struct *keventd_wq __read_mostly;
-
 /**
  * schedule_work - put work task in global workqueue
  * @work: job to be done
@@ -2266,7 +2271,7 @@ static struct workqueue_struct *keventd_wq __read_mostly;
  */
 int schedule_work(struct work_struct *work)
 {
-	return queue_work(keventd_wq, work);
+	return queue_work(system_wq, work);
 }
 EXPORT_SYMBOL(schedule_work);
 
@@ -2279,7 +2284,7 @@ EXPORT_SYMBOL(schedule_work);
  */
 int schedule_work_on(int cpu, struct work_struct *work)
 {
-	return queue_work_on(cpu, keventd_wq, work);
+	return queue_work_on(cpu, system_wq, work);
 }
 EXPORT_SYMBOL(schedule_work_on);
 
@@ -2294,7 +2299,7 @@ EXPORT_SYMBOL(schedule_work_on);
 int schedule_delayed_work(struct delayed_work *dwork,
 					unsigned long delay)
 {
-	return queue_delayed_work(keventd_wq, dwork, delay);
+	return queue_delayed_work(system_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work);
 
@@ -2327,7 +2332,7 @@ EXPORT_SYMBOL(flush_delayed_work);
 int schedule_delayed_work_on(int cpu,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
+	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work_on);
 
@@ -2392,7 +2397,7 @@ int schedule_on_each_cpu(work_func_t func)
  */
 void flush_scheduled_work(void)
 {
-	flush_workqueue(keventd_wq);
+	flush_workqueue(system_wq);
 }
 EXPORT_SYMBOL(flush_scheduled_work);
 
@@ -2424,7 +2429,7 @@ EXPORT_SYMBOL_GPL(execute_in_process_context);
 
 int keventd_up(void)
 {
-	return keventd_wq != NULL;
+	return system_wq != NULL;
 }
 
 static struct cpu_workqueue_struct *alloc_cwqs(void)
@@ -2850,7 +2855,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 			continue;
 
 		debug_work_activate(rebind_work);
-		insert_work(get_cwq(gcwq->cpu, keventd_wq), rebind_work,
+		insert_work(get_cwq(gcwq->cpu, system_wq), rebind_work,
 			    worker->scheduled.next,
 			    work_color_to_flags(WORK_NO_COLOR));
 	}
@@ -3235,6 +3240,9 @@ void __init init_workqueues(void)
 		spin_unlock_irq(&gcwq->lock);
 	}
 
-	keventd_wq = __create_workqueue("events", 0, WQ_DFL_ACTIVE);
-	BUG_ON(!keventd_wq);
+	system_wq = __create_workqueue("events", 0, WQ_DFL_ACTIVE);
+	system_long_wq = __create_workqueue("events_long", 0, WQ_DFL_ACTIVE);
+	system_nrt_wq = __create_workqueue("events_nrt", WQ_NON_REENTRANT,
+					   WQ_DFL_ACTIVE);
+	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq);
 }
-- 
1.6.4.2

