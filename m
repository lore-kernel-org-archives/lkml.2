Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747Ab2IFUH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:07:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47570 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab2IFUH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:07:27 -0400
Date: Thu, 6 Sep 2012 13:07:23 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH wq/for-3.6-fixes 2/3] workqueue: rename rebind_workers() to
 gcwq_associate() and let it handle locking and DISASSOCIATED clearing
Message-ID: <20120906200723.GH29092@google.com>
References: <20120906200647.GG29092@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906200647.GG29092@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0150a04271dbcc9abbb2575911fa1d72d40451bf Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 6 Sep 2012 12:50:40 -0700

CPU_ONLINE used to handle locking and clearing of DISASSOCIATED and
rebind_workers() just the rebinding.  This patch renames the function
to gcwq_associate() and let it handle the whole onlining.  This is for
the scheduled fix of a subtle idle worker depletion issue during
CPU_ONLINE.

Note that this removes the unnecessary relock at the end of
gcwq_associate().

This patch doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 63ede1f..b19170b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -480,6 +480,8 @@ static atomic_t unbound_pool_nr_running[NR_WORKER_POOLS] = {
 };
 
 static int worker_thread(void *__worker);
+static void gcwq_claim_management(struct global_cwq *gcwq);
+static void gcwq_release_management(struct global_cwq *gcwq);
 
 static int worker_pool_pri(struct worker_pool *pool)
 {
@@ -1355,11 +1357,11 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 }
 
 /**
- * rebind_workers - rebind all workers of a gcwq to the associated CPU
+ * gcwq_associate - (re)associate a gcwq to its CPU and rebind its workers
  * @gcwq: gcwq of interest
  *
- * @gcwq->cpu is coming online.  Rebind all workers to the CPU.  Rebinding
- * is different for idle and busy ones.
+ * @gcwq->cpu is coming online.  Clear %GCWQ_DISASSOCIATED and rebind all
+ * workers to the CPU.  Rebinding is different for idle and busy ones.
  *
  * The idle ones should be rebound synchronously and idle rebinding should
  * be complete before any worker starts executing work items with
@@ -1378,8 +1380,7 @@ static void busy_worker_rebind_fn(struct work_struct *work)
  * On return, all workers are guaranteed to either be bound or have rebind
  * work item scheduled.
  */
-static void rebind_workers(struct global_cwq *gcwq)
-	__releases(&gcwq->lock) __acquires(&gcwq->lock)
+static void gcwq_associate(struct global_cwq *gcwq)
 {
 	struct idle_rebind idle_rebind;
 	struct worker_pool *pool;
@@ -1387,10 +1388,10 @@ static void rebind_workers(struct global_cwq *gcwq)
 	struct hlist_node *pos;
 	int i;
 
-	lockdep_assert_held(&gcwq->lock);
+	gcwq_claim_management(gcwq);
+	spin_lock_irq(&gcwq->lock);
 
-	for_each_worker_pool(pool, gcwq)
-		lockdep_assert_held(&pool->manager_mutex);
+	gcwq->flags &= ~GCWQ_DISASSOCIATED;
 
 	/*
 	 * Rebind idle workers.  Interlocked both ways.  We wait for
@@ -1477,8 +1478,11 @@ retry:
 	if (--idle_rebind.cnt) {
 		spin_unlock_irq(&gcwq->lock);
 		wait_for_completion(&idle_rebind.done);
-		spin_lock_irq(&gcwq->lock);
+	} else {
+		spin_unlock_irq(&gcwq->lock);
 	}
+
+	gcwq_release_management(gcwq);
 }
 
 static struct worker *alloc_worker(void)
@@ -3496,12 +3500,7 @@ static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		gcwq_claim_management(gcwq);
-		spin_lock_irq(&gcwq->lock);
-		gcwq->flags &= ~GCWQ_DISASSOCIATED;
-		rebind_workers(gcwq);
-		spin_unlock_irq(&gcwq->lock);
-		gcwq_release_management(gcwq);
+		gcwq_associate(gcwq);
 		break;
 	}
 	return NOTIFY_OK;
-- 
1.7.7.3

