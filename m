Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab1ESJNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:13:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120Ab1ESJKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:31 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/32] GFS2: Make gfs2_dir_del update link count when required
Date: Thu, 19 May 2011 09:47:16 +0100
Message-Id: <1305794847-3291-22-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we remove an entry from a directory, we can save ourselves
some trouble if we know the type of the entry in question, since
if it is itself a directory, we can update the link count of the
parent at the same time as removing the directory entry.

In addition this patch also merges the rmdir and unlink code which
was almost identical anyway. This eliminates the calls to remove
the . and .. directory entries on each rmdir (not needed since the
directory will be deallocated, anyway) which was the only thing preventing
passing the dentry to gfs2_dir_del(). The passing of the dentry
rather than just the name allows us to figure out the type of the entry
which is being removed, and thus adjust the link count when required.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index f7a3137..4102651 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1669,8 +1669,9 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
  * Returns: 0 on success, error code on failure
  */
 
-int gfs2_dir_del(struct gfs2_inode *dip, const struct qstr *name)
+int gfs2_dir_del(struct gfs2_inode *dip, const struct dentry *dentry)
 {
+	const struct qstr *name = &dentry->d_name;
 	struct gfs2_dirent *dent, *prev = NULL;
 	struct buffer_head *bh;
 	int error;
@@ -1711,6 +1712,8 @@ int gfs2_dir_del(struct gfs2_inode *dip, const struct qstr *name)
 	gfs2_trans_add_bh(dip->i_gl, bh, 1);
 	dip->i_entries--;
 	dip->i_inode.i_mtime = dip->i_inode.i_ctime = CURRENT_TIME;
+	if (S_ISDIR(dentry->d_inode->i_mode))
+		drop_nlink(&dip->i_inode);
 	gfs2_dinode_out(dip, bh->b_data);
 	brelse(bh);
 	mark_inode_dirty(&dip->i_inode);
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index a98f644..66831f1 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -23,7 +23,7 @@ extern int gfs2_dir_check(struct inode *dir, const struct qstr *filename,
 			  const struct gfs2_inode *ip);
 extern int gfs2_dir_add(struct inode *inode, const struct qstr *filename,
 			const struct gfs2_inode *ip, unsigned int type);
-extern int gfs2_dir_del(struct gfs2_inode *dip, const struct qstr *filename);
+extern int gfs2_dir_del(struct gfs2_inode *dip, const struct dentry *dentry);
 extern int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 			 filldir_t filldir);
 extern int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index acb6f69..765da06 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -312,11 +312,52 @@ static int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 }
 
 /**
- * gfs2_unlink - Unlink a file
- * @dir: The inode of the directory containing the file to unlink
+ * gfs2_unlink_inode - Removes an inode from its parent dir and unlinks it
+ * @dip: The parent directory
+ * @name: The name of the entry in the parent directory
+ * @bh: The inode buffer for the inode to be removed
+ * @inode: The inode to be removed
+ *
+ * Called with all the locks and in a transaction. This will only be
+ * called for a directory after it has been checked to ensure it is empty.
+ *
+ * Returns: 0 on success, or an error
+ */
+
+static int gfs2_unlink_inode(struct gfs2_inode *dip,
+			     const struct dentry *dentry,
+			     struct buffer_head *bh)
+{
+	struct inode *inode = dentry->d_inode;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	int error;
+
+	error = gfs2_dir_del(dip, dentry);
+	if (error)
+		return error;
+
+	ip->i_entries = 0;
+	inode->i_ctime = CURRENT_TIME;
+	if (S_ISDIR(inode->i_mode))
+		clear_nlink(inode);
+	else
+		drop_nlink(inode);
+	gfs2_trans_add_bh(ip->i_gl, bh, 1);
+	gfs2_dinode_out(ip, bh->b_data);
+	mark_inode_dirty(inode);
+	if (inode->i_nlink == 0)
+		gfs2_unlink_di(inode);
+	return 0;
+}
+
+
+/**
+ * gfs2_unlink - Unlink an inode (this does rmdir as well)
+ * @dir: The inode of the directory containing the inode to unlink
  * @dentry: The file itself
  *
- * Unlink a file.  Call gfs2_unlinki()
+ * This routine uses the type of the inode as a flag to figure out
+ * whether this is an unlink or an rmdir.
  *
  * Returns: errno
  */
