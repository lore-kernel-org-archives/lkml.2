Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2H3LSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:18:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:59530 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2H3LSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:18:13 -0400
Date: Thu, 30 Aug 2012 13:18:05 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stan_shebs@mentor.com
Subject: [PATCH] x86/uprobes: don't disable single stepping if it was
 already on
Message-ID: <20120830111805.GA23008@linutronix.de>
References: <20120809170953.GA27835@linutronix.de>
 <20120813132443.GB5269@redhat.com>
 <502A0C43.2000906@linutronix.de>
 <20120814142736.GA8123@redhat.com>
 <20120820104734.GA17034@linutronix.de>
 <20120822140337.GB28878@redhat.com>
 <5034E8A5.2060701@linutronix.de>
 <20120822155943.GA4237@redhat.com>
 <20120829173748.GA1121@redhat.com>
 <20120830084724.GC27415@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120830084724.GC27415@in.ibm.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change checks if single stepping was already activated and if so,
it will leave it enabled. This allows the debugger to single step over
an uprobe. The state of block stepping is not restored. It makes only
sense together with opcode & flags inspection (is this a jump that
will be taken).

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/uprobes.h |    2 ++
 arch/x86/kernel/uprobes.c      |   33 +++++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index f3971bb..cf73dbf 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -46,6 +46,8 @@ struct arch_uprobe_task {
 #ifdef CONFIG_X86_64
 	unsigned long			saved_scratch_register;
 #endif
+#define UPROBE_CLEAR_TF			(1 << 0)
+	unsigned int                    restore_flags;
 };
 
 extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index f18ea64..8aac090 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -41,6 +41,9 @@
 /* Adjust the return address of a call insn */
 #define UPROBE_FIX_CALL	0x2
 
+/* Instruction will modify TF, don't change it */
+#define UPROBE_TF_CHANGES	0x4
+
 #define UPROBE_FIX_RIP_AX	0x8000
 #define UPROBE_FIX_RIP_CX	0x4000
 
@@ -239,6 +242,10 @@ static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
 	insn_get_opcode(insn);	/* should be a nop */
 
 	switch (OPCODE1(insn)) {
+	case 0x9d:
+		/* popf */
+		auprobe->fixups |= UPROBE_TF_CHANGES;
+		break;
 	case 0xc3:		/* ret/lret */
 	case 0xcb:
 	case 0xc2:
@@ -471,6 +478,17 @@ int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	regs->ip = current->utask->xol_vaddr;
 	pre_xol_rip_insn(auprobe, regs, autask);
 
+	autask->restore_flags = 0;
+	if (!test_tsk_thread_flag(current, TIF_SINGLESTEP) &&
+			!(auprobe->fixups & UPROBE_TF_CHANGES))
+		autask->restore_flags |= UPROBE_CLEAR_TF;
+	/*
+	 * The state of TIF_BLOCKSTEP is not saved. With the TF flag set we
+	 * would to examine the opcode and the flags to make it right. Without
+	 * TF block stepping makes no sense. Instead we wakeup the debugger via
+	 * SIGTRAP in case TF was set. This has the side effect that the
+	 * debugger gets woken up even if the opcode normally wouldn't do so.
+	 */
 	user_enable_single_step(current);
 	return 0;
 }
@@ -555,6 +573,17 @@ bool arch_uprobe_xol_was_trapped(struct task_struct *t)
 	return false;
 }
 
+static void disable_single_step(void)
+{
+	struct uprobe_task *utask	= current->utask;
+	struct arch_uprobe_task *autask	= &utask->autask;
+
+	if (autask->restore_flags & UPROBE_CLEAR_TF)
+		user_disable_single_step(current);
+	else
+		send_sig(SIGTRAP, current, 0);
+}
+
 /*
  * Called after single-stepping. To avoid the SMP problems that can
  * occur when we temporarily put back the original opcode to
@@ -597,7 +626,7 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	if (auprobe->fixups & UPROBE_FIX_CALL)
 		result = adjust_ret_addr(regs->sp, correction);
 
-	user_disable_single_step(current);
+	disable_single_step();
 	return result;
 }
 
@@ -642,7 +671,7 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	current->thread.trap_nr = utask->autask.saved_trap_nr;
 	handle_riprel_post_xol(auprobe, regs, NULL);
 	instruction_pointer_set(regs, utask->vaddr);
-	user_disable_single_step(current);
+	disable_single_step();
 }
 
 /*
-- 
1.7.10.4

