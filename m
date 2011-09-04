Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1IDSCH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 14:02:07 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51952 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1IDSBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 14:01:46 -0400
From: Tejun Heo <htejun@gmail.com>
To: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul Menage <menage@google.com>
Subject: [PATCH 2/4] threadgroup: rename signal->threadgroup_fork_lock to ->group_rwsem
Date: Mon,  5 Sep 2011 03:01:18 +0900
Message-Id: <1315159280-25032-3-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315159280-25032-1-git-send-email-htejun@gmail.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

Make the following renames to prepare for extension of threadgroup
locking.

* s/signal->threadgroup_fork_lock/signal->group_rwsem/
* s/threadgroup_fork_read_lock()/threadgroup_change_begin()/
* s/threadgroup_fork_read_unlock()/threadgroup_change_done()/
* s/threadgroup_fork_write_lock()/threadgroup_lock()/
* s/threadgroup_fork_write_unlock()/threadgroup_unlock()/

This patch doesn't cause any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/init_task.h |    9 ++++-----
 include/linux/sched.h     |   30 +++++++++++++++---------------
 kernel/cgroup.c           |   12 ++++++------
 kernel/fork.c             |    8 ++++----
 4 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index d14e058..3a0d9f2 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -23,11 +23,10 @@ extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
 #ifdef CONFIG_CGROUPS
-#define INIT_THREADGROUP_FORK_LOCK(sig)					\
-	.threadgroup_fork_lock =					\
-		__RWSEM_INITIALIZER(sig.threadgroup_fork_lock),
+#define INIT_GROUP_RWSEM(sig)						\
+	.group_rwsem = __RWSEM_INITIALIZER(sig.group_rwsem),
 #else
-#define INIT_THREADGROUP_FORK_LOCK(sig)
+#define INIT_GROUP_RWSEM(sig)
 #endif
 
 #define INIT_SIGNALS(sig) {						\
@@ -46,7 +45,7 @@ extern struct fs_struct init_fs;
 	},								\
 	.cred_guard_mutex =						\
 		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
