Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2KROaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:30:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:59363 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2KROaO (ORCPT
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
Subject: [PATCH 07/32] perf tests: Move perf_evsel__roundtrip_name_test into separate object
Date: Sun, 18 Nov 2012 11:29:32 -0300
Message-Id: <1353248997-30763-8-git-send-email-acme@infradead.org>
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

Separating perf_evsel__roundtrip_name_test test from the builtin-test
into evsel-roundtrip-name object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352508412-16914-8-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                     |    1 +
 tools/perf/tests/builtin-test.c         |  112 +-----------------------------
 tools/perf/tests/evsel-roundtrip-name.c |  114 +++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h                |    1 +
 4 files changed, 117 insertions(+), 111 deletions(-)
 create mode 100644 tools/perf/tests/evsel-roundtrip-name.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2e5197a..ad6fcb5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -437,6 +437,7 @@ LIB_OBJS += $(OUTPUT)tests/open-syscall-all-cpus.o
 LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
 LIB_OBJS += $(OUTPUT)tests/perf-record.o
 LIB_OBJS += $(OUTPUT)tests/rdpmc.o
+LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
 LIB_OBJS += $(OUTPUT)tests/util.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 1e9a0ea..93f5e91 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -35,116 +35,6 @@ static int test__perf_pmu(void)
 	return perf_pmu__test();
 }
 
