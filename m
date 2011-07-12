Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1GLTDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:03:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55634 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab1GLTDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:03:05 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=MCqKf7WbFRsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=gegcIg_2A_rqngjKG-4A:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110712185131.698851699@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 12 Jul 2011 14:51:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 0/3] ftrace: entend notrace to notrace called functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On IRC, Thomas complained about the noise/signal ratio of useful
traced functions. Although several functions have been disabled via
notrace, these notrace functions tend to call other functions and
they get traced. Often times they confuse the trace because its hard
to know where these functions were called from.

Other times it is just that we really want to ignore functions
that have been marked with notrace, and we also don't care about
what functions they call.

The problem is that, unlike the function graph tracer, the function
tracer does not have the ability to know when a function has returned.
Knowing when a function has been called by a function marked as
notrace is not trivial, as a lot of notrace functions are completely
hidden to ftrace. Searching all functions to see if it is not marked
notrace would slow things down even more than the function graph tracer.

The trick I used was to use the function graph tracer's ret_stack,
to keep track of the call chain. By checking the parent against the
call chain, we can mostly get what functions belong at what depth,
and if a parent is not in the call chain, it may be a clue that the
parent was a notrace function. There's other times that a parent
may not be in the call chain (irqs, and top level calls), but
most of the time, we can figure it out.

Note, things called from assembly are just like being called by a
notrace function as assembly functions are not traced. For example
do_page_fault() and preempt_schedule() are both called from assembly
and can be skipped.

To enable this feature, just echo 1 into debug/tracing/options/extend-notrace

I also added a debug/tracing/options/extend-notrace-debug that inverses
what gets traced (things that would be ignored by extend-notrace would
be traced, and things that would be traced are not). This debug option
is a way to see what functions may be ignored by extend-notrace.

This is just a RFC, and was something that I tried to quickly write up
(although it took much longer than I wanted it too). As this was
a feature request from Thomas who happened to be using ftrace currently
as a real debug tool. And this would help him now.

But I'm leaving this as RFC for the time being and going back to working
on RT stuff and other things. Maybe I may get some time on libperf!

-- Steve


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
rfc/trace

Head SHA1: 0011c1566f498e410787fa1173148513153ec443


Steven Rostedt (3):
      ftrace: Make ret_stack usable by other than function graph
      ftrace: Add extend-notrace to not trace sub funcs of notrace funcs
      ftrace: Add extend-notrace-debug to see what is not traced

----
 include/linux/ftrace.h         |   38 ++++--
 include/linux/sched.h          |   16 ++-
 kernel/fork.c                  |    5 +-
 kernel/sched.c                 |    2 +-
 kernel/trace/ftrace.c          |  281 +++++++++++++++++++++++-----------------
 kernel/trace/trace.c           |    5 +
 kernel/trace/trace.h           |   11 ++
 kernel/trace/trace_functions.c |  163 +++++++++++++++++++++++-
 8 files changed, 380 insertions(+), 141 deletions(-)
