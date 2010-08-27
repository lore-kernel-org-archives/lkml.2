Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0H0LEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:04:07 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52547 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab0H0LEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:04:04 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V19 08/15] vfs: Add handle based xattr syscalls
Date: Fri, 27 Aug 2010 16:32:55 +0530
Message-Id: <1282906982-26918-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/xattr.c               |   70 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h |   15 ++++++++++
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 01bb813..1d236c9 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -335,6 +335,26 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 	return error;
 }
 
+SYSCALL_DEFINE6(handle_setxattr, int, mountdirfd,
+		struct file_handle __user *, ufh,
+		const char __user *, name, const void __user *, value,
+		size_t, size, int, flags)
+{
+	struct path path;
+	int error;
+
+	error = handle_to_path(mountdirfd, ufh, &path);
+	if (error)
+		return error;
+	error = mnt_want_write(path.mnt);
+	if (!error) {
+		error = setxattr(path.dentry, name, value, size, flags);
+		mnt_drop_write(path.mnt);
+	}
+	path_put(&path);
+	return error;
+}
+
 /*
  * Extended attribute GET operations
  */
@@ -416,6 +436,22 @@ SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
 	return error;
 }
 
+SYSCALL_DEFINE5(handle_getxattr, int, mountdirfd,
+		struct file_handle __user *, ufh,
+		const char __user *, name,
+		void __user *, value, size_t, size)
+{
+	struct path path;
+	ssize_t error;
+
+	error = handle_to_path(mountdirfd, ufh, &path);
+	if (error)
+		return error;
+	error = getxattr(path.dentry, name, value, size);
+	path_put(&path);
+	return error;
+}
+
 /*
  * Extended attribute LIST operations
  */
@@ -488,6 +524,21 @@ SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 	return error;
 }
 
+SYSCALL_DEFINE4(handle_listxattr, int, mountdirfd,
+		struct file_handle __user *, ufh,
+		char __user *, list, size_t, size)
+{
+	struct path path;
+	ssize_t error;
+
+	error = handle_to_path(mountdirfd, ufh, &path);
+	if (error)
+		return error;
+	error = listxattr(path.dentry, list, size);
+	path_put(&path);
+	return error;
+}
+
 /*
  * Extended attribute REMOVE operations
  */
@@ -562,6 +613,25 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 	return error;
 }
 
+SYSCALL_DEFINE3(handle_removexattr, int, mountdirfd,
+		struct file_handle __user *, ufh,
+		const char __user *, name)
+{
+	struct path path;
+	int error;
+
+	error = handle_to_path(mountdirfd, ufh, &path);
+	if (error)
+		return error;
+	error = mnt_want_write(path.mnt);
+	if (!error) {
+		error = removexattr(path.dentry, name);
+		mnt_drop_write(path.mnt);
+	}
+	path_put(&path);
+	return error;
+}
+
 
 static const char *
 strcmp_prefix(const char *a, const char *a_prefix)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 6dab72b..4c7e922 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -854,4 +854,19 @@ asmlinkage long sys_handle_link(int mountdirfd, struct file_handle __user *uofh,
 				int newfd, const char __user *newname);
 asmlinkage long sys_handle_chown(int mountdirfd, struct file_handle __user *ufh,
 				 uid_t user, gid_t group);
+asmlinkage long sys_handle_setxattr(int mountdirfd,
+				    struct file_handle __user *ufh,
+				    const char __user *name,
+				    const void __user *value,
+				    size_t size, int flags);
+asmlinkage long sys_handle_getxattr(int mountdirfd,
+				    struct file_handle __user *ufh,
+				    const char __user *name,
+				    void __user *value, size_t size);
+asmlinkage long sys_handle_listxattr(int mountdirfd,
+				     struct file_handle __user *ufh,
+				     char __user *list, size_t size);
+asmlinkage long sys_handle_removexattr(int mountdirfd,
+				       struct file_handle __user *ufh,
+				       const char __user *name);
 #endif
-- 
1.7.0.4

