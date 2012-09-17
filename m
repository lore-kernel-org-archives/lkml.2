Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab2IQPpC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:45:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50367 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756672Ab2IQPox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:44:53 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344182400"; 
   d="scan'208";a="5859717"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V2 for-next PATCH 2/7] workqueue: async idle rebinding
Date: Mon, 17 Sep 2012 23:46:43 +0800
Message-Id: <1347896808-2398-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:06,
	Serialize complete at 2012/09/17 23:45:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current rebind_workers() uses synchronous algorithm for idle_workers,
becuase the workers in @idle_list must be rebound before
local-wake-up become available.

but synchronous algorithm adds a lot of complication. So we search
another way to handle local-wake-up and use async algrithm for it.

To avoid to wrongly do local-wake-up, we add an exile-operation for
idle-worker-rebinding. When a idle worker is exiled, it will be dequeued
from @idle_list and it will be enqueued back after it is rebound.

When a cpu is online, rebind_workers() just
notifies the idle workers to do rebind(A) and
exile the idle wokers(dequeue the idle workers from idle_list)(B).

And every idle worker will rebind itself(^A) and add itself back to idle_list(^B).

A and ^A ensure all idle workers will do rebind after the CPU is up.
B and ^B ensure that all workers in idle_list are bound when !GCWQ_DISASSOCIATED

When we have exile-operation, any bound worker can safely to do
local-wake-up when idle_list is not empty, because all workers
can't add itself to idle_list until it has rebound.

After we have exile-operation, the @nr_idle is not only the count
of @idle_list, but also exiled idle workers. so I check all the code which
access to @nr_idle or @idle_list, and make them be aware to exile-operation.
(only change too_many_workers() at the result)

rebind_workers() become single pass and don't release gcwq->lock in between.

remove unnecessary idle_rebind structure and pointer
remove unnecessary rebind_hold.

Changed from V1:
	1) remove unlikely from too_many_workers(), @idle_list can be empty
	   anytime, even before this patch, no reason to use unlikely.
	2) fix a small rebasing mistake.
	   (which is from rebasing the orignal fixing patch to for-next)
	3) add a lot of comments.
	4) clear WORKER_REBIND unconditionaly in idle_worker_rebind()

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |  146 +++++++++++++++++-----------------------------------
 1 files changed, 47 insertions(+), 99 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cc49593..dbc942e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -126,7 +126,6 @@ enum {
 
 struct global_cwq;
 struct worker_pool;
-struct idle_rebind;
 
 /*
  * The poor guys doing the actual heavy lifting.  All on-duty workers
@@ -150,7 +149,6 @@ struct worker {
 	int			id;		/* I: worker id */
 
 	/* for rebinding worker to CPU */
-	struct idle_rebind	*idle_rebind;	/* L: for idle worker */
 	struct work_struct	rebind_work;	/* L: for busy worker */
 };
 
@@ -160,7 +158,9 @@ struct worker_pool {
 
 	struct list_head	worklist;	/* L: list of pending works */
 	int			nr_workers;	/* L: total number of workers */
-	int			nr_idle;	/* L: currently idle ones */
+	int			nr_idle;	/* L: currently idle ones,
+						      include ones in idle_list
+						      and in doing rebind. */
 
 	struct list_head	idle_list;	/* X: list of idle workers */
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
@@ -186,8 +186,6 @@ struct global_cwq {
 
 	struct worker_pool	pools[NR_WORKER_POOLS];
 						/* normal and highpri pools */
-
-	wait_queue_head_t	rebind_hold;	/* rebind hold wait */
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -687,6 +685,10 @@ static bool too_many_workers(struct worker_pool *pool)
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
+	/* Is any idle home ? */
+	if (list_empty(&pool->idle_list))
+		return false;
+
 	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
 }
 
@@ -1611,37 +1613,22 @@ __acquires(&gcwq->lock)
 	}
 }
 
