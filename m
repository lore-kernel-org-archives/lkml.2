Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2KLV2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:28:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45210 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2KLV2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:28:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [ 3.5.yuz extended stable] Patch "sched: Fix migration thread runtime bogosity" has been added to staging queue
Date: Mon, 12 Nov 2012 19:28:40 -0200
Message-Id: <1352755720-15887-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    sched: Fix migration thread runtime bogosity

to the linux-3.5.y-queue branch of the 3.5.yuz extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.5.y-queue

If you, or anyone else, feels it should not be added to the 3.5
Linux kernel, or for any feedback related to it, please reply to
this email. For more information on extended stable, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Herton

------

>From e1ad6614897d7b13cb5531d8cdc0e905bb0964d3 Mon Sep 17 00:00:00 2001
From: Mike Galbraith <mgalbraith@suse.de>
Date: Sat, 4 Aug 2012 05:44:14 +0200
Subject: [PATCH] sched: Fix migration thread runtime bogosity

commit 8f6189684eb4e85e6c593cd710693f09c944450a upstream.

Make stop scheduler class do the same accounting as other classes,

Migration threads can be caught in the act while doing exec balancing,
leading to the below due to use of unmaintained ->se.exec_start.  The
load that triggered this particular instance was an apparently out of
control heavily threaded application that does system monitoring in
what equated to an exec bomb, with one of the VERY frequently migrated
tasks being ps.

%CPU   PID USER     CMD
99.3    45 root     [migration/10]
97.7    53 root     [migration/12]
97.0    57 root     [migration/13]
90.1    49 root     [migration/11]
89.6    65 root     [migration/15]
88.7    17 root     [migration/3]
80.4    37 root     [migration/8]
78.1    41 root     [migration/9]
44.2    13 root     [migration/2]

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344051854.6739.19.camel@marge.simpson.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/sched/stop_task.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 7b386e8..da5eb5b 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -27,8 +27,10 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
 {
 	struct task_struct *stop = rq->stop;

-	if (stop && stop->on_rq)
+	if (stop && stop->on_rq) {
+		stop->se.exec_start = rq->clock_task;
 		return stop;
+	}

 	return NULL;
 }
@@ -52,6 +54,21 @@ static void yield_task_stop(struct rq *rq)

 static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 {
+	struct task_struct *curr = rq->curr;
+	u64 delta_exec;
+
+	delta_exec = rq->clock_task - curr->se.exec_start;
+	if (unlikely((s64)delta_exec < 0))
+		delta_exec = 0;
+
+	schedstat_set(curr->se.statistics.exec_max,
+			max(curr->se.statistics.exec_max, delta_exec));
+
+	curr->se.sum_exec_runtime += delta_exec;
+	account_group_exec_runtime(curr, delta_exec);
+
+	curr->se.exec_start = rq->clock_task;
+	cpuacct_charge(curr, delta_exec);
 }

 static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
@@ -60,6 +77,9 @@ static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)

 static void set_curr_task_stop(struct rq *rq)
 {
+	struct task_struct *stop = rq->stop;
+
+	stop->se.exec_start = rq->clock_task;
 }

 static void switched_to_stop(struct rq *rq, struct task_struct *p)
--
1.7.9.5

