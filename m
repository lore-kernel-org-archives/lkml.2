Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab2JHGpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:45:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40084 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab2JHGpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:45:32 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v3 7/8] perf tools: configure addr2line for cross-compiling
Date: Mon,  8 Oct 2012 09:43:32 +0300
Message-Id: <1349678613-7045-8-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
References: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

When analyzing data recorded on a target with a different architecture than
the host, we must use addr2line from the toolchain for that architecture.
Add a command line option to set addr2line at runtime.

As we have architecture information of saved perf.data file, we can
also try to find cross-built addr2line path. The predefined triplets include
support for Android (arm, x86 and mips architectures).

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/Documentation/android.txt       |   18 ++++++++++++++++++
 tools/perf/Documentation/perf-annotate.txt |    2 ++
 tools/perf/Documentation/perf-report.txt   |    2 ++
 tools/perf/arch/common.c                   |    5 +++++
 tools/perf/arch/common.h                   |    2 ++
 tools/perf/builtin-annotate.c              |    5 +++++
 tools/perf/builtin-report.c                |    6 ++++++
 tools/perf/util/annotate.c                 |   13 ++++++++++++-
 tools/perf/util/sort.c                     |   16 +++++++++++++---
 9 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/android.txt b/tools/perf/Documentation/android.txt
index 24fd01c..c2a8017 100644
--- a/tools/perf/Documentation/android.txt
+++ b/tools/perf/Documentation/android.txt
@@ -74,3 +74,21 @@ IV. Run perf
 ------------------------------------------------
 Run perf on your device/emulator to which you previously connected using adb:
   # ./data/perf
+
+V. Analyze data recorded in Android on the host
+------------------------------------------------
+perf report and perf annotate use objdump and addr2line tools from Linux.
+For analyzing data recorded for a different architecture you need to use the
+versions provided in the toolchain for that architecture. The detection of the
+proper toolchain is done at runtime; all you need to do is set some environment
+variables before running perf annotate/report:
+1. set CROSS_COMPILE
+  export CROSS_COMPILE=${NDK_TOOLCHAIN}
+or
+2. add the path to the toolchain to PATH
+  export PATH=$PATH:${ANDROID_TOOLCHAIN}
+or
+3. set the Android environment if you have the source tree
+(this will set $PATH for you as mentioned above)
+  source build/envsetup.sh
+  lunch
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
diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 1db891f..e84b139 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -157,3 +157,8 @@ void try_objdump_path(struct perf_session *session)
 {
 	objdump_path = try_binutils_path(session, "objdump");
 }
+
+void try_addr2line_path(struct perf_session *session)
+{
+	addr2line_path = try_binutils_path(session, "addr2line");
+}
diff --git a/tools/perf/arch/common.h b/tools/perf/arch/common.h
index d88ecc3..ca95f0a 100644
--- a/tools/perf/arch/common.h
+++ b/tools/perf/arch/common.h
@@ -4,7 +4,9 @@
 #include "session.h"
 
 extern const char *objdump_path;
+extern const char *addr2line_path;
 
 void try_objdump_path(struct perf_session *session);
+void try_addr2line_path(struct perf_session *session);
 
 #endif /* ARCH_PERF_COMMON_H */
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 8d90ab5..6f3b21a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -189,6 +189,8 @@ static int __cmd_annotate(struct perf_annotate *ann)
 
 	if (!objdump_path)
 		try_objdump_path(session);
+	if (!addr2line_path)
+		try_addr2line_path(session);
 
 	ret = perf_session__process_events(session, &ann->tool);
 	if (ret)
@@ -288,6 +290,9 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_STRING(0, "addr2line", &addr2line_path, "path",
+		   "addr2line binary to use for obtaining "
+		   "file names and line numbers"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e1549bc..b1a1949 100644
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
 
@@ -673,6 +676,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
+	if (!addr2line_path)
+		try_addr2line_path(session);
+
 	if (sort__branch_mode == -1 && has_br_stack)
 		sort__branch_mode = 1;
 
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
index b5b1b92..037ab89 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,5 +1,6 @@
 #include "sort.h"
 #include "hist.h"
+#include "../arch/common.h"
 
 regex_t		parent_regex;
 const char	default_parent_pattern[] = "^sys_|^do_page_fault";
@@ -256,12 +257,21 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
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
+
+	snprintf(cmd, sizeof(cmd), "%s -e %s %016" PRIx64,
+		 addr2line_path ? addr2line_path : "addr2line",
+		 symfs_dso_name, self->ip);
 	fp = popen(cmd, "r");
 	if (!fp)
 		goto out_ip;
-- 
1.7.9.5

