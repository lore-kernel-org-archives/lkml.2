Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2C1UYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:24:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42688 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab2C1UYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:24:30 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 02/16] vfs: reorganize do_last()
Date: Wed, 28 Mar 2012 22:24:31 +0200
Message-Id: <1332966285-30358-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
References: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Make the slow lookup part of O_CREAT and non-O_CREAT opens common.

This allows atomic_open to be hooked into the slow lookup part.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   92 ++++++++++++++++++++++++++++++++++++------------------------
 1 files changed, 55 insertions(+), 37 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 936648c..ff3c47b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2108,6 +2108,8 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	int want_write = 0;
 	int acc_mode = op->acc_mode;
 	struct file *filp;
+	struct inode *inode;
+	int symlink_ok = 0;
 	int error;
 
 	nd->flags &= ~LOOKUP_PARENT;
@@ -2139,47 +2141,38 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
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
@@ -2192,9 +2185,14 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
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
@@ -2238,22 +2236,38 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
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
+	if ((nd->flags & LOOKUP_DIRECTORY) && !inode->i_op->lookup)
 		goto exit;
+
+	audit_inode(pathname, nd->path.dentry);
 ok:
 	if (!S_ISREG(nd->inode->i_mode))
 		will_truncate = 0;
@@ -2298,6 +2312,10 @@ exit_dput:
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

