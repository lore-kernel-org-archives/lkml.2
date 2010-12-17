Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0LQMqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab0LQMqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:24 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 13/15] GFS2: Merge glock state fields into a bitfield
Date: Fri, 17 Dec 2010 12:24:19 +0000
Message-Id: <1292588661-14350-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can only merge the fields into a bitfield if the locking
rules for them are the same. In this case gl_spin covers all
of the fields (write side) but a couple of them are used
with GLF_LOCK as the read side lock, which should be ok
since we know that the field in question won't be changing
at the time.

The gl_req setting has to be done earlier (in glock.c) in order
to place it under gl_spin. The gl_reply setting also has to be
brought under gl_spin in order to comply with the new rules.

This saves 4*sizeof(unsigned int) per glock.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 2dd1d72..08a8beb 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -567,6 +567,7 @@ __acquires(&gl->gl_spin)
 		set_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
 		do_error(gl, 0); /* Fail queued try locks */
 	}
+	gl->gl_req = target;
 	spin_unlock(&gl->gl_spin);
 	if (glops->go_xmote_th)
 		glops->go_xmote_th(gl);
@@ -1353,24 +1354,28 @@ static int gfs2_should_freeze(const struct gfs2_glock *gl)
  * @gl: Pointer to the glock
  * @ret: The return value from the dlm
  *
+ * The gl_reply field is under the gl_spin lock so that it is ok
+ * to use a bitfield shared with other glock state fields.
  */
 
 void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 {
 	struct lm_lockstruct *ls = &gl->gl_sbd->sd_lockstruct;
 
+	spin_lock(&gl->gl_spin);
 	gl->gl_reply = ret;
 
 	if (unlikely(test_bit(DFL_BLOCK_LOCKS, &ls->ls_flags))) {
-		spin_lock(&gl->gl_spin);
 		if (gfs2_should_freeze(gl)) {
 			set_bit(GLF_FROZEN, &gl->gl_flags);
 			spin_unlock(&gl->gl_spin);
 			return;
 		}
-		spin_unlock(&gl->gl_spin);
 	}
+
+	spin_unlock(&gl->gl_spin);
 	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
+	smp_wmb();
 	gfs2_glock_hold(gl);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 		gfs2_glock_put(gl);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 764fbb4..8d3d2b4 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -207,12 +207,14 @@ struct gfs2_glock {
 
 	spinlock_t gl_spin;
 
-	unsigned int gl_state;
-	unsigned int gl_target;
-	unsigned int gl_reply;
+	/* State fields protected by gl_spin */
+	unsigned int gl_state:2,	/* Current state */
+		     gl_target:2,	/* Target state */
+		     gl_demote_state:2,	/* State requested by remote node */
+		     gl_req:2,		/* State in last dlm request */
+		     gl_reply:8;	/* Last reply from the dlm */
+
 	unsigned int gl_hash;
-	unsigned int gl_req;
-	unsigned int gl_demote_state; /* state requested by remote node */
 	unsigned long gl_demote_time; /* time of first demote request */
 	struct list_head gl_holders;
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index f40ce34..6e493ae 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -153,7 +153,6 @@ static int gdlm_lock(struct gfs2_glock *gl, unsigned int req_state,
 	int req;
 	u32 lkf;
 
-	gl->gl_req = req_state;
 	req = make_mode(req_state);
 	lkf = make_flags(gl->gl_lksb.sb_lkid, flags, req);
 
-- 
1.7.3.3

