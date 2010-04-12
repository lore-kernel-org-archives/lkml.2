Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab0DLGEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:04:01 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:39901 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0DLGD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:03:58 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACZVwkurR7Hu/2dsb2JhbACbM3GhRZgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="181521077"
Date: Sun, 11 Apr 2010 23:03:58 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 7/23] Make register values available to FRV panic notifiers
Message-ID: <20100412060358.GA24467@dvomlehn-lnx2.corp.sa.net>
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
 arch/frv/include/asm/ptrace.h |  124 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/arch/frv/include/asm/ptrace.h b/arch/frv/include/asm/ptrace.h
index 6bfad4c..7365c6a 100644
--- a/arch/frv/include/asm/ptrace.h
+++ b/arch/frv/include/asm/ptrace.h
@@ -85,6 +85,130 @@ extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include "/home/vomlehn/git/kernel.org/ptreg.h"
+#define PTREG_SAVE(r, name)	"std	" #r ", %[" # name "]\n"
+#define PTREG_SAVE_GR(i)		PTREG_SAVE_I(gr, gr, i)
+
+#define PTREG_OUT_GR(regs, i)	PTREG_OUT_I(regs, gr, r, i)
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
+			PTREG_SAVE(psr, psr)
+			PTREG_SAVE(isr, isr)
+			PTREG_SAVE(ccr, ccr)
+			PTREG_SAVE(cccr, cccr)
+			PTREG_SAVE(lr, lr)
+			PTREG_SAVE(lcr, lcr)
+			PTREG_SAVE(__status, __status)
+			PTREG_SAVE(syscallno, syscallno)
+			PTREG_SAVE(orig_gr8, orig_gr8)
+			PTREG_SAVE(gner0, gner0)
+			PTREG_SAVE(gner1, gner1)
+			PTREG_SAVE(iacc0, iacc0)
+			PTREG_SAVE(tbr, tbr)
+			PTREG_SAVE(sp, sp)
+			PTREG_SAVE(fp, fp)
+			PTREG_SAVE_GR(3)
+			PTREG_SAVE_GR(4)
+			PTREG_SAVE_GR(5)
+			PTREG_SAVE_GR(6)
+			PTREG_SAVE_GR(7)
+			PTREG_SAVE_GR(8)
+			PTREG_SAVE_GR(9)
+			PTREG_SAVE_GR(10)
+			PTREG_SAVE_GR(11)
+			PTREG_SAVE_GR(12)
+			PTREG_SAVE_GR(13)
+			PTREG_SAVE_GR(14)
+			PTREG_SAVE_GR(15)
+			PTREG_SAVE_GR(16)
+			PTREG_SAVE_GR(17)
+			PTREG_SAVE_GR(18)
+			PTREG_SAVE_GR(19)
+			PTREG_SAVE_GR(20)
+			PTREG_SAVE_GR(21)
+			PTREG_SAVE_GR(22)
+			PTREG_SAVE_GR(23)
+			PTREG_SAVE_GR(24)
+			PTREG_SAVE_GR(25)
+			PTREG_SAVE_GR(26)
+			PTREG_SAVE_GR(27)
+			PTREG_SAVE(next_frame, next_frame)
+			PTREG_SAVE_GR(29)
+			PTREG_SAVE_GR(30)
+			PTREG_SAVE_GR(31)
+		"1:\n"
+			"sethi.p	#1b, gr0\n"
+			"setlo		#1b, gr0\n"
+			PTREG_SAVE(gr0, pc)
+	:
+		PTREG_OUT(regs, psr, psr),
+		PTREG_OUT(regs, isr, isr),
+		PTREG_OUT(regs, ccr, ccr),
+		PTREG_OUT(regs, cccr, cccr),
+		PTREG_OUT(regs, lr, lr),
+		PTREG_OUT(regs, lcr, lcr),
+		PTREG_OUT(regs, pc, pc),
+		PTREG_OUT(regs, __status, __status),
+		PTREG_OUT(regs, syscallno, syscallno),
+		PTREG_OUT(regs, orig_gr8, orig_gr8),
+		PTREG_OUT(regs, gner0, gner0),
+		PTREG_OUT(regs, gner1, gner1),
+		PTREG_OUT(regs, iacc0, iacc0),
+		PTREG_OUT(regs, tbr, tbr),
+		PTREG_OUT(regs, sp, sp),
+		PTREG_OUT(regs, fp, fp),
+		PTREG_OUT_GR(regs, 3),
+		PTREG_OUT_GR(regs, 4),
+		PTREG_OUT_GR(regs, 5),
+		PTREG_OUT_GR(regs, 6),
+		PTREG_OUT_GR(regs, 7),
+		PTREG_OUT_GR(regs, 8),
+		PTREG_OUT_GR(regs, 9),
+		PTREG_OUT_GR(regs, 10),
+		PTREG_OUT_GR(regs, 11),
+		PTREG_OUT_GR(regs, 12),
+		PTREG_OUT_GR(regs, 13),
+		PTREG_OUT_GR(regs, 14),
+		PTREG_OUT_GR(regs, 15),
+		PTREG_OUT_GR(regs, 16),
+		PTREG_OUT_GR(regs, 17),
+		PTREG_OUT_GR(regs, 18),
+		PTREG_OUT_GR(regs, 19),
+		PTREG_OUT_GR(regs, 20),
+		PTREG_OUT_GR(regs, 21),
+		PTREG_OUT_GR(regs, 22),
+		PTREG_OUT_GR(regs, 23),
+		PTREG_OUT_GR(regs, 24),
+		PTREG_OUT_GR(regs, 25),
+		PTREG_OUT_GR(regs, 26),
+		PTREG_OUT_GR(regs, 27),
+		PTREG_OUT(regs, next_frame, next_frame),
+		PTREG_OUT_GR(regs, 29),
+		PTREG_OUT_GR(regs, 30),
+		PTREG_OUT_GR(regs, 31)
+	:
+		"gr0"
+	);
+
+	return regs;
+}
 #endif /* !__ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ASM_PTRACE_H */
