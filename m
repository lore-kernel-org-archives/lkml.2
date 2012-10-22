Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab2JVJrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:47:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54597 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2JVJrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:47:16 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v5 3/6] perf tools: add --addr2line command line option
Date: Mon, 22 Oct 2012 12:46:09 +0300
Message-Id: <1350899172-16965-4-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350899172-16965-1-git-send-email-irina.tirdea@gmail.com>
References: <1350899172-16965-1-git-send-email-irina.tirdea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

When analyzing data recorded on a target with a different architecture
than the host, we must use addr2line from the toolchain for that
architecture.

Add a command line option to allow setting addr2line at runtime.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/Documentation/perf-annotate.txt |    2 ++
 tools/perf/Documentation/perf-report.txt   |    2 ++
 tools/perf/builtin-annotate.c              |    3 +++
 tools/perf/builtin-report.c                |    3 +++
 tools/perf/util/annotate.c                 |    5 ++++-
 tools/perf/util/sort.c                     |    3 ++-
 tools/perf/util/sort.h                     |    1 +
 7 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index c8ffd9f..177906a 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -87,6 +87,8 @@ OPTIONS
 
 --objdump=<path>::
         Path to objdump binary.
+--addr2line=<path>::
+        Path to addr2line binary.
 
 SEE ALSO
 --------
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index f4d91be..b6bb26e 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -170,6 +170,8 @@ OPTIONS
 
 --objdump=<path>::
         Path to objdump binary.
+--addr2line=<path>::
+        Path to addr2line binary.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index c4bb645..e4df5da 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -292,6 +292,9 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_STRING(0, "addr2line", &addr2line_path, "path",
+		   "addr2line binary to use for obtaining "
+		   "file names and line numbers"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 90d1162..9c0fe68 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -642,6 +642,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_STRING(0, "addr2line", &addr2line_path, "path",
+		   "addr2line binary to use for obtaining "
+		   "file names and line numbers"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f0a9103..9c0fa54 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -18,6 +18,7 @@
 
 const char 	*disassembler_style;
 const char	*objdump_path;
+const char	*addr2line_path;
 
 static struct ins *ins__find(const char *name);
 static int disasm_line__parse(char *line, char **namep, char **rawp);
@@ -915,7 +916,9 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 			continue;
 
 		offset = start + i;
-		sprintf(cmd, "addr2line -e %s %016" PRIx64, filename, offset);
+		sprintf(cmd, "%s -e %s %016" PRIx64,
+			addr2line_path ? addr2line_path : "addr2line",
+			filename, offset);
 		fp = popen(cmd, "r");
 		if (!fp)
 			continue;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d579406..19cc046 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -268,7 +268,8 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	     strlen(PERF_TMP_DIR "/perf-")))
 		goto out_ip;
 
-	snprintf(cmd, sizeof(cmd), "addr2line -e %s %016" PRIx64,
+	snprintf(cmd, sizeof(cmd), "%s -e %s %016" PRIx64,
+		 addr2line_path ? addr2line_path : "addr2line",
 		 self->ms.map->dso->long_name, self->ip);
 	fp = popen(cmd, "r");
 	if (!fp)
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 13761d8..c8e58f6 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -139,6 +139,7 @@ struct sort_entry {
 
 extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
+extern const char *addr2line_path;
 
 void setup_sorting(const char * const usagestr[], const struct option *opts);
 extern int sort_dimension__add(const char *);
-- 
1.7.9.5

