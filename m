Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0CTO01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:26:27 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49274 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab0CTO0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:26:22 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Sat, 20 Mar 2010 19:56:17 +0530
Message-Id: <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v1 7/10] Uprobes Implementation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uprobes Implementation

The uprobes infrastructure enables a user to dynamically establish
probepoints in user applications and collect information by executing a
handler function when a probepoint is hit.

The user specifies the virtual address and the pid of the process of
interest along with the action to be performed (handler). The handle
Uprobes is implemented on the user-space breakpoint assistance layer
and uses the execution out of line strategy. Uprobes follows lazy slot
allocation. I.e, on the first probe hit for that process, a new vma (to
hold the probed instructions for execution out of line) is allocated.
Once allocated, this vma remains for the life of the process, and is
reused as needed for subsequent probes.  A slot in the vma is allocated
for a probepoint when it is first hit.

A slot is marked for reuse when the probe gets unregistered and no
threads are using that slot.

In a multithreaded process, a probepoint once registered is active for
all threads of a process. If a thread specific action for a probepoint
is required then the handler should be implemented to do the same.

If a breakpoint already exists at a particular address (irrespective of
who inserted the breakpoint including uprobes), uprobes will refuse to
register any more probes at that address.

You need to follow this up with the uprobes patch for your
architecture.

For more information: please refer to Documentation/uprobes.txt

TODO:
1. Perf/trace events interface for uprobes.
2. Allow multiple probes at a probepoint.
3. Booster probes.
4. Allow probes to be inherited across fork.
5. probing function returns.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
---

 arch/Kconfig              |   13 +
 include/linux/sched.h     |    3 
 include/linux/tracehook.h |   18 +
 include/linux/uprobes.h   |  178 ++++++++++
 kernel/Makefile           |    1 
 kernel/fork.c             |    3 
 kernel/uprobes.c          |  798 +++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 1014 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/uprobes.h
 create mode 100644 kernel/uprobes.c


diff --git a/arch/Kconfig b/arch/Kconfig
index 1a53e30..5144fc3 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -63,6 +63,16 @@ config USER_BKPT
 	  This service is used by components such as uprobes.
 	  If in doubt, say "N".
 
+config UPROBES
+	bool "User-space probes (EXPERIMENTAL)"
+	depends on MODULES && USER_BKPT_XOL
+	depends on HAVE_UPROBES
+	help
+	  Uprobes enables kernel modules to establish probepoints
+	  in user applications and execute handler functions when
+	  the probepoints are hit. For more information, refer to
+	  Documentation/uprobes.txt. If in doubt, say "N".
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
@@ -114,6 +124,9 @@ config HAVE_KRETPROBES
 
 config HAVE_OPTPROBES
 	bool
