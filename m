Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab2JTRQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 13:16:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39023 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab2JTRQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 13:16:46 -0400
Date: Sat, 20 Oct 2012 18:16:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] tile: support GENERIC_KERNEL_THREAD and
 GENERIC_KERNEL_EXECVE
Message-ID: <20121020171643.GU2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <201210192041.q9JKf7jD003998@farm-0010.internal.tilera.com>
 <20121019213548.GR2616@ZenIV.linux.org.uk>
 <5082A1F1.3080303@tilera.com>
 <20121020153401.GT2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121020153401.GT2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 04:34:01PM +0100, Al Viro wrote:
> On Sat, Oct 20, 2012 at 09:06:57AM -0400, Chris Metcalf wrote:
> > First, the compat_sys_execve() declaration provided in
> > arch/tile/include/asm/compat.h isn't right, so I deleted that (you had only
> > deleted the PTREGS_SYSCALL trampoline declaration, _compat_sys_execve).
> > 
> > However, then arch/tile/kernel/compat.c failed to build, because
> > <linux/compat.h> is included before <asm/unistd.h>, and <asm/unistd.h>
> > provides __ARCH_WANT_SYS_EXECVE, and so we end up with no declaration at
> > all for compat_sys_execve.  For most platforms this is no big deal, but on
> > tile we use the __SYSCALL #define to provide the actual syscall table, and
> > for that to work we need a declaration in scope for each syscall at the
> > time we create the table.
> > 
> > The best solution seems likely to be to copy the other place in
> > <linux/compat.h> where we need to do something configurable (that is,
> > CONFIG_ARCH_WANT_OLD_COMPAT_IPC), and just convert __ARCH_WANT_SYS_EXECVE
> > to be a Kconfig option.
> 
> Frankly, I hope to get rid of the damn thing completely.  By now we have
> at least some variant of execve conversions for just about everything;
> I certainly hope that by the beginning of the next cycle we'll have it
> defined on everything.  And put unconditional declarations in syscalls.h
> and compat.h
> 
> Actually, we can make the declaration in linux/compat.h unconditional
> right now.  The only obstacle is the situation on arm64; there the mainline
> has C variant of that sucker (with struct pt_regs * in arguments) in
> arch/arm64/kernel/sys_compat.c.  So we could ask Linus to pull
> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64 execve
> and then do the following in one patch:
> 	introduce current_pt_regs() on tile (from your commit)
> 	get rid of pt_regs * argument in tile compat_sys_execve(), making it
> use current_pt_regs(); kill its wrapper
> 	kill the declarations of compat_sys_execve()/_compat_sys_execve()
> in tile asm/compat.h
> 	make declaration in linux/compat.h unconditional
> Note that this does *not* depend on kernel_thread/kernel_execve patch -
> kernel_execve() is never going to hit compat_sys_execve(), since it's
> only called from kernel threads and those are not going to be 32bit.
> After that we can do kernel_thread/kernel_execve commit and
> sys_execve() conversion with nothing outside of arch/tile touched.

Another possible variant is for you to merge that branch from arm64 tree
(only 3 commits it it) and then do as described above.  I.e. on top of
that apply the thing below, followed by your kernel_thread()/kernel_execve()
patch (sans current_pt_regs() part), followed by obviously massaged parts
of generic sys_execve for tile patch I've sent.  FWIW, I've put the
whole series (based at the end of arm64 branch) in signal.git#arch-tile.
Comments?

Drop struct pt_regs * argument in compat_sys_execve()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index 3063e6f..3bcf1b9 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -275,9 +275,6 @@ extern int compat_setup_rt_frame(int sig, struct k_sigaction *ka,
 struct compat_sigaction;
 struct compat_siginfo;
 struct compat_sigaltstack;
-long compat_sys_execve(const char __user *path,
-		       compat_uptr_t __user *argv,
-		       compat_uptr_t __user *envp, struct pt_regs *);
 long compat_sys_rt_sigaction(int sig, struct compat_sigaction __user *act,
 			     struct compat_sigaction __user *oact,
 			     size_t sigsetsize);
@@ -304,9 +301,6 @@ long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 				      struct compat_timespec __user *interval);
 
 /* These are the intvec_64.S trampolines. */
