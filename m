Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0F1VGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:06:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:42876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab0F1VGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:06:25 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 29/35] workqueue: s/__create_workqueue()/alloc_workqueue()/, and add system workqueues
Date: Mon, 28 Jun 2010 23:04:17 +0200
Message-Id: <1277759063-24607-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 21:05:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes changes to make new workqueue features available to
its users.

* Now that workqueue is more featureful, there should be a public
  workqueue creation function which takes paramters to control them.
  Rename __create_workqueue() to alloc_workqueue() and make 0
  max_active mean WQ_DFL_ACTIVE.  In the long run, all
  create_workqueue_*() will be converted over to alloc_workqueue().

* To further unify access interface, rename keventd_wq to system_wq
  and export it.

* Add system_long_wq and system_nrt_wq.  The former is to host long
  running works separately (so that flush_scheduled_work() dosen't
  take so long) and the latter guarantees any queued work item is
  never executed in parallel by multiple CPUs.  These will be used by
  future patches to update workqueue users.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   40 +++++++++++++++++++++++++++++-----------
 kernel/workqueue.c        |   42 +++++++++++++++++++++++++-----------------
 2 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 33e24e7..48b7422 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -232,12 +232,31 @@ enum {
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
-__create_workqueue_key(const char *name, unsigned int flags, int max_active,
-		       struct lock_class_key *key, const char *lock_name);
+__alloc_workqueue_key(const char *name, unsigned int flags, int max_active,
+		      struct lock_class_key *key, const char *lock_name);
 
 #ifdef CONFIG_LOCKDEP
-#define __create_workqueue(name, flags, max_active)		\
+#define alloc_workqueue(name, flags, max_active)		\
 ({								\
 	static struct lock_class_key __key;			\
 	const char *__lock_name;				\
@@ -247,21 +266,20 @@ __create_workqueue_key(const char *name, unsigned int flags, int max_active,
 	else							\
 		__lock_name = #name;				\
 								\
-	__create_workqueue_key((name), (flags), (max_active),	\
-				&__key, __lock_name);		\
+	__alloc_workqueue_key((name), (flags), (max_active),	\
+			      &__key, __lock_name);		\
 })
 #else
-#define __create_workqueue(name, flags, max_active)		\
-	__create_workqueue_key((name), (flags), (max_active), NULL, NULL)
+#define alloc_workqueue(name, flags, max_active)		\
+	__alloc_workqueue_key((name), (flags), (max_active), NULL, NULL)
 #endif
 
 #define create_workqueue(name)					\
-	__create_workqueue((name), WQ_RESCUER, 1)
+	alloc_workqueue((name), WQ_RESCUER, 1)
 #define create_freezeable_workqueue(name)			\
-	__create_workqueue((name),				\
-			   WQ_FREEZEABLE | WQ_SINGLE_CPU | WQ_RESCUER, 1)
+	alloc_workqueue((name), WQ_FREEZEABLE | WQ_SINGLE_CPU | WQ_RESCUER, 1)
 #define create_singlethread_workqueue(name)			\
-	__create_workqueue((name), WQ_SINGLE_CPU | WQ_RESCUER, 1)
+	alloc_workqueue((name), WQ_SINGLE_CPU | WQ_RESCUER, 1)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a5a36f3..08e4eb3 100644
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
@@ -2306,8 +2313,6 @@ int cancel_delayed_work_sync(struct delayed_work *dwork)
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
-static struct workqueue_struct *keventd_wq __read_mostly;
-
 /**
  * schedule_work - put work task in global workqueue
  * @work: job to be done
@@ -2321,7 +2326,7 @@ static struct workqueue_struct *keventd_wq __read_mostly;
  */
 int schedule_work(struct work_struct *work)
 {
-	return queue_work(keventd_wq, work);
+	return queue_work(system_wq, work);
 }
 EXPORT_SYMBOL(schedule_work);
 
@@ -2334,7 +2339,7 @@ EXPORT_SYMBOL(schedule_work);
  */
 int schedule_work_on(int cpu, struct work_struct *work)
 {
-	return queue_work_on(cpu, keventd_wq, work);
+	return queue_work_on(cpu, system_wq, work);
 }
 EXPORT_SYMBOL(schedule_work_on);
 
@@ -2349,7 +2354,7 @@ EXPORT_SYMBOL(schedule_work_on);
 int schedule_delayed_work(struct delayed_work *dwork,
 					unsigned long delay)
 {
-	return queue_delayed_work(keventd_wq, dwork, delay);
+	return queue_delayed_work(system_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work);
 
@@ -2382,7 +2387,7 @@ EXPORT_SYMBOL(flush_delayed_work);
 int schedule_delayed_work_on(int cpu,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
+	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work_on);
 
@@ -2447,7 +2452,7 @@ int schedule_on_each_cpu(work_func_t func)
  */
 void flush_scheduled_work(void)
 {
-	flush_workqueue(keventd_wq);
+	flush_workqueue(system_wq);
 }
 EXPORT_SYMBOL(flush_scheduled_work);
 
@@ -2479,7 +2484,7 @@ EXPORT_SYMBOL_GPL(execute_in_process_context);
 
 int keventd_up(void)
 {
-	return keventd_wq != NULL;
+	return system_wq != NULL;
 }
 
 static struct cpu_workqueue_struct *alloc_cwqs(void)
@@ -2533,15 +2538,16 @@ static int wq_clamp_max_active(int max_active, const char *name)
 	return clamp_val(max_active, 1, WQ_MAX_ACTIVE);
 }
 
-struct workqueue_struct *__create_workqueue_key(const char *name,
-						unsigned int flags,
-						int max_active,
-						struct lock_class_key *key,
-						const char *lock_name)
+struct workqueue_struct *__alloc_workqueue_key(const char *name,
+					       unsigned int flags,
+					       int max_active,
+					       struct lock_class_key *key,
+					       const char *lock_name)
 {
 	struct workqueue_struct *wq;
 	unsigned int cpu;
 
+	max_active = max_active ?: WQ_DFL_ACTIVE;
 	max_active = wq_clamp_max_active(max_active, name);
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
@@ -2620,7 +2626,7 @@ err:
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(__create_workqueue_key);
+EXPORT_SYMBOL_GPL(__alloc_workqueue_key);
 
 /**
  * destroy_workqueue - safely terminate a workqueue
@@ -2904,7 +2910,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 			continue;
 
 		debug_work_activate(rebind_work);
-		insert_work(get_cwq(gcwq->cpu, keventd_wq), rebind_work,
+		insert_work(get_cwq(gcwq->cpu, system_wq), rebind_work,
 			    worker->scheduled.next,
 			    work_color_to_flags(WORK_NO_COLOR));
 	}
@@ -3289,6 +3295,8 @@ void __init init_workqueues(void)
 		spin_unlock_irq(&gcwq->lock);
 	}
 
-	keventd_wq = __create_workqueue("events", 0, WQ_DFL_ACTIVE);
-	BUG_ON(!keventd_wq);
+	system_wq = alloc_workqueue("events", 0, 0);
+	system_long_wq = alloc_workqueue("events_long", 0, 0);
+	system_nrt_wq = alloc_workqueue("events_nrt", WQ_NON_REENTRANT, 0);
+	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq);
 }
-- 
1.6.4.2

