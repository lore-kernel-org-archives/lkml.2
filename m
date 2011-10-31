Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934100Ab1JaTFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:05:46 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44251 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033Ab1JaTFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:05:43 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>, Samuel Ortiz <samuel@sortiz.org>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/17] freezer: unexport refrigerator() and update try_to_freeze() slightly
Date: Mon, 31 Oct 2011 12:05:14 -0700
Message-Id: <1320087928-32307-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to export two functions for entering the
refrigerator.  Calling refrigerator() instead of try_to_freeze()
doesn't save anything noticeable or removes any race condition.

* Rename refrigerator() to __refrigerator() and make it return bool
  indicating whether it scheduled out for freezing.

* Update try_to_freeze() to return bool and relay the return value of
  __refrigerator() if freezing().

* Convert all refrigerator() users to try_to_freeze().

* Update documentation accordingly.

* While at it, add might_sleep() to try_to_freeze().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>
---
 Documentation/power/freezing-of-tasks.txt |   12 ++++++------
 drivers/net/irda/stir4200.c               |    2 +-
 fs/btrfs/async-thread.c                   |    2 +-
 fs/btrfs/disk-io.c                        |    8 ++------
 fs/ext4/super.c                           |    3 +--
 fs/gfs2/log.c                             |    4 ++--
 fs/gfs2/quota.c                           |    4 ++--
 fs/jbd/journal.c                          |    2 +-
 fs/jbd2/journal.c                         |    2 +-
 fs/jfs/jfs_logmgr.c                       |    2 +-
 fs/jfs/jfs_txnmgr.c                       |    4 ++--
 fs/nilfs2/segment.c                       |    2 +-
 fs/xfs/xfs_buf.c                          |    2 +-
 include/linux/freezer.h                   |   17 ++++++++---------
 kernel/freezer.c                          |   10 +++++++---
 15 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
index 710c965..cbea897 100644
--- a/Documentation/power/freezing-of-tasks.txt
+++ b/Documentation/power/freezing-of-tasks.txt
@@ -21,7 +21,7 @@ freeze_processes() (defined in kernel/power/process.c) is called.  It executes
 try_to_freeze_tasks() that sets TIF_FREEZE for all of the freezable tasks and
 either wakes them up, if they are kernel threads, or sends fake signals to them,
 if they are user space processes.  A task that has TIF_FREEZE set, should react
