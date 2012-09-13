Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab2IMK3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:29:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:37374 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751708Ab2IMK3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:29:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1//FQ0RvB3/lcfDSCh+RcoAXRtNCTnKP8AG009OAO
	Sv4t5/bfsCQfp+
Message-ID: <1347532167.6821.75.camel@marge.simpson.net>
Subject: Re: [RFC] sched: nohz_idle_balance
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, mingo@redhat.com
Date: Thu, 13 Sep 2012 12:29:27 +0200
In-Reply-To: <1347524381.15764.100.camel@twins>
References: <1347509486-8688-1-git-send-email-vincent.guittot@linaro.org>
	 <1347518991.6821.45.camel@marge.simpson.net>
	 <1347524381.15764.100.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 10:19 +0200, Peter Zijlstra wrote: 
> On Thu, 2012-09-13 at 08:49 +0200, Mike Galbraith wrote:
> > On Thu, 2012-09-13 at 06:11 +0200, Vincent Guittot wrote: 
> > > On tickless system, one CPU runs load balance for all idle CPUs.
> > > The cpu_load of this CPU is updated before starting the load balance
> > > of each other idle CPUs. We should instead update the cpu_load of the balance_cpu.
> > > 
> > > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> > > ---
> > >  kernel/sched/fair.c |   11 ++++++-----
> > >  1 file changed, 6 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > > index 1ca4fe4..9ae3a5b 100644
> > > --- a/kernel/sched/fair.c
> > > +++ b/kernel/sched/fair.c
> > > @@ -4794,14 +4794,15 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
> > >  		if (need_resched())
> > >  			break;
> > >  
> > > -		raw_spin_lock_irq(&this_rq->lock);
> > > -		update_rq_clock(this_rq);
> > > -		update_idle_cpu_load(this_rq);
> > > -		raw_spin_unlock_irq(&this_rq->lock);
> > > +		rq = cpu_rq(balance_cpu);
> > > +
> > > +		raw_spin_lock_irq(&rq->lock);
> > > +		update_rq_clock(rq);
> > > +		update_idle_cpu_load(rq);
> > > +		raw_spin_unlock_irq(&rq->lock);
> > >  
> > >  		rebalance_domains(balance_cpu, CPU_IDLE);
> > >  
> > > -		rq = cpu_rq(balance_cpu);
> > >  		if (time_after(this_rq->next_balance, rq->next_balance))
> > >  			this_rq->next_balance = rq->next_balance;
> > >  	}
> > 
> > Ew, banging locks and updating clocks to what good end?
> 
> Well, updating the load statistics on the cpu you're going to balance
> seems like a good end to me.. ;-) No point updating the local statistics
> N times and leaving the ones you're going to balance stale for god knows
> how long.

Sure, the goal is fine, but I wonder about the price vs payoff.  I was
thinking perhaps the redundant updates should go away instead, unless
stats are shown to be causing real world pain.

-Mike

