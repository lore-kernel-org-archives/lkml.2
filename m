Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab0EKDJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:09:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab0EKDJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:09:12 -0400
X-Authority-Analysis: v=1.1 cv=OMZqYO3L41gFG4eI735GctFZkIqa2t9YKv4cWfI71LE= c=1 sm=0 a=4KIbQ352WcsA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=mItTUIqUFLtxEDWy9KgA:9 a=doIA_4OYt687OB3PRRwA:7 a=mmhA87gRa3sEwkCPNf43Mvr9V0YA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100511030020.837892321@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 May 2010 23:00:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 00/10 -v3][RFC] tracing: Lowering the footprint of TRACE_EVENTs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Version 3]

OK, this should be my final RFC release. If there are no complaints
about this one, I'll post it as an official git pull.

This also affecs kprobes and perf.

At the Linux Collaboration Summit, I talked with Mathieu and others about
lowering the footprint of trace events. I spent all of last week
trying to get the size as small as I could.

Currently, each TRACE_EVENT() macro adds 1 - 5K per tracepoint. I got various
results by adding a TRACE_EVENT() with the compiler, depending on
config options that did not seem related. The new tracepoint I added
would add between 1 and 5K, but I did not investigate enough to
see what the true size was.

What was consistent, was the DEFINE_EVENT(). Currently, it adds
a little over 700 bytes per DEFINE_EVENT().

This patch series does not seem to affect TRACE_EVENT() much (had
the same various sizes), but consistently brings DEFINE_EVENT()s
down from 700 bytes to 250 bytes per DEFINE_EVENT(). Since syscalls
use one "class" and are equivalent to DEFINE_EVENT() this can
be a significant savings.

With events and syscalls (82 events and 616 syscalls), before this
patch series, the size of vmlinux was: 16161794, and afterward: 16058182.

That is 103,612 bytes in savings! (over 100K)


Without tracing syscalls (82 events), it brought the size of vmlinux
down from 1591046 to 15888394.

22,071 bytes in savings.

This is just an RFC (for now), to get peoples opinions on the changes.
It does a bit of rewriting of the CPP macros, just to warning you ;-)

Changes in v3:

 o  Ported to latest tip/tracing/core

 o  Fixed typo in change log that a comment in LWN noticed:
    Wrote: 15999394 when it should have been 15888394.
    (Note: these numbers are from the original posting. I need to
     redo them again before posting officially).

 o  Added Mathieu Desnoyers's check_trace patch that will check
    the callback to make sure it matches what DECLARE_TRACE() expects
    it.

 o  Added the check_trace to the ftrace and perf callback probes.
    Note, kprobes and syscalls do not use the register tracepoint
    so they are not affected.

 o  Moved the define of DECLARE_TRACE() and DECLARE_TRACE_NOARGS()
    out of the #ifdef CONFIG_TRACEPOINTS, since they were the same
    whether or not CONFIG_TRACEPOINTS was enabled. The internal
    __DECLARE_TRACE() changed.

Changes in v2:

 o  Ported to latest tip/tracing/core

 o  Removed DECLARE_TRACE_DATA() and made DECLARE_TRACE() have
    the ability to pass a data parameter. This makes DECLARE_TRACE()
    not work with no args. A new DECLARE_TRACE_NOARGS() has been created
    that also allows data to be passed, but does is for tracepoint(void).

 o  Made the callbacks be "proto, void *data" and typecast the data
    within the function.


-- Steve

The code can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/rfc-1


Mathieu Desnoyers (1):
      tracepoints: Add check trace callback type

Steven Rostedt (9):
      tracing: Create class struct for events
      tracing: Let tracepoints have data passed to tracepoint callbacks
      tracing: Remove per event trace registering
      tracing: Move fields from event to class structure
      tracing: Move raw_init from events to class
      tracing: Allow events to share their print functions
      tracing: Move print functions into event class
      tracing: Remove duplicate id information in event structure
      tracing: Combine event filter_active and enable into single flags field

----
 include/linux/ftrace_event.h                   |   73 ++++++--
 include/linux/syscalls.h                       |   57 ++----
 include/linux/tracepoint.h                     |   98 ++++++++---
 include/trace/ftrace.h                         |  233 +++++++++---------------
 include/trace/syscall.h                        |   10 +-
 kernel/trace/blktrace.c                        |  138 ++++++++------
 kernel/trace/ftrace.c                          |    7 +-
 kernel/trace/kmemtrace.c                       |   70 +++++---
 kernel/trace/trace.c                           |    9 +-
 kernel/trace/trace.h                           |    5 +-
 kernel/trace/trace_event_perf.c                |   17 ++-
 kernel/trace/trace_events.c                    |  131 +++++++++-----
 kernel/trace/trace_events_filter.c             |   28 ++--
 kernel/trace/trace_export.c                    |   16 +-
 kernel/trace/trace_functions_graph.c           |   13 +-
 kernel/trace/trace_kprobe.c                    |  104 +++++++----
 kernel/trace/trace_output.c                    |  137 ++++++++++-----
 kernel/trace/trace_output.h                    |    2 +-
 kernel/trace/trace_sched_switch.c              |   23 ++-
 kernel/trace/trace_sched_wakeup.c              |   27 ++--
 kernel/trace/trace_syscalls.c                  |  137 ++++++++++++---
 kernel/trace/trace_workqueue.c                 |   26 ++-
 kernel/tracepoint.c                            |   91 +++++----
 samples/tracepoints/tp-samples-trace.h         |    4 +-
 samples/tracepoints/tracepoint-probe-sample.c  |   13 +-
 samples/tracepoints/tracepoint-probe-sample2.c |    7 +-
 26 files changed, 879 insertions(+), 597 deletions(-)
