Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2F0SkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:40:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab2F0SkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:40:19 -0400
Date: Wed, 27 Jun 2012 20:37:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 1/4] task_work: use the single-linked list to shrink
	sizeof(task_work)
Message-ID: <20120627183742.GB23086@redhat.com>
References: <1340369098.2464.20.camel@falcor> <20120623092049.GH14083@ZenIV.linux.org.uk> <20120623194505.GI14083@ZenIV.linux.org.uk> <20120623203800.GA10306@redhat.com> <20120623210141.GK14083@ZenIV.linux.org.uk> <20120624041652.GN14083@ZenIV.linux.org.uk> <20120624153310.GB24596@redhat.com> <20120625060357.GT14083@ZenIV.linux.org.uk> <20120625151812.GA16062@redhat.com> <20120627183721.GA23086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627183721.GA23086@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change struct task_work to have a single forward pointer. The pending
task_work's create the circular list, and task->last_twork points to
the last element. This way we can access head/tail in O(1).

Suggested-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h     |    3 +-
 include/linux/task_work.h |    5 +--
 include/linux/tracehook.h |    4 +-
 kernel/fork.c             |    2 +-
 kernel/task_work.c        |   62 +++++++++++++++++++++++++-------------------
 5 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4059c0f..5486299 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -101,6 +101,7 @@ struct bio_list;
 struct fs_struct;
 struct perf_event_context;
 struct blk_plug;
+struct task_work;
 
 /*
  * List of flags we want to share for kernel threads,
@@ -1405,7 +1406,7 @@ struct task_struct {
 	int (*notifier)(void *priv);
 	void *notifier_data;
 	sigset_t *notifier_mask;
-	struct hlist_head task_works;
+	struct task_work *last_twork;
 
 	struct audit_context *audit_context;
 #ifdef CONFIG_AUDITSYSCALL
diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 294d5d5..03640fb 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -1,14 +1,13 @@
 #ifndef _LINUX_TASK_WORK_H
 #define _LINUX_TASK_WORK_H
 
-#include <linux/list.h>
 #include <linux/sched.h>
 
 struct task_work;
 typedef void (*task_work_func_t)(struct task_work *);
 
 struct task_work {
-	struct hlist_node hlist;
+	struct task_work *next;
 	task_work_func_t func;
 	void *data;
 };
@@ -26,7 +25,7 @@ void task_work_run(void);
 
 static inline void exit_task_work(struct task_struct *task)
 {
-	if (unlikely(!hlist_empty(&task->task_works)))
+	if (unlikely(task->last_twork))
 		task_work_run();
 }
 
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 6a4d82b..89e88fe 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -189,10 +189,10 @@ static inline void tracehook_notify_resume(struct pt_regs *regs)
 	/*
 	 * The caller just cleared TIF_NOTIFY_RESUME. This barrier
 	 * pairs with task_work_add()->set_notify_resume() after
-	 * hlist_add_head(task->task_works);
+	 * addition to task->last_twork list.
 	 */
 	smp_mb__after_clear_bit();
-	if (unlikely(!hlist_empty(&current->task_works)))
+	if (unlikely(current->last_twork))
 		task_work_run();
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index ab5211b..075000b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1415,7 +1415,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 */
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
-	INIT_HLIST_HEAD(&p->task_works);
+	p->last_twork = NULL;
 
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 82d1c79..a0a3133 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -2,10 +2,15 @@
 #include <linux/task_work.h>
 #include <linux/tracehook.h>
 
+/*
+ * task->last_twork points to the last node in the circular single-linked list.
+ */
+
 int
 task_work_add(struct task_struct *task, struct task_work *twork, bool notify)
 {
 	unsigned long flags;
+	struct task_work *last;
 	int err = -ESRCH;
 
 #ifndef TIF_NOTIFY_RESUME
@@ -19,7 +24,10 @@ task_work_add(struct task_struct *task, struct task_work *twork, bool notify)
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	if (likely(!(task->flags & PF_EXITING))) {
-		hlist_add_head(&twork->hlist, &task->task_works);
+		last = task->last_twork ?: twork;
+		task->last_twork = twork;
+		twork->next = last->next;
+		last->next = twork;
 		err = 0;
 	}
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
@@ -34,15 +42,26 @@ struct task_work *
 task_work_cancel(struct task_struct *task, task_work_func_t func)
 {
 	unsigned long flags;
-	struct task_work *twork;
-	struct hlist_node *pos;
+	struct task_work *last, *prev, *twork;
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	hlist_for_each_entry(twork, pos, &task->task_works, hlist) {
-		if (twork->func == func) {
-			hlist_del(&twork->hlist);
+	last = task->last_twork;
+	if (last) {
+		twork = last;
+		do {
+			prev = twork;
+			twork = twork->next;
+			if (twork->func != func)
+				continue;
+
+			prev->next = twork->next;
+			if (twork == last) {
+				if (prev == twork)
+					prev = NULL;
+				task->last_twork = prev;
+			}
 			goto found;
-		}
+		} while (twork != last);
 	}
 	twork = NULL;
  found:
@@ -54,31 +73,20 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
 void task_work_run(void)
 {
 	struct task_struct *task = current;
-	struct hlist_head task_works;
-	struct hlist_node *pos;
+	struct task_work *last, *next, *twork;
 
 	raw_spin_lock_irq(&task->pi_lock);
-	hlist_move_list(&task->task_works, &task_works);
+	last = task->last_twork;
+	task->last_twork = NULL;
 	raw_spin_unlock_irq(&task->pi_lock);
 
-	if (unlikely(hlist_empty(&task_works)))
+	if (unlikely(!last))
 		return;
-	/*
-	 * We use hlist to save the space in task_struct, but we want fifo.
-	 * Find the last entry, the list should be short, then process them
-	 * in reverse order.
-	 */
-	for (pos = task_works.first; pos->next; pos = pos->next)
-		;
 
-	for (;;) {
-		struct hlist_node **pprev = pos->pprev;
-		struct task_work *twork = container_of(pos, struct task_work,
-							hlist);
+	next = last->next;
+	do {
+		twork = next;
+		next = twork->next;
 		twork->func(twork);
-
-		if (pprev == &task_works.first)
-			break;
-		pos = container_of(pprev, struct hlist_node, next);
-	}
+	} while (twork != last);
 }
-- 
1.5.5.1


