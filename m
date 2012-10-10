Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2JJMyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:54:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab2JJMyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:54:37 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 8/8] perf test: Add automated tests for pmu sysfs translated events
Date: Wed, 10 Oct 2012 14:53:18 +0200
Message-Id: <1349873598-12583-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated tests for all events found under PMU/events
directory. Tested events are in 'cpu/event=xxx/u' format,
where 'xxx' is substituted by every event found.

The 'event=xxx' term is translated to the cpu specific term.
We only check that the event is created (not the real config
numbers) and that modifier is properly set.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/parse-events-test.c | 68 +++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index d7244e5..c9354b6 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -443,6 +443,23 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
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
@@ -1020,6 +1037,51 @@ static int test_pmu(void)
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
 	int ret1, ret2 = 0;
@@ -1036,6 +1098,12 @@ do {							\
 	if (test_pmu())
 		TEST_EVENTS(test__events_pmu);
 
+	if (test_pmu()) {
+		int ret = test_pmu_events();
+		if (ret)
+			return ret;
+	}
+
 	ret1 = test_terms(test__terms, ARRAY_SIZE(test__terms));
 	if (!ret2)
 		ret2 = ret1;
-- 
1.7.11.4

