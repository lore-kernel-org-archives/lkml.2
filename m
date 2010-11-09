Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0KISBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:01:46 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39734 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab0KISBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:01:43 -0500
Subject: Re: Q: perf_event && event->owner
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101109174219.GA8279@redhat.com>
References: <20101108145647.GA3426@redhat.com>
	 <20101108145754.GB3434@redhat.com> <20101108201108.GA6777@nowhere>
	 <20101109155714.GA1903@redhat.com> <1289321804.2191.57.camel@laptop>
	 <20101109165805.GA6971@redhat.com> <1289322469.2191.59.camel@laptop>
	 <20101109174219.GA8279@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Nov 2010 19:01:43 +0100
Message-ID: <1289325703.2191.60.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 18:42 +0100, Oleg Nesterov wrote:
> On 11/09, Peter Zijlstra wrote:
> >
> > Ah,.. quite so. So how about we explicitly destroy the list when the
> > task dies?
> 
> Yes, I think it makes sense to destroy the list and set ->owner = NULL.
> If we reset the owner, we can also avoid get_task_struct().
> 
> The only problem is perf_event_release_kernel(), it can race with the
> exiting event->owner. It can do get_task_struct() under rcu lock temporary,
> just to take the mutex and remove the entry.
> 
> > > And ptrace(), it doesn't use sys_perf_event_open() to create the event.
> >
> > Right, I guess it uses kernel based things, I guess we could not add
> > kernel based counters to the list.
> 
> Agreed, another case when event->owner should be NULL.
> 
> 
> 
> Hmm. With or without these changes. Shouldn't perf_event_release_kernel()
> remove the event from list before anything else? Otherwise, afaics a thread
> which does close(event_fd) can race with creator doing prctl(EVENTS_ENABLE),
> no?

I think you're right, how about something like this?

---
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2234,11 +2234,6 @@ int perf_event_release_kernel(struct per
 	raw_spin_unlock_irq(&ctx->lock);
 	mutex_unlock(&ctx->mutex);
 
-	mutex_lock(&event->owner->perf_event_mutex);
-	list_del_init(&event->owner_entry);
-	mutex_unlock(&event->owner->perf_event_mutex);
-	put_task_struct(event->owner);
-
 	free_event(event);
 
 	return 0;
@@ -2254,6 +2249,12 @@ static int perf_release(struct inode *in
 
 	file->private_data = NULL;
 
+	if (event->owner) {
+		mutex_lock(&event->owner->perf_event_mutex);
+		list_del_init(&event->owner_entry);
+		mutex_unlock(&event->owner->perf_event_mutex);
+	}
+
 	return perf_event_release_kernel(event);
 }
 
@@ -5677,7 +5678,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_unlock(&ctx->mutex);
 
 	event->owner = current;
-	get_task_struct(current);
+
 	mutex_lock(&current->perf_event_mutex);
 	list_add_tail(&event->owner_entry, &current->perf_event_list);
 	mutex_unlock(&current->perf_event_mutex);
@@ -5745,12 +5746,6 @@ perf_event_create_kernel_counter(struct 
 	++ctx->generation;
 	mutex_unlock(&ctx->mutex);
 
-	event->owner = current;
-	get_task_struct(current);
-	mutex_lock(&current->perf_event_mutex);
-	list_add_tail(&event->owner_entry, &current->perf_event_list);
-	mutex_unlock(&current->perf_event_mutex);
-
 	return event;
 
 err_free:
@@ -5901,8 +5896,16 @@ static void perf_event_exit_task_context
  */
 void perf_event_exit_task(struct task_struct *child)
 {
+	struct perf_event *event, *tmp;
 	int ctxn;
 
+	mutex_lock(&child->perf_event_mutex);
+	list_for_each_entry_safe(event, tmp, &child->perf_event_list,
+				 owner_entry) {
+		list_del_init(&event->owner_entry);
+	}
+	mutex_unlock(&child->perf_event_mutex);
+
 	for_each_task_context_nr(ctxn)
 		perf_event_exit_task_context(child, ctxn);
 }

