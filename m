Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab2JWRgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:36:09 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:25554 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab2JWRgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:36:07 -0400
Message-ID: <201210231736.q9NHa6lP014817@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 23 Oct 2012 13:30:54 -0400
Subject: [PATCH] arch/tile: eliminate pt_regs trampolines for syscalls
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20121016223508.GR2616@ZenIV.linux.org.uk> <201210192041.q9JKf7jD003998@farm-0010.internal.tilera.com> <20121019213548.GR2616@ZenIV.linux.org.uk> <5082A1F1.3080303@tilera.com> <20121020153401.GT2616@ZenIV.linux.org.uk> <20121020171643.GU2616@ZenIV.linux.org.uk>
In-Reply-To: <20121020171643.GU2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the new current_pt_regs() model, we can remove some trampolines
from assembly code and call directly to the C syscall implementations.
rt_sigreturn() and clone() still need some assembly wrapping, but no
longer are passed a pt_regs pointer.  sigaltstack() and the
tilepro-specific cmpxchg_badaddr() syscalls are now just straight C.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
This is based on Al Viro's signal.git#arch-tile branch, which includes
some ARM64 changes and some Tile changes for generic kernel execve.

 arch/tile/include/asm/compat.h   |    9 +++------
 arch/tile/include/asm/syscalls.h |   19 +++++++++++++------
 arch/tile/kernel/compat.c        |    4 ++--
 arch/tile/kernel/compat_signal.c |   10 +++++-----
 arch/tile/kernel/intvec_32.S     |   13 +------------
 arch/tile/kernel/intvec_64.S     |   13 +------------
 arch/tile/kernel/process.c       |    6 +++---
 arch/tile/kernel/signal.c        |    9 +++++----
 arch/tile/kernel/sys.c           |    8 +++-----
 arch/tile/mm/fault.c             |    5 +++--
 10 files changed, 39 insertions(+), 57 deletions(-)

diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index 3bcf1b9..ca61fb4 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -280,10 +280,9 @@ long compat_sys_rt_sigaction(int sig, struct compat_sigaction __user *act,
 			     size_t sigsetsize);
 long compat_sys_rt_sigqueueinfo(int pid, int sig,
 				struct compat_siginfo __user *uinfo);
-long compat_sys_rt_sigreturn(struct pt_regs *);
+long compat_sys_rt_sigreturn(void);
 long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
-			    struct compat_sigaltstack __user *uoss_ptr,
-			    struct pt_regs *);
+			    struct compat_sigaltstack __user *uoss_ptr);
 long compat_sys_truncate64(char __user *filename, u32 dummy, u32 low, u32 high);
 long compat_sys_ftruncate64(unsigned int fd, u32 dummy, u32 low, u32 high);
 long compat_sys_pread64(unsigned int fd, char __user *ubuf, size_t count,
@@ -300,9 +299,7 @@ long compat_sys_fallocate(int fd, int mode,
 long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 				      struct compat_timespec __user *interval);
 
-/* These are the intvec_64.S trampolines. */
-long _compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
-			    struct compat_sigaltstack __user *uoss_ptr);
+/* Assembly trampoline to avoid clobbering r0. */
 long _compat_sys_rt_sigreturn(void);
 
 #endif /* _ASM_TILE_COMPAT_H */
diff --git a/arch/tile/include/asm/syscalls.h b/arch/tile/include/asm/syscalls.h
index 0d52992..369696d 100644
--- a/arch/tile/include/asm/syscalls.h
+++ b/arch/tile/include/asm/syscalls.h
@@ -51,8 +51,7 @@ long sys_cacheflush(unsigned long addr, unsigned long len,
 
 #ifndef __tilegx__
 /* mm/fault.c */
-long sys_cmpxchg_badaddr(unsigned long address, struct pt_regs *);
-long _sys_cmpxchg_badaddr(unsigned long address);
+long sys_cmpxchg_badaddr(unsigned long address);
 #endif
 
 #ifdef CONFIG_COMPAT
@@ -63,15 +62,23 @@ long sys_truncate64(const char __user *path, loff_t length);
 long sys_ftruncate64(unsigned int fd, loff_t length);
 #endif
 
-/* These are the intvec*.S trampolines. */
-long _sys_sigaltstack(const stack_t __user *, stack_t __user *);
-long _sys_rt_sigreturn(void);
-long _sys_clone(unsigned long clone_flags, unsigned long newsp,
+/* Provide versions of standard syscalls that use current_pt_regs(). */
+long sys_clone(unsigned long clone_flags, unsigned long newsp,
 		void __user *parent_tid, void __user *child_tid);
 long sys_execve(const char __user *filename,
 		 const char __user *const __user *argv,
 		 const char __user *const __user *envp);
+long sys_rt_sigreturn(void);
+long sys_sigaltstack(const stack_t __user *, stack_t __user *);
+#define sys_clone sys_clone
 #define sys_execve sys_execve
+#define sys_rt_sigreturn sys_rt_sigreturn
+#define sys_sigaltstack sys_sigaltstack
+
+/* These are the intvec*.S trampolines. */
+long _sys_rt_sigreturn(void);
+long _sys_clone(unsigned long clone_flags, unsigned long newsp,
+		void __user *parent_tid, void __user *child_tid);
 
 #include <asm-generic/syscalls.h>
 
diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
index a8e5a84..a2e8055 100644
--- a/arch/tile/kernel/compat.c
+++ b/arch/tile/kernel/compat.c
@@ -102,9 +102,9 @@ long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 #define compat_sys_fadvise64_64 sys32_fadvise64_64
 #define compat_sys_readahead sys32_readahead
 
-/* Call the trampolines to manage pt_regs where necessary. */
-#define compat_sys_sigaltstack _compat_sys_sigaltstack
+/* Call the assembly trampolines where necessary. */
 #define compat_sys_rt_sigreturn _compat_sys_rt_sigreturn
+#undef sys_clone
 #define sys_clone _sys_clone
 
 /*
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index 08b4fe1..210a9bb 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -197,8 +197,7 @@ int copy_siginfo_from_user32(siginfo_t *to, struct compat_siginfo __user *from)
 }
 
 long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
-			    struct compat_sigaltstack __user *uoss_ptr,
-			    struct pt_regs *regs)
+			    struct compat_sigaltstack __user *uoss_ptr)
 {
 	stack_t uss, uoss;
 	int ret;
@@ -219,7 +218,7 @@ long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
 	set_fs(KERNEL_DS);
 	ret = do_sigaltstack(uss_ptr ? (stack_t __user __force *)&uss : NULL,
 			     (stack_t __user __force *)&uoss,
-			     (unsigned long)compat_ptr(regs->sp));
+			     (unsigned long)compat_ptr(current_pt_regs()->sp));
 	set_fs(seg);
 	if (ret >= 0 && uoss_ptr)  {
 		if (!access_ok(VERIFY_WRITE, uoss_ptr, sizeof(*uoss_ptr)) ||
@@ -232,8 +231,9 @@ long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
 }
 
 /* The assembly shim for this function arranges to ignore the return value. */
-long compat_sys_rt_sigreturn(struct pt_regs *regs)
+long compat_sys_rt_sigreturn(void)
 {
+	struct pt_regs *regs = current_pt_regs();
 	struct compat_rt_sigframe __user *frame =
 		(struct compat_rt_sigframe __user *) compat_ptr(regs->sp);
 	sigset_t set;
@@ -248,7 +248,7 @@ long compat_sys_rt_sigreturn(struct pt_regs *regs)
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
 
-	if (compat_sys_sigaltstack(&frame->uc.uc_stack, NULL, regs) != 0)
+	if (compat_sys_sigaltstack(&frame->uc.uc_stack, NULL) != 0)
 		goto badframe;
 
 	return 0;
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 174b837..f212bf7 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1452,15 +1452,6 @@ STD_ENTRY_LOCAL(bad_intr)
 	panic   "Unhandled interrupt %#x: PC %#lx"
 	STD_ENDPROC(bad_intr)
 
-/* Put address of pt_regs in reg and jump. */
-#define PTREGS_SYSCALL(x, reg)                          \
-	STD_ENTRY(_##x);                                \
-	{                                               \
-	 PTREGS_PTR(reg, PTREGS_OFFSET_BASE);           \
-	 j      x                                       \
-	};                                              \
-	STD_ENDPROC(_##x)
-
 /*
  * Special-case sigreturn to not write r0 to the stack on return.
  * This is technically more efficient, but it also avoids difficulties
@@ -1476,11 +1467,9 @@ STD_ENTRY_LOCAL(bad_intr)
 	};                                              \
 	STD_ENDPROC(_##x)
 
-PTREGS_SYSCALL(sys_sigaltstack, r2)
 PTREGS_SYSCALL_SIGRETURN(sys_rt_sigreturn, r0)
-PTREGS_SYSCALL(sys_cmpxchg_badaddr, r1)
 
-/* Save additional callee-saves to pt_regs, put address in r4 and jump. */
+/* Save additional callee-saves to pt_regs and jump to standard function. */
 STD_ENTRY(_sys_clone)
 	push_extra_callee_saves r4
 	j       sys_clone
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 283efed..54bc9a6 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -1181,15 +1181,6 @@ STD_ENTRY_LOCAL(bad_intr)
 	panic   "Unhandled interrupt %#x: PC %#lx"
 	STD_ENDPROC(bad_intr)
 
-/* Put address of pt_regs in reg and jump. */
-#define PTREGS_SYSCALL(x, reg)                          \
-	STD_ENTRY(_##x);                                \
-	{                                               \
-	 PTREGS_PTR(reg, PTREGS_OFFSET_BASE);           \
-	 j      x                                       \
-	};                                              \
-	STD_ENDPROC(_##x)
-
 /*
  * Special-case sigreturn to not write r0 to the stack on return.
  * This is technically more efficient, but it also avoids difficulties
@@ -1205,14 +1196,12 @@ STD_ENTRY_LOCAL(bad_intr)
 	};                                              \
 	STD_ENDPROC(_##x)
 
-PTREGS_SYSCALL(sys_sigaltstack, r2)
 PTREGS_SYSCALL_SIGRETURN(sys_rt_sigreturn, r0)
 #ifdef CONFIG_COMPAT
-PTREGS_SYSCALL(compat_sys_sigaltstack, r2)
 PTREGS_SYSCALL_SIGRETURN(compat_sys_rt_sigreturn, r0)
 #endif
 
-/* Save additional callee-saves to pt_regs, put address in r4 and jump. */
+/* Save additional callee-saves to pt_regs and jump to standard function. */
 STD_ENTRY(_sys_clone)
 	push_extra_callee_saves r4
 	j       sys_clone
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 58f8fd1..6e7fb4e 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -584,10 +584,10 @@ int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 }
 
 /* Note there is an implicit fifth argument if (clone_flags & CLONE_SETTLS). */
-SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
-		void __user *, parent_tidptr, void __user *, child_tidptr,
-		struct pt_regs *, regs)
+SYSCALL_DEFINE4(clone, unsigned long, clone_flags, unsigned long, newsp,
+		void __user *, parent_tidptr, void __user *, child_tidptr)
 {
+	struct pt_regs *regs = current_pt_regs();
 	if (!newsp)
 		newsp = regs->sp;
 	return do_fork(clone_flags, newsp, regs, 0,
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 67efb65..657a7ac 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -37,10 +37,10 @@
 
 #define DEBUG_SIG 0
 
-SYSCALL_DEFINE3(sigaltstack, const stack_t __user *, uss,
-		stack_t __user *, uoss, struct pt_regs *, regs)
+SYSCALL_DEFINE2(sigaltstack, const stack_t __user *, uss,
+		stack_t __user *, uoss)
 {
-	return do_sigaltstack(uss, uoss, regs->sp);
+	return do_sigaltstack(uss, uoss, current_pt_regs()->sp);
 }
 
 
@@ -83,8 +83,9 @@ void signal_fault(const char *type, struct pt_regs *regs,
 }
 
 /* The assembly shim for this function arranges to ignore the return value. */
-SYSCALL_DEFINE1(rt_sigreturn, struct pt_regs *, regs)
+SYSCALL_DEFINE0(rt_sigreturn)
 {
+	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe __user *frame =
 		(struct rt_sigframe __user *)(regs->sp);
 	sigset_t set;
diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
index 359e76f..02ff5c0 100644
--- a/arch/tile/kernel/sys.c
+++ b/arch/tile/kernel/sys.c
@@ -106,13 +106,11 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 #define sys_readahead sys32_readahead
 #endif
 
-/* Call the trampolines to manage pt_regs where necessary. */
-#define sys_sigaltstack _sys_sigaltstack
+/* Call the assembly trampolines where necessary. */
+#undef sys_rt_sigreturn
 #define sys_rt_sigreturn _sys_rt_sigreturn
+#undef sys_clone
 #define sys_clone _sys_clone
-#ifndef __tilegx__
-#define sys_cmpxchg_badaddr _sys_cmpxchg_badaddr
-#endif
 
 /*
  * Note that we can't include <linux/unistd.h> here since the header
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index fe811fa..3d2b81c 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -70,9 +70,10 @@ static noinline void force_sig_info_fault(const char *type, int si_signo,
  * Synthesize the fault a PL0 process would get by doing a word-load of
  * an unaligned address or a high kernel address.
  */
-SYSCALL_DEFINE2(cmpxchg_badaddr, unsigned long, address,
-		struct pt_regs *, regs)
+SYSCALL_DEFINE1(cmpxchg_badaddr, unsigned long, address)
 {
+	struct pt_regs *regs = current_pt_regs();
+
 	if (address >= PAGE_OFFSET)
 		force_sig_info_fault("atomic segfault", SIGSEGV, SEGV_MAPERR,
 				     address, INT_DTLB_MISS, current, regs);
-- 
1.7.10.3

