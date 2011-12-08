Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1LHUvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 15:51:06 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51765 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1LHUvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 15:51:02 -0500
Date: Thu, 8 Dec 2011 12:50:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: [PATCH UPDATED AGAIN 03/10] threadgroup: extend threadgroup_lock()
 to cover exit and exec
Message-ID: <20111208205055.GB12108@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111124225054.GA14828@google.com>
 <20111125140136.GC23307@somewhere.redhat.com>
 <20111127193001.GC4266@google.com>
 <20111202162753.GA19752@somewhere.redhat.com>
 <20111205184315.GJ627@google.com>
 <20111207153046.GC13252@somewhere.redhat.com>
 <20111207182214.GA7610@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207182214.GA7610@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Note for Linus at the bottom)

threadgroup_lock() protected only protected against new addition to
the threadgroup, which was inherently somewhat incomplete and
problematic for its only user cgroup.  On-going migration could race
against exec and exit leading to interesting problems - the symmetry
between various attach methods, task exiting during method execution,
->exit() racing against attach methods, migrating task switching basic
properties during exec and so on.

This patch extends threadgroup_lock() such that it protects against
all three threadgroup altering operations - fork, exit and exec.  For
exit, threadgroup_change_begin/end() calls are added to exit_signals
around assertion of PF_EXITING.  For exec, threadgroup_[un]lock() are
updated to also grab and release cred_guard_mutex.

With this change, threadgroup_lock() guarantees that the target
threadgroup will remain stable - no new task will be added, no new
PF_EXITING will be set and exec won't happen.

The next patch will update cgroup so that it can take full advantage
of this change.

-v2: beefed up comment as suggested by Frederic.

-v3: narrowed scope of protection in exit path as suggested by
     Frederic.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
Okay, narrowed exit path protection down to setting of PF_EXITING
itself.  ->exit() on dangling tasks is a bit weird but I don't think
it's too bad.  Frederic, are you okay with this version?

Linus, if Frederic is okay with it, I'm gonna rebase the series on top
of freezer changes in pm tree to avoid conflicts in cgroup_freezer,
which sits between cgroup and freezer, both of which are going through
non-trivial changes, push the branch to linux-next and put pending
cgroup patches on top.  Please scream if you're mighty unhappy with it
or have a better idea.

Thank you.

 include/linux/sched.h |   47 +++++++++++++++++++++++++++++++++++++++++------
 kernel/signal.c       |   10 ++++++++++
 2 files changed, 51 insertions(+), 6 deletions(-)

Index: work/include/linux/sched.h
===================================================================
--- work.orig/include/linux/sched.h
+++ work/include/linux/sched.h
@@ -635,11 +635,13 @@ struct signal_struct {
 #endif
 #ifdef CONFIG_CGROUPS
 	/*
-	 * The group_rwsem prevents threads from forking with
-	 * CLONE_THREAD while held for writing. Use this for fork-sensitive
-	 * threadgroup-wide operations. It's taken for reading in fork.c in
-	 * copy_process().
-	 * Currently only needed write-side by cgroups.
+	 * group_rwsem prevents new tasks from entering the threadgroup and
+	 * member tasks from exiting,a more specifically, setting of
+	 * PF_EXITING.  fork and exit paths are protected with this rwsem
+	 * using threadgroup_change_begin/end().  Users which require
+	 * threadgroup to remain stable should use threadgroup_[un]lock()
+	 * which also takes care of exec path.  Currently, cgroup is the
+	 * only user.
 	 */
 	struct rw_semaphore group_rwsem;
 #endif
@@ -2374,7 +2376,6 @@ static inline void unlock_task_sighand(s
 	spin_unlock_irqrestore(&tsk->sighand->siglock, *flags);
 }
 
-/* See the declaration of group_rwsem in signal_struct. */
 #ifdef CONFIG_CGROUPS
 static inline void threadgroup_change_begin(struct task_struct *tsk)
 {
@@ -2384,13 +2385,47 @@ static inline void threadgroup_change_en
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
+ * fork and exit paths explicitly call threadgroup_change_{begin|end}() for
+ * synchronization.  While held, no new task will be added to threadgroup
+ * and no existing live task will have its PF_EXITING set.
+ *
+ * During exec, a task goes and puts its thread group through unusual
+ * changes.  After de-threading, exclusive access is assumed to resources
+ * which are usually shared by tasks in the same group - e.g. sighand may
+ * be replaced with a new one.  Also, the exec'ing task takes over group
+ * leader role including its pid.  Exclude these changes while locked by
+ * grabbing cred_guard_mutex which is used to synchronize exec path.
+ */
 static inline void threadgroup_lock(struct task_struct *tsk)
 {
+	/*
+	 * exec uses exit for de-threading nesting group_rwsem inside
+	 * cred_guard_mutex. Grab cred_guard_mutex first.
+	 */
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
Index: work/kernel/signal.c
===================================================================
--- work.orig/kernel/signal.c
+++ work/kernel/signal.c
@@ -2359,8 +2359,15 @@ void exit_signals(struct task_struct *ts
 	int group_stop = 0;
 	sigset_t unblocked;
 
+	/*
+	 * @tsk is about to have PF_EXITING set - lock out users which
+	 * expect stable threadgroup.
+	 */
+	threadgroup_change_begin(tsk);
+
 	if (thread_group_empty(tsk) || signal_group_exit(tsk->signal)) {
 		tsk->flags |= PF_EXITING;
+		threadgroup_change_end(tsk);
 		return;
 	}
 
@@ -2370,6 +2377,9 @@ void exit_signals(struct task_struct *ts
 	 * see wants_signal(), do_signal_stop().
 	 */
 	tsk->flags |= PF_EXITING;
+
+	threadgroup_change_end(tsk);
+
 	if (!signal_pending(tsk))
 		goto out;
 
