Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2IDKcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 06:32:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41425 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab2IDKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 06:32:34 -0400
Message-ID: <1346754750.16299.3.camel@localhost.localdomain>
Subject: [PATCH] perf: allow user to indicate path to objdump in command line
From: Maciek Borzecki <maciek.borzecki@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Date: Tue, 04 Sep 2012 12:32:30 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When analyzing perf data from hosts of other architecture than one of the local
host it's useful to call objdump that is part of a toolchain for that
architecture. Instead of calling regular objdump, call one that user specified
in command line.

Signed-off-by: Maciek Borzecki <maciek.borzecki@gmail.com>
---
 tools/perf/Documentation/perf-annotate.txt | 3 +++
 tools/perf/Documentation/perf-report.txt   | 3 +++
 tools/perf/builtin-annotate.c              | 2 ++
 tools/perf/builtin-report.c                | 2 ++
 tools/perf/util/annotate.c                 | 4 +++-
 tools/perf/util/annotate.h                 | 1 +
 6 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index c89f9e1..c8ffd9f 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -85,6 +85,9 @@ OPTIONS
 -M::
 --disassembler-style=:: Set disassembler style for objdump.
 
+--objdump=<path>::
+        Path to objdump binary.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 2d89f02..2da267f 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -168,6 +168,9 @@ OPTIONS
 	branch stacks and it will automatically switch to the branch view mode,
 	unless --no-branch-stack is used.
 
+--objdump=<path>::
+        Path to objdump binary.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 67522cf..2f3f002 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -282,6 +282,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 		    "Display raw encoding of assembly instructions (default)"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
+	OPT_STRING(0, "objdump", &objdump_path, "path",
+		   "objdump binary to use for disassembly and annotations"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 25249f7..dad231b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -635,6 +635,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		    "Show a column with the sum of periods"),
 	OPT_CALLBACK_NOOPT('b', "branch-stack", &sort__branch_mode, "",
 		    "use branch records for histogram filling", parse_branch_mode),
+	OPT_STRING(0, "objdump", &objdump_path, "path",
+		   "objdump binary to use for disassembly and annotations"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 8069dfb..be7290c 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -17,6 +17,7 @@
 #include <pthread.h>
 
 const char 	*disassembler_style;
+const char	*objdump_path;
 
 static struct ins *ins__find(const char *name);
 static int disasm_line__parse(char *line, char **namep, char **rawp);
@@ -809,9 +810,10 @@ fallback:
 		 dso, dso->long_name, sym, sym->name);
 
 	snprintf(command, sizeof(command),
-		 "objdump %s%s --start-address=0x%016" PRIx64
+		 "%s %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64
 		 " -d %s %s -C %s|grep -v %s|expand",
+		 objdump_path ? objdump_path : "objdump",
 		 disassembler_style ? "-M " : "",
 		 disassembler_style ? disassembler_style : "",
 		 map__rip_2objdump(map, sym->start),
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 78a5692..a6d6bc5 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -152,5 +152,6 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 #endif
 
 extern const char	*disassembler_style;
+extern const char	*objdump_path;
 
 #endif	/* __PERF_ANNOTATE_H */
-- 
1.7.11.4



