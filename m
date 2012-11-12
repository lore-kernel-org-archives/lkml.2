Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab2KLLvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:51:32 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:51552 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2KLLv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:51:28 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 44/55] ARC: kprobes support
Date: Mon, 12 Nov 2012 17:19:02 +0530
Message-ID: <1352720953-24321-14-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Origin port done by Rajeshwar Ranga <rajeshwar.ranga@gmail.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig               |    2 +
 arch/arc/include/asm/kprobes.h |   62 +++++
 arch/arc/kernel/Makefile       |    1 +
 arch/arc/kernel/disasm.c       |    5 +-
 arch/arc/kernel/kprobes.c      |  525 ++++++++++++++++++++++++++++++++++++++++
 arch/arc/kernel/traps.c        |   13 +
 6 files changed, 605 insertions(+), 3 deletions(-)
 create mode 100644 arch/arc/include/asm/kprobes.h
 create mode 100644 arch/arc/kernel/kprobes.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 26609d6..3ef21be 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -22,6 +22,8 @@ config ARC
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 	select HAVE_MOD_ARCH_SPECIFIC if ARC_DW2_UNWIND
 	select HAVE_OPROFILE
 	select HOTPLUG if !INITRAMFS_SOURCE=""
diff --git a/arch/arc/include/asm/kprobes.h b/arch/arc/include/asm/kprobes.h
new file mode 100644
index 0000000..4d9c211
--- /dev/null
+++ b/arch/arc/include/asm/kprobes.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ARC_KPROBES_H
+#define _ARC_KPROBES_H
+
+#ifdef CONFIG_KPROBES
+
+typedef u16 kprobe_opcode_t;
+
+#define UNIMP_S_INSTRUCTION 0x79e0
+#define TRAP_S_2_INSTRUCTION 0x785e
+
+#define MAX_INSN_SIZE   8
+#define MAX_STACK_SIZE  64
+
+struct arch_specific_insn {
+	int is_short;
+	kprobe_opcode_t *t1_addr, *t2_addr;
+	kprobe_opcode_t t1_opcode, t2_opcode;
+};
+
+#define flush_insn_slot(p)  do {  } while (0)
+
+#define kretprobe_blacklist_size    0
+
+struct kprobe;
+
+void arch_remove_kprobe(struct kprobe *p);
+
+int kprobe_exceptions_notify(struct notifier_block *self,
+			     unsigned long val, void *data);
+
+struct prev_kprobe {
+	struct kprobe *kp;
+	unsigned long status;
+};
+
+struct kprobe_ctlblk {
+	unsigned int kprobe_status;
+	struct pt_regs jprobe_saved_regs;
+	char jprobes_stack[MAX_STACK_SIZE];
+	struct prev_kprobe prev_kprobe;
+};
+
+int kprobe_fault_handler(struct pt_regs *regs, unsigned long cause);
+void kretprobe_trampoline(void);
+void trap_is_kprobe(unsigned long cause, unsigned long address,
+			   struct pt_regs *regs);
+#else
+static void trap_is_kprobe(unsigned long cause, unsigned long address,
+			   struct pt_regs *regs)
+{
+}
+#endif
+
+#endif
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index 1fc0461..442d024 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_MODULES)			+= arcksyms.o module.o
 obj-$(CONFIG_ARC_DBG_EVENT_TIMELINE)	+= event-log.o
 obj-$(CONFIG_SMP) 			+= smp.o
 obj-$(CONFIG_ARC_DW2_UNWIND)		+= unwind.o
+obj-$(CONFIG_KPROBES)      		+= kprobes.o
 obj-$(CONFIG_ARC_FPU_SAVE_RESTORE)	+= fpu.o
 CFLAGS_fpu.o   += -mdpfp
 
