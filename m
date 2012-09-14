Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab2INGJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:09:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48871 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2INGJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:09:47 -0400
Date: Thu, 13 Sep 2012 23:09:31 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-9da33de62431c7839f98156720862262272a8380@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com
In-Reply-To: <20120826191211.GA4228@redhat.com>
References: <20120826191211.GA4228@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] task_work: task_work_add()
  should not succeed after exit_task_work()
Git-Commit-ID: 9da33de62431c7839f98156720862262272a8380
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:09:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9da33de62431c7839f98156720862262272a8380
Gitweb:     http://git.kernel.org/tip/9da33de62431c7839f98156720862262272a8380
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 26 Aug 2012 21:12:11 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 16:47:34 +0200

task_work: task_work_add() should not succeed after exit_task_work()

ed3e694d "move exit_task_work() past exit_files() et.al" destroyed
the add/exit synchronization we had, the caller itself should ensure
task_work_add() can't race with the exiting task.

However, this is not convenient/simple, and the only user which tries
to do this is buggy (see the next patch). Unless the task is current,
there is simply no way to do this in general.

Change exit_task_work()->task_work_run() to use the dummy "work_exited"
entry to let task_work_add() know it should fail.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120826191211.GA4228@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
