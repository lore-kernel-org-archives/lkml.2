Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030471Ab2CGV3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:29:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47153 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab2CGVXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:01 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 04/25] vfs: add i_op->atomic_open()
Date: Wed,  7 Mar 2012 22:22:21 +0100
Message-Id: <1331155362-11132-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new inode operation which is called on the last component of an open.
Using this the filesystem can look up, possibly create and open the file in one
atomic operation.  If it cannot perform this (e.g. the file type turned out to
be wrong) it may signal this by returning NULL instead of an open struct file
pointer.

i_op->atomic_open() is only called if the last component is negative or needs
lookup.  Handling cached positive dentries here doesn't add much value: these
can be opened using f_op->open().  If the cached file turns out to be invalid,
the open can be retried, this time using ->atomic_open() with a fresh dentry.

For now leave the old way of using open intents in lookup and revalidate in
place.  This will be removed once all the users are converted.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h      |    5 +
 fs/namei.c         |  231 +++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/open.c          |   27 ++++++
 include/linux/fs.h |    6 ++
 4 files changed, 258 insertions(+), 11 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 4d69fdd..10143de 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -87,12 +87,17 @@ extern struct super_block *user_get_super(dev_t);
 struct nameidata;
 extern struct file *nameidata_to_filp(struct nameidata *);
 extern void release_open_intent(struct nameidata *);
+struct opendata {
+	struct vfsmount *mnt;
+	struct file **filp;
+};
 struct open_flags {
 	int open_flag;
 	umode_t mode;
 	int acc_mode;
 	int intent;
 };
+
 extern struct file *do_filp_open(int dfd, const char *pathname,
 		const struct open_flags *op, int lookup_flags);
 extern struct file *do_file_open_root(struct dentry *, struct vfsmount *,
diff --git a/fs/namei.c b/fs/namei.c
index ff8bc94..835dcf1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2100,6 +2100,201 @@ static inline int open_to_namei_flags(int flag)
 	return flag;
 }
 
