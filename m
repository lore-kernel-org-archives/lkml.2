Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab2AQCPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:15:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:49915 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab2AQCPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:15:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112986890"
Subject: Re: x86/mce: machine check warning during poweroff
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Date: Mon, 16 Jan 2012 18:21:32 -0800
In-Reply-To: <4F10EB5B.5060804@linux.vnet.ibm.com>
References: <20120111000051.GA28874@dztty>
	 <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
	 <4F10929E.8070007@linux.vnet.ibm.com>
	 <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
	 <4F10BDF7.8030306@linux.vnet.ibm.com>
	 <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
	 <4F10EB5B.5060804@linux.vnet.ibm.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326766892.16150.21.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-14 at 08:11 +0530, Srivatsa S. Bhat wrote:
> Of course, the warnings at drivers/base/core.c: device_release()
> as well as the IPI to offline cpu warnings still appear but are rather
> unrelated and harmless to the issue being discussed.

As far the IPI offline cpu warnings are concerned, appended patch should
fix it. Can you please give it a try? Peterz, can you please review and
queue it after Srivatsa confirms that it works? Thanks.
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
 kernel/sched/fair.c |   40 +++++++++++++++++++++++++++++++++++-----
 1 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8e42de9..defc92d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4862,6 +4862,15 @@ static void nohz_balancer_kick(int cpu)
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
@@ -4900,6 +4909,12 @@ void select_nohz_load_balancer(int stop_tick)
 {
 	int cpu = smp_processor_id();
 
+	/*
+ 	 * If this cpu is going down, then nothing needs to be done.
+ 	 */
+	if (!cpu_active(cpu))
+		return;
+
 	if (stop_tick) {
 		if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
 			return;
@@ -4910,6 +4925,24 @@ void select_nohz_load_balancer(int stop_tick)
 	}
 	return;
 }
+
+static void __cpuinit __sched_ilb_notifier(void *info)
+{
+	clear_nohz_tick_stopped(smp_processor_id());
+}
+
+static int __cpuinit sched_ilb_notifier(struct notifier_block *nfb,
+					unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DOWN_PREPARE:
+		smp_call_function_single((unsigned long) hcpu,
+					 __sched_ilb_notifier, NULL, 1);
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
 #endif
 
 static DEFINE_SPINLOCK(balancing);
@@ -5066,11 +5099,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
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
@@ -5586,6 +5615,7 @@ __init void init_sched_fair_class(void)
 
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
+	cpu_notifier(sched_ilb_notifier, 0);
 #endif
 #endif /* SMP */
 


