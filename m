Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2LEQQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:16:41 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55549 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab2LEQJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:38 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 26/44] metag: Scheduling/Process management
Date: Wed, 5 Dec 2012 16:08:44 +0000
Message-ID: <1354723742-6195-27-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/thread_info.h |  155 ++++++++++++
 arch/metag/kernel/process.c          |  453 ++++++++++++++++++++++++++++++++++
 2 files changed, 608 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/thread_info.h
 create mode 100644 arch/metag/kernel/process.c

diff --git a/arch/metag/include/asm/thread_info.h b/arch/metag/include/asm/thread_info.h
new file mode 100644
index 0000000..0ecd34d
--- /dev/null
+++ b/arch/metag/include/asm/thread_info.h
@@ -0,0 +1,155 @@
+/* thread_info.h: Meta low-level thread information
+ *
+ * Copyright (C) 2002  David Howells (dhowells@redhat.com)
+ * - Incorporating suggestions made by Linus Torvalds and Dave Miller
+ *
+ * Meta port by Imagination Technologies
+ */
+
+#ifndef _ASM_THREAD_INFO_H
+#define _ASM_THREAD_INFO_H
+
+#include <linux/compiler.h>
+#include <asm/page.h>
+
+#ifndef __ASSEMBLY__
+#include <asm/processor.h>
+#endif
+
+/*
+ * low level task data that entry.S needs immediate access to
+ * - this struct should fit entirely inside of one cache line
+ * - this struct shares the supervisor stack pages
+ * - if the contents of this structure are changed, the assembly constants must
+ *   also be changed
+ */
+#ifndef __ASSEMBLY__
+
+/* This must be 8 byte aligned so we can ensure stack alignment. */
+struct thread_info {
+	struct task_struct *task;	/* main task structure */
+	struct exec_domain *exec_domain;	/* execution domain */
+	unsigned long flags;	/* low level flags */
+	unsigned long status;	/* thread-synchronous flags */
+	u32 cpu;		/* current CPU */
+	int preempt_count;	/* 0 => preemptable, <0 => BUG */
+
+	mm_segment_t addr_limit;	/* thread address space */
+	struct restart_block restart_block;
+
+	u8 supervisor_stack[0];
+};
+
+#else /* !__ASSEMBLY__ */
+
+#include <generated/asm-offsets.h>
+
+#endif
+
+#define PREEMPT_ACTIVE		0x10000000
+
+#ifdef CONFIG_4KSTACKS
+#define THREAD_SHIFT		12
+#else
+#define THREAD_SHIFT		13
+#endif
+
+#if THREAD_SHIFT >= PAGE_SHIFT
+#define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
+#else
+#define THREAD_SIZE_ORDER	0
+#endif
+
+#define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
+
+#define STACK_WARN		(THREAD_SIZE/8)
+/*
+ * macros/functions for gaining access to the thread information structure
+ */
+#ifndef __ASSEMBLY__
+
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.flags		= 0,			\
+	.cpu		= 0,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block = {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+
+/* how to get the current stack pointer from C */
+register unsigned long current_stack_pointer asm("A0StP") __used;
+
+/* how to get the thread information struct from C */
+static inline struct thread_info *current_thread_info(void)
+{
+	return (struct thread_info *)(current_stack_pointer &
+				      ~(THREAD_SIZE - 1));
+}
+
+#define __HAVE_ARCH_KSTACK_END
+static inline int kstack_end(void *addr)
+{
+	return addr == (void *) (((unsigned long) addr & ~(THREAD_SIZE - 1))
+				 + sizeof(struct thread_info));
+}
+
+#endif
+
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files may need to
+ *   access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_SINGLESTEP		3	/* restore singlestep on return to user
+					   mode */
+#define TIF_SYSCALL_AUDIT	4	/* syscall auditing active */
+#define TIF_SECCOMP		5	/* secure computing */
+#define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
+#define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
+#define TIF_POLLING_NRFLAG      8	/* true if poll_idle() is polling
+					   TIF_NEED_RESCHED */
+#define TIF_MEMDIE		9	/* is terminating due to OOM killer */
+#define TIF_SYSCALL_TRACEPOINT  10	/* syscall tracepoint instrumentation */
+
+
+#define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
+#define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
+#define _TIF_SECCOMP		(1<<TIF_SECCOMP)
+#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
+#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
+
+/* work to do in syscall trace */
+#define _TIF_WORK_SYSCALL_MASK	(_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP | \
+				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | \
+				 _TIF_SYSCALL_TRACEPOINT)
+
+/* work to do on any return to u-space */
+#define _TIF_ALLWORK_MASK	(_TIF_SYSCALL_TRACE | _TIF_SIGPENDING      | \
+				 _TIF_NEED_RESCHED  | _TIF_SYSCALL_AUDIT   | \
+				 _TIF_SINGLESTEP    | _TIF_RESTORE_SIGMASK | \
+				 _TIF_NOTIFY_RESUME)
+
+/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		(_TIF_ALLWORK_MASK & ~(_TIF_SYSCALL_TRACE | \
+				 _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP))
+
+#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
+
+#endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/metag/kernel/process.c b/arch/metag/kernel/process.c
new file mode 100644
index 0000000..379b52e
--- /dev/null
+++ b/arch/metag/kernel/process.c
@@ -0,0 +1,453 @@
+/*
+ * Copyright (C) 2005,2006,2007,2008,2009,2010,2011 Imagination Technologies
+ *
+ * This file contains the architecture-dependent parts of process handling.
+ *
+ */
+
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/user.h>
+#include <linux/reboot.h>
+#include <linux/elfcore.h>
+#include <linux/fs.h>
+#include <linux/tick.h>
+#include <linux/slab.h>
+#include <linux/mman.h>
+#include <linux/pm.h>
+#include <linux/uaccess.h>
+#include <asm/user_gateway.h>
+#include <asm/tcm.h>
+#include <asm/traps.h>
+#include <asm/switch_to.h>
+
+void cpu_idle(void)
+{
+	set_thread_flag(TIF_POLLING_NRFLAG);
+
+	while (1) {
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
+
+		while (!need_resched()) {
+#ifdef CONFIG_HOTPLUG_CPU
+			if (cpu_is_offline(smp_processor_id()))
+				cpu_die();
+#endif
+			__asm__ volatile ("SWITCH #0x400000\n"
+					  : : : "memory");
+		}
+
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
+		schedule_preempt_disabled();
+	 }
+}
+
+void (*pm_power_off)(void);
+EXPORT_SYMBOL(pm_power_off);
+
+void (*soc_restart)(char *cmd);
+void (*soc_halt)(void);
+
+void machine_restart(char *cmd)
+{
+	if (soc_restart)
+		soc_restart(cmd);
+	hard_processor_halt(HALT_OK);
+}
+
+void machine_halt(void)
+{
+	if (soc_halt)
+		soc_halt();
+	smp_send_stop();
+	hard_processor_halt(HALT_OK);
+}
+
+void machine_power_off(void)
+{
+	if (pm_power_off)
+		pm_power_off();
+	smp_send_stop();
+	hard_processor_halt(HALT_OK);
+}
+
+#define FLAG_Z 0x8
+#define FLAG_N 0x4
+#define FLAG_O 0x2
+#define FLAG_C 0x1
+
+void show_regs(struct pt_regs *regs)
+{
+	int i;
+	const char *AX0_names[] = {"A0StP", "A0FrP"};
+	const char *AX1_names[] = {"A1GbP", "A1LbP"};
+
+	const char *DX0_names[] = {
+		"D0Re0",
+		"D0Ar6",
+		"D0Ar4",
+		"D0Ar2",
+		"D0FrT",
+		"D0.5 ",
+		"D0.6 ",
+		"D0.7 "
+	};
+
+	const char *DX1_names[] = {
+		"D1Re0",
+		"D1Ar5",
+		"D1Ar3",
+		"D1Ar1",
+		"D1RtP",
+		"D1.5 ",
+		"D1.6 ",
+		"D1.7 "
+	};
+
+	pr_info(" pt_regs @ %p\n", regs);
+	pr_info(" SaveMask = 0x%04hx\n", regs->ctx.SaveMask);
+	pr_info(" Flags = 0x%04hx (%c%c%c%c)\n", regs->ctx.Flags,
+		regs->ctx.Flags & FLAG_Z ? 'Z' : 'z',
+		regs->ctx.Flags & FLAG_N ? 'N' : 'n',
+		regs->ctx.Flags & FLAG_O ? 'O' : 'o',
+		regs->ctx.Flags & FLAG_C ? 'C' : 'c');
+	pr_info(" TXRPT = 0x%08x\n", regs->ctx.CurrRPT);
+	pr_info(" PC = 0x%08x\n", regs->ctx.CurrPC);
+
+	/* AX regs */
+	for (i = 0; i < 2; i++) {
+		pr_info(" %s = 0x%08x    ",
+			AX0_names[i],
+			regs->ctx.AX[i].U0);
+		printk(" %s = 0x%08x\n",
+			AX1_names[i],
+			regs->ctx.AX[i].U1);
+	}
+
+	if (regs->ctx.SaveMask & TBICTX_XEXT_BIT)
+		pr_warn(" Extended state present - AX2.[01] will be WRONG\n");
+
+	/* Special place with AXx.2 */
+	pr_info(" A0.2  = 0x%08x    ",
+		regs->ctx.Ext.AX2.U0);
+	printk(" A1.2  = 0x%08x\n",
+		regs->ctx.Ext.AX2.U1);
+
+	/* 'extended' AX regs (nominally, just AXx.3) */
+	for (i = 0; i < (TBICTX_AX_REGS - 3); i++) {
+		pr_info(" A0.%d  = 0x%08x    ", i + 3, regs->ctx.AX3[i].U0);
+		printk(" A1.%d  = 0x%08x\n", i + 3, regs->ctx.AX3[i].U1);
+	}
+
+	for (i = 0; i < 8; i++) {
+		pr_info(" %s = 0x%08x    ", DX0_names[i], regs->ctx.DX[i].U0);
+		printk(" %s = 0x%08x\n", DX1_names[i], regs->ctx.DX[i].U1);
+	}
+
+	show_trace(NULL, (unsigned long *)regs->ctx.AX[0].U0, regs);
+}
+
+extern void kernel_thread_helper(void);
+__asm__(".pushsection .text\n\t"
+	".type _kernel_thread_helper,function\n\t"
+	"_kernel_thread_helper:\n\t"
+	"SWAP    PC,D1RtP\n\t"
+	"MOV     D1Ar1,D0Re0\n\t"
+	"MOVT    D1RtP,#HI(_do_exit)\n\t"
+	"CALL    D1RtP,#LO(_do_exit)\n\t"
+	".size   _kernel_thread_helper,.-_kernel_thread_helper\n\t"
+	".popsection");
+
+/*
+ * Create a kernel thread
+ */
+int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
+{
+	struct pt_regs regs;
+	unsigned long global_base;
+
+	memset(&regs, 0, sizeof(regs));
+	regs.ctx.DX[3].U1 = (unsigned long)arg;
+	regs.ctx.DX[4].U1 = (unsigned long)fn;
+
+	asm volatile("MOV %0,A1GbP\n" : "=r" (global_base));
+	regs.ctx.AX[0].U1 = (unsigned long)global_base;
+
+	regs.ctx.CurrPC = (unsigned long)kernel_thread_helper;
+
+	/* Ok, create the new process.. */
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
+		       &regs, 0, NULL, NULL);
+}
+
+int copy_thread(unsigned long clone_flags, unsigned long usp,
+		unsigned long unused, struct task_struct *tsk,
+		struct pt_regs *regs)
+{
+	struct pt_regs *childregs = task_pt_regs(tsk);
+	void *kernel_context = ((void *) childregs +
+				sizeof(struct pt_regs));
+
+	BUG_ON(((unsigned long)childregs) & 0x7);
+	BUG_ON(((unsigned long)kernel_context) & 0x7);
+
+	/* Get a pointer to where the new child's register block should have
+	 * been pushed.
+	 * The Meta's stack grows upwards, and the context is the the first
+	 * thing to be pushed by TBX (phew)
+	 */
+	*childregs = *regs;
+
+	/* Set the correct stack for the clone mode */
+	if (user_mode(childregs)) {
+		childregs->ctx.AX[0].U0 = ALIGN(usp, 8);
+		tsk->thread.int_depth = 1;
+	} else {
+		childregs->ctx.AX[0].U0 = (unsigned long) kernel_context;
+		tsk->thread.int_depth = 2;
+	}
+
+	/* set return value for child process */
+	childregs->ctx.DX[0].U0 = 0;
+
+	tsk->thread.kernel_context = __TBISwitchInit(kernel_context,
+						     ret_from_fork,
+						     0, 0);
+
+	/* The TLS pointer is passed as an argument to sys_clone. */
+	if (clone_flags & CLONE_SETTLS)
+		tsk->thread.tls_ptr = (__force void __user *)regs->ctx.DX[1].U1;
+
+#ifdef CONFIG_METAG_FPU
+	if (tsk->thread.fpu_context) {
+		struct meta_fpu_context *ctx;
+
+		ctx = kmemdup(tsk->thread.fpu_context,
+			      sizeof(struct meta_fpu_context), GFP_ATOMIC);
+		tsk->thread.fpu_context = ctx;
+	}
+#endif
+
+#ifdef CONFIG_METAG_DSP
+	if (tsk->thread.dsp_context) {
+		struct meta_ext_context *ctx;
+		int i;
+
+		ctx = kmemdup(tsk->thread.dsp_context,
+			      sizeof(struct meta_ext_context), GFP_ATOMIC);
+		for (i = 0; i < 2; i++)
+			ctx->ram[i] = kmemdup(ctx->ram[i], ctx->ram_sz[i],
+					      GFP_ATOMIC);
+		tsk->thread.dsp_context = ctx;
+	}
+#endif
+
+	return 0;
+}
+
+#ifdef CONFIG_METAG_FPU
+static void alloc_fpu_context(struct thread_struct *thread)
+{
+	thread->fpu_context = kzalloc(sizeof(struct meta_fpu_context),
+				      GFP_ATOMIC);
+}
+
+static void clear_fpu(struct thread_struct *thread)
+{
+	thread->user_flags &= ~TBICTX_FPAC_BIT;
+	kfree(thread->fpu_context);
+	thread->fpu_context = NULL;
+}
+#else
+static void clear_fpu(struct thread_struct *thread)
+{
+}
+#endif
+
+#ifdef CONFIG_METAG_DSP
+static void clear_dsp(struct thread_struct *thread)
+{
+	if (thread->dsp_context) {
+		kfree(thread->dsp_context->ram[0]);
+		kfree(thread->dsp_context->ram[1]);
+
+		kfree(thread->dsp_context);
+
+		thread->dsp_context = NULL;
+	}
+
+	TBI_SETREG(D0.8, 0);
+}
+#else
+static void clear_dsp(struct thread_struct *thread)
+{
+}
+#endif
+
+struct task_struct *__sched __switch_to(struct task_struct *prev,
+					struct task_struct *next)
+{
+	TBIRES to, from;
+
+	to.Switch.pCtx = next->thread.kernel_context;
+	to.Switch.pPara = prev;
+
+#ifdef CONFIG_METAG_FPU
+	if (prev->thread.user_flags & TBICTX_FPAC_BIT) {
+		struct pt_regs *regs = task_pt_regs(prev);
+		TBIRES state;
+
+		state.Sig.SaveMask = prev->thread.user_flags;
+		state.Sig.pCtx = &regs->ctx;
+
+		if (!prev->thread.fpu_context)
+			alloc_fpu_context(&prev->thread);
+		if (prev->thread.fpu_context)
+			__TBICtxFPUSave(state, prev->thread.fpu_context);
+	}
+	/*
+	 * Force a restore of the FPU context next time this process is
+	 * scheduled.
+	 */
+	if (prev->thread.fpu_context)
+		prev->thread.fpu_context->needs_restore = true;
+#endif
+
+
+	from = __TBISwitch(to, &prev->thread.kernel_context);
+
+	/* Restore TLS pointer for this process. */
+	set_gateway_tls(current->thread.tls_ptr);
+
+	return (struct task_struct *) from.Switch.pPara;
+}
+
+int sys_clone(unsigned long clone_flags,
+	      unsigned long newsp,
+	      unsigned long parent_tidptr,
+	      unsigned long child_tidptr,
+	      unsigned long tls,
+	      unsigned long arg6,
+	      struct pt_regs *pregs)
+{
+	if (!newsp)
+		newsp = pregs->ctx.AX[0].U0;
+
+	return do_fork(clone_flags, newsp, pregs, 0,
+		       (int __user *)parent_tidptr,
+		       (int __user *)child_tidptr);
+}
+
+void flush_thread(void)
+{
+	clear_fpu(&current->thread);
+	clear_dsp(&current->thread);
+}
+
+/*
+ * Free current thread data structures etc.
+ */
+void exit_thread(void)
+{
+	clear_fpu(&current->thread);
+	clear_dsp(&current->thread);
+}
+
+/* TODO: figure out how to unwind the kernel stack here to figure out
+ * where we went to sleep. */
+unsigned long get_wchan(struct task_struct *p)
+{
+	return 0;
+}
+
+int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)
+{
+	/* Returning 0 indicates that the FPU state was not stored (as it was
+	 * not in use) */
+	return 0;
+}
+
+#ifdef CONFIG_METAG_USER_TCM
+
+#define ELF_MIN_ALIGN	PAGE_SIZE
+
+#define ELF_PAGESTART(_v) ((_v) & ~(unsigned long)(ELF_MIN_ALIGN-1))
+#define ELF_PAGEOFFSET(_v) ((_v) & (ELF_MIN_ALIGN-1))
+#define ELF_PAGEALIGN(_v) (((_v) + ELF_MIN_ALIGN - 1) & ~(ELF_MIN_ALIGN - 1))
+
+#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
+
+unsigned long __metag_elf_map(struct file *filep, unsigned long addr,
+			      struct elf_phdr *eppnt, int prot, int type,
+			      unsigned long total_size)
+{
+	unsigned long map_addr, size;
+	unsigned long page_off = ELF_PAGEOFFSET(eppnt->p_vaddr);
+	unsigned long raw_size = eppnt->p_filesz + page_off;
+	unsigned long off = eppnt->p_offset - page_off;
+	unsigned int tcm_tag;
+	addr = ELF_PAGESTART(addr);
+	size = ELF_PAGEALIGN(raw_size);
+
+	/* mmap() will return -EINVAL if given a zero size, but a
+	 * segment with zero filesize is perfectly valid */
+	if (!size)
+		return addr;
+
+	tcm_tag = tcm_lookup_tag(addr);
+
+	if (tcm_tag != TCM_INVALID_TAG)
+		type &= ~MAP_FIXED;
+
+	/*
+	* total_size is the size of the ELF (interpreter) image.
+	* The _first_ mmap needs to know the full size, otherwise
+	* randomization might put this image into an overlapping
+	* position with the ELF binary image. (since size < total_size)
+	* So we first map the 'big' image - and unmap the remainder at
+	* the end. (which unmap is needed for ELF images with holes.)
+	*/
+	if (total_size) {
+		total_size = ELF_PAGEALIGN(total_size);
+		map_addr = vm_mmap(filep, addr, total_size, prot, type, off);
+		if (!BAD_ADDR(map_addr))
+			vm_munmap(map_addr+size, total_size-size);
+	} else
+		map_addr = vm_mmap(filep, addr, size, prot, type, off);
+
+	if (!BAD_ADDR(map_addr) && tcm_tag != TCM_INVALID_TAG) {
+		struct tcm_allocation *tcm;
+		unsigned long tcm_addr;
+
+		tcm = kmalloc(sizeof(*tcm), GFP_KERNEL);
+		if (!tcm)
+			return -ENOMEM;
+
+		tcm_addr = tcm_alloc(tcm_tag, raw_size);
+		if (tcm_addr != addr) {
+			kfree(tcm);
+			return -ENOMEM;
+		}
+
+		tcm->tag = tcm_tag;
+		tcm->addr = tcm_addr;
+		tcm->size = raw_size;
+
+		list_add(&tcm->list, &current->mm->context.tcm);
+
+		eppnt->p_vaddr = map_addr;
+		if (copy_from_user((void *) addr, (void __user *) map_addr,
+				   raw_size))
+			return -EFAULT;
+	}
+
+	return map_addr;
+}
+#endif
-- 
1.7.7.6