-long _compat_sys_execve(const char __user *path,
-			const compat_uptr_t __user *argv,
-			const compat_uptr_t __user *envp);
 long _compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
 			    struct compat_sigaltstack __user *uoss_ptr);
 long _compat_sys_rt_sigreturn(void);
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 8c4dd9f..9a83e53 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -239,6 +239,9 @@ unsigned long get_wchan(struct task_struct *p);
 #define KSTK_TOP(task)	(task_ksp0(task) - STACK_TOP_DELTA)
 #define task_pt_regs(task) \
   ((struct pt_regs *)(task_ksp0(task) - KSTK_PTREGS_GAP) - 1)
+#define current_pt_regs()                                   \
+  ((struct pt_regs *)((stack_pointer | (THREAD_SIZE - 1)) - \
+                      (KSTK_PTREGS_GAP - 1)) - 1)
 #define task_sp(task)	(task_pt_regs(task)->sp)
 #define task_pc(task)	(task_pt_regs(task)->pc)
 /* Aliases for pc and sp (used in fs/proc/array.c) */
diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
index d67459b..a8e5a84 100644
--- a/arch/tile/kernel/compat.c
+++ b/arch/tile/kernel/compat.c
@@ -103,7 +103,6 @@ long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 #define compat_sys_readahead sys32_readahead
 
 /* Call the trampolines to manage pt_regs where necessary. */
-#define compat_sys_execve _compat_sys_execve
 #define compat_sys_sigaltstack _compat_sys_sigaltstack
 #define compat_sys_rt_sigreturn _compat_sys_rt_sigreturn
 #define sys_clone _sys_clone
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 7c06d59..73f6c0a 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -1194,7 +1194,6 @@ PTREGS_SYSCALL(sys_execve, r3)
 PTREGS_SYSCALL(sys_sigaltstack, r2)
 PTREGS_SYSCALL_SIGRETURN(sys_rt_sigreturn, r0)
 #ifdef CONFIG_COMPAT
-PTREGS_SYSCALL(compat_sys_execve, r3)
 PTREGS_SYSCALL(compat_sys_sigaltstack, r2)
 PTREGS_SYSCALL_SIGRETURN(compat_sys_rt_sigreturn, r0)
 #endif
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 307d010..9dc1391 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -614,8 +614,7 @@ out:
 #ifdef CONFIG_COMPAT
 long compat_sys_execve(const char __user *path,
 		       compat_uptr_t __user *argv,
-		       compat_uptr_t __user *envp,
-		       struct pt_regs *regs)
+		       compat_uptr_t __user *envp)
 {
 	long error;
 	struct filename *filename;
@@ -624,7 +623,8 @@ long compat_sys_execve(const char __user *path,
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = compat_do_execve(filename->name, argv, envp, regs);
+	error = compat_do_execve(filename->name, argv, envp,
+				 current_pt_regs());
 	putname(filename);
 	if (error == 0)
 		single_step_execve();
diff --git a/include/linux/compat.h b/include/linux/compat.h
index d0ced10..d2db710 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -286,10 +286,8 @@ asmlinkage ssize_t compat_sys_pwritev(unsigned long fd,
 
 int compat_do_execve(const char *filename, const compat_uptr_t __user *argv,
 		     const compat_uptr_t __user *envp, struct pt_regs *regs);
-#ifdef __ARCH_WANT_SYS_EXECVE
 asmlinkage long compat_sys_execve(const char __user *filename, const compat_uptr_t __user *argv,
 		     const compat_uptr_t __user *envp);
-#endif
 
 asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
