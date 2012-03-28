Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab2C1MgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:36:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab2C1MgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:36:23 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC 00/15] perf: Add backtrace post dwarf unwind 
Date: Wed, 28 Mar 2012 14:35:43 +0200
Message-Id: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending RFC version of the post unwinding user stack backtrace
using dwarf unwind - via libunwind. The original work was
done by Frederic. I mostly took his patches and make them
compile in current kernel code plus I added some stuff here
and there.

The main idea is to store user registers and portion of user
stack when the sample data during the record phase. Then during
the report, when the data is presented, perform the actual dwarf
dwarf unwind.

attached patches:
 01/15 perf, tool: Fix the array pointer to follow event data properly
 02/15 uaccess: Add new copy_from_user_gup API
 03/15 perf: Unified API to record selective sets of arch registers
 04/15 perf: Add ability to dump user regs
 05/15 perf: Add ability to dump part of the user stack
 06/15 perf: Add attribute to filter out user callchains
 07/15 perf, tool: Factor DSO symtab types to generic binary types
 08/15 perf, tool: Add interface to read DSO image data
 09/15 perf, tool: Add '.note' check into search for NOTE section
 10/15 perf, tool: Back [vdso] DSO with real data
 11/15 perf, tool: Add interface to arch registers sets
 12/15 perf, tool: Add libunwind dependency for dwarf cfi unwinding
 13/15 perf, tool: Support user regs and stack in sample parsing
 14/15 perf, tool: Support for dwarf cfi unwinding on post processing
 15/15 perf, tool: Support for dwarf mode callchain on perf record

The unwind processing could considerably prolong the computing
time of the report command, but I believe this could be improved.
   - caching DSO data accesses (as suggested in patch 8/15)
   - maybe separate thread with unwind processing on background,
     so the user does no need to wait for all the data to be
     processed.

I tested on Fedora. There was not much gain on i386, because the
binaries are compiled with frame pointers. Thought the dwarf
backtrace is more accurade and unwraps calls in more details
(functions that do not set the frame pointers).

I could see some improvement on x86_64, where I got full backtrace
where current code could got just the first address out of the
instruction pointer.

Example on x86_64:
[dwarf]
   perf record -g -e syscalls:sys_enter_write date

   100.00%     date  libc-2.14.90.so  [.] __GI___libc_write
               |
               --- __GI___libc_write
                   _IO_file_write@@GLIBC_2.2.5
                   new_do_write
                   _IO_do_write@@GLIBC_2.2.5
                   _IO_file_overflow@@GLIBC_2.2.5
                   0x4022cd
                   0x401ee6
                   __libc_start_main
                   0x4020b9


[frame pointer]
   perf record -g fp -e syscalls:sys_enter_write date

   100.00%     date  libc-2.14.90.so  [.] __GI___libc_write
               |
               --- __GI___libc_write

Also I tested on coreutils binaries mainly, but I could see
getting wider backtraces with dwarf unwind for more complex
application like firefox.

The unwind should go throught [vdso] object. I haven't studied
the [vsyscall] yet, so not sure there.

Attached patches should work on both x86 and x86_64. I did
some initial testing so far.

The unwind backtrace can be interrupted by following reasons:
    - bug in unwind information of processed shared library
    - bug in unwind processing code (most likely ;) )
    - insufficient dump stack size
    - wrong register value - x86_64 does not store whole
      set of registers when in exception, but so far
      it looks like RIP and RSP should be enough

I'd like to have some automated tests on this, but so far nothing
smart is comming to me.. ;)

thanks for comments,
jirka
---
 arch/Kconfig                                       |    7 +
 arch/x86/Kconfig                                   |    1 +
 arch/x86/include/asm/perf_regs.h                   |   15 +
 arch/x86/include/asm/perf_regs_32.h                |   86 +++
 arch/x86/include/asm/perf_regs_64.h                |  101 ++++
 arch/x86/include/asm/uaccess.h                     |    8 +-
 arch/x86/kernel/cpu/perf_event.c                   |    4 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |    3 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |    2 +-
 arch/x86/lib/usercopy.c                            |    4 +-
 arch/x86/oprofile/backtrace.c                      |    4 +-
 include/asm-generic/uaccess.h                      |    4 +
 include/linux/perf_event.h                         |   36 ++-
 kernel/events/callchain.c                          |    4 +-
 kernel/events/core.c                               |  127 +++++-
 kernel/events/internal.h                           |   59 ++-
 kernel/events/ring_buffer.c                        |    4 +-
 tools/perf/Makefile                                |   40 ++-
 tools/perf/arch/x86/Makefile                       |    3 +
 tools/perf/arch/x86/include/perf_regs.h            |  101 ++++
 tools/perf/arch/x86/util/unwind.c                  |  111 ++++
 tools/perf/builtin-record.c                        |   89 +++-
 tools/perf/builtin-report.c                        |   24 +-
 tools/perf/builtin-script.c                        |   56 ++-
 tools/perf/builtin-test.c                          |    3 +-
 tools/perf/builtin-top.c                           |    7 +-
 tools/perf/config/feature-tests.mak                |   25 +
 tools/perf/perf.h                                  |    9 +-
 tools/perf/util/annotate.c                         |    2 +-
 tools/perf/util/event.h                            |   15 +-
 tools/perf/util/evlist.c                           |   16 +
 tools/perf/util/evlist.h                           |    2 +
 tools/perf/util/evsel.c                            |   36 ++-
 tools/perf/util/include/linux/compiler.h           |    1 +
 tools/perf/util/map.c                              |   16 +-
 tools/perf/util/map.h                              |    7 +-
 tools/perf/util/perf_regs.h                        |   10 +
 tools/perf/util/python.c                           |    3 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    3 +-
 .../util/scripting-engines/trace-event-python.c    |    3 +-
 tools/perf/util/session.c                          |  100 +++-
 tools/perf/util/session.h                          |   10 +-
 tools/perf/util/symbol.c                           |  317 +++++++++---
 tools/perf/util/symbol.h                           |   40 +-
 tools/perf/util/trace-event-scripting.c            |    3 +-
 tools/perf/util/trace-event.h                      |    5 +-
 tools/perf/util/unwind.c                           |  563 ++++++++++++++++++++
 tools/perf/util/unwind.h                           |   34 ++
 tools/perf/util/vdso.c                             |   92 ++++
 tools/perf/util/vdso.h                             |    7 +
 50 files changed, 2023 insertions(+), 199 deletions(-)
