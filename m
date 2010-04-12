Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0DLGEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:04:15 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:10590 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab0DLGEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:04:11 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHRUwkurR7Hu/2dsb2JhbACbM3GhRZgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="113730829"
Date: Sun, 11 Apr 2010 23:04:11 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 11/23] Make register values available to M68K panic
	notifiers
Message-ID: <20100412060411.GA24636@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The save_ptregs() function has not been tested or even built. I will need
help to complete this.

This appeared to require a Makefile change in order to compile kernel/entry.S.
The problem was that it was complaining about having an "invalid instruction
for this architecture; needs 68000 or higher". Choosing a processor didn't
seem to help, but adding the processor to KBUILD_AFLAGS in appropriate places
resolved the problem. Has bit rot set in to the m68k tree?

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 arch/m68k/Makefile             |    2 +
 arch/m68k/include/asm/ptrace.h |   74 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index 570d85c..bab0202 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -41,10 +41,12 @@ ifndef CONFIG_M68030
 
 ifndef CONFIG_M68060
 KBUILD_CFLAGS += -m68040
+KBUILD_AFLAGS += -m68040
 endif
 
 ifndef CONFIG_M68040
 KBUILD_CFLAGS += -m68060
+KBUILD_AFLAGS += -m68060
 endif
 
 endif
diff --git a/arch/m68k/include/asm/ptrace.h b/arch/m68k/include/asm/ptrace.h
index ee4011c..2786ea4 100644
--- a/arch/m68k/include/asm/ptrace.h
+++ b/arch/m68k/include/asm/ptrace.h
@@ -85,6 +85,80 @@ struct switch_stack {
 #define profile_pc(regs) instruction_pointer(regs)
 extern void show_regs(struct pt_regs *);
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+
+#include <linux/ptreg.h>
+
+#define PTREG_SAVE(r, name)	"movel	%" #r ", %[" #name "]\n"
+#define PTREG_SAVE_D(i)		_PTREG_SAVE_I(d, d, i)
+#define PTREG_SAVE_A(i)		_PTREG_SAVE_I(a, a, i)
+
+#define PTREG_OUT_D(regs, i)	_PTREG_OUT_I(regs, d, d, i)
+#define PTREG_OUT_A(regs, i)	_PTREG_OUT_I(regs, a, a, i)
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
+			PTREG_SAVE_D(1)
+			PTREG_SAVE_D(2)
+			PTREG_SAVE_D(3)
+			PTREG_SAVE_D(4)
+			PTREG_SAVE_D(5)
+			PTREG_SAVE_A(0)
+			PTREG_SAVE_A(1)
+			PTREG_SAVE_A(2)
+			PTREG_SAVE_D(0)
+			PTREG_SAVE(orig_d0, orig_d0)
+			PTREG_SAVE(stkadj, stkadj)
+#if 0
+			PTREG_SAVE(format, format)
+			PTREG_SAVE(vector, vector)
+#endif
+			PTREG_SAVE(sr, sr)
+		"1:\n"
+			"lea	1b, %a0"
+			PTREG_SAVE(a0, pc)
+	:
+		PTREG_OUT_D(regs, 0),
+		PTREG_OUT_D(regs, 1),
+		PTREG_OUT_D(regs, 2),
+		PTREG_OUT_D(regs, 3),
+		PTREG_OUT_D(regs, 4),
+		PTREG_OUT_D(regs, 5),
+		PTREG_OUT_A(regs, 0),
+		PTREG_OUT_A(regs, 1),
+		PTREG_OUT_A(regs, 2),
+		PTREG_OUT(regs, orig_d0, orig_d0),
+		PTREG_OUT(regs, stkadj, stkadj),
+#if 0
+/* Are these registers that must be saved? */
+		PTREG_OUT(regs, format, format),
+		PTREG_OUT(regs, vector, vector),
+#endif
+		PTREG_OUT(regs, sr, sr),
+		PTREG_OUT(regs, pc, pc)
+	:
+	:
+		"a0"
+	);
+
+	return regs;
+}
+
 /*
  * These are defined as per linux/ptrace.h.
  */
