Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab0LDCbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 21:31:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52435 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab0LDCbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 21:31:43 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=ERE9BSCttyQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=ToJ5R8-vIOH6_0CJYEUA:9 a=u8pGRSdO-Cly7ZbCS7ac4KKnKL0A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101204021744.521599148@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 03 Dec 2010 21:17:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 0/4] [GIT PULL] tracing: Harry Potter and the Deathly Macros
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This pull request is for 2.6.38.

The first two patches are boring and are just some updates for tracing.

But the second two patches are the Deathly Macros.

The first of the two is the Macro of Invisibility. Not really anything
to worry about. It adds the TP_CONDITION() which allows a tracepoint
to "hide" unwanted traces nicely. If the condition is not met, that
tracepoint will not be traced. Also, the "if" statement is outside
the fast path and is only hit during actual tracing (not there when
tracing is disabled).

The second patch is the Macro of Resurrection. It is resurrecting
the debate about stable tracepoints and if current tracepoints may change.
This patch uses the first patch to only trace the wakeup tracepoint
if it succeeds to actually wake something up. This makes the
"success" field in the tracepoint redundant and it seems silly to
keep it there. It wastes space in the buffers and adds a slight overhead
just to record it. But this wasted space is more of an issue than
the overhead.

Now if we change this, it may break tools that analyze the wakeup
tracepoint and checks the "success" field to know if it should
ignore it or not. Any tools that do this should have tested to
see if that field was there and if not assume the wakeup succeeded.

If we had the Macro of Invinicibility (true stable events), then
this would not be an issue for us. But unfortunately, the Macro of
Invincibility is not here, and is probably buried somewhere
with an old gay wizard.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (3):
      tracing/events: Show real number in array fields
      tracing: Add TRACE_EVENT_CONDITIONAL()
      tracing: Only trace sched_wakeup if it actually work something up

Wu Zhangjin (1):
      ftrace: Speed up recordmcount

----
 include/linux/ftrace_event.h |    4 ++++
 include/linux/tracepoint.h   |   29 +++++++++++++++++++++++------
 include/trace/define_trace.h |   15 +++++++++++++++
 include/trace/events/sched.h |   16 ++++++++--------
 include/trace/ftrace.h       |   14 ++++++++++----
 kernel/trace/trace_events.c  |    6 ++++++
 kernel/trace/trace_export.c  |   14 ++++++++++----
 scripts/Makefile.build       |   13 +++++++++----
 8 files changed, 85 insertions(+), 26 deletions(-)

