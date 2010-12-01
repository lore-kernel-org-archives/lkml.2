Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0LASCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:02:48 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62353 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab0LASCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:02:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RcFEpxqwacFimn5xoUofeqKNCoqsdQEUPSctgjbxetOmOmNb0fSbQ6NDH7qEhHHvSR
         XfGsndHKjFa6Fzr1h7fat4xElbicsiqSqcpfGG6m2IUgObXaVluQstVEnHfRInUYtqti
         vfUAL9VQsfHLW+3TWlYRRKLnzMRko2724FIhY=
Date: Wed, 1 Dec 2010 19:02:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG(?)] perf_events: combining multiple tracepoint events
 into a group produces no counts on member events
Message-ID: <20101201180237.GB3438@nowhere>
References: <4CF59E20.1040301@linux.vnet.ibm.com>
 <1291203990.4023.16.camel@twins>
 <1291205078.32004.1381.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291205078.32004.1381.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 01:04:37PM +0100, Peter Zijlstra wrote:
> @@ -545,6 +546,11 @@ struct hw_perf_event {
>  			struct task_struct		*bp_target;
>  		};
>  #endif
> +		/*
> +		 * Same fudge as for breakpoints, trace-events needs
> +		 * it too,.. convert the bp crap over..
> +		 */
> +		struct task_struct *event_target;

Yeah, looks like we can merge the bp_target and event_target.


>  struct task_struct {
>  	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
>  	void *stack;
> @@ -1452,6 +1458,9 @@ struct task_struct {
>  	struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
>  	struct mutex perf_event_mutex;
>  	struct list_head perf_event_list;
> +#ifdef CONFIG_EVENT_TRACING
> +	struct perf_tp_idr *perf_tp_idr;

Why not attaching this to the ctx eventually? This makes one pointer less
in task_struct.

> @@ -370,6 +372,7 @@ list_del_event(struct perf_event *event,
>  	 */
>  	if (event->state > PERF_EVENT_STATE_OFF)
>  		event->state = PERF_EVENT_STATE_OFF;
> +	++ctx->generation;

What's the role of the ctx->generation? It seems to be incremented two times
but doesn't appear to have any purpose.


>  }
>  
>  static void perf_group_detach(struct perf_event *event)
> @@ -1228,6 +1231,12 @@ void perf_event_context_sched_out(struct
>  	if (!cpuctx->task_ctx)
>  		return;
>  
> +#if 0
> +	/*
> +	 * Need to sort out how to make task_struct::perf_tp_idr
> +	 * work with this fancy switching stuff.. tracepoints could be
> +	 * in multiple contexts due to the software event muck.
> +	 */

Not sure what's the issue here. Each ctx have the perf_tp_idr matching
active tracepoints, isn't it?

> +static struct perf_tp_idr *perf_event_idr(struct perf_event *event, bool create)
> +{
> +	struct perf_tp_idr *tp_idr;
> +	struct task_struct *task;
> +
> +	if (event->attach_state & PERF_ATTACH_TASK) {
> +		task = event->hw.event_target;
> +		tp_idr = task->perf_tp_idr;
> +		if (!tp_idr && create)

Is it possible that task->perf_tp_idr can eventually disappear
under us there? Like when an event is released from that task?

> +			tp_idr = perf_tp_init_task(event, task);
> +	} else
> +		tp_idr = &per_cpu(perf_tp_idr, event->cpu);
> +
> +	return tp_idr;
> +}