-static int perf_evsel__roundtrip_cache_name_test(void)
-{
-	char name[128];
-	int type, op, err = 0, ret = 0, i, idx;
-	struct perf_evsel *evsel;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-
-        if (evlist == NULL)
-                return -ENOMEM;
-
-	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
-		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
-			/* skip invalid cache type */
-			if (!perf_evsel__is_cache_op_valid(type, op))
-				continue;
-
-			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
-									name, sizeof(name));
-				err = parse_events(evlist, name, 0);
-				if (err)
-					ret = err;
-			}
-		}
-	}
-
-	idx = 0;
-	evsel = perf_evlist__first(evlist);
-
-	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
-		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
-			/* skip invalid cache type */
-			if (!perf_evsel__is_cache_op_valid(type, op))
-				continue;
-
-			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
-									name, sizeof(name));
-				if (evsel->idx != idx)
-					continue;
-
-				++idx;
-
-				if (strcmp(perf_evsel__name(evsel), name)) {
-					pr_debug("%s != %s\n", perf_evsel__name(evsel), name);
-					ret = -1;
-				}
-
-				evsel = perf_evsel__next(evsel);
-			}
-		}
-	}
-
-	perf_evlist__delete(evlist);
-	return ret;
-}
-
-static int __perf_evsel__name_array_test(const char *names[], int nr_names)
-{
-	int i, err;
-	struct perf_evsel *evsel;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-
-        if (evlist == NULL)
-                return -ENOMEM;
-
-	for (i = 0; i < nr_names; ++i) {
-		err = parse_events(evlist, names[i], 0);
-		if (err) {
-			pr_debug("failed to parse event '%s', err %d\n",
-				 names[i], err);
-			goto out_delete_evlist;
-		}
-	}
-
-	err = 0;
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		if (strcmp(perf_evsel__name(evsel), names[evsel->idx])) {
-			--err;
-			pr_debug("%s != %s\n", perf_evsel__name(evsel), names[evsel->idx]);
-		}
-	}
-
-out_delete_evlist:
-	perf_evlist__delete(evlist);
-	return err;
-}
-
-#define perf_evsel__name_array_test(names) \
-	__perf_evsel__name_array_test(names, ARRAY_SIZE(names))
-
-static int perf_evsel__roundtrip_name_test(void)
-{
-	int err = 0, ret = 0;
-
-	err = perf_evsel__name_array_test(perf_evsel__hw_names);
-	if (err)
-		ret = err;
-
-	err = perf_evsel__name_array_test(perf_evsel__sw_names);
-	if (err)
-		ret = err;
-
-	err = perf_evsel__roundtrip_cache_name_test();
-	if (err)
-		ret = err;
-
-	return ret;
-}
-
 static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
 				  int size, bool should_be_signed)
 {
@@ -382,7 +272,7 @@ static struct test {
 	},
 	{
 		.desc = "roundtrip evsel->name check",
-		.func = perf_evsel__roundtrip_name_test,
+		.func = test__perf_evsel__roundtrip_name_test,
 	},
 	{
 		.desc = "Check parsing of sched tracepoints fields",
diff --git a/tools/perf/tests/evsel-roundtrip-name.c b/tools/perf/tests/evsel-roundtrip-name.c
new file mode 100644
index 0000000..e61fc82
--- /dev/null
+++ b/tools/perf/tests/evsel-roundtrip-name.c
@@ -0,0 +1,114 @@
+#include "evlist.h"
+#include "evsel.h"
+#include "parse-events.h"
+#include "tests.h"
+
+static int perf_evsel__roundtrip_cache_name_test(void)
+{
+	char name[128];
+	int type, op, err = 0, ret = 0, i, idx;
+	struct perf_evsel *evsel;
+        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+
+        if (evlist == NULL)
+                return -ENOMEM;
+
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			/* skip invalid cache type */
+			if (!perf_evsel__is_cache_op_valid(type, op))
+				continue;
+
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
+									name, sizeof(name));
+				err = parse_events(evlist, name, 0);
+				if (err)
+					ret = err;
+			}
+		}
+	}
+
+	idx = 0;
+	evsel = perf_evlist__first(evlist);
+
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			/* skip invalid cache type */
+			if (!perf_evsel__is_cache_op_valid(type, op))
+				continue;
+
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
+									name, sizeof(name));
+				if (evsel->idx != idx)
+					continue;
+
+				++idx;
+
+				if (strcmp(perf_evsel__name(evsel), name)) {
+					pr_debug("%s != %s\n", perf_evsel__name(evsel), name);
+					ret = -1;
+				}
+
+				evsel = perf_evsel__next(evsel);
+			}
+		}
+	}
+
+	perf_evlist__delete(evlist);
+	return ret;
+}
+
+static int __perf_evsel__name_array_test(const char *names[], int nr_names)
+{
+	int i, err;
+	struct perf_evsel *evsel;
+        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+
+        if (evlist == NULL)
+                return -ENOMEM;
+
+	for (i = 0; i < nr_names; ++i) {
+		err = parse_events(evlist, names[i], 0);
+		if (err) {
+			pr_debug("failed to parse event '%s', err %d\n",
+				 names[i], err);
+			goto out_delete_evlist;
+		}
+	}
+
+	err = 0;
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (strcmp(perf_evsel__name(evsel), names[evsel->idx])) {
+			--err;
+			pr_debug("%s != %s\n", perf_evsel__name(evsel), names[evsel->idx]);
+		}
+	}
+
+out_delete_evlist:
+	perf_evlist__delete(evlist);
+	return err;
+}
+
+#define perf_evsel__name_array_test(names) \
+	__perf_evsel__name_array_test(names, ARRAY_SIZE(names))
+
+int test__perf_evsel__roundtrip_name_test(void)
+{
+	int err = 0, ret = 0;
+
+	err = perf_evsel__name_array_test(perf_evsel__hw_names);
+	if (err)
+		ret = err;
+
+	err = perf_evsel__name_array_test(perf_evsel__sw_names);
+	if (err)
+		ret = err;
+
+	err = perf_evsel__roundtrip_cache_name_test();
+	if (err)
+		ret = err;
+
+	return ret;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 03d428d..5897dd1 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -8,6 +8,7 @@ int test__open_syscall_event_on_all_cpus(void);
 int test__basic_mmap(void);
 int test__PERF_RECORD(void);
 int test__rdpmc(void);
+int test__perf_evsel__roundtrip_name_test(void);
 
 /* Util */
 int trace_event__id(const char *evname);
-- 
1.7.9.2.358.g22243

