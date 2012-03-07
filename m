Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2CGVXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:23:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47153 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab2CGVW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:22:58 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 02/25] vfs: reorganize do_last()
Date: Wed,  7 Mar 2012 22:22:19 +0100
Message-Id: <1331155362-11132-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Make the slow lookup part of O_CREAT and non-O_CREAT opens common.

This allows atomic_open to be hooked into the slow lookup part.

The audit_inode() from after mutex_unlock() was moved down just before the "ok:"
label.  Is this correct?

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   93 +++++++++++++++++++++++++++++++++++------------------------
 1 files changed, 55 insertions(+), 38 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f9639bf..ff8bc94 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2113,6 +2113,8 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	int want_write = 0;
 	int acc_mode = op->acc_mode;
 	struct file *filp;
+	struct inode *inode;
+	int symlink_ok = 0;
 	int error;
 
 	nd->flags &= ~LOOKUP_PARENT;
@@ -2144,47 +2146,38 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	}
 
 	if (!(open_flag & O_CREAT)) {
-		int symlink_ok = 0;
 		if (nd->last.name[nd->last.len])
 			nd->flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
 		if (open_flag & O_PATH && !(nd->flags & LOOKUP_FOLLOW))
 			symlink_ok = 1;
 		/* we _can_ be in RCU mode here */
-		error = walk_component(nd, path, &nd->last, LAST_NORM,
-					!symlink_ok);
-		if (error < 0)
-			return ERR_PTR(error);
-		if (error) /* symlink */
-			return NULL;
-		/* sayonara */
+		error = lookup_fast(nd, &nd->last, path, &inode);
+		if (error <= 0) {
+			if (error)
+				goto terminate;
+
+			goto finish_lookup;
+		}
+		/* cached lookup failed, no longer in RCU mode */
+	} else {
+		/* create side of things */
+
+		/*
+		 * This will *only* deal with leaving RCU mode - LOOKUP_JUMPED
+		 * has been cleared when we got to the last component we are
+		 * about to look up
+		 */
 		error = complete_walk(nd);
 		if (error)
 			return ERR_PTR(error);
 
-		error = -ENOTDIR;
-		if (nd->flags & LOOKUP_DIRECTORY) {
-			if (!nd->inode->i_op->lookup)
-				goto exit;
-		}
-		audit_inode(pathname, nd->path.dentry);
-		goto ok;
+		audit_inode(pathname, dir);
+		error = -EISDIR;
+		/* trailing slashes? */
+		if (nd->last.name[nd->last.len])
+			goto exit;
 	}
 
-	/* create side of things */
-	/*
-	 * This will *only* deal with leaving RCU mode - LOOKUP_JUMPED has been
-	 * cleared when we got to the last component we are about to look up
-	 */
-	error = complete_walk(nd);
-	if (error)
-		return ERR_PTR(error);
-
-	audit_inode(pathname, dir);
-	error = -EISDIR;
-	/* trailing slashes? */
-	if (nd->last.name[nd->last.len])
-		goto exit;
-
 	mutex_lock(&dir->d_inode->i_mutex);
 
 	dentry = lookup_hash(nd);
@@ -2197,9 +2190,14 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	path->dentry = dentry;
 	path->mnt = nd->path.mnt;
 
-	/* Negative dentry, just create the file */
+	/* Negative dentry, create the file if O_CREAT */
 	if (!dentry->d_inode) {
 		umode_t mode = op->mode;
+
+		error = -ENOENT;
+		if (!(open_flag & O_CREAT))
+			goto exit_mutex_unlock;
+
 		if (!IS_POSIXACL(dir->d_inode))
 			mode &= ~current_umask();
 		/*
@@ -2233,7 +2231,6 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	 * It already exists.
 	 */
 	mutex_unlock(&dir->d_inode->i_mutex);
-	audit_inode(pathname, path->dentry);
 
 	error = -EEXIST;
 	if (open_flag & O_EXCL)
@@ -2243,22 +2240,38 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (error)
 		goto exit_dput;
 
+	inode = path->dentry->d_inode;
+finish_lookup:
 	error = -ENOENT;
-	if (!path->dentry->d_inode)
-		goto exit_dput;
+	if (!inode) {
+		path_to_nameidata(path, nd);
+		goto terminate;
+	}
 
-	if (path->dentry->d_inode->i_op->follow_link)
+	if (should_follow_link(inode, !symlink_ok)) {
+		if (nd->flags & LOOKUP_RCU) {
+			if (unlikely(unlazy_walk(nd, path->dentry))) {
+				error = -ECHILD;
+				goto terminate;
+			}
+		}
 		return NULL;
+	}
 
 	path_to_nameidata(path, nd);
-	nd->inode = path->dentry->d_inode;
-	/* Why this, you ask?  _Now_ we might have grown LOOKUP_JUMPED... */
+	nd->inode = inode;
+
 	error = complete_walk(nd);
 	if (error)
 		return ERR_PTR(error);
 	error = -EISDIR;
-	if (S_ISDIR(nd->inode->i_mode))
+	if ((open_flag & O_CREAT) && S_ISDIR(inode->i_mode))
+		goto exit;
+	error = -ENOTDIR;
+	if (nd->flags & LOOKUP_DIRECTORY && !inode->i_op->lookup)
 		goto exit;
+
+	audit_inode(pathname, nd->path.dentry);
 ok:
 	if (!S_ISREG(nd->inode->i_mode))
 		will_truncate = 0;
@@ -2303,6 +2316,10 @@ exit_dput:
 exit:
 	filp = ERR_PTR(error);
 	goto out;
+
+terminate:
+	terminate_walk(nd);
+	return ERR_PTR(error);
 }
 
 static struct file *path_openat(int dfd, const char *pathname,
-- 
1.7.7

