Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1BGAoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 19:44:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab1BGAn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 19:43:57 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/6] perf annotate: Support multiple histograms in annotation
Date: Sun,  6 Feb 2011 22:42:14 -0200
Message-Id: <1297039337-6690-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297039337-6690-1-git-send-email-acme@infradead.org>
References: <1297039337-6690-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The perf annotate tool continues aggregating everything on just one
histograms, but to support the top model add support for one histogram
perf evsel in the evlist.

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
 tools/perf/builtin-annotate.c          |   29 ++++++++++++----
 tools/perf/builtin-report.c            |   15 +++++++--
 tools/perf/util/annotate.c             |   57 +++++++++++++++-----------------
 tools/perf/util/annotate.h             |   29 +++++++++++++---
 tools/perf/util/hist.c                 |    4 +-
 tools/perf/util/hist.h                 |   16 +++++----
 tools/perf/util/ui/browsers/annotate.c |   12 +++---
 tools/perf/util/ui/browsers/hists.c    |    9 +++--
 8 files changed, 106 insertions(+), 65 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 9072ef4..f3e4423 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -57,7 +57,18 @@ static int hists__add_entry(struct hists *self, struct addr_location *al)
 	if (he == NULL)
 		return -ENOMEM;
 
-	return hist_entry__inc_addr_samples(he, al->addr);
+	if (he->ms.sym != NULL) {
+		/*
+		 * All aggregated on the first sym_hist.
+		 */
+		struct annotation *notes = symbol__annotation(he->ms.sym);
+		if (notes->histograms == NULL && symbol__alloc_hist(he->ms.sym, 1) < 0)
+			return -ENOMEM;
+
+		return hist_entry__inc_addr_samples(he, 0, al->addr);
+	}
+
+	return 0;
 }
 
 static int process_sample_event(union perf_event *event,
@@ -81,9 +92,9 @@ static int process_sample_event(union perf_event *event,
 	return 0;
 }
 
-static int hist_entry__tty_annotate(struct hist_entry *he)
+static int hist_entry__tty_annotate(struct hist_entry *he, int evidx)
 {
-	return symbol__tty_annotate(he->ms.sym, he->ms.map,
+	return symbol__tty_annotate(he->ms.sym, he->ms.map, evidx,
 				    print_line, full_paths);
 }
 
@@ -100,7 +111,7 @@ static void hists__find_annotations(struct hists *self)
 			goto find_next;
 
 		notes = symbol__annotation(he->ms.sym);
-		if (notes->histogram == NULL) {
+		if (notes->histograms == NULL) {
 find_next:
 			if (key == KEY_LEFT)
 				nd = rb_prev(nd);
@@ -110,7 +121,8 @@ find_next:
 		}
 
 		if (use_browser > 0) {
-			key = hist_entry__tui_annotate(he);
+			/* For now all is aggregated on the first */
+			key = hist_entry__tui_annotate(he, 0);
 			switch (key) {
 			case KEY_RIGHT:
 				next = rb_next(nd);
@@ -125,15 +137,16 @@ find_next:
 			if (next != NULL)
 				nd = next;
 		} else {
-			hist_entry__tty_annotate(he);
+			/* For now all is aggregated on the first */
+			hist_entry__tty_annotate(he, 0);
 			nd = rb_next(nd);
 			/*
 			 * Since we have a hist_entry per IP for the same
 			 * symbol, free he->ms.sym->histogram to signal we already
 			 * processed this symbol.
 			 */
-			free(notes->histogram);
-			notes->histogram = NULL;
+			free(notes->histograms);
+			notes->histograms = NULL;
 		}
 	}
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 91e4cdb..de06bf5 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -118,8 +118,17 @@ static int perf_session__add_hist_entry(struct perf_session *session,
 	 * so we don't allocated the extra space needed because the stdio
 	 * code will not use it.
 	 */
-	if (use_browser > 0)
-		err = hist_entry__inc_addr_samples(he, al->addr);
+	if (al->sym != NULL && use_browser > 0) {
+		/*
+		 * All aggregated on the first sym_hist.
+		 */
+		struct annotation *notes = symbol__annotation(he->ms.sym);
+		if (notes->histograms == NULL &&
+		    symbol__alloc_hist(he->ms.sym, 1) < 0)
+			err = -ENOMEM;
+		else
+			err = hist_entry__inc_addr_samples(he, 0, al->addr);
+	}
 
 	return err;
 }
@@ -349,7 +358,7 @@ static int __cmd_report(void)
 	}
 
 	if (use_browser > 0)
-		hists__tui_browse_tree(&session->hists_tree, help);
+		hists__tui_browse_tree(&session->hists_tree, help, 0);
 	else
 		hists__tty_browse_tree(&session->hists_tree, help);
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 9b25575..7488fe9 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -15,44 +15,40 @@
 #include "debug.h"
 #include "annotate.h"
 
-static int symbol__alloc_hist(struct symbol *sym)
+int symbol__alloc_hist(struct symbol *sym, int nevents)
 {
 	struct annotation *notes = symbol__annotation(sym);
-	const int size = (sizeof(*notes->histogram) +
-			  (sym->end - sym->start) * sizeof(u64));
 
-	notes->histogram = zalloc(size);
-	return notes->histogram == NULL ? -1 : 0;
+	notes->sizeof_sym_hist = (sizeof(*notes->histograms) +
+				  (sym->end - sym->start) * sizeof(u64));
+	notes->histograms = calloc(nevents, notes->sizeof_sym_hist);
+	return notes->histograms == NULL ? -1 : 0;
 }
 
-int symbol__inc_addr_samples(struct symbol *sym, struct map *map, u64 addr)
+int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
+			     int evidx, u64 addr)
 {
-	unsigned int sym_size, offset;
+	unsigned offset;
 	struct annotation *notes;
 	struct sym_hist *h;
 
-	if (!sym || !map)
-		return 0;
-
 	notes = symbol__annotation(sym);
-	if (notes->histogram == NULL && symbol__alloc_hist(sym) < 0)
+	if (notes->histograms == NULL)
 		return -ENOMEM;
 
-	sym_size = sym->end - sym->start;
-	offset = addr - sym->start;
-
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
-	if (offset >= sym_size)
+	if (addr >= sym->end)
 		return 0;
 
-	h = notes->histogram;
+	offset = addr - sym->start;
+	h = annotation__histogram(notes, evidx);
 	h->sum++;
 	h->addr[offset]++;
 
 	pr_debug3("%#" PRIx64 " %s: period++ [addr: %#" PRIx64 ", %#" PRIx64
-		  "] => %" PRIu64 "\n", sym->start, sym->name,
-		  addr, addr - sym->start, h->addr[offset]);
+		  ", evidx=%d] => %" PRIu64 "\n", sym->start, sym->name,
+		  addr, addr - sym->start, evidx, h->addr[offset]);
 	return 0;
 }
 
