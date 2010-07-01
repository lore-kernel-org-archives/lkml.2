Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0GAP4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:56:25 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47061 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026Ab0GAPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:07 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/21] perf: rewire generic library stuff, p5
Date: Thu,  1 Jul 2010 17:55:51 +0200
Message-Id: <1277999763-20357-10-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Carve out debug.[ch] and string.c and make them generic.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/Makefile                       |    3 +
 tools/lib/lk/debug.c                     |  108 +++++++++++
 tools/lib/lk/debug.h                     |   50 +++++
 tools/lib/lk/pstack.c                    |    2 +-
 tools/lib/lk/string.c                    |  296 ++++++++++++++++++++++++++++++
 tools/lib/lk/util.h                      |    2 +-
 tools/perf/Makefile                      |    3 -
 tools/perf/bench/mem-memcpy.c            |    2 +-
 tools/perf/builtin-annotate.c            |    2 +-
 tools/perf/builtin-buildid-cache.c       |    2 +-
 tools/perf/builtin-buildid-list.c        |    2 +-
 tools/perf/builtin-diff.c                |    2 +-
 tools/perf/builtin-inject.c              |    2 +-
 tools/perf/builtin-kmem.c                |    2 +-
 tools/perf/builtin-kvm.c                 |    2 +-
 tools/perf/builtin-lock.c                |    2 +-
 tools/perf/builtin-probe.c               |    2 +-
 tools/perf/builtin-record.c              |    2 +-
 tools/perf/builtin-report.c              |    2 +-
 tools/perf/builtin-sched.c               |    2 +-
 tools/perf/builtin-stat.c                |    2 +-
 tools/perf/builtin-test.c                |    2 +-
 tools/perf/builtin-timechart.c           |    2 +-
 tools/perf/builtin-top.c                 |    2 +-
 tools/perf/builtin-trace.c               |    3 +-
 tools/perf/perf.c                        |    2 +-
 tools/perf/util/build-id.c               |    1 +
 tools/perf/util/cache.h                  |    2 -
 tools/perf/util/callchain.c              |    1 +
 tools/perf/util/debug.c                  |   98 ----------
 tools/perf/util/debug.h                  |   39 ----
 tools/perf/util/event.c                  |    2 +-
 tools/perf/util/header.c                 |    2 +-
 tools/perf/util/include/linux/compiler.h |    1 +
 tools/perf/util/include/linux/kernel.h   |    3 -
 tools/perf/util/map.c                    |   32 ++--
 tools/perf/util/newt.c                   |    2 +-
 tools/perf/util/parse-events.c           |    1 +
 tools/perf/util/probe-event.c            |    2 +-
 tools/perf/util/probe-finder.c           |    2 +-
 tools/perf/util/sort.h                   |    2 +-
 tools/perf/util/string.c                 |  296 ------------------------------
 tools/perf/util/symbol.c                 |    2 +
 tools/perf/util/thread.c                 |    2 +-
 44 files changed, 509 insertions(+), 484 deletions(-)
 create mode 100644 tools/lib/lk/debug.c
 create mode 100644 tools/lib/lk/debug.h
 create mode 100644 tools/lib/lk/string.c
 delete mode 100644 tools/perf/util/debug.c
 delete mode 100644 tools/perf/util/debug.h
 delete mode 100644 tools/perf/util/string.c

diff --git a/tools/lib/Makefile b/tools/lib/Makefile
index 7acb91d..df60156 100644
--- a/tools/lib/Makefile
+++ b/tools/lib/Makefile
@@ -11,6 +11,7 @@ LIB_H += lk/types.h
 LIB_H += lk/pstack.h
 LIB_H += lk/strbuf.h
 LIB_H += lk/color.h
+LIB_H += lk/debug.h
 
 LIB_OBJS += $(OUTPUT)lk/bitmap.o
 LIB_OBJS += $(OUTPUT)lk/cpumap.o
@@ -23,6 +24,8 @@ LIB_OBJS += $(OUTPUT)lk/strbuf.o
 LIB_OBJS += $(OUTPUT)lk/usage.o
 LIB_OBJS += $(OUTPUT)lk/color.o
 LIB_OBJS += $(OUTPUT)lk/config.o
+LIB_OBJS += $(OUTPUT)lk/debug.o
+LIB_OBJS += $(OUTPUT)lk/string.o
 
 LIBFILE = lklib.a
 
