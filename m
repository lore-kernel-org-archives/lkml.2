Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab1HEFjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 01:39:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:45440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab1HEFjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 01:39:15 -0400
Date: Fri, 5 Aug 2011 05:39:07 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-318f5a2a672152328c9fb4dead504b89ec738a43@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, luto@mit.edu, tglx@linutronix.de,
        hpa@linux.intel.com, luto@mit.edu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, konrad.wilk@oracle.com, tglx@linutronix.de,
        hpa@linux.intel.com, luto@mit.edu
In-Reply-To: <f4fcb3947340d9e96ce1054a432f183f9da9db83.1312378163.git.luto@mit.edu>
References: <f4fcb3947340d9e96ce1054a432f183f9da9db83.1312378163.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Add user_64bit_mode paravirt op
Git-Commit-ID: 318f5a2a672152328c9fb4dead504b89ec738a43
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Aug 2011 05:39:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  318f5a2a672152328c9fb4dead504b89ec738a43
Gitweb:     http://git.kernel.org/tip/318f5a2a672152328c9fb4dead504b89ec738a43
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Wed, 3 Aug 2011 09:31:53 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 4 Aug 2011 16:13:49 -0700

x86-64: Add user_64bit_mode paravirt op

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
Link: http://lkml.kernel.org/r/f4fcb3947340d9e96ce1054a432f183f9da9db83.1312378163.git.luto@mit.edu
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index 8288509..96a0f80 100644
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
index 869e1ae..681f159 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -299,6 +299,10 @@ struct pv_info pv_info = {
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
index 2dbf6bf..c1d0182 100644
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
index 5525163..78fe33d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -937,6 +937,10 @@ static const struct pv_info xen_info __initconst = {
 	.paravirt_enabled = 1,
 	.shared_kernel_pmd = 0,
 
+#ifdef CONFIG_X86_64
+	.extra_user_64bit_cs = FLAT_USER_CS64,
+#endif
+
 	.name = "Xen",
 };
 
