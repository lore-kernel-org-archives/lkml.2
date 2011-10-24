Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab1JXMu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:50:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387Ab1JXMrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:43 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/24] GFS2: Cache the most recently used resource group in the inode
Date: Mon, 24 Oct 2011 13:48:26 +0100
Message-Id: <1319460518-9046-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This means that after the initial allocation for any inode, the
last used resource group is cached in the inode for future use.
This drastically reduces the number of lookups of resource
groups in the common case, and this the contention on that
data structure.

The allocation algorithm is the same as previously, except that we
always check to see if the goal block is within the cached rgrp
first before going to the rbtree to look one up.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 212fe74..4858e1f 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -663,7 +663,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	if (&ip->i_inode == sdp->sd_rindex)
 		rblocks += 2 * RES_STATFS;
 	if (alloc_required)
-		rblocks += gfs2_rg_blocks(al);
+		rblocks += gfs2_rg_blocks(ip);
 
 	error = gfs2_trans_begin(sdp, rblocks,
 				 PAGE_CACHE_SIZE/sdp->sd_sb.sb_bsize);
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index d717b72..3467f36 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -397,7 +397,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		rblocks += data_blocks ? data_blocks : 1;
 	if (ind_blocks || data_blocks) {
 		rblocks += RES_STATFS + RES_QUOTA;
-		rblocks += gfs2_rg_blocks(al);
+		rblocks += gfs2_rg_blocks(ip);
 	}
 	ret = gfs2_trans_begin(sdp, rblocks, 0);
 	if (ret)
@@ -823,7 +823,7 @@ static void calc_max_reserv(struct gfs2_inode *ip, loff_t max, loff_t *len,
 			    unsigned int *data_blocks, unsigned int *ind_blocks)
 {
 	const struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	unsigned int max_blocks = ip->i_alloc->al_rgd->rd_free_clone;
+	unsigned int max_blocks = ip->i_rgd->rd_free_clone;
 	unsigned int tmp, max_data = max_blocks - 3 * (sdp->sd_max_height - 1);
 
 	for (tmp = max_data; tmp > sdp->sd_diptrs;) {
@@ -912,7 +912,7 @@ retry:
 		al->al_requested = data_blocks + ind_blocks;
 
 		rblocks = RES_DINODE + ind_blocks + RES_STATFS + RES_QUOTA +
-			  RES_RG_HDR + gfs2_rg_blocks(al);
+			  RES_RG_HDR + gfs2_rg_blocks(ip);
 		if (gfs2_is_jdata(ip))
 			rblocks += data_blocks ? data_blocks : 1;
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 56847f5..55e335b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -256,8 +256,6 @@ struct gfs2_alloc {
 	unsigned int al_line;
 	char *al_file;
 	struct gfs2_holder al_rgd_gh;
-	struct gfs2_rgrpd *al_rgd;
-
 };
 
 enum {
@@ -279,6 +277,7 @@ struct gfs2_inode {
 	struct gfs2_holder i_iopen_gh;
 	struct gfs2_holder i_gh; /* for prepare/commit_write only */
 	struct gfs2_alloc *i_alloc;
+	struct gfs2_rgrpd *i_rgd;
 	u64 i_goal;	/* goal block for allocations */
 	struct rw_semaphore i_rw_mutex;
 	struct list_head i_trunc_list;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 29703dd..55b3bba 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -583,7 +583,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 			goto fail_quota_locks;
 
 		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
-					 al->al_rgd->rd_length +
+					 dip->i_rgd->rd_length +
 					 2 * RES_DINODE +
 					 RES_STATFS + RES_QUOTA, 0);
 		if (error)
@@ -613,8 +613,7 @@ fail_end_trans:
 	gfs2_trans_end(sdp);
 
 fail_ipreserv:
-	if (dip->i_alloc->al_rgd)
-		gfs2_inplace_release(dip);
+	gfs2_inplace_release(dip);
 
 fail_quota_locks:
 	gfs2_quota_unlock(dip);
@@ -731,8 +730,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		brelse(bh);
 
 	gfs2_trans_end(sdp);
-	if (dip->i_alloc->al_rgd)
-		gfs2_inplace_release(dip);
+	gfs2_inplace_release(dip);
 	gfs2_quota_unlock(dip);
 	gfs2_alloc_put(dip);
 	mark_inode_dirty(inode);
@@ -896,7 +894,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 			goto out_gunlock_q;
 
 		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
-					 gfs2_rg_blocks(al) +
+					 gfs2_rg_blocks(dip) +
 					 2 * RES_DINODE + RES_STATFS +
 					 RES_QUOTA, 0);
 		if (error)
@@ -1371,7 +1369,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			goto out_gunlock_q;
 
 		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
-					 gfs2_rg_blocks(al) +
+					 gfs2_rg_blocks(ndip) +
 					 4 * RES_DINODE + 4 * RES_LEAF +
 					 RES_STATFS + RES_QUOTA + 4, 0);
 		if (error)
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 3a9a974..10a59cd 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -813,7 +813,7 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 		goto out_alloc;
 
 	if (nalloc)
-		blocks += gfs2_rg_blocks(al) + nalloc * ind_blocks + RES_STATFS;
+		blocks += gfs2_rg_blocks(ip) + nalloc * ind_blocks + RES_STATFS;
 
 	error = gfs2_trans_begin(sdp, blocks, 0);
 	if (error)
@@ -1598,7 +1598,7 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 		error = gfs2_inplace_reserve(ip);
 		if (error)
 			goto out_alloc;
-		blocks += gfs2_rg_blocks(al);
+		blocks += gfs2_rg_blocks(ip);
 	}
 
 	/* Some quotas span block boundaries and can update two blocks,
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 88d5b75..5bfb970 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -882,24 +882,21 @@ struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip)
 /**
  * try_rgrp_fit - See if a given reservation will fit in a given RG
  * @rgd: the RG data
- * @al: the struct gfs2_alloc structure describing the reservation
+ * @ip: the inode
  *
  * If there's room for the requested blocks to be allocated from the RG:
- *   Sets the $al_rgd field in @al.
  *
  * Returns: 1 on success (it fits), 0 on failure (it doesn't fit)
  */
 
