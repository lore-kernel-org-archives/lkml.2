Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab1ESJKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab1ESJKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:04 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/32] GFS2: remove *leaf_call_t and simplify leaf_dealloc
Date: Thu, 19 May 2011 09:46:57 +0100
Message-Id: <1305794847-3291-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Since foreach_leaf is only called with leaf_dealloc as its only possible
call function, we can simplify the code by making it call leaf_dealloc
directly.  This simplifies the code and eliminates the need for
leaf_call_t, the generic call method.  This is a first small step in
simplifying the directory leaf deallocation code.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index f789c57..0bb5f6b 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -82,11 +82,11 @@
 struct qstr gfs2_qdot __read_mostly;
 struct qstr gfs2_qdotdot __read_mostly;
 
-typedef int (*leaf_call_t) (struct gfs2_inode *dip, u32 index, u32 len,
-			    u64 leaf_no, void *data);
 typedef int (*gfs2_dscan_t)(const struct gfs2_dirent *dent,
 			    const struct qstr *name, void *opaque);
 
+static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
+			u64 leaf_no);
 
 int gfs2_dir_get_new_buffer(struct gfs2_inode *ip, u64 block,
 			    struct buffer_head **bhp)
@@ -1770,13 +1770,11 @@ int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
 /**
  * foreach_leaf - call a function for each leaf in a directory
  * @dip: the directory
- * @lc: the function to call for each each
- * @data: private data to pass to it
  *
  * Returns: errno
  */
 
-static int foreach_leaf(struct gfs2_inode *dip, leaf_call_t lc, void *data)
+static int foreach_leaf(struct gfs2_inode *dip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct buffer_head *bh;
@@ -1823,7 +1821,7 @@ static int foreach_leaf(struct gfs2_inode *dip, leaf_call_t lc, void *data)
 			len = 1 << (dip->i_depth - be16_to_cpu(leaf->lf_depth));
 			brelse(bh);
 
-			error = lc(dip, index, len, leaf_no, data);
+			error = leaf_dealloc(dip, index, len, leaf_no);
 			if (error)
 				goto out;
 
@@ -1855,7 +1853,7 @@ out:
  */
 
 static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
-			u64 leaf_no, void *data)
+			u64 leaf_no)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_leaf *tmp_leaf;
@@ -1978,7 +1976,7 @@ int gfs2_dir_exhash_dealloc(struct gfs2_inode *dip)
 	int error;
 
 	/* Dealloc on-disk leaves to FREEMETA state */
-	error = foreach_leaf(dip, leaf_dealloc, NULL);
+	error = foreach_leaf(dip);
 	if (error)
 		return error;
 
-- 
1.7.4

