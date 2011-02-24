Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1BXMNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:13:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:45123 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab1BXMNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:13:43 -0500
Date: Thu, 24 Feb 2011 13:13:39 +0100
From: Jan Kara <jack@suse.cz>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Jan Kara <jack@suse.cz>, "Li, Shaohua" <shaohua.li@intel.com>,
        Corrado Zoccolo <czoccolo@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
Message-ID: <20110224121339.GE23042@quack.suse.cz>
References: <1295402148.4773.143.camel@debian>
 <1295402606.1949.871.camel@sli10-conroe>
 <20110120151656.GC18875@redhat.com>
 <20110126081529.GA28909@sli10-conroe.sh.intel.com>
 <1297502512.29573.26.camel@debian>
 <AANLkTi=B6kabp+NvRJC_g-AqQO0ZOvnEDYpVFmScttR6@mail.gmail.com>
 <1297650318.29573.2482.camel@debian>
 <1297732201.24560.2.camel@sli10-conroe>
 <20110221164909.GG6584@quack.suse.cz>
 <1298449487.14712.1064.camel@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <1298449487.14712.1064.camel@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 23-02-11 16:24:47, Alex,Shi wrote:
> Though these patches can not totally recovered the problem, but they are
> quite helpful with ccache enabled situation. It increase 10% performance
> on 38-rc1 kernel. 
  OK and what was the original performance drop with WRITE_SYNC change?

> I have tried to enabled they to latest rc6 kernel but failed. the vmstat output is here: 
> with patches:
  I'm attaching patches rebased on top of latest Linus's tree. 
Corrado, could you possibly run your fsync-heavy tests so that we see
whether there isn't negative impact of my patches on your fsync-heavy
workload? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--UPT3ojh+0CqEDtpF
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-jbd2-Refine-commit-writeout-logic.patch"

>From 555d33d45bd38a8da6b187a15ad5eb9e9c4f1ab9 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 19 Jan 2011 13:45:04 +0100
Subject: [PATCH 1/2] jbd2: Refine commit writeout logic

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
 fs/jbd2/transaction.c |   15 +++++++++------
 fs/ocfs2/aops.c       |    2 +-
 fs/ocfs2/super.c      |    2 +-
 include/linux/jbd2.h  |   18 ++++++++++--------
 9 files changed, 36 insertions(+), 30 deletions(-)

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
index f6a318f..bfce0d6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4115,7 +4115,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 
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
index 97e7346..04835d6 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -476,7 +476,7 @@ int __jbd2_log_space_left(journal_t *journal)
  * Called with j_state_lock locked for writing.
  * Returns true if a transaction commit was started.
  */
-int __jbd2_log_start_commit(journal_t *journal, tid_t target)
+int __jbd2_log_start_commit(journal_t *journal, tid_t target, bool will_wait)
 {
 	/*
 	 * Are we already doing a recent enough commit?
@@ -486,7 +486,8 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t target)
 		 * We want a new commit: OK, mark the request and wakeup the
 		 * commit thread.  We do _not_ do the commit ourselves.
 		 */
-
+		if (will_wait && !tid_geq(journal->j_commit_waited, target))
+			journal->j_commit_waited = target;
 		journal->j_commit_request = target;
 		jbd_debug(1, "JBD: requesting commit %d/%d\n",
 			  journal->j_commit_request,
@@ -497,12 +498,12 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t target)
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
@@ -539,7 +540,7 @@ int jbd2_journal_force_commit_nested(journal_t *journal)
 	tid = transaction->t_tid;
 	read_unlock(&journal->j_state_lock);
 	if (need_to_start)
-		jbd2_log_start_commit(journal, tid);
+		jbd2_log_start_commit(journal, tid, true);
 	jbd2_log_wait_commit(journal, tid);
 	return 1;
 }
@@ -549,7 +550,7 @@ int jbd2_journal_force_commit_nested(journal_t *journal)
  * if a transaction is going to be committed (or is currently already
  * committing), and fills its tid in at *ptid
  */
