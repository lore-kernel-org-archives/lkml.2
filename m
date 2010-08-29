Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0H2R3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 13:29:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51458 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0H2R3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 13:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xxnFx7iB5KapUm9uAyM+3EkCrGiBsN55AAZPrr3I61MqQkCWsOVesXM27DfqvqsKoh
         UA7hyfUoOFdBefM+TgtsdN/J1wII8ZH3MoP7BavGojPgEhgysjzGNZgke7U78I5jCncm
         scRmRDOY/tg7MmiRMRohz76cDBY+gpHMeyT4I=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
        Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [RFC v2 PATCH 2/3] initramfs: use kern_sys_* wrappers instead of syscall
Date: Mon, 30 Aug 2010 02:28:47 +0900
Message-Id: <1283102928-3051-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283102928-3051-1-git-send-email-namhyung@gmail.com>
References: <1283102928-3051-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace direct call to syscall routines to its wrapper functions
defined in init/sys-wrapper.h

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/sys-wrapper.c |  589 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 589 insertions(+), 0 deletions(-)
 create mode 100644 init/sys-wrapper.c

diff --git a/init/sys-wrapper.c b/init/sys-wrapper.c
new file mode 100644
index 0000000..fa5949f
--- /dev/null
+++ b/init/sys-wrapper.c
@@ -0,0 +1,589 @@
+/*
+ * init/sys-wrapper.c
+ *
+ * Copyright (C) 2010  Namhyung Kim <namhyung@gmail.com>
+ *
+ * Wrappers for various syscalls for use in the init code.
+ * Most of these functions are copied from their syscall implementation
+ * verbatim except that path lookup codes are changed to use kernel
+ * functions and security checks are removed.
+ *
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/file.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
+#include <linux/fcntl.h>
+#include <linux/dirent.h>
+#include <linux/syscalls.h>
+#include <linux/highuid.h>
+#include "sys-wrapper.h"
+
+int __init kern_sys_link(const char *oldname, const char *newname)
+{
+	struct path old_path;
+	struct dentry *new_dentry;
+	struct nameidata nd;
+	int error;
+
+	error = kern_path(oldname, 0, &old_path);
+	if (error)
+		goto out;
+
+	error = path_lookup(newname, LOOKUP_PARENT, &nd);
+	if (error)
+		goto out_path;
+
+	error = -EXDEV;
+	if (old_path.mnt != nd.path.mnt)
+		goto out_nd;
+
+	new_dentry = lookup_create(&nd, 0);
+	if (IS_ERR(new_dentry)) {
+		error = PTR_ERR(new_dentry);
+		goto out_unlock;
+	}
+
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
+
+	error = vfs_link(old_path.dentry, nd.path.dentry->d_inode, new_dentry);
+
+	mnt_drop_write(nd.path.mnt);
+out_dput:
+	dput(new_dentry);
+out_unlock:
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+out_nd:
+	path_put(&nd.path);
+out_path:
+	path_put(&old_path);
+out:
+	return error;
+}
+
+static struct dentry *lookup_hash(struct nameidata *nd)
+{
+	int err;
+	struct dentry *base;
+	struct qstr *name;
+	struct inode *inode;
+	struct dentry *dentry;
+
+	base = nd->path.dentry;
+	name = &nd->last;
+	inode = base->d_inode;
+
+	if (inode->i_op->permission) {
+		err = inode->i_op->permission(inode, MAY_EXEC);
+		if (err)
+			return ERR_PTR(err);
+	}
+
+	/*
+	 * See if the low-level filesystem might want
+	 * to use its own hash..
+	 */
+	if (base->d_op && base->d_op->d_hash) {
+		err = base->d_op->d_hash(base, name);
+		if (err < 0)
+			return ERR_PTR(err);
+	}
+
+	/*
+	 * Don't bother with __d_lookup: callers are for creat as
+	 * well as unlink, so a lot of the time it would cost
+	 * a double lookup.
+	 */
+	dentry = d_lookup(nd->path.dentry, &nd->last);
+
+	if (dentry && dentry->d_op && dentry->d_op->d_revalidate) {
+		int status = dentry->d_op->d_revalidate(dentry, nd);
+		if (unlikely(status <= 0)) {
+			/*
+			 * The dentry failed validation.
+			 * If d_revalidate returned 0 attempt to invalidate
+			 * the dentry otherwise d_revalidate is asking us
+			 * to return a fail status.
+			 */
+			if (!status) {
+				if (!d_invalidate(dentry)) {
+					dput(dentry);
+					dentry = NULL;
+				}
+			} else {
+				dput(dentry);
+				return ERR_PTR(status);
+			}
+		}
+	}
+
+	if (!dentry) {
+		struct dentry *old;
+		/* Don't create child dentry for a dead directory. */
+		if (unlikely(IS_DEADDIR(inode)))
+			return ERR_PTR(-ENOENT);
+
+		dentry = d_alloc(base, name);
+		if (unlikely(!dentry))
+			return ERR_PTR(-ENOMEM);
+
+		old = inode->i_op->lookup(inode, dentry, nd);
+		if (unlikely(old)) {
+			dput(dentry);
+			dentry = old;
+		}
+	}
+	return dentry;
+}
+
+int __init kern_sys_unlink(const char *pathname)
+{
+	int error;
+	struct dentry *dentry;
+	struct nameidata nd;
+	struct inode *inode = NULL;
+
+	error = path_lookup(pathname, LOOKUP_PARENT, &nd);
+	if (error)
+		return error;
+
+	error = -EISDIR;
+	if (nd.last_type != LAST_NORM)
+		goto out_path;
+
+	nd.flags &= ~LOOKUP_PARENT;
+
+	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+	dentry = lookup_hash(&nd);
+	error = PTR_ERR(dentry);
+	if (!IS_ERR(dentry)) {
+		/* Why not before? Because we want correct error value */
+		if (nd.last.name[nd.last.len])
+			goto slashes;
+		inode = dentry->d_inode;
+		if (inode)
+			atomic_inc(&inode->i_count);
+		error = mnt_want_write(nd.path.mnt);
+		if (error)
+			goto out_dput;
+		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
+
+		mnt_drop_write(nd.path.mnt);
+	out_dput:
+		dput(dentry);
+	}
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+	if (inode)
+		iput(inode);	/* truncate the inode here */
+out_path:
+	path_put(&nd.path);
+	return error;
+
+slashes:
+	error = !dentry->d_inode ? -ENOENT :
+		S_ISDIR(dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
+	goto out_dput;
+}
+
+/* This functions is taken from fs/stat.c */
+static int __init cp_new_stat(struct kstat *stat, struct stat *statbuf)
+{
+	struct stat tmp;
+
+#if BITS_PER_LONG == 32
+	if (!old_valid_dev(stat->dev) || !old_valid_dev(stat->rdev))
+		return -EOVERFLOW;
+#else
+	if (!new_valid_dev(stat->dev) || !new_valid_dev(stat->rdev))
+		return -EOVERFLOW;
+#endif
+
+	memset(&tmp, 0, sizeof(tmp));
+#if BITS_PER_LONG == 32
+	tmp.st_dev = old_encode_dev(stat->dev);
+#else
+	tmp.st_dev = new_encode_dev(stat->dev);
+#endif
+	tmp.st_ino = stat->ino;
+	if (sizeof(tmp.st_ino) < sizeof(stat->ino) && tmp.st_ino != stat->ino)
+		return -EOVERFLOW;
+	tmp.st_mode = stat->mode;
+	tmp.st_nlink = stat->nlink;
+	if (tmp.st_nlink != stat->nlink)
+		return -EOVERFLOW;
+	SET_UID(tmp.st_uid, stat->uid);
+	SET_GID(tmp.st_gid, stat->gid);
+#if BITS_PER_LONG == 32
+	tmp.st_rdev = old_encode_dev(stat->rdev);
+#else
+	tmp.st_rdev = new_encode_dev(stat->rdev);
+#endif
+#if BITS_PER_LONG == 32
+	if (stat->size > MAX_NON_LFS)
+		return -EOVERFLOW;
+#endif
+	tmp.st_size = stat->size;
+	tmp.st_atime = stat->atime.tv_sec;
+	tmp.st_mtime = stat->mtime.tv_sec;
+	tmp.st_ctime = stat->ctime.tv_sec;
+#ifdef STAT_HAVE_NSEC
+	tmp.st_atime_nsec = stat->atime.tv_nsec;
+	tmp.st_mtime_nsec = stat->mtime.tv_nsec;
+	tmp.st_ctime_nsec = stat->ctime.tv_nsec;
+#endif
+	tmp.st_blocks = stat->blocks;
+	tmp.st_blksize = stat->blksize;
+
+	memcpy(statbuf, &tmp, sizeof(tmp));
+	return 0;
+}
+
+int __init kern_sys_newlstat(const char *filename, struct stat *statbuf)
+{
+	int error;
+	struct path path;
+	struct kstat kstat;
+
+	error = kern_path(filename, 0, &path);
+	if (error)
+		return error;
+
+	error = vfs_getattr(path.mnt, path.dentry, &kstat);
+	if (error)
+		goto out;
+
+	cp_new_stat(&kstat, statbuf);
+out:
+	path_put(&path);
+	return error;
+}
+
+int __init kern_sys_mkdir(const char *pathname, int mode)
+{
+	int error;
+	struct dentry *dentry;
+	struct nameidata nd;
+
+	error = path_lookup(pathname, LOOKUP_PARENT, &nd);
+	if (error)
+		goto out_err;
+
+	dentry = lookup_create(&nd, 1);
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto out_unlock;
+	}
+
+	if (!IS_POSIXACL(nd.path.dentry->d_inode))
+		mode &= ~current_umask();
+
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
+
+	error = vfs_mkdir(nd.path.dentry->d_inode, dentry, mode);
+
+	mnt_drop_write(nd.path.mnt);
+out_dput:
+	dput(dentry);
+out_unlock:
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+	path_put(&nd.path);
+out_err:
+	return error;
+}
+
+int __init kern_sys_rmdir(const char *pathname)
+{
+	int error;
+	struct dentry *dentry;
+	struct nameidata nd;
+
+	error = path_lookup(pathname, LOOKUP_PARENT, &nd);
+	if (error)
+		return error;
+
+	switch(nd.last_type) {
+	case LAST_DOTDOT:
+		error = -ENOTEMPTY;
+		goto exit1;
+	case LAST_DOT:
+		error = -EINVAL;
+		goto exit1;
+	case LAST_ROOT:
+		error = -EBUSY;
+		goto exit1;
+	}
+
+	nd.flags &= ~LOOKUP_PARENT;
+
+	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+
+	dentry = lookup_hash(&nd);
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto exit2;
+	}
+
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto exit3;
+
+	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
+
+	mnt_drop_write(nd.path.mnt);
+exit3:
+	dput(dentry);
+exit2:
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+exit1:
+	path_put(&nd.path);
+	return error;
+}
+
+int __init kern_sys_mknod(const char *filename, int mode, unsigned dev)
+{
+	int error;
+	struct dentry *dentry;
+	struct nameidata nd;
+
+	if (S_ISDIR(mode))
+		return -EPERM;
+
+	error = path_lookup(filename, LOOKUP_PARENT, &nd);
+	if (error)
+		return error;
+
+	dentry = lookup_create(&nd, 0);
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto out_unlock;
+	}
+
+	if (!IS_POSIXACL(nd.path.dentry->d_inode))
+		mode &= ~current_umask();
+
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFIFO:
+	case S_IFSOCK:
+	case 0: /* zero mode translates to S_IFREG */
+		break;
+	case S_IFDIR:
+		error = -EPERM;
+		goto out_dput;
+	default:
+		error = -EINVAL;
+		goto out_dput;
+	}
+
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
+
+	switch (mode & S_IFMT) {
+	case 0:
+	case S_IFREG:
+		error = vfs_create(nd.path.dentry->d_inode,dentry, mode, &nd);
+		break;
+
+	case S_IFCHR:
+	case S_IFBLK:
+		error = vfs_mknod(nd.path.dentry->d_inode,dentry, mode,
+				  new_decode_dev(dev));
+		break;
+
+	case S_IFIFO:
+	case S_IFSOCK:
+		error = vfs_mknod(nd.path.dentry->d_inode,dentry, mode, 0);
+		break;
+	}
+
+	mnt_drop_write(nd.path.mnt);
+out_dput:
+	dput(dentry);
+out_unlock:
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+	path_put(&nd.path);
+
+	return error;
+}
+
+static int __init chown_common(struct path *path, uid_t user, gid_t group)
+{
+	int error;
+	struct iattr newattrs;
+	struct inode *inode = path->dentry->d_inode;
+
+	newattrs.ia_valid =  ATTR_CTIME;
+	if (user != (uid_t) -1) {
+		newattrs.ia_valid |= ATTR_UID;
+		newattrs.ia_uid = user;
+	}
+	if (group != (gid_t) -1) {
+		newattrs.ia_valid |= ATTR_GID;
+		newattrs.ia_gid = group;
+	}
+	if (!S_ISDIR(inode->i_mode))
+		newattrs.ia_valid |=
+			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
+
+	mutex_lock(&inode->i_mutex);
+	error = notify_change(path->dentry, &newattrs);
+	mutex_unlock(&inode->i_mutex);
+
+	return error;
+}
+
+int __init kern_sys_chown(const char *filename, uid_t user, gid_t group)
+{
+	int error;
+	struct path path;
+
+	error = kern_path(filename, LOOKUP_FOLLOW, &path);
+	if (error)
+		goto out;
+
+	error = mnt_want_write(path.mnt);
+	if (error)
+		goto out_release;
+
+	error = chown_common(&path, user, group);
+
+	mnt_drop_write(path.mnt);
+out_release:
+	path_put(&path);
+out:
+	return error;
+}
+
+int __init kern_sys_chmod(const char *filename, mode_t mode)
+{
+	int error;
+	struct path path;
+	struct inode *inode;
+	struct iattr newattrs;
+
+	error = kern_path(filename, LOOKUP_FOLLOW, &path);
+	if (error)
+		goto out;
+
+	inode = path.dentry->d_inode;
+
+	error = mnt_want_write(path.mnt);
+	if (error)
+		goto dput_and_out;
+
+	mutex_lock(&inode->i_mutex);
+
+	if (mode == (mode_t) -1)
+		mode = inode->i_mode;
+
+	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
+	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
+
+	error = notify_change(path.dentry, &newattrs);
+
+	mutex_unlock(&inode->i_mutex);
+	mnt_drop_write(path.mnt);
+dput_and_out:
+	path_put(&path);
+out:
+	return error;
+}
+
+int __init kern_sys_open(const char *filename, int flags, int mode)
+{
+	int fd;
+
+	if (force_o_largefile())
+		flags |= O_LARGEFILE;
+
+	fd = get_unused_fd_flags(flags);
+	if (fd >= 0) {
+		struct file *f = do_filp_open(AT_FDCWD, filename, flags,
+					      mode, 0);
+		if (IS_ERR(f)) {
+			put_unused_fd(fd);
+			fd = PTR_ERR(f);
+		} else {
+			fd_install(fd, f);
+		}
+	}
+	return fd;
+}
+
+int __init kern_sys_symlink(const char *oldname, const char *newname)
+{
+	int error;
+	struct dentry *dentry;
+	struct nameidata nd;
+
+	error = path_lookup(newname, LOOKUP_PARENT, &nd);
+	if (error)
+		goto out_putname;
+
+	dentry = lookup_create(&nd, 0);
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto out_unlock;
+	}
+
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
+
+	error = vfs_symlink(nd.path.dentry->d_inode, dentry, oldname);
+
+	mnt_drop_write(nd.path.mnt);
+out_dput:
+	dput(dentry);
+out_unlock:
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+	path_put(&nd.path);
+out_putname:
+	return error;
+}
+
+int __init kern_sys_lchown(const char *filename, uid_t user, gid_t group)
+{
+	int error;
+	struct path path;
+
+	error = kern_path(filename, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path);
+	if (error)
+		goto out;
+
+	error = mnt_want_write(path.mnt);
+	if (error)
+		goto out_release;
+
+	error = chown_common(&path, user, group);
+
+	mnt_drop_write(path.mnt);
+out_release:
+	path_put(&path);
+out:
+	return error;
+}
--
1.7.2.2

