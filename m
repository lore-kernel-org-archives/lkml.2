Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab2K3KSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:18:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab2K3KSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:36 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/16] GFS2: only use lvb on glocks that need it
Date: Fri, 30 Nov 2012 09:52:17 +0000
Message-Id: <1354269141-3311-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Save the effort of allocating, reading and writing
the lvb for most glocks that do not use it.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 9d29a51..2284de4 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -105,10 +105,12 @@ static void gfs2_glock_dealloc(struct rcu_head *rcu)
 {
 	struct gfs2_glock *gl = container_of(rcu, struct gfs2_glock, gl_rcu);
 
-	if (gl->gl_ops->go_flags & GLOF_ASPACE)
+	if (gl->gl_ops->go_flags & GLOF_ASPACE) {
 		kmem_cache_free(gfs2_glock_aspace_cachep, gl);
-	else
+	} else {
+		kfree(gl->gl_lvb);
 		kmem_cache_free(gfs2_glock_cachep, gl);
+	}
 }
 
 void gfs2_glock_free(struct gfs2_glock *gl)
@@ -545,7 +547,10 @@ __acquires(&gl->gl_spin)
 	if (sdp->sd_lockstruct.ls_ops->lm_lock)	{
 		/* lock_dlm */
 		ret = sdp->sd_lockstruct.ls_ops->lm_lock(gl, target, lck_flags);
-		GLOCK_BUG_ON(gl, ret);
+		if (ret) {
+			printk(KERN_ERR "GFS2: lm_lock ret %d\n", ret);
+			GLOCK_BUG_ON(gl, 1);
+		}
 	} else { /* lock_nolock */
 		finish_xmote(gl, target);
 		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
@@ -734,6 +739,18 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	if (!gl)
 		return -ENOMEM;
 
+	memset(&gl->gl_lksb, 0, sizeof(struct dlm_lksb));
+	gl->gl_lvb = NULL;
+
+	if (glops->go_flags & GLOF_LVB) {
+		gl->gl_lvb = kzalloc(GFS2_MIN_LVB_SIZE, GFP_KERNEL);
+		if (!gl->gl_lvb) {
+			kmem_cache_free(cachep, gl);
+			return -ENOMEM;
+		}
+		gl->gl_lksb.sb_lvbptr = gl->gl_lvb;
+	}
+
 	atomic_inc(&sdp->sd_glock_disposal);
 	gl->gl_sbd = sdp;
 	gl->gl_flags = 0;
@@ -751,9 +768,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	preempt_enable();
 	gl->gl_stats.stats[GFS2_LKS_DCOUNT] = 0;
 	gl->gl_stats.stats[GFS2_LKS_QCOUNT] = 0;
-	memset(&gl->gl_lksb, 0, sizeof(struct dlm_lksb));
-	memset(gl->gl_lvb, 0, 32 * sizeof(char));
-	gl->gl_lksb.sb_lvbptr = gl->gl_lvb;
 	gl->gl_tchange = jiffies;
 	gl->gl_object = NULL;
 	gl->gl_hold_time = GL_GLOCK_DFT_HOLD;
@@ -775,6 +789,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	tmp = search_bucket(hash, sdp, &name);
 	if (tmp) {
 		spin_unlock_bucket(hash);
+		kfree(gl->gl_lvb);
 		kmem_cache_free(cachep, gl);
 		atomic_dec(&sdp->sd_glock_disposal);
 		gl = tmp;
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index e86fe26..78d4184 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -552,7 +552,7 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_unlock = gfs2_rgrp_go_unlock,
 	.go_dump = gfs2_rgrp_dump,
 	.go_type = LM_TYPE_RGRP,
-	.go_flags = GLOF_ASPACE,
+	.go_flags = GLOF_ASPACE | GLOF_LVB,
 };
 
 const struct gfs2_glock_operations gfs2_trans_glops = {
@@ -577,6 +577,7 @@ const struct gfs2_glock_operations gfs2_nondisk_glops = {
 
 const struct gfs2_glock_operations gfs2_quota_glops = {
 	.go_type = LM_TYPE_QUOTA,
+	.go_flags = GLOF_LVB,
 };
 
 const struct gfs2_glock_operations gfs2_journal_glops = {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index a35ef5c..bd577fc 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -216,6 +216,7 @@ struct gfs2_glock_operations {
 	const int go_type;
 	const unsigned long go_flags;
 #define GLOF_ASPACE 1
+#define GLOF_LVB    2
 };
 
 enum {
@@ -321,7 +322,7 @@ struct gfs2_glock {
 	ktime_t gl_dstamp;
 	struct gfs2_lkstats gl_stats;
 	struct dlm_lksb gl_lksb;
-	char gl_lvb[32];
+	char *gl_lvb;
 	unsigned long gl_tchange;
 	void *gl_object;
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index f6504d3..d28ae37 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -120,7 +120,7 @@ static void gdlm_ast(void *arg)
 	gfs2_update_reply_times(gl);
 	BUG_ON(gl->gl_lksb.sb_flags & DLM_SBF_DEMOTED);
 
-	if (gl->gl_lksb.sb_flags & DLM_SBF_VALNOTVALID)
+	if (gl->gl_lksb.sb_flags & DLM_SBF_VALNOTVALID && gl->gl_lvb)
 		memset(gl->gl_lvb, 0, GDLM_LVB_SIZE);
 
 	switch (gl->gl_lksb.sb_status) {
@@ -203,8 +203,10 @@ static int make_mode(const unsigned int lmstate)
 static u32 make_flags(struct gfs2_glock *gl, const unsigned int gfs_flags,
 		      const int req)
 {
-	u32 lkf = DLM_LKF_VALBLK;
-	u32 lkid = gl->gl_lksb.sb_lkid;
+	u32 lkf = 0;
+
+	if (gl->gl_lvb)
+		lkf |= DLM_LKF_VALBLK;
 
 	if (gfs_flags & LM_FLAG_TRY)
 		lkf |= DLM_LKF_NOQUEUE;
@@ -228,7 +230,7 @@ static u32 make_flags(struct gfs2_glock *gl, const unsigned int gfs_flags,
 			BUG();
 	}
 
-	if (lkid != 0) {
+	if (gl->gl_lksb.sb_lkid != 0) {
 		lkf |= DLM_LKF_CONVERT;
 		if (test_bit(GLF_BLOCKING, &gl->gl_flags))
 			lkf |= DLM_LKF_QUECVT;
@@ -292,7 +294,7 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 
 	/* don't want to skip dlm_unlock writing the lvb when lock is ex */
 	if (test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags) &&
-	    gl->gl_state != LM_ST_EXCLUSIVE) {
+	    gl->gl_lvb && gl->gl_state != LM_ST_EXCLUSIVE) {
 		gfs2_glock_free(gl);
 		return;
 	}
-- 
1.7.4

