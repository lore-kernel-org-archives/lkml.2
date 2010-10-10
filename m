Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0JJKPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 06:15:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53516 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754279Ab0JJKPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 06:15:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ndHZBErinNPhmBYcVXq/FjnlMdwM7iSIpi05BKY
	Eng4jlQgVgtTFD
Subject: Re: [PATCH 0/3][RFC] Improve load balancing when tasks have large
 weight differential
From: Mike Galbraith <efault@gmx.de>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTim8m6r_8pFO6o0uOnki6mNoaR+8NZ4M0pO3H515@mail.gmail.com>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
	 <1285682273.7469.3.camel@marge.simson.net>
	 <AANLkTin=Dic2UE55yUaam8NzGHTib=9s=x-wyzk03BU0@mail.gmail.com>
	 <1285724758.7440.11.camel@marge.simson.net>
	 <AANLkTi=TQnYGLPC=Pi0o1As83W6VdWdjvimZNSrGT4qW@mail.gmail.com>
	 <1286161717.7410.12.camel@marge.simson.net>
	 <AANLkTinf7fj5A4DnQOWdj8QeMhf4exPGgpMUdTGA9mTC@mail.gmail.com>
	 <1286522543.8189.13.camel@marge.simson.net>
	 <AANLkTim8m6r_8pFO6o0uOnki6mNoaR+8NZ4M0pO3H515@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 10 Oct 2010 12:15:34 +0200
Message-Id: <1286705734.7478.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 13:34 -0700, Nikhil Rao wrote:

> I have attached a patch that tackles the problem in different way.
> Instead of preventing the sched group from entering the bad state, it
> shortcuts the checks in fbg if the group has extra capacity, where
> extra capacity is defined as group_capacity > nr_running. The patch
> exposes a sched feature called PREFER_UTILIZATION (disabled by
> default). When this is enabled, f_b_g shortcuts the checks if the
> local group has capacity. This actually works quite well.

Yeah, it does seem to work well.

I don't like the sched feature much though, a domain flag seems more
appropriate.  I bent your patch up a bit to correct utilization woes
during NEWIDLE balancing instead.. still seems to work fine.

---
 kernel/sched_fair.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

Index: linux-2.6.36.git/kernel/sched_fair.c
===================================================================
--- linux-2.6.36.git.orig/kernel/sched_fair.c
+++ linux-2.6.36.git/kernel/sched_fair.c
@@ -1764,6 +1764,10 @@ static void pull_task(struct rq *src_rq,
 	set_task_cpu(p, this_cpu);
 	activate_task(this_rq, p, 0);
 	check_preempt_curr(this_rq, p, 0);
+
+	/* re-arm NEWIDLE balancing when moving tasks */
+	src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
+	this_rq->idle_stamp = 0;
 }
 
 /*
@@ -2030,12 +2034,14 @@ struct sd_lb_stats {
 	unsigned long this_load;
 	unsigned long this_load_per_task;
 	unsigned long this_nr_running;
+	unsigned long this_has_capacity;
 
 	/* Statistics of the busiest group */
 	unsigned long max_load;
 	unsigned long busiest_load_per_task;
 	unsigned long busiest_nr_running;
 	unsigned long busiest_group_capacity;
+	unsigned long busiest_has_capacity;
 
 	int group_imb; /* Is there imbalance in this sd */
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -2058,6 +2064,7 @@ struct sg_lb_stats {
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long group_capacity;
 	int group_imb; /* Is there an imbalance in the group ? */
+	int group_has_capacity; /* Is there extra capacity in the group? */
 };
 
 /**
@@ -2454,6 +2461,9 @@ static inline void update_sg_lb_stats(st
 		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(sd, group);
+
+	if (sgs->group_capacity > sgs->sum_nr_running)
+		sgs->group_has_capacity = 1;
 }
 
 /**
@@ -2552,12 +2562,14 @@ static inline void update_sd_lb_stats(st
 			sds->this = sg;
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
+			sds->this_has_capacity = sgs.group_has_capacity;
 		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = sg;
 			sds->busiest_nr_running = sgs.sum_nr_running;
 			sds->busiest_group_capacity = sgs.group_capacity;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
+			sds->busiest_has_capacity = sgs.group_has_capacity;
 			sds->group_imb = sgs.group_imb;
 		}
 
@@ -2754,6 +2766,15 @@ static inline void calculate_imbalance(s
 		return fix_small_imbalance(sds, this_cpu, imbalance);
 
 }
+
+bool check_utilization(struct sd_lb_stats *sds)
+{
+	if (!sds->this_has_capacity || sds->busiest_has_capacity)
+		return false;
+
+	return true;
+}
+
 /******* find_busiest_group() helpers end here *********************/
 
 /**
@@ -2816,6 +2837,10 @@ find_busiest_group(struct sched_domain *
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
+	/*  SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
+	if (idle == CPU_NEWLY_IDLE && check_utilization(&sds))
+		goto force_balance;
+
 	if (sds.this_load >= sds.max_load)
 		goto out_balanced;
 
@@ -2827,6 +2852,7 @@ find_busiest_group(struct sched_domain *
 	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
 		goto out_balanced;
 
+force_balance:
 	/* Looks like there is an imbalance. Compute it */
 	calculate_imbalance(&sds, this_cpu, imbalance);
 	return sds.busiest;
@@ -3153,10 +3179,8 @@ static void idle_balance(int this_cpu, s
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
-			this_rq->idle_stamp = 0;
+		if (pulled_task)
 			break;
-		}
 	}
 
 	raw_spin_lock(&this_rq->lock);


