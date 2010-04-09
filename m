Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0DIGVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:21:22 -0400
Received: from ozlabs.org ([203.10.76.45]:46431 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab0DIGVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:21:20 -0400
To: Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Michael Neuling <mikey@neuling.org>
Date: Fri, 09 Apr 2010 16:21:18 +1000
Subject: [PATCH 1/5] sched: fix capacity calculations for SMT4
In-Reply-To: <1270794078.794237.347827867455.qpush@pale>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Message-Id: <20100409062118.D4096CBB6C@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calculating capacity we use the following calculation:

       capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);

In SMT2, power will be 1178/2 (provided we are not scaling power with
freq say) and SCHED_LOAD_SCALE will be 1024, resulting in capacity
being 1.

With SMT4 however, power will be 1178/4, hence capacity will end up as
0.

Fix this by ensuring capacity is always at least 1 after this
calculation.

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
I'm not sure this is the correct fix but this works for me.  
Original post here: 
  http://lkml.org/lkml/2010/3/30/884

---

 kernel/sched_fair.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6-ozlabs/kernel/sched_fair.c
===================================================================
--- linux-2.6-ozlabs.orig/kernel/sched_fair.c
+++ linux-2.6-ozlabs/kernel/sched_fair.c
@@ -1482,6 +1482,7 @@ static int select_task_rq_fair(struct ta
 			}
 
 			capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
+			capacity = max(capacity, 1UL);
 
 			if (tmp->flags & SD_POWERSAVINGS_BALANCE)
 				nr_running /= 2;
@@ -2488,6 +2489,7 @@ static inline void update_sg_lb_stats(st
 
 	sgs->group_capacity =
 		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	sgs->group_capacity = max(sgs->group_capacity, 1UL);
 }
 
 /**
@@ -2795,9 +2797,11 @@ find_busiest_queue(struct sched_group *g
 
 	for_each_cpu(i, sched_group_cpus(group)) {
 		unsigned long power = power_of(i);
-		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
+		unsigned long capacity;
 		unsigned long wl;
 
+		capacity = max(DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE), 1UL);
+
 		if (!cpumask_test_cpu(i, cpus))
 			continue;
 
