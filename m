Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab1FFRak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:30:40 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:52541 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618Ab1FFRaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:30:35 -0400
X-AuditID: 1209190f-b7c4dae0000007bd-88-4ded0e317d7a
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: pageexec@freemail.hu, Mikael Pettersson <mikpe@it.uu.se>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 2/3] x86-64: Clean up vsyscall emulation and remove fixed-address ret
Date: Mon,  6 Jun 2011 13:27:24 -0400
Message-Id: <bd468a0e02befab146667fab5de57df7332d54d9.1307380481.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307380481.git.luto@mit.edu>
References: <cover.1307380481.git.luto@mit.edu>
In-Reply-To: <cover.1307380481.git.luto@mit.edu>
References: <cover.1307380481.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42IR4hTV1t3N99bX4HezhUXflaPsFtM2iltc
	3jWHzeJJ83VGiy2XmlktHq95zmzxqO8tu8WPDY9ZHTg8brX9YfZY0vGD3WPnrLvsHv9fHmHz
	2LSqk83jxIzfLB6fN8l5nGj5whrAEcVlk5Kak1mWWqRvl8CV8WrSBvaCRouKE9sWsjYwbtXp
	YuTkkBAwkXg1fSk7hC0mceHeerYuRi4OIYF9jBL3d79khHDWM0o031zHBOEcYpJomHqXGaSF
	TUBFomPpAyYQW0RAX+L32UVgHcwCzxklXnw4ATSLg0NYIFTi8uQ6EJNFQFVi/h9GkHJegSCJ
	7/2fmUDCEgIKEudX5YOEOQUMJKbengVWIgQ08fy+yay4xCcwCixgZFjFKJuSW6Wbm5iZU5ya
	rFucnJiXl1qka6KXm1mil5pSuokRHNKS/DsYvx1UOsQowMGoxMP7+ssbXyHWxLLiytxDjJIc
	TEqivH953/oK8SXlp1RmJBZnxBeV5qQWH2KU4GBWEuGNfwNUzpuSWFmVWpQPk5LmYFES550l
	qe4rJJCeWJKanZpakFoEk5Xh4FCS4OUCxq6QYFFqempFWmZOCUKaiYMTZDgP0PB5HEA1vMUF
	ibnFmekQ+VOMuhxbT7w9yCjEkpeflyolzrsa5DoBkKKM0jy4ObBU9IpRHOgtYV4LkHU8wDQG
	N+kV0BImoCXHnV6BLClJREhJNTDaWapeK6+8nd6joaceyn122ZtVe09zRb7lrZ8bI71ht4Jg
	2zfu9bt5pH2uBy6ZKT6n6uOK1fdSb3hdvXDdwVYtUmzKpZKMmPvl/0qK7+18Ls/eoPlt3vm1
	jsa3lWfq/b6kJvS55/hU73MCHRP9T/8TnrI++CvXjrOKZ9T/f3TqK7bqqV8cXb5FiaU4I9FQ
	i7moOBEA16HBwyADAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the fixed-address ret in the vsyscall emulation stubs.  As a
result, int 0xcc no longer works if executed from user address space
(which is OK -- nothing sensible should do that).

Removing support for int 0xcc in user address space cleans up the
code considerably.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/vsyscall.h   |   10 ++++-
 arch/x86/kernel/vsyscall_64.c     |   78 +++++++++++--------------------------
 arch/x86/kernel/vsyscall_emu_64.S |   17 +--------
 3 files changed, 32 insertions(+), 73 deletions(-)

diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index 293ae08..bb710cb 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -32,9 +32,15 @@ extern struct timezone sys_tz;
 extern void map_vsyscall(void);
 
 /* Emulation */
-static inline bool in_vsyscall_page(unsigned long addr)
+
+static inline bool is_vsyscall_entry(unsigned long addr)
+{
+	return (addr & ~0xC00UL) == VSYSCALL_START;
+}
+
+static inline int vsyscall_entry_nr(unsigned long addr)
 {
-	return (addr & ~(PAGE_SIZE - 1)) == VSYSCALL_START;
+	return (addr & 0xC00UL) >> 10;
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 0b50b3c..04540f7 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -96,25 +96,10 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 
 	tsk = current;
 
-	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx",
+	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
 	       level, tsk->comm, task_pid_nr(tsk),
 	       message,
 	       regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
-	if (!in_vsyscall_page(regs->ip - 2))
-		print_vma_addr(" in ", regs->ip - 2);
-	printk("\n");
-}
-
-/* al values for each vsyscall; see vsyscall_emu_64.S for why. */
-static u8 vsyscall_nr_to_al[] = {0xcc, 0xce, 0xf0};
-
-static int al_to_vsyscall_nr(u8 al)
-{
-	int i;
-	for (i = 0; i < ARRAY_SIZE(vsyscall_nr_to_al); i++)
-		if (vsyscall_nr_to_al[i] == al)
-			return i;
-	return -1;
 }
 
 #ifdef CONFIG_COMPAT_VSYSCALLS
@@ -141,17 +126,12 @@ vtime(time_t *t)
 
 #endif /* CONFIG_COMPAT_VSYSCALLS */
 
