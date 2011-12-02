Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab1LBBMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:12:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:55150 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab1LBBKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:10:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,281,1320652800"; 
   d="scan'208";a="43122732"
Message-Id: <20111202010832.714874234@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 01 Dec 2011 17:07:36 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch v3 5/6] sched, ttwu_queue: queue remote wakeups only when crossing cache domains
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=use_ttwu_queue_when_crossing_cache_domains.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

Context-switch intensive microbenchmark on a 8-socket system had
~600K times more resched IPI's on each logical CPU because of the
TTWU_QUEUE sched feature, which queues the task on the remote cpu's
queue and completes the wakeup locally using an IPI.

As the TTWU_QUEUE sched feature is for minimizing the cache-misses
associated with the remote wakeups, use the IPI only when the local and
the remote cpu's are from different cache domains. Otherwise use the
traditional remote wakeup.

With this, context-switch microbenchmark performed 5 times better on the
8-socket NHM-EX system.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched/core.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

Index: tip/kernel/sched/core.c
===================================================================
--- tip.orig/kernel/sched/core.c
+++ tip/kernel/sched/core.c
@@ -1481,12 +1481,35 @@ static int ttwu_activate_remote(struct t
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 #endif /* CONFIG_SMP */
 
+static int ttwu_share_cache(int this_cpu, int cpu)
+{
+#ifndef CONFIG_X86
+	struct sched_domain *sd;
+	int ret = 0;
+
+	rcu_read_lock();
+	for_each_domain(this_cpu, sd) {
+		if (!cpumask_test_cpu(cpu, sched_domain_span(sd)))
+			continue;
+
+		ret = (sd->flags & SD_SHARE_PKG_RESOURCES);
+		break;
+	}
+	rcu_read_unlock();
+
+	return ret;
+#else
+	return per_cpu(cpu_llc_id, this_cpu) == per_cpu(cpu_llc_id, cpu);
+#endif
+}
+
 static void ttwu_queue(struct task_struct *p, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 
 #if defined(CONFIG_SMP)
-	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+	if (sched_feat(TTWU_QUEUE) &&
+	    !ttwu_share_cache(smp_processor_id(), cpu)) {
 		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;


