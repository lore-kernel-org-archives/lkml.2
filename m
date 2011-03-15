Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab1COJfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab1COJeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:13 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/15] GFS2: Fix glock deallocation race
Date: Tue, 15 Mar 2011 09:11:38 +0000
Message-Id: <1300180305-5993-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a race in deallocating glocks which was introduced
in the RCU glock patch. We need to ensure that the glock count is
kept correct even in the case that there is a race to add a new
glock into the hash table. Also, to avoid having to wait for an
RCU grace period, the glock counter can be decremented before
call_rcu() is called.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ddc3e1e..3f45a14 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -103,16 +103,21 @@ static inline void spin_unlock_bucket(unsigned int hash)
 	__bit_spin_unlock(0, (unsigned long *)bl);
 }
 
-void gfs2_glock_free(struct rcu_head *rcu)
+static void gfs2_glock_dealloc(struct rcu_head *rcu)
 {
 	struct gfs2_glock *gl = container_of(rcu, struct gfs2_glock, gl_rcu);
-	struct gfs2_sbd *sdp = gl->gl_sbd;
 
 	if (gl->gl_ops->go_flags & GLOF_ASPACE)
 		kmem_cache_free(gfs2_glock_aspace_cachep, gl);
 	else
 		kmem_cache_free(gfs2_glock_cachep, gl);
+}
+
+void gfs2_glock_free(struct gfs2_glock *gl)
+{
+	struct gfs2_sbd *sdp = gl->gl_sbd;
 
+	call_rcu(&gl->gl_rcu, gfs2_glock_dealloc);
 	if (atomic_dec_and_test(&sdp->sd_glock_disposal))
 		wake_up(&sdp->sd_glock_wait);
 }
@@ -760,6 +765,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	if (tmp) {
 		spin_unlock_bucket(hash);
 		kmem_cache_free(cachep, gl);
+		atomic_dec(&sdp->sd_glock_disposal);
 		gl = tmp;
 	} else {
 		hlist_bl_add_head_rcu(&gl->gl_list, &gl_hash_table[hash]);
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index afa8bfe..aea1606 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -230,7 +230,7 @@ extern void gfs2_gl_hash_clear(struct gfs2_sbd *sdp);
 extern void gfs2_glock_finish_truncate(struct gfs2_inode *ip);
 extern void gfs2_glock_thaw(struct gfs2_sbd *sdp);
 extern void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl);
-extern void gfs2_glock_free(struct rcu_head *rcu);
+extern void gfs2_glock_free(struct gfs2_glock *gl);
 
 extern int __init gfs2_glock_init(void);
 extern void gfs2_glock_exit(void);
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index c80485c..98c80d8 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -30,7 +30,7 @@ static void gdlm_ast(void *arg)
 
 	switch (gl->gl_lksb.sb_status) {
 	case -DLM_EUNLOCK: /* Unlocked, so glock can be freed */
-		call_rcu(&gl->gl_rcu, gfs2_glock_free);
+		gfs2_glock_free(gl);
 		return;
 	case -DLM_ECANCEL: /* Cancel while getting lock */
 		ret |= LM_OUT_CANCELED;
@@ -165,7 +165,7 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 	int error;
 
 	if (gl->gl_lksb.sb_lkid == 0) {
-		call_rcu(&gl->gl_rcu, gfs2_glock_free);
+		gfs2_glock_free(gl);
 		return;
 	}
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index a39c103..67654d0 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -928,14 +928,9 @@ static const match_table_t nolock_tokens = {
 	{ Opt_err, NULL },
 };
 
-static void nolock_put_lock(struct gfs2_glock *gl)
-{
-	call_rcu(&gl->gl_rcu, gfs2_glock_free);
-}
-
 static const struct lm_lockops nolock_ops = {
 	.lm_proto_name = "lock_nolock",
-	.lm_put_lock = nolock_put_lock,
+	.lm_put_lock = gfs2_glock_free,
 	.lm_tokens = &nolock_tokens,
 };
 
-- 
1.7.4

