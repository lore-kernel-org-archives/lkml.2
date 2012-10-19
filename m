Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab2JSVf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:35:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36195 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab2JSVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:35:53 -0400
Date: Fri, 19 Oct 2012 22:35:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] tile: support GENERIC_KERNEL_THREAD and
 GENERIC_KERNEL_EXECVE
Message-ID: <20121019213548.GR2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <201210192041.q9JKf7jD003998@farm-0010.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210192041.q9JKf7jD003998@farm-0010.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 04:25:12PM -0400, Chris Metcalf wrote:
> Also provide an optimized current_pt_regs() while we're at it.

Applied.  BTW, are you sure you want to record parent's pid and not tid?

Anyway, here's a followup on top of this one (again, completely untested) -
switching to generic sys_execve().  Does that look right for you?  While
we are at it, I wonder if any of PTREGS_SYSCALL wrappers are needed -
current_pt_regs() would do just as well, won't it?  It's a couple of
arithmetical operations vs. arith operation + branch; even if the latter
is somehow cheaper, can't be cheaper by much.  And I'd expect it to be
costlier, actually, what with the icache effects.

Until now current_pt_regs() was not an option for execve(), due to
kernel_thread() implementation being what it was, but now it should
work for all of them...

diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index 3063e6f..404a3dd 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -304,9 +304,6 @@ long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 				      struct compat_timespec __user *interval);
 
 /* These are the intvec_64.S trampolines. */
-long _compat_sys_execve(const char __user *path,
-			const compat_uptr_t __user *argv,
-			const compat_uptr_t __user *envp);
 long _compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
 			    struct compat_sigaltstack __user *uoss_ptr);
 long _compat_sys_rt_sigreturn(void);
diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
index f8ccf08..b73e103 100644
--- a/arch/tile/include/asm/elf.h
+++ b/arch/tile/include/asm/elf.h
@@ -148,6 +148,7 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 #define compat_start_thread(regs, ip, usp) do { \
 		regs->pc = ptr_to_compat_reg((void *)(ip)); \
 		regs->sp = ptr_to_compat_reg((void *)(usp)); \
+		single_step_execve();	\
 	} while (0)
 
 /*
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 9a83e53..879073e 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -211,6 +211,7 @@ static inline void start_thread(struct pt_regs *regs,
 {
 	regs->pc = pc;
 	regs->sp = usp;
+	single_step_execve();
 }
 
 /* Free all resources held by a thread. */
diff --git a/arch/tile/include/asm/syscalls.h b/arch/tile/include/asm/syscalls.h
index 06f0464..0d52992 100644
--- a/arch/tile/include/asm/syscalls.h
+++ b/arch/tile/include/asm/syscalls.h
@@ -68,9 +68,10 @@ long _sys_sigaltstack(const stack_t __user *, stack_t __user *);
 long _sys_rt_sigreturn(void);
 long _sys_clone(unsigned long clone_flags, unsigned long newsp,
 		void __user *parent_tid, void __user *child_tid);
-long _sys_execve(const char __user *filename,
+long sys_execve(const char __user *filename,
 		 const char __user *const __user *argv,
 		 const char __user *const __user *envp);
+#define sys_execve sys_execve
 
 #include <asm-generic/syscalls.h>
 
diff --git a/arch/tile/include/asm/unistd.h b/arch/tile/include/asm/unistd.h
index 6e032a0..dab827d 100644
--- a/arch/tile/include/asm/unistd.h
+++ b/arch/tile/include/asm/unistd.h
@@ -16,4 +16,5 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #endif
 #define __ARCH_WANT_SYS_NEWFSTATAT
+#define __ARCH_WANT_SYS_EXECVE
 #include <uapi/asm/unistd.h>
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
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 58aad51..174b837 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1476,7 +1476,6 @@ STD_ENTRY_LOCAL(bad_intr)
 	};                                              \
 	STD_ENDPROC(_##x)
 
-PTREGS_SYSCALL(sys_execve, r3)
 PTREGS_SYSCALL(sys_sigaltstack, r2)
 PTREGS_SYSCALL_SIGRETURN(sys_rt_sigreturn, r0)
 PTREGS_SYSCALL(sys_cmpxchg_badaddr, r1)
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index a84911c4..283efed 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -1205,11 +1205,9 @@ STD_ENTRY_LOCAL(bad_intr)
 	};                                              \
 	STD_ENDPROC(_##x)
 
-PTREGS_SYSCALL(sys_execve, r3)
 PTREGS_SYSCALL(sys_sigaltstack, r2)
 PTREGS_SYSCALL_SIGRETURN(sys_rt_sigreturn, r0)
 #ifdef CONFIG_COMPAT
-PTREGS_SYSCALL(compat_sys_execve, r3)
 PTREGS_SYSCALL(compat_sys_sigaltstack, r2)
 PTREGS_SYSCALL_SIGRETURN(compat_sys_rt_sigreturn, r0)
 #endif
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index ca6de8d..58f8fd1 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -594,51 +594,6 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		       parent_tidptr, child_tidptr);
 }
 
-/*
- * sys_execve() executes a new program.
- */
-SYSCALL_DEFINE4(execve, const char __user *, path,
-		const char __user *const __user *, argv,
-		const char __user *const __user *, envp,
-		struct pt_regs *, regs)
-{
-	long error;
-	struct filename *filename;
-
-	filename = getname(path);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		goto out;
-	error = do_execve(filename->name, argv, envp, regs);
-	putname(filename);
-	if (error == 0)
-		single_step_execve();
-out:
-	return error;
-}
-
-#ifdef CONFIG_COMPAT
-long compat_sys_execve(const char __user *path,
-		       compat_uptr_t __user *argv,
-		       compat_uptr_t __user *envp,
-		       struct pt_regs *regs)
-{
-	long error;
-	struct filename *filename;
-
-	filename = getname(path);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		goto out;
-	error = compat_do_execve(filename->name, argv, envp, regs);
-	putname(filename);
-	if (error == 0)
-		single_step_execve();
-out:
-	return error;
-}
-#endif
-
 unsigned long get_wchan(struct task_struct *p)
 {
 	struct KBacktraceIterator kbt;
diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
index b08095b..359e76f 100644
--- a/arch/tile/kernel/sys.c
+++ b/arch/tile/kernel/sys.c
@@ -107,7 +107,6 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 #endif
 
 /* Call the trampolines to manage pt_regs where necessary. */
-#define sys_execve _sys_execve
 #define sys_sigaltstack _sys_sigaltstack
 #define sys_rt_sigreturn _sys_rt_sigreturn
 #define sys_clone _sys_clone