-int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
+int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid, bool will_wait)
 {
 	int ret = 0;
 
@@ -557,7 +558,7 @@ int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
 	if (journal->j_running_transaction) {
 		tid_t tid = journal->j_running_transaction->t_tid;
 
-		__jbd2_log_start_commit(journal, tid);
+		__jbd2_log_start_commit(journal, tid, will_wait);
 		/* There's a running transaction and we've just made sure
 		 * it's commit has been scheduled. */
 		if (ptid)
@@ -1564,7 +1565,7 @@ int jbd2_journal_flush(journal_t *journal)
 	/* Force everything buffered to the log... */
 	if (journal->j_running_transaction) {
 		transaction = journal->j_running_transaction;
-		__jbd2_log_start_commit(journal, transaction->t_tid);
+		__jbd2_log_start_commit(journal, transaction->t_tid, true);
 	} else if (journal->j_committing_transaction)
 		transaction = journal->j_committing_transaction;
 
@@ -1680,7 +1681,7 @@ void __jbd2_journal_abort_hard(journal_t *journal)
 	journal->j_flags |= JBD2_ABORT;
 	transaction = journal->j_running_transaction;
 	if (transaction)
-		__jbd2_log_start_commit(journal, transaction->t_tid);
+		__jbd2_log_start_commit(journal, transaction->t_tid, false);
 	write_unlock(&journal->j_state_lock);
 }
 
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 1d11910..340dd5e 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -226,7 +226,7 @@ repeat:
 		need_to_start = !tid_geq(journal->j_commit_request, tid);
 		read_unlock(&journal->j_state_lock);
 		if (need_to_start)
-			jbd2_log_start_commit(journal, tid);
+			jbd2_log_start_commit(journal, tid, false);
 		schedule();
 		finish_wait(&journal->j_wait_transaction_locked, &wait);
 		goto repeat;
@@ -469,8 +469,12 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mask)
 	spin_unlock(&transaction->t_handle_lock);
 
 	jbd_debug(2, "restarting handle %p\n", handle);
+<<<<<<< HEAD
 	tid = transaction->t_tid;
 	need_to_start = !tid_geq(journal->j_commit_request, tid);
+=======
+	__jbd2_log_start_commit(journal, transaction->t_tid, false);
+>>>>>>> jbd2: Refine commit writeout logic
 	read_unlock(&journal->j_state_lock);
 	if (need_to_start)
 		jbd2_log_start_commit(journal, tid);
@@ -1368,8 +1372,6 @@ int jbd2_journal_stop(handle_t *handle)
 		}
 	}
 
-	if (handle->h_sync)
-		transaction->t_synchronous_commit = 1;
 	current->journal_info = NULL;
 	atomic_sub(handle->h_buffer_credits,
 		   &transaction->t_outstanding_credits);
@@ -1390,15 +1392,16 @@ int jbd2_journal_stop(handle_t *handle)
 
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
index 38f986d..45d9f82 100644
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


--UPT3ojh+0CqEDtpF
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-jbd-Refine-commit-writeout-logic.patch"

>From 3e4f42155513df7b6d36584e7b8383b86f425467 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 21 Feb 2011 17:25:37 +0100
Subject: [PATCH 2/2] jbd: Refine commit writeout logic

Currently we write out all journal buffers in WRITE_SYNC mode. This improves
performance for fsync heavy workloads but hinders performance when writes
are mostly asynchronous. So add possibility for callers starting a transaction
commit to specify whether they are going to wait for the commit and submit
journal writes in WRITE_SYNC mode only in that case.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/fsync.c      |    2 +-
 fs/ext3/super.c      |    2 +-
 fs/jbd/checkpoint.c  |    2 +-
 fs/jbd/commit.c      |    4 ++--
 fs/jbd/journal.c     |   19 ++++++++++---------
 fs/jbd/transaction.c |    9 ++++-----
 include/linux/jbd.h  |   21 ++++++++++++---------
 7 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index 09b13bb..5396dd6 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -81,7 +81,7 @@ int ext3_sync_file(struct file *file, int datasync)
 	if (test_opt(inode->i_sb, BARRIER) &&
 	    !journal_trans_will_send_data_barrier(journal, commit_tid))
 		needs_barrier = 1;
