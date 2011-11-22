Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1KVVPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:15:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57043 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1KVVPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:15:49 -0500
Message-ID: <1321996541.14799.23.camel@twins>
Subject: Re: [PATCH] perf_event: fix loss of notification with multi-event
 sampling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Tue, 22 Nov 2011 22:15:41 +0100
In-Reply-To: <CABPqkBT+XT4Oq9p0aquJgFZy8DBVudamFU4jRZqmdLUDR-Cpqg@mail.gmail.com>
References: <20111116145320.GA20146@quad> <1321958457.5148.17.camel@twins>
	 <CABPqkBT-ZPZC2Ku6NjyMygWUU+kMr3h9FCdKTAjvhR6ywFmNqw@mail.gmail.com>
	 <1321968559.14799.2.camel@twins>
	 <CABPqkBQLvZ1VY6Xn+X2Tw_+dXvfZe8zqvqqyLVuBpkjNYOVuyA@mail.gmail.com>
	 <CABPqkBT+XT4Oq9p0aquJgFZy8DBVudamFU4jRZqmdLUDR-Cpqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the only thing I can seem to come up with is something like the below
and uglier..

the below isn't compiled and I suspect there's still a race between poll
and perf_event_set_output() which we could plug by taking mmap_mutex in
perf_poll() but that'd be cheating..

also, yuck!

---
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -833,6 +833,7 @@ struct perf_event {
 	struct ring_buffer		*rb;
 
 	/* poll related */
+	struct list_head		rb_entry;
 	wait_queue_head_t		waitq;
 	struct fasync_struct		*fasync;
 
Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -3014,8 +3014,10 @@ static unsigned int perf_poll(struct fil
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
-	if (rb)
+	if (rb) {
+		ring_buffer_attach(event, rb);
 		events = atomic_xchg(&rb->poll, 0);
+	}
 	rcu_read_unlock();
 
 	poll_wait(file, &event->waitq, wait);
@@ -3321,6 +3323,47 @@ static int perf_mmap_fault(struct vm_are
 	return ret;
 }
 
+static void ring_buffer_attach(struct perf_event *event, struct ring_buffer *rb)
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
+	list_add(&event->rb_entry, rb->event_list);
+unlock:
+	spin_unlock_irqrestore(&rb->event_lock, flags);
+}
+
+static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
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
+	list_for_each_entry_rcu(event, rb->event_list, rb_entry) {
+		wake_up_all(!event->waitq);
+	}
+	rcu_read_unlock();
+}
+
 static void rb_free_rcu(struct rcu_head *rcu_head)
 {
 	struct ring_buffer *rb;
@@ -3346,9 +3389,19 @@ static struct ring_buffer *ring_buffer_g
 
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
 
@@ -3371,6 +3424,7 @@ static void perf_mmap_close(struct vm_ar
 		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
 		vma->vm_mm->pinned_vm -= event->mmap_locked;
 		rcu_assign_pointer(event->rb, NULL);
+		ring_buffer_detach(event, rb);
 		mutex_unlock(&event->mmap_mutex);
 
 		ring_buffer_put(rb);
@@ -3527,7 +3581,7 @@ static const struct file_operations perf
 
 void perf_event_wakeup(struct perf_event *event)
 {
-	wake_up_all(&event->waitq);
+	ring_buffer_wakeup(event);
 
 	if (event->pending_kill) {
 		kill_fasync(&event->fasync, SIGIO, event->pending_kill);
@@ -5882,6 +5936,8 @@ perf_event_set_output(struct perf_event
 
 	old_rb = event->rb;
 	rcu_assign_pointer(event->rb, rb);
+	if (old_rb)
+		ring_buffer_detach(event, old_rb);
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
Index: linux-2.6/kernel/events/internal.h
===================================================================
--- linux-2.6.orig/kernel/events/internal.h
+++ linux-2.6/kernel/events/internal.h
@@ -27,6 +27,10 @@ struct ring_buffer {
 
 	long				watermark;	/* wakeup watermark  */
 
+	/* poll crap */
+	spinlock_t			event_lock;
+	struct list_struct		event_list;
+
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
 };

