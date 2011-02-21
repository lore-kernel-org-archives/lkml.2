Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1BUQtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:49:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:41522 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab1BUQtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:49:14 -0500
Date: Mon, 21 Feb 2011 17:49:09 +0100
From: Jan Kara <jack@suse.cz>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "Shi, Alex" <alex.shi@intel.com>, Jan Kara <jack@suse.cz>,
        Corrado Zoccolo <czoccolo@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
Message-ID: <20110221164909.GG6584@quack.suse.cz>
References: <1295402148.4773.143.camel@debian>
 <1295402606.1949.871.camel@sli10-conroe>
 <20110120151656.GC18875@redhat.com>
 <20110126081529.GA28909@sli10-conroe.sh.intel.com>
 <1297502512.29573.26.camel@debian>
 <AANLkTi=B6kabp+NvRJC_g-AqQO0ZOvnEDYpVFmScttR6@mail.gmail.com>
 <1297650318.29573.2482.camel@debian>
 <1297732201.24560.2.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <1297732201.24560.2.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 15-02-11 09:10:01, Shaohua Li wrote:
> On Mon, 2011-02-14 at 10:25 +0800, Shi, Alex wrote:
> > On Sun, 2011-02-13 at 02:25 +0800, Corrado Zoccolo wrote:
> > > On Sat, Feb 12, 2011 at 10:21 AM, Alex,Shi <alex.shi@intel.com> wrote:
> > > > On Wed, 2011-01-26 at 16:15 +0800, Li, Shaohua wrote:
> > > >> On Thu, Jan 20, 2011 at 11:16:56PM +0800, Vivek Goyal wrote:
> > > >> > On Wed, Jan 19, 2011 at 10:03:26AM +0800, Shaohua Li wrote:
> > > >> > > add Jan and Theodore to the loop.
> > > >> > >
> > > >> > > On Wed, 2011-01-19 at 09:55 +0800, Shi, Alex wrote:
> > > >> > > > Shaohua and I tested kernel building performance on latest kernel. and
> > > >> > > > found it is drop about 15% on our 64 LCPUs NHM-EX machine on ext4 file
> > > >> > > > system. We find this performance dropping is due to commit
> > > >> > > > 749ef9f8423054e326f. If we revert this patch or just change the
> > > >> > > > WRITE_SYNC back to WRITE in jbd2/commit.c file. the performance can be
> > > >> > > > recovered.
> > > >> > > >
> > > >> > > > iostat report show with the commit, read request merge number increased
> > > >> > > > and write request merge dropped. The total request size increased and
> > > >> > > > queue length dropped. So we tested another patch: only change WRITE_SYNC
> > > >> > > > to WRITE_SYNC_PLUG in jbd2/commit.c, but nothing effected.
> > > >> > > since WRITE_SYNC_PLUG doesn't work, this isn't a simple no-write-merge issue.
> > > >> > >
> > > >> >
> > > >> > Yep, it does sound like reduce write merging. But moving journal commits
> > > >> > back to WRITE, then fsync performance will drop as there will be idling
> > > >> > introduced between fsync thread and journalling thread. So that does
> > > >> > not sound like a good idea either.
> > > >> >
> > > >> > Secondly, in presence of mixed workload (some other sync read happening)
> > > >> > WRITES can get less bandwidth and sync workload much more. So by
> > > >> > marking journal commits as WRITES you might increase the delay there
> > > >> > in completion in presence of other sync workload.
> > > >> >
> > > >> > So Jan Kara's approach makes sense that if somebody is waiting on
> > > >> > commit then make it WRITE_SYNC otherwise make it WRITE. Not sure why
> > > >> > did it not work for you. Is it possible to run some traces and do
> > > >> > more debugging that figure out what's happening.
> > > >> Sorry for the long delay.
> > > >>
> > > >> Looks fedora enables ccache by default. While our kbuild test is on ext4 disk
> > > >> but rootfs is on ext3 where ccache cache files live. Jan's patch only covers
> > > >> ext4, maybe this is the reason.
> > > >> I changed jbd to use WRITE for journal_commit_transaction. With the change and
> > > >> Jan's patch, the test seems fine.
> > > > Let me clarify the bug situation again.
> > > > With the following scenarios, the regression is clear.
> > > > 1, ccache_dir setup at rootfs that format is ext3 on /dev/sda1; 2,
> > > > kbuild on /dev/sdb1 with ext4.
> > > > but if we disable the ccache, only do kbuild on sdb1 with ext4. There is
> > > > no regressions whenever with or without Jan's patch.
> > > > So, problem focus on the ccache scenario, (from fedora 11, ccache is
> > > > default setting).
> > > >
> > > > If we compare the vmstat output with or without ccache, there is too
> > > > many write when ccache enabled. According the result, it should to do
> > > > some tunning on ext3 fs.
> > > Is ext3 configured with data ordered or writeback?
> > 
> > The ext3 on sda and ext4 on sdb are both used 'ordered' mounting mode. 
> > 
> > > I think ccache might be performing fsyncs, and this is a bad workload
> > > for ext3, especially in ordered mode.
> > > It might be that my patch introduced a regression in ext3 fsync
> > > performance, but I don't understand how reverting only the change in
> > > jbd2 (that is the ext4 specific journaling daemon) could restore it.
> > > The two partitions are on different disks, so each one should be
> > > isolated from the I/O perspective (do they share a single
> > > controller?).
> > 
> > No, sda/sdb use separated controller. 
> >  
> > >  The only interaction I see happens at the VM level,
> > > since changing performance of any of the two changes the rate at which
> > > pages can be cleaned.
> > > 
> > > Corrado
> > > >
> > > >
> > > > vmstat average output per 10 seconds, without ccache
> > > > procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
> > > >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> > > > 26.8 0.5 0.0 63930192.3 9677.0 96544.9 0.0 0.0 2486.9 337.9 17729.9 4496.4 17.5 2.5 79.8 0.2 0.0
> > > >
> > > > vmstat average output per 10 seconds, with ccache
> > > > procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
> > > >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> > > > 2.4 40.7 0.0 64316231.0 17260.6 119533.8 0.0 0.0 2477.6 1493.1 8606.4 3565.2 2.5 1.1 83.0 13.5 0.0
> > > >
> > > >
> > > >>
> > > >> Jan,
> > > >> can you send a patch with similar change for ext3? So we can do more tests.
> Hi Jan,
> can you send a patch with both ext3 and ext4 changes? Our test shows
> your patch has positive effect, but need confirm with the ext3 change.
  Sure. Patches for both ext3 & ext4 are attached. Sorry, it took me a
while to get to this.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--DocE+STaALJfprDB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-jbd2-Refine-commit-writeout-logic.patch"

>From 5674f84e70db8274d5aac56a41439ea3b3bcb46e Mon Sep 17 00:00:00 2001
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
index 48ce561..0aeb877 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4113,7 +4113,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 
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
index faad2bd..c48e6e8 100644
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


--DocE+STaALJfprDB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-jbd-Refine-commit-writeout-logic.patch"

>From ff2be0c11564d1253d9420ee0f805f2ba8f62e9f Mon Sep 17 00:00:00 2001
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


--DocE+STaALJfprDB--
