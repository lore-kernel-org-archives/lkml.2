Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab2HJHbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 03:31:16 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46581 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab2HJHbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 03:31:13 -0400
X-AuditID: 9c93016f-b7c98ae0000013b4-a3-5024b8bfb7a5
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC/PATCH] sched: Honor sync wake up in select_idle_sibling
Date: Fri, 10 Aug 2012 16:25:12 +0900
Message-Id: <1344583512-25352-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When sync wakeup happens and there's the waker task running alone,
select the target cpu as if it's already idle.

Cc: Mike Galbraith <efault@gmx.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/sched/fair.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d0cc03b3e70b..64b68bc82b52 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2632,7 +2632,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 /*
  * Try and locate an idle CPU in the sched_domain.
  */
-static int select_idle_sibling(struct task_struct *p, int target)
+static int select_idle_sibling(struct task_struct *p, int target, int sync)
 {
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
@@ -2646,6 +2646,13 @@ static int select_idle_sibling(struct task_struct *p, int target)
 		return cpu;
 
 	/*
+	 * If the task is going to be woken-up on this cpu and there's only
+	 * the sync-waker running, then it is the right target.
+	 */
+	if (target == cpu && sync && this_rq()->nr_running == 1)
+		return cpu;
+
+	/*
 	 * If the task is going to be woken-up on the cpu where it previously
 	 * ran and if it is currently idle, then it the right target.
 	 */
@@ -2748,7 +2755,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
 			prev_cpu = cpu;
 
-		new_cpu = select_idle_sibling(p, prev_cpu);
+		new_cpu = select_idle_sibling(p, prev_cpu, sync);
 		goto unlock;
 	}
 
-- 
1.7.11.2

