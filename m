Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2JPLZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:25:43 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37413 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab2JPLZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:25:40 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v3] compat: Generic compat_sys_sched_rr_get_interval implementation
Date: Tue, 16 Oct 2012 12:25:29 +0100
Message-Id: <1350386729-10640-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
X-OriginalArrivalTime: 16 Oct 2012 11:25:37.0351 (UTC) FILETIME=[F722DD70:01CDAB90]
X-MC-Unique: 112101612253708901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9GBPowu030862

This function is used by sparc, powerpc tile and arm64 for compat
support. The patch adds a generic implementation with a wrapper for
PowerPC to do the u32->int sign extension.

The reason for a single patch covering powerpc, tile, sparc and arm64 is
to keep it bisectable, otherwise kernel building may fail with
mismatched function declarations.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>  [for tile]
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

Andrew, please consider merging this patch. I updated it to 3.7-rc1 to
fix the conflicts in the arm64 tree. Thanks.

 arch/arm64/include/asm/unistd.h   |  1 +
 arch/arm64/kernel/sys_compat.c    | 15 ---------------
 arch/powerpc/include/asm/systbl.h |  2 +-
 arch/powerpc/include/asm/unistd.h |  1 +
 arch/powerpc/kernel/sys_ppc32.c   | 17 ++++-------------
 arch/sparc/include/asm/unistd.h   |  1 +
 arch/sparc/kernel/sys_sparc32.c   | 14 --------------
 arch/tile/include/asm/compat.h    |  2 --
 arch/tile/include/asm/unistd.h    |  1 +
 arch/tile/kernel/compat.c         | 18 ------------------
 include/linux/compat.h            |  3 +++
 kernel/compat.c                   | 17 +++++++++++++++++
 12 files changed, 29 insertions(+), 63 deletions(-)

diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 63f853f..0f13ca8 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -25,5 +25,6 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #endif
 #include <uapi/asm/unistd.h>
diff --git a/arch/arm64/kernel/sys_compat.c b/arch/arm64/kernel/sys_compat.c
index 906e3bd..fd8ae6e 100644
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -67,21 +67,6 @@ out:
 	return error;
 }
 
