Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2LJI0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:26:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:14834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab2LJI0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:26:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="178808697"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: [PATCH 02/18] sched: fix find_idlest_group mess logical
Date: Mon, 10 Dec 2012 16:22:18 +0800
Message-Id: <1355127754-8444-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
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
 kernel/sched/fair.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df99456..b40bc2b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2953,6 +2953,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		  int this_cpu, int load_idx)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
+	struct sched_group *this_group = NULL;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
@@ -2987,14 +2988,19 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 
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
1.7.5.1

