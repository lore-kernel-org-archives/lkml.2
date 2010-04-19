Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0DSSwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:52:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab0DSSwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:52:20 -0400
Subject: Re: [REGRESSION 2.6.30][PATCH v3] sched: update load count only
 once per cpu in 10 tick update window
From: Peter Zijlstra <peterz@infradead.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
In-Reply-To: <1271200751-18697-1-git-send-email-chase.douglas@canonical.com>
References: <1271200751-18697-1-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 20:52:10 +0200
Message-ID: <1271703130.1676.214.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 16:19 -0700, Chase Douglas wrote:
> There's a period of 10 ticks where calc_load_tasks is updated by all the
> cpus for the load avg. Usually all the cpus do this during the first
> tick. If any cpus go idle, calc_load_tasks is decremented accordingly.
> However, if they wake up calc_load_tasks is not incremented. Thus, if
> cpus go idle during the 10 tick period, calc_load_tasks may be
> decremented to a non-representative value. This issue can lead to
> systems having a load avg of exactly 0, even though the real load avg
> could theoretically be up to NR_CPUS.
> 
> This change defers calc_load_tasks accounting after each cpu updates the
> count until after the 10 tick update window.
> 
> A few points:
> 
> * A global atomic deferral counter, and not per-cpu vars, is needed
>   because a cpu may go NOHZ idle and not be able to update the global
>   calc_load_tasks variable for subsequent load calculations.
> * It is not enough to add calls to account for the load when a cpu is
>   awakened:
>   - Load avg calculation must be independent of cpu load.
>   - If a cpu is awakend by one tasks, but then has more scheduled before
>     the end of the update window, only the first task will be accounted.

OK, so what you're saying is that because we update calc_load_tasks from
entering idle, we decrease earlier than a regular 10 tick sample
interval would?

Hence you batch these early updates into _deferred and let the next 10
tick sample roll them over?

So the only early updates can come from
pick_next_task_idle()->calc_load_account_active(), so why not specialize
that callchain instead of the below?

Also, since its all NO_HZ, why not stick this in with the ILB? Once
people get around to making that scale better, this can hitch a ride.

Something like the below perhaps? It does run partially from softirq
context, but since there's a distinct lack of synchronization here that
didn't seem like an immediate problem.

---
 kernel/sched.c          |   10 ++++++----
 kernel/sched_fair.c     |    4 +++-
 kernel/sched_idletask.c |    2 --
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 95eaecc..cdd4d8c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2959,6 +2959,11 @@ static void calc_load_account_active(struct rq *this_rq)
 {
 	long nr_active, delta;
 
+	if (!time_after_eq(jiffies, this_rq->calc_load_update))
+		return;
+
+	this_rq->calc_load_update += LOAD_FREQ;
+
 	nr_active = this_rq->nr_running;
 	nr_active += (long) this_rq->nr_uninterruptible;
 
@@ -2998,10 +3003,7 @@ static void update_cpu_load(struct rq *this_rq)
 		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
 	}
 
-	if (time_after_eq(jiffies, this_rq->calc_load_update)) {
-		this_rq->calc_load_update += LOAD_FREQ;
-		calc_load_account_active(this_rq);
-	}
+	calc_load_account_active(this_rq);
 }
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 88d3053..2c267ef 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3394,9 +3394,11 @@ static void run_rebalance_domains(struct softirq_action *h)
 			if (need_resched())
 				break;
 
+			rq = cpu_rq(balance_cpu);
+			calc_load_account_active(rq);
+
 			rebalance_domains(balance_cpu, CPU_IDLE);
 
-			rq = cpu_rq(balance_cpu);
 			if (time_after(this_rq->next_balance, rq->next_balance))
 				this_rq->next_balance = rq->next_balance;
 		}
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index bea2b8f..6ca191f 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -23,8 +23,6 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
-	/* adjust the active tasks as we might go into a long sleep */
-	calc_load_account_active(rq);
 	return rq->idle;
 }
 


