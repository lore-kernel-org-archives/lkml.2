Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab1JCVMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:12:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:61684 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360Ab1JCVMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:12:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,481,1312182000"; 
   d="scan'208";a="58330339"
Subject: Re: [patch 1/2] sched: use resched IPI to kick off the nohz idle
 balance
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Mon, 03 Oct 2011 14:13:54 -0700
In-Reply-To: <1317670590.20367.38.camel@twins>
References: <20110929223242.837017656@sbsiddha-desk.sc.intel.com>
	 <1317670590.20367.38.camel@twins>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317676434.11592.156.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 12:36 -0700, Peter Zijlstra wrote:
> On Thu, 2011-09-29 at 15:30 -0700, Suresh Siddha wrote:
> 
> > ---
> >  kernel/sched.c      |   14 +++++++++++---
> >  kernel/sched_fair.c |   27 +++++++--------------------
> >  2 files changed, 18 insertions(+), 23 deletions(-)
> > 
> > Index: linux-2.6-tip/kernel/sched.c
> > ===================================================================
> > --- linux-2.6-tip.orig/kernel/sched.c
> > +++ linux-2.6-tip/kernel/sched.c
> > @@ -2733,7 +2733,7 @@ void scheduler_ipi(void)
> >  	struct rq *rq = this_rq();
> >  	struct task_struct *list = xchg(&rq->wake_list, NULL);
> >  
> > -	if (!list)
> > +	if (!list && !idle_cpu(cpu_of(rq)))
> >  		return;
> 
> Why not make that !rq->nohz_balance_kick? (wrapped in a helper for !
> CONFIG_NO_HZ)

If a rq gets busy before we do nohz_idle_balance() which does the
nohz_balance_kick reset, we will have a busy rq with nohz_balance_kick
set. And wanted to bail out sooner by checking for idle cpu and minimize
the impact for a busy rq having the nohz_idle_balance set.

I can probably rename your got_nohz_kick() as got_nohz_idle_kick() and
fix it.

> > tself as idle load_balancer, while
> > @@ -4450,11 +4434,14 @@ static void nohz_balancer_kick(int cpu)
> >  	}
> >  
> >  	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
> > -		struct call_single_data *cp;
> > -
> >  		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
> > -		cp = &per_cpu(remote_sched_softirq_cb, cpu);
> > -		__smp_call_function_single(ilb_cpu, cp, 0);
> > +		/*
> > +		 * Use kick_process instead of resched_cpu.
> > +		 * This way we generate a sched IPI on the target cpu which
> > +		 * is idle. And the softirq performing nohz idle load balance
> > +		 * will be run before returning from the IPI.
> > +		 */
> 
> Shouldn't we have a memory barrier of sorts before sending the IPI?
> 
> > +		kick_process(idle_task(ilb_cpu));

Correct and also I think we can use smp_send_reschedule() directly
instead of kick process. Will fix it.

thanks,
suresh

