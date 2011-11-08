Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1KHRMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:12:20 -0500
Received: from ams-iport-2.cisco.com ([144.254.224.141]:16948 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab1KHRLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:11:41 -0500
X-IronPort-AV: E=Sophos;i="4.69,477,1315180800"; 
   d="scan'208";a="59436563"
Date: Tue, 8 Nov 2011 22:38:26 +0530
From: Maneesh Soni <manesoni@cisco.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>, ananth@in.ibm.com,
        kamensky@cisco.com, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: [PATCH 4/4] MIPS Kprobes: Support branch instructions probing - v2
Message-ID: <20111108170826.GE16526@cisco.com>
Reply-To: manesoni@cisco.com
References: <20111108170336.GA16526@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108170336.GA16526@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Maneesh Soni <manesoni@cisco.com>

MIPS Kprobes: Support branch instructions probing - v2

This patch provides support for kprobes on branch instructions. The branch
instruction at the probed address is actually emulated and not executed
out-of-line like other normal instructions. Instead the delay-slot instruction
is copied and single stepped out of line.

At the time of probe hit, the original branch instruction is evaluated
and the target cp0_epc is computed similar to compute_retrun_epc(). It
is also checked if the delay slot instruction can be skipped, which is
true if there is a NOP in delay slot or branch is taken in case of
branch likely instructions. Once the delay slot instruction is single
stepped the normal execution resume with the cp0_epc updated the earlier
computed cp0_epc as per the branch instructions.

o Changes from v1
- added missing preempt_enable_no_reshced()
- using refactored __compute_return_epc() to avoid missing instructions

Signed-off-by: Maneesh Soni <manesoni@cisco.com>
Signed-off-by: Victor Kamensky <kamensky@cisco.com>
---
 arch/mips/include/asm/kprobes.h |    5 ++
 arch/mips/kernel/kprobes.c      |  145 ++++++++++++++++++++++++++++++---------
 2 files changed, 117 insertions(+), 33 deletions(-)

diff --git a/arch/mips/include/asm/kprobes.h b/arch/mips/include/asm/kprobes.h
index e6ea4d4..1fbbca0 100644
--- a/arch/mips/include/asm/kprobes.h
+++ b/arch/mips/include/asm/kprobes.h
@@ -74,6 +74,8 @@ struct prev_kprobe {
 		: MAX_JPROBES_STACK_SIZE)
 
 
+#define SKIP_DELAYSLOT 0x0001
+
 /* per-cpu kprobe control block */
 struct kprobe_ctlblk {
 	unsigned long kprobe_status;
@@ -82,6 +84,9 @@ struct kprobe_ctlblk {
 	unsigned long kprobe_saved_epc;
 	unsigned long jprobe_saved_sp;
 	struct pt_regs jprobe_saved_regs;
+	/* Per-thread fields, used while emulating branches */
+	unsigned long flags;
+	unsigned long target_epc;
 	u8 jprobes_stack[MAX_JPROBES_STACK_SIZE];
 	struct prev_kprobe prev_kprobe;
 };
diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
index 0ab1a5f..158467d 100644
--- a/arch/mips/kernel/kprobes.c
+++ b/arch/mips/kernel/kprobes.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 
 #include <asm/ptrace.h>
+#include <asm/branch.h>
 #include <asm/break.h>
 #include <asm/inst.h>
 
@@ -152,13 +153,6 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 		goto out;
 	}
 
-	if (insn_has_delayslot(insn)) {
-		pr_notice("Kprobes for branch and jump instructions are not"
-			  "supported\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if ((probe_kernel_read(&prev_insn, p->addr - 1,
 				sizeof(mips_instruction)) == 0) &&
 				insn_has_delayslot(prev_insn)) {
@@ -178,9 +172,20 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	 * In the kprobe->ainsn.insn[] array we store the original
 	 * instruction at index zero and a break trap instruction at
 	 * index one.
+	 *
+	 * On MIPS arch if the instruction at probed address is a
+	 * branch instruction, we need to execute the instruction at
+	 * Branch Delayslot (BD) at the time of probe hit. As MIPS also
+	 * doesn't have single stepping support, the BD instruction can
+	 * not be executed in-line and it would be executed on SSOL slot
+	 * using a normal breakpoint instruction in the next slot.
+	 * So, read the instruction and save it for later execution.
 	 */
+	if (insn_has_delayslot(insn))
+		memcpy(&p->ainsn.insn[0], p->addr + 1, sizeof(kprobe_opcode_t));
+	else
+		memcpy(&p->ainsn.insn[0], p->addr, sizeof(kprobe_opcode_t));
 
-	memcpy(&p->ainsn.insn[0], p->addr, sizeof(kprobe_opcode_t));
 	p->ainsn.insn[1] = breakpoint2_insn;
 	p->opcode = *p->addr;
 
@@ -231,16 +236,96 @@ static void set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 	kcb->kprobe_saved_epc = regs->cp0_epc;
 }
 
