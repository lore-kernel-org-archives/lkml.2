Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab0HCSWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:22:55 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19465 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab0HCSWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:22:47 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org, hschauhan@nulltrace.org,
        David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 3/5] MIPS: Add KProbe support.
Date: Tue,  3 Aug 2010 11:22:20 -0700
Message-Id: <1280859742-26364-4-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
References: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 03 Aug 2010 18:22:46.0266 (UTC) FILETIME=[DEFF75A0:01CB3338]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is based on previous work by Sony and Himanshu Chauhan.

I have done some cleanup and implemented JProbes and KRETPROBES.  The
KRETPROBES part is pretty much copied verbatim from powerpc.  A
possible future enhance might be to factor out the common code.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Himanshu Chauhan <hschauhan@nulltrace.org>
---
 arch/mips/Kconfig               |    2 +
 arch/mips/Makefile              |    3 +
 arch/mips/include/asm/break.h   |    2 +
 arch/mips/include/asm/kdebug.h  |    3 +
 arch/mips/include/asm/kprobes.h |   91 +++++++
 arch/mips/kernel/Makefile       |    1 +
 arch/mips/kernel/kprobes.c      |  562 +++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/traps.c        |   22 ++-
 arch/mips/mm/fault.c            |   15 +-
 9 files changed, 699 insertions(+), 2 deletions(-)
 create mode 100644 arch/mips/include/asm/kprobes.h
 create mode 100644 arch/mips/kernel/kprobes.c

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index aaca439..36642df 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -10,6 +10,8 @@ config MIPS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 	select RTC_LIB if !MACH_LOONGSON
 
 mainmenu "Linux/MIPS Kernel Configuration"
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 9296cbf..f0d1960 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -259,6 +259,9 @@ endif
 vmlinux.32: vmlinux
 	$(OBJCOPY) -O $(32bit-bfd) $(OBJCOPYFLAGS) $< $@
 
+
+#obj-$(CONFIG_KPROBES)		+= kprobes.o
+
 #
 # The 64-bit ELF tools are pretty broken so at this time we generate 64-bit
 # ELF files from 32-bit files by conversion.
diff --git a/arch/mips/include/asm/break.h b/arch/mips/include/asm/break.h
index 44437ed..9161e68 100644
--- a/arch/mips/include/asm/break.h
+++ b/arch/mips/include/asm/break.h
@@ -30,6 +30,8 @@
 #define BRK_BUG		512	/* Used by BUG() */
 #define BRK_KDB		513	/* Used in KDB_ENTER() */
 #define BRK_MEMU	514	/* Used by FPU emulator */
+#define BRK_KPROBE_BP	515	/* Kprobe break */
+#define BRK_KPROBE_SSTEPBP 516	/* Kprobe single step software implementation */
 #define BRK_MULOVF	1023	/* Multiply overflow */
 
 #endif /* __ASM_BREAK_H */
diff --git a/arch/mips/include/asm/kdebug.h b/arch/mips/include/asm/kdebug.h
index 5bf62aa..6a9af5f 100644
--- a/arch/mips/include/asm/kdebug.h
+++ b/arch/mips/include/asm/kdebug.h
@@ -8,6 +8,9 @@ enum die_val {
 	DIE_FP,
 	DIE_TRAP,
 	DIE_RI,
+	DIE_PAGE_FAULT,
+	DIE_BREAK,
+	DIE_SSTEPBP
 };
 
 #endif /* _ASM_MIPS_KDEBUG_H */
