Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab0DLGEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:04:32 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:40000 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0DLGE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:04:28 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACZVwkurR7Hu/2dsb2JhbACbM3GhRZgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="181521266"
Date: Sun, 11 Apr 2010 23:04:26 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 15/23] Make register values available to PA-RISC panic
	notifiers
Message-ID: <20100412060426.GA24751@dvomlehn-lnx2.corp.sa.net>
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
 arch/parisc/include/asm/ptrace.h |  146 ++++++++++++++++++++++++++++++++++++++
 arch/parisc/kernel/traps.c       |    4 +-
 2 files changed, 148 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/ptrace.h b/arch/parisc/include/asm/ptrace.h
index aead40b..f95d560 100644
--- a/arch/parisc/include/asm/ptrace.h
+++ b/arch/parisc/include/asm/ptrace.h
@@ -63,6 +63,152 @@ void user_enable_block_step(struct task_struct *task);
 unsigned long profile_pc(struct pt_regs *);
 extern void show_regs(struct pt_regs *);
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include "/home/vomlehn/git/kernel.org/ptreg.h"
+#define PTREG_SAVE(r, name)		"stw	%%" #r ", %[" #r "]\n"
+#define PTREG_SAVE_GR(i)		PTREG_SAVE_IDX(gr, r, i)
+#define PTREG_SAVE_SR(i)		PTREG_SAVE_IDX(sr, sr, i)
+#define PTREG_SAVE_IASQ(i)		PTREG_SAVE_IDX(iasq, iasq, i)
+#define PTREG_SAVE_IAOQ(i)		PTREG_SAVE_IDX(iaoq, iaoq, i)
+
+#define PTREG_OUT_GR(regs, i)		PTREG_SAVE_IDX(regs, gr, gr, i)
+#define PTREG_OUT_SR(regs, i)		PTREG_SAVE_IDX(regs, sr, sr, i)
+#define PTREG_OUT_IASQ(regs, i)		PTREG_SAVE_IDX(regs, iasq, iasq, i)
+#define PTREG_OUT_IAOQ(regs, i)		PTREG_SAVE_IDX(regs, iaoq, iaoq, i)
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
+			PTREG_SAVE_GR(0)
+			PTREG_SAVE_GR(1)
+			PTREG_SAVE_GR(2)
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
+			PTREG_SAVE_GR(28)
+			PTREG_SAVE_GR(29)
+			PTREG_SAVE_GR(30)
+			PTREG_SAVE_GR(31)
+			PTREG_SAVE_SR(0)
+			PTREG_SAVE_SR(1)
+			PTREG_SAVE_SR(2)
+			PTREG_SAVE_SR(3)
+			PTREG_SAVE_SR(4)
+			PTREG_SAVE_SR(5)
+			PTREG_SAVE_SR(6)
+			PTREG_SAVE_SR(7)
+			PTREG_SAVE_IASQ(0)
+			PTREG_SAVE_IASQ(1)
+			PTREG_SAVE_IAOQ(0)
+			PTREG_SAVE_IAOQ(1)
+			PTREG_SAVE(cr27, cr27)
+			PTREG_SAVE(orig_r28, orig_r28)
+			PTREG_SAVE(ksp, ksp)
+			PTREG_SAVE(kpc, kpc)
+			PTREG_SAVE(sar, sar)
+			PTREG_SAVE(iir, iir)
+			PTREG_SAVE(isr, isr)
+			PTREG_SAVE(ior, ior)
+			PTREG_SAVE(ipsw, ipsw)
+		"1:\n"
+			"ldil	1b, %r1\n"
+			PTSAVE(r0, pc)
+	:
+		PTREG_OUT_GR(regs, 0)
+		PTREG_OUT_GR(regs, 1)
+		PTREG_OUT_GR(regs, 2)
+		PTREG_OUT_GR(regs, 3)
+		PTREG_OUT_GR(regs, 4)
+		PTREG_OUT_GR(regs, 5)
+		PTREG_OUT_GR(regs, 6)
+		PTREG_OUT_GR(regs, 7)
+		PTREG_OUT_GR(regs, 8)
+		PTREG_OUT_GR(regs, 9)
+		PTREG_OUT_GR(regs, 10)
+		PTREG_OUT_GR(regs, 11)
+		PTREG_OUT_GR(regs, 12)
+		PTREG_OUT_GR(regs, 13)
+		PTREG_OUT_GR(regs, 14)
+		PTREG_OUT_GR(regs, 15)
+		PTREG_OUT_GR(regs, 16)
+		PTREG_OUT_GR(regs, 17)
+		PTREG_OUT_GR(regs, 18)
+		PTREG_OUT_GR(regs, 19)
+		PTREG_OUT_GR(regs, 20)
+		PTREG_OUT_GR(regs, 21)
+		PTREG_OUT_GR(regs, 22)
+		PTREG_OUT_GR(regs, 23)
+		PTREG_OUT_GR(regs, 24)
+		PTREG_OUT_GR(regs, 25)
+		PTREG_OUT_GR(regs, 26)
+		PTREG_OUT_GR(regs, 27)
+		PTREG_OUT_GR(regs, 28)
+		PTREG_OUT_GR(regs, 29)
+		PTREG_OUT_GR(regs, 30)
+		PTREG_OUT_GR(regs, 31)
+		PTREG_OUT_SR(regs, 0)
+		PTREG_OUT_SR(regs, 1)
+		PTREG_OUT_SR(regs, 2)
+		PTREG_OUT_SR(regs, 3)
+		PTREG_OUT_SR(regs, 4)
+		PTREG_OUT_SR(regs, 5)
+		PTREG_OUT_SR(regs, 6)
+		PTREG_OUT_SR(regs, 7)
+		PTREG_OUT_IASQ(regs, 0)
+		PTREG_OUT_IASQ(regs, 1)
+		PTREG_OUT_IAOQ(regs, 0)
+		PTREG_OUT_IAOQ(regs, 1)
+		PTREG_OUT(regs, cr27, cr27)
+		PTREG_OUT(regs, orig_r28, orig_r28)
+		PTREG_OUT(regs, ksp, ksp)
+		PTREG_OUT(regs, kpc, kpc)
+		PTREG_OUT(regs, sar, sar)
+		PTREG_OUT(regs, iir, iir)
+		PTREG_OUT(regs, isr, isr)
+		PTREG_OUT(regs, ior, ior)
+		PTREG_OUT(regs, ipsw, ipsw)
+	:
+		"r0"
+	);
+
+	return regs;
+}
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 8b58bf0..23dabd2 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -286,12 +286,12 @@ void die_if_kernel(char *str, struct pt_regs *regs, long err)
 	add_taint(TAINT_DIE);
 
 	if (in_interrupt())
-		panic("Fatal exception in interrupt");
+		panic_with_regs(regs, "Fatal exception in interrupt");
 
 	if (panic_on_oops) {
 		printk(KERN_EMERG "Fatal exception: panic in 5 seconds\n");
 		ssleep(5);
-		panic("Fatal exception");
+		panic_with_regs(regs, "Fatal exception");
 	}
 
 	oops_exit();
