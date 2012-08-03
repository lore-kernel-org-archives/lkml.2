Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2HCRog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:44:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41087 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2HCRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:44:31 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        tomi.valkeinen@ti.com, Tejun Heo <tj@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 12/14] workqueue: mark a work item being canceled as such
Date: Fri,  3 Aug 2012 10:43:57 -0700
Message-Id: <1344015839-21800-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344015839-21800-1-git-send-email-tj@kernel.org>
References: <1344015839-21800-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There can be two reasons try_to_grab_pending() can fail with -EAGAIN.
One is when someone else is queueing or deqeueing the work item.  With
the previous patches, it is guaranteed that PENDING and queued state
will soon agree making it safe to busy-retry in this case.

The other is if multiple __cancel_work_timer() invocations are racing
one another.  __cancel_work_timer() grabs PENDING and then waits for
running instances of the target work item on all CPUs while holding
PENDING and !queued.  try_to_grab_pending() invoked from another task
will keep returning -EAGAIN while the current owner is waiting.

Not distinguishing the two cases is okay because __cancel_work_timer()
is the only user of try_to_grab_pending() and it invokes
wait_on_work() whenever grabbing fails.  For the first case, busy
looping should be fine but wait_on_work() doesn't cause any critical
problem.  For the latter case, the new contender usually waits for the
same condition as the current owner, so no unnecessarily extended
busy-looping happens.  Combined, these make __cancel_work_timer()
technically correct even without irq protection while grabbing PENDING
or distinguishing the two different cases.

While the current code is technically correct, not distinguishing the
two cases makes it difficult to use try_to_grab_pending() for other
purposes than canceling because it's impossible to tell whether it's
safe to busy-retry grabbing.

This patch adds a mechanism to mark a work item being canceled.
try_to_grab_pending() now disables irq on success and returns -EAGAIN
to indicate that grabbing failed but PENDING and queued states are
gonna agree soon and it's safe to busy-loop.  It returns -ENOENT if
the work item is being canceled and it may stay PENDING && !queued for
arbitrary amount of time.

__cancel_work_timer() is modified to mark the work canceling with
WORK_OFFQ_CANCELING after grabbing PENDING, thus making
try_to_grab_pending() fail with -ENOENT instead of -EAGAIN.  Also, it
invokes wait_on_work() iff grabbing failed with -ENOENT.  This isn't
necessary for correctness but makes it consistent with other future
users of try_to_grab_pending().

v2: try_to_grab_pending() was testing preempt_count() to ensure that
    the caller has disabled preemption.  This triggers spuriously if
    !CONFIG_PREEMPT_COUNT.  Use preemptible() instead.  Reported by
    Fengguang Wu.

v3: Updated so that try_to_grab_pending() disables irq on success
    rather than requiring preemption disabled by the caller.  This
    makes busy-looping easier and will allow try_to_grap_pending() to
    be used from bh/irq contexts.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 include/linux/workqueue.h |    5 ++-
 kernel/workqueue.c        |   90 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 76 insertions(+), 19 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f562674..5f4aeaa 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -70,7 +70,10 @@ enum {
 
 	/* data contains off-queue information when !WORK_STRUCT_CWQ */
 	WORK_OFFQ_FLAG_BASE	= WORK_STRUCT_FLAG_BITS,
-	WORK_OFFQ_FLAG_BITS	= 0,
+
+	WORK_OFFQ_CANCELING	= (1 << WORK_OFFQ_FLAG_BASE),
+
+	WORK_OFFQ_FLAG_BITS	= 1,
 	WORK_OFFQ_CPU_SHIFT	= WORK_OFFQ_FLAG_BASE + WORK_OFFQ_FLAG_BITS,
 
 	/* convenience constants */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4b3663b..b4a4e05 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -537,15 +537,20 @@ static int work_next_color(int color)
  * contain the pointer to the queued cwq.  Once execution starts, the flag
  * is cleared and the high bits contain OFFQ flags and CPU number.
  *
- * set_work_cwq(), set_work_cpu_and_clear_pending() and clear_work_data()
- * can be used to set the cwq, cpu or clear work->data.  These functions
- * should only be called while the work is owned - ie. while the PENDING
- * bit is set.
+ * set_work_cwq(), set_work_cpu_and_clear_pending(), mark_work_canceling()
+ * and clear_work_data() can be used to set the cwq, cpu or clear
+ * work->data.  These functions should only be called while the work is
+ * owned - ie. while the PENDING bit is set.
  *
- * get_work_[g]cwq() can be used to obtain the gcwq or cwq
- * corresponding to a work.  gcwq is available once the work has been
- * queued anywhere after initialization.  cwq is available only from
- * queueing until execution starts.
+ * get_work_[g]cwq() can be used to obtain the gcwq or cwq corresponding to
+ * a work.  gcwq is available once the work has been queued anywhere after
+ * initialization until it is sync canceled.  cwq is available only while
+ * the work item is queued.
+ *
+ * %WORK_OFFQ_CANCELING is used to mark a work item which is being
+ * canceled.  While being canceled, a work item may have its PENDING set
+ * but stay off timer and worklist for arbitrarily long and nobody should
+ * try to steal the PENDING bit.
  */
 static inline void set_work_data(struct work_struct *work, unsigned long data,
 				 unsigned long flags)
@@ -600,6 +605,22 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 	return get_gcwq(cpu);
 }
 
