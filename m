Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab2IZI7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:59:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab2IZIva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:30 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/27] GFS2: Remove rs_requested field from reservations
Date: Wed, 26 Sep 2012 09:25:23 +0100
Message-Id: <1348647948-3219-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rs_requested field is left over from the original allocation
code, however this should have been a parameter passed to the
various functions from gfs2_inplace_reserve() and not a member of the
reservation structure as the value is not required after the
initial allocation.

This also helps simplify the code since we no longer need to set
the rs_requested to zero. Also the gfs2_inplace_release()
function can also be simplified since the reservation structure
will always be defined when it is called, and the only remaining
task is to unlock the rgrp if required. It can also now be
called unconditionally too, resulting in a further simplification.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index d652634..00eaa83 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -612,6 +612,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	struct gfs2_sbd *sdp = GFS2_SB(mapping->host);
 	struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
 	unsigned int data_blocks = 0, ind_blocks = 0, rblocks;
+	unsigned requested = 0;
 	int alloc_required;
 	int error = 0;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
@@ -641,7 +642,8 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 		if (error)
 			goto out_unlock;
 
-		error = gfs2_inplace_reserve(ip, data_blocks + ind_blocks);
+		requested = data_blocks + ind_blocks;
+		error = gfs2_inplace_reserve(ip, requested);
 		if (error)
 			goto out_qunlock;
 	}
@@ -654,7 +656,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	if (&ip->i_inode == sdp->sd_rindex)
 		rblocks += 2 * RES_STATFS;
 	if (alloc_required)
-		rblocks += gfs2_rg_blocks(ip);
+		rblocks += gfs2_rg_blocks(ip, requested);
 
 	error = gfs2_trans_begin(sdp, rblocks,
 				 PAGE_CACHE_SIZE/sdp->sd_sb.sb_bsize);
@@ -868,8 +870,7 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 	brelse(dibh);
 failed:
 	gfs2_trans_end(sdp);
-	if (gfs2_mb_reserved(ip))
-		gfs2_inplace_release(ip);
+	gfs2_inplace_release(ip);
 	if (ip->i_res->rs_qa_qd_num)
 		gfs2_quota_unlock(ip);
 	if (inode == sdp->sd_rindex) {
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 382000f..30e2199 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -441,7 +441,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		rblocks += data_blocks ? data_blocks : 1;
 	if (ind_blocks || data_blocks) {
 		rblocks += RES_STATFS + RES_QUOTA;
-		rblocks += gfs2_rg_blocks(ip);
+		rblocks += gfs2_rg_blocks(ip, data_blocks + ind_blocks);
 	}
 	ret = gfs2_trans_begin(sdp, rblocks, 0);
 	if (ret)
@@ -845,7 +845,7 @@ retry:
 				&max_bytes, &data_blocks, &ind_blocks);
 
 		rblocks = RES_DINODE + ind_blocks + RES_STATFS + RES_QUOTA +
-			  RES_RG_HDR + gfs2_rg_blocks(ip);
+			  RES_RG_HDR + gfs2_rg_blocks(ip, data_blocks + ind_blocks);
 		if (gfs2_is_jdata(ip))
 			rblocks += data_blocks ? data_blocks : 1;
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index aaecc80..52078a1 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -250,9 +250,6 @@ struct gfs2_blkreserv {
 	/* components used during write (step 1): */
 	atomic_t rs_sizehint;         /* hint of the write size */
 
-	/* components used during inplace_reserve (step 2): */
-	u32 rs_requested; /* Filled in by caller of gfs2_inplace_reserve() */
-
 	/* components used during get_local_rgrp (step 3): */
 	struct gfs2_rgrpd *rs_rgd;    /* pointer to the gfs2_rgrpd */
 	struct gfs2_holder rs_rgd_gh; /* Filled in by get_local_rgrp */
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 753af3d..f2709ea 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -737,10 +737,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		brelse(bh);
 
 	gfs2_trans_end(sdp);
-	/* Check if we reserved space in the rgrp. Function link_dinode may
-	   not, depending on whether alloc is required. */
-	if (gfs2_mb_reserved(dip))
-		gfs2_inplace_release(dip);
+	gfs2_inplace_release(dip);
 	gfs2_quota_unlock(dip);
 	mark_inode_dirty(inode);
 	gfs2_glock_dq_uninit_m(2, ghs);
@@ -897,7 +894,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 			goto out_gunlock_q;
 
 		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
-					 gfs2_rg_blocks(dip) +
+					 gfs2_rg_blocks(dip, sdp->sd_max_dirres) +
 					 2 * RES_DINODE + RES_STATFS +
 					 RES_QUOTA, 0);
 		if (error)
