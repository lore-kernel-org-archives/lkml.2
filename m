Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2FFHBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:01:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2FFHBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:01:23 -0400
Date: Wed, 6 Jun 2012 00:00:56 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-472606458f3e1ced5fe3cc5f04e90a6b5a4732cf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        namhyung@gmail.com, fan4326@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, namhyung.kim@lge.com, namhyung@gmail.com,
        fan4326@gmail.com, tglx@linutronix.de
In-Reply-To: <1338443007-24857-1-git-send-email-namhyung.kim@lge.com>
References: <1338443007-24857-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf callchain: Make callchain cursors TLS
Git-Commit-ID: 472606458f3e1ced5fe3cc5f04e90a6b5a4732cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 00:01:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  472606458f3e1ced5fe3cc5f04e90a6b5a4732cf
Gitweb:     http://git.kernel.org/tip/472606458f3e1ced5fe3cc5f04e90a6b5a4732cf
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 31 May 2012 14:43:26 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 May 2012 10:47:12 -0300

perf callchain: Make callchain cursors TLS

perf top -G has a race on callchain cursor between main thread and
display thread. Since the callchain cursors are used locally make them
thread-local data would solve the problem.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reported-by: Sunjin Yang <fan4326@gmail.com>
Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sunjin Yang <fan4326@gmail.com>
Link: http://lkml.kernel.org/r/1338443007-24857-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index 2400e00..25249f7 100644
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
index 871b540..6bb0277 100644
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
index 9f7106a..3a6bff4 100644
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
index 7f9c0f1..3bdb407 100644
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
index 1293b5e..514e2a4 100644
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
index cfc64e2..34bb556 100644
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
index 4820614..3b6f8e4 100644
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
