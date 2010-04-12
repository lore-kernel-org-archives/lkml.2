Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0DLGOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:14:12 -0400
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:3850 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab0DLGOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:14:11 -0400
Authentication-Results: rtp-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAK9UwktAZnwN/2dsb2JhbACbM3GhRZgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="100750487"
Date: Sun, 11 Apr 2010 23:04:29 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 16/23] Make register values available to PowerPC panic
	notifiers
Message-ID: <20100412060429.GA24780@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The save_ptregs() functions compiles cleanly on 32-bit systems, but has not
been tested. Compilation on 64-bit systems has not been done.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 arch/powerpc/include/asm/ptrace.h |  167 +++++++++++++++++++++++++++++++++++++
 arch/powerpc/kernel/traps.c       |    4 +-
 2 files changed, 169 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
index cbd759e..5b3dd23 100644
--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -225,6 +225,7 @@ extern void user_disable_single_step(struct task_struct *);
 #define PT_VR0_32 164	/* each Vector reg occupies 4 slots in 32-bit */
 #define PT_VSCR_32 (PT_VR0 + 32*4 + 3)
 #define PT_VRSAVE_32 (PT_VR0 + 33*4)
+
 #endif
 
 /*
@@ -237,6 +238,172 @@ extern void user_disable_single_step(struct task_struct *);
 #endif
 #endif /* __powerpc64__ */
 
+#if !defined(__ASSEMBLY__) && defined(__KERNEL__)
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+
+#include <linux/ptreg.h>
+
+#ifdef __powerpc64__
+#define PTREG_SAVE(r, name)		"std	" #r ", %[" #name "]\n"
+#else
+#define PTREG_SAVE(r, name)		"stw	" #r ", %[" #name "]\n"
+#endif
+
+#define PTREG_SAVE_GPR(i)		_PTREG_SAVE_IDX(, gpr, i)
+
+#define PTREG_OUT_GPR(regs, i)		_PTREG_OUT_IDX(regs, gpr, gpr, i)
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
+	:
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
+		PTREG_OUT_GPR(regs, 29)
+	:
+	);
+
+	/*
+	 * We have a 30 operand limitation in asm statements, so this is the
+	 * continuation. Nothing should be happening betweent the two
+	 * statements and they are __volatile__, so the registers *shouldn't*
+	 * change values.
+	 */
+	__asm__ __volatile__ (
+			PTREG_SAVE_GPR(30)
+			PTREG_SAVE_GPR(31)
+
+			/*
+			 * Now get various special registers. These must first
+			 * be moved to register 0, so the entry value must
+			 * already be saved.
+			 */
+			"mfxer	0\n"
+			PTREG_SAVE(0, xer)
+
+			"mfmsr	0\n"
+			PTREG_SAVE(0, msr)
+
+			"mfctr	0\n"
+			PTREG_SAVE(0, ctr)
+
+			"mflr	0\n"
+			PTREG_SAVE(0, link)
+
+			"mfcr	0\n"
+			PTREG_SAVE(0, ccr)
+#ifdef __powerpc64__
+			PTREG_SAVE(softe, softe)
+#endif
+			"mfdar	0\n"
+			PTREG_SAVE(0, dar)
+
+			"mfdsisr	0\n"
+			PTREG_SAVE(0, dsisr)
+		"1:\n"
+#ifdef __powerpc64__
+			"li	0, 1b\n"
+#else
+			"lis	0, 1b@ha\n"
+			"addi	0, 0, 1b@l\n"
+#endif
+			PTREG_SAVE(0, nip)
+	:
+		PTREG_OUT_GPR(regs, 30),
+		PTREG_OUT_GPR(regs, 31),
+		PTREG_OUT(regs, xer, xer),
+		PTREG_OUT(regs, msr, msr),
+		PTREG_OUT(regs, ctr, ctr),
+		PTREG_OUT(regs, link, link),
+		PTREG_OUT(regs, ccr, ccr),
+#ifdef __powerpc64__
+		PTREG_OUT(regs, softe, softe),
+#else
+		PTREG_OUT(regs, mq, mq),
+#endif
+		PTREG_OUT(regs, dar, dar),
+		PTREG_OUT(regs, dsisr, dsisr),
+		PTREG_OUT(regs, nip, nip)
+	:
+	:
+		"r0"
+	);
+
+	return regs;
+}
+#endif
+
 /*
  * Get/set all the altivec registers vr0..vr31, vscr, vrsave, in one go.
  * The transfer totals 34 quadword.  Quadwords 0-31 contain the
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index d069ff8..9b56fec 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -163,10 +163,10 @@ int die(const char *str, struct pt_regs *regs, long err)
 	crash_kexec_secondary(regs);
 
 	if (in_interrupt())
-		panic("Fatal exception in interrupt");
+		panic_with_regs(regs, "Fatal exception in interrupt");
 
 	if (panic_on_oops)
-		panic("Fatal exception");
+		panic_with_regs(regs, "Fatal exception");
 
 	oops_exit();
 	do_exit(err);
