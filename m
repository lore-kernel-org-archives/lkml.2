Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0EJQdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:33:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:59389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab0EJQcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:32:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Eric B Munson <ebmunson@us.ibm.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/4] perf hist: Introduce hists class and move lots of methods to it
Date: Mon, 10 May 2010 13:32:21 -0300
Message-Id: <1273509141-15696-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273509141-15696-1-git-send-email-acme@infradead.org>
References: <1273509141-15696-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In cbbc79a we introduced support for multiple events by introducing a
new "event_stat_id" struct and then made several perf_session methods
receive a point to it instead of a pointer to perf_session, and kept the
event_stats and hists rb_tree in perf_session.

While working on the new newt based browser, I realised that it would be
better to introduce a new class, "hists" (short for "histograms"),
renaming the "event_stat_id" struct and the perf_session methods that
were really "hists" methods, as they manipulate only struct hists
members, not touching anything in the other perf_session members.

Other optimizations, such as calculating the maximum lenght of a symbol
name present in an hists instance will be possible as we add them,
avoiding a re-traversal just for finding that information.

The rationale for the name "hists" to replace "event_stat_id" is that we
may have multiple sets of hists for the same event_stat id, as, for
instance, the 'perf diff' tool has, so event stat id is not what
characterizes what this struct and the functions that manipulate it do.

Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   17 ++++----
 tools/perf/builtin-diff.c     |   50 ++++++++++------------
 tools/perf/builtin-report.c   |   71 +++++++++++++++----------------
 tools/perf/builtin-trace.c    |    2 +-
 tools/perf/util/event.c       |    2 +-
 tools/perf/util/event.h       |   14 ------
 tools/perf/util/hist.c        |   92 ++++++++++++++++++----------------------
 tools/perf/util/hist.h        |   48 ++++++++++++---------
 tools/perf/util/session.c     |    2 +-
 tools/perf/util/session.h     |   12 ++++-
 10 files changed, 146 insertions(+), 164 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index c7ac45a..3940964 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -96,8 +96,7 @@ static int annotate__hist_hit(struct hist_entry *he, u64 ip)
 	return 0;
 }
 
-static int perf_session__add_hist_entry(struct perf_session *self,
-					struct addr_location *al)
+static int hists__add_entry(struct hists *self, struct addr_location *al)
 {
 	struct hist_entry *he;
 
@@ -112,7 +111,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 		return 0;
 	}
 
-	he = __perf_session__add_hist_entry(&self->hists, al, NULL, 1);
+	he = __hists__add_entry(self, al, NULL, 1);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -132,7 +131,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		return -1;
 	}
 
