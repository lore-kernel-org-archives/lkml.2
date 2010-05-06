Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab0EFSC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:02:59 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59843 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab0EFSCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:02:50 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 06 May 2010 23:32:46 +0530
Message-Id: <20100506180246.28877.89255.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 5/10] Uprobes Implementation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobes_core.patch

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Uprobes Implementation

Changelog from v2:
    - Introduce TIF_UPROBED flag.

    - uprobes hooks now in fork/exec/exit paths instead of tracehooks.

    - uprobe_process is now part of the mm struct and is shared between
      processes that share the mm.

    - per thread information is now allocated on the fly.
	* Hence allocation and freeing of this information is lockless.

    - For now run the handler only in task context. The reasons for this
      change being:
	* utask (per-task meta-data structure) is now allocated on the
	  fly. Hence first request on the thread and first request for the
          breakpoint have to be anyway allocated in task context.
	* Measurements showed task based handler had negligible
	  overhead over interrupt based handlers.
        * Feedback from Oleg and few others.
        * Feedback at LFCS.
        * Simplicity  atleast till uprobes stabilizes.
        ( However we may introduce interrupt based handlers at a later time.)
	Here are sample overhead figures (in usec) for x86 architecture.

	i686: Intel(R) Xeon(TM) CPU 2.40GHz
	Without probe module.
	100000 interations in 0.000650 sec i.e 0.006500 usec per iteration

	With probes and handler run in interrupt context.
	100000 interations in 0.340774 sec i.e 3.407740 usec per iteration
	probe overhead is  3.401240 usec per probe hit.

	With probes and handler run in task context.
	100000 interations in 0.365589 sec i.e 3.655890 usec per iteration
	probe overhead is 3.649390 usec per probe hit.

	x86_64: Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
	Without probe module.
	100000 interations in 0.000468 sec i.e  0.004680 usec per iteration

	With probes and handler run in interrupt context.
	100000 interations in 0.120369 sec i.e 1.203690 usec per iteration
	Probe overhead is 1.199010 usec per probe hit.

	With probes and handler run in task context.
	100000 interations in 0.130685 sec i.e 1.306850 usec per iteration
	Probe overhead is 1.302170 usec per probe hit.

     - find_probept() takes the spinlock; unlike previously when it was
       expected that the spinlock was taken before calling it.



Changelog from v1:
	- If fixup might sleep; then do the post singlestep
	   processing in task context.

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

 arch/Kconfig                       |   13 +
 arch/x86/include/asm/thread_info.h |    2 
 arch/x86/kernel/signal.c           |    5 
 fs/exec.c                          |    4 
 include/linux/mm_types.h           |    4 
 include/linux/sched.h              |    3 
 include/linux/uprobes.h            |  169 +++++++++
 kernel/Makefile                    |    1 
 kernel/fork.c                      |   20 +
 kernel/uprobes.c                   |  681 ++++++++++++++++++++++++++++++++++++
 10 files changed, 902 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/uprobes.h
 create mode 100644 kernel/uprobes.c


diff --git a/arch/Kconfig b/arch/Kconfig
index 424494e..34ce376 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -62,6 +62,16 @@ config USER_BKPT
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
@@ -113,6 +123,9 @@ config HAVE_KRETPROBES
 
 config HAVE_OPTPROBES
 	bool
