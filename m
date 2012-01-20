Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab2ATCWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 21:22:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:8737 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab2ATCWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 21:22:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="98539069"
Subject: Re: x86/mce: machine check warning during poweroff
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Date: Thu, 19 Jan 2012 18:28:57 -0800
In-Reply-To: <4F18066D.9050102@linux.vnet.ibm.com>
References: <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
	 <4F10929E.8070007@linux.vnet.ibm.com>
	 <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
	 <4F10BDF7.8030306@linux.vnet.ibm.com>
	 <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
	 <4F10EB5B.5060804@linux.vnet.ibm.com>
	 <1326766892.16150.21.camel@sbsiddha-desk.sc.intel.com>
	 <4F1544EA.5060907@linux.vnet.ibm.com>
	 <1326856624.5291.20.camel@sbsiddha-mobl2>
	 <4F16C60B.4030903@linux.vnet.ibm.com>
	 <20120118133236.GA3878@swordfish.minsk.epam.com>
	 <1326924509.13915.29.camel@sbsiddha-mobl2>
	 <4F18066D.9050102@linux.vnet.ibm.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1327026538.16150.40.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-19 at 17:32 +0530, Srivatsa S. Bhat wrote:
> Suresh, your patch works perfectly! Thanks a lot!
> Tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> And the reasoning behind the patch matches the test results:
> we don't allow select_nohz_load_balancer() to undo the cleanup that we
> did in sched_ilb_notifier(), by ensuring that sched_ilb_notifier() runs
> *after* sched_cpu_inactive().
> 
> So, you can have my "Reviewed-by" too, if you like!
> 
> By the way, it would be great if you could kindly describe the above
> mentioned subtle aspect in the patch description as well..

Thanks Srivatsa and Sergey for the tests.

Ingo, Peterz, can you please queue this appended patch for 3.3?

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: sched, nohz: fix nohz cpu idle load balancing state with cpu hotplug

With the recent nohz scheduler changes, rq's nohz flag 'NOHZ_TICK_STOPPED'
and its associated state doesn't get cleared immediately after the
cpu exits idle. This gets cleared as part of the next tick seen on that cpu.

For the cpu offline support, we need to clear this state manually. Fix it by
registering a cpu notifier, which clears the nohz idle load balance
state for this rq explicitly during the CPU_DYING notification.

There won't be any nohz updates for that cpu, after the CPU_DYING notification.
But lets be extra paranoid and skip updating the nohz state in the
select_nohz_load_balancer() if the cpu is not in active state anymore.

Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Reviewed-and-tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched/fair.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 84adb2d..7c6414f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4866,6 +4866,15 @@ static void nohz_balancer_kick(int cpu)
 	return;
 }
 
+static inline void clear_nohz_tick_stopped(int cpu)
+{
+	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
+		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
+		atomic_dec(&nohz.nr_cpus);
+		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
+	}
+}
+
 static inline void set_cpu_sd_state_busy(void)
 {
 	struct sched_domain *sd;
@@ -4904,6 +4913,12 @@ void select_nohz_load_balancer(int stop_tick)
 {
 	int cpu = smp_processor_id();
 
+	/*
+	 * If this cpu is going down, then nothing needs to be done.
+	 */
+	if (!cpu_active(cpu))
+		return;
+
 	if (stop_tick) {
 		if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
 			return;
@@ -4914,6 +4929,18 @@ void select_nohz_load_balancer(int stop_tick)
 	}
 	return;
 }
+
+static int __cpuinit sched_ilb_notifier(struct notifier_block *nfb,
+					unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DYING:
+		clear_nohz_tick_stopped(smp_processor_id());
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
 #endif
 
 static DEFINE_SPINLOCK(balancing);
@@ -5070,11 +5097,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	* busy tick after returning from idle, we will update the busy stats.
 	*/
 	set_cpu_sd_state_busy();
-	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
-		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
-		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
-		atomic_dec(&nohz.nr_cpus);
-	}
+	clear_nohz_tick_stopped(cpu);
 
 	/*
 	 * None are in tickless mode and hence no need for NOHZ idle load
@@ -5590,6 +5613,7 @@ __init void init_sched_fair_class(void)
 
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
+	cpu_notifier(sched_ilb_notifier, 0);
 #endif
 #endif /* SMP */
 


