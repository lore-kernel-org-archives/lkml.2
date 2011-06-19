Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1FSXv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:51:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59730 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab1FSXvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uPZ9fES87JgVrtMTMGEJmqeL6YrJZoj5o2tndEf37oOf24NP55/BA6ve/7AU+/inQy
         uhiCHHtjPlYGbvEtapCjqqDNLR/gOdv5mDC1XeLbFqt2liwfG+gDBLV4RKhJRldghDz/
         azCOYpT6PZXgy862lxaaZ/3AxZhUG67KRvOyw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 1/4] cgroups: Allow a cgroup subsys to reject a fork
Date: Mon, 20 Jun 2011 01:51:11 +0200
Message-Id: <1308527474-20704-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the cgroup subsystem fork callback return a value
so that subsystems are able to accept or reject a fork
completion with a custom error value.

This prepares for implementing rlimit in cgroups scope.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/cgroup.h  |    9 ++++++---
 kernel/cgroup.c         |   13 ++++++++++---
 kernel/cgroup_freezer.c |    6 ++++--
 kernel/fork.c           |    5 ++++-
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ab4ac0c..07213af 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -32,7 +32,7 @@ extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_fork_callbacks(struct task_struct *p);
+extern int cgroup_fork_callbacks(struct task_struct *p);
 extern void cgroup_post_fork(struct task_struct *p);
 extern void cgroup_exit(struct task_struct *p, int run_callbacks);
 extern int cgroupstats_build(struct cgroupstats *stats,
@@ -475,7 +475,7 @@ struct cgroup_subsys {
 	void (*attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		       struct cgroup *old_cgrp, struct task_struct *tsk);
-	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
+	int (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
 	void (*exit)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			struct cgroup *old_cgrp, struct task_struct *task);
 	int (*populate)(struct cgroup_subsys *ss,
@@ -633,7 +633,10 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
-static inline void cgroup_fork_callbacks(struct task_struct *p) {}
+static inline int cgroup_fork_callbacks(struct task_struct *p)
+{
+	return 0;
+}
 static inline void cgroup_post_fork(struct task_struct *p) {}
 static inline void cgroup_exit(struct task_struct *p, int callbacks) {}
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2731d11..688be3d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4514,10 +4514,12 @@ void cgroup_fork(struct task_struct *child)
  * tasklist. No need to take any locks since no-one can
  * be operating on this task.
  */
-void cgroup_fork_callbacks(struct task_struct *child)
+int cgroup_fork_callbacks(struct task_struct *child)
 {
 	if (need_forkexit_callback) {
 		int i;
+		int ret;
+
 		/*
 		 * forkexit callbacks are only supported for builtin
 		 * subsystems, and the builtin section of the subsys array is
@@ -4525,10 +4527,15 @@ void cgroup_fork_callbacks(struct task_struct *child)
 		 */
 		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
-			if (ss->fork)
-				ss->fork(ss, child);
+			if (ss->fork) {
+				ret = ss->fork(ss, child);
+				if (ret)
+					return ret;
+			}
 		}
 	}
+
+	return 0;
 }
 
 /**
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index e691818..e704be6 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -186,7 +186,7 @@ static int freezer_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	return 0;
 }
 
-static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
+static int freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 {
 	struct freezer *freezer;
 
@@ -206,7 +206,7 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	 * following check.
 	 */
 	if (!freezer->css.cgroup->parent)
-		return;
+		return 0;
 
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state == CGROUP_FROZEN);
@@ -215,6 +215,8 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	if (freezer->state == CGROUP_FREEZING)
 		freeze_task(task, true);
 	spin_unlock_irq(&freezer->lock);
+
+	return 0;
 }
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index 0276c30..2625461 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1298,7 +1298,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
-	cgroup_fork_callbacks(p);
+	retval = cgroup_fork_callbacks(p);
+	if (retval)
+		goto bad_fork_free_pid;
+
 	cgroup_callbacks_done = 1;
 
 	/* Need tasklist lock for parent etc handling! */
-- 
1.7.5.4

