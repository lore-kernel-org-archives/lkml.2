Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1G0DVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:21:23 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:61005 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832Ab1G0DVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:21:04 -0400
X-AuditID: 12074423-b7cb3ae000000a19-66-4e2f841b4046
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 5/5] x86-64: Add user_64bit_mode paravirt op
Date: Tue, 26 Jul 2011 23:20:39 -0400
Message-Id: <4f4f2b2fdd92eff234f833125732b82a039203e2.1311736366.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1311736366.git.luto@mit.edu>
References: <cover.1311736366.git.luto@mit.edu>
In-Reply-To: <cover.1311736366.git.luto@mit.edu>
References: <cover.1311736366.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42IR4hTV1pVu0fczaG2Ss+i7cpTd4tG8R6wW
	U5fNZbVYtvgpo8XlXXPYLJafncdm8WPDY1aLe1PesztweOycdZfdY/PF1Uwem1Z1snlMvrGc
	0WN73y52j49Pb7F4fN4kF8AexWWTkpqTWZZapG+XwJVx6t9P1oLz+hXta2+zNDCuV+ti5OSQ
	EDCR2LrgFDOELSZx4d56ti5GLg4hgX2MErNfbGKHcDYwSqw/uo8VwnnGJDGvYxETSAubgIpE
	x9IHYLaIgJNE64SPTCBFzALPGCU2HT0DNldYwEZi0rkZYEUsAqoSm763g9m8AkESF1/eY4PY
	LSdx5PJzsDingIHE3o2tYL1CAvoS677cZcYlPoFRYAEjwypG2ZTcKt3cxMyc4tRk3eLkxLy8
	1CJdM73czBK91JTSTYyggGZ3Ud7B+Oeg0iFGAQ5GJR7ejZH6fkKsiWXFlbmHGCU5mJREeTOa
	gUJ8SfkplRmJxRnxRaU5qcWHGCU4mJVEeHf81/MT4k1JrKxKLcqHSUlzsCiJ8+Z6//cVEkhP
	LEnNTk0tSC2CycpwcChJ8IaBDBUsSk1PrUjLzClBSDNxcIIM5wEa7g1Sw1tckJhbnJkOkT/F
	qCglzpsNkhAASWSU5sH1whLOK0ZxoFeEeUNAqniAyQqu+xXQYCaQq3XABpckIqSkGhhl5jr9
	ybuYcObnVpl7uk5OE49JBal0Rpjcd7+75kjrVd2lJ0KuLdLjvD1LVze+T71z/ck52xf58+z+
	8+VzqDefrGTGdacczoygIOmWDxPvhAUvPxVb6+LAebDrdb7CUZPr/xXlzn7LNqp9c33G9smV
	T4or1i5bKLV6hvNhPe6XPudvHa/5I/5YiaU4I9FQi7moOBEAydLq3xMDAAA=
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
 arch/x86/xen/enlighten.c              |    1 +
 8 files changed, 35 insertions(+), 9 deletions(-)

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
index 974a528..a9c710a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -950,6 +950,7 @@ static unsigned xen_patch(u8 type, u16 clobbers, void *insnbuf,
 static const struct pv_info xen_info __initconst = {
 	.paravirt_enabled = 1,
 	.shared_kernel_pmd = 0,
+	.extra_user_64bit_cs = FLAT_USER_CS64,
 
 	.name = "Xen",
 };
-- 
1.7.6

