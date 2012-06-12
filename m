Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2FLWy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:54:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2FLWy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:54:26 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=-F1kBjyFV80A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=b_5ldSJBWHX6sWwqdUkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120612224327.426900129@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 12 Jun 2012 18:43:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 00/13 v2] kprobes/ftrace: Making ftrace usable for kprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is an RFC of patches that allow ftrace to be used directly by
kprobes.

The first set of patches modify the function tracer to:

 1) have ftrace_ops passed to all functions
 2) allow regs to be passed to all functions when requested

The first change is not required by kprobes, but is a nice feature
that people have asked for. You can now pass data to different
functions. Well, you can pass the ftrace_ops that registered the function
such that if two ftrace_ops register the same callback, the call back
can do different things depending on what registered it.

The second change adds a second mcount trampoline. That is,
if you request to have pt_regs returned, it will call a different
function that saves those registers. If nothing asks for regs, then
the old way is performed, and there's no slow down in the performance,
as not many functions would ever require regs passed to it.

If an arch supports passing of ftrace ops, it must also pass regs.
But it does not need to support passing regs. By default
an arch can just pass NULL. If it supports  regs, then
it can allow tools like kprobes to ask for regs. Otherwise the
regs parameter should just be NULL.

The second set is Masami's patches ported on top of these changes.

This is v2, and I've cleaned the patches up a bit and added a lot more
comments. This is a more serious RFC as this is the current way I plan
on pushing it to mainline. But I'm posting first in case someone spots
something that I missed. I'll also be doing more testing on it and if
someting comes up I'll obviously will fix it before pushing.

Some change since v1:

 Added fix for undefined ftrace_location() when compiling with !DYNAMIC_FTRACE.
 
 Added missing regs passed for x86_64 (segment regs, and r11).

 Saved flags for when regs are being saved. The cmp in the mcount trampoline
 that checks if function tracing is disabled will save flags before
 the compare, and restore flags before returning back to the function.

 Decided that passing partial regs is a bad idea. Either the arch should
 pass all regs or NULL. Even though partial regs are saved for calling the
 function, it does't make sense to give that to the callback. By making
 regs be full pt_regs or NULL, then the callbacks can simply check if
 regs is NULL and if it isn't it can do more functionality, but if it
 is NULL then it just does limited work. Having 'partial regs' would just
 complicate that for no good reason. If in the future we want partial regs,
 we can add another flag to request it.

 Note, code can still check if ARCH_SUPPORTS_FTRACE_SAVE_REGS is defined,
 and if it is, if the ftrace_ops specifies the SAVE_REGS flag, then the
 arch will pass the full pt_regs to it.

These patches are in git and can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
rfc/kprobes/ftrace-v5

Head SHA1: 3cbbedd93e39d1394251825775d913be10d16e4e


Masami Hiramatsu (5):
      ftrace: add ftrace_set_filter_ip() for address based filter
      kprobes: cleanup to separate probe-able check
      kprobes: Move locks into appropriate functions
      kprobes: introduce ftrace based optimization
      kprobes/x86: ftrace based optimization for x86

Steven Rostedt (8):
      ftrace: Pass ftrace_ops as third parameter to function trace callback
      ftrace: Consolidate arch dependent functions with 'list' function
      ftrace: Return pt_regs to function trace callback
      ftrace/x86_32: Push ftrace_ops in as 3rd parameter to function tracer
      ftrace/x86: Add separate function to save regs
      ftrace/x86: Add save_regs for i386 function calls
      kprobes: Inverse taking of module_mutex with kprobe_mutex
      ftrace: Make ftrace_location() a nop on !DYNAMIC_FTRACE

----
 arch/x86/include/asm/ftrace.h     |   47 ++++---
 arch/x86/include/asm/kprobes.h    |    1 +
 arch/x86/kernel/entry_32.S        |   56 ++++++++
 arch/x86/kernel/entry_64.S        |   89 +++++++++++-
 arch/x86/kernel/ftrace.c          |   73 +++++++++-
 arch/x86/kernel/kprobes.c         |   48 +++++++
 include/linux/ftrace.h            |  130 ++++++++++++++++-
 include/linux/kprobes.h           |   27 ++++
 kernel/kprobes.c                  |  250 +++++++++++++++++++++++----------
 kernel/trace/ftrace.c             |  281 +++++++++++++++++++++++++++----------
 kernel/trace/trace_event_perf.c   |    3 +-
 kernel/trace/trace_events.c       |    3 +-
 kernel/trace/trace_functions.c    |   10 +-
 kernel/trace/trace_irqsoff.c      |    3 +-
 kernel/trace/trace_sched_wakeup.c |    3 +-
 kernel/trace/trace_selftest.c     |   20 ++-
 kernel/trace/trace_stack.c        |    3 +-
 17 files changed, 850 insertions(+), 197 deletions(-)
