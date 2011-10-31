Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220Ab1JaTFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:05:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44251 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934039Ab1JaTFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:05:49 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/17] freezer: remove racy clear_freeze_flag() and set PF_NOFREEZE on dead tasks
Date: Mon, 31 Oct 2011 12:05:17 -0700
Message-Id: <1320087928-32307-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clear_freeze_flag() in exit_mm() is racy.  Freezing can start
afterwards.  Remove it.  Skipping freezer for exiting task will be
properly implemented later.

Also, freezable() was testing exit_state directly to make system
freezer ignore dead tasks.  Let the exiting task set PF_NOFREEZE after
entering TASK_DEAD instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c          |    3 +--
 kernel/power/process.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 2913b35..3d6f570 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -679,8 +679,6 @@ static void exit_mm(struct task_struct * tsk)
 	tsk->mm = NULL;
 	up_read(&mm->mmap_sem);
 	enter_lazy_tlb(mm, current);
-	/* We don't want this task to be frozen prematurely */
-	clear_freeze_flag(tsk);
 	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 		atomic_dec(&mm->oom_disable_count);
 	task_unlock(tsk);
@@ -1042,6 +1040,7 @@ NORET_TYPE void do_exit(long code)
 	exit_rcu();
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
+	tsk->flags |= PF_NOFREEZE;	/* tell freezer to ignore us */
 	schedule();
 	BUG();
 	/* Avoid "noreturn function does return".  */
diff --git a/kernel/power/process.c b/kernel/power/process.c
index fe27872..23822dc 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -25,8 +25,7 @@
 static inline int freezable(struct task_struct * p)
 {
 	if ((p == current) ||
-	    (p->flags & PF_NOFREEZE) ||
-	    (p->exit_state != 0))
+	    (p->flags & PF_NOFREEZE))
 		return 0;
 	return 1;
 }
-- 
1.7.3.1

