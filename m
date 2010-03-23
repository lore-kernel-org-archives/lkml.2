Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab0CWSKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:10:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0CWSKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:10:42 -0400
Subject: RE: [PATCH] sched: prevent compiler from optimising
 sched_avg_update loop
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "'Eric Dumazet'" <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       Catalin Marinas <Catalin.Marinas@arm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <000101cacab3$25af90a0$710eb1e0$@deacon@arm.com>
References: <1269365805-17280-1-git-send-email-will.deacon@arm.com>
	 <1269366804.2983.300.camel@edumazet-laptop>
	 <000101cacab3$25af90a0$710eb1e0$@deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 19:10:18 +0100
Message-ID: <1269367818.5109.157.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 18:03 +0000, Will Deacon wrote:
> Hello Eric,
> 
> Thanks for looking at the patch.
> 
> > > diff --git a/kernel/sched.c b/kernel/sched.c
> > > index 9ab3cd7..6b74f21 100644
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -1238,11 +1238,10 @@ static u64 sched_avg_period(void)
> > >  static void sched_avg_update(struct rq *rq)
> > >  {
> > >  	s64 period = sched_avg_period();
> > > +	s64 elapsed_periods = div_s64(rq->clock - rq->age_stamp - 1, period);
> > >
> > > -	while ((s64)(rq->clock - rq->age_stamp) > period) {
> > > -		rq->age_stamp += period;
> > > -		rq->rt_avg /= 2;
> > > -	}
> > > +	rq->age_stamp += (u64)(elapsed_periods * period);
> > > +	rq->rt_avg >>= elapsed_periods;
> > >  }
> > >
> > >  static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
> > 
> > Please take a look at __iter_div_u64_rem() , because we had a similar
> > problem in the past. We want to avoid this div_s64() call.
> 
> Yes, I saw the inline assembly fix there. I avoided that fix because
> I was trying not to execute the loop body multiple times. Is the iterative
> approach preferred over a single call to div_s64? I don't have a handle on
> how many iterations are typically executed for this loop.

I expect it to be mostly 0 and occasionally 1 cycle, except when someone
pokes at a sysctl with funny values, at which point it might go round
much much faster.
