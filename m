Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2IQPqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:46:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50367 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab2IQPo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:44:56 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344182400"; 
   d="scan'208";a="5859720"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V2 for-next PATCH 5/7] workqueue: rename manager_mutex to assoc_mutex
Date: Mon, 17 Sep 2012 23:46:46 +0800
Message-Id: <1347896808-2398-6-git-send-email-laijs@cn.fujitsu.com>
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

We can't known what is being protected from the name of
manager_mutex or be misled by the name.

Actually, it protects the CPU-association of the gcwq,
rename it to assoc_mutex will be better.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4696441..1014b17 100644
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
@@ -165,7 +165,7 @@ struct worker_pool {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
-	struct mutex		manager_mutex;	/* mutex manager should hold */
+	struct mutex		assoc_mutex;	/* protect GCWQ_DISASSOCIATED */
 	struct ida		worker_ida;	/* L: for worker IDs */
 };
 
@@ -1681,7 +1681,7 @@ static void rebind_workers(struct global_cwq *gcwq)
 	lockdep_assert_held(&gcwq->lock);
 
 	for_each_worker_pool(pool, gcwq)
-		lockdep_assert_held(&pool->manager_mutex);
+		lockdep_assert_held(&pool->assoc_mutex);
 
 	/* dequeue and kick idle ones */
 	for_each_worker_pool(pool, gcwq) {
@@ -2085,26 +2085,26 @@ static bool manage_workers(struct worker *worker)
 
 	/*
 	 * To simplify both worker management and CPU hotplug, hold off
-	 * management while hotplug is in progress.  CPU hotplug path can't
+	 * assoc_mutex while management is in progress. CPU hotplug path can't
 	 * grab %POOL_MANAGING_WORKERS to achieve this because that can
 	 * lead to idle worker depletion (all become busy thinking someone
 	 * else is managing) which in turn can result in deadlock under
-	 * extreme circumstances.  Use @pool->manager_mutex to synchronize
+	 * extreme circumstances.  Use @pool->assoc_mutex to synchronize
 	 * manager against CPU hotplug.
 	 *
-	 * manager_mutex would always be free unless CPU hotplug is in
+	 * assoc_mutex would always be free unless CPU hotplug is in
 	 * progress.  trylock first without dropping @gcwq->lock.
 	 */
-	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
+	if (unlikely(!mutex_trylock(&pool->assoc_mutex))) {
 		spin_unlock_irq(&pool->gcwq->lock);
-		mutex_lock(&pool->manager_mutex);
+		mutex_lock(&pool->assoc_mutex);
 		/*
 		 * CPU hotplug could have happened while we were waiting
-		 * for manager_mutex.  Hotplug itself can't handle us
+		 * for assoc_mutex.  Hotplug itself can't handle us
 		 * because manager isn't either on idle or busy list, and
 		 * @gcwq's state and ours could have deviated.
 		 *
-		 * As hotplug is now excluded via manager_mutex, we can
+		 * As hotplug is now excluded via assoc_mutex, we can
 		 * simply try to bind.  It will succeed or fail depending
 		 * on @gcwq's current state.  Try it and adjust
 		 * %WORKER_UNBOUND accordingly.
@@ -2127,7 +2127,7 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_create_worker(pool);
 
 	pool->flags &= ~POOL_MANAGING_WORKERS;
-	mutex_unlock(&pool->manager_mutex);
+	mutex_unlock(&pool->assoc_mutex);
 	return ret;
 }
 
@@ -3482,23 +3482,23 @@ EXPORT_SYMBOL_GPL(work_busy);
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
@@ -3511,7 +3511,7 @@ static void gcwq_unbind_fn(struct work_struct *work)
 
 	BUG_ON(gcwq->cpu != smp_processor_id());
 
-	gcwq_claim_management_and_lock(gcwq);
+	gcwq_claim_assoc_and_lock(gcwq);
 
 	/*
 	 * We've claimed all manager positions.  Make all workers unbound
@@ -3528,7 +3528,7 @@ static void gcwq_unbind_fn(struct work_struct *work)
 
 	gcwq->flags |= GCWQ_DISASSOCIATED;
 
-	gcwq_release_management_and_unlock(gcwq);
+	gcwq_release_assoc_and_unlock(gcwq);
 
 	/*
 	 * Call schedule() so that we cross rq->lock and thus can guarantee
@@ -3584,10 +3584,10 @@ static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
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
@@ -3841,7 +3841,7 @@ static int __init init_workqueues(void)
 			setup_timer(&pool->mayday_timer, gcwq_mayday_timeout,
 				    (unsigned long)pool);
 
-			mutex_init(&pool->manager_mutex);
+			mutex_init(&pool->assoc_mutex);
 			ida_init(&pool->worker_ida);
 		}
 	}
-- 
1.7.4.4

