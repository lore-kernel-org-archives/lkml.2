Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1GMNY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:24:28 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:65181 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633Ab1GMNYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:24:25 -0400
X-AuditID: 1209190c-b7c65ae00000117c-61-4e1d9c911759
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 1/8] x86-64: Improve vsyscall emulation CS and RIP handling
Date: Wed, 13 Jul 2011 09:24:09 -0400
Message-Id: <6fb2b13ab39b743d1e4f466eef13425854912f7f.1310563276.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310563276.git.luto@mit.edu>
References: <cover.1310563276.git.luto@mit.edu>
In-Reply-To: <cover.1310563276.git.luto@mit.edu>
References: <cover.1310563276.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsUixCmqrDtxjqyfwc05XBZ9V46yW1xs3MZi
	0bp2PrvF5V1z2Cy2XGpmtdh04jejxY8Nj1kd2D26H31i9LjV9ofZY+esu+wem1Z1snmcu9bH
	7PF5k1wAWxSXTUpqTmZZapG+XQJXxsSToQX/lCsOL53M3sC4XKaLkZNDQsBEYtq6ZywQtpjE
	hXvr2boYuTiEBPYxSjy98YAVwtnAKNF/+iAzhPOMSaL1wU92kBY2ARWJjqUPmLoYOThEBIQk
	lt6tAwkzCzxhlJiwVx/EFhbwkzi6aB/YBhYBVYnpM16CtfIKBEm8aJzIBrFZTuLI5edMIDan
	gIHEnAU3wGqEBPQlnnccZsYlPoFRYAEjwypG2ZTcKt3cxMyc4tRk3eLkxLy81CJdQ73czBK9
	1JTSTYzgsJXk2cH45qDSIUYBDkYlHl7ZeBk/IdbEsuLK3EOMkhxMSqK8qrNl/YT4kvJTKjMS
	izPii0pzUosPMUpwMCuJ8NY3AOV4UxIrq1KL8mFS0hwsSuK85d7/fYUE0hNLUrNTUwtSi2Cy
	MhwcShK84sD4FBIsSk1PrUjLzClBSDNxcIIM5wEaLgxSw1tckJhbnJkOkT/FqMtx6syCI4xC
	LHn5ealS4ryfQa4TACnKKM2DmwNLN68YxYHeEub9B1LFA0xVcJNeAS1hAlqyzgpsSUkiQkqq
	gbH99mOFzdOrHhSVCcw8ctpe2kHkhdecR3pdszsMjzfZ7pGuCqlZfOm+fEx7vO2XoJNcd3dP
	kwwPlA6xbb3o8e+P/KyDvJLMT9jq3eMZYpK//p3kE7Zpgekpq/WazBOn11xdLfxp/bOQDqsf
	sm48LcmnTs24dk5ppdZirZXP1Z7XKbVIeSsrXVJiKc5INNRiLipOBAA5oJxzEgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three fixes here:
 - Send SIGSEGV if called from compat code or with a funny CS.
 - Don't BUG on impossible addresses.
 - Add a missing local_irq_disable.

This patch also removes an unused variable.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/vsyscall.h |   12 -------
 arch/x86/kernel/vsyscall_64.c   |   61 ++++++++++++++++++++++++++-------------
 2 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index bb710cb..d555973 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -31,18 +31,6 @@ extern struct timezone sys_tz;
 
 extern void map_vsyscall(void);
 
-/* Emulation */
-
-static inline bool is_vsyscall_entry(unsigned long addr)
-{
-	return (addr & ~0xC00UL) == VSYSCALL_START;
-}
-
-static inline int vsyscall_entry_nr(unsigned long addr)
-{
-	return (addr & 0xC00UL) >> 10;
-}
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 10cd8ac..a262400 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -38,6 +38,7 @@
 
 #include <asm/vsyscall.h>
 #include <asm/pgtable.h>
+#include <asm/compat.h>
 #include <asm/page.h>
 #include <asm/unistd.h>
 #include <asm/fixmap.h>
@@ -97,33 +98,63 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 
 	tsk = current;
 
-	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+	printk("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
 	       level, tsk->comm, task_pid_nr(tsk),
-	       message, regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
+	       message, regs->ip - 2, regs->cs,
+	       regs->sp, regs->ax, regs->si, regs->di);
+}
+
+static int addr_to_vsyscall_nr(unsigned long addr)
+{
+	int nr;
+
+	if ((addr & ~0xC00UL) != VSYSCALL_START)
+		return -EINVAL;
+
+	nr = (addr & 0xC00UL) >> 10;
+	if (nr >= 3)
+		return -EINVAL;
+
+	return nr;
 }
 
 void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 {
-	const char *vsyscall_name;
 	struct task_struct *tsk;
 	unsigned long caller;
 	int vsyscall_nr;
 	long ret;
 
-	/* Kernel code must never get here. */
-	BUG_ON(!user_mode(regs));
-
 	local_irq_enable();
 
 	/*
+	 * Real 64-bit user mode code has cs == __USER_CS.  Anything else
+	 * is bogus.
+	 */
+	if (regs->cs != __USER_CS) {
+		/*
+		 * If we trapped from kernel mode, we might as well OOPS now
+		 * instead of returning to some random address and OOPSing
+		 * then.
+		 */
+		BUG_ON(!user_mode(regs));
+
+		/* Compat mode and non-compat 32-bit CS should both segfault. */
+		warn_bad_vsyscall(KERN_WARNING, regs,
+				  "illegal int 0xcc from 32-bit mode");
+		goto sigsegv;
+	}
+
+	/*
 	 * x86-ism here: regs->ip points to the instruction after the int 0xcc,
 	 * and int 0xcc is two bytes long.
 	 */
-	if (!is_vsyscall_entry(regs->ip - 2)) {
-		warn_bad_vsyscall(KERN_WARNING, regs, "illegal int 0xcc (exploit attempt?)");
+	vsyscall_nr = addr_to_vsyscall_nr(regs->ip - 2);
+	if (vsyscall_nr < 0) {
+		warn_bad_vsyscall(KERN_WARNING, regs,
+				  "illegal int 0xcc (exploit attempt?)");
 		goto sigsegv;
 	}
-	vsyscall_nr = vsyscall_entry_nr(regs->ip - 2);
 
 	if (get_user(caller, (unsigned long __user *)regs->sp) != 0) {
 		warn_bad_vsyscall(KERN_WARNING, regs, "int 0xcc with bad stack (exploit attempt?)");
@@ -136,31 +167,20 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 
 	switch (vsyscall_nr) {
 	case 0:
-		vsyscall_name = "gettimeofday";
 		ret = sys_gettimeofday(
 			(struct timeval __user *)regs->di,
 			(struct timezone __user *)regs->si);
 		break;
 
 	case 1:
-		vsyscall_name = "time";
 		ret = sys_time((time_t __user *)regs->di);
 		break;
 
 	case 2:
-		vsyscall_name = "getcpu";
 		ret = sys_getcpu((unsigned __user *)regs->di,
 				 (unsigned __user *)regs->si,
 				 0);
 		break;
-
-	default:
-		/*
-		 * If we get here, then vsyscall_nr indicates that int 0xcc
-		 * happened at an address in the vsyscall page that doesn't
-		 * contain int 0xcc.  That can't happen.
-		 */
-		BUG();
 	}
 
 	if (ret == -EFAULT) {
@@ -188,6 +208,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 sigsegv:
 	regs->ip -= 2;  /* The faulting instruction should be the int 0xcc. */
 	force_sig(SIGSEGV, current);
+	local_irq_disable();
 }
 
 /*
-- 
1.7.6

