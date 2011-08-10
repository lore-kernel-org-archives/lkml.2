Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1HJQal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:30:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab1HJQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:30:40 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=vhdKIqpQuCYA:10 a=B8hPAs4K9yUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=bdZsnFCB_BOk4fQYVC4A:9 a=AvwAEEN74y3qyWqXBgEA:7 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110810162222.017387055@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 10 Aug 2011 12:22:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 0/5][RFC] kprobes/ftrace: Have kprobes use ftrace on ftrace nops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I started working on adding the -mfentry switch to ftrace, which
allows us to remove the frame pointers requirement from function tracing
as well as makes mcount (fentry) work just better.

But when I did this in another branch, I noticed that I broke kprobes
in its most common usage. The attaching a probe at the beginning of
a function to use get to its parameters.

So I started this branch. This branch is to have kprobes use ftrace
directly when a probe is attached to a ftrace nop. Currently, kprobes
will just error when that happens. With this patch set, it will hook
into the ftrace infrastructure and use ftrace instead. This is more
like an optimized probe as no breakpoints need to be set. A call to
the function is done directly via the mcount trampoline. If ftrace
pt_regs is implemented for an arch, kprobes gets this feature for free.

The first patch is just a clean up that I need to push out to get rid
of the annoying compile warning about initialized variables that
gcc can't tell have been initialized.

The next two patches have ftrace pass both the ftrace_ops structure
and the pt_regs to the callback function that is registered with ftrace.

The last two patches have kprobes interact with ftrace and use the
ftrace infrastructure instead.

I only did this for x86_64, and will do it for x86_32 and PPC64 if everyone
agrees with this approach. Then I could find people to do it for other
archs :)

Thanks!

-- Steve

This patch set can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
rfc/kprobes/ftrace

Head SHA1: e704df971bc958c789e9dcf0b453e4c02e27887b


Steven Rostedt (5):
      tracing: Clean up tb_fmt to not give faulty compile warning
      ftrace: Pass ftrace_ops as third parameter to function trace callback
      ftrace: Return pt_regs to function trace callback (x86_64 only so far)
      kprobes: Inverse taking of module_mutex with kprobe_mutex
      kprobes: Use ftrace hooks when probing ftrace nops

----
 arch/x86/include/asm/ftrace.h     |   42 ++++++----
 arch/x86/kernel/entry_64.S        |   24 +++++-
 include/linux/ftrace.h            |   27 ++++++-
 include/linux/kprobes.h           |    6 ++
 kernel/kprobes.c                  |  167 ++++++++++++++++++++++++++++++++++---
 kernel/trace/ftrace.c             |   74 +++++++++++------
 kernel/trace/trace_events.c       |    3 +-
 kernel/trace/trace_functions.c    |   10 ++-
 kernel/trace/trace_irqsoff.c      |    3 +-
 kernel/trace/trace_printk.c       |   19 ++--
 kernel/trace/trace_sched_wakeup.c |    3 +-
 kernel/trace/trace_selftest.c     |   20 ++++-
 kernel/trace/trace_stack.c        |    3 +-
 13 files changed, 323 insertions(+), 78 deletions(-)
