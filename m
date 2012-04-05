Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2DEPGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:06:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52339 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab2DEO7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:38 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 32/34] vfs: remove open intents from nameidata
Date: Thu,  5 Apr 2012 16:58:58 +0200
Message-Id: <1333637940-31884-33-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

All users of open intents have been converted to use ->atomic_{open,create}.

This patch gets rid of nd->intent.open and related infrastructure.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h         |    5 +--
 fs/namei.c            |   97 +++++++++++++++++++++++--------------------------
 fs/open.c             |   87 +-------------------------------------------
 include/linux/namei.h |   11 ------
 4 files changed, 49 insertions(+), 151 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 78c5c47..89c5f3a 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -84,13 +84,10 @@ extern struct super_block *user_get_super(dev_t);
 /*
  * open.c
  */
-struct nameidata;
-extern struct file *nameidata_to_filp(struct nameidata *);
-extern void release_open_intent(struct nameidata *);
 struct opendata {
 	struct dentry *dentry;
 	struct vfsmount *mnt;
-	struct file **filp;
+	struct file *filp;
 };
 struct open_flags {
 	int open_flag;
diff --git a/fs/namei.c b/fs/namei.c
index 4d505a4..b6020ca 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -476,22 +476,6 @@ err_root:
 	return -ECHILD;
 }
 
-/**
- * release_open_intent - free up open intent resources
- * @nd: pointer to nameidata
- */
-void release_open_intent(struct nameidata *nd)
-{
-	struct file *file = nd->intent.open.file;
-
-	if (file && !IS_ERR(file)) {
-		if (file->f_path.dentry == NULL)
-			put_filp(file);
-		else
-			fput(file);
-	}
-}
-
 static inline int d_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	return dentry->d_op->d_revalidate(dentry, nd);
@@ -2232,7 +2216,8 @@ static int may_o_create(struct path *dir, struct dentry *dentry, umode_t mode)
 }
 
 static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
