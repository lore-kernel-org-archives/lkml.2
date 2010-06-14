Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab0FNI3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:29:54 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:56709 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab0FNI3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:29:52 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Jun 2010 13:57:48 +0530
Message-Id: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v5 0/14] Uprobes v5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intro.patch

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Uprobes Patches

Changelog from v4:
  - Rebased to tip tree. (2.6.35-rc3-tip)

Changelog from v3:
  - Reverted to background page replacement as suggested by Peter Zijlstra.
  - Dso in 'perf probe' can be either be a short name or a absolute path.
  - Addressed comments from Masami, Frederic, Steven on traceevents and perf

Changelog from v2:
  - Addressed comments from Oleg, including removal of interrupt context
    handlers, reverting background page replacement in favour of
    access_process_vm().

  - Provides perf interface for uprobes.

Changelog from v1:
 - Added trace_event interface for uprobes.
 - Addressed comments from Andrew Morton and Randy Dunlap.

For previous posting: please refer: http://lkml.org/lkml/2010/3/20/107
and http://lkml.org/lkml/2010/5/18/307

This patchset implements Uprobes which enables you to dynamically break
into any routine in a user space application and collect information
non-disruptively.

This patchset is a rework based on suggestions from discussions on lkml
in January and March this year (http://lkml.org/lkml/2010/1/11/92,
http://lkml.org/lkml/2010/1/27/19, http://lkml.org/lkml/2010/3/20/107
and http://lkml.org/lkml/2010/3/31/199 ). This implementation of
uprobes doesnt depend on utrace.

When a uprobe is registered, Uprobes makes a copy of the probed
instruction, replaces the first byte(s) of the probed instruction with a
breakpoint instruction. (Uprobes uses background page replacement
mechanism and ensures that the breakpoint affects only that process.)

When a CPU hits the breakpoint instruction, Uprobes gets notified of
trap and finds the associated uprobe. It then executes the associated
handler. Uprobes single-steps its copy of the probed instruction and
resumes execution of the probed process at the instruction following the
probepoint. Instruction copies to be single-stepped are stored in a
per-process "execution out of line (XOL) area". Currently XOL area is
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

- Allowing probes across fork.
- Allowing probes per-executable/per dso.
- Allow multiple probes to share a probepoint.
- Return probes.
- Support for other architectures.
- Uprobes booster.
- Merge uprobes and kprobes trace_event.
- replace macro with bits in inat table.

The current patchset is based on 2.6.35-rc3-tip.

Please do provide your valuable comments.

Thanks in advance.
Srikar

Srikar Dronamraju (10):
 1.  X86 instruction analysis: Move Macro W to insn.h
 2.  mm: Move replace_page() to mm/memory.c
 3.  user_bkpt: User Space Breakpoint Assistance Layer
 4.  user_bkpt: X86 details for User space breakpoint assistance
 5.  user_bkpt: Slot allocation for Execution out of line
 6.  uprobes: Uprobes Implementation
 7.  uprobes: X86 details for Uprobes
 8.  samples: Uprobes samples
 9.  uprobes: Uprobes Documentation patch
 10. trace: Share common code for uprobes/kprobes traceevents
 11. trace: uprobes trace_event interface
 12. perf: Dont adjust symbols if lookup is by name.
 13. perf: Re-add make_absolute_path().
 14. perf: perf interface for uprobes.

 Documentation/uprobes.txt          |  236 +++++++++
 arch/Kconfig                       |   31 ++
 arch/x86/Kconfig                   |    2 +
 arch/x86/include/asm/insn.h        |    7 +
 arch/x86/include/asm/thread_info.h |    2 +
 arch/x86/include/asm/user_bkpt.h   |   43 ++
 arch/x86/kernel/Makefile           |    3 +
 arch/x86/kernel/kprobes.c          |    7 -
 arch/x86/kernel/signal.c           |   17 +
 arch/x86/kernel/uprobes.c          |   77 +++
 arch/x86/kernel/user_bkpt.c        |  572 ++++++++++++++++++++++
 fs/exec.c                          |    4 +
 include/linux/mm.h                 |    4 +
 include/linux/mm_types.h           |    4 +
 include/linux/sched.h              |    3 +
 include/linux/uprobes.h            |  169 +++++++
 include/linux/user_bkpt.h          |  305 ++++++++++++
 include/linux/user_bkpt_xol.h      |   40 ++
 kernel/Makefile                    |    3 +
 kernel/fork.c                      |   21 +
 kernel/trace/Kconfig               |   13 +
 kernel/trace/Makefile              |    1 +
 kernel/trace/trace.h               |    5 +
 kernel/trace/trace_kprobe.c        |  141 +------
 kernel/trace/trace_probe.h         |  159 +++++++
 kernel/trace/trace_uprobe.c        |  921 ++++++++++++++++++++++++++++++++++++
 kernel/uprobes.c                   |  681 ++++++++++++++++++++++++++
 kernel/user_bkpt.c                 |  589 +++++++++++++++++++++++
 kernel/user_bkpt_xol.c             |  302 ++++++++++++
 mm/ksm.c                           |  112 -----
 mm/memory.c                        |  120 +++++
 samples/Kconfig                    |    7 +
 samples/Makefile                   |    2 +-
 samples/uprobes/Makefile           |   17 +
 samples/uprobes/uprobe_example.c   |   83 ++++
 tools/perf/builtin-probe.c         |   13 +-
 tools/perf/builtin-top.c           |   20 -
 tools/perf/util/abspath.c          |   81 ++++
 tools/perf/util/cache.h            |    1 +
 tools/perf/util/event.c            |   20 +
 tools/perf/util/event.h            |    1 +
 tools/perf/util/probe-event.c      |  466 +++++++++++++------
 tools/perf/util/probe-event.h      |   37 +-
 tools/perf/util/probe-finder.c     |   20 +-
 tools/perf/util/probe-finder.h     |    6 +-
 tools/perf/util/symbol.c           |    6 +-
 46 files changed, 4917 insertions(+), 457 deletions(-)
---

 0 files changed, 0 insertions(+), 0 deletions(-)


