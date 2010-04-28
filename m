Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0D1USN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:18:13 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:62043 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757002Ab0D1USI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:18:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHIv2EtGGNqG/2dsb2JhbACceHK+SIUOBA
Date: Wed, 28 Apr 2010 16:18:04 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/10][RFC] tracing: Lowering the footprint of
	TRACE_EVENTs
Message-ID: <20100428201804.GA8591@Krystal>
References: <20100426195024.256424113@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100426195024.256424113@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:14:11 up 21 days,  6:07,  4 users,  load average: 0.31, 0.24,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> This is an RFC patch set that also affects kprobes and perf.

Hi Steven,

> 
> At the Linux Collaboration Summit, I talked with Mathieu and others about
> lowering the footprint of trace events. I spent all of last week
> trying to get the size as small as I could.
> 
> Currently, each TRACE_EVENT() macro adds 1 - 5K per tracepoint. I got various
> results by adding a TRACE_EVENT() with the compiler, depending on
> config options that did not seem related. The new tracepoint I added
> would add between 1 and 5K, but I did not investigate enough to
> see what the true size was.

Adding only one might not give an accurate picture, as some sections can
be aligned on 4k boundaries. So if the added TRACE_EVENT() brings you to
the next 4k page, your added size is bumped of an extra 4k.

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
> With events and syscalls (82 events and 616 syscalls), before this
> patch series, the size of vmlinux was: 16161794, and afterward: 16058182.
> 
> That is 103,612 bytes in savings! (over 100K)
> 
> 
> Without tracing syscalls (82 events), it brought the size of vmlinux
> down from 1591046 to 15999394.

Probably a cut n paste error on the line above. Should read:

down from 16021465 to 15999394.

if you want the "22071 bytes in savings" to hold.

Will look over your patchset.

Thanks,

Mathieu

> 
> 22,071 bytes in savings.
> 
> This is just an RFC (for now), to get peoples opinions on the changes.
> It does a bit of rewriting of the CPP macros, just to warning you ;-)
> 
> -- Steve
> 
> The code can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/rfc-1
> 
> 
> Steven Rostedt (10):
>       tracing: Create class struct for events
>       tracing: Let tracepoints have data passed to tracepoint callbacks
>       tracing: Convert TRACE_EVENT() to use the DECLARE_TRACE_DATA()
>       tracing: Remove per event trace registering
>       tracing: Move fields from event to class structure
>       tracing: Move raw_init from events to class
>       tracing: Allow events to share their print functions
>       tracing: Move print functions into event class
>       tracing: Remove duplicate id information in event structure
>       tracing: Combine event filter_active and enable into single flags field
> 
> ----
>  include/linux/ftrace_event.h         |   71 +++++++++---
>  include/linux/syscalls.h             |   55 +++-------
>  include/linux/tracepoint.h           |  119 ++++++++++++++++---
>  include/trace/ftrace.h               |  215 ++++++++++------------------------
>  include/trace/syscall.h              |    9 +-
>  kernel/trace/blktrace.c              |   13 ++-
>  kernel/trace/kmemtrace.c             |   28 +++--
>  kernel/trace/trace.c                 |    9 +-
>  kernel/trace/trace.h                 |    5 +-
>  kernel/trace/trace_event_perf.c      |   17 ++-
>  kernel/trace/trace_events.c          |  126 +++++++++++++-------
>  kernel/trace/trace_events_filter.c   |   28 +++--
>  kernel/trace/trace_export.c          |   16 ++-
>  kernel/trace/trace_functions_graph.c |    2 +-
>  kernel/trace/trace_kprobe.c          |  104 ++++++++++-------
>  kernel/trace/trace_output.c          |  137 +++++++++++++++-------
>  kernel/trace/trace_output.h          |    2 +-
>  kernel/trace/trace_syscalls.c        |  105 +++++++++++++++--
>  kernel/tracepoint.c                  |   91 ++++++++-------
>  19 files changed, 700 insertions(+), 452 deletions(-)
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
