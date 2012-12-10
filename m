Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2LJI0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:26:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:14834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab2LJI0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:26:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="178808704"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: [PATCH 04/18] sched: remove domain iterations in fork/exec/wake
Date: Mon, 10 Dec 2012 16:22:20 +0800
Message-Id: <1355127754-8444-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guess the search cpu from bottom to up in domain tree come from
commit 3dbd5342074a1e sched: multilevel sbe sbf, the purpose is
balancing over tasks on all level domains.

This balancing cost much if there has many domain/groups in a large
system. And force spreading task among different domains may cause
performance issue due to bad locality.

If we remove this code, we will get quick fork/exec/wake, plus better
balancing among whole system, that also reduce migrations in future
load balancing.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 05ee54e..1faf89f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3136,15 +3136,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		goto unlock;
 	}
 
-	while (sd) {
+	if (sd) {
 		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
-		int weight;
-
-		if (!(sd->flags & sd_flag)) {
-			sd = sd->child;
-			continue;
-		}
 
 		if (sd_flag & SD_BALANCE_WAKE)
 			load_idx = sd->wake_idx;
@@ -3154,18 +3148,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 			goto unlock;
 
 		new_cpu = find_idlest_cpu(group, p, cpu);
-
-		/* Now try balancing at a lower domain level of new_cpu */
-		cpu = new_cpu;
-		weight = sd->span_weight;
-		sd = NULL;
-		for_each_domain(cpu, tmp) {
-			if (weight <= tmp->span_weight)
-				break;
-			if (tmp->flags & sd_flag)
-				sd = tmp;
-		}
-		/* while loop will break here if sd == NULL */
 	}
 unlock:
 	rcu_read_unlock();
-- 
1.7.5.1

