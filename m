Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab0FGMom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:44:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46865 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab0FGMol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:44:41 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] perf probe: add kernel source path option
Date: Mon,  7 Jun 2010 08:44:24 -0400
Message-Id: <1275914664-31552-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe plugin requires access to the source code for some operations.
The source code must be in the exact same location as specified by the
DWARF tags, but sometimes the location is an absolute path that cannot
be replicated by a normal user. This change adds the -s|--source option
to allow the user to specify the root of the kernel source tree.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 tools/perf/Documentation/perf-probe.txt |    4 ++
 tools/perf/builtin-probe.c              |    2 +
 tools/perf/util/probe-finder.c          |   58 +++++++++++++++++++++++++++++--
 tools/perf/util/symbol.h                |    1 +
 4 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 94a258c..ea531d9 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -31,6 +31,10 @@ OPTIONS
 --vmlinux=PATH::
 	Specify vmlinux path which has debuginfo (Dwarf binary).
 
+-s::
+--source=PATH::
+	Specify path to kernel source.
+
 -v::
 --verbose::
         Be more verbose (show parsed arguments, etc).
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index e4a4da3..5455186 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -182,6 +182,8 @@ static const struct option options[] = {
 		     "Show source code lines.", opt_show_lines),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
+	OPT_STRING('s', "source", &symbol_conf.source_prefix,
+		   "directory", "path to kernel source"),
 #endif
 	OPT__DRY_RUN(&probe_event_dry_run),
 	OPT_INTEGER('\0', "max-probes", &params.max_probe_points,
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index d964cb1..8c33aa1 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -37,6 +37,7 @@
 #include "event.h"
 #include "debug.h"
 #include "util.h"
+#include "symbol.h"
 #include "probe-finder.h"
 
 /* Kprobe tracer basic type is up to u64 */
@@ -57,6 +58,55 @@ static int strtailcmp(const char *s1, const char *s2)
 	return 0;
 }
 
+/*
+ * Find a src file from a DWARF tag path. Prepend optional source path prefix
+ * and chop off leading directories that do not exist. Result is passed back as
+ * a newly allocated path on success.
+ * Return 0 if file was found and readable, -errno otherwise.
+ */
+static int get_real_path(const char *raw_path, char **new_path)
+{
+	if (!symbol_conf.source_prefix) {
+		if (access(raw_path, R_OK) == 0) {
+			*new_path = strdup(raw_path);
+			return 0;
+		} else
+			return -errno;
+	}
+
+	*new_path = malloc(strlen(symbol_conf.source_prefix)
+			   + strlen(raw_path) + 2);
+	if (!*new_path)
+		return -ENOMEM;
+
+	for (;;) {
+		sprintf(*new_path, "%s/%s", symbol_conf.source_prefix,
+			raw_path);
+
+		if (access(*new_path, R_OK) == 0)
+			return 0;
+
+		switch (errno) {
+		case ENAMETOOLONG:
+		case ENOENT:
+		case EROFS:
+		case EFAULT:
+			raw_path = strchr(++raw_path, '/');
+			if (!raw_path) {
+				free(*new_path);
+				*new_path = NULL;
+				return -ENOENT;
+			}
+			continue;
+
+		default:
+			free(*new_path);
+			*new_path = NULL;
+			return -errno;
+		}
+	}
+}
+
 /* Line number list operations */
 
 /* Add a line to line number list */
@@ -1096,11 +1146,13 @@ end:
 static int line_range_add_line(const char *src, unsigned int lineno,
 			       struct line_range *lr)
 {
+	int ret;
+
 	/* Copy real path */
 	if (!lr->path) {
-		lr->path = strdup(src);
-		if (lr->path == NULL)
-			return -ENOMEM;
+		ret = get_real_path(src, &lr->path);
+		if (ret != 0)
+			return ret;
 	}
 	return line_list__add_line(&lr->line_list, lineno);
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 10b7ff8..80e569b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -71,6 +71,7 @@ struct symbol_conf {
 			full_paths,
 			show_cpu_utilization;
 	const char	*vmlinux_name,
+			*source_prefix,
 			*field_sep;
 	const char	*default_guest_vmlinux_name,
 			*default_guest_kallsyms,
-- 
1.7.0.4

