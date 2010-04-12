Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0DLGE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:04:59 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:65425 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0DLGE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:04:57 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACZVwktAaMHG/2dsb2JhbACbM3GhRZgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="181521480"
Date: Sun, 11 Apr 2010 23:04:52 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 23/23] Make register values available to Xtensa panic
	notifiers
Message-ID: <20100412060452.GA24979@dvomlehn-lnx2.corp.sa.net>
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
 arch/xtensa/include/asm/ptrace.h |   93 ++++++++++++++++++++++++++++++++++++++
 arch/xtensa/kernel/traps.c       |    4 +-
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/include/asm/ptrace.h b/arch/xtensa/include/asm/ptrace.h
index 905e1e6..56d5721 100644
--- a/arch/xtensa/include/asm/ptrace.h
+++ b/arch/xtensa/include/asm/ptrace.h
@@ -130,6 +130,99 @@ extern void show_regs(struct pt_regs *);
 
 #endif	/* !__ASSEMBLY__ */
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#define PTREG_SAVE(r, name)		"movel	" #r ", %[" #name "]\n"
+#define PTREG_SAVE_R(r)			PTREG_SAVE_I(r, r, i)
+
+#define PTREG_OUT_R(regs, i)		PTREG_OUT_I(regs, i)
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
+			PTREG_SAVE(pc, pc)
+			PTREG_SAVE(ps, ps)
+			PTREG_SAVE(depc, depc)
+			PTREG_SAVE(exccause, exccause)
+			PTREG_SAVE(excvaddr, excvaddr)
+			PTREG_SAVE(debugcause, debugcause)
+			PTREG_SAVE(wmask, wmask)
+			PTREG_SAVE(lbeg, lbeg)
+			PTREG_SAVE(lend, lend)
+			PTREG_SAVE(lcount, lcount)
+			PTREG_SAVE(sar, sar)
+			PTREG_SAVE(windowbase, windowbase)
+			PTREG_SAVE(windowstart, windowstart)
+			PTREG_SAVE(syscall, syscall)
+			PTREG_SAVE(icountlevel, icountlevel)
+			/* Don't know how to handle xtregs_opt_t definitions */
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
+	:
+		PTREG_OUT(regs, pc, pc),
+		PTREG_OUT(regs, ps, ps),
+		PTREG_OUT(regs, depc, depc),
+		PTREG_OUT(regs, exccause, exccause),
+		PTREG_OUT(regs, excvaddr, excvaddr),
+		PTREG_OUT(regs, debugcause, debugcause),
+		PTREG_OUT(regs, wmask, wmask),
+		PTREG_OUT(regs, lbeg, lbeg),
+		PTREG_OUT(regs, lend, lend),
+		PTREG_OUT(regs, lcount, lcount),
+		PTREG_OUT(regs, sar, sar),
+		PTREG_OUT(regs, windowbase, windowbase),
+		PTREG_OUT(regs, windowstart, windowstart),
+		PTREG_OUT(regs, syscall, syscall),
+		PTREG_OUT(regs, icountlevel, icountlevel),
+		/* Don't know how to handle xtregs_opt_t definitions */
+		PTREG_OUT_R(regs, 0),
+		PTREG_OUT_R(regs, 1),
+		PTREG_OUT_R(regs, 2),
+		PTREG_OUT_R(regs, 3),
+		PTREG_OUT_R(regs, 4),
+		PTREG_OUT_R(regs, 5),
+		PTREG_OUT_R(regs, 6),
+		PTREG_OUT_R(regs, 7),
+		PTREG_OUT_R(regs, 8),
+		PTREG_OUT_R(regs, 9),
+		PTREG_OUT_R(regs, 10),
+		PTREG_OUT_R(regs, 11),
+		PTREG_OUT_R(regs, 12),
+		PTREG_OUT_R(regs, 13),
+		PTREG_OUT_R(regs, 14),
+		PTREG_OUT_R(regs, 15)
+	:
+	);
+
+	return regs;
+}
 #endif  /* __KERNEL__ */
 
 #endif	/* _XTENSA_PTRACE_H */
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index e64efac..3441d54 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -497,10 +497,10 @@ void die(const char * str, struct pt_regs * regs, long err)
 	spin_unlock_irq(&die_lock);
 
 	if (in_interrupt())
-		panic("Fatal exception in interrupt");
+		panic_with_regs(regs, "Fatal exception in interrupt");
 
 	if (panic_on_oops)
-		panic("Fatal exception");
+		panic_with_regs(regs, "Fatal exception");
 
 	do_exit(err);
 }