-	if (!al.filtered && perf_session__add_hist_entry(session, &al)) {
+	if (!al.filtered && hists__add_entry(&session->hists, &al)) {
 		pr_warning("problem incrementing symbol count, "
 			   "skipping event\n");
 		return -1;
@@ -514,11 +513,11 @@ static void annotate_sym(struct hist_entry *he)
 		free_source_line(he, len);
 }
 
-static void perf_session__find_annotations(struct perf_session *self)
+static void hists__find_annotations(struct hists *self)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 		struct sym_priv *priv;
 
@@ -570,9 +569,9 @@ static int __cmd_annotate(void)
 	if (verbose > 2)
 		perf_session__fprintf_dsos(session, stdout);
 
-	perf_session__collapse_resort(&session->hists);
-	perf_session__output_resort(&session->hists, session->event_total[0]);
-	perf_session__find_annotations(session);
+	hists__collapse_resort(&session->hists);
+	hists__output_resort(&session->hists);
+	hists__find_annotations(&session->hists);
 out_delete:
 	perf_session__delete(session);
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 613a5c4..3a95a02 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -22,10 +22,10 @@ static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
 
-static int perf_session__add_hist_entry(struct perf_session *self,
-					struct addr_location *al, u64 count)
+static int hists__add_entry(struct hists *self,
+			    struct addr_location *al, u64 count)
 {
-	if (__perf_session__add_hist_entry(&self->hists, al, NULL, count) != NULL)
+	if (__hists__add_entry(self, al, NULL, count) != NULL)
 		return 0;
 	return -ENOMEM;
 }
@@ -49,12 +49,12 @@ static int diff__process_sample_event(event_t *event, struct perf_session *sessi
 
 	event__parse_sample(event, session->sample_type, &data);
 
-	if (perf_session__add_hist_entry(session, &al, data.period)) {
+	if (hists__add_entry(&session->hists, &al, data.period)) {
 		pr_warning("problem incrementing symbol count, skipping event\n");
 		return -1;
 	}
 
-	session->events_stats.total += data.period;
+	session->hists.stats.total += data.period;
 	return 0;
 }
 
@@ -87,35 +87,34 @@ static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
 	rb_insert_color(&he->rb_node, root);
 }
 
-static void perf_session__resort_hist_entries(struct perf_session *self)
+static void hists__resort_entries(struct hists *self)
 {
 	unsigned long position = 1;
 	struct rb_root tmp = RB_ROOT;
-	struct rb_node *next = rb_first(&self->hists);
+	struct rb_node *next = rb_first(&self->entries);
 
 	while (next != NULL) {
 		struct hist_entry *n = rb_entry(next, struct hist_entry, rb_node);
 
 		next = rb_next(&n->rb_node);
-		rb_erase(&n->rb_node, &self->hists);
+		rb_erase(&n->rb_node, &self->entries);
 		n->position = position++;
 		perf_session__insert_hist_entry_by_name(&tmp, n);
 	}
 
-	self->hists = tmp;
+	self->entries = tmp;
 }
 
-static void perf_session__set_hist_entries_positions(struct perf_session *self)
+static void hists__set_positions(struct hists *self)
 {
-	perf_session__output_resort(&self->hists, self->events_stats.total);
-	perf_session__resort_hist_entries(self);
+	hists__output_resort(self);
+	hists__resort_entries(self);
 }
 
-static struct hist_entry *
-perf_session__find_hist_entry(struct perf_session *self,
-			      struct hist_entry *he)
+static struct hist_entry *hists__find_entry(struct hists *self,
+					    struct hist_entry *he)
 {
-	struct rb_node *n = self->hists.rb_node;
+	struct rb_node *n = self->entries.rb_node;
 
 	while (n) {
 		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
@@ -132,14 +131,13 @@ perf_session__find_hist_entry(struct perf_session *self,
 	return NULL;
 }
 
-static void perf_session__match_hists(struct perf_session *old_session,
-				      struct perf_session *new_session)
+static void hists__match(struct hists *older, struct hists *newer)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&new_session->hists); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&newer->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *pos = rb_entry(nd, struct hist_entry, rb_node);
-		pos->pair = perf_session__find_hist_entry(old_session, pos);
+		pos->pair = hists__find_entry(older, pos);
 	}
 }
 
@@ -159,15 +157,13 @@ static int __cmd_diff(void)
 			goto out_delete;
 	}
 
-	perf_session__output_resort(&session[1]->hists,
-				    session[1]->events_stats.total);
+	hists__output_resort(&session[1]->hists);
 	if (show_displacement)
-		perf_session__set_hist_entries_positions(session[0]);
+		hists__set_positions(&session[0]->hists);
 
-	perf_session__match_hists(session[0], session[1]);
-	perf_session__fprintf_hists(&session[1]->hists, session[0],
-				    show_displacement, stdout,
-				    session[1]->events_stats.total);
+	hists__match(&session[0]->hists, &session[1]->hists);
+	hists__fprintf(&session[1]->hists, &session[0]->hists,
+		       show_displacement, stdout);
 out_delete:
 	for (i = 0; i < 2; ++i)
 		perf_session__delete(session[i]);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 642a6d8..53077fd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -44,16 +44,17 @@ static char		*pretty_printing_style = default_pretty_printing_style;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
