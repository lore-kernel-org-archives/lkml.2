Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab0EQEiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 00:38:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:40333 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750947Ab0EQEio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 00:38:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19oD6g/2QFo+ysW3Bb3c7tAS6diQrfR7sZV/tnItw
	FXL9OaWqv4nb6+
Subject: Re: commit e9e9250b: sync wakeup bustage when waker is an RT task
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1273994510.7873.10.camel@marge.simson.net>
References: <1273924628.10630.24.camel@marge.simson.net>
	 <1273925052.1674.138.camel@laptop>
	 <1273943222.8752.7.camel@marge.simson.net>
	 <1273994510.7873.10.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 17 May 2010 06:38:40 +0200
Message-Id: <1274071120.15000.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-16 at 09:21 +0200, Mike Galbraith wrote: 
> On Sat, 2010-05-15 at 19:07 +0200, Mike Galbraith wrote:
> > On Sat, 2010-05-15 at 14:04 +0200, Peter Zijlstra wrote:
> > > On Sat, 2010-05-15 at 13:57 +0200, Mike Galbraith wrote:
> > > > Hi Peter,
> > > > 
> > > > This commit excluded RT tasks from rq->load, was that intentional?  The
> > > > comment in struct rq states that load reflects *all* tasks, but since
> > > > this commit, that's no longer true.
> > > 
> > > Right, because a static load value does not accurately reflect a RT task
> > > which can run as long as it pretty well pleases. So instead we measure
> > > the time spend running !fair tasks and scale down the cpu_power
> > > proportionally.
> > > 
> > > > Looking at lmbench lat_udp in a PREEMPT_RT kernel, I noticed that
> > > > wake_affine() is failing for sync wakeups when it should not.  It's
> > > > doing so because the waker in this case is an RT kernel thread
> > > > (sirq-net-rx) - we subtract the sync waker's weight, when it was never
> > > > added in the first place, resulting in this_load going gaga.  End result
> > > > is quite high latency numbers due to tasks jabbering cross-cache.
> > > > 
> > > > If the exclusion was intentional, I suppose I can do a waker class check
> > > > in wake_affine() to fix it.
> > > 
> > > So basically make all RT wakeups sync?
> > 
> > I was going to just skip subtracting waker's weight ala
> > 
> >         /*
> >          * If sync wakeup then subtract the (maximum possible)
> >          * effect of the currently running task from the load
> >          * of the current CPU:
> >          */
> > 	if (sync && !task_has_rt_policy(curr))
> 
> One-liner doesn't work.  We have one task on the cfs_rq, the one who is
> the waker in !PREEMPT_RT, which is a fail case for wake_affine() if you
> don't do the weight subtraction.  I did the below instead.

(Which is kinda fugly, only redeeming factor is it works;).

What would be the harm/consequence of restoring RT tasks to rq->load so
the wake_affine()::sync logic just worked as before without hackery?
The weight is a more or less random number, but looking around, with
them excluded, avg_load_per_task is lowered when RT tasks enter the
system, and rq->load[] misses their weight.  (Dunno what effect it has
on tg shares).

	-Mike

> sched: RT waker sync wakeup bugfix
> 
> An RT waker's weight is not on the runqueue, but we try to subrtact it anyway
> in the sync wakeup case,  sending this_load negative.  This leads to affine
> wakeup failure in cases where it should succeed.  This was found while testing
> an PREEMPT_RT kernel with lmbench's lat_udp.  In a PREEMPT_RT kernel, softirq
> threads act as a ~proxy for the !RT buddy.  Approximate !PREEMPT_RT sync wakeup
> behavior by looking at the buddy instead, and subtracting the maximum task weight
> that will not send this_load negative.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> LKML-Reference: <new-submission>
> 
>  kernel/sched_fair.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 5240469..cc40849 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1280,6 +1280,15 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  		tg = task_group(current);
>  		weight = current->se.load.weight;
>  
> +		/*
> +		 * An RT waker's weight is not on the runqueue.  Subtract the
> +		 * maximum task weight that will not send this_load negative.
> +		 */
> +		if (task_has_rt_policy(current)) {
> +			weight = max_t(unsigned long, NICE_0_LOAD, p->se.load.weight);
> +			weight = min(weight, this_load);
> +		}
> +
>  		this_load += effective_load(tg, this_cpu, -weight, -weight);
>  		load += effective_load(tg, prev_cpu, 0, -weight);
>  	}
> 

