Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2IWTuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 15:50:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49948 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab2IWTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 15:50:21 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v3 4/4] perf tools: configure addr2line path at compile time
Date: Sun, 23 Sep 2012 22:49:59 +0300
Message-Id: <1348429799-28473-1-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348428446-28245-5-git-send-email-irina.tirdea@gmail.com>
References: <1348428446-28245-5-git-send-email-irina.tirdea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

The default name for addr2line is hardcoded to "addr2line".
When cross-compiling the name of addr2line will be different
(e.g. arm-eabi-addr2line in Android).

Set the default addr2line name in the Makefile with DEFAULT_ADDR2LINE_PATH.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---

Changes in v3:
 () Fixed typo in commit message.

 tools/perf/Makefile        |    6 +++++-
 tools/perf/util/annotate.c |    3 ++-
 tools/perf/util/sort.c     |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7a3f572..745d12b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -141,6 +141,7 @@ endif
 lib = lib
 PERF_TMP_DIR = /tmp
 OBJDUMP = $(CROSS_COMPILE)objdump
+ADDR2LINE = $(CROSS_COMPILE)addr2line
 
 export prefix bindir sharedir sysconfdir
 
@@ -885,7 +886,7 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 		$<
 
 $(OUTPUT)util/annotate.o: util/annotate.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DDEFAULT_OBJDUMP_PATH='"$(OBJDUMP)"' $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DDEFAULT_OBJDUMP_PATH='"$(OBJDUMP)"' -DDEFAULT_ADDR2LINE_PATH='"$(ADDR2LIN)"' $<
 
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
@@ -896,6 +897,9 @@ $(OUTPUT)util/dso-test-data.o: util/dso-test-data.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/map.o: util/map.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
 
+$(OUTPUT)util/sort.o: util/sort.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DDEFAULT_ADDR2LINE_PATH='"$(addr2line)"' $<
+
 $(OUTPUT)util/symbol.o: util/symbol.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index d7036b3..7734a03 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -915,7 +915,8 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 			continue;
 
 		offset = start + i;
-		sprintf(cmd, "addr2line -e %s %016" PRIx64, filename, offset);
+		sprintf(cmd, DEFAULT_ADDR2LINE_PATH " -e %s %016" PRIx64,
+			filename, offset);
 		fp = popen(cmd, "r");
 		if (!fp)
 			continue;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b5b1b92..357dfc8 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -260,7 +260,7 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (path != NULL)
 		goto out_path;
 
-	snprintf(cmd, sizeof(cmd), "addr2line -e %s %016" PRIx64,
+	snprintf(cmd, sizeof(cmd), DEFAULT_ADDR2LINE_PATH " -e %s %016" PRIx64,
 		 self->ms.map->dso->long_name, self->ip);
 	fp = popen(cmd, "r");
 	if (!fp)
-- 
1.7.9.5

