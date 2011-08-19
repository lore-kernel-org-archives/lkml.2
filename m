Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1HSOSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:18:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39818 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1HSOQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:16:51 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/16] freezer: clean up freeze_processes() failure path
Date: Fri, 19 Aug 2011 16:16:18 +0200
Message-Id: <1313763382-12341-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313763382-12341-1-git-send-email-tj@kernel.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

freeze_processes() failure path is rather messy.  Freezing is canceled
for workqueues and tasks which aren't frozen yet but frozen tasks are
left alone and should be thawed by the caller and of course some
callers (xen and kexec) didn't do it.

This patch updates __thaw_task() to handle cancelation correctly and
makes thaw_processes() call thaw_processes() on failure instead so
that the system is fully thawed on failure.  Unnecessary
thaw_processes() calls are removed from kernel/power/hibernate.c and
user.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/freezer.h  |    1 -
 kernel/freezer.c         |   25 +++++++++----------------
 kernel/power/hibernate.c |   15 ++-------------
 kernel/power/process.c   |   10 ++--------
 kernel/power/user.c      |    4 +---
 5 files changed, 14 insertions(+), 41 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 59a6e97..13559a8 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -60,7 +60,6 @@ static inline bool try_to_freeze(void)
 }
 
 extern bool freeze_task(struct task_struct *p, bool sig_only);
-extern void cancel_freezing(struct task_struct *p);
 extern bool __set_freezable(bool with_signal);
 
 #ifdef CONFIG_CGROUP_FREEZER
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 82332bb..7506ef3 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -126,21 +126,6 @@ out_unlock:
 	return ret;
 }
 
-void cancel_freezing(struct task_struct *p)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&freezer_lock, flags);
-	if (freezing(p)) {
-		pr_debug("  clean up: %s\n", p->comm);
-		clear_freeze_flag(p);
-		spin_lock(&p->sighand->siglock);
-		recalc_sigpending_and_wake(p);
-		spin_unlock(&p->sighand->siglock);
-	}
-	spin_unlock_irqrestore(&freezer_lock, flags);
-}
-
 void __thaw_task(struct task_struct *p)
 {
 	unsigned long flags;
@@ -150,11 +135,19 @@ void __thaw_task(struct task_struct *p)
 	 * be visible to @p as waking up implies wmb.  Waking up inside
 	 * freezer_lock also prevents wakeups from leaking outside
 	 * refrigerator.
+	 *
+	 * If !FROZEN, @p hasn't reached refrigerator, recalc sigpending to
+	 * avoid leaving dangling TIF_SIGPENDING behind.
 	 */
 	spin_lock_irqsave(&freezer_lock, flags);
 	clear_freeze_flag(p);
-	if (frozen(p))
+	if (frozen(p)) {
 		wake_up_process(p);
+	} else {
+		spin_lock(&p->sighand->siglock);
+		recalc_sigpending_and_wake(p);
+		spin_unlock(&p->sighand->siglock);
+	}
 	spin_unlock_irqrestore(&freezer_lock, flags);
 }
 
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 8f7b1db..5fed34d 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -586,17 +586,6 @@ static void power_down(void)
 	while(1);
 }
 
-static int prepare_processes(void)
-{
-	int error = 0;
-
-	if (freeze_processes()) {
-		error = -EBUSY;
-		thaw_processes();
-	}
-	return error;
-}
-
 /**
  * hibernate - Carry out system hibernation, including saving the image.
  */
@@ -629,7 +618,7 @@ int hibernate(void)
 	sys_sync();
 	printk("done.\n");
 
-	error = prepare_processes();
+	error = freeze_processes();
 	if (error)
 		goto Finish;
 
@@ -776,7 +765,7 @@ static int software_resume(void)
 		goto close_finish;
 
 	pr_debug("PM: Preparing processes for restore.\n");
-	error = prepare_processes();
+	error = freeze_processes();
 	if (error) {
 		swsusp_close(FMODE_READ);
 		goto Done;
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 7618909..f8012f2 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -91,11 +91,6 @@ static int try_to_freeze_tasks(bool sig_only)
 	elapsed_csecs = elapsed_csecs64;
 
 	if (todo) {
-		/* This does not unfreeze processes that are already frozen
-		 * (we have slightly ugly calling convention in that respect,
-		 * and caller must call thaw_processes() if something fails),
-		 * but it cleans up leftover PF_FREEZE requests.
-		 */
 		printk("\n");
 		printk(KERN_ERR "Freezing of tasks %s after %d.%02d seconds "
 		       "(%d tasks refusing to freeze, wq_busy=%d):\n",
@@ -103,14 +98,11 @@ static int try_to_freeze_tasks(bool sig_only)
 		       elapsed_csecs / 100, elapsed_csecs % 100,
 		       todo - wq_busy, wq_busy);
 
-		thaw_workqueues();
-
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			if (!wakeup && !freezer_should_skip(p) &&
 			    freezing(p) && !frozen(p))
 				sched_show_task(p);
-			cancel_freezing(p);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 	} else {
@@ -142,6 +134,8 @@ int freeze_processes(void)
 
 	oom_killer_disable();
  Exit:
+	if (error)
+		thaw_processes();
 	BUG_ON(in_atomic());
 	printk("\n");
 
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 42ddbc6..afe7737 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -256,10 +256,8 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			break;
 
 		error = freeze_processes();
-		if (error) {
-			thaw_processes();
+		if (error)
 			usermodehelper_enable();
-		}
 		if (!error)
 			data->frozen = 1;
 		break;
-- 
1.7.6

