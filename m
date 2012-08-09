Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2HIRKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:10:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:37654 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab2HIRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:10:07 -0400
Date: Thu, 9 Aug 2012 19:09:53 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stan_shebs@mentor.com
Subject: [PATCH v2 2/5] x86/uprobes: implement x86 specific
 arch_uprobe_*_step
Message-ID: <20120809170953.GA27835@linutronix.de>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
 <1344355952-2382-3-git-send-email-bigeasy@linutronix.de>
 <20120808125709.GA4504@redhat.com>
 <50226700.9000606@linutronix.de>
 <20120808145345.GA8171@redhat.com>
 <20120809044356.GA3163@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120809044356.GA3163@in.ibm.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
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
v1..v2: re-use auprobe->fixups for fixups

 arch/x86/include/asm/uprobes.h |    2 ++
 arch/x86/kernel/uprobes.c      |   41 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

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
index 36fd420..5a43606 100644
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
 
@@ -233,12 +236,16 @@ static int validate_insn_32bits(struct arch_uprobe *auprobe, struct insn *insn)
  */
 static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
 {
-	bool fix_ip = true, fix_call = false;	/* defaults */
+	bool fix_ip = true, fix_call = false, fix_tf = false;	/* defaults */
 	int reg;
 
 	insn_get_opcode(insn);	/* should be a nop */
 
 	switch (OPCODE1(insn)) {
+	case 0x9d:
+		/* popf */
+		fix_tf = true;
+		break;
 	case 0xc3:		/* ret/lret */
 	case 0xcb:
 	case 0xc2:
@@ -277,6 +284,8 @@ static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
 		auprobe->fixups |= UPROBE_FIX_IP;
 	if (fix_call)
 		auprobe->fixups |= UPROBE_FIX_CALL;
+	if (fix_tf)
+		auprobe->fixups |= UPROBE_TF_CHANGES;
 }
 
 #ifdef CONFIG_X86_64
@@ -673,3 +682,33 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	}
 	return false;
 }
+
+void arch_uprobe_enable_step(struct arch_uprobe *auprobe)
+{
+	struct uprobe_task	*utask		= current->utask;
+	struct arch_uprobe_task	*autask		= &utask->autask;
+
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