@@ -325,7 +366,9 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct gfs2_inode *dip = GFS2_I(dir);
 	struct gfs2_sbd *sdp = GFS2_SB(dir);
-	struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
+	struct inode *inode = dentry->d_inode;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct buffer_head *bh;
 	struct gfs2_holder ghs[3];
 	struct gfs2_rgrpd *rgd;
 	struct gfs2_holder ri_gh;
@@ -351,9 +394,15 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 		goto out_child;
 
 	error = -ENOENT;
-	if (ip->i_inode.i_nlink == 0)
+	if (inode->i_nlink == 0)
 		goto out_rgrp;
 
+	if (S_ISDIR(inode->i_mode)) {
+		error = -ENOTEMPTY;
+		if (ip->i_entries > 2 || inode->i_nlink > 2)
+			goto out_rgrp;
+	}
+
 	error = gfs2_glock_nq(ghs + 2); /* rgrp */
 	if (error)
 		goto out_rgrp;
@@ -362,15 +411,16 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	if (error)
 		goto out_gunlock;
 
-	error = gfs2_trans_begin(sdp, 2*RES_DINODE + RES_LEAF + RES_RG_BIT, 0);
+	error = gfs2_trans_begin(sdp, 2*RES_DINODE + 3*RES_LEAF + RES_RG_BIT, 0);
 	if (error)
 		goto out_gunlock;
 
-	error = gfs2_dir_del(dip, &dentry->d_name);
-        if (error)
-                goto out_end_trans;
+	error = gfs2_meta_inode_buffer(ip, &bh);
+	if (error)
+		goto out_end_trans;
 
-	error = gfs2_change_nlink(ip, -1);
+	error = gfs2_unlink_inode(dip, dentry, bh);
+	brelse(bh);
 
 out_end_trans:
 	gfs2_trans_end(sdp);
