Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0DLGD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:03:57 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:39867 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0DLGDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:03:52 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACZVwkurR7H+/2dsb2JhbACbM3GhRZgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="181521026"
Date: Sun, 11 Apr 2010 23:03:52 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 5/23] Make register values available to Blackfin panic
	notifiers
Message-ID: <20100412060352.GA24409@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The save_ptregs() functions compiles cleanly, but has not been tested.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 arch/blackfin/include/asm/blackfin.h |   10 +-
 arch/blackfin/include/asm/ptrace.h   |  187 ++++++++++++++++++++++++++++++++++
 arch/blackfin/kernel/traps.c         |    8 +-
 3 files changed, 196 insertions(+), 9 deletions(-)

diff --git a/arch/blackfin/include/asm/blackfin.h b/arch/blackfin/include/asm/blackfin.h
index eb7c144..9cfa5cc 100644
--- a/arch/blackfin/include/asm/blackfin.h
+++ b/arch/blackfin/include/asm/blackfin.h
@@ -11,6 +11,11 @@
 
 #include <mach/anomaly.h>
 
+#define LO(con32) ((con32) & 0xFFFF)
+#define lo(con32) ((con32) & 0xFFFF)
+#define HI(con32) (((con32) >> 16) & 0xFFFF)
+#define hi(con32) (((con32) >> 16) & 0xFFFF)
+
 #ifndef __ASSEMBLY__
 
 /* SSYNC implementation for C file */
@@ -63,11 +68,6 @@ static inline void CSYNC(void)
 
 #else  /* __ASSEMBLY__ */
 
-#define LO(con32) ((con32) & 0xFFFF)
-#define lo(con32) ((con32) & 0xFFFF)
-#define HI(con32) (((con32) >> 16) & 0xFFFF)
-#define hi(con32) (((con32) >> 16) & 0xFFFF)
-
 /* SSYNC & CSYNC implementations for assembly files */
 
 #define ssync(x) SSYNC(x)
