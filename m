Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab1JFR1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:27:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:44280 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716Ab1JFRWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/15] perf hists: Threaded addition and sorting of entries
Date: Thu,  6 Oct 2011 14:22:27 -0300
Message-Id: <1317921758-4154-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

By using a mutex just for inserting and rotating two hist_entry rb
trees, so that when sorting we can get the last batch of entries created
from the ring buffer, merge it with whatever we have processed so far
and show the output while new entries are being added.

The 'report' tool continues, for now, to do it without threading, but
will use this in the future to allow visualization of results in long
perf.data sessions while the entries are being processed.

The new 'top' tool will be the first user.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9b05atsn0q6m7fqgrug8fk2i@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    1 +
 tools/perf/util/hist.c  |  111 ++++++++++++++++++++++++++++++++++-------------
 tools/perf/util/hist.h  |    9 ++++
 tools/perf/util/sort.h  |    1 +
 4 files changed, 92 insertions(+), 30 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a03a36b..8b58626 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -37,6 +37,7 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	evsel->idx	   = idx;
 	evsel->attr	   = *attr;
 	INIT_LIST_HEAD(&evsel->node);
+	hists__init(&evsel->hists);
 }
 
 struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 32c9086..80fe30d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -118,6 +118,7 @@ static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
 		++hists->nr_entries;
+		hists->stats.total_period += h->period;
 	}
 }
 
@@ -132,7 +133,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
 				      struct symbol *sym_parent, u64 period)
 {
-	struct rb_node **p = &hists->entries.rb_node;
+	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	struct hist_entry entry = {
@@ -150,9 +151,13 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 	};
 	int cmp;
 
+	pthread_mutex_lock(&hists->lock);
+
+	p = &hists->entries_in->rb_node;
+
 	while (*p != NULL) {
 		parent = *p;
-		he = rb_entry(parent, struct hist_entry, rb_node);
+		he = rb_entry(parent, struct hist_entry, rb_node_in);
 
 		cmp = hist_entry__cmp(&entry, he);
 
@@ -170,12 +175,14 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 
 	he = hist_entry__new(&entry);
 	if (!he)
-		return NULL;
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &hists->entries);
-	hists__inc_nr_entries(hists, he);
+		goto out_unlock;
+
+	rb_link_node(&he->rb_node_in, parent, p);
+	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
 	hist_entry__add_cpumode_period(he, al->cpumode, period);
+out_unlock:
+	pthread_mutex_unlock(&hists->lock);
 	return he;
 }
 
@@ -233,7 +240,7 @@ static bool hists__collapse_insert_entry(struct hists *hists,
 
 	while (*p != NULL) {
 		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
+		iter = rb_entry(parent, struct hist_entry, rb_node_in);
 
 		cmp = hist_entry__collapse(iter, he);
 
@@ -254,35 +261,57 @@ static bool hists__collapse_insert_entry(struct hists *hists,
 			p = &(*p)->rb_right;
 	}
 
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, root);
+	rb_link_node(&he->rb_node_in, parent, p);
+	rb_insert_color(&he->rb_node_in, root);
 	return true;
 }
 
-void hists__collapse_resort(struct hists *hists)
+static struct rb_root *hists__get_rotate_entries_in(struct hists *hists)
 {
-	struct rb_root tmp;
+	struct rb_root *root;
+
+	pthread_mutex_lock(&hists->lock);
+
+	root = hists->entries_in;
+	if (++hists->entries_in > &hists->entries_in_array[1])
+		hists->entries_in = &hists->entries_in_array[0];
+
+	pthread_mutex_unlock(&hists->lock);
+
+	return root;
+}
+
+static void __hists__collapse_resort(struct hists *hists, bool threaded)
+{
+	struct rb_root *root;
 	struct rb_node *next;
 	struct hist_entry *n;
 
-	if (!sort__need_collapse)
+	if (!sort__need_collapse && !threaded)
 		return;
 
-	tmp = RB_ROOT;
-	next = rb_first(&hists->entries);
-	hists->nr_entries = 0;
-	hists__reset_col_len(hists);
+	root = hists__get_rotate_entries_in(hists);
+	next = rb_first(root);
+	hists->stats.total_period = 0;
 
 	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		next = rb_next(&n->rb_node);
+		n = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&n->rb_node_in);
 
