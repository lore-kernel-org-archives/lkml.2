Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab1ESJKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018Ab1ESJKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:19 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/32] GFS2: Optimise glock lru and end of life inodes
Date: Thu, 19 May 2011 09:47:07 +0100
Message-Id: <1305794847-3291-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GLF_LRU flag introduced in the previous patch can be
used to check if a glock is on the lru list when a new
holder is queued and if so remove it, without having first
to get the lru_lock.

The main purpose of this patch however is to optimise the
glocks left over when an inode at end of life is being
evicted. Previously such glocks were left with the GLF_LFLUSH
flag set, so that when reclaimed, each one required a log flush.
This patch resets the GLF_LFLUSH flag when there is nothing
left to flush thus preventing later log flushes as glocks are
reused or demoted.

In order to do this, we need to keep track of the number of
revokes which are outstanding, and also to clear the GLF_LFLUSH
bit after a log commit when only revokes have been processed.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 0c6c690..cb8776f 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -145,14 +145,9 @@ static int demote_ok(const struct gfs2_glock *gl)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 
-	/* assert_spin_locked(&gl->gl_spin); */
-
 	if (gl->gl_state == LM_ST_UNLOCKED)
 		return 0;
-	if (test_bit(GLF_LFLUSH, &gl->gl_flags))
-		return 0;
-	if ((gl->gl_name.ln_type != LM_TYPE_INODE) &&
-	    !list_empty(&gl->gl_holders))
+	if (!list_empty(&gl->gl_holders))
 		return 0;
 	if (glops->go_demote_ok)
 		return glops->go_demote_ok(gl);
@@ -174,6 +169,17 @@ void gfs2_glock_add_to_lru(struct gfs2_glock *gl)
 	spin_unlock(&lru_lock);
 }
 
+static void gfs2_glock_remove_from_lru(struct gfs2_glock *gl)
+{
+	spin_lock(&lru_lock);
+	if (!list_empty(&gl->gl_lru)) {
+		list_del_init(&gl->gl_lru);
+		atomic_dec(&lru_count);
+		clear_bit(GLF_LRU, &gl->gl_flags);
+	}
+	spin_unlock(&lru_lock);
+}
+
 /**
  * __gfs2_glock_schedule_for_reclaim - Add a glock to the reclaim list
  * @gl: the glock
@@ -217,12 +223,7 @@ void gfs2_glock_put(struct gfs2_glock *gl)
 		spin_lock_bucket(gl->gl_hash);
 		hlist_bl_del_rcu(&gl->gl_list);
 		spin_unlock_bucket(gl->gl_hash);
-		spin_lock(&lru_lock);
-		if (!list_empty(&gl->gl_lru)) {
-			list_del_init(&gl->gl_lru);
-			atomic_dec(&lru_count);
-		}
-		spin_unlock(&lru_lock);
+		gfs2_glock_remove_from_lru(gl);
 		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_holders));
 		GLOCK_BUG_ON(gl, mapping && mapping->nrpages);
 		trace_gfs2_glock_put(gl);
@@ -1025,6 +1026,9 @@ int gfs2_glock_nq(struct gfs2_holder *gh)
 	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
 		return -EIO;
 
+	if (test_bit(GLF_LRU, &gl->gl_flags))
+		gfs2_glock_remove_from_lru(gl);
+
 	spin_lock(&gl->gl_spin);
 	add_to_queue(gh);
 	if ((LM_FLAG_NOEXP & gh->gh_flags) &&
@@ -1082,7 +1086,8 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 		    !test_bit(GLF_DEMOTE, &gl->gl_flags))
 			fast_path = 1;
 	}
-	__gfs2_glock_schedule_for_reclaim(gl);
+	if (!test_bit(GLF_LFLUSH, &gl->gl_flags))
+		__gfs2_glock_schedule_for_reclaim(gl);
 	trace_gfs2_glock_queue(gh, 0);
 	spin_unlock(&gl->gl_spin);
 	if (likely(fast_path))
@@ -1461,12 +1466,7 @@ static void thaw_glock(struct gfs2_glock *gl)
 
 static void clear_glock(struct gfs2_glock *gl)
 {
-	spin_lock(&lru_lock);
-	if (!list_empty(&gl->gl_lru)) {
-		list_del_init(&gl->gl_lru);
-		atomic_dec(&lru_count);
-	}
-	spin_unlock(&lru_lock);
+	gfs2_glock_remove_from_lru(gl);
 
 	spin_lock(&gl->gl_spin);
 	if (gl->gl_state != LM_ST_UNLOCKED)
@@ -1666,7 +1666,7 @@ static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 	dtime *= 1000000/HZ; /* demote time in uSec */
 	if (!test_bit(GLF_DEMOTE, &gl->gl_flags))
 		dtime = 0;
