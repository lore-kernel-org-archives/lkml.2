Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1KAXqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:46:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37379 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab1KAXqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:46:47 -0400
From: Tejun Heo <tj@kernel.org>
To: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] threadgroup: extend threadgroup_lock() to cover exit and exec
Date: Tue,  1 Nov 2011 16:46:26 -0700
Message-Id: <1320191193-8110-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320191193-8110-1-git-send-email-tj@kernel.org>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

threadgroup_lock() protected only protected against new addition to
the threadgroup, which was inherently somewhat incomplete and
problematic for its only user cgroup.  On-going migration could race
against exec and exit leading to interesting problems - the symmetry
between various attach methods, task exiting during method execution,
->exit() racing against attach methods, migrating task switching basic
properties during exec and so on.

This patch extends threadgroup_lock() such that it protects against
all three threadgroup altering operations - fork, exit and exec.  For
exit, threadgroup_change_begin/end() calls are added to exit path.
For exec, threadgroup_[un]lock() are updated to also grab and release
cred_guard_mutex.

With this change, threadgroup_lock() guarantees that the target
threadgroup will remain stable - no new task will be added, no new
PF_EXITING will be set and exec won't happen.

The next patch will update cgroup so that it can take full advantage
of this change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/sched.h |   36 ++++++++++++++++++++++++++++++------
 kernel/exit.c         |   17 +++++++++++++----
 2 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index aa47d0f..6fb546e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -635,11 +635,12 @@ struct signal_struct {
 #endif
 #ifdef CONFIG_CGROUPS
 	/*
-	 * The group_rwsem prevents threads from forking with
-	 * CLONE_THREAD while held for writing. Use this for fork-sensitive
-	 * threadgroup-wide operations. It's taken for reading in fork.c in
-	 * copy_process().
-	 * Currently only needed write-side by cgroups.
+	 * group_rwsem prevents new tasks from entering the threadgroup and
+	 * member tasks from exiting.  fork and exit paths are protected
+	 * with this rwsem using threadgroup_change_begin/end().  Users
+	 * which require threadgroup to remain stable should use
+	 * threadgroup_[un]lock() which also takes care of exec path.
+	 * Currently, cgroup is the only user.
 	 */
 	struct rw_semaphore group_rwsem;
 #endif
@@ -2367,7 +2368,6 @@ static inline void unlock_task_sighand(struct task_struct *tsk,
 	spin_unlock_irqrestore(&tsk->sighand->siglock, *flags);
 }
 
-/* See the declaration of group_rwsem in signal_struct. */
 #ifdef CONFIG_CGROUPS
 static inline void threadgroup_change_begin(struct task_struct *tsk)
 {
@@ -2377,13 +2377,37 @@ static inline void threadgroup_change_done(struct task_struct *tsk)
 {
 	up_read(&tsk->signal->group_rwsem);
 }
+
+/**
+ * threadgroup_lock - lock threadgroup
+ * @tsk: member task of the threadgroup to lock
+ *
+ * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
+ * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
+ * perform exec.  This is useful for cases where the threadgroup needs to
+ * stay stable across blockable operations.
+ *
+ * fork and exit explicitly call threadgroup_change_{begin|end}() for
+ * synchronization.  exec is already synchronized with cread_guard_mutex
+ * which we grab here.
+ */
 static inline void threadgroup_lock(struct task_struct *tsk)
 {
+	/* exec uses exit for de-threading, grab cred_guard_mutex first */
+	mutex_lock(&tsk->signal->cred_guard_mutex);
 	down_write(&tsk->signal->group_rwsem);
 }
+
+/**
+ * threadgroup_unlock - unlock threadgroup
+ * @tsk: member task of the threadgroup to unlock
+ *
+ * Reverse threadgroup_lock().
+ */
 static inline void threadgroup_unlock(struct task_struct *tsk)
 {
 	up_write(&tsk->signal->group_rwsem);
+	mutex_unlock(&tsk->signal->cred_guard_mutex);
 }
 #else
 static inline void threadgroup_change_begin(struct task_struct *tsk) {}
diff --git a/kernel/exit.c b/kernel/exit.c
index 2913b35..3565f00 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -938,6 +938,12 @@ NORET_TYPE void do_exit(long code)
 		schedule();
 	}
 
+	/*
+	 * @tsk's threadgroup is going through changes - lock out users
+	 * which expect stable threadgroup.
+	 */
+	threadgroup_change_begin(tsk);
+
 	exit_irq_thread();
 
 	exit_signals(tsk);  /* sets PF_EXITING */
@@ -1020,10 +1026,6 @@ NORET_TYPE void do_exit(long code)
 		kfree(current->pi_state_cache);
 #endif
 	/*
-	 * Make sure we are holding no locks:
-	 */
-	debug_check_no_locks_held(tsk);
-	/*
 	 * We can do this unlocked here. The futex code uses this flag
 	 * just to verify whether the pi state cleanup has been done
 	 * or not. In the worst case it loops once more.
@@ -1040,6 +1042,13 @@ NORET_TYPE void do_exit(long code)
 
 	preempt_disable();
 	exit_rcu();
+
+	/*
+	 * Release threadgroup and make sure we are holding no locks.
+	 */
+	threadgroup_change_done(tsk);
+	debug_check_no_locks_held(tsk);
+
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
 	schedule();
-- 
1.7.3.1