-struct idle_rebind {
-	int			cnt;		/* # workers to be rebound */
-	struct completion	done;		/* all workers rebound */
-};
-
 /*
- * Rebind an idle @worker to its CPU.  During CPU onlining, this has to
- * happen synchronously for idle workers.  worker_thread() will test
+ * Rebind an idle @worker to its CPU. worker_thread() will test
  * %WORKER_REBIND before leaving idle and call this function.
  */
 static void idle_worker_rebind(struct worker *worker)
 {
 	struct global_cwq *gcwq = worker->pool->gcwq;
 
-	/* CPU must be online at this point */
-	WARN_ON(!worker_maybe_bind_and_lock(worker));
-	if (!--worker->idle_rebind->cnt)
-		complete(&worker->idle_rebind->done);
-	spin_unlock_irq(&worker->pool->gcwq->lock);
+	if (!worker_maybe_bind_and_lock(worker))
+		worker->flags |= WORKER_UNBOUND;
 
-	/* we did our part, wait for rebind_workers() to finish up */
-	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
+	worker_clr_flags(worker, WORKER_REBIND);
 
-	/*
-	 * rebind_workers() shouldn't finish until all workers passed the
-	 * above WORKER_REBIND wait.  Tell it when done.
-	 */
-	spin_lock_irq(&worker->pool->gcwq->lock);
-	if (!--worker->idle_rebind->cnt)
-		complete(&worker->idle_rebind->done);
-	spin_unlock_irq(&worker->pool->gcwq->lock);
+	/* it is idle worker, add itself back */
+	list_add(&worker->entry, &worker->pool->idle_list);
+	spin_unlock_irq(&gcwq->lock);
 }
 
 /*
@@ -1677,29 +1664,29 @@ static void busy_worker_rebind_fn(struct work_struct *work)
  * @gcwq->cpu is coming online.  Rebind all workers to the CPU.  Rebinding
  * is different for idle and busy ones.
  *
- * The idle ones should be rebound synchronously and idle rebinding should
- * be complete before any worker starts executing work items with
- * concurrency management enabled; otherwise, scheduler may oops trying to
- * wake up non-local idle worker from wq_worker_sleeping().
+ * The idle ones will be kicked out of the idle_list, and it will
+ * add itself back when it finish to rebind. It forces all unbound
+ * workers leave the idles list and avoid wrong local-wake-up.
  *
- * This is achieved by repeatedly requesting rebinding until all idle
- * workers are known to have been rebound under @gcwq->lock and holding all
- * idle workers from becoming busy until idle rebinding is complete.
- *
- * Once idle workers are rebound, busy workers can be rebound as they
- * finish executing their current work items.  Queueing the rebind work at
- * the head of their scheduled lists is enough.  Note that nr_running will
+ * The busy workers can be rebound as they finish executing
+ * their current work items.  Queueing the rebind work at the head of
+ * their scheduled lists is enough.  Note that nr_running will
  * be properbly bumped as busy workers rebind.
  *
- * On return, all workers are guaranteed to either be bound or have rebind
- * work item scheduled.
+ * On return, all workers are guaranteed to be scheduled to do rebind.
+ * (maybe except for manager, see the comments of manage_workers().)
+ * And any worker(including manager) will not appear in @idle_list until
+ * it finishs to rebind.
+ *
+ * On return, @idle_list is guaranteed to contain only bound workers
+ * if the gcwq is still associated. So any bound worker can safely
+ * do local-wake-up when idle_list is not empty, because any
+ * workers can't add itself to idle_list until it has rebound.
  */
 static void rebind_workers(struct global_cwq *gcwq)
