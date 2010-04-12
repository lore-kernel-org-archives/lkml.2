Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0DLGFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:05:21 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:10732 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab0DLGEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:04:49 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHRUwkurR7Hu/2dsb2JhbACbM3GhRZgUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="113731090"
Date: Sun, 11 Apr 2010 23:04:49 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 22/23] Make register values available to x86 panic notifiers
Message-ID: <20100412060449.GA24950@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The save_ptregs() function compiles cleanly for 32-bit and 64-bit
configurations, but has not been tested for either.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 arch/x86/include/asm/ptrace.h |  115 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c       |    6 +-
 2 files changed, 118 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 9d369f6..9e2d3d2 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -306,6 +306,121 @@ extern void ptrace_bts_untrace(struct task_struct *tsk);
 #define arch_ptrace_untrace(tsk)	ptrace_bts_untrace(tsk)
 #endif /* CONFIG_X86_PTRACE_BTS */
 
+#include <linux/ptreg.h>
+#define arch_has_save_ptregs	1
+
+/**
+ * save_ptregs - save processor registers for backtracing
+ * @regs:	Pointer to &struct pt_regs structure in which to save the
+ *		registers
+ *
+ * Returns a constant pointer to @regs
+ */
+#ifdef __i386__
+#define PTREG_SAVE(r)	"	mov	%%" #r ", %[" #r "]\n"
+
+static __always_inline
+const struct pt_regs *save_ptregs(register struct pt_regs *regs)
+{
+	__asm__ __volatile__ (
+			PTREG_SAVE(bx)
+			PTREG_SAVE(cx)
+			PTREG_SAVE(dx)
+			PTREG_SAVE(si)
+			PTREG_SAVE(di)
+			PTREG_SAVE(bp)
+			PTREG_SAVE(ax)
+			PTREG_SAVE(ds)
+			PTREG_SAVE(es)
+			PTREG_SAVE(fs)
+			PTREG_SAVE(gs)
+			PTREG_SAVE(cs)
+			PTREG_SAVE(sp)
+			PTREG_SAVE(ss)
+		"	pushfl\n"
+		"	pop	%[flags]\n"
+		"1:\n"
+		"	movl	$1b, %[ip]\n"
+	:
+		PTREG_OUT(regs, bx, bx),
+		PTREG_OUT(regs, cx, cx),
+		PTREG_OUT(regs, dx, dx),
+		PTREG_OUT(regs, si, si),
+		PTREG_OUT(regs, di, di),
+		PTREG_OUT(regs, bp, bp),
+		PTREG_OUT(regs, ax, ax),
+		PTREG_OUT(regs, ds, ds),
+		PTREG_OUT(regs, es, es),
+		PTREG_OUT(regs, fs, fs),
+		PTREG_OUT(regs, gs, gs),
+		PTREG_OUT(regs, ip, ip),
+		PTREG_OUT(regs, cs, cs),
+		PTREG_OUT(regs, flags, flags),
+		PTREG_OUT(regs, sp, sp),
+		PTREG_OUT(regs, ss, ss)
+	:
+	);
+	return regs;
+}
+#else
+#define PTREG_SAVE(r, name)	"	movq	%%" #r ", %[" #name "]\n"
+#define PTREG_SAVE_R(i)		_PTREG_SAVE_I(r, r, i)
+
+#define PTREG_OUT_R(regs, i)	_PTREG_OUT_I(regs, r, r, i)
+
+static __always_inline
+const struct pt_regs *save_ptregs(struct pt_regs *regs)
+{
+	__asm__ __volatile__ (
+			PTREG_SAVE_R(15)
+			PTREG_SAVE_R(14)
+			PTREG_SAVE_R(13)
+			PTREG_SAVE_R(12)
+			PTREG_SAVE(rbp, bp)
+			PTREG_SAVE(rbx, bx)
+			PTREG_SAVE_R(11)
+			PTREG_SAVE_R(10)
+			PTREG_SAVE_R(9)
+			PTREG_SAVE_R(8)
+			PTREG_SAVE(rax, ax)
+			PTREG_SAVE(rcx, cx)
+			PTREG_SAVE(rdx, dx)
+			PTREG_SAVE(rsi, si)
+			PTREG_SAVE(rdi, di)
+			"mov	%%cs, %%ax\n"
+			PTREG_SAVE(rax, cs)
+			PTREG_SAVE(rsp, sp)
+			"mov	%%ss, %%ax\n"
+			PTREG_SAVE(rax, ss)
+		"	pushf\n"
+		"	popq	%[flags]\n"
+		"1:\n"
+		"	movq	$1b, %[ip]\n"
+	:
+		PTREG_OUT_R(regs, 15),
+		PTREG_OUT_R(regs, 14),
+		PTREG_OUT_R(regs, 13),
+		PTREG_OUT_R(regs, 12),
+		PTREG_OUT(regs, bp, bp),
+		PTREG_OUT(regs, bx, bx),
+		PTREG_OUT_R(regs, 11),
+		PTREG_OUT_R(regs, 10),
+		PTREG_OUT_R(regs, 9),
+		PTREG_OUT_R(regs, 8),
+		PTREG_OUT(regs, ax, ax),
+		PTREG_OUT(regs, cx, cx),
+		PTREG_OUT(regs, dx, dx),
+		PTREG_OUT(regs, si, si),
+		PTREG_OUT(regs, di, di),
+		PTREG_OUT(regs, ip, ip),
+		PTREG_OUT(regs, cs, cs),
+		PTREG_OUT(regs, flags, flags),
+		PTREG_OUT(regs, sp, sp),
+		PTREG_OUT(regs, ss, ss)
+	);
+	return regs;
+}
+#endif /* __i386 */
 #endif /* __KERNEL__ */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 3339917..5b6af80 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -326,7 +326,7 @@ mem_parity_error(unsigned char reason, struct pt_regs *regs)
 #endif
 
 	if (panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
+		panic_with_regs(regs, "NMI: Not continuing");
 
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 
@@ -344,7 +344,7 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	show_registers(regs);
 
 	if (panic_on_io_nmi)
-		panic("NMI IOCK error: Not continuing");
+		panic_with_regs(regs, "NMI IOCK error: Not continuing");
 
 	/* Re-enable the IOCK line, wait for a few seconds */
 	reason = (reason & 0xf) | 8;
@@ -380,7 +380,7 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 
 	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
 	if (panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
+		panic_with_regs(regs, "NMI: Not continuing");
 
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 }
