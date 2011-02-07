Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1BGQJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 11:09:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1BGQJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 11:09:34 -0500
Subject: [RFC][PATCH] cgroup: Fix cgroup_subsys::exit callback
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com, lizf@cn.fujitsu.com, Paul Menage <menage@google.com>
In-Reply-To: <20110202190251.GB16409@balbir.in.ibm.com>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
	 <1295534345.28776.175.camel@laptop> <1296646160.26581.315.camel@laptop>
	 <20110202115012.GA16409@balbir.in.ibm.com>
	 <1296650792.26581.319.camel@laptop>
	 <20110202190251.GB16409@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 17:10:33 +0100
Message-ID: <1297095033.13327.46.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 00:32 +0530, Balbir Singh wrote:
> > No, just fixed. The callback as it exists isn't useful and leads to
> > hacks like the above.

---
Subject: cgroup: Fix cgroup_subsys::exit callback
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Feb 07 17:02:20 CET 2011

Make the ::exit method act like ::attach, it is after all very nearly
the same thing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
Index: linux-2.6/include/linux/cgroup.h
===================================================================
--- linux-2.6.orig/include/linux/cgroup.h
+++ linux-2.6/include/linux/cgroup.h
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
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -4230,20 +4230,10 @@ void cgroup_post_fork(struct task_struct
  */
 void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 {
-	int i;
 	struct css_set *cg;
+	int i;
 
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
+	mutex_lock(&cgroup_mutex);
 
 	/*
 	 * Unlink from the css_set task list if necessary.
@@ -4262,6 +4252,25 @@ void cgroup_exit(struct task_struct *tsk
 	cg = tsk->cgroups;
 	tsk->cgroups = &init_css_set;
 	task_unlock(tsk);
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
+
+	mutex_unlock(&cgroup_mutex);
+
 	if (cg)
 		put_css_set_taskexit(cg);
 }
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -606,9 +606,6 @@ static inline struct task_group *task_gr
 	struct task_group *tg;
 	struct cgroup_subsys_state *css;
 
-	if (p->flags & PF_EXITING)
-		return &root_task_group;
-
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
 			lockdep_is_held(&task_rq(p)->lock));
 	tg = container_of(css, struct task_group, css);
@@ -9081,7 +9078,8 @@ cpu_cgroup_attach(struct cgroup_subsys *
 }
 
 static void
-cpu_cgroup_exit(struct cgroup_subsys *ss, struct task_struct *task)
+cpu_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
+		struct cgroup *old_cgrp, struct task_struct *task)
 {
 	/*
 	 * cgroup_exit() is called in the copy_process() failure path.


