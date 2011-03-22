Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1CVPbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:31:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46978 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1CVPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:30:21 -0400
Message-Id: <20110322153014.560003169@szeredi.hu>
References: <20110322152602.053930811@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 22 Mar 2011 16:26:03 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
Subject: [PATCH 1/6 v7] vfs: add i_op->open()
Content-Disposition: inline; filename=vfs-add-i_op-open.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new inode operation i_op->open().  This is for stacked
filesystems that want to return a struct file from a different
filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/open.c          |   76 ++++++++++++++++++++++++++++++++++-------------------
 include/linux/fs.h |    2 +
 2 files changed, 52 insertions(+), 26 deletions(-)

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2011-03-22 15:11:27.000000000 +0100
+++ linux-2.6/include/linux/fs.h	2011-03-22 15:11:30.000000000 +0100
@@ -1597,6 +1597,7 @@ struct inode_operations {
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	struct file *(*open)(struct dentry *, int flags, const struct cred *);
 } ____cacheline_aligned;
 
 struct seq_file;
@@ -1991,6 +1992,7 @@ extern long do_sys_open(int dfd, const c
 extern struct file *filp_open(const char *, int, int);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int);
+extern struct file *vfs_open(struct path *, int flags, const struct cred *);
 extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
 				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2011-03-22 15:11:27.000000000 +0100
+++ linux-2.6/fs/open.c	2011-03-22 15:11:30.000000000 +0100
@@ -666,8 +666,7 @@ static inline int __get_file_write_acces
 	return error;
 }
 
-static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
-					struct file *f,
+static struct file *__dentry_open(struct path *path, struct file *f,
 					int (*open)(struct inode *, struct file *),
 					const struct cred *cred)
 {
@@ -675,15 +674,16 @@ static struct file *__dentry_open(struct
 	struct inode *inode;
 	int error;
 
+	path_get(path);
 	f->f_mode = OPEN_FMODE(f->f_flags) | FMODE_LSEEK |
 				FMODE_PREAD | FMODE_PWRITE;
 
 	if (unlikely(f->f_flags & O_PATH))
 		f->f_mode = FMODE_PATH;
 
-	inode = dentry->d_inode;
+	inode = path->dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
-		error = __get_file_write_access(inode, mnt);
+		error = __get_file_write_access(inode, path->mnt);
 		if (error)
 			goto cleanup_file;
 		if (!special_file(inode->i_mode))
@@ -691,8 +691,7 @@ static struct file *__dentry_open(struct
 	}
 
 	f->f_mapping = inode->i_mapping;
-	f->f_path.dentry = dentry;
-	f->f_path.mnt = mnt;
+	f->f_path = *path;
 	f->f_pos = 0;
 	file_sb_list_add(f, inode->i_sb);
 
@@ -745,7 +744,7 @@ static struct file *__dentry_open(struct
 			 * here, so just reset the state.
 			 */
 			file_reset_write(f);
-			mnt_drop_write(mnt);
+			mnt_drop_write(path->mnt);
 		}
 	}
 	file_sb_list_del(f);
@@ -753,8 +752,7 @@ static struct file *__dentry_open(struct
 	f->f_path.mnt = NULL;
 cleanup_file:
 	put_filp(f);
-	dput(dentry);
-	mntput(mnt);
+	path_put(path);
 	return ERR_PTR(error);
 }
 
@@ -780,14 +778,14 @@ static struct file *__dentry_open(struct
 struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry,
 		int (*open)(struct inode *, struct file *))
 {
+	struct path path = { .dentry = dentry, .mnt = nd->path.mnt };
 	const struct cred *cred = current_cred();
 
 	if (IS_ERR(nd->intent.open.file))
 		goto out;
 	if (IS_ERR(dentry))
 		goto out_err;
-	nd->intent.open.file = __dentry_open(dget(dentry), mntget(nd->path.mnt),
-					     nd->intent.open.file,
+	nd->intent.open.file = __dentry_open(&path, nd->intent.open.file,
 					     open, cred);
 out:
 	return nd->intent.open.file;
@@ -816,10 +814,17 @@ struct file *nameidata_to_filp(struct na
 
 	/* Has the filesystem initialised the file for us? */
 	if (filp->f_path.dentry == NULL) {
-		path_get(&nd->path);
-		filp = __dentry_open(nd->path.dentry, nd->path.mnt, filp,
-				     NULL, cred);
+		struct inode *inode = nd->path.dentry->d_inode;
+
+		if (inode->i_op->open) {
+			int flags = filp->f_flags;
+			put_filp(filp);
+			filp = inode->i_op->open(nd->path.dentry, flags, cred);
+		} else {
+			filp = __dentry_open(&nd->path, filp, NULL, cred);
+		}
 	}
+
 	return filp;
 }
 
@@ -830,26 +835,45 @@ struct file *nameidata_to_filp(struct na
 struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags,
 			 const struct cred *cred)
 {
-	int error;
-	struct file *f;
-
-	validate_creds(cred);
+	struct path path = { .dentry = dentry, .mnt = mnt };
+	struct file *ret;
 
 	/* We must always pass in a valid mount pointer. */
 	BUG_ON(!mnt);
 
-	error = -ENFILE;
+	ret = vfs_open(&path, flags, cred);
+	path_put(&path);
+
+	return ret;
+}
+EXPORT_SYMBOL(dentry_open);
+
+/**
+ * vfs_open - open the file at the given path
+ * @path: path to open
+ * @flags: open flags
+ * @cred: credentials to use
+ *
+ * Open the file.  If successful, the returned file will have acquired
+ * an additional reference for path.
+ */
+struct file *vfs_open(struct path *path, int flags, const struct cred *cred)
+{
+	struct file *f;
+	struct inode *inode = path->dentry->d_inode;
+
+	validate_creds(cred);
+
+	if (inode->i_op->open)
+		return inode->i_op->open(path->dentry, flags, cred);
 	f = get_empty_filp();
-	if (f == NULL) {
-		dput(dentry);
-		mntput(mnt);
-		return ERR_PTR(error);
-	}
+	if (f == NULL)
+		return ERR_PTR(-ENFILE);
 
 	f->f_flags = flags;
-	return __dentry_open(dentry, mnt, f, NULL, cred);
+	return __dentry_open(path, f, NULL, cred);
 }
-EXPORT_SYMBOL(dentry_open);
+EXPORT_SYMBOL(vfs_open);
 
 static void __put_unused_fd(struct files_struct *files, unsigned int fd)
 {

-- 
