Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1IWMYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:24:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab1IWMYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:24:39 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=pPwHPQqvJkcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=qts_dfAlhfRuTEoZlAoA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH 19/21] tracing: Account for preempt off in
 preempt_schedule()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1316776936.9084.5.camel@twins>
References: <20110922220935.537134016@goodmis.org>
	 <20110922221029.678324653@goodmis.org>  <1316775648.9084.1.camel@twins>
	 <1316776749.29966.156.camel@gandalf.stny.rr.com>
	 <1316776936.9084.5.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 23 Sep 2011 08:24:36 -0400
Message-ID: <1316780676.29966.184.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 13:22 +0200, Peter Zijlstra wrote:
> On Fri, 2011-09-23 at 07:19 -0400, Steven Rostedt wrote:
> 
> > What would you suggest? Just ignore the latencies that schedule
> > produces, even though its been one of the top causes of latencies?
> 
> I would like to actually understand the issue first.. so far all I've
> got is confusion.

Simple. The preemptoff and even preemptirqsoff latency tracers record
every time preemption is disabled and enabled. For preemptoff, this only
includes modification of the preempt count. For preemptirqsoff, it
includes both preempt count increment and interrupts being
disabled/enabled.


Currently, the preempt check is done in add/sub_preempt_count(). But in
preempt_schedule() we call add/sub_preempt_count_notrace() which updates
the preempt_count directly without any of the preempt off/on checks.

The changelog I referenced talked about why we use the notrace versions.
Some function tracing hooks use the preempt_enable/disable_notrace().
Function tracer is not the only user of the function tracing facility.
With the original preempt_diable(), when we have preempt tracing
enabled, the add/sub_preempt_count()s become traced by the function
tracer (which is also a good thing as I've used that info). The issue is
in preempt_schedule() which is called by preempt_enable() if
NEED_RESCHED is set and PREEMPT_ACTIVE is not set. One of the first
things that preempt_schedule() does is call
add_preempt_count(PREEMPT_ACTIVE), to add the PREEMPT_ACTIVE to preempt
count and not come back into preempt_schedule() when interrupted again.

But! If add_preempt_count(PREEPMT_ACTIVE) is traced, we call into the
function tracing mechanism *before* it adds PREEMPT_ACTIVE, and when the
function hook calls preempt_enable_notrace() it will notice the
NEED_RESCHED set and PREEMPT_ACTIVE not set and recurse back into the
preempt_schedule() and boom!

By making preempt_schedule() use notrace we avoid this issue with the
function tracing hooks, but in the mean time, we just lost the check
that preemption was disabled. Since we know that preemption and
interrupts were both enabled before calling into preempt_schedule()
(otherwise it is a bug), we can just tell the latency tracers that
preemption is being disabled manually with the
start/stop_critical_timings(). Note, these function names comes from the
original latency_tracer that was in -rt.

There's another location in the kernel that we need to manually call
into the latency tracer and that's in idle. The cpu_idle() calls
disables preemption then disables interrupts and may call some assembly
instruction that puts the system into idle but wakes up on interrupts.
Then on return, interrupts are enabled and preemption is again enabled.

Since we don't know about this wakeup on interrupts, the latency tracers
would count this idle wait as a latency, which obviously is not what we
want. Which is where the start/stop_critical_timings() was created for.
The preempt_schedule() case is similar in an opposite way. Instead of
not wanting to trace, we want to trace, and the code works for this
location too.

-- Steve


