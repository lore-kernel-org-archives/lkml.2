Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab0LCOrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:47:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63923 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab0LCOrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:47:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oDi+Y0kywdIqEyJHqTHcu+pzpmHKSrqupQBwNSeUb1vDXQ1uGVKRft6ok4Lg89rBkE
         0NTSv2XmrcauvoblwXzYAuAno9qJk1F2NuRR0F5AN4blsoE9DuodNq/PJtCKxWp8bfke
         nGCP1itImQra/BSR5BmGFHCKzAayB6bQYJIuk=
Date: Fri, 3 Dec 2010 15:47:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [RFC][PATCH 0/2 v2] tracing: Add conditional to tracepoints
Message-ID: <20101203144720.GA1711@nowhere>
References: <20101203040358.955427199@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203040358.955427199@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 11:03:58PM -0500, Steven Rostedt wrote:
> This is an RFC that adds the TP_CONDITION() to the TRACE_EVENT()
> code.
> 
> There are certain cases that a tracepoint only makes sense if
> a specific condition is met. But because we do not want to dirty
> the fast path (the non tracing case) with if statements that are
> there only to avoid tracing, we just pass the condition variables
> to the tracepoint, and let the user filter them out if needed.
> 
> A perfect example is the tracepoint sched_wakeup. It traces all
> calls to try_to_wake_up() even if it fails to wake up. But if we add:
> 
>         if (success)
>                 trace_sched_wakeup(p);
> 
> We have that "if (success)" tested for every time we call try_to_wake_up().
> Even when tracing is not (or never will be) enabled.
> 
> This patch set adds a variant TRACE_EVENT_CONDITIONAL()
> (and DEFINE_EVENT_CONDITIONAL()) that has a "cond" argument.
> This argument is encapsulated with "TP_CONDITIONAL()" which turns into:
> 
>         if (!cond)
>                 return;
> 
> What's new with this version?
> 
> This version adds this if statement to __DO_TRACE(). As it is
> in a static inline function, the return still applies.
> 
> Also, since the shortcut is made before the callbacks, the test
> is at the call site. This means that you can have a DECLARE_EVENT_CLASS()
> where one of its DEFINE_EVENTS() is normal and the other is a
> DEFINE_EVENT_CONDITION().
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: rfc/trace-conditional-v2
> 
> 
> Steven Rostedt (2):
>       tracing: Add TRACE_EVENT_CONDITIONAL()
>       tracing: Only trace sched_wakeup if it actually work something up
> 
> ----
>  include/linux/tracepoint.h   |   29 +++++++++++++++++++++++------
>  include/trace/define_trace.h |   15 +++++++++++++++
>  include/trace/events/sched.h |   16 ++++++++--------
>  3 files changed, 46 insertions(+), 14 deletions(-)


Looks good

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

I suspect we'll need to fix some scripts/subperf commands in perf. Those that do:

	if (success)

tests after reading a trace from a wakeup event.
