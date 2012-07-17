Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2GQRM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:12:59 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52408 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab2GQRMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:12:51 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
        linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 9/9] workqueue: simplify CPU hotplug code
Date: Tue, 17 Jul 2012 10:12:29 -0700
Message-Id: <1342545149-3515-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With trustee gone, CPU hotplug code can be simplified.

* gcwq_claim/release_management() now grab and release gcwq lock too
  respectively and gained _and_lock and _and_unlock postfixes.

* All CPU hotplug logic was implemented in workqueue_cpu_callback()
  which was called by workqueue_cpu_up/down_callback() for the correct
  priority.  This was because up and down paths shared a lot of logic,
  which is no longer true.  Remove workqueue_cpu_callback() and move
  all hotplug logic into the two actual callbacks.

This patch doesn't make any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   79 ++++++++++++++++-----------------------------------
 1 files changed, 25 insertions(+), 54 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d1545da..471996a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3358,19 +3358,21 @@ EXPORT_SYMBOL_GPL(work_busy);
  */
 
 /* claim manager positions of all pools */
-static void gcwq_claim_management(struct global_cwq *gcwq)
+static void gcwq_claim_management_and_lock(struct global_cwq *gcwq)
 {
 	struct worker_pool *pool;
 
 	for_each_worker_pool(pool, gcwq)
 		mutex_lock_nested(&pool->manager_mutex, pool - gcwq->pools);
+	spin_lock_irq(&gcwq->lock);
 }
 
 /* release manager positions */
-static void gcwq_release_management(struct global_cwq *gcwq)
+static void gcwq_release_management_and_unlock(struct global_cwq *gcwq)
 {
 	struct worker_pool *pool;
 
+	spin_unlock_irq(&gcwq->lock);
 	for_each_worker_pool(pool, gcwq)
 		mutex_unlock(&pool->manager_mutex);
 }
@@ -3385,8 +3387,7 @@ static void gcwq_unbind_fn(struct work_struct *work)
 
 	BUG_ON(gcwq->cpu != smp_processor_id());
 
-	gcwq_claim_management(gcwq);
-	spin_lock_irq(&gcwq->lock);
+	gcwq_claim_management_and_lock(gcwq);
 
 	/*
 	 * We've claimed all manager positions.  Make all workers unbound
@@ -3403,8 +3404,7 @@ static void gcwq_unbind_fn(struct work_struct *work)
 
 	gcwq->flags |= GCWQ_DISASSOCIATED;
 
-	spin_unlock_irq(&gcwq->lock);
-	gcwq_release_management(gcwq);
+	gcwq_release_management_and_unlock(gcwq);
 
 	/*
 	 * Call schedule() so that we cross rq->lock and thus can guarantee
@@ -3428,26 +3428,19 @@ static void gcwq_unbind_fn(struct work_struct *work)
 		atomic_set(get_pool_nr_running(pool), 0);
 }
 
-static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
-						unsigned long action,
-						void *hcpu)
+/*
+ * Workqueues should be brought up before normal priority CPU notifiers.
+ * This will be registered high priority CPU notifier.
+ */
+static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
+					       unsigned long action,
+					       void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct global_cwq *gcwq = get_gcwq(cpu);
 	struct worker_pool *pool;
-	struct work_struct unbind_work;
-	unsigned long flags;
-
-	action &= ~CPU_TASKS_FROZEN;
-
-	switch (action) {
-	case CPU_DOWN_PREPARE:
-		/* unbinding should happen on the local CPU */
-		INIT_WORK_ONSTACK(&unbind_work, gcwq_unbind_fn);
-		schedule_work_on(cpu, &unbind_work);
-		flush_work(&unbind_work);
-		break;
 
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
 		for_each_worker_pool(pool, gcwq) {
 			struct worker *worker;
@@ -3463,45 +3456,16 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 			start_worker(worker);
 			spin_unlock_irq(&gcwq->lock);
 		}
-	}
-
-	/* some are called w/ irq disabled, don't disturb irq status */
-	spin_lock_irqsave(&gcwq->lock, flags);
+		break;
 
-	switch (action) {
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		spin_unlock_irq(&gcwq->lock);
-		gcwq_claim_management(gcwq);
-		spin_lock_irq(&gcwq->lock);
-
+		gcwq_claim_management_and_lock(gcwq);
 		gcwq->flags &= ~GCWQ_DISASSOCIATED;
-
 		rebind_workers(gcwq);
-
-		gcwq_release_management(gcwq);
+		gcwq_release_management_and_unlock(gcwq);
 		break;
 	}
-
-	spin_unlock_irqrestore(&gcwq->lock, flags);
-
-	return notifier_from_errno(0);
-}
-
-/*
- * Workqueues should be brought up before normal priority CPU notifiers.
- * This will be registered high priority CPU notifier.
- */
-static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
-					       unsigned long action,
-					       void *hcpu)
-{
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_UP_PREPARE:
-	case CPU_DOWN_FAILED:
-	case CPU_ONLINE:
-		return workqueue_cpu_callback(nfb, action, hcpu);
-	}
 	return NOTIFY_OK;
 }
 
@@ -3513,9 +3477,16 @@ static int __devinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 						 unsigned long action,
 						 void *hcpu)
 {
+	unsigned int cpu = (unsigned long)hcpu;
+	struct work_struct unbind_work;
+
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
-		return workqueue_cpu_callback(nfb, action, hcpu);
+		/* unbinding should happen on the local CPU */
+		INIT_WORK_ONSTACK(&unbind_work, gcwq_unbind_fn);
+		schedule_work_on(cpu, &unbind_work);
+		flush_work(&unbind_work);
+		break;
 	}
 	return NOTIFY_OK;
 }
-- 
1.7.7.3

