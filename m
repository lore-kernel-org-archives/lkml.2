Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab2IRRDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:03:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62527 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374Ab2IRRDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:03:04 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] compat: Generic compat_sys_sched_rr_get_interval implementation
Date: Tue, 18 Sep 2012 18:02:07 +0100
Message-Id: <1347987727-13739-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is used by sparc, powerpc tile and arm64 for compat
support. The patch adds a generic implementation with a wrapper for
PowerPC to do the u32->int sign extension.

The reason for a single patch covering powerpc, tile and sparc is to
keep it bisectable, otherwise kernel building may fail with mismatched
function declarations.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

Please note that the patch has only been compile-tested on sparc, tile
and powerpc (run-time tested on arm64).

 arch/powerpc/include/asm/systbl.h |    2 +-
 arch/powerpc/include/asm/unistd.h |    1 +
 arch/powerpc/kernel/sys_ppc32.c   |   17 ++++-------------
 arch/sparc/include/asm/unistd.h   |    1 +
 arch/sparc/kernel/sys_sparc32.c   |   14 --------------
 arch/tile/include/asm/compat.h    |    2 --
 arch/tile/include/asm/unistd.h    |    1 +
 arch/tile/kernel/compat.c         |   18 ------------------
 include/linux/compat.h            |    3 +++
 kernel/compat.c                   |   17 +++++++++++++++++
 10 files changed, 28 insertions(+), 48 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 8fb2429..b5a2fbd 100644
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
index c683fa3..bd52cb3 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -420,6 +420,7 @@
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_SYS_NEWFSTATAT
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #endif
 
 /*
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index abd1112..f369e7b 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -197,19 +197,10 @@ asmlinkage long compat_sys_prctl(u32 option, u32 arg2, u32 arg3, u32 arg4, u32 a
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
index d9a677c..bba519b 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -448,6 +448,7 @@
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #endif
 
 /*
diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
index d862499..dc1daaa 100644
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
index 6e74450..fec9ae6 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -238,8 +238,6 @@ long compat_sys_sync_file_range2(int fd, unsigned int flags,
 long compat_sys_fallocate(int fd, int mode,
 			  u32 offset_lo, u32 offset_hi,
 			  u32 len_lo, u32 len_hi);
-long compat_sys_sched_rr_get_interval(compat_pid_t pid,
-				      struct compat_timespec __user *interval);
 
 /* These are the intvec_64.S trampolines. */
 long _compat_sys_execve(const char __user *path,
diff --git a/arch/tile/include/asm/unistd.h b/arch/tile/include/asm/unistd.h
index a017246..52e0540 100644
--- a/arch/tile/include/asm/unistd.h
+++ b/arch/tile/include/asm/unistd.h
@@ -40,6 +40,7 @@ __SYSCALL(__NR_cmpxchg_badaddr, sys_cmpxchg_badaddr)
 /* In compat mode, we use sys_llseek() for compat_sys_llseek(). */
 #ifdef CONFIG_COMPAT
 #define __ARCH_WANT_SYS_LLSEEK
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #endif
 #define __ARCH_WANT_SYS_NEWFSTATAT
 #endif
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
index fd4e299..68a010b 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -593,6 +593,9 @@ asmlinkage ssize_t compat_sys_process_vm_writev(compat_pid_t pid,
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
