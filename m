Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0E2DeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:34:04 -0400
Received: from king.tilera.com ([72.1.168.226]:16055 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab0E2Ddx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:33:53 -0400
Message-Id: <201005290333.o4T3XoVB029926@farm-0002.internal.tilera.com>
In-Reply-To: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 28 May 2010 23:01:00 -0400
Subject: [PATCH 1/8] Fix up the "generic" unistd.h ABI to be more useful.
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org
X-OriginalArrivalTime: 29 May 2010 03:33:51.0249 (UTC) FILETIME=[C1963810:01CAFEDF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reserve 16 "architecture-specific" syscall numbers starting at 244.

Allow use of the sys_sync_file_range2() API with the generic unistd.h
by specifying __ARCH_WANT_SYNC_FILE_RANGE2 before including it.

Allow using the generic unistd.h to create the "compat" syscall table
by specifying __SYSCALL_COMPAT before including it.

Use sys_fadvise64_64 for __NR3264_fadvise64 in both 32- and 64-bit mode.

Request the appropriate __ARCH_WANT_COMPAT_SYS_xxx values when
some deprecated syscall modes are selected.

As part of this change to fix up the syscalls, also provide a couple
of missing signal-related syscall prototypes in <linux/syscalls.h>.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 include/asm-generic/unistd.h |   26 ++++++++++++++++++++------
 include/linux/syscalls.h     |    4 ++++
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 6a0b30f..30218b4 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -18,7 +18,7 @@
 #define __SYSCALL(x, y)
 #endif
 
-#if __BITS_PER_LONG == 32
+#if __BITS_PER_LONG == 32 || defined(__SYSCALL_COMPAT)
 #define __SC_3264(_nr, _32, _64) __SYSCALL(_nr, _32)
 #else
 #define __SC_3264(_nr, _32, _64) __SYSCALL(_nr, _64)
@@ -241,8 +241,13 @@ __SYSCALL(__NR_sync, sys_sync)
 __SYSCALL(__NR_fsync, sys_fsync)
 #define __NR_fdatasync 83
 __SYSCALL(__NR_fdatasync, sys_fdatasync)
+#ifdef __ARCH_WANT_SYNC_FILE_RANGE2
+#define __NR_sync_file_range2 84
+__SYSCALL(__NR_sync_file_range2, sys_sync_file_range2)
+#else
 #define __NR_sync_file_range 84
-__SYSCALL(__NR_sync_file_range, sys_sync_file_range) /* .long sys_sync_file_range2, */
+__SYSCALL(__NR_sync_file_range, sys_sync_file_range)
+#endif
 
 /* fs/timerfd.c */
 #define __NR_timerfd_create 85
@@ -580,7 +585,7 @@ __SYSCALL(__NR_execve, sys_execve)	/* .long sys_execve_wrapper */
 __SC_3264(__NR3264_mmap, sys_mmap2, sys_mmap)
 /* mm/fadvise.c */
 #define __NR3264_fadvise64 223
-__SC_3264(__NR3264_fadvise64, sys_fadvise64_64, sys_fadvise64)
+__SYSCALL(__NR3264_fadvise64, sys_fadvise64_64)
 
 /* mm/, CONFIG_MMU only */
 #ifndef __ARCH_NOMMU
@@ -627,8 +632,14 @@ __SYSCALL(__NR_accept4, sys_accept4)
 #define __NR_recvmmsg 243
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
 
+/*
+ * Architectures may provide up to 16 syscalls of their own
+ * starting with this value.
+ */
+#define __NR_arch_specific_syscall 244
+
 #undef __NR_syscalls
-#define __NR_syscalls 244
+#define __NR_syscalls 260
 
 /*
  * All syscalls below here should go away really,
@@ -694,7 +705,8 @@ __SYSCALL(__NR_signalfd, sys_signalfd)
 #define __NR_syscalls (__NR_signalfd+1)
 #endif /* __ARCH_WANT_SYSCALL_NO_FLAGS */
 
-#if __BITS_PER_LONG == 32 && defined(__ARCH_WANT_SYSCALL_OFF_T)
+#if (__BITS_PER_LONG == 32 || defined(__SYSCALL_COMPAT)) && \
+     defined(__ARCH_WANT_SYSCALL_OFF_T)
 #define __NR_sendfile 1046
 __SYSCALL(__NR_sendfile, sys_sendfile)
 #define __NR_ftruncate 1047
@@ -740,6 +752,7 @@ __SYSCALL(__NR_getpgrp, sys_getpgrp)
 __SYSCALL(__NR_pause, sys_pause)
 #define __NR_time 1062
 #define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_COMPAT_SYS_TIME
 __SYSCALL(__NR_time, sys_time)
 #define __NR_utime 1063
 #define __ARCH_WANT_SYS_UTIME
@@ -801,7 +814,7 @@ __SYSCALL(__NR_fork, sys_ni_syscall)
  * Here we map the numbers so that both versions
  * use the same syscall table layout.
  */
-#if __BITS_PER_LONG == 64
+#if __BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)
 #define __NR_fcntl __NR3264_fcntl
 #define __NR_statfs __NR3264_statfs
 #define __NR_fstatfs __NR3264_fstatfs
@@ -848,6 +861,7 @@ __SYSCALL(__NR_fork, sys_ni_syscall)
 #endif
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 
 /*
  * "Conditional" syscalls
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 057929b..d39ddb3 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -387,9 +387,13 @@ asmlinkage long sys_init_module(void __user *umod, unsigned long len,
 asmlinkage long sys_delete_module(const char __user *name_user,
 				unsigned int flags);
 
+asmlinkage long sys_rt_sigaction(int sig, const struct sigaction __user *act,
+				 struct sigaction __user *oact,
+				 size_t sigsetsize);
 asmlinkage long sys_rt_sigprocmask(int how, sigset_t __user *set,
 				sigset_t __user *oset, size_t sigsetsize);
 asmlinkage long sys_rt_sigpending(sigset_t __user *set, size_t sigsetsize);
+asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize);
 asmlinkage long sys_rt_sigtimedwait(const sigset_t __user *uthese,
 				siginfo_t __user *uinfo,
 				const struct timespec __user *uts,
-- 
1.6.5.2

