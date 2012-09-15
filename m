Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab2IOIrJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 04:47:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63329 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab2IOIpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 04:45:32 -0400
X-IronPort-AV: E=Sophos;i="4.80,427,1344182400"; 
   d="scan'208";a="5850814"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/6] workqueue: async idle rebinding
Date: Sat, 15 Sep 2012 16:13:34 +0800
Message-Id: <1347696825-24622-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347696825-24622-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347696825-24622-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/15 16:12:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/15 16:12:52,
	Serialize complete at 2012/09/15 16:12:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current rebind_workers() uses synchronous algorithm for idle_workers,
becuase the workers in idle_list must be rebound before local-wake-up.

but synchronous algorithm adds a lot of complication. so we search
another way to handle local-wake-up and use async algrithm for it.

To avoid to wrongly do local-wake-up, we add an exile-operation for
idle-worker-rebinding. When a idle worker is exiled, it will not queued
on @idle_list until it is rebound.

When a cpu is online, rebind_workers() just
notifies the idle workers to do rebind(A). and
exile the idle wokers(remove the idle workers from idle_list)(B).

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

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |  126 +++++++++++-----------------------------------------
 1 files changed, 26 insertions(+), 100 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7b91332..e8b28d6 100644
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
+	if (unlikely(list_empty(&pool->idle_list)))
+		return false;
+
 	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
 }
 
@@ -1611,37 +1613,20 @@ __acquires(&gcwq->lock)
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
-
-	/* we did our part, wait for rebind_workers() to finish up */
-	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
+	if (worker_maybe_bind_and_lock(worker))
+		worker_clr_flags(worker, WORKER_UNBOUND);
 
-	/*
-	 * rebind_workers() shouldn't finish until all workers passed the
-	 * above WORKER_REBIND wait.  Tell it when done.
-	 */
-	spin_lock_irq(&worker->pool->gcwq->lock);
-	if (!--worker->idle_rebind->cnt)
-		complete(&worker->idle_rebind->done);
-	spin_unlock_irq(&worker->pool->gcwq->lock);
+	worker_clr_flags(worker, WORKER_REBIND);
+	list_add(&worker->entry, &worker->pool->idle_list);
+	spin_unlock_irq(&gcwq->lock);
 }
 
 /*
@@ -1668,29 +1653,21 @@ static void busy_worker_rebind_fn(struct work_struct *work)
  * @gcwq->cpu is coming online.  Rebind all workers to the CPU.  Rebinding
  * is different for idle and busy ones.
  *
- * The idle ones should be rebound synchronously and idle rebinding should
- * be complete before any worker starts executing work items with
- * concurrency management enabled; otherwise, scheduler may oops trying to
- * wake up non-local idle worker from wq_worker_sleeping().
- *
- * This is achieved by repeatedly requesting rebinding until all idle
- * workers are known to have been rebound under @gcwq->lock and holding all
- * idle workers from becoming busy until idle rebinding is complete.
+ * The idle ones will be kicked out of the idle_list, and it will
+ * add itself back when it finish to rebind.
  *
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
+ * On return, all workers are guaranteed to be rebound when they
+ * add themselves back to idle_list if the gcwq is still associated.
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
 
@@ -1699,46 +1676,25 @@ static void rebind_workers(struct global_cwq *gcwq)
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
+			/* exile idle workers */
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
@@ -1768,34 +1724,6 @@ retry:
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
@@ -3908,8 +3836,6 @@ static int __init init_workqueues(void)
 			mutex_init(&pool->manager_mutex);
 			ida_init(&pool->worker_ida);
 		}
-
-		init_waitqueue_head(&gcwq->rebind_hold);
 	}
 
 	/* create the initial worker */
-- 
1.7.4.4

