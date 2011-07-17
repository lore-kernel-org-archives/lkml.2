Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1GQJ36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:29:58 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39304 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab1GQJ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:29:56 -0400
X-AuditID: b753bd60-a28adba0000019f4-f4-4e22ab919cd3
X-AuditID: b753bd60-a28adba0000019f4-f4-4e22ab919cd3
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v2 0/6] perf script: add BTS analysis features
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Sun, 17 Jul 2011 18:30:31 +0900
Message-ID: <20110717093031.3447.52715.stgit@linux3>
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
makes perf-script more informative version 2.
The patches add the following functions.
 - Output correct IP address
 - Output "(unknown)" as symbol name when perf-script can't resolve symbols.
 - Output "[unknown]" as DSO name when perf-script can't resolve DSO path.
 - Resolve DSOs and symbols for user-space address
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

301ec016b0      (unknown) (/lib/modules/3.0.0-rc6-tip+/build/vmlinux) ffffffff81467612 irq_return+0x0 (/lib/modules/3.0.0-rc6-tip+/build/vmlinux)
301ec016b0     _start+0x0 (/lib64/ld-2.14.so) ffffffff81467612 irq_return+0x0 (/lib/modules/3.0.0-rc6-tip+/build/vmlinux)
301ec04b70  _dl_start+0x0 (/lib64/ld-2.14.so)       301ec016b3 _start+0x3 (/lib64/ld-2.14.so)
301ec04b70  _dl_start+0x0 (/lib64/ld-2.14.so) ffffffff81467612 irq_return+0x0 (/lib/modules/3.0.0-rc6-tip+/build/vmlinux)
301ec04b96 _dl_start+0x26 (/lib64/ld-2.14.so) ffffffff81467612 irq_return+0x0 (/lib/modules/3.0.0-rc6-tip+/build/vmlinux)
301ec04b9d _dl_start+0x2d (/lib64/ld-2.14.so) ffffffff81467612 irq_return+0x0 (/lib/modules/3.0.0-rc6-tip+/build/vmlinux)
301ec04c0d _dl_start+0x9d (/lib64/ld-2.14.so)       301ec04beb _dl_start+0x7b (/lib64/ld-2.14.so)
[snip]
401fd0                 main+0x0 (/root/bin/ls)       301f021399 __libc_start_main+0xe9 (/lib64/libc-2.14.so)
409ad0     set_program_name+0x0 (/root/bin/ls)           401ff3 main+0x23 (/root/bin/ls)
409ad0     set_program_name+0x0 (/root/bin/ls) ffffffff81467612 irq_return+0x0 (/lib/modules/3.0.0-rc6-tip+/build/vmlinux)
401ca8          strrchr@plt+0x0 (/root/bin/ls)           409ade set_program_name+0xe (/root/bin/ls)
401cae          strrchr@plt+0x6 (/root/bin/ls)           401ca8 strrchr@plt+0x0 (/root/bin/ls)
401a38               _init+0x18 (/root/bin/ls)           401cb3 strrchr@plt+0xb (/root/bin/ls)
301ec13840 _dl_runtime_resolve+0x0 (/lib64/ld-2.14.so)   401a3e _init+0x1e (/root/bin/ls)
301ec0d6a0        _dl_fixup+0x0 (/lib64/ld-2.14.so)  301ec13870 _dl_runtime_resolve+0x30 (/lib64/ld-2.14.so)
[snip]

It shows the tracee application's execution path.


TODO:
 - add source code path field, line number field ...etc.
 - add record/report script to use easily and, show human-friendly output.
 - filtering kernel functions using scripts

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

Akihiro Nagai (6):
      perf script: add option resolving vmlinux path
      perf script: add the offset field specifier
      perf script: print DSOs and symbols for BTS branch_from addr
      perf script: resolve DSOs and symbols for user-space
      perf script: add magic word to indicate the failure of resolving symbols
      [BUGFIX] perf script: print correct IP address


 tools/perf/Documentation/perf-script.txt |    5 +++
 tools/perf/builtin-script.c              |   46 +++++++++++++++++++++---------
 tools/perf/util/event.c                  |    5 +++
 tools/perf/util/map.c                    |   15 ++++++++++
 tools/perf/util/map.h                    |    1 +
 tools/perf/util/session.c                |   42 ++++++++++-----------------
 tools/perf/util/session.h                |    3 +-
 tools/perf/util/symbol.c                 |   21 ++++++++++++++
 tools/perf/util/symbol.h                 |    4 +++
 9 files changed, 100 insertions(+), 42 deletions(-)

-- 
Akihiro Nagai (akihiro.nagai.hw@hitachi.com)
