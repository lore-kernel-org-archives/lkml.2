Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1CFUtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:49:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab1CFUsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:48:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 5/6] perf tools: Improve support for sessions with multiple events
Date: Sun,  6 Mar 2011 17:48:26 -0300
Message-Id: <1299444507-26549-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1299444507-26549-1-git-send-email-acme@infradead.org>
References: <1299444507-26549-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

By creating an perf_evlist out of the attributes in the perf.data file
header, so that we can use evlists and evsels when reading recorded
sessions in addition to when we record sessions.

More work is needed to allow tools to allow the user to select which
events are wanted when browsing sessions, be it just one or a subset of
them, aggregated or showed at the same time but with different
indications on the UI to allow seeing workloads thru different views at
the same time.

But the overall goal/trend is to more uniformly use evsels and evlists.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c       |   80 +++++++++++++----
 tools/perf/builtin-report.c         |  160 +++++++++++------------------------
 tools/perf/util/evsel.h             |    2 +
 tools/perf/util/header.c            |   31 -------
 tools/perf/util/header.h            |    2 -
 tools/perf/util/hist.c              |    6 +-
 tools/perf/util/hist.h              |   12 +--
 tools/perf/util/session.c           |   63 ++++++++++++++-
 tools/perf/util/session.h           |   16 ++--
 tools/perf/util/ui/browsers/hists.c |   32 ++++---
 10 files changed, 208 insertions(+), 196 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4271829..695de4b 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -19,6 +19,8 @@
 #include "perf.h"
 #include "util/debug.h"
 
+#include "util/evlist.h"
+#include "util/evsel.h"
 #include "util/annotate.h"
 #include "util/event.h"
 #include "util/parse-options.h"
@@ -38,9 +40,13 @@ static bool		print_line;
 
 static const char *sym_hist_filter;
 
-static int hists__add_entry(struct hists *self, struct addr_location *al)
+static int perf_evlist__add_sample(struct perf_evlist *evlist,
+				   struct perf_sample *sample,
+				   struct addr_location *al)
 {
+	struct perf_evsel *evsel;
 	struct hist_entry *he;
+	int ret;
 
 	if (sym_hist_filter != NULL &&
 	    (al->sym == NULL || strcmp(sym_hist_filter, al->sym->name) != 0)) {
@@ -53,23 +59,35 @@ static int hists__add_entry(struct hists *self, struct addr_location *al)
 		return 0;
 	}
 
-	he = __hists__add_entry(self, al, NULL, 1);
+	evsel = perf_evlist__id2evsel(evlist, sample->id);
+	if (evsel == NULL) {
+		/*
+		 * FIXME: Propagate this back, but at least we're in a builtin,
+		 * where exit() is allowed. ;-)
+		 */
+		ui__warning("Invalid %s file, contains samples with id not in "
+			    "its header!\n", input_name);
+		exit_browser(0);
+		exit(1);
+	}
+
+	he = __hists__add_entry(&evsel->hists, al, NULL, 1);
 	if (he == NULL)
 		return -ENOMEM;
 
+	ret = 0;
 	if (he->ms.sym != NULL) {
-		/*
-		 * All aggregated on the first sym_hist.
-		 */
 		struct annotation *notes = symbol__annotation(he->ms.sym);
 		if (notes->src == NULL &&
-		    symbol__alloc_hist(he->ms.sym, 1) < 0)
+		    symbol__alloc_hist(he->ms.sym, evlist->nr_entries) < 0)
 			return -ENOMEM;
 
-		return hist_entry__inc_addr_samples(he, 0, al->addr);
+		ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 	}
 
