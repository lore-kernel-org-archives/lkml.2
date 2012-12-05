Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2LERCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:02:13 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52782 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab2LERCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:02:12 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/1] metag: Switch to generic kernel_{thread,execve}
Date: Wed, 5 Dec 2012 17:01:39 +0000
Message-ID: <1354726899-19023-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_17_02_07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 2aa3a7f8660355c3dddead17e224545c1a3d5a5f
"preparation for generic kernel_thread()"
and commit a74fb73c12398b250fdc5e333a11e15a9e3a84fc
"infrastructure for saner ret_from_kernel_thread semantics"

introduced in v3.7-rc1, arches are advised to migrate to the new generic
implementation of the kernel_thread() and kernel_execve() functions. The
generic implementation of kernel_thread() does not fill the the pt_regs
anymore, but it passes the 'fn' and 'arg' arguments to do_fork() which
then blindly passes them to copy_thread(). As a result of which,
copy_thread() needs to check whether a kernel thread did a do_fork()
call, and if it did, it need to prepare the stack like the arch-specific
kernel_thread() used to do. Later on, when the kernel thread is
returning from the do_fork() call, it will execute fn(arg) which never
returns.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
This patch is based on v2 of the core metag patchset, which can be found
at git://github.com/jahogan/metag-linux.git, branch metag-core (tag
metag-core-v2).

 arch/metag/Kconfig            |    2 +
 arch/metag/kernel/process.c   |   77 ++++++++++++++++-------------------------
 arch/metag/kernel/sys_metag.c |   20 -----------
 arch/metag/kernel/traps.c     |    8 ++++
 4 files changed, 40 insertions(+), 67 deletions(-)

diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index 29787c8..d53606d 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -33,6 +33,8 @@ config METAG
 	select MODULES_USE_ELF_RELA
 	select OF
 	select OF_EARLY_FLATTREE
+	select GENERIC_KERNEL_EXECVE
+	select GENERIC_KERNEL_THREAD
 
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
diff --git a/arch/metag/kernel/process.c b/arch/metag/kernel/process.c
index 379b52e..8522750 100644
--- a/arch/metag/kernel/process.c
+++ b/arch/metag/kernel/process.c
@@ -154,73 +154,56 @@ void show_regs(struct pt_regs *regs)
 	show_trace(NULL, (unsigned long *)regs->ctx.AX[0].U0, regs);
 }
 