-static void prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
+/**
+ * evaluate_branch_instrucion -
+ *
+ * Evaluate the branch instruction at probed address during probe hit. The
+ * result of evaluation would be the updated epc. The insturction in delayslot
+ * would actually be single stepped using a normal breakpoint) on SSOL slot.
+ *
+ * The result is also saved in the kprobe control block for later use,
+ * in case we need to execute the delayslot instruction. The latter will be
+ * false for NOP instruction in dealyslot and the branch-likely instructions
+ * when the branch is taken. And for those cases we set a flag as
+ * SKIP_DELAYSLOT in the kprobe control block
+ */
+static int evaluate_branch_instruction(struct kprobe *p, struct pt_regs *regs,
+					struct kprobe_ctlblk *kcb)
 {
+	union mips_instruction insn = p->opcode;
+	long epc;
+	int ret = 0;
+
+	epc = regs->cp0_epc;
+	if (epc & 3)
+		goto unaligned;
+
+	if (p->ainsn.insn->word == 0)
+		kcb->flags |= SKIP_DELAYSLOT;
+	else
+		kcb->flags &= ~SKIP_DELAYSLOT;
+
+	ret = __compute_return_epc_for_insn(regs, insn);
+	if (ret < 0)
+		return ret;
+
+	if (ret == BRANCH_LIKELY_TAKEN)
+		kcb->flags |= SKIP_DELAYSLOT;
+
+	kcb->target_epc = regs->cp0_epc;
+
+	return 0;
+
+unaligned:
+	pr_notice("%s: unaligned epc - sending SIGBUS.\n", current->comm);
+	force_sig(SIGBUS, current);
+	return -EFAULT;
+
+}
+
+static void prepare_singlestep(struct kprobe *p, struct pt_regs *regs,
+						struct kprobe_ctlblk *kcb)
+{
+	int ret = 0;
+
 	regs->cp0_status &= ~ST0_IE;
 
 	/* single step inline if the instruction is a break */
 	if (p->opcode.word == breakpoint_insn.word ||
 	    p->opcode.word == breakpoint2_insn.word)
 		regs->cp0_epc = (unsigned long)p->addr;
-	else
-		regs->cp0_epc = (unsigned long)&p->ainsn.insn[0];
+	else if (insn_has_delayslot(p->opcode)) {
+		ret = evaluate_branch_instruction(p, regs, kcb);
+		if (ret < 0) {
+			pr_notice("Kprobes: Error in evaluating branch\n");
+			return;
+		}
+	}
+	regs->cp0_epc = (unsigned long)&p->ainsn.insn[0];
+}
+
+/*
+ * Called after single-stepping.  p->addr is the address of the
+ * instruction whose first byte has been replaced by the "break 0"
+ * instruction.  To avoid the SMP problems that can occur when we
+ * temporarily put back the original opcode to single-step, we
+ * single-stepped a copy of the instruction.  The address of this
+ * copy is p->ainsn.insn.
+ *
+ * This function prepares to return from the post-single-step
+ * breakpoint trap. In case of branch instructions, the target
+ * epc to be restored.
+ */
+static void __kprobes resume_execution(struct kprobe *p,
+				       struct pt_regs *regs,
+				       struct kprobe_ctlblk *kcb)
+{
+	if (insn_has_delayslot(p->opcode))
+		regs->cp0_epc = kcb->target_epc;
+	else {
+		unsigned long orig_epc = kcb->kprobe_saved_epc;
+		regs->cp0_epc = orig_epc + 4;
+	}
 }
 
 static int __kprobes kprobe_handler(struct pt_regs *regs)
@@ -279,8 +364,13 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			save_previous_kprobe(kcb);
 			set_current_kprobe(p, regs, kcb);
 			kprobes_inc_nmissed_count(p);
-			prepare_singlestep(p, regs);
+			prepare_singlestep(p, regs, kcb);
 			kcb->kprobe_status = KPROBE_REENTER;
+			if (kcb->flags & SKIP_DELAYSLOT) {
+				resume_execution(p, regs, kcb);
+				restore_previous_kprobe(kcb);
+				preempt_enable_no_resched();
+			}
 			return 1;
 		} else {
 			if (addr->word != breakpoint_insn.word) {
@@ -324,8 +414,16 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	}
 
 ss_probe:
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
+	prepare_singlestep(p, regs, kcb);
+	if (kcb->flags & SKIP_DELAYSLOT) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		if (p->post_handler)
+			p->post_handler(p, regs, 0);
+		resume_execution(p, regs, kcb);
+		preempt_enable_no_resched();
+	} else
+		kcb->kprobe_status = KPROBE_HIT_SS;
+
 	return 1;
 
 no_kprobe:
@@ -334,25 +432,6 @@ no_kprobe:
 
 }
 
-/*
- * Called after single-stepping.  p->addr is the address of the
- * instruction whose first byte has been replaced by the "break 0"
- * instruction.  To avoid the SMP problems that can occur when we
- * temporarily put back the original opcode to single-step, we
- * single-stepped a copy of the instruction.  The address of this
- * copy is p->ainsn.insn.
- *
- * This function prepares to return from the post-single-step
- * breakpoint trap.
- */
-static void __kprobes resume_execution(struct kprobe *p,
-				       struct pt_regs *regs,
-				       struct kprobe_ctlblk *kcb)
-{
-	unsigned long orig_epc = kcb->kprobe_saved_epc;
-	regs->cp0_epc = orig_epc + 4;
-}
-
 static inline int post_kprobe_handler(struct pt_regs *regs)
 {
 	struct kprobe *cur = kprobe_running();
-- 
1.7.1

