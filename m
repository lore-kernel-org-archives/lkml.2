Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab0HaJjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:39:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:43408 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab0HaJjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:39:08 -0400
Message-ID: <4C7CCD7A.7090309@kernel.org>
Date: Tue, 31 Aug 2010 11:38:02 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Xiaotian Feng <xtfeng@gmail.com>,
        CAI Qian <caiqian@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [GIT PULL] workqueue: fixes for v2.6.36-rc3
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 31 Aug 2010 09:38:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive workqueue fixes for
v2.6.36-rc3.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

The branch contains eight patches making the following changes.

* cwq->nr_active could underflow, which could lead to BUG_ON()
  triggering on workqueue destruction and other work scheduling
  oddities.  The fix adds one bit to work struct flags enlarging the
  alignment requirement for cpu_workqueues to 256 bytes.  This will be
  reduced again by dropping WORK_STRUCT_CWQ_BIT in the next merge
  window.

* GCWQ_DISASSOCIATED and gcwq->mayday_mask initializations were
  incorrect.  This could make rescuers fall into infinite loops on
  CONFIG_CPUMASK_OFFSTACK=y configurations.  CAI Qian verified the
  fix.

* As worklist is shared by multiple workqueues now, it's important
  that there's no work pending when a workqueue is being destroyed.
  Some workqueue users didn't do this and ended up triggering BUG_ON()
  during destroy_workqueue(), at which point it's not clear who caused
  the problem.  WQ_DYING flag is added so that work queueing attempts
  after the final flush can be caught on queueing.

* Fix memory leak on destroy_workqueue().

* Sparse annotations and docbook update.

Thanks.


Jason Baron (1):
      workqueue: Add a workqueue chapter to the tracepoint docbook

Namhyung Kim (2):
      workqueue: annotate lock context change
      workqueue: mark lock acquisition on worker_maybe_bind_and_lock()

Tejun Heo (4):
      workqueue: improve destroy_workqueue() debuggability
      workqueue: fix cwq->nr_active underflow
      workqueue: fix GCWQ_DISASSOCIATED initialization
      workqueue: use zalloc_cpumask_var() for gcwq->mayday_mask

Xiaotian Feng (1):
      workqueue: free rescuer on destroy_workqueue

 Documentation/DocBook/tracepoint.tmpl |    5 +++
 include/linux/workqueue.h             |   18 +++++++----
 kernel/workqueue.c                    |   53 +++++++++++++++++++++++---------
 3 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/Documentation/DocBook/tracepoint.tmpl b/Documentation/DocBook/tracepoint.tmpl
index e8473ea..b57a9ed 100644
--- a/Documentation/DocBook/tracepoint.tmpl
+++ b/Documentation/DocBook/tracepoint.tmpl
@@ -104,4 +104,9 @@
    <title>Block IO</title>
 !Iinclude/trace/events/block.h
   </chapter>
