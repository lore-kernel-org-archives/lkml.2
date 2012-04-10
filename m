Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab2DJBGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:06:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab2DJBGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:06:35 -0400
Date: Tue, 10 Apr 2012 03:06:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH 1/1] task_work_queue: add generic process-context
	callbacks
Message-ID: <20120410010609.GB18358@redhat.com>
References: <20120409190323.GA14712@redhat.com> <20120409190350.GA14716@redhat.com> <20120410010547.GA18358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410010547.GA18358@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a simple mechanism that allows running code in the
(nonatomic) context of the arbitrary task.

The caller does task_work_queue(task, task_work) and this task
executes task_work->func() either from do_notify_resume() or
from do_exit(). The callback can rely on PF_EXITING to detect
the latter case.

"struct task_work" can be embedded in another struct, still it
has "void *data" to handle the most common/simple case.

This allows us to kill the ->replacement_session_keyring hack,
and potentially this can have more users.

Performance-wise, this adds 2 "unlikely(!hlist_empty())" checks
into tracehook_notify_resume() and do_exit(). But at the same
time we can remove the "replacement_session_keyring != NULL"
checks from arch/*/signal.c and exit_creds().

Note: task_work_queue/task_work_run abuses ->pi_lock. This is
only because this lock is already used by lookup_pi_state() to
synchronize with do_exit() setting PF_EXITING. Fortunately the
scope of this lock in task_work.c is really tiny, and the code
is unlikely anyway.

Todo:
	- move clear_thread_flag(TIF_NOTIFY_RESUME) from arch/
	  to tracehook_notify_resume()

	- rename tracehook_notify_resume() and move it into
	  linux/task_work.h

	- m68k and xtensa don't have TIF_NOTIFY_RESUME and thus
	  they can't use this feature.

	  However, ->replacement_session_keyring equally needs
	  this logic, task_work_queue() is not worse.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h     |    2 +
 include/linux/task_work.h |   39 +++++++++++++++++++++++++++++
 include/linux/tracehook.h |   10 +++++++-
 kernel/Makefile           |    2 +-
 kernel/exit.c             |    5 +++-
 kernel/fork.c             |    1 +
 kernel/task_work.c        |   59 +++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 115 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/task_work.h
 create mode 100644 kernel/task_work.c

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 81a173c..be004ac 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1445,6 +1445,8 @@ struct task_struct {
 	int (*notifier)(void *priv);
 	void *notifier_data;
 	sigset_t *notifier_mask;
+	struct hlist_head task_works;
+
 	struct audit_context *audit_context;
 #ifdef CONFIG_AUDITSYSCALL
 	uid_t loginuid;
diff --git a/include/linux/task_work.h b/include/linux/task_work.h
new file mode 100644
index 0000000..9fba177
--- /dev/null
+++ b/include/linux/task_work.h
@@ -0,0 +1,39 @@
+#ifndef _LINUX_TASK_WORK_H
+#define _LINUX_TASK_WORK_H	1
+
+#include <linux/sched.h>
+
+struct task_work {
+	struct hlist_node hlist;
+	void (*func)(struct task_work*);
+	void *data;
+};
+
+static inline void init_task_work(struct task_work *twork,
+				void (*func)(struct task_work*), void *data)
+{
+	twork->func = func;
+	twork->data = data;
+}
+
+#ifdef TIF_NOTIFY_RESUME
+int task_work_queue(struct task_struct *task, struct task_work *twork);
+void task_work_run(struct task_struct *task);
+#else
+static inline
+int task_work_queue(struct task_struct *task, struct task_work *twork)
+{
+	return -ENOTSUPP;
+}
+static inline void task_work_run(struct task_struct *task)
+{
+}
+#endif	/* TIF_NOTIFY_RESUME */
+
+static inline void exit_task_work(struct task_struct *task)
+{
+	if (unlikely(!hlist_empty(&task->task_works)))
+		task_work_run(task);
+}
+
+#endif	/* _LINUX_TASK_WORK_H */
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 51bd91d..67dd262 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -46,7 +46,7 @@
 #ifndef _LINUX_TRACEHOOK_H
 #define _LINUX_TRACEHOOK_H	1
 
