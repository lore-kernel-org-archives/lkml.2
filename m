Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0EQNAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:00:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab0EQM6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:58:07 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/11] GFS2: Various gfs2_logd improvements
Date: Mon, 17 May 2010 13:40:19 +0100
Message-Id: <1274100025-26629-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274100025-26629-5-git-send-email-swhiteho@redhat.com>
References: <1274100025-26629-1-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-2-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-3-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-4-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-5-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

This patch contains various tweaks to how log flushes and active item writeback
work. gfs2_logd is now managed by a waitqueue, and gfs2_log_reseve now waits
for gfs2_logd to do the log flushing.  Multiple functions were rewritten to
remove the need to call gfs2_log_lock(). Instead of using one test to see if
gfs2_logd had work to do, there are now seperate tests to check if there
are two many buffers in the incore log or if there are two many items on the
active items list.

This patch is a port of a patch Steve Whitehouse wrote about a year ago, with
some minor changes.  Since gfs2_ail1_start always submits all the active items,
it no longer needs to keep track of the first ai submitted, so this has been
removed. In gfs2_log_reserve(), the order of the calls to
prepare_to_wait_exclusive() and wake_up() when firing off the logd thread has
been switched.  If it called wake_up first there was a small window for a race,
where logd could run and return before gfs2_log_reserve was ready to get woken
up. If gfs2_logd ran, but did not free up enough blocks, gfs2_log_reserve()
would be left waiting for gfs2_logd to eventualy run because it timed out.
Finally, gt_logd_secs, which controls how long to wait before gfs2_logd times
out, and flushes the log, can now be set on mount with ar_commit.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/incore.h     |   10 ++--
 fs/gfs2/log.c        |  157 ++++++++++++++++++++++++++++----------------------
 fs/gfs2/log.h        |    1 -
 fs/gfs2/lops.c       |    2 +
 fs/gfs2/meta_io.c    |    1 +
 fs/gfs2/ops_fstype.c |   17 +++---
 fs/gfs2/super.c      |    8 +-
 fs/gfs2/sys.c        |    4 -
 fs/gfs2/trans.c      |   18 ++++++
 9 files changed, 126 insertions(+), 92 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 3aac46f..08dd657 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -439,9 +439,6 @@ struct gfs2_args {
 struct gfs2_tune {
 	spinlock_t gt_spin;
 
-	unsigned int gt_incore_log_blocks;
-	unsigned int gt_log_flush_secs;
-
 	unsigned int gt_logd_secs;
 
 	unsigned int gt_quota_simul_sync; /* Max quotavals to sync at once */
@@ -618,6 +615,7 @@ struct gfs2_sbd {
 	unsigned int sd_log_commited_databuf;
 	int sd_log_commited_revoke;
 
+	atomic_t sd_log_pinned;
 	unsigned int sd_log_num_buf;
 	unsigned int sd_log_num_revoke;
 	unsigned int sd_log_num_rg;
@@ -629,15 +627,17 @@ struct gfs2_sbd {
 	struct list_head sd_log_le_databuf;
 	struct list_head sd_log_le_ordered;
 
+	atomic_t sd_log_thresh1;
+	atomic_t sd_log_thresh2;
 	atomic_t sd_log_blks_free;
-	struct mutex sd_log_reserve_mutex;
+	wait_queue_head_t sd_log_waitq;
+	wait_queue_head_t sd_logd_waitq;
 
 	u64 sd_log_sequence;
 	unsigned int sd_log_head;
 	unsigned int sd_log_tail;
 	int sd_log_idle;
 
-	unsigned long sd_log_flush_time;
 	struct rw_semaphore sd_log_flush_lock;
 	atomic_t sd_log_in_flight;
 	wait_queue_head_t sd_log_flush_wait;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index e5bf4b5..d5959df 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -168,12 +168,11 @@ static int gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai, int fl
 	return list_empty(&ai->ai_ail1_list);
 }
 
-static void gfs2_ail1_start(struct gfs2_sbd *sdp, int flags)
+static void gfs2_ail1_start(struct gfs2_sbd *sdp)
 {
 	struct list_head *head;
 	u64 sync_gen;
-	struct list_head *first;
-	struct gfs2_ail *first_ai, *ai, *tmp;
+	struct gfs2_ail *ai;
 	int done = 0;
 
 	gfs2_log_lock(sdp);
@@ -184,21 +183,9 @@ static void gfs2_ail1_start(struct gfs2_sbd *sdp, int flags)
 	}
 	sync_gen = sdp->sd_ail_sync_gen++;
 
-	first = head->prev;
-	first_ai = list_entry(first, struct gfs2_ail, ai_list);
-	first_ai->ai_sync_gen = sync_gen;
-	gfs2_ail1_start_one(sdp, first_ai); /* This may drop log lock */
-
-	if (flags & DIO_ALL)
-		first = NULL;
-
 	while(!done) {
-		if (first && (head->prev != first ||
-			      gfs2_ail1_empty_one(sdp, first_ai, 0)))
-			break;
-
 		done = 1;
-		list_for_each_entry_safe_reverse(ai, tmp, head, ai_list) {
+		list_for_each_entry_reverse(ai, head, ai_list) {
 			if (ai->ai_sync_gen >= sync_gen)
 				continue;
 			ai->ai_sync_gen = sync_gen;
@@ -290,58 +277,57 @@ static void ail2_empty(struct gfs2_sbd *sdp, unsigned int new_tail)
  * flush time, so we ensure that we have just enough free blocks at all
  * times to avoid running out during a log flush.
  *
+ * We no longer flush the log here, instead we wake up logd to do that
+ * for us. To avoid the thundering herd and to ensure that we deal fairly
+ * with queued waiters, we use an exclusive wait. This means that when we
+ * get woken with enough journal space to get our reservation, we need to
+ * wake the next waiter on the list.
+ *
  * Returns: errno
  */
 
 int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks)
 {
-	unsigned int try = 0;
 	unsigned reserved_blks = 6 * (4096 / sdp->sd_vfs->s_blocksize);
+	unsigned wanted = blks + reserved_blks;
+	DEFINE_WAIT(wait);
+	int did_wait = 0;
+	unsigned int free_blocks;
 
 	if (gfs2_assert_warn(sdp, blks) ||
 	    gfs2_assert_warn(sdp, blks <= sdp->sd_jdesc->jd_blocks))
 		return -EINVAL;
-
-	mutex_lock(&sdp->sd_log_reserve_mutex);
-	gfs2_log_lock(sdp);
-	while(atomic_read(&sdp->sd_log_blks_free) <= (blks + reserved_blks)) {
-		gfs2_log_unlock(sdp);
-		gfs2_ail1_empty(sdp, 0);
-		gfs2_log_flush(sdp, NULL);
-
-		if (try++)
-			gfs2_ail1_start(sdp, 0);
-		gfs2_log_lock(sdp);
+retry:
+	free_blocks = atomic_read(&sdp->sd_log_blks_free);
+	if (unlikely(free_blocks <= wanted)) {
+		do {
+			prepare_to_wait_exclusive(&sdp->sd_log_waitq, &wait,
+					TASK_UNINTERRUPTIBLE);
+			wake_up(&sdp->sd_logd_waitq);
+			did_wait = 1;
+			if (atomic_read(&sdp->sd_log_blks_free) <= wanted)
+				io_schedule();
+			free_blocks = atomic_read(&sdp->sd_log_blks_free);
+		} while(free_blocks <= wanted);
+		finish_wait(&sdp->sd_log_waitq, &wait);
 	}
-	atomic_sub(blks, &sdp->sd_log_blks_free);
+	if (atomic_cmpxchg(&sdp->sd_log_blks_free, free_blocks,
+				free_blocks - blks) != free_blocks)
+		goto retry;
 	trace_gfs2_log_blocks(sdp, -blks);
-	gfs2_log_unlock(sdp);
-	mutex_unlock(&sdp->sd_log_reserve_mutex);
+
+	/*
+	 * If we waited, then so might others, wake them up _after_ we get
+	 * our share of the log.
+	 */
+	if (unlikely(did_wait))
+		wake_up(&sdp->sd_log_waitq);
 
 	down_read(&sdp->sd_log_flush_lock);
 
 	return 0;
 }
 
-/**
- * gfs2_log_release - Release a given number of log blocks
- * @sdp: The GFS2 superblock
- * @blks: The number of blocks
- *
- */
-
-void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
-{
-
-	gfs2_log_lock(sdp);
-	atomic_add(blks, &sdp->sd_log_blks_free);
-	trace_gfs2_log_blocks(sdp, blks);
-	gfs2_assert_withdraw(sdp,
-			     atomic_read(&sdp->sd_log_blks_free) <= sdp->sd_jdesc->jd_blocks);
-	gfs2_log_unlock(sdp);
-	up_read(&sdp->sd_log_flush_lock);
-}
-
 static u64 log_bmap(struct gfs2_sbd *sdp, unsigned int lbn)
 {
 	struct gfs2_journal_extent *je;
@@ -559,11 +545,10 @@ static void log_pull_tail(struct gfs2_sbd *sdp, unsigned int new_tail)
 
 	ail2_empty(sdp, new_tail);
 
-	gfs2_log_lock(sdp);
 	atomic_add(dist, &sdp->sd_log_blks_free);
 	trace_gfs2_log_blocks(sdp, dist);
-	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <= sdp->sd_jdesc->jd_blocks);
-	gfs2_log_unlock(sdp);
+	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
+			     sdp->sd_jdesc->jd_blocks);
 
 	sdp->sd_log_tail = new_tail;
 }
@@ -822,6 +807,13 @@ static void buf_lo_incore_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
  * @sdp: the filesystem
  * @tr: the transaction
  *
+ * We wake up gfs2_logd if the number of pinned blocks exceed thresh1
+ * or the total number of used blocks (pinned blocks plus AIL blocks)
+ * is greater than thresh2.
+ *
+ * At mount time thresh1 is 1/3rd of journal size, thresh2 is 2/3rd of
+ * journal size.
+ *
  * Returns: errno
  */
 
@@ -832,10 +824,10 @@ void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 
 	up_read(&sdp->sd_log_flush_lock);
 
-	gfs2_log_lock(sdp);
-	if (sdp->sd_log_num_buf > gfs2_tune_get(sdp, gt_incore_log_blocks))
-		wake_up_process(sdp->sd_logd_process);
-	gfs2_log_unlock(sdp);
+	if (atomic_read(&sdp->sd_log_pinned) > atomic_read(&sdp->sd_log_thresh1) ||
+	    ((sdp->sd_jdesc->jd_blocks - atomic_read(&sdp->sd_log_blks_free)) >
+	    atomic_read(&sdp->sd_log_thresh2)))
+		wake_up(&sdp->sd_logd_waitq);
 }
 
 /**
@@ -882,13 +874,23 @@ void gfs2_meta_syncfs(struct gfs2_sbd *sdp)
 {
 	gfs2_log_flush(sdp, NULL);
 	for (;;) {
-		gfs2_ail1_start(sdp, DIO_ALL);
+		gfs2_ail1_start(sdp);
 		if (gfs2_ail1_empty(sdp, DIO_ALL))
 			break;
 		msleep(10);
 	}
 }
 
+static inline int gfs2_jrnl_flush_reqd(struct gfs2_sbd *sdp)
+{
+	return (atomic_read(&sdp->sd_log_pinned) >= atomic_read(&sdp->sd_log_thresh1));
+}
+
+static inline int gfs2_ail_flush_reqd(struct gfs2_sbd *sdp)
+{
+	unsigned int used_blocks = sdp->sd_jdesc->jd_blocks - atomic_read(&sdp->sd_log_blks_free);
+	return used_blocks >= atomic_read(&sdp->sd_log_thresh2);
+}
 
 /**
  * gfs2_logd - Update log tail as Active Items get flushed to in-place blocks
@@ -901,28 +903,43 @@ void gfs2_meta_syncfs(struct gfs2_sbd *sdp)
 int gfs2_logd(void *data)
 {
 	struct gfs2_sbd *sdp = data;
-	unsigned long t;
-	int need_flush;
+	unsigned long t = 1;
+	DEFINE_WAIT(wait);
+	unsigned preflush;
 
 	while (!kthread_should_stop()) {
-		/* Advance the log tail */
 
-		t = sdp->sd_log_flush_time +
-		    gfs2_tune_get(sdp, gt_log_flush_secs) * HZ;
+		preflush = atomic_read(&sdp->sd_log_pinned);
+		if (gfs2_jrnl_flush_reqd(sdp) || t == 0) {
+			gfs2_ail1_empty(sdp, DIO_ALL);
+			gfs2_log_flush(sdp, NULL);
+			gfs2_ail1_empty(sdp, DIO_ALL);
+		}
 
-		gfs2_ail1_empty(sdp, DIO_ALL);
-		gfs2_log_lock(sdp);
-		need_flush = sdp->sd_log_num_buf > gfs2_tune_get(sdp, gt_incore_log_blocks);
-		gfs2_log_unlock(sdp);
-		if (need_flush || time_after_eq(jiffies, t)) {
+		if (gfs2_ail_flush_reqd(sdp)) {
+			gfs2_ail1_start(sdp);
+			io_schedule();
+			gfs2_ail1_empty(sdp, 0);
 			gfs2_log_flush(sdp, NULL);
-			sdp->sd_log_flush_time = jiffies;
+			gfs2_ail1_empty(sdp, DIO_ALL);
 		}
 
+		wake_up(&sdp->sd_log_waitq);
 		t = gfs2_tune_get(sdp, gt_logd_secs) * HZ;
 		if (freezing(current))
 			refrigerator();
-		schedule_timeout_interruptible(t);
+
+		do {
+			prepare_to_wait(&sdp->sd_logd_waitq, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!gfs2_ail_flush_reqd(sdp) &&
+			    !gfs2_jrnl_flush_reqd(sdp) &&
+			    !kthread_should_stop())
+				t = schedule_timeout(t);
+		} while(t && !gfs2_ail_flush_reqd(sdp) &&
+			!gfs2_jrnl_flush_reqd(sdp) &&
+			!kthread_should_stop());
+		finish_wait(&sdp->sd_logd_waitq, &wait);
 	}
 
 	return 0;
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 7c64510..eb570b4 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -51,7 +51,6 @@ unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
 			    unsigned int ssize);
 
 int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks);
-void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks);
 void gfs2_log_incr_head(struct gfs2_sbd *sdp);
 
 struct buffer_head *gfs2_log_get_buf(struct gfs2_sbd *sdp);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index adc260f..bf33f82 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -54,6 +54,7 @@ static void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	if (bd->bd_ail)
 		list_move(&bd->bd_ail_st_list, &bd->bd_ail->ai_ail2_list);
 	get_bh(bh);
