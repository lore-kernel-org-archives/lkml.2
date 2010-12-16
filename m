Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0LPJ7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:59:53 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38104 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0LPJ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:59:51 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:27:14 +0530
Message-Id: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 0/20]  0: Inode based uprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

into any routine in a user space application and collect information
non-disruptively.

For previous posting: please refer: http://lkml.org/lkml/2010/8/25/165
http://lkml.org/lkml/2010/7/27/121, http://lkml.org/lkml/2010/7/12/67,
http://lkml.org/lkml/2010/7/8/239, http://lkml.org/lkml/2010/6/29/299,
http://lkml.org/lkml/2010/6/14/41, http://lkml.org/lkml/2010/3/20/107
and http://lkml.org/lkml/2010/5/18/307

Uprobes Patches
Unlike the previous postings where a probe was specified as pid:vaddr,
this patchset implements inode based uprobes which are specified as
<file>:<offset> where offset is the offset from start of the map.
The probehit overhead is around 3X times the previous patchset overhead.

This patchset is a rework based on suggestions from discussions on lkml
in September, March and January 2010 (http://lkml.org/lkml/2010/1/11/92,
http://lkml.org/lkml/2010/1/27/19, http://lkml.org/lkml/2010/3/20/107
and http://lkml.org/lkml/2010/3/31/199 ). This implementation of uprobes
doesnt depend on utrace.

When a uprobe is registered, Uprobes makes a copy of the probed
instruction, replaces the first byte(s) of the probed instruction with a
breakpoint instruction. (Uprobes uses background page replacement
mechanism and ensures that the breakpoint affects only that process.)

When a CPU hits the breakpoint instruction, Uprobes gets notified of
trap and finds the associated uprobe. It then executes the associated
handler. Uprobes single-steps its copy of the probed instruction and
resumes execution of the probed process at the instruction following the
probepoint. Instruction copies to be single-stepped are stored in a
per-mm "execution out of line (XOL) area". Currently XOL area is
allocated as one page vma.

Advantages of uprobes over conventional debugging include:

1. Non-disruptive.
Unlike current ptrace based mechanisms, uprobes tracing wouldnt
involve signals, stopping threads and context switching between the
tracer and tracee.

2. Much better handling of multithreaded programs because of XOL.
Current ptrace based mechanisms use single stepping inline, i.e they
copy back the original instruction on hitting a breakpoint.  In such
mechanisms tracers have to stop all the threads on a breakpoint hit or
tracers will not be able to handle all hits to the location of
interest. Uprobes uses execution out of line, where the instruction to
be traced is analysed at the time of breakpoint insertion and a copy
of instruction is stored at a different location.  On breakpoint hit,
uprobes jumps to that copied location and singlesteps the same
instruction and does the necessary fixups post singlestepping.

3. Multiple tracers for an application.
Multiple uprobes based tracer could work in unison to trace an
application. There could one tracer that could be interested in
generic events for a particular set of process. While there could be
another tracer that is just interested in one specific event of a
particular process thats part of the previous set of process.

4. Corelating events from kernels and userspace.
Uprobes could be used with other tools like kprobes, tracepoints or as
part of higher level tools like perf to give a consolidated set of
events from kernel and userspace.  In future we could look at a single
backtrace showing application, library and kernel calls.

Here is the list of TODO Items.

- Integrating perf probe with this patchset.
- Prefiltering (i.e filtering at the time of probe insertion)
 (Can be achieved if we can dynamically assign consumers at uprobe tracer
  enable time; Suggestions on how to do this are welcome)
- Signal handling.
	- queueing non-uprobes based INT3 as SIGTRAPS.
	- delaying signals from INT3 till post singlestep and queueing the
	  delayed signals.
- Return probes.
- Support for other architectures.
- Uprobes booster.
- replace macro W with bits in inat table.
- Bulk registration/unregisteration.

To try please fetch using
git fetch \
git://git.kernel.org/pub/scm/linux/kernel/git/srikar/linux-uprobes.git \
tip_inode_uprobes_161210:tip_inode_uprobes

Please refer "[RFC] [PATCH 2.6.37-rc5-tip 20/20] 20: tracing: uprobes
trace_event infrastructure" on how to use uprobe_tracer.

Please do provide your valuable comments.

Thanks in advance.
Srikar

 Srikar Dronamraju(20)
 0: Inode based uprobes
 1: mm: Move replace_page() / write_protect_page() to mm/memory.c
 2: X86 specific breakpoint definitions.
 3: uprobes: Breakground page replacement.
 4: uprobes: Adding and remove a uprobe in a rb tree.
 5: Uprobes: register/unregister probes.
 6: x86: analyze instruction and determine fixups.
 7: uprobes: store/restore original instruction.
 8: uprobes: mmap and fork hooks.
 9: x86: architecture specific task information.
10: uprobes: task specific information.
11: uprobes: slot allocation for uprobes
12: uprobes: get the breakpoint address.
13: x86: x86 specific probe handling
14: uprobes: Handing int3 and singlestep exception.
15: x86: uprobes exception notifier for x86.
16: uprobes: register a notifier for uprobes.
17: uprobes: filter chain
18: uprobes: commonly used filters.
19: tracing: Extract out common code for kprobes/uprobes traceevents.
20: tracing: uprobes trace_event interface

 arch/Kconfig                       |    4 +
 arch/x86/Kconfig                   |    3 +
 arch/x86/include/asm/thread_info.h |    2 +
 arch/x86/include/asm/uprobes.h     |   55 ++
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/signal.c           |   14 +
 arch/x86/kernel/uprobes.c          |  599 +++++++++++++++++
 include/linux/mm.h                 |    4 +
 include/linux/mm_types.h           |    9 +
 include/linux/sched.h              |    3 +
 include/linux/uprobes.h            |  186 ++++++
 kernel/Makefile                    |    1 +
 kernel/fork.c                      |   10 +
 kernel/trace/Kconfig               |   20 +
 kernel/trace/Makefile              |    2 +
 kernel/trace/trace.h               |    5 +
 kernel/trace/trace_kprobe.c        |  752 +---------------------
 kernel/trace/trace_probe.c         |  654 +++++++++++++++++++
 kernel/trace/trace_probe.h         |  157 +++++
 kernel/trace/trace_uprobe.c        |  753 ++++++++++++++++++++++
 kernel/uprobes.c                   | 1250 ++++++++++++++++++++++++++++++++++++
 mm/ksm.c                           |  114 ----
 mm/memory.c                        |  122 ++++
 mm/mmap.c                          |    2 +
 24 files changed, 3871 insertions(+), 851 deletions(-)
