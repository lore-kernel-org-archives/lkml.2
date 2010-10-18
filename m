Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab0JROir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab0JROhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:52 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/22] GFS2: Fix spectator umount issue
Date: Mon, 18 Oct 2010 15:15:41 +0100
Message-Id: <1287411346-17855-18-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tests further down the recovery function relating to
unlocking the journal need to be updated to match the
intial test. Also, a test in the umount code which was
surplus to requirements has been removed. Umounting
spectator mounts now works correctly, as expected.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c3f2a5c..8777885 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1517,7 +1517,7 @@ static void clear_glock(struct gfs2_glock *gl)
 	spin_unlock(&lru_lock);
 
 	spin_lock(&gl->gl_spin);
-	if (find_first_holder(gl) == NULL && gl->gl_state != LM_ST_UNLOCKED)
+	if (gl->gl_state != LM_ST_UNLOCKED)
 		handle_callback(gl, LM_ST_UNLOCKED, 0);
 	spin_unlock(&gl->gl_spin);
 	gfs2_glock_hold(gl);
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 666548e..f2a02ed 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -455,12 +455,13 @@ void gfs2_recover_func(struct work_struct *work)
 	int ro = 0;
 	unsigned int pass;
 	int error;
+	int jlocked = 0;
 
 	if (sdp->sd_args.ar_spectator ||
 	    (jd->jd_jid != sdp->sd_lockstruct.ls_jid)) {
 		fs_info(sdp, "jid=%u: Trying to acquire journal lock...\n",
 			jd->jd_jid);
-
+		jlocked = 1;
 		/* Acquire the journal lock so we can do recovery */
 
 		error = gfs2_glock_nq_num(sdp, jd->jd_jid, &gfs2_journal_glops,
@@ -555,13 +556,12 @@ void gfs2_recover_func(struct work_struct *work)
 			jd->jd_jid, t);
 	}
 
-	if (jd->jd_jid != sdp->sd_lockstruct.ls_jid)
-		gfs2_glock_dq_uninit(&ji_gh);
-
 	gfs2_recovery_done(sdp, jd->jd_jid, LM_RD_SUCCESS);
 
-	if (jd->jd_jid != sdp->sd_lockstruct.ls_jid)
+	if (jlocked) {
+		gfs2_glock_dq_uninit(&ji_gh);
 		gfs2_glock_dq_uninit(&j_gh);
+	}
 
 	fs_info(sdp, "jid=%u: Done\n", jd->jd_jid);
 	goto done;
@@ -569,7 +569,7 @@ void gfs2_recover_func(struct work_struct *work)
 fail_gunlock_tr:
 	gfs2_glock_dq_uninit(&t_gh);
 fail_gunlock_ji:
-	if (jd->jd_jid != sdp->sd_lockstruct.ls_jid) {
+	if (jlocked) {
 		gfs2_glock_dq_uninit(&ji_gh);
 fail_gunlock_j:
 		gfs2_glock_dq_uninit(&j_gh);
-- 
1.7.1.1

