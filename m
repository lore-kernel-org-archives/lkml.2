Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab2HFEra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:47:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52194 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2HFEr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:47:29 -0400
X-AuditID: 9c930197-b7b66ae000006a2c-74-501f4c5f5648
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHSET 0/4] perf tools: Minimal build without libelf dependency (v4)
Date: Mon,  6 Aug 2012 13:41:18 +0900
Message-Id: <1344228082-15569-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my forth version of the series. Please consider applying. :)

v4:
 * rebase on current tip/perf/core

v3:
 * drop already merged (cross-build related) patches
 * drop SYMBIND_* change (Arnaldo)

v2:
 * change make option name to NO_LIBELF
 * make it default when libelf doesn't exist (Ingo)
 * get rid of elf-minimal.h and use elf.h (Jiri)

Original description follows:

-- 

Current build procedure of perf tools requires a couple of external
libraries. Although most of them are optional, elfutils' libelf is
mandatory for resolving symbols and build-id of the binaries being
profiled. For some reason, it makes embedded guys' life harder who
want to build and run perf tools on their boards.

This patchset tries to fix the problem by letting the perf could
be built without the libelf. The initial intent was just providing
perf record command to gather performance events interested on the
system and copies perf.data to development box to be used by (full-
fledged) perf report for analysis.

However it's changed to have most of perf commands as is because
perf can resolve kernel symbols without libelf and many of perf
commands deal (mostly) with kernel events - so no need to restrict
capability of perf tools. Therefore, the end result is not so
minimalistic actually and the only thing it cannot do is "perf probe".

And there's a poor man's version of ELF parser only for parsing the
build-id info. While it's not absolutely needed, I think it's good to
have, just in case.

In addition, I changed my mind to keep unrelated configurations -
i.g. tui/gui and perf/python support - enabled by default so that
it can be configured by a find-grained config method in the future.

To build a minimal perf tools explicitly, pass NO_LIBELF=1 to make.
Or, if the system doesn't provide the elfutils it'll detect that
and converts to the minimal build mode automatically. The resulting
perf report will not display symbol names in userland:

 # Samples: 3K of event 'cycles'
 # Event count (approx.): 3740267998
 #
 # Overhead  Command      Shared Object                          Symbol
 # ........  .......  .................  ..............................
 #
     99.70%  noploop  noploop            [.] 0x000000000000066d        
      0.10%  noploop  [kernel.kallsyms]  [k] free_pgd_range            
      0.03%  noploop  [kernel.kallsyms]  [k] native_write_msr_safe     
      0.03%  noploop  [kernel.kallsyms]  [k] raise_softirq             
      0.03%  noploop  [kernel.kallsyms]  [k] rb_insert_color       
 
But perf buildid-list can show the build-id's:

 $ ./perf buildid-list --with-hits
 5eaf1839576cc801053e63300762def90a77a305 [kernel.kallsyms]
 43a7a2b399b6ee2ff29c6bdadbda6bff88712ed4 /home/namhyung/bin/noploop

So it can be packed using perf archive command and copied and
analized with full-fledged perf tools on a development machine.


Namhyung Kim (4):
  perf symbols: Introduce symbol__elf_init()
  perf tools: Split out util/symbol-elf.c
  perf tools: Support minimal build without libelf
  perf symbols: Implement poor man's ELF parser

 tools/perf/Makefile                 |  58 ++-
 tools/perf/builtin-buildid-list.c   |   4 +-
 tools/perf/builtin-inject.c         |   5 +-
 tools/perf/command-list.txt         |   2 +-
 tools/perf/perf.c                   |   2 +
 tools/perf/util/generate-cmdlist.sh |  15 +
 tools/perf/util/map.c               |  22 +-
 tools/perf/util/map.h               |   1 +
 tools/perf/util/symbol-elf.c        | 775 ++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c    | 267 ++++++++++++
 tools/perf/util/symbol.c            | 802 +-----------------------------------
 tools/perf/util/symbol.h            |  16 +
 12 files changed, 1156 insertions(+), 813 deletions(-)
 create mode 100644 tools/perf/util/symbol-elf.c
 create mode 100644 tools/perf/util/symbol-minimal.c

-- 
1.7.11.2

