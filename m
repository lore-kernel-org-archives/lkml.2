Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab1I2WtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:49:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:43967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab1I2WsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/16] perf: Support setting the disassembler style
Date: Thu, 29 Sep 2011 19:48:07 -0300
Message-Id: <1317336490-19437-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add -M option to report/annotate to pass directly to objdump.  This
allows to use -M intel for intel style disassembler syntax, which is
useful for people who are very used to the Intel syntax.

Link: http://lkml.kernel.org/r/1316122302-24306-2-git-send-email-andi@firstfloor.org
[committer note: Add missing Documentation bits, fixup conflicts with 3e6a2a7]
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt |    3 +++
 tools/perf/Documentation/perf-report.txt   |    3 +++
 tools/perf/builtin-annotate.c              |    2 ++
 tools/perf/builtin-report.c                |    2 ++
 tools/perf/util/annotate.c                 |    6 +++++-
 tools/perf/util/annotate.h                 |    2 ++
 6 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 98a31e3..0102d83 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -83,6 +83,9 @@ OPTIONS
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
 
+-M::
+--disassembler-style=:: Set disassembler style for objdump.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 04253c0..6349b6c 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -134,6 +134,9 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+-M::
+--disassembler-style=:: Set disassembler style for objdump.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index c5be288..cf68819 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -273,6 +273,8 @@ static const struct option options[] = {
 		    "Interleave source code with assembly code (default)"),
 	OPT_BOOLEAN('0', "asm-raw", &symbol_conf.annotate_asm_raw,
 		    "Display raw encoding of assembly instructions (default)"),
+	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
+		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d7ff277..a0673ee 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -487,6 +487,8 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
+		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 01d36ba..bc8f477 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -16,6 +16,8 @@
 #include "annotate.h"
 #include <pthread.h>
 
+const char 	*disassembler_style;
+
 int symbol__annotate_init(struct map *map __used, struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
@@ -323,9 +325,11 @@ fallback:
 		 dso, dso->long_name, sym, sym->name);
 
 	snprintf(command, sizeof(command),
-		 "objdump --start-address=0x%016" PRIx64
+		 "objdump %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64
 		 " -d %s %s -C %s|grep -v %s|expand",
+		 disassembler_style ? "-M " : "",
+		 disassembler_style ? disassembler_style : "",
 		 map__rip_2objdump(map, sym->start),
 		 map__rip_2objdump(map, sym->end),
 		 symbol_conf.annotate_asm_raw ? "" : "--no-show-raw",
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index c2c2868..6ede128 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -100,4 +100,6 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			 int refresh);
 #endif
 
+extern const char	*disassembler_style;
+
 #endif	/* __PERF_ANNOTATE_H */
-- 
1.6.2.5

