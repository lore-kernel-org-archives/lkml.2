Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1FXU7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 16:59:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5336 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1FXU65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 16:58:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=ncSrw9l7Ea4DoIQAKnN6Bhg9eKgq85d4FWQrlAOTvVB8lvsYXx3ruklBJAUrnADNM
	BgvQegdpjvCiCDJ9IRYng==
From: Justin TerAvest <teravest@google.com>
To: jaxboe@fusionio.com, viro@zeniv.linux.org.uk, jeffm@suse.de,
        tytso@google.com
Cc: mingo@elte.hu, peterz@infradead.org, hch@infradead.org,
        linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: [PATCH] fixlet: Remove fs_excl from struct task.
Date: Fri, 24 Jun 2011 13:58:27 -0700
Message-Id: <1308949107-1962-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs_excl is a poor man's priority inheritance for filesystems to hint to
the block layer that an operation is important. It was never clearly
specified, not widely adopted, and will not prevent starvation in many
cases (like across cgroups).

I talked to Ted Ts'o about this, and he said that it used to used more
frequently in the 2.4 and prior versions of Linux, back when we were
first converting from the Big Kernel Lock to having subsystem level
locks, and so it made sense to use fs_excl when a process owned the
global fs mutex and was waiting for an I/O to complete, but it's no
longer used much at all, and filesystems have better ways to mark an I/O
request as high priority.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c       |   28 +---------------------------
 fs/reiserfs/journal.c     |   13 -------------
 fs/super.c                |    4 ----
 include/linux/fs.h        |    4 ----
 include/linux/init_task.h |    1 -
 include/linux/sched.h     |    1 -
 kernel/exit.c             |    1 -
 kernel/fork.c             |    1 -
 8 files changed, 1 insertions(+), 52 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f379943..dd485fa 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -136,7 +136,7 @@ struct cfq_queue {
 
 	/* io prio of this group */
 	unsigned short ioprio, org_ioprio;
-	unsigned short ioprio_class, org_ioprio_class;
+	unsigned short ioprio_class;
 
 	pid_t pid;
 
@@ -2880,7 +2880,6 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 	 * elevate the priority of this queue
 	 */
 	cfqq->org_ioprio = cfqq->ioprio;
-	cfqq->org_ioprio_class = cfqq->ioprio_class;
 	cfq_clear_cfqq_prio_changed(cfqq);
 }
 
@@ -3612,30 +3611,6 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		cfq_schedule_dispatch(cfqd);
 }
 
