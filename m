Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab2H1Ld1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:33:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49681 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab2H1Ld0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:33:26 -0400
X-IronPort-AV: E=Sophos;i="4.77,842,1336320000"; 
   d="scan'208";a="5740310"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/3 V2] workqueue: reimplement rebind_workers()
Date: Tue, 28 Aug 2012 19:34:37 +0800
Message-Id: <1346153686-3380-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 19:33:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 19:33:14,
	Serialize complete at 2012/08/28 19:33:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current idle_worker_rebind() has a bug.

Worker thread:					The second CPU_ONLINE thread
idle_worker_rebind()
  wait_event(gcwq->rebind_hold)
    test for WORKER_REBIND and fails
    sleeping...

    #the first CPU_ONLINE is wokenup,
    #finish its later work and gone.

    this thread is also wokenup, but it is
    not scheduled, it is still sleeping
    sleeping...

    #the cpu is offline again
    #the cpu is online again,
    #the online code do notify(CPU_ONLINE)	call rebind_workers()
    #I name this is the seconed CPU_ONLINE	  set WORKER_REBIND to idle workers
    #thread, see the right.			  .
						  .
    this thread is finally scheduled,		  .
    sees the WORKER_REBIND is not cleared,	  .
    go to sleep again waiting for (another)	  .
    rebind_workers() to wake up me.	<--bug->  waiting for the idles' ACK.

The two thread wait each other. It is bug.

So this implement adds an "all_done", thus rebind_workers() can't leave until
idle_worker_rebind() successful wait something until all other idle also done,
so this "wait something" will not cause deadlock as the old code.

The code of "idle_worker_rebind() wait something until all other idle also done"
is also changed. It is changed to wait on "worker_rebind.idle_done". With
the help of "all_done" this "worker_rebind" is valid when they wait on
"worker_rebind.idle_done".

The busy_worker_rebind_fn() also explicitly wait on all idle done. It adds
a small overhead on cold path, but it makes the rebind_workers() as single pass.
Clean Code/Readability wins.

"all_cnt" 's decreasing is done without any lock, because this decreasing
only happens on the bound CPU, no lock needed. (the bound CPU can't go
until we notify on "all_done")

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |  108 ++++++++++++++++++++++++++-------------------------
 1 files changed, 55 insertions(+), 53 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 692d976..5f63883 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -125,7 +125,7 @@ enum {
 
 struct global_cwq;
 struct worker_pool;
-struct idle_rebind;
+struct worker_rebind;
 
 /*
  * The poor guys doing the actual heavy lifting.  All on-duty workers
@@ -149,7 +149,7 @@ struct worker {
 	int			id;		/* I: worker id */
 
 	/* for rebinding worker to CPU */
-	struct idle_rebind	*idle_rebind;	/* L: for idle worker */
+	struct worker_rebind	*worker_rebind;	/* L: for all worker */
 	struct work_struct	rebind_work;	/* L: for busy worker */
 };
 
@@ -1304,9 +1304,17 @@ __acquires(&gcwq->lock)
 	}
 }
 
