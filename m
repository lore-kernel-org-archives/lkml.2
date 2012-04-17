Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2DQLSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:18:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab2DQLSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:18:04 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com
Subject: [RFCv2 00/15] perf: Add backtrace post dwarf unwind 
Date: Tue, 17 Apr 2012 13:17:05 +0200
Message-Id: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending another RFC version. There are some fixies and some
yet unresolved issues outlined below.

thanks for comments,
jirka

v2 changes:
	02/16 - fixed register enums
	12/16 - fixed the perf_evlist__* names
	14/16 - 'fp' stays default even if compiled with dwarf unwind
	15/16 - added cache to the DSO data interface, it makes the
                dwarf unwind real fast now

v2 not solved yet:
  1) generic user regs capturing
     discussed in here:
       http://marc.info/?l=linux-kernel&m=133304076114629&w=2

     Looks like we could have a generic way of getting registers
     on samples and support more than only user level registers.
     But looks like it wasn't completely decided what register
     levels are worth to store..

     It looks to me that each level could add its own registers
     mask and it'd be used/saved if the mask is non zero.
     The same way the user level regs are dealt with now ;).

     Or we could add something that Stephane came up with:
       attr->sample_type |= PERF_SAMPLE_REGS
       attr->sample_regs = EAX | EBX | EDI | ESI |.....
       attr->sample_reg_mode = { INTR, PRECISE, USER }

     But I guess we need to decide what levels make sense
     to store first. Also if there's like 2 or 3 only, it might be
     better to use separate masks as pointed out above.

  2) compat task handling
     we dont handle compat tasks unwinding currently, we probably want
     to make it part of the 1) solution or add something like:
	__u64 user_regs_compat;

     Handling the compat task would also need some other changes in the
     unwind code and I'm not completely sure how libunwind deals with that,
     need to check.

     How much do we want this? ;)

  3) registers version names
     this one is now probably connected to 1) and 2) ;)
     I kept the register version, since I think it might be usefull
     for dealing with compat tasks - to recognize what type of registers
     were stored

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
 01/16 uaccess: Add new copy_from_user_gup API
 02/16 perf: Unified API to record selective sets of arch registers
 03/16 perf: Add ability to dump user regs
 04/16 perf: Add ability to dump part of the user stack
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
 arch/x86/include/asm/perf_regs.h                   |   16 +
 arch/x86/include/asm/perf_regs_32.h                |   84 +++
 arch/x86/include/asm/perf_regs_64.h                |  101 ++++
 arch/x86/include/asm/uaccess.h                     |    7 +-
 arch/x86/kernel/cpu/perf_event.c                   |    4 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |    3 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |    2 +-
 arch/x86/lib/usercopy.c                            |    4 +-
 arch/x86/oprofile/backtrace.c                      |    4 +-
 include/asm-generic/perf_regs.h                    |   23 +
 include/asm-generic/uaccess.h                      |    4 +
 include/linux/perf_event.h                         |   18 +-
 kernel/events/callchain.c                          |    4 +-
 kernel/events/core.c                               |  127 +++++-
 kernel/events/internal.h                           |   59 ++-
 kernel/events/ring_buffer.c                        |    4 +-
 tools/perf/Makefile                                |   41 ++-
 tools/perf/arch/x86/Makefile                       |    3 +
 tools/perf/arch/x86/include/perf_regs.h            |  101 ++++
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
 tools/perf/util/event.h                            |   15 +-
 tools/perf/util/evlist.c                           |   16 +
 tools/perf/util/evlist.h                           |    2 +
 tools/perf/util/evsel.c                            |   35 ++-
 tools/perf/util/include/linux/compiler.h           |    1 +
 tools/perf/util/map.c                              |   23 +-
 tools/perf/util/map.h                              |    7 +-
 tools/perf/util/perf_regs.h                        |   10 +
 tools/perf/util/python.c                           |    3 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    3 +-
 .../util/scripting-engines/trace-event-python.c    |    3 +-
 tools/perf/util/session.c                          |  104 ++++-
 tools/perf/util/session.h                          |   10 +-
 tools/perf/util/symbol.c                           |  435 +++++++++++++---
 tools/perf/util/symbol.h                           |   52 ++-
 tools/perf/util/trace-event-scripting.c            |    3 +-
 tools/perf/util/trace-event.h                      |    5 +-
 tools/perf/util/unwind.c                           |  565 ++++++++++++++++++++
 tools/perf/util/unwind.h                           |   34 ++
 tools/perf/util/vdso.c                             |   90 +++
 tools/perf/util/vdso.h                             |    8 +
 50 files changed, 2315 insertions(+), 199 deletions(-)
