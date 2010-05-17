Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0EQFeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:34:15 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59470 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0EQFeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:34:11 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V8 3/9] vfs: Add open by file handle support
Date: Mon, 17 May 2010 11:03:46 +0530
Message-Id: <1274074432-29695-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c         |   50 +++++++++++++++
 fs/open.c          |  171 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    3 +-
 3 files changed, 223 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a7dce91..1fe4ee9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1556,6 +1556,56 @@ static int open_will_truncate(int flag, struct inode *inode)
 	return (flag & O_TRUNC);
 }
 
+struct file *finish_open_handle(struct path *path,
+			int open_flag, int acc_mode)
+{
+	int error;
+	struct file *filp;
+	int will_truncate;
+
+	will_truncate = open_will_truncate(open_flag, path->dentry->d_inode);
+	if (will_truncate) {
+		error = mnt_want_write(path->mnt);
+		if (error)
+			goto exit;
+	}
+	error = may_open(path, acc_mode, open_flag);
+	if (error) {
+		if (will_truncate)
+			mnt_drop_write(path->mnt);
+		goto exit;
+	}
+	filp = dentry_open(path->dentry, path->mnt, open_flag, current_cred());
+	if (!IS_ERR(filp)) {
+		error = ima_file_check(filp, acc_mode);
+		if (error) {
+			fput(filp);
+			filp = ERR_PTR(error);
+		}
+	}
+	if (!IS_ERR(filp)) {
+		if (will_truncate) {
+			error = handle_truncate(path);
+			if (error) {
+				fput(filp);
+				filp = ERR_PTR(error);
+			}
+		}
+	}
+	/*
+	 * It is now safe to drop the mnt write
+	 * because the filp has had a write taken
+	 * on its behalf.
+	 */
+	if (will_truncate)
+		mnt_drop_write(path->mnt);
+	return filp;
+
+exit:
+	path_put(path);
+	return ERR_PTR(error);
+}
+
 static struct file *finish_open(struct nameidata *nd,
 				int open_flag, int acc_mode)
 {
diff --git a/fs/open.c b/fs/open.c
index f63550b..0bd49b3 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1292,3 +1292,174 @@ err_out:
 	asmlinkage_protect(4, ret, dfd, name, handle, flag);
 	return ret;
 }
+
+static struct vfsmount *get_vfsmount_from_fd(int fd)
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
+					(struct fid *)handle->f_handle,
+					handle_size, handle->handle_type,
+					vfs_dentry_acceptable, NULL);
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
+static long do_sys_open_by_handle(int mountdirfd,
+				struct file_handle __user *ufh, int open_flag)
+{
+	int acc_mode;
+	int fd, retval = 0;
+	struct file *filp;
+	struct path *path;
+	struct file_handle f_handle;
+	struct file_handle *handle = NULL;
+
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
+		(f_handle.handle_size <= 0)) {
+		retval =  -EINVAL;
+		goto out_err;
+	}
+	if (!capable(CAP_DAC_OVERRIDE)) {
+		retval = -EPERM;
+		goto out_err;
+	}
+	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_size,
+			GFP_KERNEL);
+	if (!handle) {
+		retval =  -ENOMEM;
+		goto out_err;
+	}
+	/* copy the full handle */
+	if (copy_from_user(handle, ufh,
+				sizeof(struct file_handle) +
+				f_handle.handle_size)) {
+		retval = -EFAULT;
+		goto out_handle;
+	}
+	path = handle_to_path(mountdirfd, handle);
+	if (IS_ERR(path)) {
+		retval = PTR_ERR(path);
+		goto out_handle;
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
+	filp = finish_open_handle(path, open_flag, acc_mode);
+	if (IS_ERR(filp)) {
+		put_unused_fd(fd);
+		retval =  PTR_ERR(filp);
+	} else {
+		retval = fd;
+		fsnotify_open(filp->f_path.dentry);
+		fd_install(fd, filp);
+	}
+	kfree(path);
+	kfree(handle);
+	return retval;
+
+out_path:
+	path_put(path);
+	kfree(path);
+out_handle:
+	kfree(handle);
+out_err:
+	return retval;
+}
+
+SYSCALL_DEFINE3(open_by_handle, int, mountdirfd,
+		struct file_handle __user *, handle,
+		int, flags)
+{
+	long ret;
+
+	if (force_o_largefile())
+		flags |= O_LARGEFILE;
+
+	ret = do_sys_open_by_handle(mountdirfd, handle, flags);
+
+	/* avoid REGPARM breakage on x86: */
+	asmlinkage_protect(3, ret, mountdirfd, handle, flags);
+	return ret;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 055734c..c73e1a0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2144,7 +2144,8 @@ extern int may_open(struct path *, int, int);
 
 extern int kernel_read(struct file *, loff_t, char *, unsigned long);
 extern struct file * open_exec(const char *);
- 
+extern struct file *finish_open_handle(struct path *, int, int);
+
 /* fs/dcache.c -- generic fs support functions */
 extern int is_subdir(struct dentry *, struct dentry *);
 extern int path_is_under(struct path *, struct path *);
-- 
1.7.1.78.g212f0

