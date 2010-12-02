Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab0LBR5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 12:57:00 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51511 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942Ab0LBR47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 12:56:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ribj5FC4+/SoGrdMFThuotvlLBRNCsY1fZFJW1ieQhHlnBFpKXmibSZkPxFweiGDYC
         dwZpJgoz7iVGNTfxURV/jQ4c9HIu0W7ORKJfINprG6t2Qkz/bixZDZD/I9Ud21jYFZB4
         umG9ACgw3tnGAbMd2Grcdn0nziAvjSrtaYeCI=
Date: Thu, 2 Dec 2010 18:56:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG(?)] perf_events: combining multiple tracepoint events
 into a group produces no counts on member events
Message-ID: <20101202175647.GB1750@nowhere>
References: <4CF59E20.1040301@linux.vnet.ibm.com>
 <1291203990.4023.16.camel@twins>
 <1291205078.32004.1381.camel@laptop>
 <20101201180237.GB3438@nowhere>
 <1291229526.32004.1882.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291229526.32004.1882.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 07:52:06PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-01 at 19:02 +0100, Frederic Weisbecker wrote:
> 
> > >  struct task_struct {
> > >  	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
> > >  	void *stack;
> > > @@ -1452,6 +1458,9 @@ struct task_struct {
> > >  	struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
> > >  	struct mutex perf_event_mutex;
> > >  	struct list_head perf_event_list;
> > > +#ifdef CONFIG_EVENT_TRACING
> > > +	struct perf_tp_idr *perf_tp_idr;
> > 
> > Why not attaching this to the ctx eventually? This makes one pointer less
> > in task_struct.
> 
> What context? :-) There's now two context's (with the possibility of
> even more), which one will hold the tracepoint stuff?
> 
> Also, since we only need one such structure, adding it to the context
> doesn't make sense.

Oh you're right, I forgot the per pmu context thing :)


> 
> > > @@ -370,6 +372,7 @@ list_del_event(struct perf_event *event,
> > >  	 */
> > >  	if (event->state > PERF_EVENT_STATE_OFF)
> > >  		event->state = PERF_EVENT_STATE_OFF;
> > > +	++ctx->generation;
> > 
> > What's the role of the ctx->generation? It seems to be incremented two times
> > but doesn't appear to have any purpose.
> 
> You didn't look hard enough, its a sequence stamp on the context for
> inheritance, then later, when we want to compare inherited contexts we
> can simply compare generation numbers, if they're the same the contexts
> are the same.

Ah right.

> > >  }
> > >  
> > >  static void perf_group_detach(struct perf_event *event)
> > > @@ -1228,6 +1231,12 @@ void perf_event_context_sched_out(struct
> > >  	if (!cpuctx->task_ctx)
> > >  		return;
> > >  
> > > +#if 0
> > > +	/*
> > > +	 * Need to sort out how to make task_struct::perf_tp_idr
> > > +	 * work with this fancy switching stuff.. tracepoints could be
> > > +	 * in multiple contexts due to the software event muck.
> > > +	 */
> > 
> > Not sure what's the issue here. Each ctx have the perf_tp_idr matching
> > active tracepoints, isn't it?
> 
> No, there's only 1 idr per task. Having one per context means we have to
> iterate all contexts when a tracepoint triggers and it adds yet another
> pointer chase. It also means we have to manage more stuff when
> tracepoints change context etc..
> 
> But yes, it would make this part easier, I just don't like the added
> fast path overhead.

Ok.