diff --git a/arch/blackfin/include/asm/ptrace.h b/arch/blackfin/include/asm/ptrace.h
index aaa1c6c..8bb8012 100644
--- a/arch/blackfin/include/asm/ptrace.h
+++ b/arch/blackfin/include/asm/ptrace.h
@@ -127,6 +127,193 @@ extern void user_disable_single_step(struct task_struct *child);
 	    ((unsigned long)task_stack_page(task) + \
 	     (THREAD_SIZE - sizeof(struct pt_regs)))
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include <linux/ptreg.h>
+#include <asm/blackfin.h>
+
+#define STR(x)	#x
+#define VAL(x)	STR(x)
+
+#define PTREG_SAVE(r, name)	"%[" #name	"] = " #r "\n"
+
+/*
+ * The following is used for cases where the register can't be saved
+ * directly, but must first be moved to another register that can be
+ * saved directly. The second register must already have been saved
+ * by the time this macro is used.
+ */
+#define PTREG_INDIRECT_SAVE(tmp_r, r, name) \
+				#tmp_r " = " #r "\n" \
+				PTREG_SAVE(tmp_r, name)
+
+#define PTREG_SAVE_LB(i)	_PTREG_INDIRECT_SAVE_I(R0, LB, lb, i)
+#define PTREG_SAVE_LT(i)	_PTREG_INDIRECT_SAVE_I(R0, LT, lt, i)
+#define PTREG_SAVE_LC(i)	_PTREG_INDIRECT_SAVE_I(R0, LC, lc, i)
+#define PTREG_SAVE_B(i)		_PTREG_INDIRECT_SAVE_I(R0, B, b, i)
+#define PTREG_SAVE_L(i)		_PTREG_INDIRECT_SAVE_I(R0, L, l, i)
+#define PTREG_SAVE_M(i)		_PTREG_INDIRECT_SAVE_I(R0, M, m, i)
+#define PTREG_SAVE_I(_i)	_PTREG_INDIRECT_SAVE_I(R0, I, i, _i)
+#define PTREG_SAVE_P(i)		_PTREG_SAVE_I(P, p, i)
+#define PTREG_SAVE_R(i)		_PTREG_SAVE_I(R, r, i)
+
+#define PTREG_OUT_LB(regs, i)	_PTREG_OUT_I(regs, lb, lb, i)
+#define PTREG_OUT_LT(regs, i)	_PTREG_OUT_I(regs, lt, lt, i)
+#define PTREG_OUT_LC(regs, i)	_PTREG_OUT_I(regs, lc, lc, i)
+#define PTREG_OUT_B(regs, i)	_PTREG_OUT_I(regs, b, b, i)
+#define PTREG_OUT_L(regs, i)	_PTREG_OUT_I(regs, l, l, i)
+#define PTREG_OUT_M(regs, i)	_PTREG_OUT_I(regs, m, m, i)
+#define PTREG_OUT_I(regs, _i)	_PTREG_OUT_I(regs, i, i, _i)
+#define PTREG_OUT_P(regs, i)	_PTREG_OUT_I(regs, p, p, i)
+#define PTREG_OUT_R(regs, i)	_PTREG_OUT_I(regs, r, r, i)
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
+			/* Save the Dregs and Pregs first because we may
+			 * use them to save other registers */
+			PTREG_SAVE_R(7)
+			PTREG_SAVE_R(6)
+			PTREG_SAVE_R(5)
+			PTREG_SAVE_R(4)
+			PTREG_SAVE_R(3)
+			PTREG_SAVE_R(2)
+			PTREG_SAVE_R(1)
+			PTREG_SAVE_R(0)
+			PTREG_SAVE_P(5)
+			PTREG_SAVE_P(4)
+			PTREG_SAVE_P(3)
+			PTREG_SAVE_P(2)
+			PTREG_SAVE_P(1)
+			PTREG_SAVE_P(0)
+
+			/* Now all of the Dregs and Pregs can be used for
+			 * saving other registers. Just be sure to add them
+			 * to the clobbered list */
+
+			"p0.l = " VAL(lo(IPEND)) "\n"
+			"p0.h = " VAL(hi(IPEND)) "\n"
+			PTREG_SAVE(p0, ipend)
+			PTREG_INDIRECT_SAVE(R0, seqstat, seqstat)
+			PTREG_INDIRECT_SAVE(R0, rete, rete)
+			PTREG_INDIRECT_SAVE(R0, retn, retn)
+			PTREG_INDIRECT_SAVE(R0, retx, retx)
+			PTREG_INDIRECT_SAVE(R0, rets, rets)
+			PTREG_INDIRECT_SAVE(R0, astat, astat)
+			PTREG_SAVE_LB(1)
+			PTREG_SAVE_LB(0)
+			PTREG_SAVE_LT(1)
+			PTREG_SAVE_LT(0)
+			PTREG_SAVE_LC(1)
+			PTREG_SAVE_LC(0)
+
+	:
+		PTREG_OUT_R(regs, 7),
+		PTREG_OUT_R(regs, 6),
+		PTREG_OUT_R(regs, 5),
+		PTREG_OUT_R(regs, 4),
+		PTREG_OUT_R(regs, 3),
+		PTREG_OUT_R(regs, 2),
+		PTREG_OUT_R(regs, 1),
+		PTREG_OUT_R(regs, 0),
+		PTREG_OUT_P(regs, 5),
+		PTREG_OUT_P(regs, 4),
+		PTREG_OUT_P(regs, 3),
+		PTREG_OUT_P(regs, 2),
+		PTREG_OUT_P(regs, 1),
+		PTREG_OUT_P(regs, 0),
+		PTREG_OUT(regs, ipend, ipend),
+		PTREG_OUT(regs, seqstat, seqstat),
+		PTREG_OUT(regs, rete, rete),
+		PTREG_OUT(regs, retn, retn),
+		PTREG_OUT(regs, retx, retx),
+		PTREG_OUT(regs, rets, rets),
+		PTREG_OUT(regs, astat, astat),
+		PTREG_OUT_LB(regs, 1),
+		PTREG_OUT_LB(regs, 0),
+		PTREG_OUT_LT(regs, 1),
+		PTREG_OUT_LT(regs, 0),
+		PTREG_OUT_LC(regs, 1),
+		PTREG_OUT_LC(regs, 0)
+	:
+	:
+		"R0", "P0"
+	);
+	__asm__ __volatile__ (
+			PTREG_INDIRECT_SAVE(R0, A1.W, a1w)
+			PTREG_INDIRECT_SAVE(R0, A1.X, a1x)
+			PTREG_INDIRECT_SAVE(R0, A0.W, a0w)
+			PTREG_INDIRECT_SAVE(R0, A0.X, a0x)
+			PTREG_SAVE_B(3)
+			PTREG_SAVE_B(2)
+			PTREG_SAVE_B(1)
+			PTREG_SAVE_B(0)
+			PTREG_SAVE_L(3)
+			PTREG_SAVE_L(2)
+			PTREG_SAVE_L(1)
+			PTREG_SAVE_L(0)
+			PTREG_SAVE_M(3)
+			PTREG_SAVE_M(2)
+			PTREG_SAVE_M(1)
+			PTREG_SAVE_M(0)
+			PTREG_SAVE_I(3)
+			PTREG_SAVE_I(2)
+			PTREG_SAVE_I(1)
+			PTREG_SAVE_I(0)
+			PTREG_INDIRECT_SAVE(R0, USP, usp)
+			PTREG_INDIRECT_SAVE(R0, FP, fp)
+			PTREG_INDIRECT_SAVE(R0, SYSCFG, syscfg)
+		"1:\n"
+			/* We've saved P0 already, so we can use it go set
+			 * the pc */
+			"P0.h = 1b\n"
+			"P0.l = 1b\n"
+			PTREG_SAVE(P0, pc)
+	:
+		PTREG_OUT(regs, a1w, a1w),
+		PTREG_OUT(regs, a1x, a1x),
+		PTREG_OUT(regs, a0w, a0w),
+		PTREG_OUT(regs, a0x, a0x),
+		PTREG_OUT_B(regs, 3),
+		PTREG_OUT_B(regs, 2),
+		PTREG_OUT_B(regs, 1),
+		PTREG_OUT_B(regs, 0),
+		PTREG_OUT_L(regs, 3),
+		PTREG_OUT_L(regs, 2),
+		PTREG_OUT_L(regs, 1),
+		PTREG_OUT_L(regs, 0),
+		PTREG_OUT_M(regs, 3),
+		PTREG_OUT_M(regs, 2),
+		PTREG_OUT_M(regs, 1),
+		PTREG_OUT_M(regs, 0),
+		PTREG_OUT_I(regs, 3),
+		PTREG_OUT_I(regs, 2),
+		PTREG_OUT_I(regs, 1),
+		PTREG_OUT_I(regs, 0),
+		PTREG_OUT(regs, usp, usp),
+		PTREG_OUT(regs, fp, fp),
+		PTREG_OUT(regs, syscfg, syscfg),
+		PTREG_OUT(regs, pc, pc)
+	:
+	:
+		"R0", "P0"
+	);
+
+	return regs;
+}
 #endif  /*  __KERNEL__  */
 
 #endif				/* __ASSEMBLY__ */
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index ba70c4b..44a709c 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -246,7 +246,7 @@ asmlinkage void double_fault_c(struct pt_regs *fp)
 		dump_bfin_trace_buffer();
 	}
 #endif
-	panic("Double Fault - unrecoverable event");
+	panic_with_regs(fp, "Double Fault - unrecoverable event");
 
 }
 
@@ -388,7 +388,7 @@ asmlinkage notrace void trap_c(struct pt_regs *fp)
 				/* call to panic() will dump trace, and it is
 				 * off at this point, so it won't be clobbered
 				 */
-				panic("BUG()");
+				panic_with_regs(fp, "BUG()");
 			}
 		}
 #endif
@@ -631,7 +631,7 @@ asmlinkage notrace void trap_c(struct pt_regs *fp)
 			verbose_printk(KERN_EMERG "Please turn on "
 			       "CONFIG_ACCESS_CHECK\n");
 #endif
-			panic("Kernel exception");
+			panic_with_regs(fp, "Kernel exception");
 		} else {
 #ifdef CONFIG_DEBUG_VERBOSE
 			unsigned long *stack;
@@ -1347,5 +1347,5 @@ void panic_cplb_error(int cplb_panic, struct pt_regs *fp)
 	dump_bfin_mem(fp);
 	show_regs(fp);
 	dump_stack();
-	panic("Unrecoverable event");
+	panic_with_regs(fp, "Unrecoverable event");
 }
