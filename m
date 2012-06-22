Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761214Ab2FVFlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:41:23 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43654 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab2FVFlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:41:22 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-47-4fe4057f4b87
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: [RFC/PATCHSET 0/8] perf tools: Minimal build without libelf dependency (v2)
Date: Fri, 22 Jun 2012 14:37:34 +0900
Message-Id: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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

And then I realized that the perf record needs to know about the
build-id's anyway. :( So I implemented a poor man's version of elf
parser only for parsing the build-id info.

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

This patchset is based on current tip 32c46e579b68 ("Merge tag
'perf-core-for-mingo' ...") and tested on x86_64 and ARM.

Any comments are welcome.
Namhyung

v2:
 * change make option name to NO_LIBELF
 * make it default when libelf doesn't exist (by Ingo)
 * get rid of elf-minimal.h and use elf.h (by Jiri)


Namhyung Kim (8):
  perf evsel: Fix a build failure on cross compilation
  tools lib traceevent: Make dependency files regeneratable
  tools lib traceevent: Detect build environment changes
  perf symbols: Introduce symbol__elf_init()
  perf symbols: Do not use ELF's symbol binding constants
  perf tools: Split out util/symbol-elf.c
  perf tools: Support minimal build without libelf
  perf symbols: Implement poor man's ELF parser

 tools/lib/traceevent/Makefile       |   18 +-
 tools/perf/Makefile                 |   58 ++-
 tools/perf/builtin-buildid-list.c   |    4 +-
 tools/perf/builtin-inject.c         |    5 +-
 tools/perf/builtin-top.c            |    5 +-
 tools/perf/command-list.txt         |    2 +-
 tools/perf/perf.c                   |    2 +
 tools/perf/ui/browsers/map.c        |    5 +-
 tools/perf/util/evsel.c             |    1 -
 tools/perf/util/generate-cmdlist.sh |   15 +
 tools/perf/util/map.c               |    3 +-
 tools/perf/util/symbol-elf.c        |  719 ++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c    |  261 ++++++++++++
 tools/perf/util/symbol.c            |  740 +----------------------------------
 tools/perf/util/symbol.h            |   20 +
 15 files changed, 1110 insertions(+), 748 deletions(-)
 create mode 100644 tools/perf/util/symbol-elf.c
 create mode 100644 tools/perf/util/symbol-minimal.c

-- 
1.7.10.2

