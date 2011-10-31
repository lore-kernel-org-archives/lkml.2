Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586Ab1JaTGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:06:06 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63571 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934193Ab1JaTGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:06:02 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/17] freezer: kill PF_FREEZING
Date: Mon, 31 Oct 2011 12:05:22 -0700
Message-Id: <1320087928-32307-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous changes, there's no meaningful difference between
PF_FREEZING and PF_FROZEN.  Remove PF_FREEZING and use PF_FROZEN
instead in task_contributes_to_load().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched.h |    3 +--
 kernel/freezer.c      |    6 ------
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e8acce7..57f916d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -220,7 +220,7 @@ extern char ___assert_task_state[1 - 2*!!(
 			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\
 				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
-				 (task->flags & PF_FREEZING) == 0)
+				 (task->flags & PF_FROZEN) == 0)
 
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)
@@ -1766,7 +1766,6 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
 #define PF_NPROC_EXCEEDED 0x00001000	/* set_user noticed that RLIMIT_NPROC was exceeded */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
-#define PF_FREEZING	0x00004000	/* freeze in progress. do not account to load */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 5c911c0..3be1e36 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -44,9 +44,6 @@ repeat:
 	recalc_sigpending(); /* We sent fake signal, clean it up */
 	spin_unlock_irq(&current->sighand->siglock);
 
-	/* prevent accounting of that task to load */
-	current->flags |= PF_FREEZING;
-
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!freezing(current) ||
@@ -56,9 +53,6 @@ repeat:
 		schedule();
 	}
 
-	/* Remove the accounting blocker */
-	current->flags &= ~PF_FREEZING;
-
 	/* leave FROZEN */
 	spin_lock_irq(&freezer_lock);
 	if (freezing(current))
-- 
1.7.3.1

