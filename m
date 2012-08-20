Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2HTQ0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:26:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:56617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab2HTQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/24] perf symbols: Fix builds with NO_LIBELF set
Date: Mon, 20 Aug 2012 13:26:22 -0300
Message-Id: <1345479985-18669-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Build currently fails:
  $ make -C tools/perf O=/tmp/pbuild NO_LIBELF=1

  util/symbol.c: In function ‘dso__load’:
  util/symbol.c:1128:27: error: ‘struct symsrc’ has no member named ‘dynsym’
      CC /tmp/pbuild/util/pager.o
  make: *** [/tmp/pbuild/util/symbol.o] Error 1
  make: *** Waiting for unfinished jobs....

Moving the dynsym reference to symbol-elf.c reveals that NO_LIBELF requires
NO_LIBUNWIND:

  $ make -C tools/perf O=/tmp/pbuild NO_LIBELF=1

      LINK /tmp/pbuild/perf
  /tmp/pbuild/libperf.a(unwind.o): In function `elf_section_offset':
  /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:176: undefined reference to `elf_begin'
  /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:181: undefined reference to `gelf_getehdr'
  /tmp/pbuild/libperf.a(unwind.o): In function `elf_section_by_name':
  /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:157: undefined reference to `elf_nextscn'
  /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:160: undefined reference to `gelf_getshdr'
  /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:161: undefined reference to `elf_strptr'
  /tmp/pbuild/libperf.a(unwind.o): In function `elf_section_offset':
  /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:190: undefined reference to `elf_end'
  /tmp/pbuild/libperf.a(unwind.o): In function `read_unwind_spec':
  /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:190: undefined reference to `elf_end'
  collect2: ld returned 1 exit status
  make: *** [/tmp/pbuild/perf] Error 1
  make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'

This patch fixes both.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1345391234-71906-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile          |    1 +
 tools/perf/util/symbol-elf.c |    3 +++
 tools/perf/util/symbol.c     |    2 +-
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8beff99..90cfecf 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -469,6 +469,7 @@ PYRF_OBJS += $(OUTPUT)util/xyarray.o
 ifdef NO_LIBELF
 	NO_DWARF := 1
 	NO_DEMANGLE := 1
+	NO_LIBUNWIND := 1
 else
 FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
 ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 5b37e13..db0cc92 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -183,6 +183,9 @@ int dso__synthesize_plt_symbols(struct dso *dso, struct symsrc *ss, struct map *
 	Elf *elf;
 	int nr = 0, symidx, err = 0;
 
+	if (!ss->dynsym)
+		return 0;
+
 	elf = ss->elf;
 	ehdr = ss->ehdr;
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2293a4a..753699a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1125,7 +1125,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	else
 		ret = -1;
 
-	if (ret > 0 && runtime_ss->dynsym) {
+	if (ret > 0) {
 		int nr_plt;
 
 		nr_plt = dso__synthesize_plt_symbols(dso, runtime_ss, map, filter);
-- 
1.7.1

