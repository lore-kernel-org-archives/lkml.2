Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2IHRLo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:11:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42421 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab2IHRLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:11:22 -0400
X-IronPort-AV: E=Sophos;i="4.80,392,1344182400"; 
   d="scan'208";a="5807478"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 5/7 V6] workqueue: rename manager_mutex to assoc_mutex
Date: Sun, 9 Sep 2012 01:12:54 +0800
Message-Id: <1347124383-18723-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:48,
	Serialize complete at 2012/09/09 01:10:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

assoc_mutex is clear, it protects GCWQ_DISASSOCIATED.

And the C.S. of assoc_mutex is narrowed, it protects
create_worker()+start_worker() which require
GCWQ_DISASSOCIATED stable. don't need to protects
the whole manage_workers().

A result of narrowed C.S. maybe_rebind_manager()
has to be moved to the bottom of manage_workers().

Other result of narrowed C.S. manager_workers() becomes
simpler.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   63 ++++++++++++++++++++++++----------------------------
 1 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 207b6a1..d9765c4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -58,7 +58,7 @@ enum {
 	 * be executing on any CPU.  The gcwq behaves as an unbound one.
 	 *
 	 * Note that DISASSOCIATED can be flipped only while holding
-	 * managership of all pools on the gcwq to avoid changing binding
+	 * assoc_mutex of all pools on the gcwq to avoid changing binding
 	 * state while create_worker() is in progress.
 	 */
 	GCWQ_DISASSOCIATED	= 1 << 0,	/* cpu can't serve workers */
@@ -166,7 +166,7 @@ struct worker_pool {
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
 	struct worker		*manager;	/* L: manager worker */
-	struct mutex		manager_mutex;	/* mutex manager should hold */
+	struct mutex		assoc_mutex;	/* protect GCWQ_DISASSOCIATED */
 	struct ida		worker_ida;	/* L: for worker IDs */
 };
 
@@ -1673,7 +1673,7 @@ static void rebind_workers(struct global_cwq *gcwq)
 	lockdep_assert_held(&gcwq->lock);
 
 	for_each_worker_pool(pool, gcwq)
-		lockdep_assert_held(&pool->manager_mutex);
+		lockdep_assert_held(&pool->assoc_mutex);
 
 	/* set REBIND and kick idle ones */
 	for_each_worker_pool(pool, gcwq) {
@@ -1975,15 +1975,18 @@ restart:
 	while (true) {
 		struct worker *worker;
 
+		mutex_lock(&pool->assoc_mutex);
 		worker = create_worker(pool);
 		if (worker) {
 			del_timer_sync(&pool->mayday_timer);
 			spin_lock_irq(&gcwq->lock);
 			start_worker(worker);
 			BUG_ON(need_to_create_worker(pool));
+			mutex_unlock(&pool->assoc_mutex);
 			return true;
 		}
 
+		mutex_unlock(&pool->assoc_mutex);
 		if (!need_to_create_worker(pool))
 			break;
 
@@ -2040,7 +2043,7 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
 }
 
 /* does the manager need to be rebind after we just release gcwq->lock */
-static void maybe_rebind_manager(struct worker *manager)
+static bool maybe_rebind_manager(struct worker *manager)
 {
 	struct global_cwq *gcwq = manager->pool->gcwq;
 	bool assoc = !(gcwq->flags & GCWQ_DISASSOCIATED);
@@ -2050,7 +2053,11 @@ static void maybe_rebind_manager(struct worker *manager)
 
 		if (worker_maybe_bind_and_lock(manager))
 			worker_clr_flags(manager, WORKER_UNBOUND);
+
+		return true;
 	}
+
+	return false;
 }
 
 /**
@@ -2061,9 +2068,7 @@ static void maybe_rebind_manager(struct worker *manager)
  * to.  At any given time, there can be only zero or one manager per
  * gcwq.  The exclusion is handled automatically by this function.
  *
- * The caller can safely start processing works on false return.  On
- * true return, it's guaranteed that need_to_create_worker() is false
- * and may_start_working() is true.
+ * The caller can safely start processing works on false return.
  *
  * CONTEXT:
  * spin_lock_irq(gcwq->lock) which may be released and regrabbed
@@ -2076,29 +2081,12 @@ static void maybe_rebind_manager(struct worker *manager)
 static bool manage_workers(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
-	struct global_cwq *gcwq = pool->gcwq;
 	bool ret = false;
 
 	if (pool->manager)
 		return ret;
 
 	pool->manager = worker;
-	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
-		/*
-		 * Ouch! rebind_workers() or gcwq_unbind_fn() beats we.
-		 * it can't return false here, otherwise it will lead to
-		 * worker depletion. So we release gcwq->lock and then
-		 * grab manager_mutex again.
-		 */
-		spin_unlock_irq(&gcwq->lock);
-		mutex_lock(&pool->manager_mutex);
-		spin_lock_irq(&gcwq->lock);
-
-		/* rebind_workers() can happen when we release gcwq->lock */
-		maybe_rebind_manager(worker);
-		ret = true;
-	}
-
 	pool->flags &= ~POOL_MANAGE_WORKERS;
 
 	/*
@@ -2108,7 +2096,14 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
-	mutex_unlock(&pool->manager_mutex);
+	/*
+	 * rebind_workers() can happen while it does manage, so it has to
+	 * check and do rebind by itself.
+	 * Before rebind, it's guaranteed that need_to_create_worker() is
+	 * false and may_start_working() is true here.
+	 */
+	ret |= maybe_rebind_manager(worker);
+
 	pool->manager = NULL;
 
 	return ret;
