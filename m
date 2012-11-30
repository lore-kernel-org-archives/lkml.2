Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab2K3KSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:18:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab2K3KSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:31 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/16] GFS2: Eliminate redundant buffer_head manipulation in gfs2_unlink_inode
Date: Fri, 30 Nov 2012 09:52:14 +0000
Message-Id: <1354269141-3311-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Since we now have a dirty_inode that takes care of manipulating the
inode buffer and writing from the inode to the buffer, we can
eliminate some unnecessary buffer manipulations in gfs2_unlink_inode
that are now redundant.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index ef3ce00..e321333 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -995,7 +995,6 @@ static int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
  * gfs2_unlink_inode - Removes an inode from its parent dir and unlinks it
  * @dip: The parent directory
  * @name: The name of the entry in the parent directory
- * @bh: The inode buffer for the inode to be removed
  * @inode: The inode to be removed
  *
  * Called with all the locks and in a transaction. This will only be
@@ -1005,8 +1004,7 @@ static int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
  */
 
 static int gfs2_unlink_inode(struct gfs2_inode *dip,
-			     const struct dentry *dentry,
-			     struct buffer_head *bh)
+			     const struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 	struct gfs2_inode *ip = GFS2_I(inode);
@@ -1046,7 +1044,6 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	struct gfs2_sbd *sdp = GFS2_SB(dir);
 	struct inode *inode = dentry->d_inode;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct buffer_head *bh;
 	struct gfs2_holder ghs[3];
 	struct gfs2_rgrpd *rgd;
 	int error;
@@ -1095,14 +1092,9 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 
 	error = gfs2_trans_begin(sdp, 2*RES_DINODE + 3*RES_LEAF + RES_RG_BIT, 0);
 	if (error)
-		goto out_gunlock;
-
-	error = gfs2_meta_inode_buffer(ip, &bh);
-	if (error)
 		goto out_end_trans;
 
-	error = gfs2_unlink_inode(dip, dentry, bh);
-	brelse(bh);
+	error = gfs2_unlink_inode(dip, dentry);
 
 out_end_trans:
 	gfs2_trans_end(sdp);
@@ -1402,14 +1394,8 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 
 	/* Remove the target file, if it exists */
 
-	if (nip) {
-		struct buffer_head *bh;
-		error = gfs2_meta_inode_buffer(nip, &bh);
-		if (error)
-			goto out_end_trans;
-		error = gfs2_unlink_inode(ndip, ndentry, bh);
-		brelse(bh);
-	}
+	if (nip)
+		error = gfs2_unlink_inode(ndip, ndentry);
 
 	if (dir_rename) {
 		error = gfs2_dir_mvino(ip, &gfs2_qdotdot, ndip, DT_DIR);
-- 
1.7.4

