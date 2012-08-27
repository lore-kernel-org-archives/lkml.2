Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2H0Qxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:53:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34047 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2H0Qxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:53:40 -0400
Date: Mon, 27 Aug 2012 09:53:22 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-9bfbbc6d1e6b4d055860231e232b807911bf8325@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, jolsa@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1345572195-23857-2-git-send-email-robert.richter@amd.com>
References: <1345572195-23857-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Do not abort tests on error
Git-Commit-ID: 9bfbbc6d1e6b4d055860231e232b807911bf8325
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 09:53:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9bfbbc6d1e6b4d055860231e232b807911bf8325
Gitweb:     http://git.kernel.org/tip/9bfbbc6d1e6b4d055860231e232b807911bf8325
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 21 Aug 2012 20:03:15 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Aug 2012 13:34:23 -0300

perf test: Do not abort tests on error

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
