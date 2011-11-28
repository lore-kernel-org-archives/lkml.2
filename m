Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1K1MIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:08:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59767 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1K1MIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:08:18 -0500
Date: Mon, 28 Nov 2011 16:08:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Matt Helsley <matthltc@us.ibm.com>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>
Subject: [RFC] cgroups: freezer -- Allow to attach a task to a frozen cgroup
Message-ID: <20111128120813.GK1775@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In checkpoint/restore we need an ability to attach pids to
a frozen cgroup. Thus once pid reaches a frozen cgroup it is
not rejected, but the task get frozen immediately.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

I would really appreciate complains and comments.

 include/linux/cgroup.h  |    2 
 kernel/cgroup.c         |    6 +-
 kernel/cgroup_freezer.c |  119 +++++++++++++++++++++++++++++++++---------------
 mm/memcontrol.c         |    2 
 4 files changed, 90 insertions(+), 39 deletions(-)

Index: linux-2.6.git/include/linux/cgroup.h
===================================================================
--- linux-2.6.git.orig/include/linux/cgroup.h
+++ linux-2.6.git/include/linux/cgroup.h
@@ -470,7 +470,7 @@ struct cgroup_subsys {
 			  struct task_struct *tsk);
 	int (*can_attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
 	void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
-			      struct task_struct *tsk);
+			      struct cgroup *old_cgrp, struct task_struct *tsk);
 	void (*pre_attach)(struct cgroup *cgrp);
 	void (*attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
Index: linux-2.6.git/kernel/cgroup.c
===================================================================
--- linux-2.6.git.orig/kernel/cgroup.c
+++ linux-2.6.git/kernel/cgroup.c
@@ -1884,7 +1884,7 @@ out:
 				 */
 				break;
 			if (ss->cancel_attach)
-				ss->cancel_attach(ss, cgrp, tsk);
+				ss->cancel_attach(ss, cgrp, oldcgrp, tsk);
 		}
 	}
 	return retval;
@@ -2178,11 +2178,11 @@ out_cancel_attach:
 		for_each_subsys(root, ss) {
 			if (ss == failed_ss) {
 				if (cancel_failed_ss && ss->cancel_attach)
-					ss->cancel_attach(ss, cgrp, leader);
+					ss->cancel_attach(ss, cgrp, oldcgrp, leader);
 				break;
 			}
 			if (ss->cancel_attach)
-				ss->cancel_attach(ss, cgrp, leader);
+				ss->cancel_attach(ss, cgrp, oldcgrp, leader);
 		}
 	}
 	/* clean up the array of referenced threads in the group. */
Index: linux-2.6.git/kernel/cgroup_freezer.c
===================================================================
--- linux-2.6.git.orig/kernel/cgroup_freezer.c
+++ linux-2.6.git/kernel/cgroup_freezer.c
@@ -153,39 +153,6 @@ static void freezer_destroy(struct cgrou
 	kfree(cgroup_freezer(cgroup));
 }
 
