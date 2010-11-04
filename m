Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab0KDPm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:42:29 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41965 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0KDPjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:19 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 08/20] perf: Export cpumap
Date: Thu,  4 Nov 2010 16:36:44 +0100
Message-Id: <1288885016-18295-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Export cpu counting and cpumap manipulating utils for general use. This
pulls ctype.c along.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/Makefile       |    3 +
 tools/lib/lk/cpumap.c       |  114 +++++++++++++++++++++++++++++++++++++++++++
 tools/lib/lk/cpumap.h       |    7 +++
 tools/lib/lk/ctype.c        |   39 +++++++++++++++
 tools/perf/Makefile         |    3 -
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-stat.c   |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/util/cpumap.c    |  114 -------------------------------------------
 tools/perf/util/cpumap.h    |    7 ---
 tools/perf/util/ctype.c     |   39 ---------------
 11 files changed, 166 insertions(+), 166 deletions(-)
 create mode 100644 tools/lib/lk/cpumap.c
 create mode 100644 tools/lib/lk/cpumap.h
 create mode 100644 tools/lib/lk/ctype.c
 delete mode 100644 tools/perf/util/cpumap.c
 delete mode 100644 tools/perf/util/cpumap.h
 delete mode 100644 tools/perf/util/ctype.c

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 823bbb5..ff94b2e 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -7,9 +7,12 @@ LIB_OBJS=
 LIB_H += debugfs.h
 LIB_H += util.h
 LIB_H += types.h
+LIB_H += cpumap.h
 
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
+LIB_OBJS += cpumap.o
+LIB_OBJS += ctype.o
 
 LIBFILE = $(LIB_OUTPUT)lklib.a
 
