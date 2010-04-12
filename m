Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab0DLGEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:04:11 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:23062 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab0DLGEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:04:05 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADZUwkurR7Ht/2dsb2JhbACbM3GhP5gUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="513153610"
Date: Sun, 11 Apr 2010 23:04:04 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 9/23] Make register values available to IA64 panic notifiers
Message-ID: <20100412060404.GA24580@dvomlehn-lnx2.corp.sa.net>
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
 arch/ia64/include/asm/ptrace.h |  124 ++++++++++++++++++++++++++++++++++++++++
 arch/ia64/kernel/traps.c       |    2 +-
 2 files changed, 125 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/ptrace.h b/arch/ia64/include/asm/ptrace.h
index 14055c6..4d39be8 100644
--- a/arch/ia64/include/asm/ptrace.h
+++ b/arch/ia64/include/asm/ptrace.h
@@ -325,6 +325,130 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
   #define arch_has_block_step()   (1)
   extern void user_enable_block_step(struct task_struct *);
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include "/home/vomlehn/git/kernel.org/ptreg.h"
+#define PTREG_SAVE(r, name)	"st8	%[" #name "] = " #r "\n"
+#define PTREG_SAVE_R(i)		PTREG_SAVE_I(r, r, i)
+#define PTREG_SAVE_B(i)		PTREG_SAVE_I(b, b, i)
+
+#define PTREG_OUT_R(regs, i)	PTREG_OUT_I(regs, r, r, i)
+#define PTREG_OUT_B(regs, i)	PTREG_OUT_I(regs, b, b, i)
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
+			PTREG_SAVE_B(6)
+			PTREG_SAVE_B(7)
+			PTREG_SAVE(ar_csd, ar_csd)
+			PTREG_SAVE(ar_ssd, ar_ssd)
+			PTREG_SAVE_R(8)
+			PTREG_SAVE_R(9)
+			PTREG_SAVE_R(10)
+			PTREG_SAVE_R(11)
+			PTREG_SAVE(cr_ipsr, cr_ipsr)
+			PTREG_SAVE(cr_iip, cr_iip)
+			PTREG_SAVE(cr_ifs, cr_ifs)
+			PTREG_SAVE(ar_unat, ar_unat)
+			PTREG_SAVE(ar_pfs, ar_pfs)
+			PTREG_SAVE(ar_rsc, ar_rsc)
+			PTREG_SAVE(ar_rnat, ar_rnat)
+			PTREG_SAVE(ar_bspstore, ar_bspstore)
+			PTREG_SAVE(pr, pr)
+			PTREG_SAVE_B(0)
+			PTREG_SAVE(loadrs, loadrs)
+			PTREG_SAVE_R(1)
+			PTREG_SAVE_R(12)
+			PTREG_SAVE_R(13)
+			PTREG_SAVE(ar_fpsr, ar_fpsr)
+			PTREG_SAVE_R(15)
+			PTREG_SAVE_R(14)
+			PTREG_SAVE_R(2)
+			PTREG_SAVE_R(3)
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
+			PTREG_SAVE(ar_ccv, ar_ccv)
+		'1:\n"
+			"movl	r0=1b\n"
+			PTREG_SAVE(r0, pc)
+	:
+		PTREG_OUT_B(regs, 6)
+		PTREG_OUT_B(regs, 7)
+		PTREG_OUT(regs, ar_csd, ar_csd)
+		PTREG_OUT(regs, ar_ssd, ar_ssd)
+		PTREG_OUT_R(regs, 8)
+		PTREG_OUT_R(regs, 9)
+		PTREG_OUT_R(regs, 10)
+		PTREG_OUT_R(regs, 11)
+		PTREG_OUT(regs, cr_ipsr, cr_ipsr)
+		PTREG_OUT(regs, cr_iip, cr_iip)
+		PTREG_OUT(regs, cr_ifs, cr_ifs)
+		PTREG_OUT(regs, ar_unat, ar_unat)
+		PTREG_OUT(regs, ar_pfs, ar_pfs)
+		PTREG_OUT(regs, ar_rsc, ar_rsc)
+		PTREG_OUT(regs, ar_rnat, ar_rnat)
+		PTREG_OUT(regs, ar_bspstore, ar_bspstore)
+		PTREG_OUT(regs, pr, pr)
+		PTREG_OUT_B(regs, 0)
+		PTREG_OUT(regs, loadrs, loadrs)
+		PTREG_OUT_R(regs, 1)
+		PTREG_OUT_R(regs, 12)
+		PTREG_OUT_R(regs, 13)
+		PTREG_OUT(regs, ar_fpsr, ar_fpsr)
+		PTREG_OUT_R(regs, 15)
+		PTREG_OUT_R(regs, 14)
+		PTREG_OUT_R(regs, 2)
+		PTREG_OUT_R(regs, 3)
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
+		PTREG_OUT(regs, ar_ccv, ar_ccv)
+	:
+		"r0"
+	);
+
+	return regs;
+}
 #endif /* !__KERNEL__ */
 
 /* pt_all_user_regs is used for PTRACE_GETREGS PTRACE_SETREGS */
diff --git a/arch/ia64/kernel/traps.c b/arch/ia64/kernel/traps.c
index f0cda76..541ea2f 100644
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -79,7 +79,7 @@ die (const char *str, struct pt_regs *regs, long err)
 		return 1;
 
 	if (panic_on_oops)
-		panic("Fatal exception");
+		panic_with_regs(regs, "Fatal exception");
 
   	do_exit(SIGSEGV);
 	return 0;
