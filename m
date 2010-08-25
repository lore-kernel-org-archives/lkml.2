Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab0HYNqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:46:08 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:40372 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab0HYNqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:46:04 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 25 Aug 2010 19:11:17 +0530
Message-Id: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv11 2.6.36-rc2-tip 0/15]  0: Uprobes Patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changelog from V10:
 * Replaced function pointers in user_bkpt structure with weak
   functions as suggested by Peter Zijlstra.
 * CONFIG_PROBE_EVENTS now selects uprobe-tracer and kprobe-tracer
   as suggested by Frederic.
 * Split perf-probe listing patches into smaller patches.

Changelog from V9:
 * Resolved comments from Arnaldo on perf support for uprobes.
 * perf probe -S will now list only global binding functions as
   requested by Christoph Hellwig.
 * Moved Changelog to below Signed-off-by: line, so that its not part
   of the patch description. (Suggested by Christoph.)

Changelog from V8:
 * Fix build issues reported by Christoph.
 * List available probes in a file without need to specify pid.

Changelog from V7:
 * New feature: perf probe lists available probes.
 * Fix perf probes for uprobes to exit with a error message on dwarf
   based probes.
 * Merge changes to kprobes traceevent infrastructure.
 * Merge changes to perf.

Changelog from V6:
 * Remove perf adjust symbols patch.

Changelog from V5:
 * Merged user_bkpt and user_bkpt_xol into uprobes.
 * Addressed comments till now.

Changelog from V4:
 * Rebased to tip tree. (2.6.35-rc3-tip)

Changelog from v3:
 * Reverted to background page replacement as suggested by Peter Zijlstra.
 * Dso in 'perf probe' can be either be a short name or a absolute path.
 * Addressed comments from Masami, Frederic, Steven on traceevents and perf

Changelog from v2:
 * Addressed comments from Oleg, including removal of interrupt context
    handlers, reverting background page replacement in favour of
    access_process_vm().

 * Provides perf interface for uprobes.

Changelog from v1:
 * Added trace_event interface for uprobes.
 * Addressed comments from Andrew Morton and Randy Dunlap.

For previous posting: please refer:
http://lkml.org/lkml/2010/7/27/121, http://lkml.org/lkml/2010/7/12/67,
http://lkml.org/lkml/2010/7/8/239, http://lkml.org/lkml/2010/6/29/299,
http://lkml.org/lkml/2010/6/14/41, http://lkml.org/lkml/2010/3/20/107
and http://lkml.org/lkml/2010/5/18/307

This patchset implements Uprobes which enables you to dynamically break
into any routine in a user space application and collect information
non-disruptively.

This patchset is a rework based on suggestions from discussions on lkml
in January and March 2010 (http://lkml.org/lkml/2010/1/11/92,
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

- Perf automatically adds probes for high-overhead functions.
- Allow trace scripts to insert probes
- Syscall integration and TRACE_EVENT() universe.
	(Need clarity/discussion on API)
- Allowing probes across fork.
- Allowing probes per-executable/per dso.
- Allow multiple probes to share a probepoint.
- Return probes.
- Support for other architectures.
- Uprobes booster.
- Merge uprobes and kprobes trace_event.
- replace macro W with bits in inat table.

Please do provide your valuable comments.

Thanks in advance.
Srikar

---

 Srikar Dronamraju(15)
 1: mm: Move replace_page() / write_protect_page() to mm/memory.c
 2: uprobes: Breakpoint insertion/removal in user space applications.
 3: uprobes: Slot allocation for Execution out of line(XOL)
 4: uprobes: x86 specific functions for user space breakpointing.
 5: uprobes: Uprobes (un)registration and exception handling.
 6: uprobes: X86 support for Uprobes
 7: uprobes: Uprobes Documentation
 8: tracing: Extract out common code for kprobes/uprobes traceevents.
 9: tracing: uprobes trace_event interface
10: tracing: config option to enable both kprobe-tracer and uprobe-tracer.
11: perf: list symbols in a dso in ascending order.
12: perf: show possible probes in a given file.
13: perf: Loop thro each of the maps in a map_group.
14: perf: perf interface for uprobes
15: perf: Show Potential probe points.


 Documentation/uprobes.txt          |  188 +++++
 arch/Kconfig                       |    6 +
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/thread_info.h |    2 +
 arch/x86/include/asm/uprobes.h     |   43 ++
 arch/x86/kernel/Makefile           |    2 +
 arch/x86/kernel/signal.c           |   13 +
 arch/x86/kernel/uprobes.c          |  613 ++++++++++++++++
 fs/exec.c                          |    4 +
 include/linux/mm.h                 |    4 +
 include/linux/mm_types.h           |    4 +
 include/linux/sched.h              |    3 +
 include/linux/uprobes.h            |  305 ++++++++
 kernel/Makefile                    |    1 +
 kernel/fork.c                      |   21 +
 kernel/trace/Kconfig               |   61 ++-
 kernel/trace/Makefile              |    2 +
 kernel/trace/trace.h               |    5 +
 kernel/trace/trace_kprobe.c        |  752 +-------------------
 kernel/trace/trace_probe.c         |  654 +++++++++++++++++
 kernel/trace/trace_probe.h         |  157 ++++
 kernel/trace/trace_uprobe.c        |  739 +++++++++++++++++++
 kernel/uprobes.c                   | 1405 ++++++++++++++++++++++++++++++++++++
 mm/ksm.c                           |  112 ---
 mm/memory.c                        |  120 +++
 tools/perf/builtin-probe.c         |   55 ++-
 tools/perf/util/map.h              |   27 +
 tools/perf/util/probe-event.c      |  503 +++++++++++--
 tools/perf/util/probe-event.h      |   13 +-
 tools/perf/util/symbol.c           |   22 +
 tools/perf/util/symbol.h           |    2 +
 31 files changed, 4886 insertions(+), 953 deletions(-)
