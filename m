Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2HTLo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:44:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:50970 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2HTLov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:44:51 -0400
Message-ID: <1345463081.23018.34.camel@twins>
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Aug 2012 13:44:41 +0200
In-Reply-To: <1345446957.23018.14.camel@twins>
References: <20120724203613.GA9637@redhat.com>
	 <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
	 <1345446957.23018.14.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 09:15 +0200, Peter Zijlstra wrote:
> On Fri, 2012-08-17 at 17:14 +0200, Oleg Nesterov wrote:
> > I still think that task_work_add() should synhronize with exit_task_work()
> > itself and fail if necessary. But I wasn't able to convince Al ;)
> 
> I'm not at all sure how that relates to needing task_lock() in the
> keyctl stuff.
> 
> Also, can't task_work use llist stuff? That would also avoid using
> ->pi_lock.

How about something like the below?

---
 include/linux/task_work.h |   7 +--
 kernel/exit.c             |   2 +-
 kernel/task_work.c        | 120 ++++++++++++++++++++++++----------------------
 3 files changed, 65 insertions(+), 64 deletions(-)

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
index 91d4e17..e5eac14 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -2,79 +2,85 @@
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
+	entry = &head;
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
+static void __task_work_run(struct callback_head *tail)
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
+	struct callback_head **head = &current->task_works;
+
+	do {
+		struct callback_head *work = xchg(head, NULL);
+		while (work) {
+			struct callback_head *next = ACCESS_ONCE(work->next);
+
+			WARN_ON_ONCE(work == &dead);
+
+			work->func(work);
+			work = next;
 		}
-	}
+	} while (cmpxchg(head, NULL, tail) != NULL);
+}
+
+void task_work_run(void)
+{
+	__task_work_run(NULL);
+}
+
+void task_work_exit(void)
+{
+	__task_work_run(&dead);
 }

