Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab0LBXVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:21:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62898 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0LBXVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:21:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WDUQ3zuHHaXHpA0+KkCR7dBkH4rXU+5tqRVw46ErcPlIr3av8kd6L8GawsfTzUKA/c
         yvG6iFiWAacpU3rN8DEyk1LJD6rJepDjHVfi/tTNjBTSE4HOZMljdGsGV5C5TPfBtEEr
         0Tr2hdrSKVS1LDRx401yU7hSAgBpBC0nBwbjA=
Date: Fri, 3 Dec 2010 00:19:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [RFC][PATCH 0/2] tracing: Add conditional to tracepoints
Message-ID: <20101202231957.GB1639@nowhere>
References: <20101202223654.596106888@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202223654.596106888@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 05:36:54PM -0500, Steven Rostedt wrote:
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
> 	if (success)
> 		trace_sched_wakeup(p);
> 
> We have that "if (success)" tested for every time we call try_to_wake_up().
> Even when tracing is not (or never will be) enabled.
> 
> This patch set adds a variant TRACE_EVENT_CONDITIONAL()
> (and DECLARE_EVENT_CLASS_CONDITIONAL()) that has a "cond" argument.
> This argument is encapsulated with "TP_CONDITIONAL()" which turns into:
> 
> 	if (!cond)
> 		return;
> 
> This is placed inside the called tracepoint routine, and is only tested
> when the trace is enabled. Otherwise it is a nop as tracepoints normally
> are when disabled.
> 
> Note, another variant of this, is to move the test directly into the
> _DO_TRACE() macro, and not call any registered event callbacks. This would
> even speed it up faster when tracing is enabled. I did not do this
> orginially because I just thought of it now as I wrote this change log ;-)

Hehe :)

Yeah indeed. And that looks fairly possible.


> I'm posting this version now just in case people prefer it instead.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: rfc/trace-conditional
> 
> 
> Steven Rostedt (2):
>       tracing: Add TRACE_EVENT_CONDITIONAL()
>       tracing: Only trace sched_wakeup if it actually work something up
> 
> ----
>  include/linux/tracepoint.h   |    3 ++
>  include/trace/define_trace.h |    6 +++
>  include/trace/events/sched.h |   12 +++---
>  include/trace/ftrace.h       |   70 +++++++++++++++++++++++++++++++----------
>  4 files changed, 68 insertions(+), 23 deletions(-)
