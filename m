Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1IWOBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:01:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:33599 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab1IWOBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:01:21 -0400
Subject: Re: [PATCH 19/21] tracing: Account for preempt off in
 preempt_schedule()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 23 Sep 2011 16:00:51 +0200
In-Reply-To: <1316780676.29966.184.camel@gandalf.stny.rr.com>
References: <20110922220935.537134016@goodmis.org>
	 <20110922221029.678324653@goodmis.org>  <1316775648.9084.1.camel@twins>
	 <1316776749.29966.156.camel@gandalf.stny.rr.com>
	 <1316776936.9084.5.camel@twins>
	 <1316780676.29966.184.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316786451.9084.41.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 08:24 -0400, Steven Rostedt wrote:
> On Fri, 2011-09-23 at 13:22 +0200, Peter Zijlstra wrote:
> > On Fri, 2011-09-23 at 07:19 -0400, Steven Rostedt wrote:
> > 
> > > What would you suggest? Just ignore the latencies that schedule
> > > produces, even though its been one of the top causes of latencies?
> > 
> > I would like to actually understand the issue first.. so far all I've
> > got is confusion.
> 
> Simple. The preemptoff and even preemptirqsoff latency tracers record
> every time preemption is disabled and enabled. For preemptoff, this only
> includes modification of the preempt count. For preemptirqsoff, it
> includes both preempt count increment and interrupts being
> disabled/enabled.

Simple, except for this blob below..

> Currently, the preempt check is done in add/sub_preempt_count(). But in
> preempt_schedule() we call add/sub_preempt_count_notrace() which updates
> the preempt_count directly without any of the preempt off/on checks.
> 
> The changelog I referenced talked about why we use the notrace versions.

Which is the important bit, because that's icky and obviously buggy
(otherwise you wouldn't need to fix it), so one cannot judge the fix
without understanding the initial problem. 

> Some function tracing hooks use the preempt_enable/disable_notrace().

That's pretty much a non-statement in that it doesn't explain anything.

> Function tracer is not the only user of the function tracing facility.

So what?!

> With the original preempt_diable(), when we have preempt tracing
> enabled, the add/sub_preempt_count()s become traced by the function
> tracer (which is also a good thing as I've used that info). 

Why and how? It would seem to me marking those notrace would cure some
of the issues.

> The issue is
> in preempt_schedule() which is called by preempt_enable() if
> NEED_RESCHED is set and PREEMPT_ACTIVE is not set. One of the first
> things that preempt_schedule() does is call
> add_preempt_count(PREEMPT_ACTIVE), to add the PREEMPT_ACTIVE to preempt
> count and not come back into preempt_schedule() when interrupted again.

That sentence doesn't really parse for me, but I think you mean to say
that PREEMPT_ACTIVE guards against recursive preemption?

> But! If add_preempt_count(PREEPMT_ACTIVE) is traced, we call into the
> function tracing mechanism *before* it adds PREEMPT_ACTIVE, and when the
> function hook calls preempt_enable_notrace() it will notice the
> NEED_RESCHED set and PREEMPT_ACTIVE not set and recurse back into the
> preempt_schedule() and boom!

Right, so you've got the mess that there's two different notrace options
for the {add,sub}_preempt_count(). One is not doing the
trace_preempt_{off,on} thing, and one is marking the function notrace.

The normal {add,sub}_preempt_count() muck does everything, the
_notrace() one doesn't do either, and here you need one that does one
but not the other.

So you then open code things, but instead of using
trace_preempt_{off,on} you use {start,stop}_critical_timings(), which is
a totally different beast, confusing matters more.

What's worse, there's not a single comment near preempt_schedule()
explaining any of this mess.

> By making preempt_schedule() use notrace we avoid this issue with the
> function tracing hooks, but in the mean time, we just lost the check
> that preemption was disabled.

Uhm, no, by marking preempt_schedule() notrace you don't call into the
function tracer for this call. The preemption check was lost by using
the _notrace() preempt_count fiddling.

Hiding preempt_schedule() from the function tracer isn't exactly nice
though. Although I think we can reconstruct it was called by seeing
schedule() called and seeing N set (except of course that the default
function tracer output doesn't show that (one more reason the the
default output format is broken).

>  Since we know that preemption and
> interrupts were both enabled before calling into preempt_schedule()
> (otherwise it is a bug), we can just tell the latency tracers that
> preemption is being disabled manually with the
> start/stop_critical_timings(). Note, these function names comes from the
> original latency_tracer that was in -rt.

Doesn't matter where they come from, they're still confusing for anybody
trying to make sense of the {add,sub}_preempt_count vs &_notrace
functions.

> There's another location in the kernel that we need to manually call
> into the latency tracer and that's in idle. The cpu_idle() calls
> disables preemption then disables interrupts and may call some assembly
> instruction that puts the system into idle but wakes up on interrupts.
> Then on return, interrupts are enabled and preemption is again enabled.

> Since we don't know about this wakeup on interrupts, the latency tracers
> would count this idle wait as a latency, which obviously is not what we
> want. Which is where the start/stop_critical_timings() was created for.
> The preempt_schedule() case is similar in an opposite way. Instead of
> not wanting to trace, we want to trace, and the code works for this
> location too.

Wouldn't it be much more sensible to mark all that preempt/irq fiddling
in the idle path with _notrace instead? And stick a comment near.

Having two things to do the same thing just doesn't make sense.

