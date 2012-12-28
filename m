Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab2L1TUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:20:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55714 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932476Ab2L1TUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:20:01 -0500
Message-Id: <20121228190336.653264206@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 032/173] cgroup: cgroup_subsys->fork() should be called after the task is
 added to css_set
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 5edee61edeaaebafe584f8fb7074c1ef4658596b upstream.

cgroup core has a bug which violates a basic rule about event
notifications - when a new entity needs to be added, you add that to
the notification list first and then make the new entity conform to
the current state.  If done in the reverse order, an event happening
inbetween will be lost.

cgroup_subsys->fork() is invoked way before the new task is added to
the css_set.  Currently, cgroup_freezer is the only user of ->fork()
and uses it to make new tasks conform to the current state of the
freezer.  If FROZEN state is requested while fork is in progress
between cgroup_fork_callbacks() and cgroup_post_fork(), the child
could escape freezing - the cgroup isn't frozen when ->fork() is
called and the freezer couldn't see the new task on the css_set.

This patch moves cgroup_subsys->fork() invocation to
cgroup_post_fork() after the new task is added to the css_set.
cgroup_fork_callbacks() is removed.

Because now a task may be migrated during cgroup_subsys->fork(),
freezer_fork() is updated so that it adheres to the usual RCU locking
and the rather pointless comment on why locking can be different there
is removed (if it doesn't make anything simpler, why even bother?).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
[bwh: Backported to 3.2:
 - Adjust context
 - Iterate over first CGROUP_BUILTIN_SUBSYS_COUNT elements of subsys
 - cgroup_subsys::fork takes cgroup_subsys pointer as first parameter]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/cgroup.h  |    1 -
 kernel/cgroup.c         |   62 +++++++++++++++++++++++------------------------
 kernel/cgroup_freezer.c |   13 +++-------
 kernel/fork.c           |    9 +------
 4 files changed, 35 insertions(+), 50 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -32,7 +32,6 @@ extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_fork_callbacks(struct task_struct *p);
 extern void cgroup_post_fork(struct task_struct *p);
 extern void cgroup_exit(struct task_struct *p, int run_callbacks);
 extern int cgroupstats_build(struct cgroupstats *stats,
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4508,41 +4508,19 @@ void cgroup_fork(struct task_struct *chi
 }
 
 /**
- * cgroup_fork_callbacks - run fork callbacks
- * @child: the new task
- *
- * Called on a new task very soon before adding it to the
- * tasklist. No need to take any locks since no-one can
- * be operating on this task.
- */
-void cgroup_fork_callbacks(struct task_struct *child)
-{
-	if (need_forkexit_callback) {
-		int i;
-		/*
-		 * forkexit callbacks are only supported for builtin
-		 * subsystems, and the builtin section of the subsys array is
-		 * immutable, so we don't need to lock the subsys array here.
-		 */
-		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
-			struct cgroup_subsys *ss = subsys[i];
-			if (ss->fork)
-				ss->fork(ss, child);
-		}
-	}
-}
-
-/**
  * cgroup_post_fork - called on a new task after adding it to the task list
  * @child: the task in question
  *
- * Adds the task to the list running through its css_set if necessary.
- * Has to be after the task is visible on the task list in case we race
- * with the first call to cgroup_iter_start() - to guarantee that the
- * new task ends up on its list.
+ * Adds the task to the list running through its css_set if necessary and
+ * call the subsystem fork() callbacks.  Has to be after the task is
+ * visible on the task list in case we race with the first call to
+ * cgroup_iter_start() - to guarantee that the new task ends up on its
+ * list.
  */
 void cgroup_post_fork(struct task_struct *child)
 {
+	int i;
+
 	if (use_task_css_set_links) {
 		write_lock(&css_set_lock);
 		task_lock(child);
@@ -4551,7 +4529,21 @@ void cgroup_post_fork(struct task_struct
 		task_unlock(child);
 		write_unlock(&css_set_lock);
 	}
+
+	/*
+	 * Call ss->fork().  This must happen after @child is linked on
+	 * css_set; otherwise, @child might change state between ->fork()
+	 * and addition to css_set.
+	 */
+	if (need_forkexit_callback) {
+		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
+			struct cgroup_subsys *ss = subsys[i];
+			if (ss->fork)
+				ss->fork(child);
+		}
+	}
 }
+
 /**
  * cgroup_exit - detach cgroup from exiting task
  * @tsk: pointer to task_struct of exiting process
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -197,23 +197,15 @@ static void freezer_fork(struct cgroup_s
 {
 	struct freezer *freezer;
 
-	/*
-	 * No lock is needed, since the task isn't on tasklist yet,
-	 * so it can't be moved to another cgroup, which means the
-	 * freezer won't be removed and will be valid during this
-	 * function call.  Nevertheless, apply RCU read-side critical
-	 * section to suppress RCU lockdep false positives.
-	 */
 	rcu_read_lock();
 	freezer = task_freezer(task);
-	rcu_read_unlock();
 
 	/*
 	 * The root cgroup is non-freezable, so we can skip the
 	 * following check.
 	 */
 	if (!freezer->css.cgroup->parent)
-		return;
+		goto out;
 
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state == CGROUP_FROZEN);
@@ -221,7 +213,10 @@ static void freezer_fork(struct cgroup_s
 	/* Locking avoids race with FREEZING -> THAWED transitions. */
 	if (freezer->state == CGROUP_FREEZING)
 		freeze_task(task, true);
+
 	spin_unlock_irq(&freezer->lock);
+out:
+	rcu_read_unlock();
 }
 
 /*
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1057,7 +1057,6 @@ static struct task_struct *copy_process(
 {
 	int retval;
 	struct task_struct *p;
-	int cgroup_callbacks_done = 0;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1312,12 +1311,6 @@ static struct task_struct *copy_process(
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
 
-	/* Now that the task is set up, run cgroup callbacks if
-	 * necessary. We need to run them before the task is visible
-	 * on the tasklist. */
-	cgroup_fork_callbacks(p);
-	cgroup_callbacks_done = 1;
-
 	/* Need tasklist lock for parent etc handling! */
 	write_lock_irq(&tasklist_lock);
 
@@ -1419,7 +1412,7 @@ bad_fork_cleanup_cgroup:
 #endif
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_fork_read_unlock(current);
-	cgroup_exit(p, cgroup_callbacks_done);
+	cgroup_exit(p, 0);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:


