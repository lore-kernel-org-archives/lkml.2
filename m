Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2DNCNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 22:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab2DNCNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 22:13:17 -0400
Date: Sat, 14 Apr 2012 04:12:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Gordeev <agordeev@redhat.com>, Chris Zankel <chris@zankel.net>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/3] task_work_add: generic process-context callbacks
Message-ID: <20120414021220.GA23393@redhat.com>
References: <20120414021201.GA23385@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120414021201.GA23385@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a simple mechanism that allows running code in the
(nonatomic) context of the arbitrary task.

The caller does task_work_add(task, task_work) and this task
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

Note: task_work_add/task_work_run abuses ->pi_lock. This is
only because this lock is already used by lookup_pi_state() to
synchronize with do_exit() setting PF_EXITING. Fortunately the
scope of this lock in task_work.c is really tiny, and the code
is unlikely anyway.

v2:
	- implement task_work_cancel(func), it removes the first
	  task_work with the same callback.
v3:
	- task_work_add() gets the new arg, "bool notify" to
	  conditionalize set_notify_resume(), this makes it useable
	  for kthreads and task_work_add(notify => false) can
	  work without TIF_NOTIFY_RESUME.

	- don't add the dummy "ifndef TIF_NOTIFY_RESUME" inlines,
	  just add the simple check in task_work_add().
v4:
	- s/task_work_queue/task_work_add/

Todo:
	- move clear_thread_flag(TIF_NOTIFY_RESUME) from arch/
	  to tracehook_notify_resume()

	- rename tracehook_notify_resume() and move it into
	  linux/task_work.h

	- m68k and xtensa don't have TIF_NOTIFY_RESUME and thus
	  task_work_add(notify => true) fails with -ENOTSUPP.

	  However, ->replacement_session_keyring equally needs
	  this flag, task_work_add() is not worse.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h     |    2 +
 include/linux/task_work.h |   33 ++++++++++++++++++
 include/linux/tracehook.h |   13 ++++++-
 kernel/Makefile           |    2 +-
 kernel/exit.c             |    5 ++-
 kernel/fork.c             |    1 +
 kernel/task_work.c        |   83 +++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 135 insertions(+), 4 deletions(-)
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
index 0000000..9ed6c31
--- /dev/null
+++ b/include/linux/task_work.h
@@ -0,0 +1,33 @@
+#ifndef _LINUX_TASK_WORK_H
+#define _LINUX_TASK_WORK_H
+
+#include <linux/list.h>
+#include <linux/sched.h>
+
+struct task_work;
+typedef void (*task_work_func_t)(struct task_work *);
+
+struct task_work {
+	struct hlist_node hlist;
+	task_work_func_t func;
+	void *data;
+};
+
+static inline void
+init_task_work(struct task_work *twork, task_work_func_t func, void *data)
+{
+	twork->func = func;
+	twork->data = data;
+}
+
+int task_work_add(struct task_struct *task, struct task_work *twork, bool);
+struct task_work *task_work_cancel(struct task_struct *, task_work_func_t);
+void task_work_run(struct task_struct *task);
+
+static inline void exit_task_work(struct task_struct *task)
+{
+	if (unlikely(!hlist_empty(&task->task_works)))
+		task_work_run(task);
+}
+
+#endif	/* _LINUX_TASK_WORK_H */
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 51bd91d..a575f26 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -49,6 +49,7 @@
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/security.h>
+#include <linux/task_work.h>
 struct linux_binprm;
 
 /*
@@ -153,7 +154,6 @@ static inline void tracehook_signal_handler(int sig, siginfo_t *info,
 		ptrace_notify(SIGTRAP);
 }
 
-#ifdef TIF_NOTIFY_RESUME
 /**
  * set_notify_resume - cause tracehook_notify_resume() to be called
  * @task:		task that will call tracehook_notify_resume()
@@ -165,8 +165,10 @@ static inline void tracehook_signal_handler(int sig, siginfo_t *info,
  */
 static inline void set_notify_resume(struct task_struct *task)
 {
+#ifdef TIF_NOTIFY_RESUME
 	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_RESUME))
 		kick_process(task);
+#endif
 }
 
 /**
@@ -184,7 +186,14 @@ static inline void set_notify_resume(struct task_struct *task)
  */
 static inline void tracehook_notify_resume(struct pt_regs *regs)
 {
+	/*
+	 * The caller just cleared TIF_NOTIFY_RESUME. This barrier
+	 * pairs with task_work_add()->set_notify_resume() after
+	 * hlist_add_head(task->task_works);
+	 */
+	smp_mb__after_clear_bit();
+	if (unlikely(!hlist_empty(&current->task_works)))
+		task_work_run(current);
 }
-#endif	/* TIF_NOTIFY_RESUME */
 
 #endif	/* <linux/tracehook.h> */
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
index d8bd3b4..b82c38e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -946,11 +946,14 @@ void do_exit(long code)
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
-	 * an exiting task cleaning up the robust pi futexes.
+	 * an exiting task cleaning up the robust pi futexes, and in
+	 * task_work_add() to avoid the race with exit_task_work().
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
index 0000000..a7fe579
--- /dev/null
+++ b/kernel/task_work.c
@@ -0,0 +1,83 @@
+#include <linux/spinlock.h>
+#include <linux/task_work.h>
+#include <linux/tracehook.h>
+
+int
+task_work_add(struct task_struct *task, struct task_work *twork, bool notify)
+{
+	unsigned long flags;
+	int err = -ESRCH;
+
+#ifndef TIF_NOTIFY_RESUME
+	if (notify)
+		return -ENOTSUPP;
+#endif
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
+	if (likely(!err) && notify)
+		set_notify_resume(task);
+	return err;
+}
+
+struct task_work *
+task_work_cancel(struct task_struct *task, task_work_func_t func)
+{
+	unsigned long flags;
+	struct task_work *twork;
+	struct hlist_node *pos;
+
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	hlist_for_each_entry(twork, pos, &task->task_works, hlist) {
+		if (twork->func == func) {
+			hlist_del(&twork->hlist);
+			goto found;
+		}
+	}
+	twork = NULL;
+ found:
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	return twork;
+}
+
+void task_work_run(struct task_struct *task)
+{
+	struct hlist_head task_works;
+	struct hlist_node *pos;
+
+	raw_spin_lock_irq(&task->pi_lock);
+	hlist_move_list(&task->task_works, &task_works);
+	raw_spin_unlock_irq(&task->pi_lock);
+
+	if (unlikely(hlist_empty(&task_works)))
+		return;
+	/*
+	 * We use hlist to save the space in task_struct, but we want fifo.
+	 * Find the last entry, the list should be short, then process them
+	 * in reverse order.
+	 */
+	for (pos = task_works.first; pos->next; pos = pos->next)
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
-- 
1.5.5.1


