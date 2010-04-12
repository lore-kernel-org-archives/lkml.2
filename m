Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0DLGLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:11:36 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:23122 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab0DLGEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:04:23 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGJVwkurR7Ht/2dsb2JhbACbM3GhNpgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="513153694"
Date: Sun, 11 Apr 2010 23:04:22 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 14/23] Make register values available to MN10300 panic
	notifiers
Message-ID: <20100412060422.GA24724@dvomlehn-lnx2.corp.sa.net>
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
 arch/mn10300/include/asm/ptrace.h |   92 +++++++++++++++++++++++++++++++++++++
 arch/mn10300/kernel/traps.c       |    2 +-
 2 files changed, 93 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/include/asm/ptrace.h b/arch/mn10300/include/asm/ptrace.h
index 1b0ba5e..e8e3548 100644
--- a/arch/mn10300/include/asm/ptrace.h
+++ b/arch/mn10300/include/asm/ptrace.h
@@ -102,6 +102,98 @@ extern void show_regs(struct pt_regs *);
 extern void user_enable_single_step(struct task_struct *);
 extern void user_disable_single_step(struct task_struct *);
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#define PTREG_SAVE(r, name)	"mov	" #r ", %[" #name "]\n"
+#define PTREG_SAVE_D(i)		PTREG_SAVE_I(d, d, i)
+#define PTREG_SAVE_A(i)		PTREG_SAVE_I(a, a, i)
+#define PTREG_SAVE_E(i)		PTREG_SAVE_I(e, e, i)
+
+#define PTREG_OUT_D(regs, i)	PTREG_OUT_I(regs, d, d, i)
+#define PTREG_OUT_A(regs, i)	PTREG_OUT_I(regs, a, a, i)
+#define PTREG_OUT_E(regs, i)	PTREG_OUT_I(regs, e, e, i)
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
+			PTREG_SAVE_A(3)
+			PTREG_SAVE_A(2)
+			PTREG_SAVE_D(3)
+			PTREG_SAVE_D(2)
+			PTREG_SAVE(mcvf, mcvf)
+			PTREG_SAVE(mcrl, mcrl)
+			PTREG_SAVE(mcrh, mcrh)
+			PTREG_SAVE(mdrq, mdrq)
+			PTREG_SAVE_E(1)
+			PTREG_SAVE_E(0)
+			PTREG_SAVE_E(7)
+			PTREG_SAVE_E(6)
+			PTREG_SAVE_E(5)
+			PTREG_SAVE_E(4)
+			PTREG_SAVE_E(3)
+			PTREG_SAVE_E(2)
+			PTREG_SAVE(sp, sp)
+			PTREG_SAVE(lar, lar)
+			PTREG_SAVE(lir, lir)
+			PTREG_SAVE(mdr, mdr)
+			PTREG_SAVE_A(1)
+			PTREG_SAVE_A(0)
+			PTREG_SAVE_D(1)
+			PTREG_SAVE_D(0)
+			PTREG_SAVE(next, next)
+			PTREG_SAVE(orig_d0, orig_d0)
+			PTREG_SAVE(epsw, epsw)
+		"1:\n"
+			"mov	1b, a0\n"
+			PTREG_SAVE(a0, pc)
+	:
+		PTREG_OUT_A(regs, 3)
+		PTREG_OUT_A(regs, 2)
+		PTREG_OUT_D(regs, 3)
+		PTREG_OUT_D(regs, 2)
+		PTREG_OUT(regs, mcvf, mcvf)
+		PTREG_OUT(regs, mcrl, mcrl)
+		PTREG_OUT(regs, mcrh, mcrh)
+		PTREG_OUT(regs, mdrq, mdrq)
+		PTREG_OUT_E(regs, 1)
+		PTREG_OUT_E(regs, 0)
+		PTREG_OUT_E(regs, 7)
+		PTREG_OUT_E(regs, 6)
+		PTREG_OUT_E(regs, 5)
+		PTREG_OUT_E(regs, 4)
+		PTREG_OUT_E(regs, 3)
+		PTREG_OUT_E(regs, 2)
+		PTREG_OUT(regs, sp, sp)
+		PTREG_OUT(regs, lar, lar)
+		PTREG_OUT(regs, lir, lir)
+		PTREG_OUT(regs, mdr, mdr)
+		PTREG_OUT_A(regs, 1)
+		PTREG_OUT_A(regs, 0)
+		PTREG_OUT_D(regs, 1)
+		PTREG_OUT_D(regs, 0)
+		PTREG_OUT(regs, next, next)
+		PTREG_OUT(regs, orig_d0, orig_d0)
+		PTREG_OUT(regs, epsw, epsw)
+		PTREG_OUT(regs, pc, pc)
+	:
+		"a0"
+	);
+
+	return regs;
+}
 #endif  /*  !__ASSEMBLY  */
 
 #define profile_pc(regs) ((regs)->pc)
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index 91365ad..0251adf 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -471,7 +471,7 @@ asmlinkage void io_bus_error(u32 bcberr, u32 bcbear, struct pt_regs *regs)
 	printk(KERN_EMERG "\n");
 	show_registers(regs);
 
-	panic("Halted due to asynchronous I/O Bus Error\n");
+	panic_with_regs(regs, "Halted due to asynchronous I/O Bus Error\n");
 }
 
 /*
