Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab2LQGjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:39:14 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45648 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab2LQGjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:39:10 -0500
X-AuditID: 9c930179-b7becae000000e51-67-50cebe0c7ee4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 02/14] perf test: Add group test conditions
Date: Mon, 17 Dec 2012 15:38:53 +0900
Message-Id: <1355726345-29553-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As some new fields for handling groups added, check them to be sure to
have valid values in test__group* cases.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/tests/parse-events.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 294ffddfbf42..9cd6f3597829 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -22,6 +22,7 @@ static int test__checkevent_tracepoint(struct perf_evlist *evlist)
 	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 0 == evlist->nr_groups);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong sample_type",
 		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
@@ -34,6 +35,7 @@ static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 
 	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
+	TEST_ASSERT_VAL("wrong number of groups", 0 == evlist->nr_groups);
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		TEST_ASSERT_VAL("wrong type",
@@ -509,6 +511,7 @@ static int test__group1(struct perf_evlist *evlist)
 	struct perf_evsel *evsel, *leader;
 
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 1 == evlist->nr_groups);
 
 	/* instructions:k */
 	evsel = leader = perf_evlist__first(evlist);
@@ -522,6 +525,8 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* cycles:upp */
 	evsel = perf_evsel__next(evsel);
@@ -536,6 +541,7 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	return 0;
 }
@@ -545,6 +551,7 @@ static int test__group2(struct perf_evlist *evlist)
 	struct perf_evsel *evsel, *leader;
 
 	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 1 == evlist->nr_groups);
 
 	/* faults + :ku modifier */
 	evsel = leader = perf_evlist__first(evlist);
@@ -558,6 +565,8 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* cache-references + :u modifier */
 	evsel = perf_evsel__next(evsel);
@@ -571,6 +580,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	/* cycles:k */
 	evsel = perf_evsel__next(evsel);
@@ -593,6 +603,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	struct perf_evsel *evsel, *leader;
 
 	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 2 == evlist->nr_groups);
 
 	/* group1 syscalls:sys_enter_open:H */
 	evsel = leader = perf_evlist__first(evlist);
@@ -609,6 +620,8 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong group name",
 		!strcmp(leader->group_name, "group1"));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* group1 cycles:kppp */
 	evsel = perf_evsel__next(evsel);
@@ -624,6 +637,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 3);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	/* group2 cycles + G modifier */
 	evsel = leader = perf_evsel__next(evsel);
@@ -639,6 +653,8 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong group name",
 		!strcmp(leader->group_name, "group2"));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* group2 1:3 + G modifier */
 	evsel = perf_evsel__next(evsel);
@@ -651,6 +667,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	/* instructions:u */
 	evsel = perf_evsel__next(evsel);
@@ -673,6 +690,7 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	struct perf_evsel *evsel, *leader;
 
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 1 == evlist->nr_groups);
 
 	/* cycles:u + p */
 	evsel = leader = perf_evlist__first(evlist);
@@ -688,6 +706,8 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* instructions:kp + p */
 	evsel = perf_evsel__next(evsel);
@@ -702,6 +722,7 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	return 0;
 }
@@ -711,6 +732,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	struct perf_evsel *evsel, *leader;
 
 	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 2 == evlist->nr_groups);
 
 	/* cycles + G */
 	evsel = leader = perf_evlist__first(evlist);
@@ -725,6 +747,8 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* instructions + G */
 	evsel = perf_evsel__next(evsel);
@@ -738,6 +762,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	/* cycles:G */
 	evsel = leader = perf_evsel__next(evsel);
@@ -752,6 +777,8 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* instructions:G */
 	evsel = perf_evsel__next(evsel);
@@ -765,6 +792,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	/* cycles */
 	evsel = perf_evsel__next(evsel);
-- 
1.7.11.7

