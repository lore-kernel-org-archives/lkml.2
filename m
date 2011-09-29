Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab1I2WgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:36:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:37914 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744Ab1I2WgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:36:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,464,1312182000"; 
   d="scan'208";a="72332500"
Message-Id: <20110929223242.896899319@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 29 Sep 2011 15:30:25 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/2] sched: request for idle balance during nohz idle load balance
References: <20110929223242.837017656@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=request_idle_balance.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq's idle_at_tick is set to idle/busy during the timer tick
depending on the cpu was idle or not. This will be used later in the load
balance that will be done in the softirq context (which is a process
context in -RT kernels).

For nohz kernels, for the cpu doing nohz idle load balance on behalf of
all the idle cpu's, its rq->idle_at_tick might have a stale value (which is
recorded when it got the timer tick presumably when it is busy).

As the nohz idle load balancing is also being done at the same place
as the regular load balancing, nohz idle load balancing was bailing out
when it sees rq's idle_at_tick not set.

Thus leading to poor system utilization.

Rename rq's idle_at_tick to idle_balance and set it when someone requests
for nohz idle balance on an idle cpu.

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched.c      |    8 +++++---
 kernel/sched_fair.c |    4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -644,7 +644,7 @@ struct rq {
 
 	unsigned long cpu_power;
 
-	unsigned char idle_at_tick;
+	unsigned char idle_balance;
 	/* For active balancing */
 	int post_schedule;
 	int active_balance;
@@ -2758,8 +2758,10 @@ void scheduler_ipi(void)
  	 * Check if someone kicked us for doing the nohz idle load balance.
  	 */
 	if (unlikely((rq->idle == current) && rq->nohz_balance_kick &&
-		     !need_resched()))
+		     !need_resched())) {
+		rq->idle_balance = 1;
 		raise_softirq_irqoff(SCHED_SOFTIRQ);
+	}
 	irq_exit();
 }
 
@@ -4266,7 +4268,7 @@ void scheduler_tick(void)
 	perf_event_task_tick();
 
 #ifdef CONFIG_SMP
-	rq->idle_at_tick = idle_cpu(cpu);
+	rq->idle_balance = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);
 #endif
 }
Index: linux-2.6-tip/kernel/sched_fair.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_fair.c
+++ linux-2.6-tip/kernel/sched_fair.c
@@ -4674,7 +4674,7 @@ static inline int nohz_kick_needed(struc
 	if (time_before(now, nohz.next_balance))
 		return 0;
 
-	if (rq->idle_at_tick)
+	if (idle_cpu(cpu))
 		return 0;
 
 	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
@@ -4710,7 +4710,7 @@ static void run_rebalance_domains(struct
 {
 	int this_cpu = smp_processor_id();
 	struct rq *this_rq = cpu_rq(this_cpu);
-	enum cpu_idle_type idle = this_rq->idle_at_tick ?
+	enum cpu_idle_type idle = this_rq->idle_balance ?
 						CPU_IDLE : CPU_NOT_IDLE;
 
 	rebalance_domains(this_cpu, idle);


