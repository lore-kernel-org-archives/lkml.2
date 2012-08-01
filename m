Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab2HAMtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:49:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab2HAMtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:49:05 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@ghostprotocols.net, a.p.zijlstra@chello.nl, mingo@redhat.com,
        paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf, test: Fix parse events automated tests
Date: Wed,  1 Aug 2012 14:48:58 +0200
Message-Id: <1343825338-10618-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse events tests got broken after following commit:

  perf tools: Fix trace events storms due to weight demux
  commit 0983cc0dbca45250cbb5984bec7c303ac265b8e5
  Author: Frederic Weisbecker <fweisbec@gmail.com>

that added PERF_SAMPLE_PERIOD sample type for tracepoints.

Updating related tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/parse-events-test.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 1b997d2..127d648 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -13,6 +13,9 @@ do { \
 	} \
 } while (0)
 
+#define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
+			     PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
+
 static int test__checkevent_tracepoint(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = list_entry(evlist->entries.next,
@@ -21,8 +24,7 @@ static int test__checkevent_tracepoint(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong sample_type",
-		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
-		evsel->attr.sample_type);
+		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
 	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
 	return 0;
 }
@@ -37,8 +39,7 @@ static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
 		TEST_ASSERT_VAL("wrong type",
 			PERF_TYPE_TRACEPOINT == evsel->attr.type);
 		TEST_ASSERT_VAL("wrong sample_type",
-			(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU)
-			== evsel->attr.sample_type);
+			PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
 		TEST_ASSERT_VAL("wrong sample_period",
 			1 == evsel->attr.sample_period);
 	}
@@ -428,8 +429,7 @@ static int test__checkevent_list(struct perf_evlist *evlist)
 	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong sample_type",
-		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
-		evsel->attr.sample_type);
+		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
 	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-- 
1.7.7.6

