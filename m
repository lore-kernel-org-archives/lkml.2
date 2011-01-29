Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1A2TJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:09:29 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46784 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab1A2TJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:09:25 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V26 13/16] fs: Support "" relative pathnames
Date: Sun, 30 Jan 2011 00:38:16 +0530
Message-Id: <1296328099-23263-14-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support "" relative pathnames relative to file descriptor opened
with O_PATH flag. This is needed so that we can make *_at variant
syscall operate on the dirfd passed.

Primary motivation is to enable readlinkat and linkat syscall
to work on symlink file descriptor. This also enables us to
do path lookup in userspace which can be useful for implementing
file servers in userspace.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c         |  104 +++++++++++++++++++++++++++++++++++++++-------------
 include/linux/fs.h |   10 ++++-
 2 files changed, 87 insertions(+), 27 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b9a500c..990b155 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -115,7 +115,8 @@
  * POSIX.1 2.4: an empty pathname is invalid (ENOENT).
  * PATH_MAX includes the nul terminator --RR.
  */
-static int do_getname(const char __user *filename, char *page)
+static int __do_getname(const char __user *filename,
+			char *page, int allow_null_name)
 {
 	int retval;
 	unsigned long len = PATH_MAX;
@@ -132,19 +133,20 @@ static int do_getname(const char __user *filename, char *page)
 		if (retval < len)
 			return 0;
 		return -ENAMETOOLONG;
-	} else if (!retval)
+	} else if (!retval && !allow_null_name)
 		retval = -ENOENT;
+
 	return retval;
 }
 
-char * getname(const char __user * filename)
+char *do_getname(const char __user *filename, int allow_null_name)
 {
 	char *tmp, *result;
 
 	result = ERR_PTR(-ENOMEM);
 	tmp = __getname();
 	if (tmp)  {
-		int retval = do_getname(filename, tmp);
+		int retval = __do_getname(filename, tmp, allow_null_name);
 
 		result = tmp;
 		if (retval < 0) {
@@ -155,6 +157,7 @@ char * getname(const char __user * filename)
 	audit_getname(result);
 	return result;
 }
+EXPORT_SYMBOL(do_getname);
 
 #ifdef CONFIG_AUDITSYSCALL
 void putname(const char *name)
@@ -1605,6 +1608,14 @@ static int path_init_rcu(int dfd, const char *name, unsigned int flags, struct n
 		struct fs_struct *fs = current->fs;
 		unsigned seq;
 
+		/*
+		 * If relative name is "" the descriptor should
+		 * be O_PATH descriptor.
+		 */
+		if (*name == 0) {
+			retval = -ENOENT;
+			goto out_fail;
+		}
 		br_read_lock(vfsmount_lock);
 		rcu_read_lock();
 
@@ -1617,21 +1628,38 @@ static int path_init_rcu(int dfd, const char *name, unsigned int flags, struct n
 	} else {
 		struct dentry *dentry;
 
-		file = fget_light(dfd, &fput_needed);
+		file = fget_light_lenient(dfd, &fput_needed);
 		retval = -EBADF;
 		if (!file)
 			goto out_fail;
 
 		dentry = file->f_path.dentry;
-
-		retval = -ENOTDIR;
-		if (!S_ISDIR(dentry->d_inode->i_mode))
-			goto fput_fail;
-
-		retval = file_permission(file, MAY_EXEC);
-		if (retval)
-			goto fput_fail;
-
+		/*
+		 * We allow O_PATH fd to be used relative
+		 * to "" name. This indicate operate on
+		 * dfd itself.
+		 */
+		if (!S_ISDIR(dentry->d_inode->i_mode)) {
+			if (!(file->f_flags & O_PATH) || (*name != 0)) {
+				retval = -ENOTDIR;
+				goto fput_fail;
+			}
+		} else {
+			/*
+			 * if directory and relative name is not ""
+			 * then we need to check for EXEC permission.
+			 * If relative name is "" the descriptor should
+			 * be O_PATH descriptor.
+			 */
+			if (*name != 0) {
+				retval = file_permission(file, MAY_EXEC);
+				if (retval)
+					goto fput_fail;
+			} else if (!(file->f_flags & O_PATH)) {
+				retval = -ENOENT;
+				goto fput_fail;
+			}
+		}
 		nd->path = file->f_path;
 		if (fput_needed)
 			nd->file = file;
@@ -1665,25 +1693,50 @@ static int path_init(int dfd, const char *name, unsigned int flags, struct namei
 		nd->path = nd->root;
 		path_get(&nd->root);
 	} else if (dfd == AT_FDCWD) {
+		/*
+		 * If relative name is "" the descriptor should
+		 * be O_PATH descriptor.
+		 */
+		if (*name == 0) {
+			retval = -ENOENT;
+			goto out_fail;
+		}
 		get_fs_pwd(current->fs, &nd->path);
 	} else {
 		struct dentry *dentry;
 
-		file = fget_light(dfd, &fput_needed);
+		file = fget_light_lenient(dfd, &fput_needed);
 		retval = -EBADF;
 		if (!file)
 			goto out_fail;
 
 		dentry = file->f_path.dentry;
-
-		retval = -ENOTDIR;
-		if (!S_ISDIR(dentry->d_inode->i_mode))
-			goto fput_fail;
-
-		retval = file_permission(file, MAY_EXEC);
-		if (retval)
-			goto fput_fail;
-
+		/*
+		 * We allow O_PATH fd to be used relative
+		 * to "" name. This indicate operate on
+		 * dfd itself.
+		 */
+		if (!S_ISDIR(dentry->d_inode->i_mode)) {
+			if (!(file->f_flags & O_PATH) || (*name != 0)) {
+				retval = -ENOTDIR;
+				goto fput_fail;
+			}
+		} else {
+			/*
+			 * if directory and relative name is not ""
+			 * then we need to check for EXEC permission.
+			 * If relative name is "" the descriptor should
+			 * be O_PATH descriptor.
+			 */
+			if (*name != 0) {
+				retval = file_permission(file, MAY_EXEC);
+				if (retval)
+					goto fput_fail;
+			} else if (!(file->f_flags & O_PATH)) {
+				retval = -ENOENT;
+				goto fput_fail;
+			}
+		}
 		nd->path = file->f_path;
 		path_get(&file->f_path);
 
@@ -1926,7 +1979,7 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
 		 struct path *path)
 {
 	struct nameidata nd;
-	char *tmp = getname(name);
+	char *tmp = getname_null(name);
 	int err = PTR_ERR(tmp);
 	if (!IS_ERR(tmp)) {
 
@@ -3806,7 +3859,6 @@ EXPORT_SYMBOL(follow_down_one);
 EXPORT_SYMBOL(follow_down);
 EXPORT_SYMBOL(follow_up);
 EXPORT_SYMBOL(get_write_access); /* binfmt_aout */
-EXPORT_SYMBOL(getname);
 EXPORT_SYMBOL(lock_rename);
 EXPORT_SYMBOL(lookup_one_len);
 EXPORT_SYMBOL(page_follow_link_light);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ac6e899..3f1e7fc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2004,7 +2004,15 @@ struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
 				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
-extern char * getname(const char __user *);
+extern char *do_getname(const char __user *, int allow_null_name);
+static inline char *getname(const char __user *name)
+{
+	return do_getname(name, 0);
+}
+static inline char *getname_null(const char __user *name)
+{
+	return do_getname(name, 1);
+}
 
 /* fs/ioctl.c */
 
-- 
1.7.1

