Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab1ASM4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:56:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:49954 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab1ASM4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:56:33 -0500
Date: Wed, 19 Jan 2011 13:56:30 +0100
From: Jan Kara <jack@suse.cz>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "Shi, Alex" <alex.shi@intel.com>, jack@suse.cz, tytso@mit.edu,
        "czoccolo@gmail.com" <czoccolo@gmail.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
Message-ID: <20110119125630.GB4246@quack.suse.cz>
References: <1295402148.4773.143.camel@debian>
 <1295402606.1949.871.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295402606.1949.871.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-01-11 10:03:26, Shaohua Li wrote:
> add Jan and Theodore to the loop.
  Thanks.

> On Wed, 2011-01-19 at 09:55 +0800, Shi, Alex wrote:
> > Shaohua and I tested kernel building performance on latest kernel. and
> > found it is drop about 15% on our 64 LCPUs NHM-EX machine on ext4 file
> > system. We find this performance dropping is due to commit
> > 749ef9f8423054e326f. If we revert this patch or just change the
> > WRITE_SYNC back to WRITE in jbd2/commit.c file. the performance can be
> > recovered. 
> > 
> > iostat report show with the commit, read request merge number increased
> > and write request merge dropped. The total request size increased and
> > queue length dropped. So we tested another patch: only change WRITE_SYNC
> > to WRITE_SYNC_PLUG in jbd2/commit.c, but nothing effected.
> since WRITE_SYNC_PLUG doesn't work, this isn't a simple no-write-merge issue.
> 
> > we didn't test deadline IO mode, just test cfq. seems insert write
> > request into sync queue effect much read performance, but we don't know
> > details. What's your comments of this? 
  Indeed it seems that the optimization of the case where we wait for the
transaction is negatively impacting the performance when we are not. Does
patch below help for your load? It refines the logic when WRITE_SYNC
is needed (of course, we should also test whether the patch works for fsync
heavy loads as well).
  The patch is mostly a proof of concept and only lightly tested so be
careful...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From 6060f56ac919ac6b146057787af219bbf2503ea0 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 19 Jan 2011 13:45:04 +0100
Subject: [PATCH] jbd2: Refine commit writeout logic

Currently we write out all journal buffers in WRITE_SYNC mode. This improves
performance for fsync heavy workloads but hinders performance when writes
are mostly asynchronous. So add possibility for callers starting a transaction
commit to specify whether they are going to wait for the commit and submit
journal writes in WRITE_SYNC mode only in that case.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/fsync.c       |    2 +-
 fs/ext4/super.c       |    2 +-
 fs/jbd2/checkpoint.c  |    2 +-
 fs/jbd2/commit.c      |    4 ++--
 fs/jbd2/journal.c     |   19 ++++++++++---------
 fs/jbd2/transaction.c |   13 ++++++-------
 fs/ocfs2/aops.c       |    2 +-
 fs/ocfs2/super.c      |    2 +-
 include/linux/jbd2.h  |   18 ++++++++++--------
 9 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 7829b28..19434da 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -198,7 +198,7 @@ int ext4_sync_file(struct file *file, int datasync)
 		return ext4_force_commit(inode->i_sb);
 
 	commit_tid = datasync ? ei->i_datasync_tid : ei->i_sync_tid;
