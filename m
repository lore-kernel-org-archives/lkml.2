Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab1COJfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:35:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab1COJeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:21 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/15] GFS2: introduce AIL lock
Date: Tue, 15 Mar 2011 09:11:42 +0000
Message-Id: <1300180305-5993-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The log lock is currently used to protect the AIL lists and
the movements of buffers into and out of them. The lists
are self contained and no log specific items outside the
lists are accessed when starting or emptying the AIL lists.

Hence the operation of the AIL does not require the protection
of the log lock so split them out into a new AIL specific lock
to reduce the amount of traffic on the log lock. This will
also reduce the amount of serialisation that occurs when
the gfs2_logd pushes on the AIL to move it forward.

This reduces the impact of log pushing on sequential write
throughput.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index ac5fac9..3754e3c 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -56,20 +56,26 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	BUG_ON(current->journal_info);
 	current->journal_info = &tr;
 
-	gfs2_log_lock(sdp);
+	spin_lock(&sdp->sd_ail_lock);
 	while (!list_empty(head)) {
 		bd = list_entry(head->next, struct gfs2_bufdata,
 				bd_ail_gl_list);
 		bh = bd->bd_bh;
 		gfs2_remove_from_ail(bd);
+		spin_unlock(&sdp->sd_ail_lock);
+
 		bd->bd_bh = NULL;
 		bh->b_private = NULL;
 		bd->bd_blkno = bh->b_blocknr;
+		gfs2_log_lock(sdp);
 		gfs2_assert_withdraw(sdp, !buffer_busy(bh));
 		gfs2_trans_add_revoke(sdp, bd);
+		gfs2_log_unlock(sdp);
+
+		spin_lock(&sdp->sd_ail_lock);
 	}
 	gfs2_assert_withdraw(sdp, !atomic_read(&gl->gl_ail_count));
-	gfs2_log_unlock(sdp);
+	spin_unlock(&sdp->sd_ail_lock);
 
 	gfs2_trans_end(sdp);
 	gfs2_log_flush(sdp, NULL);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 59aaaa0..870a89d 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -651,6 +651,7 @@ struct gfs2_sbd {
 	unsigned int sd_log_flush_head;
 	u64 sd_log_flush_wrapped;
 
+	spinlock_t sd_ail_lock;
 	struct list_head sd_ail1_list;
 	struct list_head sd_ail2_list;
 	u64 sd_ail_sync_gen;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index eb01f35..4e3c044 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -88,8 +88,8 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
  */
 
 static void gfs2_ail1_start_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
-__releases(&sdp->sd_log_lock)
-__acquires(&sdp->sd_log_lock)
+__releases(&sdp->sd_ail_lock)
+__acquires(&sdp->sd_ail_lock)
 {
 	struct gfs2_bufdata *bd, *s;
 	struct buffer_head *bh;
@@ -117,7 +117,7 @@ __acquires(&sdp->sd_log_lock)
 			list_move(&bd->bd_ail_st_list, &ai->ai_ail1_list);
 
 			get_bh(bh);
-			gfs2_log_unlock(sdp);
+			spin_unlock(&sdp->sd_ail_lock);
 			lock_buffer(bh);
 			if (test_clear_buffer_dirty(bh)) {
 				bh->b_end_io = end_buffer_write_sync;
@@ -126,7 +126,7 @@ __acquires(&sdp->sd_log_lock)
 				unlock_buffer(bh);
 				brelse(bh);
 			}
-			gfs2_log_lock(sdp);
+			spin_lock(&sdp->sd_ail_lock);
 
 			retry = 1;
 			break;
@@ -175,10 +175,10 @@ static void gfs2_ail1_start(struct gfs2_sbd *sdp)
 	struct gfs2_ail *ai;
 	int done = 0;
 
-	gfs2_log_lock(sdp);
+	spin_lock(&sdp->sd_ail_lock);
 	head = &sdp->sd_ail1_list;
 	if (list_empty(head)) {
-		gfs2_log_unlock(sdp);
+		spin_unlock(&sdp->sd_ail_lock);
 		return;
 	}
 	sync_gen = sdp->sd_ail_sync_gen++;
@@ -189,13 +189,13 @@ static void gfs2_ail1_start(struct gfs2_sbd *sdp)
 			if (ai->ai_sync_gen >= sync_gen)
 				continue;
 			ai->ai_sync_gen = sync_gen;
-			gfs2_ail1_start_one(sdp, ai); /* This may drop log lock */
+			gfs2_ail1_start_one(sdp, ai); /* This may drop ail lock */
 			done = 0;
 			break;
 		}
 	}
 