@@ -1378,7 +1375,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			goto out_gunlock_q;
 
 		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
-					 gfs2_rg_blocks(ndip) +
+					 gfs2_rg_blocks(ndip, sdp->sd_max_dirres) +
 					 4 * RES_DINODE + 4 * RES_LEAF +
 					 RES_STATFS + RES_QUOTA + 4, 0);
 		if (error)
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index a3bde91..420bc38 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -765,6 +765,7 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 	struct gfs2_holder *ghs, i_gh;
 	unsigned int qx, x;
 	struct gfs2_quota_data *qd;
+	unsigned reserved;
 	loff_t offset;
 	unsigned int nalloc = 0, blocks;
 	int error;
@@ -811,13 +812,13 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 	 * two blocks need to be updated instead of 1 */
 	blocks = num_qd * data_blocks + RES_DINODE + num_qd + 3;
 
-	error = gfs2_inplace_reserve(ip, 1 +
-				     (nalloc * (data_blocks + ind_blocks)));
+	reserved = 1 + (nalloc * (data_blocks + ind_blocks));
+	error = gfs2_inplace_reserve(ip, reserved);
 	if (error)
 		goto out_alloc;
 
 	if (nalloc)
-		blocks += gfs2_rg_blocks(ip) + nalloc * ind_blocks + RES_STATFS;
+		blocks += gfs2_rg_blocks(ip, reserved) + nalloc * ind_blocks + RES_STATFS;
 
 	error = gfs2_trans_begin(sdp, blocks, 0);
 	if (error)
@@ -1598,7 +1599,7 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 		error = gfs2_inplace_reserve(ip, blocks);
 		if (error)
 			goto out_i;
-		blocks += gfs2_rg_blocks(ip);
+		blocks += gfs2_rg_blocks(ip, blocks);
 	}
 
 	/* Some quotas span block boundaries and can update two blocks,
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index c9ed814..a2b43bb 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -539,7 +539,6 @@ static void __rs_deltree(struct gfs2_blkreserv *rs)
 	   E.g. We can't set rs_rgd to NULL because the rgd glock is held and
 	   dequeued through this pointer.
 	   Can't: atomic_set(&rs->rs_sizehint, 0);
-	   Can't: rs->rs_requested = 0;
 	   Can't: rs->rs_rgd = NULL;*/
 	rs->rs_bi = NULL;
 	rs->rs_biblk = 0;
@@ -1350,7 +1349,7 @@ static u32 unclaimed_blocks(struct gfs2_rgrpd *rgd)
  * Returns: 0 if successful or BFITNOENT if there isn't enough free space
  */
 
