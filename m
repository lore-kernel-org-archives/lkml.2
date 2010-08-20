Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0HTBwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:52:05 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49348 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab0HTBwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:52:01 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V18 03/13] vfs: Add open by file handle support
Date: Fri, 20 Aug 2010 07:21:27 +0530
Message-Id: <1282269097-26166-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/exportfs/expfs.c      |    2 +
 fs/namei.c               |  220 +++++++++++++++++++++++++++++++++++++++++++---
 fs/open.c                |   32 ++++++-
 include/linux/fs.h       |    8 ++-
 include/linux/namei.h    |    1 +
 include/linux/syscalls.h |    3 +
 6 files changed, 247 insertions(+), 19 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index cfee0f0..05a1179 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -373,6 +373,8 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 	/*
 	 * Try to get any dentry for the given file handle from the filesystem.
 	 */
+	if (!nop || !nop->fh_to_dentry)
+		return ERR_PTR(-ESTALE);
 	result = nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type);
 	if (!result)
 		result = ERR_PTR(-ESTALE);
diff --git a/fs/namei.c b/fs/namei.c
index 17ea76b..1291dfc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -32,6 +32,7 @@
 #include <linux/fcntl.h>
 #include <linux/device_cgroup.h>
 #include <linux/fs_struct.h>
+#include <linux/exportfs.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -1042,6 +1043,29 @@ out_fail:
 	return retval;
 }
 
+struct vfsmount *get_vfsmount_from_fd(int fd)
+{
+	int fput_needed;
+	struct path *path;
+	struct file *filep;
+
+	if (fd == AT_FDCWD) {
+		struct fs_struct *fs = current->fs;
+		read_lock(&fs->lock);
+		path = &fs->pwd;
+		mntget(path->mnt);
+		read_unlock(&fs->lock);
+	} else {
+		filep = fget_light(fd, &fput_needed);
+		if (!filep)
+			return ERR_PTR(-EBADF);
+		path = &filep->f_path;
+		mntget(path->mnt);
+		fput_light(filep, fput_needed);
+	}
+	return path->mnt;
+}
+
 /* Returns 0 and nd will be valid on success; Retuns error, otherwise. */
 static int do_path_lookup(int dfd, const char *name,
 				unsigned int flags, struct nameidata *nd)
@@ -1546,26 +1570,30 @@ static int open_will_truncate(int flag, struct inode *inode)
 	return (flag & O_TRUNC);
 }
 