-struct idle_rebind {
-	int			cnt;		/* # workers to be rebound */
-	struct completion	done;		/* all workers rebound */
+struct worker_rebind {
+	int		  idle_cnt;	/* # idle workers to be rebound */
+	struct completion idle_done;	/* all idle workers rebound */
+
+	/*
+	 * notify the rebind_workers() that:
+	 * 1. All workers are rebound.
+	 * 2. No worker has ref to this struct
+	 */
+	int		  all_cnt;	/* # all workers to be rebound */
+	struct completion all_done;	/* all workers rebound */
 };
 
 /*
@@ -1316,33 +1324,42 @@ struct idle_rebind {
  */
 static void idle_worker_rebind(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->pool->gcwq;
-
 	/* CPU must be online at this point */
 	WARN_ON(!worker_maybe_bind_and_lock(worker));
-	if (!--worker->idle_rebind->cnt)
-		complete(&worker->idle_rebind->done);
+	worker_clr_flags(worker, WORKER_REBIND);
+	if (!--worker->worker_rebind->idle_cnt)
+		complete_all(&worker->worker_rebind->idle_done);
 	spin_unlock_irq(&worker->pool->gcwq->lock);
 
-	/* we did our part, wait for rebind_workers() to finish up */
-	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
+	/* It did its part, wait for all other idle to finish up */
+	wait_for_completion(&worker->worker_rebind->idle_done);
+
+	/* all_cnt is only accessed by the bound CPU, don't need any lock */
+	if (!--worker->worker_rebind->all_cnt)
+		complete(&worker->worker_rebind->all_done);
 }
 
 /*
  * Function for @worker->rebind.work used to rebind unbound busy workers to
  * the associated cpu which is coming back online.  This is scheduled by
- * cpu up but can race with other cpu hotplug operations and may be
- * executed twice without intervening cpu down.
+ * cpu up.
  */
 static void busy_worker_rebind_fn(struct work_struct *work)
 {
 	struct worker *worker = container_of(work, struct worker, rebind_work);
 	struct global_cwq *gcwq = worker->pool->gcwq;
 
-	if (worker_maybe_bind_and_lock(worker))
-		worker_clr_flags(worker, WORKER_REBIND);
+	/* Wait for all idle to finish up */
+	wait_for_completion(&worker->worker_rebind->idle_done);
 
+	/* CPU must be online at this point */
+	WARN_ON(!worker_maybe_bind_and_lock(worker));
+	worker_clr_flags(worker, WORKER_REBIND);
 	spin_unlock_irq(&gcwq->lock);
+
+	/* all_cnt is only accessed by the bound CPU, don't need any lock */
+	if (!--worker->worker_rebind->all_cnt)
+		complete(&worker->worker_rebind->all_done);
 }
 
 /**
@@ -1366,13 +1383,13 @@ static void busy_worker_rebind_fn(struct work_struct *work)
  * the head of their scheduled lists is enough.  Note that nr_running will
  * be properbly bumped as busy workers rebind.
  *
- * On return, all workers are guaranteed to either be bound or have rebind
- * work item scheduled.
+ * On return, all workers are guaranteed to be bound.
  */
 static void rebind_workers(struct global_cwq *gcwq)
 	__releases(&gcwq->lock) __acquires(&gcwq->lock)
 {
-	struct idle_rebind idle_rebind;
+	int idle_cnt = 0, all_cnt = 0;
+	struct worker_rebind worker_rebind;
 	struct worker_pool *pool;
 	struct worker *worker;
 	struct hlist_node *pos;
@@ -1383,54 +1400,22 @@ static void rebind_workers(struct global_cwq *gcwq)
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
 	/* set REBIND and kick idle ones, we'll wait for these later */
 	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry(worker, &pool->idle_list, entry) {
-			if (worker->flags & WORKER_REBIND)
-				continue;
-
 			/* morph UNBOUND to REBIND */
 			worker->flags &= ~WORKER_UNBOUND;
 			worker->flags |= WORKER_REBIND;
 
-			idle_rebind.cnt++;
-			worker->idle_rebind = &idle_rebind;
+			idle_cnt++;
+			all_cnt++;
+			worker->worker_rebind = &worker_rebind;
 
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
@@ -1443,12 +1428,29 @@ retry:
 				     work_data_bits(rebind_work)))
 			continue;
 
+		all_cnt++;
+		worker->worker_rebind = &worker_rebind;
+
 		/* wq doesn't matter, use the default one */
 		debug_work_activate(rebind_work);
 		insert_work(get_cwq(gcwq->cpu, system_wq), rebind_work,
 			    worker->scheduled.next,
 			    work_color_to_flags(WORK_NO_COLOR));
 	}
+
+	if (all_cnt) {
+		worker_rebind.idle_cnt = idle_cnt;
+		init_completion(&worker_rebind.idle_done);
+		worker_rebind.all_cnt = all_cnt;
+		init_completion(&worker_rebind.all_done);
+
+		if (!idle_cnt)
+			complete_all(&worker_rebind.idle_done);
+
+		spin_unlock_irq(&gcwq->lock);
+		wait_for_completion(&worker_rebind.all_done);
+		spin_lock_irq(&gcwq->lock);
+	}
 }
 
 static struct worker *alloc_worker(void)
-- 
1.7.4.4

