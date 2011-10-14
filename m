Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab1JNAja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 20:39:30 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:35183 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab1JNAj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 20:39:29 -0400
Date: Thu, 13 Oct 2011 20:36:01 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Ben Blum <bblum@andrew.cmu.edu>, NeilBrown <neilb@suse.de>,
        paulmck@linux.vnet.ibm.com, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 2/2] cgroups: convert ss->attach to use whole threadgroup
 flex_array (cpuset, memcontrol)
Message-ID: <20111014003601.GC22527@ghc17.ghc.andrew.cmu.edu>
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com>
 <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu>
 <20110728171345.67d3797d@notabene.brown>
 <20110729142842.GA8462@unix33.andrew.cmu.edu>
 <20110815184957.GA16588@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815184957.GA16588@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_6000_6999 0, BODY_SIZE_7000_LESS 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ss->attach to take a flex_array of tasks instead of just the leader.

From: Ben Blum <bblum@andrew.cmu.edu>

This lets subsystems with whole-threadgroup attach calls (i.e., cpuset and
memcontrol) to accurately find the group's mm even when a non-leader does exec
and leaves the leader with a NULL mm pointer.

Also converts cpuset and memcontrol to take the flex_array and iterate down it
until an mm is found, instead of just attempting to use the leader's mm.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
---
 Documentation/cgroups/cgroups.txt |    7 ++++++-
 include/linux/cgroup.h            |    4 +++-
 kernel/cgroup.c                   |   16 +++++++++++++---
 kernel/cpuset.c                   |   16 ++++++++++++++--
 mm/memcontrol.c                   |   17 +++++++++++++++--
 5 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 3fa646f..8e900ec 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -637,12 +637,17 @@ For any non-per-thread attachment work that needs to happen before
 attach_task. Needed by cpuset.
 
 void attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-	    struct cgroup *old_cgrp, struct task_struct *task)
+	    struct cgroup *old_cgrp, struct flex_array *group,
+	    int group_size)
 (cgroup_mutex held by caller)
 
 Called after the task has been attached to the cgroup, to allow any
 post-attachment activity that requires memory allocations or blocking.
 
+The flex_array contains pointers to every task_struct being moved, so
+that subsystems can, for example, iterate over a threadgroup's tasks to
+find one with an mm that needs to be moved.
+
 void attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
 		 struct task_struct *tsk);
 (cgroup_mutex held by caller)
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ddc13eb..2f97a3b 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -25,6 +25,7 @@ struct cgroupfs_root;
 struct inode;
 struct cgroup;
 struct css_id;
+struct flex_array;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
@@ -481,7 +482,8 @@ struct cgroup_subsys {
 	void (*attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp,
 			    struct task_struct *tsk);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		       struct cgroup *old_cgrp, struct task_struct *tsk);
+		       struct cgroup *old_cgrp, struct flex_array *group,
+		       int group_size);
 	int (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
 	void (*exit)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			struct cgroup *old_cgrp, struct task_struct *task);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 32fb4c8..f5fc882 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1824,10 +1824,18 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	struct cgroup *oldcgrp;
 	struct cgroupfs_root *root = cgrp->root;
 
+	/* Singleton array, for ss->attach (see cgroup_attach_proc). */
+	struct flex_array *group = flex_array_alloc(sizeof(tsk), 1, GFP_KERNEL);
+	if (!group)
+		return -ENOMEM;
+	retval = flex_array_put_ptr(group, 0, tsk, GFP_KERNEL);
+	if (retval < 0)
+		goto out_free_array;
+
 	/* Nothing to do if the task is already in that cgroup */
 	oldcgrp = task_cgroup_from_root(tsk, root);
 	if (cgrp == oldcgrp)
-		return 0;
+		goto out_free_array;
 
 	for_each_subsys(root, ss) {
 		if (ss->can_attach) {
@@ -1862,7 +1870,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 		if (ss->attach_task)
 			ss->attach_task(cgrp, oldcgrp, tsk);
 		if (ss->attach)
-			ss->attach(ss, cgrp, oldcgrp, tsk);
+			ss->attach(ss, cgrp, oldcgrp, group, 1);
 	}
 
 	synchronize_rcu();
@@ -1890,6 +1898,8 @@ out:
 				ss->cancel_attach(ss, cgrp, tsk);
 		}
 	}
+out_free_array:
+	flex_array_free(group);
 	return retval;
 }
 
@@ -2164,7 +2174,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	 */
 	for_each_subsys(root, ss) {
 		if (ss->attach)
-			ss->attach(ss, cgrp, oldcgrp, leader);
+			ss->attach(ss, cgrp, oldcgrp, group, group_size);
 	}
 
 	/*
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 00b3430..fce7841 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -59,6 +59,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/flex_array.h>
 
 /*
  * Workqueue for cpuset related tasks.
@@ -1440,11 +1441,13 @@ static void cpuset_attach_task(struct cgroup *cont, struct cgroup *old,
 }
 
 static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
-			  struct cgroup *oldcont, struct task_struct *tsk)
+			  struct cgroup *oldcont, struct flex_array *group,
+			  int group_size)
 {
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
+	int i;
 
 	/*
 	 * Change mm, possibly for multiple threads in a threadgroup. This is
@@ -1452,7 +1455,16 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	 */
 	cpuset_attach_nodemask_from = oldcs->mems_allowed;
 	cpuset_attach_nodemask_to = cs->mems_allowed;
-	mm = get_task_mm(tsk);
+	/*
+	 * Find the first task in the group that still has its mm. (This could
+	 * be not the first one if another did exec() and the leader exited.
+	 */
+	for (i = 0; i < group_size; i++) {
+		struct task_struct *tsk = flex_array_get_ptr(group, i);
+		mm = get_task_mm(tsk);
+		if (mm)
+			break;
+	}
 	if (mm) {
 		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
 		if (is_memory_migrate(cs))
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6aff93c..f951a9c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -49,6 +49,7 @@
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
+#include <linux/flex_array.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -5455,9 +5456,21 @@ retry:
 static void mem_cgroup_move_task(struct cgroup_subsys *ss,
 				struct cgroup *cont,
 				struct cgroup *old_cont,
-				struct task_struct *p)
+				struct flex_array *group, int group_size)
 {
-	struct mm_struct *mm = get_task_mm(p);
+	struct mm_struct *mm;
+	int i;
+
+	/*
+	 * Find the first task in the group that still has its mm. (This could
+	 * be not the first one if another did exec() and the leader exited.
+	 */
+	for (i = 0; i < group_size; i++) {
+		struct task_struct *tsk = flex_array_get_ptr(group, i);
+		mm = get_task_mm(tsk);
+		if (mm)
+			break;
+	}
 
 	if (mm) {
 		if (mc.to)