-#include <linux/sched.h>
+#include <linux/task_work.h>
 #include <linux/ptrace.h>
 #include <linux/security.h>
 struct linux_binprm;
@@ -184,6 +184,14 @@ static inline void set_notify_resume(struct task_struct *task)
  */
 static inline void tracehook_notify_resume(struct pt_regs *regs)
 {
+	/*
+	 * The caller just cleared TIF_NOTIFY_RESUME. This barrier
+	 * pairs with task_work_queue()->set_notify_resume() after
+	 * hlist_add_head(task->task_works);
+	 */
+	smp_mb__after_clear_bit();
+	if (unlikely(!hlist_empty(&current->task_works)))
+		task_work_run(current);
 }
 #endif	/* TIF_NOTIFY_RESUME */
 
diff --git a/kernel/Makefile b/kernel/Makefile
index cb41b95..5790f8b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o \
-	    async.o range.o groups.o
+	    async.o range.o groups.o task_work.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
diff --git a/kernel/exit.c b/kernel/exit.c
index d8bd3b4..dc852c2 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -946,11 +946,14 @@ void do_exit(long code)
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
-	 * an exiting task cleaning up the robust pi futexes.
+	 * an exiting task cleaning up the robust pi futexes, and in
+	 * task_work_queue() to avoid the race with exit_task_work().
 	 */
 	smp_mb();
 	raw_spin_unlock_wait(&tsk->pi_lock);
 
+	exit_task_work(tsk);
+
 	exit_irq_thread();
 
 	if (unlikely(in_atomic()))
diff --git a/kernel/fork.c b/kernel/fork.c
index b9372a0..d1108ac 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1380,6 +1380,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 */
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
+	INIT_HLIST_HEAD(&p->task_works);
 
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
diff --git a/kernel/task_work.c b/kernel/task_work.c
new file mode 100644
index 0000000..d8e2bcf
--- /dev/null
+++ b/kernel/task_work.c
@@ -0,0 +1,59 @@
+#include <linux/tracehook.h>
+
+#ifdef TIF_NOTIFY_RESUME
+int task_work_queue(struct task_struct *task, struct task_work *twork)
+{
+	unsigned long flags;
+	int err = -EINVAL;
+
+	/*
+	 * We must not insert the new work if the task has already passed
+	 * exit_task_work(). We rely on do_exit()->raw_spin_unlock_wait()
+	 * and check PF_EXITING under pi_lock.
+	 */
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	if (likely(!(task->flags & PF_EXITING))) {
+		hlist_add_head(&twork->hlist, &task->task_works);
+		err = 0;
+	}
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	/* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
+	if (likely(!err))
+		set_notify_resume(task);
+	return err;
+}
+
+void task_work_run(struct task_struct *task)
+{
+	unsigned long flags;
+	struct hlist_head task_works;
+	struct hlist_node *pos;
+
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	hlist_move_list(&task->task_works, &task_works);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	if (WARN_ON(hlist_empty(&task_works)))
+		return;
+
+	/*
+	 * We use hlist to save the space in task_struct, but we want fifo.
+	 * Find the last entry, the list should be short, then process them
+	 * in reverse order.
+	 */
+	for (pos = task_works.first; pos->next ; pos = pos->next)
+		;
+
+	for (;;) {
+		struct hlist_node **pprev = pos->pprev;
+		struct task_work *twork = container_of(pos, struct task_work,
+							hlist);
+		twork->func(twork);
+
+		if (pprev == &task_works.first)
+			break;
+		pos = container_of(pprev, struct hlist_node, next);
+	}
+}
+#endif /* TIF_NOTIFY_RESUME */
-- 
1.5.5.1


