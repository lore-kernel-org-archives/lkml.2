Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0DLGLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:11:06 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:6473 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0DLGGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:06:13 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACZVwkurR7Hu/2dsb2JhbACbM3GhRZgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="181522072"
Date: Sun, 11 Apr 2010 23:06:13 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux-arch@vger.kernel.org"@cisco.com,
       linux-arch@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 2/23] Make register values available to Alpha panic
	notifiers
Message-ID: <20100412060613.GA25303@dvomlehn-lnx2.corp.sa.net>
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
 arch/alpha/include/asm/ptrace.h |  124 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/include/asm/ptrace.h b/arch/alpha/include/asm/ptrace.h
index 65cf3e2..952d177 100644
--- a/arch/alpha/include/asm/ptrace.h
+++ b/arch/alpha/include/asm/ptrace.h
@@ -79,6 +79,130 @@ extern void show_regs(struct pt_regs *);
 
 #define force_successful_syscall_return() (task_pt_regs(current)->r0 = 0)
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include "/home/vomlehn/git/kernel.org/linux/ptreg.h"
+#define PTREG_SAVE(r, name)	"stq	" #r ", %[" #name "]\n"
+#define PTREG_SAVE_R(i)		PTREG_SAVE_I($, r, i)
+
+#define PTREG_OUT_R(regsp, i)	PTREG_OUT_I(regsp, r, r, i)
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
+			/* Based on the SAVE_ALL code */
+			PTREG_SAVE_R(0)
+			PTREG_SAVE_R(1)
+			PTREG_SAVE_R(2)
+			PTREG_SAVE_R(3)
+			PTREG_SAVE_R(4)
+			PTREG_SAVE_R(28)
+			"lda	$2, alpha_mv\n"
+			PTREG_SAVE_R(5)
+			PTREG_SAVE_R(6)
+			PTREG_SAVE_R(7)
+			PTREG_SAVE_R(8)
+			PTREG_SAVE_R(19)
+			PTREG_SAVE_R(20)
+			PTREG_SAVE_R(21)
+			"ldq	$2, HAE_CACHE($2)\n"
+			PTREG_SAVE_R(22)
+			PTREG_SAVE_R(23)
+			PTREG_SAVE_R(24)
+			PTREG_SAVE_R(25)
+			PTREG_SAVE_R(26)
+			PTREG_SAVE_R(27)
+			PTREG_SAVE($2, hae)
+			PTREG_SAVE_R(16)
+			PTREG_SAVE_R(17)
+			PTREG_SAVE_R(18)
+
+			PTREG_SAVE_R(9)
+			PTREG_SAVE_R(10)
+			PTREG_SAVE_R(11)
+			PTREG_SAVE_R(12)
+			PTREG_SAVE_R(13)
+			PTREG_SAVE_R(14)
+			PTREG_SAVE_R(15)
+			PTREG_SAVE_R(29)
+			PTREG_SAVE_R(30)
+			PTREG_SAVE_R(31)
+			PTREG_SAVE_REG($gp, gp)
+			PTREG_SAVE_REG($31, ps)
+
+			/* These are almost certainly wrong */
+			PTREG_SAVE_REG(trap_a0, trap_a0)
+			PTREG_SAVE_REG(trap_a1, trap_a1)
+			PTREG_SAVE_REG(trap_a2, trap_a2)
+		/*
+		 * The current location is the one for which the register
+		 * values are correct, even if some had been modified on
+		 * function entry. So, the current location is the value to
+		 * save as the execution address.
+		 */
+		"1b:\n"
+			"lda	$2, 1b\n"
+			PTREG_SAVE($2, pc)
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
+		PTREG_OUT_R(regs, 13),
+		PTREG_OUT_R(regs, 14),
+		PTREG_OUT_R(regs, 15),
+		PTREG_OUT_R(regs, 16),
+		PTREG_OUT_R(regs, 17),
+		PTREG_OUT_R(regs, 18),
+		PTREG_OUT_R(regs, 19),
+		PTREG_OUT_R(regs, 20),
+		PTREG_OUT_R(regs, 21),
+		PTREG_OUT_R(regs, 22),
+		PTREG_OUT_R(regs, 23),
+		PTREG_OUT_R(regs, 24),
+		PTREG_OUT_R(regs, 25),
+		PTREG_OUT_R(regs, 26),
+		PTREG_OUT_R(regs, 27),
+		PTREG_OUT_R(regs, 28),
+		PTREG_OUT_R(regs, 29),
+		PTREG_OUT_R(regs, 30),
+		PTREG_OUT_R(regs, 31),
+
+		PTREG_OUT(regs, hae, hae),
+		PTREG_OUT(regs, trap_a0, trap_a0),
+		PTREG_OUT(regs, trap_a1, trap_a1),
+		PTREG_OUT(regs, trap_a2, trap_a2),
+		PTREG_OUT(regs, ps, ps),
+		PTREG_OUT(regs, pc, pc),
+		PTREG_OUT(regs, gp, gp)
+	:
+		"$2"
+	);
+
+	return regs;
+}
 #endif
 
 #endif
