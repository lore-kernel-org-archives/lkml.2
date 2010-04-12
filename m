Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab0DLGDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:03:51 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:23022 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0DLGDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:03:49 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADZUwkurRN+K/2dsb2JhbACbM3GhP5gUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="513153515"
Date: Sun, 11 Apr 2010 23:03:48 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 4/23] Make register values available to AV32 panic notifiers
Message-ID: <20100412060348.GA24382@dvomlehn-lnx2.corp.sa.net>
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
 arch/avr32/include/asm/ptrace.h |   68 +++++++++++++++++++++++++++++++++++++++
 arch/avr32/kernel/traps.c       |    4 +-
 2 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/include/asm/ptrace.h b/arch/avr32/include/asm/ptrace.h
index e53dd0d..28b7f25 100644
--- a/arch/avr32/include/asm/ptrace.h
+++ b/arch/avr32/include/asm/ptrace.h
@@ -151,6 +151,74 @@ static __inline__ int valid_user_regs(struct pt_regs *regs)
 	return 0;
 }
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#define PTREG_SAVE(r, name)	"st.w	" #r ", %[" #name "]\n"
+#define PTREG_SAVE_R(i)		PTREG_SAVE_I(r, r, i)
+
+#define PTREG_OUT_R(regs, i)	PTREG_OUT(regs, r##i, r##i)
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
+			PTREG_SAVE(sp, sp)
+			PTREG_SAVE(lr, lr)
+			PTREG_SAVE(sr, sr)
+			PTREG_SAVE(r12_orig, r12_orig)
+		"1:\n"
+			"mov r0, 1b\n"
+			PTREG_SAVE(r0, pc)
+	:
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
+		PTREG_OUT(regs, sp, sp),
+		PTREG_OUT(regs, lr, lr),
+		PTREG_OUT(regs, pc, pc),
+		PTREG_OUT(regs, sr, sr),
+		PTREG_OUT(regs, r12_orig, r12_orig)
+	:
+		"r0"
+	);
+
+	return regs;
+}
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index b91b204..100c52a 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -65,10 +65,10 @@ void NORET_TYPE die(const char *str, struct pt_regs *regs, long err)
 	spin_unlock_irq(&die_lock);
 
 	if (in_interrupt())
-		panic("Fatal exception in interrupt");
+		panic_with_regs(regs, "Fatal exception in interrupt");
 
 	if (panic_on_oops)
-		panic("Fatal exception");
+		panic_with_regs(regs, "Fatal exception");
 
 	do_exit(err);
 }
