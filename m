Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2JNTYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:24:32 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65331 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2JNTXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:23:54 -0400
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 9/9] ARM: add uprobes support
Date: Sun, 14 Oct 2012 21:23:13 +0200
Message-Id: <1350242593-17761-9-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350242593-17761-1-git-send-email-rabin@rab.in>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic uprobes support for ARM.

perf probe --exec and SystemTap's userspace probing work.  The ARM
kprobes test code has also been run in a userspace harness to test the
uprobe instruction decoding.

Caveats:

 - Thumb is not supported
 - XOL abort/trap handling is not implemented

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/Kconfig                   |    4 +
 arch/arm/include/asm/ptrace.h      |    6 ++
 arch/arm/include/asm/thread_info.h |    5 +-
 arch/arm/include/asm/uprobes.h     |   34 +++++++
 arch/arm/kernel/Makefile           |    1 +
 arch/arm/kernel/signal.c           |    4 +
 arch/arm/kernel/uprobes.c          |  191 ++++++++++++++++++++++++++++++++++++
 7 files changed, 244 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/include/asm/uprobes.h
 create mode 100644 arch/arm/kernel/uprobes.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 272c3a1..2191b61d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -168,6 +168,10 @@ config ZONE_DMA
 config NEED_DMA_MAP_STATE
        def_bool y
 
+config ARCH_SUPPORTS_UPROBES
+	depends on KPROBES
+	def_bool y
+
 config ARCH_HAS_DMA_SET_COHERENT_MASK
 	bool
 
diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index 142d6ae..297936a 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -197,6 +197,12 @@ static inline long regs_return_value(struct pt_regs *regs)
 
 #define instruction_pointer(regs)	(regs)->ARM_pc
 
+static inline void instruction_pointer_set(struct pt_regs *regs,
+					   unsigned long val)
+{
+	instruction_pointer(regs) = val;
+}
+
 #ifdef CONFIG_SMP
 extern unsigned long profile_pc(struct pt_regs *regs);
 #else
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 8477b4c..7bedaee 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -148,6 +148,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
+#define TIF_UPROBE		7
 #define TIF_SYSCALL_TRACE	8
 #define TIF_SYSCALL_AUDIT	9
 #define TIF_SYSCALL_TRACEPOINT	10
@@ -160,6 +161,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
@@ -172,7 +174,8 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 /*
  * Change these and you break ASM code in entry-common.S
  */
-#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_RESUME)
+#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
+				 _TIF_NOTIFY_RESUME | _TIF_UPROBE)
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_ARM_THREAD_INFO_H */
diff --git a/arch/arm/include/asm/uprobes.h b/arch/arm/include/asm/uprobes.h
new file mode 100644
index 0000000..fa4b81e
--- /dev/null
+++ b/arch/arm/include/asm/uprobes.h
@@ -0,0 +1,34 @@
+#ifndef _ASM_UPROBES_H
+#define _ASM_UPROBES_H
+
+#include <asm/probes.h>
+
+typedef u32 uprobe_opcode_t;
+
+#define MAX_UINSN_BYTES		4
+#define UPROBE_XOL_SLOT_BYTES	64
+
+#define UPROBE_SWBP_INSN	0x07f001f9
+#define UPROBE_SS_INSN		0x07f001fa
+#define UPROBE_SWBP_INSN_SIZE	4
+
+struct arch_uprobe_task {
+	u32 backup;
+};
+
+struct arch_uprobe {
+	u8 insn[MAX_UINSN_BYTES];
+	uprobe_opcode_t modinsn;
+	uprobe_opcode_t bpinsn;
+	bool simulate;
+	u32 pcreg;
+	void (*prehandler)(struct arch_uprobe *auprobe,
+			   struct arch_uprobe_task *autask,
+			   struct pt_regs *regs);
+	void (*posthandler)(struct arch_uprobe *auprobe,
+			    struct arch_uprobe_task *autask,
+			    struct pt_regs *regs);
+	struct arch_specific_insn asi;
+};
+
+#endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 5bbec7b..a39f634 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o insn.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o
 obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_UPROBES)		+= uprobes.o uprobes-arm.o kprobes-arm.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-common.o patch.o
 ifdef CONFIG_THUMB2_KERNEL
 obj-$(CONFIG_KPROBES)		+= kprobes-thumb.o
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 56f72d2..3b1e88e 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -12,6 +12,7 @@
 #include <linux/personality.h>
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
+#include <linux/uprobes.h>
 
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
@@ -655,6 +656,9 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 					return restart;
 				}
 				syscall = 0;