@@ -522,138 +572,6 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 }
 
 /**
- * gfs2_rmdiri - Remove a directory
- * @dip: The parent directory of the directory to be removed
- * @name: The name of the directory to be removed
- * @ip: The GFS2 inode of the directory to be removed
- *
- * Assumes Glocks on dip and ip are held
- *
- * Returns: errno
- */
-
-static int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
-		       struct gfs2_inode *ip)
-{
-	int error;
-
-	if (ip->i_entries != 2) {
-		if (gfs2_consist_inode(ip))
-			gfs2_dinode_print(ip);
-		return -EIO;
-	}
-
-	error = gfs2_dir_del(dip, name);
-	if (error)
-		return error;
-
-	error = gfs2_change_nlink(dip, -1);
-	if (error)
-		return error;
-
-	error = gfs2_dir_del(ip, &gfs2_qdot);
-	if (error)
-		return error;
-
-	error = gfs2_dir_del(ip, &gfs2_qdotdot);
-	if (error)
-		return error;
-
-	/* It looks odd, but it really should be done twice */
-	error = gfs2_change_nlink(ip, -1);
-	if (error)
-		return error;
-
-	error = gfs2_change_nlink(ip, -1);
-	if (error)
-		return error;
-
-	return error;
-}
-
-/**
- * gfs2_rmdir - Remove a directory
- * @dir: The parent directory of the directory to be removed
- * @dentry: The dentry of the directory to remove
- *
- * Remove a directory. Call gfs2_rmdiri()
- *
- * Returns: errno
- */
-
-static int gfs2_rmdir(struct inode *dir, struct dentry *dentry)
-{
-	struct gfs2_inode *dip = GFS2_I(dir);
-	struct gfs2_sbd *sdp = GFS2_SB(dir);
-	struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
-	struct gfs2_holder ghs[3];
-	struct gfs2_rgrpd *rgd;
-	struct gfs2_holder ri_gh;
-	int error;
-
-	error = gfs2_rindex_hold(sdp, &ri_gh);
-	if (error)
-		return error;
-	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, ghs + 1);
-
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
-	gfs2_holder_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + 2);
-
-	error = gfs2_glock_nq(ghs); /* parent */
-	if (error)
-		goto out_parent;
-
-	error = gfs2_glock_nq(ghs + 1); /* child */
-	if (error)
-		goto out_child;
-
-	error = -ENOENT;
-	if (ip->i_inode.i_nlink == 0)
-		goto out_rgrp;
-
-	error = gfs2_glock_nq(ghs + 2); /* rgrp */
-	if (error)
-		goto out_rgrp;
-
-	error = gfs2_unlink_ok(dip, &dentry->d_name, ip);
-	if (error)
-		goto out_gunlock;
-
-	if (ip->i_entries < 2) {
-		if (gfs2_consist_inode(ip))
-			gfs2_dinode_print(ip);
-		error = -EIO;
-		goto out_gunlock;
-	}
-	if (ip->i_entries > 2) {
-		error = -ENOTEMPTY;
-		goto out_gunlock;
-	}
-
-	error = gfs2_trans_begin(sdp, 2 * RES_DINODE + 3 * RES_LEAF + RES_RG_BIT, 0);
-	if (error)
-		goto out_gunlock;
-
-	error = gfs2_rmdiri(dip, &dentry->d_name, ip);
-
-	gfs2_trans_end(sdp);
-
-out_gunlock:
-	gfs2_glock_dq(ghs + 2);
-out_rgrp:
-	gfs2_holder_uninit(ghs + 2);
-	gfs2_glock_dq(ghs + 1);
-out_child:
-	gfs2_holder_uninit(ghs + 1);
-	gfs2_glock_dq(ghs);
-out_parent:
-	gfs2_holder_uninit(ghs);
-	gfs2_glock_dq_uninit(&ri_gh);
-	return error;
-}
-
-/**
  * gfs2_mknod - Make a special file
  * @dir: The directory in which the special file will reside
  * @dentry: The dentry of the special file
@@ -930,25 +848,18 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	/* Remove the target file, if it exists */
 
 	if (nip) {
-		if (S_ISDIR(nip->i_inode.i_mode))
-			error = gfs2_rmdiri(ndip, &ndentry->d_name, nip);
-		else {
-			error = gfs2_dir_del(ndip, &ndentry->d_name);
-			if (error)
-				goto out_end_trans;
-			error = gfs2_change_nlink(nip, -1);
-		}
+		struct buffer_head *bh;
+		error = gfs2_meta_inode_buffer(nip, &bh);
 		if (error)
 			goto out_end_trans;
+		error = gfs2_unlink_inode(ndip, ndentry, bh);
+		brelse(bh);
 	}
 
 	if (dir_rename) {
 		error = gfs2_change_nlink(ndip, +1);
 		if (error)
 			goto out_end_trans;
-		error = gfs2_change_nlink(odip, -1);
-		if (error)
-			goto out_end_trans;
 
 		error = gfs2_dir_mvino(ip, &gfs2_qdotdot, ndip, DT_DIR);
 		if (error)
@@ -964,7 +875,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		brelse(dibh);
 	}
 
-	error = gfs2_dir_del(odip, &odentry->d_name);
+	error = gfs2_dir_del(odip, odentry);
 	if (error)
 		goto out_end_trans;
 
@@ -1347,7 +1258,7 @@ const struct inode_operations gfs2_dir_iops = {
 	.unlink = gfs2_unlink,
 	.symlink = gfs2_symlink,
 	.mkdir = gfs2_mkdir,
-	.rmdir = gfs2_rmdir,
+	.rmdir = gfs2_unlink,
 	.mknod = gfs2_mknod,
 	.rename = gfs2_rename,
 	.permission = gfs2_permission,
-- 
1.7.4

