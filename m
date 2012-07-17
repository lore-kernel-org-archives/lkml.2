Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2GQRMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:12:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55586 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2GQRMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:12:47 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
        linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] workqueue: don't butcher idle workers on an offline CPU
Date: Tue, 17 Jul 2012 10:12:27 -0700
Message-Id: <1342545149-3515-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, during CPU offlining, after all pending work items are
drained, the trustee butchers all workers.  Also, on CPU onlining
failure, workqueue_cpu_callback() ensures that the first idle worker
is destroyed.  Combined, these guarantee that an offline CPU doesn't
have any worker for it once all the lingering work items are finished.

This guarantee isn't really necessary and makes CPU on/offlining more
expensive than needs to be, especially for platforms which use CPU
hotplug for powersaving.

This patch lets offline CPUs removes idle worker butchering from the
trustee and let a CPU which failed onlining keep the created first
worker.  The first worker is created if the CPU doesn't have any
during CPU_DOWN_PREPARE and started right away.  If onlining succeeds,
the rebind_workers() call in CPU_ONLINE will rebind it like any other
workers.  If onlining fails, the worker is left alone till the next
try.

This makes CPU hotplugs cheaper by allowing global_cwqs to keep
workers across them and simplifies code.

Note that trustee doesn't re-arm idle timer when it's done and thus
the disassociated global_cwq will keep all workers until it comes back
online.  This will be improved by further patches.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   94 ++++++++--------------------------------------------
 1 files changed, 14 insertions(+), 80 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6927fec..acfabb2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -175,7 +175,6 @@ struct worker_pool {
 
 	struct mutex		manager_mutex;	/* mutex manager should hold */
 	struct ida		worker_ida;	/* L: for worker IDs */
-	struct worker		*first_idle;	/* L: first idle worker */
 };
 
 /*
@@ -3477,16 +3476,6 @@ static void gcwq_release_management(struct global_cwq *gcwq)
 	__ret1 < 0 ? -1 : 0;						\
 })
 
-static bool gcwq_has_idle_workers(struct global_cwq *gcwq)
-{
-	struct worker_pool *pool;
-
-	for_each_worker_pool(pool, gcwq)
-		if (!list_empty(&pool->idle_list))
-			return true;
-	return false;
-}
-
 static int __cpuinit trustee_thread(void *__gcwq)
 {
 	struct global_cwq *gcwq = __gcwq;
@@ -3494,7 +3483,6 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	struct worker *worker;
 	struct work_struct *work;
 	struct hlist_node *pos;
-	long rc;
 	int i;
 
 	BUG_ON(gcwq->cpu != smp_processor_id());
@@ -3597,25 +3585,6 @@ static int __cpuinit trustee_thread(void *__gcwq)
 			break;
 	}
 
-	/*
-	 * Either all works have been scheduled and cpu is down, or
-	 * cpu down has already been canceled.  Wait for and butcher
-	 * all workers till we're canceled.
-	 */
-	do {
-		rc = trustee_wait_event(gcwq_has_idle_workers(gcwq));
-
-		i = 0;
-		for_each_worker_pool(pool, gcwq) {
-			while (!list_empty(&pool->idle_list)) {
-				worker = list_first_entry(&pool->idle_list,
-							  struct worker, entry);
-				destroy_worker(worker);
-			}
-			i |= pool->nr_workers;
-		}
-	} while (i && rc >= 0);
-
 	gcwq_release_management(gcwq);
 
 	/* notify completion */
@@ -3658,10 +3627,8 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 	unsigned int cpu = (unsigned long)hcpu;
 	struct global_cwq *gcwq = get_gcwq(cpu);
 	struct task_struct *new_trustee = NULL;
-	struct worker *new_workers[NR_WORKER_POOLS] = { };
 	struct worker_pool *pool;
 	unsigned long flags;
-	int i;
 
 	action &= ~CPU_TASKS_FROZEN;
 
@@ -3672,14 +3639,22 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		if (IS_ERR(new_trustee))
 			return notifier_from_errno(PTR_ERR(new_trustee));
 		kthread_bind(new_trustee, cpu);
-		/* fall through */
+		break;
+
 	case CPU_UP_PREPARE:
-		i = 0;
 		for_each_worker_pool(pool, gcwq) {
-			BUG_ON(pool->first_idle);
-			new_workers[i] = create_worker(pool);
-			if (!new_workers[i++])
-				goto err_destroy;
+			struct worker *worker;
+
+			if (pool->nr_workers)
+				continue;
+
+			worker = create_worker(pool);
+			if (!worker)
+				return NOTIFY_BAD;
+
+			spin_lock_irq(&gcwq->lock);
+			start_worker(worker);
+			spin_unlock_irq(&gcwq->lock);
 		}
 	}
 
@@ -3694,23 +3669,10 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		gcwq->trustee_state = TRUSTEE_START;
 		wake_up_process(gcwq->trustee);
 		wait_trustee_state(gcwq, TRUSTEE_IN_CHARGE);
-		/* fall through */
-	case CPU_UP_PREPARE:
-		i = 0;
-		for_each_worker_pool(pool, gcwq) {
-			BUG_ON(pool->first_idle);
-			pool->first_idle = new_workers[i++];
-		}
 		break;
 
 	case CPU_POST_DEAD:
 		gcwq->trustee_state = TRUSTEE_BUTCHER;
-		/* fall through */
-	case CPU_UP_CANCELED:
-		for_each_worker_pool(pool, gcwq) {
-			destroy_worker(pool->first_idle);
-			pool->first_idle = NULL;
-		}
 		break;
 
 	case CPU_DOWN_FAILED:
@@ -3730,39 +3692,12 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		rebind_workers(gcwq);
 
 		gcwq_release_management(gcwq);
-
-		/*
-		 * Trustee is done and there might be no worker left.
-		 * Put the first_idle in and request a real manager to
-		 * take a look.
-		 */
-		for_each_worker_pool(pool, gcwq) {
-			spin_unlock_irq(&gcwq->lock);
-			kthread_bind(pool->first_idle->task, cpu);
-			spin_lock_irq(&gcwq->lock);
-			pool->flags |= POOL_MANAGE_WORKERS;
-			pool->first_idle->flags &= ~WORKER_UNBOUND;
-			start_worker(pool->first_idle);
-			pool->first_idle = NULL;
-		}
 		break;
 	}
 
 	spin_unlock_irqrestore(&gcwq->lock, flags);
 
 	return notifier_from_errno(0);
-
-err_destroy:
-	if (new_trustee)
-		kthread_stop(new_trustee);
-
-	spin_lock_irqsave(&gcwq->lock, flags);
-	for (i = 0; i < NR_WORKER_POOLS; i++)
-		if (new_workers[i])
-			destroy_worker(new_workers[i]);
-	spin_unlock_irqrestore(&gcwq->lock, flags);
-
-	return NOTIFY_BAD;
 }
 
 /*
@@ -3775,7 +3710,6 @@ static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_CANCELED:
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
 		return workqueue_cpu_callback(nfb, action, hcpu);
-- 
1.7.7.3

