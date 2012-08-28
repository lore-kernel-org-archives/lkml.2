Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2H1Q3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:29:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42591 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2H1Q3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:29:10 -0400
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20120824185619.GA16719@redhat.com>
References: <1345463081.23018.34.camel@twins>
	 <20120820150507.GC18499@redhat.com> <1345475530.23018.50.camel@twins>
	 <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins>
	 <20120820161012.GC21400@redhat.com> <1345479590.23018.75.camel@twins>
	 <20120820162302.GA22354@redhat.com> <20120821182751.GA11243@redhat.com>
	 <20120821183408.GA11721@redhat.com>  <20120824185619.GA16719@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Aug 2012 18:29:02 +0200
Message-ID: <1346171342.2296.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-24 at 20:56 +0200, Oleg Nesterov wrote:
> 
> Peter, if you think it can work for you and if you agree with
> the implementation I will be happy to send the patch. 

Yeah I think it would work, but I'm not sure why you're introducing the
cmp_xchg helper just for this..

Anyway, how about something like the below, it pops the works one by one
when running, that way when the cancel will only return NULL when the
work is either being executed or already executed.

( And yeah, I know, its not FIFO ;-)

---
 include/linux/task_work.h |    7 +--
 kernel/exit.c             |    2 +-
 kernel/task_work.c        |  130 +++++++++++++++++++++++++--------------------
 3 files changed, 75 insertions(+), 64 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index fb46b03..f365416 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -15,11 +15,6 @@ init_task_work(struct callback_head *twork, task_work_func_t func)
 int task_work_add(struct task_struct *task, struct callback_head *twork, bool);
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
 void task_work_run(void);
-
-static inline void exit_task_work(struct task_struct *task)
-{
-	if (unlikely(task->task_works))
-		task_work_run();
-}
+void task_work_exit(void);
 
 #endif	/* _LINUX_TASK_WORK_H */
diff --git a/kernel/exit.c b/kernel/exit.c
index f65345f..92aa94b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -992,7 +992,7 @@ void do_exit(long code)
 	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
-	exit_task_work(tsk);
+	task_work_exit();
 	check_stack_usage();
 	exit_thread();
 
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 91d4e17..7767924 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -2,79 +2,95 @@
 #include <linux/task_work.h>
 #include <linux/tracehook.h>
 
+static void task_work_nop(struct callback_head *work)
+{
+}
+
+static struct callback_head dead = {
+	.next = NULL,
+	.func = task_work_nop,
+};
+
 int
-task_work_add(struct task_struct *task, struct callback_head *twork, bool notify)
+task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
-	struct callback_head *last, *first;
-	unsigned long flags;
-
-	/*
-	 * Not inserting the new work if the task has already passed
-	 * exit_task_work() is the responisbility of callers.
-	 */
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	last = task->task_works;
-	first = last ? last->next : twork;
-	twork->next = first;
-	if (last)
-		last->next = twork;
-	task->task_works = twork;
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	struct callback_head **head = &task->task_works;
+	struct callback_head *entry, *old_entry;
+
+	entry = *head;
+	for (;;) {
+		if (entry == &dead)
+			return -ESRCH;
+
+		old_entry = entry;
+		work->next = entry;
+		entry = cmpxchg(head, old_entry, work);
+		if (entry == old_entry)
+			break;
+	}
 
 	/* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
 	if (notify)
 		set_notify_resume(task);
+
 	return 0;
 }
 
 struct callback_head *
 task_work_cancel(struct task_struct *task, task_work_func_t func)
 {
-	unsigned long flags;
-	struct callback_head *last, *res = NULL;
-
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	last = task->task_works;
-	if (last) {
-		struct callback_head *q = last, *p = q->next;
-		while (1) {
-			if (p->func == func) {
-				q->next = p->next;
-				if (p == last)
-					task->task_works = q == p ? NULL : q;
-				res = p;
-				break;
-			}
-			if (p == last)
-				break;
-			q = p;
-			p = q->next;
+	struct callback_head **workp, *work;
+
+again:
+	workp = &task->task_works;
+	work = *workp;
+	while (work) {
+		if (work->func == func) {
+			if (cmpxchg(workp, work, work->next) == work)
+				return work;
+			goto again;
 		}
+
+		workp = &work->next;
+		work = *workp;
 	}
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-	return res;
+
+	return NULL;
 }
 
-void task_work_run(void)
+static callback_head *task_work_pop(void)
 {
-	struct task_struct *task = current;
-	struct callback_head *p, *q;
-
-	while (1) {
-		raw_spin_lock_irq(&task->pi_lock);
-		p = task->task_works;
-		task->task_works = NULL;
-		raw_spin_unlock_irq(&task->pi_lock);
-
-		if (unlikely(!p))
-			return;
-
-		q = p->next; /* head */
-		p->next = NULL; /* cut it */
-		while (q) {
-			p = q->next;
-			q->func(q);
-			q = p;
-		}
+	struct callback_head **head = &current->task_work;
+	struct callback_head *entry, *old_entry;
+
+	entry = *head;
+	for (;;) {
+		if (!entry || entry == &dead)
+			return NULL;
+
+		old_entry = entry;
+		entry = cmpxchg(head, entry, entry->next);
+		if (entry == old_entry)
+			break;
 	}
+
+	return entry;
+}
+
+void task_work_run(void)
+{
+	struct callback_head *work;
+
+	for (work = task_work_pop(); work; )
+		work->func(work);
+}
+
+void task_work_exit(void)
+{
+	struct callback_head **head = &current->task_works;
+
+again:
+	task_work_run();
+	if (cmpxchg(head, NULL, &dead) != NULL)
+		goto again;
 }


