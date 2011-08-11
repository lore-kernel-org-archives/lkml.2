Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1HKMFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:05:36 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34164 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab1HKMFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:05:35 -0400
X-AuditID: b753bd60-a3cafba0000019f4-10-4e43c58dcd6f
X-AuditID: b753bd60-a3cafba0000019f4-10-4e43c58dcd6f
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v3 0/5] perf script: add BTS analysis features
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 11 Aug 2011 21:05:55 +0900
Message-ID: <20110811120555.5900.23642.stgit@linux3>
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
makes perf-script more informative version 3.
The patches add the following functions.
 - Unify the expression to "[unknown]"
 - Fix BTS record header to resolve DSOs and symbols of user-space
 - Resolve DSOs and symbols for BTS's branch_from addresses
 - Show the offset of symbols with the 'offs' field specifier.
 - Resolve the real path of [kernel.kallsym] using
   '--show-kernel-path' option.

Usage:
First, get the BTS log with the following command.
# perf record -e branches:u -c 1 -d <command>

Second, analyze that trace data.
# perf script -f ip,addr,sym,offs,dso [--show-kernel-path]
This command's output format is:
<branch_to addr> <branch_to function+offset> <branch_to DSO> <branch_from addr> <branch_from function+offset> <branch_from DSO>

Output sample:
# perf record -e branches:u -c 1 -d ls
[snip]
# perf script -f ip,addr,sym,dso,offs --show-kernel-path

34308016b0 _start+0x0     (/lib64/ld-2.14.so) ffffffff81465a6d irq_return+0x0 (/lib/modules/3.0.0+/build/vmlinux)
34308016b0 _start+0x0     (/lib64/ld-2.14.so) ffffffff81465a6d irq_return+0x0 (/lib/modules/3.0.0+/build/vmlinux)
3430804b80 _dl_start+0x0  (/lib64/ld-2.14.so)       34308016b3 _start+0x3     (/lib64/ld-2.14.so)
3430804b80 _dl_start+0x0  (/lib64/ld-2.14.so) ffffffff81465a6d irq_return+0x0 (/lib/modules/3.0.0+/build/vmlinux)
3430804ba6 _dl_start+0x26 (/lib64/ld-2.14.so) ffffffff81465a6d irq_return+0x0 (/lib/modules/3.0.0+/build/vmlinux)
3430804bad _dl_start+0x2d (/lib64/ld-2.14.so) ffffffff81465a6d irq_return+0x0 (/lib/modules/3.0.0+/build/vmlinux)
3430804c1d _dl_start+0x9d (/lib64/ld-2.14.so)       3430804bfb _dl_start+0x7b (/lib64/ld-2.14.so)
3430804c00 _dl_start+0x80 (/lib64/ld-2.14.so)       3430804c21 _dl_start+0xa1 (/lib64/ld-2.14.so)
[snip]
401fd0 main+0x0             (/root/bin/ls)       3430c21399 __libc_start_main+0xe9 (/lib64/libc-2.14.so)
409ad0 set_program_name+0x0 (/root/bin/ls)           401ff3 main+0x23              (/root/bin/ls)
409ad0 set_program_name+0x0 (/root/bin/ls) ffffffff81465a6d irq_return+0x0         (/lib/modules/3.0.0+/build/vmlinux)
401ca8 strrchr@plt+0x0      (/root/bin/ls)           409ade set_program_name+0xe   (/root/bin/ls)
401cae strrchr@plt+0x6      (/root/bin/ls)           401ca8 strrchr@plt+0x0        (/root/bin/ls)
401a38 _init+0x18           (/root/bin/ls)           401cb3 strrchr@plt+0xb        (/root/bin/ls)
3430813850 _dl_runtime_resolve+0x0 (/lib64/ld-2.14.so)           401a3e _init+0x1e (/root/bin/ls)
[snip]

It shows the tracee application's execution path.


TODO:
 - add source code path field, line number field ...etc.
 - add record/report script to use easily and, show human-friendly output.
 - filtering kernel functions using scripts

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
      perf script: enhance IP and ADDR correlate detection for BTS
      perf: change perf_event_header.misc to PERF_RECORD_MISC_USER for BTS
      perf-script: unify the expressions indicate "unknown"


 arch/x86/kernel/cpu/perf_event_intel_ds.c |    8 +++++
 tools/perf/Documentation/perf-script.txt  |    5 +++
 tools/perf/builtin-script.c               |   44 +++++++++++++++++++----------
 tools/perf/util/map.c                     |   15 ++++++++++
 tools/perf/util/map.h                     |    1 +
 tools/perf/util/session.c                 |   38 +++++++++----------------
 tools/perf/util/session.h                 |    3 +-
 tools/perf/util/symbol.c                  |   20 +++++++++++++
 tools/perf/util/symbol.h                  |    4 +++
 9 files changed, 96 insertions(+), 42 deletions(-)

-- 
Akihiro Nagai (akihiro.nagai.hw@hitachi.com)