@@ -3436,23 +3431,23 @@ EXPORT_SYMBOL_GPL(work_busy);
  */
 
 /* claim manager positions of all pools */
-static void gcwq_claim_management_and_lock(struct global_cwq *gcwq)
+static void gcwq_claim_assoc_and_lock(struct global_cwq *gcwq)
 {
 	struct worker_pool *pool;
 
 	for_each_worker_pool(pool, gcwq)
-		mutex_lock_nested(&pool->manager_mutex, pool - gcwq->pools);
+		mutex_lock_nested(&pool->assoc_mutex, pool - gcwq->pools);
 	spin_lock_irq(&gcwq->lock);
 }
 
 /* release manager positions */
-static void gcwq_release_management_and_unlock(struct global_cwq *gcwq)
+static void gcwq_release_assoc_and_unlock(struct global_cwq *gcwq)
 {
 	struct worker_pool *pool;
 
 	spin_unlock_irq(&gcwq->lock);
 	for_each_worker_pool(pool, gcwq)
-		mutex_unlock(&pool->manager_mutex);
+		mutex_unlock(&pool->assoc_mutex);
 }
 
 static void gcwq_unbind_fn(struct work_struct *work)
@@ -3465,7 +3460,7 @@ static void gcwq_unbind_fn(struct work_struct *work)
 
 	BUG_ON(gcwq->cpu != smp_processor_id());
 
-	gcwq_claim_management_and_lock(gcwq);
+	gcwq_claim_assoc_and_lock(gcwq);
 
 	/*
 	 * We've claimed all manager positions.  Make all workers unbound
@@ -3485,7 +3480,7 @@ static void gcwq_unbind_fn(struct work_struct *work)
 
 	gcwq->flags |= GCWQ_DISASSOCIATED;
 
-	gcwq_release_management_and_unlock(gcwq);
+	gcwq_release_assoc_and_unlock(gcwq);
 
 	/*
 	 * Call schedule() so that we cross rq->lock and thus can guarantee
@@ -3541,10 +3536,10 @@ static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		gcwq_claim_management_and_lock(gcwq);
+		gcwq_claim_assoc_and_lock(gcwq);
 		gcwq->flags &= ~GCWQ_DISASSOCIATED;
 		rebind_workers(gcwq);
-		gcwq_release_management_and_unlock(gcwq);
+		gcwq_release_assoc_and_unlock(gcwq);
 		break;
 	}
 	return NOTIFY_OK;
@@ -3799,7 +3794,7 @@ static int __init init_workqueues(void)
 				    (unsigned long)pool);
 
 			pool->manager = NULL;
-			mutex_init(&pool->manager_mutex);
+			mutex_init(&pool->assoc_mutex);
 			ida_init(&pool->worker_ida);
 		}
 	}
-- 
1.7.4.4

