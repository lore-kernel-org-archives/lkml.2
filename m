Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab1JXMu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:50:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab1JXMrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:41 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/24] GFS2: Make resource groups "append only" during life of fs
Date: Mon, 24 Oct 2011 13:48:25 +0100
Message-Id: <1319460518-9046-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have ruled out supporting online filesystem shrink,
it is possible to make the resource group list append only
during the life of a super block. This gives several benefits:

Firstly, we only need to read new rindex elements as they are added
rather than needing to reread the whole rindex file each time one
element is added.

Secondly, the rindex glock can be held for much shorter periods of
time, and is completely removed from the fast path for allocations.
The lock is taken in shared mode only when updating the resource
groups when the first allocation occurs, and after a grow has
taken place.

Thirdly, this results in a reduction in code size, and everything
gets a lot simpler to understand in this area.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 7878c47..e602961 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -783,11 +783,6 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 	else if (ip->i_depth)
 		revokes = sdp->sd_inptrs;
 
-	if (ip != GFS2_I(sdp->sd_rindex))
-		error = gfs2_rindex_hold(sdp, &ip->i_alloc->al_ri_gh);
-	else if (!sdp->sd_rgrps)
-		error = gfs2_ri_update(ip);
-
 	if (error)
 		return error;
 
@@ -887,8 +882,6 @@ out_rg_gunlock:
 out_rlist:
 	gfs2_rlist_free(&rlist);
 out:
-	if (ip != GFS2_I(sdp->sd_rindex))
-		gfs2_glock_dq_uninit(&ip->i_alloc->al_ri_gh);
 	return error;
 }
 
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 898e62e..90b877b 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1807,10 +1807,6 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 	if (error)
 		goto out_put;
 
-	error = gfs2_rindex_hold(sdp, &dip->i_alloc->al_ri_gh);
-	if (error)
-		goto out_qs;
-
 	/*  Count the number of leaves  */
 	bh = leaf_bh;
 
@@ -1889,8 +1885,6 @@ out_rg_gunlock:
 	gfs2_glock_dq_m(rlist.rl_rgrps, rlist.rl_ghs);
 out_rlist:
 	gfs2_rlist_free(&rlist);