-extern void kernel_thread_helper(void);
-__asm__(".pushsection .text\n\t"
-	".type _kernel_thread_helper,function\n\t"
-	"_kernel_thread_helper:\n\t"
-	"SWAP    PC,D1RtP\n\t"
-	"MOV     D1Ar1,D0Re0\n\t"
-	"MOVT    D1RtP,#HI(_do_exit)\n\t"
-	"CALL    D1RtP,#LO(_do_exit)\n\t"
-	".size   _kernel_thread_helper,.-_kernel_thread_helper\n\t"
-	".popsection");
-
-/*
- * Create a kernel thread
- */
-int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
-{
-	struct pt_regs regs;
-	unsigned long global_base;
-
-	memset(&regs, 0, sizeof(regs));
-	regs.ctx.DX[3].U1 = (unsigned long)arg;
-	regs.ctx.DX[4].U1 = (unsigned long)fn;
-
-	asm volatile("MOV %0,A1GbP\n" : "=r" (global_base));
-	regs.ctx.AX[0].U1 = (unsigned long)global_base;
-
-	regs.ctx.CurrPC = (unsigned long)kernel_thread_helper;
-
-	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
-		       &regs, 0, NULL, NULL);
-}
-
 int copy_thread(unsigned long clone_flags, unsigned long usp,
-		unsigned long unused, struct task_struct *tsk,
+		unsigned long arg, struct task_struct *tsk,
 		struct pt_regs *regs)
 {
 	struct pt_regs *childregs = task_pt_regs(tsk);
 	void *kernel_context = ((void *) childregs +
 				sizeof(struct pt_regs));
+	unsigned long global_base;
 
 	BUG_ON(((unsigned long)childregs) & 0x7);
 	BUG_ON(((unsigned long)kernel_context) & 0x7);
 
-	/* Get a pointer to where the new child's register block should have
+	memset(&tsk->thread.kernel_context, 0,
+			sizeof(tsk->thread.kernel_context));
+
+	tsk->thread.kernel_context = __TBISwitchInit(kernel_context,
+						     ret_from_fork,
+						     0, 0);
+
+	/* generic kernel_thread() passes a NULL pointer for *regs */
+	if (unlikely(tsk->flags & PF_KTHREAD)) {
+		/*
+		 * Make sure we don't leak any kernel data to child's regs
+		 * if kernel thread becomes a userspace thread in the future
+		 */
+		memset(childregs, 0 , sizeof(struct pt_regs));
+
+		asm volatile("MOV %0,A1GbP\n" : "=r" (global_base));
+		childregs->ctx.AX[0].U1 = (unsigned long) global_base;
+		childregs->ctx.AX[0].U0 = (unsigned long) kernel_context;
+		/* Set D1Ar1=arg and D1RtP=usp (fn) */
+		childregs->ctx.DX[4].U1 = usp;
+		childregs->ctx.DX[3].U1 = arg;
+		tsk->thread.int_depth = 2;
+		return 0;
+	}
+	/*
+	 * Get a pointer to where the new child's register block should have
 	 * been pushed.
 	 * The Meta's stack grows upwards, and the context is the the first
 	 * thing to be pushed by TBX (phew)
 	 */
 	*childregs = *regs;
-
 	/* Set the correct stack for the clone mode */
-	if (user_mode(childregs)) {
-		childregs->ctx.AX[0].U0 = ALIGN(usp, 8);
-		tsk->thread.int_depth = 1;
-	} else {
-		childregs->ctx.AX[0].U0 = (unsigned long) kernel_context;
-		tsk->thread.int_depth = 2;
-	}
+	childregs->ctx.AX[0].U0 = ALIGN(usp, 8);
+	tsk->thread.int_depth = 1;
 
 	/* set return value for child process */
 	childregs->ctx.DX[0].U0 = 0;
 
-	tsk->thread.kernel_context = __TBISwitchInit(kernel_context,
-						     ret_from_fork,
-						     0, 0);
-
 	/* The TLS pointer is passed as an argument to sys_clone. */
 	if (clone_flags & CLONE_SETTLS)
 		tsk->thread.tls_ptr = (__force void __user *)regs->ctx.DX[1].U1;
diff --git a/arch/metag/kernel/sys_metag.c b/arch/metag/kernel/sys_metag.c
index 7d8f389..b21f1fe 100644
--- a/arch/metag/kernel/sys_metag.c
+++ b/arch/metag/kernel/sys_metag.c
@@ -74,26 +74,6 @@ out:
 	return ret;
 }
 
-/*
- * Do a system call from kernel instead of calling sys_execve so we
- * end up with proper pt_regs.
- */
-int kernel_execve(const char *filename, const char *const argv[],
-		  const char *const envp[])
-{
-	register long __call __asm__("D1Re0") = __NR_execve;
-	register long __res __asm__("D0Re0");
-	register long __a __asm__("D1Ar1") = (long)(filename);
-	register long __b __asm__("D0Ar2") = (long)(argv);
-	register long __c __asm__("D1Ar3") = (long)(envp);
-	__asm__ __volatile__("SWITCH	#%c1"
-			     : "=d" (__res)
-			     : "i" (__METAG_SW_SYS), "d" (__call),
-			       "d" (__a), "d" (__b), "d" (__c)
-			     : "memory");
-	return __res;
-}
-
 #define TXDEFR_FPU_MASK ((0x1f << 16) | 0x1f)
 
 asmlinkage void sys_metag_set_fpu_flags(unsigned int flags)
diff --git a/arch/metag/kernel/traps.c b/arch/metag/kernel/traps.c
index e476a4d..c3cff52 100644
--- a/arch/metag/kernel/traps.c
+++ b/arch/metag/kernel/traps.c
@@ -861,10 +861,18 @@ int ret_from_fork(TBIRES arg)
 	struct task_struct *prev = arg.Switch.pPara;
 	struct task_struct *tsk = current;
 	struct pt_regs *regs = task_pt_regs(tsk);
+	int (*fn)(void *);
 	TBIRES Next;
 
 	schedule_tail(prev);
 
+	if (tsk->flags & PF_KTHREAD) {
+		fn = (void *)regs->ctx.DX[4].U1;
+		BUG_ON(!fn);
+
+		fn((void *)regs->ctx.DX[3].U1);
+	}
+
 	if (test_syscall_work())
 		syscall_trace_leave(regs);
 
-- 
1.7.7.6


