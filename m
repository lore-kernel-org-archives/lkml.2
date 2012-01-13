Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab2AMByF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:54:05 -0500
Received: from alcazar.beanwood.com ([70.85.129.230]:39747 "EHLO
	alcazar.beanwood.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab2AMBxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:53:55 -0500
From: Andrew Ayer <agwa@andrewayer.name>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] vfs: Add fchmodat4 syscall: fchmodat with flag argument
Date: Thu, 12 Jan 2012 17:53:45 -0800
Message-Id: <1326419626-22568-2-git-send-email-agwa@andrewayer.name>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1326419626-22568-1-git-send-email-agwa@andrewayer.name>
References: <1326419626-22568-1-git-send-email-agwa@andrewayer.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a 4 argument version of fchmodat (fchmodat4) that
supports a flag argument, as specified by POSIX.  It supports
the same two flags as fchownat: AT_SYMLINK_NOFOLLOW and AT_EMPTY_PATH.

Signed-off-by: Andrew Ayer <agwa@andrewayer.name>
---
 fs/open.c                |   21 +++++++++++++++++++--
 include/linux/syscalls.h |    2 ++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 77becc0..4f087e7 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -452,6 +452,9 @@ static int chmod_common(struct path *path, umode_t mode)
 	struct iattr newattrs;
 	int error;
 
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
 	error = mnt_want_write(path->mnt);
 	if (error)
 		return error;
@@ -484,10 +487,24 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
 
 SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t, mode)
 {
+	return sys_fchmodat4(dfd, filename, mode, 0);
+}
+
+SYSCALL_DEFINE4(fchmodat4, int, dfd, const char __user *, filename,
+		umode_t, mode, int, flag)
+{
 	struct path path;
 	int error;
+	int lookup_flags;
+
+	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
 
-	error = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
+	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	if (flag & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
+
+	error = user_path_at(dfd, filename, lookup_flags, &path);
 	if (!error) {
 		error = chmod_common(&path, mode);
 		path_put(&path);
@@ -497,7 +514,7 @@ SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t, mode
 
 SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
 {
-	return sys_fchmodat(AT_FDCWD, filename, mode);
+	return sys_fchmodat4(AT_FDCWD, filename, mode, 0);
 }
 
 static int chown_common(struct path *path, uid_t user, gid_t group)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 515669f..4834904 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -770,6 +770,8 @@ asmlinkage long sys_futimesat(int dfd, const char __user *filename,
 asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode);
 asmlinkage long sys_fchmodat(int dfd, const char __user * filename,
 			     umode_t mode);
+asmlinkage long sys_fchmodat4(int dfd, const char __user * filename,
+			     umode_t mode, int flag);
 asmlinkage long sys_fchownat(int dfd, const char __user *filename, uid_t user,
 			     gid_t group, int flag);
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
-- 
1.7.1