-	gfs2_glock_dq_uninit(&dip->i_alloc->al_ri_gh);
-out_qs:
 	gfs2_quota_unhold(dip);
 out_put:
 	gfs2_alloc_put(dip);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 6f82aac..951541b 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -134,8 +134,7 @@ void gfs2_ail_flush(struct gfs2_glock *gl)
 static void rgrp_go_sync(struct gfs2_glock *gl)
 {
 	struct address_space *metamapping = gfs2_glock2aspace(gl);
-	struct gfs2_rgrpd *rgd = gl->gl_object;
-	unsigned int x;
+	struct gfs2_rgrpd *rgd;
 	int error;
 
 	if (!test_and_clear_bit(GLF_DIRTY, &gl->gl_flags))
@@ -148,14 +147,11 @@ static void rgrp_go_sync(struct gfs2_glock *gl)
         mapping_set_error(metamapping, error);
 	gfs2_ail_empty_gl(gl);
 
-	if (!rgd)
-		return;
-
-	for (x = 0; x < rgd->rd_length; x++) {
-		struct gfs2_bitmap *bi = rgd->rd_bits + x;
-		kfree(bi->bi_clone);
-		bi->bi_clone = NULL;
-	}
+	spin_lock(&gl->gl_spin);
+	rgd = gl->gl_object;
+	if (rgd)
+		gfs2_free_clones(rgd);
+	spin_unlock(&gl->gl_spin);
 }
 
 /**
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 9e753fc..56847f5 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -255,7 +255,6 @@ struct gfs2_alloc {
 
 	unsigned int al_line;
 	char *al_file;
-	struct gfs2_holder al_ri_gh;
 	struct gfs2_holder al_rgd_gh;
 	struct gfs2_rgrpd *al_rgd;
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 2af6905..29703dd 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1041,13 +1041,8 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	struct buffer_head *bh;
 	struct gfs2_holder ghs[3];
 	struct gfs2_rgrpd *rgd;
-	struct gfs2_holder ri_gh;
 	int error;
 
-	error = gfs2_rindex_hold(sdp, &ri_gh);
-	if (error)
-		return error;
-
 	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	gfs2_holder_init(ip->i_gl,  LM_ST_EXCLUSIVE, 0, ghs + 1);
 
@@ -1104,7 +1099,6 @@ out_child:
 	gfs2_glock_dq(ghs);
 out_parent:
 	gfs2_holder_uninit(ghs);
-	gfs2_glock_dq_uninit(&ri_gh);
 	return error;
 }
 
@@ -1222,7 +1216,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	struct gfs2_inode *ip = GFS2_I(odentry->d_inode);
 	struct gfs2_inode *nip = NULL;
 	struct gfs2_sbd *sdp = GFS2_SB(odir);
-	struct gfs2_holder ghs[5], r_gh = { .gh_gl = NULL, }, ri_gh;
+	struct gfs2_holder ghs[5], r_gh = { .gh_gl = NULL, };
 	struct gfs2_rgrpd *nrgd;
 	unsigned int num_gh;
 	int dir_rename = 0;
@@ -1236,10 +1230,6 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			return 0;
 	}
 
-	error = gfs2_rindex_hold(sdp, &ri_gh);
-	if (error)
-		return error;
-
 	if (odip != ndip) {
 		error = gfs2_glock_nq_init(sdp->sd_rename_gl, LM_ST_EXCLUSIVE,
 					   0, &r_gh);
@@ -1376,7 +1366,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 
 		al->al_requested = sdp->sd_max_dirres;
 
-		error = gfs2_inplace_reserve_ri(ndip);
+		error = gfs2_inplace_reserve(ndip);
 		if (error)
 			goto out_gunlock_q;
 
@@ -1447,7 +1437,6 @@ out_gunlock_r:
 	if (r_gh.gh_gl)
 		gfs2_glock_dq_uninit(&r_gh);
 out:
-	gfs2_glock_dq_uninit(&ri_gh);
 	return error;
 }
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 00f6e3d..88d5b75 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -332,14 +332,10 @@ struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk)
 	struct rb_node **newn, *parent = NULL;
 
 	spin_lock(&sdp->sd_rindex_spin);
-
 	newn = &sdp->sd_rindex_tree.rb_node;
-
-	/* Figure out where to put new node */
 	while (*newn) {
 		struct gfs2_rgrpd *cur = rb_entry(*newn, struct gfs2_rgrpd,
 						  rd_node);
-
 		parent = *newn;
 		if (blk < cur->rd_addr)
 			newn = &((*newn)->rb_left);
@@ -350,7 +346,6 @@ struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk)
 			return cur;
 		}
 	}
-
 	spin_unlock(&sdp->sd_rindex_spin);
 
 	return NULL;
@@ -368,8 +363,10 @@ struct gfs2_rgrpd *gfs2_rgrpd_get_first(struct gfs2_sbd *sdp)
 	const struct rb_node *n;
 	struct gfs2_rgrpd *rgd;
 
+	spin_lock(&sdp->sd_rindex_spin);
 	n = rb_first(&sdp->sd_rindex_tree);
 	rgd = rb_entry(n, struct gfs2_rgrpd, rd_node);
+	spin_unlock(&sdp->sd_rindex_spin);
 
 	return rgd;
 }
@@ -400,7 +397,18 @@ struct gfs2_rgrpd *gfs2_rgrpd_get_next(struct gfs2_rgrpd *rgd)
 	return rgd;
 }
 
-static void clear_rgrpdi(struct gfs2_sbd *sdp)
+void gfs2_free_clones(struct gfs2_rgrpd *rgd)
+{
+	int x;
+
+	for (x = 0; x < rgd->rd_length; x++) {
+		struct gfs2_bitmap *bi = rgd->rd_bits + x;
+		kfree(bi->bi_clone);
+		bi->bi_clone = NULL;
+	}
+}
+
+void gfs2_clear_rgrpd(struct gfs2_sbd *sdp)
 {
 	struct rb_node *n;
 	struct gfs2_rgrpd *rgd;
@@ -413,23 +421,19 @@ static void clear_rgrpdi(struct gfs2_sbd *sdp)
 		rb_erase(n, &sdp->sd_rindex_tree);
 
 		if (gl) {
+			spin_lock(&gl->gl_spin);
 			gl->gl_object = NULL;
+			spin_unlock(&gl->gl_spin);
 			gfs2_glock_add_to_lru(gl);
 			gfs2_glock_put(gl);
 		}
 
+		gfs2_free_clones(rgd);
 		kfree(rgd->rd_bits);
 		kmem_cache_free(gfs2_rgrpd_cachep, rgd);
 	}
 }
 
