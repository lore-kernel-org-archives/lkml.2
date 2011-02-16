Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1BPNql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:46:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:39939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab1BPNqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:46:38 -0500
Date: Wed, 16 Feb 2011 13:46:12 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        menage@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, menage@google.com,
        mingo@elte.hu
In-Reply-To: <1297160655.13327.92.camel@laptop>
References: <1297160655.13327.92.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] cgroup: Fix cgroup_subsys::exit callback
Message-ID: <tip-d41d5a01631af821d3a3447e6613a316f5ee6c25@git.kernel.org>
Git-Commit-ID: d41d5a01631af821d3a3447e6613a316f5ee6c25
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 13:46:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d41d5a01631af821d3a3447e6613a316f5ee6c25
Gitweb:     http://git.kernel.org/tip/d41d5a01631af821d3a3447e6613a316f5ee6c25
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 7 Feb 2011 17:02:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 13:30:47 +0100

cgroup: Fix cgroup_subsys::exit callback

Make the ::exit method act like ::attach, it is after all very nearly
the same thing.

The bug had no effect on correctness - fixing it is an optimization for
the scheduler. Also, later perf-cgroups patches rely on it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Menage <menage@google.com>
LKML-Reference: <1297160655.13327.92.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cgroup.h |    3 ++-
 kernel/cgroup.c        |   31 ++++++++++++++++++-------------
 kernel/sched.c         |    6 ++----
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ce104e3..38117d9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -474,7 +474,8 @@ struct cgroup_subsys {
 			struct cgroup *old_cgrp, struct task_struct *tsk,
 			bool threadgroup);
 	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
-	void (*exit)(struct cgroup_subsys *ss, struct task_struct *task);
+	void (*exit)(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			struct cgroup *old_cgrp, struct task_struct *task);
 	int (*populate)(struct cgroup_subsys *ss,
 			struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b24d702..f6495f3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4230,20 +4230,8 @@ void cgroup_post_fork(struct task_struct *child)
  */
 void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 {
-	int i;
 	struct css_set *cg;
-
-	if (run_callbacks && need_forkexit_callback) {
-		/*
-		 * modular subsystems can't use callbacks, so no need to lock
-		 * the subsys array
-		 */
-		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
-			struct cgroup_subsys *ss = subsys[i];
-			if (ss->exit)
-				ss->exit(ss, tsk);
-		}
-	}
+	int i;
 
 	/*
 	 * Unlink from the css_set task list if necessary.
@@ -4261,7 +4249,24 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	task_lock(tsk);
 	cg = tsk->cgroups;
 	tsk->cgroups = &init_css_set;
+
+	if (run_callbacks && need_forkexit_callback) {
+		/*
+		 * modular subsystems can't use callbacks, so no need to lock
+		 * the subsys array
+		 */
+		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
+			struct cgroup_subsys *ss = subsys[i];
+			if (ss->exit) {
+				struct cgroup *old_cgrp =
+					rcu_dereference_raw(cg->subsys[i])->cgroup;
+				struct cgroup *cgrp = task_cgroup(tsk, i);
+				ss->exit(ss, cgrp, old_cgrp, tsk);
+			}
+		}
+	}
 	task_unlock(tsk);
+
 	if (cg)
 		put_css_set_taskexit(cg);
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index e142e92..79e611c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -606,9 +606,6 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct task_group *tg;
 	struct cgroup_subsys_state *css;
 
-	if (p->flags & PF_EXITING)
-		return &root_task_group;
-
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
 			lockdep_is_held(&task_rq(p)->lock));
 	tg = container_of(css, struct task_group, css);
@@ -8863,7 +8860,8 @@ cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 }
 
 static void
-cpu_cgroup_exit(struct cgroup_subsys *ss, struct task_struct *task)
+cpu_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
+		struct cgroup *old_cgrp, struct task_struct *task)
 {
 	/*
 	 * cgroup_exit() is called in the copy_process() failure path.