diff --git a/arch/arc/kernel/disasm.c b/arch/arc/kernel/disasm.c
index 254d11a..51bad8f 100644
--- a/arch/arc/kernel/disasm.c
+++ b/arch/arc/kernel/disasm.c
@@ -497,9 +497,8 @@ void __kprobes set_reg(int reg, long val, struct pt_regs *regs,
  * @pc +2/4/6 (ARCompact ISA allows free intermixing of 16/32 bit insns).
  *
  * If @pc is a branch
- * 	-@tgt_if_br is set to branch target.
- * 	-If branch has delay slot, @next_pc updated with actual next PC.
- *
+ *	-@tgt_if_br is set to branch target.
+ *	-If branch has delay slot, @next_pc updated with actual next PC.
  */
 int __kprobes disasm_next_pc(unsigned long pc, struct pt_regs *regs,
 			     struct callee_regs *cregs,
diff --git a/arch/arc/kernel/kprobes.c b/arch/arc/kernel/kprobes.c
new file mode 100644
index 0000000..47e42f2
--- /dev/null
+++ b/arch/arc/kernel/kprobes.c
@@ -0,0 +1,525 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/kprobes.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/kdebug.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+#include <asm/current.h>
+#include <asm/disasm.h>
+
+#define MIN_STACK_SIZE(addr)	min((unsigned long)MAX_STACK_SIZE, \
+		(unsigned long)current_thread_info() + THREAD_SIZE - (addr))
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
+DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	/* Attempt to probe at unaligned address */
+	if ((unsigned long)p->addr & 0x01)
+		return -EINVAL;
+
+	/* Address should not be in exception handling code */
+
+	p->ainsn.is_short = is_short_instr((unsigned long)p->addr);
+	p->opcode = *p->addr;
+
+	return 0;
+}
+
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	*p->addr = UNIMP_S_INSTRUCTION;
+
+	flush_icache_range((unsigned long)p->addr,
+			   (unsigned long)p->addr + sizeof(kprobe_opcode_t));
+}
+
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	*p->addr = p->opcode;
+
+	flush_icache_range((unsigned long)p->addr,
+			   (unsigned long)p->addr + sizeof(kprobe_opcode_t));
+}
+
+void __kprobes arch_remove_kprobe(struct kprobe *p)
+{
+	arch_disarm_kprobe(p);
+
+	/* Can we remove the kprobe in the middle of kprobe handling? */
+	if (p->ainsn.t1_addr) {
+		*(p->ainsn.t1_addr) = p->ainsn.t1_opcode;
+
+		flush_icache_range((unsigned long)p->ainsn.t1_addr,
+				   (unsigned long)p->ainsn.t1_addr +
+				   sizeof(kprobe_opcode_t));
+
+		p->ainsn.t1_addr = NULL;
+	}
+
+	if (p->ainsn.t2_addr) {
+		*(p->ainsn.t2_addr) = p->ainsn.t2_opcode;
+
+		flush_icache_range((unsigned long)p->ainsn.t2_addr,
+				   (unsigned long)p->ainsn.t2_addr +
+				   sizeof(kprobe_opcode_t));
+
+		p->ainsn.t2_addr = NULL;
+	}
+}
+
+static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	kcb->prev_kprobe.kp = kprobe_running();
+	kcb->prev_kprobe.status = kcb->kprobe_status;
+}
+
+static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	kcb->kprobe_status = kcb->prev_kprobe.status;
+}
+
+static inline void __kprobes set_current_kprobe(struct kprobe *p)
+{
+	__get_cpu_var(current_kprobe) = p;
+}
+
+static void __kprobes resume_execution(struct kprobe *p, unsigned long addr,
+				       struct pt_regs *regs)
+{
+	/* Remove the trap instructions inserted for single step and
+	 * restore the original instructions
+	 */
+	if (p->ainsn.t1_addr) {
+		*(p->ainsn.t1_addr) = p->ainsn.t1_opcode;
+
+		flush_icache_range((unsigned long)p->ainsn.t1_addr,
+				   (unsigned long)p->ainsn.t1_addr +
+				   sizeof(kprobe_opcode_t));
+
+		p->ainsn.t1_addr = NULL;
+	}
+
+	if (p->ainsn.t2_addr) {
+		*(p->ainsn.t2_addr) = p->ainsn.t2_opcode;
+
+		flush_icache_range((unsigned long)p->ainsn.t2_addr,
+				   (unsigned long)p->ainsn.t2_addr +
+				   sizeof(kprobe_opcode_t));
+
+		p->ainsn.t2_addr = NULL;
+	}
+
+	return;
+}
+
+static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs)
+{
+	unsigned long next_pc;
+	unsigned long tgt_if_br = 0;
+	int is_branch;
+	unsigned long bta;
+
+	/* Copy the opcode back to the kprobe location and execute the
+	 * instruction. Because of this we will not be able to get into the
+	 * same kprobe until this kprobe is done
+	 */
+	*(p->addr) = p->opcode;
+
+	flush_icache_range((unsigned long)p->addr,
+			   (unsigned long)p->addr + sizeof(kprobe_opcode_t));
+
+	/* Now we insert the trap at the next location after this instruction to
+	 * single step. If it is a branch we insert the trap at possible branch
+	 * targets
+	 */
+
+	bta = regs->bta;
+
+	if (regs->status32 & 0x40) {
+		/* We are in a delay slot with the branch taken */
+
+		next_pc = bta & ~0x01;
+
+		if (!p->ainsn.is_short) {
+			if (bta & 0x01)
+				regs->blink += 2;
+			else {
+				/* Branch not taken */
+				next_pc += 2;
+
+				/* next pc is taken from bta after executing the
+				 * delay slot instruction
+				 */
+				regs->bta += 2;
+			}
+		}
+
+		is_branch = 0;
+	} else
+		is_branch =
+		    disasm_next_pc((unsigned long)p->addr, regs,
+			(struct callee_regs *) current->thread.callee_reg,
+			&next_pc, &tgt_if_br);
+
+	p->ainsn.t1_addr = (kprobe_opcode_t *) next_pc;
+	p->ainsn.t1_opcode = *(p->ainsn.t1_addr);
+	*(p->ainsn.t1_addr) = TRAP_S_2_INSTRUCTION;
+
+	flush_icache_range((unsigned long)p->ainsn.t1_addr,
+			   (unsigned long)p->ainsn.t1_addr +
+			   sizeof(kprobe_opcode_t));
+
+	if (is_branch) {
+		p->ainsn.t2_addr = (kprobe_opcode_t *) tgt_if_br;
+		p->ainsn.t2_opcode = *(p->ainsn.t2_addr);
+		*(p->ainsn.t2_addr) = TRAP_S_2_INSTRUCTION;
+
+		flush_icache_range((unsigned long)p->ainsn.t2_addr,
+				   (unsigned long)p->ainsn.t2_addr +
+				   sizeof(kprobe_opcode_t));
+	}
+}
+
+int __kprobes arc_kprobe_handler(unsigned long addr, struct pt_regs *regs)
+{
+	struct kprobe *p;
+	struct kprobe_ctlblk *kcb;
+
+	preempt_disable();
+
+	kcb = get_kprobe_ctlblk();
+	p = get_kprobe((unsigned long *)addr);
+
+	if (p) {
+		/*
+		 * We have reentered the kprobe_handler, since another kprobe
+		 * was hit while within the handler, we save the original
+		 * kprobes and single step on the instruction of the new probe
+		 * without calling any user handlers to avoid recursive
+		 * kprobes.
+		 */
+		if (kprobe_running()) {
+			save_previous_kprobe(kcb);
+			set_current_kprobe(p);
+			kprobes_inc_nmissed_count(p);
+			setup_singlestep(p, regs);
+			kcb->kprobe_status = KPROBE_REENTER;
+			return 1;
+		}
+
+		set_current_kprobe(p);
+		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+
+		/* If we have no pre-handler or it returned 0, we continue with
+		 * normal processing. If we have a pre-handler and it returned
+		 * non-zero - which is expected from setjmp_pre_handler for
+		 * jprobe, we return without single stepping and leave that to
+		 * the break-handler which is invoked by a kprobe from
+		 * jprobe_return
+		 */
+		if (!p->pre_handler || !p->pre_handler(p, regs)) {
+			setup_singlestep(p, regs);
+			kcb->kprobe_status = KPROBE_HIT_SS;
+		}
+
+		return 1;
+	} else if (kprobe_running()) {
+		p = __get_cpu_var(current_kprobe);
+		if (p->break_handler && p->break_handler(p, regs)) {
+			setup_singlestep(p, regs);
+			kcb->kprobe_status = KPROBE_HIT_SS;
+			return 1;
+		}
+	}
+
+	/* no_kprobe: */
+	preempt_enable_no_resched();
+	return 0;
+}
+
+static int __kprobes arc_post_kprobe_handler(unsigned long addr,
+					 struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (!cur)
+		return 0;
+
+	resume_execution(cur, addr, regs);
+
+	/* Rearm the kprobe */
+	arch_arm_kprobe(cur);
+
+	/*
+	 * When we return from trap instruction we go to the next instruction
+	 * We restored the actual instruction in resume_exectuiont and we to
+	 * return to the same address and execute it
+	 */
+	regs->ret = addr;
+
+	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		cur->post_handler(cur, regs, 0);
+	}
+
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		restore_previous_kprobe(kcb);
+		goto out;
+	}
+
+	reset_current_kprobe();
+
+out:
+	preempt_enable_no_resched();
+	return 1;
+}
+
+/*
+ * Fault can be for the instruction being single stepped or for the
+ * pre/post handlers in the module.
+ * This is applicable for applications like user probes, where we have the
+ * probe in user space and the handlers in the kernel
+ */
+
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned long trapnr)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	switch (kcb->kprobe_status) {
+	case KPROBE_HIT_SS:
+	case KPROBE_REENTER:
+		/*
+		 * We are here because the instruction being single stepped
+		 * caused the fault. We reset the current kprobe and allow the
+		 * exception handler as if it is regular exception. In our
+		 * case it doesn't matter because the system will be halted
+		 */
+		resume_execution(cur, (unsigned long)cur->addr, regs);
+
+		if (kcb->kprobe_status == KPROBE_REENTER)
+			restore_previous_kprobe(kcb);
+		else
+			reset_current_kprobe();
+
+		preempt_enable_no_resched();
+		break;
+
+	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SSDONE:
+		/*
+		 * We are here because the instructions in the pre/post handler
+		 * caused the fault.
+		 */
+
+		/* We increment the nmissed count for accounting,
+		 * we can also use npre/npostfault count for accouting
+		 * these specific fault cases.
+		 */
+		kprobes_inc_nmissed_count(cur);
+
+		/*
+		 * We come here because instructions in the pre/post
+		 * handler caused the page_fault, this could happen
+		 * if handler tries to access user space by
+		 * copy_from_user(), get_user() etc. Let the
+		 * user-specified handler try to fix it first.
+		 */
+		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
+			return 1;
+
+		/*
+		 * In case the user-specified fault handler returned zero,
+		 * try to fix up.
+		 */
+		if (fixup_exception(regs))
+			return 1;
+
+		/*
+		 * fixup_exception() could not handle it,
+		 * Let do_page_fault() fix it.
+		 */
+		break;
+
+	default:
+		break;
+	}
+	return 0;
+}
+
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	struct die_args *args = data;
+	unsigned long addr = args->err;
+	int ret = NOTIFY_DONE;
+
+	switch (val) {
+	case DIE_IERR:
+		if (arc_kprobe_handler(addr, args->regs))
+			return NOTIFY_STOP;
+		break;
+
+	case DIE_TRAP:
+		if (arc_post_kprobe_handler(addr, args->regs))
+			return NOTIFY_STOP;
+		break;
+
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long sp_addr = regs->sp;
+
+	kcb->jprobe_saved_regs = *regs;
+	memcpy(kcb->jprobes_stack, (void *)sp_addr, MIN_STACK_SIZE(sp_addr));
+	regs->ret = (unsigned long)(jp->entry);
+
+	return 1;
+}
+
+void __kprobes jprobe_return(void)
+{
+	__asm__ __volatile__("unimp_s");
+	return;
+}
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long sp_addr;
+
+	*regs = kcb->jprobe_saved_regs;
+	sp_addr = regs->sp;
+	memcpy((void *)sp_addr, kcb->jprobes_stack, MIN_STACK_SIZE(sp_addr));
+	preempt_enable_no_resched();
+
+	return 1;
+}
+
+static void __used kretprobe_trampoline_holder(void)
+{
+	__asm__ __volatile__(".global kretprobe_trampoline\n"
+			     "kretprobe_trampoline:\n" "nop\n");
+}
+
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				      struct pt_regs *regs)
+{
+
+	ri->ret_addr = (kprobe_opcode_t *) regs->blink;
+
+	/* Replace the return addr with trampoline addr */
+	regs->blink = (unsigned long)&kretprobe_trampoline;
+}
+
+static int __kprobes trampoline_probe_handler(struct kprobe *p,
+					      struct pt_regs *regs)
+{
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *node, *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
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
+		if (orig_ret_address != trampoline_address) {
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+		}
+	}
+
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+	regs->ret = orig_ret_address;
+
+	reset_current_kprobe();
+	kretprobe_hash_unlock(current, &flags);
+	preempt_enable_no_resched();
+
+	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+
+	/* By returning a non zero value, we are telling the kprobe handler
+	 * that we don't want the post_handler to run
+	 */
+	return 1;
+}
+
+static struct kprobe trampoline_p = {
+	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
+	.pre_handler = trampoline_probe_handler
+};
+
+int __init arch_init_kprobes(void)
+{
+	/* Registering the trampoline code for the kret probe */
+	return register_kprobe(&trampoline_p);
+}
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *) &kretprobe_trampoline)
+		return 1;
+
+	return 0;
+}
+
+void trap_is_kprobe(unsigned long cause, unsigned long address,
+		    struct pt_regs *regs)
+{
+	notify_die(DIE_TRAP, "kprobe_trap", regs, address, cause, SIGTRAP);
+}
diff --git a/arch/arc/kernel/traps.c b/arch/arc/kernel/traps.c
index fd2457c..c6396b4 100644
--- a/arch/arc/kernel/traps.c
+++ b/arch/arc/kernel/traps.c
@@ -15,6 +15,7 @@
 #include <linux/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/setup.h>
