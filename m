Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2HZTKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 15:10:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab2HZTJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 15:09:48 -0400
Date: Sun, 26 Aug 2012 21:12:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/4] task_work: task_work_add() should not succeed after
	exit_task_work()
Message-ID: <20120826191211.GA4228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826191132.GA3743@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ed3e694d "move exit_task_work() past exit_files() et.al" destroyed
the add/exit synchronization we had, the caller itself should ensure
task_work_add() can't race with the exiting task.

However, this is not convenient/simple, and the only user which tries
to do this is buggy (see the next patch). Unless the task is current,
there is simply no way to do this in general.

Change exit_task_work()->task_work_run() to use the dummy "work_exited"
entry to let task_work_add() know it should fail.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/task_work.h |    3 +--
 kernel/task_work.c        |   22 ++++++++++++++++------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index fb46b03..ca5a1cf 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -18,8 +18,7 @@ void task_work_run(void);
 
 static inline void exit_task_work(struct task_struct *task)
 {
-	if (unlikely(task->task_works))
-		task_work_run();
+	task_work_run();
 }
 
 #endif	/* _LINUX_TASK_WORK_H */
diff --git a/kernel/task_work.c b/kernel/task_work.c
index f13ec0b..65bd3c9 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -2,16 +2,17 @@
 #include <linux/task_work.h>
 #include <linux/tracehook.h>
 
+static struct callback_head work_exited; /* all we need is ->next == NULL */
+
 int
 task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
 	struct callback_head *head;
-	/*
-	 * Not inserting the new work if the task has already passed
-	 * exit_task_work() is the responisbility of callers.
-	 */
+
 	do {
 		head = ACCESS_ONCE(task->task_works);
+		if (unlikely(head == &work_exited))
+			return -ESRCH;
 		work->next = head;
 	} while (cmpxchg(&task->task_works, head, work) != head);
 
@@ -30,7 +31,7 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
 	 * If cmpxchg() fails we continue without updating pprev.
 	 * Either we raced with task_work_add() which added the
 	 * new entry before this work, we will find it again. Or
-	 * we raced with task_work_run(), *pprev == NULL.
+	 * we raced with task_work_run(), *pprev == NULL/exited.
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	while ((work = ACCESS_ONCE(*pprev))) {
@@ -51,7 +52,16 @@ void task_work_run(void)
 	struct callback_head *work, *head, *next;
 
 	for (;;) {
-		work = xchg(&task->task_works, NULL);
+		/*
+		 * work->func() can do task_work_add(), do not set
+		 * work_exited unless the list is empty.
+		 */
+		do {
+			work = ACCESS_ONCE(task->task_works);
+			head = !work && (task->flags & PF_EXITING) ?
+				&work_exited : NULL;
+		} while (cmpxchg(&task->task_works, work, head) != work);
+
 		if (!work)
 			break;
 		/*
-- 
1.5.5.1

