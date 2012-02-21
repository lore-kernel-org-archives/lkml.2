Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2BUT5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:57:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab2BUTyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:54:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/73] VFS: Make lookup_hash() return a struct path [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org,
        Jan Blunck <jblunck@suse.de> (Original author),
        Valerie Aurora <vaurora@redhat.com>,
        David Howells <dhowells@redhat.com> (Forward porting)
Date: Tue, 21 Feb 2012 17:57:52 +0000
Message-ID: <20120221175752.25235.8473.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Blunck <jblunck@suse.de> (Original author)
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com> (Forward porting)
---

 fs/namei.c |  121 +++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4dc0e1d..2d983f7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1766,9 +1766,20 @@ static struct dentry *__lookup_hash(struct qstr *name,
  * needs parent already locked. Doesn't follow mounts.
  * SMP-safe.
  */
-static struct dentry *lookup_hash(struct nameidata *nd)
+static int lookup_hash(struct nameidata *nd, struct qstr *name,
+		       struct path *path)
 {
-	return __lookup_hash(&nd->last, nd->path.dentry, nd);
+	struct dentry *result;
+
+	result = __lookup_hash(name, nd->path.dentry, nd);
+	if (IS_ERR(result)) {
+		path->mnt = NULL;
+		path->dentry = NULL;
+		return PTR_ERR(result);
+	}
+	path->mnt = nd->path.mnt;
+	path->dentry = result;
+	return 0;
 }
 
 /**
@@ -2098,7 +2109,6 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 			    const struct open_flags *op, const char *pathname)
 {
 	struct dentry *dir = nd->path.dentry;
-	struct dentry *dentry;
 	int open_flag = op->open_flag;
 	int will_truncate = open_flag & O_TRUNC;
 	int want_write = 0;
@@ -2178,18 +2188,14 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 
 	mutex_lock(&dir->d_inode->i_mutex);
 
-	dentry = lookup_hash(nd);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry)) {
+	error = lookup_hash(nd, &nd->last, path);
+	if (error) {
 		mutex_unlock(&dir->d_inode->i_mutex);
 		goto exit;
 	}
 
-	path->dentry = dentry;
-	path->mnt = nd->path.mnt;
-
 	/* Negative dentry, just create the file */
-	if (!dentry->d_inode) {
+	if (!path->dentry->d_inode) {
 		umode_t mode = op->mode;
 		if (!IS_POSIXACL(dir->d_inode))
 			mode &= ~current_umask();
@@ -2208,15 +2214,15 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		open_flag &= ~O_TRUNC;
 		will_truncate = 0;
 		acc_mode = MAY_OPEN;
-		error = security_path_mknod(&nd->path, dentry, mode, 0);
+		error = security_path_mknod(&nd->path, path->dentry, mode, 0);
 		if (error)
 			goto exit_mutex_unlock;
-		error = vfs_create(dir->d_inode, dentry, mode, nd);
+		error = vfs_create(dir->d_inode, path->dentry, mode, nd);
 		if (error)
 			goto exit_mutex_unlock;
 		mutex_unlock(&dir->d_inode->i_mutex);
 		dput(nd->path.dentry);
-		nd->path.dentry = dentry;
+		nd->path.dentry = path->dentry;
 		goto common;
 	}
 
@@ -2395,8 +2401,8 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 
 struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path, int is_dir)
 {
-	struct dentry *dentry = ERR_PTR(-EEXIST);
 	struct nameidata nd;
+	struct path new_path;
 	int error = do_path_lookup(dfd, pathname, LOOKUP_PARENT, &nd);
 	if (error)
 		return ERR_PTR(error);
@@ -2405,6 +2411,7 @@ struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path
 	 * Yucky last component or no last component at all?
 	 * (foo/., foo/.., /////)
 	 */
+	error = -EEXIST;
 	if (nd.last_type != LAST_NORM)
 		goto out;
 	nd.flags &= ~LOOKUP_PARENT;
@@ -2415,11 +2422,11 @@ struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path
 	 * Do the final lookup.
 	 */
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_hash(&nd);
-	if (IS_ERR(dentry))
+	error = lookup_hash(&nd, &nd.last, &new_path);
+	if (error)
 		goto fail;
 
-	if (dentry->d_inode)
+	if (new_path.dentry->d_inode)
 		goto eexist;
 	/*
 	 * Special case - lookup gave negative, but... we had foo/bar/
@@ -2428,20 +2435,20 @@ struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path
 	 * been asking for (non-existent) directory. -ENOENT for you.
 	 */
 	if (unlikely(!is_dir && nd.last.name[nd.last.len])) {
-		dput(dentry);
-		dentry = ERR_PTR(-ENOENT);
-		goto fail;
+		error = -ENOENT;
+		goto fail_do_put;
 	}
 	*path = nd.path;
-	return dentry;
+	return new_path.dentry;
 eexist:
-	dput(dentry);
-	dentry = ERR_PTR(-EEXIST);
+	error = -EEXIST;
+fail_do_put:
+	dput(new_path.dentry);
 fail:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 out:
 	path_put(&nd.path);
-	return dentry;
+	return ERR_PTR(error);
 }
 EXPORT_SYMBOL(kern_path_create);
 
@@ -2673,7 +2680,7 @@ static long do_rmdir(int dfd, const char __user *pathname)
 {
 	int error = 0;
 	char * name;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 
 	error = user_path_parent(dfd, pathname, &nd, &name);
@@ -2695,25 +2702,24 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	nd.flags &= ~LOOKUP_PARENT;
 
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_hash(&nd);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry))
+	error = lookup_hash(&nd, &nd.last, &path);
+	if (error)
 		goto exit2;
-	if (!dentry->d_inode) {
+	if (!path.dentry->d_inode) {
 		error = -ENOENT;
 		goto exit3;
 	}
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto exit3;
-	error = security_path_rmdir(&nd.path, dentry);
+	error = security_path_rmdir(&nd.path, path.dentry);
 	if (error)
 		goto exit4;
-	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
+	error = vfs_rmdir(nd.path.dentry->d_inode, path.dentry);
 exit4:
 	mnt_drop_write(nd.path.mnt);
 exit3:
-	dput(dentry);
+	path_put_conditional(&path, &nd);
 exit2:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 exit1:
@@ -2769,7 +2775,7 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 {
 	int error;
 	char *name;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 	struct inode *inode = NULL;
 
@@ -2784,27 +2790,26 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	nd.flags &= ~LOOKUP_PARENT;
 
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_hash(&nd);
-	error = PTR_ERR(dentry);
-	if (!IS_ERR(dentry)) {
+	error = lookup_hash(&nd, &nd.last, &path);
+	if (!error) {
 		/* Why not before? Because we want correct error value */
 		if (nd.last.name[nd.last.len])
 			goto slashes;
-		inode = dentry->d_inode;
+		inode = path.dentry->d_inode;
 		if (!inode)
 			goto slashes;
 		ihold(inode);
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
-		error = security_path_unlink(&nd.path, dentry);
+		error = security_path_unlink(&nd.path, path.dentry);
 		if (error)
 			goto exit3;
-		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
+		error = vfs_unlink(nd.path.dentry->d_inode, path.dentry);
 exit3:
 		mnt_drop_write(nd.path.mnt);
 	exit2:
-		dput(dentry);
+		path_put_conditional(&path, &nd);
 	}
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	if (inode)
@@ -2815,8 +2820,8 @@ exit1:
 	return error;
 
 slashes:
-	error = !dentry->d_inode ? -ENOENT :
-		S_ISDIR(dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
+	error = !path.dentry->d_inode ? -ENOENT :
+		S_ISDIR(path.dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
 	goto exit2;
 }
 
@@ -3156,7 +3161,7 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
 	struct dentry *old_dir, *new_dir;
-	struct dentry *old_dentry, *new_dentry;
+	struct path old, new;
 	struct dentry *trap;
 	struct nameidata oldnd, newnd;
 	char *from;
@@ -3190,16 +3195,15 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 
 	trap = lock_rename(new_dir, old_dir);
 
-	old_dentry = lookup_hash(&oldnd);
-	error = PTR_ERR(old_dentry);
-	if (IS_ERR(old_dentry))
+	error = lookup_hash(&oldnd, &oldnd.last, &old);
+	if (error)
 		goto exit3;
 	/* source must exist */
 	error = -ENOENT;
-	if (!old_dentry->d_inode)
+	if (!old.dentry->d_inode)
 		goto exit4;
 	/* unless the source is a directory trailing slashes give -ENOTDIR */
-	if (!S_ISDIR(old_dentry->d_inode->i_mode)) {
+	if (!S_ISDIR(old.dentry->d_inode->i_mode)) {
 		error = -ENOTDIR;
 		if (oldnd.last.name[oldnd.last.len])
 			goto exit4;
@@ -3208,32 +3212,31 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	}
 	/* source should not be ancestor of target */
 	error = -EINVAL;
-	if (old_dentry == trap)
+	if (old.dentry == trap)
 		goto exit4;
-	new_dentry = lookup_hash(&newnd);
-	error = PTR_ERR(new_dentry);
-	if (IS_ERR(new_dentry))
+	error = lookup_hash(&newnd, &newnd.last, &new);
+	if (error)
 		goto exit4;
 	/* target should not be an ancestor of source */
 	error = -ENOTEMPTY;
-	if (new_dentry == trap)
+	if (new.dentry == trap)
 		goto exit5;
 
 	error = mnt_want_write(oldnd.path.mnt);
 	if (error)
 		goto exit5;
-	error = security_path_rename(&oldnd.path, old_dentry,
-				     &newnd.path, new_dentry);
+	error = security_path_rename(&oldnd.path, old.dentry,
+				     &newnd.path, new.dentry);
 	if (error)
 		goto exit6;
-	error = vfs_rename(old_dir->d_inode, old_dentry,
-				   new_dir->d_inode, new_dentry);
+	error = vfs_rename(old_dir->d_inode, old.dentry,
+				   new_dir->d_inode, new.dentry);
 exit6:
 	mnt_drop_write(oldnd.path.mnt);
 exit5:
-	dput(new_dentry);
+	path_put_conditional(&new, &newnd);
 exit4:
-	dput(old_dentry);
+	path_put_conditional(&old, &oldnd);
 exit3:
 	unlock_rename(new_dir, old_dir);
 exit2:

