Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab2JOXf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:35:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48063 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab2JOXfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:35:24 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v4 3/6] perf tools: add --addr2line command line option
Date: Tue, 16 Oct 2012 02:33:37 +0300
Message-Id: <1350344020-8071-4-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
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
 tools/perf/util/annotate.c                 |   13 ++++++++++++-
 tools/perf/util/sort.c                     |   14 +++++++++++---
 tools/perf/util/sort.h                     |    1 +
 7 files changed, 34 insertions(+), 4 deletions(-)

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
index 690fa9a..10d6ca4 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -285,6 +285,9 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_STRING(0, "addr2line", &addr2line_path, "path",
+		   "addr2line binary to use for obtaining "
+		   "file names and line numbers"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5104a40..3d30a9a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -641,6 +641,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_STRING(0, "addr2line", &addr2line_path, "path",
+		   "addr2line binary to use for obtaining "
+		   "file names and line numbers"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f0a9103..bf5573f 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -18,6 +18,7 @@
 
 const char 	*disassembler_style;
 const char	*objdump_path;
+const char	*addr2line_path;
 
 static struct ins *ins__find(const char *name);
 static int disasm_line__parse(char *line, char **namep, char **rawp);
@@ -894,10 +895,18 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	struct source_line *src_line;
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
+	char symfs_filename[PATH_MAX];
 
 	if (!h->sum)
 		return 0;
 
+	snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
+		symbol_conf.symfs, filename);
+	if (access(symfs_filename, R_OK)) {
+		snprintf(symfs_filename, sizeof(symfs_filename), "%s",
+			 filename);
+	}
+
 	src_line = notes->src->lines = calloc(len, sizeof(struct source_line));
 	if (!notes->src->lines)
 		return -1;
@@ -915,7 +924,9 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 			continue;
 
 		offset = start + i;
-		sprintf(cmd, "addr2line -e %s %016" PRIx64, filename, offset);
+		sprintf(cmd, "%s -e %s %016" PRIx64,
+			addr2line_path ? addr2line_path : "addr2line",
+			symfs_filename, offset);
 		fp = popen(cmd, "r");
 		if (!fp)
 			continue;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b5b1b92..d45e406 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -256,12 +256,20 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	FILE *fp;
 	char cmd[PATH_MAX + 2], *path = self->srcline, *nl;
 	size_t line_len;
+	char symfs_dso_name[PATH_MAX];
 
-	if (path != NULL)
+	if (path != NULL || !self->ms.map)
 		goto out_path;
 
-	snprintf(cmd, sizeof(cmd), "addr2line -e %s %016" PRIx64,
-		 self->ms.map->dso->long_name, self->ip);
+	snprintf(symfs_dso_name, sizeof(symfs_dso_name), "%s%s",
+		 symbol_conf.symfs, self->ms.map->dso->long_name);
+	if (access(symfs_dso_name, R_OK)) {
+		snprintf(symfs_dso_name, sizeof(symfs_dso_name), "%s",
+			 self->ms.map->dso->long_name);
+	}
+	snprintf(cmd, sizeof(cmd), "%s -e %s %016" PRIx64,
+		 addr2line_path ? addr2line_path : "addr2line",
+		 symfs_dso_name, self->ip);
 	fp = popen(cmd, "r");
 	if (!fp)
 		goto out_ip;
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

