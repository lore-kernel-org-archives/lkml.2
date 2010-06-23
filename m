Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0FWKHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:07:47 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47805 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab0FWKEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:35 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       David Howells <dhowells@redhat.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Kumar Gala <galak@kernel.crashing.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, David Gibson <dwg@au1.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Chase Douglas <cndougla@linux.vnet.ibm.com>
Subject: [PATCH 28/40] trace syscalls, PPC: Convert syscalls using regs to REGS_SYSCALL_DEFINE macros
Date: Wed, 23 Jun 2010 20:03:09 +1000
Message-Id: <1277287401-28571-29-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch coverts a number of system calls on PowerPC to use the new
PPC_REGS_SYSCALL_DEFINE class of macros, to record their metadata but
still use the correct syntax to access the registers through the 7th
parameter.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/syscalls.h |   10 ++++++----
 arch/powerpc/kernel/process.c       |   27 +++++++++++----------------
 arch/powerpc/kernel/signal.c        |    7 ++++---
 arch/powerpc/kernel/signal_32.c     |   11 +++++------
 arch/powerpc/kernel/signal_64.c     |   11 ++++-------
 arch/powerpc/kernel/sys_ppc32.c     |   11 ++++++-----
 6 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/arch/powerpc/include/asm/syscalls.h b/arch/powerpc/include/asm/syscalls.h
index 72badaa..531b45d 100644
--- a/arch/powerpc/include/asm/syscalls.h
+++ b/arch/powerpc/include/asm/syscalls.h
@@ -71,12 +71,14 @@ asmlinkage unsigned long sys_mmap(unsigned long addr, size_t len,
 asmlinkage unsigned long sys_mmap2(unsigned long addr, size_t len,
 		unsigned long prot, unsigned long flags,
 		unsigned long fd, unsigned long pgoff);
-asmlinkage int sys_execve(unsigned long a0, unsigned long a1,
-		unsigned long a2, unsigned long a3, unsigned long a4,
-		unsigned long a5, struct pt_regs *regs);
+asmlinkage int sys_execve(char __user * ufilename,
+		char __user * __user * argv,
+		char __user * __user * envp,
+		unsigned long, unsigned long, unsigned long,
+		struct pt_regs *regs);
 asmlinkage int sys_clone(unsigned long clone_flags, unsigned long usp,
 		int __user *parent_tidp, void __user *child_threadptr,
-		int __user *child_tidp, int p6, struct pt_regs *regs);
+		int __user *child_tidp, unsigned long p6, struct pt_regs *regs);
 asmlinkage int sys_fork(unsigned long p1, unsigned long p2,
 		unsigned long p3, unsigned long p4, unsigned long p5,
 		unsigned long p6, struct pt_regs *regs);
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 9b41ece..df08d05 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -950,10 +950,9 @@ int get_unalign_ctl(struct task_struct *tsk, unsigned long adr)
 
 #define TRUNC_PTR(x)	((typeof(x))(((unsigned long)(x)) & 0xffffffff))
 
-int sys_clone(unsigned long clone_flags, unsigned long usp,
-	      int __user *parent_tidp, void __user *child_threadptr,
-	      int __user *child_tidp, int p6,
-	      struct pt_regs *regs)
+PPC_REGS_SYSCALL_DEFINE5_RET(int, clone, regs, unsigned long, clone_flags, unsigned long, usp,
+	      int __user *, parent_tidp, void __user *, child_threadptr,
+	      int __user *, child_tidp)
 {
 	CHECK_FULL_REGS(regs);
 	if (usp == 0)
@@ -967,39 +966,35 @@ int sys_clone(unsigned long clone_flags, unsigned long usp,
  	return do_fork(clone_flags, usp, regs, 0, parent_tidp, child_tidp);
 }
 
-int sys_fork(unsigned long p1, unsigned long p2, unsigned long p3,
-	     unsigned long p4, unsigned long p5, unsigned long p6,
-	     struct pt_regs *regs)
+PPC_REGS_SYSCALL_DEFINE0_RET(int, fork, regs)
 {
 	CHECK_FULL_REGS(regs);
 	return do_fork(SIGCHLD, regs->gpr[1], regs, 0, NULL, NULL);
 }
 
-int sys_vfork(unsigned long p1, unsigned long p2, unsigned long p3,
-	      unsigned long p4, unsigned long p5, unsigned long p6,
-	      struct pt_regs *regs)
+PPC_REGS_SYSCALL_DEFINE0_RET(int, vfork, regs)
 {
 	CHECK_FULL_REGS(regs);
 	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->gpr[1],
 			regs, 0, NULL, NULL);
 }
 
