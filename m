Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0CTOZC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:25:02 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:37805 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab0CTOZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:25:00 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Sat, 20 Mar 2010 19:54:55 +0530
Message-Id: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v1 0/10] Uprobes patches.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset implements Uprobes which enables you to dynamically break
into any routine in a user space application and collect information
non-disruptively.

This patchset is a rework based on suggestions from discussions on lkml
in January this year (http://lkml.org/lkml/2010/1/11/92 and
http://lkml.org/lkml/2010/1/27/19).  This implementation of uprobes
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
per-process "execution out of line (XOL) area". Currently XOL area is
allocated as one page vma.

Advantages of uprobes over conventional debugging include:
1. Non-disruptive.
2. Much better handling of multithreaded programs because of XOL.
3. No context switch between tracer, tracee.
4. Allows multiple processes to trace same tracee.

Here is the list of TODO Items.

- Provide a perf interface to uprobes. (coming in next version)
- Allowing probes across fork/exec.
- Allowing probes on per-executable/per dso.
- Allow multiple probes to share a probepoint.
- Support for other architectures.
- Return probes.
- Uprobes booster.

This patchset is based on 2.6.34-rc2.

Please do provide your valuable comments.

Thanks in advance.
Srikar


Srikar Dronamraju (10):
 1.  X86 instruction analysis: Move Macro W to insn.h
 2.  mm: Move replace_page() to mm/memory.c
 3.  mm: Enhance replace_page() to support pagecache
 4.  user_bkpt: User Space Breakpoint Assistance Layer
 5.  user_bkpt: X86 details for User space breakpoint assistance
 6.  user_bkpt: Slot allocation for Execution out of line
 7.  uprobes: Uprobes Implementation
 8.  uprobes: X86 details for Uprobes
 9.  uprobes: Uprobes Documentation patch
 10. samples: Uprobes samples

 Documentation/uprobes.txt        |  244 ++++++++++++
 arch/Kconfig                     |   31 ++
 arch/x86/Kconfig                 |    2 +
 arch/x86/include/asm/insn.h      |    7 +
 arch/x86/include/asm/user_bkpt.h |   43 ++
 arch/x86/kernel/Makefile         |    3 +
 arch/x86/kernel/kprobes.c        |    7 -
 arch/x86/kernel/uprobes.c        |   87 ++++
 arch/x86/kernel/user_bkpt.c      |  574 +++++++++++++++++++++++++++
 include/linux/mm.h               |    2 +
 include/linux/sched.h            |    3 +
 include/linux/tracehook.h        |   18 +
 include/linux/uprobes.h          |  178 +++++++++
 include/linux/user_bkpt.h        |  296 ++++++++++++++
 include/linux/user_bkpt_xol.h    |   61 +++
 kernel/Makefile                  |    3 +
 kernel/fork.c                    |    3 +
 kernel/uprobes.c                 |  798 ++++++++++++++++++++++++++++++++++++++
 kernel/user_bkpt.c               |  572 +++++++++++++++++++++++++++
 kernel/user_bkpt_xol.c           |  290 ++++++++++++++
 mm/ksm.c                         |   59 ---
 mm/memory.c                      |   62 +++
 samples/Kconfig                  |    7 +
 samples/uprobes/Makefile         |   17 +
 samples/uprobes/uprobe_example.c |   83 ++++
 25 files changed, 3384 insertions(+), 66 deletions(-)
---

 0 files changed, 0 insertions(+), 0 deletions(-)


