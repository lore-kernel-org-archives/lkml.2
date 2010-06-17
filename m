Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437Ab0FQUlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:41:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:49940 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab0FQUkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:40:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Chase Douglas <chase.douglas@canonical.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/7] perf probe: Add kernel source path option
Date: Thu, 17 Jun 2010 17:40:02 -0300
Message-Id: <1276807204-22512-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276807204-22512-1-git-send-email-acme@infradead.org>
References: <1276807204-22512-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chase Douglas <chase.douglas@canonical.com>

The probe plugin requires access to the source code for some operations.  The
source code must be in the exact same location as specified by the DWARF tags,
but sometimes the location is an absolute path that cannot be replicated by a
normal user. This change adds the -s|--source option to allow the user to
specify the root of the kernel source tree.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <1276543590-10486-1-git-send-email-chase.douglas@canonical.com>
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index d964cb1..baf6653 100644
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
+	*new_path = malloc((strlen(symbol_conf.source_prefix) +
+			    strlen(raw_path) + 2));
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
1.6.2.5

