Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab2HUQcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:32:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32988 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab2HUQcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:32:17 -0400
Date: Tue, 21 Aug 2012 09:32:05 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-f47b58b75f5e2a424834eb15f7565a7458a12f44@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1345391234-71906-1-git-send-email-dsahern@gmail.com>
References: <1345391234-71906-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Fix builds with NO_LIBELF set
Git-Commit-ID: f47b58b75f5e2a424834eb15f7565a7458a12f44
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:32:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f47b58b75f5e2a424834eb15f7565a7458a12f44
Gitweb:     http://git.kernel.org/tip/f47b58b75f5e2a424834eb15f7565a7458a12f44
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 19 Aug 2012 09:47:14 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Aug 2012 09:35:22 -0300

perf symbols: Fix builds with NO_LIBELF set

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
