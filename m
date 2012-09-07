Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2IGQfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:35:50 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34292 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2IGQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:53 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 07/31] arm64: Process management
Date: Fri,  7 Sep 2012 17:26:42 +0100
Message-Id: <1347035226-18649-8-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:50.0191 (UTC) FILETIME=[B90A6BF0:01CD8D15]
X-MC-Unique: 112090717275104401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GatY6008487

The patch adds support for thread creation and context switching. The
context switching CPU specific code is introduced with the CPU support
patch (part of the arch/arm64/mm/proc.S file). AArch64 supports
ASID-tagged TLBs and the ASID can be either 8 or 16-bit wide (detectable
via the ID_AA64AFR0_EL1 register).

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/mmu_context.h |  152 +++++++++++++
 arch/arm64/include/asm/thread_info.h |  127 +++++++++++
 arch/arm64/kernel/process.c          |  412 ++++++++++++++++++++++++++++++++++
 arch/arm64/mm/context.c              |  159 +++++++++++++
 4 files changed, 850 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/mmu_context.h
 create mode 100644 arch/arm64/include/asm/thread_info.h
 create mode 100644 arch/arm64/kernel/process.c
 create mode 100644 arch/arm64/mm/context.c

diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
new file mode 100644
index 0000000..f68465d
--- /dev/null
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -0,0 +1,152 @@
+/*
+ * Based on arch/arm/include/asm/mmu_context.h
+ *
+ * Copyright (C) 1996 Russell King.
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_MMU_CONTEXT_H
+#define __ASM_MMU_CONTEXT_H
+
+#include <linux/compiler.h>
+#include <linux/sched.h>
+
+#include <asm/cacheflush.h>
+#include <asm/proc-fns.h>
+#include <asm-generic/mm_hooks.h>
+#include <asm/cputype.h>
+#include <asm/pgtable.h>
+
+#define MAX_ASID_BITS	16
+
+extern unsigned int cpu_last_asid;
+
+void __init_new_context(struct task_struct *tsk, struct mm_struct *mm);
+void __new_context(struct mm_struct *mm);
+
+/*
+ * Set TTBR0 to empty_zero_page. No translations will be possible via TTBR0.
+ */
+static inline void cpu_set_reserved_ttbr0(void)
+{
+	unsigned long ttbr = page_to_phys(empty_zero_page);
+
+	asm(
+	"	msr	ttbr0_el1, %0			// set TTBR0\n"
+	"	isb"
+	:
+	: "r" (ttbr));
+}
+
+static inline void switch_new_context(struct mm_struct *mm)
+{
+	unsigned long flags;
+
+	__new_context(mm);
+
+	local_irq_save(flags);
+	cpu_switch_mm(mm->pgd, mm);
+	local_irq_restore(flags);
+}
+
+static inline void check_and_switch_context(struct mm_struct *mm,
+					    struct task_struct *tsk)
+{
+	/*
+	 * Required during context switch to avoid speculative page table
+	 * walking with the wrong TTBR.
+	 */
+	cpu_set_reserved_ttbr0();
+
+	if (!((mm->context.id ^ cpu_last_asid) >> MAX_ASID_BITS))
+		/*
+		 * The ASID is from the current generation, just switch to the
+		 * new pgd. This condition is only true for calls from
+		 * context_switch() and interrupts are already disabled.
+		 */
+		cpu_switch_mm(mm->pgd, mm);
+	else if (irqs_disabled())
+		/*
+		 * Defer the new ASID allocation until after the context
+		 * switch critical region since __new_context() cannot be
+		 * called with interrupts disabled.
+		 */
+		set_ti_thread_flag(task_thread_info(tsk), TIF_SWITCH_MM);
+	else
+		/*
+		 * That is a direct call to switch_mm() or activate_mm() with
+		 * interrupts enabled and a new context.
+		 */
+		switch_new_context(mm);
+}
+
+#define init_new_context(tsk,mm)	(__init_new_context(tsk,mm),0)
+#define destroy_context(mm)		do { } while(0)
+
+#define finish_arch_post_lock_switch \
+	finish_arch_post_lock_switch
+static inline void finish_arch_post_lock_switch(void)
+{
+	if (test_and_clear_thread_flag(TIF_SWITCH_MM)) {
+		struct mm_struct *mm = current->mm;
+		unsigned long flags;
+
+		__new_context(mm);
+
+		local_irq_save(flags);
+		cpu_switch_mm(mm->pgd, mm);
+		local_irq_restore(flags);
+	}
+}
+
+/*
+ * This is called when "tsk" is about to enter lazy TLB mode.
+ *
+ * mm:  describes the currently active mm context
+ * tsk: task which is entering lazy tlb
+ * cpu: cpu number which is entering lazy tlb
+ *
+ * tsk->mm will be NULL
+ */
+static inline void
+enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
+{
+}
+
+/*
+ * This is the actual mm switch as far as the scheduler
+ * is concerned.  No registers are touched.  We avoid
+ * calling the CPU specific function when the mm hasn't
+ * actually changed.
+ */
+static inline void
+switch_mm(struct mm_struct *prev, struct mm_struct *next,
+	  struct task_struct *tsk)
+{
+	unsigned int cpu = smp_processor_id();
+
+#ifdef CONFIG_SMP
+	/* check for possible thread migration */
+	if (!cpumask_empty(mm_cpumask(next)) &&
+	    !cpumask_test_cpu(cpu, mm_cpumask(next)))
+		__flush_icache_all();
+#endif
+	if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next)) || prev != next)
+		check_and_switch_context(next, tsk);
+}
+
+#define deactivate_mm(tsk,mm)	do { } while (0)
+#define activate_mm(prev,next)	switch_mm(prev, next, NULL)
+
+#endif
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
new file mode 100644
index 0000000..3659e46
--- /dev/null
+++ b/arch/arm64/include/asm/thread_info.h
@@ -0,0 +1,127 @@
+/*
+ * Based on arch/arm/include/asm/thread_info.h
+ *
+ * Copyright (C) 2002 Russell King.
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_THREAD_INFO_H
+#define __ASM_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+#include <linux/compiler.h>
+
+#ifndef CONFIG_ARM64_64K_PAGES
+#define THREAD_SIZE_ORDER	1
+#endif
+
+#define THREAD_SIZE		8192
+#define THREAD_START_SP		(THREAD_SIZE - 16)
+
+#ifndef __ASSEMBLY__
+
+struct task_struct;
+struct exec_domain;
+
+#include <asm/types.h>
+
+typedef unsigned long mm_segment_t;
+
+/*
+ * low level task data that entry.S needs immediate access to.
+ * __switch_to() assumes cpu_context follows immediately after cpu_domain.
+ */
+struct thread_info {
+	unsigned long		flags;		/* low level flags */
+	mm_segment_t		addr_limit;	/* address limit */
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	struct restart_block	restart_block;
+	int			preempt_count;	/* 0 => preemptable, <0 => bug */
+	int			cpu;		/* cpu */
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
+	((unsigned long)(tsk->thread.cpu_context.pc))
+#define thread_saved_sp(tsk)	\
+	((unsigned long)(tsk->thread.cpu_context.sp))
+#define thread_saved_fp(tsk)	\
+	((unsigned long)(tsk->thread.cpu_context.fp))
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
+ *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
+ *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
+ */
+#define TIF_SIGPENDING		0
+#define TIF_NEED_RESCHED	1
+#define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
+#define TIF_SYSCALL_TRACE	8
+#define TIF_POLLING_NRFLAG	16
+#define TIF_MEMDIE		18	/* is terminating due to OOM killer */
+#define TIF_FREEZE		19
+#define TIF_RESTORE_SIGMASK	20
+#define TIF_SINGLESTEP		21
+#define TIF_32BIT		22	/* 32bit process */
+#define TIF_SWITCH_MM		23	/* deferred switch_mm */
+
+#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_32BIT		(1 << TIF_32BIT)
+
+#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
+				 _TIF_NOTIFY_RESUME)
+
+#endif /* __KERNEL__ */
+#endif /* __ASM_THREAD_INFO_H */
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
new file mode 100644
index 0000000..6dfd96f
--- /dev/null
+++ b/arch/arm64/kernel/process.c
@@ -0,0 +1,412 @@
+/*
+ * Based on arch/arm/kernel/process.c
+ *
+ * Original Copyright (C) 1995  Linus Torvalds
+ * Copyright (C) 1996-2000 Russell King - Converted to ARM.
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <stdarg.h>
+
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
+#include <linux/user.h>
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
+#include <linux/hw_breakpoint.h>
+#include <linux/personality.h>
+#include <linux/notifier.h>
+
+#include <asm/compat.h>
+#include <asm/cacheflush.h>
+#include <asm/processor.h>
+#include <asm/stacktrace.h>
+#include <asm/fpsimd.h>
+
+extern void setup_mm_for_reboot(void);
+
+static void setup_restart(void)
+{
+	/*
+	 * Tell the mm system that we are going to reboot -
+	 * we may need it to insert some 1:1 mappings so that
+	 * soft boot works.
+	 */
+	setup_mm_for_reboot();
+
+	/* Clean and invalidate caches */
+	flush_cache_all();
+
+	/* Turn off caching */
+	cpu_proc_fin();
+
+	/* Push out any further dirty data, and ensure cache is empty */
+	flush_cache_all();
+}
+
+void soft_restart(unsigned long addr)
+{
+	setup_restart();
+	cpu_reset(addr);
+}
+
+/*
+ * Function pointers to optional machine specific functions
+ */
+void (*pm_power_off)(void);
+EXPORT_SYMBOL(pm_power_off);
+
+void (*pm_restart)(const char *cmd);
+EXPORT_SYMBOL_GPL(pm_restart);
+
+
+/*
+ * This is our default idle handler.
+ */
+static void default_idle(void)
+{
+	/*
+	 * This should do all the clock switching and wait for interrupt
+	 * tricks
+	 */
+	cpu_do_idle();
+	local_irq_enable();
+}
+
+void (*pm_idle)(void) = default_idle;
+EXPORT_SYMBOL(pm_idle);
+
+/*
+ * The idle thread, has rather strange semantics for calling pm_idle,
+ * but this is what x86 does and we need to do the same, so that
+ * things like cpuidle get called in the same way.  The only difference
+ * is that we always respect 'hlt_counter' to prevent low power idle.
+ */
+void cpu_idle(void)
+{
+	local_fiq_enable();
+
+	/* endless idle loop with no priority at all */
+	while (1) {
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
+		while (!need_resched()) {
+			/*
+			 * We need to disable interrupts here to ensure
+			 * we don't miss a wakeup call.
+			 */
+			local_irq_disable();
+			if (!need_resched()) {
+				stop_critical_timings();
+				pm_idle();
+				start_critical_timings();
+				/*
+				 * pm_idle functions should always return
+				 * with IRQs enabled.
+				 */
+				WARN_ON(irqs_disabled());
+			} else {
+				local_irq_enable();
+			}
+		}
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
+		schedule_preempt_disabled();
+	}
+}
+
+void machine_shutdown(void)
+{
+#ifdef CONFIG_SMP
+	smp_send_stop();
+#endif
+}
+
+void machine_halt(void)
+{
+	machine_shutdown();
+	while (1);
+}
+
+void machine_power_off(void)
+{
+	machine_shutdown();
+	if (pm_power_off)
+		pm_power_off();
+}
+
+void machine_restart(char *cmd)
+{
+	machine_shutdown();
+
+	/* Disable interrupts first */
+	local_irq_disable();
+	local_fiq_disable();
+
+	/* Now call the architecture specific reboot code. */
+	if (pm_restart)
+		pm_restart(cmd);
+
+	/*
+	 * Whoops - the architecture was unable to reboot.
+	 * Tell the user!
+	 */
+	mdelay(1000);
+	printk("Reboot failed -- System halted\n");
+	while (1);
+}
+
+void __show_regs(struct pt_regs *regs)
+{
+	int i;
+
+	printk("CPU: %d    %s  (%s %.*s)\n",
+		raw_smp_processor_id(), print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+	print_symbol("PC is at %s\n", instruction_pointer(regs));
+	print_symbol("LR is at %s\n", regs->regs[30]);
+	printk("pc : [<%016llx>] lr : [<%016llx>] pstate: %08llx\n",
+	       regs->pc, regs->regs[30], regs->pstate);
+	printk("sp : %016llx\n", regs->sp);
+	for (i = 29; i >= 0; i--) {
+		printk("x%-2d: %016llx ", i, regs->regs[i]);
+		if (i % 2 == 0)
+			printk("\n");
+	}
+	printk("\n");
+}
+
+void show_regs(struct pt_regs * regs)
+{
+	printk("\n");
+	printk("Pid: %d, comm: %20s\n", task_pid_nr(current), current->comm);
+	__show_regs(regs);
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
+	fpsimd_flush_thread();
+	flush_ptrace_hw_breakpoint(current);
+}
+
+void release_thread(struct task_struct *dead_task)
+{
+}
+
+int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
+{
+	fpsimd_save_state(&current->thread.fpsimd_state);
+	*dst = *src;
+	return 0;
+}
+
+asmlinkage void ret_from_fork(void) asm("ret_from_fork");
+
+int copy_thread(unsigned long clone_flags, unsigned long stack_start,
+		unsigned long stk_sz, struct task_struct *p,
+		struct pt_regs *regs)
+{
+	struct pt_regs *childregs = task_pt_regs(p);
+	unsigned long tls = p->thread.tp_value;
+
+	*childregs = *regs;
+	childregs->regs[0] = 0;
+
+	if (is_compat_thread(task_thread_info(p)))
+		childregs->compat_sp = stack_start;
+	else {
+		/*
+		 * Read the current TLS pointer from tpidr_el0 as it may be
+		 * out-of-sync with the saved value.
+		 */
+		asm("mrs %0, tpidr_el0" : "=r" (tls));
+		childregs->sp = stack_start;
+	}
+
+	memset(&p->thread.cpu_context, 0, sizeof(struct cpu_context));
+	p->thread.cpu_context.sp = (unsigned long)childregs;
+	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
+
+	/* If a TLS pointer was passed to clone, use that for the new thread. */
+	if (clone_flags & CLONE_SETTLS)
+		tls = regs->regs[3];
+	p->thread.tp_value = tls;
+
+	ptrace_hw_copy_thread(p);
+
+	return 0;
+}
+
+static void tls_thread_switch(struct task_struct *next)
+{
+	unsigned long tpidr, tpidrro;
+
+	if (!is_compat_task()) {
+		asm("mrs %0, tpidr_el0" : "=r" (tpidr));
+		current->thread.tp_value = tpidr;
+	}
+
+	if (is_compat_thread(task_thread_info(next))) {
+		tpidr = 0;
+		tpidrro = next->thread.tp_value;
+	} else {
+		tpidr = next->thread.tp_value;
+		tpidrro = 0;
+	}
+
+	asm(
+	"	msr	tpidr_el0, %0\n"
+	"	msr	tpidrro_el0, %1"
+	: : "r" (tpidr), "r" (tpidrro));
+}
+
+/*
+ * Thread switching.
+ */
+struct task_struct *__switch_to(struct task_struct *prev,
+				struct task_struct *next)
+{
+	struct task_struct *last;
+
+	fpsimd_thread_switch(next);
+	tls_thread_switch(next);
+	hw_breakpoint_thread_switch(next);
+
+	/* the actual thread switch */
+	last = cpu_switch_to(prev, next);
+
+	return last;
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
+int dump_fpu (struct pt_regs *regs, struct user_fp *fp)
+{
+	return 0;
+}
+EXPORT_SYMBOL(dump_fpu);
+
+/*
+ * Shuffle the argument into the correct register before calling the
+ * thread function.  x1 is the thread argument, x2 is the pointer to
+ * the thread function, and x3 points to the exit function.
+ */
+extern void kernel_thread_helper(void);
+asm(	".section .text\n"
+"	.align\n"
+"	.type	kernel_thread_helper, #function\n"
+"kernel_thread_helper:\n"
+"	mov	x0, x1\n"
+"	mov	x30, x3\n"
+"	br	x2\n"
+"	.size	kernel_thread_helper, . - kernel_thread_helper\n"
+"	.previous");
+
+#define kernel_thread_exit	do_exit
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
+	regs.regs[1] = (unsigned long)arg;
+	regs.regs[2] = (unsigned long)fn;
+	regs.regs[3] = (unsigned long)kernel_thread_exit;
+	regs.pc = (unsigned long)kernel_thread_helper;
+	regs.pstate = PSR_MODE_EL1h;
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
+	frame.pc = thread_saved_pc(p);
+	do {
+		int ret = unwind_frame(&frame);
+		if (ret < 0)
+			return 0;
+		if (!in_sched_functions(frame.pc))
+			return frame.pc;
+	} while (count ++ < 16);
+	return 0;
+}
+
+unsigned long arch_align_stack(unsigned long sp)
+{
+	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
+		sp -= get_random_int() & ~PAGE_MASK;
+	return sp & ~0xf;
+}
+
+static unsigned long randomize_base(unsigned long base)
+{
+	unsigned long range_end = base + (STACK_RND_MASK << PAGE_SHIFT) + 1;
+	return randomize_range(base, range_end, 0) ? : base;
+}
+
+unsigned long arch_randomize_brk(struct mm_struct *mm)
+{
+	return randomize_base(mm->brk);
+}
+
+unsigned long randomize_et_dyn(unsigned long base)
+{
+	return randomize_base(base);
+}
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
new file mode 100644
index 0000000..baa758d
--- /dev/null
+++ b/arch/arm64/mm/context.c
@@ -0,0 +1,159 @@
+/*
+ * Based on arch/arm/mm/context.c
+ *
+ * Copyright (C) 2002-2003 Deep Blue Solutions Ltd, all rights reserved.
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/percpu.h>
+
+#include <asm/mmu_context.h>
+#include <asm/tlbflush.h>
+#include <asm/cachetype.h>
+
+#define asid_bits(reg) \
+	(((read_cpuid(ID_AA64MMFR0_EL1) & 0xf0) >> 2) + 8)
+
+#define ASID_FIRST_VERSION	(1 << MAX_ASID_BITS)
+
+static DEFINE_RAW_SPINLOCK(cpu_asid_lock);
+unsigned int cpu_last_asid = ASID_FIRST_VERSION;
+
+/*
+ * We fork()ed a process, and we need a new context for the child to run in.
+ */
+void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
+{
+	mm->context.id = 0;
+	raw_spin_lock_init(&mm->context.id_lock);
+}
+
+static void flush_context(void)
+{
+	/* set the reserved TTBR0 before flushing the TLB */
+	cpu_set_reserved_ttbr0();
+	flush_tlb_all();
+	if (icache_is_aivivt())
+		__flush_icache_all();
+}
+
+#ifdef CONFIG_SMP
+
+static void set_mm_context(struct mm_struct *mm, unsigned int asid)
+{
+	unsigned long flags;
+
+	/*
+	 * Locking needed for multi-threaded applications where the same
+	 * mm->context.id could be set from different CPUs during the
+	 * broadcast. This function is also called via IPI so the
+	 * mm->context.id_lock has to be IRQ-safe.
+	 */
+	raw_spin_lock_irqsave(&mm->context.id_lock, flags);
+	if (likely((mm->context.id ^ cpu_last_asid) >> MAX_ASID_BITS)) {
+		/*
+		 * Old version of ASID found. Set the new one and reset
+		 * mm_cpumask(mm).
+		 */
+		mm->context.id = asid;
+		cpumask_clear(mm_cpumask(mm));
+	}
+	raw_spin_unlock_irqrestore(&mm->context.id_lock, flags);
+
+	/*
+	 * Set the mm_cpumask(mm) bit for the current CPU.
+	 */
+	cpumask_set_cpu(smp_processor_id(), mm_cpumask(mm));
+}
+
+/*
+ * Reset the ASID on the current CPU. This function call is broadcast from the
+ * CPU handling the ASID rollover and holding cpu_asid_lock.
+ */
+static void reset_context(void *info)
+{
+	unsigned int asid;
+	unsigned int cpu = smp_processor_id();
+	struct mm_struct *mm = current->active_mm;
+
+	smp_rmb();
+	asid = cpu_last_asid + cpu;
+
+	flush_context();
+	set_mm_context(mm, asid);
+
+	/* set the new ASID */
+	cpu_switch_mm(mm->pgd, mm);
+}
+
+#else
+
+static inline void set_mm_context(struct mm_struct *mm, unsigned int asid)
+{
+	mm->context.id = asid;
+	cpumask_copy(mm_cpumask(mm), cpumask_of(smp_processor_id()));
+}
+
+#endif
+
+void __new_context(struct mm_struct *mm)
+{
+	unsigned int asid;
+	unsigned int bits = asid_bits();
+
+	raw_spin_lock(&cpu_asid_lock);
+#ifdef CONFIG_SMP
+	/*
+	 * Check the ASID again, in case the change was broadcast from another
+	 * CPU before we acquired the lock.
+	 */
+	if (!unlikely((mm->context.id ^ cpu_last_asid) >> MAX_ASID_BITS)) {
+		cpumask_set_cpu(smp_processor_id(), mm_cpumask(mm));
+		raw_spin_unlock(&cpu_asid_lock);
+		return;
+	}
+#endif
+	/*
+	 * At this point, it is guaranteed that the current mm (with an old
+	 * ASID) isn't active on any other CPU since the ASIDs are changed
+	 * simultaneously via IPI.
+	 */
+	asid = ++cpu_last_asid;
+
+	/*
+	 * If we've used up all our ASIDs, we need to start a new version and
+	 * flush the TLB.
+	 */
+	if (unlikely((asid & ((1 << bits) - 1)) == 0)) {
+		/* increment the ASID version */
+		cpu_last_asid += (1 << MAX_ASID_BITS) - (1 << bits);
+		if (cpu_last_asid == 0)
+			cpu_last_asid = ASID_FIRST_VERSION;
+		asid = cpu_last_asid + smp_processor_id();
+		flush_context();
+#ifdef CONFIG_SMP
+		smp_wmb();
+		smp_call_function(reset_context, NULL, 1);
+#endif
+		cpu_last_asid += NR_CPUS - 1;
+	}
+
+	set_mm_context(mm, asid);
+	raw_spin_unlock(&cpu_asid_lock);
+}

