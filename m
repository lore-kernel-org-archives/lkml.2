Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab2KJBiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:38:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab2KJBiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:38:50 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/12] perf tests: Final cleanup for builtin-test move
Date: Sat, 10 Nov 2012 01:46:51 +0100
Message-Id: <1352508412-16914-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
References: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Final function renames to match test__* style and
include cleanup.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.h               |  1 -
 tools/perf/tests/attr.c         |  3 ++-
 tools/perf/tests/builtin-test.c | 34 +++++++---------------------------
 tools/perf/tests/dso-data.c     |  3 ++-
 tools/perf/tests/parse-events.c |  3 ++-
 tools/perf/tests/tests.h        |  3 +++
 tools/perf/util/parse-events.h  |  1 -
 tools/perf/util/symbol.h        |  1 -
 8 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 054182e..0047264 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -178,7 +178,6 @@ extern bool test_attr__enabled;
 void test_attr__init(void);
 void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
 		     int fd, int group_fd, unsigned long flags);
-int  test_attr__run(void);
 
 static inline int
 sys_perf_event_open(struct perf_event_attr *attr,
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 6e2feee..25638a9 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -27,6 +27,7 @@
 #include "../perf.h"
 #include "util.h"
 #include "exec_cmd.h"
+#include "tests.h"
 
 #define ENV "PERF_TEST_ATTR"
 
@@ -151,7 +152,7 @@ static int run_dir(const char *d, const char *perf)
 	return system(cmd);
 }
 
-int test_attr__run(void)
+int test__attr(void)
 {
 	struct stat st;
 	char path_perf[PATH_MAX];
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index d3b95e0..186f675 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -4,31 +4,11 @@
  * Builtin regression testing command: ever growing number of sanity tests
  */
 #include "builtin.h"
-
-#include "util/cache.h"
-#include "util/color.h"
-#include "util/debug.h"
-#include "util/debugfs.h"
-#include "util/evlist.h"
-#include "util/machine.h"
-#include "util/parse-options.h"
-#include "util/parse-events.h"
-#include "util/symbol.h"
-#include "util/thread_map.h"
-#include "util/pmu.h"
-#include "event-parse.h"
-#include "../../include/linux/hw_breakpoint.h"
-
-#include <sys/mman.h>
-
-#include "util/cpumap.h"
-#include "util/evsel.h"
-#include <sys/types.h>
-
 #include "tests.h"
-
-#include <sched.h>
-
+#include "debug.h"
+#include "color.h"
+#include "parse-options.h"
+#include "symbol.h"
 
 static struct test {
 	const char *desc;
@@ -52,7 +32,7 @@ static struct test {
 	},
 	{
 		.desc = "parse events tests",
-		.func = parse_events__test,
+		.func = test__parse_events,
 	},
 #if defined(__x86_64__) || defined(__i386__)
 	{
@@ -70,7 +50,7 @@ static struct test {
 	},
 	{
 		.desc = "Test dso data interface",
-		.func = dso__test_data,
+		.func = test__dso_data,
 	},
 	{
 		.desc = "roundtrip evsel->name check",
@@ -86,7 +66,7 @@ static struct test {
 	},
 	{
 		.desc = "struct perf_event_attr setup",
-		.func = test_attr__run,
+		.func = test__attr,
 	},
 	{
 		.func = NULL,
diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index 0cd42fc..b5198f5 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -8,6 +8,7 @@
 
 #include "machine.h"
 #include "symbol.h"
+#include "tests.h"
 
 #define TEST_ASSERT_VAL(text, cond) \
 do { \
@@ -95,7 +96,7 @@ struct test_data_offset offsets[] = {
 	},
 };
 
-int dso__test_data(void)
+int test__dso_data(void)
 {
 	struct machine machine;
 	struct dso *dso;
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index b49c2ee..f2a82d0 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -4,6 +4,7 @@
 #include "evlist.h"
 #include "sysfs.h"
 #include "../../../include/linux/hw_breakpoint.h"
+#include "tests.h"
 
 #define TEST_ASSERT_VAL(text, cond) \
 do { \
@@ -1086,7 +1087,7 @@ static int test_pmu_events(void)
 	return ret;
 }
 
-int parse_events__test(void)
+int test__parse_events(void)
 {
 	int ret1, ret2 = 0;
 
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 88a55df..fc121ed 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -12,6 +12,9 @@ int test__perf_evsel__roundtrip_name_test(void);
 int test__perf_evsel__tp_sched_test(void);
 int test__syscall_open_tp_fields(void);
 int test__pmu(void);
+int test__attr(void);
+int test__dso_data(void);
+int test__parse_events(void);
 
 /* Util */
 int trace_event__id(const char *evname);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ac9a6aa..f639937 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -99,7 +99,6 @@ void parse_events__set_leader(char *name, struct list_head *list);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(void *data, void *scanner, char const *msg);
-int parse_events__test(void);
 
 void print_events(const char *event_glob, bool name_only);
 void print_events_type(u8 type);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 04ccf29..de68f98 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -224,7 +224,6 @@ size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp);
 size_t symbol__fprintf(struct symbol *sym, FILE *fp);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
-int dso__test_data(void);
 int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 		  struct symsrc *runtime_ss, symbol_filter_t filter,
 		  int kmodule);
-- 
1.7.11.7

