Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0FWKKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:10:52 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57814 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0FWKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:23 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Moyer <jmoyer@redhat.com>, David Howells <dhowells@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 15/40] compat: convert fs compat to use COMPAT_SYSCALL_DEFINE#N() macros
Date: Wed, 23 Jun 2010 20:02:56 +1000
Message-Id: <1277287401-28571-16-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

convert the fs/compat.c file to use the COMPAT_SYSCALL_DEFINE#N() macros to tie
them into the generic compat layer.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 fs/compat.c |  147 +++++++++++++++++++++++++++++------------------------------
 1 files changed, 72 insertions(+), 75 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 6490d21..df0b502 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -76,7 +76,7 @@ int compat_printk(const char *fmt, ...)
  * Not all architectures have sys_utime, so implement this in terms
  * of sys_utimes.
  */
-asmlinkage long compat_sys_utime(char __user *filename, struct compat_utimbuf __user *t)
+COMPAT_SYSCALL_DEFINE2(utime, char __user *, filename, struct compat_utimbuf __user *, t)
 {
 	struct timespec tv[2];
 
@@ -90,7 +90,7 @@ asmlinkage long compat_sys_utime(char __user *filename, struct compat_utimbuf __
 	return do_utimes(AT_FDCWD, filename, t ? tv : NULL, 0);
 }
 
-asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename, struct compat_timespec __user *t, int flags)
+COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, char __user *, filename, struct compat_timespec __user *, t, int, flags)
 {
 	struct timespec tv[2];
 
@@ -105,7 +105,7 @@ asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename, st
 	return do_utimes(dfd, filename, t ? tv : NULL, flags);
 }
 
-asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename, struct compat_timeval __user *t)
+COMPAT_SYSCALL_DEFINE3(futimesat, unsigned int, dfd, char __user *, filename, struct compat_timeval __user *, t)
 {
 	struct timespec tv[2];
 
@@ -124,7 +124,7 @@ asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename, st
 	return do_utimes(dfd, filename, t ? tv : NULL, 0);
 }
 
-asmlinkage long compat_sys_utimes(char __user *filename, struct compat_timeval __user *t)
+COMPAT_SYSCALL_DEFINE2(utimes, char __user *, filename, struct compat_timeval __user *, t)
 {
 	return compat_sys_futimesat(AT_FDCWD, filename, t);
 }
@@ -168,8 +168,8 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
 	return err;
 }
 
