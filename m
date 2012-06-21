Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332Ab2FUKZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:25:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308Ab2FUKZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:25:27 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@ghostprotocols.net, a.p.zijlstra@chello.nl, mingo@redhat.com,
        paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf test: Fix parse events test to follow proper raw event name
Date: Thu, 21 Jun 2012 12:25:16 +0200
Message-Id: <1340274316-5161-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following commit changed raw event names to carry event modificator.

  perf evsel: Reconstruct raw event with modifiers from perf_event_attr
  commit 6eef3d9c2bcf52b7a3c18e609f5838c007b989a4
  Author: Arnaldo Carvalho de Melo <acme@redhat.com>

The perf_evsel__name function now returns ':mod' suffix for raw
events, so we need to follow that in current tests.

All tests pass now for 'perf test parse' suite.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events-test.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 229af6d..a0f61a2 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -413,19 +413,20 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 
-	/* cpu/config=1,name=krava1/u */
+	/* cpu/config=1,name=krava/u */
 	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",  1 == evsel->attr.config);
 	TEST_ASSERT_VAL("wrong name", !strcmp(perf_evsel__name(evsel), "krava"));
 
-	/* cpu/config=2/" */
+	/* cpu/config=2/u" */
 	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong name", !strcmp(perf_evsel__name(evsel), "raw 0x2"));
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "raw 0x2:u"));
 
 	return 0;
 }
-- 
1.7.7.6

