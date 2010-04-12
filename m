Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0DLGEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:04:49 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:23218 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0DLGEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:04:43 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGJVwkurR7Ht/2dsb2JhbACbM3GhNpgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="513153806"
Date: Sun, 11 Apr 2010 23:04:43 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 20/23] Make register values available to Sparc panic
	notifiers
Message-ID: <20100412060443.GA24894@dvomlehn-lnx2.corp.sa.net>
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
 arch/sparc/include/asm/ptrace.h |  161 +++++++++++++++++++++++++++++++++++++++
 arch/sparc/kernel/traps_32.c    |    3 +-
 arch/sparc/kernel/traps_64.c    |   11 ++-
 3 files changed, 169 insertions(+), 6 deletions(-)

diff --git a/arch/sparc/include/asm/ptrace.h b/arch/sparc/include/asm/ptrace.h
index 30b0b79..7303ebf 100644
--- a/arch/sparc/include/asm/ptrace.h
+++ b/arch/sparc/include/asm/ptrace.h
@@ -420,6 +420,167 @@ extern void show_regs(struct pt_regs *);
 #define GR_SNAP_THREAD	0x30
 #define GR_SNAP_PAD1	0x38
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include <linux/ptreg.h>
+
+#if defined(__sparc__) && defined(__arch64__)
+#define PTREG_SAVE(r, name)		"stx	" #r ", %[" #name "]\n"
+#else
+#define PTREG_SAVE(r, name)		"st	" #r ", %[" #name "]\n"
+#endif
+
+#define PTREG_SAVE_U(i)			PTREG_SAVE_IDX(%g, u_regs, i)
+
+#define PTREG_OUT_U(regs, i)		PTREG_OUT_IDX(regs, %g, u_regs, i)
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
+#if defined(__sparc__) && defined(__arch64__)
+static __always_inline
+const struct pt_regs *save_ptregs(struct pt_regs *regs)
+{
+	__asm__ __volatile__ (
+			PTREG_SAVE_U(0)
+			PTREG_SAVE_U(1)
+			PTREG_SAVE_U(2)
+			PTREG_SAVE_U(3)
+			PTREG_SAVE_U(4)
+			PTREG_SAVE_U(5)
+			PTREG_SAVE_U(6)
+			PTREG_SAVE_U(7)
+			PTREG_SAVE_U(8)
+			PTREG_SAVE_U(9)
+			PTREG_SAVE_U(10)
+			PTREG_SAVE_U(11)
+			PTREG_SAVE_U(12)
+			PTREG_SAVE_U(13)
+			PTREG_SAVE_U(14)
+			PTREG_SAVE_U(15)
+			PTREG_SAVE(tstate, tstate)
+			PTREG_SAVE(tpc, tpc)
+			PTREG_SAVE(tnpc, tnpc)
+			PTREG_SAVE(y, y)
+			PTREG_SAVE(magic, magic)
+		/*
+		 * The current location is the one for which the register
+		 * values are correct, even if some had been modified on
+		 * function entry. So, the current location is the value to
+		 * save as the execution address.
+		 */
+		 "1:\n"
+			 "sethi	%%hi(1b), %g7\n"
+			"or	%g7, %lo(1b), %g7\n"
+			PTREG_SAVE(%g7, tpc)
+	:
+		PTREG_OUT_U(0),
+		PTREG_OUT_U(1),
+		PTREG_OUT_U(2),
+		PTREG_OUT_U(3),
+		PTREG_OUT_U(4),
+		PTREG_OUT_U(5),
+		PTREG_OUT_U(6),
+		PTREG_OUT_U(7),
+		PTREG_OUT_U(8),
+		PTREG_OUT_U(9),
+		PTREG_OUT_U(10),
+		PTREG_OUT_U(11),
+		PTREG_OUT_U(12),
+		PTREG_OUT_U(13),
+		PTREG_OUT_U(14),
+		PTREG_OUT_U(15),
+		PTREG_OUT(regs, tstate, tstate),
+		PTREG_OUT(regs, tpc, tpc),
+		PTREG_OUT(regs, tnpc, tnpc),
+		PTREG_OUT(regs, y, y),
+		PTREG_OUT(regs, magic, magic)
+	:
+		"g7"
+	);
+
+	return regs;
+}
+#else
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
+			PTREG_SAVE_U(0)
+			PTREG_SAVE_U(1)
+			PTREG_SAVE_U(2)
+			PTREG_SAVE_U(3)
+			PTREG_SAVE_U(4)
+			PTREG_SAVE_U(5)
+			PTREG_SAVE_U(6)
+			PTREG_SAVE_U(7)
+			PTREG_SAVE_U(8)
+			PTREG_SAVE_U(9)
+			PTREG_SAVE_U(10)
+			PTREG_SAVE_U(11)
+			PTREG_SAVE_U(12)
+			PTREG_SAVE_U(13)
+			PTREG_SAVE_U(14)
+			PTREG_SAVE_U(15)
+			PTREG_SAVE(psr, psr)
+			PTREG_SAVE(pc, pc)
+			PTREG_SAVE(npc, npc)
+			PTREG_SAVE(y, y)
+			PTREG_SAVE(magic, magic)
+		/*
+		 * The current location is the one for which the register
+		 * values are correct, even if some had been modified on
+		 * function entry. So, the current location is the value to
+		 * save as the execution address.
+		 */
+	:
+		PTREG_OUT_U(0),
+		PTREG_OUT_U(1),
+		PTREG_OUT_U(2),
+		PTREG_OUT_U(3),
+		PTREG_OUT_U(4),
+		PTREG_OUT_U(5),
+		PTREG_OUT_U(6),
+		PTREG_OUT_U(7),
+		PTREG_OUT_U(8),
+		PTREG_OUT_U(9),
+		PTREG_OUT_U(10),
+		PTREG_OUT_U(11),
+		PTREG_OUT_U(12),
+		PTREG_OUT_U(13),
+		PTREG_OUT_U(14),
+		PTREG_OUT_U(15),
+		PTREG_OUT(regs, psr, psr),
+		PTREG_OUT(regs, pc, pc),
+		PTREG_OUT(regs, npc, npc),
+		PTREG_OUT(regs, y, y),
+		PTREG_OUT(regs, magic, magic)
+	:
+	);
+
+	return regs;
+}
+#endif /* (defined(__sparc__) && defined(__arch64__)) */
+
 #endif  /*  __KERNEL__  */
 
 /* Stuff for the ptrace system call */
