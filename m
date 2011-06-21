Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab1FUTQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 15:16:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48849 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab1FUTQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 15:16:37 -0400
Date: Tue, 21 Jun 2011 20:16:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>, mikpe@it.uu.se,
        ebiederm@xmission.com, vapier@gentoo.org, tony.luck@intel.com
Subject: Re: [PATCH] ARM: quiet sparse noise due to
	__ARCH_WANT_SYS_RT_SIG(ACTION|SUSPEND)
Message-ID: <20110621191624.GK23234@n2100.arm.linux.org.uk>
References: <201106211209.46462.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106211209.46462.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 12:09:45PM -0700, H Hartley Sweeten wrote:
> ARM defines __ARCH_WANT_SYS_RT_SIG(ACTION|SUSPEND) which
> produces the following sparse warnings in kernel/signal.c:
> 
>   warning: symbol 'sys_rt_sigaction' was not declared. Should it be static?
>   warning: symbol 'sys_rt_sigsuspend' was not declared. Should it be static?
> 
> Since ARM doesn't include <asm-generic/syscalls.h>, due to different
> calling conventions for some system calls, prototype the functions
> in <asm/unistd.h> to quiet the noise.

NAK.

asm/unistd.h is an exported header.  Please don't pollute it with kernel
internal stuff.  Instead, follow the hint in asm-generic and create a new
header file to describe syscalls called... asm/syscalls.h.

And.. the problem is a lot larger than you mention above:

    arch/arm/kernel/signal.c:68:16: warning: symbol 'sys_sigsuspend' was not declared. Should it be static?
    arch/arm/kernel/signal.c:84:1: warning: symbol 'sys_sigaction' was not declared. Should it be static?
    arch/arm/kernel/signal.c:328:16: warning: symbol 'sys_sigreturn' was not declared. Should it be static?
    arch/arm/kernel/signal.c:360:16: warning: symbol 'sys_rt_sigreturn' was not declared. Should it be static?
    arch/arm/kernel/sys_arm.c:34:16: warning: symbol 'sys_fork' was not declared. Should it be static?
    arch/arm/kernel/sys_arm.c:47:16: warning: symbol 'sys_clone' was not declared. Should it be static?
    arch/arm/kernel/sys_arm.c:57:16: warning: symbol 'sys_vfork' was not declared. Should it be static?
    arch/arm/kernel/sys_arm.c:65:16: warning: symbol 'sys_execve' was not declared. Should it be static?
    arch/arm/kernel/sys_arm.c:129:17: warning: symbol 'sys_arm_fadvise64_64' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:144:17: warning: symbol 'sys_oabi_stat64' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:154:17: warning: symbol 'sys_oabi_lstat64' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:164:17: warning: symbol 'sys_oabi_fstat64' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:174:17: warning: symbol 'sys_oabi_fstatat64' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:196:17: warning: symbol 'sys_oabi_fcntl64' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:249:17: warning: symbol 'sys_oabi_epoll_ctl' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:270:17: warning: symbol 'sys_oabi_epoll_wait' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:304:17: warning: symbol 'sys_oabi_semtimedop' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:343:17: warning: symbol 'sys_oabi_semop' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:349:16: warning: symbol 'sys_oabi_ipc' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:367:17: warning: symbol 'sys_oabi_bind' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:377:17: warning: symbol 'sys_oabi_connect' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:387:17: warning: symbol 'sys_oabi_sendto' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:400:17: warning: symbol 'sys_oabi_sendmsg' was not declared. Should it be static?
    arch/arm/kernel/sys_oabi-compat.c:426:17: warning: symbol 'sys_oabi_socketcall' was not declared. Should it be static?
    arch/arm/kernel/traps.c:464:16: warning: symbol 'arm_syscall' was not declared. Should it be static?

So you actually need something like this (pasted, so whitespace
damaged).  I'll pull it out of my low priority queue and queue it up
for the next merge window.

