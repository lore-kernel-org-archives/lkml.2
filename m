Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1GVJkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:40:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab1GVJjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:39:42 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/4] GFS2: Automatically adjust glock min hold time
Date: Fri, 22 Jul 2011 10:16:52 +0100
Message-Id: <1311326214-3325-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1311326214-3325-1-git-send-email-swhiteho@redhat.com>
References: <1311326214-3325-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch is a performance improvement for GFS2 in a clustered
environment. It makes the glock hold time self-adjusting.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 1c1336e..88e8a23 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -409,6 +409,10 @@ static void state_change(struct gfs2_glock *gl, unsigned int new_state)
 	if (held1 && held2 && list_empty(&gl->gl_holders))
 		clear_bit(GLF_QUEUED, &gl->gl_flags);
 
+	if (new_state != gl->gl_target)
+		/* shorten our minimum hold time */
+		gl->gl_hold_time = max(gl->gl_hold_time - GL_GLOCK_HOLD_DECR,
+				       GL_GLOCK_MIN_HOLD);
 	gl->gl_state = new_state;
 	gl->gl_tchange = jiffies;
 }
@@ -668,7 +672,7 @@ static void glock_work_func(struct work_struct *work)
 	    gl->gl_demote_state != LM_ST_EXCLUSIVE) {
 		unsigned long holdtime, now = jiffies;
 
-		holdtime = gl->gl_tchange + gl->gl_ops->go_min_hold_time;
+		holdtime = gl->gl_tchange + gl->gl_hold_time;
 		if (time_before(now, holdtime))
 			delay = holdtime - now;
 
@@ -679,9 +683,14 @@ static void glock_work_func(struct work_struct *work)
 	}
 	run_queue(gl, 0);
 	spin_unlock(&gl->gl_spin);
-	if (!delay ||
-	    queue_delayed_work(glock_workqueue, &gl->gl_work, delay) == 0)
+	if (!delay)
 		gfs2_glock_put(gl);
+	else {
+		if (gl->gl_name.ln_type != LM_TYPE_INODE)
+			delay = 0;
+		if (queue_delayed_work(glock_workqueue, &gl->gl_work, delay) == 0)
+			gfs2_glock_put(gl);
+	}
 	if (drop_ref)
 		gfs2_glock_put(gl);
 }
@@ -743,6 +752,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_tchange = jiffies;
 	gl->gl_object = NULL;
 	gl->gl_sbd = sdp;
+	gl->gl_hold_time = GL_GLOCK_DFT_HOLD;
 	INIT_DELAYED_WORK(&gl->gl_work, glock_work_func);
 	INIT_WORK(&gl->gl_delete, delete_work_func);
 
@@ -855,8 +865,15 @@ static int gfs2_glock_demote_wait(void *word)
 
 static void wait_on_holder(struct gfs2_holder *gh)
 {
+	unsigned long time1 = jiffies;
+
 	might_sleep();
 	wait_on_bit(&gh->gh_iflags, HIF_WAIT, gfs2_glock_holder_wait, TASK_UNINTERRUPTIBLE);
+	if (time_after(jiffies, time1 + HZ)) /* have we waited > a second? */
+		/* Lengthen the minimum hold time. */
+		gh->gh_gl->gl_hold_time = min(gh->gh_gl->gl_hold_time +
+					      GL_GLOCK_HOLD_INCR,
+					      GL_GLOCK_MAX_HOLD);
 }
 
 static void wait_on_demote(struct gfs2_glock *gl)
@@ -1093,8 +1110,9 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 
 	gfs2_glock_hold(gl);
 	if (test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
-	    !test_bit(GLF_DEMOTE, &gl->gl_flags))
-		delay = gl->gl_ops->go_min_hold_time;
+	    !test_bit(GLF_DEMOTE, &gl->gl_flags) &&
+	    gl->gl_name.ln_type == LM_TYPE_INODE)
+		delay = gl->gl_hold_time;
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, delay) == 0)
 		gfs2_glock_put(gl);
 }
