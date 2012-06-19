Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2FSPsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:48:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab2FSPsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:48:53 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org
Subject: [RFCv5 00/23] perf: Add backtrace post dwarf unwind 
Date: Tue, 19 Jun 2012 17:47:51 +0200
Message-Id: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

patches available also as tarball in here:
http://people.redhat.com/~jolsa/perf_post_unwind_v6.tar.bz2

v6 changes:
   patch 01/23 - unrelated - ftrace stuff
   patch 03/23 - added PERF_SAMPLE_REGS_USER bit
               - added regs_user initialization
   patch 07/23 - added PERF_SAMPLE_STACK_USER bit
               - sample_stack_user changed to u32 and
                 added size check
   new patches 1,9,10,20

v5 changes:
   patch 1/19 - having just one enum set of the perf registers
   patch 2/19 - using for_each_set_bit for scanning the mask
              - single regs enum for both 32 and 64 bits versions
              - using regs mask != 0 trigger to trigger the regs dump
   patch 5/19 - adding perf_output_skip so we can skip undumped part of the stack in RB
   patch 6/19 - using stack size != 0 trigger to trigger the stack dump
              - do not zero the memory for non retrieved part of the stack dump
   patch 7/19 - adding exclude_callchain_kernel attribute
   patch 8/19 - this could be taken without the rest of the series

v4 changes:
   - no real change from v3, just rebase
   - v3 patch 06/17 got already merged

v3 changes:
   patch 01/17
   - added HAVE_PERF_REGS config option
   patch 02/17, 04/17
   - regs and stack perf interface is more general now
   patch 06/17
   - unrelated online fix for i386 compilation
   patch 16/17
   - few namespace fixies

---
Adding the post unwinding user stack backtrace using dwarf unwind
via libunwind. The original work was done by Frederic. I mostly took
his patches and make them compile in current kernel code plus I added
some stuff here and there.

The main idea is to store user registers and portion of user
stack when the sample data during the record phase. Then during
the report, when the data is presented, perform the actual dwarf
dwarf unwind.

attached patches:
  01/23 tracing/filter: Add missing initialization
  02/23 perf: Unified API to record selective sets of arch registers
  03/23 perf: Add ability to attach user level registers dump to sample
  04/23 perf, x86: Add copy_from_user_nmi_nochk for best effort copy
  05/23 perf: Factor __output_copy to be usable with specific copy function
  06/23 perf: Add perf_output_skip function to skip bytes in sample
  07/23 perf: Add ability to attach user stack dump to sample
  08/23 perf: Add attribute to filter out callchains
  09/23 x86_64: Store userspace rsp in system_call fastpath
  10/23 perf, tool: Adding PERF_ATTR_SIZE_VER2 to the header swap check
  11/23 perf, tool: Remove unsused evsel parameter from machine__resolve_callchain
  12/23 perf, tool: Factor DSO symtab types to generic binary types
  13/23 perf, tool: Add interface to read DSO image data
  14/23 perf, tool: Add '.note' check into search for NOTE section
  15/23 perf, tool: Back [vdso] DSO with real data
  16/23 perf, tool: Add interface to arch registers sets
  17/23 perf, tool: Add libunwind dependency for dwarf cfi unwinding
  18/23 perf, tool: Support user regs and stack in sample parsing
  19/23 perf, tool: Support for dwarf cfi unwinding on post processing
  20/23 perf, tool: Adding round_up/round_down macros
  21/23 perf, tool: Support for dwarf mode callchain on perf
  22/23 perf, tool: Add dso data caching
  23/23 perf, tool: Add dso data caching tests


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

thanks for comments,
jirka
---
 arch/Kconfig                                       |    6 +
 arch/x86/Kconfig                                   |    1 +
 arch/x86/include/asm/perf_event.h                  |    2 +
 arch/x86/include/asm/perf_regs.h                   |   34 ++
 arch/x86/include/asm/uaccess.h                     |    2 +
 arch/x86/kernel/Makefile                           |    2 +
 arch/x86/kernel/entry_64.S                         |    5 +
 arch/x86/kernel/perf_regs.c                        |   90 +++
 arch/x86/lib/usercopy.c                            |   15 +-
 include/linux/perf_event.h                         |   45 ++-
 include/linux/perf_regs.h                          |   19 +
 kernel/events/callchain.c                          |   25 +-
 kernel/events/core.c                               |  184 +++++++-
 kernel/events/internal.h                           |   69 ++-
 kernel/events/ring_buffer.c                        |   10 +-
 kernel/trace/trace_events_filter.c                 |    2 +-
 tools/perf/Makefile                                |   45 ++-
 tools/perf/arch/x86/Makefile                       |    3 +
 tools/perf/arch/x86/include/perf_regs.h            |   80 +++
 tools/perf/arch/x86/util/unwind.c                  |  111 ++++
 tools/perf/builtin-record.c                        |  106 ++++-
 tools/perf/builtin-report.c                        |   24 +-
 tools/perf/builtin-script.c                        |   56 ++-
 tools/perf/builtin-test.c                          |    8 +-
 tools/perf/builtin-top.c                           |    7 +-
 tools/perf/config/feature-tests.mak                |   25 +
 tools/perf/perf.h                                  |    9 +-
 tools/perf/util/annotate.c                         |    2 +-
 tools/perf/util/dso-test-data.c                    |  154 ++++++
 tools/perf/util/event.h                            |   16 +-
 tools/perf/util/evlist.c                           |    8 +
 tools/perf/util/evlist.h                           |    1 +
 tools/perf/util/evsel.c                            |   41 ++-
 tools/perf/util/header.c                           |    3 +
 tools/perf/util/include/linux/compiler.h           |    1 +
 tools/perf/util/include/linux/kernel.h             |   10 +
 tools/perf/util/map.c                              |   23 +-
 tools/perf/util/map.h                              |    9 +-
 tools/perf/util/perf_regs.h                        |   14 +
 tools/perf/util/python.c                           |    3 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    3 +-
 .../util/scripting-engines/trace-event-python.c    |    3 +-
 tools/perf/util/session.c                          |  111 ++++-
 tools/perf/util/session.h                          |   15 +-
 tools/perf/util/symbol.c                           |  435 ++++++++++++---
 tools/perf/util/symbol.h                           |   52 ++-
 tools/perf/util/trace-event-scripting.c            |    3 +-
 tools/perf/util/trace-event.h                      |    5 +-
 tools/perf/util/unwind.c                           |  567 ++++++++++++++++++++
 tools/perf/util/unwind.h                           |   34 ++
 tools/perf/util/vdso.c                             |   90 +++
 tools/perf/util/vdso.h                             |    8 +
 52 files changed, 2385 insertions(+), 211 deletions(-)