-/*
- * The call to cgroup_lock() in the freezer.state write method prevents
- * a write to that file racing against an attach, and hence the
- * can_attach() result will remain valid until the attach completes.
- */
-static int freezer_can_attach(struct cgroup_subsys *ss,
-			      struct cgroup *new_cgroup,
-			      struct task_struct *task)
-{
-	struct freezer *freezer;
-
-	/*
-	 * Anything frozen can't move or be moved to/from.
-	 */
-
-	freezer = cgroup_freezer(new_cgroup);
-	if (freezer->state != CGROUP_THAWED)
-		return -EBUSY;
-
-	return 0;
-}
-
-static int freezer_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
-{
-	rcu_read_lock();
-	if (__cgroup_freezing_or_frozen(tsk)) {
-		rcu_read_unlock();
-		return -EBUSY;
-	}
-	rcu_read_unlock();
-	return 0;
-}
-
 static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 {
 	struct freezer *freezer;
@@ -374,14 +341,96 @@ static int freezer_populate(struct cgrou
 	return cgroup_add_files(cgroup, ss, files, ARRAY_SIZE(files));
 }
 
+static int freezer_task_transition(struct task_struct *task, int state_to)
+{
+	int retval = 0;
+
+	switch (state_to) {
+	case CGROUP_THAWED:
+		thaw_process(task);
+		break;
+	case CGROUP_FROZEN:
+	case CGROUP_FREEZING:
+		if (freeze_task(task, true)) {
+			if (!frozen(task)) {
+				if (!freezing(task) &&
+				    !freezer_should_skip(task))
+					retval = -EBUSY;
+			}
+		}
+		break;
+	}
+
+	return retval;
+}
+
+static int freezer_can_attach_task(struct cgroup *cgroup, struct task_struct *task)
+{
+	struct freezer *old_freezer;
+	struct freezer *freezer;
+
+	int goal_state, orig_state;
+	int retval = 0;
+
+	old_freezer = task_freezer(task);
+	freezer = cgroup_freezer(cgroup);
+
+	spin_lock_irq(&freezer->lock);
+
+	if (!spin_trylock_irq(&old_freezer->lock)) {
+		retval = -EBUSY;
+		goto out_unlock_freezer;
+	}
+
+	goal_state = orig_state = CGROUP_THAWED;
+
+	if (freezer->state == CGROUP_FREEZING ||
+	    freezer->state == CGROUP_FROZEN)
+		goal_state = CGROUP_FREEZING;
+
+	if (old_freezer->state == CGROUP_FREEZING ||
+	    old_freezer->state == CGROUP_FROZEN)
+		orig_state = CGROUP_FREEZING;
+
+	/* Nothing to change */
+	if (orig_state == goal_state)
+		goto done;
+
+	retval = freezer_task_transition(task, goal_state);
+done:
+	spin_unlock_irq(&old_freezer->lock);
+out_unlock_freezer:
+	spin_unlock_irq(&freezer->lock);
+
+	return retval;
+}
+
+static void freezer_cancel_attach(struct cgroup_subsys *ss,
+				  struct cgroup *cgroup,
+				  struct cgroup *old_cgroup,
+				  struct task_struct *task)
+{
+	struct freezer *freezer = cgroup_freezer(old_cgroup);
+	int retval = 0;
+
+	spin_lock_irq(&freezer->lock);
+	retval = freezer_task_transition(task, freezer->state);
+	if (retval)
+		pr_warning("freezer: Can't move task (pid %d) to %s state\n",
+			   task_pid_nr(task),
+			   freezer_state_strs[freezer->state]);
+	spin_unlock_irq(&freezer->lock);
+}
+
 struct cgroup_subsys freezer_subsys = {
 	.name		= "freezer",
 	.create		= freezer_create,
 	.destroy	= freezer_destroy,
 	.populate	= freezer_populate,
 	.subsys_id	= freezer_subsys_id,
-	.can_attach	= freezer_can_attach,
-	.can_attach_task = freezer_can_attach_task,
+	.can_attach	= NULL,
+	.can_attach_task= freezer_can_attach_task,
+	.cancel_attach	= freezer_cancel_attach,
 	.pre_attach	= NULL,
 	.attach_task	= NULL,
 	.attach		= NULL,
Index: linux-2.6.git/mm/memcontrol.c
===================================================================
--- linux-2.6.git.orig/mm/memcontrol.c
+++ linux-2.6.git/mm/memcontrol.c
@@ -5337,6 +5337,7 @@ static int mem_cgroup_can_attach(struct
 
 static void mem_cgroup_cancel_attach(struct cgroup_subsys *ss,
 				struct cgroup *cgroup,
+				struct cgroup *old_cgroup,
 				struct task_struct *p)
 {
 	mem_cgroup_clear_mc();
@@ -5477,6 +5478,7 @@ static int mem_cgroup_can_attach(struct
 }
 static void mem_cgroup_cancel_attach(struct cgroup_subsys *ss,
 				struct cgroup *cgroup,
+				struct cgroup *old_cgroup,
 				struct task_struct *p)
 {
 }
