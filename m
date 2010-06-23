Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0FWKEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:37 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49557 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0FWKEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:31 -0400
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
       Chase Douglas <cndougla@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 23/40] trace syscalls, PPC: Convert ppc32 compat syscalls to COMPAT_SYSCALL
Date: Wed, 23 Jun 2010 20:03:04 +1000
Message-Id: <1277287401-28571-24-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Convert all the trivial 32bit PowerPC compat syscalls to use the
COMPAT_SYSCALL_DEFINE family of macros. This commit only converts the
syscalls with a return type of long for safety, syscalls with differing
return types will be dealt with in a separate commit.

This patch also alters the prefix of ppc32_select to sys32_select to fit
in with the ARCH_COMPAT_SYSCALL_DEFINE macro without conflicting with
the native sys_select syscall.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/systbl.h |    2 +-
 arch/powerpc/kernel/sys_ppc32.c   |  103 +++++++++++++++++++++---------------
 2 files changed, 61 insertions(+), 44 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index dd8494a..228eecb 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -145,7 +145,7 @@ SYSCALL_SPU(setfsuid)
 SYSCALL_SPU(setfsgid)
 SYSCALL_SPU(llseek)
 COMPAT_SYS_SPU(getdents)
-SYSX_SPU(sys_select,ppc32_select,sys_select)
+SYSX_SPU(sys_select,sys32_select,sys_select)
 SYSCALL_SPU(flock)
 SYSCALL_SPU(msync)
 COMPAT_SYS_SPU(readv)
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 19471a1..ab45dde 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -53,9 +53,9 @@
 #include <asm/syscalls.h>
 
 
