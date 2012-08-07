Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2HGQMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:12:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:53108 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2HGQMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:12:50 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/5] x86/uprobes: implement x86 specific arch_uprobe_*_step
Date: Tue,  7 Aug 2012 18:12:29 +0200
Message-Id: <1344355952-2382-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arch specific implementation behaves like user_enable_single_step()
except that it does not disable single stepping if it was already
enabled. This allows the debugger to single step over an uprobe.
The state of block stepping is not restored. It makes only sense
together with TF and if that was enabled then the debugger is notified.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/uprobes.h |    2 ++
 arch/x86/kernel/uprobes.c      |   42 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index f3971bb..cee5862 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -46,6 +46,8 @@ struct arch_uprobe_task {
 #ifdef CONFIG_X86_64
 	unsigned long			saved_scratch_register;
 #endif
+#define UPROBE_CLEAR_TF			(1 << 0)
+	unsigned int			restore_flags;
 };
 
 extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 36fd420..8df1479 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -673,3 +673,45 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	}
 	return false;
 }
+
+static int insn_changes_flags(struct arch_uprobe *auprobe)
+{
+	/* popf reads flags from stack */
+	if (auprobe->insn[0] == 0x9d)
+		return 1;
+	/*
+	 * lock popf is not a valid opcode
+	 * iret, sysret is not an opcode allowed in userland
+	 */
+	return 0;
+}
+
+void arch_uprobe_enable_step(struct arch_uprobe *auprobe)
+{
+	struct uprobe_task	*utask		= current->utask;
+	struct arch_uprobe_task	*autask		= &utask->autask;
+
+	autask->restore_flags = 0;
+	if (!test_tsk_thread_flag(current, TIF_SINGLESTEP) &&
+			!insn_changes_flags(auprobe))
+		autask->restore_flags |= UPROBE_CLEAR_TF;
+	/*
+	 * The state of TIF_BLOCKSTEP is not saved. With the TF flag set we
+	 * would to examine the opcode and the flags to make it right. Without
+	 * TF block stepping makes no sense. Instead we wakeup the debugger via
+	 * SIGTRAP in case TF was set. This has the side effect that the
+	 * debugger gets woken up even if the opcode normally wouldn't do so.
+	 */
+	user_enable_single_step(current);
+}
+
+void arch_uprobe_disable_step(struct arch_uprobe *auprobe)
+{
+	struct uprobe_task *utask		= current->utask;
+	struct arch_uprobe_task	*autask		= &utask->autask;
+
+	if (autask->restore_flags & UPROBE_CLEAR_TF)
+		user_disable_single_step(current);
+	else
+		send_sig(SIGTRAP, current, 0);
+}
-- 
1.7.10.4

