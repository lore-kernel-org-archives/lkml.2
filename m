Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab2KGJ7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:59:33 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:52765 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab2KGJ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:59:27 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 30/31] ARC: switch to generic kernel_execve() and sys_execve()
Date: Wed,  7 Nov 2012 10:47:53 +0100
Message-Id: <1352281674-2186-31-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/ptrace.h |    8 +++++++
 arch/arc/include/asm/unistd.h |    2 +
 arch/arc/kernel/entry.S       |   17 ++++++++-------
 arch/arc/kernel/process.c     |   44 -----------------------------------------
 arch/arc/kernel/sys.c         |    1 -
 5 files changed, 19 insertions(+), 53 deletions(-)

diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index ee31d8a..bc2229f 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -120,6 +120,14 @@ struct user_regs_struct {
 #define in_syscall(regs) (((regs->orig_r8) >= 0 && \
 			   (regs->orig_r8 <= NR_syscalls)) ? 1 : 0)
 
+#define current_pt_regs()					\
+({								\
+	/* open-coded current_thread_info() */			\
+	register unsigned long sp asm ("sp");			\
+	unsigned long pg_start = (sp & ~(THREAD_SIZE - 1));	\
+	(struct pt_regs *)(pg_start + THREAD_SIZE - 4) - 1;	\
+})
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __ASM_PTRACE_H */
diff --git a/arch/arc/include/asm/unistd.h b/arch/arc/include/asm/unistd.h
index 754d588..09144a8 100644
--- a/arch/arc/include/asm/unistd.h
+++ b/arch/arc/include/asm/unistd.h
@@ -22,6 +22,8 @@
 #define __ARCH_WANT_SYSCALL_NO_FLAGS
 #define __ARCH_WANT_SYSCALL_OFF_T
 #define __ARCH_WANT_SYSCALL_DEPRECATED
+#define __ARCH_WANT_KERNEL_EXECVE
+#define __ARCH_WANT_SYS_EXECVE
 
 #define sys_mmap2 sys_mmap_pgoff
 
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 46d0280..deb2652 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -588,15 +588,16 @@ ARC_ENTRY ret_from_kernel_thread
 	j   @sys_exit
 ARC_EXIT ret_from_kernel_thread
 
-;################### Special Sys Call Wrappers ##########################
-
-ARC_ENTRY sys_execve_wrapper
-	; copy pointer to pt_regs as a parameter
-	mov  r3, sp
-	bl  @sys_execve
+; When we land here, pt_regs have already been updated in-place correctly
+; A pointer to them is also passed by kernel_execve, we just need to make sure
+; that SP is set to point to them.
+ARC_ENTRY ret_from_kernel_execve
+	; Force SP to "normal" pt_regs just populated.
+	b.d   ret_from_system_call
+	mov   sp, r0
+ARC_EXIT ret_from_kernel_execve
 
-	b ret_from_system_call
-ARC_EXIT sys_execve_wrapper
+;################### Special Sys Call Wrappers ##########################
 
 ; TBD: call do_fork directly from here
 ARC_ENTRY sys_fork_wrapper
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
index d2bb27f..65dfa89 100644
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -53,50 +53,6 @@ asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
 		       child_tidptr);
 }
 
-int sys_execve(const char __user *filenamei, const char __user *__user *argv,
-	       const char __user *__user *envp, struct pt_regs *regs)
-{
-	long error;
-	struct filename *filename;
-
-	filename = getname(filenamei);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		goto out;
-
-	error = do_execve(filename->name, argv, envp, regs);
-	putname(filename);
-out:
-	return error;
-}
-
-int kernel_execve(const char *filename, const char *const argv[],
-		  const char *const envp[])
-{
-	/*
-	 * Although the arguments (order, number) to this function are
-	 * same as sys call, we don't need to setup args in regs again.
-	 * However in case mainline kernel changes the order of args to
-	 * kernel_execve, that assumtion will break.
-	 * So to be safe, let gcc know the args for sys call.
-	 * If they match no extra code will be generated
-	 */
-	register int arg2 asm("r1") = (int)argv;
-	register int arg3 asm("r2") = (int)envp;
-
-	register int filenm_n_ret asm("r0") = (int)filename;
-
-	__asm__ __volatile__(
-		"mov   r8, %1	\n\t"
-		"trap0		\n\t"
-		: "+r"(filenm_n_ret)
-		: "i"(__NR_execve), "r"(arg2), "r"(arg3)
-		: "r8", "memory");
-
-	return filenm_n_ret;
-}
-EXPORT_SYMBOL(kernel_execve);
-
 SYSCALL_DEFINE1(arc_settls, void *, user_tls_data_ptr)
 {
 	task_thread_info(current)->thr_ptr = (unsigned int)user_tls_data_ptr;
diff --git a/arch/arc/kernel/sys.c b/arch/arc/kernel/sys.c
index 4c30345..f6bdd07 100644
--- a/arch/arc/kernel/sys.c
+++ b/arch/arc/kernel/sys.c
@@ -5,7 +5,6 @@
 
 #include <asm/syscalls.h>
 
-#define sys_execve	sys_execve_wrapper
 #define sys_clone	sys_clone_wrapper
 #define sys_fork	sys_fork_wrapper
 #define sys_vfork	sys_vfork_wrapper
-- 
1.7.4.1