+static void mark_work_canceling(struct work_struct *work)
+{
+	struct global_cwq *gcwq = get_work_gcwq(work);
+	unsigned long cpu = gcwq ? gcwq->cpu : WORK_CPU_NONE;
+
+	set_work_data(work, (cpu << WORK_OFFQ_CPU_SHIFT) | WORK_OFFQ_CANCELING,
+		      WORK_STRUCT_PENDING);
+}
+
+static bool work_is_canceling(struct work_struct *work)
+{
+	unsigned long data = atomic_long_read(&work->data);
+
+	return !(data & WORK_STRUCT_CWQ) && (data & WORK_OFFQ_CANCELING);
+}
+
 /*
  * Policy functions.  These define the policies on how the global worker
  * pools are managed.  Unless noted otherwise, these functions assume that
@@ -1005,9 +1026,10 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
 }
 
 /**
- * try_to_grab_pending - steal work item from worklist
+ * try_to_grab_pending - steal work item from worklist and disable irq
  * @work: work item to steal
  * @is_dwork: @work is a delayed_work
+ * @flags: place to store irq state
  *
  * Try to grab PENDING bit of @work.  This function can handle @work in any
  * stable state - idle, on timer or on worklist.  Return values are
@@ -1015,13 +1037,30 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
  *  1		if @work was pending and we successfully stole PENDING
  *  0		if @work was idle and we claimed PENDING
  *  -EAGAIN	if PENDING couldn't be grabbed at the moment, safe to busy-retry
+ *  -ENOENT	if someone else is canceling @work, this state may persist
+ *		for arbitrarily long
  *
- * On >= 0 return, the caller owns @work's PENDING bit.
+ * On >= 0 return, the caller owns @work's PENDING bit.  To avoid getting
+ * preempted while holding PENDING and @work off queue, preemption must be
+ * disabled on entry.  This ensures that we don't return -EAGAIN while
+ * another task is preempted in this function.
+ *
+ * On successful return, >= 0, irq is disabled and the caller is
+ * responsible for releasing it using local_irq_restore(*@flags).
+ *
+ * This function is safe to call from any context other than IRQ handler.
+ * An IRQ handler may run on top of delayed_work_timer_fn() which can make
+ * this function return -EAGAIN perpetually.
  */
-static int try_to_grab_pending(struct work_struct *work, bool is_dwork)
+static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
+			       unsigned long *flags)
 {
 	struct global_cwq *gcwq;
 
+	WARN_ON_ONCE(in_irq());
+
+	local_irq_save(*flags);
+
 	/* try to steal the timer if it exists */
 	if (is_dwork) {
 		struct delayed_work *dwork = to_delayed_work(work);
@@ -1040,9 +1079,9 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork)
 	 */
 	gcwq = get_work_gcwq(work);
 	if (!gcwq)
-		return -EAGAIN;
+		goto fail;
 
-	spin_lock_irq(&gcwq->lock);
+	spin_lock(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
 		/*
 		 * This work is queued, but perhaps we locked the wrong gcwq.
@@ -1057,12 +1096,16 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork)
 				get_work_color(work),
 				*work_data_bits(work) & WORK_STRUCT_DELAYED);
 
-			spin_unlock_irq(&gcwq->lock);
+			spin_unlock(&gcwq->lock);
 			return 1;
 		}
 	}
-	spin_unlock_irq(&gcwq->lock);
-
+	spin_unlock(&gcwq->lock);
+fail:
+	local_irq_restore(*flags);
+	if (work_is_canceling(work))
+		return -ENOENT;
+	cpu_relax();
 	return -EAGAIN;
 }
 
@@ -2839,13 +2882,24 @@ EXPORT_SYMBOL_GPL(flush_work_sync);
 
 static bool __cancel_work_timer(struct work_struct *work, bool is_dwork)
 {
+	unsigned long flags;
 	int ret;
 
 	do {
-		ret = try_to_grab_pending(work, is_dwork);
-		wait_on_work(work);
+		ret = try_to_grab_pending(work, is_dwork, &flags);
+		/*
+		 * If someone else is canceling, wait for the same event it
+		 * would be waiting for before retrying.
+		 */
+		if (unlikely(ret == -ENOENT))
+			wait_on_work(work);
 	} while (unlikely(ret < 0));
 
+	/* tell other tasks trying to grab @work to back off */
+	mark_work_canceling(work);
+	local_irq_restore(flags);
+
+	wait_on_work(work);
 	clear_work_data(work);
 	return ret;
 }
-- 
1.7.7.3

