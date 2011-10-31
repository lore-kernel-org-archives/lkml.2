Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934651Ab1JaTHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:07:25 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53941 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934573Ab1JaTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:06:06 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 13/17] cgroup_freezer: prepare for removal of TIF_FREEZE
Date: Mon, 31 Oct 2011 12:05:24 -0700
Message-Id: <1320087928-32307-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TIF_FREEZE will be removed soon and freezing() will directly test
whether any freezing condition is in effect.  Make the following
changes in preparation.

* Rename cgroup_freezing_or_frozen() to cgroup_freezing() and make it
  return bool.

* Make cgroup_freezing() access task_freezer() under rcu read lock
  instead of task_lock().  This makes the state dereferencing racy
  against task moving to another cgroup; however, it was already racy
  without this change as ->state dereference wasn't synchronized.
  This will be later dealt with using attach hooks.

* freezer->state is now set before trying to push tasks into the
  target state.

-v2: Oleg pointed out that freeze_change_state() was setting
     freeze->state incorrectly to CGROUP_FROZEN instead of
     CGROUP_FREEZING.  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/freezer.h |    6 +++---
 kernel/cgroup_freezer.c |   36 ++++++++++++------------------------
 kernel/power/process.c  |    2 +-
 3 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index e6657778..243ec0b 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -63,11 +63,11 @@ static inline bool try_to_freeze(void)
 extern bool freeze_task(struct task_struct *p, bool sig_only);
 
 #ifdef CONFIG_CGROUP_FREEZER
-extern int cgroup_freezing_or_frozen(struct task_struct *task);
+extern bool cgroup_freezing(struct task_struct *task);
 #else /* !CONFIG_CGROUP_FREEZER */
-static inline int cgroup_freezing_or_frozen(struct task_struct *task)
+static inline bool cgroup_freezing(struct task_struct *task)
 {
-	return 0;
+	return false;
 }
 #endif /* !CONFIG_CGROUP_FREEZER */
 
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 1a73727..2fae8b2 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -48,19 +48,17 @@ static inline struct freezer *task_freezer(struct task_struct *task)
 			    struct freezer, css);
 }
 
-static inline int __cgroup_freezing_or_frozen(struct task_struct *task)
+bool cgroup_freezing(struct task_struct *task)
 {
-	enum freezer_state state = task_freezer(task)->state;
-	return (state == CGROUP_FREEZING) || (state == CGROUP_FROZEN);
-}
+	enum freezer_state state;
+	bool ret;
 
-int cgroup_freezing_or_frozen(struct task_struct *task)
-{
-	int result;
-	task_lock(task);
-	result = __cgroup_freezing_or_frozen(task);
-	task_unlock(task);
-	return result;
+	rcu_read_lock();
+	state = task_freezer(task)->state;
+	ret = state == CGROUP_FREEZING || state == CGROUP_FROZEN;
+	rcu_read_unlock();
+
+	return ret;
 }
 
 /*
@@ -102,9 +100,6 @@ struct cgroup_subsys freezer_subsys;
  * freezer_can_attach():
  * cgroup_mutex (held by caller of can_attach)
  *
- * cgroup_freezing_or_frozen():
- * task->alloc_lock (to get task's cgroup)
- *
  * freezer_fork() (preserving fork() performance means can't take cgroup_mutex):
  * freezer->lock
  *  sighand->siglock (if the cgroup is freezing)
@@ -177,13 +172,7 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
 
 static int freezer_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
-	rcu_read_lock();
-	if (__cgroup_freezing_or_frozen(tsk)) {
-		rcu_read_unlock();
-		return -EBUSY;
-	}
-	rcu_read_unlock();
-	return 0;
+	return cgroup_freezing(tsk) ? -EBUSY : 0;
 }
 
 static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
@@ -279,7 +268,6 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	struct task_struct *task;
 	unsigned int num_cant_freeze_now = 0;
 
-	freezer->state = CGROUP_FREEZING;
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (!freeze_task(task, true))
@@ -303,8 +291,6 @@ static void unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	while ((task = cgroup_iter_next(cgroup, &it)))
 		__thaw_task(task);
 	cgroup_iter_end(cgroup, &it);
-
-	freezer->state = CGROUP_THAWED;
 }
 
 static int freezer_change_state(struct cgroup *cgroup,
@@ -323,9 +309,11 @@ static int freezer_change_state(struct cgroup *cgroup,
 
 	switch (goal_state) {
 	case CGROUP_THAWED:
+		freezer->state = CGROUP_THAWED;
 		unfreeze_cgroup(cgroup, freezer);
 		break;
 	case CGROUP_FROZEN:
+		freezer->state = CGROUP_FREEZING;
 		retval = try_to_freeze_cgroup(cgroup, freezer);
 		break;
 	default:
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 85ecaec..54ba145 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -166,7 +166,7 @@ void thaw_processes(void)
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
-		if (cgroup_freezing_or_frozen(p))
+		if (cgroup_freezing(p))
 			continue;
 
 		__thaw_task(p);
-- 
1.7.3.1

