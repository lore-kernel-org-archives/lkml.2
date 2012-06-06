Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab2FFEAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:00:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30972 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2FFEAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:00:15 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=sI77fHhe7ukA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=OnI6tmfyTExYHtWpoS8A:9 a=E6k37eg1NvgA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120606035058.108720095@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Jun 2012 23:50:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 00/12] kprobes/ftrace: Making ftrace usable for kprobes
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
But it does not need to support passing all (or any) regs. By default
an arch can just pass NULL. If it supports full regs, then
it can allow tools like kprobes to ask for regs. Otherwise regs
is either NULL or a subset of full regs.

The second set is Masami's patches ported on top of these changes.

Note, I just got these working and they could use more comments in
the code. I plan on doing so and cleaning things up, but wanted to
get these out in the "release early, release often" mentality.

-- Steve

These patches are in git and can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
rfc/kprobes/ftrace-v3

Head SHA1: 80a5eca4e5d019c752ba580400f656afc5d8aca6


Masami Hiramatsu (5):
      ftrace: add ftrace_set_filter_ip() for address based filter
      kprobes: cleanup to separate probe-able check
      kprobes: Move locks into appropriate functions
      kprobes: introduce ftrace based optimization
      kprobes/x86: ftrace based optimization for x86

Steven Rostedt (7):
      ftrace: Pass ftrace_ops as third parameter to function trace callback
      ftrace: Consolidate arch dependent functions with 'list' function
      ftrace: Return pt_regs to function trace callback (x86_64 only so far)
      ftrace/x86_32: Push ftrace_ops in as 3rd parameter to function tracer
      ftrace/x86: Add separate function to save regs
      ftrace/x86: Add save_regs for i386 function calls
      kprobes: Inverse taking of module_mutex with kprobe_mutex

----
 arch/x86/include/asm/ftrace.h     |   44 +++---
 arch/x86/include/asm/kprobes.h    |    1 +
 arch/x86/kernel/entry_32.S        |   56 ++++++++
 arch/x86/kernel/entry_64.S        |   73 +++++++++-
 arch/x86/kernel/ftrace.c          |   62 ++++++++-
 arch/x86/kernel/kprobes.c         |   48 +++++++
 include/linux/ftrace.h            |   89 +++++++++++-
 include/linux/kprobes.h           |   27 ++++
 kernel/kprobes.c                  |  250 +++++++++++++++++++++++----------
 kernel/trace/ftrace.c             |  273 ++++++++++++++++++++++++++-----------
 kernel/trace/trace_event_perf.c   |    3 +-
 kernel/trace/trace_events.c       |    3 +-
 kernel/trace/trace_functions.c    |   10 +-
 kernel/trace/trace_irqsoff.c      |    3 +-
 kernel/trace/trace_sched_wakeup.c |    3 +-
 kernel/trace/trace_selftest.c     |   20 ++-
 kernel/trace/trace_stack.c        |    3 +-
 17 files changed, 778 insertions(+), 190 deletions(-)
