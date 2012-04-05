Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2DEPAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:00:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62866 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2DEO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:14 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 22/34] vfs: add i_op->atomic_open()
Date: Thu,  5 Apr 2012 16:58:48 +0200
Message-Id: <1333637940-31884-23-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
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
 fs/internal.h      |    5 ++
 fs/namei.c         |  203 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/open.c          |   42 +++++++++++
 include/linux/fs.h |    7 ++
 4 files changed, 255 insertions(+), 2 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 4d69fdd..78c5c47 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -87,6 +87,11 @@ extern struct super_block *user_get_super(dev_t);
 struct nameidata;
 extern struct file *nameidata_to_filp(struct nameidata *);
 extern void release_open_intent(struct nameidata *);
+struct opendata {
+	struct dentry *dentry;
+	struct vfsmount *mnt;
+	struct file **filp;
+};
 struct open_flags {
 	int open_flag;
 	umode_t mode;
diff --git a/fs/namei.c b/fs/namei.c
index 4815607..4d505a4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2218,6 +2218,176 @@ static inline int open_to_namei_flags(int flag)
 	return flag;
 }
 
+static int may_o_create(struct path *dir, struct dentry *dentry, umode_t mode)
+{
+	int error = security_path_mknod(dir, dentry, mode, 0);
+	if (error)
+		return error;
+
+	error = inode_permission(dir->dentry->d_inode, MAY_WRITE | MAY_EXEC);
+	if (error)
+		return error;
+
+	return security_inode_create(dir->dentry->d_inode, dentry, mode);
+}
+
+static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
+				struct path *path, const struct open_flags *op,
+				int *want_write, bool need_lookup,
+				bool *created)
+{
+	struct inode *dir =  nd->path.dentry->d_inode;
+	unsigned open_flag = open_to_namei_flags(op->open_flag);
+	umode_t mode;
+	int error;
+	int acc_mode;
+	struct opendata od;
+	struct file *filp;
+	int create_error = 0;
+	struct dentry *const DENTRY_NOT_SET = (void *) -1UL;
+
+	BUG_ON(dentry->d_inode);
+
+	/* Don't create child dentry for a dead directory. */
+	if (unlikely(IS_DEADDIR(dir))) {
+		filp = ERR_PTR(-ENOENT);
+		goto out;
+	}
+
+	mode = op->mode & S_IALLUGO;
+	if ((open_flag & O_CREAT) && !IS_POSIXACL(dir))
+		mode &= ~current_umask();
+
+	if (open_flag & O_EXCL) {
+		open_flag &= ~O_TRUNC;
+		*created = true;
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
+			goto no_open;
+		} else if (open_flag & (O_EXCL | O_TRUNC)) {
+			/* Fall back and fail with the right error */
+			create_error = error;
+			goto no_open;
+		} else {
+			/* No side effects, safe to clear O_CREAT */
+			create_error = error;
+			open_flag &= ~O_CREAT;
+		}
+	}
+
+	if (open_flag & O_CREAT) {
+		error = may_o_create(&nd->path, dentry, op->mode);
+		if (error) {
+			create_error = error;
+			if (open_flag & O_EXCL)
+				goto no_open;
+			open_flag &= ~O_CREAT;
+		}
+	}
+
+	if (nd->flags & LOOKUP_DIRECTORY)
+		open_flag |= O_DIRECTORY;
+
+	od.dentry = DENTRY_NOT_SET;
+	od.mnt = nd->path.mnt;
+	od.filp = &nd->intent.open.file;
+	filp = dir->i_op->atomic_open(dir, dentry, &od, open_flag, mode,
+				      created);
+	if (IS_ERR(filp)) {
+		if (WARN_ON(od.dentry != DENTRY_NOT_SET))
+			dput(od.dentry);
+
+		if (create_error && PTR_ERR(filp) == -ENOENT)
+			filp = ERR_PTR(create_error);
+		goto out;
+	}
+
+	acc_mode = op->acc_mode;
+	if (*created) {
+		fsnotify_create(dir, dentry);
+		acc_mode = MAY_OPEN;
+	}
+
+	if (!filp) {
+		if (WARN_ON(od.dentry == DENTRY_NOT_SET)) {
+			filp = ERR_PTR(-EIO);
+			goto out;
+		}
+		if (od.dentry) {
+			dput(dentry);
+			dentry = od.dentry;
+		}
+		goto looked_up;
+	}
+
+	/*
+	 * We didn't have the inode before the open, so check open permission
+	 * here.
+	 */
+	error = may_open(&filp->f_path, acc_mode, open_flag);
+	if (error)
+		goto out_fput;
+
+	error = open_check_o_direct(filp);
+	if (error)
+		goto out_fput;
+
+out:
+	dput(dentry);
+	return filp;
+
+out_fput:
+	fput(filp);
+	filp = ERR_PTR(error);
+	goto out;
+
+no_open:
+	if (need_lookup) {
+		dentry = lookup_real(dir, dentry, nd);
+		if (IS_ERR(dentry))
+			return ERR_CAST(dentry);
+
+		if (create_error) {
+			int open_flag = op->open_flag;
+
+			filp = ERR_PTR(create_error);
+			if ((open_flag & O_EXCL)) {
+				if (!dentry->d_inode)
+					goto out;
+			} else if (!dentry->d_inode) {
+				goto out;
+			} else if ((open_flag & O_TRUNC) &&
+				   S_ISREG(dentry->d_inode->i_mode)) {
+				goto out;
+			}
+			/* will fail later, go on to get the right error */
+		}
+	}
+looked_up:
+	path->dentry = dentry;
+	path->mnt = nd->path.mnt;
+	return NULL;
+}
+
 /*
  * Lookup, maybe create and open the last component
  *
@@ -2241,6 +2411,15 @@ static struct file *lookup_open(struct nameidata *nd, struct path *path,
 	if (IS_ERR(dentry))
 		return ERR_CAST(dentry);
 
+	/* Cached positive dentry: will open in f_op->open */
+	if (!need_lookup && dentry->d_inode)
+		goto out_no_open;
+
+	if ((nd->flags & LOOKUP_OPEN) && dir_inode->i_op->atomic_open) {
+		return atomic_open(nd, dentry, path, op, want_write,
+				   need_lookup, created);
+	}
+
 	if (need_lookup) {
 		BUG_ON(dentry->d_inode);
 
@@ -2273,6 +2452,7 @@ static struct file *lookup_open(struct nameidata *nd, struct path *path,
 		if (error)
 			goto out_dput;
 	}
+out_no_open:
 	path->dentry = dentry;
 	path->mnt = nd->path.mnt;
 	return NULL;
@@ -2366,8 +2546,16 @@ retry_lookup:
 	filp = lookup_open(nd, path, op, &want_write, &created);
 	mutex_unlock(&dir->d_inode->i_mutex);
 
-	if (IS_ERR(filp))
-		goto out;
+	if (filp) {
+		if (IS_ERR(filp))
+			goto out;
+
+		if (created)
+			will_truncate = 0;
+
+		audit_inode(pathname, filp->f_path.dentry);
+		goto opened;
+	}
 
 	if (created) {
 		/* Don't check for write permission, don't truncate */
@@ -2383,6 +2571,16 @@ retry_lookup:
 	 */
 	audit_inode(pathname, path->dentry);
 
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
@@ -2464,6 +2662,7 @@ common:
 		retried = true;
 		goto retry_lookup;
 	}
+opened:
 	if (!IS_ERR(filp)) {
 		error = ima_file_check(filp, op->acc_mode);
 		if (error) {
diff --git a/fs/open.c b/fs/open.c
index 0510e58..a973c2c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -801,6 +801,48 @@ out_err:
 EXPORT_SYMBOL_GPL(lookup_instantiate_filp);
 
 /**
+ * finish_open - finish opening a file
+ * @od: opaque open data
+ * @dentry: pointer to dentry
+ * @open: open callback
+ *
+ * This can be used to finish opening a file passed to i_op->atomic_open().
+ *
+ * If the open callback is set to NULL, then the standard f_op->open()
+ * filesystem callback is substituted.
+ */
+struct file *finish_open(struct opendata *od, struct dentry *dentry,
+			 int (*open)(struct inode *, struct file *))
+{
+	struct file *res;
+
+	mntget(od->mnt);
+	dget(dentry);
+
+	res = do_dentry_open(dentry, od->mnt, *od->filp, open, current_cred());
+	if (!IS_ERR(res))
+		*od->filp = NULL;
+
+	return res;
+}
+EXPORT_SYMBOL(finish_open);
+
+/**
+ * finish_no_open - finish ->atomic_open() without opening the file
+ *
+ * @od: opaque open data
+ * @dentry: dentry or NULL (as returned from ->lookup())
+ *
+ * This can be used to set the result of a successful lookup in ->atomic_open().
+ * The filesystem's atomic_open() method shall return NULL after calling this.
+ */
+void finish_no_open(struct opendata *od, struct dentry *dentry)
+{
+	od->dentry = dentry;
+}
+EXPORT_SYMBOL(finish_no_open);
+
+/**
  * nameidata_to_filp - convert a nameidata to an open filp.
  * @nd: pointer to nameidata
  * @flags: open flags
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 135693e..2700bea 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -417,6 +417,7 @@ struct kstatfs;
 struct vm_area_struct;
 struct vfsmount;
 struct cred;
+struct opendata;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1659,6 +1660,9 @@ struct inode_operations {
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	struct file * (*atomic_open)(struct inode *, struct dentry *,
+				     struct opendata *, unsigned open_flag,
+				     umode_t create_mode, bool *created);
 } ____cacheline_aligned;
 
 struct seq_file;
@@ -2020,6 +2024,9 @@ extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
 				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 extern char * getname(const char __user *);
+extern struct file *finish_open(struct opendata *od, struct dentry *dentry,
+				int (*open)(struct inode *, struct file *));
+extern void finish_no_open(struct opendata *od, struct dentry *dentry);
 
 /* fs/ioctl.c */
 
-- 
1.7.7

