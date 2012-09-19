Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2ISLCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:02:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37525 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168Ab2ISLCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:02:49 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2] compat: fs: Generic compat_sys_sendfile implementation
Date: Wed, 19 Sep 2012 12:01:52 +0100
Message-Id: <1348052512-15538-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is used by sparc, powerpc and arm64 for compat support.
The patch adds a generic implementation which calls do_sendfile()
directly and avoids set_fs().

The sparc architecture has wrappers for the sign extensions while
powerpc relies on the compiler to do the this. The patch adds wrappers
for powerpc to handle the u32->int type conversion.

compat_sys_sendfile64() can be replaced by a sys_sendfile() call since
compat_loff_t has the same size as off_t on a 64-bit system.

On powerpc, the patch also changes the 64-bit sendfile call from
sys_sendile64 to sys_sendfile.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

Changes from the first version:
- PowerPC fixed for 32-bit mode.
- PowerPC 64-bit __NR_sendfile routed to sys_sendfile() rather than
  sys_sendfile64().

 arch/powerpc/include/asm/systbl.h |    4 +-
 arch/powerpc/include/asm/unistd.h |    1 +
 arch/powerpc/kernel/sys_ppc32.c   |   45 +++++------------------------------
 arch/sparc/include/asm/unistd.h   |    1 +
 arch/sparc/kernel/sys32.S         |    2 +-
 arch/sparc/kernel/sys_sparc32.c   |   46 -------------------------------------
 fs/compat.c                       |   22 +++++++++++++++++
 fs/read_write.c                   |    4 +-
 fs/read_write.h                   |    2 +
 include/linux/compat.h            |    3 ++
 10 files changed, 41 insertions(+), 89 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 559ae1e..8408387 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -189,7 +189,7 @@ SYSCALL_SPU(getcwd)
 SYSCALL_SPU(capget)
 SYSCALL_SPU(capset)
 COMPAT_SYS(sigaltstack)
-SYSX_SPU(sys_sendfile64,compat_sys_sendfile,sys_sendfile)
+SYSX_SPU(sys_sendfile,compat_sys_sendfile_wrapper,sys_sendfile)
 SYSCALL(ni_syscall)
 SYSCALL(ni_syscall)
 PPC_SYS(vfork)
@@ -229,7 +229,7 @@ COMPAT_SYS_SPU(sched_setaffinity)
 COMPAT_SYS_SPU(sched_getaffinity)
 SYSCALL(ni_syscall)
 SYSCALL(ni_syscall)
-SYS32ONLY(sendfile64)
+SYSX(sys_ni_syscall,compat_sys_sendfile64_wrapper,sys_sendfile64)
 COMPAT_SYS_SPU(io_setup)
 SYSCALL_SPU(io_destroy)
 COMPAT_SYS_SPU(io_getevents)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index bd377a3..c683fa3 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -419,6 +419,7 @@
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_SYS_NEWFSTATAT
+#define __ARCH_WANT_COMPAT_SYS_SENDFILE
 #endif
 
 /*
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 81c5706..abd1112 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -143,48 +143,17 @@ long compat_sys_ipc(u32 call, u32 first, u32 second, u32 third, compat_uptr_t pt
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sendfile(u32 out_fd, u32 in_fd, compat_off_t __user * offset, u32 count)
+asmlinkage long compat_sys_sendfile_wrapper(u32 out_fd, u32 in_fd,
+					    compat_off_t __user *offset, u32 count)
 {
-	mm_segment_t old_fs = get_fs();
-	int ret;
-	off_t of;
-	off_t __user *up;
-
-	if (offset && get_user(of, offset))
-		return -EFAULT;
-
-	/* The __user pointer cast is valid because of the set_fs() */		
-	set_fs(KERNEL_DS);
-	up = offset ? (off_t __user *) &of : NULL;
-	ret = sys_sendfile((int)out_fd, (int)in_fd, up, count);
-	set_fs(old_fs);
-	
-	if (offset && put_user(of, offset))
-		return -EFAULT;
-		
-	return ret;
+	return compat_sys_sendfile((int)out_fd, (int)in_fd, offset, count);
 }
 