@@ -90,8 +86,8 @@ struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
 }
 
 static void objdump_line__print(struct objdump_line *oline,
-				struct list_head *head,
-				struct symbol *sym, u64 len)
+				struct list_head *head, struct symbol *sym,
+				int evidx, u64 len)
 {
 	static const char *prev_line;
 	static const char *prev_color;
@@ -103,7 +99,7 @@ static void objdump_line__print(struct objdump_line *oline,
 		const char *color;
 		struct annotation *notes = symbol__annotation(sym);
 		struct source_line *src_line = notes->src_line;
-		struct sym_hist *h = notes->histogram;
+		struct sym_hist *h = annotation__histogram(notes, evidx);
 		s64 offset = oline->offset;
 		struct objdump_line *next = objdump__get_next_ip_line(head, oline);
 
@@ -328,7 +324,7 @@ static void symbol__free_source_line(struct symbol *sym, int len)
 
 /* Get the filename:line for the colored entries */
 static int symbol__get_source_line(struct symbol *sym, struct map *map,
-				   struct rb_root *root, int len,
+				   int evidx, struct rb_root *root, int len,
 				   const char *filename)
 {
 	u64 start;
@@ -336,7 +332,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	char cmd[PATH_MAX * 2];
 	struct source_line *src_line;
 	struct annotation *notes = symbol__annotation(sym);
-	struct sym_hist *h = notes->histogram;
+	struct sym_hist *h = annotation__histogram(notes, evidx);
 
 	if (!h->sum)
 		return 0;
@@ -409,10 +405,10 @@ static void print_summary(struct rb_root *root, const char *filename)
 	}
 }
 
-static void symbol__annotate_hits(struct symbol *sym)
+static void symbol__annotate_hits(struct symbol *sym, int evidx)
 {
 	struct annotation *notes = symbol__annotation(sym);
-	struct sym_hist *h = notes->histogram;
+	struct sym_hist *h = annotation__histogram(notes, evidx);
 	u64 len = sym->end - sym->start, offset;
 
 	for (offset = 0; offset < len; ++offset)
@@ -422,8 +418,8 @@ static void symbol__annotate_hits(struct symbol *sym)
 	printf("%*s: %" PRIu64 "\n", BITS_PER_LONG / 2, "h->sum", h->sum);
 }
 
-int symbol__tty_annotate(struct symbol *sym, struct map *map, bool print_lines,
-			 bool full_paths)
+int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
+			 bool print_lines, bool full_paths)
 {
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name, *d_filename;
@@ -443,7 +439,8 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, bool print_lines,
 	len = sym->end - sym->start;
 
 	if (print_lines) {
-		symbol__get_source_line(sym, map, &source_line, len, filename);
+		symbol__get_source_line(sym, map, evidx, &source_line,
+					len, filename);
 		print_summary(&source_line, filename);
 	}
 
@@ -452,10 +449,10 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, bool print_lines,
 	printf("------------------------------------------------\n");
 
 	if (verbose)
-		symbol__annotate_hits(sym);
+		symbol__annotate_hits(sym, evidx);
 
 	list_for_each_entry_safe(pos, n, &head, node) {
-		objdump_line__print(pos, &head, sym, len);
+		objdump_line__print(pos, &head, sym, evidx, len);
 		list_del(&pos->node);
 		objdump_line__free(pos);
 	}
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 6e2fbc2..0a5069c 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -28,9 +28,21 @@ struct source_line {
 	char		*path;
 };
 
+/** struct annotation - symbols with hits have this attached as in sannotation
+ *
+ * @histogram: Array of addr hit histograms per event being monitored
+ * @src_line: If 'print_lines' is specified, per source code line percentages
+ *
+ * src_line is allocated, percentages calculated and all sorted by percentage
+ * when the annotation is about to be presented, so the percentages are for
+ * one of the entries in the histogram array, i.e. for the event/counter being
+ * presented. It is deallocated right after symbol__{tui,tty,etc}_annotate
+ * returns.
+ */
 struct annotation {
-	struct sym_hist	   *histogram;
 	struct source_line *src_line;
+	struct sym_hist	   *histograms;
+	int    		   sizeof_sym_hist;
 };
 
 struct sannotation {
@@ -38,28 +50,35 @@ struct sannotation {
 	struct symbol	  symbol;
 };
 
+static inline struct sym_hist *annotation__histogram(struct annotation *notes, int idx)
+{
+	return ((void *)notes->histograms) + (notes->sizeof_sym_hist * idx);
+}
+
 static inline struct annotation *symbol__annotation(struct symbol *sym)
 {
 	struct sannotation *a = container_of(sym, struct sannotation, symbol);
 	return &a->annotation;
 }
 
-int symbol__inc_addr_samples(struct symbol *sym, struct map *map, u64 addr);
+int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
+			     int evidx, u64 addr);
+int symbol__alloc_hist(struct symbol *sym, int nevents);
 
 int symbol__annotate(struct symbol *sym, struct map *map,
 		     struct list_head *head, size_t privsize);
 
-int symbol__tty_annotate(struct symbol *sym, struct map *map,
+int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 bool print_lines, bool full_paths);
 
 #ifdef NO_NEWT_SUPPORT
 static inline int symbol__tui_annotate(symbol *sym __used,
-				       struct map *map __used)
+				       struct map *map __used, int evidx __used)
 {
 	return 0;
 }
 #else
