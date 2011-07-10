Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1GJDW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 23:22:27 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:48017 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755326Ab1GJDWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 23:22:23 -0400
X-AuditID: 12074425-b7bcaae000000a1b-a8-4e191ac6c507
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 1/8] x86-64: Improve vsyscall emulation CS and RIP handling
Date: Sat,  9 Jul 2011 23:22:08 -0400
Message-Id: <2215c119e580b40f243c37d284e7bced309d975f.1310267866.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310267866.git.luto@mit.edu>
References: <cover.1310267866.git.luto@mit.edu>
In-Reply-To: <cover.1310267866.git.luto@mit.edu>
References: <cover.1310267866.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42IR4hTV1j0mJeln0HHZ0qLvylF2i4uN21gs
	WtfOZ7e4vGsOm8WWS82sFj82PGZ1YPPofvSJ0eNW2x9mj52z7rJ7bFrVyeZx7lofs8fnTXIB
	bFFcNimpOZllqUX6dglcGRsO3GItaFKq2P7mNksD4wupLkZODgkBE4nZc3+yQthiEhfurWfr
	YuTiEBLYxyjRcH8uO4SznlFiz9+XzBDOUyaJNS9/soC0sAmoSHQsfcDUxcjBISIgJLH0bh1I
	DbPAJkaJX5smMoLUCAv4SWxfd4MJxGYRUJVoX9cKZvMKBEm8b3nFBLFaTuLI5edgNqeAgcTy
	u7PZQGwhAX2Jzk/72XGJT2AUWMDIsIpRNiW3Sjc3MTOnODVZtzg5MS8vtUjXQi83s0QvNaV0
	EyMoYNldVHcwTjikdIhRgINRiYc3oEzCT4g1say4MvcQoyQHk5IoLy8w3IX4kvJTKjMSizPi
	i0pzUosPMUpwMCuJ8NZsAirnTUmsrEotyodJSXOwKInzhnj/9xUSSE8sSc1OTS1ILYLJynBw
	KEnwioAMFSxKTU+tSMvMKUFIM3FwggznARrOCVLDW1yQmFucmQ6RP8VozLFp29wjjBynziw4
	wijEkpeflyolzisFUioAUppRmgc3DZZ0XjGKAz0nzMsFUsUDTFhw814BrWICWjX9OcgfxSWJ
	CCmpBkYJ1/IOhoZpAivMxHmmxH102lrp5aUiG79GrO+X+XydYyVGV81VV4rOrW29+aiQveL6
	1XvCl0vkGFx4fv88v51zd8C68oM28+9whaleFMtd253yks27fML03xsEXGT3PG/T1Mxdcy7f
	IrhC+vFLRunrqpPqktq3tkY+O+rk/07pf+mBKsH2HUosxRmJhlrMRcWJALERxcUVAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two fixes here:
 - Send SIGSEGV if called from compat code or with a funny CS.
 - Don't BUG on impossible addresses.

This patch also removes an unused variable.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/vsyscall.h |   12 --------
 arch/x86/kernel/vsyscall_64.c   |   59 +++++++++++++++++++++++++--------------
 2 files changed, 38 insertions(+), 33 deletions(-)

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
index 10cd8ac..6d14848 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -38,6 +38,7 @@
 
 #include <asm/vsyscall.h>
 #include <asm/pgtable.h>
+#include <asm/compat.h>
 #include <asm/page.h>
 #include <asm/unistd.h>
 #include <asm/fixmap.h>
@@ -97,33 +98,60 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 
 	tsk = current;
 
-	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+	printk("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
 	       level, tsk->comm, task_pid_nr(tsk),
-	       message, regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
+	       message, regs->ip - 2, regs->cs,
+	       regs->sp, regs->ax, regs->si, regs->di);
+}
+
+static int addr_to_vsyscall_nr(unsigned *vsyscall_nr, unsigned long addr)
+{
+	if ((addr & ~0xC00UL) != VSYSCALL_START)
+		return -EINVAL;
+
+	*vsyscall_nr = (addr & 0xC00UL) >> 10;
+	if (*vsyscall_nr >= 3)
+		return -EINVAL;
+
+	return 0;
 }
 
 void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 {
-	const char *vsyscall_name;
 	struct task_struct *tsk;
 	unsigned long caller;
-	int vsyscall_nr;
+	unsigned vsyscall_nr;
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
+	if (addr_to_vsyscall_nr(&vsyscall_nr, regs->ip - 2) != 0) {
+		warn_bad_vsyscall(KERN_WARNING, regs,
+				  "illegal int 0xcc (exploit attempt?)");
 		goto sigsegv;
 	}
-	vsyscall_nr = vsyscall_entry_nr(regs->ip - 2);
 
 	if (get_user(caller, (unsigned long __user *)regs->sp) != 0) {
 		warn_bad_vsyscall(KERN_WARNING, regs, "int 0xcc with bad stack (exploit attempt?)");
@@ -136,31 +164,20 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 
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
-- 
1.7.6

