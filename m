Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1HaVcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:32:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab1HaV2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:28:12 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH 08/24] C6X: process management
Date: Wed, 31 Aug 2011 17:26:43 -0400
Message-Id: <1314826019-22330-9-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826019-22330-1-git-send-email-msalter@redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/processor.h   |  132 ++++++++++++++++++
 arch/c6x/include/asm/thread_info.h |  121 +++++++++++++++++
 arch/c6x/kernel/process.c          |  260 ++++++++++++++++++++++++++++++++++++
 arch/c6x/kernel/switch_to.S        |   74 ++++++++++
 4 files changed, 587 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/include/asm/processor.h
 create mode 100644 arch/c6x/include/asm/thread_info.h
 create mode 100644 arch/c6x/kernel/process.c
 create mode 100644 arch/c6x/kernel/switch_to.S

diff --git a/arch/c6x/include/asm/processor.h b/arch/c6x/include/asm/processor.h
new file mode 100644
index 0000000..8154c4e
--- /dev/null
+++ b/arch/c6x/include/asm/processor.h
@@ -0,0 +1,132 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Updated for 2.6.34: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_PROCESSOR_H
+#define _ASM_C6X_PROCESSOR_H
+
+#include <asm/ptrace.h>
+#include <asm/page.h>
+#include <asm/current.h>
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+#define current_text_addr()			\
+({						\
+	void *__pc;				\
+	asm("mvc .S2 pce1,%0\n" : "=b"(__pc));	\
+	__pc;					\
+})
+
+/*
+ * User space process size. This is mostly meaningless for NOMMU
+ * but some C6X processors may have RAM addresses up to 0xFFFFFFFF.
+ * Since calls like mmap() can return an address or an error, we
+ * have to allow room for error returns when code does something
+ * like:
+ *
+ *       addr = do_mmap(...)
+ *       if ((unsigned long)addr >= TASK_SIZE)
+ *            ... its an error code, not an address ...
+ *
+ * Here, we allow for 4096 error codes which means we really can't
+ * use the last 4K page on systems with RAM extending all the way
+ * to the end of the 32-bit address space.
+ */
+#define TASK_SIZE	0xFFFFF000
+
+/*
+ * This decides where the kernel will search for a free chunk of vm
+ * space during mmap's. We won't be using it
+ */
+#define TASK_UNMAPPED_BASE	0
+
+struct thread_struct {
+	unsigned long long b15_14;
+	unsigned long long a15_14;
+	unsigned long long b13_12;
+	unsigned long long a13_12;
+	unsigned long long b11_10;
+	unsigned long long a11_10;
+	unsigned long long ricl_icl;
+	unsigned long  usp;		/* user stack pointer */
+	unsigned long  pc;		/* kernel pc */
+	unsigned long  wchan;
+};
+
+#define INIT_THREAD					\
+{							\
+	.usp = 0,					\
+	.wchan = 0,					\
+}
+
+#define INIT_MMAP { \
+	&init_mm, 0, 0, NULL, PAGE_SHARED, VM_READ | VM_WRITE | VM_EXEC, 1, \
+	NULL, NULL }
+
+#define task_pt_regs(task) \
+	((struct pt_regs *)(THREAD_START_SP + task_stack_page(task)) - 1)
+
+#define alloc_kernel_stack()	__get_free_page(GFP_KERNEL)
+#define free_kernel_stack(page) free_page((page))
+
+
+/* Forward declaration, a strange C thing */
+struct task_struct;
+
+extern void start_thread(struct pt_regs *regs, unsigned int pc,
+			 unsigned long usp);
+
+/* Free all resources held by a thread. */
+static inline void release_thread(struct task_struct *dead_task)
+{
+}
+
+/* Prepare to copy thread state - unlazy all lazy status */
+#define prepare_to_copy(tsk)	do { } while (0)
+
+extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
+
+#define copy_segments(tsk, mm)		do { } while (0)
+#define release_segments(mm)		do { } while (0)
+
+/*
+ * saved PC of a blocked thread.
+ */
+#define thread_saved_pc(tsk) (task_pt_regs(tsk)->pc)
+
+/*
+ * saved kernel SP and DP of a blocked thread.
+ */
+#ifdef _BIG_ENDIAN
+#define thread_saved_ksp(tsk) \
+	(*(unsigned long *)&(tsk)->thread.b15_14)
+#define thread_saved_dp(tsk) \
+	(*(((unsigned long *)&(tsk)->thread.b15_14) + 1))
+#else
+#define thread_saved_ksp(tsk) \
+	(*(((unsigned long *)&(tsk)->thread.b15_14) + 1))
+#define thread_saved_dp(tsk) \
+	(*(unsigned long *)&(tsk)->thread.b15_14)
+#endif
+
+extern unsigned long get_wchan(struct task_struct *p);
+
+#define KSTK_EIP(tsk)	(task_pt_regs(task)->pc)
+#define	KSTK_ESP(tsk)	(task_pt_regs(task)->sp)
+
+#define cpu_relax()		do { } while (0)
+
+extern const struct seq_operations cpuinfo_op;
+
+#endif /* ASM_C6X_PROCESSOR_H */
diff --git a/arch/c6x/include/asm/thread_info.h b/arch/c6x/include/asm/thread_info.h
new file mode 100644
index 0000000..fd99148
--- /dev/null
+++ b/arch/c6x/include/asm/thread_info.h
@@ -0,0 +1,121 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Updated for 2.6.3x: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_THREAD_INFO_H
+#define _ASM_C6X_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+#include <asm/page.h>
+
+#ifdef CONFIG_4KSTACKS
+#define THREAD_SIZE		4096
+#define THREAD_SHIFT		12
+#define THREAD_ORDER		0
+#else
+#define THREAD_SIZE		8192
+#define THREAD_SHIFT		13
+#define THREAD_ORDER		1
+#endif
+
+#define THREAD_START_SP		(THREAD_SIZE - 8)
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+/*
+ * low level task data.
+ */
+struct thread_info {
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	unsigned long		flags;		/* low level flags */
+	int			cpu;		/* cpu we're on */
+	int			preempt_count;	/* 0 = preemptable, <0 = BUG */
+	mm_segment_t		addr_limit;	/* thread address space */
+	struct restart_block	restart_block;
+};
+
+/*
+ * macros/functions for gaining access to the thread information structure
+ *
+ * preempt_count needs to be 1 initially, until the scheduler is functional.
+ */
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.flags		= 0,			\
+	.cpu		= 0,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block	= {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+
+/* get the thread information struct of current task */
+static inline __attribute__((const))
+struct thread_info *current_thread_info(void)
+{
+	struct thread_info *ti;
+	asm volatile (" clr   .s2 B15,0,%1,%0\n"
+		      : "=b" (ti)
+		      : "Iu5" (THREAD_SHIFT - 1));
+	return ti;
+}
+
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
+/* thread information allocation */
+#ifdef CONFIG_DEBUG_STACK_USAGE
+#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
+#else
+#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK)
+#endif
+
+#define alloc_thread_info_node(tsk, node)	\
+	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+
+#define free_thread_info(ti)	free_pages((unsigned long) (ti), THREAD_ORDER)
+#define get_thread_info(ti)	get_task_struct((ti)->task)
+#define put_thread_info(ti)	put_task_struct((ti)->task)
+#endif /* __ASSEMBLY__ */
+
+#define	PREEMPT_ACTIVE	0x10000000
+
+/*
+ * thread information flag bit numbers
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
+
+#define TIF_POLLING_NRFLAG	16	/* true if polling TIF_NEED_RESCHED */
+#define TIF_MEMDIE		17	/* OOM killer killed process */
+
+#define TIF_WORK_MASK		0x00007FFE /* work on irq/exception return */
+#define TIF_ALLWORK_MASK	0x00007FFF /* work on any return to u-space */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_C6X_THREAD_INFO_H */
diff --git a/arch/c6x/kernel/process.c b/arch/c6x/kernel/process.c
new file mode 100644
index 0000000..d7bc66f
--- /dev/null
+++ b/arch/c6x/kernel/process.c
@@ -0,0 +1,260 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2006, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+#include <linux/module.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/init_task.h>
+#include <linux/tick.h>
+#include <linux/mqueue.h>
+#include <linux/syscalls.h>
+#include <linux/reboot.h>
+
+#include <asm/syscalls.h>
+
+/* hooks for board specific support */
+void	(*c6x_restart)(void);
+void	(*c6x_halt)(void);
+void	(*c6x_power_off)(void);
+
+extern asmlinkage void ret_from_fork(void);
+
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+
+/*
+ * Initial thread structure.
+ */
+union thread_union init_thread_union __init_task_data =	{
+	INIT_THREAD_INFO(init_task)
+};
+
+/*
+ * Initial task structure.
+ */
+struct task_struct init_task = INIT_TASK(init_task);
+EXPORT_SYMBOL(init_task);
+
+/*
+ * power off function, if any
+ */
+void (*pm_power_off)(void);
+EXPORT_SYMBOL(pm_power_off);
+
+/*
+ * power management idle function, if any..
+ */
+void (*pm_idle)(void);
+EXPORT_SYMBOL(pm_idle);
+
+static void default_idle(void)
+{
+	asm volatile ("IDLE\n");
+}
+
+/*
+ * The idle loop for C64x
+ */
+void cpu_idle(void)
+{
+	/* endless idle loop with no priority at all */
+	while (1) {
+		tick_nohz_stop_sched_tick(1);
+		while (!need_resched()) {
+			void (*idle)(void);
+
+			smp_rmb();
+			idle = pm_idle;
+			if (!idle)
+				idle = default_idle;
+			idle();
+		}
+		tick_nohz_restart_sched_tick();
+
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
+	}
+}
+
+static void halt_loop(void)
+{
+	printk(KERN_EMERG "System Halted, OK to turn off power\n");
+	local_irq_disable();
+	while (1)
+		default_idle();
+}
+
+void machine_restart(char *__unused)
+{
+	if (c6x_restart)
+		c6x_restart();
+	halt_loop();
+}
+
+void machine_halt(void)
+{
+	if (c6x_halt)
+		c6x_halt();
+	halt_loop();
+}
+
+void machine_power_off(void)
+{
+	if (c6x_power_off)
+		c6x_power_off();
+	halt_loop();
+}
+
+static void kernel_thread_helper(int dummy, void *arg, int (*fn)(void *))
+{
+	do_exit(fn(arg));
+}
+
+/*
+ * Create a kernel thread
+ */
+int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
+{
+	struct pt_regs regs;
+
+	/*
+	 * copy_thread sets a4 to zero (child return from fork)
+	 * so we can't just set things up to directly return to
+	 * fn.
+	 */
+	memset(&regs, 0, sizeof(regs));
+	regs.b4 = (unsigned long) arg;
+	regs.a6 = (unsigned long) fn;
+	regs.pc = (unsigned long) kernel_thread_helper;
+	local_save_flags(regs.csr);
+	regs.csr |= 1;
+	regs.tsr = 5; /* Set GEE and GIE in TSR */
+
+	/* Ok, create the new process.. */
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, -1, &regs,
+		       0, NULL, NULL);
+}
+EXPORT_SYMBOL(kernel_thread);
+
+void flush_thread(void)
+{
+}
+
+void exit_thread(void)
+{
+}
+
+SYSCALL_DEFINE1(c6x_clone, struct pt_regs *, regs)
+{
+	unsigned long clone_flags;
+	unsigned long newsp;
+
+	/* syscall puts clone_flags in A4 and usp in B4 */
+	clone_flags = regs->orig_a4;
+	if (regs->b4)
+		newsp = regs->b4;
+	else
+		newsp = regs->sp;
+
+	return do_fork(clone_flags, newsp, regs, 0, (int __user *)regs->a6,
+		       (int __user *)regs->b6);
+}
+
+/*
+ * Do necessary setup to start up a newly executed thread.
+ */
+void start_thread(struct pt_regs *regs, unsigned int pc, unsigned long usp)
+{
+	/*
+	 * The binfmt loader will setup a "full" stack, but the C6X
+	 * operates an "empty" stack. So we adjust the usp so that
+	 * argc doesn't get destroyed if an interrupt is taken before
+	 * it is read from the stack.
+	 *
+	 * NB: Library startup code needs to match this.
+	 */
+	usp -= 8;
+
+	set_fs(USER_DS);
+	regs->pc  = pc;
+	regs->sp  = usp;
+	regs->tsr |= 0x40; /* set user mode */
+	current->thread.usp = usp;
+}
+
+/*
+ * Copy a new thread context in its stack.
+ */
+int copy_thread(unsigned long clone_flags, unsigned long usp,
+		unsigned long ustk_size,
+		struct task_struct *p, struct pt_regs *regs)
+{
+	struct pt_regs *childregs;
+
+	childregs = task_pt_regs(p);
+
+	*childregs = *regs;
+	childregs->a4 = 0;
+
+	if (usp == -1)
+		/* case of  __kernel_thread: we return to supervisor space */
+		childregs->sp = (unsigned long)(childregs + 1);
+	else
+		/* Otherwise use the given stack */
+		childregs->sp = usp;
+
+	/* Set usp/ksp */
+	p->thread.usp = childregs->sp;
+	/* switch_to uses stack to save/restore 14 callee-saved regs */
+	thread_saved_ksp(p) = (unsigned long)childregs - 8;
+	p->thread.pc = (unsigned int) ret_from_fork;
+	p->thread.wchan	= (unsigned long) ret_from_fork;
+#ifdef __DSBT__
+	{
+		unsigned long dp;
+
+		asm volatile ("mv .S2 b14,%0\n" : "=b"(dp));
+
+		thread_saved_dp(p) = dp;
+		if (usp == -1)
+			childregs->dp = dp;
+	}
+#endif
+	return 0;
+}
+
+/*
+ * c6x_execve() executes a new program.
+ */
+SYSCALL_DEFINE4(c6x_execve, const char __user *, name,
+		const char __user *const __user *, argv,
+		const char __user *const __user *, envp,
+		struct pt_regs *, regs)
+{
+	int error;
+	char *filename;
+
+	filename = getname(name);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+
+	error = do_execve(filename, argv, envp, regs);
+	putname(filename);
+out:
+	return error;
+}
+
+unsigned long get_wchan(struct task_struct *p)
+{
+	return p->thread.wchan;
+}
diff --git a/arch/c6x/kernel/switch_to.S b/arch/c6x/kernel/switch_to.S
new file mode 100644
index 0000000..09177ed
--- /dev/null
+++ b/arch/c6x/kernel/switch_to.S
@@ -0,0 +1,74 @@
+/*
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter (msalter@redhat.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+
+#define SP	B15
+
+	/*
+	 * void __switch_to(struct thread_info *prev,
+	 *      	    struct thread_info *next,
+	 *		    struct task_struct *tsk) ;
+	 */
+ENTRY(__switch_to)
+	LDDW	.D2T2	*+B4(THREAD_B15_14),B7:B6
+ ||	MV	.L2X	A4,B5	; prev
+ ||	MV	.L1X	B4,A5	; next
+ ||	MVC	.S2	RILC,B1
+
+	STW	.D2T2	B3,*+B5(THREAD_PC)
+ ||	STDW	.D1T1	A13:A12,*+A4(THREAD_A13_12)
+ ||	MVC	.S2	ILC,B0
+
+	LDW	.D2T2	*+B4(THREAD_PC),B3
+ ||	LDDW	.D1T1	*+A5(THREAD_A13_12),A13:A12
+
+	STDW	.D1T1	A11:A10,*+A4(THREAD_A11_10)
+ ||	STDW	.D2T2	B1:B0,*+B5(THREAD_RICL_ICL)
+#ifndef __DSBT__
+ ||	MVKL	.S2	current_ksp,B1
+#endif
+
+	STDW	.D2T2	B15:B14,*+B5(THREAD_B15_14)
+ ||	STDW	.D1T1	A15:A14,*+A4(THREAD_A15_14)
+#ifndef __DSBT__
+ ||	MVKH	.S2	current_ksp,B1
+#endif
+
+	;; Switch to next SP
+	MV	.S2	B7,SP
+#ifdef __DSBT__
+ ||	STW	.D2T2	B7,*+B14(current_ksp)
+#else
+ ||	STW	.D2T2	B7,*B1
+ ||	MV	.L2	B6,B14
+#endif
+ ||	LDDW	.D1T1	*+A5(THREAD_RICL_ICL),A1:A0
+
+	STDW	.D2T2	B11:B10,*+B5(THREAD_B11_10)
+ ||	LDDW	.D1T1	*+A5(THREAD_A15_14),A15:A14
+
+	STDW	.D2T2	B13:B12,*+B5(THREAD_B13_12)
+ ||	LDDW	.D1T1	*+A5(THREAD_A11_10),A11:A10
+
+	B	.S2	B3		; return in next E1
+ ||	LDDW	.D2T2	*+B4(THREAD_B13_12),B13:B12
+
+	LDDW	.D2T2	*+B4(THREAD_B11_10),B11:B10
+	NOP
+
+	MV	.L2X	A0,B0
+ ||	MV	.S1	A6,A4
+
+	MVC	.S2	B0,ILC
+ ||	MV	.L2X	A1,B1
+
+	MVC	.S2	B1,RILC
+ENDPROC(__switch_to)
-- 
1.7.6

