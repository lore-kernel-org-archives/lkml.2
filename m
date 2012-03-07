Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab2CGV0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:26:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61310 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab2CGVX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:26 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 17/25] vfs: remove open intents from nameidata
Date: Wed,  7 Mar 2012 22:22:34 +0100
Message-Id: <1331155362-11132-18-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

All users of open intents have been converted to use ->atomic_{open,create}.

This patch gets rid of nd->intent.open and related infrastructure.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h         |    5 +--
 fs/namei.c            |  109 +++++++++++++++++++++---------------------------
 fs/open.c             |   97 +++++--------------------------------------
 include/linux/namei.h |   11 -----
 4 files changed, 61 insertions(+), 161 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 10143de..6d71416 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -84,12 +84,9 @@ extern struct super_block *user_get_super(dev_t);
 /*
  * open.c
  */
-struct nameidata;
-extern struct file *nameidata_to_filp(struct nameidata *);
-extern void release_open_intent(struct nameidata *);
 struct opendata {
 	struct vfsmount *mnt;
-	struct file **filp;
+	struct file *filp;
 };
 struct open_flags {
 	int open_flag;
diff --git a/fs/namei.c b/fs/namei.c
index 200cffe..ff21a67 100644
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
@@ -2174,6 +2158,7 @@ static int may_o_create(struct path *dir, struct dentry *dentry, umode_t mode)
 }
 
 static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