-		rb_erase(&n->rb_node, &hists->entries);
-		if (hists__collapse_insert_entry(hists, &tmp, n))
+		rb_erase(&n->rb_node_in, root);
+		if (hists__collapse_insert_entry(hists, &hists->entries_collapsed, n))
 			hists__inc_nr_entries(hists, n);
 	}
+}
 
-	hists->entries = tmp;
+void hists__collapse_resort(struct hists *hists)
+{
+	return __hists__collapse_resort(hists, false);
+}
+
+void hists__collapse_resort_threaded(struct hists *hists)
+{
+	return __hists__collapse_resort(hists, true);
 }
 
 /*
@@ -315,31 +344,43 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 	rb_insert_color(&he->rb_node, entries);
 }
 
-void hists__output_resort(struct hists *hists)
+static void __hists__output_resort(struct hists *hists, bool threaded)
 {
-	struct rb_root tmp;
+	struct rb_root *root;
 	struct rb_node *next;
 	struct hist_entry *n;
 	u64 min_callchain_hits;
 
 	min_callchain_hits = hists->stats.total_period * (callchain_param.min_percent / 100);
 
-	tmp = RB_ROOT;
-	next = rb_first(&hists->entries);
+	if (sort__need_collapse || threaded)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
+
+	next = rb_first(root);
+	hists->entries = RB_ROOT;
 
 	hists->nr_entries = 0;
 	hists__reset_col_len(hists);
 
 	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		next = rb_next(&n->rb_node);
+		n = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&n->rb_node_in);
 
-		rb_erase(&n->rb_node, &hists->entries);
-		__hists__insert_output_entry(&tmp, n, min_callchain_hits);
+		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
 		hists__inc_nr_entries(hists, n);
 	}
+}
 
-	hists->entries = tmp;
+void hists__output_resort(struct hists *hists)
+{
+	return __hists__output_resort(hists, false);
+}
+
+void hists__output_resort_threaded(struct hists *hists)
+{
+	return __hists__output_resort(hists, true);
 }
 
 static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
@@ -1043,3 +1084,13 @@ size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
 
 	return ret;
 }
+
+void hists__init(struct hists *hists)
+{
+	memset(hists, 0, sizeof(*hists));
+	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
+	hists->entries_in = &hists->entries_in_array[0];
+	hists->entries_collapsed = RB_ROOT;
+	hists->entries = RB_ROOT;
+	pthread_mutex_init(&hists->lock, NULL);
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 861ffc3..d3f976c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -2,6 +2,7 @@
 #define __PERF_HIST_H
 
 #include <linux/types.h>
+#include <pthread.h>
 #include "callchain.h"
 
 extern struct callchain_param callchain_param;
@@ -43,8 +44,12 @@ enum hist_column {
 };
 
 struct hists {
+	struct rb_root		entries_in_array[2];
+	struct rb_root		*entries_in;
 	struct rb_root		entries;
+	struct rb_root		entries_collapsed;
 	u64			nr_entries;
+	pthread_mutex_t		lock;
 	struct events_stats	stats;
 	u64			event_stream;
 	u16			col_len[HISTC_NR_COLS];
@@ -52,6 +57,8 @@ struct hists {
 	struct callchain_cursor	callchain_cursor;
 };
 
+void hists__init(struct hists *hists);
+
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *parent, u64 period);
@@ -67,7 +74,9 @@ int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
 void hist_entry__free(struct hist_entry *);
 
 void hists__output_resort(struct hists *self);
+void hists__output_resort_threaded(struct hists *hists);
 void hists__collapse_resort(struct hists *self);
+void hists__collapse_resort_threaded(struct hists *hists);
 
 void hists__inc_nr_events(struct hists *self, u32 type);
 size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 77d0388..03851e3 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -45,6 +45,7 @@ extern enum sort_type sort__first_dimension;
  * @nr_rows - rows expanded in callchain, recalculated on folding/unfolding
  */
 struct hist_entry {
+	struct rb_node		rb_node_in;
 	struct rb_node		rb_node;
 	u64			period;
 	u64			period_sys;
-- 
1.6.2.5