-asmlinkage long ppc32_select(u32 n, compat_ulong_t __user *inp,
-		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
-		compat_uptr_t tvp_x)
+ARCH_COMPAT_SYSCALL_DEFINE5(select, u32, n, compat_ulong_t __user *, inp,
+		compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
+		compat_uptr_t, tvp_x)
 {
 	/* sign extend n */
 	return compat_sys_select((int)n, inp, outp, exp, compat_ptr(tvp_x));
@@ -66,7 +66,8 @@ asmlinkage long ppc32_select(u32 n, compat_ulong_t __user *inp,
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sysfs(u32 option, u32 arg1, u32 arg2)
+COMPAT_SYSCALL_DEFINE3(sysfs, u32, option, u32, arg1,
+		u32, arg2)
 {
 	return sys_sysfs((int)option, arg1, arg2);
 }
@@ -143,7 +144,8 @@ long compat_sys_ipc(u32 call, u32 first, u32 second, u32 third, compat_uptr_t pt
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sendfile(u32 out_fd, u32 in_fd, compat_off_t __user * offset, u32 count)
+COMPAT_SYSCALL_DEFINE4(sendfile, u32, out_fd, u32, in_fd,
+		compat_off_t __user *, offset, u32, count)
 {
 	mm_segment_t old_fs = get_fs();
 	int ret;
@@ -214,7 +216,8 @@ out:
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_prctl(u32 option, u32 arg2, u32 arg3, u32 arg4, u32 arg5)
+COMPAT_SYSCALL_DEFINE5(prctl, u32, option, u32, arg2,
+		u32, arg3, u32, arg4, u32, arg5)
 {
 	return sys_prctl((int)option,
 			 (unsigned long) arg2,
@@ -228,7 +231,8 @@ asmlinkage long compat_sys_prctl(u32 option, u32 arg2, u32 arg3, u32 arg4, u32 a
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sched_rr_get_interval(u32 pid, struct compat_timespec __user *interval)
+COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval, u32, pid,
+		struct compat_timespec __user *, interval)
 {
 	struct timespec t;
 	int ret;
@@ -248,7 +252,8 @@ asmlinkage long compat_sys_sched_rr_get_interval(u32 pid, struct compat_timespec
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_access(const char __user * filename, u32 mode)
+COMPAT_SYSCALL_DEFINE2(access, const char __user *, filename,
+		u32, mode)
 {
 	return sys_access(filename, (int)mode);
 }
@@ -259,7 +264,8 @@ asmlinkage long compat_sys_access(const char __user * filename, u32 mode)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_creat(const char __user * pathname, u32 mode)
+COMPAT_SYSCALL_DEFINE2(creat, const char __user *, pathname,
+		u32, mode)
 {
 	return sys_creat(pathname, (int)mode);
 }
@@ -270,7 +276,8 @@ asmlinkage long compat_sys_creat(const char __user * pathname, u32 mode)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_waitpid(u32 pid, unsigned int __user * stat_addr, u32 options)
+COMPAT_SYSCALL_DEFINE3(waitpid, u32, pid,
+		unsigned int __user *, stat_addr, u32, options)
 {
 	return sys_waitpid((int)pid, stat_addr, (int)options);
 }
@@ -281,7 +288,8 @@ asmlinkage long compat_sys_waitpid(u32 pid, unsigned int __user * stat_addr, u32
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_getgroups(u32 gidsetsize, gid_t __user *grouplist)
+COMPAT_SYSCALL_DEFINE2(getgroups, u32, gidsetsize,
+		gid_t __user *, grouplist)
 {
 	return sys_getgroups((int)gidsetsize, grouplist);
 }
@@ -292,7 +300,7 @@ asmlinkage long compat_sys_getgroups(u32 gidsetsize, gid_t __user *grouplist)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_getpgid(u32 pid)
+COMPAT_SYSCALL_DEFINE1(getpgid, u32, pid)
 {
 	return sys_getpgid((int)pid);
 }
@@ -304,7 +312,7 @@ asmlinkage long compat_sys_getpgid(u32 pid)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_getsid(u32 pid)
+COMPAT_SYSCALL_DEFINE1(getsid, u32, pid)
 {
 	return sys_getsid((int)pid);
 }
@@ -315,7 +323,7 @@ asmlinkage long compat_sys_getsid(u32 pid)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_kill(u32 pid, u32 sig)
+COMPAT_SYSCALL_DEFINE2(kill, u32, pid, u32, sig)
 {
 	return sys_kill((int)pid, (int)sig);
 }
@@ -326,7 +334,8 @@ asmlinkage long compat_sys_kill(u32 pid, u32 sig)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_mkdir(const char __user * pathname, u32 mode)
+COMPAT_SYSCALL_DEFINE2(mkdir, const char __user *, pathname,
+		u32, mode)
 {
 	return sys_mkdir(pathname, (int)mode);
 }
@@ -360,7 +369,8 @@ long compat_sys_ftruncate(int fd, u32 length)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_readlink(const char __user * path, char __user * buf, u32 bufsiz)
+COMPAT_SYSCALL_DEFINE3(readlink, const char __user *, path,
+		char __user *, buf, u32, bufsiz)
 {
 	return sys_readlink(path, buf, (int)bufsiz);
 }
@@ -370,7 +380,7 @@ asmlinkage long compat_sys_readlink(const char __user * path, char __user * buf,
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sched_get_priority_max(u32 policy)
+COMPAT_SYSCALL_DEFINE1(sched_get_priority_max, u32, policy)
 {
 	return sys_sched_get_priority_max((int)policy);
 }
@@ -381,7 +391,7 @@ asmlinkage long compat_sys_sched_get_priority_max(u32 policy)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sched_get_priority_min(u32 policy)
+COMPAT_SYSCALL_DEFINE1(sched_get_priority_min, u32, policy)
 {
 	return sys_sched_get_priority_min((int)policy);
 }
@@ -392,7 +402,8 @@ asmlinkage long compat_sys_sched_get_priority_min(u32 policy)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sched_getparam(u32 pid, struct sched_param __user *param)
+COMPAT_SYSCALL_DEFINE2(sched_getparam, u32, pid,
+		struct sched_param __user *, param)
 {
 	return sys_sched_getparam((int)pid, param);
 }
@@ -403,7 +414,7 @@ asmlinkage long compat_sys_sched_getparam(u32 pid, struct sched_param __user *pa
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sched_getscheduler(u32 pid)
+COMPAT_SYSCALL_DEFINE1(sched_getscheduler, u32, pid)
 {
 	return sys_sched_getscheduler((int)pid);
 }
@@ -414,7 +425,8 @@ asmlinkage long compat_sys_sched_getscheduler(u32 pid)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sched_setparam(u32 pid, struct sched_param __user *param)
+COMPAT_SYSCALL_DEFINE2(sched_setparam, u32, pid,
+		struct sched_param __user *, param)
 {
 	return sys_sched_setparam((int)pid, param);
 }
@@ -425,7 +437,8 @@ asmlinkage long compat_sys_sched_setparam(u32 pid, struct sched_param __user *pa
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sched_setscheduler(u32 pid, u32 policy, struct sched_param __user *param)
+COMPAT_SYSCALL_DEFINE3(sched_setscheduler, u32, pid,
+		u32, policy, struct sched_param __user *, param)
 {
 	return sys_sched_setscheduler((int)pid, (int)policy, param);
 }
@@ -436,7 +449,8 @@ asmlinkage long compat_sys_sched_setscheduler(u32 pid, u32 policy, struct sched_
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_setdomainname(char __user *name, u32 len)
+COMPAT_SYSCALL_DEFINE2(setdomainname, char __user *, name,
+		u32, len)
 {
 	return sys_setdomainname(name, (int)len);
 }
@@ -447,13 +461,15 @@ asmlinkage long compat_sys_setdomainname(char __user *name, u32 len)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_setgroups(u32 gidsetsize, gid_t __user *grouplist)
+COMPAT_SYSCALL_DEFINE2(setgroups, u32, gidsetsize,
+		gid_t __user *, grouplist)
 {
 	return sys_setgroups((int)gidsetsize, grouplist);
 }
 
 
-asmlinkage long compat_sys_sethostname(char __user *name, u32 len)
+COMPAT_SYSCALL_DEFINE2(sethostname, char __user *, name,
+		u32, len)
 {
 	/* sign extend len */
 	return sys_sethostname(name, (int)len);
@@ -465,7 +481,7 @@ asmlinkage long compat_sys_sethostname(char __user *name, u32 len)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_setpgid(u32 pid, u32 pgid)
+COMPAT_SYSCALL_DEFINE2(setpgid, u32, pid, u32, pgid)
 {
 	return sys_setpgid((int)pid, (int)pgid);
 }
@@ -499,12 +515,13 @@ long compat_sys_ioprio_set(u32 which, u32 who, u32 ioprio)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_ssetmask(u32 newmask)
+COMPAT_SYSCALL_DEFINE1(ssetmask, u32, newmask)
 {
 	return sys_ssetmask((int) newmask);
 }
 
-asmlinkage long compat_sys_syslog(u32 type, char __user * buf, u32 len)
+COMPAT_SYSCALL_DEFINE3(syslog, u32, type, char __user *, buf,
+		u32, len)
 {
 	/* sign extend len */
 	return sys_syslog(type, buf, (int)len);
@@ -516,7 +533,7 @@ asmlinkage long compat_sys_syslog(u32 type, char __user * buf, u32 len)
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_umask(u32 mask)
+COMPAT_SYSCALL_DEFINE1(umask, u32, mask)
 {
 	return sys_umask((int)mask);
 }
@@ -563,8 +580,8 @@ asmlinkage int compat_sys_truncate64(const char __user * path, u32 reg4,
 	return sys_truncate(path, (high << 32) | low);
 }
 
-asmlinkage long compat_sys_fallocate(int fd, int mode, u32 offhi, u32 offlo,
-				     u32 lenhi, u32 lenlo)
+COMPAT_SYSCALL_DEFINE6(fallocate, int, fd, int, mode,
+		u32, offhi, u32, offlo, u32, lenhi, u32, lenlo)
 {
 	return sys_fallocate(fd, mode, ((loff_t)offhi << 32) | offlo,
 			     ((loff_t)lenhi << 32) | lenlo);
@@ -590,26 +607,26 @@ long ppc32_fadvise64(int fd, u32 unused, u32 offset_high, u32 offset_low,
 			     advice);
 }
 
-asmlinkage long compat_sys_add_key(const char __user *_type,
-			      const char __user *_description,
-			      const void __user *_payload,
-			      u32 plen,
-			      u32 ringid)
+COMPAT_SYSCALL_DEFINE5(add_key, const char __user *, _type,
+			      const char __user *, _description,
+			      const void __user *, _payload,
+			      u32, plen,
+			      u32, ringid)
 {
 	return sys_add_key(_type, _description, _payload, plen, ringid);
 }
 
-asmlinkage long compat_sys_request_key(const char __user *_type,
-				  const char __user *_description,
-				  const char __user *_callout_info,
-				  u32 destringid)
+COMPAT_SYSCALL_DEFINE4(request_key, const char __user *, _type,
+				  const char __user *, _description,
+				  const char __user *, _callout_info,
+				  u32, destringid)
 {
 	return sys_request_key(_type, _description, _callout_info, destringid);
 }
 
-asmlinkage long compat_sys_sync_file_range2(int fd, unsigned int flags,
-				   unsigned offset_hi, unsigned offset_lo,
-				   unsigned nbytes_hi, unsigned nbytes_lo)
+COMPAT_SYSCALL_DEFINE6(sync_file_range2, int, fd, unsigned int, flags,
+				   unsigned, offset_hi, unsigned, offset_lo,
+				   unsigned, nbytes_hi, unsigned, nbytes_lo)
 {
 	loff_t offset = ((loff_t)offset_hi << 32) | offset_lo;
 	loff_t nbytes = ((loff_t)nbytes_hi << 32) | nbytes_lo;
-- 
1.7.1

