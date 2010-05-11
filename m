Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab0EKS55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:57:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46421 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0EKS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:57:55 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=V1EeE3CHaDgA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=b8VgSBC0AAAA:8 a=VwQbUJbxAAAA:8 a=uWRYUrwWJtbqfdxOXWoA:9 a=dRj9ZR6ZrYutbkgz4ngA:7 a=P4y4fnqBvaOM0xMkckkjG8xmlSwA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100511182022.826921702@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 11 May 2010 14:20:22 -0400
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
Subject: [PATCH 00/10] [GIT PULL] tracing: Lowering the footprint of TRACE_EVENTs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Final version! ]

Ingo,

This also affects kprobes and perf.

At the Linux Collaboration Summit, I talked with Mathieu and others about
lowering the footprint of trace events. I spent all of last two weeks
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

With events and syscalls (82 events and 618 syscalls), before this
patch series, the size of vmlinux was: 6863829, and afterward: 6768675.

That is 95,154 bytes in savings! (over 92K)

Note: I did this series with disabling KERNEL_DEBUG and that made
 the effect of savings smaller. The original numbers with KERNEL_DEBUG
 options enabled was: orinal-16161794, new-16058182, savings-103612
 which was over 100K) This may still be true with KERNEL_DEBUG enabled
 but I only tried it this time with it disabled.

 But if I go by percentage, this series saves 1.38% where the
 KERNEL_DEBUG series only saved 0.64% of the total vmlinux image.

 Config for this run can be found here:
  http://rostedt.homelinux.com/config-size

Without tracing syscalls (82 events), it brought the size of vmlinux
down from 6617121 to 659870.

18,421 bytes in savings.

Note: Original numbers with KERNEL_DEBUG options enabled:
 original-1591046, new-15888394, savings-22071

Final changes:

 o  Updated the change logs to reflect the sizes with KERNEL_DEBUG
    disabled.

 o  Added Mathieu Desnoyers's Acked-by to the change logs.

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

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


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
