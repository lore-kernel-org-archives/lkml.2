Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1KZBrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 20:47:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60242 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1KZBrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 20:47:31 -0500
Date: Sat, 26 Nov 2011 02:47:31 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu
Subject: Re: [PATCH] perf_event: fix loss of notification with multi-event
Message-ID: <20111126014731.GA7030@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is a fixed version of Peter's patch.
I fixed the compilation errors + added the missing
linked list + spinlock initializations.

I also added the mmap_mutex in perf_poll() to avoid the
race with perf_set_output(). It's not pretty but it solves
the problem of a process getting stuck on a sampling buffer
which is never going to get any samples. This was an unlikely
scenario but we should take care of it anyway.

This patch solves the issue with loss of buffer notifications
when sampling on multiple events at the same time. In that
case fewer than expected samples would be captured.

Reviewed-by: Stephane Eranian <eranian@google.com>

---

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1e9ebe5..b1f8912 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -822,6 +822,7 @@ struct perf_event {
 	int				mmap_locked;
 	struct user_struct		*mmap_user;
 	struct ring_buffer		*rb;
+	struct list_head		rb_entry;
 
 	/* poll related */
 	wait_queue_head_t		waitq;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2e41c8e..7d319ea 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -185,6 +185,9 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 static void update_context_time(struct perf_event_context *ctx);
 static u64 perf_event_time(struct perf_event *event);
 
+static void ring_buffer_attach(struct perf_event *event,
+			       struct ring_buffer *rb);
+
 void __weak perf_event_print_debug(void)	{ }
 
 extern __weak const char *perf_pmu_name(void)
@@ -2984,12 +2987,33 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	struct ring_buffer *rb;
 	unsigned int events = POLL_HUP;
 
+	/*
+	 * Race between perf_set_output() and perf_poll():
+	 * perf_poll() grabs the rb reference but perf_set_output()
+	 * overrides it. Here is the timeline for two threads T1, T2:
+	 * t0: T1, rb = rcu_dereference(event->rb)
+	 * t1: T2, old_rb = event->rb
+	 * t2: T2, event->rb = new rb
+	 * t3: T2, ring_buffer_detach(old_rb)
+	 * t4: T1, ring_buffer_attach(rb1)
+	 * t5: T1, poll_wait(event->waitq)
+	 *
+	 * To avoid this problem, we grab mmap_mutex in perf_poll()
+	 * thereby ensuring that the assignment of the new ring buffer
+	 * and the detachment of the old buffer appear atomic to perf_poll()
+	 */
+	mutex_lock(&event->mmap_mutex);
+
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
-	if (rb)
+	if (rb) {
+		ring_buffer_attach(event, rb);
 		events = atomic_xchg(&rb->poll, 0);
+	}
 	rcu_read_unlock();
 
+	mutex_unlock(&event->mmap_mutex);
+
 	poll_wait(file, &event->waitq, wait);
 
 	return events;
@@ -3290,6 +3314,49 @@ unlock:
 	return ret;
 }
 
+static void ring_buffer_attach(struct perf_event *event,
+			       struct ring_buffer *rb)
+{
+	unsigned long flags;
+
+	if (!list_empty(&event->rb_entry))
+		return;
+
+	spin_lock_irqsave(&rb->event_lock, flags);
+	if (!list_empty(&event->rb_entry))
+		goto unlock;
+
+	list_add(&event->rb_entry, &rb->event_list);
+unlock:
+	spin_unlock_irqrestore(&rb->event_lock, flags);
+}
+
+static void ring_buffer_detach(struct perf_event *event,
+			       struct ring_buffer *rb)
+{
+	unsigned long flags;
+
+	if (list_empty(&event->rb_entry))
+		return;
+
+	spin_lock_irqsave(&rb->event_lock, flags);
+	list_del_init(&event->rb_entry);
+	wake_up_all(&event->waitq);
+	spin_unlock_irqrestore(&rb->event_lock, flags);
+}
+
+static void ring_buffer_wakeup(struct perf_event *event)
+{
+	struct ring_buffer *rb;
+
+	rcu_read_lock();
+	rb = rcu_dereference(event->rb);
+	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
+		wake_up_all(&event->waitq);
+	}
+	rcu_read_unlock();
+}
+
 static void rb_free_rcu(struct rcu_head *rcu_head)
 {
 	struct ring_buffer *rb;
@@ -3315,9 +3382,19 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 
 static void ring_buffer_put(struct ring_buffer *rb)
 {
+	struct perf_event *event, *n;
+	unsigned long flags;
+
 	if (!atomic_dec_and_test(&rb->refcount))
 		return;
 
+	spin_lock_irqsave(&rb->event_lock, flags);
+	list_for_each_entry_safe(event, n, &rb->event_list, rb_entry) {
+		list_del_init(&event->rb_entry);
+		wake_up_all(&event->waitq);
+	}
+	spin_unlock_irqrestore(&rb->event_lock, flags);
+
 	call_rcu(&rb->rcu_head, rb_free_rcu);
 }
 
@@ -3340,6 +3417,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
 		vma->vm_mm->pinned_vm -= event->mmap_locked;
 		rcu_assign_pointer(event->rb, NULL);
+		ring_buffer_detach(event, rb);
 		mutex_unlock(&event->mmap_mutex);
 
 		ring_buffer_put(rb);
@@ -3494,7 +3572,7 @@ static const struct file_operations perf_fops = {
 
 void perf_event_wakeup(struct perf_event *event)
 {
-	wake_up_all(&event->waitq);
+	ring_buffer_wakeup(event);
 
 	if (event->pending_kill) {
 		kill_fasync(&event->fasync, SIGIO, event->pending_kill);
@@ -5621,6 +5699,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->group_entry);
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
+	INIT_LIST_HEAD(&event->rb_entry);
+
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
 
@@ -5827,6 +5907,8 @@ set:
 
 	old_rb = event->rb;
 	rcu_assign_pointer(event->rb, rb);
+	if (old_rb)
+		ring_buffer_detach(event, old_rb);
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index be4a43f..b0b107f 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -26,6 +26,9 @@ struct ring_buffer {
 	local_t				lost;		/* nr records lost   */
 
 	long				watermark;	/* wakeup watermark  */
+	/* poll crap */
+	spinlock_t			event_lock;
+	struct list_head		event_list;
 
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index a2a2920..7f3011c 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -209,6 +209,9 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
 		rb->writable = 1;
 
 	atomic_set(&rb->refcount, 1);
+
+	INIT_LIST_HEAD(&rb->event_list);
+	spin_lock_init(&rb->event_lock);
 }
 
 #ifndef CONFIG_PERF_USE_VMALLOC