+			} else if (thread_flags & _TIF_UPROBE) {
+				clear_thread_flag(TIF_UPROBE);
+				uprobe_notify_resume(regs);
 			} else {
 				clear_thread_flag(TIF_NOTIFY_RESUME);
 				tracehook_notify_resume(regs);
diff --git a/arch/arm/kernel/uprobes.c b/arch/arm/kernel/uprobes.c
new file mode 100644
index 0000000..f25a4af
--- /dev/null
+++ b/arch/arm/kernel/uprobes.c
@@ -0,0 +1,191 @@
+/*
+ * Copyright (C) 2012 Rabin Vincent <rabin@rab.in>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/uprobes.h>
+#include <linux/notifier.h>
+#include <linux/kprobes.h>
+
+#include <asm/opcodes.h>
+#include <asm/traps.h>
+
+#include "kprobes.h"
+
+bool is_swbp_insn(uprobe_opcode_t *insn)
+{
+	return (__mem_to_opcode_arm(*insn) & 0x0fffffff) == UPROBE_SWBP_INSN;
+}
+
+bool arch_uprobe_ignore(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	if (!auprobe->asi.insn_check_cc(regs->ARM_cpsr)) {
+		regs->ARM_pc += 4;
+		return true;
+	}
+
+	return false;
+}
+
+bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	struct kprobe kp;
+
+	if (!auprobe->simulate)
+		return false;
+
+	kp.addr = (void *) regs->ARM_pc;
+	kp.opcode = __mem_to_opcode_arm(*(unsigned int *) auprobe->insn);
+	kp.ainsn.insn_handler = auprobe->asi.insn_handler;
+
+	auprobe->asi.insn_singlestep(&kp, regs);
+
+	return true;
+}
+
+int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
+			     unsigned long addr)
+{
+	unsigned int insn;
+	unsigned int bpinsn;
+	enum kprobe_insn ret;
+
+	/* Thumb not yet support */
+	if (addr & 0x3)
+		return -EINVAL;
+
+	insn = __mem_to_opcode_arm(*(unsigned int *)auprobe->insn);
+	auprobe->modinsn = insn;
+
+	ret = arm_kprobe_decode_insn(insn, &auprobe->asi, true);
+	switch (ret) {
+	case INSN_REJECTED:
+		return -EINVAL;
+
+	case INSN_GOOD_NO_SLOT:
+		auprobe->simulate = true;
+		break;
+
+	case INSN_GOOD:
+	default:
+		break;
+	}
+
+	bpinsn = UPROBE_SWBP_INSN;
+	if (insn >= 0xe0000000)
+		bpinsn |= 0xe0000000;  /* Unconditional instruction */
+	else
+		bpinsn |= insn & 0xf0000000;  /* Copy condition from insn */
+
+	auprobe->bpinsn = bpinsn;
+
+	return 0;
+}
+
+void arch_uprobe_write_opcode(struct arch_uprobe *auprobe, void *vaddr,
+			      uprobe_opcode_t opcode)
+{
+	unsigned long *addr = vaddr;
+
+	if (opcode == UPROBE_SWBP_INSN)
+		opcode = __opcode_to_mem_arm(auprobe->bpinsn);
+
+	*addr = opcode;
+}
+
+void arch_uprobe_xol_copy(struct arch_uprobe *auprobe, void *vaddr)
+{
+	unsigned long *addr = vaddr;
+
+	addr[0] = __opcode_to_mem_arm(auprobe->modinsn);
+	addr[1] = __opcode_to_mem_arm(0xe0000000 | UPROBE_SS_INSN);
+}
+
+int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+
+	if (auprobe->prehandler)
+		auprobe->prehandler(auprobe, &utask->autask, regs);
+
+	regs->ARM_pc = utask->xol_vaddr;
+
+	return 0;
+}
+
+int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+
+	regs->ARM_pc = utask->vaddr + 4;
+
+	if (auprobe->posthandler)
+		auprobe->posthandler(auprobe, &utask->autask, regs);
+
+	return 0;
+}
+
+bool arch_uprobe_xol_was_trapped(struct task_struct *t)
+{
+	/* TODO: implement */
+	return false;
+}
+
+void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	/* TODO: implement */
+}
+
+int arch_uprobe_exception_notify(struct notifier_block *self,
+				 unsigned long val, void *data)
+{
+	return NOTIFY_DONE;
+}
+
+static int uprobe_trap_handler(struct pt_regs *regs, unsigned int instr)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if ((instr & 0x0fffffff) == UPROBE_SWBP_INSN)
+		uprobe_pre_sstep_notifier(regs);
+	else
+		uprobe_post_sstep_notifier(regs);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
+{
+	return instruction_pointer(regs);
+}
+
+static struct undef_hook uprobes_arm_break_hook = {
+	.instr_mask	= 0x0fffffff,
+	.instr_val	= UPROBE_SWBP_INSN,
+	.cpsr_mask	= MODE_MASK,
+	.cpsr_val	= USR_MODE,
+	.fn		= uprobe_trap_handler,
+};
+
+static struct undef_hook uprobes_arm_ss_hook = {
+	.instr_mask	= 0x0fffffff,
+	.instr_val	= UPROBE_SS_INSN,
+	.cpsr_mask	= MODE_MASK,
+	.cpsr_val	= USR_MODE,
+	.fn		= uprobe_trap_handler,
+};
+
+int arch_uprobes_init(void)
+{
+	register_undef_hook(&uprobes_arm_break_hook);
+	register_undef_hook(&uprobes_arm_ss_hook);
+
+	return 0;
+}
-- 
1.7.9.5

