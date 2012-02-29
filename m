Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030863Ab2B2QYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 11:24:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39508 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab2B2QYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 11:24:41 -0500
Message-ID: <1330532667.11248.153.camel@twins>
Subject: Re: Inconsistent load average on tickless kernels
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Les=C5=82aw_Kope=C4=87?= <leslaw.kopec@nasza-klasa.pl>
Cc: Aman Gupta <aman@tmm1.net>, linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>,
        Damien Wyart <damien.wyart@free.fr>, Kyle McMartin <kyle@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Date: Wed, 29 Feb 2012 17:24:27 +0100
In-Reply-To: <1330517195.11248.148.camel@twins>
References: <CAK=uwuy80LaNdQ4P49i+bGUXFvxf1zB=oKqNBTdAyvFc+mOTyw@mail.gmail.com>
	 <4F465F6E.9070605@nasza-klasa.pl> <1330517195.11248.148.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 13:06 +0100, Peter Zijlstra wrote:
> 
> > Steps to reproduce: run a bunch of CPU bound processes that will not use
> > all available cycles. The biggest difference between expected and
> > measured load is around 30% CPU utilization in my case.
> 
> Hrmm, this suggests we age too hard with nohz code.. in your test case
> is there significant idle time? That is, suppose you run each cpu at 30%
> what is the period of you load? Running 3s out of 10s is significantly
> different from running .3ms out of 1ms.

I can indeed see some weirdness, but not only downwards, I can manage to
get a load of 1 with two 20% burners (0.1 ms period). Still need to try
with bigger periods.

> > Has there been any other patches that correct load calculation? Maybe
> > I'm testing it in a wrong way? I'd appreciate any suggestions. I'd be
> > happy to test new patches. Sadly, I cannot propose any fixes as kernel
> > sources are still a mystery to me.
> 
> Darned load-tracking stuff.. I went over it again but couldn't spot
> anything obviously broken. I suspect the tail magic of
> calc_global_nohz() is busted, just not seeing it atm.
> 
> Will go brew myself a fresh pot of tea and stare more.

The only thing I could find is that on nohz we can confuse the per-rq
sample period, does the below make a difference?

---
 kernel/sched/core.c  |    9 +--------
 kernel/sched/sched.h |    1 -
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d7c4322..370c578 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2372,15 +2372,13 @@ static void calc_load_account_active(struct rq *this_rq)
 {
 	long delta;
 
-	if (time_before(jiffies, this_rq->calc_load_update))
+	if (time_before(jiffies, calc_load_update))
 		return;
 
 	delta  = calc_load_fold_active(this_rq);
 	delta += calc_load_fold_idle();
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
-
-	this_rq->calc_load_update += LOAD_FREQ;
 }
 
 /*
@@ -5329,10 +5327,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 
-	case CPU_UP_PREPARE:
-		rq->calc_load_update = calc_load_update;
-		break;
-
 	case CPU_ONLINE:
 		/* Update our root-domain */
 		raw_spin_lock_irqsave(&rq->lock, flags);
@@ -6879,7 +6873,6 @@ void __init sched_init(void)
 		raw_spin_lock_init(&rq->lock);
 		rq->nr_running = 0;
 		rq->calc_load_active = 0;
-		rq->calc_load_update = jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8a2c768..59b5a33 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -441,7 +441,6 @@ struct rq {
 #endif
 
 	/* calc_load related fields */
-	unsigned long calc_load_update;
 	long calc_load_active;
 
 #ifdef CONFIG_SCHED_HRTICK