-	if (jbd2_log_start_commit(journal, commit_tid)) {
+	if (jbd2_log_start_commit(journal, commit_tid, true)) {
 		/*
 		 * When the journal is on a different device than the
 		 * fs data disk, we need to issue the barrier in
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0f10ccd..eee8486 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4121,7 +4121,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 
 	trace_ext4_sync_fs(sb, wait);
 	flush_workqueue(sbi->dio_unwritten_wq);
-	if (jbd2_journal_start_commit(sbi->s_journal, &target)) {
+	if (jbd2_journal_start_commit(sbi->s_journal, &target, true)) {
 		if (wait)
 			jbd2_log_wait_commit(sbi->s_journal, target);
 	}
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 6a79fd0..3436d53 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -309,7 +309,7 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 			       "Waiting for Godot: block %llu\n",
 			       journal->j_devname,
 			       (unsigned long long) bh->b_blocknr);
-		jbd2_log_start_commit(journal, tid);
+		jbd2_log_start_commit(journal, tid, true);
 		jbd2_log_wait_commit(journal, tid);
 		ret = 1;
 	} else if (!buffer_dirty(bh)) {
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f3ad159..19973eb 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -329,7 +329,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	int tag_bytes = journal_tag_bytes(journal);
 	struct buffer_head *cbh = NULL; /* For transactional checksums */
 	__u32 crc32_sum = ~0;
-	int write_op = WRITE_SYNC;
+	int write_op = WRITE;
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -368,7 +368,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * we unplug the device. We don't do explicit unplugging in here,
 	 * instead we rely on sync_buffer() doing the unplug for us.
 	 */
-	if (commit_transaction->t_synchronous_commit)
+	if (tid_geq(journal->j_commit_waited, commit_transaction->t_tid))
 		write_op = WRITE_SYNC_PLUG;
 	trace_jbd2_commit_locking(journal, commit_transaction);
 	stats.run.rs_wait = commit_transaction->t_max_wait;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 9e46869..e278fa2 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -475,7 +475,7 @@ int __jbd2_log_space_left(journal_t *journal)
 /*
  * Called under j_state_lock.  Returns true if a transaction commit was started.
  */
-int __jbd2_log_start_commit(journal_t *journal, tid_t target)
+int __jbd2_log_start_commit(journal_t *journal, tid_t target, bool will_wait)
 {
 	/*
 	 * Are we already doing a recent enough commit?
@@ -485,7 +485,8 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t target)
 		 * We want a new commit: OK, mark the request and wakeup the
 		 * commit thread.  We do _not_ do the commit ourselves.
 		 */
-
+		if (will_wait && !tid_geq(journal->j_commit_waited, target))
+			journal->j_commit_waited = target;
 		journal->j_commit_request = target;
 		jbd_debug(1, "JBD: requesting commit %d/%d\n",
 			  journal->j_commit_request,
@@ -496,12 +497,12 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t target)
 	return 0;
 }
 
-int jbd2_log_start_commit(journal_t *journal, tid_t tid)
+int jbd2_log_start_commit(journal_t *journal, tid_t tid, bool will_wait)
 {
 	int ret;
 
 	write_lock(&journal->j_state_lock);
-	ret = __jbd2_log_start_commit(journal, tid);
+	ret = __jbd2_log_start_commit(journal, tid, will_wait);
 	write_unlock(&journal->j_state_lock);
 	return ret;
 }
@@ -524,7 +525,7 @@ int jbd2_journal_force_commit_nested(journal_t *journal)
 	read_lock(&journal->j_state_lock);
 	if (journal->j_running_transaction && !current->journal_info) {
 		transaction = journal->j_running_transaction;
-		__jbd2_log_start_commit(journal, transaction->t_tid);
+		__jbd2_log_start_commit(journal, transaction->t_tid, true);
 	} else if (journal->j_committing_transaction)
 		transaction = journal->j_committing_transaction;
 
@@ -544,7 +545,7 @@ int jbd2_journal_force_commit_nested(journal_t *journal)
  * if a transaction is going to be committed (or is currently already
  * committing), and fills its tid in at *ptid
  */
-int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
+int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid, bool will_wait)
 {
 	int ret = 0;
 
@@ -552,7 +553,7 @@ int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
 	if (journal->j_running_transaction) {
 		tid_t tid = journal->j_running_transaction->t_tid;
 
-		__jbd2_log_start_commit(journal, tid);
+		__jbd2_log_start_commit(journal, tid, will_wait);
 		/* There's a running transaction and we've just made sure
 		 * it's commit has been scheduled. */
 		if (ptid)
@@ -1559,7 +1560,7 @@ int jbd2_journal_flush(journal_t *journal)
 	/* Force everything buffered to the log... */
 	if (journal->j_running_transaction) {
 		transaction = journal->j_running_transaction;
-		__jbd2_log_start_commit(journal, transaction->t_tid);
+		__jbd2_log_start_commit(journal, transaction->t_tid, true);
 	} else if (journal->j_committing_transaction)
 		transaction = journal->j_committing_transaction;
 
@@ -1675,7 +1676,7 @@ void __jbd2_journal_abort_hard(journal_t *journal)
 	journal->j_flags |= JBD2_ABORT;
 	transaction = journal->j_running_transaction;
 	if (transaction)
-		__jbd2_log_start_commit(journal, transaction->t_tid);
+		__jbd2_log_start_commit(journal, transaction->t_tid, false);
 	write_unlock(&journal->j_state_lock);
 }
 
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 3948932..3d5215e 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -222,7 +222,7 @@ repeat:
 		atomic_sub(nblocks, &transaction->t_outstanding_credits);
 		prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
 				TASK_UNINTERRUPTIBLE);
-		__jbd2_log_start_commit(journal, transaction->t_tid);
+		__jbd2_log_start_commit(journal, transaction->t_tid, false);
 		read_unlock(&journal->j_state_lock);
 		schedule();
 		finish_wait(&journal->j_wait_transaction_locked, &wait);
@@ -465,7 +465,7 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mask)
 	spin_unlock(&transaction->t_handle_lock);
 
 	jbd_debug(2, "restarting handle %p\n", handle);
