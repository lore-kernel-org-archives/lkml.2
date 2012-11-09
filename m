Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2KIR2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:28:35 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52364 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab2KIR2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:28:34 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHSET 00/13] perf annotate: Add support for event group view (v1)
Date: Sat, 10 Nov 2012 02:27:11 +0900
Message-Id: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a patchset to support event grouping on perf annotate.

It depends on perf report event group view patchset [1] and contains
a couple of annotate fixup/cleanup patches that I sent yesterday
(although I fixed a compile problem and added a cleanup patch).

The symbol histograms already contain hit counts for every event so it
was relatively easier to support than that of perf report case. I added
a sort of flexible array to struct source_line and browser_disasm_line
for gathering percent values for each group members.

Patch 0001-0004 are cleanups and can be merged separately.  I sent
  similar patches yesterday, and this is the up-to-date version.
Patch 0005-0006 are preparation for later patches and
Patch 0007 added event group view for --stdio.
Patch 0008-0009 added event group view for --print-line and
Patch 0010-0012 added event group view for --tui.
Patch 0013 added --group option to enable group view suport.

Let me show you an example:

  $ perf annotate --group --stdio --print-line
  
  Sorted summary for file /lib/ld-2.11.1.so
  ----------------------------------------------
  
     33.33    0.00 /build/buildd/eglibc-2.11.1/elf/rtld.c:381
     33.33    0.00 /build/buildd/eglibc-2.11.1/elf/dynamic-link.h:128
     33.33    0.00 /build/buildd/eglibc-2.11.1/elf/do-rel.h:105
      0.00   75.00 /build/buildd/eglibc-2.11.1/elf/dynamic-link.h:137
      0.00   25.00 /build/buildd/eglibc-2.11.1/elf/dynamic-link.h:187
   Percent         |      Source code & Disassembly of ld-2.11.1.so
  ------------------------------------------------------------------
                   :
                   :
                   :
                   :      Disassembly of section .text:
                   :
                   :      0000000000001120 <_dl_rtld_di_serinfo-0x7a20>:
      0.00    0.00 :        1120:       push   %rbp
      0.00    0.00 :        1121:       mov    %rsp,%rbp
      0.00    0.00 :        1124:       push   %r15
      0.00    0.00 :        1126:       push   %r14
      0.00    0.00 :        1128:       push   %r13
      0.00    0.00 :        112a:       push   %r12
      0.00    0.00 :        112c:       push   %rbx
      0.00    0.00 :        112d:       mov    %rdi,%rbx
      0.00    0.00 :        1130:       sub    $0x28,%rsp
      0.00    0.00 :        1134:       rdtsc  
      0.00    0.00 :        1136:       shl    $0x20,%rdx
      0.00    0.00 :        113a:       mov    %eax,%eax
      0.00    0.00 :        113c:       or     %rax,%rdx
      0.00    0.00 :        113f:       lea    -0x26(%rip),%r13        # 1120 <free@plt+0x648>
      0.00    0.00 :        1146:       sub    0x21ea93(%rip),%r13        # 21fbe0 <calloc+0x208c80>
   /build/buildd/eglibc-2.11.1/elf/rtld.c:381
     33.33    0.00 :        114d:       mov    %rdx,0x21ec54(%rip)        # 21fda8 <_rtld_global_ro+0x1a8>
      0.00    0.00 :        1154:       mov    %r13,%rdx
  ...
  

You can access it via my tree as well.

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git perf/annotate-group-v1

As always, any comments are welcome, thanks.
Namhyung


[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg337706.html

Namhyung Kim (13):
  perf annotate: Parse --asm-raw output properly
  perf annotate: Whitespace fixups
  perf annotate: Merge same lines in summary view
  perf annotate: Don't try to follow jump target on PLT symbols
  perf annotate: Pass evsel instead of evidx on annotation functions
  perf annotate: Factor out disasm__calc_percent()
  perf annotate: Basic support for event group view
  perf annotate: Factor out struct source_line_percent
  perf annotate: Support event group view for --print-line
  perf annotate browser: Make browser_disasm_line->percent an array
  perf annotate browser: Use disasm__calc_percent()
  perf annotate browser: Support event group view on TUI
  perf annotate: Add --group option

 tools/perf/builtin-annotate.c     |   20 ++-
 tools/perf/builtin-top.c          |    2 +-
 tools/perf/ui/browsers/annotate.c |  151 ++++++++++------
 tools/perf/ui/browsers/hists.c    |    2 +-
 tools/perf/util/annotate.c        |  349 ++++++++++++++++++++++++++++++-------
 tools/perf/util/annotate.h        |   28 ++-
 tools/perf/util/hist.h            |    5 +-
 7 files changed, 418 insertions(+), 139 deletions(-)

-- 
1.7.9.2

