Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab2KJArq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 19:47:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503Ab2KJArj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 19:47:39 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/12] perf tests: Move perf_evsel__tp_sched_test into separate object
Date: Sat, 10 Nov 2012 01:46:48 +0100
Message-Id: <1352508412-16914-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
References: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating perf_evsel__tp_sched_test test from the
builtin-test into evsel-tp-sched object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile               |  1 +
 tools/perf/tests/builtin-test.c   | 83 +-------------------------------------
 tools/perf/tests/evsel-tp-sched.c | 84 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h          |  1 +
 4 files changed, 87 insertions(+), 82 deletions(-)
 create mode 100644 tools/perf/tests/evsel-tp-sched.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ad6fcb5..e510b53 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -438,6 +438,7 @@ LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
 LIB_OBJS += $(OUTPUT)tests/perf-record.o
 LIB_OBJS += $(OUTPUT)tests/rdpmc.o
 LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
+LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/util.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 93f5e91..c66caa7 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -35,87 +35,6 @@ static int test__perf_pmu(void)
 	return perf_pmu__test();
 }
 
-static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
-				  int size, bool should_be_signed)
-{
-	struct format_field *field = perf_evsel__field(evsel, name);
-	int is_signed;
-	int ret = 0;
-
-	if (field == NULL) {
-		pr_debug("%s: \"%s\" field not found!\n", evsel->name, name);
-		return -1;
-	}
-
-	is_signed = !!(field->flags | FIELD_IS_SIGNED);
-	if (should_be_signed && !is_signed) {
-		pr_debug("%s: \"%s\" signedness(%d) is wrong, should be %d\n",
-			 evsel->name, name, is_signed, should_be_signed);
-		ret = -1;
-	}
-
-	if (field->size != size) {
-		pr_debug("%s: \"%s\" size (%d) should be %d!\n",
-			 evsel->name, name, field->size, size);
-		ret = -1;
-	}
-
-	return ret;
-}
-
-static int perf_evsel__tp_sched_test(void)
-{
-	struct perf_evsel *evsel = perf_evsel__newtp("sched", "sched_switch", 0);
-	int ret = 0;
-
-	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
-		return -1;
-	}
-
-	if (perf_evsel__test_field(evsel, "prev_comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_prio", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_state", 8, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_prio", 4, true))
-		ret = -1;
-
-	perf_evsel__delete(evsel);
-
-	evsel = perf_evsel__newtp("sched", "sched_wakeup", 0);
-
-	if (perf_evsel__test_field(evsel, "comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prio", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "success", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
-		ret = -1;
-
-	return ret;
-}
-
 static int test__syscall_open_tp_fields(void)
 {
 	struct perf_record_opts opts = {
@@ -276,7 +195,7 @@ static struct test {
 	},
 	{
 		.desc = "Check parsing of sched tracepoints fields",
-		.func = perf_evsel__tp_sched_test,
+		.func = test__perf_evsel__tp_sched_test,
 	},
 	{
 		.desc = "Generate and check syscalls:sys_enter_open event fields",
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
new file mode 100644
index 0000000..a5d2fcc
--- /dev/null
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -0,0 +1,84 @@
+#include "evsel.h"
+#include "tests.h"
+#include "event-parse.h"
+
+static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
+				  int size, bool should_be_signed)
+{
+	struct format_field *field = perf_evsel__field(evsel, name);
+	int is_signed;
+	int ret = 0;
+
+	if (field == NULL) {
+		pr_debug("%s: \"%s\" field not found!\n", evsel->name, name);
+		return -1;
+	}
+
+	is_signed = !!(field->flags | FIELD_IS_SIGNED);
+	if (should_be_signed && !is_signed) {
+		pr_debug("%s: \"%s\" signedness(%d) is wrong, should be %d\n",
+			 evsel->name, name, is_signed, should_be_signed);
+		ret = -1;
+	}
+
+	if (field->size != size) {
+		pr_debug("%s: \"%s\" size (%d) should be %d!\n",
+			 evsel->name, name, field->size, size);
+		ret = -1;
+	}
+
+	return ret;
+}
+
+int test__perf_evsel__tp_sched_test(void)
+{
+	struct perf_evsel *evsel = perf_evsel__newtp("sched", "sched_switch", 0);
+	int ret = 0;
+
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new\n");
+		return -1;
+	}
+
+	if (perf_evsel__test_field(evsel, "prev_comm", 16, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prev_pid", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prev_prio", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prev_state", 8, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "next_comm", 16, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "next_pid", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "next_prio", 4, true))
+		ret = -1;
+
+	perf_evsel__delete(evsel);
+
+	evsel = perf_evsel__newtp("sched", "sched_wakeup", 0);
+
+	if (perf_evsel__test_field(evsel, "comm", 16, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "pid", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prio", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "success", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
+		ret = -1;
+
+	return ret;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 5897dd1..1ef265d 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -9,6 +9,7 @@ int test__basic_mmap(void);
 int test__PERF_RECORD(void);
 int test__rdpmc(void);
 int test__perf_evsel__roundtrip_name_test(void);
+int test__perf_evsel__tp_sched_test(void);
 
 /* Util */
 int trace_event__id(const char *evname);
-- 
1.7.11.7

