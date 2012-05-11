Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab2EKGdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:33:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57102 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2EKGdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:33:22 -0400
Date: Thu, 10 May 2012 23:33:01 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-12864b31583bcbd26789ebe68c612688f9ee2e30@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1335417327-11796-9-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-9-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf target: Split out perf_target handling code
Git-Commit-ID: 12864b31583bcbd26789ebe68c612688f9ee2e30
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:33:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12864b31583bcbd26789ebe68c612688f9ee2e30
Gitweb:     http://git.kernel.org/tip/12864b31583bcbd26789ebe68c612688f9ee2e30
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 26 Apr 2012 14:15:22 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 2 May 2012 15:41:11 -0300

perf target: Split out perf_target handling code

For further work on perf_target, it'd be better off splitting the code
into a separate file.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335417327-11796-9-git-send-email-namhyung.kim@lge.com
[ committer note: Fixed perl build by using stdbool and types.h in target.h ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    2 ++
 tools/perf/perf.h        |    9 +--------
 tools/perf/util/evlist.c |    1 +
 tools/perf/util/evsel.c  |    1 +
 tools/perf/util/target.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/target.h |   18 ++++++++++++++++++
 tools/perf/util/usage.c  |   34 ----------------------------------
 tools/perf/util/util.h   |    2 --
 8 files changed, 68 insertions(+), 44 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e98e14c..4122a66 100644
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
index 7e226c0..14f1034 100644
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
index a43e2c5..3032862 100644
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
index d90598e..bb785a0 100644
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
index 0000000..3fadf85
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
index 0000000..218291f
--- /dev/null
+++ b/tools/perf/util/target.h
@@ -0,0 +1,18 @@
+#ifndef _PERF_TARGET_H
+#define _PERF_TARGET_H
+
+#include <stdbool.h>
+#include <sys/types.h>
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
index 228f0a5..e851abc 100644
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
index 3f05d62..52be74c 100644
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