-asmlinkage int compat_sys_sendfile64(int out_fd, int in_fd, compat_loff_t __user *offset, s32 count)
+asmlinkage long compat_sys_sendfile64_wrapper(u32 out_fd, u32 in_fd,
+					      compat_loff_t __user *offset, u32 count)
 {
-	mm_segment_t old_fs = get_fs();
-	int ret;
-	loff_t lof;
-	loff_t __user *up;
-	
-	if (offset && get_user(lof, offset))
-		return -EFAULT;
-		
-	/* The __user pointer cast is valid because of the set_fs() */		
-	set_fs(KERNEL_DS);
-	up = offset ? (loff_t __user *) &lof : NULL;
-	ret = sys_sendfile64(out_fd, in_fd, up, count);
-	set_fs(old_fs);
-	
-	if (offset && put_user(lof, offset))
-		return -EFAULT;
-		
-	return ret;
+	return sys_sendfile((int)out_fd, (int)in_fd,
+			    (off_t __user *)offset, count);
 }
 
 long compat_sys_execve(unsigned long a0, unsigned long a1, unsigned long a2,
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
index fb26934..d9a677c 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -447,6 +447,7 @@
 #else
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_COMPAT_SYS_SENDFILE
 #endif
 
 /*
diff --git a/arch/sparc/kernel/sys32.S b/arch/sparc/kernel/sys32.S
index d97f3eb..44025f4 100644
--- a/arch/sparc/kernel/sys32.S
+++ b/arch/sparc/kernel/sys32.S
@@ -90,7 +90,7 @@ SIGN1(sys32_mkdir, sys_mkdir, %o1)
 SIGN3(sys32_futex, compat_sys_futex, %o1, %o2, %o5)
 SIGN1(sys32_sysfs, compat_sys_sysfs, %o0)
 SIGN2(sys32_sendfile, compat_sys_sendfile, %o0, %o1)
-SIGN2(sys32_sendfile64, compat_sys_sendfile64, %o0, %o1)
+SIGN2(sys32_sendfile64, sys_sendfile, %o0, %o1)
 SIGN1(sys32_prctl, sys_prctl, %o0)
 SIGN1(sys32_sched_rr_get_interval, compat_sys_sched_rr_get_interval, %o0)
 SIGN2(sys32_waitpid, sys_waitpid, %o0, %o2)
diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
index f739233..d862499 100644
--- a/arch/sparc/kernel/sys_sparc32.c
+++ b/arch/sparc/kernel/sys_sparc32.c
@@ -506,52 +506,6 @@ long compat_sys_fadvise64_64(int fd,
 				advice);
 }
 
-asmlinkage long compat_sys_sendfile(int out_fd, int in_fd,
-				    compat_off_t __user *offset,
-				    compat_size_t count)
-{
-	mm_segment_t old_fs = get_fs();
-	int ret;
-	off_t of;
-	
-	if (offset && get_user(of, offset))
-		return -EFAULT;
-		
-	set_fs(KERNEL_DS);
-	ret = sys_sendfile(out_fd, in_fd,
-			   offset ? (off_t __user *) &of : NULL,
-			   count);
-	set_fs(old_fs);
-	
-	if (offset && put_user(of, offset))
-		return -EFAULT;
-		
-	return ret;
-}
-
-asmlinkage long compat_sys_sendfile64(int out_fd, int in_fd,
-				      compat_loff_t __user *offset,
-				      compat_size_t count)
-{
-	mm_segment_t old_fs = get_fs();
-	int ret;
-	loff_t lof;
-	
-	if (offset && get_user(lof, offset))
-		return -EFAULT;
-		
-	set_fs(KERNEL_DS);
-	ret = sys_sendfile64(out_fd, in_fd,
-			     offset ? (loff_t __user *) &lof : NULL,
-			     count);
-	set_fs(old_fs);
-	
-	if (offset && put_user(lof, offset))
-		return -EFAULT;
-		
-	return ret;
-}
-
 /* This is just a version for 32-bit applications which does
  * not force O_LARGEFILE on.
  */
diff --git a/fs/compat.c b/fs/compat.c
index 1bdb350..a241da9 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1802,3 +1802,25 @@ compat_sys_open_by_handle_at(int mountdirfd,
 	return do_handle_open(mountdirfd, handle, flags);
 }
 #endif
+
+#ifdef __ARCH_WANT_COMPAT_SYS_SENDFILE
+asmlinkage long compat_sys_sendfile(int out_fd, int in_fd,
+				    compat_off_t __user *offset, compat_size_t count)
+{
+	loff_t pos;
+	off_t off;
+	ssize_t ret;
+
+	if (offset) {
+		if (unlikely(get_user(off, offset)))
+			return -EFAULT;
+		pos = off;
+		ret = do_sendfile(out_fd, in_fd, &pos, count, MAX_NON_LFS);
+		if (unlikely(put_user(pos, offset)))
+			return -EFAULT;
+		return ret;
+	}
+
+	return do_sendfile(out_fd, in_fd, NULL, count, 0);
+}
+#endif /* __ARCH_WANT_COMPAT_SYS_SENDFILE */
diff --git a/fs/read_write.c b/fs/read_write.c
index 1adfb69..d8e88fe 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -884,8 +884,8 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 	return ret;
 }
 
-static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
-			   size_t count, loff_t max)
+ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos, size_t count,
+		    loff_t max)
 {
 	struct file * in_file, * out_file;
 	struct inode * in_inode, * out_inode;
diff --git a/fs/read_write.h b/fs/read_write.h
index d07b954..d3e00ef 100644
--- a/fs/read_write.h
+++ b/fs/read_write.h
@@ -12,3 +12,5 @@ ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 		unsigned long nr_segs, size_t len, loff_t *ppos, iov_fn_t fn);
 ssize_t do_loop_readv_writev(struct file *filp, struct iovec *iov,
 		unsigned long nr_segs, loff_t *ppos, io_fn_t fn);
+ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos, size_t count,
+		    loff_t max);
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 09b28b7..fd4e299 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -590,6 +590,9 @@ asmlinkage ssize_t compat_sys_process_vm_writev(compat_pid_t pid,
 		unsigned long liovcnt, const struct compat_iovec __user *rvec,
 		unsigned long riovcnt, unsigned long flags);
 
+asmlinkage long compat_sys_sendfile(int out_fd, int in_fd,
+				    compat_off_t __user *offset, compat_size_t count);
+
 #else
 
 #define is_compat_task() (0)
