Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab2AEMQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:16:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab2AEMQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:26 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/16] GFS2: move toward a generic multi-block allocator
Date: Thu,  5 Jan 2012 11:51:56 +0000
Message-Id: <1325764322-10807-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch is a revision of the one I previously posted.
I tried to integrate all the suggestions Steve gave.
The purpose of the patch is to change function gfs2_alloc_block
(allocate either a dinode block or an extent of data blocks)
to a more generic gfs2_alloc_blocks function that can
allocate both a dinode _and_ an extent of data blocks in the
same call. This will ultimately help us create a multi-block
reservation scheme to reduce file fragmentation.

This patch moves more toward a generic multi-block allocator that
takes a pointer to the number of data blocks to allocate, plus whether
or not to allocate a dinode. In theory, it could be called to allocate
(1) a single dinode block, (2) a group of one or more data blocks, or
(3) a dinode plus several data blocks.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index b69235b..cb74312 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -133,7 +133,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 		   and write it out to disk */
 
 		unsigned int n = 1;
-		error = gfs2_alloc_block(ip, &block, &n, 0, NULL);
+		error = gfs2_alloc_blocks(ip, &block, &n, 0, NULL);
 		if (error)
 			goto out_brelse;
 		if (isdir) {
@@ -503,7 +503,7 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 	do {
 		int error;
 		n = blks - alloced;
-		error = gfs2_alloc_block(ip, &bn, &n, 0, NULL);
+		error = gfs2_alloc_blocks(ip, &bn, &n, 0, NULL);
 		if (error)
 			return error;
 		alloced += n;
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index ae75319..f8485da 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -823,7 +823,7 @@ static struct gfs2_leaf *new_leaf(struct inode *inode, struct buffer_head **pbh,
 	struct gfs2_dirent *dent;
 	struct qstr name = { .name = "", .len = 0, .hash = 0 };
 
-	error = gfs2_alloc_block(ip, &bn, &n, 0, NULL);
+	error = gfs2_alloc_blocks(ip, &bn, &n, 0, NULL);
 	if (error)
 		return NULL;
 	bh = gfs2_meta_new(ip->i_gl, bn);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index de2668f..3ab192b 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -389,6 +389,7 @@ static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	int error;
+	int dblocks = 0;
 
 	if (gfs2_alloc_get(dip) == NULL)
 		return -ENOMEM;
@@ -402,7 +403,7 @@ static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
 	if (error)
 		goto out_ipreserv;
 
-	error = gfs2_alloc_block(dip, no_addr, NULL, 1, generation);
+	error = gfs2_alloc_blocks(dip, no_addr, &dblocks, 1, generation);
 
 	gfs2_trans_end(sdp);
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 855597a..b8935af 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -65,8 +65,8 @@ static const char valid_change[16] = {
 };
 
 static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
-                        unsigned char old_state, unsigned char new_state,
-			unsigned int *n);
+                        unsigned char old_state, bool dinode,
+			unsigned int *ndata);
 
 /**
  * gfs2_setbit - Set a bit in the bitmaps
@@ -921,8 +921,7 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 	while (goal < rgd->rd_data) {
 		down_write(&sdp->sd_log_flush_lock);
 		n = 1;
-		block = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED,
-				     GFS2_BLKST_UNLINKED, &n);
+		block = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED, 0, &n);
 		up_write(&sdp->sd_log_flush_lock);
 		if (block == BFITNOENT)
 			break;
@@ -1115,7 +1114,7 @@ static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
  * @rgd: the resource group descriptor
  * @goal: the goal block within the RG (start here to search for avail block)
  * @old_state: GFS2_BLKST_XXX the before-allocation state to find
- * @new_state: GFS2_BLKST_XXX the after-allocation block state
+ * @dinode: TRUE if the first block we allocate is for a dinode
  * @n: The extent length
  *
  * Walk rgrp's bitmap to find bits that represent a block in @old_state.
@@ -1132,8 +1131,7 @@ static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
  */
 
 static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
-			unsigned char old_state, unsigned char new_state,
-			unsigned int *n)
+			unsigned char old_state, bool dinode, unsigned int *n)
 {
 	struct gfs2_bitmap *bi = NULL;
 	const u32 length = rgd->rd_length;
@@ -1192,13 +1190,14 @@ skip:
 	if (blk == BFITNOENT)
 		return blk;
 
-	*n = 1;
-	if (old_state == new_state)
+	if (old_state == GFS2_BLKST_UNLINKED)
 		goto out;
 
 	gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
 	gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone, bi->bi_offset,
-		    bi, blk, new_state);
+		    bi, blk, dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
+	if (!dinode)
+		(*n)++;
 	goal = blk;
 	while (*n < elen) {
 		goal++;
@@ -1208,7 +1207,7 @@ skip:
 		    GFS2_BLKST_FREE)
 			break;
 		gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone, bi->bi_offset,
-			    bi, goal, new_state);
+			    bi, goal, GFS2_BLKST_USED);
 		(*n)++;
 	}
 out:
