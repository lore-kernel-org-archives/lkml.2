Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1LBX45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:56:57 -0500
Received: from mga14.intel.com ([143.182.124.37]:28404 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1LBX4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:56:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,286,1320652800"; 
   d="scan'208";a="81705074"
Subject: [PATCH 1/3] workqueue: promote workqueue_lock to hard-irq safe
To: tj@kernel.org, JBottomley@parallels.com
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Fri, 02 Dec 2011 15:56:50 -0800
Message-ID: <20111202235650.24470.57997.stgit@localhost6.localdomain6>
In-Reply-To: <20111202235319.24470.65483.stgit@localhost6.localdomain6>
References: <20111202235319.24470.65483.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15-7-g9bfb-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for a deferred work implementation to queue unchained
work at the conclusion of a drain_workqueue() event.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/workqueue.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1783aab..f476895 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2403,10 +2403,10 @@ void drain_workqueue(struct workqueue_struct *wq)
 	 * hotter than drain_workqueue() and already looks at @wq->flags.
 	 * Use WQ_DRAINING so that queue doesn't have to check nr_drainers.
 	 */
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 	if (!wq->nr_drainers++)
 		wq->flags |= WQ_DRAINING;
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 reflush:
 	flush_workqueue(wq);
 
@@ -2428,10 +2428,10 @@ reflush:
 		goto reflush;
 	}
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 	if (!--wq->nr_drainers)
 		wq->flags &= ~WQ_DRAINING;
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
 
@@ -3033,7 +3033,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	 * list.  Grab it, set max_active accordingly and add the new
 	 * workqueue to workqueues list.
 	 */
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	if (workqueue_freezing && wq->flags & WQ_FREEZABLE)
 		for_each_cwq_cpu(cpu, wq)
@@ -3041,7 +3041,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 
 	list_add(&wq->list, &workqueues);
 
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 
 	return wq;
 err:
@@ -3072,9 +3072,9 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
 	 */
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 	list_del(&wq->list);
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 
 	/* sanity check */
 	for_each_cwq_cpu(cpu, wq) {
@@ -3114,23 +3114,23 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 
 	max_active = wq_clamp_max_active(max_active, wq->flags, wq->name);
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	wq->saved_max_active = max_active;
 
 	for_each_cwq_cpu(cpu, wq) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
 
-		spin_lock_irq(&gcwq->lock);
+		spin_lock(&gcwq->lock);
 
 		if (!(wq->flags & WQ_FREEZABLE) ||
 		    !(gcwq->flags & GCWQ_FREEZING))
 			get_cwq(gcwq->cpu, wq)->max_active = max_active;
 
-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock(&gcwq->lock);
 	}
 
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 EXPORT_SYMBOL_GPL(workqueue_set_max_active);
 
@@ -3642,7 +3642,7 @@ void freeze_workqueues_begin(void)
 {
 	unsigned int cpu;
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	BUG_ON(workqueue_freezing);
 	workqueue_freezing = true;
@@ -3651,7 +3651,7 @@ void freeze_workqueues_begin(void)
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct workqueue_struct *wq;
 
-		spin_lock_irq(&gcwq->lock);
+		spin_lock(&gcwq->lock);
 
 		BUG_ON(gcwq->flags & GCWQ_FREEZING);
 		gcwq->flags |= GCWQ_FREEZING;
@@ -3663,10 +3663,10 @@ void freeze_workqueues_begin(void)
 				cwq->max_active = 0;
 		}
 
-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock(&gcwq->lock);
 	}
 
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 
 /**
@@ -3687,7 +3687,7 @@ bool freeze_workqueues_busy(void)
 	unsigned int cpu;
 	bool busy = false;
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	BUG_ON(!workqueue_freezing);
 
@@ -3711,7 +3711,7 @@ bool freeze_workqueues_busy(void)
 		}
 	}
 out_unlock:
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 	return busy;
 }
 
@@ -3728,7 +3728,7 @@ void thaw_workqueues(void)
 {
 	unsigned int cpu;
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	if (!workqueue_freezing)
 		goto out_unlock;
@@ -3737,7 +3737,7 @@ void thaw_workqueues(void)
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct workqueue_struct *wq;
 
-		spin_lock_irq(&gcwq->lock);
+		spin_lock(&gcwq->lock);
 
 		BUG_ON(!(gcwq->flags & GCWQ_FREEZING));
 		gcwq->flags &= ~GCWQ_FREEZING;
@@ -3758,12 +3758,12 @@ void thaw_workqueues(void)
 
 		wake_up_worker(gcwq);
 
-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock(&gcwq->lock);
 	}
 
 	workqueue_freezing = false;
 out_unlock:
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 #endif /* CONFIG_FREEZER */
 

