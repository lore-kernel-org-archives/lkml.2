Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab2HQQoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:44:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521Ab2HQQoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:44:20 -0400
Date: Fri, 17 Aug 2012 18:40:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: task_work_add() should not succeed unconditionally (Was: lockdep
	trace from posix timers)
Message-ID: <20120817164041.GA12017@redhat.com>
References: <20120724203613.GA9637@redhat.com> <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com> <20120817151747.GA8248@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817151747.GA8248@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Oleg Nesterov wrote:
>
> On 08/17, Oleg Nesterov wrote:
> >
> > On 08/16, Peter Zijlstra wrote:
> > >
> > >      write_lock_irq(&tasklist_lock)
> > >      task_lock(parent)		parent->alloc_lock
> >
> > And this is already wrong. See the comment above task_lock().
> >
> > > And since it_lock is IRQ-safe and alloc_lock isn't, you've got the IRQ
> > > inversion deadlock reported.
> >
> > Yes. Or, IOW, write_lock(tasklist) is IRQ-safe and thus it can't nest
> > with alloc_lock.
> >
> > > David, Al, anybody want to have a go at fixing this?
> >
> > I still think that task_work_add() should synhronize with exit_task_work()
> > itself and fail if necessary. But I wasn't able to convince Al ;)
>
> And this is my old patch: http://marc.info/?l=linux-kernel&m=134082268721700
> It should be re-diffed of course.

Something like below. Uncompiled/untested, I need to re-check and test.
Now we can remove that task_lock() and rely on task_work_add().

Al, what do you think?

Oleg.

--- x/include/linux/task_work.h
+++ x/include/linux/task_work.h
@@ -18,8 +18,7 @@ void task_work_run(void);
 
 static inline void exit_task_work(struct task_struct *task)
 {
-	if (unlikely(task->task_works))
-		task_work_run();
+	task_work_run();
 }
 
 #endif	/* _LINUX_TASK_WORK_H */
--- x/kernel/task_work.c
+++ x/kernel/task_work.c
@@ -2,29 +2,35 @@
 #include <linux/task_work.h>
 #include <linux/tracehook.h>
 
+#define TWORK_EXITED	((struct callback_head *)1)
+
 int
 task_work_add(struct task_struct *task, struct callback_head *twork, bool notify)
 {
 	struct callback_head *last, *first;
 	unsigned long flags;
+	int err = -ESRCH;
 
 	/*
-	 * Not inserting the new work if the task has already passed
-	 * exit_task_work() is the responisbility of callers.
+	 * We must not insert the new work if the exiting task has already
+	 * passed task_work_run().
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	last = task->task_works;
-	first = last ? last->next : twork;
-	twork->next = first;
-	if (last)
-		last->next = twork;
-	task->task_works = twork;
+	if (likely(task->task_works != TWORK_EXITED) {
+		last = task->task_works;
+		first = last ? last->next : twork;
+		twork->next = first;
+		if (last)
+			last->next = twork;
+		task->task_works = twork;
+		err = 0;
+	}
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
 	/* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
-	if (notify)
+	if (!err && notify)
 		set_notify_resume(task);
-	return 0;
+	return err;
 }
 
 struct callback_head *
@@ -35,7 +41,7 @@ task_work_cancel(struct task_struct *tas
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	last = task->task_works;
-	if (last) {
+	if (last && last != TWORK_EXITED) {
 		struct callback_head *q = last, *p = q->next;
 		while (1) {
 			if (p->func == func) {
@@ -63,7 +69,12 @@ void task_work_run(void)
 	while (1) {
 		raw_spin_lock_irq(&task->pi_lock);
 		p = task->task_works;
-		task->task_works = NULL;
+		/*
+		 * twork->func() can do task_work_add(), do not
+		 * set TWORK_EXITED until the list becomes empty.
+		 */
+		task->task_works = (!p && (task->flags & PF_EXITING))
+					? TWORK_EXITED : NULL;
 		raw_spin_unlock_irq(&task->pi_lock);
 
 		if (unlikely(!p))

