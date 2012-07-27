Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2G0X5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:57:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2G0Xzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:55:33 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/15] workqueue: move try_to_grab_pending() upwards
Date: Fri, 27 Jul 2012 16:55:01 -0700
Message-Id: <1343433308-26614-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343433308-26614-1-git-send-email-tj@kernel.org>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_grab_pending() will be used by to-be-implemented
mod_delayed_work[_on]().  Move try_to_grab_pending() and related
functions above queueing functions.

This patch only moves functions around.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  286 ++++++++++++++++++++++++++--------------------------
 1 files changed, 143 insertions(+), 143 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e3383e8..97d2f71 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -904,6 +904,149 @@ static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
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
+ * spin_lock_irq(gcwq->lock).
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
+static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
+{
+	struct work_struct *work = list_first_entry(&cwq->delayed_works,
+						    struct work_struct, entry);
+
+	trace_workqueue_activate_work(work);
+	move_linked_works(work, &cwq->pool->worklist, NULL);
+	__clear_bit(WORK_STRUCT_DELAYED_BIT, work_data_bits(work));
+	cwq->nr_active++;
+}
+
+/**
+ * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
+ * @cwq: cwq of interest
+ * @color: color of work which left the queue
+ * @delayed: for a delayed work
+ *
+ * A work either has completed or is removed from pending queue,
+ * decrement nr_in_flight of its cwq and handle workqueue flushing.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
+				 bool delayed)
+{
+	/* ignore uncolored works */
+	if (color == WORK_NO_COLOR)
+		return;
+
+	cwq->nr_in_flight[color]--;
+
+	if (!delayed) {
+		cwq->nr_active--;
+		if (!list_empty(&cwq->delayed_works)) {
+			/* one down, submit a delayed one */
+			if (cwq->nr_active < cwq->max_active)
+				cwq_activate_first_delayed(cwq);
+		}
+	}
+
+	/* is flush in progress and are we at the flushing tip? */
+	if (likely(cwq->flush_color != color))
+		return;
+
+	/* are there still in-flight works? */
+	if (cwq->nr_in_flight[color])
+		return;
+
+	/* this cwq is done, clear flush_color */
+	cwq->flush_color = -1;
+
+	/*
+	 * If this was the last cwq, wake up the first flusher.  It
+	 * will handle the rest.
+	 */
+	if (atomic_dec_and_test(&cwq->wq->nr_cwqs_to_flush))
+		complete(&cwq->wq->first_flusher->done);
+}
+
+/*
+ * Upon a successful return (>= 0), the caller "owns" WORK_STRUCT_PENDING bit,
+ * so this work can't be re-armed in any way.
+ */
+static int try_to_grab_pending(struct work_struct *work)
+{
+	struct global_cwq *gcwq;
+	int ret = -1;
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
+		return 0;
+
+	/*
+	 * The queueing is in progress, or it is already queued. Try to
+	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
+	 */
+	gcwq = get_work_gcwq(work);
+	if (!gcwq)
+		return ret;
+
+	spin_lock_irq(&gcwq->lock);
+	if (!list_empty(&work->entry)) {
+		/*
+		 * This work is queued, but perhaps we locked the wrong gcwq.
+		 * In that case we must see the new value after rmb(), see
+		 * insert_work()->wmb().
+		 */
+		smp_rmb();
+		if (gcwq == get_work_gcwq(work)) {
+			debug_work_deactivate(work);
+			list_del_init(&work->entry);
+			cwq_dec_nr_in_flight(get_work_cwq(work),
+				get_work_color(work),
+				*work_data_bits(work) & WORK_STRUCT_DELAYED);
+			ret = 1;
+		}
+	}
+	spin_unlock_irq(&gcwq->lock);
+
+	return ret;
+}
+
+/**
  * insert_work - insert a work into gcwq
  * @cwq: cwq @work belongs to
  * @work: work to insert
@@ -1832,107 +1975,6 @@ static bool manage_workers(struct worker *worker)
 }
 
 /**
- * move_linked_works - move linked works to a list
- * @work: start of series of works to be scheduled
- * @head: target list to append @work to
- * @nextp: out paramter for nested worklist walking
- *
- * Schedule linked works starting from @work to @head.  Work series to
- * be scheduled starts at @work and includes any consecutive work with
- * WORK_STRUCT_LINKED set in its predecessor.
- *
- * If @nextp is not NULL, it's updated to point to the next work of
- * the last scheduled work.  This allows move_linked_works() to be
- * nested inside outer list_for_each_entry_safe().
- *
- * CONTEXT:
- * spin_lock_irq(gcwq->lock).
- */
-static void move_linked_works(struct work_struct *work, struct list_head *head,
-			      struct work_struct **nextp)
-{
-	struct work_struct *n;
-
-	/*
-	 * Linked worklist will always end before the end of the list,
-	 * use NULL for list head.
-	 */
-	list_for_each_entry_safe_from(work, n, NULL, entry) {
-		list_move_tail(&work->entry, head);
-		if (!(*work_data_bits(work) & WORK_STRUCT_LINKED))
-			break;
-	}
-
-	/*
-	 * If we're already inside safe list traversal and have moved
-	 * multiple works to the scheduled queue, the next position
-	 * needs to be updated.
-	 */
-	if (nextp)
-		*nextp = n;
-}
-
-static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
-{
-	struct work_struct *work = list_first_entry(&cwq->delayed_works,
-						    struct work_struct, entry);
-
-	trace_workqueue_activate_work(work);
-	move_linked_works(work, &cwq->pool->worklist, NULL);
-	__clear_bit(WORK_STRUCT_DELAYED_BIT, work_data_bits(work));
-	cwq->nr_active++;
-}
-
-/**
- * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
- * @cwq: cwq of interest
- * @color: color of work which left the queue
- * @delayed: for a delayed work
- *
- * A work either has completed or is removed from pending queue,
- * decrement nr_in_flight of its cwq and handle workqueue flushing.
- *
- * CONTEXT:
- * spin_lock_irq(gcwq->lock).
- */
-static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
-				 bool delayed)
-{
-	/* ignore uncolored works */
-	if (color == WORK_NO_COLOR)
-		return;
-
-	cwq->nr_in_flight[color]--;
-
-	if (!delayed) {
-		cwq->nr_active--;
-		if (!list_empty(&cwq->delayed_works)) {
-			/* one down, submit a delayed one */
-			if (cwq->nr_active < cwq->max_active)
-				cwq_activate_first_delayed(cwq);
-		}
-	}
-
-	/* is flush in progress and are we at the flushing tip? */
-	if (likely(cwq->flush_color != color))
-		return;
-
-	/* are there still in-flight works? */
-	if (cwq->nr_in_flight[color])
-		return;
-
-	/* this cwq is done, clear flush_color */
-	cwq->flush_color = -1;
-
-	/*
-	 * If this was the last cwq, wake up the first flusher.  It
-	 * will handle the rest.
-	 */
-	if (atomic_dec_and_test(&cwq->wq->nr_cwqs_to_flush))
-		complete(&cwq->wq->first_flusher->done);
-}
-
-/**
  * process_one_work - process single work
  * @worker: self
  * @work: work to process
@@ -2767,48 +2809,6 @@ bool flush_work_sync(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(flush_work_sync);
 
-/*
- * Upon a successful return (>= 0), the caller "owns" WORK_STRUCT_PENDING bit,
- * so this work can't be re-armed in any way.
- */
-static int try_to_grab_pending(struct work_struct *work)
-{
-	struct global_cwq *gcwq;
-	int ret = -1;
-
-	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
-		return 0;
-
-	/*
-	 * The queueing is in progress, or it is already queued. Try to
-	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
-	 */
-	gcwq = get_work_gcwq(work);
-	if (!gcwq)
-		return ret;
-
-	spin_lock_irq(&gcwq->lock);
-	if (!list_empty(&work->entry)) {
-		/*
-		 * This work is queued, but perhaps we locked the wrong gcwq.
-		 * In that case we must see the new value after rmb(), see
-		 * insert_work()->wmb().
-		 */
-		smp_rmb();
-		if (gcwq == get_work_gcwq(work)) {
-			debug_work_deactivate(work);
-			list_del_init(&work->entry);
-			cwq_dec_nr_in_flight(get_work_cwq(work),
-				get_work_color(work),
-				*work_data_bits(work) & WORK_STRUCT_DELAYED);
-			ret = 1;
-		}
-	}
-	spin_unlock_irq(&gcwq->lock);
-
-	return ret;
-}
-
 static bool __cancel_work_timer(struct work_struct *work,
 				struct timer_list* timer)
 {
-- 
1.7.7.3

