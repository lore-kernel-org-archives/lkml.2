Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab2GIUia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:38:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab2GIUi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:38:28 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/6] perf, test: Add automated tests for pmu sysfs translated events
Date: Mon,  9 Jul 2012 22:37:50 +0200
Message-Id: <1341866270-4915-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341866270-4915-1-git-send-email-jolsa@redhat.com>
References: <1341866270-4915-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated tests for all events found under PMU/events
directory. Tested events are in 'cpu/event=xxx/u' format,
where 'xxx' is substibuted by every event found.

The 'event=xxx' term is translated to the cpu specific term.
We only check that the event is created (not the real config
numbers) and that modifier is properly set.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events-test.c |   75 ++++++++++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 1b997d2..a2aac11 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -13,6 +13,8 @@ do { \
 	} \
 } while (0)
 
+static int test_cnt;
+
 static int test__checkevent_tracepoint(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = list_entry(evlist->entries.next,
@@ -470,6 +472,23 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_pmu_events(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong exclude_user",
+			!evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel",
+			evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return 0;
+}
+
 static int test__checkterms_simple(struct list_head *terms)
 {
 	struct parse_events__term *term;
@@ -666,6 +685,8 @@ static int test_event(struct test__event_st *e)
 	struct perf_evlist *evlist;
 	int ret;
 
+	pr_debug("running test %4d '%s'\n", test_cnt++, e->name);
+
 	evlist = perf_evlist__new(NULL, NULL);
 	if (evlist == NULL)
 		return -ENOMEM;
@@ -691,7 +712,6 @@ static int test_events(struct test__event_st *events, unsigned cnt)
 	for (i = 0; i < cnt; i++) {
 		struct test__event_st *e = &events[i];
 
-		pr_debug("running test %d '%s'\n", i, e->name);
 		ret = test_event(e);
 		if (ret)
 			break;
@@ -732,7 +752,7 @@ static int test_terms(struct test__term *terms, unsigned cnt)
 	for (i = 0; i < cnt; i++) {
 		struct test__term *t = &terms[i];
 
-		pr_debug("running test %d '%s'\n", i, t->str);
+		pr_debug("running test %4d '%s'\n", test_cnt, t->str);
 		ret = test_term(t);
 		if (ret)
 			break;
@@ -756,6 +776,51 @@ static int test_pmu(void)
 	return !ret;
 }
 
+static int test_pmu_events(void)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	struct dirent *ent;
+	DIR *dir;
+	int ret;
+
+	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/events/",
+		 sysfs_find_mountpoint());
+
+	ret = stat(path, &st);
+	if (ret) {
+		pr_debug("ommiting PMU cpu events tests\n");
+		return 0;
+	}
+
+	dir = opendir(path);
+	if (!dir) {
+		pr_debug("can't open pmu event dir");
+		return -1;
+	}
+
+	while (!ret && (ent = readdir(dir))) {
+#define MAX_NAME 100
+		struct test__event_st e;
+		char name[MAX_NAME];
+
+		if (!strcmp(ent->d_name, ".") ||
+		    !strcmp(ent->d_name, ".."))
+			continue;
+
+		snprintf(name, MAX_NAME, "cpu/event=%s/u", ent->d_name);
+
+		e.name  = name;
+		e.check = test__checkevent_pmu_events;
+
+		ret = test_event(&e);
+#undef MAX_NAME
+	}
+
+	closedir(dir);
+	return ret;
+}
+
 int parse_events__test(void)
 {
 	int ret;
@@ -772,5 +837,11 @@ do {							\
 	if (test_pmu())
 		TEST_EVENTS(test__events_pmu);
 
+	if (test_pmu()) {
+		ret = test_pmu_events();
+		if (ret)
+			return ret;
+	}
+
 	return test_terms(test__terms, ARRAY_SIZE(test__terms));
 }
-- 
1.7.10.4

