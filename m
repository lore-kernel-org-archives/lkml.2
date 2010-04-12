Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0DLGHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:07:21 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:11409 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab0DLGHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:07:01 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKlVwkurR7H+/2dsb2JhbACbM3GhN5gUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="113732124"
Date: Sun, 11 Apr 2010 23:07:00 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux-arch@vger.kernel.org"@cisco.com,
       linux-arch@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 17/23] Make register values available to S/390 panic
	notifiers
Message-ID: <20100412060700.GA25740@dvomlehn-lnx2.corp.sa.net>
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
 arch/s390/include/asm/ptrace.h |   94 ++++++++++++++++++++++++++++++++++++++++
 arch/s390/kernel/traps.c       |    4 +-
 2 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index fef9b33..6665159 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -507,6 +507,100 @@ static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
 	return regs->gprs[15] & PSW_ADDR_INSN;
 }
 
+
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include "/home/vomlehn/git/kernel.org/ptreg.h"
+#ifndef CONFIG_64BIT
+#define PTREG_SAVE(r, name)	"st	" #r ", %[" #name "]\n"
+#else
+#define PTREG_SAVE(r, name)	"stg	" #r ", %[" #name "]\n"
+#endif
+
+#define PTREG_SAVE_GPR(i)	PTREG_SAVE_I(gprs, r, i)
+#define PTREG_SAVE_ARG(i)	PTREG_SAVE_I(args, r, i)
+
+#define PTREG_SAVE_R(regs, i)	PTREG_SAVE_I(regs, gprs, r, i)
+#define PTREG_SAVE_ARG(regs, i)	PTREG_SAVE_I(regs, arg, r, i)
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
+			PTREG_SAVE_ARG(0)
+			PTREG_SAVE(psw, psw)
+			PTREG_SAVE_GPR(0)
+			PTREG_SAVE_GPR(1)
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
+			PTREG_SAVE(orig_gpr2, orig_gpr2)
+			PTREG_SAVE(svcnr, svcnr)
+			PTREG_SAVE(ilc, ilc)
+		/*
+		 * The current location is the one for which the register
+		 * values are correct, even if some had been modified on
+		 * function entry. So, the current location is the value to
+		 * save as the execution address.
+		 */
+#ifndef CONFIG_64BIT
+			"basr	1, 0\n"
+		"0:\n"
+			"ahi	 1, 1b\n"
+#else
+			"lalr	 1, 1b\n"
+#endif
+			PTREG_SAVE(1, ilc)
+	:
+		PTREG_OUT(regs, psw, psw),
+		PTREG_OUT_GPR(regs, 0),
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
+		PTREG_OUT(regs, orig_gpr2, orig_gpr2),
+		PTREG_OUT(regs, svcnr, svcnr),
+		PTREG_OUT(regs, ilc, ilc)
+	:
+		"r1"
+	);
+
+	return regs;
+}
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 6e7ad63..49eacce 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -308,9 +308,9 @@ void die(const char * str, struct pt_regs * regs, long err)
 	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
 	if (in_interrupt())
-		panic("Fatal exception in interrupt");
+		panic_with_regs(regs, "Fatal exception in interrupt");
 	if (panic_on_oops)
-		panic("Fatal exception: panic_on_oops");
+		panic_with_regs(regs, "Fatal exception: panic_on_oops");
 	oops_exit();
 	do_exit(SIGSEGV);
 }
