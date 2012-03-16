Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161495Ab2CPUEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:04:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34776 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab2CPUCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:02:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/13] perf hists: Add hists__filter_by_symbol
Date: Fri, 16 Mar 2012 17:02:06 -0300
Message-Id: <1331928130-16243-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1331928130-16243-1-git-send-email-acme@infradead.org>
References: <1331928130-16243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

This function will be used for simple (sub-)string matching filter based
on user input.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331887855-874-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   35 +++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h |    2 ++
 2 files changed, 37 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 8380c3d..2c624ad 100644
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
@@ -420,6 +423,7 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
 {
 	hists__filter_entry_by_dso(hists, he);
 	hists__filter_entry_by_thread(hists, he);
+	hists__filter_entry_by_symbol(hists, he);
 }
 
 static void __hists__collapse_resort(struct hists *hists, bool threaded)
@@ -1247,6 +1251,37 @@ void hists__filter_by_thread(struct hists *hists)
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
index 9413f3e..10343c0 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -62,6 +62,7 @@ struct hists {
 	const struct thread	*thread_filter;
 	const struct dso	*dso_filter;
 	const char		*uid_filter_str;
+	const char		*symbol_filter_str;
 	pthread_mutex_t		lock;
 	struct events_stats	stats;
 	u64			event_stream;
@@ -107,6 +108,7 @@ int hist_entry__annotate(struct hist_entry *self, size_t privsize);
 
 void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
+void hists__filter_by_symbol(struct hists *hists);
 
 u16 hists__col_len(struct hists *self, enum hist_column col);
 void hists__set_col_len(struct hists *self, enum hist_column col, u16 len);
-- 
1.7.9.2.358.g22243

