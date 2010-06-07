Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0FGMyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:54:14 -0400
Received: from king.tilera.com ([72.1.168.226]:30352 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab0FGMyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:54:13 -0400
Message-Id: <201006071254.o57CsAwG002729@farm-0002.internal.tilera.com>
In-Reply-To: <20100607140140.870c0fb5.sfr@canb.auug.org.au>
From: Chris Metcalf <cmetcalf@tilera.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 7 Jun 2010 08:48:13 -0400
Subject: [PATCH] Revert adding some arch-specific signal syscalls to <linux/syscalls.h>.
X-OriginalArrivalTime: 07 Jun 2010 12:54:11.0908 (UTC) FILETIME=[86C76840:01CB0640]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out there is some variance on the calling conventions for
these syscalls, and <asm-generic/syscalls.h> is already the mechanism
used to handle this.  Switch arch/tile over to using that mechanism and
tweak the calling conventions for a couple of tile syscalls to match
<asm-generic/syscalls.h>.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/syscalls.h |   22 +---------------------
 arch/tile/kernel/process.c       |    2 +-
 arch/tile/kernel/signal.c        |    4 ++--
 arch/tile/kernel/sys.c           |    2 +-
 include/linux/syscalls.h         |    4 ----
 5 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/arch/tile/include/asm/syscalls.h b/arch/tile/include/asm/syscalls.h
index e1be54d..9f2b8e2 100644
--- a/arch/tile/include/asm/syscalls.h
+++ b/arch/tile/include/asm/syscalls.h
@@ -22,21 +22,7 @@
 #include <linux/linkage.h>
 #include <linux/signal.h>
 #include <linux/types.h>
-
-/* kernel/process.c */
-int sys_fork(struct pt_regs *);
-int sys_vfork(struct pt_regs *);
-int sys_clone(unsigned long clone_flags, unsigned long newsp,
-	      int __user *parent_tidptr, int __user *child_tidptr,
-	      struct pt_regs *);
-int sys_execve(char __user *path, char __user *__user *argv,
-	       char __user *__user *envp, struct pt_regs *);
-
-/* kernel/signal.c */
-int sys_sigaltstack(const stack_t __user *, stack_t __user *,
-		    struct pt_regs *);
-long sys_rt_sigreturn(struct pt_regs *);
-int sys_raise_fpe(int code, unsigned long addr, struct pt_regs*);
+#include <asm-generic/syscalls.h>
 
 /* kernel/sys.c */
 ssize_t sys32_readahead(int fd, u32 offset_lo, u32 offset_hi, u32 count);
@@ -45,12 +31,6 @@ long sys32_fadvise64(int fd, u32 offset_lo, u32 offset_hi,
 int sys32_fadvise64_64(int fd, u32 offset_lo, u32 offset_hi,
 		       u32 len_lo, u32 len_hi, int advice);
 long sys_flush_cache(void);
-long sys_mmap(unsigned long addr, unsigned long len,
-	      unsigned long prot, unsigned long flags,
-	      unsigned long fd, unsigned long offset);
-long sys_mmap2(unsigned long addr, unsigned long len,
-	       unsigned long prot, unsigned long flags,
-	       unsigned long fd, unsigned long offset);
 
 #ifndef __tilegx__
 /* mm/fault.c */
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 824f230..c70ff14 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -502,7 +502,7 @@ int _sys_fork(struct pt_regs *regs)
 }
 
 int _sys_clone(unsigned long clone_flags, unsigned long newsp,
-	       int __user *parent_tidptr, int __user *child_tidptr,
+	       void __user *parent_tidptr, void __user *child_tidptr,
 	       struct pt_regs *regs)
 {
 	if (!newsp)
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 7ea85eb..45835cf 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -43,8 +43,8 @@
 /* Caller before callee in this file; other callee is in assembler */
 void do_signal(struct pt_regs *regs);
 
-int _sys_sigaltstack(const stack_t __user *uss,
-		     stack_t __user *uoss, struct pt_regs *regs)
+long _sys_sigaltstack(const stack_t __user *uss,
+                      stack_t __user *uoss, struct pt_regs *regs)
 {
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
index a3d982b..0427978 100644
--- a/arch/tile/kernel/sys.c
+++ b/arch/tile/kernel/sys.c
@@ -95,7 +95,7 @@ SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
  */
 SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags,
-		unsigned long, fd, unsigned long, offset)
+		unsigned long, fd, off_t, offset)
 {
 	if (offset & ((1 << PAGE_SHIFT) - 1))
 		return -EINVAL;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1e3cd5f..7f614ce 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -364,13 +364,9 @@ asmlinkage long sys_init_module(void __user *umod, unsigned long len,
 asmlinkage long sys_delete_module(const char __user *name_user,
 				unsigned int flags);
 
-asmlinkage long sys_rt_sigaction(int sig, const struct sigaction __user *act,
-				 struct sigaction __user *oact,
-				 size_t sigsetsize);
 asmlinkage long sys_rt_sigprocmask(int how, sigset_t __user *set,
 				sigset_t __user *oset, size_t sigsetsize);
 asmlinkage long sys_rt_sigpending(sigset_t __user *set, size_t sigsetsize);
-asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize);
 asmlinkage long sys_rt_sigtimedwait(const sigset_t __user *uthese,
 				siginfo_t __user *uinfo,
 				const struct timespec __user *uts,
-- 
1.6.5.2

