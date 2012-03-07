Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab2CGVXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:23:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43421 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2CGVX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:28 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 18/25] vfs: only retry last component if opening stale dentry
Date: Wed,  7 Mar 2012 22:22:35 +0100
Message-Id: <1331155362-11132-19-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

NFS optimizes away d_revalidates for last component of open.  This means that
open itself can find the dentry stale.  It returns ESTALE resulting in the
complete path being looked up again with LOOKUP_REVAL.

This is unnecessary, however, since it would be enough to retry the last
component only.  Introduce EOPENSTALE (a kernel private errno) and allow NFS to
retry opening only the last component.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c            |   34 ++++++++++++++++++++++++++++++----
 fs/nfs/file.c         |    2 +-
 fs/open.c             |   16 +++++++++-------
 include/linux/errno.h |    1 +
 4 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ff21a67..b991aa0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2194,8 +2194,8 @@ static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
 	 * Another problem is returing the "right" error value (e.g. for an
 	 * O_EXCL open we want to return EEXIST not EROFS).
 	 */
-	if ((open_flag & (O_CREAT | O_TRUNC)) ||
-	    (open_flag & O_ACCMODE) != O_RDONLY) {
+	if (!*want_write && ((open_flag & (O_CREAT | O_TRUNC)) ||
+			     (open_flag & O_ACCMODE) != O_RDONLY)) {
 		error = mnt_want_write(nd->path.mnt);
 		if (!error) {
 			*want_write = 1;
@@ -2370,6 +2370,8 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	int acc_mode = op->acc_mode;
 	struct inode *inode;
 	int symlink_ok = 0;
+	struct path save_parent = { .dentry = NULL, .mnt = NULL };
+	bool retried = false;
 	int error;
 
 	nd->flags &= ~LOOKUP_PARENT;
@@ -2433,6 +2435,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 			goto exit;
 	}
 
+retry_lookup:
 	mutex_lock(&dir->d_inode->i_mutex);
 
 	filp = lookup_open(nd, path, od, op, &want_write);
@@ -2532,12 +2535,21 @@ finish_lookup:
 		return NULL;
 	}
 
-	path_to_nameidata(path, nd);
+	if ((nd->flags & LOOKUP_RCU) || nd->path.mnt != path->mnt) {
+		path_to_nameidata(path, nd);
+	} else {
+		save_parent.dentry = nd->path.dentry;
+		save_parent.mnt = mntget(path->mnt);
+		nd->path.dentry = path->dentry;
+
+	}
 	nd->inode = inode;
 
 	error = complete_walk(nd);
-	if (error)
+	if (error) {
+		path_put(&save_parent);
 		return ERR_PTR(error);
+	}
 	error = -EISDIR;
 	if ((open_flag & O_CREAT) && S_ISDIR(inode->i_mode))
 		goto exit;
@@ -2562,6 +2574,19 @@ common:
 		goto exit;
 	od->mnt = nd->path.mnt;
 	filp = finish_open(od, nd->path.dentry, NULL);
+	if (IS_ERR(filp) && PTR_ERR(filp) == -EOPENSTALE) {
+		error = -ESTALE;
+		if (!save_parent.dentry || retried)
+			goto exit;
+		BUG_ON(save_parent.dentry != dir);
+		path_put(&nd->path);
+		nd->path = save_parent;
+		nd->inode = dir->d_inode;
+		save_parent.mnt = NULL;
+		save_parent.dentry = NULL;
+		retried = true;
+		goto retry_lookup;
+	}
 	if (IS_ERR(filp))
 		goto out;
 	error = open_check_o_direct(filp);
@@ -2580,6 +2605,7 @@ opened:
 out:
 	if (want_write)
 		mnt_drop_write(nd->path.mnt);
+	path_put(&save_parent);
 	path_put(&nd->path);
 	return filp;
 
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 4e626ec..bb1f5cb 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -935,7 +935,7 @@ out:
 
 out_drop:
 	d_drop(dentry);
-	err = -ESTALE;
+	err = -EOPENSTALE;
 	goto out_put_ctx;
 }
 
diff --git a/fs/open.c b/fs/open.c
index b51afcc..d324139 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -737,7 +737,6 @@ cleanup_all:
 	f->f_path.dentry = NULL;
 	f->f_path.mnt = NULL;
 cleanup_file:
-	put_filp(f);
 	dput(dentry);
 	mntput(mnt);
 	return ERR_PTR(error);
@@ -758,15 +757,16 @@ cleanup_file:
 struct file *finish_open(struct opendata *od, struct dentry *dentry,
 			 int (*open)(struct inode *, struct file *))
 {
-	struct file *filp;
-
-	filp = od->filp;
-	od->filp = NULL;
+	struct file *res;
 
 	mntget(od->mnt);
 	dget(dentry);
 
-	return do_dentry_open(dentry, od->mnt, filp, open, current_cred());
+	res = do_dentry_open(dentry, od->mnt, od->filp, open, current_cred());
+	if (!IS_ERR(res))
+		od->filp = NULL;
+
+	return res;
 }
 EXPORT_SYMBOL(finish_open);
 
@@ -795,7 +795,9 @@ struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags,
 
 	f->f_flags = flags;
 	res = do_dentry_open(dentry, mnt, f, NULL, cred);
-	if (!IS_ERR(res)) {
+	if (IS_ERR(res)) {
+		put_filp(f);
+	} else {
 		int error = open_check_o_direct(f);
 		if (error) {
 			fput(res);
diff --git a/include/linux/errno.h b/include/linux/errno.h
index 4668583..b1c33a0 100644
--- a/include/linux/errno.h
+++ b/include/linux/errno.h
@@ -16,6 +16,7 @@
 #define ERESTARTNOHAND	514	/* restart if no handler.. */
 #define ENOIOCTLCMD	515	/* No ioctl command */
 #define ERESTART_RESTARTBLOCK 516 /* restart by calling sys_restart_syscall */
+#define EOPENSTALE	517	/* open found a stale dentry */
 
 /* Defined for the NFSv3 protocol */
 #define EBADHANDLE	521	/* Illegal NFS file handle */
-- 
1.7.7