+	atomic_inc(&sdp->sd_log_pinned);
 	trace_gfs2_pin(bd, 1);
 }
 
@@ -94,6 +95,7 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	trace_gfs2_pin(bd, 0);
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
+	atomic_dec(&sdp->sd_log_pinned);
 }
 
 
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 0bb12c8..abafda1 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -313,6 +313,7 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 	struct gfs2_bufdata *bd = bh->b_private;
 
 	if (test_clear_buffer_pinned(bh)) {
+		atomic_dec(&sdp->sd_log_pinned);
 		list_del_init(&bd->bd_le.le_list);
 		if (meta) {
 			gfs2_assert_warn(sdp, sdp->sd_log_num_buf);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index dc35f34..3593b3a 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -57,8 +57,6 @@ static void gfs2_tune_init(struct gfs2_tune *gt)
 {
 	spin_lock_init(&gt->gt_spin);
 
-	gt->gt_incore_log_blocks = 1024;
-	gt->gt_logd_secs = 1;
 	gt->gt_quota_simul_sync = 64;
 	gt->gt_quota_warn_period = 10;
 	gt->gt_quota_scale_num = 1;
@@ -101,14 +99,15 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	spin_lock_init(&sdp->sd_trunc_lock);
 
 	spin_lock_init(&sdp->sd_log_lock);
-
+	atomic_set(&sdp->sd_log_pinned, 0);
 	INIT_LIST_HEAD(&sdp->sd_log_le_buf);
 	INIT_LIST_HEAD(&sdp->sd_log_le_revoke);
 	INIT_LIST_HEAD(&sdp->sd_log_le_rg);
 	INIT_LIST_HEAD(&sdp->sd_log_le_databuf);
 	INIT_LIST_HEAD(&sdp->sd_log_le_ordered);
 
-	mutex_init(&sdp->sd_log_reserve_mutex);
+	init_waitqueue_head(&sdp->sd_log_waitq);
+	init_waitqueue_head(&sdp->sd_logd_waitq);
 	INIT_LIST_HEAD(&sdp->sd_ail1_list);
 	INIT_LIST_HEAD(&sdp->sd_ail2_list);
 
@@ -733,6 +732,8 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 	if (sdp->sd_args.ar_spectator) {
 		sdp->sd_jdesc = gfs2_jdesc_find(sdp, 0);
 		atomic_set(&sdp->sd_log_blks_free, sdp->sd_jdesc->jd_blocks);
+		atomic_set(&sdp->sd_log_thresh1, 2*sdp->sd_jdesc->jd_blocks/5);
+		atomic_set(&sdp->sd_log_thresh2, 4*sdp->sd_jdesc->jd_blocks/5);
 	} else {
 		if (sdp->sd_lockstruct.ls_jid >= gfs2_jindex_size(sdp)) {
 			fs_err(sdp, "can't mount journal #%u\n",
@@ -770,6 +771,8 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 			goto fail_jinode_gh;
 		}
 		atomic_set(&sdp->sd_log_blks_free, sdp->sd_jdesc->jd_blocks);
+		atomic_set(&sdp->sd_log_thresh1, 2*sdp->sd_jdesc->jd_blocks/5);
+		atomic_set(&sdp->sd_log_thresh2, 4*sdp->sd_jdesc->jd_blocks/5);
 
 		/* Map the extents for this journal's blocks */
 		map_journal_extents(sdp);
@@ -951,8 +954,6 @@ static int init_threads(struct gfs2_sbd *sdp, int undo)
 	if (undo)
 		goto fail_quotad;
 
-	sdp->sd_log_flush_time = jiffies;
-
 	p = kthread_run(gfs2_logd, sdp, "gfs2_logd");
 	error = IS_ERR(p);
 	if (error) {
@@ -1160,7 +1161,7 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
                                GFS2_BASIC_BLOCK_SHIFT;
 	sdp->sd_fsb2bb = 1 << sdp->sd_fsb2bb_shift;
 
-	sdp->sd_tune.gt_log_flush_secs = sdp->sd_args.ar_commit;
+	sdp->sd_tune.gt_logd_secs = sdp->sd_args.ar_commit;
 	sdp->sd_tune.gt_quota_quantum = sdp->sd_args.ar_quota_quantum;
 	if (sdp->sd_args.ar_statfs_quantum) {
 		sdp->sd_tune.gt_statfs_slow = 0;
@@ -1323,7 +1324,7 @@ static int gfs2_get_sb(struct file_system_type *fs_type, int flags,
 	memset(&args, 0, sizeof(args));
 	args.ar_quota = GFS2_QUOTA_DEFAULT;
 	args.ar_data = GFS2_DATA_DEFAULT;
-	args.ar_commit = 60;
+	args.ar_commit = 30;
 	args.ar_statfs_quantum = 30;
 	args.ar_quota_quantum = 60;
 	args.ar_errors = GFS2_ERRORS_DEFAULT;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 50aac60..7a93e9f 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1113,7 +1113,7 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 	int error;
 
 	spin_lock(&gt->gt_spin);
-	args.ar_commit = gt->gt_log_flush_secs;
+	args.ar_commit = gt->gt_logd_secs;
 	args.ar_quota_quantum = gt->gt_quota_quantum;
 	if (gt->gt_statfs_slow)
 		args.ar_statfs_quantum = 0;
@@ -1160,7 +1160,7 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 	else
 		clear_bit(SDF_NOBARRIERS, &sdp->sd_flags);
 	spin_lock(&gt->gt_spin);
-	gt->gt_log_flush_secs = args.ar_commit;
+	gt->gt_logd_secs = args.ar_commit;
 	gt->gt_quota_quantum = args.ar_quota_quantum;
 	if (args.ar_statfs_quantum) {
 		gt->gt_statfs_slow = 0;
@@ -1305,8 +1305,8 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	}
 	if (args->ar_discard)
 		seq_printf(s, ",discard");
-	val = sdp->sd_tune.gt_log_flush_secs;
-	if (val != 60)
+	val = sdp->sd_tune.gt_logd_secs;
+	if (val != 30)
 		seq_printf(s, ",commit=%d", val);
 	val = sdp->sd_tune.gt_statfs_quantum;
 	if (val != 30)
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 419042f..2ac845d 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -469,8 +469,6 @@ static ssize_t name##_store(struct gfs2_sbd *sdp, const char *buf, size_t len)\
 }                                                                             \
 TUNE_ATTR_2(name, name##_store)
 
-TUNE_ATTR(incore_log_blocks, 0);
-TUNE_ATTR(log_flush_secs, 0);
 TUNE_ATTR(quota_warn_period, 0);
 TUNE_ATTR(quota_quantum, 0);
 TUNE_ATTR(max_readahead, 0);
@@ -482,8 +480,6 @@ TUNE_ATTR(statfs_quantum, 1);
 TUNE_ATTR_3(quota_scale, quota_scale_show, quota_scale_store);
 
 static struct attribute *tune_attrs[] = {
-	&tune_attr_incore_log_blocks.attr,
-	&tune_attr_log_flush_secs.attr,
 	&tune_attr_quota_warn_period.attr,
 	&tune_attr_quota_quantum.attr,
 	&tune_attr_max_readahead.attr,
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 4ef0e9f..9ec73a8 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -23,6 +23,7 @@
 #include "meta_io.h"
 #include "trans.h"
 #include "util.h"
+#include "trace_gfs2.h"
 
 int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 		     unsigned int revokes)
@@ -75,6 +76,23 @@ fail_holder_uninit:
 	return error;
 }
 
+/**
+ * gfs2_log_release - Release a given number of log blocks
+ * @sdp: The GFS2 superblock
+ * @blks: The number of blocks
+ *
+ */
+
+static void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
+{
+
+	atomic_add(blks, &sdp->sd_log_blks_free);
+	trace_gfs2_log_blocks(sdp, blks);
+	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
+				  sdp->sd_jdesc->jd_blocks);
+	up_read(&sdp->sd_log_flush_lock);
+}
+
 void gfs2_trans_end(struct gfs2_sbd *sdp)
 {
 	struct gfs2_trans *tr = current->journal_info;
-- 
1.6.2.5

