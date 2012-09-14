Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab2INGI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:08:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48856 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2INGI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:08:56 -0400
Date: Thu, 13 Sep 2012 23:08:35 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-ac3d0da8f3290b3d394cdb7f50604424a7cd6092@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        peterz@infradead.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20120826191209.GA4221@redhat.com>
References: <20120826191209.GA4221@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] task_work: Make task_work_add() lockless
Git-Commit-ID: ac3d0da8f3290b3d394cdb7f50604424a7cd6092
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:08:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac3d0da8f3290b3d394cdb7f50604424a7cd6092
Gitweb:     http://git.kernel.org/tip/ac3d0da8f3290b3d394cdb7f50604424a7cd6092
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 26 Aug 2012 21:12:09 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 16:47:33 +0200

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
