Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1HSOQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:16:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63671 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1HSOQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:16:48 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/16] freezer: fix set_freezable[_with_signal]() race
Date: Fri, 19 Aug 2011 16:16:16 +0200
Message-Id: <1313763382-12341-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313763382-12341-1-git-send-email-tj@kernel.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A kthread doing set_freezable*() may race with on-going PM freeze and
the freezer might think all tasks are frozen while the new freezable
kthread is marrily proceeding to execute code paths which aren't
supposed to be executing during PM freeze.

This can be fixed by modifying and testing the related PF flags inside
freezer_lock and removing mostly unnecessary early tests from the
callers of freeze/thaw_task().

* Remove all unnecessary tests from kerne/power/process.c and add
  PF_NOFREEZE test to freeze_task(), which is meaningful as it avoids
  sending unsolicted wakeups to nofreeze tasks.

* Reimplement set_freezable[_with_signal]() using __set_freezable()
  such that freezable PF flags are modified under freezer_lock and
  try_to_freeze() is called afterwards.  Combined with the above
  change, this eliminates race condition against freezing.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/freezer.h |    9 +++++----
 kernel/freezer.c        |   28 +++++++++++++++++++++++++++-
 kernel/power/process.c  |   16 +---------------
 3 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 80a455d..59a6e97 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -61,6 +61,7 @@ static inline bool try_to_freeze(void)
 
 extern bool freeze_task(struct task_struct *p, bool sig_only);
 extern void cancel_freezing(struct task_struct *p);
+extern bool __set_freezable(bool with_signal);
 
 #ifdef CONFIG_CGROUP_FREEZER
 extern int cgroup_freezing_or_frozen(struct task_struct *task);
@@ -118,18 +119,18 @@ static inline int freezer_should_skip(struct task_struct *p)
 /*
  * Tell the freezer that the current task should be frozen by it
  */
-static inline void set_freezable(void)
+static inline bool set_freezable(void)
 {
-	current->flags &= ~PF_NOFREEZE;
+	return __set_freezable(false);
 }
 
 /*
  * Tell the freezer that the current task should be frozen by it and that it
  * should send a fake signal to the task to freeze it.
  */
-static inline void set_freezable_with_signal(void)
+static inline bool set_freezable_with_signal(void)
 {
-	current->flags &= ~(PF_NOFREEZE | PF_FREEZER_NOSIG);
+	return __set_freezable(true);
 }
 
 /*
diff --git a/kernel/freezer.c b/kernel/freezer.c
index d6165cd..501f1b7 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -106,7 +106,8 @@ bool freeze_task(struct task_struct *p, bool sig_only)
 
 	spin_lock_irqsave(&freezer_lock, flags);
 
-	if (sig_only && !should_send_signal(p))
+	if ((p->flags & PF_NOFREEZE) ||
+	    (sig_only && !should_send_signal(p)))
 		goto out_unlock;
 
 	if (frozen(p))
@@ -162,3 +163,28 @@ void __thaw_task(struct task_struct *p)
 		wake_up_process(p);
 	spin_unlock_irqrestore(&freezer_lock, flags);
 }
+
+/**
+ * __set_freezable - make %current freezable
+ * @with_signal: do we want %TIF_SIGPENDING for notification too?
+ *
+ * Mark %current freezable and enter refrigerator if necessary.
+ */
+bool __set_freezable(bool with_signal)
+{
+	might_sleep();
+
+	/*
+	 * Modify flags while holding freezer_lock.  This ensures the
+	 * freezer notices that we aren't frozen yet or the freezing
+	 * condition is visible to try_to_freeze() below.
+	 */
+	spin_lock_irq(&freezer_lock);
+	current->flags &= ~PF_NOFREEZE;
+	if (with_signal)
+		current->flags &= ~PF_FREEZER_NOSIG;
+	spin_unlock_irq(&freezer_lock);
+
+	return try_to_freeze();
+}
+EXPORT_SYMBOL(__set_freezable);
diff --git a/kernel/power/process.c b/kernel/power/process.c
index f075c2f..7618909 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -22,14 +22,6 @@
  */
 #define TIMEOUT	(20 * HZ)
 
-static inline int freezable(struct task_struct * p)
-{
-	if ((p == current) ||
-	    (p->flags & PF_NOFREEZE))
-		return 0;
-	return 1;
-}
-
 static int try_to_freeze_tasks(bool sig_only)
 {
 	struct task_struct *g, *p;
@@ -52,10 +44,7 @@ static int try_to_freeze_tasks(bool sig_only)
 		todo = 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (frozen(p) || !freezable(p))
-				continue;
-
-			if (!freeze_task(p, sig_only))
+			if (p == current || !freeze_task(p, sig_only))
 				continue;
 
 			/*
@@ -171,9 +160,6 @@ void thaw_processes(void)
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
-		if (!freezable(p))
-			continue;
-
 		if (cgroup_freezing_or_frozen(p))
 			continue;
 
-- 
1.7.6

