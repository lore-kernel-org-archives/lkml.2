Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1FFRgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:36:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab1FFRgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:36:21 -0400
Date: Mon, 6 Jun 2011 18:46:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: RCU-protect __set_task_cpu() in set_task_cpu()
Message-ID: <20110606164657.GA20752@redhat.com>
References: <20110531172651.GA4478@swordfish.minsk.epam.com> <1307115427.2353.3456.camel@twins> <20110605191233.GA20462@redhat.com> <1307351198.2353.7415.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307351198.2353.7415.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06, Peter Zijlstra wrote:
>
> You're right, p->pi_lock for wakeups, rq->lock for runnable tasks.

Good, thanks.

Help! I have another question.

	try_to_wake_up:

		raw_spin_lock_irqsave(&p->pi_lock, flags);
		if (!(p->state & state))
			goto out;

		cpu = task_cpu(p);

		if (p->on_rq && ttwu_remote(p, wake_flags))
			goto stat;

This doesn't look a bit confusing, we can't trust "cpu = task_cpu" before
we check ->on_rq. OK, not a problem, this cpu number can only be used in
ttwu_stat(cpu).

But ttwu_stat(cpu) in turn does

	if (cpu != task_cpu(p))
		schedstat_inc(p, se.statistics.nr_wakeups_migrate);

Ignoring the theoretical races with pull_task/etc, how it is possible
that cpu != task_cpu(p) ? Another caller is try_to_wake_up_local(), it
obviously can't trigger this case.

This looks broken to me. Looking at its name, I guess nr_wakeups_migrate
should be incremented if ttwu does set_task_cpu(), correct?

IOW. Don't we need something like the (untested/ucompiled) patch below?
_If_ I am right, I can resend it with the changelog/etc but please feel
free to make another fix.

Oleg.

--- x/kernel/sched.c
+++ x/kernel/sched.c
@@ -2423,13 +2423,14 @@ static void update_avg(u64 *avg, u64 sam
 #endif
 
 static void
-ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
+ttwu_stat(struct task_struct *p, bool migrate, int wake_flags)
 {
 #ifdef CONFIG_SCHEDSTATS
 	struct rq *rq = this_rq();
 
 #ifdef CONFIG_SMP
 	int this_cpu = smp_processor_id();
+	int cpu = task_cpu(p);
 
 	if (cpu == this_cpu) {
 		schedstat_inc(rq, ttwu_local);
@@ -2455,7 +2456,7 @@ ttwu_stat(struct task_struct *p, int cpu
 	if (wake_flags & WF_SYNC)
 		schedstat_inc(p, se.statistics.nr_wakeups_sync);
 
-	if (cpu != task_cpu(p))
+	if (migrate)
 		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
 
 #endif /* CONFIG_SCHEDSTATS */
@@ -2630,6 +2631,7 @@ try_to_wake_up(struct task_struct *p, un
 {
 	unsigned long flags;
 	int cpu, success = 0;
+	bool migrate = false;
 
 	smp_wmb();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
@@ -2637,7 +2639,6 @@ try_to_wake_up(struct task_struct *p, un
 		goto out;
 
 	success = 1; /* we're going to change ->state */
-	cpu = task_cpu(p);
 
 	if (p->on_rq && ttwu_remote(p, wake_flags))
 		goto stat;
@@ -2674,13 +2675,15 @@ try_to_wake_up(struct task_struct *p, un
 		p->sched_class->task_waking(p);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (task_cpu(p) != cpu)
+	if (task_cpu(p) != cpu) {
 		set_task_cpu(p, cpu);
+		migrate = true;
+	}
 #endif /* CONFIG_SMP */
 
 	ttwu_queue(p, cpu);
 stat:
-	ttwu_stat(p, cpu, wake_flags);
+	ttwu_stat(p, migrate, wake_flags);
 out:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
@@ -2716,7 +2719,7 @@ static void try_to_wake_up_local(struct 
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_do_wakeup(rq, p, 0);
-	ttwu_stat(p, smp_processor_id(), 0);
+	ttwu_stat(p, false, 0);
 out:
 	raw_spin_unlock(&p->pi_lock);
 }