-to it by calling the function called refrigerator() (defined in
+to it by calling the function called __refrigerator() (defined in
 kernel/power/process.c), which sets the task's PF_FROZEN flag, changes its state
 to TASK_UNINTERRUPTIBLE and makes it loop until PF_FROZEN is cleared for it.
 Then, we say that the task is 'frozen' and therefore the set of functions
@@ -29,10 +29,10 @@ handling this mechanism is referred to as 'the freezer' (these functions are
 defined in kernel/power/process.c and include/linux/freezer.h).  User space
 processes are generally frozen before kernel threads.
 
-It is not recommended to call refrigerator() directly.  Instead, it is
-recommended to use the try_to_freeze() function (defined in
-include/linux/freezer.h), that checks the task's TIF_FREEZE flag and makes the
-task enter refrigerator() if the flag is set.
+__refrigerator() must not be called directly.  Instead, use the
+try_to_freeze() function (defined in include/linux/freezer.h), that checks
+the task's TIF_FREEZE flag and makes the task enter __refrigerator() if the
+flag is set.
 
 For user space processes try_to_freeze() is called automatically from the
 signal-handling code, but the freezable kernel threads need to call it
@@ -61,7 +61,7 @@ wait_event_freezable() and wait_event_freezable_timeout() macros.
 After the system memory state has been restored from a hibernation image and
 devices have been reinitialized, the function thaw_processes() is called in
 order to clear the PF_FROZEN flag for each frozen task.  Then, the tasks that
-have been frozen leave refrigerator() and continue running.
+have been frozen leave __refrigerator() and continue running.
 
 III. Which kernel threads are freezable?
 
diff --git a/drivers/net/irda/stir4200.c b/drivers/net/irda/stir4200.c
index 41c96b3..e880c79 100644
--- a/drivers/net/irda/stir4200.c
+++ b/drivers/net/irda/stir4200.c
@@ -750,7 +750,7 @@ static int stir_transmit_thread(void *arg)
 
 			write_reg(stir, REG_CTRL1, CTRL1_TXPWD|CTRL1_RXPWD);
 
-			refrigerator();
+			try_to_freeze();
 
 			if (change_speed(stir, stir->speed))
 				break;
diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7ec1409..98ab240 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -340,7 +340,7 @@ again:
 		if (freezing(current)) {
 			worker->working = 0;
 			spin_unlock_irq(&worker->lock);
-			refrigerator();
+			try_to_freeze();
 		} else {
 			spin_unlock_irq(&worker->lock);
 			if (!kthread_should_stop()) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 07b3ac6..64b1c07 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1508,9 +1508,7 @@ static int cleaner_kthread(void *arg)
 			btrfs_run_defrag_inodes(root->fs_info);
 		}
 
-		if (freezing(current)) {
-			refrigerator();
-		} else {
+		if (!try_to_freeze()) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!kthread_should_stop())
 				schedule();
@@ -1564,9 +1562,7 @@ sleep:
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
 
-		if (freezing(current)) {
-			refrigerator();
-		} else {
+		if (!try_to_freeze()) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!kthread_should_stop() &&
 			    !btrfs_transaction_blocked(root->fs_info))
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 44d0c8d..45e5c43 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2853,8 +2853,7 @@ cont_thread:
 		}
 		mutex_unlock(&eli->li_list_mtx);
 
