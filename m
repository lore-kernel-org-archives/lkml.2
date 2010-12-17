Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0LQMtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:49:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab0LQMqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:10 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/15] GFS2: Clean up duplicated setattr code
Date: Fri, 17 Dec 2010 12:24:10 +0000
Message-Id: <1292588661-14350-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While preparing the last patch I noticed that the gfs2_setattr_simple
code had been duplicated into two other places. This patch updates
those to call gfs2_setattr_simple rather than open coding it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 457ecd1..1db6b73 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1069,7 +1069,6 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	struct buffer_head *dibh;
 	u32 ouid, ogid, nuid, ngid;
 	int error;
 
@@ -1100,16 +1099,10 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	if (error)
 		goto out_gunlock_q;
 
-	error = gfs2_meta_inode_buffer(ip, &dibh);
+	error = gfs2_setattr_simple(ip, attr);
 	if (error)
 		goto out_end_trans;
 
-	setattr_copy(inode, attr);
-	mark_inode_dirty(inode);
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-	gfs2_dinode_out(ip, dibh->b_data);
-	brelse(dibh);
-
 	if (ouid != NO_QUOTA_CHANGE || ogid != NO_QUOTA_CHANGE) {
 		u64 blocks = gfs2_get_inode_blocks(&ip->i_inode);
 		gfs2_quota_change(ip, -blocks, ouid, ogid);
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index ecfd40d..439b61c 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -1296,10 +1296,8 @@ fail:
 
 int gfs2_xattr_acl_chmod(struct gfs2_inode *ip, struct iattr *attr, char *data)
 {
-	struct inode *inode = &ip->i_inode;
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_ea_location el;
-	struct buffer_head *dibh;
 	int error;
 
 	error = gfs2_ea_find(ip, GFS2_EATYPE_SYS, GFS2_POSIX_ACL_ACCESS, &el);
@@ -1321,17 +1319,7 @@ int gfs2_xattr_acl_chmod(struct gfs2_inode *ip, struct iattr *attr, char *data)
 	if (error)
 		return error;
 
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		goto out_trans_end;
-
-	setattr_copy(inode, attr);
-	mark_inode_dirty(inode);
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-	gfs2_dinode_out(ip, dibh->b_data);
-	brelse(dibh);
-
-out_trans_end:
+	error = gfs2_setattr_simple(ip, attr);
 	gfs2_trans_end(sdp);
 	return error;
 }
-- 
1.7.3.3

