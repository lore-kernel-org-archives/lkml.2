Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab2IEKgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:36:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758190Ab2IEKgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:36:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789516"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 10/11 V5] workqueue: unbind/rebind without manager_mutex
Date: Wed, 5 Sep 2012 18:37:47 +0800
Message-Id: <1346841475-4422-11-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:51,
	Serialize complete at 2012/09/05 18:35:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcwq_unbind_fn() unbind manager by ->manager pointer.

rebinding-manger, unbinding/rebinding newly created worker are done by
other place. so we don't need manager_mutex any more.

Also change the comment of @bind accordingly.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   52 ++++++++++++++++------------------------------------
 1 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 819c84e..5fb712a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1667,17 +1667,15 @@ static void busy_worker_rebind_fn(struct work_struct *work)
  * add themselves back to idle_list if the gcwq is still associated.
  */
 static void rebind_workers(struct global_cwq *gcwq)
-	__releases(&gcwq->lock) __acquires(&gcwq->lock)
 {
 	struct worker_pool *pool;
 	struct worker *worker, *n;
 	struct hlist_node *pos;
 	int i;
 
-	lockdep_assert_held(&gcwq->lock);
+	spin_lock_irq(&gcwq->lock);
 
-	for_each_worker_pool(pool, gcwq)
-		lockdep_assert_held(&pool->manager_mutex);
+	gcwq->flags &= ~GCWQ_DISASSOCIATED;
 
 	/* exile and kick idle ones */
 	for_each_worker_pool(pool, gcwq) {
@@ -1714,6 +1712,8 @@ static void rebind_workers(struct global_cwq *gcwq)
 			worker->scheduled.next,
 			work_color_to_flags(WORK_NO_COLOR));
 	}
+
+	spin_unlock_irq(&gcwq->lock);
 }
 
 static struct worker *alloc_worker(void)
@@ -1981,11 +1981,14 @@ __acquires(&gcwq->lock)
 	bool bind;
 
 	/*
-	 * Note we have held the manage_mutex, so DISASSOCIATED can't be
-	 * flipped and it is correct that we calculate @bind only once
-	 * and then release the gcwq->lock.
+	 * Snapshot the value of @bind.
+	 * Because the %UNBOUND bit of manager can't be cleared while it
+	 * is creating worker. So we can detect whether the real @bind
+	 * is/was changed and fix the newly created worker's binding in
+	 * manager_start_worker().
 	 */
 	bind = !(gcwq->flags & GCWQ_DISASSOCIATED);
+	BUG_ON(!bind && !(pool->manager->flags & WORKER_UNBOUND));
 
 	if (!need_to_create_worker(pool))
 		return false;
@@ -3441,26 +3444,6 @@ EXPORT_SYMBOL_GPL(work_busy);
  * cpu comes back online.
  */
 
-/* claim manager positions of all pools */
-static void gcwq_claim_management_and_lock(struct global_cwq *gcwq)
-{
-	struct worker_pool *pool;
-
-	for_each_worker_pool(pool, gcwq)
-		mutex_lock_nested(&pool->manager_mutex, pool - gcwq->pools);
-	spin_lock_irq(&gcwq->lock);
-}
-
-/* release manager positions */
-static void gcwq_release_management_and_unlock(struct global_cwq *gcwq)
-{
-	struct worker_pool *pool;
-
-	spin_unlock_irq(&gcwq->lock);
-	for_each_worker_pool(pool, gcwq)
-		mutex_unlock(&pool->manager_mutex);
-}
-
 static void gcwq_unbind_fn(struct work_struct *work)
 {
 	struct global_cwq *gcwq = get_gcwq(smp_processor_id());
@@ -3471,13 +3454,13 @@ static void gcwq_unbind_fn(struct work_struct *work)
 
 	BUG_ON(gcwq->cpu != smp_processor_id());
 
-	gcwq_claim_management_and_lock(gcwq);
+	spin_lock_irq(&gcwq->lock);
 
 	/*
-	 * We've claimed all manager positions.  Make all workers unbound
-	 * and set DISASSOCIATED.  Before this, all workers except for the
-	 * ones which are still executing works from before the last CPU
-	 * down must be on the cpu.  After this, they may become diasporas.
+	 * Make all workers unbound and set DISASSOCIATED.
+	 * Before this, all workers except for the ones which are still
+	 * executing works from before the last CPU down must be on the cpu.
+	 * After this, they may become diasporas.
 	 */
 	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry(worker, &pool->idle_list, entry)
@@ -3491,7 +3474,7 @@ static void gcwq_unbind_fn(struct work_struct *work)
 
 	gcwq->flags |= GCWQ_DISASSOCIATED;
 
-	gcwq_release_management_and_unlock(gcwq);
+	spin_unlock_irq(&gcwq->lock);
 
 	/*
 	 * Call schedule() so that we cross rq->lock and thus can guarantee
@@ -3547,10 +3530,7 @@ static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		gcwq_claim_management_and_lock(gcwq);
-		gcwq->flags &= ~GCWQ_DISASSOCIATED;
 		rebind_workers(gcwq);
-		gcwq_release_management_and_unlock(gcwq);
 		break;
 	}
 	return NOTIFY_OK;
-- 
1.7.4.4

