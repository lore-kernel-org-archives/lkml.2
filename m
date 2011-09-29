Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1I2Aqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 20:46:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:30904 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab1I2Aqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 20:46:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,458,1312182000"; 
   d="scan'208";a="56772017"
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Venki Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Sep 2011 17:47:43 -0700
In-Reply-To: <20110928041501.GH4357@linux.vnet.ibm.com>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
	 <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
	 <1317167376.11592.53.camel@sbsiddha-desk.sc.intel.com>
	 <20110928041501.GH4357@linux.vnet.ibm.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317257264.11592.76.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 21:15 -0700, Srivatsa Vaddagiri wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> [2011-09-27 16:49:36]:
> 
> > I will post this patch mostly tomorrow. That patch will not use the
> > idle_at_tick check in the nohz_idle_balance(). So that should address
> > your issue in some cases if not most.
> 
> Ok ..would be glad to test your change ..

Vatsa, Here is the promised patch. I haven't completely made up my mind
about this patch.  Specially the change that I am doing now in
scheduler_ipi().

Initially I was planning to use resched_cpu() to trigger the
nohz_idle_balance() as part of the idle_balance(). But preemption is
disabled  during idle_balance() and I don't want to do more work in
idle_balance. Thomas/PeterZ may not like that. And also the idle cpu
would have done tick_nohz_restart_sched_tick() unnecessarily etc.

So ended up with using kick_process() and the scheduler_ipi() context to
trigger the SCHED_SOFTIRQ instead of using smp call function vector
sequence (which has a deadlock scenario in the context of heavy
interrupts which I can explain in detail when I send the complete
changelog). And also I am explicitly requesting for idle balance to
address the stale idle_at_tick condition.

Anyways, this appended patch is just for your quick experiment. I will
think a bit more tomorrow morning before sending the patch with complete
changelog. Thanks.
---

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched.c      |   10 +++++++---
 kernel/sched_fair.c |   25 +++----------------------
 2 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c5cf15e..482b9d2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -644,7 +644,7 @@ struct rq {
 
 	unsigned long cpu_power;
 
-	unsigned char idle_at_tick;
+	unsigned char idle_balance;
 	/* For active balancing */
 	int post_schedule;
 	int active_balance;
@@ -2733,6 +2733,11 @@ void scheduler_ipi(void)
 	struct rq *rq = this_rq();
 	struct task_struct *list = xchg(&rq->wake_list, NULL);
 
+	if (unlikely((rq->idle == current) && rq->nohz_balance_kick)) {
+		rq->idle_balance = 1;
+		raise_softirq_irqoff(SCHED_SOFTIRQ);
+	}
+
 	if (!list)
 		return;
 
@@ -4257,7 +4262,7 @@ void scheduler_tick(void)
 	perf_event_task_tick();
 
 #ifdef CONFIG_SMP
-	rq->idle_at_tick = idle_cpu(cpu);
+	rq->idle_balance = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);
 #endif
 }
@@ -8303,7 +8308,6 @@ void __init sched_init(void)
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
 		rq->nohz_balance_kick = 0;
-		init_sched_softirq_csd(&per_cpu(remote_sched_softirq_cb, i));
 #endif
 #endif
 		init_rq_hrtick(rq);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fef0bfd..bcefcb8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -4269,22 +4269,6 @@ out_unlock:
 }
 
 #ifdef CONFIG_NO_HZ
-
-static DEFINE_PER_CPU(struct call_single_data, remote_sched_softirq_cb);
-
-static void trigger_sched_softirq(void *data)
-{
-	raise_softirq_irqoff(SCHED_SOFTIRQ);
-}
-
-static inline void init_sched_softirq_csd(struct call_single_data *csd)
-{
-	csd->func = trigger_sched_softirq;
-	csd->info = NULL;
-	csd->flags = 0;
-	csd->priv = 0;
-}
-
 /*
  * idle load balancing details
  * - One of the idle CPUs nominates itself as idle load_balancer, while
@@ -4450,11 +4434,8 @@ static void nohz_balancer_kick(int cpu)
 	}
 
 	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
-		struct call_single_data *cp;
-
 		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
-		cp = &per_cpu(remote_sched_softirq_cb, cpu);
-		__smp_call_function_single(ilb_cpu, cp, 0);
+		kick_process(idle_task(ilb_cpu));
 	}
 	return;
 }
@@ -4687,7 +4668,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	if (time_before(now, nohz.next_balance))
 		return 0;
 
-	if (rq->idle_at_tick)
+	if (idle_cpu(cpu))
 		return 0;
 
 	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
@@ -4723,7 +4704,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 {
 	int this_cpu = smp_processor_id();
 	struct rq *this_rq = cpu_rq(this_cpu);
-	enum cpu_idle_type idle = this_rq->idle_at_tick ?
+	enum cpu_idle_type idle = this_rq->idle_balance ?
 						CPU_IDLE : CPU_NOT_IDLE;
 
 	rebalance_domains(this_cpu, idle);