-asmlinkage int compat_sys_sched_rr_get_interval(compat_pid_t pid,
-						struct compat_timespec __user *interval)
-{
-	struct timespec t;
-	int ret;
-	mm_segment_t old_fs = get_fs();
-
-	set_fs(KERNEL_DS);
-	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
-	set_fs(old_fs);
-	if (put_compat_timespec(&t, interval))
-		return -EFAULT;
-	return ret;
-}
-
 static inline void
 do_compat_cache_op(unsigned long start, unsigned long end, int flags)
 {
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 8408387..cec8aae 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -164,7 +164,7 @@ COMPAT_SYS_SPU(sched_getscheduler)
 SYSCALL_SPU(sched_yield)
 COMPAT_SYS_SPU(sched_get_priority_max)
 COMPAT_SYS_SPU(sched_get_priority_min)
-COMPAT_SYS_SPU(sched_rr_get_interval)
+SYSX_SPU(sys_sched_rr_get_interval,compat_sys_sched_rr_get_interval_wrapper,sys_sched_rr_get_interval)
 COMPAT_SYS_SPU(nanosleep)
 SYSCALL_SPU(mremap)
 SYSCALL_SPU(setresuid)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 921dce6..b4bf767 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -54,6 +54,7 @@
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_SYS_NEWFSTATAT
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #endif
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_KERNEL_EXECVE
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 9c2ed90..8a93778 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -175,19 +175,10 @@ asmlinkage long compat_sys_prctl(u32 option, u32 arg2, u32 arg3, u32 arg4, u32 a
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sched_rr_get_interval(u32 pid, struct compat_timespec __user *interval)
-{
-	struct timespec t;
-	int ret;
-	mm_segment_t old_fs = get_fs ();
-
-	/* The __user pointer cast is valid because of the set_fs() */
-	set_fs (KERNEL_DS);
-	ret = sys_sched_rr_get_interval((int)pid, (struct timespec __user *) &t);
-	set_fs (old_fs);
-	if (put_compat_timespec(&t, interval))
-		return -EFAULT;
-	return ret;
+asmlinkage long compat_sys_sched_rr_get_interval_wrapper(u32 pid,
+							 struct compat_timespec __user *interval)
+{
+	return compat_sys_sched_rr_get_interval((int)pid, interval);
 }
 
 /* Note: it is necessary to treat mode as an unsigned int,
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
index 0ecea6e..87ce24c 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -45,6 +45,7 @@
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #endif
 
 /*
diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
index c323981..b5873ba 100644
--- a/arch/sparc/kernel/sys_sparc32.c
+++ b/arch/sparc/kernel/sys_sparc32.c
@@ -211,20 +211,6 @@ asmlinkage long compat_sys_sysfs(int option, u32 arg1, u32 arg2)
 	return sys_sysfs(option, arg1, arg2);
 }
 
-asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid, struct compat_timespec __user *interval)
-{
-	struct timespec t;
-	int ret;
-	mm_segment_t old_fs = get_fs ();
-	
-	set_fs (KERNEL_DS);
-	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *) &t);
-	set_fs (old_fs);
-	if (put_compat_timespec(&t, interval))
-		return -EFAULT;
-	return ret;
-}
-
 asmlinkage long compat_sys_rt_sigprocmask(int how,
 					  compat_sigset_t __user *set,
 					  compat_sigset_t __user *oset,
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index 3063e6f..06568a9 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -300,8 +300,6 @@ long compat_sys_sync_file_range2(int fd, unsigned int flags,
 long compat_sys_fallocate(int fd, int mode,
 			  u32 offset_lo, u32 offset_hi,
 			  u32 len_lo, u32 len_hi);
-long compat_sys_sched_rr_get_interval(compat_pid_t pid,
-				      struct compat_timespec __user *interval);
 
 /* These are the intvec_64.S trampolines. */
 long _compat_sys_execve(const char __user *path,
diff --git a/arch/tile/include/asm/unistd.h b/arch/tile/include/asm/unistd.h
index 6e032a0..359b45b 100644
--- a/arch/tile/include/asm/unistd.h
+++ b/arch/tile/include/asm/unistd.h
@@ -14,6 +14,7 @@
 /* In compat mode, we use sys_llseek() for compat_sys_llseek(). */
 #ifdef CONFIG_COMPAT
 #define __ARCH_WANT_SYS_LLSEEK
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #endif
 #define __ARCH_WANT_SYS_NEWFSTATAT
 #include <uapi/asm/unistd.h>
diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
index d67459b..ef5ab9d 100644
--- a/arch/tile/kernel/compat.c
+++ b/arch/tile/kernel/compat.c
@@ -76,24 +76,6 @@ long compat_sys_fallocate(int fd, int mode,
 			     ((loff_t)len_hi << 32) | len_lo);
 }
 
-
-
-long compat_sys_sched_rr_get_interval(compat_pid_t pid,
-				      struct compat_timespec __user *interval)
-{
-	struct timespec t;
-	int ret;
-	mm_segment_t old_fs = get_fs();
-
-	set_fs(KERNEL_DS);
-	ret = sys_sched_rr_get_interval(pid,
-					(struct timespec __force __user *)&t);
-	set_fs(old_fs);
-	if (put_compat_timespec(&t, interval))
-		return -EFAULT;
-	return ret;
-}
-
 /* Provide the compat syscall number to call mapping. */
 #undef __SYSCALL
 #define __SYSCALL(nr, call) [nr] = (call),
diff --git a/include/linux/compat.h b/include/linux/compat.h
index d0ced10..30840c5 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -592,6 +592,9 @@ asmlinkage ssize_t compat_sys_process_vm_writev(compat_pid_t pid,
 asmlinkage long compat_sys_sendfile(int out_fd, int in_fd,
 				    compat_off_t __user *offset, compat_size_t count);
 
+asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
+						 struct compat_timespec __user *interval);
+
 #else
 
 #define is_compat_task() (0)
diff --git a/kernel/compat.c b/kernel/compat.c
index c28a306..f6150e9 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -1215,6 +1215,23 @@ compat_sys_sysinfo(struct compat_sysinfo __user *info)
 	return 0;
 }
 
+#ifdef __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
+asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
+						 struct compat_timespec __user *interval)
+{
+	struct timespec t;
+	int ret;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(KERNEL_DS);
+	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
+	set_fs(old_fs);
+	if (put_compat_timespec(&t, interval))
+		return -EFAULT;
+	return ret;
+}
+#endif /* __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL */
+
 /*
  * Allocate user-space memory for the duration of a single system call,
  * in order to marshall parameters inside a compat thunk.

