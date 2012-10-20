Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2JTOeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:34:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab2JTOd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:33:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 09/11] perf test: Add parse events tests for leader sampling
Date: Sat, 20 Oct 2012 16:33:17 +0200
Message-Id: <1350743599-4805-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding 2 more tests to the automated parse events suite
for following event config:

  '{cycles,cache-misses,branch-misses}:S'
  '{instructions,branch-misses}:Su'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/parse-events-test.c | 117 ++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index d7244e5..903ba77 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -504,6 +504,7 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* cycles:upp */
 	evsel = perf_evsel__next(evsel);
@@ -517,6 +518,7 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	return 0;
 }
@@ -539,6 +541,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* cache-references + :u modifier */
 	evsel = perf_evsel__next(evsel);
@@ -552,6 +555,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* cycles:k */
 	evsel = perf_evsel__next(evsel);
@@ -565,6 +569,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	return 0;
 }
@@ -590,6 +595,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
 	TEST_ASSERT_VAL("wrong group name",
 		!strcmp(leader->group_name, "group1"));
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* group1 cycles:kppp */
 	evsel = perf_evsel__next(evsel);
@@ -604,6 +610,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 3);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* group2 cycles + G modifier */
 	evsel = leader = perf_evsel__next(evsel);
@@ -619,6 +626,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
 	TEST_ASSERT_VAL("wrong group name",
 		!strcmp(leader->group_name, "group2"));
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* group2 1:3 + G modifier */
 	evsel = perf_evsel__next(evsel);
@@ -631,6 +639,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* instructions:u */
 	evsel = perf_evsel__next(evsel);
@@ -644,6 +653,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	return 0;
 }
@@ -667,6 +677,7 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* instructions:kp + p */
 	evsel = perf_evsel__next(evsel);
@@ -680,6 +691,7 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	return 0;
 }
@@ -703,6 +715,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* instructions + G */
 	evsel = perf_evsel__next(evsel);
@@ -716,6 +729,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* cycles:G */
 	evsel = leader = perf_evsel__next(evsel);
@@ -730,6 +744,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* instructions:G */
 	evsel = perf_evsel__next(evsel);
@@ -743,6 +758,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* cycles */
 	evsel = perf_evsel__next(evsel);
@@ -756,6 +772,99 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
+
+	return 0;
+}
+
+static int test__leader_sample1(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
+
+	/* cycles - sampling group leader */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong sample_read", evsel->sample_read);
+
+	/* cache-misses - not sampling */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CACHE_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", evsel->sample_read);
+
+	/* branch-misses - not sampling */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_BRANCH_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", evsel->sample_read);
+
+	return 0;
+}
+
+static int test__leader_sample2(struct perf_evlist *evlist __maybe_unused)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+
+	/* cycles - sampling group leader */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong sample_read", evsel->sample_read);
+
+	/* branch-misses - not sampling */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_BRANCH_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", evsel->sample_read);
 
 	return 0;
 }
@@ -899,6 +1008,14 @@ static struct test__event_st test__events[] = {
 		.name  = "{cycles,instructions}:G,{cycles:G,instructions:G},cycles",
 		.check = test__group5,
 	},
+	[33] = {
+		.name  = "{cycles,cache-misses,branch-misses}:S",
+		.check = test__leader_sample1,
+	},
+	[34] = {
+		.name  = "{instructions,branch-misses}:Su",
+		.check = test__leader_sample2,
+	},
 };
 
 static struct test__event_st test__events_pmu[] = {
-- 
1.7.11.4

