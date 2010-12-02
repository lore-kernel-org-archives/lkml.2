Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab0LBWsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:48:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43282 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab0LBWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:48:17 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=mj4VcQyPWysA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=-IMD-OhX-f2QkI05OmwA:9 a=ugEEesLZa_FcQ_Nkldz_5fCH_UQA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101202223654.596106888@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 17:36:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [RFC][PATCH 0/2] tracing: Add conditional to tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an RFC that adds the TP_CONDITION() to the TRACE_EVENT()
code.

There are certain cases that a tracepoint only makes sense if
a specific condition is met. But because we do not want to dirty
the fast path (the non tracing case) with if statements that are
there only to avoid tracing, we just pass the condition variables
to the tracepoint, and let the user filter them out if needed.

A perfect example is the tracepoint sched_wakeup. It traces all
calls to try_to_wake_up() even if it fails to wake up. But if we add:

	if (success)
		trace_sched_wakeup(p);

We have that "if (success)" tested for every time we call try_to_wake_up().
Even when tracing is not (or never will be) enabled.

This patch set adds a variant TRACE_EVENT_CONDITIONAL()
(and DECLARE_EVENT_CLASS_CONDITIONAL()) that has a "cond" argument.
This argument is encapsulated with "TP_CONDITIONAL()" which turns into:

	if (!cond)
		return;

This is placed inside the called tracepoint routine, and is only tested
when the trace is enabled. Otherwise it is a nop as tracepoints normally
are when disabled.

Note, another variant of this, is to move the test directly into the
_DO_TRACE() macro, and not call any registered event callbacks. This would
even speed it up faster when tracing is enabled. I did not do this
orginially because I just thought of it now as I wrote this change log ;-)
I'm posting this version now just in case people prefer it instead.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/trace-conditional


Steven Rostedt (2):
      tracing: Add TRACE_EVENT_CONDITIONAL()
      tracing: Only trace sched_wakeup if it actually work something up

----
 include/linux/tracepoint.h   |    3 ++
 include/trace/define_trace.h |    6 +++
 include/trace/events/sched.h |   12 +++---
 include/trace/ftrace.h       |   70 +++++++++++++++++++++++++++++++----------
 4 files changed, 68 insertions(+), 23 deletions(-)