-static struct event_stat_id *get_stats(struct perf_session *self,
-				       u64 event_stream, u32 type, u64 config)
+static struct hists *perf_session__hists_findnew(struct perf_session *self,
+						 u64 event_stream, u32 type,
+						 u64 config)
 {
-	struct rb_node **p = &self->stats_by_id.rb_node;
+	struct rb_node **p = &self->hists_tree.rb_node;
 	struct rb_node *parent = NULL;
-	struct event_stat_id *iter, *new;
+	struct hists *iter, *new;
 
 	while (*p != NULL) {
 		parent = *p;
-		iter = rb_entry(parent, struct event_stat_id, rb_node);
+		iter = rb_entry(parent, struct hists, rb_node);
 		if (iter->config == config)
 			return iter;
 
@@ -64,15 +65,15 @@ static struct event_stat_id *get_stats(struct perf_session *self,
 			p = &(*p)->rb_left;
 	}
 
-	new = malloc(sizeof(struct event_stat_id));
+	new = malloc(sizeof(struct hists));
 	if (new == NULL)
 		return NULL;
-	memset(new, 0, sizeof(struct event_stat_id));
+	memset(new, 0, sizeof(struct hists));
 	new->event_stream = event_stream;
 	new->config = config;
 	new->type = type;
 	rb_link_node(&new->rb_node, parent, p);
-	rb_insert_color(&new->rb_node, &self->stats_by_id);
+	rb_insert_color(&new->rb_node, &self->hists_tree);
 	return new;
 }
 
@@ -84,7 +85,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	struct symbol *parent = NULL;
 	int err = -ENOMEM;
 	struct hist_entry *he;
-	struct event_stat_id *stats;
+	struct hists *hists;
 	struct perf_event_attr *attr;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && data->callchain) {
@@ -96,13 +97,12 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 
 	attr = perf_header__find_attr(data->id, &self->header);
 	if (attr)
-		stats = get_stats(self, data->id, attr->type, attr->config);
+		hists = perf_session__hists_findnew(self, data->id, attr->type, attr->config);
 	else
-		stats = get_stats(self, data->id, 0, 0);
-	if (stats == NULL)
+		hists = perf_session__hists_findnew(self, data->id, 0, 0);
+	if (hists == NULL)
 		goto out_free_syms;
-	he = __perf_session__add_hist_entry(&stats->hists, al, parent,
-					    data->period);
+	he = __hists__add_entry(hists, al, parent, data->period);
 	if (he == NULL)
 		goto out_free_syms;
 	err = 0;
@@ -117,18 +117,19 @@ static int add_event_total(struct perf_session *session,
 			   struct sample_data *data,
 			   struct perf_event_attr *attr)
 {
-	struct event_stat_id *stats;
+	struct hists *hists;
 
 	if (attr)
-		stats = get_stats(session, data->id, attr->type, attr->config);
+		hists = perf_session__hists_findnew(session, data->id,
+						    attr->type, attr->config);
 	else
-		stats = get_stats(session, data->id, 0, 0);
+		hists = perf_session__hists_findnew(session, data->id, 0, 0);
 
-	if (!stats)
+	if (!hists)
 		return -ENOMEM;
 
-	stats->stats.total += data->period;
-	session->events_stats.total += data->period;
+	hists->stats.total += data->period;
+	session->hists.stats.total += data->period;
 	return 0;
 }
 
@@ -292,35 +293,33 @@ static int __cmd_report(void)
 	if (verbose > 2)
 		perf_session__fprintf_dsos(session, stdout);
 
-	next = rb_first(&session->stats_by_id);
+	next = rb_first(&session->hists_tree);
 	while (next) {
-		struct event_stat_id *stats;
+		struct hists *hists;
 		u64 nr_hists;
 
-		stats = rb_entry(next, struct event_stat_id, rb_node);
-		perf_session__collapse_resort(&stats->hists);
-		nr_hists = perf_session__output_resort(&stats->hists,
-						       stats->stats.total);
+		hists = rb_entry(next, struct hists, rb_node);
+		hists__collapse_resort(hists);
+		nr_hists = hists__output_resort(hists);
 		if (use_browser)
-			perf_session__browse_hists(&stats->hists, nr_hists,
-						   stats->stats.total, help,
+			perf_session__browse_hists(&hists->entries, nr_hists,
+						   hists->stats.total, help,
 						   input_name);
 		else {
-			if (rb_first(&session->stats_by_id) ==
-			    rb_last(&session->stats_by_id))
+			if (rb_first(&session->hists.entries) ==
+			    rb_last(&session->hists.entries))
 				fprintf(stdout, "# Samples: %Ld\n#\n",
-					stats->stats.total);
+					hists->stats.total);
 			else
 				fprintf(stdout, "# Samples: %Ld %s\n#\n",
-					stats->stats.total,
-					__event_name(stats->type, stats->config));
+					hists->stats.total,
+					__event_name(hists->type, hists->config));
 
-			perf_session__fprintf_hists(&stats->hists, NULL, false, stdout,
-					    stats->stats.total);
+			hists__fprintf(hists, NULL, false, stdout);
 			fprintf(stdout, "\n\n");
 		}
 
-		next = rb_next(&stats->rb_node);
+		next = rb_next(&hists->rb_node);
 	}
 
 	if (!use_browser && sort_order == default_sort_order &&
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9c483e9..6e268ca 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -107,7 +107,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 					     data.time, thread->comm);
 	}
 
