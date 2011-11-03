Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1KCWZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:25:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52299 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1KCWZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:25:50 -0400
Date: Thu, 3 Nov 2011 15:25:38 -0700
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH UPDATED 12/17] freezer: clean up freeze_processes() failure
 path
Message-ID: <20111103222538.GQ4417@google.com>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
 <1320087928-32307-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320087928-32307-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2981f8990826d8ab411c7d7bba59bfb7540a015c Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 3 Nov 2011 15:19:27 -0700

freeze_processes() failure path is rather messy.  Freezing is canceled
for workqueues and tasks which aren't frozen yet but frozen tasks are
left alone and should be thawed by the caller and of course some
callers (xen and kexec) didn't do it.

This patch updates __thaw_task() to handle cancelation correctly and
makes freeze_processes() and freeze_kernel_threads() call
thaw_processes() on failure instead so that the system is fully thawed
on failure.  Unnecessary [suspend_]thaw_processes() calls are removed
from kernel/power/hibernate.c, suspend.c and user.c.

While at it, restructure error checking if clause in suspend_prepare()
to be less weird.

-v2: Srivatsa spotted missing removal of suspend_thaw_processes() in
     suspend_prepare() and error in commit message.  Updated.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---
Alright, updated suspend.c and the commit message and added Srivatsa's
Acked-by.  This update doesn't cause conflicts with other patches and
git branch is updated accordingly.

Thanks.

 include/linux/freezer.h  |    1 -
 kernel/freezer.c         |   25 +++++++++----------------
 kernel/power/hibernate.c |   15 ++-------------
 kernel/power/process.c   |   16 ++++++++--------
 kernel/power/suspend.c   |    8 +++-----
 kernel/power/user.c      |    4 +---
 6 files changed, 23 insertions(+), 46 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 253bcfe..e6657778 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -61,7 +61,6 @@ static inline bool try_to_freeze(void)
 }
 
 extern bool freeze_task(struct task_struct *p, bool sig_only);
-extern void cancel_freezing(struct task_struct *p);
 
 #ifdef CONFIG_CGROUP_FREEZER
 extern int cgroup_freezing_or_frozen(struct task_struct *task);
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 3be1e36..7a9f706 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -129,21 +129,6 @@ out_unlock:
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
@@ -153,10 +138,18 @@ void __thaw_task(struct task_struct *p)
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
index 1c53f7f..def6406 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -593,17 +593,6 @@ static void power_down(void)
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
@@ -636,7 +625,7 @@ int hibernate(void)
 	sys_sync();
 	printk("done.\n");
 
-	error = prepare_processes();
+	error = freeze_processes();
 	if (error)
 		goto Finish;
 
@@ -799,7 +788,7 @@ static int software_resume(void)
 		goto close_finish;
 
 	pr_debug("PM: Preparing processes for restore.\n");
-	error = prepare_processes();
+	error = freeze_processes();
 	if (error) {
 		swsusp_close(FMODE_READ);
 		goto Done;
diff --git a/kernel/power/process.c b/kernel/power/process.c
index e59676f..ce64383 100644
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
@@ -123,6 +115,8 @@ static int try_to_freeze_tasks(bool sig_only)
 
 /**
  * freeze_processes - Signal user space processes to enter the refrigerator.
+ *
+ * On success, returns 0.  On failure, -errno and system is fully thawed.
  */
 int freeze_processes(void)
 {
@@ -137,11 +131,15 @@ int freeze_processes(void)
 	printk("\n");
 	BUG_ON(in_atomic());
 
+	if (error)
+		thaw_processes();
 	return error;
 }
 
 /**
  * freeze_kernel_threads - Make freezable kernel threads go to the refrigerator.
+ *
+ * On success, returns 0.  On failure, -errno and system is fully thawed.
  */
 int freeze_kernel_threads(void)
 {
@@ -155,6 +153,8 @@ int freeze_kernel_threads(void)
 	printk("\n");
 	BUG_ON(in_atomic());
 
+	if (error)
+		thaw_processes();
 	return error;
 }
 
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index fdd4263..633e9f9 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -104,13 +104,11 @@ static int suspend_prepare(void)
 		goto Finish;
 
 	error = suspend_freeze_processes();
-	if (error) {
-		suspend_stats.failed_freeze++;
-		dpm_save_failed_step(SUSPEND_FREEZE);
-	} else
+	if (!error)
 		return 0;
 
-	suspend_thaw_processes();
+	suspend_stats.failed_freeze++;
+	dpm_save_failed_step(SUSPEND_FREEZE);
 	usermodehelper_enable();
  Finish:
 	pm_notifier_call_chain(PM_POST_SUSPEND);
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
1.7.3.1

