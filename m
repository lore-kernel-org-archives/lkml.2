Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1HCNc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:32:59 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:51690 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860Ab1HCNcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:32:20 -0400
X-AuditID: 12074425-b7b15ae000000f71-37-4e394db5e074
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 5/6] x86-64: Add user_64bit_mode paravirt op
Date: Wed,  3 Aug 2011 09:31:53 -0400
Message-Id: <f4fcb3947340d9e96ce1054a432f183f9da9db83.1312378163.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsUixG6norvN19LP4NpNJou+K0fZLR7Ne8Rq
	MXXZXFaLZYufMlpc3jWHzWL52XlsFj82PGa1uDflPbsDh8fOWXfZPTZfXM3ksWlVJ5vH5BvL
	GT229+1i9/j49BaLx+dNcgHsUVw2Kak5mWWpRfp2CVwZJ3etZy/Yrl9xZMJVxgbG6WpdjJwc
	EgImErs79rJB2GISF+6tB7K5OIQE9jFK7D0xC8pZzyjxf+4zZgjnKZPE2uvPmUBa2ARUJDqW
	PgCzRQScJFonfGQCKWIWeMYosenoGaAODg5hAXuJxr8mIDUsAqoS++48ZQMJ8woESaw/pA6x
	WU7iyGWIkZwCBhKrFjxnASkREtCXeLAmH4fwBEaBBYwMqxhlU3KrdHMTM3OKU5N1i5MT8/JS
	i3Qt9HIzS/RSU0o3MYID2UV1B+OEQ0qHGAU4GJV4eBnlLfyEWBPLiitzDzFKcjApifIu97L0
	E+JLyk+pzEgszogvKs1JLT7EKMHBrCTC284LlONNSaysSi3Kh0lJc7AoifOGeP/3FRJITyxJ
	zU5NLUgtgsnKcHAoSfB6ASNWSLAoNT21Ii0zpwQhzcTBCTKcB2i4DUgNb3FBYm5xZjpE/hSj
	opQ4ryFIQgAkkVGaB9cLSzSvGMWBXhHmtQWp4gEmKbjuV0CDmYAG/39vATK4JBEhJdXAGHhI
	UMXWWdF/03auM4W6maHz7j3RrJ9ulci+xOykoS6zdk/Jno/bGfMyVqexLcryuZkhV3Dh1het
	vUI9h/mebNaZdMpga8wdZbn8wF75DYdbJ5eazLVRqLOQU5+UUfbW4O8L1f4JFd9unS6K00pM
	XbSgSsa8cfO+f3dVTL0zj1snrt7/TqdJiaU4I9FQi7moOBEAqpMXbQ8DAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three places in the kernel assume that the only long mode CPL 3
selector is __USER_CS.  This is not true on Xen -- Xen's sysretq
changes cs to the magic value 0xe033.

Two of the places are corner cases, but as of "x86-64: Improve
vsyscall emulation CS and RIP handling"
(c9712944b2a12373cb6ff8059afcfb7e826a6c54), vsyscalls will segfault
if called with Xen's extra CS selector.  This causes a panic when
older init builds die.

It seems impossible to make Xen use __USER_CS reliably without
taking a performance hit on every system call, so this fixes the
tests instead with a new paravirt op.  It's a little ugly because
ptrace.h can't include paravirt.h.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/desc.h           |    4 ++--
 arch/x86/include/asm/paravirt_types.h |    6 ++++++
 arch/x86/include/asm/ptrace.h         |   19 +++++++++++++++++++
 arch/x86/kernel/paravirt.c            |    4 ++++
 arch/x86/kernel/step.c                |    2 +-
 arch/x86/kernel/vsyscall_64.c         |    6 +-----
 arch/x86/mm/fault.c                   |    2 +-
 arch/x86/xen/enlighten.c              |    4 ++++
 8 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 7b439d9..41935fa 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -27,8 +27,8 @@ static inline void fill_ldt(struct desc_struct *desc, const struct user_desc *in
 
 	desc->base2		= (info->base_addr & 0xff000000) >> 24;
 	/*
-	 * Don't allow setting of the lm bit. It is useless anyway
-	 * because 64bit system calls require __USER_CS:
+	 * Don't allow setting of the lm bit. It would confuse
+	 * user_64bit_mode and would get overridden by sysret anyway.
 	 */
 	desc->l			= 0;
 }
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 2c76521..8e8b9a4 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -41,6 +41,7 @@
 
 #include <asm/desc_defs.h>
 #include <asm/kmap_types.h>
