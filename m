Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab2AEMQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:16:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab2AEMQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:33 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/16] GFS2: decouple quota allocations from block allocations
Date: Thu,  5 Jan 2012 11:51:59 +0000
Message-Id: <1325764322-10807-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch separates the code pertaining to allocations into two
parts: quota-related information and block reservations.
This patch also moves all the block reservation structure allocations to
function gfs2_inplace_reserve to simplify the code, and moves
the frees to function gfs2_inplace_release.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 4858e1f..501e5cb 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -615,7 +615,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	unsigned int data_blocks = 0, ind_blocks = 0, rblocks;
 	int alloc_required;
 	int error = 0;
-	struct gfs2_alloc *al = NULL;
+	struct gfs2_qadata *qa = NULL;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
 	struct page *page;
@@ -639,8 +639,8 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 		gfs2_write_calc_reserv(ip, len, &data_blocks, &ind_blocks);
 
 	if (alloc_required) {
-		al = gfs2_alloc_get(ip);
-		if (!al) {
+		qa = gfs2_qadata_get(ip);
+		if (!qa) {
 			error = -ENOMEM;
 			goto out_unlock;
 		}
@@ -649,8 +649,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 		if (error)
 			goto out_alloc_put;
 
-		al->al_requested = data_blocks + ind_blocks;
-		error = gfs2_inplace_reserve(ip);
+		error = gfs2_inplace_reserve(ip, data_blocks + ind_blocks);
 		if (error)
 			goto out_qunlock;
 	}
@@ -711,7 +710,7 @@ out_trans_fail:
 out_qunlock:
 		gfs2_quota_unlock(ip);
 out_alloc_put:
-		gfs2_alloc_put(ip);
+		gfs2_qadata_put(ip);
 	}
 out_unlock:
 	if (&ip->i_inode == sdp->sd_rindex) {
@@ -848,7 +847,7 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
 	struct buffer_head *dibh;
-	struct gfs2_alloc *al = ip->i_alloc;
+	struct gfs2_qadata *qa = ip->i_qadata;
 	unsigned int from = pos & (PAGE_CACHE_SIZE - 1);
 	unsigned int to = from + len;
 	int ret;
@@ -880,10 +879,11 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 	brelse(dibh);
 failed:
 	gfs2_trans_end(sdp);
-	if (al) {
+	if (ip->i_res)
 		gfs2_inplace_release(ip);
+	if (qa) {
 		gfs2_quota_unlock(ip);
-		gfs2_alloc_put(ip);
+		gfs2_qadata_put(ip);
 	}
 	if (inode == sdp->sd_rindex) {
 		gfs2_glock_dq(&m_ip->i_gh);
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index cb74312..14a7040 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1041,7 +1041,7 @@ static int trunc_dealloc(struct gfs2_inode *ip, u64 size)
 		lblock = (size - 1) >> sdp->sd_sb.sb_bsize_shift;
 
 	find_metapath(sdp, lblock, &mp, ip->i_height);
-	if (!gfs2_alloc_get(ip))
+	if (!gfs2_qadata_get(ip))
 		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
@@ -1061,7 +1061,7 @@ static int trunc_dealloc(struct gfs2_inode *ip, u64 size)
 	gfs2_quota_unhold(ip);
 
 out:
-	gfs2_alloc_put(ip);
+	gfs2_qadata_put(ip);
 	return error;
 }
 
@@ -1163,21 +1163,20 @@ static int do_grow(struct inode *inode, u64 size)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct buffer_head *dibh;
-	struct gfs2_alloc *al = NULL;
+	struct gfs2_qadata *qa = NULL;
 	int error;
 
 	if (gfs2_is_stuffed(ip) &&
 	    (size > (sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)))) {
-		al = gfs2_alloc_get(ip);
-		if (al == NULL)
+		qa = gfs2_qadata_get(ip);
+		if (qa == NULL)
 			return -ENOMEM;
 
 		error = gfs2_quota_lock_check(ip);
 		if (error)
 			goto do_grow_alloc_put;
 
-		al->al_requested = 1;
-		error = gfs2_inplace_reserve(ip);
+		error = gfs2_inplace_reserve(ip, 1);
 		if (error)
 			goto do_grow_qunlock;
 	}
@@ -1186,7 +1185,7 @@ static int do_grow(struct inode *inode, u64 size)
 	if (error)
 		goto do_grow_release;
 
-	if (al) {
+	if (qa) {
 		error = gfs2_unstuff_dinode(ip, NULL);
 		if (error)
 			goto do_end_trans;
@@ -1205,12 +1204,12 @@ static int do_grow(struct inode *inode, u64 size)
 do_end_trans:
 	gfs2_trans_end(sdp);
 do_grow_release:
-	if (al) {
+	if (qa) {
 		gfs2_inplace_release(ip);
 do_grow_qunlock:
 		gfs2_quota_unlock(ip);
 do_grow_alloc_put:
-		gfs2_alloc_put(ip);
+		gfs2_qadata_put(ip);
 	}
 	return error;
 }
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index f8485da..c35573a 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1850,7 +1850,7 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 	if (!ht)
 		return -ENOMEM;
 
-	if (!gfs2_alloc_get(dip)) {
+	if (!gfs2_qadata_get(dip)) {
 		error = -ENOMEM;
 		goto out;
 	}
@@ -1939,7 +1939,7 @@ out_rlist:
 	gfs2_rlist_free(&rlist);
 	gfs2_quota_unhold(dip);
 out_put:
-	gfs2_alloc_put(dip);
+	gfs2_qadata_put(dip);
 out:
 	kfree(ht);
 	return error;
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 9b6c6ac..42ceb23 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -365,7 +365,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	u64 pos = page->index << PAGE_CACHE_SHIFT;
 	unsigned int data_blocks, ind_blocks, rblocks;
 	struct gfs2_holder gh;
-	struct gfs2_alloc *al;
+	struct gfs2_qadata *qa;
 	loff_t size;
 	int ret;
 
@@ -393,16 +393,15 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	}
 
 	ret = -ENOMEM;
-	al = gfs2_alloc_get(ip);
-	if (al == NULL)
+	qa = gfs2_qadata_get(ip);
+	if (qa == NULL)
 		goto out_unlock;
 
 	ret = gfs2_quota_lock_check(ip);
 	if (ret)
 		goto out_alloc_put;
 	gfs2_write_calc_reserv(ip, PAGE_CACHE_SIZE, &data_blocks, &ind_blocks);
-	al->al_requested = data_blocks + ind_blocks;
-	ret = gfs2_inplace_reserve(ip);
+	ret = gfs2_inplace_reserve(ip, data_blocks + ind_blocks);
 	if (ret)
 		goto out_quota_unlock;
 
@@ -448,7 +447,7 @@ out_trans_fail:
 out_quota_unlock:
 	gfs2_quota_unlock(ip);
 out_alloc_put:
-	gfs2_alloc_put(ip);
+	gfs2_qadata_put(ip);
 out_unlock:
 	gfs2_glock_dq(&gh);
 out:
@@ -750,7 +749,7 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	unsigned int data_blocks = 0, ind_blocks = 0, rblocks;
 	loff_t bytes, max_bytes;
-	struct gfs2_alloc *al;
+	struct gfs2_qadata *qa;
 	int error;
 	const loff_t pos = offset;
 	const loff_t count = len;
@@ -784,8 +783,8 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	while (len > 0) {
 		if (len < bytes)
 			bytes = len;
-		al = gfs2_alloc_get(ip);
-		if (!al) {
+		qa = gfs2_qadata_get(ip);
+		if (!qa) {
 			error = -ENOMEM;
 			goto out_unlock;
 		}
@@ -797,8 +796,7 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 retry:
 		gfs2_write_calc_reserv(ip, bytes, &data_blocks, &ind_blocks);
 
-		al->al_requested = data_blocks + ind_blocks;
-		error = gfs2_inplace_reserve(ip);
+		error = gfs2_inplace_reserve(ip, data_blocks + ind_blocks);
 		if (error) {
 			if (error == -ENOSPC && bytes > sdp->sd_sb.sb_bsize) {
 				bytes >>= 1;
@@ -812,7 +810,6 @@ retry:
 		max_bytes = bytes;
 		calc_max_reserv(ip, (len > max_chunk_size)? max_chunk_size: len,
 				&max_bytes, &data_blocks, &ind_blocks);
-		al->al_requested = data_blocks + ind_blocks;
 
 		rblocks = RES_DINODE + ind_blocks + RES_STATFS + RES_QUOTA +
 			  RES_RG_HDR + gfs2_rg_blocks(ip);
@@ -834,7 +831,7 @@ retry:
 		offset += max_bytes;
 		gfs2_inplace_release(ip);
 		gfs2_quota_unlock(ip);
-		gfs2_alloc_put(ip);
+		gfs2_qadata_put(ip);
 	}
 
 	if (error == 0)
@@ -846,7 +843,7 @@ out_trans_fail:
 out_qunlock:
 	gfs2_quota_unlock(ip);
 out_alloc_put:
-	gfs2_alloc_put(ip);
+	gfs2_qadata_put(ip);
 out_unlock:
 	gfs2_glock_dq(&ip->i_gh);
 out_uninit:
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 32f5bec..e1d3bb5 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -244,16 +244,16 @@ struct gfs2_glock {
 
 #define GFS2_MIN_LVB_SIZE 32	/* Min size of LVB that gfs2 supports */
 
-struct gfs2_alloc {
+struct gfs2_qadata { /* quota allocation data */
 	/* Quota stuff */
-	struct gfs2_quota_data *al_qd[2*MAXQUOTAS];
-	struct gfs2_holder al_qd_ghs[2*MAXQUOTAS];
-	unsigned int al_qd_num;
-
-	u32 al_requested; /* Filled in by caller of gfs2_inplace_reserve() */
+	struct gfs2_quota_data *qa_qd[2*MAXQUOTAS];
+	struct gfs2_holder qa_qd_ghs[2*MAXQUOTAS];
+	unsigned int qa_qd_num;
+};
 
-	/* Filled in by gfs2_inplace_reserve() */
-	struct gfs2_holder al_rgd_gh;
+struct gfs2_blkreserv {
+	u32 rs_requested; /* Filled in by caller of gfs2_inplace_reserve() */
+	struct gfs2_holder rs_rgd_gh; /* Filled in by gfs2_inplace_reserve() */
 };
 
 enum {
@@ -274,7 +274,8 @@ struct gfs2_inode {
 	struct gfs2_glock *i_gl; /* Move into i_gh? */
 	struct gfs2_holder i_iopen_gh;
 	struct gfs2_holder i_gh; /* for prepare/commit_write only */
-	struct gfs2_alloc *i_alloc;
+	struct gfs2_qadata *i_qadata; /* quota allocation data */
+	struct gfs2_blkreserv *i_res; /* resource group block reservation */
 	struct gfs2_rgrpd *i_rgd;
 	u64 i_goal;	/* goal block for allocations */
 	struct rw_semaphore i_rw_mutex;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 3ab192b..ab8c429 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -391,11 +391,11 @@ static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
 	int error;
 	int dblocks = 0;
 
-	if (gfs2_alloc_get(dip) == NULL)
-		return -ENOMEM;
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		fs_warn(sdp, "rindex update returns %d\n", error);
 
-	dip->i_alloc->al_requested = RES_DINODE;
-	error = gfs2_inplace_reserve(dip);
+	error = gfs2_inplace_reserve(dip, RES_DINODE);
 	if (error)
 		goto out;
 
@@ -410,7 +410,6 @@ static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
 out_ipreserv:
 	gfs2_inplace_release(dip);
 out:
-	gfs2_alloc_put(dip);
 	return error;
 }
 
@@ -526,7 +525,7 @@ static int make_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	int error;
 
 	munge_mode_uid_gid(dip, &mode, &uid, &gid);
-	if (!gfs2_alloc_get(dip))
+	if (!gfs2_qadata_get(dip))
 		return -ENOMEM;
 
 	error = gfs2_quota_lock(dip, uid, gid);
@@ -548,7 +547,7 @@ static int make_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 out_quota:
 	gfs2_quota_unlock(dip);
 out:
-	gfs2_alloc_put(dip);
+	gfs2_qadata_put(dip);
 	return error;
 }
 
@@ -556,13 +555,13 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 		       struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	struct gfs2_alloc *al;
+	struct gfs2_qadata *qa;
 	int alloc_required;
 	struct buffer_head *dibh;
 	int error;
 
-	al = gfs2_alloc_get(dip);
-	if (!al)
+	qa = gfs2_qadata_get(dip);
+	if (!qa)
 		return -ENOMEM;
 
 	error = gfs2_quota_lock(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
@@ -577,9 +576,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 		if (error)
 			goto fail_quota_locks;
 
-		al->al_requested = sdp->sd_max_dirres;
-
-		error = gfs2_inplace_reserve(dip);
+		error = gfs2_inplace_reserve(dip, sdp->sd_max_dirres);
 		if (error)
 			goto fail_quota_locks;
 
@@ -620,7 +617,7 @@ fail_quota_locks:
 	gfs2_quota_unlock(dip);
 
 fail:
-	gfs2_alloc_put(dip);
+	gfs2_qadata_put(dip);
 	return error;
 }
 
@@ -729,9 +726,12 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		brelse(bh);
 
 	gfs2_trans_end(sdp);
-	gfs2_inplace_release(dip);
+	/* Check if we reserved space in the rgrp. Function link_dinode may
+	   not, depending on whether alloc is required. */
+	if (dip->i_res)
+		gfs2_inplace_release(dip);
 	gfs2_quota_unlock(dip);
-	gfs2_alloc_put(dip);
+	gfs2_qadata_put(dip);
 	mark_inode_dirty(inode);
 	gfs2_glock_dq_uninit_m(2, ghs);
 	d_instantiate(dentry, inode);
@@ -876,8 +876,9 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	error = 0;
 
 	if (alloc_required) {
-		struct gfs2_alloc *al = gfs2_alloc_get(dip);
-		if (!al) {
+		struct gfs2_qadata *qa = gfs2_qadata_get(dip);
+
+		if (!qa) {
 			error = -ENOMEM;
 			goto out_gunlock;
 		}
@@ -886,9 +887,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 		if (error)
 			goto out_alloc;
 
-		al->al_requested = sdp->sd_max_dirres;
-
-		error = gfs2_inplace_reserve(dip);
+		error = gfs2_inplace_reserve(dip, sdp->sd_max_dirres);
 		if (error)
 			goto out_gunlock_q;
 
@@ -931,7 +930,7 @@ out_gunlock_q:
 		gfs2_quota_unlock(dip);
 out_alloc:
 	if (alloc_required)
-		gfs2_alloc_put(dip);
+		gfs2_qadata_put(dip);
 out_gunlock:
 	gfs2_glock_dq(ghs + 1);
 out_child:
@@ -1354,8 +1353,9 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	error = 0;
 
 	if (alloc_required) {
-		struct gfs2_alloc *al = gfs2_alloc_get(ndip);
-		if (!al) {
+		struct gfs2_qadata *qa = gfs2_qadata_get(ndip);
+
+		if (!qa) {
 			error = -ENOMEM;
 			goto out_gunlock;
 		}
@@ -1364,9 +1364,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		if (error)
 			goto out_alloc;
 
-		al->al_requested = sdp->sd_max_dirres;
-
-		error = gfs2_inplace_reserve(ndip);
+		error = gfs2_inplace_reserve(ndip, sdp->sd_max_dirres);
 		if (error)
 			goto out_gunlock_q;
 
@@ -1427,7 +1425,7 @@ out_gunlock_q:
 		gfs2_quota_unlock(ndip);
 out_alloc:
 	if (alloc_required)
-		gfs2_alloc_put(ndip);
+		gfs2_qadata_put(ndip);
 out_gunlock:
 	while (x--) {
 		gfs2_glock_dq(ghs + x);
@@ -1588,7 +1586,7 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	if (!(attr->ia_valid & ATTR_GID) || ogid == ngid)
 		ogid = ngid = NO_QUOTA_CHANGE;
 
-	if (!gfs2_alloc_get(ip))
+	if (!gfs2_qadata_get(ip))
 		return -ENOMEM;
 
 	error = gfs2_quota_lock(ip, nuid, ngid);
@@ -1620,7 +1618,7 @@ out_end_trans:
 out_gunlock_q:
 	gfs2_quota_unlock(ip);
 out_alloc:
-	gfs2_alloc_put(ip);
+	gfs2_qadata_put(ip);
 	return error;
 }
 
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 8a139ff..c150298 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -40,7 +40,8 @@ static void gfs2_init_inode_once(void *foo)
 	inode_init_once(&ip->i_inode);
 	init_rwsem(&ip->i_rw_mutex);
 	INIT_LIST_HEAD(&ip->i_trunc_list);
-	ip->i_alloc = NULL;
+	ip->i_qadata = NULL;
+	ip->i_res = NULL;
 	ip->i_hash_cache = NULL;
 }
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index d1962b2..98a01db 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -494,11 +494,11 @@ static void qdsb_put(struct gfs2_quota_data *qd)
 int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = ip->i_alloc;
-	struct gfs2_quota_data **qd = al->al_qd;
+	struct gfs2_qadata *qa = ip->i_qadata;
+	struct gfs2_quota_data **qd = qa->qa_qd;
 	int error;
 
-	if (gfs2_assert_warn(sdp, !al->al_qd_num) ||
+	if (gfs2_assert_warn(sdp, !qa->qa_qd_num) ||
 	    gfs2_assert_warn(sdp, !test_bit(GIF_QD_LOCKED, &ip->i_flags)))
 		return -EIO;
 
@@ -508,20 +508,20 @@ int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
 	error = qdsb_get(sdp, QUOTA_USER, ip->i_inode.i_uid, qd);
 	if (error)
 		goto out;
-	al->al_qd_num++;
+	qa->qa_qd_num++;
 	qd++;
 
 	error = qdsb_get(sdp, QUOTA_GROUP, ip->i_inode.i_gid, qd);
 	if (error)
 		goto out;
-	al->al_qd_num++;
+	qa->qa_qd_num++;
 	qd++;
 
 	if (uid != NO_QUOTA_CHANGE && uid != ip->i_inode.i_uid) {
 		error = qdsb_get(sdp, QUOTA_USER, uid, qd);
 		if (error)
 			goto out;
-		al->al_qd_num++;
+		qa->qa_qd_num++;
 		qd++;
 	}
 
@@ -529,7 +529,7 @@ int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
 		error = qdsb_get(sdp, QUOTA_GROUP, gid, qd);
 		if (error)
 			goto out;
-		al->al_qd_num++;
+		qa->qa_qd_num++;
 		qd++;
 	}
 
@@ -542,16 +542,16 @@ out:
 void gfs2_quota_unhold(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = ip->i_alloc;
+	struct gfs2_qadata *qa = ip->i_qadata;
 	unsigned int x;
 
 	gfs2_assert_warn(sdp, !test_bit(GIF_QD_LOCKED, &ip->i_flags));
 
-	for (x = 0; x < al->al_qd_num; x++) {
-		qdsb_put(al->al_qd[x]);
-		al->al_qd[x] = NULL;
+	for (x = 0; x < qa->qa_qd_num; x++) {
+		qdsb_put(qa->qa_qd[x]);
+		qa->qa_qd[x] = NULL;
 	}
-	al->al_qd_num = 0;
+	qa->qa_qd_num = 0;
 }
 
 static int sort_qd(const void *a, const void *b)
@@ -762,7 +762,6 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 	struct gfs2_quota_data *qd;
 	loff_t offset;
 	unsigned int nalloc = 0, blocks;
-	struct gfs2_alloc *al = NULL;
 	int error;
 
 	gfs2_write_calc_reserv(ip, sizeof(struct gfs2_quota),
@@ -792,26 +791,19 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 			nalloc++;
 	}
 
-	al = gfs2_alloc_get(ip);
-	if (!al) {
-		error = -ENOMEM;
-		goto out_gunlock;
-	}
 	/* 
 	 * 1 blk for unstuffing inode if stuffed. We add this extra
 	 * block to the reservation unconditionally. If the inode
 	 * doesn't need unstuffing, the block will be released to the 
 	 * rgrp since it won't be allocated during the transaction
 	 */
-	al->al_requested = 1;
 	/* +3 in the end for unstuffing block, inode size update block
 	 * and another block in case quota straddles page boundary and 
 	 * two blocks need to be updated instead of 1 */
 	blocks = num_qd * data_blocks + RES_DINODE + num_qd + 3;
 
-	if (nalloc)
-		al->al_requested += nalloc * (data_blocks + ind_blocks);		
-	error = gfs2_inplace_reserve(ip);
+	error = gfs2_inplace_reserve(ip, 1 +
+				     (nalloc * (data_blocks + ind_blocks)));
 	if (error)
 		goto out_alloc;
 
@@ -840,8 +832,6 @@ out_end_trans:
 out_ipres:
 	gfs2_inplace_release(ip);
 out_alloc:
-	gfs2_alloc_put(ip);
-out_gunlock:
 	gfs2_glock_dq_uninit(&i_gh);
 out:
 	while (qx--)
@@ -925,7 +915,7 @@ fail:
 int gfs2_quota_lock(struct gfs2_inode *ip, u32 uid, u32 gid)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = ip->i_alloc;
+	struct gfs2_qadata *qa = ip->i_qadata;
 	struct gfs2_quota_data *qd;
 	unsigned int x;
 	int error = 0;
@@ -938,15 +928,15 @@ int gfs2_quota_lock(struct gfs2_inode *ip, u32 uid, u32 gid)
 	    sdp->sd_args.ar_quota != GFS2_QUOTA_ON)
 		return 0;
 
-	sort(al->al_qd, al->al_qd_num, sizeof(struct gfs2_quota_data *),
+	sort(qa->qa_qd, qa->qa_qd_num, sizeof(struct gfs2_quota_data *),
 	     sort_qd, NULL);
 
-	for (x = 0; x < al->al_qd_num; x++) {
+	for (x = 0; x < qa->qa_qd_num; x++) {
 		int force = NO_FORCE;
-		qd = al->al_qd[x];
+		qd = qa->qa_qd[x];
 		if (test_and_clear_bit(QDF_REFRESH, &qd->qd_flags))
 			force = FORCE;
-		error = do_glock(qd, force, &al->al_qd_ghs[x]);
+		error = do_glock(qd, force, &qa->qa_qd_ghs[x]);
 		if (error)
 			break;
 	}
@@ -955,7 +945,7 @@ int gfs2_quota_lock(struct gfs2_inode *ip, u32 uid, u32 gid)
 		set_bit(GIF_QD_LOCKED, &ip->i_flags);
 	else {
 		while (x--)
-			gfs2_glock_dq_uninit(&al->al_qd_ghs[x]);
+			gfs2_glock_dq_uninit(&qa->qa_qd_ghs[x]);
 		gfs2_quota_unhold(ip);
 	}
 
@@ -1000,7 +990,7 @@ static int need_sync(struct gfs2_quota_data *qd)
 
 void gfs2_quota_unlock(struct gfs2_inode *ip)
 {
-	struct gfs2_alloc *al = ip->i_alloc;
+	struct gfs2_qadata *qa = ip->i_qadata;
 	struct gfs2_quota_data *qda[4];
 	unsigned int count = 0;
 	unsigned int x;
@@ -1008,14 +998,14 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
 	if (!test_and_clear_bit(GIF_QD_LOCKED, &ip->i_flags))
 		goto out;
 
-	for (x = 0; x < al->al_qd_num; x++) {
+	for (x = 0; x < qa->qa_qd_num; x++) {
 		struct gfs2_quota_data *qd;
 		int sync;
 
-		qd = al->al_qd[x];
+		qd = qa->qa_qd[x];
 		sync = need_sync(qd);
 
-		gfs2_glock_dq_uninit(&al->al_qd_ghs[x]);
+		gfs2_glock_dq_uninit(&qa->qa_qd_ghs[x]);
 
 		if (sync && qd_trylock(qd))
 			qda[count++] = qd;
@@ -1048,7 +1038,7 @@ static int print_message(struct gfs2_quota_data *qd, char *type)
 int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = ip->i_alloc;
+	struct gfs2_qadata *qa = ip->i_qadata;
 	struct gfs2_quota_data *qd;
 	s64 value;
 	unsigned int x;
@@ -1060,8 +1050,8 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
         if (sdp->sd_args.ar_quota != GFS2_QUOTA_ON)
                 return 0;
 
-	for (x = 0; x < al->al_qd_num; x++) {
-		qd = al->al_qd[x];
+	for (x = 0; x < qa->qa_qd_num; x++) {
+		qd = qa->qa_qd[x];
 
 		if (!((qd->qd_id == uid && test_bit(QDF_USER, &qd->qd_flags)) ||
 		      (qd->qd_id == gid && !test_bit(QDF_USER, &qd->qd_flags))))
@@ -1099,7 +1089,7 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 		       u32 uid, u32 gid)
 {
-	struct gfs2_alloc *al = ip->i_alloc;
+	struct gfs2_qadata *qa = ip->i_qadata;
 	struct gfs2_quota_data *qd;
 	unsigned int x;
 
@@ -1108,8 +1098,8 @@ void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 	if (ip->i_diskflags & GFS2_DIF_SYSTEM)
 		return;
 
-	for (x = 0; x < al->al_qd_num; x++) {
-		qd = al->al_qd[x];
+	for (x = 0; x < qa->qa_qd_num; x++) {
+		qd = qa->qa_qd[x];
 
 		if ((qd->qd_id == uid && test_bit(QDF_USER, &qd->qd_flags)) ||
 		    (qd->qd_id == gid && !test_bit(QDF_USER, &qd->qd_flags))) {
@@ -1529,7 +1519,6 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 	unsigned int data_blocks, ind_blocks;
 	unsigned int blocks = 0;
 	int alloc_required;
-	struct gfs2_alloc *al;
 	loff_t offset;
 	int error;
 
@@ -1594,15 +1583,12 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 	if (gfs2_is_stuffed(ip))
 		alloc_required = 1;
 	if (alloc_required) {
-		al = gfs2_alloc_get(ip);
-		if (al == NULL)
-			goto out_i;
 		gfs2_write_calc_reserv(ip, sizeof(struct gfs2_quota),
 				       &data_blocks, &ind_blocks);
-		blocks = al->al_requested = 1 + data_blocks + ind_blocks;
-		error = gfs2_inplace_reserve(ip);
+		blocks = 1 + data_blocks + ind_blocks;
+		error = gfs2_inplace_reserve(ip, blocks);
 		if (error)
-			goto out_alloc;
+			goto out_i;
 		blocks += gfs2_rg_blocks(ip);
 	}
 
@@ -1617,11 +1603,8 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 
 	gfs2_trans_end(sdp);
 out_release:
-	if (alloc_required) {
+	if (alloc_required)
 		gfs2_inplace_release(ip);
-out_alloc:
-		gfs2_alloc_put(ip);
-	}
 out_i:
 	gfs2_glock_dq_uninit(&i_gh);
 out_q:
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 6b6cc09..f6e05d6 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -860,22 +860,36 @@ fail:
 }
 
 /**
- * gfs2_alloc_get - get the struct gfs2_alloc structure for an inode
+ * gfs2_qadata_get - get the struct gfs2_qadata structure for an inode
  * @ip: the incore GFS2 inode structure
  *
- * Returns: the struct gfs2_alloc
+ * Returns: the struct gfs2_qadata
  */
 
-struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip)
+struct gfs2_qadata *gfs2_qadata_get(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	int error;
-	BUG_ON(ip->i_alloc != NULL);
-	ip->i_alloc = kzalloc(sizeof(struct gfs2_alloc), GFP_NOFS);
+	BUG_ON(ip->i_qadata != NULL);
+	ip->i_qadata = kzalloc(sizeof(struct gfs2_qadata), GFP_NOFS);
 	error = gfs2_rindex_update(sdp);
 	if (error)
 		fs_warn(sdp, "rindex update returns %d\n", error);
-	return ip->i_alloc;
+	return ip->i_qadata;
+}
+
+/**
+ * gfs2_blkrsv_get - get the struct gfs2_blkreserv structure for an inode
+ * @ip: the incore GFS2 inode structure
+ *
+ * Returns: the struct gfs2_qadata
+ */
+
+static struct gfs2_blkreserv *gfs2_blkrsv_get(struct gfs2_inode *ip)
+{
+	BUG_ON(ip->i_res != NULL);
+	ip->i_res = kzalloc(sizeof(struct gfs2_blkreserv), GFP_NOFS);
+	return ip->i_res;
 }
 
 /**
@@ -890,11 +904,11 @@ struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip)
 
 static int try_rgrp_fit(const struct gfs2_rgrpd *rgd, const struct gfs2_inode *ip)
 {
-	const struct gfs2_alloc *al = ip->i_alloc;
+	const struct gfs2_blkreserv *rs = ip->i_res;
 
 	if (rgd->rd_flags & (GFS2_RGF_NOALLOC | GFS2_RDF_ERROR))
 		return 0;
-	if (rgd->rd_free_clone >= al->al_requested)
+	if (rgd->rd_free_clone >= rs->rs_requested)
 		return 1;
 	return 0;
 }
@@ -982,7 +996,7 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd, *begin = NULL;
-	struct gfs2_alloc *al = ip->i_alloc;
+	struct gfs2_blkreserv *rs = ip->i_res;
 	int error, rg_locked, flags = LM_FLAG_TRY;
 	int loops = 0;
 
@@ -1002,7 +1016,7 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 			error = 0;
 		} else {
 			error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE,
-						   flags, &al->al_rgd_gh);
+						   flags, &rs->rs_rgd_gh);
 		}
 		switch (error) {
 		case 0:
@@ -1013,7 +1027,7 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 			if (rgd->rd_flags & GFS2_RDF_CHECK)
 				try_rgrp_unlink(rgd, last_unlinked, ip->i_no_addr);
 			if (!rg_locked)
-				gfs2_glock_dq_uninit(&al->al_rgd_gh);
+				gfs2_glock_dq_uninit(&rs->rs_rgd_gh);
 			/* fall through */
 		case GLR_TRYFAILED:
 			rgd = gfs2_rgrpd_get_next(rgd);
@@ -1030,6 +1044,13 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 	return -ENOSPC;
 }
 
+static void gfs2_blkrsv_put(struct gfs2_inode *ip)
+{
+	BUG_ON(ip->i_res == NULL);
+	kfree(ip->i_res);
+	ip->i_res = NULL;
+}
+
 /**
  * gfs2_inplace_reserve - Reserve space in the filesystem
  * @ip: the inode to reserve space for
@@ -1037,16 +1058,23 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
  * Returns: errno
  */
 
-int gfs2_inplace_reserve(struct gfs2_inode *ip)
+int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = ip->i_alloc;
+	struct gfs2_blkreserv *rs;
 	int error = 0;
 	u64 last_unlinked = NO_BLOCK;
 	int tries = 0;
 
-	if (gfs2_assert_warn(sdp, al->al_requested))
-		return -EINVAL;
+	rs = gfs2_blkrsv_get(ip);
+	if (!rs)
+		return -ENOMEM;
+
+	rs->rs_requested = requested;
+	if (gfs2_assert_warn(sdp, requested)) {
+		error = -EINVAL;
+		goto out;
+	}
 
 	do {
 		error = get_local_rgrp(ip, &last_unlinked);
@@ -1063,6 +1091,9 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip)
 		gfs2_log_flush(sdp, NULL);
 	} while (tries++ < 3);
 
+out:
+	if (error)
+		gfs2_blkrsv_put(ip);
 	return error;
 }
 
@@ -1075,10 +1106,11 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip)
 
 void gfs2_inplace_release(struct gfs2_inode *ip)
 {
-	struct gfs2_alloc *al = ip->i_alloc;
+	struct gfs2_blkreserv *rs = ip->i_res;
 
-	if (al->al_rgd_gh.gh_gl)
-		gfs2_glock_dq_uninit(&al->al_rgd_gh);
+	gfs2_blkrsv_put(ip);
+	if (rs->rs_rgd_gh.gh_gl)
+		gfs2_glock_dq_uninit(&rs->rs_rgd_gh);
 }
 
 /**
@@ -1338,7 +1370,6 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *ndata,
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head *dibh;
-	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_rgrpd *rgd;
 	u32 goal, extlen, blk; /* block, within the rgrp scope */
 	u64 block; /* block, within the file system scope */
@@ -1348,7 +1379,7 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *ndata,
 	/* Only happens if there is a bug in gfs2, return something distinctive
 	 * to ensure that it is noticed.
 	 */
-	if (al == NULL)
+	if (ip->i_res == NULL)
 		return -ECANCELED;
 
 	rgd = ip->i_rgd;
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index b3b61b8..ceec910 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -28,15 +28,15 @@ extern void gfs2_free_clones(struct gfs2_rgrpd *rgd);
 extern int gfs2_rgrp_go_lock(struct gfs2_holder *gh);
 extern void gfs2_rgrp_go_unlock(struct gfs2_holder *gh);
 
-extern struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip);
-static inline void gfs2_alloc_put(struct gfs2_inode *ip)
+extern struct gfs2_qadata *gfs2_qadata_get(struct gfs2_inode *ip);
+static inline void gfs2_qadata_put(struct gfs2_inode *ip)
 {
-	BUG_ON(ip->i_alloc == NULL);
-	kfree(ip->i_alloc);
-	ip->i_alloc = NULL;
+	BUG_ON(ip->i_qadata == NULL);
+	kfree(ip->i_qadata);
+	ip->i_qadata = NULL;
 }
 
-extern int gfs2_inplace_reserve(struct gfs2_inode *ip);
+extern int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested);
 extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
 extern int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 71e4209..69eb568 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1399,8 +1399,9 @@ static void gfs2_final_release_pages(struct gfs2_inode *ip)
 static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al;
+	struct gfs2_qadata *qa;
 	struct gfs2_rgrpd *rgd;
+	struct gfs2_holder gh;
 	int error;
 
 	if (gfs2_get_inode_blocks(&ip->i_inode) != 1) {
@@ -1408,8 +1409,8 @@ static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 		return -EIO;
 	}
 
-	al = gfs2_alloc_get(ip);
-	if (!al)
+	qa = gfs2_qadata_get(ip);
+	if (!qa)
 		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
@@ -1423,8 +1424,7 @@ static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 		goto out_qs;
 	}
 
-	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0,
-				   &al->al_rgd_gh);
+	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	if (error)
 		goto out_qs;
 
@@ -1440,11 +1440,11 @@ static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 	gfs2_trans_end(sdp);
 
 out_rg_gunlock:
-	gfs2_glock_dq_uninit(&al->al_rgd_gh);
+	gfs2_glock_dq_uninit(&gh);
 out_qs:
 	gfs2_quota_unhold(ip);
 out:
-	gfs2_alloc_put(ip);
+	gfs2_qadata_put(ip);
 	return error;
 }
 
diff --git a/fs/gfs2/trans.h b/fs/gfs2/trans.h
index f8f101e..125d457 100644
--- a/fs/gfs2/trans.h
+++ b/fs/gfs2/trans.h
@@ -30,9 +30,9 @@ struct gfs2_glock;
  * block, or all of the blocks in the rg, whichever is smaller */
 static inline unsigned int gfs2_rg_blocks(const struct gfs2_inode *ip)
 {
-	const struct gfs2_alloc *al = ip->i_alloc;
-	if (al->al_requested < ip->i_rgd->rd_length)
-		return al->al_requested + 1;
+	const struct gfs2_blkreserv *rs = ip->i_res;
+	if (rs->rs_requested < ip->i_rgd->rd_length)
+		return rs->rs_requested + 1;
 	return ip->i_rgd->rd_length;
 }
 
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index ef74e159..e963659 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -321,11 +321,11 @@ static int ea_remove_unstuffed(struct gfs2_inode *ip, struct buffer_head *bh,
 			       struct gfs2_ea_header *ea,
 			       struct gfs2_ea_header *prev, int leave)
 {
-	struct gfs2_alloc *al;
+	struct gfs2_qadata *qa;
 	int error;
 
-	al = gfs2_alloc_get(ip);
-	if (!al)
+	qa = gfs2_qadata_get(ip);
+	if (!qa)
 		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
@@ -336,7 +336,7 @@ static int ea_remove_unstuffed(struct gfs2_inode *ip, struct buffer_head *bh,
 
 	gfs2_quota_unhold(ip);
 out_alloc:
-	gfs2_alloc_put(ip);
+	gfs2_qadata_put(ip);
 	return error;
 }
 
@@ -709,21 +709,19 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 			     unsigned int blks,
 			     ea_skeleton_call_t skeleton_call, void *private)
 {
-	struct gfs2_alloc *al;
+	struct gfs2_qadata *qa;
 	struct buffer_head *dibh;
 	int error;
 
-	al = gfs2_alloc_get(ip);
-	if (!al)
+	qa = gfs2_qadata_get(ip);
+	if (!qa)
 		return -ENOMEM;
 
 	error = gfs2_quota_lock_check(ip);
 	if (error)
 		goto out;
 
-	al->al_requested = blks;
-
-	error = gfs2_inplace_reserve(ip);
+	error = gfs2_inplace_reserve(ip, blks);
 	if (error)
 		goto out_gunlock_q;
 
@@ -752,7 +750,7 @@ out_ipres:
 out_gunlock_q:
 	gfs2_quota_unlock(ip);
 out:
-	gfs2_alloc_put(ip);
+	gfs2_qadata_put(ip);
 	return error;
 }
 
@@ -1436,9 +1434,9 @@ out:
 static int ea_dealloc_block(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_rgrpd *rgd;
 	struct buffer_head *dibh;
+	struct gfs2_holder gh;
 	int error;
 
 	rgd = gfs2_blk2rgrpd(sdp, ip->i_eattr);
@@ -1447,8 +1445,7 @@ static int ea_dealloc_block(struct gfs2_inode *ip)
 		return -EIO;
 	}
 
-	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0,
-				   &al->al_rgd_gh);
+	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	if (error)
 		return error;
 
@@ -1472,7 +1469,7 @@ static int ea_dealloc_block(struct gfs2_inode *ip)
 	gfs2_trans_end(sdp);
 
 out_gunlock:
-	gfs2_glock_dq_uninit(&al->al_rgd_gh);
+	gfs2_glock_dq_uninit(&gh);
 	return error;
 }
 
@@ -1485,11 +1482,11 @@ out_gunlock:
 
 int gfs2_ea_dealloc(struct gfs2_inode *ip)
 {
-	struct gfs2_alloc *al;
+	struct gfs2_qadata *qa;
 	int error;
 
-	al = gfs2_alloc_get(ip);
-	if (!al)
+	qa = gfs2_qadata_get(ip);
+	if (!qa)
 		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
@@ -1511,7 +1508,7 @@ int gfs2_ea_dealloc(struct gfs2_inode *ip)
 out_quota:
 	gfs2_quota_unhold(ip);
 out_alloc:
-	gfs2_alloc_put(ip);
+	gfs2_qadata_put(ip);
 	return error;
 }
 
-- 
1.7.4

