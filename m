Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2HWPKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:10:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49956 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab2HWPKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:10:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/12] perf test: Do not abort tests on error
Date: Thu, 23 Aug 2012 12:09:46 -0300
Message-Id: <1345734596-7601-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345734596-7601-1-git-send-email-acme@infradead.org>
References: <1345734596-7601-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Run through all tests regardless of failures. On errors, return the
first error code detected.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345572195-23857-2-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events-test.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index bf055ce..392308c 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -948,19 +948,19 @@ static int test_event(struct test__event_st *e)
 
 static int test_events(struct test__event_st *events, unsigned cnt)
 {
-	int ret = 0;
+	int ret1, ret2 = 0;
 	unsigned i;
 
 	for (i = 0; i < cnt; i++) {
 		struct test__event_st *e = &events[i];
 
 		pr_debug("running test %d '%s'\n", i, e->name);
-		ret = test_event(e);
-		if (ret)
-			break;
+		ret1 = test_event(e);
+		if (ret1)
+			ret2 = ret1;
 	}
 
-	return ret;
+	return ret2;
 }
 
 static int test_term(struct test__term *t)
@@ -1021,13 +1021,13 @@ static int test_pmu(void)
 
 int parse_events__test(void)
 {
-	int ret;
+	int ret1, ret2 = 0;
 
 #define TEST_EVENTS(tests)				\
 do {							\
-	ret = test_events(tests, ARRAY_SIZE(tests));	\
-	if (ret)					\
-		return ret;				\
+	ret1 = test_events(tests, ARRAY_SIZE(tests));	\
+	if (!ret2)					\
+		ret2 = ret1;				\
 } while (0)
 
 	TEST_EVENTS(test__events);
@@ -1035,5 +1035,9 @@ do {							\
 	if (test_pmu())
 		TEST_EVENTS(test__events_pmu);
 
-	return test_terms(test__terms, ARRAY_SIZE(test__terms));
+	ret1 = test_terms(test__terms, ARRAY_SIZE(test__terms));
+	if (!ret2)
+		ret2 = ret1;
+
+	return ret2;
 }
-- 
1.7.1