+static int may_o_create(struct path *dir, struct dentry *dentry, umode_t mode)
+{
+	int error = security_path_mknod(dir, dentry, mode, 0);
+	if (error)
+		return error;
+
+	error = may_create(dir->dentry->d_inode, dentry);
+	if (error)
+		return error;
+
+	return security_inode_create(dir->dentry->d_inode, dentry, mode);
+}
+
+static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
+				const struct open_flags *op,
+				int *want_write, int *create_error)
+{
+	struct inode *dir =  nd->path.dentry->d_inode;
+	unsigned open_flag = open_to_namei_flags(op->open_flag);
+	umode_t mode;
+	int error;
+	bool created = false;
+	int acc_mode;
+	struct opendata od;
+	struct file *filp;
+
+	BUG_ON(dentry->d_inode);
+
+	/* Don't create child dentry for a dead directory. */
+	if (unlikely(IS_DEADDIR(dir)))
+		return ERR_PTR(-ENOENT);
+
+	mode = op->mode & S_IALLUGO;
+	if ((open_flag & O_CREAT) && !IS_POSIXACL(dir))
+		mode &= ~current_umask();
+
+	if (open_flag & O_EXCL) {
+		open_flag &= ~O_TRUNC;
+		created = true;
+	}
+
+	/*
+	 * Checking write permission is tricky, bacuse we don't know if we are
+	 * going to actually need it: O_CREAT opens should work as long as the
+	 * file exists.  But checking existence breaks atomicity.  The trick is
+	 * to check access and if not granted clear O_CREAT from the flags.
+	 *
+	 * Another problem is returing the "right" error value (e.g. for an
+	 * O_EXCL open we want to return EEXIST not EROFS).
+	 */
+	if ((open_flag & (O_CREAT | O_TRUNC)) ||
+	    (open_flag & O_ACCMODE) != O_RDONLY) {
+		error = mnt_want_write(nd->path.mnt);
+		if (!error) {
+			*want_write = 1;
+		} else if (!(open_flag & O_CREAT)) {
+			/*
+			 * No O_CREATE -> atomicity not a requirement -> fall
+			 * back to lookup + open
+			 */
+			goto look_up;
+		} else if (open_flag & (O_EXCL | O_TRUNC)) {
+			/* Fall back and fail with the right error */
+			*create_error = error;
+			goto look_up;
+		} else {
+			/* No side effects, safe to clear O_CREAT */
+			*create_error = error;
+			open_flag &= ~O_CREAT;
+		}
+	}
+
+	if (open_flag & O_CREAT) {
+		error = may_o_create(&nd->path, dentry, op->mode);
+		if (error) {
+			*create_error = error;
+			if (open_flag & O_EXCL)
+				goto look_up;
+			open_flag &= ~O_CREAT;
+		}
+	}
+
+	if (nd->flags & LOOKUP_DIRECTORY)
+		open_flag |= O_DIRECTORY;
+
+	od.mnt = nd->path.mnt;
+	od.filp = &nd->intent.open.file;
+	filp = dir->i_op->atomic_open(dir, dentry, &od, open_flag, mode,
+				      &created);
+	if (IS_ERR(filp)) {
+		if (*create_error && PTR_ERR(filp) == -ENOENT)
+			filp = ERR_PTR(*create_error);
+		goto out;
+	}
+
+	acc_mode = op->acc_mode;
+	if (created) {
+		fsnotify_create(dir, dentry);
+		acc_mode = MAY_OPEN;
+	}
+
+	if (filp) {
+		/*
+		 * We didn't have the inode before the open, so check open
+		 * permission here.
+		 */
+		error = may_open(&filp->f_path, acc_mode, open_flag);
+		if (error)
+			goto out_fput;
+
+		error = open_check_o_direct(filp);
+		if (error)
+			goto out_fput;
+	}
+	*create_error = 0;
+
+out:
+	return filp;
+
+out_fput:
+	fput(filp);
+	return ERR_PTR(error);
+
+look_up:
+	return NULL;
+}
+
+/*
+ * Lookup and possibly open (and create) the last component
+ *
+ * Must be called with i_mutex held on parent.
+ *
+ * Returns open file or NULL on success, error otherwise.  NULL means no open
+ * was performed, only lookup.
+ */
+static struct file *lookup_open(struct nameidata *nd, struct path *path,
+				const struct open_flags *op, int *want_write)
+{
+	struct dentry *dir = nd->path.dentry;
+	struct inode *dir_inode = dir->d_inode;
+	struct dentry *dentry;
+	int error;
+	int create_error = 0;
+	bool need_lookup;
+
+	dentry = lookup_dcache(&nd->last, dir, nd, &need_lookup);
+	if (IS_ERR(dentry))
+		return ERR_CAST(dentry);
+
+	/* Cached positive dentry: will open in f_op->open */
+	if (!need_lookup && dentry->d_inode)
+		goto out_no_open;
+
+	if ((nd->flags & LOOKUP_OPEN) && dir_inode->i_op->atomic_open) {
+		struct file *filp;
+
+		filp = atomic_open(nd, dentry, op, want_write, &create_error);
+		if (filp) {
+			dput(dentry);
+			return filp;
+		}
+		/* fall back to plain lookup */
+	}
+
+	if (need_lookup) {
+		BUG_ON(dentry->d_inode);
+
+		dentry = lookup_real(dir_inode, dentry, nd);
+		if (IS_ERR(dentry))
+			return ERR_CAST(dentry);
+
+		if (create_error) {
+			int open_flag = op->open_flag;
+
+			error = create_error;
+			if ((open_flag & O_EXCL) && !dentry->d_inode)
+				goto out_dput;
+			if (!(open_flag & O_EXCL) && (open_flag & O_TRUNC) &&
+			    dentry->d_inode && S_ISREG(dentry->d_inode->i_mode))
+				goto out_dput;
+
+			/* will fail later, go on to get the right error */
+		}
+	}
+
+out_no_open:
+	path->dentry = dentry;
+	path->mnt = nd->path.mnt;
+	return NULL;
+
+out_dput:
+	dput(dentry);
+	return ERR_PTR(error);
+}
+
 /*
  * Handle the last step of open()
  */
