Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0HBJtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:49:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab0HBJtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:49:19 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 8/8] GFS2: Fix recovery stuck bug (try #2)
Date: Mon,  2 Aug 2010 10:27:59 +0100
Message-Id: <1280741279-6782-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
References: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a clean up of the code which deals with LM_FLAG_NOEXP
which aims to remove any possible race conditions by using
gl_spin to cover the gap between testing for the LM_FLAG_NOEXP
and the GL_FROZEN flag.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 2b3d8f8..9adf8f9 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1063,6 +1063,9 @@ int gfs2_glock_nq(struct gfs2_holder *gh)
 
 	spin_lock(&gl->gl_spin);
 	add_to_queue(gh);
+	if ((LM_FLAG_NOEXP & gh->gh_flags) &&
+	    test_and_clear_bit(GLF_FROZEN, &gl->gl_flags))
+		set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
 	run_queue(gl, 1);
 	spin_unlock(&gl->gl_spin);
 
@@ -1320,6 +1323,36 @@ void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 }
 
 /**
+ * gfs2_should_freeze - Figure out if glock should be frozen
+ * @gl: The glock in question
+ *
+ * Glocks are not frozen if (a) the result of the dlm operation is
+ * an error, (b) the locking operation was an unlock operation or
+ * (c) if there is a "noexp" flagged request anywhere in the queue
+ *
+ * Returns: 1 if freezing should occur, 0 otherwise
+ */
+
+static int gfs2_should_freeze(const struct gfs2_glock *gl)
+{
+	const struct gfs2_holder *gh;
+
+	if (gl->gl_reply & ~LM_OUT_ST_MASK)
+		return 0;
+	if (gl->gl_target == LM_ST_UNLOCKED)
+		return 0;
+
+	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
+		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+			continue;
+		if (LM_FLAG_NOEXP & gh->gh_flags)
+			return 0;
+	}
+
+	return 1;
+}
+
+/**
  * gfs2_glock_complete - Callback used by locking
  * @gl: Pointer to the glock
  * @ret: The return value from the dlm
@@ -1329,18 +1362,17 @@ void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 {
 	struct lm_lockstruct *ls = &gl->gl_sbd->sd_lockstruct;
+
 	gl->gl_reply = ret;
+
 	if (unlikely(test_bit(DFL_BLOCK_LOCKS, &ls->ls_flags))) {
-		struct gfs2_holder *gh;
 		spin_lock(&gl->gl_spin);
-		gh = find_first_waiter(gl);
-		if ((!(gh && (gh->gh_flags & LM_FLAG_NOEXP)) &&
-		     (gl->gl_target != LM_ST_UNLOCKED)) ||
-		    ((ret & ~LM_OUT_ST_MASK) != 0))
+		if (gfs2_should_freeze(gl)) {
 			set_bit(GLF_FROZEN, &gl->gl_flags);
-		spin_unlock(&gl->gl_spin);
-		if (test_bit(GLF_FROZEN, &gl->gl_flags))
+			spin_unlock(&gl->gl_spin);
 			return;
+		}
+		spin_unlock(&gl->gl_spin);
 	}
 	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
 	gfs2_glock_hold(gl);
-- 
1.7.1.1

