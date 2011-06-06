Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1FFVlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:41:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:55146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226Ab1FFVlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:41:12 -0400
Date: Mon, 6 Jun 2011 21:40:36 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-7dc0452808b75615d1dc4d5160b26aaabc6a7300@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, torvalds@linux-foundation.org, mikpe@it.uu.se,
        tglx@linutronix.de, mingo@elte.hu, luto@mit.edu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, torvalds@linux-foundation.org, mikpe@it.uu.se,
        tglx@linutronix.de, mingo@elte.hu, luto@mit.edu
In-Reply-To: <bd468a0e02befab146667fab5de57df7332d54d9.1307380481.git.luto@mit.edu>
References: <bd468a0e02befab146667fab5de57df7332d54d9.1307380481.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Clean up vsyscall emulation and remove fixed-address ret
Git-Commit-ID: 7dc0452808b75615d1dc4d5160b26aaabc6a7300
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 21:40:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7dc0452808b75615d1dc4d5160b26aaabc6a7300
Gitweb:     http://git.kernel.org/tip/7dc0452808b75615d1dc4d5160b26aaabc6a7300
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Mon, 6 Jun 2011 13:27:24 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Jun 2011 19:47:20 +0200

x86-64: Clean up vsyscall emulation and remove fixed-address ret

Remove the fixed-address ret in the vsyscall emulation stubs.
As a result, int 0xcc no longer works if executed from user
address space (which is OK -- nothing sensible should do that).

Removing support for int 0xcc in user address space cleans up
the code considerably.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: pageexec@freemail.hu
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/bd468a0e02befab146667fab5de57df7332d54d9.1307380481.git.luto@mit.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
