Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3AIGvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 01:51:10 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60740 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab3AIGvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 01:51:08 -0500
X-AuditID: 9c930179-b7c7fae00000255c-32-50ed1359c3c4
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Mike Galbraith <efault@gmx.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Alex Shi <alex.shi@intel.com>
Subject: [PATCH] sched: Get rid of unnecessary checks from select_idle_sibling
Date: Wed,  9 Jan 2013 15:50:56 +0900
Message-Id: <1357714256-24373-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

AFAICS @target cpu of select_idle_sibling() is always either prev_cpu
or this_cpu.  So no need to check it again and the conditionals can be
consolidated.

Cc: Mike Galbraith <efault@gmx.de>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Alex Shi <alex.shi@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/sched/fair.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea8707234a..af665814c216 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3254,25 +3254,16 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  */
 static int select_idle_sibling(struct task_struct *p, int target)
 {
-	int cpu = smp_processor_id();
-	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
 	struct sched_group *sg;
 	int i;
 
 	/*
-	 * If the task is going to be woken-up on this cpu and if it is
-	 * already idle, then it is the right target.
-	 */
-	if (target == cpu && idle_cpu(cpu))
-		return cpu;
-
-	/*
-	 * If the task is going to be woken-up on the cpu where it previously
-	 * ran and if it is currently idle, then it the right target.
+	 * If the task is going to be woken-up on this cpu or the cpu where it
+	 * previously ran and it is already idle, then it is the right target.
 	 */
-	if (target == prev_cpu && idle_cpu(prev_cpu))
-		return prev_cpu;
+	if (idle_cpu(target))
+		return target;
 
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
-- 
1.7.11.7

