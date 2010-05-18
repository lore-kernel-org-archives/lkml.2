Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab0ERNqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:46:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:54183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab0ERNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:46:45 -0400
Message-Id: <20100518133725.963596631@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 18 May 2010 15:33:00 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/5] perf: Remove IRQ-disable from the perf_output path
References: <20100518133258.000434886@chello.nl>
Content-Disposition: inline; filename=perf-buffer-no-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we can now assume there is only a single writer to each buffer,
we can remove per-cpu lock thingy and use a simply nest-count to the
same effect.

This removes the need to disable IRQs.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    5 --
 kernel/perf_event.c        |   94 +++++++++++++--------------------------------
 2 files changed, 30 insertions(+), 69 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -597,12 +597,12 @@ struct perf_mmap_data {
 	atomic_t			events;		/* event_id limit       */
 
 	atomic_long_t			head;		/* write position    */
-	atomic_long_t			done_head;	/* completed head    */
 
-	atomic_t			lock;		/* concurrent writes */
 	atomic_t			wakeup;		/* needs a wakeup    */
 	atomic_t			lost;		/* nr records lost   */
 
+	atomic_t			nest;		/* nested writers    */
+
 	long				watermark;	/* wakeup watermark  */
 
 	struct perf_event_mmap_page	*user_page;
@@ -807,7 +807,6 @@ struct perf_output_handle {
 	unsigned long			offset;
 	int				nmi;
 	int				sample;
-	int				locked;
 };
 
 #ifdef CONFIG_PERF_EVENTS
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2519,8 +2519,6 @@ perf_mmap_data_init(struct perf_event *e
 {
 	long max_size = perf_data_size(data);
 
-	atomic_set(&data->lock, -1);
-
 	if (event->attr.watermark) {
 		data->watermark = min_t(long, max_size,
 					event->attr.wakeup_watermark);
@@ -2906,82 +2904,56 @@ static void perf_output_wakeup(struct pe
 }
 
 /*
- * Curious locking construct.
- *
  * We need to ensure a later event_id doesn't publish a head when a former
- * event_id isn't done writing. However since we need to deal with NMIs we
+ * event isn't done writing. However since we need to deal with NMIs we
  * cannot fully serialize things.
  *
- * What we do is serialize between CPUs so we only have to deal with NMI
- * nesting on a single CPU.
- *
  * We only publish the head (and generate a wakeup) when the outer-most
- * event_id completes.
+ * event completes.
  */
-static void perf_output_lock(struct perf_output_handle *handle)
+static void perf_output_get_handle(struct perf_output_handle *handle)
 {
 	struct perf_mmap_data *data = handle->data;
-	int cur, cpu = get_cpu();
-
-	handle->locked = 0;
-
-	for (;;) {
-		cur = atomic_cmpxchg(&data->lock, -1, cpu);
-		if (cur == -1) {
-			handle->locked = 1;
-			break;
-		}
-		if (cur == cpu)
-			break;
 
-		cpu_relax();
-	}
+	preempt_disable();
+	atomic_inc(&data->nest);
 }
 
-static void perf_output_unlock(struct perf_output_handle *handle)
+static void perf_output_put_handle(struct perf_output_handle *handle)
 {
 	struct perf_mmap_data *data = handle->data;
 	unsigned long head;
-	int cpu;
-
-	data->done_head = data->head;
-
-	if (!handle->locked)
-		goto out;
 
 again:
-	/*
-	 * The xchg implies a full barrier that ensures all writes are done
-	 * before we publish the new head, matched by a rmb() in userspace when
-	 * reading this position.
-	 */
-	while ((head = atomic_long_xchg(&data->done_head, 0)))
-		data->user_page->data_head = head;
+	head = atomic_long_read(&data->head);
 
 	/*
-	 * NMI can happen here, which means we can miss a done_head update.
+	 * IRQ/NMI can happen here, which means we can miss a head update.
 	 */
 
-	cpu = atomic_xchg(&data->lock, -1);
-	WARN_ON_ONCE(cpu != smp_processor_id());
+	if (!atomic_dec_and_test(&data->nest))
+		return;
 
 	/*
-	 * Therefore we have to validate we did not indeed do so.
+	 * Publish the known good head. Rely on the full barrier implied
+	 * by atomic_dec_and_test() order the data->head read and this
+	 * write.
 	 */
-	if (unlikely(atomic_long_read(&data->done_head))) {
-		/*
-		 * Since we had it locked, we can lock it again.
-		 */
-		while (atomic_cmpxchg(&data->lock, -1, cpu) != -1)
-			cpu_relax();
+	data->user_page->data_head = head;
 
+	/*
+	 * Now check if we missed an update, rely on the (compiler)
+	 * barrier in atomic_dec_and_test() to re-read data->head.
+	 */
+	if (unlikely(head != atomic_long_read(&data->head))) {
+		atomic_inc(&data->nest);
 		goto again;
 	}
 
 	if (atomic_xchg(&data->wakeup, 0))
 		perf_output_wakeup(handle);
-out:
-	put_cpu();
+
+	preempt_enable();
 }
 
 void perf_output_copy(struct perf_output_handle *handle,
@@ -3063,7 +3035,7 @@ int perf_output_begin(struct perf_output
 	if (have_lost)
 		size += sizeof(lost_event);
 
-	perf_output_lock(handle);
+	perf_output_get_handle(handle);
 
 	do {
 		/*
@@ -3083,7 +3055,7 @@ int perf_output_begin(struct perf_output
 	handle->head	= head;
 
 	if (head - tail > data->watermark)
-		atomic_set(&data->wakeup, 1);
+		atomic_inc(&data->wakeup);
 
 	if (have_lost) {
 		lost_event.header.type = PERF_RECORD_LOST;
@@ -3099,7 +3071,7 @@ int perf_output_begin(struct perf_output
 
 fail:
 	atomic_inc(&data->lost);
-	perf_output_unlock(handle);
+	perf_output_put_handle(handle);
 out:
 	rcu_read_unlock();
 
@@ -3117,11 +3089,11 @@ void perf_output_end(struct perf_output_
 		int events = atomic_inc_return(&data->events);
 		if (events >= wakeup_events) {
 			atomic_sub(wakeup_events, &data->events);
-			atomic_set(&data->wakeup, 1);
+			atomic_inc(&data->wakeup);
 		}
 	}
 
-	perf_output_unlock(handle);
+	perf_output_put_handle(handle);
 	rcu_read_unlock();
 }
 
@@ -3457,22 +3429,13 @@ static void perf_event_task_output(struc
 {
 	struct perf_output_handle handle;
 	struct task_struct *task = task_event->task;
-	unsigned long flags;
 	int size, ret;
 
-	/*
-	 * If this CPU attempts to acquire an rq lock held by a CPU spinning
-	 * in perf_output_lock() from interrupt context, it's game over.
-	 */
-	local_irq_save(flags);
-
 	size  = task_event->event_id.header.size;
 	ret = perf_output_begin(&handle, event, size, 0, 0);
 
-	if (ret) {
-		local_irq_restore(flags);
+	if (ret)
 		return;
-	}
 
 	task_event->event_id.pid = perf_event_pid(event, task);
 	task_event->event_id.ppid = perf_event_pid(event, current);
@@ -3483,7 +3446,6 @@ static void perf_event_task_output(struc
 	perf_output_put(&handle, task_event->event_id);
 
 	perf_output_end(&handle);
-	local_irq_restore(flags);
 }
 
 static int perf_event_task_match(struct perf_event *event)


