Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055Ab1IOVby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:31:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:43244 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab1IOVby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:31:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48896184"
From: Andi Kleen <andi@firstfloor.org>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] perf: Support setting the disassembler style
Date: Thu, 15 Sep 2011 14:31:41 -0700
Message-Id: <1316122302-24306-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316122302-24306-1-git-send-email-andi@firstfloor.org>
References: <1316122302-24306-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add -M option to report/annotate to pass directly to objdump.
This allows to use -M intel for intel style disassembler syntax,
which is useful for people who are very used to the Intel syntax.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-annotate.txt |    3 +++
 tools/perf/Documentation/perf-report.txt   |    3 +++
 tools/perf/builtin-annotate.c              |    2 ++
 tools/perf/builtin-report.c                |    2 ++
 tools/perf/util/annotate.c                 |    6 +++++-
 tools/perf/util/annotate.h                 |    2 ++
 6 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 85c5f02..4a42c31 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -72,6 +72,9 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+-M::
+--disassembler-style=:: Set disassembler style for objdump.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 04253c0..0407c8c 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -134,6 +134,9 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+-m::
+--disassembler-style=:: Set disassembler style for objdump.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 555aefd..5b0a0ac 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -267,6 +267,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the displayed pathnames"),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
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
index e01af2b..6495966 100644
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
@@ -323,8 +325,10 @@ fallback:
 		 dso, dso->long_name, sym, sym->name);
 
 	snprintf(command, sizeof(command),
-		 "objdump --start-address=0x%016" PRIx64
+		 "objdump %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64 " -dS -C %s|grep -v %s|expand",
+		 disassembler_style ? "-M " : "",
+		 disassembler_style ? disassembler_style : "",
 		 map__rip_2objdump(map, sym->start),
 		 map__rip_2objdump(map, sym->end),
 		 symfs_filename, filename);
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
1.7.4.4

