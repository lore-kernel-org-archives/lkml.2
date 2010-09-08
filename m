Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab0IHSmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 14:42:31 -0400
Received: from king.tilera.com ([72.1.168.226]:43243 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab0IHSm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:42:27 -0400
Message-Id: <201009081842.o88IgNvt028003@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 8 Sep 2010 14:18:44 -0400
Subject: [PATCH] arch/tile: Use <asm-generic/syscalls.h>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 08 Sep 2010 18:42:24.0977 (UTC) FILETIME=[946F7C10:01CB4F85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change we now include <asm-generic/syscalls.h> into the "tile"
version of the header.  To take full advantage of the prototypes there,
we also change our naming convention for "struct pt_regs *" syscalls so
that, e.g., _sys_execve() is the "true" syscall entry, which sets the
appropriate register to point to the pt_regs before calling sys_execve().

While doing this I realized I no longer needed the fork and vfork
entry point stubs, since those functions aren't in the generic
syscall ABI, so I removed them as well.

This change also fixes a compilation failure from the recent bombing
of sys_execve() arguments to be more const-ified.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/compat.h   |   18 ++++++++--
 arch/tile/include/asm/syscalls.h |   68 ++++++++++----------------------------
 arch/tile/kernel/compat.c        |    6 +++
 arch/tile/kernel/compat_signal.c |   10 +++---
 arch/tile/kernel/intvec_32.S     |   23 +++++--------
 arch/tile/kernel/process.c       |   30 ++++++----------
 arch/tile/kernel/signal.c        |    6 ++--
 arch/tile/kernel/sys.c           |    9 +++++
 arch/tile/mm/fault.c             |    6 ++--
 9 files changed, 78 insertions(+), 98 deletions(-)

diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index 5a34da6..ff3a83b 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -214,16 +214,18 @@ extern int compat_setup_rt_frame(int sig, struct k_sigaction *ka,
 struct compat_sigaction;
 struct compat_siginfo;
 struct compat_sigaltstack;
-long compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
-		       compat_uptr_t __user *envp);
+long compat_sys_execve(const char __user *path,
+                       const compat_uptr_t __user *argv,
+		       const compat_uptr_t __user *envp, struct pt_regs *);
 long compat_sys_rt_sigaction(int sig, struct compat_sigaction __user *act,
 			     struct compat_sigaction __user *oact,
 			     size_t sigsetsize);
 long compat_sys_rt_sigqueueinfo(int pid, int sig,
 				struct compat_siginfo __user *uinfo);
-long compat_sys_rt_sigreturn(void);
+long compat_sys_rt_sigreturn(struct pt_regs *);
 long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
-			    struct compat_sigaltstack __user *uoss_ptr);
+			    struct compat_sigaltstack __user *uoss_ptr,
+			    struct pt_regs *);
 long compat_sys_truncate64(char __user *filename, u32 dummy, u32 low, u32 high);
 long compat_sys_ftruncate64(unsigned int fd, u32 dummy, u32 low, u32 high);
 long compat_sys_pread64(unsigned int fd, char __user *ubuf, size_t count,
@@ -254,4 +256,12 @@ long tile_compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 /* Tilera Linux syscalls that don't have "compat" versions. */
 #define compat_sys_flush_cache sys_flush_cache
 
+/* These are the intvec_64.S trampolines. */
+long _compat_sys_execve(const char __user *path,
+                        const compat_uptr_t __user *argv,
+			const compat_uptr_t __user *envp);
+long _compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
+			    struct compat_sigaltstack __user *uoss_ptr);
+long _compat_sys_rt_sigreturn(void);
+
 #endif /* _ASM_TILE_COMPAT_H */
diff --git a/arch/tile/include/asm/syscalls.h b/arch/tile/include/asm/syscalls.h
index af165a7..3f5fe5e 100644
--- a/arch/tile/include/asm/syscalls.h
+++ b/arch/tile/include/asm/syscalls.h
@@ -32,8 +32,9 @@ extern void *compat_sys_call_table[];
 
 /*
  * Note that by convention, any syscall which requires the current
- * register set takes an additional "struct pt_regs *" pointer; the
- * sys_xxx() function just adds the pointer and tail-calls to _sys_xxx().
+ * register set takes an additional "struct pt_regs *" pointer; a
+ * _sys_xxx() trampoline in intvec*.S just sets up the pointer and
+ * jumps to sys_xxx().
  */
 
 /* kernel/sys.c */
