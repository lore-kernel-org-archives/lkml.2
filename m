Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab1KHRLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:11:55 -0500
Received: from ams-iport-4.cisco.com ([144.254.224.147]:28272 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab1KHRLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:11:42 -0500
X-IronPort-AV: E=Sophos;i="4.69,477,1315180800"; 
   d="scan'208";a="2658711"
Date: Tue, 8 Nov 2011 22:37:11 +0530
From: Maneesh Soni <manesoni@cisco.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>, ananth@in.ibm.com,
        kamensky@cisco.com, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: [PATCH 3/4] MIPS Kprobes: Refactoring Branch emulation
Message-ID: <20111108170711.GD16526@cisco.com>
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

MIPS Refactoring Branch emulation

This patch refactors MIPS branch emulation code so as to allow skipping delay
slot instruction in case of branch likely instructions when branch is not
taken. This is useful for keeping the code common for use cases like kprobes
where one would like to handle the branch instructions keeping the delay slot
instuction also in picture for branch likely instructions. Also allow
emulation when instruction to be decoded is not at pt_regs->cp0_epc as in
case of kprobes where pt_regs->cp0_epc points to the breakpoint instruction.

The patch also exports the function for modules.

Signed-off-by: Maneesh Soni <manesoni@cisco.com>
Signed-off-by: Victor Kamensky <kamensky@cisco.com>
---
 arch/mips/include/asm/branch.h |    5 ++
 arch/mips/kernel/branch.c      |  128 ++++++++++++++++++++++++++--------------
 arch/mips/math-emu/cp1emu.c    |    2 +-
 3 files changed, 90 insertions(+), 45 deletions(-)

diff --git a/arch/mips/include/asm/branch.h b/arch/mips/include/asm/branch.h
index 37c6857..888766a 100644
--- a/arch/mips/include/asm/branch.h
+++ b/arch/mips/include/asm/branch.h
@@ -9,6 +9,7 @@
 #define _ASM_BRANCH_H
 
 #include <asm/ptrace.h>
+#include <asm/inst.h>
 
 static inline int delay_slot(struct pt_regs *regs)
 {
@@ -23,7 +24,11 @@ static inline unsigned long exception_epc(struct pt_regs *regs)
 	return regs->cp0_epc + 4;
 }
 
+#define BRANCH_LIKELY_TAKEN 0x0001
+
 extern int __compute_return_epc(struct pt_regs *regs);
+extern int __compute_return_epc_for_insn(struct pt_regs *regs,
+					 union mips_instruction insn);
 
 static inline int compute_return_epc(struct pt_regs *regs)
 {
diff --git a/arch/mips/kernel/branch.c b/arch/mips/kernel/branch.c
index 32103cc..4d735d0 100644
--- a/arch/mips/kernel/branch.c
+++ b/arch/mips/kernel/branch.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
+#include <linux/module.h>
 #include <asm/branch.h>
 #include <asm/cpu.h>
 #include <asm/cpu-features.h>
@@ -17,28 +18,22 @@
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
 
-/*
- * Compute the return address and do emulate branch simulation, if required.
+/**
+ * __compute_return_epc_for_insn - Computes the return address and do emulate
+ *				    branch simulation, if required.
+ *
+ * @regs:	Pointer to pt_regs
+ * @insn:	branch instruction to decode
+ * @returns:	-EFAULT on error and forces SIGBUS, and on success
+ *		returns 0 or BRANCH_LIKELY_TAKEN as appropriate after
+ *		evaluating the branch.
  */
-int __compute_return_epc(struct pt_regs *regs)
+int __compute_return_epc_for_insn(struct pt_regs *regs,
+				   union mips_instruction insn)
 {
-	unsigned int __user *addr;
 	unsigned int bit, fcr31, dspcontrol;
-	long epc;
-	union mips_instruction insn;
-
-	epc = regs->cp0_epc;
-	if (epc & 3)
-		goto unaligned;
-
-	/*
-	 * Read the instruction
-	 */
-	addr = (unsigned int __user *) epc;
-	if (__get_user(insn.word, addr)) {
-		force_sig(SIGSEGV, current);
-		return -EFAULT;
-	}
+	long epc = regs->cp0_epc;
+	int ret = 0;
 
 	switch (insn.i_format.opcode) {
 	/*
@@ -64,18 +59,22 @@ int __compute_return_epc(struct pt_regs *regs)
 		switch (insn.i_format.rt) {
 	 	case bltz_op:
 		case bltzl_op:
-			if ((long)regs->regs[insn.i_format.rs] < 0)
+			if ((long)regs->regs[insn.i_format.rs] < 0) {
 				epc = epc + 4 + (insn.i_format.simmediate << 2);
-			else
+				if (insn.i_format.rt == bltzl_op)
+					ret = BRANCH_LIKELY_TAKEN;
+			} else
 				epc += 8;
 			regs->cp0_epc = epc;
 			break;
 
 		case bgez_op:
 		case bgezl_op:
-			if ((long)regs->regs[insn.i_format.rs] >= 0)
+			if ((long)regs->regs[insn.i_format.rs] >= 0) {
 				epc = epc + 4 + (insn.i_format.simmediate << 2);
-			else
+				if (insn.i_format.rt == bgezl_op)
+					ret = BRANCH_LIKELY_TAKEN;
+			} else
 				epc += 8;
 			regs->cp0_epc = epc;
 			break;
@@ -83,9 +82,11 @@ int __compute_return_epc(struct pt_regs *regs)
 		case bltzal_op:
 		case bltzall_op:
 			regs->regs[31] = epc + 8;
-			if ((long)regs->regs[insn.i_format.rs] < 0)
+			if ((long)regs->regs[insn.i_format.rs] < 0) {
 				epc = epc + 4 + (insn.i_format.simmediate << 2);
-			else
+				if (insn.i_format.rt == bltzall_op)
+					ret = BRANCH_LIKELY_TAKEN;
+			} else
 				epc += 8;
 			regs->cp0_epc = epc;
 			break;
@@ -93,12 +94,15 @@ int __compute_return_epc(struct pt_regs *regs)
 		case bgezal_op:
 		case bgezall_op:
 			regs->regs[31] = epc + 8;
-			if ((long)regs->regs[insn.i_format.rs] >= 0)
+			if ((long)regs->regs[insn.i_format.rs] >= 0) {
 				epc = epc + 4 + (insn.i_format.simmediate << 2);
-			else
+				if (insn.i_format.rt == bgezall_op)
+					ret = BRANCH_LIKELY_TAKEN;
+			} else
 				epc += 8;
 			regs->cp0_epc = epc;
 			break;
+
 		case bposge32_op:
 			if (!cpu_has_dsp)
 				goto sigill;
@@ -133,9 +137,11 @@ int __compute_return_epc(struct pt_regs *regs)
 	case beq_op:
 	case beql_op:
 		if (regs->regs[insn.i_format.rs] ==
-		    regs->regs[insn.i_format.rt])
+		    regs->regs[insn.i_format.rt]) {
 			epc = epc + 4 + (insn.i_format.simmediate << 2);
-		else
+			if (insn.i_format.rt == beql_op)
+				ret = BRANCH_LIKELY_TAKEN;
+		} else
 			epc += 8;
 		regs->cp0_epc = epc;
 		break;
@@ -143,9 +149,11 @@ int __compute_return_epc(struct pt_regs *regs)
 	case bne_op:
 	case bnel_op:
 		if (regs->regs[insn.i_format.rs] !=
-		    regs->regs[insn.i_format.rt])
+		    regs->regs[insn.i_format.rt]) {
 			epc = epc + 4 + (insn.i_format.simmediate << 2);
-		else
+			if (insn.i_format.rt == bnel_op)
+				ret = BRANCH_LIKELY_TAKEN;
+		} else
 			epc += 8;
 		regs->cp0_epc = epc;
 		break;
@@ -153,9 +161,11 @@ int __compute_return_epc(struct pt_regs *regs)
 	case blez_op: /* not really i_format */
 	case blezl_op:
 		/* rt field assumed to be zero */
-		if ((long)regs->regs[insn.i_format.rs] <= 0)
+		if ((long)regs->regs[insn.i_format.rs] <= 0) {
 			epc = epc + 4 + (insn.i_format.simmediate << 2);
-		else
+			if (insn.i_format.rt == bnel_op)
+				ret = BRANCH_LIKELY_TAKEN;
+		} else
 			epc += 8;
 		regs->cp0_epc = epc;
 		break;
@@ -163,9 +173,11 @@ int __compute_return_epc(struct pt_regs *regs)
 	case bgtz_op:
 	case bgtzl_op:
 		/* rt field assumed to be zero */
-		if ((long)regs->regs[insn.i_format.rs] > 0)
+		if ((long)regs->regs[insn.i_format.rs] > 0) {
 			epc = epc + 4 + (insn.i_format.simmediate << 2);
-		else
+			if (insn.i_format.rt == bnel_op)
+				ret = BRANCH_LIKELY_TAKEN;
+		} else
 			epc += 8;
 		regs->cp0_epc = epc;
 		break;
@@ -187,18 +199,22 @@ int __compute_return_epc(struct pt_regs *regs)
 		switch (insn.i_format.rt & 3) {
 		case 0:	/* bc1f */
 		case 2:	/* bc1fl */
-			if (~fcr31 & (1 << bit))
+			if (~fcr31 & (1 << bit)) {
 				epc = epc + 4 + (insn.i_format.simmediate << 2);
-			else
+				if (insn.i_format.rt == 2)
+					ret = BRANCH_LIKELY_TAKEN;
+			} else
 				epc += 8;
 			regs->cp0_epc = epc;
 			break;
 
 		case 1:	/* bc1t */
 		case 3:	/* bc1tl */
-			if (fcr31 & (1 << bit))
+			if (fcr31 & (1 << bit)) {
 				epc = epc + 4 + (insn.i_format.simmediate << 2);
-			else
+				if (insn.i_format.rt == 3)
+					ret = BRANCH_LIKELY_TAKEN;
+			} else
 				epc += 8;
 			regs->cp0_epc = epc;
 			break;
@@ -239,15 +255,39 @@ int __compute_return_epc(struct pt_regs *regs)
 #endif
 	}
 
-	return 0;
+	return ret;
 
-unaligned:
-	printk("%s: unaligned epc - sending SIGBUS.\n", current->comm);
+sigill:
+	printk("%s: DSP branch but not DSP ASE - sending SIGBUS.\n", current->comm);
 	force_sig(SIGBUS, current);
 	return -EFAULT;
+}
+EXPORT_SYMBOL_GPL(__compute_return_epc_for_insn);
 
-sigill:
-	printk("%s: DSP branch but not DSP ASE - sending SIGBUS.\n", current->comm);
+int __compute_return_epc(struct pt_regs *regs)
+{
+	unsigned int __user *addr;
+	long epc;
+	union mips_instruction insn;
+
+	epc = regs->cp0_epc;
+	if (epc & 3)
+		goto unaligned;
+
+	/*
+	 * Read the instruction
+	 */
+	addr = (unsigned int __user *) epc;
+	if (__get_user(insn.word, addr)) {
+		force_sig(SIGSEGV, current);
+		return -EFAULT;
+	}
+
+	return __compute_return_epc_for_insn(regs, insn);
+
+unaligned:
+	printk("%s: unaligned epc - sending SIGBUS.\n", current->comm);
 	force_sig(SIGBUS, current);
 	return -EFAULT;
+
 }
diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index dbf2f93..a03bf00 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -245,7 +245,7 @@ static int cop1Emulate(struct pt_regs *xcp, struct mips_fpu_struct *ctx,
 		 */
 		emulpc = xcp->cp0_epc + 4;	/* Snapshot emulation target */
 
-		if (__compute_return_epc(xcp)) {
+		if (__compute_return_epc(xcp) < 0) {
 #ifdef CP1DBG
 			printk("failed to emulate branch at %p\n",
 				(void *) (xcp->cp0_epc));
-- 
1.7.1

