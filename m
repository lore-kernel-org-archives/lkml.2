Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0FGAWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 20:22:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49459 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab0FGAWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 20:22:20 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf probe: add kernel source path option
Date: Sun,  6 Jun 2010 20:22:05 -0400
Message-Id: <1275870125-25666-1-git-send-email-chase.douglas@canonical.com>
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
 tools/perf/util/probe-finder.c          |   56 +++++++++++++++++++++++++++++-
 tools/perf/util/symbol.h                |    1 +
 4 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 34202b1..d387d8b 100644
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
index 152d6c9..ae7ba65 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -167,6 +167,8 @@ static const struct option options[] = {
 #ifndef NO_DWARF_SUPPORT
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
+	OPT_STRING('s', "source", &symbol_conf.source_prefix,
+		   "directory", "path to kernel source"),
 #endif
 	OPT_BOOLEAN('l', "list", &session.list_events,
 		    "list up current probe events"),
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c171a24..e1a88f1 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -36,6 +36,7 @@
 #include "event.h"
 #include "debug.h"
 #include "util.h"
+#include "symbol.h"
 #include "probe-finder.h"
 
 
@@ -105,6 +106,55 @@ static int strtailcmp(const char *s1, const char *s2)
 	return 0;
 }
 
+/*
+ * Find a src file from a DWARF tag path. Prepend optional source path prefix
+ * and chop off leading directories that do not exist. Result is passed back as
+ * a newly allocated path on success.
+ * Return 0 if file was found and readable, -1 otherwise.
+ */
+static int get_real_src(const char *raw_path, char **new_path)
+{
+	if (!symbol_conf.source_prefix) {
+		if (access(raw_path, R_OK) == 0) {
+			*new_path = strdup(raw_path);
+			return 0;
+		} else
+			return -1;
+	}
+
+	*new_path = malloc(strlen(symbol_conf.source_prefix)
+			   + strlen(raw_path) + 2);
+	if (!*new_path)
+		return -1;
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
+				return -1;
+			}
+			continue;
+
+		default:
+			free(*new_path);
+			*new_path = NULL;
+			return -1;
+		}
+	}
+}
+
 /* Line number list operations */
 
 /* Add a line to line number list */
@@ -726,8 +776,10 @@ static void find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 			continue;
 
 		/* Copy real path */
-		if (!lf->lr->path)
-			lf->lr->path = strdup(src);
+		if (!lf->lr->path && get_real_src(src, &lf->lr->path) != 0) {
+			perror("Could not find path to source");
+			break;
+		}
 		line_list__add_line(&lf->lr->line_list, (unsigned int)lineno);
 	}
 	/* Update status */
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index f30a374..fdec2eb 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -65,6 +65,7 @@ struct symbol_conf {
 			exclude_other,
 			full_paths;
 	const char	*vmlinux_name,
+			*source_prefix,
 			*field_sep;
 	char            *dso_list_str,
 			*comm_list_str,
-- 
1.7.0.4

