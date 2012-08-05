Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2HEQnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:43:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56702 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2HEQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:43:41 -0400
Date: Sun, 5 Aug 2012 09:43:16 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-30f31c0a492d0c1cd64af631476697f38d6a79d4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1343825338-10618-1-git-send-email-jolsa@redhat.com>
References: <1343825338-10618-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf test: Fix parse events automated tests
Git-Commit-ID: 30f31c0a492d0c1cd64af631476697f38d6a79d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 09:43:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30f31c0a492d0c1cd64af631476697f38d6a79d4
Gitweb:     http://git.kernel.org/tip/30f31c0a492d0c1cd64af631476697f38d6a79d4
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 1 Aug 2012 14:48:58 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Aug 2012 18:42:10 -0300

perf test: Fix parse events automated tests

Parse events tests got broken after following commit:

  perf tools: Fix trace events storms due to weight demux
  commit 0983cc0dbca45250cbb5984bec7c303ac265b8e5
  Author: Frederic Weisbecker <fweisbec@gmail.com>

that added PERF_SAMPLE_PERIOD sample type for tracepoints.

Updating related tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1343825338-10618-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
