Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab2KJArj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 19:47:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715Ab2KJArb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 19:47:31 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/12] perf tests: Move pmu tests into separate object
Date: Sat, 10 Nov 2012 01:46:50 +0100
Message-Id: <1352508412-16914-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
References: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating pmu's object tests into pmu object under
tests directory.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |   1 +
 tools/perf/tests/builtin-test.c |   7 +-
 tools/perf/tests/pmu.c          | 178 ++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   1 +
 tools/perf/util/pmu.c           | 185 ++--------------------------------------
 tools/perf/util/pmu.h           |   4 +
 6 files changed, 191 insertions(+), 185 deletions(-)
 create mode 100644 tools/perf/tests/pmu.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1e50559..9af012f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -440,6 +440,7 @@ LIB_OBJS += $(OUTPUT)tests/perf-record.o
 LIB_OBJS += $(OUTPUT)tests/rdpmc.o
 LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
 LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
+LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/util.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index bab8490..d3b95e0 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -30,11 +30,6 @@
 #include <sched.h>
 
 
-static int test__perf_pmu(void)
-{
-	return perf_pmu__test();
-}
-
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -71,7 +66,7 @@ static struct test {
 	},
 	{
 		.desc = "Test perf pmu format parsing",
-		.func = test__perf_pmu,
+		.func = test__pmu,
 	},
 	{
 		.desc = "Test dso data interface",
diff --git a/tools/perf/tests/pmu.c b/tools/perf/tests/pmu.c
new file mode 100644
index 0000000..a5f3798
--- /dev/null
+++ b/tools/perf/tests/pmu.c
@@ -0,0 +1,178 @@
+#include "parse-events.h"
+#include "pmu.h"
+#include "util.h"
+#include "tests.h"
+
+/* Simulated format definitions. */
+static struct test_format {
+	const char *name;
+	const char *value;
+} test_formats[] = {
+	{ "krava01", "config:0-1,62-63\n", },
+	{ "krava02", "config:10-17\n", },
+	{ "krava03", "config:5\n", },
+	{ "krava11", "config1:0,2,4,6,8,20-28\n", },
+	{ "krava12", "config1:63\n", },
+	{ "krava13", "config1:45-47\n", },
+	{ "krava21", "config2:0-3,10-13,20-23,30-33,40-43,50-53,60-63\n", },
+	{ "krava22", "config2:8,18,48,58\n", },
+	{ "krava23", "config2:28-29,38\n", },
+};
+
+#define TEST_FORMATS_CNT (sizeof(test_formats) / sizeof(struct test_format))
+
+/* Simulated users input. */
+static struct parse_events__term test_terms[] = {
+	{
+		.config    = (char *) "krava01",
+		.val.num   = 15,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
+	},
+	{
+		.config    = (char *) "krava02",
+		.val.num   = 170,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
+	},
+	{
+		.config    = (char *) "krava03",
+		.val.num   = 1,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
+	},
+	{
+		.config    = (char *) "krava11",
+		.val.num   = 27,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
+	},
+	{
+		.config    = (char *) "krava12",
+		.val.num   = 1,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
+	},
+	{
+		.config    = (char *) "krava13",
+		.val.num   = 2,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
+	},
+	{
+		.config    = (char *) "krava21",
+		.val.num   = 119,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
+	},
+	{
+		.config    = (char *) "krava22",
+		.val.num   = 11,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
+	},
+	{
+		.config    = (char *) "krava23",
+		.val.num   = 2,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
+	},
+};
+#define TERMS_CNT (sizeof(test_terms) / sizeof(struct parse_events__term))
+
+/*
+ * Prepare format directory data, exported by kernel
+ * at /sys/bus/event_source/devices/<dev>/format.
+ */
+static char *test_format_dir_get(void)
+{
+	static char dir[PATH_MAX];
+	unsigned int i;
+
+	snprintf(dir, PATH_MAX, "/tmp/perf-pmu-test-format-XXXXXX");
+	if (!mkdtemp(dir))
+		return NULL;
+
+	for (i = 0; i < TEST_FORMATS_CNT; i++) {
+		static char name[PATH_MAX];
+		struct test_format *format = &test_formats[i];
+		FILE *file;
+
+		snprintf(name, PATH_MAX, "%s/%s", dir, format->name);
+
+		file = fopen(name, "w");
+		if (!file)
+			return NULL;
+
+		if (1 != fwrite(format->value, strlen(format->value), 1, file))
+			break;
+
+		fclose(file);
+	}
+
+	return dir;
+}
+
+/* Cleanup format directory. */
+static int test_format_dir_put(char *dir)
+{
+	char buf[PATH_MAX];
+	snprintf(buf, PATH_MAX, "rm -f %s/*\n", dir);
+	if (system(buf))
+		return -1;
+
+	snprintf(buf, PATH_MAX, "rmdir %s\n", dir);
+	return system(buf);
+}
+
+static struct list_head *test_terms_list(void)
+{
+	static LIST_HEAD(terms);
+	unsigned int i;
+
+	for (i = 0; i < TERMS_CNT; i++)
+		list_add_tail(&test_terms[i].list, &terms);
+
+	return &terms;
+}
+
+#undef TERMS_CNT
+
+int test__pmu(void)
+{
+	char *format = test_format_dir_get();
+	LIST_HEAD(formats);
+	struct list_head *terms = test_terms_list();
+	int ret;
+
+	if (!format)
+		return -EINVAL;
+
+	do {
+		struct perf_event_attr attr;
+
+		memset(&attr, 0, sizeof(attr));
+
+		ret = perf_pmu__format_parse(format, &formats);
+		if (ret)
+			break;
+
+		ret = perf_pmu__config_terms(&formats, &attr, terms);
+		if (ret)
+			break;
+
+		ret = -EINVAL;
+
+		if (attr.config  != 0xc00000000002a823)
+			break;
+		if (attr.config1 != 0x8000400000000145)
+			break;
+		if (attr.config2 != 0x0400000020041d07)
+			break;
+
+		ret = 0;
+	} while (0);
+
+	test_format_dir_put(format);
+	return ret;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index f70f998..88a55df 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -11,6 +11,7 @@ int test__rdpmc(void);
 int test__perf_evsel__roundtrip_name_test(void);
 int test__perf_evsel__tp_sched_test(void);
 int test__syscall_open_tp_fields(void);
+int test__pmu(void);
 
 /* Util */
 int trace_event__id(const char *evname);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 18e8480..9bdc60c 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -22,7 +22,7 @@ static LIST_HEAD(pmus);
  * Parse & process all the sysfs attributes located under
  * the directory specified in 'dir' parameter.
  */
-static int pmu_format_parse(char *dir, struct list_head *head)
+int perf_pmu__format_parse(char *dir, struct list_head *head)
 {
 	struct dirent *evt_ent;
 	DIR *format_dir;
@@ -77,7 +77,7 @@ static int pmu_format(char *name, struct list_head *format)
 	if (stat(path, &st) < 0)
 		return 0;	/* no error if format does not exist */
 
-	if (pmu_format_parse(path, format))
+	if (perf_pmu__format_parse(path, format))
 		return -1;
 
 	return 0;
@@ -446,8 +446,9 @@ static int pmu_config_term(struct list_head *formats,
 	return 0;
 }
 
-static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
-		      struct list_head *head_terms)
+int perf_pmu__config_terms(struct list_head *formats,
+			   struct perf_event_attr *attr,
+			   struct list_head *head_terms)
 {
 	struct parse_events__term *term;
 
@@ -467,7 +468,7 @@ int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms)
 {
 	attr->type = pmu->type;
-	return pmu_config(&pmu->format, attr, head_terms);
+	return perf_pmu__config_terms(&pmu->format, attr, head_terms);
 }
 
 static struct perf_pmu__alias *pmu_find_alias(struct perf_pmu *pmu,
@@ -551,177 +552,3 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to)
 	for (b = from; b <= to; b++)
 		set_bit(b, bits);
 }
-
-/* Simulated format definitions. */
-static struct test_format {
-	const char *name;
-	const char *value;
-} test_formats[] = {
-	{ "krava01", "config:0-1,62-63\n", },
-	{ "krava02", "config:10-17\n", },
-	{ "krava03", "config:5\n", },
-	{ "krava11", "config1:0,2,4,6,8,20-28\n", },
-	{ "krava12", "config1:63\n", },
-	{ "krava13", "config1:45-47\n", },
-	{ "krava21", "config2:0-3,10-13,20-23,30-33,40-43,50-53,60-63\n", },
-	{ "krava22", "config2:8,18,48,58\n", },
-	{ "krava23", "config2:28-29,38\n", },
-};
-
-#define TEST_FORMATS_CNT (sizeof(test_formats) / sizeof(struct test_format))
-
-/* Simulated users input. */
-static struct parse_events__term test_terms[] = {
-	{
-		.config    = (char *) "krava01",
-		.val.num   = 15,
-		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
-		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
-	},
-	{
-		.config    = (char *) "krava02",
-		.val.num   = 170,
-		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
-		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
-	},
-	{
-		.config    = (char *) "krava03",
-		.val.num   = 1,
-		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
-		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
-	},
-	{
-		.config    = (char *) "krava11",
-		.val.num   = 27,
-		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
-		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
-	},
-	{
-		.config    = (char *) "krava12",
-		.val.num   = 1,
-		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
-		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
-	},
-	{
-		.config    = (char *) "krava13",
-		.val.num   = 2,
-		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
-		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
-	},
-	{
-		.config    = (char *) "krava21",
-		.val.num   = 119,
-		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
-		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
-	},
-	{
-		.config    = (char *) "krava22",
-		.val.num   = 11,
-		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
-		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
-	},
-	{
-		.config    = (char *) "krava23",
-		.val.num   = 2,
-		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
-		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
-	},
-};
-#define TERMS_CNT (sizeof(test_terms) / sizeof(struct parse_events__term))
-
-/*
- * Prepare format directory data, exported by kernel
- * at /sys/bus/event_source/devices/<dev>/format.
- */
-static char *test_format_dir_get(void)
-{
-	static char dir[PATH_MAX];
-	unsigned int i;
-
-	snprintf(dir, PATH_MAX, "/tmp/perf-pmu-test-format-XXXXXX");
-	if (!mkdtemp(dir))
-		return NULL;
-
-	for (i = 0; i < TEST_FORMATS_CNT; i++) {
-		static char name[PATH_MAX];
-		struct test_format *format = &test_formats[i];
-		FILE *file;
-
-		snprintf(name, PATH_MAX, "%s/%s", dir, format->name);
-
-		file = fopen(name, "w");
-		if (!file)
-			return NULL;
-
-		if (1 != fwrite(format->value, strlen(format->value), 1, file))
-			break;
-
-		fclose(file);
-	}
-
-	return dir;
-}
-
-/* Cleanup format directory. */
-static int test_format_dir_put(char *dir)
-{
-	char buf[PATH_MAX];
-	snprintf(buf, PATH_MAX, "rm -f %s/*\n", dir);
-	if (system(buf))
-		return -1;
-
-	snprintf(buf, PATH_MAX, "rmdir %s\n", dir);
-	return system(buf);
-}
-
-static struct list_head *test_terms_list(void)
-{
-	static LIST_HEAD(terms);
-	unsigned int i;
-
-	for (i = 0; i < TERMS_CNT; i++)
-		list_add_tail(&test_terms[i].list, &terms);
-
-	return &terms;
-}
-
-#undef TERMS_CNT
-
-int perf_pmu__test(void)
-{
-	char *format = test_format_dir_get();
-	LIST_HEAD(formats);
-	struct list_head *terms = test_terms_list();
-	int ret;
-
-	if (!format)
-		return -EINVAL;
-
-	do {
-		struct perf_event_attr attr;
-
-		memset(&attr, 0, sizeof(attr));
-
-		ret = pmu_format_parse(format, &formats);
-		if (ret)
-			break;
-
-		ret = pmu_config(&formats, &attr, terms);
-		if (ret)
-			break;
-
-		ret = -EINVAL;
-
-		if (attr.config  != 0xc00000000002a823)
-			break;
-		if (attr.config1 != 0x8000400000000145)
-			break;
-		if (attr.config2 != 0x0400000020041d07)
-			break;
-
-		ret = 0;
-	} while (0);
-
-	test_format_dir_put(format);
-	return ret;
-}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 39f3aba..07d553f 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -37,6 +37,9 @@ struct perf_pmu {
 struct perf_pmu *perf_pmu__find(char *name);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms);
+int perf_pmu__config_terms(struct list_head *formats,
+			   struct perf_event_attr *attr,
+			   struct list_head *head_terms);
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms);
 struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
 				struct list_head *head_terms);
@@ -46,6 +49,7 @@ void perf_pmu_error(struct list_head *list, char *name, char const *msg);
 int perf_pmu__new_format(struct list_head *list, char *name,
 			 int config, unsigned long *bits);
 void perf_pmu__set_format(unsigned long *bits, long from, long to);
+int perf_pmu__format_parse(char *dir, struct list_head *head);
 
 struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
 
-- 
1.7.11.7

