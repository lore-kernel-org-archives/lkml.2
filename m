Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0IPLY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 07:24:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:40131 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab0IPLYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 07:24:25 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: dmitry.torokhov@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] workqueue: factor out start_flush_work()
Date: Thu, 16 Sep 2010 13:24:06 +0200
Message-Id: <1284636247-4734-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284636247-4734-1-git-send-email-tj@kernel.org>
References: <1284636247-4734-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Sep 2010 11:24:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out start_flush_work() from flush_work().  start_flush_work()
has @wait_executing argument which controls whether the barrier is
queued only if the work is pending or also if executing.  As
flush_work() needs to wait for execution too, it uses %true.

This commit doesn't cause any behavior difference.  start_flush_work()
will be used to implement flush_work_sync().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   64 ++++++++++++++++++++++++++++++----------------------
 1 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1240b9d..33d31d7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2326,35 +2326,17 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
-/**
- * flush_work - wait for a work to finish executing the last queueing instance
- * @work: the work to flush
- *
- * Wait until @work has finished execution.  This function considers
- * only the last queueing instance of @work.  If @work has been
- * enqueued across different CPUs on a non-reentrant workqueue or on
- * multiple workqueues, @work might still be executing on return on
- * some of the CPUs from earlier queueing.
- *
- * If @work was queued only on a non-reentrant, ordered or unbound
- * workqueue, @work is guaranteed to be idle on return if it hasn't
- * been requeued since flush started.
- *
- * RETURNS:
- * %true if flush_work() waited for the work to finish execution,
- * %false if it was already idle.
- */
-bool flush_work(struct work_struct *work)
+static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
+			     bool wait_executing)
 {
 	struct worker *worker = NULL;
 	struct global_cwq *gcwq;
 	struct cpu_workqueue_struct *cwq;
-	struct wq_barrier barr;
 
 	might_sleep();
 	gcwq = get_work_gcwq(work);
 	if (!gcwq)
-		return 0;
+		return false;
 
 	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
@@ -2367,26 +2349,54 @@ bool flush_work(struct work_struct *work)
 		cwq = get_work_cwq(work);
 		if (unlikely(!cwq || gcwq != cwq->gcwq))
 			goto already_gone;
-	} else {
+	} else if (wait_executing) {
 		worker = find_worker_executing_work(gcwq, work);
 		if (!worker)
 			goto already_gone;
 		cwq = worker->current_cwq;
-	}
+	} else
+		goto already_gone;
 
-	insert_wq_barrier(cwq, &barr, work, worker);
+	insert_wq_barrier(cwq, barr, work, worker);
 	spin_unlock_irq(&gcwq->lock);
 
 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);
-
-	wait_for_completion(&barr.done);
-	destroy_work_on_stack(&barr.work);
 	return true;
 already_gone:
 	spin_unlock_irq(&gcwq->lock);
 	return false;
 }
+
+/**
+ * flush_work - wait for a work to finish executing the last queueing instance
+ * @work: the work to flush
+ *
+ * Wait until @work has finished execution.  This function considers
+ * only the last queueing instance of @work.  If @work has been
+ * enqueued across different CPUs on a non-reentrant workqueue or on
+ * multiple workqueues, @work might still be executing on return on
+ * some of the CPUs from earlier queueing.
+ *
+ * If @work was queued only on a non-reentrant, ordered or unbound
+ * workqueue, @work is guaranteed to be idle on return if it hasn't
+ * been requeued since flush started.
+ *
+ * RETURNS:
+ * %true if flush_work() waited for the work to finish execution,
+ * %false if it was already idle.
+ */
+bool flush_work(struct work_struct *work)
+{
+	struct wq_barrier barr;
+
+	if (start_flush_work(work, &barr, true)) {
+		wait_for_completion(&barr.done);
+		destroy_work_on_stack(&barr.work);
+		return true;
+	} else
+		return false;
+}
 EXPORT_SYMBOL_GPL(flush_work);
 
 static bool wait_on_cpu_work(struct global_cwq *gcwq, struct work_struct *work)
-- 
1.7.1

