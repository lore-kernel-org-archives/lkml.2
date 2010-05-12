Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab0ELVSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:18:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab0ELVSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:18:23 -0400
Message-ID: <4BEB1ADC.4020303@redhat.com>
Date: Wed, 12 May 2010 17:17:16 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/10 final] tracing: Lowering the footprint of TRACE_EVENTs
References: <20100512152810.819338250@goodmis.org>
In-Reply-To: <20100512152810.819338250@goodmis.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> [ Final final version! ]
> 
> Ingo,
> 
> This also affects kprobes and perf.

At least, kprobes part is good to me. :)
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you!

> 
> At the Linux Collaboration Summit, I talked with Mathieu and others about
> lowering the footprint of trace events. I spent all of last two weeks
> trying to get the size as small as I could.
> 
> Currently, each TRACE_EVENT() macro adds 1 - 5K per tracepoint. I got various
> results by adding a TRACE_EVENT() with the compiler, depending on
> config options that did not seem related. The new tracepoint I added
> would add between 1 and 5K, but I did not investigate enough to
> see what the true size was.
> 
> What was consistent, was the DEFINE_EVENT(). Currently, it adds
> a little over 700 bytes per DEFINE_EVENT().
> 
> This patch series does not seem to affect TRACE_EVENT() much (had
> the same various sizes), but consistently brings DEFINE_EVENT()s
> down from 700 bytes to 250 bytes per DEFINE_EVENT(). Since syscalls
> use one "class" and are equivalent to DEFINE_EVENT() this can
> be a significant savings.
> 
> With events and syscalls (82 events and 618 syscalls), before this
> patch series, the size of vmlinux was: 6863829, and afterward: 6768675.
> 
> That is 95,154 bytes in savings! (over 92K)
> 
> Note: I did this series with disabling KERNEL_DEBUG and that made
>  the effect of savings smaller. The original numbers with KERNEL_DEBUG
>  options enabled was: orinal-16161794, new-16058182, savings-103612
>  which was over 100K) This may still be true with KERNEL_DEBUG enabled
>  but I only tried it this time with it disabled.
> 
>  But if I go by percentage, this series saves 1.38% where the
>  KERNEL_DEBUG series only saved 0.64% of the total vmlinux image.
> 
>  Config for this run can be found here:
>   http://rostedt.homelinux.com/config-size
> 
> Without tracing syscalls (82 events), it brought the size of vmlinux
> down from 6617121 to 659870.
> 
> 18,421 bytes in savings.
> 
> Note: Original numbers with KERNEL_DEBUG options enabled:
>  original-1591046, new-15888394, savings-22071
> 
> Final final changes:
> 
>  o  Fixed trace_event.c self tests to use the probe field in the
>     structure to determine if the event should be tested.
>     (old regfunc no longer exists)
> 
>  o  Fixed missing ';' in static struct in macro.
> 
>  o  Fixed the trace register functions in net drop monitor to conform
>     with the new API.
> 
> Final changes:
> 
>  o  Updated the change logs to reflect the sizes with KERNEL_DEBUG
>     disabled.
> 
>  o  Added Mathieu Desnoyers's Acked-by to the change logs.
> 
> Changes in v3:
> 
>  o  Ported to latest tip/tracing/core
> 
>  o  Fixed typo in change log that a comment in LWN noticed:
>     Wrote: 15999394 when it should have been 15888394.
>     (Note: these numbers are from the original posting. I need to
>      redo them again before posting officially).
> 
>  o  Added Mathieu Desnoyers's check_trace patch that will check
>     the callback to make sure it matches what DECLARE_TRACE() expects
>     it.
> 
>  o  Added the check_trace to the ftrace and perf callback probes.
>     Note, kprobes and syscalls do not use the register tracepoint
>     so they are not affected.
> 
>  o  Moved the define of DECLARE_TRACE() and DECLARE_TRACE_NOARGS()
>     out of the #ifdef CONFIG_TRACEPOINTS, since they were the same
>     whether or not CONFIG_TRACEPOINTS was enabled. The internal
>     __DECLARE_TRACE() changed.
> 
> Changes in v2:
> 
>  o  Ported to latest tip/tracing/core
> 
>  o  Removed DECLARE_TRACE_DATA() and made DECLARE_TRACE() have
>     the ability to pass a data parameter. This makes DECLARE_TRACE()
>     not work with no args. A new DECLARE_TRACE_NOARGS() has been created
>     that also allows data to be passed, but does is for tracepoint(void).
> 
>  o  Made the callbacks be "proto, void *data" and typecast the data
>     within the function.
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Mathieu Desnoyers (1):
>       tracepoints: Add check trace callback type
> 
> Steven Rostedt (9):
>       tracing: Create class struct for events
>       tracing: Let tracepoints have data passed to tracepoint callbacks
>       tracing: Remove per event trace registering
>       tracing: Move fields from event to class structure
>       tracing: Move raw_init from events to class
>       tracing: Allow events to share their print functions
>       tracing: Move print functions into event class
>       tracing: Remove duplicate id information in event structure
>       tracing: Combine event filter_active and enable into single flags field
> 
> ----
>  include/linux/ftrace_event.h                   |   73 ++++++--
>  include/linux/syscalls.h                       |   57 ++----
>  include/linux/tracepoint.h                     |   98 ++++++++---
>  include/trace/ftrace.h                         |  237 +++++++++---------------
>  include/trace/syscall.h                        |   10 +-
>  kernel/trace/blktrace.c                        |  138 ++++++++------
>  kernel/trace/ftrace.c                          |    7 +-
>  kernel/trace/kmemtrace.c                       |   70 +++++---
>  kernel/trace/trace.c                           |    9 +-
>  kernel/trace/trace.h                           |    5 +-
>  kernel/trace/trace_event_perf.c                |   17 ++-
>  kernel/trace/trace_events.c                    |  137 +++++++++-----
>  kernel/trace/trace_events_filter.c             |   28 ++--
>  kernel/trace/trace_export.c                    |   16 +-
>  kernel/trace/trace_functions_graph.c           |   13 +-
>  kernel/trace/trace_kprobe.c                    |  104 +++++++----
>  kernel/trace/trace_output.c                    |  137 +++++++++-----
>  kernel/trace/trace_output.h                    |    2 +-
>  kernel/trace/trace_sched_switch.c              |   23 ++-
>  kernel/trace/trace_sched_wakeup.c              |   27 ++--
>  kernel/trace/trace_syscalls.c                  |  137 ++++++++++++---
>  kernel/trace/trace_workqueue.c                 |   26 ++-
>  kernel/tracepoint.c                            |   91 +++++----
>  net/core/drop_monitor.c                        |   12 +-
>  samples/tracepoints/tp-samples-trace.h         |    4 +-
>  samples/tracepoints/tracepoint-probe-sample.c  |   13 +-
>  samples/tracepoints/tracepoint-probe-sample2.c |    7 +-
>  27 files changed, 890 insertions(+), 608 deletions(-)


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