-static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_alloc *al)
+static int try_rgrp_fit(const struct gfs2_rgrpd *rgd, const struct gfs2_inode *ip)
 {
+	const struct gfs2_alloc *al = ip->i_alloc;
+
 	if (rgd->rd_flags & (GFS2_RGF_NOALLOC | GFS2_RDF_ERROR))
 		return 0;
-
-	if (rgd->rd_free_clone >= al->al_requested) {
-		al->al_rgd = rgd;
+	if (rgd->rd_free_clone >= al->al_requested)
 		return 1;
-	}
-
 	return 0;
 }
 
@@ -985,7 +982,10 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 	int error, rg_locked;
 	int loops = 0;
 
-	rgd = begin = gfs2_blk2rgrpd(sdp, ip->i_goal);
+	if (ip->i_rgd && rgrp_contains_block(ip->i_rgd, ip->i_goal))
+		rgd = begin = ip->i_rgd;
+	else
+		rgd = begin = gfs2_blk2rgrpd(sdp, ip->i_goal);
 
 	if (rgd == NULL)
 		return -EBADSLT;
@@ -1002,8 +1002,10 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 		}
 		switch (error) {
 		case 0:
-			if (try_rgrp_fit(rgd, al))
+			if (try_rgrp_fit(rgd, ip)) {
+				ip->i_rgd = rgd;
 				return 0;
+			}
 			if (rgd->rd_flags & GFS2_RDF_CHECK)
 				try_rgrp_unlink(rgd, last_unlinked, ip->i_no_addr);
 			if (!rg_locked)
@@ -1014,7 +1016,6 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 			if (rgd == begin)
 				loops++;
 			break;
-
 		default:
 			return error;
 		}
