Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab2ICPYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:24:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333Ab2ICPYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:24:00 -0400
Date: Mon, 3 Sep 2012 17:26:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] uprobes: Do not (ab)use
	TIF_SINGLESTEP/user_*_single_step() for single-stepping
Message-ID: <20120903152613.GA9078@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903152525.GA9028@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

user_enable/disable_single_step() was designed for ptrace, it assumes
a single user and does unnecessary and wrong things for uprobes. For
example:

	- arch_uprobe_enable_step() can't trust TIF_SINGLESTEP, an
	  application itself can set X86_EFLAGS_TF which must be
	  preserved after arch_uprobe_disable_step().

	- we do not want to set TIF_SINGLESTEP/TIF_FORCED_TF in
	  arch_uprobe_enable_step(), this only makes sense for ptrace.

	- otoh we leak TIF_SINGLESTEP if arch_uprobe_disable_step()
	  doesn't do user_disable_single_step(), the application will
	  be killed after the next syscall.

	- arch_uprobe_enable_step() does access_process_vm() we do
	  not need/want.

Change arch_uprobe_enable/disable_step() to set/clear X86_EFLAGS_TF
directly, this is much simpler and more correct. However, we need to
clear TIF_BLOCKSTEP/DEBUGCTLMSR_BTF before executing the probed insn,
add set_task_blockstep(false).

Note: with or without this patch, there is another (hopefully minor)
problem. A probed "pushf" insn can see the wrong X86_EFLAGS_TF set by
uprobes. Perhaps we should change _disable to update the stack, or
teach arch_uprobe_skip_sstep() to emulate this insn.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/step.c           |    2 +-
 arch/x86/kernel/uprobes.c        |   32 ++++++++++++++++++--------------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d048cad..433d2e5 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -759,6 +759,8 @@ static inline void update_debugctlmsr(unsigned long debugctlmsr)
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
 }
 
+extern void set_task_blockstep(struct task_struct *task, bool on);
+
 /*
  * from system description table in BIOS. Mostly for MCA use, but
  * others may find it useful:
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index f89cdc6..cd3b243 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -157,7 +157,7 @@ static int enable_single_step(struct task_struct *child)
 	return 1;
 }
 
-static void set_task_blockstep(struct task_struct *task, bool on)
+void set_task_blockstep(struct task_struct *task, bool on)
 {
 	unsigned long debugctl;
 
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 309a0e0..3b4aae6 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -683,26 +683,30 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 void arch_uprobe_enable_step(struct arch_uprobe *auprobe)
 {
-	struct uprobe_task	*utask		= current->utask;
-	struct arch_uprobe_task	*autask		= &utask->autask;
+	struct task_struct *task = current;
+	struct arch_uprobe_task	*autask	= &task->utask->autask;
+	struct pt_regs *regs = task_pt_regs(task);
 
 	autask->restore_flags = 0;
-	if (!test_tsk_thread_flag(current, TIF_SINGLESTEP) &&
-			!(auprobe->fixups & UPROBE_FIX_SETF))
+	if (!(regs->flags & X86_EFLAGS_TF) &&
+	    !(auprobe->fixups & UPROBE_FIX_SETF))
 		autask->restore_flags |= UPROBE_CLEAR_TF;
-	/*
-	 * The state of TIF_BLOCKSTEP is not saved. With the TF flag set we
-	 * would to examine the opcode and the flags to make it right. Without
-	 * TF block stepping makes no sense.
-	 */
-	user_enable_single_step(current);
+
+	regs->flags |= X86_EFLAGS_TF;
+	if (test_tsk_thread_flag(task, TIF_BLOCKSTEP))
+		set_task_blockstep(task, false);
 }
 
 void arch_uprobe_disable_step(struct arch_uprobe *auprobe)
 {
-	struct uprobe_task *utask		= current->utask;
-	struct arch_uprobe_task	*autask		= &utask->autask;
-
+	struct task_struct *task = current;
+	struct arch_uprobe_task	*autask	= &task->utask->autask;
+	struct pt_regs *regs = task_pt_regs(task);
+	/*
+	 * The state of TIF_BLOCKSTEP was not saved so we can get an extra
+	 * SIGTRAP if we do not clear TF. We need to examine the opcode to
+	 * make it right.
+	 */
 	if (autask->restore_flags & UPROBE_CLEAR_TF)
-		user_disable_single_step(current);
+		regs->flags &= ~X86_EFLAGS_TF;
 }
-- 
1.5.5.1

