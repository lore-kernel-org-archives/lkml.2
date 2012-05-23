Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993Ab2EWTct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:32:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933039Ab2EWTco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:32:44 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org
Subject: [RFCv4 00/16] perf: Add backtrace post dwarf unwind 
Date: Wed, 23 May 2012 21:31:59 +0200
Message-Id: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
v3 does not apply to current tip anymore, sending rebased version

also available as tarball in here:
http://people.redhat.com/~jolsa/perf_post_unwind_v4.tar.bz2

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
  01/16 perf: Unified API to record selective sets of arch registers
  02/16 perf: Add ability to attach registers dump to sample
  03/16 perf: Factor __output_copy to be usable with specific copy function
  04/16 perf: Add ability to attach user stack dump to sample
  05/16 perf: Add attribute to filter out user callchains
  06/16 perf, tool: Factor DSO symtab types to generic binary types
  07/16 perf, tool: Add interface to read DSO image data
  08/16 perf, tool: Add '.note' check into search for NOTE section
  09/16 perf, tool: Back [vdso] DSO with real data
  10/16 perf, tool: Add interface to arch registers sets
  11/16 perf, tool: Add libunwind dependency for dwarf cfi unwinding
  12/16 perf, tool: Support user regs and stack in sample parsing
  13/16 perf, tool: Support for dwarf cfi unwinding on post processing
  14/16 perf, tool: Support for dwarf mode callchain on perf record
  15/16 perf, tool: Add dso data caching
  16/16 perf, tool: Add dso data caching tests


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
 arch/x86/include/asm/perf_regs.h                   |   10 +
 arch/x86/include/asm/perf_regs_32.h                |   84 +++
 arch/x86/include/asm/perf_regs_64.h                |   99 ++++
 include/linux/perf_event.h                         |   49 ++-
 include/linux/perf_regs.h                          |   28 +
 kernel/events/callchain.c                          |    4 +-
 kernel/events/core.c                               |  204 +++++++-
 kernel/events/internal.h                           |   65 ++-
 kernel/events/ring_buffer.c                        |    4 +-
 tools/perf/Makefile                                |   45 ++-
 tools/perf/arch/x86/Makefile                       |    3 +
 tools/perf/arch/x86/include/perf_regs.h            |  108 ++++
 tools/perf/arch/x86/util/unwind.c                  |  111 ++++
 tools/perf/builtin-record.c                        |   86 +++-
 tools/perf/builtin-report.c                        |   24 +-
 tools/perf/builtin-script.c                        |   56 ++-
 tools/perf/builtin-test.c                          |    7 +-
 tools/perf/builtin-top.c                           |    7 +-
 tools/perf/config/feature-tests.mak                |   25 +
 tools/perf/perf.h                                  |    9 +-
 tools/perf/util/annotate.c                         |    2 +-
 tools/perf/util/dso-test.c                         |  154 ++++++
 tools/perf/util/event.h                            |   16 +-
 tools/perf/util/evlist.c                           |   24 +
 tools/perf/util/evlist.h                           |    3 +
 tools/perf/util/evsel.c                            |   43 ++-
 tools/perf/util/include/linux/compiler.h           |    1 +
 tools/perf/util/map.c                              |   23 +-
 tools/perf/util/map.h                              |    7 +-
 tools/perf/util/perf_regs.h                        |   19 +
 tools/perf/util/python.c                           |    3 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    3 +-
 .../util/scripting-engines/trace-event-python.c    |    3 +-
 tools/perf/util/session.c                          |  134 +++++-
 tools/perf/util/session.h                          |   15 +-
 tools/perf/util/symbol.c                           |  435 +++++++++++++---
 tools/perf/util/symbol.h                           |   52 ++-
 tools/perf/util/trace-event-scripting.c            |    3 +-
 tools/perf/util/trace-event.h                      |    5 +-
 tools/perf/util/unwind.c                           |  565 ++++++++++++++++++++
 tools/perf/util/unwind.h                           |   34 ++
 tools/perf/util/vdso.c                             |   90 +++
 tools/perf/util/vdso.h                             |    8 +
 46 files changed, 2487 insertions(+), 192 deletions(-)