-	session->events_stats.total += data.period;
+	session->hists.stats.total += data.period;
 	return 0;
 }
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index d2ea9dd..cce006e 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -368,7 +368,7 @@ int event__process_comm(event_t *self, struct perf_session *session)
 int event__process_lost(event_t *self, struct perf_session *session)
 {
 	dump_printf(": id:%Ld: lost:%Ld\n", self->lost.id, self->lost.lost);
-	session->events_stats.lost += self->lost.lost;
+	session->hists.stats.lost += self->lost.lost;
 	return 0;
 }
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 6cc1b1d..48c2cc9 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -131,20 +131,6 @@ typedef union event_union {
 	struct build_id_event		build_id;
 } event_t;
 
-struct events_stats {
-	u64 total;
-	u64 lost;
-};
-
-struct event_stat_id {
-	struct rb_node		rb_node;
-	struct rb_root		hists;
-	struct events_stats	stats;
-	u64			config;
-	u64			event_stream;
-	u32			type;
-};
-
 void event__print_totals(void);
 
 struct perf_session;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 0f154a5..410cf56 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -8,21 +8,21 @@ struct callchain_param	callchain_param = {
 	.min_percent = 0.5
 };
 
-static void perf_session__add_cpumode_count(struct hist_entry *he,
-					    unsigned int cpumode, u64 count)
+static void hist_entry__add_cpumode_count(struct hist_entry *self,
+					  unsigned int cpumode, u64 count)
 {
 	switch (cpumode) {
 	case PERF_RECORD_MISC_KERNEL:
-		he->count_sys += count;
+		self->count_sys += count;
 		break;
 	case PERF_RECORD_MISC_USER:
-		he->count_us += count;
+		self->count_us += count;
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
-		he->count_guest_sys += count;
+		self->count_guest_sys += count;
 		break;
 	case PERF_RECORD_MISC_GUEST_USER:
-		he->count_guest_us += count;
+		self->count_guest_us += count;
 		break;
 	default:
 		break;
@@ -47,12 +47,11 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return self;
 }
 
-struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
-						  struct addr_location *al,
-						  struct symbol *sym_parent,
-						  u64 count)
+struct hist_entry *__hists__add_entry(struct hists *self,
+				      struct addr_location *al,
+				      struct symbol *sym_parent, u64 count)
 {
-	struct rb_node **p = &hists->rb_node;
+	struct rb_node **p = &self->entries.rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	struct hist_entry entry = {
@@ -89,9 +88,9 @@ struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 	if (!he)
 		return NULL;
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, hists);
+	rb_insert_color(&he->rb_node, &self->entries);
 out:
-	perf_session__add_cpumode_count(he, al->cpumode, count);
+	hist_entry__add_cpumode_count(he, al->cpumode, count);
 	return he;
 }
 
@@ -167,7 +166,7 @@ static void collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 	rb_insert_color(&he->rb_node, root);
 }
 
-void perf_session__collapse_resort(struct rb_root *hists)
+void hists__collapse_resort(struct hists *self)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
@@ -177,28 +176,28 @@ void perf_session__collapse_resort(struct rb_root *hists)
 		return;
 
 	tmp = RB_ROOT;
-	next = rb_first(hists);
+	next = rb_first(&self->entries);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, hists);
+		rb_erase(&n->rb_node, &self->entries);
 		collapse__insert_entry(&tmp, n);
 	}
 
-	*hists = tmp;
+	self->entries = tmp;
 }
 
 /*
  * reverse the map, sort on count.
  */
 
