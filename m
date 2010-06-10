Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab0FJQYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:24:34 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:35739 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759313Ab0FJQYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:24:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pt+J/1S4tTsm+6ut12d2XtXOJQFPDSJ6E21APmVcrFd8gRXP3mtgsKzlhfEzANN/E5
         IZQU44xI7XkGDoiUp4xZBt4AAuwGmBSqDWakO9y7Zb8DyIuZie8IHlP5HIi5cSth1IRE
         3uSMQAklWSuzTpGjVF3vWi5/vaGja57gStaqI=
Date: Thu, 10 Jun 2010 18:24:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/5] perf: Introduce task, softirq and hardirq contexts
	exclusion
Message-ID: <20100610162429.GB5255@nowhere>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com> <1276141760-11590-5-git-send-regression-fweisbec@gmail.com> <1276167687.2077.120.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276167687.2077.120.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 01:01:27PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-10 at 05:49 +0200, Frederic Weisbecker wrote:
> > @@ -642,17 +643,31 @@ event_sched_in(struct perf_event *event,
> >         if (event->state <= PERF_EVENT_STATE_OFF)
> >                 return 0;
> >  
> > -       event->state = PERF_EVENT_STATE_ACTIVE;
> > +       if (event->attr.exclude_task)
> > +               event->state = PERF_EVENT_STATE_PAUSED;
> > +       else
> > +               event->state = PERF_EVENT_STATE_ACTIVE;
> > +
> >         event->oncpu = smp_processor_id();
> > +
> 
> Aah, so that is why you added the PAUSE state knowledge to the arch
> code, you want to be able to call ->enable() on a PAUSEd event.
> 
> That means you need to audit/touch all implementations anyway, isn't
> there a better interface we can use, like maybe extend ->enable() with a
> flags argument?




The problem is more on hw_perf_enable/disable() as this is the place
where we do the true activations.

Moreover we also need to keep track of this paused state from the
generic code.

If I add a flag in enable(), this is going to add the same check
everywhere, and in fact hardware event would need to maintain
an internal paused state while this is something we have in the
generic code already.



 
> >         /*
> >          * The new state must be visible before we turn it on in the hardware:
> >          */
> >         smp_wmb();
> >  
> > -       if (event->pmu->enable(event)) {
> > -               event->state = PERF_EVENT_STATE_INACTIVE;
> > -               event->oncpu = -1;
> > -               return -EAGAIN;
> > +       /*
> > +        * If we exclude the tasks, we only need to schedule hardware
> > +        * events that need to settle themselves, even in a pause mode.
> > +        * Software events can simply be scheduled anytime.
> > +        * If we want more granularity in all that, we can still provide
> > +        * later a pmu->reserve callback.
> > +        */
> > +       if (!event->attr.exclude_task || !is_software_event(event)) {
> > +               if (event->pmu->enable(event)) {
> > +                       event->state = PERF_EVENT_STATE_INACTIVE;
> > +                       event->oncpu = -1;
> > +                       return -EAGAIN;
> > +               }
> >         }
> >  
> >         event->tstamp_running += ctx->time - event->tstamp_stopped; 
> 
> Remove is_software_event(), not add more.



I don't like this either, that's why I talked about the potential need
of a pmu:reserve() callback in the comments.

ie, pmu->reserve() would mean that the pmu knows how to deal with the
PAUSED state. If a pmu doesn't have it, then we would need to call
->enable() without setting the PAUSED state, so that exclude_* things
don't work with them (as we haven't audited the code).

What do you think? That would solve the audit everywhere problem
plus the is_software_event() problem.

pmu->reserve() would be the same than pmu->enable on x86 pmu, and
it would be a stub on software events. On x86 we would just need
to use the generic PAUSED state to make the difference, as it
would be a waste to maintain a parallel internal state.

