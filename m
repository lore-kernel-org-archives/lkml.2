Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0HHPzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:55:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab0HHPzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:55:36 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>,
        Valdis.Kletnieks@vt.edu
Subject: [PATCH 28/39] union-mount: In-kernel file copyup routines
Date: Sun,  8 Aug 2010 11:52:45 -0400
Message-Id: <1281282776-5447-29-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a file on the read-only layer of a union mount is altered, it
must be copied up to the topmost read-write layer.  This patch creates
union_copyup() and its supporting routines.

Thanks to Valdis Kletnieks for a bug fix.

XXX - Miklos Szeredi points out: What happens if we crash halfway
through the file copyup?  Answer: A bug, the file is truncated.  Needs
fixing.

Cc: Valdis.Kletnieks@vt.edu
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/union.c |  323 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/union.h |    7 +-
 2 files changed, 329 insertions(+), 1 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index a91e8fc..103c436 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -24,6 +24,8 @@
 #include <linux/namei.h>
 #include <linux/file.h>
 #include <linux/security.h>
+#include <linux/splice.h>
+#include <linux/xattr.h>
 
 #include "union.h"
 
@@ -191,6 +193,72 @@ int needs_lookup_union(struct path *parent_path, struct path *path)
 	return 1;
 }
 
+/**
+ * union_copyup_xattr
+ *
+ * @old: dentry of original file
+ * @new: dentry of new copy
+ *
+ * Copy up extended attributes from the original file to the new one.
+ *
+ * XXX - Permissions?  For now, copying up every xattr.
+ */
+
+static int union_copyup_xattr(struct dentry *old, struct dentry *new)
+{
+	ssize_t list_size, size;
+	char *buf, *name, *value;
+	int error;
+
+	/* Check for xattr support */
+	if (!old->d_inode->i_op->getxattr ||
+	    !new->d_inode->i_op->getxattr)
+		return 0;
+
+	/* Find out how big the list of xattrs is */
+	list_size = vfs_listxattr(old, NULL, 0);
+	if (list_size <= 0)
+		return list_size;
+
+	/* Allocate memory for the list */
+	buf = kzalloc(list_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* Allocate memory for the xattr's value */
+	error = -ENOMEM;
+	value = kmalloc(XATTR_SIZE_MAX, GFP_KERNEL);
+	if (!value)
+		goto out;
+
+	/* Actually get the list of xattrs */
+	list_size = vfs_listxattr(old, buf, list_size);
+	if (list_size <= 0) {
+		error = list_size;
+		goto out_free_value;
+	}
+
+	for (name = buf; name < (buf + list_size); name += strlen(name) + 1) {
+		/* XXX Locking? old is on read-only fs */
+		size = vfs_getxattr(old, name, value, XATTR_SIZE_MAX);
+		if (size <= 0) {
+			error = size;
+			goto out_free_value;
+		}
+		/* XXX do we really need to check for size overflow? */
+		/* XXX locks new dentry, lock ordering problems? */
+		error = vfs_setxattr(new, name, value, size, 0);
+		if (error)
+			goto out_free_value;
+	}
+
+out_free_value:
+	kfree(value);
+out:
+	kfree(buf);
+	return error;
+}
+
 /*
  * union_create_topmost_dir - Create a matching dir in the topmost file system
  */
@@ -209,6 +277,13 @@ int union_create_topmost_dir(struct path *parent, struct qstr *name,
 
 	res = vfs_mkdir(parent->dentry->d_inode, topmost->dentry, mode);
 
+	if (res)
+		goto out;
+
+	res = union_copyup_xattr(lower->dentry, topmost->dentry);
+	if (res)
+		dput(topmost->dentry);
+out:
 	mnt_drop_write(parent->mnt);
 
 	return res;
@@ -427,3 +502,251 @@ generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,
 	}
 	return -ENOENT;
 }
+
+/**
+ * union_create_file
+ *
+ * @nd: namediata for source file
+ * @old: path of the source file
+ * @new: path of the new file, negative dentry
+ *
+ * Must already have mnt_want_write() on the mnt and the parent's
+ * i_mutex.
+ */
+
+static int union_create_file(struct nameidata *nd, struct path *old,
+			     struct dentry *new)
+{
+	struct path *parent = &nd->path;
+	BUG_ON(!mutex_is_locked(&parent->dentry->d_inode->i_mutex));
+
+	return vfs_create(parent->dentry->d_inode, new,
+			  old->dentry->d_inode->i_mode, nd);
+}
+
+/**
+ * union_create_symlink
+ *
+ * @nd: namediata for source symlink
+ * @old: path of the source symlink
+ * @new: path of the new symlink, negative dentry
+ *
+ * Must already have mnt_want_write() on the mnt and the parent's
+ * i_mutex.
+ */
+
+static int union_create_symlink(struct nameidata *nd, struct path *old,
+				struct dentry *new)
+{
+	void *cookie;
+	int error;
+
+	BUG_ON(!mutex_is_locked(&nd->path.dentry->d_inode->i_mutex));
+	/*
+	 * We want the contents of this symlink, not to follow it, so
+	 * this is modeled on generic_readlink() rather than
+	 * do_follow_link().
+	 */
+	nd->depth = 0;
+	cookie = old->dentry->d_inode->i_op->follow_link(old->dentry, nd);
+	if (IS_ERR(cookie))
+		return PTR_ERR(cookie);
+	/* Create a copy of the link on the top layer */
+	error = vfs_symlink(nd->path.dentry->d_inode, new,
+			    nd_get_link(nd));
+	if (old->dentry->d_inode->i_op->put_link)
+		old->dentry->d_inode->i_op->put_link(old->dentry, nd, cookie);
+	return error;
+}
+
+/**
+ * union_copyup_data - Copy up len bytes of old's data to new
+ *
+ * @old: path of source file
+ * @new_mnt: vfsmount of target file
+ * @new_dentry: dentry of target file
+ * @len: number of bytes to copy
+ */
+
+static int union_copyup_data(struct path *old, struct vfsmount *new_mnt,
+			     struct dentry *new_dentry, size_t len)
+{
+	struct file *old_file;
+	struct file *new_file;
+	const struct cred *cred = current_cred();
+	loff_t offset = 0;
+	long bytes;
+	int error = 0;
+
+	if (len == 0)
+		return 0;
+
+	/* Get reference to balance later fput() */
+	path_get(old);
+	old_file = dentry_open(old->dentry, old->mnt, O_RDONLY, cred);
+	if (IS_ERR(old_file))
+		return PTR_ERR(old_file);
+
+	mntget(new_mnt);
+	dget(new_dentry);
+	new_file = dentry_open(new_dentry, new_mnt, O_WRONLY, cred);
+	if (IS_ERR(new_file)) {
+		error = PTR_ERR(new_file);
+		goto out_fput;
+	}
+
+	bytes = do_splice_direct(old_file, &offset, new_file, len,
+				 SPLICE_F_MOVE);
+	if (bytes < 0)
+		error = bytes;
+
+	fput(new_file);
+out_fput:
+	fput(old_file);
+	return error;
+}
+
+/**
+ * __union_copyup_len - Copy up a file and len bytes of data
+ *
+ * @nd: nameidata for topmost parent dir
+ * @path: path of file to be copied up
+ * @len: number of bytes of file data to copy up
+ *
+ * Parent's i_mutex must be held by caller.  Newly copied up path is
+ * returned in @path and original is path_put().
+ */
+
+static int __union_copyup_len(struct nameidata *nd, struct path *path,
+			      size_t len)
+{
+	struct path *parent = &nd->path;
+	struct dentry *dentry;
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
+		/*
+		 * We raced with someone else and "lost."  That's
+		 * okay, they did all the work of copying up the file.
+		 * Note that currently data copyup happens under the
+		 * parent dir's i_mutex.  If we move it outside that,
+		 * we'll need some way of waiting for the data copyup
+		 * to complete here.
+		 */
+		error = 0;
+		goto out_newpath;
+	}
+	if (S_ISREG(path->dentry->d_inode->i_mode)) {
+		/* Create file */
+		error = union_create_file(nd, path, dentry);
+		if (error)
+			goto out_dput;
+		/* Copyup data */
+		error = union_copyup_data(path, parent->mnt, dentry, len);
+	} else {
+		BUG_ON(!S_ISLNK(path->dentry->d_inode->i_mode));
+		error = union_create_symlink(nd, path, dentry);
+	}
+	if (error) {
+		/* Most likely error: ENOSPC */
+		vfs_unlink(parent->dentry->d_inode, dentry);
+		goto out_dput;
+	}
+	/* XXX Copyup xattrs and any other dangly bits */
+	error = union_copyup_xattr(path->dentry, dentry);
+	if (error)
+		goto out_dput;
+out_newpath:
+	/* path_put() of original must happen before we copy in new */
+	path_put(path);
+	path->dentry = dentry;
+	path->mnt = mntget(parent->mnt);
+	return error;
+out_dput:
+	/* Don't path_put(path), let caller unwind */
+	dput(dentry);
+	return error;
+}
+
+/**
+ * do_union_copyup_len - Copy up a file given its path (and its parent's)
+ *
+ * @nd: nameidata for topmost parent dir
+ * @path: path of file to be copied up
+ * @copy_all: if set, copy all of the file's data and ignore @len
+ * @len: if @copy_all is not set, number of bytes of file data to copy up
+ *
+ * Newly copied up path is returned in @path.
+ */
+
+static int do_union_copyup_len(struct nameidata *nd, struct path *path,
+			       int copy_all, size_t len)
+{
+	struct path *parent = &nd->path;
+	int error;
+
+	if (!IS_DIR_UNIONED(parent->dentry))
+		return 0;
+	if (parent->mnt == path->mnt)
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
+		if (((size_t)len != len) || ((ssize_t)len != len))
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
+	size_t len;
+	len = i_size_read(path->dentry->d_inode);
+	if (((size_t)len != len) || ((ssize_t)len != len))
+		return -EFBIG;
+
+	return __union_copyup_len(nd, path, len);
+}
+
+/*
+ * Helper function to copy up part of a file
+ */
+int union_copyup_len(struct nameidata *nd, struct path *path, size_t len)
+{
+	return do_union_copyup_len(nd, path, 0, len);
+}
diff --git a/fs/union.h b/fs/union.h
index 80c2421..01fa183 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -59,7 +59,9 @@ int needs_lookup_union(struct path *, struct path *);
 int union_create_topmost_dir(struct path *, struct qstr *, struct path *,
 			     struct path *);
 extern int union_copyup_dir(struct path *);
-
+extern int union_copyup(struct nameidata *, struct path *);
+extern int __union_copyup(struct nameidata *, struct path *);
+extern int union_copyup_len(struct nameidata *, struct path *, size_t len);
 #else /* CONFIG_UNION_MOUNT */
 
 #define IS_MNT_UNION(x)			(0)
@@ -69,6 +71,9 @@ extern int union_copyup_dir(struct path *);
 #define needs_lookup_union(x, y)	({ (0); })
 #define union_create_topmost_dir(w, x, y, z)	({ BUG(); (NULL); })
 #define union_copyup_dir(x)		({ BUG(); (0); })
+#define union_copyup(x, y)		({ BUG(); (NULL); })
+#define __union_copyup(x, y)		({ BUG(); (NULL); })
+#define union_copyup_len(x, y, z)	({ BUG(); (NULL); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.3.3