-	__jbd2_log_start_commit(journal, transaction->t_tid);
+	__jbd2_log_start_commit(journal, transaction->t_tid, false);
 	read_unlock(&journal->j_state_lock);
 
 	lock_map_release(&handle->h_lockdep_map);
@@ -1361,8 +1361,6 @@ int jbd2_journal_stop(handle_t *handle)
 		}
 	}
 
-	if (handle->h_sync)
-		transaction->t_synchronous_commit = 1;
 	current->journal_info = NULL;
 	atomic_sub(handle->h_buffer_credits,
 		   &transaction->t_outstanding_credits);
@@ -1383,15 +1381,16 @@ int jbd2_journal_stop(handle_t *handle)
 
 		jbd_debug(2, "transaction too old, requesting commit for "
 					"handle %p\n", handle);
-		/* This is non-blocking */
-		jbd2_log_start_commit(journal, transaction->t_tid);
-
 		/*
 		 * Special case: JBD2_SYNC synchronous updates require us
 		 * to wait for the commit to complete.
 		 */
 		if (handle->h_sync && !(current->flags & PF_MEMALLOC))
 			wait_for_commit = 1;
+
+		/* This is non-blocking */
+		jbd2_log_start_commit(journal, transaction->t_tid,
+				      wait_for_commit);
 	}
 
 	/*
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1fbb0e2..d493f32 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1659,7 +1659,7 @@ static int ocfs2_try_to_free_truncate_log(struct ocfs2_super *osb,
 		goto out;
 	}
 
-	if (jbd2_journal_start_commit(osb->journal->j_journal, &target)) {
+	if (jbd2_journal_start_commit(osb->journal->j_journal, &target, true)) {
 		jbd2_log_wait_commit(osb->journal->j_journal, target);
 		ret = 1;
 	}
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 31c3ffd..aab448c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -414,7 +414,7 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
 	}
 
 	if (jbd2_journal_start_commit(OCFS2_SB(sb)->journal->j_journal,
-				      &target)) {
+				      &target, wait)) {
 		if (wait)
 			jbd2_log_wait_commit(OCFS2_SB(sb)->journal->j_journal,
 					     target);
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 27e79c2..46aaf45 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -631,11 +631,6 @@ struct transaction_s
 	 */
 	atomic_t		t_handle_count;
 
-	/*
-	 * This transaction is being forced and some process is
-	 * waiting for it to finish.
-	 */
-	unsigned int t_synchronous_commit:1;
 	unsigned int t_flushed_data_blocks:1;
 
 	/*
@@ -900,6 +895,13 @@ struct journal_s
 	tid_t			j_commit_request;
 
 	/*
+	 * Sequence number of the most recent transaction someone is waiting
+	 * for to commit.
+	 * [j_state_lock]
+	 */
+	tid_t			j_commit_waited;
+
+	/*
 	 * Journal uuid: identifies the object (filesystem, LVM volume etc)
 	 * backed by this journal.  This will eventually be replaced by an array
 	 * of uuids, allowing us to index multiple devices within a single
@@ -1200,9 +1202,9 @@ extern void	jbd2_journal_switch_revoke_table(journal_t *journal);
  */
 
 int __jbd2_log_space_left(journal_t *); /* Called with journal locked */
-int jbd2_log_start_commit(journal_t *journal, tid_t tid);
-int __jbd2_log_start_commit(journal_t *journal, tid_t tid);
-int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
+int jbd2_log_start_commit(journal_t *journal, tid_t tid, bool will_wait);
+int __jbd2_log_start_commit(journal_t *journal, tid_t tid, bool will_wait);
+int jbd2_journal_start_commit(journal_t *journal, tid_t *tid, bool will_wait);
 int jbd2_journal_force_commit_nested(journal_t *journal);
 int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
 int jbd2_log_do_checkpoint(journal_t *journal);
-- 
1.7.1