+
+config HAVE_UPROBES
+	def_bool n
 #
 # An arch should select this if it provides all these things:
 #
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..2d2433a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1506,6 +1506,9 @@ struct task_struct {
 		unsigned long memsw_bytes; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_UPROBES
+	struct uprobe_task *utask;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 10db010..9a91d1e 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -49,6 +49,7 @@
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/security.h>
+#include <linux/uprobes.h>
 struct linux_binprm;
 
 /**
@@ -204,6 +205,11 @@ static inline void tracehook_report_exec(struct linux_binfmt *fmt,
 	if (!ptrace_event(PT_TRACE_EXEC, PTRACE_EVENT_EXEC, 0) &&
 	    unlikely(task_ptrace(current) & PT_PTRACED))
 		send_sig(SIGTRAP, current, 0);
+
+#ifdef CONFIG_UPROBES
+	if (unlikely(current->utask))
+		uprobe_free_utask();
+#endif
 }
 
 /**
@@ -219,6 +225,10 @@ static inline void tracehook_report_exec(struct linux_binfmt *fmt,
 static inline void tracehook_report_exit(long *exit_code)
 {
 	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
+#ifdef CONFIG_UPROBES
+	if (unlikely(current->utask))
+		uprobe_free_utask();
+#endif
 }
 
 /**
@@ -293,6 +303,10 @@ static inline void tracehook_report_clone(struct pt_regs *regs,
 		sigaddset(&child->pending.signal, SIGSTOP);
 		set_tsk_thread_flag(child, TIF_SIGPENDING);
 	}
+#ifdef CONFIG_UPROBES
+	if (unlikely(current->utask))
+		uprobe_handle_clone(clone_flags, child);
+#endif
 }
 
 /**
@@ -593,6 +607,10 @@ static inline void set_notify_resume(struct task_struct *task)
  */
 static inline void tracehook_notify_resume(struct pt_regs *regs)
 {
+#ifdef CONFIG_UPROBES
+	if (current->utask && current->utask->active_ppt)
+		uprobe_notify_resume(regs);
+#endif
 }
 #endif	/* TIF_NOTIFY_RESUME */
 
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
new file mode 100644
index 0000000..25a91a4
--- /dev/null
+++ b/include/linux/uprobes.h
@@ -0,0 +1,178 @@
+#ifndef _LINUX_UPROBES_H
+#define _LINUX_UPROBES_H
+/*
+ * Userspace Probes (UProbes)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2008-2010
+ * Authors:
+ *	Srikar Dronamraju
+ *	Jim Keniston
+ */
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/rcupdate.h>
+#include <linux/mutex.h>
+#include <linux/wait.h>
+#include <linux/spinlock_types.h>
+#include <asm/atomic.h>
+#include <linux/user_bkpt.h>
+#include <linux/user_bkpt_xol.h>
+
+struct task_struct;
+struct pid;
+struct pt_regs;
+
+/* This is what the user supplies us. */
+struct uprobe {
+	/*
+	 * The pid of the probed process.  Currently, this can be the
+	 * thread ID (task->pid) of any active thread in the process.
+	 */
+	pid_t pid;
+
+	/* Location of the probepoint */
+	unsigned long vaddr;
+
+	/* Handler to run when the probepoint is hit */
+	void (*handler)(struct uprobe*, struct pt_regs*);
+
+	/* true if handler runs in interrupt context*/
+	bool handler_in_interrupt;
+};
+
+/*
+ * uprobe_process -- not a user-visible struct.
+ * A uprobe_process represents a probed process.  A process can have
+ * multiple probepoints (each represented by a uprobe_probept) and
+ * one or more threads (each represented by a uprobe_task).
+ */
+struct uprobe_process {
+	/*
+	 * mutex locked for any change to the uprobe_process's
+	 * graph (including uprobe_probept, taking a slot in xol_area) --
+	 * e.g., due to probe [un]registration or special events like exit.
+	 */
+	struct mutex mutex;
+
+	/* Table of uprobe_probepts registered for this process */
+	struct list_head uprobe_list;
+
+	atomic_t refcount;
+
+	/* lock held while traversing/modifying uprobe_list */
+	spinlock_t pptlist_lock;	/* protects uprobe_list */
+
+	/* number of probept allocated for this process */
+	int n_ppts;
+
+	/*
+	 * All threads (tasks) in a process share the same uprobe_process.
+	 */
+	struct pid *tg_leader;
+
+	/*
+	 * Manages slots for instruction-copies to be single-stepped
+	 * out of line.
+	 */
+	void *xol_area;
+};
+
+/*
+ * uprobe_probept -- not a user-visible struct.
+ * A uprobe_probept represents a probepoint.
+ * Guarded by uproc->lock.
+ */
+struct uprobe_probept {
+	/* breakpoint/XOL details */
+	struct user_bkpt user_bkpt;
+
+	/*
+	 * ppt goes in the uprobe_process->uprobe_table when registered --
+	 * even before the breakpoint has been inserted.
+	 */
+	struct list_head ut_node;
+
+	atomic_t refcount;
+
+	/* The parent uprobe_process */
+	struct uprobe_process *uproc;
+
+	struct uprobe *uprobe;
+};
+
+/*
+ * uprobe_utask -- not a user-visible struct.
+ * Corresponds to a thread in a probed process.
+ * Guarded by uproc->mutex.
+ */
+struct uprobe_task {
+	struct user_bkpt_task_arch_info arch_info;
+
+	/* Back pointer to the associated uprobe_process */
+	struct uprobe_process *uproc;
+
+	struct uprobe_probept *active_ppt;
+};
+
+#ifdef CONFIG_UPROBES
+extern int uprobes_exception_notify(struct notifier_block *self,
+				unsigned long val, void *data);
+extern int uprobe_bkpt_notifier(struct pt_regs *regs);
+extern int uprobe_post_notifier(struct pt_regs *regs);
+extern void uprobe_notify_resume(struct pt_regs *regs);
+extern void arch_uprobe_enable_sstep(struct pt_regs *regs);
+extern void arch_uprobe_disable_sstep(struct pt_regs *regs);
+extern int register_uprobe(struct uprobe *u);
+extern void unregister_uprobe(struct uprobe *u);
+extern void uprobe_free_utask(void);
+extern void uprobe_handle_clone(unsigned long clone_flags,
+				struct task_struct *child);
+extern void uprobe_enable_interrupts(void);
+extern void uprobe_disable_interrupts(void);
+#else
+
+/*
+ * Only register_uprobe() and unregister_uprobe() are part of
+ * the client API.
+ */
+static inline int register_uprobe(struct uprobe *u)
+{
+	return -ENOSYS;
+}
+static inline void unregister_uprobe(struct uprobe *u)
+{
+}
+static inline void uprobe_free_utask(void)
+{
+}
+static inline void uprobe_handle_clone(unsigned long clone_flags,
+				struct task_struct *child)
+{
+}
+static inline void uprobe_notify_resume(struct pt_regs *regs)
+{
+}
+static inline int uprobe_bkpt_notifier(struct pt_regs *regs)
+{
+	return 0;
+}
+static inline int uprobe_post_notifier(struct pt_regs *regs)
+{
+	return 0;
+}
+#endif	/* CONFIG_UPROBES */
+#endif	/* _LINUX_UPROBES_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index e404aa0..f0cfb02 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -107,6 +107,7 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_USER_BKPT) += user_bkpt.o
 obj-$(CONFIG_USER_BKPT_XOL) += user_bkpt_xol.o
+obj-$(CONFIG_UPROBES) += uprobes.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/fork.c b/kernel/fork.c
index 4799c5f..63c5efc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1180,6 +1180,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	INIT_LIST_HEAD(&p->pi_state_list);
 	p->pi_state_cache = NULL;
 #endif
+#ifdef CONFIG_UPROBES
+	p->utask = NULL;
+#endif
 	/*
 	 * sigaltstack should be cleared when sharing the same VM
 	 */
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
new file mode 100644
index 0000000..026a6f8
--- /dev/null
+++ b/kernel/uprobes.c
@@ -0,0 +1,798 @@
+/*
+ *  Userspace Probes (UProbes)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2008-2010
+ * Authors:
+ *	Srikar Dronamraju
+ *	Jim Keniston
+ */
+#include <linux/types.h>
+#include <linux/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/err.h>
+#include <linux/uprobes.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+#include <linux/errno.h>
+#include <linux/kdebug.h>
+
+static u16 user_bkpt_strategies;
+
+struct notifier_block uprobes_exception_nb = {
+	.notifier_call = uprobes_exception_notify,
+	.priority = 0x7ffffff0,
+};
+
+typedef void (*uprobe_handler_t)(struct uprobe*, struct pt_regs*);
+
+/* Guards lookup, creation, and deletion of uproc. */
+static DEFINE_MUTEX(uprobe_mutex);
+
+static inline void get_probept(struct uprobe_probept *ppt)
+{
+	atomic_inc(&ppt->refcount);
+}
+
+/*
+ * Creates a uprobe_probept and connects it to uprobe and uproc.
+ * Runs with uproc->mutex locked.
+ */
+static struct uprobe_probept *add_probept(struct uprobe *u,
+					struct uprobe_process *uproc)
+{
+	struct uprobe_probept *ppt;
+
+	ppt = kzalloc(sizeof *ppt, GFP_USER);
+	if (unlikely(ppt == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	ppt->user_bkpt.vaddr = u->vaddr;
+	ppt->uprobe = u;
+	ppt->user_bkpt.xol_vaddr = 0;
+
+	ppt->user_bkpt.strategy = user_bkpt_strategies;
+
+	ppt->uproc = uproc;
+	INIT_LIST_HEAD(&ppt->ut_node);
+	spin_lock(&uproc->pptlist_lock);
+	list_add(&ppt->ut_node, &uproc->uprobe_list);
+	spin_unlock(&uproc->pptlist_lock);
+	atomic_set(&ppt->refcount, 1);
+	return ppt;
+}
+
+static void put_probept(struct uprobe_probept *ppt)
+{
+	struct uprobe_process *uproc;
+
+	uproc = ppt->uproc;
+	if (atomic_dec_and_lock(&ppt->refcount, &uproc->pptlist_lock)) {
+		list_del(&ppt->ut_node);
+		xol_free_insn_slot(ppt->user_bkpt.xol_vaddr, uproc->xol_area);
+		spin_unlock(&uproc->pptlist_lock);
+		kfree(ppt);
+	}
+}
+
+/*
+ * In the given uproc's hash table of probepoints, find the one with the
+ * specified virtual address.
+ * Called with uproc->pptlist_lock acquired.
+ */
+static struct uprobe_probept *find_probept(struct uprobe_process *uproc,
+							unsigned long vaddr)
+{
+	struct uprobe_probept *ppt;
+
+	list_for_each_entry(ppt, &uproc->uprobe_list, ut_node) {
+		if (ppt->user_bkpt.vaddr == vaddr)
+			return ppt;
+	}
+	return NULL;
+}
+
+/*
+ * Save a copy of the original instruction (so it can be single-stepped
+ * out of line), insert the breakpoint instruction.
+ * Runs with uproc->mutex locked.
+ */
+static int insert_bkpt(struct uprobe_probept *ppt, struct task_struct *tsk)
+{
+	int result;
+
+	if (tsk)
+		result = user_bkpt_insert_bkpt(tsk, &ppt->user_bkpt);
+	else
+		/* No surviving tasks associated with ppt->uproc */
+		result = -ESRCH;
+	return result;
+}
+
+ /* Runs with uproc->mutex locked. */
+static void remove_bkpt(struct uprobe_probept *ppt, struct task_struct *tsk)
+{
+	if (!tsk)
+		return;
+
+	if (user_bkpt_remove_bkpt(tsk, &ppt->user_bkpt) != 0) {
+		printk(KERN_ERR "Error removing uprobe at pid %d vaddr %#lx:"
+			" can't restore original instruction\n",
+			tsk->tgid, ppt->user_bkpt.vaddr);
+		/*
+		 * This shouldn't happen, since we were previously able
+		 * to write the breakpoint at that address.  There's not
+		 * much we can do besides let the process die with a
+		 * SIGTRAP the next time the breakpoint is hit.
+		 */
+	}
+}
+
+/* Runs with the uprobe_mutex held. */
+static struct uprobe_process *find_uprocess(struct pid *tg_leader)
+{
+	struct uprobe_process *uproc;
+	struct task_struct *tsk = get_pid_task(tg_leader, PIDTYPE_PID);
+
+	if (!tsk->utask || !tsk->utask->uproc) {
+		put_task_struct(tsk);
+		return NULL;
+	}
+
+	uproc = tsk->utask->uproc;
+	BUG_ON(uproc->tg_leader != tg_leader);
+	atomic_inc(&uproc->refcount);
+	put_task_struct(tsk);
+	return uproc;
+}
+
+/*
+ * uproc's process is exiting or exec-ing.
+ * Called in context of the last thread of the process. This thread is also
+ * exiting. Hence we can traverse the uprobe_list without
+ * taking spinlock.
+ * Called with no locks held.
+ */
+static int free_uprocess(struct uprobe_process *uproc)
+{
+	struct uprobe_probept *ppt, *pnode;
+
+	mutex_lock(&uproc->mutex);
+	list_for_each_entry_safe(ppt, pnode, &uproc->uprobe_list, ut_node) {
+		put_probept(ppt);
+	}
+	if (uproc->xol_area)
+		xol_free_area(uproc->xol_area);
+
+	put_pid(uproc->tg_leader);
+	uproc->tg_leader = NULL;
+	mutex_unlock(&uproc->mutex);	/* So kfree doesn't complain */
+	kfree(uproc);
+	return 0;
+}
+
+/*
+ * Dismantle uproc and all its remaining uprobe_tasks.
+ * Runs with uprobe_mutex held;
+ */
+static void cleanup_uprocess(struct uprobe_process *uproc)
+{
+	struct task_struct *tsk, *group_leader;
+	tsk = pid_task(uproc->tg_leader, PIDTYPE_PID);
+	group_leader = tsk->group_leader;
+
+	rcu_read_lock();
+	do {
+		if (tsk->utask) {
+			kfree(tsk->utask);
+			tsk->utask = NULL;
+		}
+	} while_each_thread(group_leader, tsk);
+	rcu_read_unlock();
+}
+
+/* Called with no locks held */
+static void put_uprocess(struct uprobe_process *uproc)
+{
+	if (atomic_dec_and_test(&uproc->refcount)) {
+		mutex_lock(&uprobe_mutex);
+		if (unlikely(atomic_read(&uproc->refcount)))
+			mutex_unlock(&uprobe_mutex);
+		else {
+			cleanup_uprocess(uproc);
+			mutex_unlock(&uprobe_mutex);
+			free_uprocess(uproc);
+		}
+	}
+}
+
+/*
+ * Called with no locks held.
+ * Called in context of a exiting or a exec-ing thread.
+ */
+void uprobe_free_utask(void)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_task *utask;
+
+	mutex_lock(&uprobe_mutex);
+	utask = current->utask;
+	if (!utask) {
+		mutex_unlock(&uprobe_mutex);
+		return;
+	}
+	uproc = utask->uproc;
+	BUG_ON(!uproc);
+
+	kfree(utask);
+	current->utask = NULL;
+	mutex_unlock(&uprobe_mutex);
+	if (current_is_single_threaded())
+		/* Last thread, lets release the uproc */
+		put_uprocess(uproc);
+}
+
+/*
+ * Allocate a uprobe_task object for the task and add it to uproc's list.
+ * Called with t "got" and uprobe_mutex locked.  Called in one of
+ * the following cases:
+ * - before setting the first uprobe in t's process
+ * - we're in clone() and t is the newly added thread
+ *
+ * Returns:
+ * - pointer to new uprobe_task on success
+ * - negative errno otherwise
+ */
+static struct uprobe_task *add_utask(struct task_struct *t,
+					struct uprobe_process *uproc)
+{
+	struct uprobe_task *utask;
+
+	if (!t)
+		return NULL;
+	utask = kzalloc(sizeof *utask, GFP_USER);
+	if (unlikely(utask == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	utask->uproc = uproc;
+	utask->active_ppt = NULL;
+	t->utask = utask;
+
+	return utask;
+}
+
+/*
+ * Find the next thread that doesn't have a corresponding uprobe_task
+ * yet.  start is the a ref-counted thread in the probed process. We
+ * decrement the ref-count for start here.
+ *
+ * Return the next ref-counted thread for that process, if any, else
+ * NULL.
+ */
+static struct task_struct *find_next_thread(struct uprobe_process *uproc,
+						struct task_struct *start)
+{
+	struct task_struct *next_t = NULL;
+
+	rcu_read_lock();
+	if (start) {
+		struct task_struct *t = start;
+
+		do {
+			if (unlikely(t->flags & PF_EXITING))
+				goto dont_add;
+			if (t->utask)
+				/* Already added */
+				goto dont_add;
+
+			/* Found thread/task to add. */
+			get_task_struct(t);
+			next_t = t;
+			break;
+dont_add:
+			t = next_thread(t);
+		} while (t != start);
+	}
+	rcu_read_unlock();
+	return next_t;
+}
+
+/* Runs with uprobe_mutex held; */
+static struct uprobe_process *create_uprocess(struct pid *tg_leader)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_task *utask;
+	struct task_struct *add_me, *cur_t;
+	long err;
+
+	uproc = kzalloc(sizeof *uproc, GFP_USER);
+	if (unlikely(uproc == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	/* Initialize fields */
+	mutex_init(&uproc->mutex);
+	spin_lock_init(&uproc->pptlist_lock);
+	atomic_set(&uproc->refcount, 1);
+	uproc->tg_leader = get_pid(tg_leader);
+	INIT_LIST_HEAD(&uproc->uprobe_list);
+
+	/*
+	 * Create and populate one utask per thread in this process.  We
+	 * can't call add_utask() while holding RCU lock, so we:
+	 *	1. rcu_read_lock()
+	 *	2. Find the next thread, add_me, in this process that's not
+	 *	having a utask struct allocated.
+	 *	3. rcu_read_unlock()
+	 *	4. add_utask(add_me, uproc)
+	 *	Repeat 1-4 'til we have utasks for all threads.
+	 */
+	cur_t = get_pid_task(tg_leader, PIDTYPE_PID);
+	do {
+		utask = add_utask(cur_t, uproc);
+		if (IS_ERR(utask)) {
+			put_task_struct(cur_t);
+			err = PTR_ERR(utask);
+			goto fail;
+		}
+		add_me = find_next_thread(uproc, cur_t);
+		put_task_struct(cur_t);
+		cur_t = add_me;
+	} while (add_me != NULL);
+
+	atomic_inc(&uproc->refcount);
+	return uproc;
+
+fail:
+	cleanup_uprocess(uproc);
+	kfree(uproc);
+	return ERR_PTR(err);
+}
+
+/*
+ * Given a numeric thread ID, return a ref-counted struct pid for the
+ * task-group-leader thread.
+ */
+static struct pid *get_tg_leader(pid_t p)
+{
+	struct pid *pid = NULL;
+
+	rcu_read_lock();
+	if (current->nsproxy)
+		pid = find_vpid(p);
+	if (pid) {
+		struct task_struct *t = pid_task(pid, PIDTYPE_PID);
+		if (!t || unlikely(t->flags & PF_EXITING))
+			pid = NULL;
+		else
+			pid = get_pid(task_tgid(t));
+	}
+	rcu_read_unlock();
+	return pid;
+}
+
+/* See Documentation/uprobes.txt. */
+int register_uprobe(struct uprobe *u)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_probept *ppt;
+	struct task_struct *tsk;
+	struct pid *p;
+	int ret = 0;
+
+	if (!u || !u->handler)
+		return -EINVAL;
+
+	p = get_tg_leader(u->pid);
+	if (!p)
+		return -ESRCH;
+
+	tsk = pid_task(p, PIDTYPE_PID);
+
+	/* Get the uprobe_process for this pid, or make a new one. */
+	mutex_lock(&uprobe_mutex);
+	uproc = find_uprocess(p);
+
+	if (!uproc) {
+		uproc = create_uprocess(p);
+		if (IS_ERR(uproc)) {
+			ret = (int) PTR_ERR(uproc);
+			mutex_unlock(&uprobe_mutex);
+			goto fail_tsk;
+		}
+	}
+	mutex_unlock(&uprobe_mutex);
+	mutex_lock(&uproc->mutex);
+
+	if (uproc->n_ppts >= MAX_USER_BKPT_XOL_SLOTS)
+		goto fail_uproc;
+
+	ret = xol_validate_vaddr(p, u->vaddr, uproc->xol_area);
+	if (ret < 0)
+		goto fail_uproc;
+
+	/* See if we already have a probepoint at the vaddr. */
+	spin_lock(&uproc->pptlist_lock);
+	ppt = find_probept(uproc, u->vaddr);
+	spin_unlock(&uproc->pptlist_lock);
+	if (ppt) {
+		/*
+		 * A uprobe already exists at that address.
+		 */
+		ret = -EALREADY;
+		goto fail_uproc;
+	} else {
+		ppt = add_probept(u, uproc);
+		if (IS_ERR(ppt)) {
+			ret = (int) PTR_ERR(ppt);
+			goto fail_uproc;
+		}
+		ret = insert_bkpt(ppt, tsk);
+		if (ret != 0)
+			goto fail_uproc;
+	}
+
+	uproc->n_ppts++;
+
+fail_uproc:
+	mutex_unlock(&uproc->mutex);
+	put_uprocess(uproc);
+
+fail_tsk:
+	put_pid(p);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_uprobe);
+
+/* See Documentation/uprobes.txt. */
+void unregister_uprobe(struct uprobe *u)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_probept *ppt;
+	struct pid *p;
+
+	if (!u)
+		return;
+	p = get_tg_leader(u->pid);
+	if (!p)
+		return;
+
+	/* Get the uprobe_process for this pid. */
+	mutex_lock(&uprobe_mutex);
+	uproc = find_uprocess(p);
+	mutex_unlock(&uprobe_mutex);
+	if (!uproc) {
+		put_pid(p);
+		return;
+	}
+
+	/*
+	 * Lock uproc before walking the graph, in case the process
+	 * we're probing is exiting.
+	 */
+	mutex_lock(&uproc->mutex);
+
+	spin_lock(&uproc->pptlist_lock);
+	ppt = find_probept(uproc, u->vaddr);
+	spin_unlock(&uproc->pptlist_lock);
+	if (!ppt)
+		/*
+		 * This probe was never successfully registered, or
+		 * has already been unregistered.
+		 */
+		goto done;
+
+	if (ppt->uprobe != u)
+		/*
+		 * unregister request doesnt correspond to successful
+		 * register request.
+		 */
+		goto done;
+
+	remove_bkpt(ppt, pid_task(p, PIDTYPE_PID));
+
+	/*
+	 * Breakpoint is removed; however a thread could have hit the
+	 * same breakpoint and yet to find its corresponding probepoint.
+	 * Before we remove the probepoint, give the breakpointed thread a
+	 * chance to find the probepoint.
+	 */
+	mutex_unlock(&uproc->mutex);
+	synchronize_sched();
+	mutex_lock(&uproc->mutex);
+	put_probept(ppt);
+	uproc->n_ppts--;
+
+done:
+	mutex_unlock(&uproc->mutex);
+	put_uprocess(uproc);
+	put_pid(p);
+}
+EXPORT_SYMBOL_GPL(unregister_uprobe);
+
+/* Prepare to single-step ppt's probed instruction out of line. */
+static int pre_ssout(struct uprobe_task *utask, struct uprobe_probept *ppt,
+						struct pt_regs *regs)
+{
+	struct uprobe_process *uproc = utask->uproc;
+
+	BUG_ON(!uproc);
+
+	if (unlikely(!ppt->user_bkpt.xol_vaddr)) {
+#ifdef CONFIG_X86_32
+		/*
+		 * On x86_32, do_notify_resume() gets called with
+		 * interrupts disabled. Hence enable interrupts if they
+		 * are still disabled.
+		 */
+		uprobe_enable_interrupts();
+#endif
+		mutex_lock(&uproc->mutex);
+		if (unlikely(!uproc->xol_area))
+			uproc->xol_area = xol_alloc_area();
+		if (uproc->xol_area && !ppt->user_bkpt.xol_vaddr)
+			ppt->user_bkpt.xol_vaddr =
+					xol_get_insn_slot(&ppt->user_bkpt,
+							uproc->xol_area);
+		mutex_unlock(&uproc->mutex);
+#ifdef CONFIG_X86_32
+		uprobe_disable_interrupts();
+#endif
+		if (unlikely(!ppt->user_bkpt.xol_vaddr))
+			goto fail;
+	}
+	user_bkpt_pre_sstep(current, &ppt->user_bkpt,
+						&utask->arch_info, regs);
+	user_bkpt_set_ip(regs, ppt->user_bkpt.xol_vaddr);
+	return 0;
+
+/*
+ * We failed to execute out of line.
+ * reset the instruction pointer and remove the breakpoint.
+ */
+fail:
+	remove_bkpt(ppt, current);
+	user_bkpt_set_ip(regs, ppt->user_bkpt.vaddr);
+	put_probept(ppt);
+	return -1;
+}
+
+/* Prepare to continue execution after single-stepping out of line. */
+static int post_ssout(struct uprobe_probept *ppt, struct pt_regs *regs)
+{
+	return user_bkpt_post_sstep(current, &ppt->user_bkpt,
+					&current->utask->arch_info, regs);
+}
+
+/*
+ * Verify from Instruction Pointer if singlestep has indeed occurred.
+ * If Singlestep has occurred, then do post singlestep fix-ups.
+ */
+static bool sstep_complete(struct pt_regs *regs,
+				struct uprobe_probept *ppt)
+{
+	unsigned long vaddr = instruction_pointer(regs);
+
+	/*
+	 * If we have executed out of line, Instruction pointer
+	 * cannot be same as virtual address of XOL slot.
+	 */
+	if (vaddr == ppt->user_bkpt.xol_vaddr)
+		return false;
+	post_ssout(ppt, regs);
+	return true;
+}
+
+/*
+ * Clone callback: The current task has spawned a thread/process.
+ * NOTE: For now, we don't pass on uprobes from the parent to the
+ * child. We now do the necessary clearing of breakpoints in the
+ * child's address space.
+ *
+ * TODO:
+ *	- Provide option for child to inherit uprobes.
+ */
+void uprobe_handle_clone(unsigned long clone_flags,
+				struct task_struct *child)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_task *ptask, *ctask;
+
+	ptask = current->utask;
+	if (!ptask)
+		return;
+
+	uproc = ptask->uproc;
+
+	BUG_ON(!uproc);
+
+	if (clone_flags & CLONE_THREAD) {
+		mutex_lock(&uprobe_mutex);
+		/* New thread in the same process. */
+		ctask = child->utask;
+		if (unlikely(ctask)) {
+			/*
+			 * create_uprocess() ran just as this clone
+			 * happened, and has already accounted for the
+			 * new child.
+			 */
+		} else {
+			ctask = add_utask(child, uproc);
+			BUG_ON(!ctask);
+		}
+		mutex_unlock(&uprobe_mutex);
+	} else {
+		struct uprobe_probept *ppt;
+
+		/*
+		 * New process spawned by parent.  Remove the probepoints
+		 * in the child's text.
+		 *
+		 * We also hold the uproc->mutex for the parent - so no
+		 * new uprobes will be registered 'til we return.
+		 */
+		mutex_lock(&uproc->mutex);
+		ctask = child->utask;
+		if (unlikely(ctask)) {
+			/*
+			 * create_uprocess() ran just as this fork
+			 * happened, and has already created a new utask.
+			 */
+			mutex_unlock(&uproc->mutex);
+			return;
+		}
+		list_for_each_entry(ppt, &uproc->uprobe_list, ut_node) {
+			if (user_bkpt_remove_bkpt(child,
+					&ppt->user_bkpt) != 0) {
+				/* Ratelimit this? */
+				printk(KERN_ERR "Pid %d forked %d; failed to"
+					" remove probepoint at %#lx in child\n",
+					current->pid, child->pid,
+					ppt->user_bkpt.vaddr);
+			}
+		}
+		mutex_unlock(&uproc->mutex);
+	}
+}
+
+
+/*
+ * uprobe_notify_resume gets called in task context just before returning
+ * to userspace.  it gets called if.
+ *  - handler has to be run in task context.
+ *  - 1st time the probepoint is hit.
+ *
+ *  If its the first time the probepoint is hit, we allocate the slot here.
+ */
+void uprobe_notify_resume(struct pt_regs *regs)
+{
+	struct uprobe_probept *ppt;
+	struct uprobe_task *utask;
+	struct uprobe *u;
+
+	utask = current->utask;
+	if (!utask)
+		return;
+
+	ppt = utask->active_ppt;
+	if (!ppt)
+		return;
+
+	u = ppt->uprobe;
+	if (!u->handler_in_interrupt && u->handler)
+		u->handler(u, regs);
+	if (!pre_ssout(utask, ppt, regs))
+		arch_uprobe_enable_sstep(regs);
+}
+
+/*
+ * uprobe_bkpt_notifier gets called from interrupt context
+ * it sets TIF_NOTIFY_RESUME flag, if
+ *	- handler has to be run in task context
+ *	- slot for the probepoint is not yet allocated.
+ */
+int uprobe_bkpt_notifier(struct pt_regs *regs)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_probept *ppt;
+	struct uprobe_task *utask;
+	struct uprobe *u;
+	unsigned long probept;
+
+	utask = current->utask;
+	if (!utask || !utask->uproc)
+		/* task is currently not uprobed */
+		return 0;
+
+	uproc = utask->uproc;
+	probept = user_bkpt_get_bkpt_addr(regs);
+	spin_lock(&uproc->pptlist_lock);
+	ppt = find_probept(uproc, probept);
+	if (!ppt) {
+		spin_unlock(&uproc->pptlist_lock);
+		return 0;
+	}
+	get_probept(ppt);
+	spin_unlock(&uproc->pptlist_lock);
+	utask->active_ppt = ppt;
+	u = ppt->uprobe;
+
+	if (u->handler_in_interrupt && u->handler)
+		u->handler(u, regs);
+
+	if (ppt->user_bkpt.xol_vaddr && u->handler_in_interrupt) {
+		user_bkpt_pre_sstep(current, &ppt->user_bkpt,
+						&utask->arch_info, regs);
+		arch_uprobe_enable_sstep(regs);
+	} else
+		set_thread_flag(TIF_NOTIFY_RESUME);
+	return 1;
+}
+
+/*
+ * uprobe_post_notifier gets called in interrupt context.
+ * It completes the single step operation.
+ */
+int uprobe_post_notifier(struct pt_regs *regs)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_probept *ppt;
+	struct uprobe_task *utask;
+
+	utask = current->utask;
+	ppt = utask->active_ppt;
+	uproc = utask->uproc;
+
+	if (!utask || !utask->uproc)
+		/* task is currently not uprobed */
+		return 0;
+
+	if (!ppt)
+		return 0;
+
+	if (sstep_complete(regs, ppt)) {
+		arch_uprobe_disable_sstep(regs);
+		put_probept(ppt);
+		utask->active_ppt = NULL;
+		return 1;
+	}
+	return 0;
+}
+
+
+static int __init init_uprobes(void)
+{
+	int ret;
+
+	user_bkpt_strategies = USER_BKPT_HNT_TSKINFO;
+	ret = user_bkpt_init(&user_bkpt_strategies);
+	if (ret != 0) {
+		printk(KERN_ERR "Can't start uprobes: user_bkpt_init() returned %d\n",
+								ret);
+		return ret;
+	}
+
+	register_die_notifier(&uprobes_exception_nb);
+	return 0;
+}
+
+static void __exit exit_uprobes(void)
+{
+}
+
+module_init(init_uprobes);
+module_exit(exit_uprobes);