+				struct opendata *od,
 				const struct open_flags *op,
 				int *want_write, int *create_error)
 {
@@ -2183,7 +2168,6 @@ static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
 	int error;
 	bool created = false;
 	int acc_mode;
-	struct opendata od;
 	struct file *filp;
 
 	BUG_ON(dentry->d_inode);
@@ -2245,9 +2229,8 @@ static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
 	if (nd->flags & LOOKUP_DIRECTORY)
 		open_flag |= O_DIRECTORY;
 
-	od.mnt = nd->path.mnt;
-	od.filp = &nd->intent.open.file;
-	filp = dir->i_op->atomic_open(dir, dentry, &od, open_flag, mode,
+	od->mnt = nd->path.mnt;
+	filp = dir->i_op->atomic_open(dir, dentry, od, open_flag, mode,
 				      &created);
 	if (IS_ERR(filp)) {
 		if (*create_error && PTR_ERR(filp) == -ENOENT)
@@ -2310,6 +2293,7 @@ static bool is_atomic_lookup_open(struct inode *dir, struct nameidata *nd)
  * was performed, only lookup.
  */
 static struct file *lookup_open(struct nameidata *nd, struct path *path,
+				struct opendata *od,
 				const struct open_flags *op, int *want_write)
 {
 	struct dentry *dir = nd->path.dentry;
@@ -2330,7 +2314,8 @@ static struct file *lookup_open(struct nameidata *nd, struct path *path,
 	if (is_atomic_lookup_open(dir_inode, nd)) {
 		struct file *filp;
 
-		filp = atomic_open(nd, dentry, op, want_write, &create_error);
+		filp = atomic_open(nd, dentry, od, op, want_write,
+				   &create_error);
 		if (filp) {
 			dput(dentry);
 			return filp;
@@ -2373,15 +2358,16 @@ out_dput:
  * Handle the last step of open()
  */
 static struct file *do_last(struct nameidata *nd, struct path *path,
-			    const struct open_flags *op, const char *pathname)
+			    struct opendata *od, const struct open_flags *op,
+			    const char *pathname)
 {
 	struct dentry *dir = nd->path.dentry;
 	struct dentry *dentry;
+	struct file *filp;
 	int open_flag = open_to_namei_flags(op->open_flag);
 	int will_truncate = open_flag & O_TRUNC;
 	int want_write = 0;
 	int acc_mode = op->acc_mode;
-	struct file *filp;
 	struct inode *inode;
 	int symlink_ok = 0;
 	int error;
@@ -2449,7 +2435,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 
 	mutex_lock(&dir->d_inode->i_mutex);
 
-	filp = lookup_open(nd, path, op, &want_write);
+	filp = lookup_open(nd, path, od, op, &want_write);
 	if (filp) {
 		mutex_unlock(&dir->d_inode->i_mutex);
 		if (IS_ERR(filp))
@@ -2462,7 +2448,6 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 
 	/* Negative dentry, create the file if O_CREAT */
 	if (!dentry->d_inode) {
-		struct opendata od;
 		umode_t mode = op->mode;
 
 		error = -ENOENT;
@@ -2476,7 +2461,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		 * rw->ro transition does not occur between
 		 * the time when the file is created and when
 		 * a permanent write count is taken through
-		 * the 'struct file' in nameidata_to_filp().
+		 * the 'struct file' in finish_open().
 		 */
 		if (!want_write) {
 			error = mnt_want_write(nd->path.mnt);
@@ -2491,9 +2476,8 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		error = security_path_mknod(&nd->path, dentry, mode, 0);
 		if (error)
 			goto exit_mutex_unlock;
-		od.mnt = nd->path.mnt;
-		od.filp = &nd->intent.open.file;
-		filp = create_open(dir->d_inode, dentry, &od, open_flag, mode,
+		od->mnt = nd->path.mnt;
+		filp = create_open(dir->d_inode, dentry, od, open_flag, mode,
 				   nd);
 		mutex_unlock(&dir->d_inode->i_mutex);
 		dput(nd->path.dentry);
@@ -2576,23 +2560,22 @@ common:
 	error = may_open(&nd->path, acc_mode, open_flag);
 	if (error)
 		goto exit;
-	filp = nameidata_to_filp(nd);
+	od->mnt = nd->path.mnt;
+	filp = finish_open(od, nd->path.dentry, NULL);
+	if (IS_ERR(filp))
+		goto out;
+	error = open_check_o_direct(filp);
+	if (error)
+		goto exit_fput;
 opened:
-	if (!IS_ERR(filp)) {
-		error = ima_file_check(filp, op->acc_mode);
-		if (error) {
-			fput(filp);
-			filp = ERR_PTR(error);
-		}
-	}
-	if (!IS_ERR(filp)) {
-		if (will_truncate) {
-			error = handle_truncate(filp);
-			if (error) {
-				fput(filp);
-				filp = ERR_PTR(error);
-			}
-		}
+	error = ima_file_check(filp, op->acc_mode);
+	if (error)
+		goto exit_fput;
+
+	if (will_truncate) {
+		error = handle_truncate(filp);
+		if (error)
+			goto exit_fput;
 	}
 out:
 	if (want_write)
@@ -2608,6 +2591,10 @@ exit:
 	filp = ERR_PTR(error);
 	goto out;
 
+exit_fput:
+	fput(filp);
+	goto exit;
+
 terminate:
 	terminate_walk(nd);
 	return ERR_PTR(error);
@@ -2617,18 +2604,16 @@ static struct file *path_openat(int dfd, const char *pathname,
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
@@ -2639,23 +2624,23 @@ static struct file *path_openat(int dfd, const char *pathname,
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
@@ -2663,11 +2648,14 @@ out:
 		path_put(&nd->root);
 	if (base)
 		fput(base);
-	release_open_intent(nd);
-	return filp;
+	if (od.filp) {
+		BUG_ON(od.filp->f_path.dentry);
+		put_filp(od.filp);
+	}
+	return res;
 
 out_filp:
-	filp = ERR_PTR(error);
+	res = ERR_PTR(error);
 	goto out;
 }
 
@@ -2723,7 +2711,6 @@ struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path
 		goto out;
 	nd.flags &= ~LOOKUP_PARENT;
 	nd.flags |= LOOKUP_CREATE | LOOKUP_EXCL;
-	nd.intent.open.flags = O_EXCL;
 
 	/*
 	 * Do the final lookup.
diff --git a/fs/open.c b/fs/open.c
index 238c5ae..b51afcc 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -743,62 +743,6 @@ cleanup_file:
 	return ERR_PTR(error);
 }
 
-static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
-				struct file *f,
-				int (*open)(struct inode *, struct file *),
-				const struct cred *cred)
-{
-	struct file *res = do_dentry_open(dentry, mnt, f, open, cred);
-	if (!IS_ERR(res)) {
-		int error = open_check_o_direct(f);
-		if (error) {
-			fput(res);
-			res = ERR_PTR(error);
-		}
-	}
-	return res;
-}
-
-/**
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
 /**
  * finish_open - set up a not fully instantiated file
  * @od: opaque open data
@@ -816,8 +760,8 @@ struct file *finish_open(struct opendata *od, struct dentry *dentry,
 {
 	struct file *filp;
 
-	filp = *(od->filp);
-	*(od->filp) = NULL;
+	filp = od->filp;
+	od->filp = NULL;
 
 	mntget(od->mnt);
 	dget(dentry);
@@ -826,31 +770,6 @@ struct file *finish_open(struct opendata *od, struct dentry *dentry,
 }
 EXPORT_SYMBOL(finish_open);
 
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
-	nd->intent.open.file = NULL;
-
-	/* Has the filesystem initialised the file for us? */
-	if (filp->f_path.dentry == NULL) {
-		path_get(&nd->path);
-		filp = __dentry_open(nd->path.dentry, nd->path.mnt, filp,
-				     NULL, cred);
-	}
-	return filp;
-}
-
 /*
  * dentry_open() will have done dput(dentry) and mntput(mnt) if it returns an
  * error.
@@ -859,7 +778,7 @@ struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags,
 			 const struct cred *cred)
 {
 	int error;
-	struct file *f;
+	struct file *f, *res;
 
 	validate_creds(cred);
 
@@ -875,7 +794,15 @@ struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags,
 	}
 
 	f->f_flags = flags;
-	return __dentry_open(dentry, mnt, f, NULL, cred);
+	res = do_dentry_open(dentry, mnt, f, NULL, cred);
+	if (!IS_ERR(res)) {
+		int error = open_check_o_direct(f);
+		if (error) {
+			fput(res);
+			res = ERR_PTR(error);
+		}
+	}
+	return res;
 }
 EXPORT_SYMBOL(dentry_open);
 
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