-/* If CONFIG_COMPAT_VSYSCALLS=y, then this is incorrect for vsyscall_nr == 1. */
-static inline unsigned long vsyscall_intcc_addr(int vsyscall_nr)
-{
-	return VSYSCALL_START + 1024*vsyscall_nr + 2;
-}
-
 void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 {
 	static DEFINE_RATELIMIT_STATE(rs, 3600 * HZ, 3);
 	struct task_struct *tsk;
 	const char *vsyscall_name;
+	unsigned long caller;
 	int vsyscall_nr;
 	long ret;
 
@@ -160,39 +140,26 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 
 	local_irq_enable();
 
-	vsyscall_nr = al_to_vsyscall_nr(regs->ax & 0xff);
-	if (vsyscall_nr < 0) {
+	/*
+	 * x86-ism here: regs->ip points to the instruction after the int 0xcc,
+	 * and int 0xcc is two bytes long.
+	 */
+	if (!is_vsyscall_entry(regs->ip - 2)) {
 		warn_bad_vsyscall(KERN_WARNING, regs, "illegal int 0xcc "
 				  "(exploit attempt?)");
 		goto sigsegv;
 	}
+	vsyscall_nr = vsyscall_entry_nr(regs->ip - 2);
 
-	if (regs->ip - 2 != vsyscall_intcc_addr(vsyscall_nr)) {
-		if (in_vsyscall_page(regs->ip - 2)) {
-			/* This should not be possible. */
-			warn_bad_vsyscall(KERN_WARNING, regs,
-					  "int 0xcc bogus magic "
-					  "(exploit attempt?)");
-			goto sigsegv;
-		} else {
-			/*
-			 * We allow the call because tools like ThreadSpotter
-			 * might copy the int 0xcc instruction to user memory.
-			 * We make it annoying, though, to try to persuade
-			 * the authors to stop doing that...
-			 */
-			warn_bad_vsyscall(KERN_WARNING, regs,
-					  "int 0xcc in user code "
-					  "(exploit attempt? legacy "
-					  "instrumented code?)");
-		}
+	if (get_user(caller, (unsigned long __user *)regs->sp) != 0) {
+		warn_bad_vsyscall(KERN_WARNING, regs, "int 0xcc with bad stack "
+				  "(exploit attempt?)");
+		goto sigsegv;
 	}
 
 	tsk = current;
-	if (seccomp_mode(&tsk->seccomp)) {
+	if (seccomp_mode(&tsk->seccomp))
 		do_exit(SIGKILL);
-		goto out;
-	}
 
 	switch (vsyscall_nr) {
 	case 0:
@@ -202,12 +169,8 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 			(struct timezone __user *)regs->si);
 		break;
 
+#ifndef CONFIG_COMPAT_VSYSCALLS
 	case 1:
-#ifdef CONFIG_COMPAT_VSYSCALLS
-		warn_bad_vsyscall(KERN_WARNING, regs, "bogus time() vsyscall "
-				  "emulation (exploit attempt?)");
-		goto sigsegv;
-#else
 		vsyscall_name = "time";
 		ret = sys_time((time_t __user *)regs->di);
 		break;
@@ -221,6 +184,11 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 		break;
 
 	default:
+		/*
+		 * If we get here, then vsyscall_nr indicates that int 0xcc
+		 * happened at an address in the vsyscall page that doesn't
+		 * contain int 0xcc.  That can't happen.
+		 */
 		BUG();
 	}
 
@@ -240,9 +208,6 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 	regs->ax = ret;
 
 	if (__ratelimit(&rs)) {
-		unsigned long caller;
-		if (get_user(caller, (unsigned long __user *)regs->sp))
-			caller = 0;  /* no need to crash on this fault. */
 		printk(KERN_INFO "%s[%d] emulated legacy vsyscall %s(); "
 		       "upgrade your code to avoid a performance hit. "
 		       "ip:%lx sp:%lx caller:%lx",
@@ -253,7 +218,10 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 		printk("\n");
 	}
 
-out:
+	/* Emulate a ret instruction. */
+	regs->ip = caller;
+	regs->sp += 8;
+
 	local_irq_disable();
 	return;
 
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
index 2d53e26..5658d42 100644
--- a/arch/x86/kernel/vsyscall_emu_64.S
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -7,36 +7,21 @@
 #include <linux/linkage.h>
 #include <asm/irq_vectors.h>
 
-/*
- * These magic incantations are chosen so that they fault if entered anywhere
- * other than an instruction boundary.  The movb instruction is two bytes, and
- * the int imm8 instruction is also two bytes, so the only misaligned places
- * to enter are the immediate values for the two instructions.  0xcc is int3
- * (always faults), 0xce is into (faults on x64-64, and 32-bit code can't get
- * here), and 0xf0 is lock (lock int is invalid).
- *
- * The unused parts of the page are filled with 0xcc by the linker script.
- */
+/* The unused parts of the page are filled with 0xcc by the linker script. */
 
 .section .vsyscall_0, "a"
 ENTRY(vsyscall_0)
-	movb $0xcc, %al
 	int $VSYSCALL_EMU_VECTOR
-	ret
 END(vsyscall_0)
 
 #ifndef CONFIG_COMPAT_VSYSCALLS
 .section .vsyscall_1, "a"
 ENTRY(vsyscall_1)
-	movb $0xce, %al
 	int $VSYSCALL_EMU_VECTOR
-	ret
 END(vsyscall_1)
 #endif
 
 .section .vsyscall_2, "a"
 ENTRY(vsyscall_2)
-	movb $0xf0, %al
 	int $VSYSCALL_EMU_VECTOR
-	ret
 END(vsyscall_2)
-- 
1.7.5.2

