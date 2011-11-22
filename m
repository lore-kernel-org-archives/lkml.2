Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab1KVO3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:29:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab1KVO3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:29:18 -0500
Subject: [patch 4/7] sched: convert rq->avg_idle to rq->avg_event
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321971445.6855.14.camel@marge.simson.net>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1321629441.7080.15.camel@marge.simson.net>
	 <1321630552.2197.15.camel@twins>
	 <1321971445.6855.14.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 15:22:31 +0100
Message-ID: <1321971751.6855.19.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We update rq->clock only at points of interest to the scheduler.
Using this distance has the same effect as measuring idle time
for idle_balance() throttling, and allows other uses as well.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched/core.c  |   29 ++++++++++-------------------
 kernel/sched/debug.c |    2 +-
 kernel/sched/fair.c  |    8 ++------
 kernel/sched/sched.h |    3 +--
 4 files changed, 14 insertions(+), 28 deletions(-)

Index: linux-3.0-tip/kernel/sched/core.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched/core.c
+++ linux-3.0-tip/kernel/sched/core.c
@@ -107,6 +107,14 @@ void start_bandwidth_timer(struct hrtime
 DEFINE_MUTEX(sched_domains_mutex);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
+static void update_avg(u64 *avg, u64 sample)
+{
+#ifdef CONFIG_SMP
+	s64 diff = sample - *avg;
+	*avg += diff >> 3;
+#endif
+}
+
 static void update_rq_clock_task(struct rq *rq, s64 delta);
 
 void update_rq_clock(struct rq *rq)
@@ -119,6 +127,7 @@ void update_rq_clock(struct rq *rq)
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
 	rq->clock += delta;
 	update_rq_clock_task(rq, delta);
+	update_avg(&rq->avg_event, delta);
 }
 
 /*
@@ -1287,12 +1296,6 @@ int select_task_rq(struct task_struct *p
 
 	return cpu;
 }
-
-static void update_avg(u64 *avg, u64 sample)
-{
-	s64 diff = sample - *avg;
-	*avg += diff >> 3;
-}
 #endif
 
 static void
@@ -1358,17 +1361,6 @@ ttwu_do_wakeup(struct rq *rq, struct tas
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
-
-	if (rq->idle_stamp) {
-		u64 delta = rq->clock - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
-
-		if (delta > max)
-			rq->avg_idle = max;
-		else
-			update_avg(&rq->avg_idle, delta);
-		rq->idle_stamp = 0;
-	}
 #endif
 }
 
@@ -6835,8 +6827,7 @@ void __init sched_init(void)
 		rq->push_cpu = 0;
 		rq->cpu = i;
 		rq->online = 0;
-		rq->idle_stamp = 0;
-		rq->avg_idle = 2*sysctl_sched_migration_cost;
+		rq->avg_event = 0;
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
 		rq->nohz_balance_kick = 0;
Index: linux-3.0-tip/kernel/sched/debug.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched/debug.c
+++ linux-3.0-tip/kernel/sched/debug.c
@@ -292,7 +292,7 @@ static void print_cpu(struct seq_file *m
 	P(sched_count);
 	P(sched_goidle);
 #ifdef CONFIG_SMP
-	P64(avg_idle);
+	P64(avg_event);
 #endif
 
 	P(ttwu_count);
Index: linux-3.0-tip/kernel/sched/fair.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched/fair.c
+++ linux-3.0-tip/kernel/sched/fair.c
@@ -4605,9 +4605,7 @@ void idle_balance(int this_cpu, struct r
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 
-	this_rq->idle_stamp = this_rq->clock;
-
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+	if (this_rq->avg_event < sysctl_sched_migration_cost)
 		return;
 
 	/*
@@ -4633,10 +4631,8 @@ void idle_balance(int this_cpu, struct r
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
-			this_rq->idle_stamp = 0;
+		if (pulled_task)
 			break;
-		}
 	}
 	rcu_read_unlock();
 
Index: linux-3.0-tip/kernel/sched/sched.h
===================================================================
--- linux-3.0-tip.orig/kernel/sched/sched.h
+++ linux-3.0-tip/kernel/sched/sched.h
@@ -426,8 +426,7 @@ struct rq {
 
 	u64 rt_avg;
 	u64 age_stamp;
-	u64 idle_stamp;
-	u64 avg_idle;
+	u64 avg_event;
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING


