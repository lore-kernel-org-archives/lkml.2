Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1BMGev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 01:34:51 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:43160 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab1BMGeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 01:34:44 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCHv2 05/11] unicore32 core architecture: process/thread related codes
Date: Sun, 13 Feb 2011 14:34:33 +0800
Message-ID: <02eb01cbcb48$13ad4f00$3b07ed00$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvLSAvJpXLjLC3ARhqxkgOPu7d8Qw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements process/thread related codes. Backtrace and stacktrace are here.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/stacktrace.h  |   31 +++
 arch/unicore32/include/asm/thread_info.h |  154 ++++++++++++
 arch/unicore32/kernel/init_task.c        |   44 ++++
 arch/unicore32/kernel/process.c          |  389 ++++++++++++++++++++++++++++++
 arch/unicore32/kernel/stacktrace.c       |  131 ++++++++++
 arch/unicore32/lib/backtrace.S           |  163 +++++++++++++
 6 files changed, 912 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/stacktrace.h
 create mode 100644 arch/unicore32/include/asm/thread_info.h
 create mode 100644 arch/unicore32/kernel/init_task.c
 create mode 100644 arch/unicore32/kernel/process.c
 create mode 100644 arch/unicore32/kernel/stacktrace.c
 create mode 100644 arch/unicore32/lib/backtrace.S

diff --git a/arch/unicore32/include/asm/stacktrace.h b/arch/unicore32/include/asm/stacktrace.h
new file mode 100644
index 0000000..76edc65
--- /dev/null
+++ b/arch/unicore32/include/asm/stacktrace.h
@@ -0,0 +1,31 @@
+/*
+ * linux/arch/unicore32/include/asm/stacktrace.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __UNICORE_STACKTRACE_H__
+#define __UNICORE_STACKTRACE_H__
+
+struct stackframe {
+	unsigned long fp;
+	unsigned long sp;
+	unsigned long lr;
+	unsigned long pc;
+};
+
+#ifdef CONFIG_FRAME_POINTER
+extern int unwind_frame(struct stackframe *frame);
+#else
+#define unwind_frame(f) (-EINVAL)
+#endif
+extern void walk_stackframe(struct stackframe *frame,
+			    int (*fn)(struct stackframe *, void *), void *data);
+
+#endif	/* __UNICORE_STACKTRACE_H__ */
diff --git a/arch/unicore32/include/asm/thread_info.h b/arch/unicore32/include/asm/thread_info.h
new file mode 100644
index 0000000..c270e9e
--- /dev/null
+++ b/arch/unicore32/include/asm/thread_info.h
@@ -0,0 +1,154 @@
+/*
+ * linux/arch/unicore32/include/asm/thread_info.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_THREAD_INFO_H__
+#define __UNICORE_THREAD_INFO_H__
+
+#ifdef __KERNEL__
+
+#include <linux/compiler.h>
+#include <asm/fpstate.h>
+
+#define THREAD_SIZE_ORDER	1
+#define THREAD_SIZE		8192
+#define THREAD_START_SP		(THREAD_SIZE - 8)
+
+#ifndef __ASSEMBLY__
+
+struct task_struct;
+struct exec_domain;
+
+#include <asm/types.h>
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+struct cpu_context_save {
+	__u32	r4;
+	__u32	r5;
+	__u32	r6;
+	__u32	r7;
+	__u32	r8;
+	__u32	r9;
+	__u32	r10;
+	__u32	r11;
+	__u32	r12;
+	__u32	r13;
+	__u32	r14;
+	__u32	r15;
+	__u32	r16;
+	__u32	r17;
+	__u32	r18;
+	__u32	r19;
+	__u32	r20;
+	__u32	r21;
+	__u32	r22;
+	__u32	r23;
+	__u32	r24;
+	__u32	r25;
+	__u32	r26;
+	__u32	fp;
+	__u32	sp;
+	__u32	pc;
+};
+
+/*
+ * low level task data that entry.S needs immediate access to.
+ * __switch_to() assumes cpu_context follows immediately after cpu_domain.
+ */
+struct thread_info {
+	unsigned long		flags;		/* low level flags */
+	int			preempt_count;	/* 0 => preemptable */
+						/* <0 => bug */
+	mm_segment_t		addr_limit;	/* address limit */
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	__u32			cpu;		/* cpu */
+	struct cpu_context_save	cpu_context;	/* cpu context */
+	__u32			syscall;	/* syscall number */
+	__u8			used_cp[16];	/* thread used copro */
+#ifdef CONFIG_UNICORE_FPU_F64
+	struct fp_state		fpstate __attribute__((aligned(8)));
+#endif
+	struct restart_block	restart_block;
+};
+
+#define INIT_THREAD_INFO(tsk)						\
+{									\
+	.task		= &tsk,						\
+	.exec_domain	= &default_exec_domain,				\
+	.flags		= 0,						\
+	.preempt_count	= INIT_PREEMPT_COUNT,				\
+	.addr_limit	= KERNEL_DS,					\
+	.restart_block	= {						\
+		.fn	= do_no_restart_syscall,			\
+	},								\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+
+/*
+ * how to get the thread information struct from C
+ */
+static inline struct thread_info *current_thread_info(void) __attribute_const__;
+
+static inline struct thread_info *current_thread_info(void)
+{
+	register unsigned long sp asm ("sp");
+	return (struct thread_info *)(sp & ~(THREAD_SIZE - 1));
+}
+
+#define thread_saved_pc(tsk)	\
+	((unsigned long)(task_thread_info(tsk)->cpu_context.pc))
+#define thread_saved_sp(tsk)	\
+	((unsigned long)(task_thread_info(tsk)->cpu_context.sp))
+#define thread_saved_fp(tsk)	\
+	((unsigned long)(task_thread_info(tsk)->cpu_context.fp))
+
+#endif
+
+/*
+ * We use bit 30 of the preempt_count to indicate that kernel
+ * preemption is occurring.  See <asm/hardirq.h>.
+ */
+#define PREEMPT_ACTIVE	0x40000000
+
+/*
+ * thread information flags:
+ *  TIF_SYSCALL_TRACE	- syscall trace active
+ *  TIF_SIGPENDING	- signal pending
+ *  TIF_NEED_RESCHED	- rescheduling necessary
+ *  TIF_NOTIFY_RESUME	- callback before returning to user
+ */
+#define TIF_SIGPENDING		0
+#define TIF_NEED_RESCHED	1
+#define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
+#define TIF_SYSCALL_TRACE	8
+#define TIF_MEMDIE		18
+#define TIF_FREEZE		19
+#define TIF_RESTORE_SIGMASK	20
+
+#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
+#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+
+/*
+ * Change these and you break ASM code in entry-common.S
+ */
+#define _TIF_WORK_MASK		0x000000ff
+
+#endif /* __KERNEL__ */
+#endif /* __UNICORE_THREAD_INFO_H__ */
diff --git a/arch/unicore32/kernel/init_task.c b/arch/unicore32/kernel/init_task.c
new file mode 100644
index 0000000..a35a1e5
--- /dev/null
+++ b/arch/unicore32/kernel/init_task.c
@@ -0,0 +1,44 @@
+/*
+ * linux/arch/unicore32/kernel/init_task.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/init_task.h>
+#include <linux/mqueue.h>
+#include <linux/uaccess.h>
+
+#include <asm/pgtable.h>
+
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+/*
+ * Initial thread structure.
+ *
+ * We need to make sure that this is 8192-byte aligned due to the
+ * way process stacks are handled. This is done by making sure
+ * the linker maps this in the .text segment right after head.S,
+ * and making head.S ensure the proper alignment.
+ *
+ * The things we do for performance..
+ */
+union thread_union init_thread_union __init_task_data = {
+	INIT_THREAD_INFO(init_task) };
+
+/*
+ * Initial task structure.
+ *
+ * All other task structs will be allocated on slabs in fork.c
+ */
+struct task_struct init_task = INIT_TASK(init_task);
+EXPORT_SYMBOL(init_task);
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
new file mode 100644
index 0000000..8d4a273
--- /dev/null
+++ b/arch/unicore32/kernel/process.c
@@ -0,0 +1,389 @@
+/*
+ * linux/arch/unicore32/kernel/process.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <stdarg.h>
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
+#include <linux/delay.h>
+#include <linux/reboot.h>
+#include <linux/interrupt.h>
+#include <linux/kallsyms.h>
+#include <linux/init.h>
+#include <linux/cpu.h>
+#include <linux/elfcore.h>
+#include <linux/pm.h>
+#include <linux/tick.h>
+#include <linux/utsname.h>
+#include <linux/uaccess.h>
+#include <linux/random.h>
+#include <linux/gpio.h>
+#include <linux/stacktrace.h>
+
+#include <asm/cacheflush.h>
+#include <asm/processor.h>
+#include <asm/system.h>
+#include <asm/stacktrace.h>
+
+#include "setup.h"
+
+static const char * const processor_modes[] = {
+	"UK00", "UK01", "UK02", "UK03", "UK04", "UK05", "UK06", "UK07",
+	"UK08", "UK09", "UK0A", "UK0B", "UK0C", "UK0D", "UK0E", "UK0F",
+	"USER", "REAL", "INTR", "PRIV", "UK14", "UK15", "UK16", "ABRT",
+	"UK18", "UK19", "UK1A", "EXTN", "UK1C", "UK1D", "UK1E", "SUSR"
+};
+
+/*
+ * The idle thread, has rather strange semantics for calling pm_idle,
+ * but this is what x86 does and we need to do the same, so that
+ * things like cpuidle get called in the same way.
+ */
+void cpu_idle(void)
+{
+	/* endless idle loop with no priority at all */
+	while (1) {
+		tick_nohz_stop_sched_tick(1);
+		while (!need_resched()) {
+			local_irq_disable();
+			stop_critical_timings();
+			cpu_do_idle();
+			local_irq_enable();
+			start_critical_timings();
+		}
+		tick_nohz_restart_sched_tick();
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
+	}
+}
+
+static char reboot_mode = 'h';
+
+int __init reboot_setup(char *str)
+{
+	reboot_mode = str[0];
+	return 1;
+}
+
+__setup("reboot=", reboot_setup);
+
+void machine_halt(void)
+{
+	gpio_set_value(GPO_SOFT_OFF, 0);
+}
+
+/*
+ * Function pointers to optional machine specific functions
+ */
+void (*pm_power_off)(void) = NULL;
+
+void machine_power_off(void)
+{
+	if (pm_power_off)
+		pm_power_off();
+	machine_halt();
+}
+
+void machine_restart(char *cmd)
+{
+	/* Disable interrupts first */
+	local_irq_disable();
+
+	/*
+	 * Tell the mm system that we are going to reboot -
+	 * we may need it to insert some 1:1 mappings so that
+	 * soft boot works.
+	 */
+	setup_mm_for_reboot(reboot_mode);
+
+	/* Clean and invalidate caches */
+	flush_cache_all();
+
+	/* Turn off caching */
+	cpu_proc_fin();
+
+	/* Push out any further dirty data, and ensure cache is empty */
+	flush_cache_all();
+
+	/*
+	 * Now handle reboot code.
+	 */
+	if (reboot_mode == 's') {
+		/* Jump into ROM at address 0xffff0000 */
+		cpu_reset(VECTORS_BASE);
+	} else {
+		PM_PLLSYSCFG = 0x00002001; /* cpu clk = 250M */
+		PM_PLLDDRCFG = 0x00100800; /* ddr clk =  44M */
+		PM_PLLVGACFG = 0x00002001; /* vga clk = 250M */
+
+		/* Use on-chip reset capability */
+		/* following instructions must be in one icache line */
+		__asm__ __volatile__(
+			"	.align 5\n\t"
+			"	stw	%1, [%0]\n\t"
+			"201:	ldw	r0, [%0]\n\t"
+			"	cmpsub.a	r0, #0\n\t"
+			"	bne	201b\n\t"
+			"	stw	%3, [%2]\n\t"
+			"	nop; nop; nop\n\t"
+			/* prefetch 3 instructions at most */
+			:
+			: "r" ((unsigned long)&PM_PMCR),
+			  "r" (PM_PMCR_CFBSYS | PM_PMCR_CFBDDR
+				| PM_PMCR_CFBVGA),
+			  "r" ((unsigned long)&RESETC_SWRR),
+			  "r" (RESETC_SWRR_SRB)
+			: "r0", "memory");
+	}
+
+	/*
+	 * Whoops - the architecture was unable to reboot.
+	 * Tell the user!
+	 */
+	mdelay(1000);
+	printk(KERN_EMERG "Reboot failed -- System halted\n");
+	do { } while (1);
+}
+
+void __show_regs(struct pt_regs *regs)
+{
+	unsigned long flags;
+	char buf[64];
+
+	printk(KERN_DEFAULT "CPU: %d    %s  (%s %.*s)\n",
+		raw_smp_processor_id(), print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+	print_symbol("PC is at %s\n", instruction_pointer(regs));
+	print_symbol("LR is at %s\n", regs->UCreg_lr);
+	printk(KERN_DEFAULT "pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
+	       "sp : %08lx  ip : %08lx  fp : %08lx\n",
+		regs->UCreg_pc, regs->UCreg_lr, regs->UCreg_asr,
+		regs->UCreg_sp, regs->UCreg_ip, regs->UCreg_fp);
+	printk(KERN_DEFAULT "r26: %08lx  r25: %08lx  r24: %08lx\n",
+		regs->UCreg_26, regs->UCreg_25,
+		regs->UCreg_24);
+	printk(KERN_DEFAULT "r23: %08lx  r22: %08lx  r21: %08lx  r20: %08lx\n",
+		regs->UCreg_23, regs->UCreg_22,
+		regs->UCreg_21, regs->UCreg_20);
+	printk(KERN_DEFAULT "r19: %08lx  r18: %08lx  r17: %08lx  r16: %08lx\n",
+		regs->UCreg_19, regs->UCreg_18,
+		regs->UCreg_17, regs->UCreg_16);
+	printk(KERN_DEFAULT "r15: %08lx  r14: %08lx  r13: %08lx  r12: %08lx\n",
+		regs->UCreg_15, regs->UCreg_14,
+		regs->UCreg_13, regs->UCreg_12);
+	printk(KERN_DEFAULT "r11: %08lx  r10: %08lx  r9 : %08lx  r8 : %08lx\n",
+		regs->UCreg_11, regs->UCreg_10,
+		regs->UCreg_09, regs->UCreg_08);
+	printk(KERN_DEFAULT "r7 : %08lx  r6 : %08lx  r5 : %08lx  r4 : %08lx\n",
+		regs->UCreg_07, regs->UCreg_06,
+		regs->UCreg_05, regs->UCreg_04);
+	printk(KERN_DEFAULT "r3 : %08lx  r2 : %08lx  r1 : %08lx  r0 : %08lx\n",
+		regs->UCreg_03, regs->UCreg_02,
+		regs->UCreg_01, regs->UCreg_00);
+
+	flags = regs->UCreg_asr;
+	buf[0] = flags & PSR_S_BIT ? 'S' : 's';
+	buf[1] = flags & PSR_Z_BIT ? 'Z' : 'z';
+	buf[2] = flags & PSR_C_BIT ? 'C' : 'c';
+	buf[3] = flags & PSR_V_BIT ? 'V' : 'v';
+	buf[4] = '\0';
+
+	printk(KERN_DEFAULT "Flags: %s  INTR o%s  REAL o%s  Mode %s  Segment %s\n",
+		buf, interrupts_enabled(regs) ? "n" : "ff",
+		fast_interrupts_enabled(regs) ? "n" : "ff",
+		processor_modes[processor_mode(regs)],
+		segment_eq(get_fs(), get_ds()) ? "kernel" : "user");
+	{
+		unsigned int ctrl;
+
+		buf[0] = '\0';
+		{
+			unsigned int transbase;
+			asm("movc %0, p0.c2, #0\n"
+			    : "=r" (transbase));
+			snprintf(buf, sizeof(buf), "  Table: %08x", transbase);
+		}
+		asm("movc %0, p0.c1, #0\n" : "=r" (ctrl));
+
+		printk(KERN_DEFAULT "Control: %08x%s\n", ctrl, buf);
+	}
+}
+
+void show_regs(struct pt_regs *regs)
+{
+	printk(KERN_DEFAULT "\n");
+	printk(KERN_DEFAULT "Pid: %d, comm: %20s\n",
+			task_pid_nr(current), current->comm);
+	__show_regs(regs);
+	__backtrace();
+}
+
+/*
+ * Free current thread data structures etc..
+ */
+void exit_thread(void)
+{
+}
+
+void flush_thread(void)
+{
+	struct thread_info *thread = current_thread_info();
+	struct task_struct *tsk = current;
+
+	memset(thread->used_cp, 0, sizeof(thread->used_cp));
+	memset(&tsk->thread.debug, 0, sizeof(struct debug_info));
+#ifdef CONFIG_UNICORE_FPU_F64
+	memset(&thread->fpstate, 0, sizeof(struct fp_state));
+#endif
+}
+
+void release_thread(struct task_struct *dead_task)
+{
+}
+
+asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
+
+int
+copy_thread(unsigned long clone_flags, unsigned long stack_start,
+	    unsigned long stk_sz, struct task_struct *p, struct pt_regs *regs)
+{
+	struct thread_info *thread = task_thread_info(p);
+	struct pt_regs *childregs = task_pt_regs(p);
+
+	*childregs = *regs;
+	childregs->UCreg_00 = 0;
+	childregs->UCreg_sp = stack_start;
+
+	memset(&thread->cpu_context, 0, sizeof(struct cpu_context_save));
+	thread->cpu_context.sp = (unsigned long)childregs;
+	thread->cpu_context.pc = (unsigned long)ret_from_fork;
+
+	if (clone_flags & CLONE_SETTLS)
+		childregs->UCreg_16 = regs->UCreg_03;
+
+	return 0;
+}
+
+/*
+ * Fill in the task's elfregs structure for a core dump.
+ */
+int dump_task_regs(struct task_struct *t, elf_gregset_t *elfregs)
+{
+	elf_core_copy_regs(elfregs, task_pt_regs(t));
+	return 1;
+}
+
+/*
+ * fill in the fpe structure for a core dump...
+ */
+int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fp)
+{
+	struct thread_info *thread = current_thread_info();
+	int used_math = thread->used_cp[1] | thread->used_cp[2];
+
+#ifdef CONFIG_UNICORE_FPU_F64
+	if (used_math)
+		memcpy(fp, &thread->fpstate, sizeof(*fp));
+#endif
+	return used_math != 0;
+}
+EXPORT_SYMBOL(dump_fpu);
+
+/*
+ * Shuffle the argument into the correct register before calling the
+ * thread function.  r1 is the thread argument, r2 is the pointer to
+ * the thread function, and r3 points to the exit function.
+ */
+asm(".pushsection .text\n"
+"	.align\n"
+"	.type	kernel_thread_helper, #function\n"
+"kernel_thread_helper:\n"
+"	mov.a	asr, r7\n"
+"	mov	r0, r4\n"
+"	mov	lr, r6\n"
+"	mov	pc, r5\n"
+"	.size	kernel_thread_helper, . - kernel_thread_helper\n"
+"	.popsection");
+
+/*
+ * Create a kernel thread.
+ */
+pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
+{
+	struct pt_regs regs;
+
+	memset(&regs, 0, sizeof(regs));
+
+	regs.UCreg_04 = (unsigned long)arg;
+	regs.UCreg_05 = (unsigned long)fn;
+	regs.UCreg_06 = (unsigned long)do_exit;
+	regs.UCreg_07 = PRIV_MODE;
+	regs.UCreg_pc = (unsigned long)kernel_thread_helper;
+	regs.UCreg_asr = regs.UCreg_07 | PSR_I_BIT;
+
+	return do_fork(flags|CLONE_VM|CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
+}
+EXPORT_SYMBOL(kernel_thread);
+
+unsigned long get_wchan(struct task_struct *p)
+{
+	struct stackframe frame;
+	int count = 0;
+	if (!p || p == current || p->state == TASK_RUNNING)
+		return 0;
+
+	frame.fp = thread_saved_fp(p);
+	frame.sp = thread_saved_sp(p);
+	frame.lr = 0;			/* recovered from the stack */
+	frame.pc = thread_saved_pc(p);
+	do {
+		int ret = unwind_frame(&frame);
+		if (ret < 0)
+			return 0;
+		if (!in_sched_functions(frame.pc))
+			return frame.pc;
+	} while ((count++) < 16);
+	return 0;
+}
+
+unsigned long arch_randomize_brk(struct mm_struct *mm)
+{
+	unsigned long range_end = mm->brk + 0x02000000;
+	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+}
+
+/*
+ * The vectors page is always readable from user space for the
+ * atomic helpers and the signal restart code.  Let's declare a mapping
+ * for it so it is visible through ptrace and /proc/<pid>/mem.
+ */
+
+int vectors_user_mapping(void)
+{
+	struct mm_struct *mm = current->mm;
+	return install_special_mapping(mm, 0xffff0000, PAGE_SIZE,
+				       VM_READ | VM_EXEC |
+				       VM_MAYREAD | VM_MAYEXEC |
+				       VM_ALWAYSDUMP | VM_RESERVED,
+				       NULL);
+}
+
+const char *arch_vma_name(struct vm_area_struct *vma)
+{
+	return (vma->vm_start == 0xffff0000) ? "[vectors]" : NULL;
+}
diff --git a/arch/unicore32/kernel/stacktrace.c b/arch/unicore32/kernel/stacktrace.c
new file mode 100644
index 0000000..b34030b
--- /dev/null
+++ b/arch/unicore32/kernel/stacktrace.c
@@ -0,0 +1,131 @@
+/*
+ * linux/arch/unicore32/kernel/stacktrace.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/stacktrace.h>
+
+#include <asm/stacktrace.h>
+
+#if defined(CONFIG_FRAME_POINTER)
+/*
+ * Unwind the current stack frame and store the new register values in the
+ * structure passed as argument. Unwinding is equivalent to a function return,
+ * hence the new PC value rather than LR should be used for backtrace.
+ *
+ * With framepointer enabled, a simple function prologue looks like this:
+ *	mov	ip, sp
+ *	stmdb	sp!, {fp, ip, lr, pc}
+ *	sub	fp, ip, #4
+ *
+ * A simple function epilogue looks like this:
+ *	ldm	sp, {fp, sp, pc}
+ *
+ * Note that with framepointer enabled, even the leaf functions have the same
+ * prologue and epilogue, therefore we can ignore the LR value in this case.
+ */
+int notrace unwind_frame(struct stackframe *frame)
+{
+	unsigned long high, low;
+	unsigned long fp = frame->fp;
+
+	/* only go to a higher address on the stack */
+	low = frame->sp;
+	high = ALIGN(low, THREAD_SIZE);
+
+	/* check current frame pointer is within bounds */
+	if (fp < (low + 12) || fp + 4 >= high)
+		return -EINVAL;
+
+	/* restore the registers from the stack frame */
+	frame->fp = *(unsigned long *)(fp - 12);
+	frame->sp = *(unsigned long *)(fp - 8);
+	frame->pc = *(unsigned long *)(fp - 4);
+
+	return 0;
+}
+#endif
+
+void notrace walk_stackframe(struct stackframe *frame,
+		     int (*fn)(struct stackframe *, void *), void *data)
+{
+	while (1) {
+		int ret;
+
+		if (fn(frame, data))
+			break;
+		ret = unwind_frame(frame);
+		if (ret < 0)
+			break;
+	}
+}
+EXPORT_SYMBOL(walk_stackframe);
+
+#ifdef CONFIG_STACKTRACE
+struct stack_trace_data {
+	struct stack_trace *trace;
+	unsigned int no_sched_functions;
+	unsigned int skip;
+};
+
+static int save_trace(struct stackframe *frame, void *d)
+{
+	struct stack_trace_data *data = d;
+	struct stack_trace *trace = data->trace;
+	unsigned long addr = frame->pc;
+
+	if (data->no_sched_functions && in_sched_functions(addr))
+		return 0;
+	if (data->skip) {
+		data->skip--;
+		return 0;
+	}
+
+	trace->entries[trace->nr_entries++] = addr;
+
+	return trace->nr_entries >= trace->max_entries;
+}
+
+void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+{
+	struct stack_trace_data data;
+	struct stackframe frame;
+
+	data.trace = trace;
+	data.skip = trace->skip;
+
+	if (tsk != current) {
+		data.no_sched_functions = 1;
+		frame.fp = thread_saved_fp(tsk);
+		frame.sp = thread_saved_sp(tsk);
+		frame.lr = 0;		/* recovered from the stack */
+		frame.pc = thread_saved_pc(tsk);
+	} else {
+		register unsigned long current_sp asm("sp");
+
+		data.no_sched_functions = 0;
+		frame.fp = (unsigned long)__builtin_frame_address(0);
+		frame.sp = current_sp;
+		frame.lr = (unsigned long)__builtin_return_address(0);
+		frame.pc = (unsigned long)save_stack_trace_tsk;
+	}
+
+	walk_stackframe(&frame, save_trace, &data);
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
+}
+
+void save_stack_trace(struct stack_trace *trace)
+{
+	save_stack_trace_tsk(current, trace);
+}
+EXPORT_SYMBOL_GPL(save_stack_trace);
+#endif
diff --git a/arch/unicore32/lib/backtrace.S b/arch/unicore32/lib/backtrace.S
new file mode 100644
index 0000000..ef01d77
--- /dev/null
+++ b/arch/unicore32/lib/backtrace.S
@@ -0,0 +1,163 @@
+/*
+ * linux/arch/unicore32/lib/backtrace.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+		.text
+
+@ fp is 0 or stack frame
+
+#define frame	v4
+#define sv_fp	v5
+#define sv_pc	v6
+#define offset	v8
+
+ENTRY(__backtrace)
+		mov	r0, fp
+
+ENTRY(c_backtrace)
+
+#if !defined(CONFIG_FRAME_POINTER) || !defined(CONFIG_PRINTK)
+		mov	pc, lr
+ENDPROC(__backtrace)
+ENDPROC(c_backtrace)
+#else
+		stm.w	(v4 - v8, lr), [sp-]	@ Save an extra register
+						@ so we have a location...
+		mov.a	frame, r0		@ if frame pointer is zero
+		beq	no_frame		@ we have no stack frames
+
+1:		stm.w	(pc), [sp-]		@ calculate offset of PC stored
+		ldw.w	r0, [sp]+, #4		@ by stmfd for this CPU
+		adr	r1, 1b
+		sub	offset, r0, r1
+
+/*
+ * Stack frame layout:
+ *             optionally saved caller registers (r4 - r10)
+ *             saved fp
+ *             saved sp
+ *             saved lr
+ *    frame => saved pc
+ *             optionally saved arguments (r0 - r3)
+ * saved sp => <next word>
+ *
+ * Functions start with the following code sequence:
+ *                  mov   ip, sp
+ *                  stm.w (r0 - r3), [sp-] (optional)
+ * corrected pc =>  stm.w sp, (..., fp, ip, lr, pc)
+ */
+for_each_frame:
+
+1001:		ldw	sv_pc, [frame+], #0	@ get saved pc
+1002:		ldw	sv_fp, [frame+], #-12	@ get saved fp
+
+		sub	sv_pc, sv_pc, offset	@ Correct PC for prefetching
+
+1003:		ldw	r2, [sv_pc+], #-4	@ if stmfd sp, {args} exists,
+		ldw	r3, .Ldsi+4		@ adjust saved 'pc' back one
+		cxor.a	r3, r2 >> #14		@ instruction
+		beq	201f
+		sub	r0, sv_pc, #4		@ allow for mov
+		b	202f
+201:
+		sub	r0, sv_pc, #8		@ allow for mov + stmia
+202:
+		ldw	r1, [frame+], #-4	@ get saved lr
+		mov	r2, frame
+		b.l	dump_backtrace_entry
+
+		ldw	r1, [sv_pc+], #-4	@ if stmfd sp, {args} exists,
+		ldw	r3, .Ldsi+4
+		cxor.a	r3, r1 >> #14
+		bne	1004f
+		ldw	r0, [frame+], #-8	@ get sp
+		sub	r0, r0, #4		@ point at the last arg
+		b.l	.Ldumpstm		@ dump saved registers
+
+1004:		ldw	r1, [sv_pc+], #0	@ if stmfd {, fp, ip, lr, pc}
+		ldw	r3, .Ldsi		@ instruction exists,
+		cxor.a	r3, r1 >> #14
+		bne	201f
+		sub	r0, frame, #16
+		b.l	.Ldumpstm		@ dump saved registers
+201:
+		cxor.a	sv_fp, #0		@ zero saved fp means
+		beq	no_frame		@ no further frames
+
+		csub.a	sv_fp, frame		@ next frame must be
+		mov	frame, sv_fp		@ above the current frame
+		bua	for_each_frame
+
+1006:		adr	r0, .Lbad
+		mov	r1, frame
+		b.l	printk
+no_frame:	ldm.w	(v4 - v8, pc), [sp]+
+ENDPROC(__backtrace)
+ENDPROC(c_backtrace)
+
+		.pushsection __ex_table,"a"
+		.align	3
+		.long	1001b, 1006b
+		.long	1002b, 1006b
+		.long	1003b, 1006b
+		.long	1004b, 1006b
+		.popsection
+
+#define instr v4
+#define reg   v5
+#define stack v6
+
+.Ldumpstm:	stm.w	(instr, reg, stack, v7, lr), [sp-]
+		mov	stack, r0
+		mov	instr, r1
+		mov	reg, #14
+		mov	v7, #0
+1:		mov	r3, #1
+		csub.a	reg, #8
+		bne	201f
+		sub	reg, reg, #3
+201:
+		cand.a	instr, r3 << reg
+		beq	2f
+		add	v7, v7, #1
+		cxor.a	v7, #6
+		cmoveq	v7, #1
+		cmoveq	r1, #'\n'
+		cmovne	r1, #' '
+		ldw.w	r3, [stack]+, #-4
+		mov	r2, reg
+		csub.a	r2, #8
+		bsl	201f
+		sub	r2, r2, #3
+201:
+		cand.a	instr, #0x40		@ if H is 1, high 16 regs
+		beq	201f
+		add	r2, r2, #0x10		@ so r2 need add 16
+201:
+		adr	r0, .Lfp
+		b.l	printk
+2:		sub.a	reg, reg, #1
+		bns	1b
+		cxor.a	v7, #0
+		beq	201f
+		adr	r0, .Lcr
+		b.l	printk
+201:		ldm.w	(instr, reg, stack, v7, pc), [sp]+
+
+.Lfp:		.asciz	"%cr%d:%08x"
+.Lcr:		.asciz	"\n"
+.Lbad:		.asciz	"Backtrace aborted due to bad frame pointer <%p>\n"
+		.align
+.Ldsi:		.word	0x92eec000 >> 14	@ stm.w sp, (... fp, ip, lr, pc)
+		.word	0x92e10000 >> 14	@ stm.w sp, ()
+
+#endif
-- 
1.7.0.4