-	__releases(&gcwq->lock) __acquires(&gcwq->lock)
 {
-	struct idle_rebind idle_rebind;
 	struct worker_pool *pool;
-	struct worker *worker;
+	struct worker *worker, *n;
 	struct hlist_node *pos;
 	int i;
 
@@ -1708,46 +1695,37 @@ static void rebind_workers(struct global_cwq *gcwq)
 	for_each_worker_pool(pool, gcwq)
 		lockdep_assert_held(&pool->manager_mutex);
 
-	/*
-	 * Rebind idle workers.  Interlocked both ways.  We wait for
-	 * workers to rebind via @idle_rebind.done.  Workers will wait for
-	 * us to finish up by watching %WORKER_REBIND.
-	 */
-	init_completion(&idle_rebind.done);
-retry:
-	idle_rebind.cnt = 1;
-	INIT_COMPLETION(idle_rebind.done);
-
-	/* set REBIND and kick idle ones, we'll wait for these later */
+	/* set REBIND and kick idle ones */
 	for_each_worker_pool(pool, gcwq) {
-		list_for_each_entry(worker, &pool->idle_list, entry) {
+		list_for_each_entry_safe(worker, n, &pool->idle_list, entry) {
 			unsigned long worker_flags = worker->flags;
 
-			if (worker->flags & WORKER_REBIND)
-				continue;
-
 			/* morph UNBOUND to REBIND atomically */
 			worker_flags &= ~WORKER_UNBOUND;
 			worker_flags |= WORKER_REBIND;
 			ACCESS_ONCE(worker->flags) = worker_flags;
 
-			idle_rebind.cnt++;
-			worker->idle_rebind = &idle_rebind;
+			/*
+			 * All rebinding(of idle and busy workers) will
+			 * happen async, and the rebound workers may
+			 * go/continue to process works and may
+			 * do local-wake-up.
+			 *
+			 * To avoid a worker which is rebound earlier
+			 * to wrongly locally wake up this idle worker
+			 * which may be rebound later. we must dequeue
+			 * this unbound idle worker from the @idle_list.
+			 * This worker will add it self back when it has
+			 * been rebound.
+			 */
+			list_del_init(&worker->entry);
 
 			/* worker_thread() will call idle_worker_rebind() */
 			wake_up_process(worker->task);
 		}
 	}
 
-	if (--idle_rebind.cnt) {
-		spin_unlock_irq(&gcwq->lock);
-		wait_for_completion(&idle_rebind.done);
-		spin_lock_irq(&gcwq->lock);
-		/* busy ones might have become idle while waiting, retry */
-		goto retry;
-	}
-
-	/* all idle workers are rebound, rebind busy workers */
+	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		unsigned long worker_flags = worker->flags;
 		struct work_struct *rebind_work = &worker->rebind_work;
@@ -1777,34 +1755,6 @@ retry:
 			worker->scheduled.next,
 			work_color_to_flags(WORK_NO_COLOR));
 	}
-
-	/*
-	 * All idle workers are rebound and waiting for %WORKER_REBIND to
-	 * be cleared inside idle_worker_rebind().  Clear and release.
-	 * Clearing %WORKER_REBIND from this foreign context is safe
-	 * because these workers are still guaranteed to be idle.
-	 *
-	 * We need to make sure all idle workers passed WORKER_REBIND wait
-	 * in idle_worker_rebind() before returning; otherwise, workers can
-	 * get stuck at the wait if hotplug cycle repeats.
-	 */
-	idle_rebind.cnt = 1;
-	INIT_COMPLETION(idle_rebind.done);
-
-	for_each_worker_pool(pool, gcwq) {
-		list_for_each_entry(worker, &pool->idle_list, entry) {
-			worker->flags &= ~WORKER_REBIND;
-			idle_rebind.cnt++;
-		}
-	}
-
-	wake_up_all(&gcwq->rebind_hold);
-
-	if (--idle_rebind.cnt) {
-		spin_unlock_irq(&gcwq->lock);
-		wait_for_completion(&idle_rebind.done);
-		spin_lock_irq(&gcwq->lock);
-	}
 }
 
 static struct worker *alloc_worker(void)
@@ -3916,8 +3866,6 @@ static int __init init_workqueues(void)
 			mutex_init(&pool->manager_mutex);
 			ida_init(&pool->worker_ida);
 		}
-
-		init_waitqueue_head(&gcwq->rebind_hold);
 	}
 
 	/* create the initial worker */
-- 
1.7.4.4

