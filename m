Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab2AEMS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:18:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717Ab2AEMQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:22 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/16] GFS2: combine gfs2_alloc_block and gfs2_alloc_di
Date: Thu,  5 Jan 2012 11:51:53 +0000
Message-Id: <1325764322-10807-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

GFS2 functions gfs2_alloc_block and gfs2_alloc_di do basically
the same things, with a few exceptions. This patch combines
the two functions into a slightly more generic gfs2_alloc_block.
Having one centralized block allocation function will reduce
code redundancy and make it easier to implement multi-block
reservations to reduce file fragmentation in the future.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index f6be14f..b69235b 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -133,7 +133,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 		   and write it out to disk */
 
 		unsigned int n = 1;
-		error = gfs2_alloc_block(ip, &block, &n);
+		error = gfs2_alloc_block(ip, &block, &n, 0, NULL);
 		if (error)
 			goto out_brelse;
 		if (isdir) {
@@ -503,7 +503,7 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 	do {
 		int error;
 		n = blks - alloced;
-		error = gfs2_alloc_block(ip, &bn, &n);
+		error = gfs2_alloc_block(ip, &bn, &n, 0, NULL);
 		if (error)
 			return error;
 		alloced += n;
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 946b6f8..ae75319 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -823,7 +823,7 @@ static struct gfs2_leaf *new_leaf(struct inode *inode, struct buffer_head **pbh,
 	struct gfs2_dirent *dent;
 	struct qstr name = { .name = "", .len = 0, .hash = 0 };
 
-	error = gfs2_alloc_block(ip, &bn, &n);
+	error = gfs2_alloc_block(ip, &bn, &n, 0, NULL);
 	if (error)
 		return NULL;
 	bh = gfs2_meta_new(ip->i_gl, bn);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 377920d..de2668f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -402,7 +402,7 @@ static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
 	if (error)
 		goto out_ipreserv;
 
-	error = gfs2_alloc_di(dip, no_addr, generation);
+	error = gfs2_alloc_block(dip, no_addr, NULL, 1, generation);
 
 	gfs2_trans_end(sdp);
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index a1a815b..995f4e6 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1304,19 +1304,24 @@ static void gfs2_rgrp_error(struct gfs2_rgrpd *rgd)
  * @ip: the inode to allocate the block for
  * @bn: Used to return the starting block number
  * @n: requested number of blocks/extent length (value/result)
+ * dinode: 1 if we're allocating a dinode, 0 if it's a data block
+ * @generation: the generation number of the inode
  *
  * Returns: 0 or error
  */
 
-int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n)
+int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
+		     int dinode, u64 *generation)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head *dibh;
 	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_rgrpd *rgd;
-	u32 goal, blk;
-	u64 block;
+	u32 goal, blk; /* block, within the rgrp scope */
+	u64 block; /* block, within the file system scope */
+	unsigned int extn = 1;
 	int error;
+	unsigned char blk_type = dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED;
 
 	/* Only happens if there is a bug in gfs2, return something distinctive
 	 * to ensure that it is noticed.
@@ -1324,14 +1329,16 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n)
 	if (al == NULL)
 		return -ECANCELED;
 
+	if (n == NULL)
+		n = &extn;
 	rgd = ip->i_rgd;
 
-	if (rgrp_contains_block(rgd, ip->i_goal))
+	if (!dinode && rgrp_contains_block(rgd, ip->i_goal))
 		goal = ip->i_goal - rgd->rd_data0;
 	else
 		goal = rgd->rd_last_alloc;
 
-	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, GFS2_BLKST_USED, n);
+	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, blk_type, n);
 
 	/* Since all blocks are reserved in advance, this shouldn't happen */
 	if (blk == BFITNOENT)
@@ -1339,82 +1346,43 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n)
 
 	rgd->rd_last_alloc = blk;
 	block = rgd->rd_data0 + blk;
