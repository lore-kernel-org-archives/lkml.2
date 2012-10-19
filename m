Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab2JSIpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:45:24 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:47223 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757153Ab2JSIpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:45:22 -0400
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/2] unicore32: switch to generic kernel_thread()/kernel_execve()
Date: Fri, 19 Oct 2012 16:43:09 +0800
Message-Id: <1350636190-6303-1-git-send-email-gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-and-Tested-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig                 |    2 +
 arch/unicore32/include/asm/processor.h |    5 ---
 arch/unicore32/kernel/entry.S          |   15 ++++----
 arch/unicore32/kernel/process.c        |   58 ++++++++------------------------
 arch/unicore32/kernel/sys.c            |   42 -----------------------
 5 files changed, 23 insertions(+), 99 deletions(-)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 5b95ba4..fda37c9 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -16,6 +16,8 @@ config UNICORE32
 	select ARCH_WANT_FRAME_POINTERS
 	select GENERIC_IOMAP
 	select MODULES_USE_ELF_REL
+	select GENERIC_KERNEL_THREAD
+	select GENERIC_KERNEL_EXECVE
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
 	  including a series of low-power-consumption RISC chip
diff --git a/arch/unicore32/include/asm/processor.h b/arch/unicore32/include/asm/processor.h
index 14382cb..4eaa421 100644
--- a/arch/unicore32/include/asm/processor.h
+++ b/arch/unicore32/include/asm/processor.h
@@ -72,11 +72,6 @@ unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()			barrier()
 
-/*
- * Create a new kernel thread
- */
-extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
-
 #define task_pt_regs(p) \
 	((struct pt_regs *)(THREAD_START_SP + task_stack_page(p)) - 1)
 
diff --git a/arch/unicore32/kernel/entry.S b/arch/unicore32/kernel/entry.S
index dcb87ab..32648c9 100644
--- a/arch/unicore32/kernel/entry.S
+++ b/arch/unicore32/kernel/entry.S
@@ -573,17 +573,16 @@ ENDPROC(ret_to_user)
  */
 ENTRY(ret_from_fork)
 	b.l	schedule_tail
-	get_thread_info tsk
-	ldw	r1, [tsk+], #TI_FLAGS		@ check for syscall tracing
-	mov	why, #1
-	cand.a	r1, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
-	beq	ret_slow_syscall
-	mov	r1, sp
-	mov	r0, #1				@ trace exit [IP = 1]
-	b.l	syscall_trace
 	b	ret_slow_syscall
 ENDPROC(ret_from_fork)
 
