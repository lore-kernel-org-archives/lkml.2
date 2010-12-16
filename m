Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0LPKCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:02:38 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52474 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab0LPKCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:02:32 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:29:47 +0530
Message-Id: <20101216095947.23751.75003.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 13/20] 13: x86: x86 specific probe handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provides x86 specific implementations for setting the current
instruction pointer, pre single-step and post-singlestep handling,
enabling and disabling singlestep.

This patch also introduces TIF_UPROBE which is set by uprobes notifier
code. TIF_UPROBE indicates that there is pending work that needs to be
done at do_notify_resume time.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/include/asm/thread_info.h |    2 
 arch/x86/include/asm/uprobes.h     |    5 +
 arch/x86/kernel/uprobes.c          |  155 ++++++++++++++++++++++++++++++++++++
 3 files changed, 162 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index f0b6e5d..5b9c9f0 100644
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
@@ -107,6 +108,7 @@ struct thread_info {
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
+#define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index e38950f..0c9c8b6 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -44,4 +44,9 @@ struct uprobe_task_arch_info {};
 #endif
 struct uprobe;
 extern int analyze_insn(struct task_struct *tsk, struct uprobe *uprobe);
+extern void set_ip(struct pt_regs *regs, unsigned long vaddr);
+extern int pre_xol(struct uprobe *uprobe, struct pt_regs *regs);
+extern int post_xol(struct uprobe *uprobe, struct pt_regs *regs);
+extern void arch_uprobe_enable_sstep(struct pt_regs *regs);
+extern void arch_uprobe_disable_sstep(struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 352c71f..9a0b8a9 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -413,3 +413,158 @@ int analyze_insn(struct task_struct *tsk, struct uprobe *uprobe)
 	return 0;
 }
 
+/*
+ * @reg: reflects the saved state of the task
+ * @vaddr: the virtual address to jump to.
+ * Return 0 on success or a -ve number on error.
+ */
+void set_ip(struct pt_regs *regs, unsigned long vaddr)
+{
+	regs->ip = vaddr;
+}
+
+/*
+ * pre_xol - prepare to execute out of line.
+ * @uprobe: the probepoint information.
+ * @regs: reflects the saved user state of @tsk.
+ *
+ * If we're emulating a rip-relative instruction, save the contents
+ * of the scratch register and store the target address in that register.
+ *
+ * Returns true if @uprobe->opcode is @bkpt_insn.
+ */
+int pre_xol(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	struct uprobe_task_arch_info *tskinfo = &current->utask->tskinfo;
+
+	regs->ip = current->utask->xol_vaddr;
+#ifdef CONFIG_X86_64
+	if (uprobe->fixups & UPROBES_FIX_RIP_AX) {
+		tskinfo->saved_scratch_register = regs->ax;
+		regs->ax = current->utask->vaddr;
+		regs->ax += uprobe->arch_info.rip_rela_target_address;
+	} else if (uprobe->fixups & UPROBES_FIX_RIP_CX) {
+		tskinfo->saved_scratch_register = regs->cx;
+		regs->cx = current->utask->vaddr;
+		regs->cx += uprobe->arch_info.rip_rela_target_address;
+	}
+#endif
+	return 0;
+}
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
+	ncopied = uprobes_read_vm(current, (void __user *) sp, &ra, rasize);
+	if (unlikely(ncopied != rasize))
+		goto fail;
+	ra += correction;
+	ncopied = uprobes_write_vm(current, (void __user *) sp, &ra, rasize);
+	if (unlikely(ncopied != rasize))
+		goto fail;
+	return 0;
+
+fail:
+	printk(KERN_ERR
+		"uprobes: Failed to adjust return address after"
+		" single-stepping call instruction;"
+		" pid=%d, sp=%#lx\n", current->pid, sp);
+	return -EFAULT;
+}
+
+#ifdef CONFIG_X86_64
+static bool is_riprel_insn(struct uprobe *uprobe)
+{
+	return ((uprobe->fixups &
+			(UPROBES_FIX_RIP_AX | UPROBES_FIX_RIP_CX)) != 0);
+}
+
+#endif	/* CONFIG_X86_64 */
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
+#ifdef CONFIG_X86_64
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
+		correction += 4;
+	}
+#endif
+	if (uprobe->fixups & UPROBES_FIX_IP)
+		regs->ip += correction;
+	if (uprobe->fixups & UPROBES_FIX_CALL)
+		result = adjust_ret_addr(regs->sp, correction);
+	return result;
+}
+
+void arch_uprobe_enable_sstep(struct pt_regs *regs)
+{
+	/*
+	 * Enable single-stepping by
+	 * - Set TF on stack
+	 * - Set TIF_SINGLESTEP: Guarantees that TF is set when
+	 *	returning to user mode.
+	 *  - Indicate that TF is set by us.
+	 */
+	regs->flags |= X86_EFLAGS_TF;
+	set_thread_flag(TIF_SINGLESTEP);
+	set_thread_flag(TIF_FORCED_TF);
+}
+
+void arch_uprobe_disable_sstep(struct pt_regs *regs)
+{
+	/* Disable single-stepping by clearing what we set */
+	clear_thread_flag(TIF_SINGLESTEP);
+	clear_thread_flag(TIF_FORCED_TF);
+	regs->flags &= ~X86_EFLAGS_TF;
+}