-int sys_execve(unsigned long a0, unsigned long a1, unsigned long a2,
-	       unsigned long a3, unsigned long a4, unsigned long a5,
-	       struct pt_regs *regs)
+PPC_REGS_SYSCALL_DEFINE3_RET(int, execve, regs,
+		char __user *, ufilename,
+		char __user * __user *, argv,
+		char __user * __user *, envp)
 {
 	int error;
 	char *filename;
 
-	filename = getname((char __user *) a0);
+	filename = getname(ufilename);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
 	flush_fp_to_thread(current);
 	flush_altivec_to_thread(current);
 	flush_spe_to_thread(current);
-	error = do_execve(filename, (char __user * __user *) a1,
-			  (char __user * __user *) a2, regs);
+	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
 out:
 	return error;
diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index a0afb55..8ebc83b 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -13,6 +13,7 @@
 #include <linux/signal.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
+#include <asm/syscalls.h>
 
 #include "signal.h"
 
@@ -197,9 +198,9 @@ void do_signal(struct pt_regs *regs, unsigned long thread_info_flags)
 	}
 }
 
-long sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
-		unsigned long r5, unsigned long r6, unsigned long r7,
-		unsigned long r8, struct pt_regs *regs)
+PPC_REGS_SYSCALL_DEFINE2_RET(long, sigaltstack, regs,
+		const stack_t __user *, uss,
+		stack_t __user *, uoss)
 {
 	return do_sigaltstack(uss, uoss, regs->gpr[1]);
 }
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index e65d311..212583d 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -784,8 +784,8 @@ COMPAT_SYSCALL_DEFINE3(rt_sigqueueinfo, u32, pid, u32, sig,
  *       sigaltatck               compat_sys_sigaltstack
  */
 
-int compat_sys_sigaltstack(u32 __new, u32 __old, int r5,
-		      int r6, int r7, int r8, struct pt_regs *regs)
+PPC_REGS_COMPAT_SYSCALL_DEFINE2_RET(int, sigaltstack, regs,
+		u32, __new, u32, __old)
 {
 	stack_32_t __user * newstack = compat_ptr(__new);
 	stack_32_t __user * oldstack = compat_ptr(__old);
@@ -1076,10 +1076,9 @@ long sys_rt_sigreturn(int r3, int r4, int r5, int r6, int r7, int r8,
 }
 
 #ifdef CONFIG_PPC32
-int sys_debug_setcontext(struct ucontext __user *ctx,
-			 int ndbg, struct sig_dbg_op __user *dbg,
-			 int r6, int r7, int r8,
-			 struct pt_regs *regs)
+PPC_REGS_SYSCALL_DEFINE3_RET(int, debug_setcontext, regs,
+		struct ucontext __user *, ctx, int, ndbg,
+		struct sig_dbg_op __user *, dbg)
 {
 	struct sig_dbg_op op;
 	int i;
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index 2fe6fc6..a44781a 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -276,9 +276,9 @@ static long setup_trampoline(unsigned int syscall, unsigned int __user *tramp)
 /*
  * Handle {get,set,swap}_context operations
  */
-int sys_swapcontext(struct ucontext __user *old_ctx,
-		    struct ucontext __user *new_ctx,
-		    long ctx_size, long r6, long r7, long r8, struct pt_regs *regs)
+PPC_REGS_SYSCALL_DEFINE3_RET(int, swapcontext, regs,
+		struct ucontext __user *, old_ctx,
+		struct ucontext __user *, new_ctx, long, ctx_size)
 {
 	unsigned char tmp;
 	sigset_t set;
@@ -347,10 +347,7 @@ int sys_swapcontext(struct ucontext __user *old_ctx,
 /*
  * Do a signal return; undo the signal stack.
  */
-
-int sys_rt_sigreturn(unsigned long r3, unsigned long r4, unsigned long r5,
-		     unsigned long r6, unsigned long r7, unsigned long r8,
-		     struct pt_regs *regs)
+PPC_REGS_SYSCALL_DEFINE0_RET(int, rt_sigreturn, regs)
 {
 	struct ucontext __user *uc = (struct ucontext __user *)regs->gpr[1];
 	sigset_t set;
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 6fc8ba9..27cf460 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -189,21 +189,22 @@ asmlinkage int compat_sys_sendfile64(int out_fd, int in_fd, compat_loff_t __user
 	return ret;
 }
 
-long compat_sys_execve(unsigned long a0, unsigned long a1, unsigned long a2,
-		  unsigned long a3, unsigned long a4, unsigned long a5,
-		  struct pt_regs *regs)
+PPC_REGS_COMPAT_SYSCALL_DEFINE3_RET(long, execve, regs,
+		char __user *, ufilename,
+		unsigned long, argv,
+		unsigned long, envp)
 {
 	int error;
 	char * filename;
 	
-	filename = getname((char __user *) a0);
+	filename = getname(ufilename);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
 	flush_fp_to_thread(current);
 	flush_altivec_to_thread(current);
 
-	error = compat_do_execve(filename, compat_ptr(a1), compat_ptr(a2), regs);
+	error = compat_do_execve(filename, compat_ptr(argv), compat_ptr(envp), regs);
 
 	putname(filename);
 
-- 
1.7.1

