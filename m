Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2IHRLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:11:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab2IHRLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:11:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,392,1344182400"; 
   d="scan'208";a="5807475"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/7 V6] workqueue: async idle rebinding
Date: Sun, 9 Sep 2012 01:12:51 +0800
Message-Id: <1347124383-18723-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:48,
	Serialize complete at 2012/09/09 01:10:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix deadlock in rebind_workers()

Current idle_worker_rebind() has a bug.

idle_worker_rebind() path			HOTPLUG path
						online
							rebind_workers()
wait_event(gcwq->rebind_hold)
	woken up but no scheduled			rebind_workers() returns
						the same cpu offline
						the same cpu online again
							rebind_workers()
								set WORKER_REBIND
	scheduled,see the WORKER_REBIND
	wait rebind_workers() clear it    <--bug-->		wait idle_worker_rebind()
								rebound.

The two thread wait each other. It is bug.

This patch gives up to rebind idles synchronously. make them async instead.

To avoid to wrongly do local-wake-up, we add a exile-operation for
idle-worker-rebinding. When a idle worker is exiled, it will not queued
on @idle_list until it is rebound.

After we have exile-operation, the @nr_idle is not only the count of @idle_list,
but also exiled idle workers. so I check all the code, and make
them exile-operation aware. (too_many_workers())

exile-operation is also the core idea to rebind newly created worker.
(patch 9)

rebind_workers() become single pass and don't release gcwq->lock.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |  100 +++++++++++++---------------------------------------
 1 files changed, 25 insertions(+), 75 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 050b2a5..3dd7ce2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -125,7 +125,6 @@ enum {
 
 struct global_cwq;
 struct worker_pool;
-struct idle_rebind;
 
 /*
  * The poor guys doing the actual heavy lifting.  All on-duty workers
@@ -149,7 +148,6 @@ struct worker {
 	int			id;		/* I: worker id */
 
 	/* for rebinding worker to CPU */
-	struct idle_rebind	*idle_rebind;	/* L: for idle worker */
 	struct work_struct	rebind_work;	/* L: for busy worker */
 };
 
@@ -159,7 +157,9 @@ struct worker_pool {
 
 	struct list_head	worklist;	/* L: list of pending works */
 	int			nr_workers;	/* L: total number of workers */
-	int			nr_idle;	/* L: currently idle ones */
+	int			nr_idle;	/* L: currently idle ones,
+						      include ones in idle_list
+						      and in doing rebind. */
 
 	struct list_head	idle_list;	/* X: list of idle workers */
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
@@ -185,8 +185,6 @@ struct global_cwq {
 
 	struct worker_pool	pools[NR_WORKER_POOLS];
 						/* normal and highpri pools */
-
-	wait_queue_head_t	rebind_hold;	/* rebind hold wait */
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -686,6 +684,10 @@ static bool too_many_workers(struct worker_pool *pool)
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
+	/* Is any idle home ? */
+	if (unlikely(list_empty(&pool->idle_list)))
+		return false;
+
 	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
 }
 
@@ -1608,28 +1610,20 @@ __acquires(&gcwq->lock)
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
+	if (worker_maybe_bind_and_lock(worker))
+		worker_clr_flags(worker, WORKER_UNBOUND);
 
-	/* we did our part, wait for rebind_workers() to finish up */
-	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
+	worker_clr_flags(worker, WORKER_REBIND);
+	list_add(&worker->entry, &worker->pool->idle_list);
+	spin_unlock_irq(&gcwq->lock);
 }
 
 /*
@@ -1656,29 +1650,22 @@ static void busy_worker_rebind_fn(struct work_struct *work)
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
 	__releases(&gcwq->lock) __acquires(&gcwq->lock)
 {
-	struct idle_rebind idle_rebind;
 	struct worker_pool *pool;
-	struct worker *worker;
+	struct worker *worker, *n;
 	struct hlist_node *pos;
 	int i;
 
@@ -1687,54 +1674,19 @@ static void rebind_workers(struct global_cwq *gcwq)
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
-			if (worker->flags & WORKER_REBIND)
-				continue;
-
-			/* morph UNBOUND to REBIND */
-			worker->flags &= ~WORKER_UNBOUND;
+		list_for_each_entry_safe(worker, n, &pool->idle_list, entry) {
 			worker->flags |= WORKER_REBIND;
 
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
-	/*
-	 * All idle workers are rebound and waiting for %WORKER_REBIND to
-	 * be cleared inside idle_worker_rebind().  Clear and release.
-	 * Clearing %WORKER_REBIND from this foreign context is safe
-	 * because these workers are still guaranteed to be idle.
-	 */
-	for_each_worker_pool(pool, gcwq)
-		list_for_each_entry(worker, &pool->idle_list, entry)
-			worker->flags &= ~WORKER_REBIND;
-
-	wake_up_all(&gcwq->rebind_hold);
-
 	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
@@ -3811,8 +3763,6 @@ static int __init init_workqueues(void)
 			mutex_init(&pool->manager_mutex);
 			ida_init(&pool->worker_ida);
 		}
-
-		init_waitqueue_head(&gcwq->rebind_hold);
 	}
 
 	/* create the initial worker */
-- 
1.7.4.4

