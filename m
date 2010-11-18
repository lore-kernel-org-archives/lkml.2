Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0KREJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 23:09:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48273 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0KREJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 23:09:52 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=7r_CXQSnVcgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=gu6fZOg2AAAA:8 a=VwQbUJbxAAAA:8 a=qCIMQgMvocSQeM1E7XEA:9 a=cKTfWoEddgDPa67SXtcsWRDQpUcA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101118035803.453609353@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 22:58:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 0/2] tracing: Have trace_printk()s in the events/ directory
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested in:

LKML-Reference: <20101116221726.GB26243@nowhere>
  or
http://marc.info/?l=linux-kernel&m=128994587230629

To have trace_printks in the events directory.

This patch set just does it for ftrace, although it can also lay the
ground work for both perf and trace (are they different tools?)

This patch set converts the current trace_printk() into ftrace_printk()
(back to it's original name) and that stays the same.

The new trace_printk() is off by default (we can change that later
with a kernel command line option perhaps), but it can be enable now
with the events directory.

Each trace_printk() added will get a entry in the debugfs/tracing/events/
directory as  debugfs/tracing/entry/path/to/trace_printk/

For example, I added a trace_printk() in kernel/sched.c at line 2180
and it creates:

# ls /debug/tracing/events/printk/kernel/sched.c/2180/
enable  format

The format is the printk format:

# cat /debug/tracing/events/printk/kernel/sched.c/2180/format 
"migrate task %s:%d
"


Every directory has an "enable" file. By echoing 0 or 1 into this
file, it will enable all the trace_printk's below it.

This also uses jump_label() to keep overhead down when disabled.

Note, modules are not (yet) supported.

This is just the ground work. I'm busy doing other things so
if you need more, feel free to take this and carry on.

-- Steve

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/event-printk


Steven Rostedt (2):
      tracing: Rename trace_printk to ftrace_printk
      tracing: Make event based trace_printk()

----
 include/asm-generic/vmlinux.lds.h |    7 +-
 include/linux/kernel.h            |   16 +-
 include/trace/event_printk.h      |   52 ++++++
 kernel/trace/Makefile             |    1 +
 kernel/trace/event_printk.c       |  365 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_events.c       |    2 +-
 7 files changed, 435 insertions(+), 9 deletions(-)