-static void perf_session__insert_output_hist_entry(struct rb_root *root,
-						   struct hist_entry *he,
-						   u64 min_callchain_hits)
+static void __hists__insert_output_entry(struct rb_root *entries,
+					 struct hist_entry *he,
+					 u64 min_callchain_hits)
 {
-	struct rb_node **p = &root->rb_node;
+	struct rb_node **p = &entries->rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 
@@ -217,10 +216,10 @@ static void perf_session__insert_output_hist_entry(struct rb_root *root,
 	}
 
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, root);
+	rb_insert_color(&he->rb_node, entries);
 }
 
-u64 perf_session__output_resort(struct rb_root *hists, u64 total_samples)
+u64 hists__output_resort(struct hists *self)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
@@ -228,23 +227,21 @@ u64 perf_session__output_resort(struct rb_root *hists, u64 total_samples)
 	u64 min_callchain_hits;
 	u64 nr_hists = 0;
 
-	min_callchain_hits =
-		total_samples * (callchain_param.min_percent / 100);
+	min_callchain_hits = self->stats.total * (callchain_param.min_percent / 100);
 
 	tmp = RB_ROOT;
-	next = rb_first(hists);
+	next = rb_first(&self->entries);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, hists);
-		perf_session__insert_output_hist_entry(&tmp, n,
-						       min_callchain_hits);
+		rb_erase(&n->rb_node, &self->entries);
+		__hists__insert_output_entry(&tmp, n, min_callchain_hits);
 		++nr_hists;
 	}
 
-	*hists = tmp;
+	self->entries = tmp;
 	return nr_hists;
 }
 
@@ -500,12 +497,9 @@ static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 	return ret;
 }
 