-	gfs2_print_dbg(seq, "G:  s:%s n:%u/%llx f:%s t:%s d:%s/%llu a:%d r:%d\n",
+	gfs2_print_dbg(seq, "G:  s:%s n:%u/%llx f:%s t:%s d:%s/%llu a:%d v:%d r:%d\n",
 		  state2str(gl->gl_state),
 		  gl->gl_name.ln_type,
 		  (unsigned long long)gl->gl_name.ln_number,
@@ -1674,6 +1674,7 @@ static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 		  state2str(gl->gl_target),
 		  state2str(gl->gl_demote_state), dtime,
 		  atomic_read(&gl->gl_ail_count),
+		  atomic_read(&gl->gl_revokes),
 		  atomic_read(&gl->gl_ref));
 
 	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 48eb1ee..5067bea 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -236,6 +236,7 @@ struct gfs2_glock {
 
 	struct list_head gl_ail_list;
 	atomic_t gl_ail_count;
+	atomic_t gl_revokes;
 	struct delayed_work gl_work;
 	struct work_struct gl_delete;
 	struct rcu_head gl_rcu;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9134dcb..9b7b9e4 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -341,65 +341,6 @@ int gfs2_inode_refresh(struct gfs2_inode *ip)
 	return error;
 }
 
-int gfs2_dinode_dealloc(struct gfs2_inode *ip)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al;
-	struct gfs2_rgrpd *rgd;
-	int error;
-
-	if (gfs2_get_inode_blocks(&ip->i_inode) != 1) {
-		if (gfs2_consist_inode(ip))
-			gfs2_dinode_print(ip);
-		return -EIO;
-	}
-
-	al = gfs2_alloc_get(ip);
-	if (!al)
-		return -ENOMEM;
-
-	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
-	if (error)
-		goto out;
-
-	error = gfs2_rindex_hold(sdp, &al->al_ri_gh);
-	if (error)
-		goto out_qs;
-
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
-	if (!rgd) {
-		gfs2_consist_inode(ip);
-		error = -EIO;
-		goto out_rindex_relse;
-	}
-
-	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0,
-				   &al->al_rgd_gh);
-	if (error)
-		goto out_rindex_relse;
-
-	error = gfs2_trans_begin(sdp, RES_RG_BIT + RES_STATFS + RES_QUOTA, 1);
-	if (error)
-		goto out_rg_gunlock;
-
-	set_bit(GLF_DIRTY, &ip->i_gl->gl_flags);
-	set_bit(GLF_LFLUSH, &ip->i_gl->gl_flags);
-
-	gfs2_free_di(rgd, ip);
-
-	gfs2_trans_end(sdp);
-
-out_rg_gunlock:
-	gfs2_glock_dq_uninit(&al->al_rgd_gh);
-out_rindex_relse:
-	gfs2_glock_dq_uninit(&al->al_ri_gh);
-out_qs:
-	gfs2_quota_unhold(ip);
-out:
-	gfs2_alloc_put(ip);
-	return error;
-}
-
 /**
  * gfs2_change_nlink - Change nlink count on inode
  * @ip: The GFS2 inode
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 099ca30..842346e 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -106,7 +106,6 @@ extern struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr);
 
 extern int gfs2_inode_refresh(struct gfs2_inode *ip);
 
-extern int gfs2_dinode_dealloc(struct gfs2_inode *inode);
 extern int gfs2_change_nlink(struct gfs2_inode *ip, int diff);
 extern struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 				  int is_root);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 611a51d..05bbb12 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -320,12 +320,16 @@ static void buf_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 
 static void revoke_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 {
+	struct gfs2_bufdata *bd = container_of(le, struct gfs2_bufdata, bd_le);
+	struct gfs2_glock *gl = bd->bd_gl;
 	struct gfs2_trans *tr;
 
 	tr = current->journal_info;
 	tr->tr_touched = 1;
 	tr->tr_num_revoke++;
 	sdp->sd_log_num_revoke++;
+	atomic_inc(&gl->gl_revokes);
+	set_bit(GLF_LFLUSH, &gl->gl_flags);
 	list_add(&le->le_list, &sdp->sd_log_le_revoke);
 }
 
@@ -348,9 +352,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	ld->ld_data1 = cpu_to_be32(sdp->sd_log_num_revoke);
 	offset = sizeof(struct gfs2_log_descriptor);
 
-	while (!list_empty(head)) {
-		bd = list_entry(head->next, struct gfs2_bufdata, bd_le.le_list);
-		list_del_init(&bd->bd_le.le_list);
+	list_for_each_entry(bd, head, bd_le.le_list) {
 		sdp->sd_log_num_revoke--;
 
 		if (offset + sizeof(u64) > sdp->sd_sb.sb_bsize) {
@@ -365,8 +367,6 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 		}
 
 		*(__be64 *)(bh->b_data + offset) = cpu_to_be64(bd->bd_blkno);
-		kmem_cache_free(gfs2_bufdata_cachep, bd);
-
 		offset += sizeof(u64);
 	}
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_revoke);
@@ -374,6 +374,22 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	submit_bh(WRITE_SYNC, bh);
 }
 
+static void revoke_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
+{
+	struct list_head *head = &sdp->sd_log_le_revoke;
+	struct gfs2_bufdata *bd;
+	struct gfs2_glock *gl;
+
+	while (!list_empty(head)) {
+		bd = list_entry(head->next, struct gfs2_bufdata, bd_le.le_list);
+		list_del_init(&bd->bd_le.le_list);
+		gl = bd->bd_gl;
+		atomic_dec(&gl->gl_revokes);
+		clear_bit(GLF_LFLUSH, &gl->gl_flags);
+		kmem_cache_free(gfs2_bufdata_cachep, bd);
+	}
+}
+
 static void revoke_lo_before_scan(struct gfs2_jdesc *jd,
 				  struct gfs2_log_header_host *head, int pass)
 {
@@ -747,6 +763,7 @@ const struct gfs2_log_operations gfs2_buf_lops = {
 const struct gfs2_log_operations gfs2_revoke_lops = {
 	.lo_add = revoke_lo_add,
 	.lo_before_commit = revoke_lo_before_commit,
+	.lo_after_commit = revoke_lo_after_commit,
 	.lo_before_scan = revoke_lo_before_scan,
 	.lo_scan_elements = revoke_lo_scan_elements,
 	.lo_after_scan = revoke_lo_after_scan,
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 888a5f5..cfa327d 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -53,6 +53,7 @@ static void gfs2_init_glock_once(void *foo)
 	INIT_LIST_HEAD(&gl->gl_lru);
 	INIT_LIST_HEAD(&gl->gl_ail_list);
 	atomic_set(&gl->gl_ail_count, 0);
+	atomic_set(&gl->gl_revokes, 0);
 }
 
 static void gfs2_init_gl_aspace_once(void *foo)
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index b62c842..215c37b 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1315,6 +1315,78 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	return 0;
 }
 
+static void gfs2_final_release_pages(struct gfs2_inode *ip)
+{
+	struct inode *inode = &ip->i_inode;
+	struct gfs2_glock *gl = ip->i_gl;
+
+	truncate_inode_pages(gfs2_glock2aspace(ip->i_gl), 0);
+	truncate_inode_pages(&inode->i_data, 0);
+
+	if (atomic_read(&gl->gl_revokes) == 0) {
+		clear_bit(GLF_LFLUSH, &gl->gl_flags);
+		clear_bit(GLF_DIRTY, &gl->gl_flags);
+	}
+}
+
+static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	struct gfs2_alloc *al;
+	struct gfs2_rgrpd *rgd;
+	int error;
+
+	if (gfs2_get_inode_blocks(&ip->i_inode) != 1) {
+		if (gfs2_consist_inode(ip))
+			gfs2_dinode_print(ip);
+		return -EIO;
+	}
+
+	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
+
+	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	if (error)
+		goto out;
+
+	error = gfs2_rindex_hold(sdp, &al->al_ri_gh);
+	if (error)
+		goto out_qs;
+
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
+	if (!rgd) {
+		gfs2_consist_inode(ip);
+		error = -EIO;
+		goto out_rindex_relse;
+	}
+
+	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0,
+				   &al->al_rgd_gh);
+	if (error)
+		goto out_rindex_relse;
+
+	error = gfs2_trans_begin(sdp, RES_RG_BIT + RES_STATFS + RES_QUOTA, 1);
+	if (error)
+		goto out_rg_gunlock;
+
+	gfs2_free_di(rgd, ip);
+
+	gfs2_final_release_pages(ip);
+
+	gfs2_trans_end(sdp);
+
+out_rg_gunlock:
+	gfs2_glock_dq_uninit(&al->al_rgd_gh);
+out_rindex_relse:
+	gfs2_glock_dq_uninit(&al->al_ri_gh);
+out_qs:
+	gfs2_quota_unhold(ip);
+out:
+	gfs2_alloc_put(ip);
+	return error;
+}
+
 /*
  * We have to (at the moment) hold the inodes main lock to cover
  * the gap between unlocking the shared lock on the iopen lock and
@@ -1378,15 +1450,13 @@ static void gfs2_evict_inode(struct inode *inode)
 	}
 
 	error = gfs2_dinode_dealloc(ip);
-	if (error)
-		goto out_unlock;
+	goto out_unlock;
 
 out_truncate:
 	error = gfs2_trans_begin(sdp, 0, sdp->sd_jdesc->jd_blocks);
 	if (error)
 		goto out_unlock;
-	/* Needs to be done before glock release & also in a transaction */
-	truncate_inode_pages(&inode->i_data, 0);
+	gfs2_final_release_pages(ip);
 	gfs2_trans_end(sdp);
 
 out_unlock:
-- 
1.7.4

