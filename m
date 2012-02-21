Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2BUTyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:54:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440Ab2BUTx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 56/73] union-mount: In-kernel file copyup routines [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com> (Further development)
Date: Tue, 21 Feb 2012 18:04:30 +0000
Message-ID: <20120221180430.25235.22576.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a file on the read-only layer of a union mount is altered, it
must be copied up to the topmost read-write layer.  This patch creates
union_copyup() and its supporting routines.

Thanks to Valdis Kletnieks <Valdis.Kletnieks@vt.edu> for a bug fix.

XXX - split up

XXX - If dir xattr copyup fails, delete the newly created dir

XXX - set correct owner after copyup

XXX - reimplement with get_unlinked_inode()

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com> (Further development)
---

 fs/union.c |  266 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/union.h |   31 +++++++
 2 files changed, 296 insertions(+), 1 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index 8efed50..b8ee42d 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -24,6 +24,8 @@
 #include <linux/xattr.h>
 #include <linux/file.h>
 #include <linux/security.h>
+#include <linux/splice.h>
+#include <linux/xattr.h>
 
 #include "union.h"
 
@@ -197,9 +199,16 @@ int union_create_topmost_dir(struct path *parent, struct qstr *name,
 
 	error = union_copyup_xattr(lower->dentry, topmost->dentry);
 	if (error)
-		dput(topmost->dentry);
+		goto out_rmdir;
 
 	fsnotify_mkdir(dir, topmost->dentry);
+
+	mnt_drop_write(parent->mnt);
+
+	return 0;
+out_rmdir:
+	/* XXX rm created dir */
+	dput(topmost->dentry);
 out:
 	mnt_drop_write(parent->mnt);
 	return error;
@@ -439,3 +448,258 @@ int generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,
 	return -ENOENT;
 }
 EXPORT_SYMBOL(generic_readdir_fallthru);
+
+/**
+ * union_create_file
+ * @nd: namediata for source file
+ * @lower: path of the source file
+ * @new: path of the new file, negative dentry
+ *
+ * Must already have mnt_want_write() on the mnt and the parent's i_mutex.
+ */
+static int union_create_file(struct nameidata *nd, struct path *lower,
+			     struct dentry *new)
+{
+	struct path *parent = &nd->path;
+
+	BUG_ON(!mutex_is_locked(&parent->dentry->d_inode->i_mutex));
+
+	return vfs_create(parent->dentry->d_inode, new,
+			  lower->dentry->d_inode->i_mode, nd);
+}
+
+/**
+ * union_create_symlink
+ * @nd: namediata for source symlink
+ * @lower: path of the source symlink
+ * @new: path of the new symlink, negative dentry
+ *
+ * Must already have mnt_want_write() on the mnt and the parent's i_mutex.
+ */
+static int union_create_symlink(struct nameidata *nd, struct path *lower,
+				struct dentry *new)
+{
+	struct path *parent = &nd->path;
+	void *cookie;
+	int error;
+
+	BUG_ON(!mutex_is_locked(&parent->dentry->d_inode->i_mutex));
+
+	/* We want the contents of this symlink, not to follow it, so this is
+	 * modeled on generic_readlink() rather than do_follow_link().
+	 */
+	nd->depth = 0;
+	cookie = lower->dentry->d_inode->i_op->follow_link(lower->dentry, nd);
+	if (IS_ERR(cookie))
+		return PTR_ERR(cookie);
+
+	/* Create a copy of the link on the top layer */
+	error = vfs_symlink(parent->dentry->d_inode, new, nd_get_link(nd));
+	if (lower->dentry->d_inode->i_op->put_link)
+		lower->dentry->d_inode->i_op->put_link(lower->dentry, nd, cookie);
+	return error;
+}
+
+/**
+ * union_copyup_data - Copy up len bytes of old's data to new
+ * @lower: path of source file in lower layer
+ * @new_mnt: vfsmount of target file
+ * @new_dentry: dentry of target file
+ * @len: number of bytes to copy
+ */
+static int union_copyup_data(struct path *lower, struct vfsmount *new_mnt,
+			     struct dentry *new_dentry, size_t len)
+{
+	const struct cred *cred = current_cred();
+	struct file *lower_file;
+	struct file *new_file;
+	loff_t offset = 0;
+	long bytes;
+	int error = 0;
+
+	if (len == 0)
+		return 0;
+
+	/* Get reference to balance later fput() */
+	path_get(lower);
+	lower_file = dentry_open(lower->dentry, lower->mnt, O_RDONLY, cred);
+	if (IS_ERR(lower_file))
+		return PTR_ERR(lower_file);
+
+	mntget(new_mnt);
+	dget(new_dentry);
+	new_file = dentry_open(new_dentry, new_mnt, O_WRONLY, cred);
+	if (IS_ERR(new_file)) {
+		error = PTR_ERR(new_file);
+		goto out_fput;
+	}
+
+	bytes = do_splice_direct(lower_file, &offset, new_file, len,
+				 SPLICE_F_MOVE);
+	if (bytes < 0)
+		error = bytes;
+
+	fput(new_file);
+out_fput:
+	fput(lower_file);
+	return error;
+}
+
+/**
+ * union_copyup_file - Copy up a regular file, symlink or special file
+ * @nd: nameidata for topmost parent dir
+ * @lower: path of file to be copied up
+ * @dentry: dentry to copy up to
+ * @len: number of bytes of file data to copy up
+ */
+int union_copyup_file(struct nameidata *nd, struct path *lower,
+		      struct dentry *dentry, size_t len)
+{
+	struct path *parent = &nd->path;
+	int error;
+
+	BUG_ON(!mutex_is_locked(&parent->dentry->d_inode->i_mutex));
+
+	if (S_ISREG(lower->dentry->d_inode->i_mode)) {
+		error = union_create_file(nd, lower, dentry);
+		if (error)
+			return error;
+		error = union_copyup_data(lower, parent->mnt, dentry, len);
+	} else if (S_ISLNK(lower->dentry->d_inode->i_mode)) {
+		return union_create_symlink(nd, lower, dentry);
+	} else {
+		/* Don't currently support copyup of special files, though in
+		 * theory there's no reason we couldn't at least copy up
+		 * blockdev, chrdev and FIFO files
+		 */
+		return -EXDEV;
+	}
+	if (error)
+		/* Most likely error: ENOSPC */
+		vfs_unlink(parent->dentry->d_inode, dentry);
+
+	return error;
+}
+
+/**
+ * __union_copyup_len - Copy up a file and len bytes of data
+ * @nd: nameidata for topmost parent dir
+ * @path: path of file to be copied up
+ * @len: number of bytes of file data to copy up
+ *
+ * Parent's i_mutex must be held by caller.  Newly copied up path is
+ * returned in @path and original is path_put().
+ */
+static int __union_copyup_len(struct nameidata *nd, struct path *path,
+			      size_t len)
+{
+	struct dentry *dentry;
+	struct path *parent = &nd->path;
+	int error;
+
+	BUG_ON(!mutex_is_locked(&parent->dentry->d_inode->i_mutex));
+
+	dentry = lookup_one_len(path->dentry->d_name.name, parent->dentry,
+				path->dentry->d_name.len);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	if (dentry->d_inode) {
+		/* We raced with someone else and "lost".  That's okay, they
+		 * did all the work of copying up the file.
+		 *
+		 * Note that currently data copyup happens under the parent
+		 * dir's i_mutex.  If we move it outside that, we'll need some
+		 * way of waiting for the data copyup to complete here.
+		 */
+		error = 0;
+	} else {
+		error = union_copyup_file(nd, path, dentry, len);
+		if (error < 0)
+			goto out_dput;
+	}
+
+	/* Move to the new dentry */
+	path_put(path);
+	path->dentry = dentry;
+	path->mnt = mntget(parent->mnt);
+	return error;
+
+out_dput:
+	/* Don't path_put(path), let caller unwind */
+	dput(dentry);
+	return error;
+}
+
+/**
+ * do_union_copyup_len - Copy up a file given its path (and its parent's)
+ * @nd: nameidata for topmost parent dir
+ * @path: path of file to be copied up
+ * @copy_all: if set, copy all of the file's data and ignore @len
+ * @len: if @copy_all is not set, number of bytes of file data to copy up
+ *
+ * Newly copied up path is returned in @path.
+ */
+static int do_union_copyup_len(struct nameidata *nd, struct path *path,
+			       int copy_all, size_t len)
+{
+	struct path *parent = &nd->path;
+	int error;
+
+	if (!IS_DIR_UNIONED(parent->dentry) ||
+	    parent->mnt == path->mnt)
+		return 0;
+	if (!S_ISREG(path->dentry->d_inode->i_mode) &&
+	    !S_ISLNK(path->dentry->d_inode->i_mode))
+		return 0;
+
+	BUG_ON(!S_ISDIR(parent->dentry->d_inode->i_mode));
+
+	mutex_lock(&parent->dentry->d_inode->i_mutex);
+	error = -ENOENT;
+	if (IS_DEADDIR(parent->dentry->d_inode))
+		goto out_unlock;
+
+	if (copy_all && S_ISREG(path->dentry->d_inode->i_mode)) {
+		error = -EFBIG;
+		len = i_size_read(path->dentry->d_inode);
+		/* Check for overflow of file size */
+		if ((ssize_t)len != len)
+			goto out_unlock;
+	}
+
+	error = __union_copyup_len(nd, path, len);
+
+out_unlock:
+	mutex_unlock(&parent->dentry->d_inode->i_mutex);
+	return error;
+}
+
+/*
+ * Helper function to copy up all of a file
+ */
+int union_copyup(struct nameidata *nd, struct path *path)
+{
+	return do_union_copyup_len(nd, path, 1, 0);
+}
+
+/*
+ * Unlocked helper function to copy up all of a file
+ */
+int __union_copyup(struct nameidata *nd, struct path *path)
+{
+	loff_t len;
+	len = i_size_read(path->dentry->d_inode);
+	if ((ssize_t)len != len)
+		return -EFBIG;
+
+	return __union_copyup_len(nd, path, len);
+}
+
+/*
+ * Helper function to copy up part of a file for truncate and O_TRUNC.
+ */
+int union_copyup_len(struct nameidata *nd, struct path *path, size_t len)
+{
+	return do_union_copyup_len(nd, path, 0, len);
+}
diff --git a/fs/union.h b/fs/union.h
index 46944b9..62d8ef5 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -19,6 +19,7 @@
 #include <linux/mount.h>
 #include <linux/dcache.h>
 #include <linux/path.h>
+#include <linux/namei.h>
 #include <linux/bug.h>
 
 /*
@@ -73,6 +74,11 @@ extern int union_create_topmost_dir(struct path *, struct qstr *, struct path *,
 extern int union_copyup_dir(struct path *);
 extern int generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,
 				    int namlen, ino_t *ino, unsigned char *d_type);
+extern int union_copyup(struct nameidata *, struct path *);
+extern int __union_copyup(struct nameidata *, struct path *);
+extern int union_copyup_len(struct nameidata *, struct path *, size_t len);
+extern int union_copyup_file(struct nameidata *nd, struct path *lower,
+			     struct dentry *dentry, size_t len);
 
 static inline
 struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
@@ -147,4 +153,29 @@ int generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,
 	return 0;
 }
 
+static inline int union_copyup(struct nameidata *nd, struct path *path)
+{
+	BUG();
+	return 0;
+}
+
+static inline int __union_copyup(struct nameidata *nd, struct path *path)
+{
+	BUG();
+	return 0;
+}
+
+static inline int union_copyup_len(struct nameidata *nd, struct path *path,
+				   size_t len)
+{
+	BUG();
+	return 0;
+}
+
+static inline int union_copyup_file(struct nameidata *nd, struct path *lower,
+				    struct dentry *dentry, size_t len)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_UNION_MOUNT */