@@ -2180,15 +2375,16 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 
 	mutex_lock(&dir->d_inode->i_mutex);
 
-	dentry = lookup_hash(nd);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry)) {
+	filp = lookup_open(nd, path, op, &want_write);
+	if (filp) {
 		mutex_unlock(&dir->d_inode->i_mutex);
-		goto exit;
-	}
+		if (IS_ERR(filp))
+			goto out;
 
-	path->dentry = dentry;
-	path->mnt = nd->path.mnt;
+		audit_inode(pathname, filp->f_path.dentry);
+		goto opened;
+	}
+	dentry = path->dentry;
 
 	/* Negative dentry, create the file if O_CREAT */
 	if (!dentry->d_inode) {
@@ -2207,10 +2403,12 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		 * a permanent write count is taken through
 		 * the 'struct file' in nameidata_to_filp().
 		 */
-		error = mnt_want_write(nd->path.mnt);
-		if (error)
-			goto exit_mutex_unlock;
-		want_write = 1;
+		if (!want_write) {
+			error = mnt_want_write(nd->path.mnt);
+			if (error)
+				goto exit_mutex_unlock;
+			want_write = 1;
+		}
 		/* Don't check for write permission, don't truncate */
 		open_flag &= ~O_TRUNC;
 		will_truncate = 0;
@@ -2232,6 +2430,16 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	 */
 	mutex_unlock(&dir->d_inode->i_mutex);
 
+	/*
+	 * If atomic_open() acquired write access it is dropped now due to
+	 * possible mount and symlink following (this might be optimized away if
+	 * necessary...)
+	 */
+	if (want_write) {
+		mnt_drop_write(nd->path.mnt);
+		want_write = 0;
+	}
+
 	error = -EEXIST;
 	if (open_flag & O_EXCL)
 		goto exit_dput;
@@ -2287,6 +2495,7 @@ common:
 	if (error)
 		goto exit;
 	filp = nameidata_to_filp(nd);
+opened:
 	if (!IS_ERR(filp)) {
 		error = ima_file_check(filp, op->acc_mode);
 		if (error) {
diff --git a/fs/open.c b/fs/open.c
index 6acfd2d..238c5ae 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -800,6 +800,33 @@ out_err:
 EXPORT_SYMBOL_GPL(lookup_instantiate_filp);
 
 /**
+ * finish_open - set up a not fully instantiated file
+ * @od: opaque open data
+ * @dentry: pointer to dentry
+ * @open: open callback
+ *
+ * This can be used to finish opening a file passed to i_op->atomic_open() or
+ * i_op->atomic_create().
+ *
+ * If the open callback is set to NULL, then the standard f_op->open()
+ * filesystem callback is substituted.
+ */
+struct file *finish_open(struct opendata *od, struct dentry *dentry,
+			 int (*open)(struct inode *, struct file *))
+{
+	struct file *filp;
+
+	filp = *(od->filp);
+	*(od->filp) = NULL;
+
+	mntget(od->mnt);
+	dget(dentry);
+
+	return do_dentry_open(dentry, od->mnt, filp, open, current_cred());
+}
+EXPORT_SYMBOL(finish_open);
+
+/**
  * nameidata_to_filp - convert a nameidata to an open filp.
  * @nd: pointer to nameidata
  * @flags: open flags
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 69cd5bb..3a47ecd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -412,6 +412,7 @@ struct kstatfs;
 struct vm_area_struct;
 struct vfsmount;
 struct cred;
+struct opendata;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1653,6 +1654,9 @@ struct inode_operations {
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	struct file * (*atomic_open)(struct inode *, struct dentry *,
+				     struct opendata *, unsigned open_flag,
+				     umode_t create_mode, bool *created);
 } ____cacheline_aligned;
 
 struct seq_file;
@@ -2027,6 +2031,8 @@ extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
 				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 extern char * getname(const char __user *);
+extern struct file *finish_open(struct opendata *od, struct dentry *dentry,
+				int (*open)(struct inode *, struct file *));
 
 /* fs/ioctl.c */
 
-- 
1.7.7

