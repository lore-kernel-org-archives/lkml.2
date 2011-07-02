Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab1GBVSv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:18:51 -0400
Received: from mail.southpole.se ([193.12.106.18]:45886 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab1GBVQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:16:18 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v2 12/19] OpenRISC: Scheduling/Process management
Date: Sat,  2 Jul 2011 23:15:45 +0200
Message-Id: <1309641352-18714-13-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309641352-18714-1-git-send-email-jonas@southpole.se>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/include/asm/thread_info.h |  149 +++++++++++++++
 arch/openrisc/kernel/idle.c             |    2 +-
 arch/openrisc/kernel/process.c          |  305 +++++++++++++++++++++++++++++++
 3 files changed, 455 insertions(+), 1 deletions(-)
 create mode 100644 arch/openrisc/include/asm/thread_info.h
 create mode 100644 arch/openrisc/kernel/process.c

diff --git a/arch/openrisc/include/asm/thread_info.h b/arch/openrisc/include/asm/thread_info.h
new file mode 100644
index 0000000..8a8fb50
--- /dev/null
+++ b/arch/openrisc/include/asm/thread_info.h
@@ -0,0 +1,149 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _ASM_THREAD_INFO_H
+#define _ASM_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+#include <asm/types.h>
+#include <asm/processor.h>
+#endif
+
+
+/* THREAD_SIZE is the size of the task_struct/kernel_stack combo.
+ * normally, the stack is found by doing something like p + THREAD_SIZE
+ * in or32, a page is 8192 bytes, which seems like a sane size
+ */
+
+#define THREAD_SIZE_ORDER 0
+#define THREAD_SIZE       (PAGE_SIZE << THREAD_SIZE_ORDER)
+
+/*
+ * low level task data that entry.S needs immediate access to
+ * - this struct should fit entirely inside of one cache line
+ * - this struct shares the supervisor stack pages
+ * - if the contents of this structure are changed, the assembly constants
+ *   must also be changed
+ */
+#ifndef __ASSEMBLY__
+
+typedef unsigned long mm_segment_t;
+
+struct debug_entry {
+	unsigned long address;  /* Address of breakpoint */
+	unsigned long insn;     /* Instruction replaced */
+	unsigned long set;      /* Is BP active? */
+	unsigned long branch;   /* BP is after a branch */
+	unsigned long branch_target;       /* Branch address */
+	unsigned long branch_insn_address; /* PC of l.b/l.j */
+};
+
+struct debug_info {
+	struct debug_entry	bp;
+};
+
+struct thread_info {
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	unsigned long		flags;		/* low level flags */
+	__u32			cpu;		/* current CPU */
+	__s32			preempt_count; /* 0 => preemptable, <0 => BUG */
+
+	mm_segment_t		addr_limit; /* thread address space:
+					       0-0x7FFFFFFF for user-thead
+					       0-0xFFFFFFFF for kernel-thread
+					     */
+	struct restart_block    restart_block;
+	__u8			supervisor_stack[0];
+
+	/* saved context data */
+	unsigned long           ksp;
+
+	struct debug_info	debug;
+};
+#endif
+
+/*
+ * macros/functions for gaining access to the thread information structure
+ *
+ * preempt_count needs to be 1 initially, until the scheduler is functional.
+ */
+#ifndef __ASSEMBLY__
+#define INIT_THREAD_INFO(tsk)				\
+{							\
+	.task		= &tsk,				\
+	.exec_domain	= &default_exec_domain,		\
+	.flags		= 0,				\
+	.cpu		= 0,				\
+	.preempt_count	= 1,				\
+	.addr_limit	= KERNEL_DS,			\
+	.restart_block  = {				\
+		        .fn = do_no_restart_syscall,	\
+	},						\
+	.ksp            = 0,                            \
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+
+/* how to get the thread information struct from C */
+register struct thread_info *current_thread_info_reg asm("r10");
+#define current_thread_info()   (current_thread_info_reg)
+
+#define get_thread_info(ti) get_task_struct((ti)->task)
+#define put_thread_info(ti) put_task_struct((ti)->task)
+
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * thread information flags
+ *   these are process state flags that various assembly files may need to
+ *   access
+ *   - pending work-to-be-done flags are in LSW
+ *   - other flags in MSW
+ */
+#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_SINGLESTEP		4	/* restore singlestep on return to user
+					 * mode
+					 */
+#define TIF_SYSCALL_TRACEPOINT  8       /* for ftrace syscall instrumentation */
+#define TIF_RESTORE_SIGMASK     9
+#define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling						 * TIF_NEED_RESCHED
+					 */
+#define TIF_MEMDIE              17
+
+#define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
+#define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
+#define _TIF_RESTORE_SIGMASK     (1<<TIF_RESTORE_SIGMASK)
+#define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+
+
+/* Work to do when returning from interrupt/exception */
+/* For OpenRISC, this is anything in the LSW other than syscall trace */
+#define _TIF_WORK_MASK (0xff & ~(_TIF_SYSCALL_TRACE|_TIF_SINGLESTEP))
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
index 495a772..d5bc5f8 100644
--- a/arch/openrisc/kernel/idle.c
+++ b/arch/openrisc/kernel/idle.c
@@ -62,7 +62,7 @@ void cpu_idle(void)
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			if (powersave != NULL)
+			if (!need_resched() && powersave != NULL)
 				powersave();
 			start_critical_timings();
 			local_irq_enable();
diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
new file mode 100644
index 0000000..852f618
--- /dev/null
+++ b/arch/openrisc/kernel/process.c
@@ -0,0 +1,305 @@
+/*
+ * OpenRISC process.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ * This file handles the architecture-dependent parts of process handling...
+ */
+
+#define __KERNEL_SYSCALLS__
+#include <stdarg.h>
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/elfcore.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/init_task.h>
+#include <linux/mqueue.h>
+#include <linux/fs.h>
+
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/processor.h>
+#include <asm/spr_defs.h>
+
+#include <linux/smp.h>
+
+/*
+ * Pointer to Current thread info structure.
+ *
+ * Used at user space -> kernel transitions.
+ */
+struct thread_info *current_thread_info_set[NR_CPUS] = { &init_thread_info, };
+
+void machine_restart(void)
+{
+	printk(KERN_INFO "*** MACHINE RESTART ***\n");
+	__asm__("l.nop 1");
+}
+
+/*
+ * Similar to machine_power_off, but don't shut off power.  Add code
+ * here to freeze the system for e.g. post-mortem debug purpose when
+ * possible.  This halt has nothing to do with the idle halt.
+ */
+void machine_halt(void)
+{
+	printk(KERN_INFO "*** MACHINE HALT ***\n");
+	__asm__("l.nop 1");
+}
+
+/* If or when software power-off is implemented, add code here.  */
+void machine_power_off(void)
+{
+	printk(KERN_INFO "*** MACHINE POWER OFF ***\n");
+	__asm__("l.nop 1");
+}
+
+void (*pm_power_off) (void) = machine_power_off;
+
+/*
+ * When a process does an "exec", machine state like FPU and debug
+ * registers need to be reset.  This is a hook function for that.
+ * Currently we don't have any such state to reset, so this is empty.
+ */
+void flush_thread(void)
+{
+}
+
+void show_regs(struct pt_regs *regs)
+{
+	extern void show_registers(struct pt_regs *regs);
+
+	/* __PHX__ cleanup this mess */
+	show_registers(regs);
+}
+
+unsigned long thread_saved_pc(struct task_struct *t)
+{
+	return (unsigned long)user_regs(t->stack)->pc;
+}
+
+void release_thread(struct task_struct *dead_task)
+{
+}
+
+/*
+ * Copy the thread-specific (arch specific) info from the current
+ * process to the new one p
+ */
+extern asmlinkage void ret_from_fork(void);
+
+int
+copy_thread(unsigned long clone_flags, unsigned long usp,
+	    unsigned long unused, struct task_struct *p, struct pt_regs *regs)
+{
+	struct pt_regs *childregs;
+	struct pt_regs *kregs;
+	unsigned long sp = (unsigned long)task_stack_page(p) + THREAD_SIZE;
+	struct thread_info *ti;
+	unsigned long top_of_kernel_stack;
+
+	top_of_kernel_stack = sp;
+
+	p->set_child_tid = p->clear_child_tid = NULL;
+
+	/* Copy registers */
+	/* redzone */
+	sp -= STACK_FRAME_OVERHEAD;
+	sp -= sizeof(struct pt_regs);
+	childregs = (struct pt_regs *)sp;
+
+	/* Copy parent registers */
+	*childregs = *regs;
+
+	if ((childregs->sr & SPR_SR_SM) == 1) {
+		/* for kernel thread, set `current_thread_info'
+		 * and stackptr in new task
+		 */
+		childregs->sp = (unsigned long)task_stack_page(p) + THREAD_SIZE;
+		childregs->gpr[10] = (unsigned long)task_thread_info(p);
+	} else {
+		childregs->sp = usp;
+	}
+
+	childregs->gpr[11] = 0;	/* Result from fork() */
+
+	/*
+	 * The way this works is that at some point in the future
+	 * some task will call _switch to switch to the new task.
+	 * That will pop off the stack frame created below and start
+	 * the new task running at ret_from_fork.  The new task will
+	 * do some house keeping and then return from the fork or clone
+	 * system call, using the stack frame created above.
+	 */
+	/* redzone */
+	sp -= STACK_FRAME_OVERHEAD;
+	sp -= sizeof(struct pt_regs);
+	kregs = (struct pt_regs *)sp;
+
+	ti = task_thread_info(p);
+	ti->ksp = sp;
+
+	/* kregs->sp must store the location of the 'pre-switch' kernel stack
+	 * pointer... for a newly forked process, this is simply the top of
+	 * the kernel stack.
+	 */
+	kregs->sp = top_of_kernel_stack;
+	kregs->gpr[3] = (unsigned long)current;	/* arg to schedule_tail */
+	kregs->gpr[10] = (unsigned long)task_thread_info(p);
+	kregs->gpr[9] = (unsigned long)ret_from_fork;
+
+	return 0;
+}
+
+/*
+ * Set up a thread for executing a new program
+ */
+void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long sp)
+{
+	unsigned long sr = regs->sr & ~SPR_SR_SM;
+
+	set_fs(USER_DS);
+	memset(regs->gpr, 0, sizeof(regs->gpr));
+
+	regs->pc = pc;
+	regs->sr = sr;
+	regs->sp = sp;
+
+/*	printk("start thread, ksp = %lx\n", current_thread_info()->ksp);*/
+}
+
+/* Fill in the fpu structure for a core dump.  */
+int dump_fpu(struct pt_regs *regs, elf_fpregset_t * fpu)
+{
+	/* TODO */
+	return 0;
+}
+
+extern struct thread_info *_switch(struct thread_info *old_ti,
+				   struct thread_info *new_ti);
+
+struct task_struct *__switch_to(struct task_struct *old,
+				struct task_struct *new)
+{
+	struct task_struct *last;
+	struct thread_info *new_ti, *old_ti;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	/* current_set is an array of saved current pointers
+	 * (one for each cpu). we need them at user->kernel transition,
+	 * while we save them at kernel->user transition
+	 */
+	new_ti = new->stack;
+	old_ti = old->stack;
+
+	current_thread_info_set[smp_processor_id()] = new_ti;
+	last = (_switch(old_ti, new_ti))->task;
+
+	local_irq_restore(flags);
+
+	return last;
+}
+
+/*
+ * fill in the user structure for a core dump..
+ */
+void dump_thread(struct pt_regs *regs, struct user *dump)
+{
+	/* TODO */
+}
+
+extern void _kernel_thread_helper(void);
+
+void __noreturn kernel_thread_helper(int (*fn) (void *), void *arg)
+{
+	do_exit(fn(arg));
+}
+
+/*
+ * Create a kernel thread.
+ */
+int kernel_thread(int (*fn) (void *), void *arg, unsigned long flags)
+{
+	struct pt_regs regs;
+
+	memset(&regs, 0, sizeof(regs));
+
+	regs.gpr[20] = (unsigned long)fn;
+	regs.gpr[22] = (unsigned long)arg;
+	regs.sr = mfspr(SPR_SR);
+	regs.pc = (unsigned long)_kernel_thread_helper;
+
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED,
+		       0, &regs, 0, NULL, NULL);
+}
+
+/*
+ * sys_execve() executes a new program.
+ */
+asmlinkage long _sys_execve(const char __user *name,
+			    const char __user * const __user *argv,
+			    const char __user * const __user *envp,
+			    struct pt_regs *regs)
+{
+	int error;
+	char *filename;
+
+	filename = getname(name);
+	error = PTR_ERR(filename);
+
+	if (IS_ERR(filename))
+		goto out;
+
+	error = do_execve(filename, argv, envp, regs);
+	putname(filename);
+
+out:
+	return error;
+}
+
+unsigned long get_wchan(struct task_struct *p)
+{
+	/* TODO */
+
+	return 0;
+}
+
+int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+{
+	register long __res asm("r11") = __NR_execve;
+	register long __a asm("r3") = (long)(filename);
+	register long __b asm("r4") = (long)(argv);
+	register long __c asm("r5") = (long)(envp);
+	__asm__ volatile ("l.sys 1"
+			  : "=r" (__res), "=r"(__a), "=r"(__b), "=r"(__c)
+			  : "0"(__res), "1"(__a), "2"(__b), "3"(__c)
+			  : "r6", "r7", "r8", "r12", "r13", "r15",
+			    "r17", "r19", "r21", "r23", "r25", "r27",
+			    "r29", "r31");
+	__asm__ volatile ("l.nop");
+	return __res;
+}
-- 
1.7.4.1

