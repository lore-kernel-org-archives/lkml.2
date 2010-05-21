Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab0EUKCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:02:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55223 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab0EUKCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:02:09 -0400
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
 track events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100521094014.GA30108@nowhere>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.473188012@chello.nl>  <20100521094014.GA30108@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 12:02:05 +0200
Message-ID: <1274436125.1674.1690.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 11:40 +0200, Frederic Weisbecker wrote:
> On Fri, May 21, 2010 at 11:02:03AM +0200, Peter Zijlstra wrote:

> > Also, avoid conditionals on the fast path by ordering with probe unregister
> > so that we should never get on the callback path without the data being there.
> > 
> 									\
> > +	head = per_cpu_ptr(event_call->perf_events, smp_processor_id());\

> Should be rcu_dereference_sched ?

No, I removed all that rcu stuff and synchronized against the probe
unregister.

I assumed that after probe unregister a tracepoint callback doesn't
happen, which then guarantees we should never get !head.

> > +	for_each_possible_cpu(cpu)
> > +		INIT_HLIST_HEAD(per_cpu_ptr(list, cpu));
> > +
> > +	tp_event->perf_events = list;
> 
> 
> 
> I suspect this must be rcu_assign_pointer.

Same thing as above, I do this before probe register, so I see no need
for RCU.

> > +	list = per_cpu_ptr(list, smp_processor_id());
> > +	hlist_add_head_rcu(&p_event->hlist_entry, list);
> 
> 
> 
> Ah and may be small comment, because using the hlist api here
> may puzzle more people than just me ;)

What exactly is the puzzlement about?

> > +	if (--tp_event->perf_refcount > 0)
> > +		return;
> > +
> > +	tp_event->perf_event_disable(tp_event);
> 
> 
> 
> Don't we need a rcu_synchronize_sched() here?

Doesn't probe unregister synchronize things against its own callback?

> > +	free_percpu(tp_event->perf_events);
> > +	tp_event->perf_events = NULL;
> 
> 
> 
> And rcu_assign?

Which again, makes any use of RCU unneeded.


> > +	raw_data = per_cpu_ptr(perf_trace_buf[*rctxp], smp_processor_id());
> 
> 
> 
> Needs rcu_dereference_sched too. And this could be __this_cpu_var()

Ahh! so that is what its called.

> > +	preempt_disable_notrace();
> 
> 
> Why is this needed. We have the recursion context protection already.

Because:

@@ -4094,7 +4087,7 @@ end:
 
 int perf_swevent_get_recursion_context(void)
 {
-       struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
+       struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
        int rctx;
 
        if (in_nmi())

