Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab2AEMQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:16:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab2AEMQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:15 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/16] GFS2: More automated code analysis fixes
Date: Thu,  5 Jan 2012 11:51:49 +0000
Message-Id: <1325764322-10807-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A potentially uninitialised variable, some unreachable code,
and the main part of this, fixing the error path in the
unlink function.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 41d494d..f6be14f 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -743,9 +743,6 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 	else if (ip->i_depth)
 		revokes = sdp->sd_inptrs;
 
-	if (error)
-		return error;
-
 	memset(&rlist, 0, sizeof(struct gfs2_rgrp_list));
 	bstart = 0;
 	blen = 0;
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 46f6f9a..6336bc6 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -609,7 +609,7 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 	struct inode *inode = mapping->host;
 	int sync_state = inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC);
 	struct gfs2_inode *ip = GFS2_I(inode);
-	int ret, ret1 = 0;
+	int ret = 0, ret1 = 0;
 
 	if (mapping->nrpages) {
 		ret1 = filemap_fdatawrite_range(mapping, start, end);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index cfd4959..377920d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1037,12 +1037,14 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	struct buffer_head *bh;
 	struct gfs2_holder ghs[3];
 	struct gfs2_rgrpd *rgd;
-	int error;
+	int error = -EROFS;
 
 	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	gfs2_holder_init(ip->i_gl,  LM_ST_EXCLUSIVE, 0, ghs + 1);
 
 	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
+	if (!rgd)
+		goto out_inodes;
 	gfs2_holder_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + 2);
 
 
@@ -1088,12 +1090,13 @@ out_end_trans:
 out_gunlock:
 	gfs2_glock_dq(ghs + 2);
 out_rgrp:
-	gfs2_holder_uninit(ghs + 2);
 	gfs2_glock_dq(ghs + 1);
 out_child:
-	gfs2_holder_uninit(ghs + 1);
 	gfs2_glock_dq(ghs);
 out_parent:
+	gfs2_holder_uninit(ghs + 2);
+out_inodes:
+	gfs2_holder_uninit(ghs + 1);
 	gfs2_holder_uninit(ghs);
 	return error;
 }
-- 
1.7.4

