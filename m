Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab0KQA7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:59:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42678 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab0KQA7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:59:41 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=OMjBytS-4nIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=YhI5LnOVfFmIUZmwXNgA:9 a=XVE_omnNDlfU8NuHjEsA:7 a=m5DyE9ssCDCDCSMDpiMGGy-8dM4A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101117005357.024472450@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Nov 2010 19:53:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 0/5] tracing/events: stable tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ RFC ONLY - Not for inclusion ]

As discussed at Kernel Summit, there was some issues about what to
do with tracepoints.

Basically, anyone, anywhere, any developer, can create a tracepoint
and have it appear in /sys/kernel/debug/tracing/events/...

These events automatically appear in both perf and ftrace as events.
And any tool can tap into them. That's where the problem rises.

What happens when a tool starts to depend on a tracepoint?
Will that tracepoint always be there? Will it ever change?

The problem also extends to the fact that we can't guarantee that
tracepoints will stay as is. There are literally hundreds of
tracepoints, and they are used by developers to have in field
debugging tools. As the kernel changes, so will these tracepoints.
A developer can use these to ask a customer that has run into some
problem to enable a trace and send the developer back the trace
so they can go off and analyze it.

But for tools, this is a different story. They want and depend on
a tracepoint to be stable. If it changes under them, then it makes
tracepoints completely useless for tools.

This patch series is a start and RFC for the creation of
stable tracepoints. I will now call the current tracepoints raw
or in-field-debugging tracepoints or events. What I call stable tracepoints
are those that are to answer questions about the OS and not for
a developer to debug their code.

What I propose is to create a new format and a new filesystem called
eventfs. Like debugfs, when enabled, a directory will be created:

  /sys/kernel/events

Which would be the normal place to mount the eventfs filesystem.

The old format for events looked like this:

$ cat /debug/tracing/events/sched/sched_switch/format 
name: sched_switch
ID: 57
format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;
	field:int common_lock_depth;	offset:8;	size:4;	signed:1;

	field:char prev_comm[TASK_COMM_LEN];	offset:12;	size:16;	signed:1;
	field:pid_t prev_pid;	offset:28;	size:4;	signed:1;
	field:int prev_prio;	offset:32;	size:4;	signed:1;
	field:long prev_state;	offset:40;	size:8;	signed:1;
	field:char next_comm[TASK_COMM_LEN];	offset:48;	size:16;	signed:1;
	field:pid_t next_pid;	offset:64;	size:4;	signed:1;
	field:int next_prio;	offset:68;	size:4;	signed:1;

print fmt: "prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s ==> next_comm=%s next_pid=%d next_prio=%d", REC->prev_comm, REC->prev_pid, REC->prev_prio, REC->prev_state ? __print_flags(REC->prev_state, "|", { 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" }, { 16, "Z" }, { 32, "X" }, { 64, "x" }, { 128, "W" }) : "R", REC->next_comm, REC->next_pid, REC->next_prio


The "common" fields were ftrace (and because perf attached to it, also perf)
specific. Also the size is in bytes, which would limit the ability
to use bit fields. We also don't know about arch specific alignment
that may be needed to write to these fields.

We also have name (redundant), ID (should be agnostic), and print_fmt
(lots of issues).

So the new format looks like this:

[root@bxf ~]# cat /sys/kernel/event/sched_switch/format 
	array:prev_comm	type:char	size:8	count:16	align:1	signed:1;
	field:prev_pid	type:pid_t	size:32	align:4	signed:1;
	field:prev_state	type:char	size:8	align:1	signed:1;
	array:next_comm	type:char	size:8	count:16	align:1	signed:1;
	field:next_pid	type:pid_t	size:32	align:4	signed:1;


Some notes:

o  The size is in bits.
o  We added an align, that is the natural alignment for the arch of that
   type.
o  We added an "array" type, that specifies the size of an element as
   well as a "count", where total size can be align(size) * count.
o  We separated the field name from the type.

Not in this series, but for future (after we agree on all this) I would
like to move the raw tracepoints into /debug/events/... and have the
same format as here.

This patch series uses some of the same tricks as the TRACE_EVENT() code.
It has magic macros to do all the redundant code. But it has a bit
of manual work.

Right now, when a STABLE_EVENT() is created, the format appears.
But nothing hooks into it yet. perf, trace, or ftrace could register
a handle that is created, either manually, or it can use the same
magic macro tricks to automate all the stable events. The design has
been made to allow for that too.

The last two patches create two stable tracepoints. sched_switch
and sched_migrate_task (for examples as well as to get the ball rolling).
As you may have already noticed, there is currently no hierarchy with
the stable events. We want to limit the # of stable events, as they
should only be created to help answer general questions about the OS.
All events reside at the top layer of the eventfs filesystem.
(I do not plan on doing this for the raw events though).

Another note is that all stable events need a corresponding raw event.
The raw event does not need to be of the same format as the stable
event, it just needs to provide all the information that the stable
event needs, but the raw event may supply much more. This should
not be a problem, since the tracepoint that represents a stable event
should, by definition, always be stable :-)

Because the stable events piggy back on top of the raw events, the
trace_...() function in the kernel can be used by both. No changes
are needed there. As long as there's already a tracepoint
represented by a raw event, a stable event can be placed on top.

The raw event may change at anytime, as long as it always supplies
the stable event with what is needed. It will require the hooks
between them to be updated. The way tracepoints work, if they become
out of sync, the code will fail to compile.

Time to get out the hose!

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/events


Steven Rostedt (5):
      events: Add EVENT_FS the event filesystem
      tracing/events: Add code to (un)register stable events
      tracing/events: Add infrastructure to show stable event formats
      tracing/events: Add stable event sched_switch
      tracing/events: Add sched_migrate_task stable event

----
 fs/Kconfig                   |    6 +
 fs/Makefile                  |    1 +
 fs/eventfs/Makefile          |    4 +
 fs/eventfs/file.c            |   53 +++++
 fs/eventfs/inode.c           |  433 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/eventfs.h      |   83 ++++++++
 include/linux/magic.h        |    3 +-
 include/trace/stable.h       |   72 +++++++
 include/trace/stable/sched.h |   33 ++++
 include/trace/stable_list.h  |    3 +
 kernel/Makefile              |    1 +
 kernel/events/Makefile       |    1 +
 kernel/events/event_format.c |   74 +++++++
 kernel/events/event_format.h |   64 ++++++
 kernel/events/event_reg.h    |   79 ++++++++
 kernel/events/events.c       |   48 +++++
 kernel/trace/Kconfig         |    1 +
 17 files changed, 958 insertions(+), 1 deletions(-)
