Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab2A3EoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 23:44:16 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59473 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2A3EoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 23:44:15 -0500
X-AuditID: b753bd60-98392ba000007b1b-9e-4f26201c3202
X-AuditID: b753bd60-98392ba000007b1b-9e-4f26201c3202
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v5 0/5] perf script: add BTS analysis features
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 30 Jan 2012 13:42:42 +0900
Message-ID: <20120130044242.2384.23076.stgit@linux3>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic, David,

This patch series adds the functions to analyze BTS logs to perf-script and,
makes perf-script more informative version 5.
The patches add the following functions.
 - Unify the expression to "[unknown]"
 - Fix BTS record header to resolve DSOs and symbols of user-space
 - Resolve DSOs and symbols for BTS's branch_from addresses
 - Show the offset of symbols with the 'symoff' field specifier.
 - Resolve the real path of [kernel.kallsym] using
   '--show-kernel-path' option.

Usage:
First, get the BTS log with the following command.
# perf record -e branches:u -c 1 -d <command>

Second, analyze that trace data.
# perf script -f ip,addr,sym,symoff,dso [--show-kernel-path]
This command's output format is:
<branch_from addr> <branch_from function+offset> <branch_from DSO> => <branch_to addr> <branch_to function+offset> <branch_to DSO> 

Output sample:
# perf record -e branches:u -c 1 -d ls
[snip]
# perf script -f ip,addr,sym,dso,symoff --show-kernel-path
[snip]
      3430c21399 __libc_start_main+0xe9 (/lib64/libc-2.14.so)               => 402c1c main+0x0             (/root/bin/ls)
          402c41 main+0x25              (/root/bin/ls)                      => 40b390 set_program_name+0x0 (/root/bin/ls)
ffffffff814ac5ed irq_return+0x0         (/lib/modules/3.2.0+/build/vmlinux) => 40b390 set_program_name+0x0 (/root/bin/ls)
          40b39e set_program_name+0xe   (/root/bin/ls)                      => 401e20 strrchr@plt+0x0      (/root/bin/ls)
          401e20 strrchr@plt+0x0        (/root/bin/ls)                      => 401e26 strrchr@plt+0x6      (/root/bin/ls)
          401e2b strrchr@plt+0xb        (/root/bin/ls)                      => 401b80 _init+0x18           (/root/bin/ls)
          401b86 _init+0x1e             (/root/bin/ls)                      => 3430813850 _dl_runtime_resolve+0x0 (/lib64/ld-2.14.so)
[snip]

It shows the tracee application's execution path.


Future Works:
 - add source code path field, line number field ...etc.
 - add record/report script to use easily and, show human-friendly output.
 - filtering kernel functions using scripts

Changes in v5:
 - Use fprintf() instead of printf() in struct map/symbol's functions
   to print something.
 - Abolish using 'self' in function's paramater
   e.g. map__print_dsoname(self) => map__fprintf_dsoname(map, fp)
 - Change the specifier to print symbol_offset 'offs' to 'symoff'
 - Change the output format "<branch_to> <branch_from>" to
   "<branch_from> => <branch_to>"

Changes in v4:
 - add check routine to set correct perf_sample's header.

Changes in v3:
 - remove the bug fix patch already fixed.
 - unify the "[unknown]" expressions in perf-script.
 - fix perf_event_header of BTS events.
 - fix patch's descriptions

Changes in v2:
 - add a bug fix patch that prints correct IP address
 - output the magic word "(unknown)" as symbol name when perf-script can't
   resolve symbols.
 - output "[unknown]" as DSO name when perf-script can't resolve DSO path.
 - change the way to output offset of symbols from '--show-symbol-offset' to
   'offs' field.
 - clean up codes.

Thanks,

---

Akihiro Nagai (5):
      perf script: add option resolving vmlinux path
      perf script: add the offset field specifier
      perf script: print branch_from and branch_to of BTS events
      perf: set correct value to perf_event_header.misc for BTS
      perf-script: unify the expressions indicate "unknown"


 arch/x86/kernel/cpu/perf_event_intel_ds.c |   31 +++++++----
 tools/perf/Documentation/perf-script.txt  |    5 +-
 tools/perf/builtin-script.c               |   80 ++++++++++++++++++++++++-----
 tools/perf/util/map.c                     |   15 +++++
 tools/perf/util/map.h                     |    1 
 tools/perf/util/session.c                 |   39 +++++---------
 tools/perf/util/session.h                 |    2 -
 tools/perf/util/symbol.c                  |   22 ++++++++
 tools/perf/util/symbol.h                  |    4 +
 9 files changed, 147 insertions(+), 52 deletions(-)

-- 
Akihiro Nagai (akihiro.nagai.hw@hitachi.com)
