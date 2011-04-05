Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1DEOtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab1DEOt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:49:28 -0400
Date: Tue, 5 Apr 2011 16:48:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>, ben@iagu.net
Subject: Re: [PATCH] posix-timers: RCU conversion
Message-ID: <20110405144836.GA17490@redhat.com>
References: <4D8773AA.8030408@redhat.com> <AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com> <1300726498.2884.493.camel@edumazet-laptop> <4D8784A9.8040303@redhat.com> <1300727545.2884.513.camel@edumazet-laptop> <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com> <1300746429.2837.20.camel@edumazet-laptop> <1300777760.2837.38.camel@edumazet-laptop> <1301849660.2837.211.camel@edumazet-laptop> <1301940501.2319.25.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301940501.2319.25.camel@work-vm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04, john stultz wrote:
>
> On Sun, 2011-04-03 at 18:54 +0200, Eric Dumazet wrote:
> > --- a/include/linux/posix-timers.h
> > +++ b/include/linux/posix-timers.h
> > @@ -81,6 +81,7 @@ struct k_itimer {
> >  			unsigned long expires;
> >  		} mmtimer;
> >  	} it;
> > +	struct rcu_head rcu;
> >  };

Can't we move this rcu_head into the union above?

> >  struct k_clock {
> > diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
> > index 4c01249..acb9be9 100644
> > --- a/kernel/posix-timers.c
> > +++ b/kernel/posix-timers.c
> > @@ -491,6 +491,13 @@ static struct k_itimer * alloc_posix_timer(void)
> >  	return tmr;
> >  }
> >
> > +static void k_itimer_rcu_free(struct rcu_head *head)
> > +{
> > +	struct k_itimer *tmr = container_of(head, struct k_itimer, rcu);
> > +
> > +	kmem_cache_free(posix_timers_cache, tmr);
> > +}

Not that I really think it makes sense to change the patch... but we
could even use SLAB_DESTROY_BY_RCU, this is more effective. All we
need is ctor which sets ->it_signal = NULL and initializes ->it_lock
for lock_timer().

> >  static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
> >  {
> >  	struct k_itimer *timr;
> > -	/*
> > -	 * Watch out here.  We do a irqsave on the idr_lock and pass the
> > -	 * flags part over to the timer lock.  Must not let interrupts in
> > -	 * while we are moving the lock.
> > -	 */
> > -	spin_lock_irqsave(&idr_lock, *flags);
> > +
> > +	rcu_read_lock();
> >  	timr = idr_find(&posix_timers_id, (int)timer_id);
> >  	if (timr) {
> > -		spin_lock(&timr->it_lock);
> > +		spin_lock_irqsave(&timr->it_lock, *flags);
> >  		if (timr->it_signal == current->signal) {
> > -			spin_unlock(&idr_lock);
> > +			rcu_read_unlock();
> >  			return timr;
> >  		}
> > -		spin_unlock(&timr->it_lock);
> > +		spin_unlock_irqrestore(&timr->it_lock, *flags);
> >  	}
> > -	spin_unlock_irqrestore(&idr_lock, *flags);
> > +	rcu_read_unlock();

I think this is correct.

The question is, why do we use the global database for the timer ids.
All timers live in signal_struct->posix_timers anyway, perhaps we could
use a per-process array instead.

Oleg.

