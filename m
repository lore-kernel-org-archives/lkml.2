Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0F1VNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:13:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:42835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab0F1VGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:06:08 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 26/35] workqueue: implement worker_{set|clr}_flags()
Date: Mon, 28 Jun 2010 23:04:14 +0200
Message-Id: <1277759063-24607-27-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 21:05:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement worker_{set|clr}_flags() to manipulate worker flags.  These
are currently simple wrappers but logics to track the current worker
state and the current level of concurrency will be added.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   48 ++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e0a7609..8b90d87 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -412,6 +412,38 @@ static void wake_up_worker(struct global_cwq *gcwq)
 }
 
 /**
+ * worker_set_flags - set worker flags
+ * @worker: worker to set flags for
+ * @flags: flags to set
+ * @wakeup: wakeup an idle worker if necessary
+ *
+ * Set @flags in @worker->flags.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock).
+ */
+static inline void worker_set_flags(struct worker *worker, unsigned int flags,
+				    bool wakeup)
+{
+	worker->flags |= flags;
+}
+
+/**
+ * worker_clr_flags - clear worker flags
+ * @worker: worker to set flags for
+ * @flags: flags to clear
+ *
+ * Clear @flags in @worker->flags.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock).
+ */
+static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
+{
+	worker->flags &= ~flags;
+}
+
+/**
  * busy_worker_head - return the busy hash head for a work
  * @gcwq: gcwq of interest
  * @work: work to be hashed
@@ -776,7 +808,7 @@ static void worker_enter_idle(struct worker *worker)
 	BUG_ON(!list_empty(&worker->entry) &&
 	       (worker->hentry.next || worker->hentry.pprev));
 
-	worker->flags |= WORKER_IDLE;
+	worker_set_flags(worker, WORKER_IDLE, false);
 	gcwq->nr_idle++;
 
 	/* idle_list is LIFO */
@@ -800,7 +832,7 @@ static void worker_leave_idle(struct worker *worker)
 	struct global_cwq *gcwq = worker->gcwq;
 
 	BUG_ON(!(worker->flags & WORKER_IDLE));
-	worker->flags &= ~WORKER_IDLE;
+	worker_clr_flags(worker, WORKER_IDLE);
 	gcwq->nr_idle--;
 	list_del_init(&worker->entry);
 }
@@ -890,7 +922,7 @@ fail:
  */
 static void start_worker(struct worker *worker)
 {
-	worker->flags |= WORKER_STARTED;
+	worker_set_flags(worker, WORKER_STARTED, false);
 	worker->gcwq->nr_workers++;
 	worker_enter_idle(worker);
 	wake_up_process(worker->task);
@@ -920,7 +952,7 @@ static void destroy_worker(struct worker *worker)
 		gcwq->nr_idle--;
 
 	list_del_init(&worker->entry);
-	worker->flags |= WORKER_DIE;
+	worker_set_flags(worker, WORKER_DIE, false);
 
 	spin_unlock_irq(&gcwq->lock);
 
@@ -2208,10 +2240,10 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	BUG_ON(gcwq->cpu != smp_processor_id());
 
 	list_for_each_entry(worker, &gcwq->idle_list, entry)
-		worker->flags |= WORKER_ROGUE;
+		worker_set_flags(worker, WORKER_ROGUE, false);
 
 	for_each_busy_worker(worker, i, pos, gcwq)
-		worker->flags |= WORKER_ROGUE;
+		worker_set_flags(worker, WORKER_ROGUE, false);
 
 	/*
 	 * We're now in charge.  Notify and proceed to drain.  We need
@@ -2318,10 +2350,10 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 
 		/* clear ROGUE from all workers */
 		list_for_each_entry(worker, &gcwq->idle_list, entry)
-			worker->flags &= ~WORKER_ROGUE;
+			worker_clr_flags(worker, WORKER_ROGUE);
 
 		for_each_busy_worker(worker, i, pos, gcwq)
-			worker->flags &= ~WORKER_ROGUE;
+			worker_clr_flags(worker, WORKER_ROGUE);
 		break;
 	}
 
-- 
1.6.4.2

