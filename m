Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2EaFqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:46:08 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51948 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2EaFqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:46:06 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-71-4fc7059afc1d
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Sunjin Yang <fan4326@gmail.com>
Subject: [PATCH 1/2] perf callchain: Make callchain cursors TLS
Date: Thu, 31 May 2012 14:43:26 +0900
Message-Id: <1338443007-24857-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf top -G has a race on callchain cursor between main
thread and display thread. Since the callchain cursors
are used locally make them thread-local data would solve
the problem.

Reported-by: Sunjin Yang <fan4326@gmail.com>
Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/util/callchain.c |    2 ++
 tools/perf/util/callchain.h |    2 ++
 tools/perf/util/hist.c      |    7 ++++---
 tools/perf/util/hist.h      |    2 --
 tools/perf/util/session.c   |   14 +++++++-------
 7 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d58e41445d0d..159ca6435788 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -152,7 +152,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 
 	if (symbol_conf.use_callchain) {
 		err = callchain_append(he->callchain,
-				       &evsel->hists.callchain_cursor,
+				       &callchain_cursor,
 				       sample->period);
 		if (err)
 			return err;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6031dce0429f..ea7b600dc652 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -787,7 +787,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		}
 
 		if (symbol_conf.use_callchain) {
-			err = callchain_append(he->callchain, &evsel->hists.callchain_cursor,
+			err = callchain_append(he->callchain, &callchain_cursor,
 					       sample->period);
 			if (err)
 				return;
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 9f7106a8d9a4..3a6bff47614f 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -18,6 +18,8 @@
 #include "util.h"
 #include "callchain.h"
 
+__thread struct callchain_cursor callchain_cursor;
+
 bool ip_callchain__valid(struct ip_callchain *chain,
 			 const union perf_event *event)
 {
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 7f9c0f1ae3a9..3bdb407f9cd9 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -76,6 +76,8 @@ struct callchain_cursor {
 	struct callchain_cursor_node	*curr;
 };
 
+extern __thread struct callchain_cursor callchain_cursor;
+
 static inline void callchain_init(struct callchain_root *root)
 {
 	INIT_LIST_HEAD(&root->node.siblings);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 1293b5ebea4d..514e2a4b367d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -378,7 +378,7 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */
 
-static bool hists__collapse_insert_entry(struct hists *hists,
+static bool hists__collapse_insert_entry(struct hists *hists __used,
 					 struct rb_root *root,
 					 struct hist_entry *he)
 {
@@ -397,8 +397,9 @@ static bool hists__collapse_insert_entry(struct hists *hists,
 			iter->period += he->period;
 			iter->nr_events += he->nr_events;
 			if (symbol_conf.use_callchain) {
-				callchain_cursor_reset(&hists->callchain_cursor);
-				callchain_merge(&hists->callchain_cursor, iter->callchain,
+				callchain_cursor_reset(&callchain_cursor);
+				callchain_merge(&callchain_cursor,
+						iter->callchain,
 						he->callchain);
 			}
 			hist_entry__free(he);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index cfc64e293f90..34bb556d6219 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -67,8 +67,6 @@ struct hists {
 	struct events_stats	stats;
 	u64			event_stream;
 	u16			col_len[HISTC_NR_COLS];
-	/* Best would be to reuse the session callchain cursor */
-	struct callchain_cursor	callchain_cursor;
 };
 
 struct hist_entry *__hists__add_entry(struct hists *self,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 93d355d27109..4eed171d275d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -288,7 +288,8 @@ struct branch_info *machine__resolve_bstack(struct machine *self,
 	return bi;
 }
 
-int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
+int machine__resolve_callchain(struct machine *self,
+			       struct perf_evsel *evsel __used,
 			       struct thread *thread,
 			       struct ip_callchain *chain,
 			       struct symbol **parent)
@@ -297,7 +298,7 @@ int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
 	unsigned int i;
 	int err;
 
-	callchain_cursor_reset(&evsel->hists.callchain_cursor);
+	callchain_cursor_reset(&callchain_cursor);
 
 	for (i = 0; i < chain->nr; i++) {
 		u64 ip;
@@ -333,7 +334,7 @@ int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
 				break;
 		}
 
-		err = callchain_cursor_append(&evsel->hists.callchain_cursor,
+		err = callchain_cursor_append(&callchain_cursor,
 					      ip, al.map, al.sym);
 		if (err)
 			return err;
@@ -1428,7 +1429,6 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 			  int print_sym, int print_dso, int print_symoffset)
 {
 	struct addr_location al;
-	struct callchain_cursor *cursor = &evsel->hists.callchain_cursor;
 	struct callchain_cursor_node *node;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
@@ -1446,10 +1446,10 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 				error("Failed to resolve callchain. Skipping\n");
 			return;
 		}
-		callchain_cursor_commit(cursor);
+		callchain_cursor_commit(&callchain_cursor);
 
 		while (1) {
-			node = callchain_cursor_current(cursor);
+			node = callchain_cursor_current(&callchain_cursor);
 			if (!node)
 				break;
 
@@ -1465,7 +1465,7 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 			}
 			printf("\n");
 
-			callchain_cursor_advance(cursor);
+			callchain_cursor_advance(&callchain_cursor);
 		}
 
 	} else {
-- 
1.7.10.2

