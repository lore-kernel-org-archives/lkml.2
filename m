Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958Ab0EDDmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 23:42:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab0EDDmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 23:42:06 -0400
X-Authority-Analysis: v=1.1 cv=tamp8Om8S85MB4Qj1n2yU9kNzNdU9gdJUe8fX0YwrYg= c=1 sm=0 a=KmS4ZcvDDqsA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=a1hWv7aLrA7bs-OAbi0A:9 a=LpWmBTB0mZv123VX9NAA:7 a=ekEPK3CHHhgDdJTIwSzutQ9nnzkA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100504034045.085822814@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 03 May 2010 23:40:45 -0400
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
Subject: [PATCH 0/9 - v2][RFC] tracing: Lowering the footprint of TRACE_EVENTs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Version 2]

This is an RFC patch set that also affects kprobes and perf.

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
down from 1591046 to 15999394.

22,071 bytes in savings.

This is just an RFC (for now), to get peoples opinions on the changes.
It does a bit of rewriting of the CPP macros, just to warning you ;-)

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
 include/linux/ftrace_event.h           |   73 ++++++++---
 include/linux/syscalls.h               |   57 +++------
 include/linux/tracepoint.h             |   94 +++++++++++---
 include/trace/ftrace.h                 |  218 ++++++++++----------------------
 include/trace/syscall.h                |   10 +-
 kernel/trace/blktrace.c                |   13 ++-
 kernel/trace/kmemtrace.c               |   28 +++--
 kernel/trace/trace.c                   |    9 +-
 kernel/trace/trace.h                   |    5 +-
 kernel/trace/trace_event_perf.c        |   17 ++-
 kernel/trace/trace_events.c            |  131 ++++++++++++-------
 kernel/trace/trace_events_filter.c     |   28 +++--
 kernel/trace/trace_export.c            |   16 ++-
 kernel/trace/trace_functions_graph.c   |   13 ++-
 kernel/trace/trace_kprobe.c            |  104 +++++++++------
 kernel/trace/trace_output.c            |  137 ++++++++++++++-------
 kernel/trace/trace_output.h            |    2 +-
 kernel/trace/trace_syscalls.c          |  113 +++++++++++++++--
 kernel/tracepoint.c                    |   91 ++++++++------
 samples/tracepoints/tp-samples-trace.h |    4 +-
 20 files changed, 697 insertions(+), 466 deletions(-)
