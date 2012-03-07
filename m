Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030847Ab2CGWl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:41:56 -0500
Received: from outmail005.snc4.facebook.com ([66.220.144.139]:59773 "EHLO
	intmgw003.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965343Ab2CGWlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:41:40 -0500
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
Subject: [PATCH 2/2] perf: Add a new sort order: SORT_INCLUSIVE
Date: Wed,  7 Mar 2012 14:41:19 -0800
Message-Id: <1331160079-13821-3-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1331160079-13821-1-git-send-email-asharma@fb.com>
References: <1331160079-13821-1-git-send-email-asharma@fb.com>
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
 builtin-report.c |    9 +++++++--
 util/callchain.c |   14 ++++++++++++++
 util/callchain.h |    4 ++++
 util/hist.c      |   44 +++++++++++++++++++++++++++++++++++++++++++-
 util/hist.h      |    5 +++++
 util/sort.c      |    3 +++
 util/sort.h      |    2 ++
 7 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/builtin-report.c b/builtin-report.c
index 72490a4..87318c8 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -71,8 +71,12 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	}
 
 	cursor = &evsel->hists.callchain_cursor;
-	he = __hists__add_entry_single(&evsel->hists, al, parent,
-				       cursor, sample->period);
+	if (sort__first_dimension == SORT_INCLUSIVE)
+		he = __hists__add_entry_inclusive(&evsel->hists, al, parent,
+						  cursor, sample->period);
+	else
+		he = __hists__add_entry_single(&evsel->hists, al, parent,
+					       cursor, sample->period);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -591,6 +595,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
+	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "inclusive", stdout);
 
 	return __cmd_report(&report);
 }
diff --git a/util/callchain.c b/util/callchain.c
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
diff --git a/util/callchain.h b/util/callchain.h
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
diff --git a/util/hist.c b/util/hist.c
index ca2314a..9741d48 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -174,6 +174,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 			he->ms.map->referenced = true;
 		if (symbol_conf.use_callchain)
 			callchain_init(he->callchain);
+		he->inclusive = false;
 	}
 
 	return he;
@@ -184,7 +185,8 @@ static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
 		++hists->nr_entries;
-		hists->stats.total_period += h->period;
+		if (!h->inclusive)
+			hists->stats.total_period += h->period;
 	}
 }
 
@@ -252,6 +254,46 @@ out_unlock:
 	return he;
 }
 
+struct hist_entry *__hists__add_entry_inclusive(struct hists *hists,
+						struct addr_location *al,
+						struct symbol *sym_parent,
+						struct callchain_cursor *cursor,
+						u64 period)
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
+		he = __hists__add_entry(hists, &al_child, sym_parent, period);
+		if (he == NULL)
+			return NULL;
+
+		new_cursor.first = iter.curr;
+		new_cursor.nr = cursor->nr - i;
+		if (i != 0)
+			he->inclusive = 1;
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
 struct hist_entry *__hists__add_entry_single(struct hists *hists,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
diff --git a/util/hist.h b/util/hist.h
index 3ed726b..8b8b096 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -73,6 +73,11 @@ struct hist_entry *__hists__add_entry_single(struct hists *self,
 				      struct symbol *parent,
 				      struct callchain_cursor *cursor,
 				      u64 period);
+struct hist_entry *__hists__add_entry_inclusive(struct hists *self,
+				      struct addr_location *al,
+				      struct symbol *parent,
+				      struct callchain_cursor *cursor,
+				      u64 period);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
diff --git a/util/sort.c b/util/sort.c
index 16da30d..1440ad4 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -259,6 +259,7 @@ static struct sort_dimension sort_dimensions[] = {
 	{ .name = "symbol",	.entry = &sort_sym,	},
 	{ .name = "parent",	.entry = &sort_parent,	},
 	{ .name = "cpu",	.entry = &sort_cpu,	},
+	{ .name = "inclusive",	.entry = &sort_sym, 	},
 };
 
 int sort_dimension__add(const char *tok)
@@ -298,6 +299,8 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_DSO;
 			else if (!strcmp(sd->name, "symbol"))
 				sort__first_dimension = SORT_SYM;
+			else if (!strcmp(sd->name, "inclusive"))
+				sort__first_dimension = SORT_INCLUSIVE;
 			else if (!strcmp(sd->name, "parent"))
 				sort__first_dimension = SORT_PARENT;
 			else if (!strcmp(sd->name, "cpu"))
diff --git a/util/sort.h b/util/sort.h
index 3f67ae3..2d35c11 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -65,6 +65,7 @@ struct hist_entry {
 	bool			init_have_children;
 	char			level;
 	bool			used;
+	bool			inclusive;
 	u8			filtered;
 	struct symbol		*parent;
 	union {
@@ -82,6 +83,7 @@ enum sort_type {
 	SORT_SYM,
 	SORT_PARENT,
 	SORT_CPU,
+	SORT_INCLUSIVE,
 };
 
 /*
-- 
1.7.8.rc1

