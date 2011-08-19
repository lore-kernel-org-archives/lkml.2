Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1HSOQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:16:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39818 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab1HSOQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:16:47 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/16] freezer: make freezing indicate freeze condition in effect
Date: Fri, 19 Aug 2011 16:16:15 +0200
Message-Id: <1313763382-12341-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313763382-12341-1-git-send-email-tj@kernel.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently freezing (TIF_FREEZE) and frozen (PF_FROZEN) states are
interlocked - freezing is set to request freeze and when the task
actually freezes, it clears freezing and sets frozen.

This interlocking makes things more complex than necessary - freezing
doesn't mean there's freezing condition in effect and frozen doesn't
match the task actually entering and leaving frozen state (it's
cleared by the thawing task).

This patch makes freezing indicate that freeze condition is in effect.
A task enters and stays frozen if freezing.  This makes PF_FROZEN
manipulation done only by the task itself and prevents wakeup from
__thaw_task() leaking outside of refrigerator.

The only place which needs to tell freezing && !frozen is
try_to_freeze_task() to whine about tasks which don't enter frozen.
It's updated to test the condition explicitly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/freezer.c       |   38 +++++++++++++++++++++-----------------
 kernel/power/process.c |    3 ++-
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index c60082d..d6165cd 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -22,14 +22,18 @@ bool __refrigerator(bool check_kthr_stop)
 	bool was_frozen = false;
 	long save;
 
+	/*
+	 * Enter FROZEN.  If NOFREEZE, schedule immediate thawing by
+	 * clearing freezing.
+	 */
 	spin_lock_irq(&freezer_lock);
 	if (!freezing(current)) {
 		spin_unlock_irq(&freezer_lock);
 		return was_frozen;
 	}
-	if (!(current->flags & PF_NOFREEZE))
-		current->flags |= PF_FROZEN;
-	clear_freeze_flag(current);
+	if (current->flags & PF_NOFREEZE)
+		clear_freeze_flag(current);
+	current->flags |= PF_FROZEN;
 	spin_unlock_irq(&freezer_lock);
 
 	save = current->state;
@@ -44,7 +48,7 @@ bool __refrigerator(bool check_kthr_stop)
 
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!frozen(current) ||
+		if (!freezing(current) ||
 		    (check_kthr_stop && kthread_should_stop()))
 			break;
 		was_frozen = true;
@@ -54,6 +58,11 @@ bool __refrigerator(bool check_kthr_stop)
 	/* Remove the accounting blocker */
 	current->flags &= ~PF_FREEZING;
 
+	/* leave FROZEN */
+	spin_lock_irq(&freezer_lock);
+	current->flags &= ~PF_FROZEN;
+	spin_unlock_irq(&freezer_lock);
+
 	pr_debug("%s left refrigerator\n", current->comm);
 
 	/*
@@ -137,24 +146,19 @@ void cancel_freezing(struct task_struct *p)
 	spin_unlock_irqrestore(&freezer_lock, flags);
 }
 
-/*
- * Wake up a frozen task
- *
- * task_lock() is needed to prevent the race with refrigerator() which may
- * occur if the freezing of tasks fails.  Namely, without the lock, if the
- * freezing of tasks failed, thaw_tasks() might have run before a task in
- * refrigerator() could call frozen_process(), in which case the task would be
- * frozen and no one would thaw it.
- */
 void __thaw_task(struct task_struct *p)
 {
 	unsigned long flags;
 
+	/*
+	 * Clear freezing and kick @p if FROZEN.  Clearing is guaranteed to
+	 * be visible to @p as waking up implies wmb.  Waking up inside
+	 * freezer_lock also prevents wakeups from leaking outside
+	 * refrigerator.
+	 */
 	spin_lock_irqsave(&freezer_lock, flags);
-	if (frozen(p)) {
-		p->flags &= ~PF_FROZEN;
+	clear_freeze_flag(p);
+	if (frozen(p))
 		wake_up_process(p);
-	} else
-		clear_freeze_flag(p);
 	spin_unlock_irqrestore(&freezer_lock, flags);
 }
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 96d138e..f075c2f 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -118,7 +118,8 @@ static int try_to_freeze_tasks(bool sig_only)
 
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (!wakeup && freezing(p) && !freezer_should_skip(p))
+			if (!wakeup && !freezer_should_skip(p) &&
+			    freezing(p) && !frozen(p))
 				sched_show_task(p);
 			cancel_freezing(p);
 		} while_each_thread(g, p);
-- 
1.7.6