-/*
- * we temporarily boost lower priority queues if they are holding fs exclusive
- * resources. they are boosted to normal prio (CLASS_BE/4)
- */
-static void cfq_prio_boost(struct cfq_queue *cfqq)
-{
-	if (has_fs_excl()) {
-		/*
-		 * boost idle prio on transactions that would lock out other
-		 * users of the filesystem
-		 */
-		if (cfq_class_idle(cfqq))
-			cfqq->ioprio_class = IOPRIO_CLASS_BE;
-		if (cfqq->ioprio > IOPRIO_NORM)
-			cfqq->ioprio = IOPRIO_NORM;
-	} else {
-		/*
-		 * unboost the queue (if needed)
-		 */
-		cfqq->ioprio_class = cfqq->org_ioprio_class;
-		cfqq->ioprio = cfqq->org_ioprio;
-	}
-}
-
 static inline int __cfq_may_queue(struct cfq_queue *cfqq)
 {
 	if (cfq_cfqq_wait_request(cfqq) && !cfq_cfqq_must_alloc_slice(cfqq)) {
@@ -3666,7 +3641,6 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 	cfqq = cic_to_cfqq(cic, rw_is_sync(rw));
 	if (cfqq) {
 		cfq_init_prio_data(cfqq, cic->ioc);
-		cfq_prio_boost(cfqq);
 
 		return __cfq_may_queue(cfqq);
 	}
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index c5e82ec..a159ba5 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -678,23 +678,19 @@ struct buffer_chunk {
 static void write_chunk(struct buffer_chunk *chunk)
 {
 	int i;
-	get_fs_excl();
 	for (i = 0; i < chunk->nr; i++) {
 		submit_logged_buffer(chunk->bh[i]);
 	}
 	chunk->nr = 0;
-	put_fs_excl();
 }
 
 static void write_ordered_chunk(struct buffer_chunk *chunk)
 {
 	int i;
-	get_fs_excl();
 	for (i = 0; i < chunk->nr; i++) {
 		submit_ordered_buffer(chunk->bh[i]);
 	}
 	chunk->nr = 0;
-	put_fs_excl();
 }
 
 static int add_to_chunk(struct buffer_chunk *chunk, struct buffer_head *bh,
@@ -986,8 +982,6 @@ static int flush_commit_list(struct super_block *s,
 		return 0;
 	}
 
-	get_fs_excl();
-
 	/* before we can put our commit blocks on disk, we have to make sure everyone older than
 	 ** us is on disk too
 	 */
@@ -1145,7 +1139,6 @@ static int flush_commit_list(struct super_block *s,
 	if (retval)
 		reiserfs_abort(s, retval, "Journal write error in %s",
 			       __func__);
-	put_fs_excl();
 	return retval;
 }
 
@@ -1374,8 +1367,6 @@ static int flush_journal_list(struct super_block *s,
 		return 0;
 	}
 
-	get_fs_excl();
-
 	/* if all the work is already done, get out of here */
 	if (atomic_read(&(jl->j_nonzerolen)) <= 0 &&
 	    atomic_read(&(jl->j_commit_left)) <= 0) {
@@ -1597,7 +1588,6 @@ static int flush_journal_list(struct super_block *s,
 	put_journal_list(s, jl);
 	if (flushall)
 		mutex_unlock(&journal->j_flush_mutex);
-	put_fs_excl();
 	return err;
 }
 
@@ -3108,7 +3098,6 @@ static int do_journal_begin_r(struct reiserfs_transaction_handle *th,
 	th->t_trans_id = journal->j_trans_id;
 	unlock_journal(sb);
 	INIT_LIST_HEAD(&th->t_list);
-	get_fs_excl();
 	return 0;
 
       out_fail:
@@ -3964,7 +3953,6 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
 	flush = flags & FLUSH_ALL;
 	wait_on_commit = flags & WAIT;
 
-	put_fs_excl();
 	current->journal_info = th->t_handle_save;
 	reiserfs_check_lock_depth(sb, "journal end");
 	if (journal->j_len == 0) {
@@ -4316,4 +4304,3 @@ void reiserfs_abort_journal(struct super_block *sb, int errno)
 	dump_stack();
 #endif
 }
-
diff --git a/fs/super.c b/fs/super.c
index ab3d672..cf12ba5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -245,13 +245,11 @@ static int grab_super(struct super_block *s) __releases(sb_lock)
  */
 void lock_super(struct super_block * sb)
 {
-	get_fs_excl();
 	mutex_lock(&sb->s_lock);
 }
 
 void unlock_super(struct super_block * sb)
 {
-	put_fs_excl();
 	mutex_unlock(&sb->s_lock);
 }
 
@@ -280,7 +278,6 @@ void generic_shutdown_super(struct super_block *sb)
 	if (sb->s_root) {
 		shrink_dcache_for_umount(sb);
 		sync_filesystem(sb);
-		get_fs_excl();
 		sb->s_flags &= ~MS_ACTIVE;
 
 		fsnotify_unmount_inodes(&sb->s_inodes);
@@ -295,7 +292,6 @@ void generic_shutdown_super(struct super_block *sb)
 			   "Self-destruct in 5 seconds.  Have a nice day...\n",
 			   sb->s_id);
 		}
-		put_fs_excl();
 	}
 	spin_lock(&sb_lock);
 	/* should be initialized for __put_super_and_need_restart() */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6e73e2e..f6c866c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1453,10 +1453,6 @@ enum {
 #define vfs_check_frozen(sb, level) \
 	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
 
-#define get_fs_excl() atomic_inc(&current->fs_excl)
-#define put_fs_excl() atomic_dec(&current->fs_excl)
-#define has_fs_excl() atomic_read(&current->fs_excl)
-
 /*
  * until VFS tracks user namespaces for inodes, just make all files
  * belong to init_user_ns
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 580f70c..d14e058 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -176,7 +176,6 @@ extern struct cred init_cred;
 	.alloc_lock	= __SPIN_LOCK_UNLOCKED(tsk.alloc_lock),		\
 	.journal_info	= NULL,						\
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
-	.fs_excl	= ATOMIC_INIT(0),				\
 	.pi_lock	= __RAW_SPIN_LOCK_UNLOCKED(tsk.pi_lock),	\
 	.timer_slack_ns = 50000, /* 50 usec default slack */		\
 	.pids = {							\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a837b20..22f5424 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1503,7 +1503,6 @@ struct task_struct {
 	short il_next;
 	short pref_node_fork;
 #endif
-	atomic_t fs_excl;	/* holding fs exclusive resources */
 	struct rcu_head rcu;
 
 	/*
diff --git a/kernel/exit.c b/kernel/exit.c
index f2b321b..b412df4 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -906,7 +906,6 @@ NORET_TYPE void do_exit(long code)
 
 	profile_task_exit(tsk);
 
-	WARN_ON(atomic_read(&tsk->fs_excl));
 	WARN_ON(blk_needs_flush_plug(tsk));
 
 	if (unlikely(in_interrupt()))
diff --git a/kernel/fork.c b/kernel/fork.c
index 0276c30..30a0e86 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -291,7 +291,6 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 
 	/* One for us, one for whoever does the "release_task()" (usually parent) */
 	atomic_set(&tsk->usage,2);
-	atomic_set(&tsk->fs_excl, 0);
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	tsk->btrace_seq = 0;
 #endif
-- 
1.7.3.1