+#include <asm/kprobes.h>
 
 void __init trap_init(void)
 {
@@ -90,6 +91,7 @@ void do_machine_check_fault(unsigned long cause, unsigned long address,
 	die("Machine Check Exception", regs, address, cause);
 }
 
+
 /*
  * Entry point for traps induced by ARCompact TRAP_S <n> insn
  * This is same family as TRAP0/SWI insn (use the same vector).
@@ -109,6 +111,10 @@ void do_non_swi_trap(unsigned long cause, unsigned long address,
 		trap_is_brkpt(cause, address, regs);
 		break;
 
+	case 2:
+		trap_is_kprobe(param, address, regs);
+		break;
+
 	default:
 		break;
 	}
@@ -116,10 +122,17 @@ void do_non_swi_trap(unsigned long cause, unsigned long address,
 
 /*
  * Entry point for Instruction Error Exception
+ *  -For a corner case, ARC kprobes implementation resorts to using
+ *   this exception, hence the check
  */
 void do_insterror_or_kprobe(unsigned long cause,
 				       unsigned long address,
 				       struct pt_regs *regs)
 {
+	/* Check if this exception is caused by kprobes */
+	if (notify_die(DIE_IERR, "kprobe_ierr", regs, address,
+		       cause, SIGILL) == NOTIFY_STOP)
+		return;
+
 	insterror_is_error(cause, address, regs);
 }
-- 
1.7.4.1

