Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2IJPvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:51:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45067 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757547Ab2IJPvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:51:15 -0400
Date: Mon, 10 Sep 2012 16:50:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 17/31] arm64: System calls handling
Message-ID: <20120910155033.GF27042@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <201209101351.52902.arnd@arndb.de>
 <20120910140148.GD27042@arm.com>
 <201209101424.21344.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209101424.21344.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 03:24:21PM +0100, Arnd Bergmann wrote:
> On Monday 10 September 2012, Catalin Marinas wrote:
> > 
> > On Mon, Sep 10, 2012 at 02:51:52PM +0100, Arnd Bergmann wrote:
> > > On Monday 10 September 2012, Catalin Marinas wrote:
> > > > Yes, I've seen these but since Al's patches are not in mainline, I don't
> > > > want to add additional dependencies to the arm64 patches (currently
> > > > based on 3.6-rc4). Once they get into mainline, I'll add a patch that
> > > > converts arm64 to the generic functions above.
> > > > 
> > > > For kernel_execve(), I think I can simplify it further and not rely on
> > > > Al's patches (similar to other architectures doing an SVC from kernel):
> > > 
> > > Hmm, I thought one of the reasons for Al to do his series was to discourage
> > > people from doing syscalls from kernel space, but I may be misremembering
> > > things. Al?
> > 
> > If that was the aim, I'm happy to change the code similar to the
> > arch/arm one. But as I said I would wait until Al's patches get into
> > mainline.
> 
> Ok. Another point: I wouldn't be too worried about dependencies for new
> code, because it's not possible to bisect through your series anyway
> (one needs all the patches before anything starts working really),
> so from my point of view you could also write your code in a way that
> expects Al's patches to get merged first.