-	log_start_commit(journal, commit_tid);
+	log_start_commit(journal, commit_tid, true);
 	ret = log_wait_commit(journal, commit_tid);
 
 	/*
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 85c8cc8..58a4424 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2497,7 +2497,7 @@ static int ext3_sync_fs(struct super_block *sb, int wait)
 {
 	tid_t target;
 
-	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
+	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target, true)) {
 		if (wait)
 			log_wait_commit(EXT3_SB(sb)->s_journal, target);
 	}
diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index e4b87bc..26ca2c3 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -297,7 +297,7 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 
 		spin_unlock(&journal->j_list_lock);
 		jbd_unlock_bh_state(bh);
-		log_start_commit(journal, tid);
+		log_start_commit(journal, tid, true);
 		log_wait_commit(journal, tid);
 		ret = 1;
 	} else if (!buffer_dirty(bh)) {
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 34a4861..ac188cb 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -294,7 +294,7 @@ void journal_commit_transaction(journal_t *journal)
 	int first_tag = 0;
 	int tag_flag;
 	int i;
-	int write_op = WRITE_SYNC;
+	int write_op = WRITE;
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -332,7 +332,7 @@ void journal_commit_transaction(journal_t *journal)
 	 * we unplug the device. We don't do explicit unplugging in here,
 	 * instead we rely on sync_buffer() doing the unplug for us.
 	 */
-	if (commit_transaction->t_synchronous_commit)
+	if (tid_geq(journal->j_commit_waited, commit_transaction->t_tid))
 		write_op = WRITE_SYNC_PLUG;
 	spin_lock(&commit_transaction->t_handle_lock);
 	while (commit_transaction->t_updates) {
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index da1b5e4..5743b4c 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -434,7 +434,7 @@ int __log_space_left(journal_t *journal)
 /*
  * Called under j_state_lock.  Returns true if a transaction commit was started.
  */
-int __log_start_commit(journal_t *journal, tid_t target)
+int __log_start_commit(journal_t *journal, tid_t target, bool will_wait)
 {
 	/*
 	 * Are we already doing a recent enough commit?
@@ -444,7 +444,8 @@ int __log_start_commit(journal_t *journal, tid_t target)
 		 * We want a new commit: OK, mark the request and wakeup the
 		 * commit thread.  We do _not_ do the commit ourselves.
 		 */
-
+		if (will_wait && !tid_geq(journal->j_commit_waited, target))
+			journal->j_commit_waited = target;
 		journal->j_commit_request = target;
 		jbd_debug(1, "JBD: requesting commit %d/%d\n",
 			  journal->j_commit_request,
@@ -455,12 +456,12 @@ int __log_start_commit(journal_t *journal, tid_t target)
 	return 0;
 }
 
-int log_start_commit(journal_t *journal, tid_t tid)
+int log_start_commit(journal_t *journal, tid_t tid, bool will_wait)
 {
 	int ret;
 
 	spin_lock(&journal->j_state_lock);
-	ret = __log_start_commit(journal, tid);
+	ret = __log_start_commit(journal, tid, will_wait);
 	spin_unlock(&journal->j_state_lock);
 	return ret;
 }
@@ -483,7 +484,7 @@ int journal_force_commit_nested(journal_t *journal)
 	spin_lock(&journal->j_state_lock);
 	if (journal->j_running_transaction && !current->journal_info) {
 		transaction = journal->j_running_transaction;
-		__log_start_commit(journal, transaction->t_tid);
+		__log_start_commit(journal, transaction->t_tid, true);
 	} else if (journal->j_committing_transaction)
 		transaction = journal->j_committing_transaction;
 
@@ -503,7 +504,7 @@ int journal_force_commit_nested(journal_t *journal)
  * if a transaction is going to be committed (or is currently already
  * committing), and fills its tid in at *ptid
  */
-int journal_start_commit(journal_t *journal, tid_t *ptid)
+int journal_start_commit(journal_t *journal, tid_t *ptid, bool will_wait)
 {
 	int ret = 0;
 
@@ -511,7 +512,7 @@ int journal_start_commit(journal_t *journal, tid_t *ptid)
 	if (journal->j_running_transaction) {
 		tid_t tid = journal->j_running_transaction->t_tid;
 
-		__log_start_commit(journal, tid);
+		__log_start_commit(journal, tid, will_wait);
 		/* There's a running transaction and we've just made sure
 		 * it's commit has been scheduled. */
 		if (ptid)
@@ -1439,7 +1440,7 @@ int journal_flush(journal_t *journal)
 	/* Force everything buffered to the log... */
 	if (journal->j_running_transaction) {
 		transaction = journal->j_running_transaction;
-		__log_start_commit(journal, transaction->t_tid);
+		__log_start_commit(journal, transaction->t_tid, true);
 	} else if (journal->j_committing_transaction)
 		transaction = journal->j_committing_transaction;
 
@@ -1573,7 +1574,7 @@ static void __journal_abort_hard(journal_t *journal)
 	journal->j_flags |= JFS_ABORT;
 	transaction = journal->j_running_transaction;
 	if (transaction)
-		__log_start_commit(journal, transaction->t_tid);
+		__log_start_commit(journal, transaction->t_tid, false);
 	spin_unlock(&journal->j_state_lock);
 }
 
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 5b2e4c3..a12c0a3 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -178,7 +178,7 @@ repeat_locked:
 		spin_unlock(&transaction->t_handle_lock);
 		prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
 				TASK_UNINTERRUPTIBLE);
-		__log_start_commit(journal, transaction->t_tid);
+		__log_start_commit(journal, transaction->t_tid, false);
 		spin_unlock(&journal->j_state_lock);
 		schedule();
 		finish_wait(&journal->j_wait_transaction_locked, &wait);
@@ -411,7 +411,7 @@ int journal_restart(handle_t *handle, int nblocks)
 	spin_unlock(&transaction->t_handle_lock);
 
 	jbd_debug(2, "restarting handle %p\n", handle);
-	__log_start_commit(journal, transaction->t_tid);
+	__log_start_commit(journal, transaction->t_tid, false);
 	spin_unlock(&journal->j_state_lock);
 
 	lock_map_release(&handle->h_lockdep_map);
@@ -1431,8 +1431,6 @@ int journal_stop(handle_t *handle)
 		}
 	}
 