diff --git a/arch/mips/include/asm/kprobes.h b/arch/mips/include/asm/kprobes.h
new file mode 100644
index 0000000..fe58e08
--- /dev/null
+++ b/arch/mips/include/asm/kprobes.h
@@ -0,0 +1,91 @@
+/*
+ *  Kernel Probes (KProbes)
+ *  include/asm-mips/kprobes.h
+ *
+ *  Copyright 2006 Sony Corp.
+ *  Copyright 2010 Cavium Networks
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _ASM_KPROBES_H
+#define _ASM_KPROBES_H
+
+#include <linux/ptrace.h>
+#include <linux/types.h>
+
+#include <asm/kdebug.h>
+#include <asm/inst.h>
+
+#define  __ARCH_WANT_KPROBES_INSN_SLOT
+
+struct kprobe;
+struct pt_regs;
+
+typedef union mips_instruction kprobe_opcode_t;
+
+#define MAX_INSN_SIZE 2
+
+#define flush_insn_slot(p)						\
+do {									\
+	flush_icache_range((unsigned long)p->addr,			\
+			   (unsigned long)p->addr +			\
+			   (MAX_INSN_SIZE * sizeof(kprobe_opcode_t)));	\
+} while (0)
+
+
+#define kretprobe_blacklist_size 0
+
+void arch_remove_kprobe(struct kprobe *p);
+
+/* Architecture specific copy of original instruction*/
+struct arch_specific_insn {
+	/* copy of the original instruction */
+	kprobe_opcode_t *insn;
+};
+
+struct prev_kprobe {
+	struct kprobe *kp;
+	unsigned long status;
+	unsigned long old_SR;
+	unsigned long saved_SR;
+	unsigned long saved_epc;
+};
+
+#define MAX_JPROBES_STACK_SIZE 128
+#define MAX_JPROBES_STACK_ADDR \
+	(((unsigned long)current_thread_info()) + THREAD_SIZE - 32 - sizeof(struct pt_regs))
+
+#define MIN_JPROBES_STACK_SIZE(ADDR)					\
+	((((ADDR) + MAX_JPROBES_STACK_SIZE) > MAX_JPROBES_STACK_ADDR)	\
+		? MAX_JPROBES_STACK_ADDR - (ADDR)			\
+		: MAX_JPROBES_STACK_SIZE)
+
+
+/* per-cpu kprobe control block */
+struct kprobe_ctlblk {
+	unsigned long kprobe_status;
+	unsigned long kprobe_old_SR;
+	unsigned long kprobe_saved_SR;
+	unsigned long kprobe_saved_epc;
+	unsigned long jprobe_saved_sp;
+	struct pt_regs jprobe_saved_regs;
+	u8 jprobes_stack[MAX_JPROBES_STACK_SIZE];
+	struct prev_kprobe prev_kprobe;
+};
+
+extern int kprobe_exceptions_notify(struct notifier_block *self,
+				    unsigned long val, void *data);
+
+#endif				/* _ASM_KPROBES_H */
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index ff5ec2e..06f8482 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_IRQ_TXX9)		+= irq_txx9.o
 obj-$(CONFIG_IRQ_GT641XX)	+= irq-gt641xx.o
 obj-$(CONFIG_IRQ_GIC)		+= irq-gic.o
 
+obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_32BIT)		+= scall32-o32.o
 obj-$(CONFIG_64BIT)		+= scall64-64.o
 obj-$(CONFIG_MIPS32_COMPAT)	+= linux32.o ptrace32.o signal32.o
diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
new file mode 100644
index 0000000..a74ccd2
--- /dev/null
+++ b/arch/mips/kernel/kprobes.c
@@ -0,0 +1,562 @@
+/*
+ *  Kernel Probes (KProbes)
+ *  arch/mips/kernel/kprobes.c
+ *
+ *  Copyright 2006 Sony Corp.
+ *  Copyright 2010 Cavium Networks
+ *
+ *  Some portions copied from the powerpc version.
+ *
+ *   Copyright (C) IBM Corporation, 2002, 2004
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kprobes.h>
+#include <linux/preempt.h>
+#include <linux/kdebug.h>
+#include <linux/slab.h>
+
+#include <asm/cacheflush.h>
+#include <asm/ptrace.h>
+#include <asm/break.h>
+#include <asm/inst.h>
+
+static const union mips_instruction breakpoint_insn = {
+	.b_format = {
+		.opcode = spec_op,
+		.code = BRK_KPROBE_BP,
+		.func = break_op
+	}
+};
+
+static const union mips_instruction breakpoint2_insn = {
+	.b_format = {
+		.opcode = spec_op,
+		.code = BRK_KPROBE_SSTEPBP,
+		.func = break_op
+	}
+};
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe);
+DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+
+static int __kprobes insn_has_delayslot(union mips_instruction insn)
+{
+	switch (insn.i_format.opcode) {
+
+		/*
+		 * This group contains:
+		 * jr and jalr are in r_format format.
+		 */
+	case spec_op:
+		switch (insn.r_format.func) {
+		case jr_op:
+		case jalr_op:
+			break;
+		default:
+			goto insn_ok;
+		}
+
+		/*
+		 * This group contains:
+		 * bltz_op, bgez_op, bltzl_op, bgezl_op,
+		 * bltzal_op, bgezal_op, bltzall_op, bgezall_op.
+		 */
+	case bcond_op:
+
+		/*
+		 * These are unconditional and in j_format.
+		 */
+	case jal_op:
+	case j_op:
+
+		/*
+		 * These are conditional and in i_format.
+		 */
+	case beq_op:
+	case beql_op:
+	case bne_op:
+	case bnel_op:
+	case blez_op:
+	case blezl_op:
+	case bgtz_op:
+	case bgtzl_op:
+
+		/*
+		 * These are the FPA/cp1 branch instructions.
+		 */
+	case cop1_op:
+
+#ifdef CONFIG_CPU_CAVIUM_OCTEON
+	case lwc2_op: /* This is bbit0 on Octeon */
+	case ldc2_op: /* This is bbit032 on Octeon */
+	case swc2_op: /* This is bbit1 on Octeon */
+	case sdc2_op: /* This is bbit132 on Octeon */
+#endif
+		return 1;
+	default:
+		break;
+	}
+insn_ok:
+	return 0;
+}
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	union mips_instruction insn;
+	union mips_instruction prev_insn;
+	int ret = 0;
+
+	prev_insn = p->addr[-1];
+	insn = p->addr[0];
+
+	if (insn_has_delayslot(insn) || insn_has_delayslot(prev_insn)) {
+		pr_notice("Kprobes for branch and jump instructions are not supported\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* insn: must be on special executable page on mips. */
+	p->ainsn.insn = get_insn_slot();
+	if (!p->ainsn.insn) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * In the kprobe->ainsn.insn[] array we store the original
+	 * instruction at index zero and a break trap instruction at
+	 * index one.
+	 */
+
+	memcpy(&p->ainsn.insn[0], p->addr, sizeof(kprobe_opcode_t));
+	p->ainsn.insn[1] = breakpoint2_insn;
+	p->opcode = *p->addr;
+
+out:
+	return ret;
+}
+
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	*(p->addr) = breakpoint_insn;
+	flush_icache_range((unsigned long)p->addr,
+			   (unsigned long)p->addr +
+			   (MAX_INSN_SIZE * sizeof(kprobe_opcode_t)));
+}
+
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	*p->addr = p->opcode;
+	flush_icache_range((unsigned long)p->addr,
+			   (unsigned long)p->addr +
+			   (MAX_INSN_SIZE * sizeof(kprobe_opcode_t)));
+}
+
+void __kprobes arch_remove_kprobe(struct kprobe *p)
+{
+	free_insn_slot(p->ainsn.insn, 0);
+}
+
+static void save_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	kcb->prev_kprobe.kp = kprobe_running();
+	kcb->prev_kprobe.status = kcb->kprobe_status;
+	kcb->prev_kprobe.old_SR = kcb->kprobe_old_SR;
+	kcb->prev_kprobe.saved_SR = kcb->kprobe_saved_SR;
+	kcb->prev_kprobe.saved_epc = kcb->kprobe_saved_epc;
+}
+
+static void restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->kprobe_old_SR = kcb->prev_kprobe.old_SR;
+	kcb->kprobe_saved_SR = kcb->prev_kprobe.saved_SR;
+	kcb->kprobe_saved_epc = kcb->prev_kprobe.saved_epc;
+}
+
+static void set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
+			       struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = p;
+	kcb->kprobe_saved_SR = kcb->kprobe_old_SR = (regs->cp0_status & ST0_IE);
+	kcb->kprobe_saved_epc = regs->cp0_epc;
+}
+
+static void prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
+{
+	regs->cp0_status &= ~ST0_IE;
+
+	/* single step inline if the instruction is a break */
+	if (p->opcode.word == breakpoint_insn.word ||
+	    p->opcode.word == breakpoint2_insn.word)
+		regs->cp0_epc = (unsigned long)p->addr;
+	else
+		regs->cp0_epc = (unsigned long)&p->ainsn.insn[0];
+}
+
+static int __kprobes kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *p;
+	int ret = 0;
+	kprobe_opcode_t *addr;
+	struct kprobe_ctlblk *kcb;
+
+	addr = (kprobe_opcode_t *) regs->cp0_epc;
+
+	/*
+	 * We don't want to be preempted for the entire
+	 * duration of kprobe processing
+	 */
+	preempt_disable();
+	kcb = get_kprobe_ctlblk();
+
+	/* Check we're not actually recursing */
+	if (kprobe_running()) {
+		p = get_kprobe(addr);
+		if (p) {
+			if (kcb->kprobe_status == KPROBE_HIT_SS &&
+			    p->ainsn.insn->word == breakpoint_insn.word) {
+				regs->cp0_status &= ~ST0_IE;
+				regs->cp0_status |= kcb->kprobe_saved_SR;
+				goto no_kprobe;
+			}
+			/*
+			 * We have reentered the kprobe_handler(), since
+			 * another probe was hit while within the handler.
+			 * We here save the original kprobes variables and
+			 * just single step on the instruction of the new probe
+			 * without calling any user handlers.
+			 */
+			save_previous_kprobe(kcb);
+			set_current_kprobe(p, regs, kcb);
+			kprobes_inc_nmissed_count(p);
+			prepare_singlestep(p, regs);
+			kcb->kprobe_status = KPROBE_REENTER;
+			return 1;
+		} else {
+			if (addr->word != breakpoint_insn.word) {
+				/*
+				 * The breakpoint instruction was removed by
+				 * another cpu right after we hit, no further
+				 * handling of this interrupt is appropriate
+				 */
+				ret = 1;
+				goto no_kprobe;
+			}
+			p = __get_cpu_var(current_kprobe);
+			if (p->break_handler && p->break_handler(p, regs))
+				goto ss_probe;
+		}
+		goto no_kprobe;
+	}
+
+	p = get_kprobe(addr);
+	if (!p) {
+		if (addr->word != breakpoint_insn.word) {
+			/*
+			 * The breakpoint instruction was removed right
+			 * after we hit it.  Another cpu has removed
+			 * either a probepoint or a debugger breakpoint
+			 * at this address.  In either case, no further
+			 * handling of this interrupt is appropriate.
+			 */
+			ret = 1;
+		}
+		/* Not one of ours: let kernel handle it */
+		goto no_kprobe;
+	}
+
+	set_current_kprobe(p, regs, kcb);
+	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+
+	if (p->pre_handler && p->pre_handler(p, regs)) {
+		/* handler has already set things up, so skip ss setup */
+		return 1;
+	}
+
+ss_probe:
+	prepare_singlestep(p, regs);
+	kcb->kprobe_status = KPROBE_HIT_SS;
+	return 1;
+
+no_kprobe:
+	preempt_enable_no_resched();
+	return ret;
+
+}
+
+/*
+ * Called after single-stepping.  p->addr is the address of the
+ * instruction whose first byte has been replaced by the "break 0"
+ * instruction.  To avoid the SMP problems that can occur when we
+ * temporarily put back the original opcode to single-step, we
+ * single-stepped a copy of the instruction.  The address of this
+ * copy is p->ainsn.insn.
+ *
+ * This function prepares to return from the post-single-step
+ * breakpoint trap.
+ */
+static void __kprobes resume_execution(struct kprobe *p,
+				       struct pt_regs *regs,
+				       struct kprobe_ctlblk *kcb)
+{
+	unsigned long orig_epc = kcb->kprobe_saved_epc;
+	regs->cp0_epc = orig_epc + 4;
+}
+
+static inline int post_kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (!cur)
+		return 0;
+
+	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		cur->post_handler(cur, regs, 0);
+	}
+
+	resume_execution(cur, regs, kcb);
+
+	regs->cp0_status |= kcb->kprobe_saved_SR;
+
+	/* Restore back the original saved kprobes variables and continue. */
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		restore_previous_kprobe(kcb);
+		goto out;
+	}
+	reset_current_kprobe();
+out:
+	preempt_enable_no_resched();
+
+	return 1;
+}
+
+static inline int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
+		return 1;
+
+	if (kcb->kprobe_status & KPROBE_HIT_SS) {
+		resume_execution(cur, regs, kcb);
+		regs->cp0_status |= kcb->kprobe_old_SR;
+
+		reset_current_kprobe();
+		preempt_enable_no_resched();
+	}
+	return 0;
+}
+
+/*
+ * Wrapper routine for handling exceptions.
+ */
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+
+	struct die_args *args = (struct die_args *)data;
+	int ret = NOTIFY_DONE;
+
+	switch (val) {
+	case DIE_BREAK:
+		if (kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_SSTEPBP:
+		if (post_kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+
+	case DIE_PAGE_FAULT:
+		/* kprobe_running() needs smp_processor_id() */
+		preempt_disable();
+
+		if (kprobe_running()
+		    && kprobe_fault_handler(args->regs, args->trapnr))
+			ret = NOTIFY_STOP;
+		preempt_enable();
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	kcb->jprobe_saved_regs = *regs;
+	kcb->jprobe_saved_sp = regs->regs[29];
+
+	memcpy(kcb->jprobes_stack, (void *)kcb->jprobe_saved_sp,
+	       MIN_JPROBES_STACK_SIZE(kcb->jprobe_saved_sp));
+
+	regs->cp0_epc = (unsigned long)(jp->entry);
+
+	return 1;
+}
+
+/* Defined in the inline asm below. */
+void jprobe_return_end(void);
+
+void __kprobes jprobe_return(void)
+{
+	/* Assembler quirk necessitates this '0,code' business.  */
+	asm volatile(
+		"break 0,%0\n\t"
+		".globl jprobe_return_end\n"
+		"jprobe_return_end:\n"
+		: : "n" (BRK_KPROBE_BP) : "memory");
+}
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (regs->cp0_epc >= (unsigned long)jprobe_return &&
+	    regs->cp0_epc <= (unsigned long)jprobe_return_end) {
+		*regs = kcb->jprobe_saved_regs;
+		memcpy((void *)kcb->jprobe_saved_sp, kcb->jprobes_stack,
+		       MIN_JPROBES_STACK_SIZE(kcb->jprobe_saved_sp));
+		preempt_enable_no_resched();
+
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * Function return probe trampoline:
+ *	- init_kprobes() establishes a probepoint here
+ *	- When the probed function returns, this probe causes the
+ *	  handlers to fire
+ */
+static void __used kretprobe_trampoline_holder(void)
+{
+	asm volatile(
+		".set push\n\t"
+		/* Keep the assembler from reordering and placing JR here. */
+		".set noreorder\n\t"
+		"nop\n\t"
+		".global kretprobe_trampoline\n"
+		"kretprobe_trampoline:\n\t"
+		"nop\n\t"
+		".set pop"
+		: : : "memory");
+}
+
+void kretprobe_trampoline(void);
+
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				      struct pt_regs *regs)
+{
+	ri->ret_addr = (kprobe_opcode_t *) regs->regs[31];
+
+	/* Replace the return addr with trampoline addr */
+	regs->regs[31] = (unsigned long)kretprobe_trampoline;
+}
+
+/*
+ * Called when the probe at kretprobe trampoline is hit
+ */
+static int __kprobes trampoline_probe_handler(struct kprobe *p,
+						struct pt_regs *regs)
+{
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *node, *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address = (unsigned long)kretprobe_trampoline;
+
+	INIT_HLIST_HEAD(&empty_rp);
+	kretprobe_hash_lock(current, &head, &flags);
+
+	/*
+	 * It is possible to have multiple instances associated with a given
+	 * task either because an multiple functions in the call path
+	 * have a return probe installed on them, and/or more than one return
+	 * return probe was registered for a target function.
+	 *
+	 * We can handle this because:
+	 *     - instances are always inserted at the head of the list
+	 *     - when multiple return probes are registered for the same
+	 *       function, the first instance's ret_addr will point to the
+	 *       real return address, and all the rest will point to
+	 *       kretprobe_trampoline
+	 */
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		if (ri->rp && ri->rp->handler)
+			ri->rp->handler(ri, regs);
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		recycle_rp_inst(ri, &empty_rp);
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+	instruction_pointer(regs) = orig_ret_address;
+
+	reset_current_kprobe();
+	kretprobe_hash_unlock(current, &flags);
+	preempt_enable_no_resched();
+
+	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+	/*
+	 * By returning a non-zero value, we are telling
+	 * kprobe_handler() that we don't want the post_handler
+	 * to run (and have re-enabled preemption)
+	 */
+	return 1;
+}
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *)kretprobe_trampoline)
+		return 1;
+
+	return 0;
+}
+
+static struct kprobe trampoline_p = {
+	.addr = (kprobe_opcode_t *)kretprobe_trampoline,
+	.pre_handler = trampoline_probe_handler
+};
+
+int __init arch_init_kprobes(void)
+{
+	return register_kprobe(&trampoline_p);
+}
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 1515b67..4c6079f 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -25,6 +25,7 @@
 #include <linux/ptrace.h>
 #include <linux/kgdb.h>
 #include <linux/kdebug.h>
