Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0FNVjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:39:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:46955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab0FNVj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:26 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/30] workqueue: reimplement work flushing using linked works
Date: Mon, 14 Jun 2010 23:37:30 +0200
Message-Id: <1276551467-21246-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A work is linked to the next one by having WORK_STRUCT_LINKED bit set
and these links can be chained.  When a linked work is dispatched to a
worker, all linked works are dispatched to the worker's newly added
->scheduled queue and processed back-to-back.

Currently, as there's only single worker per cwq, having linked works
doesn't make any visible behavior difference.  This change is to
prepare for multiple shared workers per cpu.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    4 +-
 kernel/workqueue.c        |  152 ++++++++++++++++++++++++++++++++++++++------
 2 files changed, 134 insertions(+), 22 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 8762f62..4f4fdba 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -24,8 +24,9 @@ typedef void (*work_func_t)(struct work_struct *work);
 
 enum {
 	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
+	WORK_STRUCT_LINKED_BIT	= 1,	/* next work is linked to this one */
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
-	WORK_STRUCT_STATIC_BIT	= 1,	/* static initializer (debugobjects) */
+	WORK_STRUCT_STATIC_BIT	= 2,	/* static initializer (debugobjects) */
 	WORK_STRUCT_COLOR_SHIFT	= 3,	/* color for workqueue flushing */
 #else
 	WORK_STRUCT_COLOR_SHIFT	= 2,	/* color for workqueue flushing */
@@ -34,6 +35,7 @@ enum {
 	WORK_STRUCT_COLOR_BITS	= 4,
 
 	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
+	WORK_STRUCT_LINKED	= 1 << WORK_STRUCT_LINKED_BIT,
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 	WORK_STRUCT_STATIC	= 1 << WORK_STRUCT_STATIC_BIT,
 #else
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0b0c360..74b399b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -51,6 +51,7 @@ struct cpu_workqueue_struct;
 
 struct worker {
 	struct work_struct	*current_work;	/* L: work being processed */
+	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
 	struct cpu_workqueue_struct *cwq;	/* I: the associated cwq */
 	int			id;		/* I: worker id */
@@ -445,6 +446,8 @@ static struct worker *alloc_worker(void)
 	struct worker *worker;
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
+	if (worker)
+		INIT_LIST_HEAD(&worker->scheduled);
 	return worker;
 }
 
@@ -530,6 +533,7 @@ static void destroy_worker(struct worker *worker)
 
 	/* sanity check frenzy */
 	BUG_ON(worker->current_work);
+	BUG_ON(!list_empty(&worker->scheduled));
 
 	kthread_stop(worker->task);
 	kfree(worker);
@@ -540,6 +544,47 @@ static void destroy_worker(struct worker *worker)
 }
 
 /**
+ * move_linked_works - move linked works to a list
+ * @work: start of series of works to be scheduled
+ * @head: target list to append @work to
+ * @nextp: out paramter for nested worklist walking
+ *
+ * Schedule linked works starting from @work to @head.  Work series to
+ * be scheduled starts at @work and includes any consecutive work with
+ * WORK_STRUCT_LINKED set in its predecessor.
+ *
+ * If @nextp is not NULL, it's updated to point to the next work of
+ * the last scheduled work.  This allows move_linked_works() to be
+ * nested inside outer list_for_each_entry_safe().
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock).
+ */
+static void move_linked_works(struct work_struct *work, struct list_head *head,
+			      struct work_struct **nextp)
+{
+	struct work_struct *n;
+
+	/*
+	 * Linked worklist will always end before the end of the list,
+	 * use NULL for list head.
+	 */
+	list_for_each_entry_safe_from(work, n, NULL, entry) {
+		list_move_tail(&work->entry, head);
+		if (!(*work_data_bits(work) & WORK_STRUCT_LINKED))
+			break;
+	}
+
+	/*
+	 * If we're already inside safe list traversal and have moved
+	 * multiple works to the scheduled queue, the next position
+	 * needs to be updated.
+	 */
+	if (nextp)
+		*nextp = n;
+}
+
+/**
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
  * @color: color of work which left the queue
@@ -639,17 +684,25 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	cwq_dec_nr_in_flight(cwq, work_color);
 }
 
-static void run_workqueue(struct worker *worker)
+/**
+ * process_scheduled_works - process scheduled works
+ * @worker: self
+ *
+ * Process all scheduled works.  Please note that the scheduled list
+ * may change while processing a work, so this function repeatedly
+ * fetches a work from the top and executes it.
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock) which may be released and regrabbed
+ * multiple times.
+ */
+static void process_scheduled_works(struct worker *worker)
 {
-	struct cpu_workqueue_struct *cwq = worker->cwq;
-
-	spin_lock_irq(&cwq->lock);
-	while (!list_empty(&cwq->worklist)) {
-		struct work_struct *work = list_entry(cwq->worklist.next,
+	while (!list_empty(&worker->scheduled)) {
+		struct work_struct *work = list_first_entry(&worker->scheduled,
 						struct work_struct, entry);
 		process_one_work(worker, work);
 	}
-	spin_unlock_irq(&cwq->lock);
 }
 
 /**
@@ -684,7 +737,28 @@ static int worker_thread(void *__worker)
 					    get_cpu_mask(cwq->cpu))))
 			set_cpus_allowed_ptr(worker->task,
 					     get_cpu_mask(cwq->cpu));
-		run_workqueue(worker);
+
+		spin_lock_irq(&cwq->lock);
+
+		while (!list_empty(&cwq->worklist)) {
+			struct work_struct *work =
+				list_first_entry(&cwq->worklist,
+						 struct work_struct, entry);
+
+			if (likely(!(*work_data_bits(work) &
+				     WORK_STRUCT_LINKED))) {
+				/* optimization path, not strictly necessary */
+				process_one_work(worker, work);
+				if (unlikely(!list_empty(&worker->scheduled)))
+					process_scheduled_works(worker);
+			} else {
+				move_linked_works(work, &worker->scheduled,
+						  NULL);
+				process_scheduled_works(worker);
+			}
+		}
+
+		spin_unlock_irq(&cwq->lock);
 	}
 
 	return 0;