@@ -1042,21 +1043,20 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip,
 	if (gfs2_assert_warn(sdp, al->al_requested))
 		return -EINVAL;
 
-try_again:
 	do {
 		error = get_local_rgrp(ip, &last_unlinked);
-		/* If there is no space, flushing the log may release some */
-		if (error) {
-			if (ip == GFS2_I(sdp->sd_rindex) &&
-			    !sdp->sd_rindex_uptodate) {
-				error = gfs2_ri_update(ip);
-				if (error)
-					return error;
-				goto try_again;
-			}
-			gfs2_log_flush(sdp, NULL);
+		if (error != -ENOSPC)
+			break;
+		/* Check that fs hasn't grown if writing to rindex */
+		if (ip == GFS2_I(sdp->sd_rindex) && !sdp->sd_rindex_uptodate) {
+			error = gfs2_ri_update(ip);
+			if (error)
+				break;
+			continue;
 		}
-	} while (error && tries++ < 3);
+		/* Flushing the log may release space */
+		gfs2_log_flush(sdp, NULL);
+	} while (tries++ < 3);
 
 	if (error)
 		return error;
@@ -1086,7 +1086,6 @@ void gfs2_inplace_release(struct gfs2_inode *ip)
 		             al->al_alloced, al->al_requested, al->al_file,
 			     al->al_line);
 
-	al->al_rgd = NULL;
 	if (al->al_rgd_gh.gh_gl)
 		gfs2_glock_dq_uninit(&al->al_rgd_gh);
 }
@@ -1339,7 +1338,7 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n)
 	if (al == NULL)
 		return -ECANCELED;
 
-	rgd = al->al_rgd;
+	rgd = ip->i_rgd;
 
 	if (rgrp_contains_block(rgd, ip->i_goal))
 		goal = ip->i_goal - rgd->rd_data0;
@@ -1398,7 +1397,7 @@ int gfs2_alloc_di(struct gfs2_inode *dip, u64 *bn, u64 *generation)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_alloc *al = dip->i_alloc;
-	struct gfs2_rgrpd *rgd = al->al_rgd;
+	struct gfs2_rgrpd *rgd = dip->i_rgd;
 	u32 blk;
 	u64 block;
 	unsigned int n = 1;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index f716c4f..87e9141 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1574,6 +1574,7 @@ static struct inode *gfs2_alloc_inode(struct super_block *sb)
 	if (ip) {
 		ip->i_flags = 0;
 		ip->i_gl = NULL;
+		ip->i_rgd = NULL;
 	}
 	return &ip->i_inode;
 }
diff --git a/fs/gfs2/trans.h b/fs/gfs2/trans.h
index 980c5c0..f8f101e 100644
--- a/fs/gfs2/trans.h
+++ b/fs/gfs2/trans.h
@@ -28,10 +28,12 @@ struct gfs2_glock;
 
 /* reserve either the number of blocks to be allocated plus the rg header
  * block, or all of the blocks in the rg, whichever is smaller */
-static inline unsigned int gfs2_rg_blocks(const struct gfs2_alloc *al)
+static inline unsigned int gfs2_rg_blocks(const struct gfs2_inode *ip)
 {
-	return (al->al_requested < al->al_rgd->rd_length)?
-	       al->al_requested + 1 : al->al_rgd->rd_length;
+	const struct gfs2_alloc *al = ip->i_alloc;
+	if (al->al_requested < ip->i_rgd->rd_length)
+		return al->al_requested + 1;
+	return ip->i_rgd->rd_length;
 }
 
 extern int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 167f4af..e7bf0ea 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -727,7 +727,7 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 		goto out_gunlock_q;
 
 	error = gfs2_trans_begin(GFS2_SB(&ip->i_inode),
-				 blks + gfs2_rg_blocks(al) +
+				 blks + gfs2_rg_blocks(ip) +
 				 RES_DINODE + RES_STATFS + RES_QUOTA, 0);
 	if (error)
 		goto out_ipres;
-- 
1.7.4.4

