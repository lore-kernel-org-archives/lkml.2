Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab2IMITu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:19:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:39719 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab2IMITq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:19:46 -0400
Message-ID: <1347524381.15764.100.camel@twins>
Subject: Re: [RFC] sched: nohz_idle_balance
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, mingo@redhat.com
Date: Thu, 13 Sep 2012 10:19:41 +0200
In-Reply-To: <1347518991.6821.45.camel@marge.simpson.net>
References: <1347509486-8688-1-git-send-email-vincent.guittot@linaro.org>
	 <1347518991.6821.45.camel@marge.simpson.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 08:49 +0200, Mike Galbraith wrote:
> On Thu, 2012-09-13 at 06:11 +0200, Vincent Guittot wrote: 
> > On tickless system, one CPU runs load balance for all idle CPUs.
> > The cpu_load of this CPU is updated before starting the load balance
> > of each other idle CPUs. We should instead update the cpu_load of the balance_cpu.
> > 
> > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> > ---
> >  kernel/sched/fair.c |   11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 1ca4fe4..9ae3a5b 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4794,14 +4794,15 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
> >  		if (need_resched())
> >  			break;
> >  
> > -		raw_spin_lock_irq(&this_rq->lock);
> > -		update_rq_clock(this_rq);
> > -		update_idle_cpu_load(this_rq);
> > -		raw_spin_unlock_irq(&this_rq->lock);
> > +		rq = cpu_rq(balance_cpu);
> > +
> > +		raw_spin_lock_irq(&rq->lock);
> > +		update_rq_clock(rq);
> > +		update_idle_cpu_load(rq);
> > +		raw_spin_unlock_irq(&rq->lock);
> >  
> >  		rebalance_domains(balance_cpu, CPU_IDLE);
> >  
> > -		rq = cpu_rq(balance_cpu);
> >  		if (time_after(this_rq->next_balance, rq->next_balance))
> >  			this_rq->next_balance = rq->next_balance;
> >  	}
> 
> Ew, banging locks and updating clocks to what good end?

Well, updating the load statistics on the cpu you're going to balance
seems like a good end to me.. ;-) No point updating the local statistics
N times and leaving the ones you're going to balance stale for god knows
how long.