@@ -705,16 +779,33 @@ static void wq_barrier_func(struct work_struct *work)
  * insert_wq_barrier - insert a barrier work
  * @cwq: cwq to insert barrier into
  * @barr: wq_barrier to insert
- * @head: insertion point
+ * @target: target work to attach @barr to
+ * @worker: worker currently executing @target, NULL if @target is not executing
  *
- * Insert barrier @barr into @cwq before @head.
+ * @barr is linked to @target such that @barr is completed only after
+ * @target finishes execution.  Please note that the ordering
+ * guarantee is observed only with respect to @target and on the local
+ * cpu.
+ *
+ * Currently, a queued barrier can't be canceled.  This is because
+ * try_to_grab_pending() can't determine whether the work to be
+ * grabbed is at the head of the queue and thus can't clear LINKED
+ * flag of the previous work while there must be a valid next work
+ * after a work with LINKED flag set.
+ *
+ * Note that when @worker is non-NULL, @target may be modified
+ * underneath us, so we can't reliably determine cwq from @target.
  *
  * CONTEXT:
  * spin_lock_irq(cwq->lock).
  */
 static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
-			struct wq_barrier *barr, struct list_head *head)
+			      struct wq_barrier *barr,
+			      struct work_struct *target, struct worker *worker)
 {
+	struct list_head *head;
+	unsigned int linked = 0;
+
 	/*
 	 * debugobject calls are safe here even with cwq->lock locked
 	 * as we know for sure that this will not trigger any of the
@@ -725,8 +816,24 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 	__set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(&barr->work));
 	init_completion(&barr->done);
 
+	/*
+	 * If @target is currently being executed, schedule the
+	 * barrier to the worker; otherwise, put it after @target.
+	 */
+	if (worker)
+		head = worker->scheduled.next;
+	else {
+		unsigned long *bits = work_data_bits(target);
+
+		head = target->entry.next;
+		/* there can already be other linked works, inherit and set */
+		linked = *bits & WORK_STRUCT_LINKED;
+		__set_bit(WORK_STRUCT_LINKED_BIT, bits);
+	}
+
 	debug_work_activate(&barr->work);
-	insert_work(cwq, &barr->work, head, work_color_to_flags(WORK_NO_COLOR));
+	insert_work(cwq, &barr->work, head,
+		    work_color_to_flags(WORK_NO_COLOR) | linked);
 }
 
 /**
@@ -964,8 +1071,8 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
  */
 int flush_work(struct work_struct *work)
 {
+	struct worker *worker = NULL;
 	struct cpu_workqueue_struct *cwq;
-	struct list_head *prev;
 	struct wq_barrier barr;
 
 	might_sleep();
@@ -985,14 +1092,14 @@ int flush_work(struct work_struct *work)
 		smp_rmb();
 		if (unlikely(cwq != get_wq_data(work)))
 			goto already_gone;
-		prev = &work->entry;
 	} else {
-		if (!cwq->worker || cwq->worker->current_work != work)
+		if (cwq->worker && cwq->worker->current_work == work)
+			worker = cwq->worker;
+		if (!worker)
 			goto already_gone;
-		prev = &cwq->worklist;
 	}
-	insert_wq_barrier(cwq, &barr, prev->next);
 
+	insert_wq_barrier(cwq, &barr, work, worker);
 	spin_unlock_irq(&cwq->lock);
 	wait_for_completion(&barr.done);
 	destroy_work_on_stack(&barr.work);
@@ -1048,16 +1155,19 @@ static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 				struct work_struct *work)
 {
 	struct wq_barrier barr;
-	int running = 0;
+	struct worker *worker;
 
 	spin_lock_irq(&cwq->lock);
+
+	worker = NULL;
 	if (unlikely(cwq->worker && cwq->worker->current_work == work)) {
-		insert_wq_barrier(cwq, &barr, cwq->worklist.next);
-		running = 1;
+		worker = cwq->worker;
+		insert_wq_barrier(cwq, &barr, work, worker);
 	}
+
 	spin_unlock_irq(&cwq->lock);
 
-	if (unlikely(running)) {
+	if (unlikely(worker)) {
 		wait_for_completion(&barr.done);
 		destroy_work_on_stack(&barr.work);
 	}
-- 
1.6.4.2