@@ -1273,12 +1291,13 @@ void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 	unsigned long now = jiffies;
 
 	gfs2_glock_hold(gl);
-	holdtime = gl->gl_tchange + gl->gl_ops->go_min_hold_time;
-	if (test_bit(GLF_QUEUED, &gl->gl_flags)) {
+	holdtime = gl->gl_tchange + gl->gl_hold_time;
+	if (test_bit(GLF_QUEUED, &gl->gl_flags) &&
+	    gl->gl_name.ln_type == LM_TYPE_INODE) {
 		if (time_before(now, holdtime))
 			delay = holdtime - now;
 		if (test_bit(GLF_REPLY_PENDING, &gl->gl_flags))
-			delay = gl->gl_ops->go_min_hold_time;
+			delay = gl->gl_hold_time;
 	}
 
 	spin_lock(&gl->gl_spin);
@@ -1667,7 +1686,7 @@ static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 	dtime *= 1000000/HZ; /* demote time in uSec */
 	if (!test_bit(GLF_DEMOTE, &gl->gl_flags))
 		dtime = 0;
-	gfs2_print_dbg(seq, "G:  s:%s n:%u/%llx f:%s t:%s d:%s/%llu a:%d v:%d r:%d\n",
+	gfs2_print_dbg(seq, "G:  s:%s n:%u/%llx f:%s t:%s d:%s/%llu a:%d v:%d r:%d m:%ld\n",
 		  state2str(gl->gl_state),
 		  gl->gl_name.ln_type,
 		  (unsigned long long)gl->gl_name.ln_number,
@@ -1676,7 +1695,7 @@ static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 		  state2str(gl->gl_demote_state), dtime,
 		  atomic_read(&gl->gl_ail_count),
 		  atomic_read(&gl->gl_revokes),
-		  atomic_read(&gl->gl_ref));
+		  atomic_read(&gl->gl_ref), gl->gl_hold_time);
 
 	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
 		error = dump_holder(seq, gh);
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 6b2f757..6670711 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -113,6 +113,12 @@ enum {
 
 #define GLR_TRYFAILED		13
 
+#define GL_GLOCK_MAX_HOLD        (long)(HZ / 5)
+#define GL_GLOCK_DFT_HOLD        (long)(HZ / 5)
+#define GL_GLOCK_MIN_HOLD        (long)(10)
+#define GL_GLOCK_HOLD_INCR       (long)(HZ / 20)
+#define GL_GLOCK_HOLD_DECR       (long)(HZ / 40)
+
 struct lm_lockops {
 	const char *lm_proto_name;
 	int (*lm_mount) (struct gfs2_sbd *sdp, const char *fsname);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 95788ae..a4222c3 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -551,7 +551,6 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 	.go_lock = inode_go_lock,
 	.go_dump = inode_go_dump,
 	.go_type = LM_TYPE_INODE,
-	.go_min_hold_time = HZ / 5,
 	.go_flags = GLOF_ASPACE,
 };
 
@@ -562,7 +561,6 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_unlock = rgrp_go_unlock,
 	.go_dump = gfs2_rgrp_dump,
 	.go_type = LM_TYPE_RGRP,
-	.go_min_hold_time = HZ / 5,
 	.go_flags = GLOF_ASPACE,
 };
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 24cd55f..892ac37 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -163,7 +163,6 @@ struct gfs2_glock_operations {
 	int (*go_dump)(struct seq_file *seq, const struct gfs2_glock *gl);
 	void (*go_callback) (struct gfs2_glock *gl);
 	const int go_type;
-	const unsigned long go_min_hold_time;
 	const unsigned long go_flags;
 #define GLOF_ASPACE 1
 };
@@ -221,6 +220,7 @@ struct gfs2_glock {
 
 	unsigned int gl_hash;
 	unsigned long gl_demote_time; /* time of first demote request */
+	long gl_hold_time;
 	struct list_head gl_holders;
 
 	const struct gfs2_glock_operations *gl_ops;
-- 
1.7.4

