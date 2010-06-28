Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab0F1VGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:06:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:42863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab0F1VGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:06:15 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 31/35] workqueue: implement high priority workqueue
Date: Mon, 28 Jun 2010 23:04:19 +0200
Message-Id: <1277759063-24607-32-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 21:05:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements high priority workqueue which can be specified
with WQ_HIGHPRI flag on creation.  A high priority workqueue has the
following properties.

* A work queued to it is queued at the head of the worklist of the
  respective gcwq after other highpri works, while normal works are
  always appended at the end.

* As long as there are highpri works on gcwq->worklist,
  [__]need_more_worker() remains %true and process_one_work() wakes up
  another worker before it start executing a work.

The above two properties guarantee that works queued to high priority
workqueues are dispatched to workers and start execution as soon as
possible regardless of the state of other works.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   70 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 0a7f797..006dcf7 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -231,6 +231,7 @@ enum {
 	WQ_SINGLE_CPU		= 1 << 1, /* only single cpu at a time */
 	WQ_NON_REENTRANT	= 1 << 2, /* guarantee non-reentrance */
 	WQ_RESCUER		= 1 << 3, /* has an rescue worker */
+	WQ_HIGHPRI		= 1 << 4, /* high priority */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_DFL_ACTIVE		= WQ_MAX_ACTIVE / 2,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 979f893..e12f9aa 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -43,6 +43,7 @@ enum {
 	GCWQ_MANAGING_WORKERS	= 1 << 1,	/* managing workers */
 	GCWQ_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
 	GCWQ_FREEZING		= 1 << 3,	/* freeze in progress */
+	GCWQ_HIGHPRI_PENDING	= 1 << 4,	/* highpri works on queue */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -452,15 +453,19 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
  * assume that they're being called with gcwq->lock held.
  */
 
+static bool __need_more_worker(struct global_cwq *gcwq)
+{
+	return !atomic_read(get_gcwq_nr_running(gcwq->cpu)) ||
+		gcwq->flags & GCWQ_HIGHPRI_PENDING;
+}
+
 /*
  * Need to wake up a worker?  Called from anything but currently
  * running workers.
  */
 static bool need_more_worker(struct global_cwq *gcwq)
 {
-	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
-
-	return !list_empty(&gcwq->worklist) && !atomic_read(nr_running);
+	return !list_empty(&gcwq->worklist) && __need_more_worker(gcwq);
 }
 
 /* Can I start working?  Called from busy but !running workers. */
@@ -734,6 +739,43 @@ static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
 }
 
 /**
+ * gcwq_determine_ins_pos - find insertion position
+ * @gcwq: gcwq of interest
+ * @cwq: cwq a work is being queued for
+ *
+ * A work for @cwq is about to be queued on @gcwq, determine insertion
+ * position for the work.  If @cwq is for HIGHPRI wq, the work is
+ * queued at the head of the queue but in FIFO order with respect to
+ * other HIGHPRI works; otherwise, at the end of the queue.  This
+ * function also sets GCWQ_HIGHPRI_PENDING flag to hint @gcwq that
+ * there are HIGHPRI works pending.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ *
+ * RETURNS:
+ * Pointer to inserstion position.
+ */
+static inline struct list_head *gcwq_determine_ins_pos(struct global_cwq *gcwq,
+					       struct cpu_workqueue_struct *cwq)
+{
+	struct work_struct *twork;
+
+	if (likely(!(cwq->wq->flags & WQ_HIGHPRI)))
+		return &gcwq->worklist;
+
+	list_for_each_entry(twork, &gcwq->worklist, entry) {
+		struct cpu_workqueue_struct *tcwq = get_work_cwq(twork);
+
+		if (!(tcwq->wq->flags & WQ_HIGHPRI))
+			break;
+	}
+
+	gcwq->flags |= GCWQ_HIGHPRI_PENDING;
+	return &twork->entry;
+}
+
+/**
  * insert_work - insert a work into gcwq
  * @cwq: cwq @work belongs to
  * @work: work to insert
@@ -770,7 +812,7 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	 */
 	smp_mb();
 
-	if (!atomic_read(get_gcwq_nr_running(gcwq->cpu)))
+	if (__need_more_worker(gcwq))
 		wake_up_worker(gcwq);
 }
 
@@ -887,7 +929,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 	if (likely(cwq->nr_active < cwq->max_active)) {
 		cwq->nr_active++;
-		worklist = &gcwq->worklist;
+		worklist = gcwq_determine_ins_pos(gcwq, cwq);
 	} else
 		worklist = &cwq->delayed_works;
 
@@ -1526,8 +1568,9 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 {
 	struct work_struct *work = list_first_entry(&cwq->delayed_works,
 						    struct work_struct, entry);
+	struct list_head *pos = gcwq_determine_ins_pos(cwq->gcwq, cwq);
 
-	move_linked_works(work, &cwq->gcwq->worklist, NULL);
+	move_linked_works(work, pos, NULL);
 	cwq->nr_active++;
 }
 
@@ -1634,6 +1677,21 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	set_work_cpu(work, gcwq->cpu);
 	list_del_init(&work->entry);
 
+	/*
+	 * If HIGHPRI_PENDING, check the next work, and, if HIGHPRI,
+	 * wake up another worker; otherwise, clear HIGHPRI_PENDING.
+	 */
+	if (unlikely(gcwq->flags & GCWQ_HIGHPRI_PENDING)) {
+		struct work_struct *nwork = list_first_entry(&gcwq->worklist,
+						struct work_struct, entry);
+
+		if (!list_empty(&gcwq->worklist) &&
+		    get_work_cwq(nwork)->wq->flags & WQ_HIGHPRI)
+			wake_up_worker(gcwq);
+		else
+			gcwq->flags &= ~GCWQ_HIGHPRI_PENDING;
+	}
+
 	spin_unlock_irq(&gcwq->lock);
 
 	work_clear_pending(work);
-- 
1.6.4.2