-static int rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip)
+static int rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip, unsigned requested)
 {
 	struct gfs2_bitmap *bi = rgd->rd_bits;
 	const u32 length = rgd->rd_length;
@@ -1422,8 +1421,7 @@ do_search:
 			   what we can. If there's not enough, keep looking. */
 			if (nonzero == NULL)
 				rsv_bytes = search_bytes;
-			else if ((nonzero - ptr) * GFS2_NBBY >=
-				 ip->i_res->rs_requested)
+			else if ((nonzero - ptr) * GFS2_NBBY >= requested)
 				rsv_bytes = (nonzero - ptr);
 
 			if (rsv_bytes) {
@@ -1461,17 +1459,16 @@ skip:
  * Returns: 1 on success (it fits), 0 on failure (it doesn't fit)
  */
 
-static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip)
+static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip,
+			unsigned requested)
 {
-	struct gfs2_blkreserv *rs = ip->i_res;
-
 	if (rgd->rd_flags & (GFS2_RGF_NOALLOC | GFS2_RDF_ERROR))
 		return 0;
 	/* Look for a multi-block reservation. */
 	if (unclaimed_blocks(rgd) >= RGRP_RSRV_MINBLKS &&
-	    rg_mblk_search(rgd, ip) != BFITNOENT)
+	    rg_mblk_search(rgd, ip, requested) != BFITNOENT)
 		return 1;
-	if (unclaimed_blocks(rgd) >= rs->rs_requested)
+	if (unclaimed_blocks(rgd) >= requested)
 		return 1;
 
 	return 0;
@@ -1562,7 +1559,6 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 
 	if (sdp->sd_args.ar_rgrplvb)
 		flags |= GL_SKIP;
-	rs->rs_requested = requested;
 	if (gfs2_assert_warn(sdp, requested)) {
 		error = -EINVAL;
 		goto out;
@@ -1606,7 +1602,7 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 		case 0:
 			if (gfs2_rs_active(rs)) {
 				if (unclaimed_blocks(rs->rs_rgd) +
-				    rs->rs_free >= rs->rs_requested) {
+				    rs->rs_free >= requested) {
 					ip->i_rgd = rs->rs_rgd;
 					return 0;
 				}
@@ -1616,7 +1612,7 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 				   and look for a suitable rgrp. */
 				gfs2_rs_deltree(rs);
 			}
-			if (try_rgrp_fit(rs->rs_rgd, ip)) {
+			if (try_rgrp_fit(rs->rs_rgd, ip, requested)) {
 				if (sdp->sd_args.ar_rgrplvb)
 					gfs2_rgrp_bh_get(rs->rs_rgd);
 				ip->i_rgd = rs->rs_rgd;
@@ -1656,8 +1652,6 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 	error = -ENOSPC;
 
 out:
-	if (error)
-		rs->rs_requested = 0;
 	return error;
 }
 
@@ -1672,15 +1666,8 @@ void gfs2_inplace_release(struct gfs2_inode *ip)
 {
 	struct gfs2_blkreserv *rs = ip->i_res;
 
-	if (!rs)
-		return;
-
-	if (!rs->rs_free)
-		gfs2_rs_deltree(rs);
-
 	if (rs->rs_rgd_gh.gh_gl)
 		gfs2_glock_dq_uninit(&rs->rs_rgd_gh);
-	rs->rs_requested = 0;
 }
 
 /**
@@ -2021,12 +2008,6 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 	int error;
 	struct gfs2_bitmap *bi;
 
-	/* Only happens if there is a bug in gfs2, return something distinctive
-	 * to ensure that it is noticed.
-	 */
-	if (ip->i_res->rs_requested == 0)
-		return -ECANCELED;
-
 	/* If we have a reservation, claim blocks from it. */
 	if (gfs2_rs_active(ip->i_res)) {
 		BUG_ON(!ip->i_res->rs_free);
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index ca6e267..0b0e9cc 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -73,14 +73,6 @@ extern int gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 				   const struct gfs2_bitmap *bi, unsigned minlen, u64 *ptrimmed);
 extern int gfs2_fitrim(struct file *filp, void __user *argp);
 
-/* This is how to tell if a multi-block reservation is "inplace" reserved: */
-static inline int gfs2_mb_reserved(struct gfs2_inode *ip)
-{
-	if (ip->i_res && ip->i_res->rs_requested)
-		return 1;
-	return 0;
-}
-
 /* This is how to tell if a multi-block reservation is in the rgrp tree: */
 static inline int gfs2_rs_active(struct gfs2_blkreserv *rs)
 {
diff --git a/fs/gfs2/trans.h b/fs/gfs2/trans.h
index 41f42cd..bf2ae9a 100644
--- a/fs/gfs2/trans.h
+++ b/fs/gfs2/trans.h
@@ -28,11 +28,10 @@ struct gfs2_glock;
 
 /* reserve either the number of blocks to be allocated plus the rg header
  * block, or all of the blocks in the rg, whichever is smaller */
-static inline unsigned int gfs2_rg_blocks(const struct gfs2_inode *ip)
+static inline unsigned int gfs2_rg_blocks(const struct gfs2_inode *ip, unsigned requested)
 {
-	const struct gfs2_blkreserv *rs = ip->i_res;
-	if (rs && rs->rs_requested < ip->i_rgd->rd_length)
-		return rs->rs_requested + 1;
+	if (requested < ip->i_rgd->rd_length)
+		return requested + 1;
 	return ip->i_rgd->rd_length;
 }
 
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 5404ed1..db330e5 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -739,7 +739,7 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 		goto out_gunlock_q;
 
 	error = gfs2_trans_begin(GFS2_SB(&ip->i_inode),
-				 blks + gfs2_rg_blocks(ip) +
+				 blks + gfs2_rg_blocks(ip, blks) +
 				 RES_DINODE + RES_STATFS + RES_QUOTA, 0);
 	if (error)
 		goto out_ipres;
-- 
1.7.4

