Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1IFAOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 20:14:51 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53143 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab1IFAOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 20:14:40 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH 11/12] cgroups: Allow subsystems to cancel a fork
Date: Tue,  6 Sep 2011 02:13:05 +0200
Message-Id: <1315267986-28937-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the subsystem's fork callback return an error value so
that they can cancel a fork. This is going to be used by
the task counter subsystem to implement the limit.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h  |   14 +++++++++-----
 kernel/cgroup.c         |   23 +++++++++++++++++++----
 kernel/cgroup_freezer.c |    6 ++++--
 kernel/exit.c           |    2 +-
 kernel/fork.c           |    7 +++++--
 5 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5e39341..253543b 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -32,9 +32,11 @@ extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_fork_callbacks(struct task_struct *p);
+extern int cgroup_fork_callbacks(struct task_struct *p,
+				 struct cgroup_subsys **failed_ss);
 extern void cgroup_post_fork(struct task_struct *p);
-extern void cgroup_exit(struct task_struct *p, int run_callbacks);
+extern void cgroup_exit(struct task_struct *p, int run_callbacks,
+			struct cgroup_subsys *failed_ss);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
 extern int cgroup_load_subsys(struct cgroup_subsys *ss);
@@ -477,7 +479,7 @@ struct cgroup_subsys {
 	void (*attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp, struct task_struct *tsk);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		       struct cgroup *old_cgrp, struct task_struct *tsk);
-	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
+	int (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
 	void (*exit)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			struct cgroup *old_cgrp, struct task_struct *task);
 	int (*populate)(struct cgroup_subsys *ss,
@@ -634,9 +636,11 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
-static inline void cgroup_fork_callbacks(struct task_struct *p) {}
+static inline int cgroup_fork_callbacks(struct task_struct *p,
+					struct cgroup_subsys **failed_ss) {}
 static inline void cgroup_post_fork(struct task_struct *p) {}
-static inline void cgroup_exit(struct task_struct *p, int callbacks) {}
+static inline void cgroup_exit(struct task_struct *p, int callbacks,
+			       struct cgroup_subsys **failed_ss) {}
 
 static inline void cgroup_lock(void) {}
 static inline void cgroup_unlock(void) {}
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 73ee2fd..c99e9cc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4538,8 +4538,11 @@ void cgroup_fork(struct task_struct *child)
  * tasklist. No need to take any locks since no-one can
  * be operating on this task.
  */
-void cgroup_fork_callbacks(struct task_struct *child)
+int cgroup_fork_callbacks(struct task_struct *child,
+			  struct cgroup_subsys **failed_ss)
 {
+	int err;
+
 	if (need_forkexit_callback) {
 		int i;
 		/*
@@ -4549,10 +4552,17 @@ void cgroup_fork_callbacks(struct task_struct *child)
 		 */
 		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
-			if (ss->fork)
-				ss->fork(ss, child);
+			if (ss->fork) {
+				err = ss->fork(ss, child);
+				if (err) {
+					*failed_ss = ss;
+					return err;
+				}
+			}
 		}
 	}
+
+	return 0;
 }
 
 /**
@@ -4610,7 +4620,8 @@ void cgroup_post_fork(struct task_struct *child)
  *    which wards off any cgroup_attach_task() attempts, or task is a failed
  *    fork, never visible to cgroup_attach_task.
  */
-void cgroup_exit(struct task_struct *tsk, int run_callbacks)
+void cgroup_exit(struct task_struct *tsk, int run_callbacks,
+		 struct cgroup_subsys *failed_ss)
 {
 	struct css_set *cg;
 	int i;
@@ -4639,6 +4650,10 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 		 */
 		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
+
+			if (ss == failed_ss)
+				break;
+
 			if (ss->exit) {
 				struct cgroup *old_cgrp =
 					rcu_dereference_raw(cg->subsys[i])->cgroup;
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index c1421a1..30a4332 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -187,7 +187,7 @@ static int freezer_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
 	return 0;
 }
 
-static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
+static int freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 {
 	struct freezer *freezer;
 
@@ -207,7 +207,7 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	 * following check.
 	 */
 	if (!freezer->css.cgroup->parent)
-		return;
+		return 0;
 
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state == CGROUP_FROZEN);
@@ -216,6 +216,8 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	if (freezer->state == CGROUP_FREEZING)
 		freeze_task(task, true);
 	spin_unlock_irq(&freezer->lock);
+
+	return 0;
 }
 
 /*
diff --git a/kernel/exit.c b/kernel/exit.c
index 2913b35..abab32b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -994,7 +994,7 @@ NORET_TYPE void do_exit(long code)
 	 */
 	perf_event_exit_task(tsk);
 
-	cgroup_exit(tsk, 1);
+	cgroup_exit(tsk, 1, NULL);
 
 	if (group_dead)
 		disassociate_ctty(1);
diff --git a/kernel/fork.c b/kernel/fork.c
index f716436..989c5a0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1058,6 +1058,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	int retval;
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
+	struct cgroup_subsys *cgroup_failed_ss = NULL;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1316,8 +1317,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
-	cgroup_fork_callbacks(p);
+	retval = cgroup_fork_callbacks(p, &cgroup_failed_ss);
 	cgroup_callbacks_done = 1;
+	if (retval)
+		goto bad_fork_free_pid;
 
 	/* Need tasklist lock for parent etc handling! */
 	write_lock_irq(&tasklist_lock);
@@ -1423,7 +1426,7 @@ bad_fork_cleanup_cgroup:
 #endif
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_fork_read_unlock(current);
-	cgroup_exit(p, cgroup_callbacks_done);
+	cgroup_exit(p, cgroup_callbacks_done, cgroup_failed_ss);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-- 
1.7.5.4

