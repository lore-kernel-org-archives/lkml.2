Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2IQPo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:44:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30750 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932194Ab2IQPoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:44:54 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344182400"; 
   d="scan'208";a="5859719"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V2 for-next PATCH 4/7] workqueue: remove WORKER_REBIND
Date: Mon, 17 Sep 2012 23:46:45 +0800
Message-Id: <1347896808-2398-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:06,
	Serialize complete at 2012/09/17 23:45:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we use list_del_init(&worker->entry) when we notice idles to rebind
or destroy idles.

So we can use list_empty(&worker->entry) to know: does the worker
need to rebind or has the worker been killed.

WORKER_REBIND is not need any more, remove it and reduce the states
of workers.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   35 ++++++++++++++---------------------
 1 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6b643df..4696441 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -73,11 +73,10 @@ enum {
 	WORKER_DIE		= 1 << 1,	/* die die die */
 	WORKER_IDLE		= 1 << 2,	/* is idle */
 	WORKER_PREP		= 1 << 3,	/* preparing to run works */
-	WORKER_REBIND		= 1 << 5,	/* mom is home, come back */
 	WORKER_CPU_INTENSIVE	= 1 << 6,	/* cpu intensive */
 	WORKER_UNBOUND		= 1 << 7,	/* worker is unbound */
 
-	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_REBIND | WORKER_UNBOUND |
+	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_UNBOUND |
 				  WORKER_CPU_INTENSIVE,
 
 	NR_WORKER_POOLS		= 2,		/* # worker pools per gcwq */
@@ -1615,16 +1614,14 @@ __acquires(&gcwq->lock)
 
 /*
  * Rebind an idle @worker to its CPU. worker_thread() will test
- * %WORKER_REBIND before leaving idle and call this function.
+ * worker->entry before leaving idle and call this function.
  */
 static void idle_worker_rebind(struct worker *worker)
 {
 	struct global_cwq *gcwq = worker->pool->gcwq;
 
-	if (!worker_maybe_bind_and_lock(worker))
-		worker->flags |= WORKER_UNBOUND;
-
-	worker_clr_flags(worker, WORKER_REBIND);
+	if (worker_maybe_bind_and_lock(worker))
+		worker_clr_flags(worker, WORKER_UNBOUND);
 
 	/* it is idle worker, add itself back */
 	list_add(&worker->entry, &worker->pool->idle_list);
@@ -1686,16 +1683,9 @@ static void rebind_workers(struct global_cwq *gcwq)
 	for_each_worker_pool(pool, gcwq)
 		lockdep_assert_held(&pool->manager_mutex);
 
-	/* set REBIND and kick idle ones */
+	/* dequeue and kick idle ones */
 	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry_safe(worker, n, &pool->idle_list, entry) {
-			unsigned long worker_flags = worker->flags;
-
-			/* morph UNBOUND to REBIND atomically */
-			worker_flags &= ~WORKER_UNBOUND;
-			worker_flags |= WORKER_REBIND;
-			ACCESS_ONCE(worker->flags) = worker_flags;
-
 			/*
 			 * All rebinding(of idle and busy workers) will
 			 * happen async, and the rebound workers may
@@ -1711,7 +1701,10 @@ static void rebind_workers(struct global_cwq *gcwq)
 			 */
 			list_del_init(&worker->entry);
 
-			/* worker_thread() will call idle_worker_rebind() */
+			/*
+			 * worker_thread() will see the above dequeuing
+			 * and call idle_worker_rebind().
+			 */
 			wake_up_process(worker->task);
 		}
 	}
@@ -2181,7 +2174,7 @@ __acquires(&gcwq->lock)
 	 * necessary to avoid spurious warnings from rescuers servicing the
 	 * unbound or a disassociated gcwq.
 	 */
-	WARN_ON_ONCE(!(worker->flags & (WORKER_UNBOUND | WORKER_REBIND)) &&
+	WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
 		     !(gcwq->flags & GCWQ_DISASSOCIATED) &&
 		     raw_smp_processor_id() != gcwq->cpu);
 
@@ -2305,17 +2298,17 @@ static int worker_thread(void *__worker)
 woke_up:
 	spin_lock_irq(&gcwq->lock);
 
-	/*
-	 * DIE or REBIND can be set only while idle.  Checking here is enough.
-	 */
-	if (unlikely(worker->flags & (WORKER_REBIND | WORKER_DIE))) {
+	/* Is it still in idle_list ? */
+	if (unlikely(list_empty(&worker->entry))) {
 		spin_unlock_irq(&gcwq->lock);
 
+		/* reason: killed */
 		if (worker->flags & WORKER_DIE) {
 			worker->task->flags &= ~PF_WQ_WORKER;
 			return 0;
 		}
 
+		/* reason: idle rebind */
 		idle_worker_rebind(worker);
 		goto woke_up;
 	}
-- 
1.7.4.4

