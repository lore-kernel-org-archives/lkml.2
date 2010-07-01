Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0GAP4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:56:09 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47067 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086Ab0GAPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:08 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/21] perf: Add a common misc.c compilation unit
Date: Thu,  1 Jul 2010 17:55:58 +0200
Message-Id: <1277999763-20357-17-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is a temporary unit for sharing code between perf and the library.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/Makefile            |    2 +
 tools/lib/lk/color.c          |   16 ------------
 tools/lib/lk/color.h          |    5 +---
 tools/lib/lk/debug.c          |    6 +----
 tools/lib/lk/debug.h          |    2 -
 tools/lib/perf/misc.c         |   54 +++++++++++++++++++++++++++++++++++++++++
 tools/lib/perf/misc.h         |   11 ++++++++
 tools/perf/builtin-annotate.c |    4 +++
 tools/perf/builtin-kvm.c      |    4 +--
 tools/perf/builtin-record.c   |   11 ++++----
 tools/perf/builtin-report.c   |    1 +
 tools/perf/perf.c             |    1 +
 tools/perf/perf.h             |    3 --
 tools/perf/util/newt.c        |    1 +
 14 files changed, 83 insertions(+), 38 deletions(-)
 create mode 100644 tools/lib/perf/misc.c
 create mode 100644 tools/lib/perf/misc.h

diff --git a/tools/lib/Makefile b/tools/lib/Makefile
index 795fa3a..780c4fc 100644
--- a/tools/lib/Makefile
+++ b/tools/lib/Makefile
@@ -23,6 +23,7 @@ LIB_H += perf/hist.h
 LIB_H += perf/thread.h
 LIB_H += perf/sort.h
 LIB_H += perf/event.h
+LIB_H += perf/misc.h
 
 LIB_OBJS += $(OUTPUT)lk/bitmap.o
 LIB_OBJS += $(OUTPUT)lk/cpumap.o
@@ -49,6 +50,7 @@ LIB_OBJS += $(OUTPUT)perf/hist.o
 LIB_OBJS += $(OUTPUT)perf/thread.o
 LIB_OBJS += $(OUTPUT)perf/sort.o
 LIB_OBJS += $(OUTPUT)perf/event.o
+LIB_OBJS += $(OUTPUT)perf/misc.o
 LIB_OBJS += $(OUTPUT)trace/trace-event-read.o
 LIB_OBJS += $(OUTPUT)trace/trace-event-info.o
 LIB_OBJS += $(OUTPUT)trace/trace-event-parse.o
diff --git a/tools/lib/lk/color.c b/tools/lib/lk/color.c
index 93d6381..b3d067b 100644
--- a/tools/lib/lk/color.c
+++ b/tools/lib/lk/color.c
@@ -6,22 +6,6 @@
  */
 static int use_color_default = -1;
 
