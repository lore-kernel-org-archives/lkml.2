Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673Ab1JaWgC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:36:02 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37472 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934573Ab1JaWgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:36:00 -0400
Date: Mon, 31 Oct 2011 15:35:54 -0700
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com
Subject: [PATCH UPDATED 20/17] freezer: remove unused @sig_only from
 freeze_task()
Message-ID: <20111031223554.GF18855@google.com>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After "freezer: make freezing() test freeze conditions in effect
instead of TIF_FREEZE", freezing() returns authoritative answer on
whether the current task should freeze or not and freeze_task()
doesn't need or use @sig_only.  Remove it.

While at it, rewrite function comment for freeze_task() and rename
@sig_only to @user_only in try_to_freeze_tasks().

This patch doesn't cause any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/freezer.h |    2 +-
 kernel/cgroup_freezer.c |    4 ++--
 kernel/freezer.c        |   21 +++++++++------------
 kernel/power/process.c  |    8 ++++----
 4 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index ac0513e..4b3dc4c 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -48,7 +48,7 @@ static inline bool try_to_freeze(void)
 	return __refrigerator(false);
 }
 
-extern bool freeze_task(struct task_struct *p, bool sig_only);
+extern bool freeze_task(struct task_struct *p);
 extern bool __set_freezable(bool with_signal);
 
 #ifdef CONFIG_CGROUP_FREEZER
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 5f45423..d161958 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -206,7 +206,7 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 
 	/* Locking avoids race with FREEZING -> THAWED transitions. */
 	if (freezer->state == CGROUP_FREEZING)
-		freeze_task(task, true);
+		freeze_task(task);
 	spin_unlock_irq(&freezer->lock);
 }
 
@@ -274,7 +274,7 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
-		if (!freeze_task(task, true))
+		if (!freeze_task(task))
 			continue;
 		if (frozen(task))
 			continue;
diff --git a/kernel/freezer.c b/kernel/freezer.c
index a9c18c7..0845321 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -100,20 +100,17 @@ static void fake_signal_wake_up(struct task_struct *p)
 }
 
 /**
- *	freeze_task - send a freeze request to given task
- *	@p: task to send the request to
- *	@sig_only: if set, the request will only be sent if the task has the
- *		PF_FREEZER_NOSIG flag unset
- *	Return value: 'false', if @sig_only is set and the task has
- *		PF_FREEZER_NOSIG set or the task is frozen, 'true', otherwise
+ * freeze_task - send a freeze request to given task
+ * @p: task to send the request to
  *
- *	The freeze request is sent by setting the tasks's TIF_FREEZE flag and
- *	either sending a fake signal to it or waking it up, depending on whether
- *	or not it has PF_FREEZER_NOSIG set.  If @sig_only is set and the task
- *	has PF_FREEZER_NOSIG set (ie. it is a typical kernel thread), its
- *	TIF_FREEZE flag will not be set.
+ * If @p is freezing, the freeze request is sent by setting %TIF_FREEZE
+ * flag and either sending a fake signal to it or waking it up, depending
+ * on whether it has %PF_FREEZER_NOSIG set.
+ *
+ * RETURNS:
+ * %false, if @p is not freezing or already frozen; %true, otherwise
  */
-bool freeze_task(struct task_struct *p, bool sig_only)
+bool freeze_task(struct task_struct *p)
 {
 	unsigned long flags;
 
diff --git a/kernel/power/process.c b/kernel/power/process.c
index eed8995..8bddc48 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -22,7 +22,7 @@
  */
 #define TIMEOUT	(20 * HZ)
 
-static int try_to_freeze_tasks(bool sig_only)
+static int try_to_freeze_tasks(bool user_only)
 {
 	struct task_struct *g, *p;
 	unsigned long end_time;
@@ -37,14 +37,14 @@ static int try_to_freeze_tasks(bool sig_only)
 
 	end_time = jiffies + TIMEOUT;
 
-	if (!sig_only)
+	if (!user_only)
 		freeze_workqueues_begin();
 
 	while (true) {
 		todo = 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (p == current || !freeze_task(p, sig_only))
+			if (p == current || !freeze_task(p))
 				continue;
 
 			/*
@@ -65,7 +65,7 @@ static int try_to_freeze_tasks(bool sig_only)
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 
-		if (!sig_only) {
+		if (!user_only) {
 			wq_busy = freeze_workqueues_busy();
 			todo += wq_busy;
 		}
-- 
1.7.3.1

