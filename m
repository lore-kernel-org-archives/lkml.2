Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab1LFJxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:53:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34948 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956Ab1LFJxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:53:43 -0500
Date: Tue, 6 Dec 2011 01:53:28 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-1c792db7f7957e2e34b9a164f08200e36a25dfd0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111202010832.499438999@sbsiddha-desk.sc.intel.com>
References: <20111202010832.499438999@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, nohz: Introduce nohz_flags in 'struct rq'
Git-Commit-ID: 1c792db7f7957e2e34b9a164f08200e36a25dfd0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:53:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c792db7f7957e2e34b9a164f08200e36a25dfd0
Gitweb:     http://git.kernel.org/tip/1c792db7f7957e2e34b9a164f08200e36a25dfd0
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 1 Dec 2011 17:07:32 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 09:06:30 +0100

sched, nohz: Introduce nohz_flags in 'struct rq'

Introduce nohz_flags in the struct rq, which will track these two flags
for now.

NOHZ_TICK_STOPPED keeps track of the tick stopped status that gets set when
the tick is stopped. It will be used to update the nohz idle load balancer data
structures during the first busy tick after the tick is restarted. At this
first busy tick after tickless idle, NOHZ_TICK_STOPPED flag will be reset.
This will minimize the nohz idle load balancer status updates that currently
happen for every tickless exit, making it more scalable when there
are many logical cpu's that enter and exit idle often.

NOHZ_BALANCE_KICK will track the need for nohz idle load balance
on this rq. This will replace the nohz_balance_kick in the rq, which was
not being updated atomically.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20111202010832.499438999@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c  |    5 +++--
 kernel/sched/fair.c  |   48 +++++++++++++++++++++++++++---------------------
 kernel/sched/sched.h |   11 ++++++++++-
 3 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 07f1e99..7f1da77 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -575,7 +575,8 @@ void wake_up_idle_cpu(int cpu)
 
 static inline bool got_nohz_idle_kick(void)
 {
-	return idle_cpu(smp_processor_id()) && this_rq()->nohz_balance_kick;
+	int cpu = smp_processor_id();
+	return idle_cpu(cpu) && test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
 }
 
 #else /* CONFIG_NO_HZ */
@@ -6840,7 +6841,7 @@ void __init sched_init(void)
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
-		rq->nohz_balance_kick = 0;
+		rq->nohz_flags = 0;
 #endif
 #endif
 		init_rq_hrtick(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 81ccb81..50c06b0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4889,18 +4889,15 @@ static void nohz_balancer_kick(int cpu)
 			return;
 	}
 
-	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
-		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
-
-		smp_mb();
-		/*
-		 * Use smp_send_reschedule() instead of resched_cpu().
-		 * This way we generate a sched IPI on the target cpu which
-		 * is idle. And the softirq performing nohz idle load balance
-		 * will be run before returning from the IPI.
-		 */
-		smp_send_reschedule(ilb_cpu);
-	}
+	if (test_and_set_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu)))
+		return;
+	/*
+	 * Use smp_send_reschedule() instead of resched_cpu().
+	 * This way we generate a sched IPI on the target cpu which
+	 * is idle. And the softirq performing nohz idle load balance
+	 * will be run before returning from the IPI.
+	 */
+	smp_send_reschedule(ilb_cpu);
 	return;
 }
 
@@ -4964,6 +4961,8 @@ void select_nohz_load_balancer(int stop_tick)
 			}
 			return;
 		}
+
+		set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 	} else {
 		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
 			return;
@@ -5079,8 +5078,9 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 	struct rq *rq;
 	int balance_cpu;
 
-	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
-		return;
+	if (idle != CPU_IDLE ||
+	    !test_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu)))
+		goto end;
 
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
 		if (balance_cpu == this_cpu)
@@ -5091,10 +5091,8 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		 * work being done for other cpus. Next load
 		 * balancing owner will pick it up.
 		 */
-		if (need_resched()) {
-			this_rq->nohz_balance_kick = 0;
+		if (need_resched())
 			break;
-		}
 
 		raw_spin_lock_irq(&this_rq->lock);
 		update_rq_clock(this_rq);
@@ -5108,7 +5106,8 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 			this_rq->next_balance = rq->next_balance;
 	}
 	nohz.next_balance = this_rq->next_balance;
-	this_rq->nohz_balance_kick = 0;
+end:
+	clear_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu));
 }
 
 /*
@@ -5129,10 +5128,17 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	int ret;
 	int first_pick_cpu, second_pick_cpu;
 
-	if (time_before(now, nohz.next_balance))
+	if (unlikely(idle_cpu(cpu)))
 		return 0;
 
-	if (idle_cpu(cpu))
+       /*
+	* We may be recently in ticked or tickless idle mode. At the first
+	* busy tick after returning from idle, we will update the busy stats.
+	*/
+	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu))))
+		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
+
+	if (time_before(now, nohz.next_balance))
 		return 0;
 
 	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
@@ -5196,7 +5202,7 @@ void trigger_load_balance(struct rq *rq, int cpu)
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ
-	else if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
 		nohz_balancer_kick(cpu);
 #endif
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8715055..cf7d026 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -371,7 +371,7 @@ struct rq {
 	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ
 	u64 nohz_stamp;
-	unsigned char nohz_balance_kick;
+	unsigned long nohz_flags;
 #endif
 	int skip_clock_update;
 
@@ -1064,3 +1064,12 @@ extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
 extern void unthrottle_offline_cfs_rqs(struct rq *rq);
 
 extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
+
+#ifdef CONFIG_NO_HZ
+enum rq_nohz_flag_bits {
+	NOHZ_TICK_STOPPED,
+	NOHZ_BALANCE_KICK,
+};
+
+#define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
+#endif
