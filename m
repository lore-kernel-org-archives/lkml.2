Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab1ESJKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933Ab1ESJKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:13 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/32] GFS2: Alter point of entry to glock lru list for glocks with an address_space
Date: Thu, 19 May 2011 09:47:03 +0100
Message-Id: <1305794847-3291-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than allowing the glocks to be scheduled for possible
reclaim as soon as they have exited the journal, this patch
delays their entry to the list until the glocks in question
are no longer in use.

This means that we will rely on the vm for writeback of all
dirty data and metadata from now on. When glocks are added
to the lru list they should be freeable much faster since all
the I/O required to free them should have already been completed.

This should lead to much better I/O patterns under low memory
conditions.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f07643e..1019183 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -160,6 +160,19 @@ static int demote_ok(const struct gfs2_glock *gl)
 }
 
 
+void gfs2_glock_add_to_lru(struct gfs2_glock *gl)
+{
+	spin_lock(&lru_lock);
+
+	if (!list_empty(&gl->gl_lru))
+		list_del_init(&gl->gl_lru);
+	else
+		atomic_inc(&lru_count);
+
+	list_add_tail(&gl->gl_lru, &lru_list);
+	spin_unlock(&lru_lock);
+}
+
 /**
  * __gfs2_glock_schedule_for_reclaim - Add a glock to the reclaim list
  * @gl: the glock
@@ -170,24 +183,8 @@ static int demote_ok(const struct gfs2_glock *gl)
 
 static void __gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
 {
-	if (demote_ok(gl)) {
-		spin_lock(&lru_lock);
-
-		if (!list_empty(&gl->gl_lru))
-			list_del_init(&gl->gl_lru);
-		else
-			atomic_inc(&lru_count);
-
-		list_add_tail(&gl->gl_lru, &lru_list);
-		spin_unlock(&lru_lock);
-	}
-}
-
-void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
-{
-	spin_lock(&gl->gl_spin);
-	__gfs2_glock_schedule_for_reclaim(gl);
-	spin_unlock(&gl->gl_spin);
+	if (demote_ok(gl))
+		gfs2_glock_add_to_lru(gl);
 }
 
 /**
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index aea1606..6b2f757 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -225,11 +225,10 @@ static inline int gfs2_glock_nq_init(struct gfs2_glock *gl,
 
 extern void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state);
 extern void gfs2_glock_complete(struct gfs2_glock *gl, int ret);
-extern void gfs2_reclaim_glock(struct gfs2_sbd *sdp);
 extern void gfs2_gl_hash_clear(struct gfs2_sbd *sdp);
 extern void gfs2_glock_finish_truncate(struct gfs2_inode *ip);
 extern void gfs2_glock_thaw(struct gfs2_sbd *sdp);
-extern void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl);
+extern void gfs2_glock_add_to_lru(struct gfs2_glock *gl);
 extern void gfs2_glock_free(struct gfs2_glock *gl);
 
 extern int __init gfs2_glock_init(void);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 51d27f0..611a51d 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -40,7 +40,7 @@ static void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 {
 	struct gfs2_bufdata *bd;
 
-	gfs2_assert_withdraw(sdp, test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags));
+	BUG_ON(!current->journal_info);
 
 	clear_buffer_dirty(bh);
 	if (test_set_buffer_pinned(bh))
@@ -65,6 +65,7 @@ static void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
  * @sdp: the filesystem the buffer belongs to
  * @bh: The buffer to unpin
  * @ai:
+ * @flags: The inode dirty flags
  *
  */
 
@@ -73,10 +74,8 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 {
 	struct gfs2_bufdata *bd = bh->b_private;
 
-	gfs2_assert_withdraw(sdp, buffer_uptodate(bh));
-
-	if (!buffer_pinned(bh))
-		gfs2_assert_withdraw(sdp, 0);
+	BUG_ON(!buffer_uptodate(bh));
+	BUG_ON(!buffer_pinned(bh));
 
 	lock_buffer(bh);
 	mark_buffer_dirty(bh);
@@ -95,8 +94,7 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	list_add(&bd->bd_ail_st_list, &ai->ai_ail1_list);
 	spin_unlock(&sdp->sd_ail_lock);
 
-	if (test_and_clear_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags))
-		gfs2_glock_schedule_for_reclaim(bd->bd_gl);
+	clear_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	trace_gfs2_pin(bd, 0);
 	unlock_buffer(bh);
 	atomic_dec(&sdp->sd_log_pinned);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index b643c14..7273ad3 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -392,6 +392,7 @@ static void clear_rgrpdi(struct gfs2_sbd *sdp)
 
 		if (gl) {
 			gl->gl_object = NULL;
+			gfs2_glock_add_to_lru(gl);
 			gfs2_glock_put(gl);
 		}
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index d827b93..b62c842 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1401,6 +1401,7 @@ out:
 	end_writeback(inode);
 
 	ip->i_gl->gl_object = NULL;
+	gfs2_glock_add_to_lru(ip->i_gl);
 	gfs2_glock_put(ip->i_gl);
 	ip->i_gl = NULL;
 	if (ip->i_iopen_gh.gh_gl) {
-- 
1.7.4

