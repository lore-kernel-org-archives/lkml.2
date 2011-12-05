Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab1LEMxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:53:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56881 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab1LEMxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:53:16 -0500
Date: Mon, 5 Dec 2011 04:52:20 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-cwv8ysvpywzjq4v3xtbd4zwv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Add nr_events to symbol_conf
Git-Commit-ID: d04b35f8085f0d4c5c874515b8f65e7664357148
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:52:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d04b35f8085f0d4c5c874515b8f65e7664357148
Gitweb:     http://git.kernel.org/tip/d04b35f8085f0d4c5c874515b8f65e7664357148
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 Nov 2011 22:17:32 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:37:11 -0200

perf symbols: Add nr_events to symbol_conf

Since symbol__alloc_hists need it, to avoid passing it around in many
functions have it in the symbol_conf struct.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-cwv8ysvpywzjq4v3xtbd4zwv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c          |   22 ++++++++--------------
 tools/perf/builtin-report.c            |    3 +--
 tools/perf/builtin-top.c               |    7 ++++---
 tools/perf/util/annotate.c             |    6 +++---
 tools/perf/util/annotate.h             |    5 ++---
 tools/perf/util/header.c               |    2 ++
 tools/perf/util/hist.h                 |    3 +--
 tools/perf/util/symbol.h               |    1 +
 tools/perf/util/ui/browsers/annotate.c |   16 +++++++---------
 tools/perf/util/ui/browsers/hists.c    |    2 +-
 10 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 46b4c24..8b9091b 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -43,10 +43,9 @@ static const char *sym_hist_filter;
 static const char	*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
