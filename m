Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2IMJIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:08:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42830 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503Ab2IMJIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:08:32 -0400
Date: Thu, 13 Sep 2012 10:07:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 21/31] arm64: 32-bit (compat) applications support
Message-ID: <20120913090732.GA25131@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-22-git-send-email-catalin.marinas@arm.com>
 <201209071947.45313.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209071947.45313.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 08:47:45PM +0100, Arnd Bergmann wrote:
> On Friday 07 September 2012, Catalin Marinas wrote:
> > 
> > From: Will Deacon <will.deacon@arm.com>
> > 
> > This patch adds support for 32-bit applications. The vectors page is a
> > binary blob mapped into the application user space at 0xffff0000 (the
> > AArch64 toolchain does not support compilation of AArch32 code). Full
> > compatibility with ARMv7 user space is supported. The use of deprecated
> > ARMv7 functionality (SWP, CP15 barriers) has been disabled by default on
> > AArch64 kernels and unaligned LDM/STM is not supported.
> > 
> > Please note that only the ARM 32-bit EABI is supported, so no OABI
> > compatibility.
> > 
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Acked-by: Tony Lindgren <tony@atomide.com>
> 
> I guess you haven't had time to turn any of these into architecture
> independent functions as discussed last time?

Here they are. For converting the other architectures, I'll post
separate patches as I don't want to add an extra dependency to the
arm64 series.


>From 87fb5301a44ac05b4e6d7245db02acc2dedde831 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 13 Sep 2012 09:51:10 +0100
Subject: [PATCH 1/3] Add generic compat_sys_sendfile and
 compat_sys_sendfile64

These functions are used by other architectures requiring compat
support, so just make them generic.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/compat.h |    5 +++++
 kernel/compat.c        |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index c4be3f5..e2f5e9a 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -594,6 +594,11 @@ asmlinkage ssize_t compat_sys_process_vm_writev(compat_pid_t pid,
 		unsigned long liovcnt, const struct compat_iovec __user *rvec,
 		unsigned long riovcnt, unsigned long flags);
 
+asmlinkage int compat_sys_sendfile(int out_fd, int in_fd,
+				   compat_off_t __user *offset, s32 count);
+asmlinkage int compat_sys_sendfile64(int out_fd, int in_fd,
+				     compat_loff_t __user *offset, s32 count);
+
 #else
 
 #define is_compat_task() (0)
diff --git a/kernel/compat.c b/kernel/compat.c
index c28a306..5f07388 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -1215,6 +1215,50 @@ compat_sys_sysinfo(struct compat_sysinfo __user *info)
 	return 0;
 }
 
+#ifdef __ARCH_WANT_COMPAT_SYS_SENDFILE
+asmlinkage int compat_sys_sendfile(int out_fd, int in_fd,
+				   compat_off_t __user *offset, s32 count)
+{
+	mm_segment_t old_fs = get_fs();
+	int ret;
+	off_t of;
+
+	if (offset && get_user(of, offset))
+		return -EFAULT;
+
+	set_fs(KERNEL_DS);
+	ret = sys_sendfile(out_fd, in_fd,
+			   offset ? (off_t __user *)&of : NULL, count);
+	set_fs(old_fs);
+
+	if (offset && put_user(of, offset))
+		return -EFAULT;
+	return ret;
+}
+#endif /* __ARCH_WANT_COMPAT_SYS_SENDFILE */
+
+#ifdef __ARCH_WANT_COMPAT_SYS_SENDFILE64
+asmlinkage int compat_sys_sendfile64(int out_fd, int in_fd,
+				     compat_loff_t __user *offset, s32 count)
+{
+	mm_segment_t old_fs = get_fs();
+	int ret;
+	loff_t of;
+
+	if (offset && get_user(of, offset))
+		return -EFAULT;
+
+	set_fs(KERNEL_DS);
+	ret = sys_sendfile(out_fd, in_fd,
+			   offset ? (loff_t __user *)&of : NULL, count);
+	set_fs(old_fs);
+
+	if (offset && put_user(of, offset))
+		return -EFAULT;
+	return ret;
+}
+#endif /* __ARCH_WANT_COMPAT_SYS_SENDFILE64 */
+
 /*
  * Allocate user-space memory for the duration of a single system call,
  * in order to marshall parameters inside a compat thunk.


>From fa734f9523e35d7a6e9ab5e252ab344133111c1f Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 13 Sep 2012 09:55:17 +0100
Subject: [PATCH 2/3] Add generic compat_sys_sched_rr_get_interval
 implementation

This patch adds a generic implementation for
compat_sys_sched_rr_get_interval as it is used by other architectures.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/compat.h |    3 +++
 kernel/compat.c        |   17 +++++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index e2f5e9a..bbe89b8 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -599,6 +599,9 @@ asmlinkage int compat_sys_sendfile(int out_fd, int in_fd,
 asmlinkage int compat_sys_sendfile64(int out_fd, int in_fd,
 				     compat_loff_t __user *offset, s32 count);
 
+asmlinkage int compat_sys_sched_rr_get_interval(compat_pid_t pid,
+						struct compat_timespec __user *interval);
+
 #else
 
 #define is_compat_task() (0)
diff --git a/kernel/compat.c b/kernel/compat.c
index 5f07388..3961f67 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -1259,6 +1259,23 @@ asmlinkage int compat_sys_sendfile64(int out_fd, int in_fd,
 }
 #endif /* __ARCH_WANT_COMPAT_SYS_SENDFILE64 */
 
+#ifdef __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
+asmlinkage int compat_sys_sched_rr_get_interval(compat_pid_t pid,
+						struct compat_timespec __user *interval)
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


>From 79ed6c77bdd4480b81defe1cd81198235e9d4d03 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 13 Sep 2012 10:02:26 +0100
Subject: [PATCH 3/3] arm64: Use generic compat_sys_sendfile and
 compat_sys_sched_rr_get_interval

This patch switches the arm64 port to use the generic implementation of
the above functions.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/unistd32.h |    2 ++
 arch/arm64/kernel/sys_compat.c    |   35 -----------------------------------
 2 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index a50405f..4161b4c 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -754,5 +754,7 @@ __SYSCALL(__NR_syncfs, sys_syncfs)
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 
 #endif /* __ASM_UNISTD32_H */
diff --git a/arch/arm64/kernel/sys_compat.c b/arch/arm64/kernel/sys_compat.c
index d77ba8e..740485d 100644
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -51,41 +51,6 @@ asmlinkage int compat_sys_vfork(struct pt_regs *regs)
 		       regs, 0, NULL, NULL);
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
-asmlinkage int compat_sys_sendfile(int out_fd, int in_fd,
-				   compat_off_t __user *offset, s32 count)
-{
-	mm_segment_t old_fs = get_fs();
-	int ret;
-	off_t of;
-
-	if (offset && get_user(of, offset))
-		return -EFAULT;
-
-	set_fs(KERNEL_DS);
-	ret = sys_sendfile(out_fd, in_fd, offset ? (off_t __user *)&of : NULL,
-			   count);
-	set_fs(old_fs);
-
-	if (offset && put_user(of, offset))
-		return -EFAULT;
-	return ret;
-}
-
 static inline void
 do_compat_cache_op(unsigned long start, unsigned long end, int flags)
 {

-- 
Catalin