-	return 0;
+	evsel->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	return ret;
 }
 
 static int process_sample_event(union perf_event *event,
@@ -85,7 +103,7 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
-	if (!al.filtered && hists__add_entry(&session->hists, &al)) {
+	if (!al.filtered && perf_evlist__add_sample(session->evlist, sample, &al)) {
 		pr_warning("problem incrementing symbol count, "
 			   "skipping event\n");
 		return -1;
@@ -100,7 +118,7 @@ static int hist_entry__tty_annotate(struct hist_entry *he, int evidx)
 				    print_line, full_paths, 0, 0);
 }
 
-static void hists__find_annotations(struct hists *self)
+static void hists__find_annotations(struct hists *self, int evidx)
 {
 	struct rb_node *nd = rb_first(&self->entries), *next;
 	int key = KEY_RIGHT;
@@ -123,8 +141,7 @@ find_next:
 		}
 
 		if (use_browser > 0) {
-			/* For now all is aggregated on the first */
-			key = hist_entry__tui_annotate(he, 0);
+			key = hist_entry__tui_annotate(he, evidx);
 			switch (key) {
 			case KEY_RIGHT:
 				next = rb_next(nd);
@@ -139,8 +156,7 @@ find_next:
 			if (next != NULL)
 				nd = next;
 		} else {
-			/* For now all is aggregated on the first */
-			hist_entry__tty_annotate(he, 0);
+			hist_entry__tty_annotate(he, evidx);
 			nd = rb_next(nd);
 			/*
 			 * Since we have a hist_entry per IP for the same
@@ -166,6 +182,8 @@ static int __cmd_annotate(void)
 {
 	int ret;
 	struct perf_session *session;
+	struct perf_evsel *pos;
+	u64 total_nr_samples;
 
 	session = perf_session__new(input_name, O_RDONLY, force, false, &event_ops);
 	if (session == NULL)
@@ -186,12 +204,36 @@ static int __cmd_annotate(void)
 	if (verbose > 2)
 		perf_session__fprintf_dsos(session, stdout);
 
-	hists__collapse_resort(&session->hists);
-	hists__output_resort(&session->hists);
-	hists__find_annotations(&session->hists);
-out_delete:
-	perf_session__delete(session);
+	total_nr_samples = 0;
+	list_for_each_entry(pos, &session->evlist->entries, node) {
+		struct hists *hists = &pos->hists;
+		u32 nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
+
+		if (nr_samples > 0) {
+			total_nr_samples += nr_samples;
+			hists__collapse_resort(hists);
+			hists__output_resort(hists);
+			hists__find_annotations(hists, pos->idx);
+		}
+	}
 
+	if (total_nr_samples == 0) {
+		ui__warning("The %s file has no samples!\n", input_name);
+		goto out_delete;
+	}
+out_delete:
+	/*
+	 * Speed up the exit process, for large files this can
+	 * take quite a while.
+	 *
+	 * XXX Enable this when using valgrind or if we ever
+	 * librarize this command.
+	 *
+	 * Also experiment with obstacks to see how much speed
+	 * up we'll get here.
+	 *
+	 * perf_session__delete(session);
+	 */
 	return ret;
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index dddcc7e..1c399ea 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -21,6 +21,8 @@
 
 #include "perf.h"
 #include "util/debug.h"
+#include "util/evlist.h"
+#include "util/evsel.h"
 #include "util/header.h"
 #include "util/session.h"
 
@@ -46,39 +48,6 @@ static const char	*pretty_printing_style = default_pretty_printing_style;
 static char		callchain_default_opt[] = "fractal,0.5";
 static symbol_filter_t	annotate_init;
 
-static struct hists *perf_session__hists_findnew(struct perf_session *self,
-						 u64 event_stream, u32 type,
-						 u64 config)
-{
-	struct rb_node **p = &self->hists_tree.rb_node;
-	struct rb_node *parent = NULL;
-	struct hists *iter, *new;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct hists, rb_node);
-		if (iter->config == config)
-			return iter;
-
-
-		if (config > iter->config)
-			p = &(*p)->rb_right;
-		else
-			p = &(*p)->rb_left;
-	}
-
-	new = malloc(sizeof(struct hists));
-	if (new == NULL)
-		return NULL;
-	memset(new, 0, sizeof(struct hists));
-	new->event_stream = event_stream;
-	new->config = config;
-	new->type = type;
-	rb_link_node(&new->rb_node, parent, p);
-	rb_insert_color(&new->rb_node, &self->hists_tree);
-	return new;
-}
-
 static int perf_session__add_hist_entry(struct perf_session *session,
 					struct addr_location *al,
 					struct perf_sample *sample)
@@ -86,8 +55,7 @@ static int perf_session__add_hist_entry(struct perf_session *session,
 	struct symbol *parent = NULL;
 	int err = 0;
 	struct hist_entry *he;
-	struct hists *hists;
-	struct perf_event_attr *attr;
+	struct perf_evsel *evsel;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
 		err = perf_session__resolve_callchain(session, al->thread,
@@ -96,15 +64,19 @@ static int perf_session__add_hist_entry(struct perf_session *session,
 			return err;
 	}
 
-	attr = perf_header__find_attr(sample->id, &session->header);
-	if (attr)
-		hists = perf_session__hists_findnew(session, sample->id, attr->type, attr->config);
-	else
-		hists = perf_session__hists_findnew(session, sample->id, 0, 0);
-	if (hists == NULL)
-		return -ENOMEM;
+	evsel = perf_evlist__id2evsel(session->evlist, sample->id);
+	if (evsel == NULL) {
+		/*
+		 * FIXME: Propagate this back, but at least we're in a builtin,
+		 * where exit() is allowed. ;-)
+		 */
+		ui__warning("Invalid %s file, contains samples with id not in "
+			    "its header!\n", input_name);
+		exit_browser(0);
+		exit(1);
+	}
 
-	he = __hists__add_entry(hists, al, parent, sample->period);
+	he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -120,52 +92,30 @@ static int perf_session__add_hist_entry(struct perf_session *session,
 	 * code will not use it.
 	 */
 	if (al->sym != NULL && use_browser > 0) {
-		/*
-		 * All aggregated on the first sym_hist.
-		 */
 		struct annotation *notes = symbol__annotation(he->ms.sym);
+
+		assert(evsel != NULL);
+
+		err = -ENOMEM;
 		if (notes->src == NULL &&
-		    symbol__alloc_hist(he->ms.sym, 1) < 0)
-			err = -ENOMEM;
-		else
-			err = hist_entry__inc_addr_samples(he, 0, al->addr);
+		    symbol__alloc_hist(he->ms.sym, session->evlist->nr_entries) < 0)
+			goto out;
+
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 	}
 
+	evsel->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+out:
 	return err;
 }
 
-static int add_event_total(struct perf_session *session,
-			   struct perf_sample *sample,
-			   struct perf_event_attr *attr)
-{
-	struct hists *hists;
-
-	if (attr)
-		hists = perf_session__hists_findnew(session, sample->id,
-						    attr->type, attr->config);
-	else
-		hists = perf_session__hists_findnew(session, sample->id, 0, 0);
-
-	if (!hists)
-		return -ENOMEM;
-
-	hists->stats.total_period += sample->period;
-	/*
-	 * FIXME: add_event_total should be moved from here to
-	 * perf_session__process_event so that the proper hist is passed to
-	 * the event_op methods.
-	 */
-	hists__inc_nr_events(hists, PERF_RECORD_SAMPLE);
-	session->hists.stats.total_period += sample->period;
-	return 0;
-}
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct addr_location al;
-	struct perf_event_attr *attr;
 
 	if (perf_event__preprocess_sample(event, session, &al, sample,
 					  annotate_init) < 0) {
@@ -182,27 +132,17 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
-	attr = perf_header__find_attr(sample->id, &session->header);
-
-	if (add_event_total(session, sample, attr)) {
-		pr_debug("problem adding event period\n");
-		return -1;
-	}
-
 	return 0;
 }
 
 static int process_read_event(union perf_event *event,
 			      struct perf_sample *sample __used,
-			      struct perf_session *session __used)
+			      struct perf_session *session)
 {
-	struct perf_event_attr *attr;
-
-	attr = perf_header__find_attr(event->read.id, &session->header);
-
+	struct perf_evsel *evsel = perf_evlist__id2evsel(session->evlist,
+							 event->read.id);
 	if (show_threads) {
-		const char *name = attr ? __event_name(attr->type, attr->config)
-				   : "unknown";
+		const char *name = evsel ? event_name(evsel) : "unknown";
 		perf_read_values_add_value(&show_threads_values,
 					   event->read.pid, event->read.tid,
 					   event->read.id,
@@ -211,7 +151,7 @@ static int process_read_event(union perf_event *event,
 	}
 
 	dump_printf(": %d %d %s %" PRIu64 "\n", event->read.pid, event->read.tid,
-		    attr ? __event_name(attr->type, attr->config) : "FAIL",
+		    evsel ? event_name(evsel) : "FAIL",
 		    event->read.value);
 
 	return 0;
@@ -282,21 +222,20 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	return ret + fprintf(fp, "\n#\n");
 }
 
-static int hists__tty_browse_tree(struct rb_root *tree, const char *help)
+static int hists__tty_browse_tree(struct perf_evlist *evlist, const char *help)
 {
-	struct rb_node *next = rb_first(tree);
+	struct perf_evsel *pos;
 
-	while (next) {
-		struct hists *hists = rb_entry(next, struct hists, rb_node);
+	list_for_each_entry(pos, &evlist->entries, node) {
+		struct hists *hists = &pos->hists;
 		const char *evname = NULL;
 
 		if (rb_first(&hists->entries) != rb_last(&hists->entries))
-			evname = __event_name(hists->type, hists->config);
+			evname = event_name(pos);
 
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
 		hists__fprintf(hists, NULL, false, stdout);
 		fprintf(stdout, "\n\n");
-		next = rb_next(&hists->rb_node);
 	}
 
 	if (sort_order == default_sort_order &&
@@ -317,8 +256,9 @@ static int hists__tty_browse_tree(struct rb_root *tree, const char *help)
 static int __cmd_report(void)
 {
 	int ret = -EINVAL;
+	u64 nr_samples;
 	struct perf_session *session;
-	struct rb_node *next;
+	struct perf_evsel *pos;
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 
 	signal(SIGINT, sig_handler);
@@ -349,26 +289,24 @@ static int __cmd_report(void)
 	if (verbose > 2)
 		perf_session__fprintf_dsos(session, stdout);
 
-	next = rb_first(&session->hists_tree);
-
-	if (next == NULL) {
-		ui__warning("The %s file has no samples!\n", input_name);
-		goto out_delete;
-	}
-
-	while (next) {
-		struct hists *hists;
+	nr_samples = 0;
+	list_for_each_entry(pos, &session->evlist->entries, node) {
+		struct hists *hists = &pos->hists;
 
-		hists = rb_entry(next, struct hists, rb_node);
 		hists__collapse_resort(hists);
 		hists__output_resort(hists);
-		next = rb_next(&hists->rb_node);
+		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
+	}
+
+	if (nr_samples == 0) {
+		ui__warning("The %s file has no samples!\n", input_name);
+		goto out_delete;
 	}
 
 	if (use_browser > 0)
-		hists__tui_browse_tree(&session->hists_tree, help, 0);
+		hists__tui_browse_tree(session->evlist, help);
 	else
-		hists__tty_browse_tree(&session->hists_tree, help);
+		hists__tty_browse_tree(session->evlist, help);
 
 out_delete:
 	/*
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index f6fc8f6..281b60e 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -7,6 +7,7 @@
 #include "types.h"
 #include "xyarray.h"
 #include "cgroup.h"
+#include "hist.h"
  
 struct perf_counts_values {
 	union {
@@ -51,6 +52,7 @@ struct perf_evsel {
 	struct xyarray		*id;
 	struct perf_counts	*counts;
 	int			idx;
+	struct hists		hists;
 	char			*name;
 	void			*priv;
 	struct cgroup_sel	*cgrp;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 72c124d..108b0db 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -969,37 +969,6 @@ bool perf_header__sample_id_all(const struct perf_header *header)
 	return value;
 }
 
-struct perf_event_attr *
-perf_header__find_attr(u64 id, struct perf_header *header)
-{
-	int i;
-
-	/*
-	 * We set id to -1 if the data file doesn't contain sample
-	 * ids. This can happen when the data file contains one type
-	 * of event and in that case, the header can still store the
-	 * event attribute information. Check for this and avoid
-	 * walking through the entire list of ids which may be large.
-	 */
-	if (id == -1ULL) {
-		if (header->attrs > 0)
-			return &header->attr[0]->attr;
-		return NULL;
-	}
-
-	for (i = 0; i < header->attrs; i++) {
-		struct perf_header_attr *attr = header->attr[i];
-		int j;
-
-		for (j = 0; j < attr->ids; j++) {
-			if (attr->id[j] == id)
-				return &attr->attr;
-		}
-	}
-
-	return NULL;
-}
-
 int perf_event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
 				perf_event__handler_t process,
 				struct perf_session *session)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index f042ceb..2fab133 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -85,8 +85,6 @@ int perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 
 u64 perf_header__sample_type(struct perf_header *header);
 bool perf_header__sample_id_all(const struct perf_header *header);
-struct perf_event_attr *
-perf_header__find_attr(u64 id, struct perf_header *header);
 void perf_header__set_feat(struct perf_header *self, int feat);
 void perf_header__clear_feat(struct perf_header *self, int feat);
 bool perf_header__has_feat(const struct perf_header *self, int feat);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f7ad6bd..627a02e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -984,8 +984,12 @@ size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
 	size_t ret = 0;
 
 	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
-		const char *name = perf_event__name(i);
+		const char *name;
 
+		if (self->stats.nr_events[i] == 0)
+			continue;
+
+		name = perf_event__name(i);
 		if (!strcmp(name, "UNKNOWN"))
 			continue;
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 37c7908..0d38b43 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -42,13 +42,10 @@ enum hist_column {
 };
 
 struct hists {
-	struct rb_node		rb_node;
 	struct rb_root		entries;
 	u64			nr_entries;
 	struct events_stats	stats;
-	u64			config;
 	u64			event_stream;
-	u32			type;
 	u16			col_len[HISTC_NR_COLS];
 	/* Best would be to reuse the session callchain cursor */
 	struct callchain_cursor	callchain_cursor;
@@ -87,6 +84,8 @@ u16 hists__col_len(struct hists *self, enum hist_column col);
 void hists__set_col_len(struct hists *self, enum hist_column col, u16 len);
 bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len);
 
+struct perf_evlist;
+
 #ifdef NO_NEWT_SUPPORT
 static inline int hists__browse(struct hists *self __used,
 				const char *helpline __used,
@@ -95,9 +94,8 @@ static inline int hists__browse(struct hists *self __used,
 	return 0;
 }
 
-static inline int hists__tui_browse_tree(struct rb_root *self __used,
-					 const char *help __used,
-					 int evidx __used)
+static inline int hists__tui_browse_tree(struct perf_evlist *evlist __used,
+					 const char *help __used)
 {
 	return 0;
 }
@@ -118,7 +116,7 @@ int hist_entry__tui_annotate(struct hist_entry *self, int evidx);
 #define KEY_LEFT NEWT_KEY_LEFT
 #define KEY_RIGHT NEWT_KEY_RIGHT
 
-int hists__tui_browse_tree(struct rb_root *self, const char *help, int evidx);
+int hists__tui_browse_tree(struct perf_evlist *evlist, const char *help);
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a3a871f..0d41419 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -7,10 +7,52 @@
 #include <sys/types.h>
 #include <sys/mman.h>
 
+#include "evlist.h"
+#include "evsel.h"
 #include "session.h"
 #include "sort.h"
 #include "util.h"
 
+static int perf_session__read_evlist(struct perf_session *session)
+{
+	int i, j;
+
+	session->evlist = perf_evlist__new(NULL, NULL);
+	if (session->evlist == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < session->header.attrs; ++i) {
+		struct perf_header_attr *hattr = session->header.attr[i];
+		struct perf_evsel *evsel = perf_evsel__new(&hattr->attr, i);
+
+		if (evsel == NULL)
+			goto out_delete_evlist;
+		/*
+		 * Do it before so that if perf_evsel__alloc_id fails, this
+		 * entry gets purged too at perf_evlist__delete().
+		 */
+		perf_evlist__add(session->evlist, evsel);
+		/*
+		 * We don't have the cpu and thread maps on the header, so
+		 * for allocating the perf_sample_id table we fake 1 cpu and
+		 * hattr->ids threads.
+		 */
+		if (perf_evsel__alloc_id(evsel, 1, hattr->ids))
+			goto out_delete_evlist;
+
+		for (j = 0; j < hattr->ids; ++j)
+			perf_evlist__id_hash(session->evlist, evsel, 0, j,
+					     hattr->id[j]);
+	}
+
+	return 0;
+
+out_delete_evlist:
+	perf_evlist__delete(session->evlist);
+	session->evlist = NULL;
+	return -ENOMEM;
+}
+
 static int perf_session__open(struct perf_session *self, bool force)
 {
 	struct stat input_stat;
@@ -56,6 +98,11 @@ static int perf_session__open(struct perf_session *self, bool force)
 		goto out_close;
 	}
 
+	if (perf_session__read_evlist(self) < 0) {
+		pr_err("Not enough memory to read the event selector list\n");
+		goto out_close;
+	}
+
 	self->size = input_stat.st_size;
 	return 0;
 
@@ -141,7 +188,6 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	memcpy(self->filename, filename, len);
 	self->threads = RB_ROOT;
 	INIT_LIST_HEAD(&self->dead_threads);
-	self->hists_tree = RB_ROOT;
 	self->last_match = NULL;
 	/*
 	 * On 64bit we can mmap the data file in one go. No need for tiny mmap
@@ -1137,3 +1183,18 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
 	size_t ret = machine__fprintf_dsos_buildid(&self->host_machine, fp, with_hits);
 	return ret + machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
 }
+
+size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
+{
+	struct perf_evsel *pos;
+	size_t ret = fprintf(fp, "Aggregated stats:\n");
+
+	ret += hists__fprintf_nr_events(&session->hists, fp);
+
+	list_for_each_entry(pos, &session->evlist->entries, node) {
+		ret += fprintf(fp, "%s stats:\n", event_name(pos));
+		ret += hists__fprintf_nr_events(&pos->hists, fp);
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 977b3a1..05dd7bc 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -34,12 +34,12 @@ struct perf_session {
 	struct thread		*last_match;
 	struct machine		host_machine;
 	struct rb_root		machines;
-	struct rb_root		hists_tree;
+	struct perf_evlist	*evlist;
 	/*
-	 * FIXME: should point to the first entry in hists_tree and
-	 *        be a hists instance. Right now its only 'report'
-	 *        that is using ->hists_tree while all the rest use
-	 *        ->hists.
+	 * FIXME: Need to split this up further, we need global
+	 *	  stats + per event stats. 'perf diff' also needs
+	 *	  to properly support multiple events in a single
+	 *	  perf.data file.
 	 */
 	struct hists		hists;
 	u64			sample_type;
@@ -151,11 +151,7 @@ size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp);
 size_t perf_session__fprintf_dsos_buildid(struct perf_session *self,
 					  FILE *fp, bool with_hits);
 
-static inline
-size_t perf_session__fprintf_nr_events(struct perf_session *self, FILE *fp)
-{
-	return hists__fprintf_nr_events(&self->hists, fp);
-}
+size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp);
 
 static inline int perf_session__parse_sample(struct perf_session *session,
 					     const union perf_event *event,
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index c98e6f8..f3af4fe 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -7,6 +7,8 @@
 #include <newt.h>
 #include <linux/rbtree.h>
 
+#include "../../evsel.h"
+#include "../../evlist.h"
 #include "../../hist.h"
 #include "../../pstack.h"
 #include "../../sort.h"
@@ -987,31 +989,33 @@ out:
 	return key;
 }
 
-int hists__tui_browse_tree(struct rb_root *self, const char *help, int evidx)
+int hists__tui_browse_tree(struct perf_evlist *evlist, const char *help)
 {
-	struct rb_node *first = rb_first(self), *nd = first, *next;
-	int key = 0;
+	struct perf_evsel *pos;
 
-	while (nd) {
-		struct hists *hists = rb_entry(nd, struct hists, rb_node);
-		const char *ev_name = __event_name(hists->type, hists->config);
+	pos = list_entry(evlist->entries.next, struct perf_evsel, node);
+	while (pos) {
+		struct hists *hists = &pos->hists;
+		const char *ev_name = event_name(pos);
+		int key = hists__browse(hists, help, ev_name, pos->idx);
 
-		key = hists__browse(hists, help, ev_name, evidx);
 		switch (key) {
 		case NEWT_KEY_TAB:
-			next = rb_next(nd);
-			if (next)
-				nd = next;
+			if (pos->node.next == &evlist->entries)
+				pos = list_entry(evlist->entries.next, struct perf_evsel, node);
+			else
+				pos = list_entry(pos->node.next, struct perf_evsel, node);
 			break;
 		case NEWT_KEY_UNTAB:
-			if (nd == first)
-				continue;
-			nd = rb_prev(nd);
+			if (pos->node.prev == &evlist->entries)
+				pos = list_entry(evlist->entries.prev, struct perf_evsel, node);
+			else
+				pos = list_entry(pos->node.prev, struct perf_evsel, node);
 			break;
 		default:
 			return key;
 		}
 	}
 
-	return key;
+	return 0;
 }
-- 
1.6.2.5