diff --git a/arch/arm/include/asm/syscalls.h b/arch/arm/include/asm/syscalls.h
new file mode 100644
index 0000000..e775746
--- /dev/null
+++ b/arch/arm/include/asm/syscalls.h
@@ -0,0 +1,60 @@
+#ifndef _ASM_ARM_SYSCALLS_H
+#define _ASM_ARM_SYSCALLS_H
+
+#include <linux/linkage.h>
+#include <linux/types.h>
+
+struct msghdr;
+struct sockaddr;
+
+/* arch/arm/kernel/signal.c */
+asmlinkage int sys_sigsuspend(int, unsigned long, old_sigset_t);
+asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
+             struct old_sigaction __user *);
+asmlinkage int sys_sigreturn(struct pt_regs *);
+asmlinkage int sys_rt_sigreturn(struct pt_regs *);
+
+/* arch/arm/kernel/sys_arm.c */
+asmlinkage int sys_fork(struct pt_regs *);
+asmlinkage int sys_clone(unsigned long, unsigned long, int __user *, int,
+                        int __user *, struct pt_regs *);
+asmlinkage int sys_vfork(struct pt_regs *);
+asmlinkage int sys_execve(const char __user *,
+                         const char __user *const __user *,
+                         const char __user *const __user *, struct pt_regs *);
+asmlinkage long sys_arm_fadvise64_64(int, int, loff_t, loff_t);
+
+/* arch/arm/kernel/sys_oabi-compat.c */
+struct oldabi_stat64;
+asmlinkage long sys_oabi_stat64(const char __user *,
+                               struct oldabi_stat64 __user *);
+asmlinkage long sys_oabi_lstat64(const char __user *,
+                                struct oldabi_stat64 __user *);
+asmlinkage long sys_oabi_fstat64(unsigned long, struct oldabi_stat64 __user *);+asmlinkage long sys_oabi_fstatat64(int, const char __user *,
+                                  struct oldabi_stat64  __user *, int);
+asmlinkage long sys_oabi_fcntl64(unsigned int, unsigned int, unsigned long);
+
+struct oabi_epoll_event;
+asmlinkage long sys_oabi_epoll_ctl(int, int, int,
+                                  struct oabi_epoll_event __user *);
+asmlinkage long sys_oabi_epoll_wait(int, struct oabi_epoll_event __user *,
+                                   int, int);
+
+struct oabi_sembuf;
+asmlinkage long sys_oabi_semtimedop(int, struct oabi_sembuf __user *, unsigned,+                                   const struct timespec __user *);
+asmlinkage long sys_oabi_semop(int, struct oabi_sembuf __user *,
+                              unsigned);
+asmlinkage int sys_oabi_ipc(uint, int, int, int, void __user *, long);
+asmlinkage long sys_oabi_bind(int, struct sockaddr __user *, int);
+asmlinkage long sys_oabi_connect(int, struct sockaddr __user *, int);
+asmlinkage long sys_oabi_sendto(int, void __user *, size_t, unsigned,
+                               struct sockaddr __user *, int);
+asmlinkage long sys_oabi_sendmsg(int, struct msghdr __user *, unsigned);
+asmlinkage long sys_oabi_socketcall(int, unsigned long __user *);
+
+/* arch/arm/kernel/traps.c */
+asmlinkage int arm_syscall(int, struct pt_regs *);
+
+#endif
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 0340224..9498fb5 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -16,6 +16,7 @@

 #include <asm/elf.h>
 #include <asm/cacheflush.h>
+#include <asm/syscalls.h>
 #include <asm/ucontext.h>
 #include <asm/unistd.h>
 #include <asm/vfp.h>
diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index 62e7c61..5bda298 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -28,6 +28,8 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>

+#include <asm/syscalls.h>
+
 /* Fork a new task - this creates a new program thread.
  * This is called indirectly via a small wrapper
  */
diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index af0aaeb..e71a41c 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -85,6 +85,8 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>

+#include <asm/syscalls.h>
+
 struct oldabi_stat64 {
        unsigned long long st_dev;
        unsigned int    __pad1;
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index d52eec2..d040421 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -27,6 +27,7 @@

 #include <asm/atomic.h>
 #include <asm/cacheflush.h>
+#include <asm/syscalls.h>
 #include <asm/system.h>
 #include <asm/unistd.h>
 #include <asm/traps.h>