-int hist_entry__snprintf(struct hist_entry *self,
-			   char *s, size_t size,
-			   struct perf_session *pair_session,
-			   bool show_displacement,
-			   long displacement, bool color,
-			   u64 session_total)
+int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
+			 struct hists *pair_hists, bool show_displacement,
+			 long displacement, bool color, u64 session_total)
 {
 	struct sort_entry *se;
 	u64 count, total, count_sys, count_us, count_guest_sys, count_guest_us;
@@ -515,9 +509,9 @@ int hist_entry__snprintf(struct hist_entry *self,
 	if (symbol_conf.exclude_other && !self->parent)
 		return 0;
 
-	if (pair_session) {
+	if (pair_hists) {
 		count = self->pair ? self->pair->count : 0;
-		total = pair_session->events_stats.total;
+		total = pair_hists->stats.total;
 		count_sys = self->pair ? self->pair->count_sys : 0;
 		count_us = self->pair ? self->pair->count_us : 0;
 		count_guest_sys = self->pair ? self->pair->count_guest_sys : 0;
@@ -569,7 +563,7 @@ int hist_entry__snprintf(struct hist_entry *self,
 			ret += snprintf(s + ret, size - ret, "%11lld", count);
 	}
 
-	if (pair_session) {
+	if (pair_hists) {
 		char bf[32];
 		double old_percent = 0, new_percent = 0, diff;
 
@@ -615,14 +609,12 @@ int hist_entry__snprintf(struct hist_entry *self,
 	return ret;
 }
 
-int hist_entry__fprintf(struct hist_entry *self,
-			struct perf_session *pair_session,
-			bool show_displacement,
-			long displacement, FILE *fp,
+int hist_entry__fprintf(struct hist_entry *self, struct hists *pair_hists,
+			bool show_displacement, long displacement, FILE *fp,
 			u64 session_total)
 {
 	char bf[512];
-	hist_entry__snprintf(self, bf, sizeof(bf), pair_session,
+	hist_entry__snprintf(self, bf, sizeof(bf), pair_hists,
 			     show_displacement, displacement,
 			     true, session_total);
 	return fprintf(fp, "%s\n", bf);
@@ -644,10 +636,8 @@ static size_t hist_entry__fprintf_callchain(struct hist_entry *self, FILE *fp,
 					     left_margin);
 }
 
-size_t perf_session__fprintf_hists(struct rb_root *hists,
-				   struct perf_session *pair,
-				   bool show_displacement, FILE *fp,
-				   u64 session_total)
+size_t hists__fprintf(struct hists *self, struct hists *pair,
+		      bool show_displacement, FILE *fp)
 {
 	struct sort_entry *se;
 	struct rb_node *nd;
@@ -753,7 +743,7 @@ size_t perf_session__fprintf_hists(struct rb_root *hists,
 	fprintf(fp, "\n#\n");
 
 print_entries:
-	for (nd = rb_first(hists); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (show_displacement) {
@@ -765,10 +755,10 @@ print_entries:
 			++position;
 		}
 		ret += hist_entry__fprintf(h, pair, show_displacement,
-					   displacement, fp, session_total);
+					   displacement, fp, self->stats.total);
 
 		if (symbol_conf.use_callchain)
-			ret += hist_entry__fprintf_callchain(h, fp, session_total);
+			ret += hist_entry__fprintf_callchain(h, fp, self->stats.total);
 
 		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(&h->thread->mg,
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index b49013a..bdde81e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -6,34 +6,40 @@
 
 extern struct callchain_param callchain_param;
 
-struct perf_session;
 struct hist_entry;
 struct addr_location;
 struct symbol;
 struct rb_root;
 
-struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
-						  struct addr_location *al,
-						  struct symbol *parent,
-						  u64 count);
+struct events_stats {
+	u64 total;
+	u64 lost;
+};
+
+struct hists {
+	struct rb_node		rb_node;
+	struct rb_root		entries;
+	struct events_stats	stats;
+	u64			config;
+	u64			event_stream;
+	u32			type;
+};
+
+struct hist_entry *__hists__add_entry(struct hists *self,
+				      struct addr_location *al,
+				      struct symbol *parent, u64 count);
 extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
-int hist_entry__fprintf(struct hist_entry *self,
-			   struct perf_session *pair_session,
-			   bool show_displacement,
-			   long displacement, FILE *fp,
-			   u64 session_total);
-int hist_entry__snprintf(struct hist_entry *self,
-			 char *bf, size_t size,
-			 struct perf_session *pair_session,
-			 bool show_displacement, long displacement,
-			 bool color, u64 session_total);
+int hist_entry__fprintf(struct hist_entry *self, struct hists *pair_hists,
+			bool show_displacement, long displacement, FILE *fp,
+			u64 total);
+int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
+			 struct hists *pair_hists, bool show_displacement,
+			 long displacement, bool color, u64 total);
 void hist_entry__free(struct hist_entry *);
 
-u64 perf_session__output_resort(struct rb_root *hists, u64 total_samples);
-void perf_session__collapse_resort(struct rb_root *hists);
-size_t perf_session__fprintf_hists(struct rb_root *hists,
-				   struct perf_session *pair,
-				   bool show_displacement, FILE *fp,
-				   u64 session_total);
+u64 hists__output_resort(struct hists *self);
+void hists__collapse_resort(struct hists *self);
+size_t hists__fprintf(struct hists *self, struct hists *pair,
+		      bool show_displacement, FILE *fp);
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4130036..72a7f6a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -89,7 +89,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 
 	memcpy(self->filename, filename, len);
 	self->threads = RB_ROOT;
-	self->stats_by_id = RB_ROOT;
+	self->hists_tree = RB_ROOT;
 	self->last_match = NULL;
 	self->mmap_window = 32;
 	self->cwd = NULL;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 242d528..46190f9 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -1,6 +1,7 @@
 #ifndef __PERF_SESSION_H
 #define __PERF_SESSION_H
 
+#include "hist.h"
 #include "event.h"
 #include "header.h"
 #include "symbol.h"
@@ -28,11 +29,16 @@ struct perf_session {
 	struct thread		*last_match;
 	struct machine		host_machine;
 	struct rb_root		machines;
-	struct events_stats	events_stats;
-	struct rb_root		stats_by_id;
+	struct rb_root		hists_tree;
 	unsigned long		event_total[PERF_RECORD_MAX];
 	unsigned long		unknown_events;
-	struct rb_root		hists;
+	/*
+	 * FIXME: should point to the first entry in hists_tree and
+	 *        be a hists instance. Right now its only 'report'
+	 *        that is using ->hists_tree while all the rest use
+	 *        ->hists.
+	 */
+	struct hists		hists;
 	u64			sample_type;
 	int			fd;
 	bool			fd_pipe;
-- 
1.6.2.5