+#include <linux/kprobes.h>
 #include <linux/notifier.h>
 #include <linux/kdb.h>
 
@@ -334,7 +335,7 @@ void show_regs(struct pt_regs *regs)
 	__show_regs((struct pt_regs *)regs);
 }
 
-void show_registers(const struct pt_regs *regs)
+void show_registers(struct pt_regs *regs)
 {
 	const int field = 2 * sizeof(unsigned long);
 
@@ -783,6 +784,25 @@ asmlinkage void do_bp(struct pt_regs *regs)
 	if (bcode >= (1 << 10))
 		bcode >>= 10;
 
+	/*
+	 * notify the kprobe handlers, if instruction is likely to
+	 * pertain to them.
+	 */
+	switch (bcode) {
+	case BRK_KPROBE_BP:
+		if (notify_die(DIE_BREAK, "debug", regs, bcode, 0, 0) == NOTIFY_STOP)
+			return;
+		else
+			break;
+	case BRK_KPROBE_SSTEPBP:
+		if (notify_die(DIE_SSTEPBP, "single_step", regs, bcode, 0, 0) == NOTIFY_STOP)
+			return;
+		else
+			break;
+	default:
+		break;
+	}
+
 	do_trap_or_bp(regs, bcode, "Break");
 	return;
 
diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
index b4aac42..783ad00 100644
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -17,6 +17,7 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/module.h>
+#include <linux/kprobes.h>
 
 #include <asm/branch.h>
 #include <asm/mmu_context.h>
@@ -24,13 +25,14 @@
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/highmem.h>		/* For VMALLOC_END */
+#include <linux/kdebug.h>
 
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
  * routines.
  */
-asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
+asmlinkage void __kprobes do_page_fault(struct pt_regs *regs, unsigned long write,
 			      unsigned long address)
 {
 	struct vm_area_struct * vma = NULL;
@@ -46,6 +48,17 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
 	       field, regs->cp0_epc);
 #endif
 
+#ifdef CONFIG_KPROBES
+	/*
+	 * This is to notify the fault handler of the kprobes.  The
+	 * exception code is redundant as it is also carried in REGS,
+	 * but we pass it anyhow.
+	 */
+	if (notify_die(DIE_PAGE_FAULT, "page fault", regs, -1,
+		       (regs->cp0_cause >> 2) & 0x1f, SIGSEGV) == NOTIFY_STOP)
+		return;
+#endif
+
 	info.si_code = SEGV_MAPERR;
 
 	/*
-- 
1.7.1.1

