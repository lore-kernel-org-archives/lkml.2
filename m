Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0LQMqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab0LQMqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:16 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/15] GFS2: Clean up of gdlm_lock function
Date: Fri, 17 Dec 2010 12:24:14 +0000
Message-Id: <1292588661-14350-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DLM never returns -EAGAIN in response to dlm_lock(), and even
if it did, the test in gdlm_lock() was wrong anyway. Once that
test is removed, it is possible to greatly simplify this code
by simply using a "normal" error return code (0 for success).

We then no longer need the LM_OUT_ASYNC return code which can
be removed.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index a9b53a4..2dd1d72 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -541,21 +541,6 @@ out_locked:
 	spin_unlock(&gl->gl_spin);
 }
 
-static unsigned int gfs2_lm_lock(struct gfs2_sbd *sdp, void *lock,
-				 unsigned int req_state,
-				 unsigned int flags)
-{
-	int ret = LM_OUT_ERROR;
-
-	if (!sdp->sd_lockstruct.ls_ops->lm_lock)
-		return req_state == LM_ST_UNLOCKED ? 0 : req_state;
-
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		ret = sdp->sd_lockstruct.ls_ops->lm_lock(lock,
-							 req_state, flags);
-	return ret;
-}
-
 /**
  * do_xmote - Calls the DLM to change the state of a lock
  * @gl: The lock state
@@ -575,8 +560,8 @@ __acquires(&gl->gl_spin)
 
 	lck_flags &= (LM_FLAG_TRY | LM_FLAG_TRY_1CB | LM_FLAG_NOEXP |
 		      LM_FLAG_PRIORITY);
-	BUG_ON(gl->gl_state == target);
-	BUG_ON(gl->gl_state == gl->gl_target);
+	GLOCK_BUG_ON(gl, gl->gl_state == target);
+	GLOCK_BUG_ON(gl, gl->gl_state == gl->gl_target);
 	if ((target == LM_ST_UNLOCKED || target == LM_ST_DEFERRED) &&
 	    glops->go_inval) {
 		set_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
@@ -594,15 +579,17 @@ __acquires(&gl->gl_spin)
 	    gl->gl_state == LM_ST_DEFERRED) &&
 	    !(lck_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
 		lck_flags |= LM_FLAG_TRY_1CB;
-	ret = gfs2_lm_lock(sdp, gl, target, lck_flags);
 
-	if (!(ret & LM_OUT_ASYNC)) {
-		finish_xmote(gl, ret);
+	if (sdp->sd_lockstruct.ls_ops->lm_lock)	{
+		/* lock_dlm */
+		ret = sdp->sd_lockstruct.ls_ops->lm_lock(gl, target, lck_flags);
+		GLOCK_BUG_ON(gl, ret);
+	} else { /* lock_nolock */
+		finish_xmote(gl, target);
 		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 			gfs2_glock_put(gl);
-	} else {
-		GLOCK_BUG_ON(gl, ret != LM_OUT_ASYNC);
 	}
+
 	spin_lock(&gl->gl_spin);
 }
 
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index a12d117..ba6865c 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -91,7 +91,7 @@ enum {
 #define GL_NOCACHE		0x00000400
   
 /*
- * lm_lock() and lm_async_cb return flags
+ * lm_async_cb return flags
  *
  * LM_OUT_ST_MASK
  * Masks the lower two bits of lock state in the returned value.
@@ -99,15 +99,11 @@ enum {
  * LM_OUT_CANCELED
  * The lock request was canceled.
  *
- * LM_OUT_ASYNC
- * The result of the request will be returned in an LM_CB_ASYNC callback.
- *
  */
 
 #define LM_OUT_ST_MASK		0x00000003
 #define LM_OUT_CANCELED		0x00000008
-#define LM_OUT_ASYNC		0x00000080
-#define LM_OUT_ERROR		0x00000100
+#define LM_OUT_ERROR		0x00000004
 
 /*
  * lm_recovery_done() messages
@@ -124,8 +120,8 @@ struct lm_lockops {
  	void (*lm_unmount) (struct gfs2_sbd *sdp);
 	void (*lm_withdraw) (struct gfs2_sbd *sdp);
 	void (*lm_put_lock) (struct kmem_cache *cachep, struct gfs2_glock *gl);
-	unsigned int (*lm_lock) (struct gfs2_glock *gl,
-				 unsigned int req_state, unsigned int flags);
+	int (*lm_lock) (struct gfs2_glock *gl, unsigned int req_state,
+			unsigned int flags);
 	void (*lm_cancel) (struct gfs2_glock *gl);
 	const match_table_t *lm_tokens;
 };
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 1c09425..f40ce34 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -146,11 +146,10 @@ static u32 make_flags(const u32 lkid, const unsigned int gfs_flags,
 	return lkf;
 }
 
-static unsigned int gdlm_lock(struct gfs2_glock *gl,
-			      unsigned int req_state, unsigned int flags)
+static int gdlm_lock(struct gfs2_glock *gl, unsigned int req_state,
+		     unsigned int flags)
 {
 	struct lm_lockstruct *ls = &gl->gl_sbd->sd_lockstruct;
-	int error;
 	int req;
 	u32 lkf;
 
@@ -162,13 +161,8 @@ static unsigned int gdlm_lock(struct gfs2_glock *gl,
 	 * Submit the actual lock request.
 	 */
 
-	error = dlm_lock(ls->ls_dlm, req, &gl->gl_lksb, lkf, gl->gl_strname,
-			 GDLM_STRNAME_BYTES - 1, 0, gdlm_ast, gl, gdlm_bast);
-	if (error == -EAGAIN)
-		return 0;
-	if (error)
-		return LM_OUT_ERROR;
-	return LM_OUT_ASYNC;
+	return dlm_lock(ls->ls_dlm, req, &gl->gl_lksb, lkf, gl->gl_strname,
+			GDLM_STRNAME_BYTES - 1, 0, gdlm_ast, gl, gdlm_bast);
 }
 
 static void gdlm_put_lock(struct kmem_cache *cachep, struct gfs2_glock *gl)
-- 
1.7.3.3

