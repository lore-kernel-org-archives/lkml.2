Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab1ESJR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:17:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880Ab1ESJKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:09 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/32] GFS2: move function foreach_leaf to gfs2_dir_exhash_dealloc
Date: Thu, 19 May 2011 09:47:00 +0100
Message-Id: <1305794847-3291-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

The previous patches made function gfs2_dir_exhash_dealloc do nothing
but call function foreach_leaf.  This patch simplifies the code by
moving the entire function foreach_leaf into gfs2_dir_exhash_dealloc.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 1f5a7ac..f7a3137 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -85,10 +85,6 @@ struct qstr gfs2_qdotdot __read_mostly;
 typedef int (*gfs2_dscan_t)(const struct gfs2_dirent *dent,
 			    const struct qstr *name, void *opaque);
 
-static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
-			u64 leaf_no, struct buffer_head *leaf_bh,
-			int last_dealloc);
-
 int gfs2_dir_get_new_buffer(struct gfs2_inode *ip, u64 block,
 			    struct buffer_head **bhp)
 {
@@ -1769,81 +1765,6 @@ int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
 }
 
 /**
- * foreach_leaf - call a function for each leaf in a directory
- * @dip: the directory
- *
- * Returns: errno
- */
-
-static int foreach_leaf(struct gfs2_inode *dip)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	struct buffer_head *bh;
-	struct gfs2_leaf *leaf;
-	u32 hsize, len;
-	u32 ht_offset, lp_offset, ht_offset_cur = -1;
-	u32 index = 0, next_index;
-	__be64 *lp;
-	u64 leaf_no;
-	int error = 0, last;
-
-	hsize = 1 << dip->i_depth;
-	if (hsize * sizeof(u64) != i_size_read(&dip->i_inode)) {
-		gfs2_consist_inode(dip);
-		return -EIO;
-	}
-
-	lp = kmalloc(sdp->sd_hash_bsize, GFP_NOFS);
-	if (!lp)
-		return -ENOMEM;
-
-	while (index < hsize) {
-		lp_offset = index & (sdp->sd_hash_ptrs - 1);
-		ht_offset = index - lp_offset;
-
-		if (ht_offset_cur != ht_offset) {
-			error = gfs2_dir_read_data(dip, (char *)lp,
-						ht_offset * sizeof(__be64),
-						sdp->sd_hash_bsize, 1);
-			if (error != sdp->sd_hash_bsize) {
-				if (error >= 0)
-					error = -EIO;
-				goto out;
-			}
-			ht_offset_cur = ht_offset;
-		}
-
-		leaf_no = be64_to_cpu(lp[lp_offset]);
-		if (leaf_no) {
-			error = get_leaf(dip, leaf_no, &bh);
-			if (error)
-				goto out;
-			leaf = (struct gfs2_leaf *)bh->b_data;
-			len = 1 << (dip->i_depth - be16_to_cpu(leaf->lf_depth));
-			next_index = (index & ~(len - 1)) + len;
-			last = ((next_index >= hsize) ? 1 : 0);
-			error = leaf_dealloc(dip, index, len, leaf_no, bh,
-					     last);
-			brelse(bh);
-			if (error)
-				goto out;
-			index = next_index;
-		} else
-			index++;
-	}
-
-	if (index != hsize) {
-		gfs2_consist_inode(dip);
-		error = -EIO;
-	}
-
-out:
-	kfree(lp);
-
-	return error;
-}
-
-/**
  * leaf_dealloc - Deallocate a directory leaf
  * @dip: the directory
  * @index: the hash table offset in the directory
@@ -1988,8 +1909,71 @@ out:
 
 int gfs2_dir_exhash_dealloc(struct gfs2_inode *dip)
 {
-	/* Dealloc on-disk leaves to FREEMETA state */
-	return foreach_leaf(dip);
+	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
+	struct buffer_head *bh;
+	struct gfs2_leaf *leaf;
+	u32 hsize, len;
+	u32 ht_offset, lp_offset, ht_offset_cur = -1;
+	u32 index = 0, next_index;
+	__be64 *lp;
+	u64 leaf_no;
+	int error = 0, last;
+
+	hsize = 1 << dip->i_depth;
+	if (hsize * sizeof(u64) != i_size_read(&dip->i_inode)) {
+		gfs2_consist_inode(dip);
+		return -EIO;
+	}
+
+	lp = kmalloc(sdp->sd_hash_bsize, GFP_NOFS);
+	if (!lp)
+		return -ENOMEM;
+
+	while (index < hsize) {
+		lp_offset = index & (sdp->sd_hash_ptrs - 1);
+		ht_offset = index - lp_offset;
+
+		if (ht_offset_cur != ht_offset) {
+			error = gfs2_dir_read_data(dip, (char *)lp,
+						ht_offset * sizeof(__be64),
+						sdp->sd_hash_bsize, 1);
+			if (error != sdp->sd_hash_bsize) {
+				if (error >= 0)
+					error = -EIO;
+				goto out;
+			}
+			ht_offset_cur = ht_offset;
+		}
+
+		leaf_no = be64_to_cpu(lp[lp_offset]);
+		if (leaf_no) {
+			error = get_leaf(dip, leaf_no, &bh);
+			if (error)
+				goto out;
+			leaf = (struct gfs2_leaf *)bh->b_data;
+			len = 1 << (dip->i_depth - be16_to_cpu(leaf->lf_depth));
+
+			next_index = (index & ~(len - 1)) + len;
+			last = ((next_index >= hsize) ? 1 : 0);
+			error = leaf_dealloc(dip, index, len, leaf_no, bh,
+					     last);
+			brelse(bh);
+			if (error)
+				goto out;
+			index = next_index;
+		} else
+			index++;
+	}
+
+	if (index != hsize) {
+		gfs2_consist_inode(dip);
+		error = -EIO;
+	}
+
+out:
+	kfree(lp);
+
+	return error;
 }
 
 /**
-- 
1.7.4

