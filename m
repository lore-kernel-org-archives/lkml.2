Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab1KRLlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:41:17 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56314 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab1KRLlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:41:13 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Date: Fri, 18 Nov 2011 16:39:59 +0530
Message-Id: <20111118110959.10512.69516.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v7 3.2-rc2 17/30] x86: arch specific hooks for pre/post singlestep handling.
x-cbid: 11111802-3568-0000-0000-000000BE021F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hooks for handling pre singlestepping and post singlestepping.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/include/asm/uprobes.h |    2 +
 arch/x86/kernel/uprobes.c      |  135 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index cf794bf..99d7d4b 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -47,6 +47,8 @@ struct uprobe_task_arch_info {};
 struct uprobe;
 extern int analyze_insn(struct mm_struct *mm, struct uprobe *uprobe);
 extern void set_instruction_pointer(struct pt_regs *regs, unsigned long vaddr);
+extern int pre_xol(struct uprobe *uprobe, struct pt_regs *regs);
+extern int post_xol(struct uprobe *uprobe, struct pt_regs *regs);
 extern int uprobe_exception_notify(struct notifier_block *self,
 				       unsigned long val, void *data);
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 2ee5ddc..0792fc8 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/uprobes.h>
+#include <linux/uaccess.h>
 
 #include <linux/kdebug.h>
 #include <asm/insn.h>
@@ -409,6 +410,140 @@ void set_instruction_pointer(struct pt_regs *regs, unsigned long vaddr)
 }
 
 /*
+ * pre_xol - prepare to execute out of line.
+ * @uprobe: the probepoint information.
+ * @regs: reflects the saved user state of @tsk.
+ *
+ * If we're emulating a rip-relative instruction, save the contents
+ * of the scratch register and store the target address in that register.
+ *
+ * Returns true if @uprobe->opcode is @bkpt_insn.
+ */
+#ifdef CONFIG_X86_64
+int pre_xol(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	struct uprobe_task_arch_info *tskinfo = &current->utask->tskinfo;
+
+	regs->ip = current->utask->xol_vaddr;
+	if (uprobe->fixups & UPROBES_FIX_RIP_AX) {
+		tskinfo->saved_scratch_register = regs->ax;
+		regs->ax = current->utask->vaddr;
+		regs->ax += uprobe->arch_info.rip_rela_target_address;
+	} else if (uprobe->fixups & UPROBES_FIX_RIP_CX) {
+		tskinfo->saved_scratch_register = regs->cx;
+		regs->cx = current->utask->vaddr;
+		regs->cx += uprobe->arch_info.rip_rela_target_address;
+	}
+	return 0;
+}
+#else
+int pre_xol(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	regs->ip = current->utask->xol_vaddr;
+	return 0;
+}
+#endif
+
+/*
+ * Called by post_xol() to adjust the return address pushed by a call
+ * instruction executed out of line.
+ */
+static int adjust_ret_addr(unsigned long sp, long correction)
+{
+	int rasize, ncopied;
+	long ra = 0;
+
+	if (is_32bit_app(current))
+		rasize = 4;
+	else
+		rasize = 8;
+
+	ncopied = copy_from_user(&ra, (void __user *)sp, rasize);
+	if (unlikely(ncopied))
+		return -EFAULT;
+
+	ra += correction;
+	ncopied = copy_to_user((void __user *)sp, &ra, rasize);
+	if (unlikely(ncopied))
+		return -EFAULT;
+
+	return 0;
+}
+
+#ifdef CONFIG_X86_64
+static bool is_riprel_insn(struct uprobe *uprobe)
+{
+	return ((uprobe->fixups &
+			(UPROBES_FIX_RIP_AX | UPROBES_FIX_RIP_CX)) != 0);
+}
+
+static void handle_riprel_post_xol(struct uprobe *uprobe,
+			struct pt_regs *regs, long *correction)
+{
+	if (is_riprel_insn(uprobe)) {
+		struct uprobe_task_arch_info *tskinfo;
+		tskinfo = &current->utask->tskinfo;
+
+		if (uprobe->fixups & UPROBES_FIX_RIP_AX)
+			regs->ax = tskinfo->saved_scratch_register;
+		else
+			regs->cx = tskinfo->saved_scratch_register;
+		/*
+		 * The original instruction includes a displacement, and so
+		 * is 4 bytes longer than what we've just single-stepped.
+		 * Fall through to handle stuff like "jmpq *...(%rip)" and
+		 * "callq *...(%rip)".
+		 */
+		*correction += 4;
+	}
+}
+#else
+static void handle_riprel_post_xol(struct uprobe *uprobe,
+			struct pt_regs *regs, long *correction)
+{
+}
+#endif
+
+/*
+ * Called after single-stepping. To avoid the SMP problems that can
+ * occur when we temporarily put back the original opcode to
+ * single-step, we single-stepped a copy of the instruction.
+ *
+ * This function prepares to resume execution after the single-step.
+ * We have to fix things up as follows:
+ *
+ * Typically, the new ip is relative to the copied instruction.  We need
+ * to make it relative to the original instruction (FIX_IP).  Exceptions
+ * are return instructions and absolute or indirect jump or call instructions.
+ *
+ * If the single-stepped instruction was a call, the return address that
+ * is atop the stack is the address following the copied instruction.  We
+ * need to make it the address following the original instruction (FIX_CALL).
+ *
+ * If the original instruction was a rip-relative instruction such as
+ * "movl %edx,0xnnnn(%rip)", we have instead executed an equivalent
+ * instruction using a scratch register -- e.g., "movl %edx,(%rax)".
+ * We need to restore the contents of the scratch register and adjust
+ * the ip, keeping in mind that the instruction we executed is 4 bytes
+ * shorter than the original instruction (since we squeezed out the offset
+ * field).  (FIX_RIP_AX or FIX_RIP_CX)
+ */
+int post_xol(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+	int result = 0;
+	long correction;
+
+	correction = (long)(utask->vaddr - utask->xol_vaddr);
+	handle_riprel_post_xol(uprobe, regs, &correction);
+	if (uprobe->fixups & UPROBES_FIX_IP)
+		regs->ip += correction;
+	if (uprobe->fixups & UPROBES_FIX_CALL)
+		result = adjust_ret_addr(regs->sp, correction);
+	return result;
+}
+
+/*
  * Wrapper routine for handling exceptions.
  */
 int uprobe_exception_notify(struct notifier_block *self,

