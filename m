Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3AEIhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:37:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab3AEIhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210044"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH v3 03/22] sched: fix find_idlest_group mess logical
Date: Sat,  5 Jan 2013 16:37:32 +0800
Message-Id: <1357375071-11793-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is 4 situations in the function:
1, no task allowed group;
	so min_load = ULONG_MAX, this_load = 0, idlest = NULL
2, only local group task allowed;
	so min_load = ULONG_MAX, this_load assigned, idlest = NULL
3, only non-local task group allowed;
	so min_load assigned, this_load = 0, idlest != NULL
4, local group + another group are task allowed.
	so min_load assigned, this_load assigned, idlest != NULL

Current logical will return NULL in first 3 kinds of scenarios.
And still return NULL, if idlest group is heavier then the
local group in the 4th situation.

Actually, I thought groups in situation 2,3 are also eligible to host
the task. And in 4th situation, agree to bias toward local group.
So, has this patch.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6d3a95d..3c7b09a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3181,6 +3181,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		  int this_cpu, int load_idx)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
+	struct sched_group *this_group = NULL;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
@@ -3215,14 +3216,19 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 
 		if (local_group) {
 			this_load = avg_load;
-		} else if (avg_load < min_load) {
+			this_group = group;
+		}
+		if (avg_load < min_load) {
 			min_load = avg_load;
 			idlest = group;
 		}
 	} while (group = group->next, group != sd->groups);
 
-	if (!idlest || 100*this_load < imbalance*min_load)
-		return NULL;
+	if (this_group && idlest != this_group)
+		/* Bias toward our group again */
+		if (100*this_load < imbalance*min_load)
+			idlest = this_group;
+
 	return idlest;
 }
 
-- 
1.7.12