It's not about bisectability but rather a way to test the branch that I
publish. On its own, my branch wouldn't even compile. Anyway, here's the
update (tested on a local branch with Al's execve2 branch merged):


arm64: Switch to generic sys_execve/kernel_execve

This patch converts the arm64 port to use the generic sys_execve and
kernel_execve() functions. It introduces the ret_from_kernel_execve()
function for starting the new user context and removes the
(compat_)sys_execve_wrapper() functions.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/arch/arm64/include/asm/syscalls.h b/arch/arm64/include/asm/syscalls.h
index 09ff335..81680a0 100644
--- a/arch/arm64/include/asm/syscalls.h
+++ b/arch/arm64/include/asm/syscalls.h
@@ -23,9 +23,6 @@
 /*
  * System call wrappers implemented in kernel/entry.S.
  */
-asmlinkage long sys_execve_wrapper(const char __user *filename,
-				   const char __user *const __user *argv,
-				   const char __user *const __user *envp);
 asmlinkage long sys_clone_wrapper(unsigned long clone_flags,
 				  unsigned long newsp,
 				  void __user *parent_tid,
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index fe18a68..948cfb1 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -24,4 +24,7 @@
 #include <asm/unistd32.h>
 #endif
 
+#define __ARCH_WANT_SYS_EXECVE
+#define __ARCH_WANT_KERNEL_EXECVE
+
 #endif /* __ASM_UNISTD_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 38cf853..5e0b28c 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -592,7 +592,7 @@ work_resched:
 /*
  * "slow" syscall return path.
  */
-ENTRY(ret_to_user)
+ret_to_user:
 	disable_irq				// disable interrupts
 	ldr	x1, [tsk, #TI_FLAGS]
 	and	x2, x1, #_TIF_WORK_MASK
@@ -614,6 +614,22 @@ ENTRY(ret_from_fork)
 ENDPROC(ret_from_fork)
 
 /*
+ * ret_from_kernel_execve(struct pt_regs *normal, struct pt_regs *new)
+ *
+ * Turn a kernel thread into a user process.
+ */
+ENTRY(ret_from_kernel_execve)
+	str	xzr, [x1, #S_X0]		// returning 0
+	mov	x2, #-1
+	str	x2, [x1, #S_SYSCALLNO]		// not a syscall
+	mov	x2, #S_FRAME_SIZE
+	bl	memmove				// copy regs to the normal location
+	get_thread_info tsk
+	mov	sp, x0				// normal pt_regs
+	b	ret_to_user
+ENDPROC(ret_from_kernel_execve)
+
+/*
  * SVC handler.
  */
 	.align	6
@@ -671,11 +687,6 @@ __sys_trace_return:
 /*
  * Special system call wrappers.
  */
-ENTRY(sys_execve_wrapper)
-	mov	x3, sp
-	b	sys_execve
-ENDPROC(sys_execve_wrapper)
-
 ENTRY(sys_clone_wrapper)
 	mov	x5, sp
 	b	sys_clone
diff --git a/arch/arm64/kernel/sys.c b/arch/arm64/kernel/sys.c
index 905fcfb..9c77c0b 100644
--- a/arch/arm64/kernel/sys.c
+++ b/arch/arm64/kernel/sys.c
@@ -41,70 +41,6 @@ asmlinkage long sys_clone(unsigned long clone_flags, unsigned long newsp,
 	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
 }
 
-/*
- * sys_execve() executes a new program.
- */
-asmlinkage long sys_execve(const char __user *filenamei,
-			   const char __user *const __user *argv,
-			   const char __user *const __user *envp,
-			   struct pt_regs *regs)
-{
-	long error;
-	char * filename;
-
-	filename = getname(filenamei);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		goto out;
-	error = do_execve(filename, argv, envp, regs);
-	putname(filename);
-out:
-	return error;
-}
-
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
-	regs.regs[0] = ret;
-
-	/*
-	 * We were successful.  We won't be returning to our caller, but
-	 * instead to user space by manipulating the kernel stack.
-	 */
-	asm(	"add	x0, %0, %1\n\t"
-		"mov	x1, %2\n\t"
-		"mov	x2, %3\n\t"
-		"bl	memmove\n\t"	/* copy regs to top of stack */
-		"mov	x27, #0\n\t"	/* not a syscall */
-		"mov	x28, %0\n\t"	/* thread structure */
-		"mov	sp, x0\n\t"	/* reposition stack pointer */
-		"b	ret_to_user"
-		:
-		: "r" (current_thread_info()),
-		  "Ir" (THREAD_START_SP - sizeof(regs)),
-		  "r" (&regs),
-		  "Ir" (sizeof(regs))
-		: "x0", "x1", "x2", "x27", "x28", "x30", "memory");
-
- out:
-	return ret;
-}
-EXPORT_SYMBOL(kernel_execve);
-
 asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
 			 unsigned long prot, unsigned long flags,
 			 unsigned long fd, off_t off)
@@ -118,7 +54,6 @@ asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
 /*
  * Wrappers to pass the pt_regs argument.
  */
-#define sys_execve		sys_execve_wrapper
 #define sys_clone		sys_clone_wrapper
 #define sys_rt_sigreturn	sys_rt_sigreturn_wrapper
 #define sys_sigaltstack		sys_sigaltstack_wrapper
diff --git a/arch/arm64/kernel/sys32.S b/arch/arm64/kernel/sys32.S
index 5e4dc93..903ba9d 100644
--- a/arch/arm64/kernel/sys32.S
+++ b/arch/arm64/kernel/sys32.S
@@ -36,11 +36,6 @@ compat_sys_vfork_wrapper:
 	b	compat_sys_vfork
 ENDPROC(compat_sys_vfork_wrapper)
 
-compat_sys_execve_wrapper:
-	mov	x3, sp
-	b	compat_sys_execve
-ENDPROC(compat_sys_execve_wrapper)
-
 compat_sys_clone_wrapper:
 	mov	x5, sp
 	b	compat_sys_clone
@@ -152,7 +147,7 @@ ENDPROC(compat_sys_fanotify_mark_wrapper)
  */
 #define sys_fork		compat_sys_fork_wrapper
 #define sys_open		compat_sys_open
-#define sys_execve		compat_sys_execve_wrapper
+#define sys_execve		compat_sys_execve
 #define sys_lseek		compat_sys_lseek_wrapper
 #define sys_mount		compat_sys_mount
 #define sys_ptrace		compat_sys_ptrace
diff --git a/arch/arm64/kernel/sys_compat.c b/arch/arm64/kernel/sys_compat.c
index 967e92f..d77ba8e 100644
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -51,24 +51,6 @@ asmlinkage int compat_sys_vfork(struct pt_regs *regs)
 		       regs, 0, NULL, NULL);
 }
 
-asmlinkage int compat_sys_execve(const char __user *filenamei,
-				 compat_uptr_t argv, compat_uptr_t envp,
-				 struct pt_regs *regs)
-{
-	int error;
-	char * filename;
-
-	filename = getname(filenamei);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		goto out;
-	error = compat_do_execve(filename, compat_ptr(argv), compat_ptr(envp),
-				 regs);
-	putname(filename);
-out:
-	return error;
-}
-
 asmlinkage int compat_sys_sched_rr_get_interval(compat_pid_t pid,
 						struct compat_timespec __user *interval)
 {