diff --git a/tools/lib/lk/cpumap.c b/tools/lib/lk/cpumap.c
new file mode 100644
index 0000000..7c3008a
--- /dev/null
+++ b/tools/lib/lk/cpumap.c
@@ -0,0 +1,114 @@
+#include <lk/util.h>
+#include <perf.h>
+#include "cpumap.h"
+#include <assert.h>
+#include <stdio.h>
+
+int cpumap[MAX_NR_CPUS];
+
+static int default_cpu_map(void)
+{
+	int nr_cpus, i;
+
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	assert(nr_cpus <= MAX_NR_CPUS);
+	assert((int)nr_cpus >= 0);
+
+	for (i = 0; i < nr_cpus; ++i)
+		cpumap[i] = i;
+
+	return nr_cpus;
+}
+
+static int read_all_cpu_map(void)
+{
+	FILE *onlnf;
+	int nr_cpus = 0;
+	int n, cpu, prev;
+	char sep;
+
+	onlnf = fopen("/sys/devices/system/cpu/online", "r");
+	if (!onlnf)
+		return default_cpu_map();
+
+	sep = 0;
+	prev = -1;
+	for (;;) {
+		n = fscanf(onlnf, "%u%c", &cpu, &sep);
+		if (n <= 0)
+			break;
+		if (prev >= 0) {
+			assert(nr_cpus + cpu - prev - 1 < MAX_NR_CPUS);
+			while (++prev < cpu)
+				cpumap[nr_cpus++] = prev;
+		}
+		assert (nr_cpus < MAX_NR_CPUS);
+		cpumap[nr_cpus++] = cpu;
+		if (n == 2 && sep == '-')
+			prev = cpu;
+		else
+			prev = -1;
+		if (n == 1 || sep == '\n')
+			break;
+	}
+	fclose(onlnf);
+	if (nr_cpus > 0)
+		return nr_cpus;
+
+	return default_cpu_map();
+}
+
+int read_cpu_map(const char *cpu_list)
+{
+	unsigned long start_cpu, end_cpu = 0;
+	char *p = NULL;
+	int i, nr_cpus = 0;
+
+	if (!cpu_list)
+		return read_all_cpu_map();
+
+	if (!isdigit(*cpu_list))
+		goto invalid;
+
+	while (isdigit(*cpu_list)) {
+		p = NULL;
+		start_cpu = strtoul(cpu_list, &p, 0);
+		if (start_cpu >= INT_MAX
+		    || (*p != '\0' && *p != ',' && *p != '-'))
+			goto invalid;
+
+		if (*p == '-') {
+			cpu_list = ++p;
+			p = NULL;
+			end_cpu = strtoul(cpu_list, &p, 0);
+
+			if (end_cpu >= INT_MAX || (*p != '\0' && *p != ','))
+				goto invalid;
+
+			if (end_cpu < start_cpu)
+				goto invalid;
+		} else {
+			end_cpu = start_cpu;
+		}
+
+		for (; start_cpu <= end_cpu; start_cpu++) {
+			/* check for duplicates */
+			for (i = 0; i < nr_cpus; i++)
+				if (cpumap[i] == (int)start_cpu)
+					goto invalid;
+
+			assert(nr_cpus < MAX_NR_CPUS);
+			cpumap[nr_cpus++] = (int)start_cpu;
+		}
+		if (*p)
+			++p;
+
+		cpu_list = p;
+	}
+	if (nr_cpus > 0)
+		return nr_cpus;
+
+	return default_cpu_map();
+invalid:
+	return -1;
+}
diff --git a/tools/lib/lk/cpumap.h b/tools/lib/lk/cpumap.h
new file mode 100644
index 0000000..1d7bd56
--- /dev/null
+++ b/tools/lib/lk/cpumap.h
@@ -0,0 +1,7 @@
+#ifndef __LK_CPUMAP_H
+#define __LK_CPUMAP_H
+
+extern int read_cpu_map(const char *cpu_list);
+extern int cpumap[];
+
+#endif /* __LK_CPUMAP_H */
diff --git a/tools/lib/lk/ctype.c b/tools/lib/lk/ctype.c
new file mode 100644
index 0000000..aada3ac
--- /dev/null
+++ b/tools/lib/lk/ctype.c
@@ -0,0 +1,39 @@
+/*
+ * Sane locale-independent, ASCII ctype.
+ *
+ * No surprises, and works with signed and unsigned chars.
+ */
+#include "util.h"
+
+enum {
+	S = GIT_SPACE,
+	A = GIT_ALPHA,
+	D = GIT_DIGIT,
+	G = GIT_GLOB_SPECIAL,	/* *, ?, [, \\ */
+	R = GIT_REGEX_SPECIAL,	/* $, (, ), +, ., ^, {, | * */
+	P = GIT_PRINT_EXTRA,	/* printable - alpha - digit - glob - regex */
+
+	PS = GIT_SPACE | GIT_PRINT_EXTRA,
+};
+
+unsigned char sane_ctype[256] = {
+/*	0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F			    */
+
+	0, 0, 0, 0, 0, 0, 0, 0, 0, S, S, 0, 0, S, 0, 0,		/*   0.. 15 */
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,		/*  16.. 31 */
+	PS,P, P, P, R, P, P, P, R, R, G, R, P, P, R, P,		/*  32.. 47 */
+	D, D, D, D, D, D, D, D, D, D, P, P, P, P, P, G,		/*  48.. 63 */
+	P, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  64.. 79 */
+	A, A, A, A, A, A, A, A, A, A, A, G, G, P, R, P,		/*  80.. 95 */
+	P, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  96..111 */
+	A, A, A, A, A, A, A, A, A, A, A, R, R, P, P, 0,		/* 112..127 */
+	/* Nothing in the 128.. range */
+};
+
+const char *graph_line =
+	"_____________________________________________________________________"
+	"_____________________________________________________________________";
+const char *graph_dotted_line =
+	"---------------------------------------------------------------------"
+	"---------------------------------------------------------------------"
+	"---------------------------------------------------------------------";
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d8ef5a5..49690b8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -385,13 +385,11 @@ LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
-LIB_H += util/cpumap.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
-LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
@@ -430,7 +428,6 @@ LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/util.o
-LIB_OBJS += $(OUTPUT)util/cpumap.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 936e231..1fa7a06 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -21,7 +21,7 @@
 #include "util/debug.h"
 #include "util/session.h"
 #include "util/symbol.h"
-#include "util/cpumap.h"
+#include <lk/cpumap.h>
 
 #include <unistd.h>
 #include <sched.h>
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 12dabd3..1f60239 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -45,7 +45,7 @@
 #include "util/event.h"
 #include "util/debug.h"
 #include "util/header.h"
