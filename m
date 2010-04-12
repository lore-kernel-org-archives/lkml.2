Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0DLGHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:07:17 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:48250 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab0DLGHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:07:04 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGJVwkurR7Ht/2dsb2JhbACbM3GhNpgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="316193980"
Date: Sun, 11 Apr 2010 23:07:04 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux-arch@vger.kernel.org"@cisco.com,
       linux-arch@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 18/23] Make register values available to Score panic
	notifiers
Message-ID: <20100412060704.GA25767@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The save_ptregs() function has not been tested or even built. I will need
help to complete this.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 arch/score/include/asm/ptrace.h |  136 +++++++++++++++++++++++++++++++++++++++
 arch/score/kernel/traps.c       |    2 +-
 2 files changed, 137 insertions(+), 1 deletions(-)

diff --git a/arch/score/include/asm/ptrace.h b/arch/score/include/asm/ptrace.h
index e89dc9b..d9a1293 100644
--- a/arch/score/include/asm/ptrace.h
+++ b/arch/score/include/asm/ptrace.h
@@ -91,6 +91,142 @@ extern int read_tsk_short(struct task_struct *, unsigned long,
 
 #define arch_has_single_step()	(1)
 
+
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include "/home/vomlehn/git/kernel.org/ptreg.h"
+#define PTREG_SAVE(r, name)	"sw	" #r ", %[" #name "]\n"
+#define PTREG_SAVE_R(i)		PTREG_SAVE_I(r, r, i)
+
+#define PTREG_SAVE_R(regs, i)	PTREG_SAVE_I(regs, r, r, i)
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
+ * This function must be called first in a function. There must be no
+ * auto variables defined that are initialized before calling this function.
+ */
+static __always_inline
+const struct pt_regs *save_ptregs(struct pt_regs *regs)
+{
+	__asm__ __volatile__ (
+			PTREG_SAVE_R(0)
+			PTREG_SAVE_R(1)
+			PTREG_SAVE_R(2)
+			PTREG_SAVE_R(3)
+			PTREG_SAVE_R(4)
+			PTREG_SAVE_R(5)
+			PTREG_SAVE_R(6)
+			PTREG_SAVE_R(7)
+			PTREG_SAVE_R(8)
+			PTREG_SAVE_R(9)
+			PTREG_SAVE_R(10)
+			PTREG_SAVE_R(11)
+			PTREG_SAVE_R(12)
+			PTREG_SAVE_R(13)
+			PTREG_SAVE_R(14)
+			PTREG_SAVE_R(15)
+			PTREG_SAVE_R(16)
+			PTREG_SAVE_R(17)
+			PTREG_SAVE_R(18)
+			PTREG_SAVE_R(19)
+			PTREG_SAVE_R(20)
+			PTREG_SAVE_R(21)
+			PTREG_SAVE_R(22)
+			PTREG_SAVE_R(23)
+			PTREG_SAVE_R(24)
+			PTREG_SAVE_R(25)
+			PTREG_SAVE_R(26)
+			PTREG_SAVE_R(27)
+			PTREG_SAVE_R(28)
+			PTREG_SAVE_R(29)
+			PTREG_SAVE_R(30)
+			PTREG_SAVE_R(31)
+
+			PTREG_SAVE(sr0, sr0)
+			PTREG_SAVE(sr1, sr1)
+			PTREG_SAVE(sr2, sr2)
+
+			"mfcehl	r30, r31\n"
+			PTREG_SAVE(r30, cp0_ceh)
+			PTREG_SAVE(r31, cp0_cel)
+
+			"mfcr	r31, cr0\n"
+			PTREG_SAVE(r31, cp0_ecr)
+
+			"mfcr	r31, cr1\n"
+			PTREG_SAVE(r31, cp0_condition)
+
+			"mfcr	r31, cr2\n"
+			PTREG_SAVE(r31, cp0_ecr)
+
+			"mfcr	r31, cr6\n"
+			PTREG_SAVE(r31, cp0_ema)
+
+		/*
+		 * The current location is the one for which the register
+		 * values are correct, even if some had been modified on
+		 * function entry. So, the current location is the value to
+		 * save as the execution address.
+		 */
+		"1:\n"
+			"la	r1, 1b"
+			PTREG_SAVE(r1, cp0_epc)
+	:
+		PTREG_OUT_R(regs, 0)
+		PTREG_OUT_R(regs, 1)
+		PTREG_OUT_R(regs, 2)
+		PTREG_OUT_R(regs, 3)
+		PTREG_OUT_R(regs, 4)
+		PTREG_OUT_R(regs, 5)
+		PTREG_OUT_R(regs, 6)
+		PTREG_OUT_R(regs, 7)
+		PTREG_OUT_R(regs, 8)
+		PTREG_OUT_R(regs, 9)
+		PTREG_OUT_R(regs, 10)
+		PTREG_OUT_R(regs, 11)
+		PTREG_OUT_R(regs, 12)
+		PTREG_OUT_R(regs, 13)
+		PTREG_OUT_R(regs, 14)
+		PTREG_OUT_R(regs, 15)
+		PTREG_OUT_R(regs, 16)
+		PTREG_OUT_R(regs, 17)
+		PTREG_OUT_R(regs, 18)
+		PTREG_OUT_R(regs, 19)
+		PTREG_OUT_R(regs, 20)
+		PTREG_OUT_R(regs, 21)
+		PTREG_OUT_R(regs, 22)
+		PTREG_OUT_R(regs, 23)
+		PTREG_OUT_R(regs, 24)
+		PTREG_OUT_R(regs, 25)
+		PTREG_OUT_R(regs, 26)
+		PTREG_OUT_R(regs, 27)
+		PTREG_OUT_R(regs, 28)
+		PTREG_OUT_R(regs, 29)
+		PTREG_OUT_R(regs, 30)
+		PTREG_OUT_R(regs, 31)
+		PTREG_OUT(regs, cel, cel)
+		PTREG_OUT(regs, ceh, ceh)
+		PTREG_OUT(regs, sr0, sr0)
+		PTREG_OUT(regs, sr1, sr1)
+		PTREG_OUT(regs, sr2, sr2)
+		PTREG_OUT(regs, cp0_epc, cp0_epc)
+		PTREG_OUT(regs, cp0_ema, cp0_ema)
+		PTREG_OUT(regs, cp0_psr, cp0_psr)
+		PTREG_OUT(regs, cp0_ecr, cp0_ecr)
+		PTREG_OUT(regs, cp0_condition, cp0_condition)
+	:
+		"r30", "r31"
+	);
+
+	return regs;
+}
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_SCORE_PTRACE_H */
diff --git a/arch/score/kernel/traps.c b/arch/score/kernel/traps.c
index 0e46fb1..1331829 100644
--- a/arch/score/kernel/traps.c
+++ b/arch/score/kernel/traps.c
@@ -283,7 +283,7 @@ asmlinkage void do_reserved(struct pt_regs *regs)
 	 */
 	die_if_kernel("do_reserved execution Exception", regs);
 	show_regs(regs);
-	panic("Caught reserved exception - should not happen.");
+	panic_with_regs(regs, "Caught reserved exception - should not happen.");
 }
 
 /*