-				struct path *path, const struct open_flags *op,
+				struct path *path, struct opendata *od,
+				const struct open_flags *op,
 				int *want_write, bool need_lookup,
 				bool *created)
 {
@@ -2241,7 +2226,6 @@ static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
 	umode_t mode;
 	int error;
 	int acc_mode;
-	struct opendata od;
 	struct file *filp;
 	int create_error = 0;
 	struct dentry *const DENTRY_NOT_SET = (void *) -1UL;
@@ -2307,14 +2291,13 @@ static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
 	if (nd->flags & LOOKUP_DIRECTORY)
 		open_flag |= O_DIRECTORY;
 
-	od.dentry = DENTRY_NOT_SET;
-	od.mnt = nd->path.mnt;
-	od.filp = &nd->intent.open.file;
-	filp = dir->i_op->atomic_open(dir, dentry, &od, open_flag, mode,
+	od->dentry = DENTRY_NOT_SET;
+	od->mnt = nd->path.mnt;
+	filp = dir->i_op->atomic_open(dir, dentry, od, open_flag, mode,
 				      created);
 	if (IS_ERR(filp)) {
-		if (WARN_ON(od.dentry != DENTRY_NOT_SET))
-			dput(od.dentry);
+		if (WARN_ON(od->dentry != DENTRY_NOT_SET))
+			dput(od->dentry);
 
 		if (create_error && PTR_ERR(filp) == -ENOENT)
 			filp = ERR_PTR(create_error);
@@ -2328,13 +2311,13 @@ static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
 	}
 
 	if (!filp) {
-		if (WARN_ON(od.dentry == DENTRY_NOT_SET)) {
+		if (WARN_ON(od->dentry == DENTRY_NOT_SET)) {
 			filp = ERR_PTR(-EIO);
 			goto out;
 		}
-		if (od.dentry) {
+		if (od->dentry) {
 			dput(dentry);
-			dentry = od.dentry;
+			dentry = od->dentry;
 		}
 		goto looked_up;
 	}
@@ -2397,6 +2380,7 @@ looked_up:
  * was performed, only lookup.
  */
 static struct file *lookup_open(struct nameidata *nd, struct path *path,
+				struct opendata *od,
 				const struct open_flags *op,
 				int *want_write, bool *created)
 {
@@ -2416,7 +2400,7 @@ static struct file *lookup_open(struct nameidata *nd, struct path *path,
 		goto out_no_open;
 
 	if ((nd->flags & LOOKUP_OPEN) && dir_inode->i_op->atomic_open) {
-		return atomic_open(nd, dentry, path, op, want_write,
+		return atomic_open(nd, dentry, path, od, op, want_write,
 				   need_lookup, created);
 	}
 
@@ -2438,7 +2422,7 @@ static struct file *lookup_open(struct nameidata *nd, struct path *path,
 		 * rw->ro transition does not occur between
 		 * the time when the file is created and when
 		 * a permanent write count is taken through
-		 * the 'struct file' in nameidata_to_filp().
+		 * the 'struct file' in finish_open().
 		 */
 		error = mnt_want_write(nd->path.mnt);
 		if (error)
@@ -2466,7 +2450,8 @@ out_dput:
  * Handle the last step of open()
  */
 static struct file *do_last(struct nameidata *nd, struct path *path,
-			    const struct open_flags *op, const char *pathname)
+			    struct opendata *od, const struct open_flags *op,
+			    const char *pathname)
 {
 	struct dentry *dir = nd->path.dentry;
 	int open_flag = op->open_flag;
@@ -2543,7 +2528,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 
 retry_lookup:
 	mutex_lock(&dir->d_inode->i_mutex);
-	filp = lookup_open(nd, path, op, &want_write, &created);
+	filp = lookup_open(nd, path, od, op, &want_write, &created);
 	mutex_unlock(&dir->d_inode->i_mutex);
 
 	if (filp) {
@@ -2647,7 +2632,8 @@ common:
 	error = may_open(&nd->path, acc_mode, open_flag);
 	if (error)
 		goto exit;
-	filp = nameidata_to_filp(nd);
+	od->mnt = nd->path.mnt;
+	filp = finish_open(od, nd->path.dentry, NULL);
 	if (filp == ERR_PTR(-EOPENSTALE) && save_parent.dentry && !retried) {
 		BUG_ON(save_parent.dentry != dir);
 		path_put(&nd->path);
@@ -2662,6 +2648,11 @@ common:
 		retried = true;
 		goto retry_lookup;
 	}
+	if (IS_ERR(filp))
+		goto out;
+	error = open_check_o_direct(filp);
+	if (error)
+		goto exit_fput;
 opened:
 	if (!IS_ERR(filp)) {
 		error = ima_file_check(filp, op->acc_mode);
@@ -2691,24 +2682,26 @@ exit_dput:
 exit:
 	filp = ERR_PTR(error);
 	goto out;
+exit_fput:
+	fput(filp);
+	goto exit;
+
 }
 
 static struct file *path_openat(int dfd, const char *pathname,
 		struct nameidata *nd, const struct open_flags *op, int flags)
 {
 	struct file *base = NULL;
-	struct file *filp;
+	struct opendata od;
+	struct file *res;
 	struct path path;
 	int error;
 
-	filp = get_empty_filp();
-	if (!filp)
+	od.filp = get_empty_filp();
+	if (!od.filp)
 		return ERR_PTR(-ENFILE);
 
-	filp->f_flags = op->open_flag;
-	nd->intent.open.file = filp;
-	nd->intent.open.flags = open_to_namei_flags(op->open_flag);
-	nd->intent.open.create_mode = op->mode;
+	od.filp->f_flags = op->open_flag;
 
 	error = path_init(dfd, pathname, flags | LOOKUP_PARENT, nd, &base);
 	if (unlikely(error))
@@ -2719,23 +2712,23 @@ static struct file *path_openat(int dfd, const char *pathname,
 	if (unlikely(error))
 		goto out_filp;
 
-	filp = do_last(nd, &path, op, pathname);
-	while (unlikely(!filp)) { /* trailing symlink */
+	res = do_last(nd, &path, &od, op, pathname);
+	while (unlikely(!res)) { /* trailing symlink */
 		struct path link = path;
 		void *cookie;
 		if (!(nd->flags & LOOKUP_FOLLOW)) {
 			path_put_conditional(&path, nd);
 			path_put(&nd->path);
-			filp = ERR_PTR(-ELOOP);
+			res = ERR_PTR(-ELOOP);
 			break;
 		}
 		nd->flags |= LOOKUP_PARENT;
 		nd->flags &= ~(LOOKUP_OPEN|LOOKUP_CREATE|LOOKUP_EXCL);
 		error = follow_link(&link, nd, &cookie);
 		if (unlikely(error))
-			filp = ERR_PTR(error);
+			res = ERR_PTR(error);
 		else
-			filp = do_last(nd, &path, op, pathname);
+			res = do_last(nd, &path, &od, op, pathname);
 		put_link(nd, &link, cookie);
 	}
 out:
@@ -2743,17 +2736,20 @@ out:
 		path_put(&nd->root);
 	if (base)
 		fput(base);
-	release_open_intent(nd);
-	if (filp == ERR_PTR(-EOPENSTALE)) {
+	if (od.filp) {
+		BUG_ON(od.filp->f_path.dentry);
+		put_filp(od.filp);
+	}
+	if (res == ERR_PTR(-EOPENSTALE)) {
 		if (flags & LOOKUP_RCU)
-			filp = ERR_PTR(-ECHILD);
+			res = ERR_PTR(-ECHILD);
 		else
-			filp = ERR_PTR(-ESTALE);
+			res = ERR_PTR(-ESTALE);
 	}
-	return filp;
+	return res;
 
 out_filp:
-	filp = ERR_PTR(error);
+	res = ERR_PTR(error);
 	goto out;
 }
 
@@ -2809,7 +2805,6 @@ struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path
 		goto out;
 	nd.flags &= ~LOOKUP_PARENT;
 	nd.flags |= LOOKUP_CREATE | LOOKUP_EXCL;
-	nd.intent.open.flags = O_EXCL;
 
 	/*
 	 * Do the final lookup.
diff --git a/fs/open.c b/fs/open.c
index a973c2c..7b9b931 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -761,46 +761,6 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 }
 
 /**
- * lookup_instantiate_filp - instantiates the open intent filp
- * @nd: pointer to nameidata
- * @dentry: pointer to dentry
- * @open: open callback
- *
- * Helper for filesystems that want to use lookup open intents and pass back
- * a fully instantiated struct file to the caller.
- * This function is meant to be called from within a filesystem's
- * lookup method.
- * Beware of calling it for non-regular files! Those ->open methods might block
- * (e.g. in fifo_open), leaving you with parent locked (and in case of fifo,
- * leading to a deadlock, as nobody can open that fifo anymore, because
- * another process to open fifo will block on locked parent when doing lookup).
- * Note that in case of error, nd->intent.open.file is destroyed, but the
- * path information remains valid.
- * If the open callback is set to NULL, then the standard f_op->open()
- * filesystem callback is substituted.
- */
-struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry,
-		int (*open)(struct inode *, struct file *))
-{
-	const struct cred *cred = current_cred();
-
-	if (IS_ERR(nd->intent.open.file))
-		goto out;
-	if (IS_ERR(dentry))
-		goto out_err;
-	nd->intent.open.file = __dentry_open(dget(dentry), mntget(nd->path.mnt),
-					     nd->intent.open.file,
-					     open, cred);
-out:
-	return nd->intent.open.file;
-out_err:
-	release_open_intent(nd);
-	nd->intent.open.file = ERR_CAST(dentry);
-	goto out;
-}
-EXPORT_SYMBOL_GPL(lookup_instantiate_filp);
-
-/**
  * finish_open - finish opening a file
  * @od: opaque open data
  * @dentry: pointer to dentry
@@ -819,9 +779,9 @@ struct file *finish_open(struct opendata *od, struct dentry *dentry,
 	mntget(od->mnt);
 	dget(dentry);
 
-	res = do_dentry_open(dentry, od->mnt, *od->filp, open, current_cred());
+	res = do_dentry_open(dentry, od->mnt, od->filp, open, current_cred());
 	if (!IS_ERR(res))
-		*od->filp = NULL;
+		od->filp = NULL;
 
 	return res;
 }
@@ -842,49 +802,6 @@ void finish_no_open(struct opendata *od, struct dentry *dentry)
 }
 EXPORT_SYMBOL(finish_no_open);
 
-/**
- * nameidata_to_filp - convert a nameidata to an open filp.
- * @nd: pointer to nameidata
- * @flags: open flags
- *
- * Note that this function destroys the original nameidata
- */
-struct file *nameidata_to_filp(struct nameidata *nd)
-{
-	const struct cred *cred = current_cred();
-	struct file *filp;
-
-	/* Pick up the filp from the open intent */
-	filp = nd->intent.open.file;
-
-	/* Has the filesystem initialised the file for us? */
-	if (filp->f_path.dentry != NULL) {
-		nd->intent.open.file = NULL;
-	} else {
-		struct file *res;
-
-		path_get(&nd->path);
-		res = do_dentry_open(nd->path.dentry, nd->path.mnt,
-				     filp, NULL, cred);
-		if (!IS_ERR(res)) {
-			int error;
-
-			nd->intent.open.file = NULL;
-			BUG_ON(res != filp);
-
-			error = open_check_o_direct(filp);
-			if (error) {
-				fput(filp);
-				filp = ERR_PTR(error);
-			}
-		} else {
-			/* Allow nd->intent.open.file to be recycled */
-			filp = res;
-		}
-	}
-	return filp;
-}
-
 /*
  * dentry_open() will have done dput(dentry) and mntput(mnt) if it returns an
  * error.
diff --git a/include/linux/namei.h b/include/linux/namei.h
index ffc0213..54dadda 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -7,12 +7,6 @@
 
 struct vfsmount;
 
-struct open_intent {
-	int	flags;
-	int	create_mode;
-	struct file *file;
-};
-
 enum { MAX_NESTED_LINKS = 8 };
 
 struct nameidata {
@@ -25,11 +19,6 @@ struct nameidata {
 	int		last_type;
 	unsigned	depth;
 	char *saved_names[MAX_NESTED_LINKS + 1];
-
-	/* Intent data */
-	union {
-		struct open_intent open;
-	} intent;
 };
 
 /*
-- 
1.7.7

