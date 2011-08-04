Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1HDMz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:55:59 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38011 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab1HDMyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:54:00 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, penberg@kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 1/8] vfs: add i_op->open()
Date: Thu,  4 Aug 2011 14:53:30 +0200
Message-Id: <1312462417-8826-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1312462417-8826-1-git-send-email-miklos@szeredi.hu>
References: <1312462417-8826-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new inode operation i_op->open().  This is for stacked
filesystems that want to return a struct file from a different
filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/open.c          |   76 ++++++++++++++++++++++++++++++++++------------------
 include/linux/fs.h |    2 +
 2 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index f711921..97eeed3 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -644,8 +644,7 @@ static inline int __get_file_write_access(struct inode *inode,
 	return error;
 }
 
-static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
-					struct file *f,
+static struct file *__dentry_open(struct path *path, struct file *f,
 					int (*open)(struct inode *, struct file *),
 					const struct cred *cred)
 {
@@ -653,15 +652,16 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
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
@@ -669,8 +669,7 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 	}
 
 	f->f_mapping = inode->i_mapping;
-	f->f_path.dentry = dentry;
-	f->f_path.mnt = mnt;
+	f->f_path = *path;
 	f->f_pos = 0;
 	file_sb_list_add(f, inode->i_sb);
 
@@ -723,7 +722,7 @@ cleanup_all:
 			 * here, so just reset the state.
 			 */
 			file_reset_write(f);
-			mnt_drop_write(mnt);
+			mnt_drop_write(path->mnt);
 		}
 	}
 	file_sb_list_del(f);
@@ -731,8 +730,7 @@ cleanup_all:
 	f->f_path.mnt = NULL;
 cleanup_file:
 	put_filp(f);
-	dput(dentry);
-	mntput(mnt);
+	path_put(path);
 	return ERR_PTR(error);
 }
 
@@ -758,14 +756,14 @@ cleanup_file:
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
@@ -794,10 +792,17 @@ struct file *nameidata_to_filp(struct nameidata *nd)
 
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
 
@@ -808,26 +813,45 @@ struct file *nameidata_to_filp(struct nameidata *nd)
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 786b3b1..933e59c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1605,6 +1605,7 @@ struct inode_operations {
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	struct file *(*open)(struct dentry *, int flags, const struct cred *);
 } ____cacheline_aligned;
 
 struct seq_file;
@@ -2009,6 +2010,7 @@ extern long do_sys_open(int dfd, const char __user *filename, int flags,
 extern struct file *filp_open(const char *, int, int);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int);
+extern struct file *vfs_open(struct path *, int flags, const struct cred *);
 extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
 				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
-- 
1.7.3.4