-/*
- * This is going into tools/perf/perf.c next
- */
-int spawned_pager, pager_use_color = 1;
-
-int pager_in_use(void)
-{
-	const char *env;
-
-	if (spawned_pager)
-		return 1;
-
-	env = getenv("PERF_PAGER_IN_USE");
-	return env ? lk_config_bool("PERF_PAGER_IN_USE", env) : 0;
-}
-
 static int parse_color(const char *name, int len)
 {
 	static const char * const color_names[] = {
diff --git a/tools/lib/lk/color.h b/tools/lib/lk/color.h
index c962e1d..03927fc 100644
--- a/tools/lib/lk/color.h
+++ b/tools/lib/lk/color.h
@@ -8,6 +8,7 @@
 #include <stdarg.h>
 
 #include "util.h"
+#include <perf/misc.h>
 
 /* "\033[1;38;5;2xx;48;5;2xxm\0" is 23 bytes */
 #define COLOR_MAXLEN 24
@@ -26,10 +27,6 @@
 #define MIN_GREEN	0.5
 #define MIN_RED		5.0
 
-extern int spawned_pager, pager_use_color;
-
-extern int pager_in_use(void);
-
 void color_parse(const char *value, const char *var, char *dst);
 void color_parse_mem(const char *value, int len, const char *var, char *dst);
 int color_vsnprintf(char *bf, size_t size, const char *color,
diff --git a/tools/lib/lk/debug.c b/tools/lib/lk/debug.c
index 73edbb8..b183c4d 100644
--- a/tools/lib/lk/debug.c
+++ b/tools/lib/lk/debug.c
@@ -8,11 +8,7 @@
 #include "debug.h"
 #include <lk/util.h>
 #include <lk/color.h>
-
-/*
- * will move to tools/perf/perf.c
- */
-int use_browser = -1;
+#include <perf/misc.h>
 
 int verbose = 0;
 bool dump_trace = false;
diff --git a/tools/lib/lk/debug.h b/tools/lib/lk/debug.h
index 44fdfab..6badf99 100644
--- a/tools/lib/lk/debug.h
+++ b/tools/lib/lk/debug.h
@@ -8,8 +8,6 @@
 extern int verbose;
 extern bool dump_trace;
 
-extern int use_browser;
-
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(event_t *event);
 
diff --git a/tools/lib/perf/misc.c b/tools/lib/perf/misc.c
new file mode 100644
index 0000000..66506cf
--- /dev/null
+++ b/tools/lib/perf/misc.c
@@ -0,0 +1,54 @@
+/*
+ * This contains miscellaneous bits and pieces which are shared by the
+ * lk library and the rest of the tools. XXX: the aim should be to
+ * remove this unit later making the library independent and the tools
+ * call well-defined interfaces only.
+ */
+
+#include <stdlib.h>
+#include <inttypes.h>
+#include <lk/util.h>
+#include <lk/config.h>
+#include <linux/compiler.h>
+#include <util/parse-options.h>
+
+#include "misc.h"
+
+int spawned_pager, pager_use_color = 1;
+int use_browser = -1;
+
+bool perf_host = 1;
+bool perf_guest;
+
+int pager_in_use(void)
+{
+	const char *env;
+
+	if (spawned_pager)
+		return 1;
+
+	env = getenv("PERF_PAGER_IN_USE");
+	return env ? lk_config_bool("PERF_PAGER_IN_USE", env) : 0;
+}
+
+/*
+ * overridden by tools/perf/util/parse-options.c:usage_with_options()
+ */
+void __weak NORETURN usage_with_options(const char * const *usagestr,
+			       const struct option *opts __used)
+{
+	fprintf(stderr, "\n usage: %s\n", *usagestr++);
+	while (*usagestr && **usagestr)
+		fprintf(stderr, "    or: %s\n", *usagestr++);
+	while (*usagestr) {
+		fprintf(stderr, "%s%s\n",
+				**usagestr ? "    " : "",
+				*usagestr);
+		usagestr++;
+	}
+
+	if (opts->type != OPTION_GROUP)
+		fputc('\n', stderr);
+
+	exit(129);
+}
diff --git a/tools/lib/perf/misc.h b/tools/lib/perf/misc.h
new file mode 100644
index 0000000..2073b8c
--- /dev/null
+++ b/tools/lib/perf/misc.h
@@ -0,0 +1,11 @@
+#ifndef __PERF_MISC_H
+#define __PERF_MISC_H
+
+#include <stdbool.h>
+
+extern int spawned_pager, pager_use_color;
+extern int use_browser;
+extern int pager_in_use(void);
+extern bool perf_host, perf_guest;
+
+#endif /* __PERF_MISC_H */
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 29753d1..87e78ae 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -24,6 +24,10 @@
 #include <perf/thread.h>
 #include <perf/sort.h>
 #include <perf/hist.h>
+#include <perf/misc.h>
+#include <perf/thread.h>
+#include <perf/sort.h>
+#include <perf/hist.h>
 #include <perf/session.h>
 
 static char		const *input_name = "perf.data";
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 10a8c4d..8e92448 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -3,6 +3,7 @@
 
 #include <lk/util.h>
 #include "util/cache.h"
+#include <perf/misc.h>
 #include <perf/symbol.h>
 #include <perf/thread.h>
 #include <perf/header.h>
@@ -22,9 +23,6 @@
 static const char		*file_name;
 static char			name_buffer[256];
 
-bool				perf_host = 1;
-bool				perf_guest;
-
 static const char * const kvm_usage[] = {
 	"perf kvm [<options>] {top|record|report|diff|buildid-list}",
 	NULL
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6072b83..241c334 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -11,17 +11,18 @@
 
 #include "perf.h"
 
-#include <perf/build-id.h>
 #include <lk/util.h>
-#include "util/parse-options.h"
+#include <lk/cpumap.h>
+#include <lk/debug.h>
+#include <perf/misc.h>
 #include <perf/parse-events.h>
-
+#include <perf/build-id.h>
 #include <perf/header.h>
 #include <perf/event.h>
-#include <lk/debug.h>
 #include <perf/session.h>
 #include <perf/symbol.h>
-#include <lk/cpumap.h>
+
+#include "util/parse-options.h"
 
 #include <unistd.h>
 #include <sched.h>
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0803898..9eccc66 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -25,6 +25,7 @@
 
 #include "util/parse-options.h"
 #include <perf/parse-events.h>
+#include <perf/misc.h>
 
 #include <perf/thread.h>
 #include <perf/sort.h>
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 4268ed4..9a1b725 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -15,6 +15,7 @@
 #include <perf/build-id.h>
 #include "util/run-command.h"
 #include <perf/parse-events.h>
+#include <perf/misc.h>
 #include <lk/debugfs.h>
 #include <lk/config.h>
 #include <lk/debug.h>
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2344078..86b7ea1 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -131,7 +131,4 @@ struct ip_callchain {
 	u64 nr;
 	u64 ips[0];
 };
-
-extern bool perf_host, perf_guest;
-
 #endif
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index dffe075..3a8c453 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -21,6 +21,7 @@
 #include <perf/session.h>
 #include <perf/sort.h>
 #include <perf/symbol.h>
+#include <perf/misc.h>
 
 #if SLANG_VERSION < 20104
 #define slsmg_printf(msg, args...) SLsmg_printf((char *)msg, ##args)
-- 
1.7.1