+
+  <chapter id="workqueue">
+   <title>Workqueue</title>
+!Iinclude/trace/events/workqueue.h
+  </chapter>
 </book>
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 4f9d277..f11100f 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -25,18 +25,20 @@ typedef void (*work_func_t)(struct work_struct *work);

 enum {
 	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
-	WORK_STRUCT_CWQ_BIT	= 1,	/* data points to cwq */
-	WORK_STRUCT_LINKED_BIT	= 2,	/* next work is linked to this one */
+	WORK_STRUCT_DELAYED_BIT	= 1,	/* work item is delayed */
+	WORK_STRUCT_CWQ_BIT	= 2,	/* data points to cwq */
+	WORK_STRUCT_LINKED_BIT	= 3,	/* next work is linked to this one */
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
-	WORK_STRUCT_STATIC_BIT	= 3,	/* static initializer (debugobjects) */
-	WORK_STRUCT_COLOR_SHIFT	= 4,	/* color for workqueue flushing */
+	WORK_STRUCT_STATIC_BIT	= 4,	/* static initializer (debugobjects) */
+	WORK_STRUCT_COLOR_SHIFT	= 5,	/* color for workqueue flushing */
 #else
-	WORK_STRUCT_COLOR_SHIFT	= 3,	/* color for workqueue flushing */
+	WORK_STRUCT_COLOR_SHIFT	= 4,	/* color for workqueue flushing */
 #endif

 	WORK_STRUCT_COLOR_BITS	= 4,

 	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
+	WORK_STRUCT_DELAYED	= 1 << WORK_STRUCT_DELAYED_BIT,
 	WORK_STRUCT_CWQ		= 1 << WORK_STRUCT_CWQ_BIT,
 	WORK_STRUCT_LINKED	= 1 << WORK_STRUCT_LINKED_BIT,
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
@@ -59,8 +61,8 @@ enum {

 	/*
 	 * Reserve 7 bits off of cwq pointer w/ debugobjects turned
-	 * off.  This makes cwqs aligned to 128 bytes which isn't too
-	 * excessive while allowing 15 workqueue flush colors.
+	 * off.  This makes cwqs aligned to 256 bytes and allows 15
+	 * workqueue flush colors.
 	 */
 	WORK_STRUCT_FLAG_BITS	= WORK_STRUCT_COLOR_SHIFT +
 				  WORK_STRUCT_COLOR_BITS,
@@ -241,6 +243,8 @@ enum {
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */

+	WQ_DYING		= 1 << 6, /* internal: workqueue is dying */
+
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
 	WQ_DFL_ACTIVE		= WQ_MAX_ACTIVE / 2,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2994a0e..7855429 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -87,7 +87,8 @@ enum {
 /*
  * Structure fields follow one of the following exclusion rules.
  *
- * I: Set during initialization and read-only afterwards.
+ * I: Modifiable by initialization/destruction paths and read-only for
+ *    everyone else.
  *
  * P: Preemption protected.  Disabling preemption is enough and should
  *    only be modified and accessed from the local cpu.
@@ -195,7 +196,7 @@ typedef cpumask_var_t mayday_mask_t;
 	cpumask_test_and_set_cpu((cpu), (mask))
 #define mayday_clear_cpu(cpu, mask)		cpumask_clear_cpu((cpu), (mask))
 #define for_each_mayday_cpu(cpu, mask)		for_each_cpu((cpu), (mask))
-#define alloc_mayday_mask(maskp, gfp)		alloc_cpumask_var((maskp), (gfp))
+#define alloc_mayday_mask(maskp, gfp)		zalloc_cpumask_var((maskp), (gfp))
 #define free_mayday_mask(mask)			free_cpumask_var((mask))
 #else
 typedef unsigned long mayday_mask_t;
@@ -940,10 +941,14 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	struct global_cwq *gcwq;
 	struct cpu_workqueue_struct *cwq;
 	struct list_head *worklist;
+	unsigned int work_flags;
 	unsigned long flags;

 	debug_work_activate(work);

+	if (WARN_ON_ONCE(wq->flags & WQ_DYING))
+		return;
+
 	/* determine gcwq to use */
 	if (!(wq->flags & WQ_UNBOUND)) {
 		struct global_cwq *last_gcwq;
@@ -986,14 +991,17 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	BUG_ON(!list_empty(&work->entry));

 	cwq->nr_in_flight[cwq->work_color]++;
+	work_flags = work_color_to_flags(cwq->work_color);

 	if (likely(cwq->nr_active < cwq->max_active)) {
 		cwq->nr_active++;
 		worklist = gcwq_determine_ins_pos(gcwq, cwq);
-	} else
+	} else {
+		work_flags |= WORK_STRUCT_DELAYED;
 		worklist = &cwq->delayed_works;
+	}

-	insert_work(cwq, work, worklist, work_color_to_flags(cwq->work_color));
+	insert_work(cwq, work, worklist, work_flags);

 	spin_unlock_irqrestore(&gcwq->lock, flags);
 }
@@ -1212,6 +1220,7 @@ static void worker_leave_idle(struct worker *worker)
  * bound), %false if offline.
  */
 static bool worker_maybe_bind_and_lock(struct worker *worker)
+__acquires(&gcwq->lock)
 {
 	struct global_cwq *gcwq = worker->gcwq;
 	struct task_struct *task = worker->task;
@@ -1485,6 +1494,8 @@ static void gcwq_mayday_timeout(unsigned long __gcwq)
  * otherwise.
  */
 static bool maybe_create_worker(struct global_cwq *gcwq)
+__releases(&gcwq->lock)
+__acquires(&gcwq->lock)
 {
 	if (!need_to_create_worker(gcwq))
 		return false;
@@ -1659,6 +1670,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 	struct list_head *pos = gcwq_determine_ins_pos(cwq->gcwq, cwq);

 	move_linked_works(work, pos, NULL);
+	__clear_bit(WORK_STRUCT_DELAYED_BIT, work_data_bits(work));
 	cwq->nr_active++;
 }

@@ -1666,6 +1678,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
  * @color: color of work which left the queue
+ * @delayed: for a delayed work
  *
  * A work either has completed or is removed from pending queue,
  * decrement nr_in_flight of its cwq and handle workqueue flushing.
@@ -1673,19 +1686,22 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
  * CONTEXT:
  * spin_lock_irq(gcwq->lock).
  */
-static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
+static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
+				 bool delayed)
 {
 	/* ignore uncolored works */
 	if (color == WORK_NO_COLOR)
 		return;

 	cwq->nr_in_flight[color]--;
-	cwq->nr_active--;

-	if (!list_empty(&cwq->delayed_works)) {
-		/* one down, submit a delayed one */
-		if (cwq->nr_active < cwq->max_active)
-			cwq_activate_first_delayed(cwq);
+	if (!delayed) {
+		cwq->nr_active--;
+		if (!list_empty(&cwq->delayed_works)) {
+			/* one down, submit a delayed one */
+			if (cwq->nr_active < cwq->max_active)
+				cwq_activate_first_delayed(cwq);
+		}
 	}

 	/* is flush in progress and are we at the flushing tip? */
@@ -1722,6 +1738,8 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
  * spin_lock_irq(gcwq->lock) which is released and regrabbed.
  */
 static void process_one_work(struct worker *worker, struct work_struct *work)
+__releases(&gcwq->lock)
+__acquires(&gcwq->lock)
 {
 	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
 	struct global_cwq *gcwq = cwq->gcwq;
@@ -1814,7 +1832,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	hlist_del_init(&worker->hentry);
 	worker->current_work = NULL;
 	worker->current_cwq = NULL;
-	cwq_dec_nr_in_flight(cwq, work_color);
+	cwq_dec_nr_in_flight(cwq, work_color, false);
 }

 /**
@@ -2379,7 +2397,8 @@ static int try_to_grab_pending(struct work_struct *work)
 			debug_work_deactivate(work);
 			list_del_init(&work->entry);
 			cwq_dec_nr_in_flight(get_work_cwq(work),
-					     get_work_color(work));
+				get_work_color(work),
+				*work_data_bits(work) & WORK_STRUCT_DELAYED);
 			ret = 1;
 		}
 	}
@@ -2782,7 +2801,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 		if (IS_ERR(rescuer->task))
 			goto err;

-		wq->rescuer = rescuer;
 		rescuer->task->flags |= PF_THREAD_BOUND;
 		wake_up_process(rescuer->task);
 	}
@@ -2824,6 +2842,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 {
 	unsigned int cpu;

+	wq->flags |= WQ_DYING;
 	flush_workqueue(wq);

 	/*
@@ -2848,6 +2867,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	if (wq->flags & WQ_RESCUER) {
 		kthread_stop(wq->rescuer->task);
 		free_mayday_mask(wq->mayday_mask);
+		kfree(wq->rescuer);
 	}

 	free_cwqs(wq);
@@ -3230,6 +3250,8 @@ static int __cpuinit trustee_thread(void *__gcwq)
  * multiple times.  To be used by cpu_callback.
  */
 static void __cpuinit wait_trustee_state(struct global_cwq *gcwq, int state)
+__releases(&gcwq->lock)
+__acquires(&gcwq->lock)
 {
 	if (!(gcwq->trustee_state == state ||
 	      gcwq->trustee_state == TRUSTEE_DONE)) {
@@ -3536,8 +3558,7 @@ static int __init init_workqueues(void)
 		spin_lock_init(&gcwq->lock);
 		INIT_LIST_HEAD(&gcwq->worklist);
 		gcwq->cpu = cpu;
-		if (cpu == WORK_CPU_UNBOUND)
-			gcwq->flags |= GCWQ_DISASSOCIATED;
+		gcwq->flags |= GCWQ_DISASSOCIATED;

 		INIT_LIST_HEAD(&gcwq->idle_list);
 		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
@@ -3561,6 +3582,8 @@ static int __init init_workqueues(void)
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct worker *worker;

+		if (cpu != WORK_CPU_UNBOUND)
+			gcwq->flags &= ~GCWQ_DISASSOCIATED;
 		worker = create_worker(gcwq, true);
 		BUG_ON(!worker);
 		spin_lock_irq(&gcwq->lock);
