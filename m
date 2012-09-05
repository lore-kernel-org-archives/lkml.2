Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab2IEKgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:36:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758254Ab2IEKgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:36:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789511"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 05/11 V5] workqueue: Add @bind arguement back without change any thing
Date: Wed, 5 Sep 2012 18:37:42 +0800
Message-Id: <1346841475-4422-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:50,
	Serialize complete at 2012/09/05 18:35:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure the gcwq->flags is only accessed with gcwq->lock held.
And make the code more easier to understand.

In all current callsite of create_worker(), DISASSOCIATED can't
be flipped while create_worker().
So the whole behavior is unchanged with this patch.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   33 ++++++++++++++++++---------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6bf4185..1946be4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -56,10 +56,6 @@ enum {
 	 * While DISASSOCIATED, the cpu may be offline and all workers have
 	 * %WORKER_UNBOUND set and concurrency management disabled, and may
 	 * be executing on any CPU.  The gcwq behaves as an unbound one.
-	 *
-	 * Note that DISASSOCIATED can be flipped only while holding
-	 * managership of all pools on the gcwq to avoid changing binding
-	 * state while create_worker() is in progress.
 	 */
 	GCWQ_DISASSOCIATED	= 1 << 0,	/* cpu can't serve workers */
 	GCWQ_FREEZING		= 1 << 1,	/* freeze in progress */
@@ -1727,6 +1723,7 @@ static struct worker *alloc_worker(void)
 /**
  * create_worker - create a new workqueue worker
  * @pool: pool the new worker will belong to
+ * @bind: whether to set affinity to @cpu or not
  *
  * Create a new worker which is bound to @pool.  The returned worker
  * can be started by calling start_worker() or destroyed using
@@ -1738,7 +1735,7 @@ static struct worker *alloc_worker(void)
  * RETURNS:
  * Pointer to the newly created worker.
  */
-static struct worker *create_worker(struct worker_pool *pool)
+static struct worker *create_worker(struct worker_pool *pool, bool bind)
 {
 	struct global_cwq *gcwq = pool->gcwq;
 	const char *pri = worker_pool_pri(pool) ? "H" : "";
@@ -1775,15 +1772,10 @@ static struct worker *create_worker(struct worker_pool *pool)
 		set_user_nice(worker->task, HIGHPRI_NICE_LEVEL);
 
 	/*
-	 * Determine CPU binding of the new worker depending on
-	 * %GCWQ_DISASSOCIATED.  The caller is responsible for ensuring the
-	 * flag remains stable across this function.  See the comments
-	 * above the flag definition for details.
-	 *
 	 * As an unbound worker may later become a regular one if CPU comes
 	 * online, make sure every worker has %PF_THREAD_BOUND set.
 	 */
-	if (!(gcwq->flags & GCWQ_DISASSOCIATED)) {
+	if (bind) {
 		kthread_bind(worker->task, gcwq->cpu);
 	} else {
 		worker->task->flags |= PF_THREAD_BOUND;
@@ -1951,6 +1943,14 @@ __releases(&gcwq->lock)
 __acquires(&gcwq->lock)
 {
 	struct global_cwq *gcwq = pool->gcwq;
+	bool bind;
+
+	/*
+	 * Note we have held the manage_mutex, so DISASSOCIATED can't be
+	 * flipped and it is correct that we calculate @bind only once
+	 * and then release the gcwq->lock.
+	 */
+	bind = !(gcwq->flags & GCWQ_DISASSOCIATED);
 
 	if (!need_to_create_worker(pool))
 		return false;
@@ -1963,7 +1963,7 @@ restart:
 	while (true) {
 		struct worker *worker;
 
-		worker = create_worker(pool);
+		worker = create_worker(pool, bind);
 		if (worker) {
 			del_timer_sync(&pool->mayday_timer);
 			spin_lock_irq(&gcwq->lock);
@@ -3479,7 +3479,7 @@ static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 			if (pool->nr_workers)
 				continue;
 
-			worker = create_worker(pool);
+			worker = create_worker(pool, false);
 			if (!worker)
 				return NOTIFY_BAD;
 
@@ -3757,14 +3757,17 @@ static int __init init_workqueues(void)
 	for_each_online_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct worker_pool *pool;
+		bool bind = false;
 
-		if (cpu != WORK_CPU_UNBOUND)
+		if (cpu != WORK_CPU_UNBOUND) {
 			gcwq->flags &= ~GCWQ_DISASSOCIATED;
+			bind = true;
+		}
 
 		for_each_worker_pool(pool, gcwq) {
 			struct worker *worker;
 
-			worker = create_worker(pool);
+			worker = create_worker(pool, bind);
 			BUG_ON(!worker);
 			spin_lock_irq(&gcwq->lock);
 			start_worker(worker);
-- 
1.7.4.4

