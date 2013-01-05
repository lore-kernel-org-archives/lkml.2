Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3AEIhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:37:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755465Ab3AEIh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210111"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH v3 11/22] sched: consider runnable load average in effective_load
Date: Sat,  5 Jan 2013 16:37:40 +0800
Message-Id: <1357375071-11793-12-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

effective_load calculates the load change as seen from the
root_task_group. It needs to multiple cfs_rq's tg_runnable_contrib
when we turn to runnable load average balance.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cab62aa..247d6a8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2982,7 +2982,8 @@ static void task_waking_fair(struct task_struct *p)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
- * effective_load() calculates the load change as seen from the root_task_group
+ * effective_load() calculates the runnable load average change as seen from
+ * the root_task_group
  *
  * Adding load to a group doesn't make a group heavier, but can cause movement
  * of group shares between cpus. Assuming the shares were perfectly aligned one
@@ -3030,13 +3031,17 @@ static void task_waking_fair(struct task_struct *p)
  * Therefore the effective change in loads on CPU 0 would be 5/56 (3/8 - 2/7)
  * times the weight of the group. The effect on CPU 1 would be -4/56 (4/8 -
  * 4/7) times the weight of the group.
+ *
+ * After get effective_load of the load moving, will multiple the cpu own
+ * cfs_rq's runnable contrib of root_task_group.
  */
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 {
 	struct sched_entity *se = tg->se[cpu];
 
 	if (!tg->parent)	/* the trivial, non-cgroup case */
-		return wl;
+		return wl * tg->cfs_rq[cpu]->tg_runnable_contrib
+						>> NICE_0_SHIFT;
 
 	for_each_sched_entity(se) {
 		long w, W;
@@ -3084,7 +3089,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		wg = 0;
 	}
 
-	return wl;
+	return wl * tg->cfs_rq[cpu]->tg_runnable_contrib >> NICE_0_SHIFT;
 }
 #else
 
-- 
1.7.12

