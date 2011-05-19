Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab1ESJKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933224Ab1ESJKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 32/32] GFS2: Move all locking inside the inode creation function
Date: Thu, 19 May 2011 09:47:27 +0100
Message-Id: <1305794847-3291-33-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there are no longer any exceptions to the normal inode
creation code path, we can move the parts of the locking code
which were duplicated in mkdir/mknod/create/symlink into the
inode create function.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index c2a3d9c..03e0c52 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2011 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -413,7 +413,8 @@ out:
 	return error;
 }
 
-static void gfs2_init_dir(struct buffer_head *dibh, const struct gfs2_inode *parent)
+static void gfs2_init_dir(struct buffer_head *dibh,
+			  const struct gfs2_inode *parent)
 {
 	struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
 	struct gfs2_dirent *dent = (struct gfs2_dirent *)(di+1);
@@ -431,12 +432,17 @@ static void gfs2_init_dir(struct buffer_head *dibh, const struct gfs2_inode *par
 
 /**
  * init_dinode - Fill in a new dinode structure
- * @dip: the directory this inode is being created in
+ * @dip: The directory this inode is being created in
  * @gl: The glock covering the new inode
- * @inum: the inode number
- * @mode: the file permissions
- * @uid:
- * @gid:
+ * @inum: The inode number
+ * @mode: The file permissions
+ * @uid: The uid of the new inode
+ * @gid: The gid of the new inode
+ * @generation: The generation number of the new inode
+ * @dev: The device number (if a device node)
+ * @symname: The symlink destination (if a symlink)
+ * @size: The inode size (ignored for directories)
+ * @bhp: The buffer head (returned to caller)
  *
  */
 
@@ -644,29 +650,25 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
 }
 
 /**
- * gfs2_createi - Create a new inode
- * @ghs: An array of two holders
- * @name: The name of the new file
- * @mode: the permissions on the new inode
+ * gfs2_create_inode - Create a new inode
+ * @dir: The parent directory
+ * @dentry: The new dentry
+ * @mode: The permissions on the new inode
+ * @dev: For device nodes, this is the device number
+ * @symname: For symlinks, this is the link destination
+ * @size: The initial size of the inode (ignored for directories)
  *
- * @ghs[0] is an initialized holder for the directory
- * @ghs[1] is the holder for the inode lock
- *
- * If the return value is not NULL, the glocks on both the directory and the new
- * file are held.  A transaction has been started and an inplace reservation
- * is held, as well.
- *
- * Returns: An inode
+ * Returns: 0 on success, or error code
  */
 
-static struct inode *gfs2_createi(struct gfs2_holder *ghs,
-				  const struct qstr *name, unsigned int mode,
-				  dev_t dev, const char *symname,
-				  unsigned int size)
+static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
+			     unsigned int mode, dev_t dev, const char *symname,
+			     unsigned int size)
 {
+	const struct qstr *name = &dentry->d_name;
+	struct gfs2_holder ghs[2];
 	struct inode *inode = NULL;
-	struct gfs2_inode *dip = ghs->gh_gl->gl_object;
-	struct inode *dir = &dip->i_inode;
+	struct gfs2_inode *dip = GFS2_I(dir);
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_inum_host inum = { .no_addr = 0, .no_formal_ino = 0 };
 	int error;
@@ -674,10 +676,9 @@ static struct inode *gfs2_createi(struct gfs2_holder *ghs,
 	struct buffer_head *bh = NULL;
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
-		return ERR_PTR(-ENAMETOOLONG);
+		return -ENAMETOOLONG;
 
-	gfs2_holder_reinit(LM_ST_EXCLUSIVE, 0, ghs);
-	error = gfs2_glock_nq(ghs);
+	error = gfs2_glock_nq_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	if (error)
 		goto fail;
 
@@ -722,19 +723,29 @@ static struct inode *gfs2_createi(struct gfs2_holder *ghs,
 
 	if (bh)
 		brelse(bh);
-	return inode;
+
+	gfs2_trans_end(sdp);
+	if (dip->i_alloc->al_rgd)
+		gfs2_inplace_release(dip);
+	gfs2_quota_unlock(dip);
+	gfs2_alloc_put(dip);
+	gfs2_glock_dq_uninit_m(2, ghs);
+	mark_inode_dirty(inode);
+	d_instantiate(dentry, inode);
+	return 0;
 
 fail_gunlock2:
 	gfs2_glock_dq_uninit(ghs + 1);
 	if (inode && !IS_ERR(inode))
 		iput(inode);
 fail_gunlock:
-	gfs2_glock_dq(ghs);
+	gfs2_glock_dq_uninit(ghs);
 fail:
 	if (bh)
 		brelse(bh);
-	return ERR_PTR(error);
+	return error;
 }
+
 /**
  * gfs2_create - Create a file
  * @dir: The directory in which to create the file
@@ -747,44 +758,23 @@ fail:
 static int gfs2_create(struct inode *dir, struct dentry *dentry,
 		       int mode, struct nameidata *nd)
 {
-	struct gfs2_inode *dip = GFS2_I(dir);
-	struct gfs2_sbd *sdp = GFS2_SB(dir);
-	struct gfs2_holder ghs[2];
 	struct inode *inode;
-
-	gfs2_holder_init(dip->i_gl, 0, 0, ghs);
+	int ret;
 
 	for (;;) {
-		inode = gfs2_createi(ghs, &dentry->d_name, S_IFREG | mode, 0, NULL, 0);
-		if (!IS_ERR(inode)) {
-			gfs2_trans_end(sdp);
-			if (dip->i_alloc->al_rgd)
-				gfs2_inplace_release(dip);
-			gfs2_quota_unlock(dip);
-			gfs2_alloc_put(dip);
-			gfs2_glock_dq_uninit_m(2, ghs);
-			mark_inode_dirty(inode);
-			break;
-		} else if (PTR_ERR(inode) != -EEXIST ||
-			   (nd && nd->flags & LOOKUP_EXCL)) {
-			gfs2_holder_uninit(ghs);
-			return PTR_ERR(inode);
-		}
+		ret = gfs2_create_inode(dir, dentry, S_IFREG | mode, 0, NULL, 0);
+		if (ret != -EEXIST || (nd && (nd->flags & LOOKUP_EXCL)))
+			return ret;
 
 		inode = gfs2_lookupi(dir, &dentry->d_name, 0);
 		if (inode) {
-			if (!IS_ERR(inode)) {
-				gfs2_holder_uninit(ghs);
+			if (!IS_ERR(inode))
 				break;
-			} else {
-				gfs2_holder_uninit(ghs);
-				return PTR_ERR(inode);
-			}
+			return PTR_ERR(inode);
 		}
 	}
 
 	d_instantiate(dentry, inode);
-
 	return 0;
 }
 
@@ -1150,36 +1140,14 @@ out_parent:
 static int gfs2_symlink(struct inode *dir, struct dentry *dentry,
 			const char *symname)
 {
-	struct gfs2_inode *dip = GFS2_I(dir);
 	struct gfs2_sbd *sdp = GFS2_SB(dir);
-	struct gfs2_holder ghs[2];
-	struct inode *inode;
 	unsigned int size;
 
 	size = strlen(symname);
 	if (size > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode) - 1)
 		return -ENAMETOOLONG;
 
-	gfs2_holder_init(dip->i_gl, 0, 0, ghs);
-
-	inode = gfs2_createi(ghs, &dentry->d_name, S_IFLNK | S_IRWXUGO, 0, symname, size);
-	if (IS_ERR(inode)) {
-		gfs2_holder_uninit(ghs);
-		return PTR_ERR(inode);
-	}
-
-	gfs2_trans_end(sdp);
-	if (dip->i_alloc->al_rgd)
-		gfs2_inplace_release(dip);
-	gfs2_quota_unlock(dip);
-	gfs2_alloc_put(dip);
-
-	gfs2_glock_dq_uninit_m(2, ghs);
-
-	d_instantiate(dentry, inode);
-	mark_inode_dirty(inode);
-
-	return 0;
+	return gfs2_create_inode(dir, dentry, S_IFLNK | S_IRWXUGO, 0, symname, size);
 }
 
 /**
@@ -1193,31 +1161,7 @@ static int gfs2_symlink(struct inode *dir, struct dentry *dentry,
 
 static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-	struct gfs2_inode *dip = GFS2_I(dir);
-	struct gfs2_sbd *sdp = GFS2_SB(dir);
-	struct gfs2_holder ghs[2];
-	struct inode *inode;
-
-	gfs2_holder_init(dip->i_gl, 0, 0, ghs);
-
-	inode = gfs2_createi(ghs, &dentry->d_name, S_IFDIR | mode, 0, NULL, 0);
-	if (IS_ERR(inode)) {
-		gfs2_holder_uninit(ghs);
-		return PTR_ERR(inode);
-	}
-
-	gfs2_trans_end(sdp);
-	if (dip->i_alloc->al_rgd)
-		gfs2_inplace_release(dip);
-	gfs2_quota_unlock(dip);
-	gfs2_alloc_put(dip);
-
-	gfs2_glock_dq_uninit_m(2, ghs);
-
-	d_instantiate(dentry, inode);
-	mark_inode_dirty(inode);
-
-	return 0;
+	return gfs2_create_inode(dir, dentry, S_IFDIR | mode, 0, NULL, 0);
 }
 
 /**
@@ -1225,38 +1169,14 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
  * @dir: The directory in which the special file will reside
  * @dentry: The dentry of the special file
  * @mode: The mode of the special file
- * @rdev: The device specification of the special file
+ * @dev: The device specification of the special file
  *
  */
 
 static int gfs2_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		      dev_t dev)
 {
-	struct gfs2_inode *dip = GFS2_I(dir);
-	struct gfs2_sbd *sdp = GFS2_SB(dir);
-	struct gfs2_holder ghs[2];
-	struct inode *inode;
-
-	gfs2_holder_init(dip->i_gl, 0, 0, ghs);
-
-	inode = gfs2_createi(ghs, &dentry->d_name, mode, dev, NULL, 0);
-	if (IS_ERR(inode)) {
-		gfs2_holder_uninit(ghs);
-		return PTR_ERR(inode);
-	}
-
-	gfs2_trans_end(sdp);
-	if (dip->i_alloc->al_rgd)
-		gfs2_inplace_release(dip);
-	gfs2_quota_unlock(dip);
-	gfs2_alloc_put(dip);
-
-	gfs2_glock_dq_uninit_m(2, ghs);
-
-	d_instantiate(dentry, inode);
-	mark_inode_dirty(inode);
-
-	return 0;
+	return gfs2_create_inode(dir, dentry, mode, dev, NULL, 0);
 }
 
 /*
-- 
1.7.4

