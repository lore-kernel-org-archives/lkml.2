Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab1KRLiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:38:22 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:44222 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab1KRLiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:38:19 -0500
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
Date: Fri, 18 Nov 2011 16:42:09 +0530
Message-Id: <20111118111209.10512.44161.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v7 3.2-rc2 27/30] uprobes: x86: introduce xol_was_trapped()
x-cbid: 11111811-2674-0000-0000-000001C5306D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Postpone the signals until we execute the probed insn. This is
simply wrong if xol insn traps and generates the signal itself. Say,
SIGILL/SIGSEGV/etc.

Adds xol_was_trapped() to detect this case. It assumes that anything
like do_page_fault/do_trap/etc sets thread.trap_no != -1.

We add uprobe_task_arch_info->saved_trap_no and change
pre_xol/post_xol to save/restore thread.trap_no, xol_was_trapped()
simply checks that ->trap_no is not equal to UPROBE_TRAP_NO == -1
set by pre_xol().

Original-patch-from: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Changelog (since v6)
- added x86 specific hook for aborting xol.

 arch/x86/include/asm/uprobes.h |    7 ++++++-
 arch/x86/kernel/uprobes.c      |   33 ++++++++++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 99d7d4b..6a47024 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -39,16 +39,21 @@ struct uprobe_arch_info {
 
 struct uprobe_task_arch_info {
 	unsigned long saved_scratch_register;
+	unsigned long saved_trap_no;
 };
 #else
 struct uprobe_arch_info {};
-struct uprobe_task_arch_info {};
+struct uprobe_task_arch_info {
+	unsigned long saved_trap_no;
+};
 #endif
 struct uprobe;
 extern int analyze_insn(struct mm_struct *mm, struct uprobe *uprobe);
 extern void set_instruction_pointer(struct pt_regs *regs, unsigned long vaddr);
 extern int pre_xol(struct uprobe *uprobe, struct pt_regs *regs);
 extern int post_xol(struct uprobe *uprobe, struct pt_regs *regs);
+extern bool xol_was_trapped(struct task_struct *tsk);
 extern int uprobe_exception_notify(struct notifier_block *self,
 				       unsigned long val, void *data);
+extern void abort_xol(struct pt_regs *regs, struct uprobe *uprobe);
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 0792fc8..3f0eb4e 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -409,6 +409,8 @@ void set_instruction_pointer(struct pt_regs *regs, unsigned long vaddr)
 	regs->ip = vaddr;
 }
 
+#define	UPROBE_TRAP_NO	-1ul
+
 /*
  * pre_xol - prepare to execute out of line.
  * @uprobe: the probepoint information.
@@ -424,6 +426,9 @@ int pre_xol(struct uprobe *uprobe, struct pt_regs *regs)
 {
 	struct uprobe_task_arch_info *tskinfo = &current->utask->tskinfo;
 
+	tskinfo->saved_trap_no = current->thread.trap_no;
+	current->thread.trap_no = UPROBE_TRAP_NO;
+
 	regs->ip = current->utask->xol_vaddr;
 	if (uprobe->fixups & UPROBES_FIX_RIP_AX) {
 		tskinfo->saved_scratch_register = regs->ax;
@@ -439,6 +444,11 @@ int pre_xol(struct uprobe *uprobe, struct pt_regs *regs)
 #else
 int pre_xol(struct uprobe *uprobe, struct pt_regs *regs)
 {
+	struct uprobe_task_arch_info *tskinfo = &current->utask->tskinfo;
+
+	tskinfo->saved_trap_no = current->thread.trap_no;
+	current->thread.trap_no = UPROBE_TRAP_NO;
+
 	regs->ip = current->utask->xol_vaddr;
 	return 0;
 }
@@ -494,7 +504,8 @@ static void handle_riprel_post_xol(struct uprobe *uprobe,
 		 * Fall through to handle stuff like "jmpq *...(%rip)" and
 		 * "callq *...(%rip)".
 		 */
-		*correction += 4;
+		if (correction)
+			*correction += 4;
 	}
 }
 #else
@@ -504,6 +515,14 @@ static void handle_riprel_post_xol(struct uprobe *uprobe,
 }
 #endif
 
+bool xol_was_trapped(struct task_struct *tsk)
+{
+	if (tsk->thread.trap_no != UPROBE_TRAP_NO)
+		return true;
+
+	return false;
+}
+
 /*
  * Called after single-stepping. To avoid the SMP problems that can
  * occur when we temporarily put back the original opcode to
@@ -534,6 +553,9 @@ int post_xol(struct uprobe *uprobe, struct pt_regs *regs)
 	int result = 0;
 	long correction;
 
+	WARN_ON_ONCE(current->thread.trap_no != UPROBE_TRAP_NO);
+
+	current->thread.trap_no = utask->tskinfo.saved_trap_no;
 	correction = (long)(utask->vaddr - utask->xol_vaddr);
 	handle_riprel_post_xol(uprobe, regs, &correction);
 	if (uprobe->fixups & UPROBES_FIX_IP)
@@ -571,3 +593,12 @@ int uprobe_exception_notify(struct notifier_block *self,
 	}
 	return ret;
 }
+
+void abort_xol(struct pt_regs *regs, struct uprobe *uprobe)
+{
+	struct uprobe_task *utask = current->utask;
+
+	current->thread.trap_no = utask->tskinfo.saved_trap_no;
+	handle_riprel_post_xol(uprobe, regs, NULL);
+	set_instruction_pointer(regs, utask->vaddr);
+}

