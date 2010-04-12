Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0DLGKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:10:37 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:11236 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab0DLGGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:06:31 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKlVwkurR7Hu/2dsb2JhbACbM3GhN5gUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="113731857"
Date: Sun, 11 Apr 2010 23:06:25 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux-arch@vger.kernel.org"@cisco.com,
       linux-arch@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 6/23] Make register values available to CRIS panic notifiers
Message-ID: <20100412060625.GA25426@dvomlehn-lnx2.corp.sa.net>
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
 arch/cris/include/arch-v10/arch/ptrace.h |   80 ++++++++++++++++++++++++++++
 arch/cris/include/arch-v32/arch/ptrace.h |   84 ++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+), 0 deletions(-)

diff --git a/arch/cris/include/arch-v10/arch/ptrace.h b/arch/cris/include/arch-v10/arch/ptrace.h
index 2f464ea..28be57c 100644
--- a/arch/cris/include/arch-v10/arch/ptrace.h
+++ b/arch/cris/include/arch-v10/arch/ptrace.h
@@ -114,6 +114,86 @@ struct switch_stack {
 #define profile_pc(regs) instruction_pointer(regs)
 extern void show_regs(struct pt_regs *);
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include "/home/vomlehn/git/kernel.org/ptreg.h"
+#define PTREG_SAVE(r, name)	"move.d	$" #r ", %[" #r "]\n"
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
+			PTREG_SAVE(frametype)
+			PTREG_SAVE(orig_r10)
+			PTREGS_SAVE_R(13)
+			PTREGS_SAVE_R(12)
+			PTREGS_SAVE_R(11)
+			PTREGS_SAVE_R(10)
+			PTREGS_SAVE_R(9)
+			PTREGS_SAVE_R(8)
+			PTREGS_SAVE_R(7)
+			PTREGS_SAVE_R(6)
+			PTREGS_SAVE_R(5)
+			PTREGS_SAVE_R(4)
+			PTREGS_SAVE_R(3)
+			PTREGS_SAVE_R(2)
+			PTREGS_SAVE_R(1)
+			PTREGS_SAVE_R(0)
+			PTREG_SAVE(mof)
+			PTREG_SAVE(dccr)
+			PTREG_SAVE(srp)
+			PTREG_SAVE(irp)
+			PTREG_SAVE(csrinstr)
+			PTREG_SAVE(csraddr)
+			PTREG_SAVE(csrdata)
+		"1:\n"
+			"move.d	1b, r0\n"
+			PTREG_SAVE(r0, irp)
+	:
+		PTREG_OUT(regs, frametype, frametype),
+		PTREG_OUT(regs, orig_r10, orig_r10),
+		PTREG_OUT_I(regs, 13),
+		PTREG_OUT_I(regs, 12),
+		PTREG_OUT_I(regs, 11),
+		PTREG_OUT_I(regs, 10),
+		PTREG_OUT_I(regs, 9),
+		PTREG_OUT_I(regs, 8),
+		PTREG_OUT_I(regs, 7),
+		PTREG_OUT_I(regs, 6),
+		PTREG_OUT_I(regs, 5),
+		PTREG_OUT_I(regs, 4),
+		PTREG_OUT_I(regs, 3),
+		PTREG_OUT_I(regs, 2),
+		PTREG_OUT_I(regs, 1),
+		PTREG_OUT_I(regs, 0),
+		PTREG_OUT(regs, mof, mof),
+		PTREG_OUT(regs, dccr, dccr),
+		PTREG_OUT(regs, srp, srp),
+		PTREG_OUT(regs, irp, irp),
+		PTREG_OUT(regs, csrinstr, csrinstr),
+		PTREG_OUT(regs, csraddr, csraddr),
+		PTREG_OUT(regs, csrdata, csrdata)
+	:
+		"r0"
+	);
+
+	return regs;
+}
 #endif  /*  __KERNEL__  */
 
 #endif
diff --git a/arch/cris/include/arch-v32/arch/ptrace.h b/arch/cris/include/arch-v32/arch/ptrace.h
index ffca8d0..90ad6b1 100644
--- a/arch/cris/include/arch-v32/arch/ptrace.h
+++ b/arch/cris/include/arch-v32/arch/ptrace.h
@@ -114,6 +114,90 @@ struct switch_stack {
 extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) instruction_pointer(regs)
 
+/* Macros for saving the contents of registers and for the output constraint
+ * for those registers */
+#include "/home/vomlehn/git/kernel.org/ptreg.h"
+#define PTREG_SAVE(r, name)	"move.d	$" #r ", %[" #r "]\n"
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
+			PTREG_SAVE(frametype)
+			PTREG_SAVE(orig_r10)
+			PTREGS_SAVE_R(13)
+			PTREGS_SAVE_R(12)
+			PTREGS_SAVE_R(11)
+			PTREGS_SAVE_R(10)
+			PTREGS_SAVE_R(9)
+			PTREGS_SAVE_R(8)
+			PTREGS_SAVE_R(7)
+			PTREGS_SAVE_R(6)
+			PTREGS_SAVE_R(5)
+			PTREGS_SAVE_R(4)
+			PTREGS_SAVE_R(3)
+			PTREGS_SAVE_R(2)
+			PTREGS_SAVE_R(1)
+			PTREGS_SAVE_R(0)
+			PTREG_SAVE(acr)
+			PTREG_SAVE(srs)
+			PTREG_SAVE(mof)
+			PTREG_SAVE(spc)
+			PTREG_SAVE(ccs)
+			PTREG_SAVE(srp)
+			PTREG_SAVE(erp)
+			PTREG_SAVE(exs)
+			PTREG_SAVE(eda)
+		"1:\n"
+			"move.d	1b, r0\n"
+			PTREG_SAVE(r0, irp)
+	:
+		PTREG_OUT(regs, frametype, frametype),
+		PTREG_OUT(regs, orig_r10, orig_r10),
+		PTREG_OUT_I(regs, 0),
+		PTREG_OUT_I(regs, 1),
+		PTREG_OUT_I(regs, 2),
+		PTREG_OUT_I(regs, 3),
+		PTREG_OUT_I(regs, 4),
+		PTREG_OUT_I(regs, 5),
+		PTREG_OUT_I(regs, 6),
+		PTREG_OUT_I(regs, 7),
+		PTREG_OUT_I(regs, 8),
+		PTREG_OUT_I(regs, 9),
+		PTREG_OUT_I(regs, 10),
+		PTREG_OUT_I(regs, 11),
+		PTREG_OUT_I(regs, 12),
+		PTREG_OUT_I(regs, 13),
+		PTREG_OUT(regs, acr, acr),
+		PTREG_OUT(regs, srs, srs),
+		PTREG_OUT(regs, mof, mof),
+		PTREG_OUT(regs, spc, spc),
+		PTREG_OUT(regs, ccs, ccs),
+		PTREG_OUT(regs, srp, srp),
+		PTREG_OUT(regs, erp, erp),
+		PTREG_OUT(regs, exs, exs),
+		PTREG_OUT(regs, eda, eda)
+	:
+		"r0"
+	);
+
+	return regs;
+}
 #endif  /*  __KERNEL__  */
 
 #endif
