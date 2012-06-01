Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813Ab2FAORV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:17:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:39264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab2FAORG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="147036906"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH 5/5] reiserfs: get rid of resierfs_sync_super
Date: Fri,  1 Jun 2012 17:18:08 +0300
Message-Id: <1338560288-10727-6-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338560288-10727-1-git-send-email-dedekind1@gmail.com>
References: <1338560288-10727-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch stops reiserfs using the VFS 'write_super()' method along with the
s_dirt flag, because they are on their way out.

The whole "superblock write-out" VFS infrastructure is served by the
'sync_supers()' kernel thread, which wakes up every 5 (by default) seconds and
writes out all dirty superblock using the '->write_super()' call-back.  But the
problem with this thread is that it wastes power by waking up the system every
5 seconds, even if there are no diry superblocks, or there are no client
file-systems which would need this (e.g., btrfs does not use
'->write_super()'). So we want to kill it completely and thus, we need to make
file-systems to stop using the '->write_super()' VFS service, and then remove
it together with the kernel thread.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/reiserfs/journal.c  |    6 +++-
 fs/reiserfs/reiserfs.h |    6 +++++
 fs/reiserfs/super.c    |   54 ++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index e5e06dd..afcadcc 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1923,6 +1923,8 @@ static int do_journal_release(struct reiserfs_transaction_handle *th,
 	 * the workqueue job (flush_async_commit) needs this lock
 	 */
 	reiserfs_write_unlock(sb);
+
+	cancel_delayed_work_sync(&REISERFS_SB(sb)->old_work);
 	flush_workqueue(commit_wq);
 
 	if (!reiserfs_mounted_fs_count) {
@@ -3314,7 +3316,7 @@ int journal_mark_dirty(struct reiserfs_transaction_handle *th,
 		journal->j_first = cn;
 		journal->j_last = cn;
 	}
-	sb->s_dirt = 1;
+	reiserfs_schedule_old_flush(sb);
 	return 0;
 }
 
@@ -3952,7 +3954,7 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
 	 ** it tells us if we should continue with the journal_end, or just return
 	 */
 	if (!check_journal_end(th, sb, nblocks, flags)) {
-		sb->s_dirt = 1;
+		reiserfs_schedule_old_flush(sb);
 		wake_queued_writers(sb);
 		reiserfs_async_progress_wait(sb);
 		goto out;
diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 09664c9..d6d8a7d 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -480,6 +480,11 @@ struct reiserfs_sb_info {
 	struct dentry *priv_root;	/* root of /.reiserfs_priv */
 	struct dentry *xattr_root;	/* root of /.reiserfs_priv/xattrs */
 	int j_errno;
+
+	int work_queued;              /* non-zero delayed work is queued */
+	struct delayed_work old_work; /* old transactions flush delayed work */
+	spinlock_t old_work_lock;     /* protects old_work and work_queued */
+
 #ifdef CONFIG_QUOTA
 	char *s_qf_names[MAXQUOTAS];
 	int s_jquota_fmt;
@@ -2487,6 +2492,7 @@ void reiserfs_abort(struct super_block *sb, int errno, const char *fmt, ...);
 int reiserfs_allocate_list_bitmaps(struct super_block *s,
 				   struct reiserfs_list_bitmap *, unsigned int);
 
+void reiserfs_schedule_old_flush(struct super_block *s);
 void add_save_link(struct reiserfs_transaction_handle *th,
 		   struct inode *inode, int truncate);
 int remove_save_link(struct inode *inode, int truncate);
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 92db34b..5cc70e7 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -72,20 +72,58 @@ static int reiserfs_sync_fs(struct super_block *s, int wait)
 	if (!journal_begin(&th, s, 1))
 		if (!journal_end_sync(&th, s, 1))
 			reiserfs_flush_old_commits(s);
-	s->s_dirt = 0;	/* Even if it's not true.
-			 * We'll loop forever in sync_supers otherwise */
 	reiserfs_write_unlock(s);
 	return 0;
 }
 
-static void reiserfs_write_super(struct super_block *s)
+static void flush_old_commits(struct work_struct *work)
 {
+	struct reiserfs_sb_info *sbi;
+	struct super_block *s;
+
+	sbi = container_of(work, struct reiserfs_sb_info, old_work.work);
+	s = sbi->s_journal->j_work_sb;
+
+	spin_lock(&sbi->old_work_lock);
+	sbi->work_queued = 0;
+	spin_unlock(&sbi->old_work_lock);
+
 	reiserfs_sync_fs(s, 1);
 }
 
+void reiserfs_schedule_old_flush(struct super_block *s)
+{
+	struct reiserfs_sb_info *sbi = REISERFS_SB(s);
+	unsigned long delay;
+
+	if (s->s_flags & MS_RDONLY)
+		return;
+
+	spin_lock(&sbi->old_work_lock);
+	if (!sbi->work_queued) {
+		delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+		queue_delayed_work(system_long_wq, &sbi->old_work, delay);
+		sbi->work_queued = 1;
+	}
+	spin_unlock(&sbi->old_work_lock);
+}
+
+static void cancel_old_flush(struct super_block *s)
+{
+	struct reiserfs_sb_info *sbi = REISERFS_SB(s);
+
+	cancel_delayed_work_sync(&REISERFS_SB(s)->old_work);
+	spin_lock(&sbi->old_work_lock);
+	sbi->work_queued = 0;
+	spin_unlock(&sbi->old_work_lock);
+}
+
 static int reiserfs_freeze(struct super_block *s)
 {
 	struct reiserfs_transaction_handle th;
+
+	cancel_old_flush(s);
+
 	reiserfs_write_lock(s);
 	if (!(s->s_flags & MS_RDONLY)) {
 		int err = journal_begin(&th, s, 1);
@@ -99,7 +137,6 @@ static int reiserfs_freeze(struct super_block *s)
 			journal_end_sync(&th, s, 1);
 		}
 	}
-	s->s_dirt = 0;
 	reiserfs_write_unlock(s);
 	return 0;
 }
@@ -483,9 +520,6 @@ static void reiserfs_put_super(struct super_block *s)
 
 	reiserfs_write_lock(s);
 
-	if (s->s_dirt)
-		reiserfs_write_super(s);
-
 	/* change file system state to current state if it was mounted with read-write permissions */
 	if (!(s->s_flags & MS_RDONLY)) {
 		if (!journal_begin(&th, s, 10)) {
@@ -692,7 +726,6 @@ static const struct super_operations reiserfs_sops = {
 	.dirty_inode = reiserfs_dirty_inode,
 	.evict_inode = reiserfs_evict_inode,
 	.put_super = reiserfs_put_super,
-	.write_super = reiserfs_write_super,
 	.sync_fs = reiserfs_sync_fs,
 	.freeze_fs = reiserfs_freeze,
 	.unfreeze_fs = reiserfs_unfreeze,
@@ -1400,7 +1433,6 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	err = journal_end(&th, s, 10);
 	if (err)
 		goto out_err;
-	s->s_dirt = 0;
 
 	if (!(*mount_flags & MS_RDONLY)) {
 		dquot_resume(s, -1);
@@ -1741,6 +1773,8 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	/* setup default block allocator options */
 	reiserfs_init_alloc_options(s);
 
+	spin_lock_init(&sbi->old_work_lock);
+	INIT_DELAYED_WORK(&sbi->old_work, flush_old_commits);
 	mutex_init(&sbi->lock);
 	sbi->lock_depth = -1;
 
@@ -2003,6 +2037,8 @@ error_unlocked:
 		reiserfs_write_unlock(s);
 	}
 
+	cancel_delayed_work_sync(&REISERFS_SB(s)->old_work);
+
 	reiserfs_free_bitmap_cache(s);
 	if (SB_BUFFER_WITH_SB(s))
 		brelse(SB_BUFFER_WITH_SB(s));
-- 
1.7.7.6