-void gfs2_clear_rgrpd(struct gfs2_sbd *sdp)
-{
-	mutex_lock(&sdp->sd_rindex_mutex);
-	clear_rgrpdi(sdp);
-	mutex_unlock(&sdp->sd_rindex_mutex);
-}
-
 static void gfs2_rindex_print(const struct gfs2_rgrpd *rgd)
 {
 	printk(KERN_INFO "  ri_addr = %llu\n", (unsigned long long)rgd->rd_addr);
@@ -546,17 +550,6 @@ u64 gfs2_ri_total(struct gfs2_sbd *sdp)
 	return total_data;
 }
 
-static void gfs2_rindex_in(struct gfs2_rgrpd *rgd, const void *buf)
-{
-	const struct gfs2_rindex *str = buf;
-
-	rgd->rd_addr = be64_to_cpu(str->ri_addr);
-	rgd->rd_length = be32_to_cpu(str->ri_length);
-	rgd->rd_data0 = be64_to_cpu(str->ri_data0);
-	rgd->rd_data = be32_to_cpu(str->ri_data);
-	rgd->rd_bitbytes = be32_to_cpu(str->ri_bitbytes);
-}
-
 static void rgd_insert(struct gfs2_rgrpd *rgd)
 {
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
@@ -584,7 +577,7 @@ static void rgd_insert(struct gfs2_rgrpd *rgd)
  * read_rindex_entry - Pull in a new resource index entry from the disk
  * @gl: The glock covering the rindex inode
  *
- * Returns: 0 on success, error code otherwise
+ * Returns: 0 on success, > 0 on EOF, error code otherwise
  */
 
 static int read_rindex_entry(struct gfs2_inode *ip,
@@ -592,19 +585,18 @@ static int read_rindex_entry(struct gfs2_inode *ip,
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	loff_t pos = sdp->sd_rgrps * sizeof(struct gfs2_rindex);
-	char buf[sizeof(struct gfs2_rindex)];
+	struct gfs2_rindex buf;
 	int error;
 	struct gfs2_rgrpd *rgd;
 
-	error = gfs2_internal_read(ip, ra_state, buf, &pos,
+	if (pos >= i_size_read(&ip->i_inode))
+		return 1;
+
+	error = gfs2_internal_read(ip, ra_state, (char *)&buf, &pos,
 				   sizeof(struct gfs2_rindex));
-	if (!error)
-		return 0;
-	if (error != sizeof(struct gfs2_rindex)) {
-		if (error > 0)
-			error = -EIO;
-		return error;
-	}
+
+	if (error != sizeof(struct gfs2_rindex))
+		return (error == 0) ? 1 : error;
 
 	rgd = kmem_cache_zalloc(gfs2_rgrpd_cachep, GFP_NOFS);
 	error = -ENOMEM;
@@ -612,23 +604,34 @@ static int read_rindex_entry(struct gfs2_inode *ip,
 		return error;
 
 	rgd->rd_sbd = sdp;
-
-	gfs2_rindex_in(rgd, buf);
-	rgd_insert(rgd);
+	rgd->rd_addr = be64_to_cpu(buf.ri_addr);
+	rgd->rd_length = be32_to_cpu(buf.ri_length);
+	rgd->rd_data0 = be64_to_cpu(buf.ri_data0);
+	rgd->rd_data = be32_to_cpu(buf.ri_data);
+	rgd->rd_bitbytes = be32_to_cpu(buf.ri_bitbytes);
 
 	error = compute_bitstructs(rgd);
 	if (error)
-		return error;
+		goto fail;
 
 	error = gfs2_glock_get(sdp, rgd->rd_addr,
 			       &gfs2_rgrp_glops, CREATE, &rgd->rd_gl);
 	if (error)
-		return error;
+		goto fail;
 
 	rgd->rd_gl->gl_object = rgd;
 	rgd->rd_flags &= ~GFS2_RDF_UPTODATE;
 	if (rgd->rd_data > sdp->sd_max_rg_data)
 		sdp->sd_max_rg_data = rgd->rd_data;
+	spin_lock(&sdp->sd_rindex_spin);
+	rgd_insert(rgd);
+	sdp->sd_rgrps++;
+	spin_unlock(&sdp->sd_rindex_spin);
+	return error;
+
+fail:
+	kfree(rgd->rd_bits);
+	kmem_cache_free(gfs2_rgrpd_cachep, rgd);
 	return error;
 }
 
@@ -639,34 +642,28 @@ static int read_rindex_entry(struct gfs2_inode *ip,
  * Returns: 0 on successful update, error code otherwise
  */
 
-int gfs2_ri_update(struct gfs2_inode *ip)
+static int gfs2_ri_update(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct inode *inode = &ip->i_inode;
 	struct file_ra_state ra_state;
-	u64 rgrp_count = i_size_read(inode);
 	int error;
 
-	do_div(rgrp_count, sizeof(struct gfs2_rindex));
-	clear_rgrpdi(sdp);
-
 	file_ra_state_init(&ra_state, inode->i_mapping);
-	for (sdp->sd_rgrps = 0; sdp->sd_rgrps < rgrp_count; sdp->sd_rgrps++) {
+	do {
 		error = read_rindex_entry(ip, &ra_state);
-		if (error) {
-			clear_rgrpdi(sdp);
-			return error;
-		}
-	}
+	} while (error == 0);
+
+	if (error < 0)
+		return error;
 
 	sdp->sd_rindex_uptodate = 1;
 	return 0;
 }
 
 /**
- * gfs2_rindex_hold - Grab a lock on the rindex
+ * gfs2_rindex_update - Update the rindex if required
  * @sdp: The GFS2 superblock
- * @ri_gh: the glock holder
  *
  * We grab a lock on the rindex inode to make sure that it doesn't
  * change whilst we are performing an operation. We keep this lock
@@ -678,30 +675,29 @@ int gfs2_ri_update(struct gfs2_inode *ip)
  * special file, which might have been updated if someone expanded the
  * filesystem (via gfs2_grow utility), which adds new resource groups.
  *
- * Returns: 0 on success, error code otherwise
+ * Returns: 0 on succeess, error code otherwise
  */
 
-int gfs2_rindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ri_gh)
+int gfs2_rindex_update(struct gfs2_sbd *sdp)
 {
 	struct gfs2_inode *ip = GFS2_I(sdp->sd_rindex);
 	struct gfs2_glock *gl = ip->i_gl;
-	int error;
-
-	error = gfs2_glock_nq_init(gl, LM_ST_SHARED, 0, ri_gh);
-	if (error)
-		return error;
+	struct gfs2_holder ri_gh;
+	int error = 0;
 
 	/* Read new copy from disk if we don't have the latest */
 	if (!sdp->sd_rindex_uptodate) {
 		mutex_lock(&sdp->sd_rindex_mutex);
-		if (!sdp->sd_rindex_uptodate) {
+		error = gfs2_glock_nq_init(gl, LM_ST_SHARED, 0, &ri_gh);
+		if (error)
+			return error;
+		if (!sdp->sd_rindex_uptodate)
 			error = gfs2_ri_update(ip);
-			if (error)
-				gfs2_glock_dq_uninit(ri_gh);
-		}
+		gfs2_glock_dq_uninit(&ri_gh);
 		mutex_unlock(&sdp->sd_rindex_mutex);
 	}
 
+
 	return error;
 }
 
@@ -873,8 +869,13 @@ fail:
 
 struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip)
 {
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	int error;
 	BUG_ON(ip->i_alloc != NULL);
 	ip->i_alloc = kzalloc(sizeof(struct gfs2_alloc), GFP_NOFS);
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		fs_warn(sdp, "rindex update returns %d\n", error);
 	return ip->i_alloc;
 }
 
@@ -1029,7 +1030,7 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
  * Returns: errno
  */
 
-int gfs2_inplace_reserve_i(struct gfs2_inode *ip, int hold_rindex,
+int gfs2_inplace_reserve_i(struct gfs2_inode *ip,
 			   char *file, unsigned int line)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
@@ -1041,18 +1042,6 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip, int hold_rindex,
 	if (gfs2_assert_warn(sdp, al->al_requested))
 		return -EINVAL;
 
-	if (hold_rindex) {
-		/* We need to hold the rindex unless the inode we're using is
-		   the rindex itself, in which case it's already held. */
-		if (ip != GFS2_I(sdp->sd_rindex))
-			error = gfs2_rindex_hold(sdp, &al->al_ri_gh);
-		else if (!sdp->sd_rgrps) /* We may not have the rindex read
-					    in, so: */
-			error = gfs2_ri_update(ip);
-		if (error)
-			return error;
-	}
-
 try_again:
 	do {
 		error = get_local_rgrp(ip, &last_unlinked);
@@ -1069,11 +1058,8 @@ try_again:
 		}
 	} while (error && tries++ < 3);
 
-	if (error) {
-		if (hold_rindex && ip != GFS2_I(sdp->sd_rindex))
-			gfs2_glock_dq_uninit(&al->al_ri_gh);
+	if (error)
 		return error;
-	}
 
 	/* no error, so we have the rgrp set in the inode's allocation. */
 	al->al_file = file;
@@ -1103,8 +1089,6 @@ void gfs2_inplace_release(struct gfs2_inode *ip)
 	al->al_rgd = NULL;
 	if (al->al_rgd_gh.gh_gl)
 		gfs2_glock_dq_uninit(&al->al_rgd_gh);
-	if (ip != GFS2_I(sdp->sd_rindex) && al->al_ri_gh.gh_gl)
-		gfs2_glock_dq_uninit(&al->al_ri_gh);
 }
 
 /**
@@ -1558,34 +1542,26 @@ void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip)
 int gfs2_check_blk_type(struct gfs2_sbd *sdp, u64 no_addr, unsigned int type)
 {
 	struct gfs2_rgrpd *rgd;
-	struct gfs2_holder ri_gh, rgd_gh;
-	struct gfs2_inode *ip = GFS2_I(sdp->sd_rindex);
-	int ri_locked = 0;
+	struct gfs2_holder rgd_gh;
 	int error;
 
-	if (!gfs2_glock_is_locked_by_me(ip->i_gl)) {
-		error = gfs2_rindex_hold(sdp, &ri_gh);
-		if (error)
-			goto fail;
-		ri_locked = 1;
-	}
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		return error;
 
 	error = -EINVAL;
 	rgd = gfs2_blk2rgrpd(sdp, no_addr);
 	if (!rgd)
-		goto fail_rindex;
+		goto fail;
 
 	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_SHARED, 0, &rgd_gh);
 	if (error)
-		goto fail_rindex;
+		goto fail;
 
 	if (gfs2_get_block_type(rgd, no_addr) != type)
 		error = -ESTALE;
 
 	gfs2_glock_dq_uninit(&rgd_gh);
-fail_rindex:
-	if (ri_locked)
-		gfs2_glock_dq_uninit(&ri_gh);
 fail:
 	return error;
 }
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 59b950f..0439fca 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -18,13 +18,13 @@ struct gfs2_holder;
 
 extern void gfs2_rgrp_verify(struct gfs2_rgrpd *rgd);
 
-struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk);
-struct gfs2_rgrpd *gfs2_rgrpd_get_first(struct gfs2_sbd *sdp);
-struct gfs2_rgrpd *gfs2_rgrpd_get_next(struct gfs2_rgrpd *rgd);
+extern struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk);
+extern struct gfs2_rgrpd *gfs2_rgrpd_get_first(struct gfs2_sbd *sdp);
+extern struct gfs2_rgrpd *gfs2_rgrpd_get_next(struct gfs2_rgrpd *rgd);
 
 extern void gfs2_clear_rgrpd(struct gfs2_sbd *sdp);
-extern int gfs2_rindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ri_gh);
-
+extern int gfs2_rindex_update(struct gfs2_sbd *sdp);
+extern void gfs2_free_clones(struct gfs2_rgrpd *rgd);
 extern int gfs2_rgrp_go_lock(struct gfs2_holder *gh);
 extern void gfs2_rgrp_go_unlock(struct gfs2_holder *gh);
 
@@ -36,16 +36,13 @@ static inline void gfs2_alloc_put(struct gfs2_inode *ip)
 	ip->i_alloc = NULL;
 }
 
-extern int gfs2_inplace_reserve_i(struct gfs2_inode *ip, int hold_rindex,
+extern int gfs2_inplace_reserve_i(struct gfs2_inode *ip,
 				  char *file, unsigned int line);
 #define gfs2_inplace_reserve(ip) \
-	gfs2_inplace_reserve_i((ip), 1, __FILE__, __LINE__)
-#define gfs2_inplace_reserve_ri(ip) \
-	gfs2_inplace_reserve_i((ip), 0, __FILE__, __LINE__)
+	gfs2_inplace_reserve_i((ip),  __FILE__, __LINE__)
 
 extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
-extern int gfs2_ri_update(struct gfs2_inode *ip);
 extern int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n);
 extern int gfs2_alloc_di(struct gfs2_inode *ip, u64 *bn, u64 *generation);
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index b05fa59..f716c4f 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1037,7 +1037,6 @@ static int statfs_slow_fill(struct gfs2_rgrpd *rgd,
 
 static int gfs2_statfs_slow(struct gfs2_sbd *sdp, struct gfs2_statfs_change_host *sc)
 {
-	struct gfs2_holder ri_gh;
 	struct gfs2_rgrpd *rgd_next;
 	struct gfs2_holder *gha, *gh;
 	unsigned int slots = 64;
@@ -1050,10 +1049,6 @@ static int gfs2_statfs_slow(struct gfs2_sbd *sdp, struct gfs2_statfs_change_host
 	if (!gha)
 		return -ENOMEM;
 
-	error = gfs2_rindex_hold(sdp, &ri_gh);
-	if (error)
-		goto out;
-
 	rgd_next = gfs2_rgrpd_get_first(sdp);
 
 	for (;;) {
@@ -1096,9 +1091,6 @@ static int gfs2_statfs_slow(struct gfs2_sbd *sdp, struct gfs2_statfs_change_host
 		yield();
 	}
 
-	gfs2_glock_dq_uninit(&ri_gh);
-
-out:
 	kfree(gha);
 	return error;
 }
@@ -1150,6 +1142,10 @@ static int gfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct gfs2_statfs_change_host sc;
 	int error;
 
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		return error;
+
 	if (gfs2_tune_get(sdp, gt_statfs_slow))
 		error = gfs2_statfs_slow(sdp, &sc);
 	else
@@ -1420,21 +1416,17 @@ static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 	if (error)
 		goto out;
 
-	error = gfs2_rindex_hold(sdp, &al->al_ri_gh);
-	if (error)
-		goto out_qs;
-
 	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
 	if (!rgd) {
 		gfs2_consist_inode(ip);
 		error = -EIO;
-		goto out_rindex_relse;
+		goto out_qs;
 	}
 
 	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0,
 				   &al->al_rgd_gh);
 	if (error)
-		goto out_rindex_relse;
+		goto out_qs;
 
 	error = gfs2_trans_begin(sdp, RES_RG_BIT + RES_STATFS + RES_QUOTA,
 				 sdp->sd_jdesc->jd_blocks);
@@ -1449,8 +1441,6 @@ static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 
 out_rg_gunlock:
 	gfs2_glock_dq_uninit(&al->al_rgd_gh);
-out_rindex_relse:
-	gfs2_glock_dq_uninit(&al->al_ri_gh);
 out_qs:
 	gfs2_quota_unhold(ip);
 out:
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 695304c..167f4af 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -332,15 +332,8 @@ static int ea_remove_unstuffed(struct gfs2_inode *ip, struct buffer_head *bh,
 	if (error)
 		goto out_alloc;
 
-	error = gfs2_rindex_hold(GFS2_SB(&ip->i_inode), &al->al_ri_gh);
-	if (error)
-		goto out_quota;
-
 	error = ea_dealloc_unstuffed(ip, bh, ea, prev, (leave) ? &error : NULL);
 
-	gfs2_glock_dq_uninit(&al->al_ri_gh);
-
-out_quota:
 	gfs2_quota_unhold(ip);
 out_alloc:
 	gfs2_alloc_put(ip);
@@ -1502,24 +1495,18 @@ int gfs2_ea_dealloc(struct gfs2_inode *ip)
 	if (error)
 		goto out_alloc;
 
-	error = gfs2_rindex_hold(GFS2_SB(&ip->i_inode), &al->al_ri_gh);
-	if (error)
-		goto out_quota;
-
 	error = ea_foreach(ip, ea_dealloc_unstuffed, NULL);
 	if (error)
-		goto out_rindex;
+		goto out_quota;
 
 	if (ip->i_diskflags & GFS2_DIF_EA_INDIRECT) {
 		error = ea_dealloc_indirect(ip);
 		if (error)
-			goto out_rindex;
+			goto out_quota;
 	}
 
 	error = ea_dealloc_block(ip);
 
-out_rindex:
-	gfs2_glock_dq_uninit(&al->al_ri_gh);
 out_quota:
 	gfs2_quota_unhold(ip);
 out_alloc:
-- 
1.7.4.4