-static int perf_evlist__add_sample(struct perf_evlist *evlist,
-				   struct perf_sample *sample,
-				   struct perf_evsel *evsel,
-				   struct addr_location *al)
+static int perf_evsel__add_sample(struct perf_evsel *evsel,
+				  struct perf_sample *sample,
+				  struct addr_location *al)
 {
 	struct hist_entry *he;
 	int ret;
@@ -69,8 +68,7 @@ static int perf_evlist__add_sample(struct perf_evlist *evlist,
 	ret = 0;
 	if (he->ms.sym != NULL) {
 		struct annotation *notes = symbol__annotation(he->ms.sym);
-		if (notes->src == NULL &&
-		    symbol__alloc_hist(he->ms.sym, evlist->nr_entries) < 0)
+		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
 			return -ENOMEM;
 
 		ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
@@ -98,8 +96,7 @@ static int process_sample_event(union perf_event *event,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	if (!al.filtered &&
-	    perf_evlist__add_sample(session->evlist, sample, evsel, &al)) {
+	if (!al.filtered && perf_evsel__add_sample(evsel, sample, &al)) {
 		pr_warning("problem incrementing symbol count, "
 			   "skipping event\n");
 		return -1;
@@ -114,8 +111,7 @@ static int hist_entry__tty_annotate(struct hist_entry *he, int evidx)
 				    print_line, full_paths, 0, 0);
 }
 
-static void hists__find_annotations(struct hists *self, int evidx,
-				    int nr_events)
+static void hists__find_annotations(struct hists *self, int evidx)
 {
 	struct rb_node *nd = rb_first(&self->entries), *next;
 	int key = K_RIGHT;
@@ -138,8 +134,7 @@ find_next:
 		}
 
 		if (use_browser > 0) {
-			key = hist_entry__tui_annotate(he, evidx, nr_events,
-						       NULL, NULL, 0);
+			key = hist_entry__tui_annotate(he, evidx, NULL, NULL, 0);
 			switch (key) {
 			case K_RIGHT:
 				next = rb_next(nd);
@@ -217,8 +212,7 @@ static int __cmd_annotate(void)
 			total_nr_samples += nr_samples;
 			hists__collapse_resort(hists);
 			hists__output_resort(hists);
-			hists__find_annotations(hists, pos->idx,
-						session->evlist->nr_entries);
+			hists__find_annotations(hists, pos->idx);
 		}
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4d7c834..758a287 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -92,8 +92,7 @@ static int perf_session__add_hist_entry(struct perf_session *session,
 		assert(evsel != NULL);
 
 		err = -ENOMEM;
-		if (notes->src == NULL &&
-		    symbol__alloc_hist(he->ms.sym, session->evlist->nr_entries) < 0)
+		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
 			goto out;
 
 		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9cdedb..04288ee 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -170,7 +170,7 @@ static int parse_source(struct hist_entry *he)
 
 	pthread_mutex_lock(&notes->lock);
 
-	if (symbol__alloc_hist(sym, top.evlist->nr_entries) < 0) {
+	if (symbol__alloc_hist(sym) < 0) {
 		pthread_mutex_unlock(&notes->lock);
 		pr_err("Not enough memory for annotating '%s' symbol!\n",
 		       sym->name);
@@ -210,8 +210,7 @@ static void record_precise_ip(struct hist_entry *he, int counter, u64 ip)
 	if (pthread_mutex_trylock(&notes->lock))
 		return;
 
-	if (notes->src == NULL &&
-	    symbol__alloc_hist(sym, top.evlist->nr_entries) < 0) {
+	if (notes->src == NULL && symbol__alloc_hist(sym) < 0) {
 		pthread_mutex_unlock(&notes->lock);
 		pr_err("Not enough memory for annotating '%s' symbol!\n",
 		       sym->name);
@@ -1215,6 +1214,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		return -ENOMEM;
 	}
 
+	symbol_conf.nr_events = top.evlist->nr_entries;
+
 	if (top.delay_secs < 1)
 		top.delay_secs = 1;
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 119e996..376e643 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -25,17 +25,17 @@ int symbol__annotate_init(struct map *map __used, struct symbol *sym)
 	return 0;
 }
 
-int symbol__alloc_hist(struct symbol *sym, int nevents)
+int symbol__alloc_hist(struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	size_t sizeof_sym_hist = (sizeof(struct sym_hist) +
 				  (sym->end - sym->start) * sizeof(u64));
 
-	notes->src = zalloc(sizeof(*notes->src) + nevents * sizeof_sym_hist);
+	notes->src = zalloc(sizeof(*notes->src) + symbol_conf.nr_events * sizeof_sym_hist);
 	if (notes->src == NULL)
 		return -1;
 	notes->src->sizeof_sym_hist = sizeof_sym_hist;
-	notes->src->nr_histograms   = nevents;
+	notes->src->nr_histograms   = symbol_conf.nr_events;
 	INIT_LIST_HEAD(&notes->src->source);
 	return 0;
 }
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index d907252..efa5dc8 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -72,7 +72,7 @@ static inline struct annotation *symbol__annotation(struct symbol *sym)
 
 int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 			     int evidx, u64 addr);
-int symbol__alloc_hist(struct symbol *sym, int nevents);
+int symbol__alloc_hist(struct symbol *sym);
 void symbol__annotate_zero_histograms(struct symbol *sym);
 
 int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize);
@@ -99,8 +99,7 @@ static inline int symbol__tui_annotate(struct symbol *sym __used,
 }
 #else
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 int nr_events, void(*timer)(void *arg), void *arg,
-			 int delay_secs);
+			 void(*timer)(void *arg), void *arg, int delay_secs);
 #endif
 
 extern const char	*disassembler_style;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index bcd05d0..41424a1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2041,6 +2041,8 @@ int perf_session__read_header(struct perf_session *session, int fd)
 		lseek(fd, tmp, SEEK_SET);
 	}
 
+	symbol_conf.nr_events = nr_attrs;
+
 	if (f_header.event_types.size) {
 		lseek(fd, f_header.event_types.offset, SEEK_SET);
 		events = malloc(f_header.event_types.size);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c86c1d2..6676d55 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -119,7 +119,6 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __used,
 
 static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
 					   int evidx __used,
-					   int nr_events __used,
 					   void(*timer)(void *arg) __used,
 					   void *arg __used,
 					   int delay_secs __used)
@@ -130,7 +129,7 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
 #define K_RIGHT -2
 #else
 #include "ui/keysyms.h"
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx, int nr_events,
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
 			     void(*timer)(void *arg), void *arg, int delay_secs);
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 29f8d74..123c2e1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -68,6 +68,7 @@ struct strlist;
 
 struct symbol_conf {
 	unsigned short	priv_size;
+	unsigned short	nr_events;
 	bool		try_vmlinux_path,
 			use_modules,
 			sort_by_name,
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 0575905..295a9c9 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -224,7 +224,7 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 }
 
 static int annotate_browser__run(struct annotate_browser *self, int evidx,
-				 int nr_events, void(*timer)(void *arg),
+				 void(*timer)(void *arg),
 				 void *arg, int delay_secs)
 {
 	struct rb_node *nd = NULL;
@@ -328,8 +328,7 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				notes = symbol__annotation(target);
 				pthread_mutex_lock(&notes->lock);
 
-				if (notes->src == NULL &&
-				    symbol__alloc_hist(target, nr_events) < 0) {
+				if (notes->src == NULL && symbol__alloc_hist(target) < 0) {
 					pthread_mutex_unlock(&notes->lock);
 					ui__warning("Not enough memory for annotating '%s' symbol!\n",
 						    target->name);
@@ -337,7 +336,7 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				}
 
 				pthread_mutex_unlock(&notes->lock);
-				symbol__tui_annotate(target, ms->map, evidx, nr_events,
+				symbol__tui_annotate(target, ms->map, evidx,
 						     timer, arg, delay_secs);
 			}
 			continue;
@@ -358,15 +357,15 @@ out:
 	return key;
 }
 
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx, int nr_events,
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
 			     void(*timer)(void *arg), void *arg, int delay_secs)
 {
-	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx, nr_events,
+	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx,
 				    timer, arg, delay_secs);
 }
 
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 int nr_events, void(*timer)(void *arg), void *arg,
+			 void(*timer)(void *arg), void *arg,
 			 int delay_secs)
 {
 	struct objdump_line *pos, *n;
@@ -419,8 +418,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	browser.b.nr_entries = browser.nr_entries;
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
-	ret = annotate_browser__run(&browser, evidx, nr_events,
-				    timer, arg, delay_secs);
+	ret = annotate_browser__run(&browser, evidx, timer, arg, delay_secs);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
 		objdump_line__free(pos);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index d0c94b4..1212a38 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -1020,7 +1020,7 @@ do_annotate:
 			 * Don't let this be freed, say, by hists__decay_entry.
 			 */
 			he->used = true;
-			err = hist_entry__tui_annotate(he, evsel->idx, nr_events,
+			err = hist_entry__tui_annotate(he, evsel->idx,
 						       timer, arg, delay_secs);
 			he->used = false;
 			ui_browser__update_nr_entries(&browser->b, browser->hists->nr_entries);
