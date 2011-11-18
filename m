Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab1KRPS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:18:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:52078 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756772Ab1KRPS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:18:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18p/2VlH3gpUwyJV7v3fBsgC36XdwHXz7E1DIphPt
	+GSgUCBt++N1Oe
Subject: [patch 2/6] sched: convert rq->avg_idle to rq->avg_event
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321629267.7080.13.camel@marge.simson.net>
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
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 16:18:22 +0100
Message-ID: <1321629502.7080.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We update rq->clock only at points of interest to the scheduler.
Using this distance has the same effect as measuring idle time
for idle_balance() throttling, and allows other uses as well.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched.c       |   32 +++++++++++---------------------
 kernel/sched_debug.c |    2 +-
 kernel/sched_fair.c  |    8 ++------
 3 files changed, 14 insertions(+), 28 deletions(-)

Index: linux-3.2.git/kernel/sched.c
===================================================================
--- linux-3.2.git.orig/kernel/sched.c
+++ linux-3.2.git/kernel/sched.c
@@ -656,8 +656,7 @@ struct rq {
 
 	u64 rt_avg;
 	u64 age_stamp;
-	u64 idle_stamp;
-	u64 avg_idle;
+	u64 avg_event;
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -789,6 +788,14 @@ static inline struct task_group *task_gr
 
 #endif /* CONFIG_CGROUP_SCHED */
 
+static void update_avg(u64 *avg, u64 sample)
+{
+#ifdef CONFIG_SMP
+	s64 diff = sample - *avg;
+	*avg += diff >> 3;
+#endif
+}
+
 static void update_rq_clock_task(struct rq *rq, s64 delta);
 
 static void update_rq_clock(struct rq *rq)
@@ -801,6 +808,7 @@ static void update_rq_clock(struct rq *r
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
 	rq->clock += delta;
 	update_rq_clock_task(rq, delta);
+	update_avg(&rq->avg_event, delta);
 }
 
 /*
@@ -2593,12 +2601,6 @@ int select_task_rq(struct task_struct *p
 
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
@@ -2664,17 +2666,6 @@ ttwu_do_wakeup(struct rq *rq, struct tas
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
 
@@ -8294,8 +8285,7 @@ void __init sched_init(void)
 		rq->push_cpu = 0;
 		rq->cpu = i;
 		rq->online = 0;
-		rq->idle_stamp = 0;
-		rq->avg_idle = 2*sysctl_sched_migration_cost;
+		rq->avg_event = 0;
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
 		rq->nohz_balance_kick = 0;
Index: linux-3.2.git/kernel/sched_debug.c
===================================================================
--- linux-3.2.git.orig/kernel/sched_debug.c
+++ linux-3.2.git/kernel/sched_debug.c
@@ -290,7 +290,7 @@ static void print_cpu(struct seq_file *m
 	P(sched_count);
 	P(sched_goidle);
 #ifdef CONFIG_SMP
-	P64(avg_idle);
+	P64(avg_event);
 #endif
 
 	P(ttwu_count);
Index: linux-3.2.git/kernel/sched_fair.c
===================================================================
--- linux-3.2.git.orig/kernel/sched_fair.c
+++ linux-3.2.git/kernel/sched_fair.c
@@ -4190,9 +4190,7 @@ static void idle_balance(int this_cpu, s
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 
-	this_rq->idle_stamp = this_rq->clock;
-
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+	if (this_rq->avg_event < sysctl_sched_migration_cost)
 		return;
 
 	/*
@@ -4218,10 +4216,8 @@ static void idle_balance(int this_cpu, s
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
 


