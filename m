Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab0DOXKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:10:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab0DOXHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:07:19 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 26/35] union-mount: In-kernel copyup routines
Date: Thu, 15 Apr 2010 16:04:33 -0700
Message-Id: <1271372682-21225-27-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-26-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
 <1271372682-21225-13-git-send-email-vaurora@redhat.com>
 <1271372682-21225-14-git-send-email-vaurora@redhat.com>
 <1271372682-21225-15-git-send-email-vaurora@redhat.com>
 <1271372682-21225-16-git-send-email-vaurora@redhat.com>
 <1271372682-21225-17-git-send-email-vaurora@redhat.com>
 <1271372682-21225-18-git-send-email-vaurora@redhat.com>
 <1271372682-21225-19-git-send-email-vaurora@redhat.com>
 <1271372682-21225-20-git-send-email-vaurora@redhat.com>
 <1271372682-21225-21-git-send-email-vaurora@redhat.com>
 <1271372682-21225-22-git-send-email-vaurora@redhat.com>
 <1271372682-21225-23-git-send-email-vaurora@redhat.com>
 <1271372682-21225-24-git-send-email-vaurora@redhat.com>
 <1271372682-21225-25-git-send-email-vaurora@redhat.com>
 <1271372682-21225-26-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a file on the read-only layer of a union mount is altered, it
must be copied up to the topmost read-write layer.  This patch creates
union_copyup() and its supporting routines.
---
 fs/union.c            |  246 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/union.h |    7 +-
 2 files changed, 252 insertions(+), 1 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index e2384ad..944c720 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -26,6 +26,7 @@
 #include <linux/namei.h>
 #include <linux/file.h>
 #include <linux/security.h>
+#include <linux/splice.h>
 
 /*
  * This is borrowed from fs/inode.c. The hashtable for lookups. Somebody
@@ -633,3 +634,248 @@ out_fput:
 	mnt_drop_write(topmost_path->mnt);
 	return res;
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
+
+	printk(KERN_INFO "%s: copying up symlink\n", new->d_name.name);
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
+ * @old: source file
+ * @new: target file
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
+	int error;
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
+	dget(new_dentry);
+	mntget(new_mnt);
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
+ * union_do_copyup_path_len - Copy up a file and len bytes of data
+ *
+ * @parent: parent directory's path
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
+ * union_copyup_path - Copy up a file given its path (and its parent's)
+ *
+ * @parent: parent directory's path
+ * @path: path of file to be copied up
+ * @newpath: return path of newly copied up file
+ * @copy_all: if set, copy all of the file's data and ignore @len
+ * @len: if @copy_all is not set, number of bytes of file data to copy up
+ */
+
+int do_union_copyup_len(struct nameidata *nd, struct path *path, int copy_all,
+			size_t len)
+{
+	struct path *parent = &nd->path;
+	int error;
+
+	if (!IS_UNIONED_DIR(parent))
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
+
diff --git a/include/linux/union.h b/include/linux/union.h
index 66deeb2..21254c6 100644
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -52,7 +52,9 @@ extern struct dentry * union_create_topmost_dir(struct path *, struct qstr *,
 extern int attach_mnt_union(struct vfsmount *, struct vfsmount *);
 extern void detach_mnt_union(struct vfsmount *);
 extern int union_copyup_dir(struct path *);
-
+extern int union_copyup(struct nameidata *, struct path *);
+extern int __union_copyup(struct nameidata *, struct path *);
+extern int union_copyup_len(struct nameidata *, struct path *, size_t len);
 #else /* CONFIG_UNION_MOUNT */
 
 #define IS_MNT_UNION(x)			(0)
@@ -66,6 +68,9 @@ extern int union_copyup_dir(struct path *);
 #define attach_mnt_union(x, y)		do { } while (0)
 #define detach_mnt_union(x)		do { } while (0)
 #define union_copyup_dir(x)		({ BUG(); (0); })
+#define union_copyup(x, y)		({ BUG(); (NULL); })
+#define __union_copyup(x, y)		({ BUG(); (NULL); })
+#define union_copyup_len(x, y, z)	({ BUG(); (NULL); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.3.3

