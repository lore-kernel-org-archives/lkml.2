Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab2K3KVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:21:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab2K3KSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:37 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/16] GFS2: remove redundant lvb pointer
Date: Fri, 30 Nov 2012 09:52:18 +0000
Message-Id: <1354269141-3311-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

The lksb struct already contains a pointer to the lvb,
so another directly from the glock struct is not needed.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 2284de4..274b6be 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -108,7 +108,7 @@ static void gfs2_glock_dealloc(struct rcu_head *rcu)
 	if (gl->gl_ops->go_flags & GLOF_ASPACE) {
 		kmem_cache_free(gfs2_glock_aspace_cachep, gl);
 	} else {
-		kfree(gl->gl_lvb);
+		kfree(gl->gl_lksb.sb_lvbptr);
 		kmem_cache_free(gfs2_glock_cachep, gl);
 	}
 }
@@ -740,15 +740,13 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		return -ENOMEM;
 
 	memset(&gl->gl_lksb, 0, sizeof(struct dlm_lksb));
-	gl->gl_lvb = NULL;
 
 	if (glops->go_flags & GLOF_LVB) {
-		gl->gl_lvb = kzalloc(GFS2_MIN_LVB_SIZE, GFP_KERNEL);
-		if (!gl->gl_lvb) {
+		gl->gl_lksb.sb_lvbptr = kzalloc(GFS2_MIN_LVB_SIZE, GFP_KERNEL);
+		if (!gl->gl_lksb.sb_lvbptr) {
 			kmem_cache_free(cachep, gl);
 			return -ENOMEM;
 		}
-		gl->gl_lksb.sb_lvbptr = gl->gl_lvb;
 	}
 
 	atomic_inc(&sdp->sd_glock_disposal);
@@ -789,7 +787,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	tmp = search_bucket(hash, sdp, &name);
 	if (tmp) {
 		spin_unlock_bucket(hash);
-		kfree(gl->gl_lvb);
+		kfree(gl->gl_lksb.sb_lvbptr);
 		kmem_cache_free(cachep, gl);
 		atomic_dec(&sdp->sd_glock_disposal);
 		gl = tmp;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index bd577fc..c373a24 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -322,7 +322,6 @@ struct gfs2_glock {
 	ktime_t gl_dstamp;
 	struct gfs2_lkstats gl_stats;
 	struct dlm_lksb gl_lksb;
-	char *gl_lvb;
 	unsigned long gl_tchange;
 	void *gl_object;
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index d28ae37..8dad6b0 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -120,8 +120,8 @@ static void gdlm_ast(void *arg)
 	gfs2_update_reply_times(gl);
 	BUG_ON(gl->gl_lksb.sb_flags & DLM_SBF_DEMOTED);
 
-	if (gl->gl_lksb.sb_flags & DLM_SBF_VALNOTVALID && gl->gl_lvb)
-		memset(gl->gl_lvb, 0, GDLM_LVB_SIZE);
+	if ((gl->gl_lksb.sb_flags & DLM_SBF_VALNOTVALID) && gl->gl_lksb.sb_lvbptr)
+		memset(gl->gl_lksb.sb_lvbptr, 0, GDLM_LVB_SIZE);
 
 	switch (gl->gl_lksb.sb_status) {
 	case -DLM_EUNLOCK: /* Unlocked, so glock can be freed */
@@ -205,7 +205,7 @@ static u32 make_flags(struct gfs2_glock *gl, const unsigned int gfs_flags,
 {
 	u32 lkf = 0;
 
-	if (gl->gl_lvb)
+	if (gl->gl_lksb.sb_lvbptr)
 		lkf |= DLM_LKF_VALBLK;
 
 	if (gfs_flags & LM_FLAG_TRY)
@@ -294,7 +294,7 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 
 	/* don't want to skip dlm_unlock writing the lvb when lock is ex */
 	if (test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags) &&
-	    gl->gl_lvb && gl->gl_state != LM_ST_EXCLUSIVE) {
+	    gl->gl_lksb.sb_lvbptr && (gl->gl_state != LM_ST_EXCLUSIVE)) {
 		gfs2_glock_free(gl);
 		return;
 	}
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 6bbf64f..ae55e24 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -869,7 +869,7 @@ static int update_qd(struct gfs2_sbd *sdp, struct gfs2_quota_data *qd)
 	if (error < 0)
 		return error;
 
-	qlvb = (struct gfs2_quota_lvb *)qd->qd_gl->gl_lvb;
+	qlvb = (struct gfs2_quota_lvb *)qd->qd_gl->gl_lksb.sb_lvbptr;
 	qlvb->qb_magic = cpu_to_be32(GFS2_MAGIC);
 	qlvb->__pad = 0;
 	qlvb->qb_limit = q.qu_limit;
@@ -893,7 +893,7 @@ restart:
 	if (error)
 		return error;
 
-	qd->qd_qb = *(struct gfs2_quota_lvb *)qd->qd_gl->gl_lvb;
+	qd->qd_qb = *(struct gfs2_quota_lvb *)qd->qd_gl->gl_lksb.sb_lvbptr;
 
 	if (force_refresh || qd->qd_qb.qb_magic != cpu_to_be32(GFS2_MAGIC)) {
 		gfs2_glock_dq_uninit(q_gh);
@@ -1506,7 +1506,7 @@ static int gfs2_get_dqblk(struct super_block *sb, struct kqid qid,
 	if (error)
 		goto out;
 
-	qlvb = (struct gfs2_quota_lvb *)qd->qd_gl->gl_lvb;
+	qlvb = (struct gfs2_quota_lvb *)qd->qd_gl->gl_lksb.sb_lvbptr;
 	fdq->d_version = FS_DQUOT_VERSION;
 	fdq->d_flags = (type == QUOTA_USER) ? FS_USER_QUOTA : FS_GROUP_QUOTA;
 	fdq->d_id = from_kqid(&init_user_ns, qid);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 5625e93..37ee061 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -879,7 +879,7 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 		goto fail;
 
 	rgd->rd_gl->gl_object = rgd;
-	rgd->rd_rgl = (struct gfs2_rgrp_lvb *)rgd->rd_gl->gl_lvb;
+	rgd->rd_rgl = (struct gfs2_rgrp_lvb *)rgd->rd_gl->gl_lksb.sb_lvbptr;
 	rgd->rd_flags &= ~GFS2_RDF_UPTODATE;
 	if (rgd->rd_data > sdp->sd_max_rg_data)
 		sdp->sd_max_rg_data = rgd->rd_data;
-- 
1.7.4

