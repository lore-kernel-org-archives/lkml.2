Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab1BLXrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 18:47:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab1BLXrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 18:47:06 -0500
Subject: Re: [PATCH v3 3/6] KVM-GST: KVM Steal time accounting
From: Glauber Costa <glommer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1297451143.5226.87.camel@laptop>
References: <1297448364-14051-1-git-send-email-glommer@redhat.com>
	 <1297448364-14051-4-git-send-email-glommer@redhat.com>
	 <1297451143.5226.87.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Sat, 12 Feb 2011 21:46:52 -0200
Message-ID: <1297554412.3419.39.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 20:05 +0100, Peter Zijlstra wrote:
> On Fri, 2011-02-11 at 13:19 -0500, Glauber Costa wrote:
> 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index d747f94..5dbf509 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -302,6 +302,7 @@ long io_schedule_timeout(long timeout);
> >  extern void cpu_init (void);
> >  extern void trap_init(void);
> >  extern void update_process_times(int user);
> > +extern u64 (*hypervisor_steal_time)(int cpu);
> >  extern void scheduler_tick(void);
> 
> That's quite terrible..
> 
> >  extern void sched_show_task(struct task_struct *p);
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 18d38e4..60b0cf8 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -524,6 +524,8 @@ struct rq {
> >  	u64 prev_irq_time;
> >  #endif
> >  
> > +	u64 prev_steal_ticks;
> > +
> >  	/* calc_load related fields */
> >  	unsigned long calc_load_update;
> >  	long calc_load_active;
> > @@ -1780,6 +1782,16 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
> >  	dec_nr_running(rq);
> >  }
> >  
> > +u64 (*hypervisor_steal_time)(int cpu) = NULL;
> 
> I don't think exposing functions pointers like that is very nice at all.
> 
> > +static u64 steal_time_clock(int cpu)
> > +{
> > +	if (!hypervisor_steal_time)
> > +		return 0;
> > +
> > +	return hypervisor_steal_time(cpu);
> > +}
> 
> This really wants to be under some PARAVIRT config thing, preferably the
> same as the other bits (PARAVIRT_TIME_ACCOUNTING).

Agree on the function pointer, but (at first) disagree on the
conditional. The mere accounting of steal time is in principle
independent on its use to adjust CPU power. So we potentially may want
the first, but avoid the later. 

I can wrap the accounting on a CONFIG switch, but I don't honestly see a
reason for it. 

> Also, it would be nice to avoid the function call and conditional on
> native hardware, this is on all scheduler hot paths, best it to make
> sure you don't even get so far as to call this function on native
> hardware.

Fair.

> >  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
> >  
> >  /*
> > @@ -3509,6 +3521,33 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
> >  }
> >  
> >  /*
> > + * We have to at flush steal time information every time something else
> > + * is accounted. Since the accounting functions are all visible to the rest
> > + * of the kernel, it gets tricky to do them in one place. This helper function
> > + * helps us.
> > + *
> > + * When the system is idle, the concept of steal time does not apply. We just
> > + * tell the underlying hypervisor that we grabbed the data, but skip steal time
> > + * accounting
> > + */
> > +static int touch_steal_time(int is_idle)
> > +{
> > +	u64 steal, st;
> > +
> > +	steal = steal_time_clock(smp_processor_id());
> > +
> > +	st = steal / TICK_NSEC - this_rq()->prev_steal_ticks;
> 
> (this won't compile on 32bits)
> 
> > +	this_rq()->prev_steal_ticks += st;
> 
> This doesn't seem right..
> 
>   struct rq *rq = this_rq();
>   u64 steal, delta;
>   int ticks = 0;
> 
>   steal = steal_time_clock(smp_processor_id());
>   delta = rq->prev_steal_ticks;
>   while (delta >= TICK_NSEC) {
>     ticks++;
>     rq->prev_steal_time += TICK_NSEC;
>   }
> 
>   if (!ticks)
>     return 0;
> 
>   account_steal_time(ticks);
>   return 1;
> 
> would be much more accurate.
> 
> > +	if (!st || is_idle)
> > +		return 0;
> > +
> > +	account_steal_time(st);
> > +	return 1;
> > +}
> 
> This also wants to be much much cheaper for native hardware even if you
> were silly enough to enable the paravirt config ;-) ie. bail out of this
> function at the start instead of going through the motions when we know
> the clock doesn't count.

Okay, I will update it.

> 
> 


