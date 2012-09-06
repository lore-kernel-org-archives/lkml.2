Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab2IFTbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:31:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40927 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2IFTbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:31:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/8] perf test: Add round trip test for sw and hw event names
Date: Thu,  6 Sep 2012 16:31:17 -0300
Message-Id: <1346959881-22427-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346959881-22427-1-git-send-email-acme@infradead.org>
References: <1346959881-22427-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It basically traverses the hardware and software event name arrays
creating an evlist with all events, then it uses perf_evsel__name to
check that the name is the expected one.

With it I noticed this problem:

[root@sandy ~]# perf test 10
10: roundtrip evsel->name check:invalid or unsupported event: 'CPU-migrations'
Run 'perf list' for a list of valid events
 FAILED!

Changed it to "cpu-migrations" in the software event arrays and it
worked.

This is to catch problems like the one reported by Joel Uckelman in
http://permalink.gmane.org/gmane.linux.kernel.perf.user/1016

Hardware cache events will be checked in the following patch.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-5jskfkuqvf2fi257zmni0ftz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |   53 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.c   |    6 ++---
 tools/perf/util/evsel.h   |    6 +++--
 3 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 381d5ab..ba94fbe 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1092,6 +1092,55 @@ static int test__perf_pmu(void)
 	return perf_pmu__test();
 }
 
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
+static int perf_evsel__roundtrip_name_test(void)
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
+	return ret;
+}
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -1135,6 +1184,10 @@ static struct test {
 		.func = dso__test_data,
 	},
 	{
+		.desc = "roundtrip evsel->name check",
+		.func = perf_evsel__roundtrip_name_test,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 7ff3c8f..06f7644 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -68,7 +68,7 @@ struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 	return evsel;
 }
 
-static const char *perf_evsel__hw_names[PERF_COUNT_HW_MAX] = {
+const char *perf_evsel__hw_names[PERF_COUNT_HW_MAX] = {
 	"cycles",
 	"instructions",
 	"cache-references",
@@ -131,12 +131,12 @@ static int perf_evsel__hw_name(struct perf_evsel *evsel, char *bf, size_t size)
 	return r + perf_evsel__add_modifiers(evsel, bf + r, size - r);
 }
 
-static const char *perf_evsel__sw_names[PERF_COUNT_SW_MAX] = {
+const char *perf_evsel__sw_names[PERF_COUNT_SW_MAX] = {
 	"cpu-clock",
 	"task-clock",
 	"page-faults",
 	"context-switches",
-	"CPU-migrations",
+	"cpu-migrations",
 	"minor-faults",
 	"major-faults",
 	"alignment-faults",
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 94f6ba1..a3f562c 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -97,8 +97,10 @@ extern const char *perf_evsel__hw_cache[PERF_COUNT_HW_CACHE_MAX]
 				       [PERF_EVSEL__MAX_ALIASES];
 extern const char *perf_evsel__hw_cache_op[PERF_COUNT_HW_CACHE_OP_MAX]
 					  [PERF_EVSEL__MAX_ALIASES];
-const char *perf_evsel__hw_cache_result[PERF_COUNT_HW_CACHE_RESULT_MAX]
-				       [PERF_EVSEL__MAX_ALIASES];
+extern const char *perf_evsel__hw_cache_result[PERF_COUNT_HW_CACHE_RESULT_MAX]
+					      [PERF_EVSEL__MAX_ALIASES];
+extern const char *perf_evsel__hw_names[PERF_COUNT_HW_MAX];
+extern const char *perf_evsel__sw_names[PERF_COUNT_SW_MAX];
 int __perf_evsel__hw_cache_type_op_res_name(u8 type, u8 op, u8 result,
 					    char *bf, size_t size);
 const char *perf_evsel__name(struct perf_evsel *evsel);
-- 
1.7.9.2.358.g22243

