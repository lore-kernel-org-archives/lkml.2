Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab0FCQL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:11:57 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39845 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0FCQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:08:53 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 03/11] vfs: Add open by file handle support
Date: Thu,  3 Jun 2010 21:38:33 +0530
Message-Id: <1275581321-5861-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.236.g81fa0
In-Reply-To: <1275581321-5861-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1275581321-5861-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/exportfs/expfs.c      |    2 +
 fs/namei.c               |   50 ++++++++++++
 fs/open.c                |  198 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h       |    3 +-
 include/linux/syscalls.h |    2 +
 5 files changed, 254 insertions(+), 1 deletions(-)

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
index 868d0cb..c2d19c7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1557,6 +1557,56 @@ static int open_will_truncate(int flag, struct inode *inode)
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
index 71f4e04..9c3df5f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1154,3 +1154,201 @@ SYSCALL_DEFINE4(name_to_handle_at, int, dfd, const char __user *, name,
 	return -ENOSYS;
 }
 #endif
+
+#ifdef CONFIG_EXPORTFS
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
+	long retval = 0;
+	int fd, acc_mode;
+	struct file *filp;
+	struct path *path;
+	struct file_handle f_handle;
+	struct file_handle *handle = NULL;
+
+	/*
+	 * With handle we don't look at the execute bit on the
+	 * the directory. Ideally we whould like CAP_DAC_SEARCH.
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
+		(f_handle.handle_size <= 0)) {
+		retval =  -EINVAL;
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
+	if ((open_flag & O_DIRECTORY) &&
+		!S_ISDIR(path->dentry->d_inode->i_mode)) {
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
+	ret = do_sys_open_by_handle(mountdirfd, handle, flags);
+	return ret;
+}
+#else
+SYSCALL_DEFINE3(open_by_handle_at, int, mountdirfd,
+		struct file_handle __user *, handle,
+		int, flags)
+{
+	return -ENOSYS;
+}
+#endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ef7b00c..aec3292 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2141,7 +2141,8 @@ extern int may_open(struct path *, int, int);
 
 extern int kernel_read(struct file *, loff_t, char *, unsigned long);
 extern struct file * open_exec(const char *);
- 
+extern struct file *finish_open_handle(struct path *, int, int);
+
 /* fs/dcache.c -- generic fs support functions */
 extern int is_subdir(struct dentry *, struct dentry *);
 extern int path_is_under(struct path *, struct path *);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 45c869b..1bcdafd 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -826,5 +826,7 @@ asmlinkage long sys_mmap_pgoff(unsigned long addr, unsigned long len,
 asmlinkage long sys_old_mmap(struct mmap_arg_struct __user *arg);
 asmlinkage long sys_name_to_handle_at(int dfd, const char __user *name,
 				struct file_handle __user *handle, int flag);
+asmlinkage long sys_open_by_handle_at(int mountdirfd,
+				struct file_handle __user *handle, int flags);
 
 #endif
-- 
1.7.1.236.g81fa0

