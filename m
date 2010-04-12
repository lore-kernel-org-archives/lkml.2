Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0DLGGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:06:42 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:11236 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab0DLGGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:06:38 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKlVwkurR7Hu/2dsb2JhbACbM3GhN5gUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="113731964"
Date: Sun, 11 Apr 2010 23:06:38 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux-arch@vger.kernel.org"@cisco.com,
       linux-arch@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 10/23] Make register values available to M32R panic
	notifiers
Message-ID: <20100412060638.GA25540@dvomlehn-lnx2.corp.sa.net>
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
 arch/m32r/include/asm/ptrace.h |   91 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/include/asm/ptrace.h b/arch/m32r/include/asm/ptrace.h
index a0755b9..54f3239 100644
--- a/arch/m32r/include/asm/ptrace.h
+++ b/arch/m32r/include/asm/ptrace.h
@@ -143,6 +143,97 @@ extern void withdraw_debug_trap(struct pt_regs *regs);
 #define task_pt_regs(task) \
         ((struct pt_regs *)(task_stack_page(task) + THREAD_SIZE) - 1)
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include "/home/vomlehn/git/kernel.org/ptreg.h"
+#define PTREG_SAVE(r, name)	"movel	" #r ", %[" #r "]\n"
+#define PTREG_SAVE_R(i)		PTREG_SAVE_I(r, r, i)
+
+#define PTREG_OUT_R(regs, i)	PTREG_OUT_I(regs, r, r, i)
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
+			PTREG_SAVE_R(4)
+			PTREG_SAVE_R(5)
+			PTREG_SAVE_R(6)
+			PTREG_SAVE(pt_regs, pt_regs)
+			PTREG_SAVE_R(0)
+			PTREG_SAVE_R(1)
+			PTREG_SAVE_R(2)
+			PTREG_SAVE_R(3)
+			PTREG_SAVE_R(7)
+			PTREG_SAVE_R(8)
+			PTREG_SAVE_R(9)
+			PTREG_SAVE_R(10)
+			PTREG_SAVE_R(11)
+			PTREG_SAVE_R(12)
+			PTREG_SAVE(syscall_nr, syscall_nr)
+			PTREG_SAVE(acc0h, acc0h)
+			PTREG_SAVE(acc0l, acc0l)
+			PTREG_SAVE(acc1h, acc1h)
+			PTREG_SAVE(acc1l, acc1l)
+			PTREG_SAVE(psw, psw)
+			PTREG_SAVE(bpc, bpc)
+			PTREG_SAVE(bbpsw, bbpsw)
+			PTREG_SAVE(bbpc, bbpc)
+			PTREG_SAVE(spu, spu)
+			PTREG_SAVE(fp, fp)
+			PTREG_SAVE(lr, lr)
+			PTREG_SAVE(spi, spi)
+			PTREG_SAVE(orig_r0, orig_r0)
+		"1:\n"
+			"seth	r0, #high(1b)\n"
+			"or3	r0, r0, #low(1b)\n"
+			PTREG_SAVE(r0, bpc)
+	:
+		PTREG_OUT_R(regs, 4),
+		PTREG_OUT_R(regs, 5),
+		PTREG_OUT_R(regs, 6),
+		PTREG_OUT(regs, pt_regs, pt_regs),
+		PTREG_OUT_R(regs, 0),
+		PTREG_OUT_R(regs, 1),
+		PTREG_OUT_R(regs, 2),
+		PTREG_OUT_R(regs, 3),
+		PTREG_OUT_R(regs, 7),
+		PTREG_OUT_R(regs, 8),
+		PTREG_OUT_R(regs, 9),
+		PTREG_OUT_R(regs, 10),
+		PTREG_OUT_R(regs, 11),
+		PTREG_OUT_R(regs, 12),
+		PTREG_OUT(regs, syscall_nr, syscall_nr),
+		PTREG_OUT(regs, acc0h, acc0h),
+		PTREG_OUT(regs, acc0l, acc0l),
+		PTREG_OUT(regs, acc1h, acc1h),
+		PTREG_OUT(regs, acc1l, acc1l),
+		PTREG_OUT(regs, psw, psw),
+		PTREG_OUT(regs, bpc, bpc),
+		PTREG_OUT(regs, bbpsw, bbpsw),
+		PTREG_OUT(regs, bbpc, bbpc),
+		PTREG_OUT(regs, spu, spu),
+		PTREG_OUT(regs, fp, fp),
+		PTREG_OUT(regs, lr, lr),
+		PTREG_OUT(regs, spi, spi),
+		PTREG_OUT(regs, orig_r0, orig_r0)
+	:
+		"r0"
+	);
+
+	return regs;
+}
 #endif /* __KERNEL */
 
 #endif /* _ASM_M32R_PTRACE_H */
