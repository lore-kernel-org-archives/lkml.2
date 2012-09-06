Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662Ab2IFUGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:06:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48701 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab2IFUGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:06:53 -0400
Date: Thu, 6 Sep 2012 13:06:47 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH wq/for-3.6-fixes 1/3] workqueue: break out gcwq->lock
 locking from gcwq_claim/release_management_and_[un]lock()
Message-ID: <20120906200647.GG29092@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a6d1347ef1a08623b9881b1705ce0df6b213afb1 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 6 Sep 2012 12:50:40 -0700

Releasing management and unlocking gcwq->lock need to be done
separately for the scheduled fix of a subtle idle worker depletion
issue during CPU_ONLINE.  Break out gcwq->lock handling from these
functions.

This patch doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
This three patch series fixes the possible idle worker depletion bug
reported by Lai.  The first two patches are prep patches which don't
introduce any functional difference.  The third fixes the problem by
releasing manager_mutexes before releasing idle workers.

Thanks.

 kernel/workqueue.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dc7b845..63ede1f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3394,21 +3394,19 @@ EXPORT_SYMBOL_GPL(work_busy);
  */
 
 /* claim manager positions of all pools */
-static void gcwq_claim_management_and_lock(struct global_cwq *gcwq)
+static void gcwq_claim_management(struct global_cwq *gcwq)
 {
 	struct worker_pool *pool;
 
 	for_each_worker_pool(pool, gcwq)
 		mutex_lock_nested(&pool->manager_mutex, pool - gcwq->pools);
-	spin_lock_irq(&gcwq->lock);
 }
 
 /* release manager positions */
-static void gcwq_release_management_and_unlock(struct global_cwq *gcwq)
+static void gcwq_release_management(struct global_cwq *gcwq)
 {
 	struct worker_pool *pool;
 
-	spin_unlock_irq(&gcwq->lock);
 	for_each_worker_pool(pool, gcwq)
 		mutex_unlock(&pool->manager_mutex);
 }
@@ -3423,7 +3421,8 @@ static void gcwq_unbind_fn(struct work_struct *work)
 
 	BUG_ON(gcwq->cpu != smp_processor_id());
 
-	gcwq_claim_management_and_lock(gcwq);
+	gcwq_claim_management(gcwq);
+	spin_lock_irq(&gcwq->lock);
 
 	/*
 	 * We've claimed all manager positions.  Make all workers unbound
@@ -3440,7 +3439,8 @@ static void gcwq_unbind_fn(struct work_struct *work)
 
 	gcwq->flags |= GCWQ_DISASSOCIATED;
 
-	gcwq_release_management_and_unlock(gcwq);
+	spin_unlock_irq(&gcwq->lock);
+	gcwq_release_management(gcwq);
 
 	/*
 	 * Call schedule() so that we cross rq->lock and thus can guarantee
@@ -3496,10 +3496,12 @@ static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		gcwq_claim_management_and_lock(gcwq);
+		gcwq_claim_management(gcwq);
+		spin_lock_irq(&gcwq->lock);
 		gcwq->flags &= ~GCWQ_DISASSOCIATED;
 		rebind_workers(gcwq);
-		gcwq_release_management_and_unlock(gcwq);
+		spin_unlock_irq(&gcwq->lock);
+		gcwq_release_management(gcwq);
 		break;
 	}
 	return NOTIFY_OK;
-- 
1.7.7.3

