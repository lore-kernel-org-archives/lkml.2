Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2ENHMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:12:09 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62027 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab2ENHMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:12:08 -0400
X-AuditID: 9c93016f-b7cecae000000e00-c2-4fb0b0459a64
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC 0/5] perf tools: Minimalistic build without libelf dependency
Date: Mon, 14 May 2012 16:10:19 +0900
Message-Id: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

NOTE: This is a RFC patchset and it contains a lot of rough edges
and ugly codes.

Current build procedure of perf tools requires a couple of external
libraries. Although most of them are optional, elfutils' libelf is
mandatory for resolving symbols and build-id of the binaries being
profiled. For some reason, it makes embedded guys' life harder who
want to build and run perf tools on their boards.

This patch set tries to fix the problem by letting the perf could
be built without libelf. The initial intent was just providing
perf record command to gather performance events interested on the
system and copies the data to development box to be used by perf
report for analysis.

However it's changed to have most of perf commands as is because
perf can resolve kernel symbols without libelf and many of perf
commands deal (mostly) with kernel events - so no need to restrict
capability of perf tools. Therefore, the end result is not so
minimalistic in fact and only thing it cannot do is "perf probe".

And then I realized that the perf record needs to know about the
build-id's anyway :(. So I implemented a poor man's version of elf
parser only for parsing the build-id info.

To build a minimal perf tools, pass MINIMAL=1 to make. The perf
report will not display symbol names:

 # Samples: 988  of event 'cycles'
 # Event count (approx.): 3726465542
 #
 # Overhead  Command      Shared Object                     Symbol
 # ........  .......  .................  .........................
 #
     98.40%  noploop  noploop            [.] 0x000000000000066d   
      1.35%  noploop  ld-2.15.so         [.] 0x000000000000bab1   
      0.10%  noploop  [kernel.kallsyms]  [k] native_write_msr_safe
      0.10%  noploop  [kernel.kallsyms]  [k] scheduler_tick       
      0.03%  noploop  [kernel.kallsyms]  [k] bad_range            
      0.01%  noploop  [kernel.kallsyms]  [k] pipe_read            

But perf buildid-list can show you the build-id's:

 $ ./perf buildid-list
 ebfc1bdb98999c64d36ddfe394c58df3de6cbcfb [kernel.kallsyms]
 52f0c5f25b95075e6fd7682763f7c3a779a4e889 /usr/lib64/ld-2.15.so
 43a7a2b399b6ee2ff29c6bdadbda6bff88712ed4 /home/namhyung/bin/noploop

So it can be packed using perf archive so copied and analized
with full-fledged perf tools on a development machine.

This patchset is based on commit cb04ff9ac424 ("sched, perf: Use
a single callback into the scheduler") and tested on x86_64 and arm.

Any comments are welcome, thanks.
Namhyung


Namhyung Kim (5):
  perf symbols: Introduce symbol__elf_init()
  perf symbols: Do not use ELF's symbol binding constants
  perf tools: Split out util/symbol-elf.c
  perf tools: Support minimal build
  perf symbols: Implement poor man's ELF parser

 tools/perf/Makefile                 |   29 ++
 tools/perf/builtin-buildid-list.c   |    4 +-
 tools/perf/builtin-top.c            |    5 +-
 tools/perf/command-list.txt         |    2 +-
 tools/perf/perf.c                   |    2 +
 tools/perf/ui/browsers/map.c        |    5 +-
 tools/perf/util/elf-minimal.h       |  153 ++++++++
 tools/perf/util/generate-cmdlist.sh |   15 +
 tools/perf/util/symbol-elf.c        |  691 +++++++++++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c    |  258 +++++++++++++
 tools/perf/util/symbol.c            |  712 ++---------------------------------
 tools/perf/util/symbol.h            |   20 +
 12 files changed, 1195 insertions(+), 701 deletions(-)
 create mode 100644 tools/perf/util/elf-minimal.h
 create mode 100644 tools/perf/util/symbol-elf.c
 create mode 100644 tools/perf/util/symbol-minimal.c

-- 
1.7.10.1

