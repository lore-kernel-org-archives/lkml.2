Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab1ESJKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018Ab1ESJKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:33 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 22/32] GFS2: When adding a new dir entry, inc link count if it is a subdir
Date: Thu, 19 May 2011 09:47:17 +0100
Message-Id: <1305794847-3291-23-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an increment of the link count when we add a new directory
entry, if that entry is itself a directory. This means that we no
longer need separate code to perform this operation.

Now that both adding and removing directory entries automatically
update the parent directory's link count if required, that makes
the code shorter and simpler than before.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 4102651..091ee47 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1597,7 +1597,7 @@ static int dir_new_leaf(struct inode *inode, const struct qstr *name)
  */
 
 int gfs2_dir_add(struct inode *inode, const struct qstr *name,
-		 const struct gfs2_inode *nip, unsigned type)
+		 const struct gfs2_inode *nip)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct buffer_head *bh;
@@ -1613,7 +1613,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 				return PTR_ERR(dent);
 			dent = gfs2_init_dirent(inode, dent, name, bh);
 			gfs2_inum_out(nip, dent);
-			dent->de_type = cpu_to_be16(type);
+			dent->de_type = cpu_to_be16(IF2DT(nip->i_inode.i_mode));
 			if (ip->i_diskflags & GFS2_DIF_EXHASH) {
 				leaf = (struct gfs2_leaf *)bh->b_data;
 				be16_add_cpu(&leaf->lf_entries, 1);
@@ -1625,6 +1625,8 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 			gfs2_trans_add_bh(ip->i_gl, bh, 1);
 			ip->i_entries++;
 			ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
+			if (S_ISDIR(nip->i_inode.i_mode))
+				inc_nlink(&ip->i_inode);
 			gfs2_dinode_out(ip, bh->b_data);
 			brelse(bh);
 			error = 0;
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index 66831f1..e686af1 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -22,7 +22,7 @@ extern struct inode *gfs2_dir_search(struct inode *dir,
 extern int gfs2_dir_check(struct inode *dir, const struct qstr *filename,
 			  const struct gfs2_inode *ip);
 extern int gfs2_dir_add(struct inode *inode, const struct qstr *filename,
-			const struct gfs2_inode *ip, unsigned int type);
+			const struct gfs2_inode *ip);
 extern int gfs2_dir_del(struct gfs2_inode *dip, const struct dentry *dentry);
 extern int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 			 filldir_t filldir);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 5a02606..a8c14c9 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -362,52 +362,6 @@ int gfs2_inode_refresh(struct gfs2_inode *ip)
 	return error;
 }
 
-/**
- * gfs2_change_nlink - Change nlink count on inode
- * @ip: The GFS2 inode
- * @diff: The change in the nlink count required
- *
- * Returns: errno
- */
-int gfs2_change_nlink(struct gfs2_inode *ip, int diff)
-{
-	struct buffer_head *dibh;
-	u32 nlink;
-	int error;
-
-	BUG_ON(diff != 1 && diff != -1);
-	nlink = ip->i_inode.i_nlink + diff;
-
-	/* If we are reducing the nlink count, but the new value ends up being
-	   bigger than the old one, we must have underflowed. */
-	if (diff < 0 && nlink > ip->i_inode.i_nlink) {
-		if (gfs2_consist_inode(ip))
-			gfs2_dinode_print(ip);
-		return -EIO;
-	}
-
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		return error;
-
-	if (diff > 0)
-		inc_nlink(&ip->i_inode);
-	else
-		drop_nlink(&ip->i_inode);
-
-	ip->i_inode.i_ctime = CURRENT_TIME;
-
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-	gfs2_dinode_out(ip, dibh->b_data);
-	brelse(dibh);
-	mark_inode_dirty(&ip->i_inode);
-
-	if (ip->i_inode.i_nlink == 0)
-		gfs2_unlink_di(&ip->i_inode); /* mark inode unlinked */
-
-	return error;
-}
-
 struct inode *gfs2_lookup_simple(struct inode *dip, const char *name)
 {
 	struct qstr qstr;
@@ -723,7 +677,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 			goto fail_quota_locks;
 	}
 
-	error = gfs2_dir_add(&dip->i_inode, name, ip, IF2DT(ip->i_inode.i_mode));
+	error = gfs2_dir_add(&dip->i_inode, name, ip);
 	if (error)
 		goto fail_end_trans;
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 8d1344a..f9b8289 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -106,7 +106,6 @@ extern struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr, int nonbl
 
 extern int gfs2_inode_refresh(struct gfs2_inode *ip);
 
-extern int gfs2_change_nlink(struct gfs2_inode *ip, int diff);
 extern struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 				  int is_root);
 extern struct inode *gfs2_createi(struct gfs2_holder *ghs,
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 765da06..6b8c2bd 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -235,7 +235,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	if (error)
 		goto out_end_trans;
 
-	error = gfs2_dir_add(dir, &dentry->d_name, ip, IF2DT(inode->i_mode));
+	error = gfs2_dir_add(dir, &dentry->d_name, ip);
 	if (error)
 		goto out_brelse;
 
@@ -554,9 +554,6 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		brelse(dibh);
 	}
 
-	error = gfs2_change_nlink(dip, +1);
-	gfs2_assert_withdraw(sdp, !error); /* dip already pinned */
-
 	gfs2_trans_end(sdp);
 	if (dip->i_alloc->al_rgd)
 		gfs2_inplace_release(dip);
@@ -857,10 +854,6 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	}
 
 	if (dir_rename) {
-		error = gfs2_change_nlink(ndip, +1);
-		if (error)
-			goto out_end_trans;
-
 		error = gfs2_dir_mvino(ip, &gfs2_qdotdot, ndip, DT_DIR);
 		if (error)
 			goto out_end_trans;
@@ -879,7 +872,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	if (error)
 		goto out_end_trans;
 
-	error = gfs2_dir_add(ndir, &ndentry->d_name, ip, IF2DT(ip->i_inode.i_mode));
+	error = gfs2_dir_add(ndir, &ndentry->d_name, ip);
 	if (error)
 		goto out_end_trans;
 
-- 
1.7.4

