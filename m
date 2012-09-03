Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2ICPYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:24:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab2ICPYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:24:11 -0400
Date: Mon, 3 Sep 2012 17:26:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] uprobes: Xol should send SIGTRAP if X86_EFLAGS_TF was
	set
Message-ID: <20120903152616.GA9081@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903152525.GA9028@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_uprobe_disable_step() correctly preserves X86_EFLAGS_TF and
returns to user-mode. But this means the application gets SIGTRAP
only after the next insn.

This means that UPROBE_CLEAR_TF logic is not really right. _enable
should only record the state of X86_EFLAGS_TF, and _disable should
check it separately from UPROBE_FIX_SETF.

Remove arch_uprobe_task->restore_flags, add ->saved_tf instead, and
change enable/disable accordingly.

arch_uprobe_skip_sstep() logic has the same problem, change it to
check X86_EFLAGS_TF and send SIGTRAP as well. We will cleanup this
all after we fold enable/disable_step into pre/post_hol hooks.

Note: send_sig(SIGTRAP) is not actually right, we need send_sigtrap().
But this needs more changes, handle_swbp() does the same and this is
equally wrong.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/uprobes.h |    3 +--
 arch/x86/kernel/uprobes.c      |   19 +++++++++++++------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index cee5862..d561ff5 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -46,8 +46,7 @@ struct arch_uprobe_task {
 #ifdef CONFIG_X86_64
 	unsigned long			saved_scratch_register;
 #endif
-#define UPROBE_CLEAR_TF			(1 << 0)
-	unsigned int			restore_flags;
+	unsigned int			saved_tf;
 };
 
 extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 3b4aae6..7e993d1 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -653,7 +653,7 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
  * Skip these instructions as per the currently known x86 ISA.
  * 0x66* { 0x90 | 0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0 }
  */
-bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
+static bool __skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	int i;
 
@@ -681,16 +681,21 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	return false;
 }
 
+bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	bool ret = __skip_sstep(auprobe, regs);
+	if (ret && (regs->flags & X86_EFLAGS_TF))
+		send_sig(SIGTRAP, current, 0);
+	return ret;
+}
+
 void arch_uprobe_enable_step(struct arch_uprobe *auprobe)
 {
 	struct task_struct *task = current;
 	struct arch_uprobe_task	*autask	= &task->utask->autask;
 	struct pt_regs *regs = task_pt_regs(task);
 
-	autask->restore_flags = 0;
-	if (!(regs->flags & X86_EFLAGS_TF) &&
-	    !(auprobe->fixups & UPROBE_FIX_SETF))
-		autask->restore_flags |= UPROBE_CLEAR_TF;
+	autask->saved_tf = !!(regs->flags & X86_EFLAGS_TF);
 
 	regs->flags |= X86_EFLAGS_TF;
 	if (test_tsk_thread_flag(task, TIF_BLOCKSTEP))
@@ -707,6 +712,8 @@ void arch_uprobe_disable_step(struct arch_uprobe *auprobe)
 	 * SIGTRAP if we do not clear TF. We need to examine the opcode to
 	 * make it right.
 	 */
-	if (autask->restore_flags & UPROBE_CLEAR_TF)
+	if (autask->saved_tf)
+		send_sig(SIGTRAP, task, 0);
+	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
 		regs->flags &= ~X86_EFLAGS_TF;
 }
-- 
1.5.5.1