-static struct file *finish_open(struct nameidata *nd,
+static struct file *finish_open(struct file *filp, struct path *path,
 				int open_flag, int acc_mode)
 {
-	struct file *filp;
-	int will_truncate;
 	int error;
+	int will_truncate;
 
-	will_truncate = open_will_truncate(open_flag, nd->path.dentry->d_inode);
+	will_truncate = open_will_truncate(open_flag, path->dentry->d_inode);
 	if (will_truncate) {
-		error = mnt_want_write(nd->path.mnt);
+		error = mnt_want_write(path->mnt);
 		if (error)
 			goto exit;
 	}
-	error = may_open(&nd->path, acc_mode, open_flag);
+	error = may_open(path, acc_mode, open_flag);
 	if (error) {
 		if (will_truncate)
-			mnt_drop_write(nd->path.mnt);
+			mnt_drop_write(path->mnt);
 		goto exit;
 	}
-	filp = nameidata_to_filp(nd);
+	/* Has the filesystem initialised the file for us? */
+	if (filp->f_path.dentry == NULL)
+		filp = __dentry_open(path->dentry, path->mnt, filp,
+				     NULL, current_cred());
+	else
+		path_put(path);
 	if (!IS_ERR(filp)) {
 		error = ima_file_check(filp, acc_mode);
 		if (error) {
@@ -1575,7 +1603,7 @@ static struct file *finish_open(struct nameidata *nd,
 	}
 	if (!IS_ERR(filp)) {
 		if (will_truncate) {
-			error = handle_truncate(&nd->path);
+			error = handle_truncate(path);
 			if (error) {
 				fput(filp);
 				filp = ERR_PTR(error);
@@ -1588,13 +1616,17 @@ static struct file *finish_open(struct nameidata *nd,
 	 * on its behalf.
 	 */
 	if (will_truncate)
-		mnt_drop_write(nd->path.mnt);
+		mnt_drop_write(path->mnt);
 	return filp;
 
 exit:
-	if (!IS_ERR(nd->intent.open.file))
-		release_open_intent(nd);
-	path_put(&nd->path);
+	if (!IS_ERR(filp)) {
+		if (filp->f_path.dentry == NULL)
+			put_filp(filp);
+		else
+			fput(filp);
+	}
+	path_put(path);
 	return ERR_PTR(error);
 }
 
@@ -1728,7 +1760,9 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (S_ISDIR(path->dentry->d_inode->i_mode))
 		goto exit;
 ok:
-	filp = finish_open(nd, open_flag, acc_mode);
+	filp = finish_open(nd->intent.open.file, &nd->path,
+			   open_flag, acc_mode);
+
 	return filp;
 
 exit_mutex_unlock:
@@ -1901,6 +1935,164 @@ struct file *filp_open(const char *filename, int flags, int mode)
 }
 EXPORT_SYMBOL(filp_open);
 
+#ifdef CONFIG_EXPORTFS
+static int vfs_dentry_acceptable(void *context, struct dentry *dentry)
+{
+	return 1;
+}
+
+static struct path *handle_to_path(int mountdirfd, struct file_handle *handle)
+{
+	int retval;
+	int handle_size;
+	struct path *path;
+
+	path = kmalloc(sizeof(struct path), GFP_KERNEL);
+	if (!path)
+		return ERR_PTR(-ENOMEM);
+
+	path->mnt = get_vfsmount_from_fd(mountdirfd);
+	if (IS_ERR(path->mnt)) {
+		retval = PTR_ERR(path->mnt);
+		goto out_err;
+	}
+	/* change the handle size to multiple of sizeof(u32) */
+	handle_size = handle->handle_size >> 2;
+	path->dentry = exportfs_decode_fh(path->mnt,
+					  (struct fid *)handle->f_handle,
+					  handle_size, handle->handle_type,
+					  vfs_dentry_acceptable, NULL);
+	if (IS_ERR(path->dentry)) {
+		retval = PTR_ERR(path->dentry);
+		goto out_mnt;
+	}
+	return path;
+out_mnt:
+	mntput(path->mnt);
+out_err:
+	kfree(path);
+	return ERR_PTR(retval);
+}
+
+long do_handle_open(int mountdirfd,
+		    struct file_handle __user *ufh, int open_flag)
+{
+	long retval = 0;
+	int fd, acc_mode;
+	struct file *filp;
+	struct path *path;
+	struct file_handle f_handle;
+	struct file_handle *handle = NULL;
+
+	/*
+	 * With handle we don't look at the execute bit on the
+	 * the directory. Ideally we would like CAP_DAC_SEARCH.
+	 * But we don't have that
+	 */
+	if (!capable(CAP_DAC_READ_SEARCH)) {
+		retval = -EPERM;
+		goto out_err;
+	}
+	/* can't use O_CREATE with open_by_handle */
+	if (open_flag & O_CREAT) {
+		retval = -EINVAL;
+		goto out_err;
+	}
+	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))) {
+		retval = -EFAULT;
+		goto out_err;
+	}
+	if ((f_handle.handle_size > MAX_HANDLE_SZ) ||
+	    (f_handle.handle_size <= 0)) {
+		retval =  -EINVAL;
+		goto out_err;
+	}
+	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_size,
+			 GFP_KERNEL);
+	if (!handle) {
+		retval =  -ENOMEM;
+		goto out_err;
+	}
+	/* copy the full handle */
+	if (copy_from_user(handle, ufh,
+			   sizeof(struct file_handle) +
+			   f_handle.handle_size)) {
+		retval = -EFAULT;
+		goto out_handle;
+	}
+	path = handle_to_path(mountdirfd, handle);
+	if (IS_ERR(path)) {
+		retval = PTR_ERR(path);
+		goto out_handle;
+	}
+	if ((open_flag & O_DIRECTORY) &&
+	    !S_ISDIR(path->dentry->d_inode->i_mode)) {
+		retval = -ENOTDIR;
+		goto out_path;
+	}
+	/*
+	 * O_SYNC is implemented as __O_SYNC|O_DSYNC.  As many places only
+	 * check for O_DSYNC if the need any syncing at all we enforce it's
+	 * always set instead of having to deal with possibly weird behaviour
+	 * for malicious applications setting only __O_SYNC.
+	 */
+	if (open_flag & __O_SYNC)
+		open_flag |= O_DSYNC;
+
+	acc_mode = MAY_OPEN | ACC_MODE(open_flag);
+
+	/* O_TRUNC implies we need access checks for write permissions */
+	if (open_flag & O_TRUNC)
+		acc_mode |= MAY_WRITE;
+	/*
+	 * Allow the LSM permission hook to distinguish append
+	 * access from general write access.
+	 */
+	if (open_flag & O_APPEND)
+		acc_mode |= MAY_APPEND;
+
+	fd = get_unused_fd_flags(open_flag);
+	if (fd < 0) {
+		retval = fd;
+		goto out_path;
+	}
+	filp = get_empty_filp();
+	if (!filp) {
+		retval = -ENFILE;
+		goto out_free_fd;
+	}
+	filp->f_flags = open_flag;
+	filp = finish_open(filp, path, open_flag, acc_mode);
+	if (IS_ERR(filp)) {
+		put_unused_fd(fd);
+		retval =  PTR_ERR(filp);
+	} else {
+		retval = fd;
+		fsnotify_open(filp);
+		fd_install(fd, filp);
+	}
+	kfree(path);
+	kfree(handle);
+	return retval;
+
+out_free_fd:
+	put_unused_fd(fd);
+out_path:
+	path_put(path);
+	kfree(path);
+out_handle:
+	kfree(handle);
+out_err:
+	return retval;
+}
+#else
+long do_handle_open(int mountdirfd,
+		    struct file_handle __user *ufh, int open_flag)
+{
+	return -ENOSYS;
+}
+#endif
+
 /**
  * lookup_create - lookup a dentry, creating it if it doesn't exist
  * @nd: nameidata info
diff --git a/fs/open.c b/fs/open.c
index efb1806..7abdcba 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -652,10 +652,10 @@ static inline int __get_file_write_access(struct inode *inode,
 	return error;
 }
 
-static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
-					struct file *f,
-					int (*open)(struct inode *, struct file *),
-					const struct cred *cred)
+struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
+			   struct file *f,
+			   int (*open)(struct inode *, struct file *),
+			   const struct cred *cred)
 {
 	struct inode *inode;
 	int error;
@@ -1171,3 +1171,27 @@ SYSCALL_DEFINE5(name_to_handle_at, int, dfd, const char __user *, name,
 	return -ENOSYS;
 }
 #endif
+
+/**
+ * sys_open_by_handle_at: Open the file handle
+ * @mountdirfd: directory file descriptor
+ * @handle: file handle to be opened
+ * @flag: open flags.
+ *
+ * @mountdirfd indicate the directory file descriptor
+ * of the mount point. file handle is decoded relative
+ * to the vfsmount pointed by the @mountdirfd. @flags
+ * value is same as the open(2) flags.
+ */
+SYSCALL_DEFINE3(open_by_handle_at, int, mountdirfd,
+		struct file_handle __user *, handle,
+		int, flags)
+{
+	long ret;
+
+	if (force_o_largefile())
+		flags |= O_LARGEFILE;
+
+	ret = do_handle_open(mountdirfd, handle, flags);
+	return ret;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f2f7ad3..e9471c7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1939,6 +1939,10 @@ extern int do_fallocate(struct file *file, int mode, loff_t offset,
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
+struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
+			   struct file *f,
+			   int (*open)(struct inode *, struct file *),
+			   const struct cred *cred);
 extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
 				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
@@ -2150,11 +2154,13 @@ extern void free_write_pipe(struct file *);
 
 extern struct file *do_filp_open(int dfd, const char *pathname,
 		int open_flag, int mode, int acc_mode);
+extern long do_handle_open(int mountdirfd,
+			   struct file_handle __user *ufh, int open_flag);
 extern int may_open(struct path *, int, int);
 
 extern int kernel_read(struct file *, loff_t, char *, unsigned long);
 extern struct file * open_exec(const char *);
- 
+
 /* fs/dcache.c -- generic fs support functions */
 extern int is_subdir(struct dentry *, struct dentry *);
 extern int path_is_under(struct path *, struct path *);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 05b441d..827aef0 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -64,6 +64,7 @@ extern int user_path_at(int, const char __user *, unsigned, struct path *);
 #define user_path_dir(name, path) \
 	user_path_at(AT_FDCWD, name, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, path)
 
+extern struct vfsmount *get_vfsmount_from_fd(int);
 extern int kern_path(const char *, unsigned, struct path *);
 
 extern int path_lookup(const char *, unsigned, struct nameidata *);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f7aba76..4dc527c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -835,4 +835,7 @@ asmlinkage long sys_old_mmap(struct mmap_arg_struct __user *arg);
 asmlinkage long sys_name_to_handle_at(int dfd, const char __user *name,
 				      struct file_handle __user *handle,
 				      int __user *mnt_id, int flag);
+asmlinkage long sys_open_by_handle_at(int mountdirfd,
+				      struct file_handle __user *handle,
+				      int flags);
 #endif
-- 
1.7.0.4

