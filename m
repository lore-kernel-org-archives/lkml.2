Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934643Ab1JaTI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:08:58 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49433 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033Ab1JaTFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:05:47 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>, Paul Menage <menage@google.com>
Subject: [PATCH 05/17] freezer: rename thaw_process() to __thaw_task() and simplify the implementation
Date: Mon, 31 Oct 2011 12:05:16 -0700
Message-Id: <1320087928-32307-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thaw_process() now has only internal users - system and cgroup
freezers.  Remove the unnecessary return value, rename, unexport and
collapse __thaw_process() into it.  This will help further updates to
the freezer code.

-v2: minor style update as suggested by Matt.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Menage <menage@google.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
---
 include/linux/freezer.h |    3 +--
 kernel/cgroup_freezer.c |    7 +++----
 kernel/freezer.c        |   31 ++++++++++++-------------------
 kernel/power/process.c  |    2 +-
 4 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 4a73dd2..253bcfe 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -45,7 +45,7 @@ static inline bool should_send_signal(struct task_struct *p)
 }
 
 /* Takes and releases task alloc lock using task_lock() */
-extern int thaw_process(struct task_struct *p);
+extern void __thaw_task(struct task_struct *t);
 
 extern bool __refrigerator(bool check_kthr_stop);
 extern int freeze_processes(void);
@@ -183,7 +183,6 @@ static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void set_freeze_flag(struct task_struct *p) {}
 static inline void clear_freeze_flag(struct task_struct *p) {}
-static inline int thaw_process(struct task_struct *p) { return 1; }
 
 static inline bool __refrigerator(bool check_kthr_stop) { return false; }
 static inline int freeze_processes(void) { return -ENOSYS; }
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index e691818..e7fa0ec 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -130,7 +130,7 @@ struct cgroup_subsys freezer_subsys;
  *   write_lock css_set_lock (cgroup iterator start)
  *    task->alloc_lock
  *   read_lock css_set_lock (cgroup iterator start)
- *    task->alloc_lock (inside thaw_process(), prevents race with refrigerator())
+ *    task->alloc_lock (inside __thaw_task(), prevents race with refrigerator())
  *     sighand->siglock
  */
 static struct cgroup_subsys_state *freezer_create(struct cgroup_subsys *ss,
@@ -300,9 +300,8 @@ static void unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	struct task_struct *task;
 
 	cgroup_iter_start(cgroup, &it);
-	while ((task = cgroup_iter_next(cgroup, &it))) {
-		thaw_process(task);
-	}
+	while ((task = cgroup_iter_next(cgroup, &it)))
+		__thaw_task(task);
 	cgroup_iter_end(cgroup, &it);
 
 	freezer->state = CGROUP_THAWED;
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 57ba75f..8faa0e0 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -145,18 +145,8 @@ void cancel_freezing(struct task_struct *p)
 	}
 }
 
-static int __thaw_process(struct task_struct *p)
-{
-	if (frozen(p)) {
-		p->flags &= ~PF_FROZEN;
-		return 1;
-	}
-	clear_freeze_flag(p);
-	return 0;
-}
-
 /*
- * Wake up a frozen process
+ * Wake up a frozen task
  *
  * task_lock() is needed to prevent the race with refrigerator() which may
  * occur if the freezing of tasks fails.  Namely, without the lock, if the
@@ -164,15 +154,18 @@ static int __thaw_process(struct task_struct *p)
  * refrigerator() could call frozen_process(), in which case the task would be
  * frozen and no one would thaw it.
  */
-int thaw_process(struct task_struct *p)
+void __thaw_task(struct task_struct *p)
 {
+	bool was_frozen;
+
 	task_lock(p);
-	if (__thaw_process(p) == 1) {
-		task_unlock(p);
-		wake_up_process(p);
-		return 1;
-	}
+	was_frozen = frozen(p);
+	if (was_frozen)
+		p->flags &= ~PF_FROZEN;
+	else
+		clear_freeze_flag(p);
 	task_unlock(p);
-	return 0;
+
+	if (was_frozen)
+		wake_up_process(p);
 }
-EXPORT_SYMBOL(thaw_process);
diff --git a/kernel/power/process.c b/kernel/power/process.c
index addbbe5..fe27872 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -186,7 +186,7 @@ static void thaw_tasks(bool nosig_only)
 		if (cgroup_freezing_or_frozen(p))
 			continue;
 
-		thaw_process(p);
+		__thaw_task(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 }
-- 
1.7.3.1