@@ -1300,28 +1299,26 @@ static void gfs2_rgrp_error(struct gfs2_rgrpd *rgd)
 }
 
 /**
- * gfs2_alloc_block - Allocate one or more blocks
+ * gfs2_alloc_blocks - Allocate one or more blocks of data and/or a dinode
  * @ip: the inode to allocate the block for
  * @bn: Used to return the starting block number
- * @n: requested number of blocks/extent length (value/result)
- * dinode: 1 if we're allocating a dinode, 0 if it's a data block
+ * @ndata: requested number of data blocks/extent length (value/result)
+ * @dinode: 1 if we're allocating a dinode block, else 0
  * @generation: the generation number of the inode
  *
  * Returns: 0 or error
  */
 
-int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
-		     int dinode, u64 *generation)
+int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *ndata,
+		      bool dinode, u64 *generation)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head *dibh;
 	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_rgrpd *rgd;
-	u32 goal, blk; /* block, within the rgrp scope */
+	u32 goal, extlen, blk; /* block, within the rgrp scope */
 	u64 block; /* block, within the file system scope */
-	unsigned int extn = 1;
 	int error;
-	unsigned char blk_type = dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED;
 
 	/* Only happens if there is a bug in gfs2, return something distinctive
 	 * to ensure that it is noticed.
@@ -1329,8 +1326,6 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
 	if (al == NULL)
 		return -ECANCELED;
 
-	if (n == NULL)
-		n = &extn;
 	rgd = ip->i_rgd;
 
 	if (!dinode && rgrp_contains_block(rgd, ip->i_goal))
@@ -1338,7 +1333,7 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
 	else
 		goal = rgd->rd_last_alloc;
 
-	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, blk_type, n);
+	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, dinode, ndata);
 
 	/* Since all blocks are reserved in advance, this shouldn't happen */
 	if (blk == BFITNOENT)
@@ -1347,7 +1342,7 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
 	rgd->rd_last_alloc = blk;
 	block = rgd->rd_data0 + blk;
 	if (!dinode) {
-		ip->i_goal = block + *n - 1;
+		ip->i_goal = block + *ndata - 1;
 		error = gfs2_meta_inode_buffer(ip, &dibh);
 		if (error == 0) {
 			struct gfs2_dinode *di =
@@ -1358,10 +1353,13 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
 			brelse(dibh);
 		}
 	}
-	if (rgd->rd_free < *n)
+	extlen = *ndata;
+	if (dinode)
+		extlen++;
+	if (rgd->rd_free < extlen)
 		goto rgrp_error;
 
-	rgd->rd_free -= *n;
+	rgd->rd_free -= extlen;
 	if (dinode) {
 		rgd->rd_dinodes++;
 		*generation = rgd->rd_igeneration++;
@@ -1372,15 +1370,16 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
-	gfs2_statfs_change(sdp, 0, -(s64)*n, dinode ? 1 : 0);
+	gfs2_statfs_change(sdp, 0, -(s64)extlen, dinode ? 1 : 0);
 	if (dinode)
 		gfs2_trans_add_unrevoke(sdp, block, 1);
-	else
-		gfs2_quota_change(ip, *n, ip->i_inode.i_uid,
+	if (*ndata)
+		gfs2_quota_change(ip, *ndata, ip->i_inode.i_uid,
 				  ip->i_inode.i_gid);
 
-	rgd->rd_free_clone -= *n;
-	trace_gfs2_block_alloc(ip, block, *n, blk_type);
+	rgd->rd_free_clone -= extlen;
+	trace_gfs2_block_alloc(ip, block, *ndata,
+			       dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
 	*bn = block;
 	return 0;
 
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 4cb5608..b3b61b8 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -39,8 +39,8 @@ static inline void gfs2_alloc_put(struct gfs2_inode *ip)
 extern int gfs2_inplace_reserve(struct gfs2_inode *ip);
 extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
-extern int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
-			    int dinode, u64 *generation);
+extern int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
+			     bool dinode, u64 *generation);
 
 extern void __gfs2_free_blocks(struct gfs2_inode *ip, u64 bstart, u32 blen, int meta);
 extern void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index e4794a5..ef74e159 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -610,7 +610,7 @@ static int ea_alloc_blk(struct gfs2_inode *ip, struct buffer_head **bhp)
 	u64 block;
 	int error;
 
-	error = gfs2_alloc_block(ip, &block, &n, 0, NULL);
+	error = gfs2_alloc_blocks(ip, &block, &n, 0, NULL);
 	if (error)
 		return error;
 	gfs2_trans_add_unrevoke(sdp, block, 1);
@@ -672,7 +672,7 @@ static int ea_write(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 			int mh_size = sizeof(struct gfs2_meta_header);
 			unsigned int n = 1;
 
-			error = gfs2_alloc_block(ip, &block, &n, 0, NULL);
+			error = gfs2_alloc_blocks(ip, &block, &n, 0, NULL);
 			if (error)
 				return error;
 			gfs2_trans_add_unrevoke(sdp, block, 1);
@@ -992,7 +992,7 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	} else {
 		u64 blk;
 		unsigned int n = 1;
-		error = gfs2_alloc_block(ip, &blk, &n, 0, NULL);
+		error = gfs2_alloc_blocks(ip, &blk, &n, 0, NULL);
 		if (error)
 			return error;
 		gfs2_trans_add_unrevoke(sdp, blk, 1);
-- 
1.7.4