-	gfs2_log_unlock(sdp);
+	spin_unlock(&sdp->sd_ail_lock);
 }
 
 static int gfs2_ail1_empty(struct gfs2_sbd *sdp, int flags)
@@ -203,7 +203,7 @@ static int gfs2_ail1_empty(struct gfs2_sbd *sdp, int flags)
 	struct gfs2_ail *ai, *s;
 	int ret;
 
-	gfs2_log_lock(sdp);
+	spin_lock(&sdp->sd_ail_lock);
 
 	list_for_each_entry_safe_reverse(ai, s, &sdp->sd_ail1_list, ai_list) {
 		if (gfs2_ail1_empty_one(sdp, ai, flags))
@@ -214,7 +214,7 @@ static int gfs2_ail1_empty(struct gfs2_sbd *sdp, int flags)
 
 	ret = list_empty(&sdp->sd_ail1_list);
 
-	gfs2_log_unlock(sdp);
+	spin_unlock(&sdp->sd_ail_lock);
 
 	return ret;
 }
@@ -247,7 +247,7 @@ static void ail2_empty(struct gfs2_sbd *sdp, unsigned int new_tail)
 	int wrap = (new_tail < old_tail);
 	int a, b, rm;
 
-	gfs2_log_lock(sdp);
+	spin_lock(&sdp->sd_ail_lock);
 
 	list_for_each_entry_safe(ai, safe, &sdp->sd_ail2_list, ai_list) {
 		a = (old_tail <= ai->ai_first);
@@ -263,7 +263,7 @@ static void ail2_empty(struct gfs2_sbd *sdp, unsigned int new_tail)
 		kfree(ai);
 	}
 
-	gfs2_log_unlock(sdp);
+	spin_unlock(&sdp->sd_ail_lock);
 }
 
 /**
@@ -421,7 +421,7 @@ static unsigned int current_tail(struct gfs2_sbd *sdp)
 	struct gfs2_ail *ai;
 	unsigned int tail;
 
-	gfs2_log_lock(sdp);
+	spin_lock(&sdp->sd_ail_lock);
 
 	if (list_empty(&sdp->sd_ail1_list)) {
 		tail = sdp->sd_log_head;
@@ -430,7 +430,7 @@ static unsigned int current_tail(struct gfs2_sbd *sdp)
 		tail = ai->ai_first;
 	}
 
-	gfs2_log_unlock(sdp);
+	spin_unlock(&sdp->sd_ail_lock);
 
 	return tail;
 }
@@ -743,10 +743,12 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	sdp->sd_log_commited_databuf = 0;
 	sdp->sd_log_commited_revoke = 0;
 
+	spin_lock(&sdp->sd_ail_lock);
 	if (!list_empty(&ai->ai_ail1_list)) {
 		list_add(&ai->ai_list, &sdp->sd_ail1_list);
 		ai = NULL;
 	}
+	spin_unlock(&sdp->sd_ail_lock);
 	gfs2_log_unlock(sdp);
 	trace_gfs2_log_flush(sdp, 0);
 	up_write(&sdp->sd_log_flush_lock);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 11a73ef..4295a6a 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -80,7 +80,7 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	mark_buffer_dirty(bh);
 	clear_buffer_pinned(bh);
 
-	gfs2_log_lock(sdp);
+	spin_lock(&sdp->sd_ail_lock);
 	if (bd->bd_ail) {
 		list_del(&bd->bd_ail_st_list);
 		brelse(bh);
@@ -91,10 +91,11 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	}
 	bd->bd_ail = ai;
 	list_add(&bd->bd_ail_st_list, &ai->ai_ail1_list);
+	spin_unlock(&sdp->sd_ail_lock);
+
 	if (test_and_clear_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags))
 		gfs2_glock_schedule_for_reclaim(bd->bd_gl);
 	trace_gfs2_pin(bd, 0);
-	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
 	atomic_dec(&sdp->sd_log_pinned);
 }
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 67654d0..42ef243 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -99,6 +99,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	init_waitqueue_head(&sdp->sd_log_waitq);
 	init_waitqueue_head(&sdp->sd_logd_waitq);
+	spin_lock_init(&sdp->sd_ail_lock);
 	INIT_LIST_HEAD(&sdp->sd_ail1_list);
 	INIT_LIST_HEAD(&sdp->sd_ail2_list);
 
-- 
1.7.4

