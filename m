Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289Ab1FWRgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:36:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:34327 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab1FWRgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 087/247] sched, cgroup: Fixup broken cgroup movement
Date: Thu, 23 Jun 2011 13:32:35 -0400
Message-Id: <1308850515-15242-28-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b2b5ce022acf5e9f52f7b78c5579994fdde191d4 upstream.

Dima noticed that we fail to correct the ->vruntime of sleeping tasks
when we move them between cgroups.

Reported-by: Dima Zavin <dima@android.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1287150604.29097.1513.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |    8 ++++----
 kernel/sched_fair.c   |   25 +++++++++++++++++++------
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 89e0fee..03e34c5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1071,7 +1071,7 @@ struct sched_class {
 					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*moved_group) (struct task_struct *p, int on_rq);
+	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
 };
 
diff --git a/kernel/sched.c b/kernel/sched.c
index f7bc764..39456fc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8275,12 +8275,12 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		tsk->sched_class->put_prev_task(rq, tsk);
 
-	set_task_rq(tsk, task_cpu(tsk));
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	if (tsk->sched_class->moved_group)
-		tsk->sched_class->moved_group(tsk, on_rq);
+	if (tsk->sched_class->task_move_group)
+		tsk->sched_class->task_move_group(tsk, on_rq);
+	else
 #endif
+		set_task_rq(tsk, task_cpu(tsk));
 
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index b0f68035..f060583 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3668,13 +3668,26 @@ static void set_curr_task_fair(struct rq *rq)
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void moved_group_fair(struct task_struct *p, int on_rq)
+static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-
-	update_curr(cfs_rq);
+	/*
+	 * If the task was not on the rq at the time of this cgroup movement
+	 * it must have been asleep, sleeping tasks keep their ->vruntime
+	 * absolute on their old rq until wakeup (needed for the fair sleeper
+	 * bonus in place_entity()).
+	 *
+	 * If it was on the rq, we've just 'preempted' it, which does convert
+	 * ->vruntime to a relative base.
+	 *
+	 * Make sure both cases convert their relative position when migrating
+	 * to another cgroup's rq. This does somewhat interfere with the
+	 * fair sleeper stuff for the first placement, but who cares.
+	 */
+	if (!on_rq)
+		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
+	set_task_rq(p, task_cpu(p));
 	if (!on_rq)
-		place_entity(cfs_rq, &p->se, 1);
+		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
 }
 #endif
 
@@ -3726,7 +3739,7 @@ static const struct sched_class fair_sched_class = {
 	.get_rr_interval	= get_rr_interval_fair,
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	.moved_group		= moved_group_fair,
+	.task_move_group	= task_move_group_fair,
 #endif
 };
 
-- 
1.7.4.4