+
+config HAVE_UPROBES
+	def_bool n
 #
 # An arch should select this if it provides all these things:
 #
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e0d2890..5258e69 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -84,6 +84,7 @@ struct thread_info {
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
+#define TIF_UPROBE		12	/* breakpointed or singlestepping */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
@@ -108,6 +109,7 @@ struct thread_info {
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
+#define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4fd173c..851bc8d 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -848,6 +848,11 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
+	if (thread_info_flags & _TIF_UPROBE) {
+		clear_thread_flag(TIF_UPROBE);
+		uprobe_notify_resume(regs);
+	}
+
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
diff --git a/fs/exec.c b/fs/exec.c
index 49cdaa1..a4b6dba 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1048,6 +1048,10 @@ void setup_new_exec(struct linux_binprm * bprm)
 			
 	flush_signal_handlers(current, 0);
 	flush_old_files(current->files);
+#ifdef CONFIG_UPROBES
+	if (unlikely(current->utask))
+		uprobe_free_utask(current);
+#endif
 }
 EXPORT_SYMBOL(setup_new_exec);
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b8bb9a6..b80ffb3 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -14,6 +14,7 @@
 #include <linux/page-debug-flags.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
+#include <linux/uprobes.h>
 
 #ifndef AT_VECTOR_SIZE_ARCH
 #define AT_VECTOR_SIZE_ARCH 0
@@ -310,6 +311,9 @@ struct mm_struct {
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
+#ifdef CONFIG_UPROBES
+	struct uprobe_process *uproc;	/* per mm uprobes meta-data */
+#endif
 };
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..2d2433a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1506,6 +1506,9 @@ struct task_struct {
 		unsigned long memsw_bytes; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_UPROBES
+	struct uprobe_task *utask;	/* per-thread uprobes meta-data */
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
new file mode 100644
index 0000000..07444e1
--- /dev/null
+++ b/include/linux/uprobes.h
@@ -0,0 +1,169 @@
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
+};
+
+/*
+ * uprobe_process -- not a user-visible struct.
+ * A uprobe_process represents a probed process.  A process can have
+ * multiple probepoints (each represented by a uprobe_probept) and
+ * one or more threads (each represented by a uprobe_task).
+ *
+ * All processes/threads that share a mm share the same uprobe_process.
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
+	/* lock held while traversing/modifying uprobe_list and n_ppts */
+	spinlock_t pptlist_lock;	/* protects uprobe_list */
+
+	/* number of probept allocated for this process */
+	int n_ppts;
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
+enum uprobe_task_state {
+	UTASK_RUNNING,
+	UTASK_BP_HIT,
+	UTASK_SSTEP
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
+	enum uprobe_task_state state;
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
+extern void uprobe_free_utask(struct task_struct *tsk);
+extern void uprobe_handle_fork(struct task_struct *child);
+extern void uprobe_put_uprocess(struct mm_struct *mm);
+#else	/* CONFIG_UPROBES */
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
+static inline void uprobe_handle_fork(struct task_struct *child)
+{
+}
+static inline void uprobe_notify_resume(struct pt_regs *regs)
+{
+}
+static void uprobe_put_uprocess(struct mm_struct *mm)
+{
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
index 44b0791..035ab06 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -173,6 +173,10 @@ void __put_task_struct(struct task_struct *tsk)
 
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
+#ifdef CONFIG_UPROBES
+	if (unlikely(tsk->utask))
+		uprobe_free_utask(tsk);
+#endif
 
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
@@ -509,6 +513,10 @@ void __mmdrop(struct mm_struct *mm)
 	mm_free_pgd(mm);
 	destroy_context(mm);
 	mmu_notifier_mm_destroy(mm);
+#ifdef CONFIG_UPROBES
+	if (unlikely(mm->uproc))
+		uprobe_put_uprocess(mm);
+#endif
 	free_mm(mm);
 }
 EXPORT_SYMBOL_GPL(__mmdrop);
@@ -667,6 +675,9 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
 	if (mm->binfmt && !try_module_get(mm->binfmt->module))
 		goto free_pt;
 
+#ifdef CONFIG_UPROBES
+	mm->uproc = NULL;
+#endif
 	return mm;
 
 free_pt:
@@ -1183,6 +1194,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	INIT_LIST_HEAD(&p->pi_state_list);
 	p->pi_state_cache = NULL;
 #endif
+#ifdef CONFIG_UPROBES
+	p->utask = NULL;
+#endif
 	/*
 	 * sigaltstack should be cleared when sharing the same VM
 	 */
@@ -1281,6 +1295,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	perf_event_fork(p);
+#ifdef CONFIG_UPROBES
+	if ((current->mm) && !(clone_flags & CLONE_VM)) {
+		if (unlikely(current->mm->uproc))
+			uprobe_handle_fork(p);
+	}
+#endif
 	return p;
 
 bad_fork_free_pid:
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
new file mode 100644
index 0000000..c40c848
--- /dev/null
+++ b/kernel/uprobes.c
@@ -0,0 +1,681 @@
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
+#include <linux/slab.h>
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
+	uproc->n_ppts++;
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
+		uproc->n_ppts--;
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
+	spin_lock(&uproc->pptlist_lock);
+	list_for_each_entry(ppt, &uproc->uprobe_list, ut_node) {
+		if (ppt->user_bkpt.vaddr == vaddr) {
+			spin_unlock(&uproc->pptlist_lock);
+			return ppt;
+		}
+	}
+	spin_unlock(&uproc->pptlist_lock);
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
+	struct uprobe_process *uproc = NULL;
+	struct task_struct *tsk;
+
+	rcu_read_lock();
+	tsk = pid_task(tg_leader, PIDTYPE_PID);
+	if (!tsk || !tsk->mm)
+		goto end;
+
+	uproc = tsk->mm->uproc;
+	if (uproc)
+		atomic_inc(&uproc->refcount);
+
+end:
+	rcu_read_unlock();
+	return uproc;
+}
+
+/*
+ * uproc's process is exiting or exec-ing.
+ * The last thread of uproc's process is about to die, and its
+ * mm_struct is about to be released.
+ * Hence do the cleanup without holding locks.
+ *
+ * Called with no locks held.
+ */
+static int free_uprocess(struct uprobe_process *uproc)
+{
+	struct uprobe_probept *ppt, *pnode;
+
+	list_for_each_entry_safe(ppt, pnode, &uproc->uprobe_list, ut_node) {
+		put_probept(ppt);
+	}
+	if (uproc->xol_area)
+		xol_free_area(uproc->xol_area);
+
+	kfree(uproc);
+	return 0;
+}
+
+/* Called with no locks held */
+static void put_uprocess(struct uprobe_process *uproc)
+{
+	if (atomic_dec_and_test(&uproc->refcount))
+		free_uprocess(uproc);
+}
+
+/*
+ * Called with no locks held.
+ * Called in context of a exiting or a exec-ing thread.
+ */
+void uprobe_free_utask(struct task_struct *tsk)
+{
+	if (!tsk->utask)
+		return;
+
+	if (tsk->utask->active_ppt)
+		put_probept(tsk->utask->active_ppt);
+	kfree(tsk->utask);
+	tsk->utask = NULL;
+}
+
+/*
+ * Callback from mmput() when mm->users count reduces to zero.
+ */
+void uprobe_put_uprocess(struct mm_struct *mm)
+{
+	put_uprocess(mm->uproc);
+	mm->uproc = NULL;
+}
+
+/*
+ * Allocate a uprobe_task object for the task.
+ * Called with t "got" and uprobe_mutex locked.
+ * Called when the thread hits a breakpoint for the first time.
+ *
+ * Returns:
+ * - pointer to new uprobe_task on success
+ * - negative errno otherwise
+ */
+static struct uprobe_task *add_utask(struct uprobe_process *uproc)
+{
+	struct uprobe_task *utask;
+
+	utask = kzalloc(sizeof *utask, GFP_KERNEL);
+	if (unlikely(utask == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	utask->active_ppt = NULL;
+	current->utask = utask;
+	atomic_inc(&uproc->refcount);
+
+	return utask;
+}
+
+/* Runs with uprobe_mutex held; */
+static struct uprobe_process *create_uprocess(struct pid *tg_leader)
+{
+	struct uprobe_process *uproc = ERR_PTR(-ENOMEM);
+	struct task_struct *tsk;
+	struct mm_struct *mm = NULL;
+
+	tsk = get_pid_task(tg_leader, PIDTYPE_PID);
+	if (tsk)
+		mm = get_task_mm(tsk);
+	if (!mm) {
+		if (tsk)
+			put_task_struct(tsk);
+		return ERR_PTR(-ESRCH);
+	}
+
+	uproc = kzalloc(sizeof *uproc, GFP_KERNEL);
+	if (unlikely(uproc == NULL)) {
+		uproc =  ERR_PTR(-ENOMEM);
+		goto end;
+	}
+
+	/* Initialize fields */
+	mutex_init(&uproc->mutex);
+	spin_lock_init(&uproc->pptlist_lock);
+	atomic_set(&uproc->refcount, 1);
+	INIT_LIST_HEAD(&uproc->uprobe_list);
+
+	BUG_ON(mm->uproc);
+	mm->uproc = uproc;
+
+	/*
+	 * Incrementing the refcount saves us from calling find_uprocess
+	 * in register_uprobe path.
+	 */
+	atomic_inc(&uproc->refcount);
+
+end:
+	put_task_struct(tsk);
+	mmput(mm);
+	return uproc;
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
+	pid = find_vpid(p);
+	if (pid) {
+		struct task_struct *t = pid_task(pid, PIDTYPE_PID);
+
+		if (!t)
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
+	ppt = find_probept(uproc, u->vaddr);
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
+		ret = insert_bkpt(ppt, pid_task(p, PIDTYPE_PID));
+		if (ret != 0)
+			goto fail_uproc;
+	}
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
+	ppt = find_probept(uproc, u->vaddr);
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
+
+done:
+	mutex_unlock(&uproc->mutex);
+	put_uprocess(uproc);
+	put_pid(p);
+}
+EXPORT_SYMBOL_GPL(unregister_uprobe);
+
+/* Prepare to single-step ppt's probed instruction out of line. */
+static int pre_ssout(struct uprobe_probept *ppt, struct pt_regs *regs)
+{
+	struct uprobe_process *uproc = current->mm->uproc;
+
+	if (unlikely(!ppt->user_bkpt.xol_vaddr)) {
+		mutex_lock(&uproc->mutex);
+		if (unlikely(!uproc->xol_area))
+			uproc->xol_area = xol_alloc_area();
+		if (uproc->xol_area && !ppt->user_bkpt.xol_vaddr)
+			xol_get_insn_slot(&ppt->user_bkpt, uproc->xol_area);
+		if (unlikely(!ppt->user_bkpt.xol_vaddr))
+			goto fail;
+		mutex_unlock(&uproc->mutex);
+	}
+	user_bkpt_pre_sstep(current, &ppt->user_bkpt,
+					&current->utask->arch_info, regs);
+	user_bkpt_set_ip(regs, ppt->user_bkpt.xol_vaddr);
+	return 0;
+
+/*
+ * We failed to execute out of line.
+ * reset the instruction pointer and remove the breakpoint.
+ */
+fail:
+	remove_bkpt(ppt, current);
+	mutex_unlock(&uproc->mutex);
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
+ * Fork callback: The current task has spawned a process.
+ * NOTE: For now, we don't pass on uprobes from the parent to the
+ * child. We now do the necessary clearing of breakpoints in the
+ * child's address space.
+ * This function handles the case where vm is not shared between
+ * the parent and the child.
+ *
+ * TODO:
+ *	- Provide option for child to inherit uprobes.
+ */
+void uprobe_handle_fork(struct task_struct *child)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_probept *ppt;
+	int ret;
+
+	uproc = current->mm->uproc;
+
+	/*
+	 * New process spawned by parent but not sharing the same mm.
+	 * Remove the probepoints in the child's text.
+	 *
+	 * We also hold the uproc->mutex for the parent - so no
+	 * new uprobes will be registered 'til we return.
+	 */
+	mutex_lock(&uproc->mutex);
+	list_for_each_entry(ppt, &uproc->uprobe_list, ut_node) {
+		ret = user_bkpt_remove_bkpt(child, &ppt->user_bkpt);
+		if (ret && ret != -EINVAL) {
+			/* Ratelimit this? */
+			printk(KERN_ERR "Pid %d forked %d; failed to"
+				" remove probepoint at %#lx in child\n",
+				current->pid, child->pid,
+				ppt->user_bkpt.vaddr);
+		}
+	}
+	mutex_unlock(&uproc->mutex);
+}
+
+/*
+ * uprobe_notify_resume gets called in task context just before returning
+ * to userspace.
+ *
+ *  If its the first time the probepoint is hit, slot gets allocated here.
+ *  If its the first time the thread hit a breakpoint, utask gets
+ *  allocated here.
+ */
+void uprobe_notify_resume(struct pt_regs *regs)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_probept *ppt;
+	struct uprobe_task *utask;
+	struct uprobe *u;
+	unsigned long probept;
+
+	utask = current->utask;
+	uproc = current->mm->uproc;
+	if (unlikely(!utask)) {
+		utask = add_utask(uproc);
+
+		/* Failed to allocate utask for the current task. */
+		BUG_ON(!utask);
+		probept = user_bkpt_get_bkpt_addr(regs);
+		ppt = find_probept(uproc, probept);
+
+		/*
+		 * The probept was refcounted in uprobe_bkpt_notifier;
+		 * Hence it would be mysterious to miss ppt now
+		 */
+		WARN_ON(!ppt);
+		utask->active_ppt = ppt;
+		utask->state = UTASK_BP_HIT;
+	} else
+		ppt = utask->active_ppt;
+
+	if (utask->state == UTASK_BP_HIT) {
+		utask->state = UTASK_SSTEP;
+		u = ppt->uprobe;
+		if (u && u->handler)
+			u->handler(u, regs);
+
+		if (!pre_ssout(ppt, regs))
+			arch_uprobe_enable_sstep(regs);
+	} else if (utask->state == UTASK_SSTEP) {
+		if (sstep_complete(regs, ppt)) {
+			put_probept(ppt);
+			utask->active_ppt = NULL;
+			utask->state = UTASK_RUNNING;
+			arch_uprobe_disable_sstep(regs);
+		}
+	}
+}
+
+/*
+ * uprobe_bkpt_notifier gets called from interrupt context
+ * it gets a reference to the ppt and sets TIF_UPROBE flag,
+ */
+int uprobe_bkpt_notifier(struct pt_regs *regs)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_probept *ppt;
+	struct uprobe_task *utask;
+	unsigned long probept;
+
+	if (!current->mm || !current->mm->uproc)
+		/* task is currently not uprobed */
+		return 0;
+
+	uproc = current->mm->uproc;
+	utask = current->utask;
+	probept = user_bkpt_get_bkpt_addr(regs);
+	ppt = find_probept(uproc, probept);
+	if (!ppt)
+		return 0;
+	get_probept(ppt);
+	if (utask) {
+		utask->active_ppt = ppt;
+		utask->state = UTASK_BP_HIT;
+	}
+	set_thread_flag(TIF_UPROBE);
+	return 1;
+}
+
+/*
+ * uprobe_post_notifier gets called in interrupt context.
+ * It completes the single step operation.
+ */
+int uprobe_post_notifier(struct pt_regs *regs)
+{
+	struct uprobe_probept *ppt;
+	struct uprobe_task *utask;
+
+	if (!current->mm || !current->mm->uproc || !current->utask)
+		/* task is currently not uprobed */
+		return 0;
+
+	utask = current->utask;
+
+	ppt = utask->active_ppt;
+	if (!ppt)
+		return 0;
+
+	if (user_bkpt_resume_can_sleep(&ppt->user_bkpt)) {
+		set_thread_flag(TIF_UPROBE);
+		return 1;
+	}
+	if (sstep_complete(regs, ppt)) {
+		put_probept(ppt);
+		arch_uprobe_disable_sstep(regs);
+		utask->active_ppt = NULL;
+		utask->state = UTASK_RUNNING;
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
