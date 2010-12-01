Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0LASvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:51:53 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40083 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab0LASvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:51:52 -0500
Subject: Re: [BUG(?)] perf_events: combining multiple tracepoint events
 into a group produces no counts on member events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101201180237.GB3438@nowhere>
References: <4CF59E20.1040301@linux.vnet.ibm.com>
	 <1291203990.4023.16.camel@twins> <1291205078.32004.1381.camel@laptop>
	 <20101201180237.GB3438@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 19:52:06 +0100
Message-ID: <1291229526.32004.1882.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 19:02 +0100, Frederic Weisbecker wrote:

> >  struct task_struct {
> >  	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
> >  	void *stack;
> > @@ -1452,6 +1458,9 @@ struct task_struct {
> >  	struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
> >  	struct mutex perf_event_mutex;
> >  	struct list_head perf_event_list;
> > +#ifdef CONFIG_EVENT_TRACING
> > +	struct perf_tp_idr *perf_tp_idr;
> 
> Why not attaching this to the ctx eventually? This makes one pointer less
> in task_struct.

What context? :-) There's now two context's (with the possibility of
even more), which one will hold the tracepoint stuff?

Also, since we only need one such structure, adding it to the context
doesn't make sense.

> > @@ -370,6 +372,7 @@ list_del_event(struct perf_event *event,
> >  	 */
> >  	if (event->state > PERF_EVENT_STATE_OFF)
> >  		event->state = PERF_EVENT_STATE_OFF;
> > +	++ctx->generation;
> 
> What's the role of the ctx->generation? It seems to be incremented two times
> but doesn't appear to have any purpose.

You didn't look hard enough, its a sequence stamp on the context for
inheritance, then later, when we want to compare inherited contexts we
can simply compare generation numbers, if they're the same the contexts
are the same.

> >  }
> >  
> >  static void perf_group_detach(struct perf_event *event)
> > @@ -1228,6 +1231,12 @@ void perf_event_context_sched_out(struct
> >  	if (!cpuctx->task_ctx)
> >  		return;
> >  
> > +#if 0
> > +	/*
> > +	 * Need to sort out how to make task_struct::perf_tp_idr
> > +	 * work with this fancy switching stuff.. tracepoints could be
> > +	 * in multiple contexts due to the software event muck.
> > +	 */
> 
> Not sure what's the issue here. Each ctx have the perf_tp_idr matching
> active tracepoints, isn't it?

No, there's only 1 idr per task. Having one per context means we have to
iterate all contexts when a tracepoint triggers and it adds yet another
pointer chase. It also means we have to manage more stuff when
tracepoints change context etc..

But yes, it would make this part easier, I just don't like the added
fast path overhead.

> > +static struct perf_tp_idr *perf_event_idr(struct perf_event *event, bool create)
> > +{
> > +	struct perf_tp_idr *tp_idr;
> > +	struct task_struct *task;
> > +
> > +	if (event->attach_state & PERF_ATTACH_TASK) {
> > +		task = event->hw.event_target;
> > +		tp_idr = task->perf_tp_idr;
> > +		if (!tp_idr && create)
> 
> Is it possible that task->perf_tp_idr can eventually disappear
> under us there? Like when an event is released from that task?

We hold a ref on the task on the create path, I'd have to actually think
about the destroy path, but I think there's a problem there.

I used to have a PERF_ATTACH_CONTEXT/GROUP test in there as well, dunno
why that didn't work out.

> > +			tp_idr = perf_tp_init_task(event, task);
> > +	} else
> > +		tp_idr = &per_cpu(perf_tp_idr, event->cpu);
> > +
> > +	return tp_idr;
> > +}