+#include <asm/pgtable_types.h>
 
 struct page;
 struct thread_struct;
@@ -63,6 +64,11 @@ struct paravirt_callee_save {
 struct pv_info {
 	unsigned int kernel_rpl;
 	int shared_kernel_pmd;
+
+#ifdef CONFIG_X86_64
+	u16 extra_user_64bit_cs;  /* __USER_CS if none */
+#endif
+
 	int paravirt_enabled;
 	const char *name;
 };
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 94e7618..3566454 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -131,6 +131,9 @@ struct pt_regs {
 #ifdef __KERNEL__
 
 #include <linux/init.h>
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt_types.h>
+#endif
 
 struct cpuinfo_x86;
 struct task_struct;
@@ -187,6 +190,22 @@ static inline int v8086_mode(struct pt_regs *regs)
 #endif
 }
 
+#ifdef CONFIG_X86_64
+static inline bool user_64bit_mode(struct pt_regs *regs)
+{
+#ifndef CONFIG_PARAVIRT
+	/*
+	 * On non-paravirt systems, this is the only long mode CPL 3
+	 * selector.  We do not allow long mode selectors in the LDT.
+	 */
+	return regs->cs == __USER_CS;
+#else
+	/* Headers are too twisted for this to go in paravirt.h. */
+	return regs->cs == __USER_CS || regs->cs == pv_info.extra_user_64bit_cs;
+#endif
+}
+#endif
+
 /*
  * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
  * when it traps.  The previous stack will be directly underneath the saved
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 613a793..d90272e 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -307,6 +307,10 @@ struct pv_info pv_info = {
 	.paravirt_enabled = 0,
 	.kernel_rpl = 0,
 	.shared_kernel_pmd = 1,	/* Only used when CONFIG_X86_PAE is set */
+
+#ifdef CONFIG_X86_64
+	.extra_user_64bit_cs = __USER_CS,
+#endif
 };
 
 struct pv_init_ops pv_init_ops = {
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 7977f0c..c346d11 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -74,7 +74,7 @@ static int is_setting_trap_flag(struct task_struct *child, struct pt_regs *regs)
 
 #ifdef CONFIG_X86_64
 		case 0x40 ... 0x4f:
-			if (regs->cs != __USER_CS)
+			if (!user_64bit_mode(regs))
 				/* 32-bit mode: register increment */
 				return 0;
 			/* 64-bit mode: REX prefix */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index dda7dff..1725930 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -127,11 +127,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 
 	local_irq_enable();
 
-	/*
-	 * Real 64-bit user mode code has cs == __USER_CS.  Anything else
-	 * is bogus.
-	 */
-	if (regs->cs != __USER_CS) {
+	if (!user_64bit_mode(regs)) {
 		/*
 		 * If we trapped from kernel mode, we might as well OOPS now
 		 * instead of returning to some random address and OOPSing
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 4d09df0..decd51a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -105,7 +105,7 @@ check_prefetch_opcode(struct pt_regs *regs, unsigned char *instr,
 		 * but for now it's good enough to assume that long
 		 * mode only uses well known segments or kernel.
 		 */
-		return (!user_mode(regs)) || (regs->cs == __USER_CS);
+		return (!user_mode(regs) || user_64bit_mode(regs));
 #endif
 	case 0x60:
 		/* 0x64 thru 0x67 are valid prefixes in all modes. */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 974a528..e2345af 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -951,6 +951,10 @@ static const struct pv_info xen_info __initconst = {
 	.paravirt_enabled = 1,
 	.shared_kernel_pmd = 0,
 
+#ifdef CONFIG_X86_64
+	.extra_user_64bit_cs = FLAT_USER_CS64,
+#endif
+
 	.name = "Xen",
 };
 
-- 
1.7.6