-asmlinkage long compat_sys_newstat(char __user * filename,
-		struct compat_stat __user *statbuf)
+COMPAT_SYSCALL_DEFINE2(newstat, char __user *, filename,
+			struct compat_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error;
@@ -180,8 +180,8 @@ asmlinkage long compat_sys_newstat(char __user * filename,
 	return cp_compat_stat(&stat, statbuf);
 }
 
-asmlinkage long compat_sys_newlstat(char __user * filename,
-		struct compat_stat __user *statbuf)
+COMPAT_SYSCALL_DEFINE2(newlstat, char __user *, filename,
+			struct compat_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error;
@@ -193,8 +193,8 @@ asmlinkage long compat_sys_newlstat(char __user * filename,
 }
 
 #ifndef __ARCH_WANT_STAT64
-asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user *filename,
-		struct compat_stat __user *statbuf, int flag)
+COMPAT_SYSCALL_DEFINE4(newfstatat, unsigned int, dfd, char __user *, filename,
+			struct compat_stat __user *, statbuf, int, flag)
 {
 	struct kstat stat;
 	int error;
@@ -206,8 +206,8 @@ asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user *filename,
 }
 #endif
 
-asmlinkage long compat_sys_newfstat(unsigned int fd,
-		struct compat_stat __user * statbuf)
+COMPAT_SYSCALL_DEFINE2(newfstat, unsigned int, fd,
+			struct compat_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_fstat(fd, &stat);
@@ -258,7 +258,7 @@ static int put_compat_statfs(struct compat_statfs __user *ubuf, struct kstatfs *
  * The following statfs calls are copies of code from fs/open.c and
  * should be checked against those from time to time
  */
-asmlinkage long compat_sys_statfs(const char __user *pathname, struct compat_statfs __user *buf)
+COMPAT_SYSCALL_DEFINE2(statfs, const char __user *, pathname, struct compat_statfs __user *, buf)
 {
 	struct path path;
 	int error;
@@ -274,7 +274,7 @@ asmlinkage long compat_sys_statfs(const char __user *pathname, struct compat_sta
 	return error;
 }
 
-asmlinkage long compat_sys_fstatfs(unsigned int fd, struct compat_statfs __user *buf)
+COMPAT_SYSCALL_DEFINE2(fstatfs, unsigned int, fd, struct compat_statfs __user *, buf)
 {
 	struct file * file;
 	struct kstatfs tmp;
@@ -323,7 +323,7 @@ static int put_compat_statfs64(struct compat_statfs64 __user *ubuf, struct kstat
 	return 0;
 }
 
-asmlinkage long compat_sys_statfs64(const char __user *pathname, compat_size_t sz, struct compat_statfs64 __user *buf)
+COMPAT_SYSCALL_DEFINE3(statfs64, const char __user *, pathname, compat_size_t, sz, struct compat_statfs64 __user *, buf)
 {
 	struct path path;
 	int error;
@@ -342,7 +342,7 @@ asmlinkage long compat_sys_statfs64(const char __user *pathname, compat_size_t s
 	return error;
 }
 
-asmlinkage long compat_sys_fstatfs64(unsigned int fd, compat_size_t sz, struct compat_statfs64 __user *buf)
+COMPAT_SYSCALL_DEFINE3(fstatfs64, unsigned int, fd, compat_size_t, sz, struct compat_statfs64 __user *, buf)
 {
 	struct file * file;
 	struct kstatfs tmp;
@@ -368,7 +368,7 @@ out:
  * Given how simple this syscall is that apporach is more maintainable
  * than the various conversion hacks.
  */
-asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u)
+COMPAT_SYSCALL_DEFINE2(ustat, unsigned, dev, struct compat_ustat __user *, u)
 {
 	struct super_block *sb;
 	struct compat_ustat tmp;
@@ -443,8 +443,8 @@ static int put_compat_flock64(struct flock *kfl, struct compat_flock64 __user *u
 }
 #endif
 
-asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
-		unsigned long arg)
+COMPAT_SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
+			unsigned long, arg)
 {
 	mm_segment_t old_fs;
 	struct flock f;
@@ -512,16 +512,15 @@ asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
 	return ret;
 }
 
-asmlinkage long compat_sys_fcntl(unsigned int fd, unsigned int cmd,
-		unsigned long arg)
+COMPAT_SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd,
+			unsigned long, arg)
 {
 	if ((cmd == F_GETLK64) || (cmd == F_SETLK64) || (cmd == F_SETLKW64))
 		return -EINVAL;
 	return compat_sys_fcntl64(fd, cmd, arg);
 }
 
-asmlinkage long
-compat_sys_io_setup(unsigned nr_reqs, u32 __user *ctx32p)
+COMPAT_SYSCALL_DEFINE2(io_setup, unsigned, nr_reqs, u32 __user *, ctx32p)
 {
 	long ret;
 	aio_context_t ctx64;
@@ -540,12 +539,11 @@ compat_sys_io_setup(unsigned nr_reqs, u32 __user *ctx32p)
 	return ret;
 }
 
-asmlinkage long
-compat_sys_io_getevents(aio_context_t ctx_id,
-				 unsigned long min_nr,
-				 unsigned long nr,
-				 struct io_event __user *events,
-				 struct compat_timespec __user *timeout)
+COMPAT_SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
+				 unsigned long, min_nr,
+				 unsigned long, nr,
+				 struct io_event __user *, events,
+				 struct compat_timespec __user *, timeout)
 {
 	long ret;
 	struct timespec t;
@@ -658,8 +656,7 @@ copy_iocb(long nr, u32 __user *ptr32, struct iocb __user * __user *ptr64)
 
 #define MAX_AIO_SUBMITS 	(PAGE_SIZE/sizeof(struct iocb *))
 
-asmlinkage long
-compat_sys_io_submit(aio_context_t ctx_id, int nr, u32 __user *iocb)
+COMPAT_SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, int, nr, u32 __user *, iocb)
 {
 	struct iocb __user * __user *iocb64; 
 	long ret;
@@ -836,9 +833,9 @@ static int do_nfs4_super_data_conv(void *raw_data)
 #define NCPFS_NAME      "ncpfs"
 #define NFS4_NAME	"nfs4"
 
-asmlinkage long compat_sys_mount(char __user * dev_name, char __user * dir_name,
-				 char __user * type, unsigned long flags,
-				 void __user * data)
+COMPAT_SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
+			char __user *, type, unsigned long, flags,
+			void __user *, data)
 {
 	char *kernel_type;
 	unsigned long data_page;
@@ -937,8 +934,9 @@ efault:
 	return -EFAULT;
 }
 
-asmlinkage long compat_sys_old_readdir(unsigned int fd,
-	struct compat_old_linux_dirent __user *dirent, unsigned int count)
+COMPAT_SYSCALL_DEFINE3(old_readdir, unsigned int, fd,
+			struct compat_old_linux_dirent __user *, dirent,
+			unsigned int, count)
 {
 	int error;
 	struct file *file;
@@ -1017,8 +1015,9 @@ efault:
 	return -EFAULT;
 }
 
-asmlinkage long compat_sys_getdents(unsigned int fd,
-		struct compat_linux_dirent __user *dirent, unsigned int count)
+COMPAT_SYSCALL_DEFINE3(getdents, unsigned int, fd,
+			struct compat_linux_dirent __user *, dirent,
+			unsigned int, count)
 {
 	struct file * file;
 	struct compat_linux_dirent __user * lastdirent;
@@ -1105,8 +1104,9 @@ efault:
 	return -EFAULT;
 }
 
-asmlinkage long compat_sys_getdents64(unsigned int fd,
-		struct linux_dirent64 __user * dirent, unsigned int count)
+COMPAT_SYSCALL_DEFINE3(getdents64, unsigned int, fd,
+			struct linux_dirent64 __user *, dirent,
+			unsigned int, count)
 {
 	struct file * file;
 	struct linux_dirent64 __user * lastdirent;
@@ -1316,9 +1316,8 @@ compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
 	return ret;
 }
 
-asmlinkage long
-compat_sys_vmsplice(int fd, const struct compat_iovec __user *iov32,
-		    unsigned int nr_segs, unsigned int flags)
+COMPAT_SYSCALL_DEFINE4(vmsplice, int, fd, const struct compat_iovec __user *, iov32,
+			unsigned int, nr_segs, unsigned int, flags)
 {
 	unsigned i;
 	struct iovec __user *iov;
@@ -1340,8 +1339,7 @@ compat_sys_vmsplice(int fd, const struct compat_iovec __user *iov32,
  * Exactly like fs/open.c:sys_open(), except that it doesn't set the
  * O_LARGEFILE flag.
  */
-asmlinkage long
-compat_sys_open(const char __user *filename, int flags, int mode)
+COMPAT_SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, int, mode)
 {
 	return do_sys_open(AT_FDCWD, filename, flags, mode);
 }
@@ -1350,8 +1348,7 @@ compat_sys_open(const char __user *filename, int flags, int mode)
  * Exactly like fs/open.c:sys_openat(), except that it doesn't set the
  * O_LARGEFILE flag.
  */
-asmlinkage long
-compat_sys_openat(unsigned int dfd, const char __user *filename, int flags, int mode)
+COMPAT_SYSCALL_DEFINE4(openat, unsigned int, dfd, const char __user *, filename, int, flags, int, mode)
 {
 	return do_sys_open(dfd, filename, flags, mode);
 }
@@ -1793,9 +1790,9 @@ out_nofds:
 	return ret;
 }
 
-asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
-	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
-	struct compat_timeval __user *tvp)
+COMPAT_SYSCALL_DEFINE5(select, int, n, compat_ulong_t __user *, inp,
+			compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
+			struct compat_timeval __user *, tvp)
 {
 	struct timespec end_time, *to = NULL;
 	struct compat_timeval tv;
@@ -1888,9 +1885,9 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	return ret;
 }
 
-asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
-	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
-	struct compat_timespec __user *tsp, void __user *sig)
+COMPAT_SYSCALL_DEFINE6(pselect6, int, n, compat_ulong_t __user *, inp,
+			compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
+			struct compat_timespec __user *, tsp, void __user *, sig)
 {
 	compat_size_t sigsetsize = 0;
 	compat_uptr_t up = 0;
@@ -1907,9 +1904,9 @@ asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
 				 sigsetsize);
 }
 
-asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
-	unsigned int nfds, struct compat_timespec __user *tsp,
-	const compat_sigset_t __user *sigmask, compat_size_t sigsetsize)
+COMPAT_SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds,
+			unsigned int, nfds, struct compat_timespec __user *, tsp,
+			const compat_sigset_t __user *, sigmask, compat_size_t, sigsetsize)
 {
 	compat_sigset_t ss32;
 	sigset_t ksigmask, sigsaved;
@@ -2137,9 +2134,9 @@ static int compat_nfs_getfh_res_trans(union nfsctl_res *kres,
 	return (err) ? -EFAULT : 0;
 }
 
-asmlinkage long compat_sys_nfsservctl(int cmd,
-				struct compat_nfsctl_arg __user *arg,
-				union compat_nfsctl_res __user *res)
+COMPAT_SYSCALL_DEFINE3(nfsservctl, int, cmd,
+			struct compat_nfsctl_arg __user *, arg,
+			union compat_nfsctl_res __user *, res)
 {
 	struct nfsctl_arg *karg;
 	union nfsctl_res *kres;
@@ -2215,11 +2212,11 @@ long asmlinkage compat_sys_nfsservctl(int cmd, void *notused, void *notused2)
 #ifdef CONFIG_EPOLL
 
 #ifdef HAVE_SET_RESTORE_SIGMASK
-asmlinkage long compat_sys_epoll_pwait(int epfd,
-			struct compat_epoll_event __user *events,
-			int maxevents, int timeout,
-			const compat_sigset_t __user *sigmask,
-			compat_size_t sigsetsize)
+COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
+			struct compat_epoll_event __user *, events,
+			int, maxevents, int, timeout,
+			const compat_sigset_t __user *, sigmask,
+			compat_size_t, sigsetsize)
 {
 	long err;
 	compat_sigset_t csigmask;
@@ -2264,9 +2261,9 @@ asmlinkage long compat_sys_epoll_pwait(int epfd,
 
 #ifdef CONFIG_SIGNALFD
 
-asmlinkage long compat_sys_signalfd4(int ufd,
-				     const compat_sigset_t __user *sigmask,
-				     compat_size_t sigsetsize, int flags)
+COMPAT_SYSCALL_DEFINE4(signalfd4, int, ufd,
+			const compat_sigset_t __user *, sigmask,
+			compat_size_t, sigsetsize, int, flags)
 {
 	compat_sigset_t ss32;
 	sigset_t tmp;
@@ -2284,9 +2281,9 @@ asmlinkage long compat_sys_signalfd4(int ufd,
 	return sys_signalfd4(ufd, ksigmask, sizeof(sigset_t), flags);
 }
 
-asmlinkage long compat_sys_signalfd(int ufd,
-				    const compat_sigset_t __user *sigmask,
-				    compat_size_t sigsetsize)
+COMPAT_SYSCALL_DEFINE3(signalfd, int, ufd,
+			const compat_sigset_t __user *, sigmask,
+			compat_size_t, sigsetsize)
 {
 	return compat_sys_signalfd4(ufd, sigmask, sigsetsize, 0);
 }
@@ -2294,9 +2291,9 @@ asmlinkage long compat_sys_signalfd(int ufd,
 
 #ifdef CONFIG_TIMERFD
 
-asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
-				   const struct compat_itimerspec __user *utmr,
-				   struct compat_itimerspec __user *otmr)
+COMPAT_SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
+			const struct compat_itimerspec __user *, utmr,
+			struct compat_itimerspec __user *, otmr)
 {
 	int error;
 	struct itimerspec t;
@@ -2315,8 +2312,8 @@ asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
 	return error;
 }
 
-asmlinkage long compat_sys_timerfd_gettime(int ufd,
-				   struct compat_itimerspec __user *otmr)
+COMPAT_SYSCALL_DEFINE2(timerfd_gettime, int, ufd,
+			struct compat_itimerspec __user *, otmr)
 {
 	int error;
 	struct itimerspec t;
-- 
1.7.1