-int symbol__tui_annotate(struct symbol *sym, struct map *map);
+int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx);
 #endif
 
 #endif	/* __PERF_ANNOTATE_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6d9c92c..bac5ab6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -950,9 +950,9 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread)
 	}
 }
 
-int hist_entry__inc_addr_samples(struct hist_entry *he, u64 ip)
+int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 ip)
 {
-	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, ip);
+	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, evidx, ip);
 }
 
 int hist_entry__annotate(struct hist_entry *he, struct list_head *head,
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8a201f7..2c6cdae 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -77,7 +77,7 @@ size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
 size_t hists__fprintf(struct hists *self, struct hists *pair,
 		      bool show_displacement, FILE *fp);
 
-int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip);
+int hist_entry__inc_addr_samples(struct hist_entry *self, int evidx, u64 addr);
 int hist_entry__annotate(struct hist_entry *self, struct list_head *head,
 			 size_t privsize);
 
@@ -91,18 +91,20 @@ bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len);
 #ifdef NO_NEWT_SUPPORT
 static inline int hists__browse(struct hists *self __used,
 				const char *helpline __used,
-				const char *ev_name __used)
+				const char *ev_name __used, int evidx __used)
 {
 	return 0;
 }
 
 static inline int hists__tui_browse_tree(struct rb_root *self __used,
-					 const char *help __used)
+					 const char *help __used,
+					 int evidx __used)
 {
 	return 0;
 }
 
