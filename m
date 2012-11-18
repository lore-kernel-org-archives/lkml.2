Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2KROaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:30:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:59364 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab2KROaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/32] perf tests: Move test__open_syscall_event into separate object
Date: Sun, 18 Nov 2012 11:29:27 -0300
Message-Id: <1353248997-30763-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Separating test__open_syscall_event test from the builtin-test into
open-syscall object.

Adding util object under tests directory to gather help functions common
to more tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352508412-16914-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |    2 +
 tools/perf/tests/builtin-test.c |   84 ---------------------------------------
 tools/perf/tests/open-syscall.c |   66 ++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |    5 +++
 tools/perf/tests/util.c         |   30 ++++++++++++++
 5 files changed, 103 insertions(+), 84 deletions(-)
 create mode 100644 tools/perf/tests/open-syscall.c
 create mode 100644 tools/perf/tests/util.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7c7ba4d..69f582c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -432,6 +432,8 @@ LIB_OBJS += $(OUTPUT)tests/parse-events.o
 LIB_OBJS += $(OUTPUT)tests/dso-data.o
 LIB_OBJS += $(OUTPUT)tests/attr.o
 LIB_OBJS += $(OUTPUT)tests/vmlinux-kallsyms.o
+LIB_OBJS += $(OUTPUT)tests/open-syscall.o
+LIB_OBJS += $(OUTPUT)tests/util.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 5bc9063..b6b1e46 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -27,90 +27,6 @@
 
 #include "tests.h"
 
-static int trace_event__id(const char *evname)
-{
-	char *filename;
-	int err = -1, fd;
-
-	if (asprintf(&filename,
-		     "%s/syscalls/%s/id",
-		     tracing_events_path, evname) < 0)
-		return -1;
-
-	fd = open(filename, O_RDONLY);
-	if (fd >= 0) {
-		char id[16];
-		if (read(fd, id, sizeof(id)) > 0)
-			err = atoi(id);
-		close(fd);
-	}
-
-	free(filename);
-	return err;
-}
-
-static int test__open_syscall_event(void)
-{
-	int err = -1, fd;
-	struct thread_map *threads;
-	struct perf_evsel *evsel;
-	struct perf_event_attr attr;
-	unsigned int nr_open_calls = 111, i;
-	int id = trace_event__id("sys_enter_open");
-
-	if (id < 0) {
-		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
-		return -1;
-	}
-
-	threads = thread_map__new(-1, getpid(), UINT_MAX);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
-		return -1;
-	}
-
-	memset(&attr, 0, sizeof(attr));
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.config = id;
-	evsel = perf_evsel__new(&attr, 0);
-	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
-		goto out_thread_map_delete;
-	}
-
-	if (perf_evsel__open_per_thread(evsel, threads) < 0) {
-		pr_debug("failed to open counter: %s, "
-			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-			 strerror(errno));
-		goto out_evsel_delete;
-	}
-
-	for (i = 0; i < nr_open_calls; ++i) {
-		fd = open("/etc/passwd", O_RDONLY);
-		close(fd);
-	}
-
-	if (perf_evsel__read_on_cpu(evsel, 0, 0) < 0) {
-		pr_debug("perf_evsel__read_on_cpu\n");
-		goto out_close_fd;
-	}
-
-	if (evsel->counts->cpu[0].val != nr_open_calls) {
-		pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls, got %" PRIu64 "\n",
-			 nr_open_calls, evsel->counts->cpu[0].val);
-		goto out_close_fd;
-	}
-
-	err = 0;
-out_close_fd:
-	perf_evsel__close_fd(evsel, 1, threads->nr);
-out_evsel_delete:
-	perf_evsel__delete(evsel);
-out_thread_map_delete:
-	thread_map__delete(threads);
-	return err;
-}
-
 #include <sched.h>
 
 static int test__open_syscall_event_on_all_cpus(void)
diff --git a/tools/perf/tests/open-syscall.c b/tools/perf/tests/open-syscall.c
new file mode 100644
index 0000000..98be8b5
--- /dev/null
+++ b/tools/perf/tests/open-syscall.c
@@ -0,0 +1,66 @@
+#include "thread_map.h"
+#include "evsel.h"
+#include "debug.h"
+#include "tests.h"
+
+int test__open_syscall_event(void)
+{
+	int err = -1, fd;
+	struct thread_map *threads;
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
+	unsigned int nr_open_calls = 111, i;
+	int id = trace_event__id("sys_enter_open");
+
+	if (id < 0) {
+		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
+		return -1;
+	}
+
+	threads = thread_map__new(-1, getpid(), UINT_MAX);
+	if (threads == NULL) {
+		pr_debug("thread_map__new\n");
+		return -1;
+	}
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.config = id;
+	evsel = perf_evsel__new(&attr, 0);
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new\n");
+		goto out_thread_map_delete;
+	}
+
+	if (perf_evsel__open_per_thread(evsel, threads) < 0) {
+		pr_debug("failed to open counter: %s, "
+			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
+			 strerror(errno));
+		goto out_evsel_delete;
+	}
+
+	for (i = 0; i < nr_open_calls; ++i) {
+		fd = open("/etc/passwd", O_RDONLY);
+		close(fd);
+	}
+
+	if (perf_evsel__read_on_cpu(evsel, 0, 0) < 0) {
+		pr_debug("perf_evsel__read_on_cpu\n");
+		goto out_close_fd;
+	}
+
+	if (evsel->counts->cpu[0].val != nr_open_calls) {
+		pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls, got %" PRIu64 "\n",
+			 nr_open_calls, evsel->counts->cpu[0].val);
+		goto out_close_fd;
+	}
+
+	err = 0;
+out_close_fd:
+	perf_evsel__close_fd(evsel, 1, threads->nr);
+out_evsel_delete:
+	perf_evsel__delete(evsel);
+out_thread_map_delete:
+	thread_map__delete(threads);
+	return err;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 2223de5..bac133e 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -1,6 +1,11 @@
 #ifndef TESTS_H
 #define TESTS_H
 
+/* Tests */
 int test__vmlinux_matches_kallsyms(void);
+int test__open_syscall_event(void);
+
+/* Util */
+int trace_event__id(const char *evname);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/tests/util.c b/tools/perf/tests/util.c
new file mode 100644
index 0000000..748f2e8
--- /dev/null
+++ b/tools/perf/tests/util.c
@@ -0,0 +1,30 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include "tests.h"
+#include "debugfs.h"
+
+int trace_event__id(const char *evname)
+{
+	char *filename;
+	int err = -1, fd;
+
+	if (asprintf(&filename,
+		     "%s/syscalls/%s/id",
+		     tracing_events_path, evname) < 0)
+		return -1;
+
+	fd = open(filename, O_RDONLY);
+	if (fd >= 0) {
+		char id[16];
+		if (read(fd, id, sizeof(id)) > 0)
+			err = atoi(id);
+		close(fd);
+	}
+
+	free(filename);
+	return err;
+}
-- 
1.7.9.2.358.g22243

