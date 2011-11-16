Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab1KPOx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:53:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32769 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab1KPOxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:53:25 -0500
Date: Wed, 16 Nov 2011 15:53:20 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu
Subject: [PATCH] perf_event: fix loss of notification with multi-event
 sampling
Message-ID: <20111116145320.GA20146@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
on it.  The perf tool aggregates all samples into a single buffer, i.e.,
the buffer of the first event. Consequently, it assumes notifications
for any event will come via that descriptor.

One can discuss the ABI on this particular problem. It would seem natural
that if a tool aggregates all samples into a single buffer, it would expect
notifications to come on the file descriptor to which the buffer is bound.
The alternative approach would be to still poll on all the descriptors,
despite the aggregation. Perf is written assuming the former which seems
reasonable. Therefore let's fix the kernel.

The patch fixes this problem by moving the waitq into the ring_buffer
so it can be shared between the 'aggregated' events. The buffer is removed
only when the last event is destroyed. Therefore, we don't need extra ref
counting. The notification only needs the waitq.

With the patch, we get:
$ perf report -D | tail -20
Aggregated stats:
           TOTAL events:      30100
            MMAP events:         80
            COMM events:          2
            EXIT events:          2
          SAMPLE events:      30016
cycles stats:
           TOTAL events:      10014
            MMAP events:          5
            COMM events:          1
            EXIT events:          2
          SAMPLE events:      10006
cycles stats:
           TOTAL events:      10005
          SAMPLE events:      10005
cycles stats:
           TOTAL events:      10005
          SAMPLE events:      10005

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1e9ebe5..c9e2108 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -823,10 +823,11 @@ struct perf_event {
 	struct user_struct		*mmap_user;
 	struct ring_buffer		*rb;
 
-	/* poll related */
-	wait_queue_head_t		waitq;
+	/* ring_buffer waitq pointer */
+	wait_queue_head_t		*waitq;
 	struct fasync_struct		*fasync;
 
+
 	/* delayed work for NMIs and such */
 	int				pending_wakeup;
 	int				pending_kill;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2e41c8e..e1dd7a0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2754,6 +2754,7 @@ static void free_event(struct perf_event *event)
 	if (event->rb) {
 		ring_buffer_put(event->rb);
 		event->rb = NULL;
+		event->waitq = NULL;
 	}
 
 	if (is_cgroup_event(event))
@@ -2990,7 +2991,9 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 		events = atomic_xchg(&rb->poll, 0);
 	rcu_read_unlock();
 
-	poll_wait(file, &event->waitq, wait);
+	/* rb==NULL => waitq=NULL */
+	if (event->waitq)
+		poll_wait(file, event->waitq, wait);
 
 	return events;
 }
@@ -3440,6 +3443,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		ret = -ENOMEM;
 		goto unlock;
 	}
+	event->waitq = &rb->waitq;
 	rcu_assign_pointer(event->rb, rb);
 
 	atomic_long_add(user_extra, &user->locked_vm);
@@ -3494,7 +3498,8 @@ static const struct file_operations perf_fops = {
 
 void perf_event_wakeup(struct perf_event *event)
 {
-	wake_up_all(&event->waitq);
+	if (event->waitq)
+		wake_up_all(event->waitq);
 
 	if (event->pending_kill) {
 		kill_fasync(&event->fasync, SIGIO, event->pending_kill);
@@ -5621,7 +5626,6 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->group_entry);
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
-	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
 
 	mutex_init(&event->mmap_mutex);
@@ -5826,6 +5830,7 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	}
 
 	old_rb = event->rb;
+	event->waitq = output_event->waitq;
 	rcu_assign_pointer(event->rb, rb);
 	ret = 0;
 unlock:
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index be4a43f..2bf9546 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -19,6 +19,9 @@ struct ring_buffer {
 
 	atomic_t			poll;		/* POLL_ for wakeups */
 
+	/* poll related */
+	wait_queue_head_t		waitq;
+
 	local_t				head;		/* write position    */
 	local_t				nest;		/* nested writers    */
 	local_t				events;		/* event limit       */
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index a2a2920..ef4ea75 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -209,6 +209,7 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
 		rb->writable = 1;
 
 	atomic_set(&rb->refcount, 1);
+	init_waitqueue_head(&rb->waitq);
 }
 
 #ifndef CONFIG_PERF_USE_VMALLOC