-	ip->i_goal = block + *n - 1;
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error == 0) {
-		struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
-		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-		di->di_goal_meta = di->di_goal_data = cpu_to_be64(ip->i_goal);
-		brelse(dibh);
+	if (!dinode) {
+		ip->i_goal = block + *n - 1;
+		error = gfs2_meta_inode_buffer(ip, &dibh);
+		if (error == 0) {
+			struct gfs2_dinode *di =
+				(struct gfs2_dinode *)dibh->b_data;
+			gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+			di->di_goal_meta = di->di_goal_data =
+				cpu_to_be64(ip->i_goal);
+			brelse(dibh);
+		}
 	}
 	if (rgd->rd_free < *n)
 		goto rgrp_error;
 
 	rgd->rd_free -= *n;
+	if (dinode) {
+		rgd->rd_dinodes++;
+		*generation = rgd->rd_igeneration++;
+		if (*generation == 0)
+			*generation = rgd->rd_igeneration++;
+	}
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
 	al->al_alloced += *n;
 
-	gfs2_statfs_change(sdp, 0, -(s64)*n, 0);
-	gfs2_quota_change(ip, *n, ip->i_inode.i_uid, ip->i_inode.i_gid);
+	gfs2_statfs_change(sdp, 0, -(s64)*n, dinode ? 1 : 0);
+	if (dinode)
+		gfs2_trans_add_unrevoke(sdp, block, 1);
+	else
+		gfs2_quota_change(ip, *n, ip->i_inode.i_uid,
+				  ip->i_inode.i_gid);
 
 	rgd->rd_free_clone -= *n;
-	trace_gfs2_block_alloc(ip, block, *n, GFS2_BLKST_USED);
-	*bn = block;
-	return 0;
-
-rgrp_error:
-	gfs2_rgrp_error(rgd);
-	return -EIO;
-}
-
-/**
- * gfs2_alloc_di - Allocate a dinode
- * @dip: the directory that the inode is going in
- * @bn: the block number which is allocated
- * @generation: the generation number of the inode
- *
- * Returns: 0 on success or error
- */
-
-int gfs2_alloc_di(struct gfs2_inode *dip, u64 *bn, u64 *generation)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	struct gfs2_alloc *al = dip->i_alloc;
-	struct gfs2_rgrpd *rgd = dip->i_rgd;
-	u32 blk;
-	u64 block;
-	unsigned int n = 1;
-
-	blk = rgblk_search(rgd, rgd->rd_last_alloc,
-			   GFS2_BLKST_FREE, GFS2_BLKST_DINODE, &n);
-
-	/* Since all blocks are reserved in advance, this shouldn't happen */
-	if (blk == BFITNOENT)
-		goto rgrp_error;
-
-	rgd->rd_last_alloc = blk;
-	block = rgd->rd_data0 + blk;
-	if (rgd->rd_free == 0)
-		goto rgrp_error;
-
-	rgd->rd_free--;
-	rgd->rd_dinodes++;
-	*generation = rgd->rd_igeneration++;
-	if (*generation == 0)
-		*generation = rgd->rd_igeneration++;
-	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
-	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
-
-	al->al_alloced++;
-
-	gfs2_statfs_change(sdp, 0, -1, +1);
-	gfs2_trans_add_unrevoke(sdp, block, 1);
-
-	rgd->rd_free_clone--;
-	trace_gfs2_block_alloc(dip, block, 1, GFS2_BLKST_DINODE);
+	trace_gfs2_block_alloc(ip, block, *n, blk_type);
 	*bn = block;
 	return 0;
 
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index cf5c501..4cb5608 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -39,8 +39,8 @@ static inline void gfs2_alloc_put(struct gfs2_inode *ip)
 extern int gfs2_inplace_reserve(struct gfs2_inode *ip);
 extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
-extern int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n);
-extern int gfs2_alloc_di(struct gfs2_inode *ip, u64 *bn, u64 *generation);
+extern int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
+			    int dinode, u64 *generation);
 
 extern void __gfs2_free_blocks(struct gfs2_inode *ip, u64 bstart, u32 blen, int meta);
 extern void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index a201a1d..e4794a5 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -610,7 +610,7 @@ static int ea_alloc_blk(struct gfs2_inode *ip, struct buffer_head **bhp)
 	u64 block;
 	int error;
 
-	error = gfs2_alloc_block(ip, &block, &n);
+	error = gfs2_alloc_block(ip, &block, &n, 0, NULL);
 	if (error)
 		return error;
 	gfs2_trans_add_unrevoke(sdp, block, 1);
@@ -672,7 +672,7 @@ static int ea_write(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 			int mh_size = sizeof(struct gfs2_meta_header);
 			unsigned int n = 1;
 
-			error = gfs2_alloc_block(ip, &block, &n);
+			error = gfs2_alloc_block(ip, &block, &n, 0, NULL);
 			if (error)
 				return error;
 			gfs2_trans_add_unrevoke(sdp, block, 1);
@@ -992,7 +992,7 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	} else {
 		u64 blk;
 		unsigned int n = 1;
-		error = gfs2_alloc_block(ip, &blk, &n);
+		error = gfs2_alloc_block(ip, &blk, &n, 0, NULL);
 		if (error)
 			return error;
 		gfs2_trans_add_unrevoke(sdp, blk, 1);
-- 
1.7.4

