Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab2CMSq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:46:59 -0400
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:45976 "EHLO
	intmgw002.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753222Ab2CMSq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:46:57 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH] perf: Add a new sort order: SORT_INCLUSIVE (v3)
Date: Tue, 13 Mar 2012 11:46:35 -0700
Message-Id: <1331664395-30631-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each entry that used to get added once to the histogram, now is added
chain->nr times, each time with one less entry in the
callchain.

This will result in a non-leaf function that appears in a lot of
samples to get a histogram entry with lots of hits.

The user can then drill down into the callchains of functions that
have high inclusive times.

Sample command lines:

$ perf record -ag -- sleep 1
$ perf report -g graph,0.5,callee -n -s inclusive

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-diff.c     |    2 +-
 tools/perf/builtin-report.c   |   13 ++----
 tools/perf/builtin-top.c      |    2 +-
 tools/perf/util/callchain.c   |   14 +++++++
 tools/perf/util/callchain.h   |    4 ++
 tools/perf/util/hist.c        |   83 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/hist.h        |    4 +-
 tools/perf/util/sort.c        |   10 +++++
 tools/perf/util/sort.h        |    3 +
 10 files changed, 123 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 806e0a2..5651b7b 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -62,7 +62,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, 1);
+	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, 1);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4f19513..4a30856 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -27,7 +27,7 @@ static bool show_displacement;
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period)
 {
-	if (__hists__add_entry(self, al, NULL, period) != NULL)
+	if (__hists__add_entry(self, al, NULL, NULL, period) != NULL)
 		return 0;
 	return -ENOMEM;
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 25d34d4..f20587f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -61,6 +61,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	struct symbol *parent = NULL;
 	int err = 0;
 	struct hist_entry *he;
+	struct callchain_cursor *cursor;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
 		err = machine__resolve_callchain(machine, evsel, al->thread,
@@ -69,17 +70,12 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 			return err;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
+	cursor = &evsel->hists.callchain_cursor;
+	he = __hists__add_entry(&evsel->hists, al, parent,
+			        cursor, sample->period);
 	if (he == NULL)
 		return -ENOMEM;
 
-	if (symbol_conf.use_callchain) {
-		err = callchain_append(he->callchain,
-				       &evsel->hists.callchain_cursor,
-				       sample->period);
-		if (err)
-			return err;
-	}
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
 	 * so we don't allocated the extra space needed because the stdio
@@ -595,6 +591,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
+	sort_entry__setup_elide(&sort_sym_inclusive, symbol_conf.sym_list, "inclusive", stdout);
 
 	return __cmd_report(&report);
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e3c63ae..41e7153 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -235,7 +235,7 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 {
 	struct hist_entry *he;
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period);
+	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, sample->period);
 	if (he == NULL)
 		return NULL;
 
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 9f7106a..aa4acde 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -459,3 +459,17 @@ int callchain_cursor_append(struct callchain_cursor *cursor,
 
 	return 0;
 }
+
+int callchain_get(struct callchain_cursor *cursor,
+		  struct addr_location *al)
+{
+	struct callchain_cursor_node *node = cursor->curr;
+
+	if (node == NULL) return -1;
+
+	al->map = node->map;
+	al->sym = node->sym;
+	al->addr = node->ip;
+
+	return 0;
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 7f9c0f1..dcff6ec 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -103,9 +103,13 @@ int callchain_merge(struct callchain_cursor *cursor,
 
 struct ip_callchain;
 union perf_event;
+struct addr_location;
 
 bool ip_callchain__valid(struct ip_callchain *chain,
 			 const union perf_event *event);
+
+int callchain_get(struct callchain_cursor *cursor, struct addr_location *al);
+
 /*
  * Initialize a cursor before adding entries inside, but keep
  * the previously allocated entries as a cache.
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6f505d1..9d703ec 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -79,6 +79,7 @@ static void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 static void hist_entry__add_cpumode_period(struct hist_entry *he,
 					   unsigned int cpumode, u64 period)
 {
+	he->period_self += period;
 	switch (cpumode) {
 	case PERF_RECORD_MISC_KERNEL:
 		he->period_sys += period;
@@ -184,7 +185,7 @@ static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
 		++hists->nr_entries;
-		hists->stats.total_period += h->period;
+		hists->stats.total_period += h->period_self;
 	}
 }
 
@@ -195,7 +196,7 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 	return 0;
 }
 
-struct hist_entry *__hists__add_entry(struct hists *hists,
+static struct hist_entry *___hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
 				      struct symbol *sym_parent, u64 period)
 {
@@ -212,6 +213,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		.ip	= al->addr,
 		.level	= al->level,
 		.period	= period,
+		.period_self = period,
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 	};
@@ -252,6 +254,83 @@ out_unlock:
 	return he;
 }
 
+static struct hist_entry *__hists__add_entry_inclusive(struct hists *hists,
+				struct addr_location *al,
+				struct symbol *sym_parent,
+				struct callchain_cursor *cursor,
+				u64 period)
+{
+	struct callchain_cursor iter = *cursor;
+	struct callchain_cursor new_cursor = *cursor;
+	struct hist_entry *he, *orig_he = NULL;
+	int err;
+	u64 i;
+
+	iter.pos = 0;
+	iter.curr = iter.first;
+	for (i = 0; i < cursor->nr; i++) {
+		struct addr_location al_child = *al;
+
+		err = callchain_get(&iter, &al_child);
+		if (err)
+			return NULL;
+		he = ___hists__add_entry(hists, &al_child, sym_parent, period);
+		if (he == NULL)
+			return NULL;
+
+		new_cursor.first = iter.curr;
+		new_cursor.nr = cursor->nr - i;
+		if (i != 0)
+			he->period_self -= period;
+		else
+			orig_he = he;
+		err = callchain_append(he->callchain,
+				       &new_cursor,
+				       period);
+		if (err)
+			return NULL;
+		callchain_cursor_advance(&iter);
+	}
+	return orig_he;
+}
+
+static struct hist_entry *__hists__add_entry_single(struct hists *hists,
+					     struct addr_location *al,
+					     struct symbol *sym_parent,
+					     struct callchain_cursor *cursor,
+					     u64 period)
+{
+	struct hist_entry *he;
+	int err;
+
+	he = ___hists__add_entry(hists, al, sym_parent, period);
+	if (he == NULL)
+		return NULL;
+	if (symbol_conf.use_callchain) {
+		err = callchain_append(he->callchain, cursor, period);
+		if (err)
+			return NULL;
+	}
+	return he;
+}
+
+struct hist_entry *__hists__add_entry(struct hists *hists,
+				      struct addr_location *al,
+				      struct symbol *parent, 
+				      struct callchain_cursor *cursor,
+				      u64 period)
+{
+	struct hist_entry *he;
+
+	if (sort__first_dimension == SORT_INCLUSIVE)
+		he = __hists__add_entry_inclusive(hists, al, parent,
+						  cursor, period);
+	else
+		he = __hists__add_entry_single(hists, al, parent,
+					       cursor, period);
+	return he;
+}
+
 int64_t
 hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 48e5acd..4d3c6fb 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -67,7 +67,9 @@ struct hists {
 
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
-				      struct symbol *parent, u64 period);
+				      struct symbol *parent, 
+				      struct callchain_cursor *cursor,
+				      u64 period);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 16da30d..f7c93d9 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -197,6 +197,13 @@ struct sort_entry sort_sym = {
 	.se_width_idx	= HISTC_SYMBOL,
 };
 
+struct sort_entry sort_sym_inclusive = {
+	.se_header	= "Symbol (Inclusive)",
+	.se_cmp		= sort__sym_cmp,
+	.se_snprintf	= hist_entry__sym_snprintf,
+	.se_width_idx	= HISTC_SYMBOL,
+};
+
 /* --sort parent */
 
 static int64_t
@@ -259,6 +266,7 @@ static struct sort_dimension sort_dimensions[] = {
 	{ .name = "symbol",	.entry = &sort_sym,	},
 	{ .name = "parent",	.entry = &sort_parent,	},
 	{ .name = "cpu",	.entry = &sort_cpu,	},
+	{ .name = "inclusive",	.entry = &sort_sym_inclusive, },
 };
 
 int sort_dimension__add(const char *tok)
@@ -298,6 +306,8 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_DSO;
 			else if (!strcmp(sd->name, "symbol"))
 				sort__first_dimension = SORT_SYM;
+			else if (!strcmp(sd->name, "inclusive"))
+				sort__first_dimension = SORT_INCLUSIVE;
 			else if (!strcmp(sd->name, "parent"))
 				sort__first_dimension = SORT_PARENT;
 			else if (!strcmp(sd->name, "cpu"))
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 3f67ae3..efb145f 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -35,6 +35,7 @@ extern char *field_sep;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
 extern struct sort_entry sort_sym;
+extern struct sort_entry sort_sym_inclusive;
 extern struct sort_entry sort_parent;
 extern enum sort_type sort__first_dimension;
 
@@ -48,6 +49,7 @@ struct hist_entry {
 	struct rb_node		rb_node_in;
 	struct rb_node		rb_node;
 	u64			period;
+	u64			period_self;
 	u64			period_sys;
 	u64			period_us;
 	u64			period_guest_sys;
@@ -82,6 +84,7 @@ enum sort_type {
 	SORT_SYM,
 	SORT_PARENT,
 	SORT_CPU,
+	SORT_INCLUSIVE,
 };
 
 /*
-- 
1.7.8.4

