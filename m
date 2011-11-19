Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab1KSEl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:41:29 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:45827 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758200Ab1KSEl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:41:26 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Ir29D47hIw7BoiarSCAybBMzU1FrwPwz9LaEhKH
	q1uGCHynmmD3qY
Subject: Re: [patch 5/6] sched: disable sched feature TTWU_QUEUE by default
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com
In-Reply-To: <1321677009.6307.13.camel@marge.simson.net>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230554.105376150@sbsiddha-desk.sc.intel.com>
	 <1321677009.6307.13.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Nov 2011 05:41:20 +0100
Message-ID: <1321677680.6307.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-19 at 05:30 +0100, Mike Galbraith wrote:
> On Fri, 2011-11-18 at 15:03 -0800, Suresh Siddha wrote:
> > plain text document attachment (disable_sched_ttwu_queue.patch)
> > Context-switch intensive microbenchmark on a 8-socket system had
> > ~600K times more resched IPI's on each logical CPU with this feature enabled
> > by default. Disabling this features makes that microbenchmark perform 5 times
> > better.
> > 
> > Also disabling this feature showed 2% performance improvement on a 8-socket
> > OLTP workload.
> > 
> > More heurestics are needed when and how to use this feature by default.
> > For now, disable it by default.
> 
> Yeah, the overhead for very hefty switchers is high enough to increase
> TCP_RR latency up to 13% in my testing.  I used a trylock() to generally
> not eat that, but leave the contended case improvement intact.
> 
> Peter suggested trying doing the IPI only when crossing cache
> boundaries, which worked for me as well.

On a related TTWU_QUEUE note, I was pondering idle_balance().
 
---
 kernel/sched_fair.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Index: linux-3.0/kernel/sched_fair.c
===================================================================
--- linux-3.0.orig/kernel/sched_fair.c
+++ linux-3.0/kernel/sched_fair.c
@@ -3500,8 +3500,7 @@ out:
 static void idle_balance(int this_cpu, struct rq *this_rq)
 {
 	struct sched_domain *sd;
-	int pulled_task = 0;
-	unsigned long next_balance = jiffies + HZ;
+	unsigned long next_balance;
 
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
@@ -3512,33 +3511,41 @@ static void idle_balance(int this_cpu, s
 	raw_spin_unlock(&this_rq->lock);
 
 	update_shares(this_cpu);
+	next_balance = jiffies + HZ;
 	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;
 
+		if (this_rq->nr_running || this_rq->wake_list)
+			break;
+
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
-		if (sd->flags & SD_BALANCE_NEWIDLE) {
-			/* If we've pulled tasks over stop searching: */
-			pulled_task = load_balance(this_cpu, this_rq,
-						   sd, CPU_NEWLY_IDLE, &balance);
-		}
+		if (!(sd->flags & SD_BALANCE_NEWIDLE))
+			continue;
+
+		load_balance(this_cpu, this_rq, sd, CPU_NEWLY_IDLE, &balance);
 
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
+		if (this_rq->nr_running || this_rq->wake_list) {
 			this_rq->idle_stamp = 0;
 			break;
 		}
 	}
 	rcu_read_unlock();
 
+	/* IPI in flighht?  Let the it happen */
+	if (unlikely(this_rq->wake_list)) {
+		local_irq_enable();
+		local_irq_disable();
+	}
 	raw_spin_lock(&this_rq->lock);
 
-	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
+	if (this_rq->nr_running || time_after(jiffies, this_rq->next_balance)) {
 		/*
 		 * We are going idle. next_balance may be set based on
 		 * a busy processor. So reset next_balance.