@@ -43,61 +44,17 @@ long sys32_fadvise64(int fd, u32 offset_lo, u32 offset_hi,
 int sys32_fadvise64_64(int fd, u32 offset_lo, u32 offset_hi,
 		       u32 len_lo, u32 len_hi, int advice);
 long sys_flush_cache(void);
-long sys_mmap2(unsigned long addr, unsigned long len,
-	       unsigned long prot, unsigned long flags,
-	       unsigned long fd, unsigned long pgoff);
-#ifdef __tilegx__
-long sys_mmap(unsigned long addr, unsigned long len,
-	      unsigned long prot, unsigned long flags,
-	      unsigned long fd, off_t pgoff);
+#ifndef __tilegx__  /* No mmap() in the 32-bit kernel. */
+#define sys_mmap sys_mmap
 #endif
 
-/* kernel/process.c */
-long sys_clone(unsigned long clone_flags, unsigned long newsp,
-	       void __user *parent_tid, void __user *child_tid);
-long _sys_clone(unsigned long clone_flags, unsigned long newsp,
-		void __user *parent_tid, void __user *child_tid,
-		struct pt_regs *regs);
-long sys_fork(void);
-long _sys_fork(struct pt_regs *regs);
-long sys_vfork(void);
-long _sys_vfork(struct pt_regs *regs);
-long sys_execve(char __user *filename, char __user * __user *argv,
-		char __user * __user *envp);
-long _sys_execve(char __user *filename, char __user * __user *argv,
-		 char __user * __user *envp, struct pt_regs *regs);
-
-/* kernel/signal.c */
-long sys_sigaltstack(const stack_t __user *, stack_t __user *);
-long _sys_sigaltstack(const stack_t __user *, stack_t __user *,
-		      struct pt_regs *);
-long sys_rt_sigreturn(void);
-long _sys_rt_sigreturn(struct pt_regs *regs);
-
-/* platform-independent functions */
-long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize);
-long sys_rt_sigaction(int sig, const struct sigaction __user *act,
-		      struct sigaction __user *oact, size_t sigsetsize);
-
 #ifndef __tilegx__
 /* mm/fault.c */
-int sys_cmpxchg_badaddr(unsigned long address);
-int _sys_cmpxchg_badaddr(unsigned long address, struct pt_regs *);
+long sys_cmpxchg_badaddr(unsigned long address, struct pt_regs *);
+long _sys_cmpxchg_badaddr(unsigned long address);
 #endif
 
 #ifdef CONFIG_COMPAT
-long compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
-		       compat_uptr_t __user *envp);
-long _compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
-			compat_uptr_t __user *envp, struct pt_regs *regs);
-long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
-			    struct compat_sigaltstack __user *uoss_ptr);
-long _compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
-			     struct compat_sigaltstack __user *uoss_ptr,
-			     struct pt_regs *regs);
-long compat_sys_rt_sigreturn(void);
-long _compat_sys_rt_sigreturn(struct pt_regs *regs);
-
 /* These four are not defined for 64-bit, but serve as "compat" syscalls. */
 long sys_fcntl64(unsigned int fd, unsigned int cmd, unsigned long arg);
 long sys_fstat64(unsigned long fd, struct stat64 __user *statbuf);
@@ -105,4 +62,15 @@ long sys_truncate64(const char __user *path, loff_t length);
 long sys_ftruncate64(unsigned int fd, loff_t length);
 #endif
 
+/* These are the intvec*.S trampolines. */
+long _sys_sigaltstack(const stack_t __user *, stack_t __user *);
+long _sys_rt_sigreturn(void);
+long _sys_clone(unsigned long clone_flags, unsigned long newsp,
+		void __user *parent_tid, void __user *child_tid);
+long _sys_execve(const char __user *filename,
+                 const char __user *const __user *argv,
+		 const char __user *const __user *envp);
+
+#include <asm-generic/syscalls.h>
+
 #endif /* _ASM_TILE_SYSCALLS_H */
diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
index b1e06d0..5f24e54 100644
--- a/arch/tile/kernel/compat.c
+++ b/arch/tile/kernel/compat.c
@@ -157,6 +157,12 @@ long tile_compat_sys_msgrcv(int msqid,
 /* Pass full 64-bit values through ptrace. */
 #define compat_sys_ptrace tile_compat_sys_ptrace
 
+/* Call the trampolines to manage pt_regs where necessary. */
+#define compat_sys_execve _compat_sys_execve
+#define compat_sys_sigaltstack _compat_sys_sigaltstack
+#define compat_sys_rt_sigreturn _compat_sys_rt_sigreturn
+#define sys_clone _sys_clone
+
 /*
  * Note that we can't include <linux/unistd.h> here since the header
  * guard will defeat us; <asm/unistd.h> checks for __SYSCALL as well.
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index 9c710db..fb64b99 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -256,9 +256,9 @@ int copy_siginfo_from_user32(siginfo_t *to, struct compat_siginfo __user *from)
 	return err;
 }
 
-long _compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
-			     struct compat_sigaltstack __user *uoss_ptr,
-			     struct pt_regs *regs)
+long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
+			    struct compat_sigaltstack __user *uoss_ptr,
+			    struct pt_regs *regs)
 {
 	stack_t uss, uoss;
 	int ret;
@@ -291,7 +291,7 @@ long _compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
 	return ret;
 }
 
-long _compat_sys_rt_sigreturn(struct pt_regs *regs)
+long compat_sys_rt_sigreturn(struct pt_regs *regs)
 {
 	struct compat_rt_sigframe __user *frame =
 		(struct compat_rt_sigframe __user *) compat_ptr(regs->sp);
@@ -312,7 +312,7 @@ long _compat_sys_rt_sigreturn(struct pt_regs *regs)
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &r0))
 		goto badframe;
 
-	if (_compat_sys_sigaltstack(&frame->uc.uc_stack, NULL, regs) != 0)
+	if (compat_sys_sigaltstack(&frame->uc.uc_stack, NULL, regs) != 0)
 		goto badframe;
 
 	return r0;
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 84f296c..8818721 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1531,28 +1531,23 @@ STD_ENTRY_LOCAL(bad_intr)
 
 /* Put address of pt_regs in reg and jump. */
 #define PTREGS_SYSCALL(x, reg)                          \
-	STD_ENTRY(x);                                   \
+	STD_ENTRY(_##x);                                \
 	{                                               \
 	 PTREGS_PTR(reg, PTREGS_OFFSET_BASE);           \
-	 j      _##x                                    \
+	 j      x                                       \
 	};                                              \
-	STD_ENDPROC(x)
+	STD_ENDPROC(_##x)
 
 PTREGS_SYSCALL(sys_execve, r3)
 PTREGS_SYSCALL(sys_sigaltstack, r2)
 PTREGS_SYSCALL(sys_rt_sigreturn, r0)
+PTREGS_SYSCALL(sys_cmpxchg_badaddr, r1)
 
-/* Save additional callee-saves to pt_regs, put address in reg and jump. */
-#define PTREGS_SYSCALL_ALL_REGS(x, reg)                 \
-	STD_ENTRY(x);                                   \
-	push_extra_callee_saves reg;                    \
-	j       _##x;                                   \
-	STD_ENDPROC(x)
-
-PTREGS_SYSCALL_ALL_REGS(sys_fork, r0)
-PTREGS_SYSCALL_ALL_REGS(sys_vfork, r0)
-PTREGS_SYSCALL_ALL_REGS(sys_clone, r4)
-PTREGS_SYSCALL_ALL_REGS(sys_cmpxchg_badaddr, r1)
+/* Save additional callee-saves to pt_regs, put address in r4 and jump. */
+STD_ENTRY(_sys_clone)
+	push_extra_callee_saves r4
+	j       sys_clone
+	STD_ENDPROC(_sys_clone)
 
 /*
  * This entrypoint is taken for the cmpxchg and atomic_update fast
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 985cc28..8a099bb 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -519,14 +519,9 @@ struct task_struct *__sched _switch_to(struct task_struct *prev,
 	return __switch_to(prev, next, next_current_ksp0(next));
 }
 
-long _sys_fork(struct pt_regs *regs)
-{
-	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
-}
-
-long _sys_clone(unsigned long clone_flags, unsigned long newsp,
-		void __user *parent_tidptr, void __user *child_tidptr,
-		struct pt_regs *regs)
+SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
+		void __user *, parent_tidptr, void __user *, child_tidptr,
+		struct pt_regs *, regs)
 {
 	if (!newsp)
 		newsp = regs->sp;
@@ -534,18 +529,13 @@ long _sys_clone(unsigned long clone_flags, unsigned long newsp,
 		       parent_tidptr, child_tidptr);
 }
 
-long _sys_vfork(struct pt_regs *regs)
-{
-	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp,
-		       regs, 0, NULL, NULL);
-}
-
 /*
  * sys_execve() executes a new program.
  */
-long _sys_execve(const char __user *path,
-		 const char __user *const __user *argv,
-		 const char __user *const __user *envp, struct pt_regs *regs)
+SYSCALL_DEFINE4(execve, const char __user *, path,
+                const char __user *const __user *, argv,
+		const char __user *const __user *, envp,
+                struct pt_regs *, regs)
 {
 	long error;
 	char *filename;
@@ -561,8 +551,10 @@ out:
 }
 
 #ifdef CONFIG_COMPAT
-long _compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
-			compat_uptr_t __user *envp, struct pt_regs *regs)
+long compat_sys_execve(const char __user *path,
+                       const compat_uptr_t __user *argv,
+		       const compat_uptr_t __user *envp,
+                       struct pt_regs *regs)
 {
 	long error;
 	char *filename;
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 45b66a3..d0fd94f 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -41,8 +41,8 @@
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
 
-long _sys_sigaltstack(const stack_t __user *uss,
-		      stack_t __user *uoss, struct pt_regs *regs)
+SYSCALL_DEFINE3(sigaltstack, const stack_t __user *, uss,
+		stack_t __user *, uoss, struct pt_regs *, regs)
 {
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
@@ -72,7 +72,7 @@ int restore_sigcontext(struct pt_regs *regs,
 }
 
 /* sigreturn() returns long since it restores r0 in the interrupted code. */
-long _sys_rt_sigreturn(struct pt_regs *regs)
+SYSCALL_DEFINE1(rt_sigreturn, struct pt_regs *, regs)
 {
 	struct rt_sigframe __user *frame =
 		(struct rt_sigframe __user *)(regs->sp);
diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
index f0f87ea..7e76466 100644
--- a/arch/tile/kernel/sys.c
+++ b/arch/tile/kernel/sys.c
@@ -110,6 +110,15 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 #define sys_sync_file_range sys_sync_file_range2
 #endif
 
+/* Call the trampolines to manage pt_regs where necessary. */
+#define sys_execve _sys_execve
+#define sys_sigaltstack _sys_sigaltstack
+#define sys_rt_sigreturn _sys_rt_sigreturn
+#define sys_clone _sys_clone
+#ifndef __tilegx__
+#define sys_cmpxchg_badaddr _sys_cmpxchg_badaddr
+#endif
+
 /*
  * Note that we can't include <linux/unistd.h> here since the header
  * guard will defeat us; <asm/unistd.h> checks for __SYSCALL as well.
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 704f3e8..94f579d 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -66,10 +66,10 @@ static noinline void force_sig_info_fault(int si_signo, int si_code,
 #ifndef __tilegx__
 /*
  * Synthesize the fault a PL0 process would get by doing a word-load of
- * an unaligned address or a high kernel address.  Called indirectly
- * from sys_cmpxchg() in kernel/intvec.S.
+ * an unaligned address or a high kernel address.
  */
-int _sys_cmpxchg_badaddr(unsigned long address, struct pt_regs *regs)
+SYSCALL_DEFINE2(cmpxchg_badaddr, unsigned long, address,
+		struct pt_regs *, regs)
 {
 	if (address >= PAGE_OFFSET)
 		force_sig_info_fault(SIGSEGV, SEGV_MAPERR, address,
-- 
1.6.5.2

