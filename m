Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab0FWKE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:58 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50643 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0FWKEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:46 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       David Howells <dhowells@redhat.com>,
       Chase Douglas <cndougla@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 35/40] trace syscalls, PPC: Convert PPC syscalls without long return types
Date: Wed, 23 Jun 2010 20:03:16 +1000
Message-Id: <1277287401-28571-36-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch converts the PowerPC system calls with return types other
than long to use the various *SYSCALL_DEFINEx_RET family of macros so
their metadata is recorded for tracing.

This patch also renamed the ppc_rtas syscall to sys_rtas to fit in with
the naming convention of the SYSCALL_DEFINE macros.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/syscalls.h |    2 +-
 arch/powerpc/include/asm/systbl.h   |    4 ++--
 arch/powerpc/kernel/rtas.c          |    2 +-
 arch/powerpc/kernel/sys_ppc32.c     |   33 +++++++++++++++++++--------------
 arch/powerpc/kernel/syscalls.c      |   12 ++++++------
 5 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/include/asm/syscalls.h b/arch/powerpc/include/asm/syscalls.h
index 531b45d..050cca3 100644
--- a/arch/powerpc/include/asm/syscalls.h
+++ b/arch/powerpc/include/asm/syscalls.h
@@ -91,7 +91,7 @@ asmlinkage long sys_rt_sigaction(int sig,
 		const struct sigaction __user *act,
 		struct sigaction __user *oact, size_t sigsetsize);
 asmlinkage long sys_ppc64_personality(unsigned long personality);
-asmlinkage int ppc_rtas(struct rtas_args __user *uargs);
+asmlinkage int sys_rtas(struct rtas_args __user *uargs);
 asmlinkage time_t sys64_time(time_t __user * tloc);
 
 asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset,
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index bbcc700..06c0a73 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -22,7 +22,7 @@ SYSCALL_SPU(chmod)
 SYSCALL_SPU(lchown)
 SYSCALL(ni_syscall)
 OLDSYS(stat)
-SYSX_SPU(sys_lseek,ppc32_lseek,sys_lseek)
+SYSX_SPU(sys_lseek,sys32_lseek,sys_lseek)
 SYSCALL_SPU(getpid)
 COMPAT_SYS(mount)
 SYSX(sys_ni_syscall,sys_oldumount,sys_oldumount)
@@ -258,7 +258,7 @@ COMPAT_SYS_SPU(utimes)
 COMPAT_SYS_SPU(statfs64)
 COMPAT_SYS_SPU(fstatfs64)
 SYSX(sys_ni_syscall, sys_ppc_fadvise64_64, sys_ppc_fadvise64_64)
-PPC_SYS_SPU(rtas)
+SYSCALL_SPU(rtas)
 OLDSYS(debug_setcontext)
 SYSCALL(ni_syscall)
 COMPAT_SYS(migrate_pages)
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 0e1ec6f..ca5f8ea 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -826,7 +826,7 @@ static int rtas_ibm_suspend_me(struct rtas_args *args)
 }
 #endif
 
-asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
+SYSCALL_DEFINE1_RET(int, rtas, struct rtas_args __user *, uargs)
 {
 	struct rtas_args args;
 	unsigned long flags;
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index cf18164..431de48 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -167,7 +167,8 @@ COMPAT_SYSCALL_DEFINE4(sendfile, u32, out_fd, u32, in_fd,
 	return ret;
 }
 
-asmlinkage int compat_sys_sendfile64(int out_fd, int in_fd, compat_loff_t __user *offset, s32 count)
+COMPAT_SYSCALL_DEFINE4_RET(int, sendfile64, int, out_fd, int, in_fd,
+		compat_loff_t __user *, offset, s32, count)
 {
 	mm_segment_t old_fs = get_fs();
 	int ret;
@@ -347,7 +348,8 @@ COMPAT_SYSCALL_DEFINE1(nice, u32, increment)
 	return sys_nice((int)increment);
 }
 
-off_t ppc32_lseek(unsigned int fd, u32 offset, unsigned int origin)
+ARCH_COMPAT_SYSCALL_DEFINE3_RET(off_t, lseek,
+		unsigned int, fd, u32, offset, unsigned int, origin)
 {
 	/* sign extend n */
 	return sys_lseek(fd, (int)offset, origin);
@@ -539,9 +541,9 @@ COMPAT_SYSCALL_DEFINE1(umask, u32, mask)
 	return sys_umask((int)mask);
 }
 
-unsigned long compat_sys_mmap2(unsigned long addr, size_t len,
-			  unsigned long prot, unsigned long flags,
-			  unsigned long fd, unsigned long pgoff)
+COMPAT_SYSCALL_DEFINE6_RET(unsigned long, mmap2, unsigned long, addr, size_t, len,
+			  unsigned long, prot, unsigned long, flags,
+			  unsigned long, fd, unsigned long, pgoff)
 {
 	/* This should remain 12 even if PAGE_SIZE changes */
 	return sys_mmap(addr, len, prot, flags, fd, pgoff << 12);
@@ -558,25 +560,28 @@ COMPAT_SYSCALL_DEFINE3(tgkill, u32, tgid, u32, pid, int, sig)
  * The 32 bit ABI passes long longs in an odd even register pair.
  */
 
-compat_ssize_t compat_sys_pread64(unsigned int fd, char __user *ubuf, compat_size_t count,
-			     u32 reg6, u32 poshi, u32 poslo)
+COMPAT_SYSCALL_DEFINE6_RET(compat_ssize_t, pread64,
+		unsigned int, fd, char __user *, ubuf, compat_size_t, count,
+		u32, reg6, u32, poshi, u32, poslo)
 {
 	return sys_pread64(fd, ubuf, count, ((loff_t)poshi << 32) | poslo);
 }
 
-compat_ssize_t compat_sys_pwrite64(unsigned int fd, char __user *ubuf, compat_size_t count,
-			      u32 reg6, u32 poshi, u32 poslo)
+COMPAT_SYSCALL_DEFINE6_RET(compat_ssize_t, pwrite64,
+		unsigned int, fd, char __user *, ubuf, compat_size_t, count,
+		u32, reg6, u32, poshi, u32, poslo)
 {
 	return sys_pwrite64(fd, ubuf, count, ((loff_t)poshi << 32) | poslo);
 }
 
-compat_ssize_t compat_sys_readahead(int fd, u32 r4, u32 offhi, u32 offlo, u32 count)
+COMPAT_SYSCALL_DEFINE5_RET(compat_ssize_t, readahead,
+		int, fd, u32, r4, u32, offhi, u32, offlo, u32, count)
 {
 	return sys_readahead(fd, ((loff_t)offhi << 32) | offlo, count);
 }
 
-asmlinkage int compat_sys_truncate64(const char __user * path, u32 reg4,
-				unsigned long high, unsigned long low)
+COMPAT_SYSCALL_DEFINE4_RET(int, truncate64, const char __user *, path,
+		u32, reg4, unsigned long, high, unsigned long, low)
 {
 	return sys_truncate(path, (high << 32) | low);
 }
@@ -588,8 +593,8 @@ COMPAT_SYSCALL_DEFINE6(fallocate, int, fd, int, mode,
 			     ((loff_t)lenhi << 32) | lenlo);
 }
 
-asmlinkage int compat_sys_ftruncate64(unsigned int fd, u32 reg4, unsigned long high,
-				 unsigned long low)
+COMPAT_SYSCALL_DEFINE4_RET(int, ftruncate64, unsigned int, fd,
+		u32, reg4, unsigned long, high, unsigned long, low)
 {
 	return sys_ftruncate(fd, (high << 32) | low);
 }
diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
index f3bce3a..aee8ebb 100644
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -62,16 +62,16 @@ out:
 	return ret;
 }
 
-unsigned long sys_mmap2(unsigned long addr, size_t len,
-			unsigned long prot, unsigned long flags,
-			unsigned long fd, unsigned long pgoff)
+SYSCALL_DEFINE6_RET(unsigned long, mmap2, unsigned long, addr, size_t, len,
+			unsigned long, prot, unsigned long, flags,
+			unsigned long, fd, unsigned long, pgoff)
 {
 	return do_mmap2(addr, len, prot, flags, fd, pgoff, PAGE_SHIFT-12);
 }
 
-unsigned long sys_mmap(unsigned long addr, size_t len,
-		       unsigned long prot, unsigned long flags,
-		       unsigned long fd, off_t offset)
+SYSCALL_DEFINE6_RET(unsigned long, mmap, unsigned long, addr, size_t, len,
+		       unsigned long, prot, unsigned long, flags,
+		       unsigned long, fd, off_t, offset)
 {
 	return do_mmap2(addr, len, prot, flags, fd, offset, PAGE_SHIFT);
 }
-- 
1.7.1