-	if (handle->h_sync)
-		transaction->t_synchronous_commit = 1;
 	current->journal_info = NULL;
 	spin_lock(&journal->j_state_lock);
 	spin_lock(&transaction->t_handle_lock);
@@ -1463,7 +1461,8 @@ int journal_stop(handle_t *handle)
 		jbd_debug(2, "transaction too old, requesting commit for "
 					"handle %p\n", handle);
 		/* This is non-blocking */
-		__log_start_commit(journal, transaction->t_tid);
+		__log_start_commit(journal, transaction->t_tid,
+			handle->h_sync && !(current->flags & PF_MEMALLOC));
 		spin_unlock(&journal->j_state_lock);
 
 		/*
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index e069650..c38f73e 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -541,12 +541,6 @@ struct transaction_s
 	 * How many handles used this transaction? [t_handle_lock]
 	 */
 	int t_handle_count;
-
-	/*
-	 * This transaction is being forced and some process is
-	 * waiting for it to finish.
-	 */
-	unsigned int t_synchronous_commit:1;
 };
 
 /**
@@ -594,6 +588,8 @@ struct transaction_s
  *  transaction
  * @j_commit_request: Sequence number of the most recent transaction wanting
  *     commit
+ * @j_commit_waited: Sequence number of the most recent transaction someone
+ *     is waiting for to commit.
  * @j_uuid: Uuid of client object.
  * @j_task: Pointer to the current commit thread for this journal
  * @j_max_transaction_buffers:  Maximum number of metadata buffers to allow in a
@@ -762,6 +758,13 @@ struct journal_s
 	tid_t			j_commit_request;
 
 	/*
+	 * Sequence number of the most recent transaction someone is waiting
+	 * for to commit.
+	 * [j_state_lock]
+	 */
+	tid_t                   j_commit_waited;
+
+	/*
 	 * Journal uuid: identifies the object (filesystem, LVM volume etc)
 	 * backed by this journal.  This will eventually be replaced by an array
 	 * of uuids, allowing us to index multiple devices within a single
@@ -985,9 +988,9 @@ extern void	journal_switch_revoke_table(journal_t *journal);
  */
 
 int __log_space_left(journal_t *); /* Called with journal locked */
-int log_start_commit(journal_t *journal, tid_t tid);
-int __log_start_commit(journal_t *journal, tid_t tid);
-int journal_start_commit(journal_t *journal, tid_t *tid);
+int log_start_commit(journal_t *journal, tid_t tid, bool will_wait);
+int __log_start_commit(journal_t *journal, tid_t tid, bool will_wait);
+int journal_start_commit(journal_t *journal, tid_t *tid, bool will_wait);
 int journal_force_commit_nested(journal_t *journal);
 int log_wait_commit(journal_t *journal, tid_t tid);
 int log_do_checkpoint(journal_t *journal);
-- 
1.7.1


--UPT3ojh+0CqEDtpF--