diff --git a/tools/lib/lk/debug.c b/tools/lib/lk/debug.c
new file mode 100644
index 0000000..73edbb8
--- /dev/null
+++ b/tools/lib/lk/debug.c
@@ -0,0 +1,108 @@
+/* For general debugging purposes */
+
+#include <perf.h>
+#include <string.h>
+#include <stdarg.h>
+#include <stdio.h>
+#include "event.h"
+#include "debug.h"
+#include <lk/util.h>
+#include <lk/color.h>
+
+/*
+ * will move to tools/perf/perf.c
+ */
+int use_browser = -1;
+
+int verbose = 0;
+bool dump_trace = false;
+
+/*
+ * overridden by perf/util/newt.c:_browser__show_help()
+ */
+int __weak _browser__show_help(const char *format __used, va_list ap __used)
+{
+	return 0;
+}
+
+int eprintf(int level, const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (verbose >= level) {
+		va_start(args, fmt);
+		if (use_browser > 0)
+			ret = browser__show_help(fmt, args);
+		else
+			ret = vfprintf(stderr, fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
+
+int dump_printf(const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (dump_trace) {
+		va_start(args, fmt);
+		ret = vprintf(fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
+
+static int dump_printf_color(const char *fmt, const char *color, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (dump_trace) {
+		va_start(args, color);
+		ret = color_vfprintf(stdout, color, fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
+
+
+void trace_event(event_t *event)
+{
+	unsigned char *raw_event = (void *)event;
+	const char *color = LK_COLOR_BLUE;
+	int i, j;
+
+	if (!dump_trace)
+		return;
+
+	dump_printf(".");
+	dump_printf_color("\n. ... raw event: size %d bytes\n", color,
+			  event->header.size);
+
+	for (i = 0; i < event->header.size; i++) {
+		if ((i & 15) == 0) {
+			dump_printf(".");
+			dump_printf_color("  %04x: ", color, i);
+		}
+
+		dump_printf_color(" %02x", color, raw_event[i]);
+
+		if (((i & 15) == 15) || i == event->header.size-1) {
+			dump_printf_color("  ", color);
+			for (j = 0; j < 15-(i & 15); j++)
+				dump_printf_color("   ", color);
+			for (j = i & ~15; j <= i; j++) {
+				dump_printf_color("%c", color,
+						isprint(raw_event[j]) ?
+						raw_event[j] : '.');
+			}
+			dump_printf_color("\n", color);
+		}
+	}
+	dump_printf(".\n");
+}
diff --git a/tools/lib/lk/debug.h b/tools/lib/lk/debug.h
new file mode 100644
index 0000000..6df0457
--- /dev/null
+++ b/tools/lib/lk/debug.h
@@ -0,0 +1,50 @@
+/* For debugging general purposes */
+#ifndef __LK_DEBUG_H
+#define __LK_DEBUG_H
+
+#include <stdbool.h>
+#include <util/event.h>
+
+extern int verbose;
+extern bool dump_trace;
+
+extern int use_browser;
+
+int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
+void trace_event(event_t *event);
+
+struct ui_progress;
+
+extern int eprintf(int level,
+		   const char *fmt, ...) __attribute__((format(printf, 2, 3)));
+
+extern int __weak _browser__show_help(const char *format, va_list ap);
+
+#ifdef NO_NEWT_SUPPORT
+static inline int browser__show_help(const char *format __used, va_list ap __used)
+{
+	return 0;
+}
+
+static inline struct ui_progress *ui_progress__new(const char *title __used,
+						   u64 total __used)
+{
+	return (struct ui_progress *)1;
+}
+
+static inline void ui_progress__update(struct ui_progress *self __used,
+				       u64 curr __used) {}
+
+static inline void ui_progress__delete(struct ui_progress *self __used) {}
+#else
+static inline int browser__show_help(const char *format, va_list ap)
+{
+	return _browser__show_help(format, ap);
+}
+
+struct ui_progress *ui_progress__new(const char *title, u64 total);
+void ui_progress__update(struct ui_progress *self, u64 curr);
+void ui_progress__delete(struct ui_progress *self);
+#endif
+
+#endif	/* __LK_DEBUG_H */
diff --git a/tools/lib/lk/pstack.c b/tools/lib/lk/pstack.c
index 13d36fa..acb758b 100644
--- a/tools/lib/lk/pstack.c
+++ b/tools/lib/lk/pstack.c
@@ -5,8 +5,8 @@
  */
 
 #include "util.h"
+#include "debug.h"
 #include "pstack.h"
-#include <linux/kernel.h>
 #include <stdlib.h>
 
 struct pstack {
diff --git a/tools/lib/lk/string.c b/tools/lib/lk/string.c
new file mode 100644
index 0000000..0b02099
--- /dev/null
+++ b/tools/lib/lk/string.c
@@ -0,0 +1,296 @@
+#include <lk/util.h>
+#include "string.h"
+
+#define K 1024LL
+/*
+ * lk_atoll()
+ * Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB|tb|TB) (e.g. "256MB")
+ * and return its numeric value
+ */
+s64 lk_atoll(const char *str)
+{
+	unsigned int i;
+	s64 length = -1, unit = 1;
+
+	if (!isdigit(str[0]))
+		goto out_err;
+
+	for (i = 1; i < strlen(str); i++) {
+		switch (str[i]) {
+		case 'B':
+		case 'b':
+			break;
+		case 'K':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto kilo;
+		case 'k':
+			if (str[i + 1] != 'b')
+				goto out_err;
+kilo:
+			unit = K;
+			break;
+		case 'M':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto mega;
+		case 'm':
+			if (str[i + 1] != 'b')
+				goto out_err;
+mega:
+			unit = K * K;
+			break;
+		case 'G':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto giga;
+		case 'g':
+			if (str[i + 1] != 'b')
+				goto out_err;
+giga:
+			unit = K * K * K;
+			break;
+		case 'T':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto tera;
+		case 't':
+			if (str[i + 1] != 'b')
+				goto out_err;
+tera:
+			unit = K * K * K * K;
+			break;
+		case '\0':	/* only specified figures */
+			unit = 1;
+			break;
+		default:
+			if (!isdigit(str[i]))
+				goto out_err;
+			break;
+		}
+	}
+
+	length = atoll(str) * unit;
+	goto out;
+
+out_err:
+	length = -1;
+out:
+	return length;
+}
+
+/*
+ * Helper function for splitting a string into an argv-like array.
+ * originaly copied from lib/argv_split.c
+ */
+static const char *skip_sep(const char *cp)
+{
+	while (*cp && isspace(*cp))
+		cp++;
+
+	return cp;
+}
+
+static const char *skip_arg(const char *cp)
+{
+	while (*cp && !isspace(*cp))
+		cp++;
+
+	return cp;
+}
+
+static int count_argc(const char *str)
+{
+	int count = 0;
+
+	while (*str) {
+		str = skip_sep(str);
+		if (*str) {
+			count++;
+			str = skip_arg(str);
+		}
+	}
+
+	return count;
+}
+
+/**
+ * argv_free - free an argv
+ * @argv - the argument vector to be freed
+ *
+ * Frees an argv and the strings it points to.
+ */
+void argv_free(char **argv)
+{
+	char **p;
+	for (p = argv; *p; p++)
+		free(*p);
+
+	free(argv);
+}
+
+/**
+ * argv_split - split a string at whitespace, returning an argv
+ * @str: the string to be split
+ * @argcp: returned argument count
+ *
+ * Returns an array of pointers to strings which are split out from
+ * @str.  This is performed by strictly splitting on white-space; no
+ * quote processing is performed.  Multiple whitespace characters are
+ * considered to be a single argument separator.  The returned array
+ * is always NULL-terminated.  Returns NULL on memory allocation
+ * failure.
+ */
+char **argv_split(const char *str, int *argcp)
+{
+	int argc = count_argc(str);
+	char **argv = zalloc(sizeof(*argv) * (argc+1));
+	char **argvp;
+
+	if (argv == NULL)
+		goto out;
+
+	if (argcp)
+		*argcp = argc;
+
+	argvp = argv;
+
+	while (*str) {
+		str = skip_sep(str);
+
+		if (*str) {
+			const char *p = str;
+			char *t;
+
+			str = skip_arg(str);
+
+			t = strndup(p, str-p);
+			if (t == NULL)
+				goto fail;
+			*argvp++ = t;
+		}
+	}
+	*argvp = NULL;
+
+out:
+	return argv;
+
+fail:
+	argv_free(argv);
+	return NULL;
+}
+
+/* Character class matching */
+static bool __match_charclass(const char *pat, char c, const char **npat)
+{
+	bool complement = false, ret = true;
+
+	if (*pat == '!') {
+		complement = true;
+		pat++;
+	}
+	if (*pat++ == c)	/* First character is special */
+		goto end;
+
+	while (*pat && *pat != ']') {	/* Matching */
+		if (*pat == '-' && *(pat + 1) != ']') {	/* Range */
+			if (*(pat - 1) <= c && c <= *(pat + 1))
+				goto end;
+			if (*(pat - 1) > *(pat + 1))
+				goto error;
+			pat += 2;
+		} else if (*pat++ == c)
+			goto end;
+	}
+	if (!*pat)
+		goto error;
+	ret = false;
+
+end:
+	while (*pat && *pat != ']')	/* Searching closing */
+		pat++;
+	if (!*pat)
+		goto error;
+	*npat = pat + 1;
+	return complement ? !ret : ret;
+
+error:
+	return false;
+}
+
+/* Glob/lazy pattern matching */
+static bool __match_glob(const char *str, const char *pat, bool ignore_space)
+{
+	while (*str && *pat && *pat != '*') {
+		if (ignore_space) {
+			/* Ignore spaces for lazy matching */
+			if (isspace(*str)) {
+				str++;
+				continue;
+			}
+			if (isspace(*pat)) {
+				pat++;
+				continue;
+			}
+		}
+		if (*pat == '?') {	/* Matches any single character */
+			str++;
+			pat++;
+			continue;
+		} else if (*pat == '[')	/* Character classes/Ranges */
+			if (__match_charclass(pat + 1, *str, &pat)) {
+				str++;
+				continue;
+			} else
+				return false;
+		else if (*pat == '\\') /* Escaped char match as normal char */
+			pat++;
+		if (*str++ != *pat++)
+			return false;
+	}
+	/* Check wild card */
+	if (*pat == '*') {
+		while (*pat == '*')
+			pat++;
+		if (!*pat)	/* Tail wild card matches all */
+			return true;
+		while (*str)
+			if (strglobmatch(str++, pat))
+				return true;
+	}
+	return !*str && !*pat;
+}
+
+/**
+ * strglobmatch - glob expression pattern matching
+ * @str: the target string to match
+ * @pat: the pattern string to match
+ *
+ * This returns true if the @str matches @pat. @pat can includes wildcards
+ * ('*','?') and character classes ([CHARS], complementation and ranges are
+ * also supported). Also, this supports escape character ('\') to use special
+ * characters as normal character.
+ *
+ * Note: if @pat syntax is broken, this always returns false.
+ */
+bool strglobmatch(const char *str, const char *pat)
+{
+	return __match_glob(str, pat, false);
+}
+
+/**
+ * strlazymatch - matching pattern strings lazily with glob pattern
+ * @str: the target string to match
+ * @pat: the pattern string to match
+ *
+ * This is similar to strglobmatch, except this ignores spaces in
+ * the target string.
+ */
+bool strlazymatch(const char *str, const char *pat)
+{
+	return __match_glob(str, pat, true);
+}
diff --git a/tools/lib/lk/util.h b/tools/lib/lk/util.h
index 4db0f3f..ec87421 100644
--- a/tools/lib/lk/util.h
+++ b/tools/lib/lk/util.h
@@ -277,7 +277,7 @@ static inline int sane_case(int x, int high)
 int mkdir_p(char *path, mode_t mode);
 int copyfile(const char *from, const char *to);
 
-s64 perf_atoll(const char *str);
+s64 lk_atoll(const char *str);
 char **argv_split(const char *str, int *argcp);
 void argv_free(char **argv);
 bool strglobmatch(const char *str, const char *pat);
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 42a1756..8770ff4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -355,7 +355,6 @@ LIB_H += perf.h
 LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
-LIB_H += util/debug.h
 LIB_H += util/event.h
 LIB_H += util/exec_cmd.h
 LIB_H += util/levenshtein.h
@@ -394,7 +393,6 @@ LIB_OBJS += $(OUTPUT)util/path.o
 LIB_OBJS += $(OUTPUT)util/rbtree.o
 LIB_OBJS += $(OUTPUT)util/run-command.o
 LIB_OBJS += $(OUTPUT)util/quote.o
-LIB_OBJS += $(OUTPUT)util/string.o
 LIB_OBJS += $(OUTPUT)util/strlist.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
@@ -403,7 +401,6 @@ LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/header.o
 LIB_OBJS += $(OUTPUT)util/callchain.o
 LIB_OBJS += $(OUTPUT)util/values.o
-LIB_OBJS += $(OUTPUT)util/debug.o
 LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/thread.o
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 1b2f508..86db09e 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -105,7 +105,7 @@ int bench_mem_memcpy(int argc, const char **argv,
 
 	tv_diff.tv_sec = 0;
 	tv_diff.tv_usec = 0;
-	length = (size_t)perf_atoll((char *)length_str);
+	length = (size_t)lk_atoll((char *)length_str);
 
 	if ((s64)length <= 0) {
 		fprintf(stderr, "Invalid length:%s\n", length_str);
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 42caf9c..04afd8a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -16,7 +16,7 @@
 #include "util/symbol.h"
 
 #include "perf.h"
-#include "util/debug.h"
+#include <lk/debug.h>
 
 #include "util/event.h"
 #include "util/parse-options.h"
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 29ad20e..5621017 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -9,7 +9,7 @@
 #include "builtin.h"
 #include "perf.h"
 #include "util/cache.h"
-#include "util/debug.h"
+#include <lk/debug.h>
 #include "util/header.h"
 #include "util/parse-options.h"
 #include "util/strlist.h"
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 9989072..b767dde 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -10,7 +10,7 @@
 #include "perf.h"
 #include "util/build-id.h"
 #include "util/cache.h"
-#include "util/debug.h"
+#include <lk/debug.h>
 #include "util/parse-options.h"
 #include "util/session.h"
 #include "util/symbol.h"
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 2f5a711..b346e7f 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -6,7 +6,7 @@
  */
 #include "builtin.h"
 
-#include "util/debug.h"
+#include <lk/debug.h>
 #include "util/event.h"
 #include "util/hist.h"
 #include "util/session.h"
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 8e3e47b..c9127a9 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -9,7 +9,7 @@
 
 #include "perf.h"
 #include "util/session.h"
-#include "util/debug.h"
+#include <lk/debug.h>
 
 #include "util/parse-options.h"
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 68a6ec0..a31c848 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -11,7 +11,7 @@
 #include "util/parse-options.h"
 #include "util/trace-event.h"
 
-#include "util/debug.h"
+#include <lk/debug.h>
 
 #include <linux/rbtree.h>
 
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 3e5d0fc..173dd9f 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -11,7 +11,7 @@
 #include "util/parse-options.h"
 #include "util/trace-event.h"
 
-#include "util/debug.h"
+#include <lk/debug.h>
 
 #include <sys/prctl.h>
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index bafb8c5..80327f1 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -10,7 +10,7 @@
 #include "util/parse-options.h"
 #include "util/trace-event.h"
 
-#include "util/debug.h"
+#include <lk/debug.h>
 #include "util/session.h"
 
 #include <sys/types.h>
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index be24b54..8679663 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -37,7 +37,7 @@
 #include <lk/util.h>
 #include "util/strlist.h"
 #include "util/symbol.h"
-#include "util/debug.h"
+#include <lk/debug.h>
 #include <lk/debugfs.h>
 #include "util/parse-options.h"
 #include "util/probe-finder.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b92e009..1dee3a0 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -18,7 +18,7 @@
 
 #include "util/header.h"
 #include "util/event.h"
-#include "util/debug.h"
+#include <lk/debug.h>
 #include "util/session.h"
 #include "util/symbol.h"
 #include <lk/cpumap.h>
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9a618ac..e87180f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -19,7 +19,7 @@
 #include "util/values.h"
 
 #include "perf.h"
-#include "util/debug.h"
+#include <lk/debug.h>
 #include "util/header.h"
 #include "util/session.h"
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index c47cf08..6bbc31a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -11,7 +11,7 @@
 #include "util/parse-options.h"
 #include "util/trace-event.h"
 
-#include "util/debug.h"
+#include <lk/debug.h>
 
 #include <sys/prctl.h>
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1f60239..b4cc93e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -43,7 +43,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/event.h"
-#include "util/debug.h"
+#include <lk/debug.h>
 #include "util/header.h"
 #include <lk/cpumap.h>
 #include "util/thread.h"
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 035b9fa..1be7ad9 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -6,7 +6,7 @@
 #include "builtin.h"
 
 #include "util/cache.h"
-#include "util/debug.h"
+#include <lk/debug.h>
 #include "util/parse-options.h"
 #include "util/session.h"
 #include "util/symbol.h"
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 5440b11..c90a68f 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -15,7 +15,7 @@
 #include "builtin.h"
 
 #include <lk/util.h>
-
+#include <lk/debug.h>
 #include <lk/color.h>
 #include <linux/list.h>
 #include "util/cache.h"
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2b4dce1..e402ba4 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -30,7 +30,7 @@
 #include "util/parse-events.h"
 #include <lk/cpumap.h>
 
-#include "util/debug.h"
+#include <lk/debug.h>
 
 #include <assert.h>
 #include <fcntl.h>
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 3f9308a..be67b73 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1,6 +1,7 @@
 #include "builtin.h"
 
 #include <lk/util.h>
+#include <lk/debug.h>
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
@@ -61,7 +62,7 @@ static int cleanup_scripting(void)
 #include "util/parse-options.h"
 
 #include "perf.h"
-#include "util/debug.h"
+#include <lk/debug.h>
 
 #include "util/trace-event.h"
 #include "util/exec_cmd.h"
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 9600a2d..b92b3fd 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -17,6 +17,7 @@
 #include "util/parse-events.h"
 #include <lk/debugfs.h>
 #include <lk/config.h>
+#include <lk/debug.h>
 
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
@@ -24,7 +25,6 @@ const char perf_usage_string[] =
 const char perf_more_info_string[] =
 	"See 'perf help COMMAND' for more information on a specific command.";
 
-int use_browser = -1;
 static int use_pager = -1;
 
 struct pager_config {
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 44f2878..a338745 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2009, 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
  */
 #include <lk/util.h>
+#include <lk/debug.h>
 #include <lk/config.h>
 #include <lk/strbuf.h>
 #include <stdio.h>
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index b0902b8..4ae67b4 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -21,8 +21,6 @@
 extern void setup_pager(void);
 extern const char *pager_program;
 
-extern int use_browser;
-
 #ifdef NO_NEWT_SUPPORT
 static inline void setup_browser(void)
 {
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index a6c99a3..dcc0254 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -16,6 +16,7 @@
 #include <math.h>
 
 #include <lk/util.h>
+#include <lk/debug.h>
 #include "callchain.h"
 
 bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event)
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
deleted file mode 100644
index 56635de..0000000
--- a/tools/perf/util/debug.c
+++ /dev/null
@@ -1,98 +0,0 @@
-/* For general debugging purposes */
-
-#include "../perf.h"
-
-#include <string.h>
-#include <stdarg.h>
-#include <stdio.h>
-
-#include "cache.h"
-#include "event.h"
-#include "debug.h"
-#include <lk/util.h>
-#include <lk/color.h>
-
-int verbose = 0;
-bool dump_trace = false;
-
-int eprintf(int level, const char *fmt, ...)
-{
-	va_list args;
-	int ret = 0;
-
-	if (verbose >= level) {
-		va_start(args, fmt);
-		if (use_browser > 0)
-			ret = browser__show_help(fmt, args);
-		else
-			ret = vfprintf(stderr, fmt, args);
-		va_end(args);
-	}
-
-	return ret;
-}
-
-int dump_printf(const char *fmt, ...)
-{
-	va_list args;
-	int ret = 0;
-
-	if (dump_trace) {
-		va_start(args, fmt);
-		ret = vprintf(fmt, args);
-		va_end(args);
-	}
-
-	return ret;
-}
-
-static int dump_printf_color(const char *fmt, const char *color, ...)
-{
-	va_list args;
-	int ret = 0;
-
-	if (dump_trace) {
-		va_start(args, color);
-		ret = color_vfprintf(stdout, color, fmt, args);
-		va_end(args);
-	}
-
-	return ret;
-}
-
-
-void trace_event(event_t *event)
-{
-	unsigned char *raw_event = (void *)event;
-	const char *color = LK_COLOR_BLUE;
-	int i, j;
-
-	if (!dump_trace)
-		return;
-
-	dump_printf(".");
-	dump_printf_color("\n. ... raw event: size %d bytes\n", color,
-			  event->header.size);
-
-	for (i = 0; i < event->header.size; i++) {
-		if ((i & 15) == 0) {
-			dump_printf(".");
-			dump_printf_color("  %04x: ", color, i);
-		}
-
-		dump_printf_color(" %02x", color, raw_event[i]);
-
-		if (((i & 15) == 15) || i == event->header.size-1) {
-			dump_printf_color("  ", color);
-			for (j = 0; j < 15-(i & 15); j++)
-				dump_printf_color("   ", color);
-			for (j = i & ~15; j <= i; j++) {
-				dump_printf_color("%c", color,
-						isprint(raw_event[j]) ?
-						raw_event[j] : '.');
-			}
-			dump_printf_color("\n", color);
-		}
-	}
-	dump_printf(".\n");
-}
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
deleted file mode 100644
index 047ac33..0000000
--- a/tools/perf/util/debug.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/* For debugging general purposes */
-#ifndef __PERF_DEBUG_H
-#define __PERF_DEBUG_H
-
-#include <stdbool.h>
-#include "event.h"
-
-extern int verbose;
-extern bool dump_trace;
-
-int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
-void trace_event(event_t *event);
-
-struct ui_progress;
-
-#ifdef NO_NEWT_SUPPORT
-static inline int browser__show_help(const char *format __used, va_list ap __used)
-{
-	return 0;
-}
-
-static inline struct ui_progress *ui_progress__new(const char *title __used,
-						   u64 total __used)
-{
-	return (struct ui_progress *)1;
-}
-
-static inline void ui_progress__update(struct ui_progress *self __used,
-				       u64 curr __used) {}
-
-static inline void ui_progress__delete(struct ui_progress *self __used) {}
-#else
-int browser__show_help(const char *format, va_list ap);
-struct ui_progress *ui_progress__new(const char *title, u64 total);
-void ui_progress__update(struct ui_progress *self, u64 curr);
-void ui_progress__delete(struct ui_progress *self);
-#endif
-
-#endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index a746086..928d3de 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1,6 +1,6 @@
 #include <linux/types.h>
 #include "event.h"
-#include "debug.h"
+#include <lk/debug.h>
 #include "session.h"
 #include "sort.h"
 #include "string.h"
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 0ebd301..2177cfb 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -14,7 +14,7 @@
 #include "trace-event.h"
 #include "session.h"
 #include "symbol.h"
-#include "debug.h"
+#include <lk/debug.h>
 
 static bool no_buildid_cache = false;
 
diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index 791f9dd..8a9ca88 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -8,5 +8,6 @@
 #define __attribute_const__
 
 #define __used		__attribute__((__unused__))
+#define __weak         __attribute__((weak))
 
 #endif
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index 1eb804f..614bb72 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -87,9 +87,6 @@ simple_strtoul(const char *nptr, char **endptr, int base)
 	return strtoul(nptr, endptr, base);
 }
 
-int eprintf(int level,
-	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
-
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
 #endif
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index e672f2f..fa82eba 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -5,6 +5,8 @@
 #include <string.h>
 #include <stdio.h>
 #include <unistd.h>
+#include <lk/debug.h>
+
 #include "map.h"
 
 const char *map_type__name[MAP__NR_TYPES] = {
@@ -309,7 +311,7 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
 }
 
 size_t __map_groups__fprintf_maps(struct map_groups *self,
-				  enum map_type type, int verbose, FILE *fp)
+				  enum map_type type, int _verbose, FILE *fp)
 {
 	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
 	struct rb_node *nd;
@@ -318,7 +320,7 @@ size_t __map_groups__fprintf_maps(struct map_groups *self,
 		struct map *pos = rb_entry(nd, struct map, rb_node);
 		printed += fprintf(fp, "Map:");
 		printed += map__fprintf(pos, fp);
-		if (verbose > 2) {
+		if (_verbose > 2) {
 			printed += dso__fprintf(pos->dso, type, fp);
 			printed += fprintf(fp, "--\n");
 		}
@@ -327,17 +329,17 @@ size_t __map_groups__fprintf_maps(struct map_groups *self,
 	return printed;
 }
 
-size_t map_groups__fprintf_maps(struct map_groups *self, int verbose, FILE *fp)
+size_t map_groups__fprintf_maps(struct map_groups *self, int _verbose, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_maps(self, i, verbose, fp);
+		printed += __map_groups__fprintf_maps(self, i, _verbose, fp);
 	return printed;
 }
 
 static size_t __map_groups__fprintf_removed_maps(struct map_groups *self,
 						 enum map_type type,
-						 int verbose, FILE *fp)
+						 int _verbose, FILE *fp)
 {
 	struct map *pos;
 	size_t printed = 0;
@@ -345,7 +347,7 @@ static size_t __map_groups__fprintf_removed_maps(struct map_groups *self,
 	list_for_each_entry(pos, &self->removed_maps[type], node) {
 		printed += fprintf(fp, "Map:");
 		printed += map__fprintf(pos, fp);
-		if (verbose > 1) {
+		if (_verbose > 1) {
 			printed += dso__fprintf(pos->dso, type, fp);
 			printed += fprintf(fp, "--\n");
 		}
@@ -354,23 +356,23 @@ static size_t __map_groups__fprintf_removed_maps(struct map_groups *self,
 }
 
 static size_t map_groups__fprintf_removed_maps(struct map_groups *self,
-					       int verbose, FILE *fp)
+					       int _verbose, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_removed_maps(self, i, verbose, fp);
+		printed += __map_groups__fprintf_removed_maps(self, i, _verbose, fp);
 	return printed;
 }
 
-size_t map_groups__fprintf(struct map_groups *self, int verbose, FILE *fp)
+size_t map_groups__fprintf(struct map_groups *self, int _verbose, FILE *fp)
 {
-	size_t printed = map_groups__fprintf_maps(self, verbose, fp);
+	size_t printed = map_groups__fprintf_maps(self, _verbose, fp);
 	printed += fprintf(fp, "Removed maps:\n");
-	return printed + map_groups__fprintf_removed_maps(self, verbose, fp);
+	return printed + map_groups__fprintf_removed_maps(self, _verbose, fp);
 }
 
 int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
-				   int verbose, FILE *fp)
+				   int _verbose, FILE *fp)
 {
 	struct rb_root *root = &self->maps[map->type];
 	struct rb_node *next = rb_first(root);
@@ -382,7 +384,7 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 		if (!map__overlap(pos, map))
 			continue;
 
-		if (verbose >= 2) {
+		if (_verbose >= 2) {
 			fputs("overlapping maps:\n", fp);
 			map__fprintf(map, fp);
 			map__fprintf(pos, fp);
@@ -407,7 +409,7 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 
 			before->end = map->start - 1;
 			map_groups__insert(self, before);
-			if (verbose >= 2)
+			if (_verbose >= 2)
 				map__fprintf(before, fp);
 		}
 
@@ -419,7 +421,7 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 
 			after->start = map->end + 1;
 			map_groups__insert(self, after);
-			if (verbose >= 2)
+			if (_verbose >= 2)
 				map__fprintf(after, fp);
 		}
 	}
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index cf182ca..3918f22 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -117,7 +117,7 @@ static void ui_helpline__puts(const char *msg)
 
 static char browser__last_msg[1024];
 
-int browser__show_help(const char *format, va_list ap)
+int _browser__show_help(const char *format, va_list ap)
 {
 	int ret;
 	static int backlog;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3a76c8e..f298a43 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,5 +1,6 @@
 #include "../../../include/linux/hw_breakpoint.h"
 #include <lk/util.h>
+#include <lk/debug.h>
 #include "../perf.h"
 #include "parse-options.h"
 #include "parse-events.h"
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 74efa4a..c33e17d 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -37,7 +37,7 @@
 #include "event.h"
 #include "string.h"
 #include "strlist.h"
-#include "debug.h"
+#include <lk/debug.h>
 #include "cache.h"
 #include <lk/color.h>
 #include "symbol.h"
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index eb4eb26..8ac178d 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -35,7 +35,7 @@
 
 #include "string.h"
 #include "event.h"
-#include "debug.h"
+#include <lk/debug.h>
 #include <lk/util.h>
 #include "symbol.h"
 #include "probe-finder.h"
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 4dd264a..174b9c1 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -15,7 +15,7 @@
 #include "values.h"
 
 #include "../perf.h"
-#include "debug.h"
+#include <lk/debug.h>
 #include "header.h"
 
 #include "parse-options.h"
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
deleted file mode 100644
index 881ef63..0000000
--- a/tools/perf/util/string.c
+++ /dev/null
@@ -1,296 +0,0 @@
-#include <lk/util.h>
-#include "string.h"
-
-#define K 1024LL
-/*
- * perf_atoll()
- * Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB|tb|TB) (e.g. "256MB")
- * and return its numeric value
- */
-s64 perf_atoll(const char *str)
-{
-	unsigned int i;
-	s64 length = -1, unit = 1;
-
-	if (!isdigit(str[0]))
-		goto out_err;
-
-	for (i = 1; i < strlen(str); i++) {
-		switch (str[i]) {
-		case 'B':
-		case 'b':
-			break;
-		case 'K':
-			if (str[i + 1] != 'B')
-				goto out_err;
-			else
-				goto kilo;
-		case 'k':
-			if (str[i + 1] != 'b')
-				goto out_err;
-kilo:
-			unit = K;
-			break;
-		case 'M':
-			if (str[i + 1] != 'B')
-				goto out_err;
-			else
-				goto mega;
-		case 'm':
-			if (str[i + 1] != 'b')
-				goto out_err;
-mega:
-			unit = K * K;
-			break;
-		case 'G':
-			if (str[i + 1] != 'B')
-				goto out_err;
-			else
-				goto giga;
-		case 'g':
-			if (str[i + 1] != 'b')
-				goto out_err;
-giga:
-			unit = K * K * K;
-			break;
-		case 'T':
-			if (str[i + 1] != 'B')
-				goto out_err;
-			else
-				goto tera;
-		case 't':
-			if (str[i + 1] != 'b')
-				goto out_err;
-tera:
-			unit = K * K * K * K;
-			break;
-		case '\0':	/* only specified figures */
-			unit = 1;
-			break;
-		default:
-			if (!isdigit(str[i]))
-				goto out_err;
-			break;
-		}
-	}
-
-	length = atoll(str) * unit;
-	goto out;
-
-out_err:
-	length = -1;
-out:
-	return length;
-}
-
-/*
- * Helper function for splitting a string into an argv-like array.
- * originaly copied from lib/argv_split.c
- */
-static const char *skip_sep(const char *cp)
-{
-	while (*cp && isspace(*cp))
-		cp++;
-
-	return cp;
-}
-
-static const char *skip_arg(const char *cp)
-{
-	while (*cp && !isspace(*cp))
-		cp++;
-
-	return cp;
-}
-
-static int count_argc(const char *str)
-{
-	int count = 0;
-
-	while (*str) {
-		str = skip_sep(str);
-		if (*str) {
-			count++;
-			str = skip_arg(str);
-		}
-	}
-
-	return count;
-}
-
-/**
- * argv_free - free an argv
- * @argv - the argument vector to be freed
- *
- * Frees an argv and the strings it points to.
- */
-void argv_free(char **argv)
-{
-	char **p;
-	for (p = argv; *p; p++)
-		free(*p);
-
-	free(argv);
-}
-
-/**
- * argv_split - split a string at whitespace, returning an argv
- * @str: the string to be split
- * @argcp: returned argument count
- *
- * Returns an array of pointers to strings which are split out from
- * @str.  This is performed by strictly splitting on white-space; no
- * quote processing is performed.  Multiple whitespace characters are
- * considered to be a single argument separator.  The returned array
- * is always NULL-terminated.  Returns NULL on memory allocation
- * failure.
- */
-char **argv_split(const char *str, int *argcp)
-{
-	int argc = count_argc(str);
-	char **argv = zalloc(sizeof(*argv) * (argc+1));
-	char **argvp;
-
-	if (argv == NULL)
-		goto out;
-
-	if (argcp)
-		*argcp = argc;
-
-	argvp = argv;
-
-	while (*str) {
-		str = skip_sep(str);
-
-		if (*str) {
-			const char *p = str;
-			char *t;
-
-			str = skip_arg(str);
-
-			t = strndup(p, str-p);
-			if (t == NULL)
-				goto fail;
-			*argvp++ = t;
-		}
-	}
-	*argvp = NULL;
-
-out:
-	return argv;
-
-fail:
-	argv_free(argv);
-	return NULL;
-}
-
-/* Character class matching */
-static bool __match_charclass(const char *pat, char c, const char **npat)
-{
-	bool complement = false, ret = true;
-
-	if (*pat == '!') {
-		complement = true;
-		pat++;
-	}
-	if (*pat++ == c)	/* First character is special */
-		goto end;
-
-	while (*pat && *pat != ']') {	/* Matching */
-		if (*pat == '-' && *(pat + 1) != ']') {	/* Range */
-			if (*(pat - 1) <= c && c <= *(pat + 1))
-				goto end;
-			if (*(pat - 1) > *(pat + 1))
-				goto error;
-			pat += 2;
-		} else if (*pat++ == c)
-			goto end;
-	}
-	if (!*pat)
-		goto error;
-	ret = false;
-
-end:
-	while (*pat && *pat != ']')	/* Searching closing */
-		pat++;
-	if (!*pat)
-		goto error;
-	*npat = pat + 1;
-	return complement ? !ret : ret;
-
-error:
-	return false;
-}
-
-/* Glob/lazy pattern matching */
-static bool __match_glob(const char *str, const char *pat, bool ignore_space)
-{
-	while (*str && *pat && *pat != '*') {
-		if (ignore_space) {
-			/* Ignore spaces for lazy matching */
-			if (isspace(*str)) {
-				str++;
-				continue;
-			}
-			if (isspace(*pat)) {
-				pat++;
-				continue;
-			}
-		}
-		if (*pat == '?') {	/* Matches any single character */
-			str++;
-			pat++;
-			continue;
-		} else if (*pat == '[')	/* Character classes/Ranges */
-			if (__match_charclass(pat + 1, *str, &pat)) {
-				str++;
-				continue;
-			} else
-				return false;
-		else if (*pat == '\\') /* Escaped char match as normal char */
-			pat++;
-		if (*str++ != *pat++)
-			return false;
-	}
-	/* Check wild card */
-	if (*pat == '*') {
-		while (*pat == '*')
-			pat++;
-		if (!*pat)	/* Tail wild card matches all */
-			return true;
-		while (*str)
-			if (strglobmatch(str++, pat))
-				return true;
-	}
-	return !*str && !*pat;
-}
-
-/**
- * strglobmatch - glob expression pattern matching
- * @str: the target string to match
- * @pat: the pattern string to match
- *
- * This returns true if the @str matches @pat. @pat can includes wildcards
- * ('*','?') and character classes ([CHARS], complementation and ranges are
- * also supported). Also, this supports escape character ('\') to use special
- * characters as normal character.
- *
- * Note: if @pat syntax is broken, this always returns false.
- */
-bool strglobmatch(const char *str, const char *pat)
-{
-	return __match_glob(str, pat, false);
-}
-
-/**
- * strlazymatch - matching pattern strings lazily with glob pattern
- * @str: the target string to match
- * @pat: the pattern string to match
- *
- * This is similar to strglobmatch, except this ignores spaces in
- * the target string.
- */
-bool strlazymatch(const char *str, const char *pat)
-{
-	return __match_glob(str, pat, true);
-}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 971d0a0..7012560 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -21,6 +21,8 @@
 #include <limits.h>
 #include <sys/utsname.h>
 
+#include <lk/debug.h>
+
 #ifndef NT_GNU_BUILD_ID
 #define NT_GNU_BUILD_ID 3
 #endif
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index deb30a8..c2652fd 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -5,7 +5,7 @@
 #include "session.h"
 #include "thread.h"
 #include <lk/util.h>
-#include "debug.h"
+#include <lk/debug.h>
 
 int find_all_tid(int pid, pid_t ** all_tid)
 {
-- 
1.7.1

