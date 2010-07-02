Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab0GBIdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:33:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab0GBId3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=euziHPeM0k1JKnhiuKb+mKOHlOnBD/USAZwWQmFGT8HbnBcEKKFzQmqgl2XCWG9BBD
         FTXxky+n323p/XFOeaJTt1hKiTxrYvWpFnBEKum+7BXmLa6qr28Dy06NSwwGabtipwYY
         t7V4ybA5/rvbJJ5YklmeaOlXTCDkdPzThXUF8=
Message-ID: <4C2DA454.2010401@gmail.com>
Date: Fri, 02 Jul 2010 10:33:24 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: [PATCH 1/4] workqueue: use worker_set/clr_flags() only from worker
 itself
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <4C2DA42C.7090804@gmail.com>
In-Reply-To: <4C2DA42C.7090804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker_set/clr_flags() assume that if none of NOT_RUNNING flags is set
the worker must be contributing to nr_running which is only true if
the worker is actually running.

As when called from self, it is guaranteed that the worker is running,
those functions can be safely used from the worker itself and they
aren't necessary from other places anyway.  Make the following changes
to fix the bug.

* Make worker_set/clr_flags() whine if not called from self.

* Convert all places which called those functions from other tasks to
  manipulate flags directly.

* Make trustee_thread() directly clear nr_running after setting
  WORKER_ROGUE on all workers.  This is the only place where
  nr_running manipulation is necessary outside of workers themselves.

* While at it, add sanity check for nr_running in worker_enter_idle().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   47 ++++++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6fa847c..5587338 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -601,7 +601,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,

 /**
  * worker_set_flags - set worker flags and adjust nr_running accordingly
- * @worker: worker to set flags for
+ * @worker: self
  * @flags: flags to set
  * @wakeup: wakeup an idle worker if necessary
  *
@@ -609,14 +609,16 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
  * nr_running becomes zero and @wakeup is %true, an idle worker is
  * woken up.
  *
- * LOCKING:
- * spin_lock_irq(gcwq->lock).
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock)
  */
 static inline void worker_set_flags(struct worker *worker, unsigned int flags,
 				    bool wakeup)
 {
 	struct global_cwq *gcwq = worker->gcwq;

+	WARN_ON_ONCE(worker->task != current);
+
 	/*
 	 * If transitioning into NOT_RUNNING, adjust nr_running and
 	 * wake up an idle worker as necessary if requested by
@@ -639,19 +641,21 @@ static inline void worker_set_flags(struct worker *worker, unsigned int flags,

 /**
  * worker_clr_flags - clear worker flags and adjust nr_running accordingly
- * @worker: worker to set flags for
+ * @worker: self
  * @flags: flags to clear
  *
  * Clear @flags in @worker->flags and adjust nr_running accordingly.
  *
- * LOCKING:
- * spin_lock_irq(gcwq->lock).
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock)
  */
 static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 {
 	struct global_cwq *gcwq = worker->gcwq;
 	unsigned int oflags = worker->flags;

+	WARN_ON_ONCE(worker->task != current);
+
 	worker->flags &= ~flags;

 	/* if transitioning out of NOT_RUNNING, increment nr_running */
@@ -1073,7 +1077,8 @@ static void worker_enter_idle(struct worker *worker)
 	BUG_ON(!list_empty(&worker->entry) &&
 	       (worker->hentry.next || worker->hentry.pprev));

-	worker_set_flags(worker, WORKER_IDLE, false);
+	/* can't use worker_set_flags(), also called from start_worker() */
+	worker->flags |= WORKER_IDLE;
 	gcwq->nr_idle++;
 	worker->last_active = jiffies;

@@ -1086,6 +1091,10 @@ static void worker_enter_idle(struct worker *worker)
 				  jiffies + IDLE_WORKER_TIMEOUT);
 	} else
 		wake_up_all(&gcwq->trustee_wait);
+
+	/* sanity check nr_running */
+	WARN_ON_ONCE(gcwq->nr_workers == gcwq->nr_idle &&
+		     atomic_read(get_gcwq_nr_running(gcwq->cpu)));
 }

 /**
@@ -1270,7 +1279,7 @@ fail:
  */
 static void start_worker(struct worker *worker)
 {
-	worker_set_flags(worker, WORKER_STARTED, false);
+	worker->flags |= WORKER_STARTED;
 	worker->gcwq->nr_workers++;
 	worker_enter_idle(worker);
 	wake_up_process(worker->task);
@@ -1300,7 +1309,7 @@ static void destroy_worker(struct worker *worker)
 		gcwq->nr_idle--;

 	list_del_init(&worker->entry);
-	worker_set_flags(worker, WORKER_DIE, false);
+	worker->flags |= WORKER_DIE;

 	spin_unlock_irq(&gcwq->lock);

@@ -2979,10 +2988,10 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	gcwq->flags |= GCWQ_MANAGING_WORKERS;

 	list_for_each_entry(worker, &gcwq->idle_list, entry)
-		worker_set_flags(worker, WORKER_ROGUE, false);
+		worker->flags |= WORKER_ROGUE;

 	for_each_busy_worker(worker, i, pos, gcwq)
-		worker_set_flags(worker, WORKER_ROGUE, false);
+		worker->flags |= WORKER_ROGUE;

 	/*
 	 * Call schedule() so that we cross rq->lock and thus can
@@ -2995,12 +3004,12 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	spin_lock_irq(&gcwq->lock);

 	/*
-	 * Sched callbacks are disabled now.  gcwq->nr_running should
-	 * be zero and will stay that way, making need_more_worker()
-	 * and keep_working() always return true as long as the
-	 * worklist is not empty.
+	 * Sched callbacks are disabled now.  Zap nr_running.  After
+	 * this, nr_running stays zero and need_more_worker() and
+	 * keep_working() are always true as long as the worklist is
+	 * not empty.
 	 */
-	WARN_ON_ONCE(atomic_read(get_gcwq_nr_running(gcwq->cpu)) != 0);
+	atomic_set(get_gcwq_nr_running(gcwq->cpu), 0);

 	spin_unlock_irq(&gcwq->lock);
 	del_timer_sync(&gcwq->idle_timer);
@@ -3046,7 +3055,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 			worker = create_worker(gcwq, false);
 			spin_lock_irq(&gcwq->lock);
 			if (worker) {
-				worker_set_flags(worker, WORKER_ROGUE, false);
+				worker->flags |= WORKER_ROGUE;
 				start_worker(worker);
 			}
 		}
@@ -3085,8 +3094,8 @@ static int __cpuinit trustee_thread(void *__gcwq)
 		 * operations.  Use a separate flag to mark that
 		 * rebinding is scheduled.
 		 */
-		worker_set_flags(worker, WORKER_REBIND, false);
-		worker_clr_flags(worker, WORKER_ROGUE);
+		worker->flags |= WORKER_REBIND;
+		worker->flags &= ~WORKER_ROGUE;

 		/* queue rebind_work, wq doesn't matter, use the default one */
 		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
-- 
1.6.4.2