-		if (freezing(current))
-			refrigerator();
+		try_to_freeze();
 
 		cur = jiffies;
 		if ((time_after_eq(cur, next_wakeup)) ||
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 5986464..8154d42 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -951,8 +951,8 @@ int gfs2_logd(void *data)
 			wake_up(&sdp->sd_log_waitq);
 
 		t = gfs2_tune_get(sdp, gt_logd_secs) * HZ;
-		if (freezing(current))
-			refrigerator();
+
+		try_to_freeze();
 
 		do {
 			prepare_to_wait(&sdp->sd_logd_waitq, &wait,
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 7e528dc..d49669e 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1427,8 +1427,8 @@ int gfs2_quotad(void *data)
 		/* Check for & recover partially truncated inodes */
 		quotad_check_trunc_list(sdp);
 
-		if (freezing(current))
-			refrigerator();
+		try_to_freeze();
+
 		t = min(quotad_timeo, statfs_timeo);
 
 		prepare_to_wait(&sdp->sd_quota_wait, &wait, TASK_INTERRUPTIBLE);
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 9fe061f..908fdf0 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -166,7 +166,7 @@ loop:
 		 */
 		jbd_debug(1, "Now suspending kjournald\n");
 		spin_unlock(&journal->j_state_lock);
-		refrigerator();
+		try_to_freeze();
 		spin_lock(&journal->j_state_lock);
 	} else {
 		/*
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index f24df13..874d1c4 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -173,7 +173,7 @@ loop:
 		 */
 		jbd_debug(1, "Now suspending kjournald2\n");
 		write_unlock(&journal->j_state_lock);
-		refrigerator();
+		try_to_freeze();
 		write_lock(&journal->j_state_lock);
 	} else {
 		/*
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 583636f..c8c2d35 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2348,7 +2348,7 @@ int jfsIOWait(void *arg)
 
 		if (freezing(current)) {
 			spin_unlock_irq(&log_redrive_lock);
-			refrigerator();
+			try_to_freeze();
 		} else {
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_irq(&log_redrive_lock);
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index af96060..bb8b661 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -2800,7 +2800,7 @@ int jfs_lazycommit(void *arg)
 
 		if (freezing(current)) {
 			LAZY_UNLOCK(flags);
-			refrigerator();
+			try_to_freeze();
 		} else {
 			DECLARE_WAITQUEUE(wq, current);
 
@@ -2994,7 +2994,7 @@ int jfs_sync(void *arg)
 
 		if (freezing(current)) {
 			TXN_UNLOCK();
-			refrigerator();
+			try_to_freeze();
 		} else {
 			set_current_state(TASK_INTERRUPTIBLE);
 			TXN_UNLOCK();
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index bb24ab6..0e72ad6 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2470,7 +2470,7 @@ static int nilfs_segctor_thread(void *arg)
 
 	if (freezing(current)) {
 		spin_unlock(&sci->sc_state_lock);
-		refrigerator();
+		try_to_freeze();
 		spin_lock(&sci->sc_state_lock);
 	} else {
 		DEFINE_WAIT(wait);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index cf0ac05..0188299 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1703,7 +1703,7 @@ xfsbufd(
 
 		if (unlikely(freezing(current))) {
 			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
-			refrigerator();
+			try_to_freeze();
 		} else {
 			clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
 		}
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index a49b529..984b367 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -47,18 +47,17 @@ static inline bool should_send_signal(struct task_struct *p)
 /* Takes and releases task alloc lock using task_lock() */
 extern int thaw_process(struct task_struct *p);
 
-extern void refrigerator(void);
+extern bool __refrigerator(void);
 extern int freeze_processes(void);
 extern int freeze_kernel_threads(void);
 extern void thaw_processes(void);
 
-static inline int try_to_freeze(void)
+static inline bool try_to_freeze(void)
 {
-	if (freezing(current)) {
-		refrigerator();
-		return 1;
-	} else
-		return 0;
+	might_sleep();
+	if (likely(!freezing(current)))
+		return false;
+	return __refrigerator();
 }
 
 extern bool freeze_task(struct task_struct *p, bool sig_only);
@@ -186,12 +185,12 @@ static inline void set_freeze_flag(struct task_struct *p) {}
 static inline void clear_freeze_flag(struct task_struct *p) {}
 static inline int thaw_process(struct task_struct *p) { return 1; }
 
-static inline void refrigerator(void) {}
+static inline bool __refrigerator(void) { return false; }
 static inline int freeze_processes(void) { return -ENOSYS; }
 static inline int freeze_kernel_threads(void) { return -ENOSYS; }
 static inline void thaw_processes(void) {}
 
-static inline int try_to_freeze(void) { return 0; }
+static inline bool try_to_freeze(void) { return false; }
 
 static inline void freezer_do_not_count(void) {}
 static inline void freezer_count(void) {}
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 19a20b2..8ab0bdb 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -23,10 +23,11 @@ static inline void frozen_process(void)
 }
 
 /* Refrigerator is place where frozen processes are stored :-). */
-void refrigerator(void)
+bool __refrigerator(void)
 {
 	/* Hmm, should we be allowed to suspend when there are realtime
 	   processes around? */
+	bool was_frozen = false;
 	long save;
 
 	task_lock(current);
@@ -35,7 +36,7 @@ void refrigerator(void)
 		task_unlock(current);
 	} else {
 		task_unlock(current);
-		return;
+		return was_frozen;
 	}
 	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
@@ -51,6 +52,7 @@ void refrigerator(void)
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!frozen(current))
 			break;
+		was_frozen = true;
 		schedule();
 	}
 
@@ -65,8 +67,10 @@ void refrigerator(void)
 	 * synchronization which depends on ordered task state change.
 	 */
 	set_current_state(save);
+
+	return was_frozen;
 }
-EXPORT_SYMBOL(refrigerator);
+EXPORT_SYMBOL(__refrigerator);
 
 static void fake_signal_wake_up(struct task_struct *p)
 {
-- 
1.7.3.1

