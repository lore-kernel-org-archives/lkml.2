Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1GOEWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 00:22:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:59294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab1GOEWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 00:22:41 -0400
Date: Fri, 15 Jul 2011 04:22:24 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-c9712944b2a12373cb6ff8059afcfb7e826a6c54@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <6fb2b13ab39b743d1e4f466eef13425854912f7f.1310563276.git.luto@mit.edu>
References: <6fb2b13ab39b743d1e4f466eef13425854912f7f.1310563276.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Improve vsyscall emulation CS and RIP handling
Git-Commit-ID: c9712944b2a12373cb6ff8059afcfb7e826a6c54
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jul 2011 04:22:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9712944b2a12373cb6ff8059afcfb7e826a6c54
Gitweb:     http://git.kernel.org/tip/c9712944b2a12373cb6ff8059afcfb7e826a6c54
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Wed, 13 Jul 2011 09:24:09 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Jul 2011 11:22:55 -0700

x86-64: Improve vsyscall emulation CS and RIP handling

Three fixes here:
 - Send SIGSEGV if called from compat code or with a funny CS.
 - Don't BUG on impossible addresses.
 - Add a missing local_irq_disable.

This patch also removes an unused variable.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/6fb2b13ab39b743d1e4f466eef13425854912f7f.1310563276.git.luto@mit.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
