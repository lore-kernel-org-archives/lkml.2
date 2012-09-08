Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2IHRLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:11:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab2IHRLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:11:23 -0400
X-IronPort-AV: E=Sophos;i="4.80,392,1344182400"; 
   d="scan'208";a="5807480"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 7/7 V6] workqueue: remove WORKER_REBIND
Date: Sun, 9 Sep 2012 01:12:56 +0800
Message-Id: <1347124383-18723-8-git-send-email-laijs@cn.fujitsu.com>
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

exile operation       = list_del_init(&worker->entry).
and destory operation -> list_del_init(&worker->entry).

so we can use list_empty(&worker->entry) to know: does the worker
has been exiled or killed.

WORKER_REBIND is not need any more, remove it to reduce the states
of workers.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4863162..aa46308 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -72,11 +72,10 @@ enum {
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
@@ -1613,7 +1612,7 @@ __acquires(&gcwq->lock)
 
 /*
  * Rebind an idle @worker to its CPU. worker_thread() will test
- * %WORKER_REBIND before leaving idle and call this function.
+ * worker->entry before leaving idle and call this function.
  */
 static void idle_worker_rebind(struct worker *worker)
 {
@@ -1622,7 +1621,6 @@ static void idle_worker_rebind(struct worker *worker)
 	if (worker_maybe_bind_and_lock(worker))
 		worker_clr_flags(worker, WORKER_UNBOUND);
 
-	worker_clr_flags(worker, WORKER_REBIND);
 	list_add(&worker->entry, &worker->pool->idle_list);
 	spin_unlock_irq(&gcwq->lock);
 }
@@ -1675,11 +1673,9 @@ static void rebind_workers(struct global_cwq *gcwq)
 	for_each_worker_pool(pool, gcwq)
 		lockdep_assert_held(&pool->assoc_mutex);
 
-	/* set REBIND and kick idle ones */
+	/* exile and kick idle ones */
 	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry_safe(worker, n, &pool->idle_list, entry) {
-			worker->flags |= WORKER_REBIND;
-
 			/* exile idle workers */
 			list_del_init(&worker->entry);
 
@@ -2145,7 +2141,7 @@ __acquires(&gcwq->lock)
 	 * necessary to avoid spurious warnings from rescuers servicing the
 	 * unbound or a disassociated gcwq.
 	 */
-	WARN_ON_ONCE(!(worker->flags & (WORKER_UNBOUND | WORKER_REBIND)) &&
+	WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
 		     !(gcwq->flags & GCWQ_DISASSOCIATED) &&
 		     raw_smp_processor_id() != gcwq->cpu);
 
@@ -2269,18 +2265,17 @@ static int worker_thread(void *__worker)
 woke_up:
 	spin_lock_irq(&gcwq->lock);
 
-	/*
-	 * DIE can be set only while idle and REBIND set while busy has
-	 * @worker->rebind_work scheduled.  Checking here is enough.
-	 */
-	if (unlikely(worker->flags & (WORKER_REBIND | WORKER_DIE))) {
+	/* Is it still home ? */
+	if (unlikely(list_empty(&worker->entry))) {
 		spin_unlock_irq(&gcwq->lock);
 
+		/* reason: DIE */
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

