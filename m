Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab0I2HSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:18:11 -0400
Received: from smtp-out.google.com ([74.125.121.35]:35773 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0I2HSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:18:09 -0400
From: Dima Zavin <dima@android.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 1/2] sched: normalize sleeper's vruntime during group change
Date: Wed, 29 Sep 2010 00:17:48 -0700
Message-Id: <1285744668-9209-1-git-send-email-dima@android.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <AANLkTimM9bHqGtuNisYjOtL=d014CzB3foQSnnf-bPkv@mail.gmail.com>
References: <AANLkTimM9bHqGtuNisYjOtL=d014CzB3foQSnnf-bPkv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a new callback, prep_move_task, to struct sched_class
to give sched_fair the opportunity to adjust the task's vruntime
just before setting its new group.

This allows us to properly normalize a sleeping task's vruntime
when moving it between different cgroups.

More details about the problem:
  http://lkml.org/lkml/2010/9/28/24

Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Dima Zavin <dima@android.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    5 +++++
 kernel/sched_fair.c   |   16 +++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1e2a6db..ba3494e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1073,6 +1073,7 @@ struct sched_class {
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p, int on_rq);
+	void (*prep_move_group) (struct task_struct *p, int on_rq);
 #endif
 };
 
diff --git a/kernel/sched.c b/kernel/sched.c
index dc85ceb..fe4bb20 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8297,6 +8297,11 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		tsk->sched_class->put_prev_task(rq, tsk);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (tsk->sched_class->prep_move_group)
+		tsk->sched_class->prep_move_group(tsk, on_rq);
+#endif
+
 	set_task_rq(tsk, task_cpu(tsk));
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index db3f674..008fe57 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3827,10 +3827,23 @@ static void set_curr_task_fair(struct rq *rq)
 static void moved_group_fair(struct task_struct *p, int on_rq)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct sched_entity *se = &p->se;
 
 	update_curr(cfs_rq);
-	if (!on_rq)
+	if (!on_rq) {
+		se->vruntime += cfs_rq->min_vruntime;
 		place_entity(cfs_rq, &p->se, 1);
+	}
+}
+
+static void prep_move_group_fair(struct task_struct *p, int on_rq)
+{
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct sched_entity *se = &p->se;
+
+	/* normalize the runtime of a sleeping task before moving it */
+	if (!on_rq)
+		se->vruntime -= cfs_rq->min_vruntime;
 }
 #endif
 
@@ -3883,6 +3896,7 @@ static const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.moved_group		= moved_group_fair,
+	.prep_move_group	= prep_move_group_fair,
 #endif
 };
 
-- 
1.6.6

