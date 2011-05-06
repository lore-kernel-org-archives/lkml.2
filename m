Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1EFPrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 11:47:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab1EFPrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 11:47:42 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=PSrBKi5oSckA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=gEXOCKwQNvEARti_BIIA:9 a=lIZ5yIxBFCDuzwRUHb8A:7 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110506152624.776982312@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 11:26:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Jiri Olsa <jolsa@redhat.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>
Subject: [RFC][PATCH 00/13] ftrace: Allow multiple users to pick and choose functions to trace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo, et. al.

This is an RFC patch set of the work I did to allow multiple users
to pick and choose which functions they would like to trace without
being affected by other users (well, they are still affected, but
they can choose their own functions).

Since this rewrote a lot of the guts of ftrace's function handling
I broke it up into steps that I can sequentially think about how to
make the conversion. It also helped in understanding the changes that
had to be made.

The end result now has this:

 o The function record list flags item now stores a ref count, and
   we no longer need to have the flags if the records are filtered
   or set for "notrace"

 o Each ftrace_ops has its own set of functions to trace or not trace
   which is used to update the ref counts of the function records
   mentioned above. If the ftrace_ops is not currently active, the
   records are not touched when the filters are changed. If the filters
   are changed while the ftrace_ops is active, it is done in a way
   with RCU to make the updates.

 o If only one ftrace_ops is registered for tracing (actively tracing),
   its handler is called directly from mcount. Unless the ftrace_ops
   was allocated and not a static/global core kernel variable (see below).

 o If more than one ftrace_ops is registered, then a function is called
   that will iterate over the list of registered ftrace_ops, performing
   a check of each of its hashes to know if ftrace_ops handler should
   be called for that function.

 o If a ftrace_ops is allocated and not a static/global core kernel
   variable, it will be forced to use the function that loops through
   the ftrace_ops even if its the only one. This is because that function
   disables preemption when it performs the loop. This is needed, because
   dynamically allocated ftrace_ops must call synchronize_sched() before
   being freed (which is done when the dynamic ftrace_ops has been
   unregistered).

 o A file has been created in the debugfs/tracing directory called
   enabled_functions. This file contains a list of all functions that
   any ftrace_ops has registered, along with each functions ref count.
   This can be used to make sure nothing is tracing.

I'm posting this patch series as an RFC, but I do not expect it to
change much. I still have to put it through more tests even though
I ran several on each set already.

-- Steve

Steven Rostedt (13):
      ftrace: Replace FTRACE_FL_NOTRACE flag with a hash of ignored functions
      ftrace: Use hash instead for FTRACE_FL_FILTER
      ftrace: Create a global_ops to hold the filter and notrace hashes
      ftrace: Separate hash allocation and assignment
      ftrace: Use counters to enable functions to trace
      ftrace: Add enabled_functions file
      ftrace: Add ops parameter to ftrace_startup/shutdown functions
      ftrace: Have global_ops store the functions that are to be traced
      ftrace: Free hash with call_rcu_sched()
      ftrace: Implement separate user function filtering
      ftrace: Allow dynamically allocated function tracers
      ftrace: Modify ftrace_set_filter/notrace to take ops
      ftrace: Add self-tests for multiple function trace users

----
 include/linux/ftrace.h                |   33 +-
 include/linux/kernel.h                |    1 +
 kernel/extable.c                      |    8 +
 kernel/trace/ftrace.c                 |  992 ++++++++++++++++++++++++++++-----
 kernel/trace/trace.h                  |    2 +
 kernel/trace/trace_functions.c        |    2 +
 kernel/trace/trace_irqsoff.c          |    1 +
 kernel/trace/trace_sched_wakeup.c     |    1 +
 kernel/trace/trace_selftest.c         |  214 +++++++-
 kernel/trace/trace_selftest_dynamic.c |    6 +
 kernel/trace/trace_stack.c            |    1 +
 11 files changed, 1116 insertions(+), 145 deletions(-)
