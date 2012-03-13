Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab2CMGNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:13:04 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64668 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866Ab2CMGNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:13:01 -0400
X-AuditID: 9c93016f-b7c68ae000000b77-ce-4f5ee56bb292
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] perf hists: Add hists__filter_by_symbol
Date: Tue, 13 Mar 2012 15:14:51 +0900
Message-Id: <1331619294-29162-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function will be used for simple (sub-)string matching
filter based on user input.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/hist.c |   35 +++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h |    2 ++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6f505d1abac7..021b49c498d5 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -10,11 +10,14 @@ static bool hists__filter_entry_by_dso(struct hists *hists,
 				       struct hist_entry *he);
 static bool hists__filter_entry_by_thread(struct hists *hists,
 					  struct hist_entry *he);
+static bool hists__filter_entry_by_symbol(struct hists *hists,
+					  struct hist_entry *he);
 
 enum hist_filter {
 	HIST_FILTER__DSO,
 	HIST_FILTER__THREAD,
 	HIST_FILTER__PARENT,
+	HIST_FILTER__SYMBOL,
 };
 
 struct callchain_param	callchain_param = {
@@ -352,6 +355,7 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
 {
 	hists__filter_entry_by_dso(hists, he);
 	hists__filter_entry_by_thread(hists, he);
+	hists__filter_entry_by_symbol(hists, he);
 }
 
 static void __hists__collapse_resort(struct hists *hists, bool threaded)
@@ -1179,6 +1183,37 @@ void hists__filter_by_thread(struct hists *hists)
 	}
 }
 
+static bool hists__filter_entry_by_symbol(struct hists *hists,
+					  struct hist_entry *he)
+{
+	if (hists->symbol_filter_str != NULL &&
+	    (!he->ms.sym || strstr(he->ms.sym->name,
+				   hists->symbol_filter_str) == NULL)) {
+		he->filtered |= (1 << HIST_FILTER__SYMBOL);
+		return true;
+	}
+
+	return false;
+}
+
+void hists__filter_by_symbol(struct hists *hists)
+{
+	struct rb_node *nd;
+
+	hists->nr_entries = hists->stats.total_period = 0;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists__reset_col_len(hists);
+
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (hists__filter_entry_by_symbol(hists, h))
+			continue;
+
+		hists__remove_entry_filter(hists, h, HIST_FILTER__SYMBOL);
+	}
+}
+
 int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 ip)
 {
 	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, evidx, ip);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 48e5acd1e862..020d3477cabc 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -57,6 +57,7 @@ struct hists {
 	const struct thread	*thread_filter;
 	const struct dso	*dso_filter;
 	const char		*uid_filter_str;
+	const char		*symbol_filter_str;
 	pthread_mutex_t		lock;
 	struct events_stats	stats;
 	u64			event_stream;
@@ -96,6 +97,7 @@ int hist_entry__annotate(struct hist_entry *self, size_t privsize);
 
 void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
+void hists__filter_by_symbol(struct hists *hists);
 
 u16 hists__col_len(struct hists *self, enum hist_column col);
 void hists__set_col_len(struct hists *self, enum hist_column col, u16 len);
-- 
1.7.9

