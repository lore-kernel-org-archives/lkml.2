Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab0DATjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:39:08 -0400
Received: from www.tglx.de ([62.245.132.106]:43424 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab0DATjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:39:05 -0400
Date: Thu, 1 Apr 2010 21:37:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chase Douglas <chase.douglas@canonical.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting till
 after load update period
In-Reply-To: <20100401122740.a1ae80a7.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004012133570.32352@localhost.localdomain>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com> <1269870072-22449-2-git-send-email-chase.douglas@canonical.com> <20100401122740.a1ae80a7.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Andrew Morton wrote:
> On Mon, 29 Mar 2010 09:41:12 -0400
> Chase Douglas <chase.douglas@canonical.com> wrote:
> 
> > There's a period of 10 ticks where calc_load_tasks is updated by all the
> > cpus for the load avg. Usually all the cpus do this during the first
> > tick. If any cpus go idle, calc_load_tasks is decremented accordingly.
> > However, if they wake up calc_load_tasks is not incremented. Thus, if
> > cpus go idle during the 10 tick period, calc_load_tasks may be
> > decremented to a non-representative value. This issue can lead to
> > systems having a load avg of exactly 0, even though the real load avg
> > could theoretically be up to NR_CPUS.
> > 
> > This change defers calc_load_tasks accounting after each cpu updates the
> > count until after the 10 tick period.
> > 
> > BugLink: http://bugs.launchpad.net/bugs/513848
> > 
> 
> There was useful information in the [patch 0/1] email, such as the
> offending commit ID.  If possible, it's best to avoid the [patch 0/n]
> thing altogether - that information either has to be moved into the
> [patch 1/n] changelog by someone (ie: me), or it just gets ommitted and
> lost.
> 
> 
> > ---
> >  kernel/sched.c |   16 ++++++++++++++--
> >  1 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 9ab3cd7..c0aedac 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -3064,7 +3064,8 @@ void calc_global_load(void)
> >   */
> >  static void calc_load_account_active(struct rq *this_rq)
> >  {
> > -	long nr_active, delta;
> > +	static atomic_long_t deferred;
> > +	long nr_active, delta, deferred_delta;
> >  
> >  	nr_active = this_rq->nr_running;
> >  	nr_active += (long) this_rq->nr_uninterruptible;
> > @@ -3072,6 +3073,17 @@ static void calc_load_account_active(struct rq *this_rq)
> >  	if (nr_active != this_rq->calc_load_active) {
> >  		delta = nr_active - this_rq->calc_load_active;
> >  		this_rq->calc_load_active = nr_active;
> > +
> > +		/* Need to defer idle accounting during load update period: */
> > +		if (unlikely(time_before(jiffies, this_rq->calc_load_update) &&
> > +			     time_after_eq(jiffies, calc_load_update))) {
> > +			atomic_long_add(delta, &deferred);
> > +			return;
> > +		}
> 
> That seems a sensible way to avoid the gross-looking "10 ticks" thing.
> 
> What was the reason for "update the avenrun load estimates 10 ticks
> after the CPUs have updated calc_load_tasks"?  Can we do something
> smarter there to fix this?

The reason was to make sure that all cpus have updated their stuff
halfways before we start to calculate and we spread out stuff among
cpus to avoid contention on those global atomic variables.

Yes, we can do something smarter. First thing is to fix the
nr_uninterruptible accounting which can become negative. Peter looked
into that already and we really need to fix this first before doing
anything smart about that load avg stuff.

Thanks,

	tglx

