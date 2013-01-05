Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3AEIhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:37:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab3AEIhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210066"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH v3 05/22] sched: remove domain iterations in fork/exec/wake
Date: Sat,  5 Jan 2013 16:37:34 +0800
Message-Id: <1357375071-11793-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
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

This patch increases 10+% performance of hackbench on my 4 sockets
NHM and SNB machines.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ecfbf8e..895a3f4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3364,15 +3364,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
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
@@ -3382,18 +3376,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
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
1.7.12

