Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab1ESJRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:17:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab1ESJKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:05 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/32] GFS2: Combine transaction from gfs2_dir_exhash_dealloc
Date: Thu, 19 May 2011 09:46:58 +0100
Message-Id: <1305794847-3291-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

At the end of function gfs2_dir_exhash_dealloc, it was setting the dinode
type to "file" to prevent directory corruption in case of a crash.
It was doing so in its own journal transaction.  This patch makes the
change occur when the last call is make to leaf_dealloc, since it needs
to rewrite the directory dinode at that time anyway.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 0bb5f6b..bd57587 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -86,7 +86,7 @@ typedef int (*gfs2_dscan_t)(const struct gfs2_dirent *dent,
 			    const struct qstr *name, void *opaque);
 
 static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
-			u64 leaf_no);
+			u64 leaf_no, int last_dealloc);
 
 int gfs2_dir_get_new_buffer(struct gfs2_inode *ip, u64 block,
 			    struct buffer_head **bhp)
@@ -1781,10 +1781,10 @@ static int foreach_leaf(struct gfs2_inode *dip)
 	struct gfs2_leaf *leaf;
 	u32 hsize, len;
 	u32 ht_offset, lp_offset, ht_offset_cur = -1;
-	u32 index = 0;
+	u32 index = 0, next_index;
 	__be64 *lp;
 	u64 leaf_no;
-	int error = 0;
+	int error = 0, last;
 
 	hsize = 1 << dip->i_depth;
 	if (hsize * sizeof(u64) != i_size_read(&dip->i_inode)) {
@@ -1819,13 +1819,13 @@ static int foreach_leaf(struct gfs2_inode *dip)
 				goto out;
 			leaf = (struct gfs2_leaf *)bh->b_data;
 			len = 1 << (dip->i_depth - be16_to_cpu(leaf->lf_depth));
+			next_index = (index & ~(len - 1)) + len;
+			last = ((next_index >= hsize) ? 1 : 0);
 			brelse(bh);
-
-			error = leaf_dealloc(dip, index, len, leaf_no);
+			error = leaf_dealloc(dip, index, len, leaf_no, last);
 			if (error)
 				goto out;
-
-			index = (index & ~(len - 1)) + len;
+			index = next_index;
 		} else
 			index++;
 	}
@@ -1847,13 +1847,13 @@ out:
  * @index: the hash table offset in the directory
  * @len: the number of pointers to this leaf
  * @leaf_no: the leaf number
- * @data: not used
+ * last_dealloc: 1 if this is the final dealloc for the leaf, else 0
  *
  * Returns: errno
  */
 
 static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
-			u64 leaf_no)
+			u64 leaf_no, int last_dealloc)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_leaf *tmp_leaf;
@@ -1940,6 +1940,10 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 		goto out_end_trans;
 
 	gfs2_trans_add_bh(dip->i_gl, dibh, 1);
+	/* On the last dealloc, make this a regular file in case we crash.
+	   (We don't want to free these blocks a second time.)  */
+	if (last_dealloc)
+		dip->i_inode.i_mode = S_IFREG;
 	gfs2_dinode_out(dip, dibh->b_data);
 	brelse(dibh);
 
@@ -1971,33 +1975,8 @@ out:
 
 int gfs2_dir_exhash_dealloc(struct gfs2_inode *dip)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	struct buffer_head *bh;
-	int error;
-
 	/* Dealloc on-disk leaves to FREEMETA state */
-	error = foreach_leaf(dip);
-	if (error)
-		return error;
-
-	/* Make this a regular file in case we crash.
-	   (We don't want to free these blocks a second time.)  */
-
-	error = gfs2_trans_begin(sdp, RES_DINODE, 0);
-	if (error)
-		return error;
-
-	error = gfs2_meta_inode_buffer(dip, &bh);
-	if (!error) {
-		gfs2_trans_add_bh(dip->i_gl, bh, 1);
-		((struct gfs2_dinode *)bh->b_data)->di_mode =
-						cpu_to_be32(S_IFREG);
-		brelse(bh);
-	}
-
-	gfs2_trans_end(sdp);
-
-	return error;
+	return foreach_leaf(dip);
 }
 
 /**
-- 
1.7.4

