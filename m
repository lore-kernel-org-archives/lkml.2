Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab2K3KSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:18:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab2K3KSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:34 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/16] GFS2: skip dlm_unlock calls in unmount
Date: Fri, 30 Nov 2012 09:52:16 +0000
Message-Id: <1354269141-3311-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

When unmounting, gfs2 does a full dlm_unlock operation on every
cached lock.  This can create a very large amount of work and can
take a long time to complete.  However, the vast majority of these
dlm unlock operations are unnecessary because after all the unlocks
are done, gfs2 leaves the dlm lockspace, which automatically clears
the locks of the leaving node, without unlocking each one individually.
So, gfs2 can skip explicit dlm unlocks, and use dlm_release_lockspace to
remove the locks implicitly.  The one exception is when the lock's lvb is
being used.  In this case, dlm_unlock is called because it may update the
lvb of the resource.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 6114571..9d29a51 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1526,6 +1526,7 @@ static void dump_glock_func(struct gfs2_glock *gl)
 
 void gfs2_gl_hash_clear(struct gfs2_sbd *sdp)
 {
+	set_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags);
 	glock_hash_walk(clear_glock, sdp);
 	flush_workqueue(glock_workqueue);
 	wait_event(sdp->sd_glock_wait, atomic_read(&sdp->sd_glock_disposal) == 0);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index a46f034..a35ef5c 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -539,6 +539,7 @@ enum {
 	SDF_DEMOTE		= 5,
 	SDF_NOJOURNALID		= 6,
 	SDF_RORECOVERY		= 7, /* read only recovery */
+	SDF_SKIP_DLM_UNLOCK	= 8,
 };
 
 #define GFS2_FSNAME_LEN		256
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 0fb6539..f6504d3 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -289,6 +289,14 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 	gfs2_glstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_update_request_times(gl);
+
+	/* don't want to skip dlm_unlock writing the lvb when lock is ex */
+	if (test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags) &&
+	    gl->gl_state != LM_ST_EXCLUSIVE) {
+		gfs2_glock_free(gl);
+		return;
+	}
+
 	error = dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, DLM_LKF_VALBLK,
 			   NULL, gl);
 	if (error) {
-- 
1.7.4

