Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2AZU1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 15:27:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab2AZU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 15:27:41 -0500
Date: Thu, 26 Jan 2012 12:27:09 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-71325960d16cd68ea0e22a8da15b2495b0f363f7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, sergey.senozhatsky@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sergey.senozhatsky@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1327026538.16150.40.camel@sbsiddha-desk.sc.intel.com>
References: <1327026538.16150.40.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/nohz:
  Fix nohz cpu idle load balancing state with cpu hotplug
Git-Commit-ID: 71325960d16cd68ea0e22a8da15b2495b0f363f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 12:27:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71325960d16cd68ea0e22a8da15b2495b0f363f7
Gitweb:     http://git.kernel.org/tip/71325960d16cd68ea0e22a8da15b2495b0f363f7
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 19 Jan 2012 18:28:57 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 19:38:13 +0100

sched/nohz: Fix nohz cpu idle load balancing state with cpu hotplug

With the recent nohz scheduler changes, rq's nohz flag
'NOHZ_TICK_STOPPED' and its associated state doesn't get cleared
immediately after the cpu exits idle. This gets cleared as part
of the next tick seen on that cpu.

For the cpu offline support, we need to clear this state
manually. Fix it by registering a cpu notifier, which clears the
nohz idle load balance state for this rq explicitly during the
CPU_DYING notification.

There won't be any nohz updates for that cpu, after the
CPU_DYING notification. But lets be extra paranoid and skip
updating the nohz state in the select_nohz_load_balancer() if
the cpu is not in active state anymore.

Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Reviewed-and-tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1327026538.16150.40.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