-	INIT_THREADGROUP_FORK_LOCK(sig)					\
+	INIT_GROUP_RWSEM(sig)						\
 }
 
 extern struct nsproxy init_nsproxy;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6d45ce7..da74d6f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -635,13 +635,13 @@ struct signal_struct {
 #endif
 #ifdef CONFIG_CGROUPS
 	/*
-	 * The threadgroup_fork_lock prevents threads from forking with
+	 * The group_rwsem prevents threads from forking with
 	 * CLONE_THREAD while held for writing. Use this for fork-sensitive
 	 * threadgroup-wide operations. It's taken for reading in fork.c in
 	 * copy_process().
 	 * Currently only needed write-side by cgroups.
 	 */
-	struct rw_semaphore threadgroup_fork_lock;
+	struct rw_semaphore group_rwsem;
 #endif
 
 	int oom_adj;		/* OOM kill score adjustment (bit shift) */
@@ -2364,29 +2364,29 @@ static inline void unlock_task_sighand(struct task_struct *tsk,
 	spin_unlock_irqrestore(&tsk->sighand->siglock, *flags);
 }
 
-/* See the declaration of threadgroup_fork_lock in signal_struct. */
+/* See the declaration of group_rwsem in signal_struct. */
 #ifdef CONFIG_CGROUPS
-static inline void threadgroup_fork_read_lock(struct task_struct *tsk)
+static inline void threadgroup_change_begin(struct task_struct *tsk)
 {
-	down_read(&tsk->signal->threadgroup_fork_lock);
+	down_read(&tsk->signal->group_rwsem);
 }
-static inline void threadgroup_fork_read_unlock(struct task_struct *tsk)
+static inline void threadgroup_change_done(struct task_struct *tsk)
 {
-	up_read(&tsk->signal->threadgroup_fork_lock);
+	up_read(&tsk->signal->group_rwsem);
 }
-static inline void threadgroup_fork_write_lock(struct task_struct *tsk)
+static inline void threadgroup_lock(struct task_struct *tsk)
 {
-	down_write(&tsk->signal->threadgroup_fork_lock);
+	down_write(&tsk->signal->group_rwsem);
 }
-static inline void threadgroup_fork_write_unlock(struct task_struct *tsk)
+static inline void threadgroup_unlock(struct task_struct *tsk)
 {
-	up_write(&tsk->signal->threadgroup_fork_lock);
+	up_write(&tsk->signal->group_rwsem);
 }
 #else
-static inline void threadgroup_fork_read_lock(struct task_struct *tsk) {}
-static inline void threadgroup_fork_read_unlock(struct task_struct *tsk) {}
-static inline void threadgroup_fork_write_lock(struct task_struct *tsk) {}
-static inline void threadgroup_fork_write_unlock(struct task_struct *tsk) {}
+static inline void threadgroup_change_begin(struct task_struct *tsk) {}
+static inline void threadgroup_change_done(struct task_struct *tsk) {}
+static inline void threadgroup_lock(struct task_struct *tsk) {}
+static inline void threadgroup_unlock(struct task_struct *tsk) {}
 #endif
 
 #ifndef __HAVE_THREAD_FUNCTIONS
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bd1fb5f..e81f403 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1985,8 +1985,8 @@ static int css_set_prefetch(struct cgroup *cgrp, struct css_set *cg,
  * @cgrp: the cgroup to attach to
  * @leader: the threadgroup leader task_struct of the group to be attached
  *
- * Call holding cgroup_mutex and the threadgroup_fork_lock of the leader. Will
- * take task_lock of each thread in leader's threadgroup individually in turn.
+ * Call holding cgroup_mutex and the group_rwsem of the leader. Will take
+ * task_lock of each thread in leader's threadgroup individually in turn.
  */
 int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 {
@@ -2012,8 +2012,8 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	 * step 0: in order to do expensive, possibly blocking operations for
 	 * every thread, we cannot iterate the thread group list, since it needs
 	 * rcu or tasklist locked. instead, build an array of all threads in the
-	 * group - threadgroup_fork_lock prevents new threads from appearing,
-	 * and if threads exit, this will just be an over-estimate.
+	 * group - group_rwsem prevents new threads from appearing, and if
+	 * threads exit, this will just be an over-estimate.
 	 */
 	group_size = get_nr_threads(leader);
 	/* flex_array supports very large thread-groups better than kmalloc. */
@@ -2246,7 +2246,7 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 	}
 
 	if (threadgroup)
-		threadgroup_fork_write_lock(tsk);
+		threadgroup_lock(tsk);
 	ret = -ENODEV;
 	if (cgroup_lock_live_group(cgrp)) {
 		if (threadgroup)
@@ -2256,7 +2256,7 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 		cgroup_unlock();
 	}
 	if (threadgroup)
-		threadgroup_fork_write_unlock(tsk);
+		threadgroup_unlock(tsk);
 	put_task_struct(tsk);
 	return ret;
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index fa7beb3..f0e2e56 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -980,7 +980,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sched_autogroup_fork(sig);
 
 #ifdef CONFIG_CGROUPS
-	init_rwsem(&sig->threadgroup_fork_lock);
+	init_rwsem(&sig->group_rwsem);
 #endif
 
 	sig->oom_adj = current->signal->oom_adj;
@@ -1165,7 +1165,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->io_context = NULL;
 	p->audit_context = NULL;
 	if (clone_flags & CLONE_THREAD)
-		threadgroup_fork_read_lock(current);
+		threadgroup_change_begin(current);
 	cgroup_fork(p);
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
@@ -1377,7 +1377,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)
-		threadgroup_fork_read_unlock(current);
+		threadgroup_change_done(current);
 	perf_event_fork(p);
 	return p;
 
@@ -1417,7 +1417,7 @@ bad_fork_cleanup_policy:
 bad_fork_cleanup_cgroup:
 #endif
 	if (clone_flags & CLONE_THREAD)
-		threadgroup_fork_read_unlock(current);
+		threadgroup_change_done(current);
 	cgroup_exit(p, cgroup_callbacks_done);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
-- 
1.7.6