+ENTRY(ret_from_kernel_thread)
+	b.l	schedule_tail
+	mov	r0, r5
+	adr	lr, ret_slow_syscall
+	mov	pc, r4
+ENDPROC(ret_from_kernel_thread)
+
 /*=============================================================================
  * SWI handler
  *-----------------------------------------------------------------------------
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index b008586..a8fe265 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -258,6 +258,7 @@ void release_thread(struct task_struct *dead_task)
 }
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
+asmlinkage void ret_from_kernel_thread(void) __asm__("ret_from_kernel_thread");
 
 int
 copy_thread(unsigned long clone_flags, unsigned long stack_start,
@@ -266,17 +267,22 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	struct thread_info *thread = task_thread_info(p);
 	struct pt_regs *childregs = task_pt_regs(p);
 
-	*childregs = *regs;
-	childregs->UCreg_00 = 0;
-	childregs->UCreg_sp = stack_start;
-
 	memset(&thread->cpu_context, 0, sizeof(struct cpu_context_save));
 	thread->cpu_context.sp = (unsigned long)childregs;
-	thread->cpu_context.pc = (unsigned long)ret_from_fork;
-
-	if (clone_flags & CLONE_SETTLS)
-		childregs->UCreg_16 = regs->UCreg_03;
+	if (unlikely(!regs)) {
+		thread->cpu_context.pc = (unsigned long)ret_from_kernel_thread;
+		thread->cpu_context.r4 = stack_start;
+		thread->cpu_context.r5 = stk_sz;
+		memset(childregs, 0, sizeof(struct pt_regs));
+	} else {
+		thread->cpu_context.pc = (unsigned long)ret_from_fork;
+		*childregs = *regs;
+		childregs->UCreg_00 = 0;
+		childregs->UCreg_sp = stack_start;
 
+		if (clone_flags & CLONE_SETTLS)
+			childregs->UCreg_16 = regs->UCreg_03;
+	}
 	return 0;
 }
 
@@ -305,42 +311,6 @@ int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fp)
 }
 EXPORT_SYMBOL(dump_fpu);
 
-/*
- * Shuffle the argument into the correct register before calling the
- * thread function.  r1 is the thread argument, r2 is the pointer to
- * the thread function, and r3 points to the exit function.
- */
-asm(".pushsection .text\n"
-"	.align\n"
-"	.type	kernel_thread_helper, #function\n"
-"kernel_thread_helper:\n"
-"	mov.a	asr, r7\n"
-"	mov	r0, r4\n"
-"	mov	lr, r6\n"
-"	mov	pc, r5\n"
-"	.size	kernel_thread_helper, . - kernel_thread_helper\n"
-"	.popsection");
-
-/*
- * Create a kernel thread.
- */
-pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
-{
-	struct pt_regs regs;
-
-	memset(&regs, 0, sizeof(regs));
-
-	regs.UCreg_04 = (unsigned long)arg;
-	regs.UCreg_05 = (unsigned long)fn;
-	regs.UCreg_06 = (unsigned long)do_exit;
-	regs.UCreg_07 = PRIV_MODE;
-	regs.UCreg_pc = (unsigned long)kernel_thread_helper;
-	regs.UCreg_asr = regs.UCreg_07 | PSR_I_BIT;
-
-	return do_fork(flags|CLONE_VM|CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
-}
-EXPORT_SYMBOL(kernel_thread);
-
 unsigned long get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
diff --git a/arch/unicore32/kernel/sys.c b/arch/unicore32/kernel/sys.c
index fabdee9..8b6e4cc 100644
--- a/arch/unicore32/kernel/sys.c
+++ b/arch/unicore32/kernel/sys.c
@@ -63,48 +63,6 @@ out:
 	return error;
 }
 
-int kernel_execve(const char *filename,
-		  const char *const argv[],
-		  const char *const envp[])
-{
-	struct pt_regs regs;
-	int ret;
-
-	memset(&regs, 0, sizeof(struct pt_regs));
-	ret = do_execve(filename,
-			(const char __user *const __user *)argv,
-			(const char __user *const __user *)envp, &regs);
-	if (ret < 0)
-		goto out;
-
-	/*
-	 * Save argc to the register structure for userspace.
-	 */
-	regs.UCreg_00 = ret;
-
-	/*
-	 * We were successful.  We won't be returning to our caller, but
-	 * instead to user space by manipulating the kernel stack.
-	 */
-	asm("add	r0, %0, %1\n\t"
-		"mov	r1, %2\n\t"
-		"mov	r2, %3\n\t"
-		"mov	r22, #0\n\t"	/* not a syscall */
-		"mov	r23, %0\n\t"	/* thread structure */
-		"b.l	memmove\n\t"	/* copy regs to top of stack */
-		"mov	sp, r0\n\t"	/* reposition stack pointer */
-		"b	ret_to_user"
-		:
-		: "r" (current_thread_info()),
-		  "Ir" (THREAD_START_SP - sizeof(regs)),
-		  "r" (&regs),
-		  "Ir" (sizeof(regs))
-		: "r0", "r1", "r2", "r3", "ip", "lr", "memory");
-
- out:
-	return ret;
-}
-
 /* Note: used by the compat code even in 64-bit Linux. */
 SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags,
-- 
1.7.0.4

