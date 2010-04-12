Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0DLGEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:04:25 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:40000 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab0DLGEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:04:22 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACZVwktAaHte/2dsb2JhbACbM3GhRZgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="181521226"
Date: Sun, 11 Apr 2010 23:04:17 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 13/23] Make register values available to MIPS panic
	notifiers
Message-ID: <20100412060417.GA24693@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The save_ptregs() function has been verified to work.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 arch/mips/include/asm/ptrace.h |  134 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index ce47118..2b75856 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -114,10 +114,13 @@ struct pt_watch_regs {
 
 #ifdef __KERNEL__
 
+#include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/linkage.h>
 #include <linux/types.h>
 #include <asm/isadep.h>
+#include <asm/mipsregs.h>
+#include <asm/asm.h>
 
 struct task_struct;
 
@@ -139,6 +142,7 @@ extern int ptrace_set_watch_regs(struct task_struct *child,
 
 #define instruction_pointer(regs) ((regs)->cp0_epc)
 #define profile_pc(regs) instruction_pointer(regs)
+extern void show_regs(struct pt_regs *regs);
 
 extern asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit);
 
@@ -150,6 +154,136 @@ static inline void die_if_kernel(const char *str, const struct pt_regs *regs)
 		die(str, regs);
 }
 
+#include <linux/ptreg.h>
+
+#define PTREG_SAVE(r, name)	STR(LONG_S) "	" #r ", %[" #name "]\n"
+#define PTREG_SAVE_GPR(i)	_PTREG_SAVE_IDX($, gpr, i)
+
+#define PTREG_OUT_GPR(regsp, i)	_PTREG_OUT_IDX(regsp, regs, gpr, i)
+
+#define arch_has_save_ptregs	1
+
+/**
+ * save_ptregs - save processor registers for backtracing
+ * @regs:	Pointer to &struct pt_regs structure in which to save the
+ *		registers
+ *
+ * Returns a constant pointer to @regs.
+ *
+ * This saves all the GPRs and the EPC, Cause, and Status values for
+ * coprocessor 0.
+ *
+ * This function must be called first in a function. There must be no
+ * auto variables defined that are initialized before calling this function.
+ */
+static __always_inline
+const struct pt_regs *save_ptregs(register struct pt_regs *regs)
+{
+	/* The compiler restricts us to 30 operands in an asm construct, so we
+	 * have to break the register saving into two pieces. We can skip
+	 * saving the zero register in the first piece, since its value is
+	 * constant. Since we can ensure no calls are made between the two
+	 * pieces, we can also delay saving the ra register to the second
+	 * piece. */
+	__asm__ __volatile__ (
+		"	.set	noat\n"
+			PTREG_SAVE_GPR(1)
+		"	.set	at\n"
+			PTREG_SAVE_GPR(2)
+			PTREG_SAVE_GPR(3)
+			PTREG_SAVE_GPR(4)
+			PTREG_SAVE_GPR(5)
+			PTREG_SAVE_GPR(6)
+			PTREG_SAVE_GPR(7)
+			PTREG_SAVE_GPR(8)
+			PTREG_SAVE_GPR(9)
+			PTREG_SAVE_GPR(10)
+			PTREG_SAVE_GPR(11)
+			PTREG_SAVE_GPR(12)
+			PTREG_SAVE_GPR(13)
+			PTREG_SAVE_GPR(14)
+			PTREG_SAVE_GPR(15)
+			PTREG_SAVE_GPR(16)
+			PTREG_SAVE_GPR(17)
+			PTREG_SAVE_GPR(18)
+			PTREG_SAVE_GPR(19)
+			PTREG_SAVE_GPR(20)
+			PTREG_SAVE_GPR(21)
+			PTREG_SAVE_GPR(22)
+			PTREG_SAVE_GPR(23)
+			PTREG_SAVE_GPR(24)
+			PTREG_SAVE_GPR(25)
+			PTREG_SAVE_GPR(26)
+			PTREG_SAVE_GPR(27)
+			PTREG_SAVE_GPR(28)
+			PTREG_SAVE_GPR(29)
+			PTREG_SAVE_GPR(30)
+	:
+		PTREG_OUT_GPR(regs, 1),
+		PTREG_OUT_GPR(regs, 2),
+		PTREG_OUT_GPR(regs, 3),
+		PTREG_OUT_GPR(regs, 4),
+		PTREG_OUT_GPR(regs, 5),
+		PTREG_OUT_GPR(regs, 6),
+		PTREG_OUT_GPR(regs, 7),
+		PTREG_OUT_GPR(regs, 8),
+		PTREG_OUT_GPR(regs, 9),
+		PTREG_OUT_GPR(regs, 10),
+		PTREG_OUT_GPR(regs, 11),
+		PTREG_OUT_GPR(regs, 12),
+		PTREG_OUT_GPR(regs, 13),
+		PTREG_OUT_GPR(regs, 14),
+		PTREG_OUT_GPR(regs, 15),
+		PTREG_OUT_GPR(regs, 16),
+		PTREG_OUT_GPR(regs, 17),
+		PTREG_OUT_GPR(regs, 18),
+		PTREG_OUT_GPR(regs, 19),
+		PTREG_OUT_GPR(regs, 20),
+		PTREG_OUT_GPR(regs, 21),
+		PTREG_OUT_GPR(regs, 22),
+		PTREG_OUT_GPR(regs, 23),
+		PTREG_OUT_GPR(regs, 24),
+		PTREG_OUT_GPR(regs, 25),
+		PTREG_OUT_GPR(regs, 26),
+		PTREG_OUT_GPR(regs, 27),
+		PTREG_OUT_GPR(regs, 28),
+		PTREG_OUT_GPR(regs, 29),
+		PTREG_OUT_GPR(regs, 30)
+	:
+	:
+		"$1"
+	);
+
+	/* This is the second part, where we save the ra register. We then
+	 * set the EPC register to the location immediately after the save
+	 * of the ra register since that's the point at which the saved GPRs
+	 * correspond with the actual GPRs. */
+	__asm__ __volatile__ (
+			PTREG_SAVE_GPR(31)
+		"1:\n"
+		"	.set	noat\n"
+			STR(PTR_LA) "	$at, 1b\n"
+			PTREG_SAVE($at, cp0_epc)
+		"	.set	at\n"
+	:
+		PTREG_OUT_GPR(regs, 31),
+		PTREG_OUT(regs, cp0_epc, cp0_epc)
+	:
+	:
+		"$1"
+	);
+
+	/* The zero register is always, well, zero. */
+	regs->regs[0] = 0;
+
+	/* Grab the values of the coprocessor zero Status and Cause registers.
+	 * We haven't done anything that will affect them up to this point,
+	 * so waiting until here to save them is a reasonable thing to do. */
+	regs->cp0_status = read_c0_status();
+	regs->cp0_cause = read_c0_cause();
+
+	return regs;
+}
 #endif
 
 #endif /* _ASM_PTRACE_H */