-#include "util/cpumap.h"
+#include <lk/cpumap.h>
 #include "util/thread.h"
 
 #include <sys/prctl.h>
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7ba3759..b5bc157 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -28,7 +28,7 @@
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
-#include "util/cpumap.h"
+#include <lk/cpumap.h>
 
 #include "util/debug.h"
 
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
deleted file mode 100644
index 8ef8cef..0000000
--- a/tools/perf/util/cpumap.c
+++ /dev/null
@@ -1,114 +0,0 @@
-#include <lk/util.h>
-#include "../perf.h"
-#include "cpumap.h"
-#include <assert.h>
-#include <stdio.h>
-
-int cpumap[MAX_NR_CPUS];
-
-static int default_cpu_map(void)
-{
-	int nr_cpus, i;
-
-	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
-	assert(nr_cpus <= MAX_NR_CPUS);
-	assert((int)nr_cpus >= 0);
-
-	for (i = 0; i < nr_cpus; ++i)
-		cpumap[i] = i;
-
-	return nr_cpus;
-}
-
-static int read_all_cpu_map(void)
-{
-	FILE *onlnf;
-	int nr_cpus = 0;
-	int n, cpu, prev;
-	char sep;
-
-	onlnf = fopen("/sys/devices/system/cpu/online", "r");
-	if (!onlnf)
-		return default_cpu_map();
-
-	sep = 0;
-	prev = -1;
-	for (;;) {
-		n = fscanf(onlnf, "%u%c", &cpu, &sep);
-		if (n <= 0)
-			break;
-		if (prev >= 0) {
-			assert(nr_cpus + cpu - prev - 1 < MAX_NR_CPUS);
-			while (++prev < cpu)
-				cpumap[nr_cpus++] = prev;
-		}
-		assert (nr_cpus < MAX_NR_CPUS);
-		cpumap[nr_cpus++] = cpu;
-		if (n == 2 && sep == '-')
-			prev = cpu;
-		else
-			prev = -1;
-		if (n == 1 || sep == '\n')
-			break;
-	}
-	fclose(onlnf);
-	if (nr_cpus > 0)
-		return nr_cpus;
-
-	return default_cpu_map();
-}
-
-int read_cpu_map(const char *cpu_list)
-{
-	unsigned long start_cpu, end_cpu = 0;
-	char *p = NULL;
-	int i, nr_cpus = 0;
-
-	if (!cpu_list)
-		return read_all_cpu_map();
-
-	if (!isdigit(*cpu_list))
-		goto invalid;
-
-	while (isdigit(*cpu_list)) {
-		p = NULL;
-		start_cpu = strtoul(cpu_list, &p, 0);
-		if (start_cpu >= INT_MAX
-		    || (*p != '\0' && *p != ',' && *p != '-'))
-			goto invalid;
-
-		if (*p == '-') {
-			cpu_list = ++p;
-			p = NULL;
-			end_cpu = strtoul(cpu_list, &p, 0);
-
-			if (end_cpu >= INT_MAX || (*p != '\0' && *p != ','))
-				goto invalid;
-
-			if (end_cpu < start_cpu)
-				goto invalid;
-		} else {
-			end_cpu = start_cpu;
-		}
-
-		for (; start_cpu <= end_cpu; start_cpu++) {
-			/* check for duplicates */
-			for (i = 0; i < nr_cpus; i++)
-				if (cpumap[i] == (int)start_cpu)
-					goto invalid;
-
-			assert(nr_cpus < MAX_NR_CPUS);
-			cpumap[nr_cpus++] = (int)start_cpu;
-		}
-		if (*p)
-			++p;
-
-		cpu_list = p;
-	}
-	if (nr_cpus > 0)
-		return nr_cpus;
-
-	return default_cpu_map();
-invalid:
-	return -1;
-}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
deleted file mode 100644
index 3e60f56..0000000
--- a/tools/perf/util/cpumap.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __PERF_CPUMAP_H
-#define __PERF_CPUMAP_H
-
-extern int read_cpu_map(const char *cpu_list);
-extern int cpumap[];
-
-#endif /* __PERF_CPUMAP_H */
diff --git a/tools/perf/util/ctype.c b/tools/perf/util/ctype.c
deleted file mode 100644
index 3507362..0000000
--- a/tools/perf/util/ctype.c
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Sane locale-independent, ASCII ctype.
- *
- * No surprises, and works with signed and unsigned chars.
- */
-#include "cache.h"
-
-enum {
-	S = GIT_SPACE,
-	A = GIT_ALPHA,
-	D = GIT_DIGIT,
-	G = GIT_GLOB_SPECIAL,	/* *, ?, [, \\ */
-	R = GIT_REGEX_SPECIAL,	/* $, (, ), +, ., ^, {, | * */
-	P = GIT_PRINT_EXTRA,	/* printable - alpha - digit - glob - regex */
-
-	PS = GIT_SPACE | GIT_PRINT_EXTRA,
-};
-
-unsigned char sane_ctype[256] = {
-/*	0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F			    */
-
-	0, 0, 0, 0, 0, 0, 0, 0, 0, S, S, 0, 0, S, 0, 0,		/*   0.. 15 */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,		/*  16.. 31 */
-	PS,P, P, P, R, P, P, P, R, R, G, R, P, P, R, P,		/*  32.. 47 */
-	D, D, D, D, D, D, D, D, D, D, P, P, P, P, P, G,		/*  48.. 63 */
-	P, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  64.. 79 */
-	A, A, A, A, A, A, A, A, A, A, A, G, G, P, R, P,		/*  80.. 95 */
-	P, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  96..111 */
-	A, A, A, A, A, A, A, A, A, A, A, R, R, P, P, 0,		/* 112..127 */
-	/* Nothing in the 128.. range */
-};
-
-const char *graph_line =
-	"_____________________________________________________________________"
-	"_____________________________________________________________________";
-const char *graph_dotted_line =
-	"---------------------------------------------------------------------"
-	"---------------------------------------------------------------------"
-	"---------------------------------------------------------------------";
-- 
1.7.3.1