-static inline int hist_entry__tui_annotate(struct hist_entry *self __used)
+static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
+					   int evidx __used)
 {
 	return 0;
 }
@@ -111,13 +113,13 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self __used)
 #else
 #include <newt.h>
 int hists__browse(struct hists *self, const char *helpline,
-		  const char *ev_name);
-int hist_entry__tui_annotate(struct hist_entry *self);
+		  const char *ev_name, int evidx);
+int hist_entry__tui_annotate(struct hist_entry *self, int evidx);
 
 #define KEY_LEFT NEWT_KEY_LEFT
 #define KEY_RIGHT NEWT_KEY_RIGHT
 
-int hists__tui_browse_tree(struct rb_root *self, const char *help);
+int hists__tui_browse_tree(struct rb_root *self, const char *help, int evidx);
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index daa7138..8d8a168 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -61,7 +61,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 
 static double objdump_line__calc_percent(struct objdump_line *self,
 					 struct list_head *head,
-					 struct symbol *sym)
+					 struct symbol *sym, int evidx)
 {
 	double percent = 0.0;
 
@@ -70,7 +70,7 @@ static double objdump_line__calc_percent(struct objdump_line *self,
 		unsigned int hits = 0;
 		struct annotation *notes = symbol__annotation(sym);
 		struct source_line *src_line = notes->src_line;
-		struct sym_hist *h = notes->histogram;
+		struct sym_hist *h = annotation__histogram(notes, evidx);
 		s64 offset = self->offset;
 		struct objdump_line *next = objdump__get_next_ip_line(head, self);
 
@@ -183,12 +183,12 @@ out:
 	return key;
 }
 
-int hist_entry__tui_annotate(struct hist_entry *he)
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx)
 {
-	return symbol__tui_annotate(he->ms.sym, he->ms.map);
+	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx);
 }
 
-int symbol__tui_annotate(struct symbol *sym, struct map *map)
+int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx)
 {
 	struct objdump_line *pos, *n;
 	struct objdump_line_rb_node *rbpos;
@@ -223,7 +223,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map)
 			browser.b.width = line_len;
 		rbpos = objdump_line__rb(pos);
 		rbpos->idx = browser.b.nr_entries++;
-		rbpos->percent = objdump_line__calc_percent(pos, &head, sym);
+		rbpos->percent = objdump_line__calc_percent(pos, &head, sym, evidx);
 		if (rbpos->percent < 0.01)
 			continue;
 		objdump__insert_line(&browser.entries, rbpos);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 8642823..294b495 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -797,7 +797,8 @@ static int hists__browser_title(struct hists *self, char *bf, size_t size,
 	return printed;
 }
 
-int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
+int hists__browse(struct hists *self, const char *helpline,
+		  const char *ev_name, int evidx)
 {
 	struct hist_browser *browser = hist_browser__new(self);
 	struct pstack *fstack;
@@ -935,7 +936,7 @@ do_annotate:
 			if (he == NULL)
 				continue;
 
-			hist_entry__tui_annotate(he);
+			hist_entry__tui_annotate(he, evidx);
 		} else if (choice == browse_map)
 			map__browse(browser->selection->map);
 		else if (choice == zoom_dso) {
@@ -984,7 +985,7 @@ out:
 	return key;
 }
 
-int hists__tui_browse_tree(struct rb_root *self, const char *help)
+int hists__tui_browse_tree(struct rb_root *self, const char *help, int evidx)
 {
 	struct rb_node *first = rb_first(self), *nd = first, *next;
 	int key = 0;
@@ -993,7 +994,7 @@ int hists__tui_browse_tree(struct rb_root *self, const char *help)
 		struct hists *hists = rb_entry(nd, struct hists, rb_node);
 		const char *ev_name = __event_name(hists->type, hists->config);
 
-		key = hists__browse(hists, help, ev_name);
+		key = hists__browse(hists, help, ev_name, evidx);
 		switch (key) {
 		case NEWT_KEY_TAB:
 			next = rb_next(nd);
-- 
1.6.2.5

