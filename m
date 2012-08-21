Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab2HUSDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:03:51 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:18400
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758277Ab2HUSDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:03:43 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M94A60-01-5ZH-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/2] perf test: Do not abort tests on error
Date: Tue, 21 Aug 2012 20:03:15 +0200
Message-ID: <1345572195-23857-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345572195-23857-1-git-send-email-robert.richter@amd.com>
References: <20120820174247.GD1176@krava.brq.redhat.com>
 <1345572195-23857-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Run through all tests regardless of failures. On errors, return the
first error code detected.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/parse-events-test.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 74be1bf..bc8b651 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -949,19 +949,19 @@ static int test_event(struct test__event_st *e)
 
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
@@ -1022,13 +1022,13 @@ static int test_pmu(void)
 
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
@@ -1036,5 +1036,9 @@ do {							\
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
1.7.8.6


