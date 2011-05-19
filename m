Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab1ESJKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932879Ab1ESJKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:08 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/32] GFS2: pass leaf_bh into leaf_dealloc
Date: Thu, 19 May 2011 09:46:59 +0100
Message-Id: <1305794847-3291-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Function foreach_leaf used to look up the leaf block address and get
a buffer_head.  Then it would call leaf_dealloc which did the same
lookup.  This patch combines the two operations by making foreach_leaf
pass the leaf bh to leaf_dealloc.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index bd57587..1f5a7ac 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -86,7 +86,8 @@ typedef int (*gfs2_dscan_t)(const struct gfs2_dirent *dent,
 			    const struct qstr *name, void *opaque);
 
 static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
-			u64 leaf_no, int last_dealloc);
+			u64 leaf_no, struct buffer_head *leaf_bh,
+			int last_dealloc);
 
 int gfs2_dir_get_new_buffer(struct gfs2_inode *ip, u64 block,
 			    struct buffer_head **bhp)
@@ -1821,8 +1822,9 @@ static int foreach_leaf(struct gfs2_inode *dip)
 			len = 1 << (dip->i_depth - be16_to_cpu(leaf->lf_depth));
 			next_index = (index & ~(len - 1)) + len;
 			last = ((next_index >= hsize) ? 1 : 0);
+			error = leaf_dealloc(dip, index, len, leaf_no, bh,
+					     last);
 			brelse(bh);
-			error = leaf_dealloc(dip, index, len, leaf_no, last);
 			if (error)
 				goto out;
 			index = next_index;
@@ -1847,13 +1849,15 @@ out:
  * @index: the hash table offset in the directory
  * @len: the number of pointers to this leaf
  * @leaf_no: the leaf number
+ * @leaf_bh: buffer_head for the starting leaf
  * last_dealloc: 1 if this is the final dealloc for the leaf, else 0
  *
  * Returns: errno
  */
 
 static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
-			u64 leaf_no, int last_dealloc)
+			u64 leaf_no, struct buffer_head *leaf_bh,
+			int last_dealloc)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_leaf *tmp_leaf;
@@ -1885,14 +1889,18 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 		goto out_qs;
 
 	/*  Count the number of leaves  */
+	bh = leaf_bh;
 
 	for (blk = leaf_no; blk; blk = nblk) {
-		error = get_leaf(dip, blk, &bh);
-		if (error)
-			goto out_rlist;
+		if (blk != leaf_no) {
+			error = get_leaf(dip, blk, &bh);
+			if (error)
+				goto out_rlist;
+		}
 		tmp_leaf = (struct gfs2_leaf *)bh->b_data;
 		nblk = be64_to_cpu(tmp_leaf->lf_next);
-		brelse(bh);
+		if (blk != leaf_no)
+			brelse(bh);
 
 		gfs2_rlist_add(sdp, &rlist, blk);
 		l_blocks++;
@@ -1916,13 +1924,18 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 	if (error)
 		goto out_rg_gunlock;
 
+	bh = leaf_bh;
+
 	for (blk = leaf_no; blk; blk = nblk) {
-		error = get_leaf(dip, blk, &bh);
-		if (error)
-			goto out_end_trans;
+		if (blk != leaf_no) {
+			error = get_leaf(dip, blk, &bh);
+			if (error)
+				goto out_end_trans;
+		}
 		tmp_leaf = (struct gfs2_leaf *)bh->b_data;
 		nblk = be64_to_cpu(tmp_leaf->lf_next);
-		brelse(bh);
+		if (blk != leaf_no)
+			brelse(bh);
 
 		gfs2_free_meta(dip, blk, 1);
 		gfs2_add_inode_blocks(&dip->i_inode, -1);
-- 
1.7.4

