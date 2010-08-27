Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab0H0LEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:04:13 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47138 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab0H0LEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:04:09 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V19 09/15] vfs: Add file access and modification time update via handle syscall
Date: Fri, 27 Aug 2010 16:32:56 +0530
Message-Id: <1282906982-26918-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/compat.c              |   20 ++++++++++++++++++
 fs/utimes.c              |   49 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h |    3 ++
 include/linux/time.h     |    3 ++
 4 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index c4037fd..29c4cb4 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -131,6 +131,26 @@ asmlinkage long compat_sys_utimes(const char __user *filename, struct compat_tim
 	return compat_sys_futimesat(AT_FDCWD, filename, t);
 }
 
+asmlinkage long compat_sys_handle_utimes(unsigned int mountdirfd,
+					 struct file_handle __user *ufh,
+					 struct compat_timeval __user *t)
+{
+	struct timespec tv[2];
+	if (t) {
+		if (get_user(tv[0].tv_sec, &t[0].tv_sec) ||
+		    get_user(tv[0].tv_nsec, &t[0].tv_usec) ||
+		    get_user(tv[1].tv_sec, &t[1].tv_sec) ||
+		    get_user(tv[1].tv_nsec, &t[1].tv_usec))
+			return -EFAULT;
+		if (tv[0].tv_nsec >= 1000000 || tv[0].tv_nsec < 0 ||
+		    tv[1].tv_nsec >= 1000000 || tv[1].tv_nsec < 0)
+			return -EINVAL;
+		tv[0].tv_nsec *= 1000;
+		tv[1].tv_nsec *= 1000;
+	}
+	return do_handle_utimes(mountdirfd, ufh, t ? tv : NULL);
+}
+
 static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
 {
 	compat_ino_t ino = stat->ino;
diff --git a/fs/utimes.c b/fs/utimes.c
index 179b586..df241a1 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -222,3 +222,52 @@ SYSCALL_DEFINE2(utimes, char __user *, filename,
 {
 	return sys_futimesat(AT_FDCWD, filename, utimes);
 }
+
+long do_handle_utimes(int mountdirfd, struct file_handle __user *ufh,
+		      struct timespec *times)
+{
+	struct path path;
+	int error = -EINVAL;
+
+	if (times && (!nsec_valid(times[0].tv_nsec) ||
+		      !nsec_valid(times[1].tv_nsec))) {
+		goto out;
+	}
+	error = handle_to_path(mountdirfd, ufh, &path);
+	if (error)
+		goto out;
+
+	error = utimes_common(&path, times);
+	path_put(&path);
+out:
+	return error;
+}
+
+SYSCALL_DEFINE3(handle_utimes, int, mountdirfd,
+		struct file_handle __user *, ufh,
+		struct timeval __user *, utimes)
+{
+	struct timeval times[2];
+	struct timespec tstimes[2];
+
+	if (utimes) {
+		if (copy_from_user(&times, utimes, sizeof(times)))
+			return -EFAULT;
+
+		/* This test is needed to catch all invalid values.  If we
+		   would test only in do_utimes we would miss those invalid
+		   values truncated by the multiplication with 1000.  Note
+		   that we also catch UTIME_{NOW,OMIT} here which are only
+		   valid for utimensat.  */
+		if (times[0].tv_usec >= 1000000 || times[0].tv_usec < 0 ||
+		    times[1].tv_usec >= 1000000 || times[1].tv_usec < 0)
+			return -EINVAL;
+
+		tstimes[0].tv_sec = times[0].tv_sec;
+		tstimes[0].tv_nsec = 1000 * times[0].tv_usec;
+		tstimes[1].tv_sec = times[1].tv_sec;
+		tstimes[1].tv_nsec = 1000 * times[1].tv_usec;
+	}
+
+	return do_handle_utimes(mountdirfd, ufh, utimes ? tstimes : NULL);
+}
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4c7e922..411a450 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -869,4 +869,7 @@ asmlinkage long sys_handle_listxattr(int mountdirfd,
 asmlinkage long sys_handle_removexattr(int mountdirfd,
 				       struct file_handle __user *ufh,
 				       const char __user *name);
+asmlinkage long sys_handle_utimes(int mountdirfd,
+				  struct file_handle __user *ufh,
+				  struct timeval __user *utimes);
 #endif
diff --git a/include/linux/time.h b/include/linux/time.h
index 9f15ac7..ce84274 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -151,6 +151,9 @@ extern int do_settimeofday(struct timespec *tv);
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
 extern long do_utimes(int dfd, const char __user *filename, struct timespec *times, int flags);
+struct file_handle;
+extern long do_handle_utimes(int mountdirfd, struct file_handle __user *ufh,
+			     struct timespec *times);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
-- 
1.7.0.4

