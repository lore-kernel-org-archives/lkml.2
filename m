Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2F0Skd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:40:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab2F0Skb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:40:31 -0400
Date: Wed, 27 Jun 2012 20:37:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] task_work: don't rely on PF_EXITING
Message-ID: <20120627183757.GC23086@redhat.com>
References: <1340369098.2464.20.camel@falcor> <20120623092049.GH14083@ZenIV.linux.org.uk> <20120623194505.GI14083@ZenIV.linux.org.uk> <20120623203800.GA10306@redhat.com> <20120623210141.GK14083@ZenIV.linux.org.uk> <20120624041652.GN14083@ZenIV.linux.org.uk> <20120624153310.GB24596@redhat.com> <20120625060357.GT14083@ZenIV.linux.org.uk> <20120625151812.GA16062@redhat.com> <20120627183721.GA23086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627183721.GA23086@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_work_add() checks PF_EXITING to ensure it can't insert the new
twork after exit_task_work(). This means that the exiting task can
not use it after exit_signals().

Change task_work_add() and task_work_run() to use the fake
TWORK_EXITED pointer to synchronize with each other, now we can
move exit_task_work() down and make task_work_add() more useful.

Unfortunately, this means that the exiting task needs to take
pi_lock unconditionally.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/task_work.h |    6 ++----
 kernel/task_work.c        |   15 ++++++++-------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 03640fb..ef70b01 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -1,9 +1,8 @@
 #ifndef _LINUX_TASK_WORK_H
 #define _LINUX_TASK_WORK_H
 
-#include <linux/sched.h>
-
 struct task_work;
+struct task_struct;
 typedef void (*task_work_func_t)(struct task_work *);
 
 struct task_work {
@@ -25,8 +24,7 @@ void task_work_run(void);
 
 static inline void exit_task_work(struct task_struct *task)
 {
-	if (unlikely(task->last_twork))
-		task_work_run();
+	task_work_run();
 }
 
 #endif	/* _LINUX_TASK_WORK_H */
diff --git a/kernel/task_work.c b/kernel/task_work.c
index a0a3133..b2ff3b7 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -6,6 +6,8 @@
  * task->last_twork points to the last node in the circular single-linked list.
  */
 
+#define TWORK_EXITED	((struct task_work *)1)
+
 int
 task_work_add(struct task_struct *task, struct task_work *twork, bool notify)
 {
@@ -18,12 +20,11 @@ task_work_add(struct task_struct *task, struct task_work *twork, bool notify)
 		return -ENOTSUPP;
 #endif
 	/*
-	 * We must not insert the new work if the task has already passed
-	 * exit_task_work(). We rely on do_exit()->raw_spin_unlock_wait()
-	 * and check PF_EXITING under pi_lock.
+	 * We must not insert the new work if the exiting task has already
+	 * passed task_work_run().
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	if (likely(!(task->flags & PF_EXITING))) {
+	if (likely(task->last_twork != TWORK_EXITED)) {
 		last = task->last_twork ?: twork;
 		task->last_twork = twork;
 		twork->next = last->next;
@@ -46,7 +47,7 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	last = task->last_twork;
-	if (last) {
+	if (last && last != TWORK_EXITED) {
 		twork = last;
 		do {
 			prev = twork;
@@ -77,10 +78,10 @@ void task_work_run(void)
 
 	raw_spin_lock_irq(&task->pi_lock);
 	last = task->last_twork;
-	task->last_twork = NULL;
+	task->last_twork = (task->flags & PF_EXITING) ? TWORK_EXITED : NULL;
 	raw_spin_unlock_irq(&task->pi_lock);
 
-	if (unlikely(!last))
+	if (!last)
 		return;
 
 	next = last->next;
-- 
1.5.5.1