diff --git a/arch/sparc/kernel/traps_32.c b/arch/sparc/kernel/traps_32.c
index c0490c7..9b41e2f 100644
--- a/arch/sparc/kernel/traps_32.c
+++ b/arch/sparc/kernel/traps_32.c
@@ -353,7 +353,8 @@ void handle_watchpoint(struct pt_regs *regs, unsigned long pc, unsigned long npc
 	       pc, npc, psr);
 #endif
 	if(psr & PSR_PS)
-		panic("Tell me what a watchpoint trap is, and I'll then deal "
+		panic_with_regs(regs,
+			"Tell me what a watchpoint trap is, and I'll then deal "
 		      "with such a beast...");
 }
 
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 10f7bb9..c4035d3 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -1347,7 +1347,7 @@ void cheetah_fecc_handler(struct pt_regs *regs, unsigned long afsr, unsigned lon
 	cheetah_log_errors(regs, &local_snapshot, afsr, afar, recoverable);
 
 	if (!recoverable)
-		panic("Irrecoverable Fast-ECC error trap.\n");
+		panic_with_regs(regs, "Irrecoverable Fast-ECC error trap.\n");
 
 	/* Flush E-cache to kick the error trap handlers out. */
 	cheetah_flush_ecache();
@@ -1525,7 +1525,8 @@ void cheetah_cee_handler(struct pt_regs *regs, unsigned long afsr, unsigned long
 	cheetah_log_errors(regs, &local_snapshot, afsr, afar, recoverable);
 
 	if (!recoverable)
-		panic("Irrecoverable Correctable-ECC error trap.\n");
+		panic_with_regs(regs,
+			"Irrecoverable Correctable-ECC error trap.\n");
 }
 
 void cheetah_deferred_handler(struct pt_regs *regs, unsigned long afsr, unsigned long afar)
@@ -1712,7 +1713,7 @@ void cheetah_deferred_handler(struct pt_regs *regs, unsigned long afsr, unsigned
 	}
 
 	if (!recoverable)
-		panic("Irrecoverable deferred error trap.\n");
+		panic_with_regs(regs, "Irrecoverable deferred error trap.\n");
 }
 
 /* Handle a D/I cache parity error trap.  TYPE is encoded as:
@@ -1747,7 +1748,7 @@ void cheetah_plus_parity_error(int type, struct pt_regs *regs)
 		       (type & 0x1) ? 'I' : 'D',
 		       regs->tpc);
 		printk(KERN_EMERG "TPC<%pS>\n", (void *) regs->tpc);
-		panic("Irrecoverable Cheetah+ parity error.");
+		panic_with_regs(regs, "Irrecoverable Cheetah+ parity error.");
 	}
 
 	printk(KERN_WARNING "CPU[%d]: Cheetah+ %c-cache parity error at TPC[%016lx]\n",
@@ -1934,7 +1935,7 @@ void sun4v_nonresum_error(struct pt_regs *regs, unsigned long offset)
 			KERN_EMERG "NON-RESUMABLE ERROR",
 			&sun4v_nonresum_oflow_cnt);
 
-	panic("Non-resumable error.");
+	panic_with_regs(regs, "Non-resumable error.");
 }
 
 /* If we try to printk() we'll probably make matters worse, by trying
