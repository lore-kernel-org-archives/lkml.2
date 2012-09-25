Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2IYNvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:51:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab2IYNvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:51:41 -0400
Date: Tue, 25 Sep 2012 15:52:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: possible recursive locking in numasched code
Message-ID: <20120925135255.GA9669@redhat.com>
References: <20120925094157.GD18334@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925094157.GD18334@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25, Srikar Dronamraju wrote:
>
>  ======================================================
>  [ INFO: possible circular locking dependency detected ]
>  3.6.0-rc1-numasched_v2_100912+ #2 Not tainted
>  -------------------------------------------------------
>
>  -> #0 (&p->pi_lock){-.-.-.}:
>        [<ffffffff810be478>] __lock_acquire+0x1428/0x1690
>        [<ffffffff810be782>] lock_acquire+0xa2/0x130
>        [<ffffffff81551a15>] _raw_spin_lock_irqsave+0x55/0xa0
>        [<ffffffff81078b08>] task_work_add+0x38/0xb0

Yes. This should be fixed by ac3d0da8 from tip:core/urgent,
attached below.

Oleg.

task_work: Make task_work_add() lockless

Change task_work's to use llist-like code to avoid pi_lock
in task_work_add(), this makes it useable under rq->lock.

task_work_cancel() and task_work_run() still use pi_lock
to synchronize with each other.

(This is in preparation for a deadlock fix.)

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120826191209.GA4221@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/task_work.c |   95 ++++++++++++++++++++++++++-------------------------
 1 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index d320d44..f13ec0b 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -3,25 +3,18 @@
 #include <linux/tracehook.h>
 
 int
-task_work_add(struct task_struct *task, struct callback_head *twork, bool notify)
+task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
-	struct callback_head *last, *first;
-	unsigned long flags;
-
+	struct callback_head *head;
 	/*
 	 * Not inserting the new work if the task has already passed
 	 * exit_task_work() is the responisbility of callers.
 	 */
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	last = task->task_works;
-	first = last ? last->next : twork;
-	twork->next = first;
-	if (last)
-		last->next = twork;
-	task->task_works = twork;
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	do {
+		head = ACCESS_ONCE(task->task_works);
+		work->next = head;
+	} while (cmpxchg(&task->task_works, head, work) != head);
 
-	/* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
 	if (notify)
 		set_notify_resume(task);
 	return 0;
@@ -30,52 +23,60 @@ task_work_add(struct task_struct *task, struct callback_head *twork, bool notify
 struct callback_head *
 task_work_cancel(struct task_struct *task, task_work_func_t func)
 {
+	struct callback_head **pprev = &task->task_works;
+	struct callback_head *work = NULL;
 	unsigned long flags;
-	struct callback_head *last, *res = NULL;
-
+	/*
+	 * If cmpxchg() fails we continue without updating pprev.
+	 * Either we raced with task_work_add() which added the
+	 * new entry before this work, we will find it again. Or
+	 * we raced with task_work_run(), *pprev == NULL.
+	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
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
-		}
+	while ((work = ACCESS_ONCE(*pprev))) {
+		read_barrier_depends();
+		if (work->func != func)
+			pprev = &work->next;
+		else if (cmpxchg(pprev, work, work->next) == work)
+			break;
 	}
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-	return res;
+
+	return work;
 }
 
 void task_work_run(void)
 {
 	struct task_struct *task = current;
-	struct callback_head *p, *q;
+	struct callback_head *work, *head, *next;
 
-	while (1) {
-		raw_spin_lock_irq(&task->pi_lock);
-		p = task->task_works;
-		task->task_works = NULL;
-		raw_spin_unlock_irq(&task->pi_lock);
+	for (;;) {
+		work = xchg(&task->task_works, NULL);
+		if (!work)
+			break;
+		/*
+		 * Synchronize with task_work_cancel(). It can't remove
+		 * the first entry == work, cmpxchg(task_works) should
+		 * fail, but it can play with *work and other entries.
+		 */
+		raw_spin_unlock_wait(&task->pi_lock);
+		smp_mb();
 
-		if (unlikely(!p))
-			return;
+		/* Reverse the list to run the works in fifo order */
+		head = NULL;
+		do {
+			next = work->next;
+			work->next = head;
+			head = work;
+			work = next;
+		} while (work);
 
-		q = p->next; /* head */
-		p->next = NULL; /* cut it */
-		while (q) {
-			p = q->next;
-			q->func(q);
-			q = p;
+		work = head;
+		do {
+			next = work->next;
+			work->func(work);
+			work = next;
 			cond_resched();
-		}
+		} while (work);
 	}
 }


