Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab0LCEIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 23:08:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51150 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410Ab0LCEIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 23:08:24 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=I6tHtAtiSkgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=R05is4XlUSo2y7uVi0cA:9 a=7d66lCB-1X3P-1VXTOK_DBobTXMA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101203040358.955427199@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 23:03:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [RFC][PATCH 0/2 v2] tracing: Add conditional to tracepoints
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
(and DEFINE_EVENT_CONDITIONAL()) that has a "cond" argument.
This argument is encapsulated with "TP_CONDITIONAL()" which turns into:

        if (!cond)
                return;

What's new with this version?

This version adds this if statement to __DO_TRACE(). As it is
in a static inline function, the return still applies.

Also, since the shortcut is made before the callbacks, the test
is at the call site. This means that you can have a DECLARE_EVENT_CLASS()
where one of its DEFINE_EVENTS() is normal and the other is a
DEFINE_EVENT_CONDITION().

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/trace-conditional-v2


Steven Rostedt (2):
      tracing: Add TRACE_EVENT_CONDITIONAL()
      tracing: Only trace sched_wakeup if it actually work something up

----
 include/linux/tracepoint.h   |   29 +++++++++++++++++++++++------
 include/trace/define_trace.h |   15 +++++++++++++++
 include/trace/events/sched.h |   16 ++++++++--------
 3 files changed, 46 insertions(+), 14 deletions(-)
