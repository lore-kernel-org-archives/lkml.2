Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1LENQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:16:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab1LENQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:16:27 -0500
Date: Mon, 5 Dec 2011 05:16:01 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-10c6db110d0eb4466b59812c49088ab56218fc2e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111126014731.GA7030@quad>
References: <20111126014731.GA7030@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix loss of notification with multi-event
Git-Commit-ID: 10c6db110d0eb4466b59812c49088ab56218fc2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:16:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10c6db110d0eb4466b59812c49088ab56218fc2e
Gitweb:     http://git.kernel.org/tip/10c6db110d0eb4466b59812c49088ab56218fc2e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 26 Nov 2011 02:47:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 09:33:03 +0100

perf: Fix loss of notification with multi-event

When you do:
        $ perf record -e cycles,cycles,cycles noploop 10

You expect about 10,000 samples for each event, i.e., 10s at
1000samples/sec. However, this is not what's happening. You
get much fewer samples, maybe 3700 samples/event:

$ perf report -D | tail -15
Aggregated stats:
           TOTAL events:      10998
            MMAP events:         66
            COMM events:          2
          SAMPLE events:      10930
cycles stats:
           TOTAL events:       3644
          SAMPLE events:       3644
cycles stats:
           TOTAL events:       3642
          SAMPLE events:       3642
cycles stats:
           TOTAL events:       3644
          SAMPLE events:       3644

On a Intel Nehalem or even AMD64, there are 4 counters capable
of measuring cycles, so there is plenty of space to measure those
events without multiplexing (even with the NMI watchdog active).
And even with multiplexing, we'd expect roughly the same number
of samples per event.

The root of the problem was that when the event that caused the buffer
to become full was not the first event passed on the cmdline, the user
notification would get lost. The notification was sent to the file
descriptor of the overflowed event but the perf tool was not polling
on it.  The perf tool aggregates all samples into a single buffer,
i.e., the buffer of the first event. Consequently, it assumes
notifications for any event will come via that descriptor.

The seemingly straight forward solution of moving the waitq into the
ringbuffer object doesn't work because of life-time issues. One could
perf_event_set_output() on a fd that you're also blocking on and cause
the old rb object to be freed while its waitq would still be
referenced by the blocked thread -> FAIL.

Therefore link all events to the ringbuffer and broadcast the wakeup
from the ringbuffer object to all possible events that could be waited
upon. This is rather ugly, and we're open to better solutions but it
works for now.

Reported-by: Stephane Eranian <eranian@google.com>
Finished-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111126014731.GA7030@quad
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h  |    1 +
 kernel/events/core.c        |   86 ++++++++++++++++++++++++++++++++++++++++++-
 kernel/events/internal.h    |    3 +
 kernel/events/ring_buffer.c |    3 +
 4 files changed, 91 insertions(+), 2 deletions(-)

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
index b0c1186..600c162 100644
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
@@ -3191,12 +3194,33 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	struct ring_buffer *rb;
 	unsigned int events = POLL_HUP;
 
+	/*
+	 * Race between perf_event_set_output() and perf_poll(): perf_poll()
+	 * grabs the rb reference but perf_event_set_output() overrides it.
+	 * Here is the timeline for two threads T1, T2:
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
@@ -3497,6 +3521,49 @@ unlock:
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
@@ -3522,9 +3589,19 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 
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
 
@@ -3547,6 +3624,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
 		vma->vm_mm->pinned_vm -= event->mmap_locked;
 		rcu_assign_pointer(event->rb, NULL);
+		ring_buffer_detach(event, rb);
 		mutex_unlock(&event->mmap_mutex);
 
 		ring_buffer_put(rb);
@@ -3701,7 +3779,7 @@ static const struct file_operations perf_fops = {
 
 void perf_event_wakeup(struct perf_event *event)
 {
-	wake_up_all(&event->waitq);
+	ring_buffer_wakeup(event);
 
 	if (event->pending_kill) {
 		kill_fasync(&event->fasync, SIGIO, event->pending_kill);
@@ -5823,6 +5901,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->group_entry);
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
+	INIT_LIST_HEAD(&event->rb_entry);
+
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
 
@@ -6029,6 +6109,8 @@ set:
 
 	old_rb = event->rb;
 	rcu_assign_pointer(event->rb, rb);
+	if (old_rb)
+		ring_buffer_detach(event, old_rb);
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 09097dd..64568a6 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -22,6 +22,9 @@ struct ring_buffer {
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
