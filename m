Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2ARWJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:09:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:42677 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab2ARWJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:09:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97303299"
Subject: Re: x86/mce: machine check warning during poweroff
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
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
In-Reply-To: <20120118133236.GA3878@swordfish.minsk.epam.com>
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
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Wed, 18 Jan 2012 14:08:29 -0800
Message-ID: <1326924509.13915.29.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 16:32 +0300, Sergey Senozhatsky wrote:
> Just a small note, since you're talking about removing CPU from nohz.idle_cpus_mask, 
> that I'm able to reproduce this problem not only when offlining CPU, but during
> onlininig as well (kernel 3.3):

yes, if the nohz state is not cleared properly during offline, then the
issue can happen any time including cpu online etc.

Srivatsa, I thought CPU_PRI_SCHED_INACTIVE as INT_MAX for some reason
and was expecting sched_ilb_notifier() will be called after setting that
cpu as inactive. I am now using CPU_DYING which will be called from the
cpu going down.

Here is the v2 version of the fix. Can you folks please give it another
try?

Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: sched, nohz: fix nohz cpu idle load balancing state with cpu hotplug

With the recent nohz scheduler changes, rq's nohz flag 'NOHZ_TICK_STOPPED'
and its associated state doesn't get cleared immediately after the
cpu exits idle. This gets cleared as part of the next tick seen on that cpu.

With the cpu offline, we need to clear this state manually. Fix it by
registering a cpu notifier which clears the nohz idle load balance
state for this rq explicitly.

Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched/fair.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2237ffe..f605e1d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4843,6 +4843,15 @@ static void nohz_balancer_kick(int cpu)
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
@@ -4881,6 +4890,12 @@ void select_nohz_load_balancer(int stop_tick)
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
@@ -4891,6 +4906,18 @@ void select_nohz_load_balancer(int stop_tick)
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
@@ -5047,11 +5074,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
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
@@ -5549,6 +5572,7 @@ __init void init_sched_fair_class(void)
 
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
+	cpu_notifier(sched_ilb_notifier, 0);
 #endif
 #endif /* SMP */
 


