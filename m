Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2DZFSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:18:31 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50162 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab2DZFQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:24 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-2a-4f98da243e9f
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 08/13] perf target: Split out perf_target handling code
Date: Thu, 26 Apr 2012 14:15:22 +0900
Message-Id: <1335417327-11796-9-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For further work on perf_target, it'd be better off splitting
the code into a separate file.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/Makefile      |    2 ++
 tools/perf/perf.h        |    9 +--------
 tools/perf/util/evlist.c |    1 +
 tools/perf/util/evsel.c  |    1 +
 tools/perf/util/target.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/target.h |   17 +++++++++++++++++
 tools/perf/util/usage.c  |   34 ----------------------------------
 tools/perf/util/util.h   |    2 --
 8 files changed, 67 insertions(+), 44 deletions(-)
 create mode 100644 tools/perf/util/target.c
 create mode 100644 tools/perf/util/target.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e98e14c88532..4122a668952e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -300,6 +300,7 @@ LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
+LIB_H += util/target.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -361,6 +362,7 @@ LIB_OBJS += $(OUTPUT)util/util.o
 LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
 LIB_OBJS += $(OUTPUT)util/cgroup.o
+LIB_OBJS += $(OUTPUT)util/target.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 7e226c0e0e31..14f1034f14f9 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -207,14 +207,7 @@ extern const char perf_version_string[];
 
 void pthread__unblock_sigwinch(void);
 
-struct perf_target {
-	const char   *pid;
-	const char   *tid;
-	const char   *cpu_list;
-	const char   *uid_str;
-	uid_t	     uid;
-	bool	     system_wide;
-};
+#include "util/target.h"
 
 struct perf_record_opts {
 	struct perf_target target;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 556d98af1a0b..183b199b0d09 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -11,6 +11,7 @@
 #include <poll.h>
 #include "cpumap.h"
 #include "thread_map.h"
+#include "target.h"
 #include "evlist.h"
 #include "evsel.h"
 #include <unistd.h>
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d90598edcf1d..bb785a098ced 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -14,6 +14,7 @@
 #include "util.h"
 #include "cpumap.h"
 #include "thread_map.h"
+#include "target.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
new file mode 100644
index 000000000000..3fadf85dd7e3
--- /dev/null
+++ b/tools/perf/util/target.c
@@ -0,0 +1,45 @@
+/*
+ * Helper functions for handling target threads/cpus
+ *
+ * Copyright (C) 2012, LG Electronics, Namhyung Kim <namhyung.kim@lge.com>
+ *
+ * Released under the GPL v2.
+ */
+
+#include "target.h"
+#include "debug.h"
+
+
+void perf_target__validate(struct perf_target *target)
+{
+	if (target->pid)
+		target->tid = target->pid;
+
+	/* CPU and PID are mutually exclusive */
+	if (target->tid && target->cpu_list) {
+		ui__warning("WARNING: PID switch overriding CPU\n");
+		sleep(1);
+		target->cpu_list = NULL;
+	}
+
+	/* UID and PID are mutually exclusive */
+	if (target->tid && target->uid_str) {
+		ui__warning("PID/TID switch overriding UID\n");
+		sleep(1);
+		target->uid_str = NULL;
+	}
+
+	/* UID and CPU are mutually exclusive */
+	if (target->uid_str && target->cpu_list) {
+		ui__warning("UID switch overriding CPU\n");
+		sleep(1);
+		target->cpu_list = NULL;
+	}
+
+	/* PID/UID and SYSTEM are mutually exclusive */
+	if ((target->tid || target->uid_str) && target->system_wide) {
+		ui__warning("PID/TID/UID switch overriding CPU\n");
+		sleep(1);
+		target->system_wide = false;
+	}
+}
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
new file mode 100644
index 000000000000..1348065ada5e
--- /dev/null
+++ b/tools/perf/util/target.h
@@ -0,0 +1,17 @@
+#ifndef _PERF_TARGET_H
+#define _PERF_TARGET_H
+
+#include "util.h"
+
+struct perf_target {
+	const char   *pid;
+	const char   *tid;
+	const char   *cpu_list;
+	const char   *uid_str;
+	uid_t	     uid;
+	bool	     system_wide;
+};
+
+void perf_target__validate(struct perf_target *target);
+
+#endif /* _PERF_TARGET_H */
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index 228f0a558872..e851abc22ccc 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -113,37 +113,3 @@ uid_t parse_target_uid(const char *str)
 
 	return result->pw_uid;
 }
-
-void perf_target__validate(struct perf_target *target)
-{
-	if (target->pid)
-		target->tid = target->pid;
-
-	/* CPU and PID are mutually exclusive */
-	if (target->tid && target->cpu_list) {
-		ui__warning("WARNING: PID switch overriding CPU\n");
-		sleep(1);
-		target->cpu_list = NULL;
-	}
-
-	/* UID and PID are mutually exclusive */
-	if (target->tid && target->uid_str) {
-		ui__warning("PID/TID switch overriding UID\n");
-		sleep(1);
-		target->uid_str = NULL;
-	}
-
-	/* UID and CPU are mutually exclusive */
-	if (target->uid_str && target->cpu_list) {
-		ui__warning("UID switch overriding CPU\n");
-		sleep(1);
-		target->cpu_list = NULL;
-	}
-
-	/* PID/UID and SYSTEM are mutually exclusive */
-	if ((target->tid || target->uid_str) && target->system_wide) {
-		ui__warning("PID/TID/UID switch overriding CPU\n");
-		sleep(1);
-		target->system_wide = false;
-	}
-}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 3f05d6264dab..52be74c359d3 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -246,12 +246,10 @@ unsigned long convert_unit(unsigned long value, char *unit);
 int readn(int fd, void *buf, size_t size);
 
 struct perf_event_attr;
-struct perf_target;
 
 void event_attr_init(struct perf_event_attr *attr);
 
 uid_t parse_target_uid(const char *str);
-void perf_target__validate(struct perf_target *target);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
-- 
1.7.10

