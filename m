Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1BHWJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:09:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:38297 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab1BHWJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:09:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/3] perf annotate: Move locking to struct annotation
Date: Tue,  8 Feb 2011 20:09:19 -0200
Message-Id: <1297202960-15269-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297202960-15269-1-git-send-email-acme@infradead.org>
References: <1297202960-15269-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since we'll need it when implementing the live annotate TUI browser.

This also simplifies things a bit by having the list head for the source
code to be in the dynamicly allocated part of struct annotation, that
way we don't have to pass it around, it can be found from the struct
symbol that is passed everywhere.

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
 tools/perf/builtin-annotate.c          |   14 +++--
 tools/perf/builtin-report.c            |    5 +-
 tools/perf/builtin-top.c               |   67 +++++++++++++------------
 tools/perf/util/annotate.c             |   85 ++++++++++++++++++-------------
 tools/perf/util/annotate.h             |   34 ++++++++-----
 tools/perf/util/hist.c                 |    5 +-
 tools/perf/util/hist.h                 |    3 +-
 tools/perf/util/top.h                  |    6 --
 tools/perf/util/ui/browsers/annotate.c |   18 +++---
 9 files changed, 126 insertions(+), 111 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index ea6a116..4271829 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -62,7 +62,8 @@ static int hists__add_entry(struct hists *self, struct addr_location *al)
 		 * All aggregated on the first sym_hist.
 		 */
 		struct annotation *notes = symbol__annotation(he->ms.sym);
-		if (notes->histograms == NULL && symbol__alloc_hist(he->ms.sym, 1) < 0)
+		if (notes->src == NULL &&
+		    symbol__alloc_hist(he->ms.sym, 1) < 0)
 			return -ENOMEM;
 
 		return hist_entry__inc_addr_samples(he, 0, al->addr);
@@ -77,7 +78,8 @@ static int process_sample_event(union perf_event *event,
 {
 	struct addr_location al;
 
-	if (perf_event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
+	if (perf_event__preprocess_sample(event, session, &al, sample,
+					  symbol__annotate_init) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
@@ -111,7 +113,7 @@ static void hists__find_annotations(struct hists *self)
 			goto find_next;
 
 		notes = symbol__annotation(he->ms.sym);
-		if (notes->histograms == NULL) {
+		if (notes->src == NULL) {
 find_next:
 			if (key == KEY_LEFT)
 				nd = rb_prev(nd);
@@ -142,11 +144,11 @@ find_next:
 			nd = rb_next(nd);
 			/*
 			 * Since we have a hist_entry per IP for the same
-			 * symbol, free he->ms.sym->histogram to signal we already
+			 * symbol, free he->ms.sym->src to signal we already
 			 * processed this symbol.
 			 */
-			free(notes->histograms);
-			notes->histograms = NULL;
+			free(notes->src);
+			notes->src = NULL;
 		}
 	}
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index de06bf5..f403ace 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -123,7 +123,7 @@ static int perf_session__add_hist_entry(struct perf_session *session,
 		 * All aggregated on the first sym_hist.
 		 */
 		struct annotation *notes = symbol__annotation(he->ms.sym);
-		if (notes->histograms == NULL &&
+		if (notes->src == NULL &&
 		    symbol__alloc_hist(he->ms.sym, 1) < 0)
 			err = -ENOMEM;
 		else
@@ -166,7 +166,8 @@ static int process_sample_event(union perf_event *event,
 	struct addr_location al;
 	struct perf_event_attr *attr;
 
-	if (perf_event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
+	if (perf_event__preprocess_sample(event, session, &al, sample,
+					  symbol__annotate_init) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b790673..7dbf22d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -139,7 +139,7 @@ static void sig_winch_handler(int sig __used)
 static int parse_source(struct sym_entry *syme)
 {
 	struct symbol *sym;
-	struct sym_entry_source *source;
+	struct annotation *notes;
 	struct map *map;
 	int err = -1;
 
@@ -152,39 +152,35 @@ static int parse_source(struct sym_entry *syme)
 	/*
 	 * We can't annotate with just /proc/kallsyms
 	 */
-	if (map->dso->origin == DSO__ORIG_KERNEL)
+	if (map->dso->origin == DSO__ORIG_KERNEL) {
+		pr_err("Can't annotate %s: No vmlinux file was found in the "
+		       "path\n", sym->name);
+		sleep(1);
 		return -1;
-
-	if (syme->src == NULL) {
-		syme->src = zalloc(sizeof(*source));
-		if (syme->src == NULL)
-			return -1;
-		pthread_mutex_init(&syme->src->lock, NULL);
-		INIT_LIST_HEAD(&syme->src->head);
 	}
 
-	source = syme->src;
-
-	if (symbol__annotation(sym)->histograms != NULL) {
-		pthread_mutex_lock(&source->lock);
+	notes = symbol__annotation(sym);
+	if (notes->src != NULL) {
+		pthread_mutex_lock(&notes->lock);
 		goto out_assign;
 	}
 
-	pthread_mutex_lock(&source->lock);
+	pthread_mutex_lock(&notes->lock);
 
 	if (symbol__alloc_hist(sym, top.evlist->nr_entries) < 0) {
 		pr_err("Not enough memory for annotating '%s' symbol!\n",
 		       sym->name);
+		sleep(1);
 		goto out_unlock;
 	}
 
-	err = symbol__annotate(sym, syme->map, &source->head, 0);
+	err = symbol__annotate(sym, syme->map, 0);
 	if (err == 0) {
 out_assign:
 	sym_filter_entry = syme;
 	}
 out_unlock:
-	pthread_mutex_unlock(&source->lock);
+	pthread_mutex_unlock(&notes->lock);
 	return err;
 }
 
@@ -196,20 +192,27 @@ static void __zero_source_counters(struct sym_entry *syme)
 
 static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
 {
+	struct annotation *notes;
+	struct symbol *sym;
+
 	if (syme != sym_filter_entry)
 		return;
 
-	if (pthread_mutex_trylock(&syme->src->lock))
+	sym = sym_entry__symbol(syme);
+	notes = symbol__annotation(sym);
+
+	if (pthread_mutex_trylock(&notes->lock))
 		return;
 
 	ip = syme->map->map_ip(syme->map, ip);
-	symbol__inc_addr_samples(sym_entry__symbol(syme), syme->map, counter, ip);
+	symbol__inc_addr_samples(sym, syme->map, counter, ip);
 
-	pthread_mutex_unlock(&syme->src->lock);
+	pthread_mutex_unlock(&notes->lock);
 }
 
 static void show_details(struct sym_entry *syme)
 {
+	struct annotation *notes;
 	struct symbol *symbol;
 	int more;
 
@@ -217,24 +220,26 @@ static void show_details(struct sym_entry *syme)
 		return;
 
 	symbol = sym_entry__symbol(syme);
-	if (!syme->src || symbol__annotation(symbol)->histograms == NULL)
-		return;
+	notes = symbol__annotation(symbol);
+
+	pthread_mutex_lock(&notes->lock);
+
+	if (notes->src == NULL)
+		goto out_unlock;
 
 	printf("Showing %s for %s\n", event_name(top.sym_evsel), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
 
-	pthread_mutex_lock(&syme->src->lock);
-	more = symbol__annotate_printf(symbol, syme->map, &syme->src->head,
-				       top.sym_evsel->idx, 0, sym_pcnt_filter,
-				       top.print_entries);
+	more = symbol__annotate_printf(symbol, syme->map, top.sym_evsel->idx,
+				       0, sym_pcnt_filter, top.print_entries);
 	if (top.zero)
 		symbol__annotate_zero_histogram(symbol, top.sym_evsel->idx);
 	else
-		symbol__annotate_decay_histogram(symbol, &syme->src->head,
-						 top.sym_evsel->idx);
-	pthread_mutex_unlock(&syme->src->lock);
+		symbol__annotate_decay_histogram(symbol, top.sym_evsel->idx);
 	if (more != 0)
 		printf("%d lines not displayed, maybe increase display entries [e]\n", more);
+out_unlock:
+	pthread_mutex_unlock(&notes->lock);
 }
 
 static const char		CONSOLE_CLEAR[] = "[H[2J";
@@ -372,10 +377,8 @@ static void prompt_symbol(struct sym_entry **target, const char *msg)
 
 	/* zero counters of active symbol */
 	if (syme) {
-		pthread_mutex_lock(&syme->src->lock);
 		__zero_source_counters(syme);
 		*target = NULL;
-		pthread_mutex_unlock(&syme->src->lock);
 	}
 
 	fprintf(stdout, "\n%s: ", msg);
@@ -554,10 +557,8 @@ static void handle_keypress(struct perf_session *session, int c)
 			else {
 				struct sym_entry *syme = sym_filter_entry;
 
-				pthread_mutex_lock(&syme->src->lock);
 				sym_filter_entry = NULL;
 				__zero_source_counters(syme);
-				pthread_mutex_unlock(&syme->src->lock);
 			}
 			break;
 		case 'U':
@@ -653,7 +654,7 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 
 	syme = symbol__priv(sym);
 	syme->map = map;
-	syme->src = NULL;
+	symbol__annotate_init(map, sym);
 
 	if (!sym_filter_entry && sym_filter && !strcmp(name, sym_filter)) {
 		/* schedule initial sym_filter_entry setup */
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 6db4351..c777bda 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -14,25 +14,39 @@
 #include "symbol.h"
 #include "debug.h"
 #include "annotate.h"
+#include <pthread.h>
 
-int symbol__alloc_hist(struct symbol *sym, int nevents)
+int symbol__annotate_init(struct map *map __used, struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
+	pthread_mutex_init(&notes->lock, NULL);
+	return 0;
+}
 
-	notes->sizeof_sym_hist = (sizeof(*notes->histograms) +
+int symbol__alloc_hist(struct symbol *sym, int nevents)
+{
+	struct annotation *notes = symbol__annotation(sym);
+	size_t sizeof_sym_hist = (sizeof(struct sym_hist) +
 				  (sym->end - sym->start) * sizeof(u64));
-	notes->histograms = calloc(nevents, notes->sizeof_sym_hist);
-	notes->nr_histograms = nevents;
-	return notes->histograms == NULL ? -1 : 0;
+
+	notes->src = zalloc(sizeof(*notes->src) + nevents * sizeof_sym_hist);
+	if (notes->src == NULL)
+		return -1;
+	notes->src->sizeof_sym_hist = sizeof_sym_hist;
+	notes->src->nr_histograms   = nevents;
+	INIT_LIST_HEAD(&notes->src->source);
+	return 0;
 }
 
 void symbol__annotate_zero_histograms(struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
 
-	if (notes->histograms != NULL)
-		memset(notes->histograms, 0,
-		       notes->nr_histograms * notes->sizeof_sym_hist);
+	pthread_mutex_lock(&notes->lock);
+	if (notes->src != NULL)
+		memset(notes->src->histograms, 0,
+		       notes->src->nr_histograms * notes->src->sizeof_sym_hist);
+	pthread_mutex_unlock(&notes->lock);
 }
 
 int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
@@ -43,7 +57,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 	struct sym_hist *h;
 
 	notes = symbol__annotation(sym);
-	if (notes->histograms == NULL)
+	if (notes->src == NULL)
 		return -ENOMEM;
 
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
@@ -95,8 +109,7 @@ struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
 	return NULL;
 }
 
-static int objdump_line__print(struct objdump_line *oline,
-			       struct list_head *head, struct symbol *sym,
+static int objdump_line__print(struct objdump_line *oline, struct symbol *sym,
 			       int evidx, u64 len, int min_pcnt,
 			       int printed, int max_lines)
 {
@@ -109,10 +122,12 @@ static int objdump_line__print(struct objdump_line *oline,
 		double percent = 0.0;
 		const char *color;
 		struct annotation *notes = symbol__annotation(sym);
-		struct source_line *src_line = notes->src_line;
+		struct source_line *src_line = notes->src->lines;
 		struct sym_hist *h = annotation__histogram(notes, evidx);
 		s64 offset = oline->offset;
-		struct objdump_line *next = objdump__get_next_ip_line(head, oline);
+		struct objdump_line *next;
+
+		next = objdump__get_next_ip_line(&notes->src->source, oline);
 
 		while (offset < (s64)len &&
 		       (next == NULL || offset < next->offset)) {
@@ -166,9 +181,10 @@ static int objdump_line__print(struct objdump_line *oline,
 	return 0;
 }
 
-static int symbol__parse_objdump_line(struct symbol *sym, struct map *map, FILE *file,
-				      struct list_head *head, size_t privsize)
+static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
+				      FILE *file, size_t privsize)
 {
+	struct annotation *notes = symbol__annotation(sym);
 	struct objdump_line *objdump_line;
 	char *line = NULL, *tmp, *tmp2, *c;
 	size_t line_len;
@@ -222,13 +238,12 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map, FILE
 		free(line);
 		return -1;
 	}
-	objdump__add_line(head, objdump_line);
+	objdump__add_line(&notes->src->source, objdump_line);
 
 	return 0;
 }
 
-int symbol__annotate(struct symbol *sym, struct map *map,
-		     struct list_head *head, size_t privsize)
+int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 {
 	struct dso *dso = map->dso;
 	char *filename = dso__build_id_filename(dso, NULL, 0);
@@ -297,7 +312,7 @@ fallback:
 		goto out_free_filename;
 
 	while (!feof(file))
-		if (symbol__parse_objdump_line(sym, map, file, head, privsize) < 0)
+		if (symbol__parse_objdump_line(sym, map, file, privsize) < 0)
 			break;
 
 	pclose(file);
@@ -330,14 +345,14 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 static void symbol__free_source_line(struct symbol *sym, int len)
 {
 	struct annotation *notes = symbol__annotation(sym);
-	struct source_line *src_line = notes->src_line;
+	struct source_line *src_line = notes->src->lines;
 	int i;
 
 	for (i = 0; i < len; i++)
 		free(src_line[i].path);
 
 	free(src_line);
-	notes->src_line = NULL;
+	notes->src->lines = NULL;
 }
 
 /* Get the filename:line for the colored entries */
@@ -355,8 +370,8 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	if (!h->sum)
 		return 0;
 
-	src_line = notes->src_line = calloc(len, sizeof(struct source_line));
-	if (!notes->src_line)
+	src_line = notes->src->lines = calloc(len, sizeof(struct source_line));
+	if (!notes->src->lines)
 		return -1;
 
 	start = map->unmap_ip(map, sym->start);
@@ -436,12 +451,12 @@ static void symbol__annotate_hits(struct symbol *sym, int evidx)
 	printf("%*s: %" PRIu64 "\n", BITS_PER_LONG / 2, "h->sum", h->sum);
 }
 
-int symbol__annotate_printf(struct symbol *sym, struct map *map,
-			    struct list_head *head, int evidx, bool full_paths,
-			    int min_pcnt, int max_lines)
+int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
+			    bool full_paths, int min_pcnt, int max_lines)
 {
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name, *d_filename;
+	struct annotation *notes = symbol__annotation(sym);
 	struct objdump_line *pos;
 	int printed = 2;
 	int more = 0;
@@ -460,8 +475,8 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 	if (verbose)
 		symbol__annotate_hits(sym, evidx);
 
-	list_for_each_entry(pos, head, node) {
-		switch (objdump_line__print(pos, head, sym, evidx, len, min_pcnt,
+	list_for_each_entry(pos, &notes->src->source, node) {
+		switch (objdump_line__print(pos, sym, evidx, len, min_pcnt,
 					    printed, max_lines)) {
 		case 0:
 			++printed;
@@ -485,11 +500,10 @@ void symbol__annotate_zero_histogram(struct symbol *sym, int evidx)
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
 
-	memset(h, 0, notes->sizeof_sym_hist);
+	memset(h, 0, notes->src->sizeof_sym_hist);
 }
 
-void symbol__annotate_decay_histogram(struct symbol *sym,
-				      struct list_head *head, int evidx)
+void symbol__annotate_decay_histogram(struct symbol *sym, int evidx)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
@@ -497,7 +511,7 @@ void symbol__annotate_decay_histogram(struct symbol *sym,
 
 	h->sum = 0;
 
-	list_for_each_entry(pos, head, node) {
+	list_for_each_entry(pos, &notes->src->source, node) {
 		if (pos->offset != -1) {
 			h->addr[pos->offset] = h->addr[pos->offset] * 7 / 8;
 			h->sum += h->addr[pos->offset];
@@ -522,10 +536,9 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name;
 	struct rb_root source_line = RB_ROOT;
-	LIST_HEAD(head);
 	u64 len;
 
-	if (symbol__annotate(sym, map, &head, 0) < 0)
+	if (symbol__annotate(sym, map, 0) < 0)
 		return -1;
 
 	len = sym->end - sym->start;
@@ -536,12 +549,12 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 		print_summary(&source_line, filename);
 	}
 
-	symbol__annotate_printf(sym, map, &head, evidx, full_paths,
+	symbol__annotate_printf(sym, map, evidx, full_paths,
 				min_pcnt, max_lines);
 	if (print_lines)
 		symbol__free_source_line(sym, len);
 
-	objdump_line_list__purge(&head);
+	objdump_line_list__purge(&symbol__annotation(sym)->src->source);
 
 	return 0;
 }
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index bc08b36..b237c86 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -28,22 +28,29 @@ struct source_line {
 	char		*path;
 };
 
-/** struct annotation - symbols with hits have this attached as in sannotation
+/** struct annotated_source - symbols with hits have this attached as in sannotation
  *
  * @histogram: Array of addr hit histograms per event being monitored
- * @src_line: If 'print_lines' is specified, per source code line percentages
+ * @lines: If 'print_lines' is specified, per source code line percentages
+ * @source: source parsed from objdump -dS
  *
- * src_line is allocated, percentages calculated and all sorted by percentage
+ * lines is allocated, percentages calculated and all sorted by percentage
  * when the annotation is about to be presented, so the percentages are for
  * one of the entries in the histogram array, i.e. for the event/counter being
  * presented. It is deallocated right after symbol__{tui,tty,etc}_annotate
  * returns.
  */
-struct annotation {
-	struct source_line *src_line;
-	struct sym_hist	   *histograms;
+struct annotated_source {
+	struct list_head   source;
+	struct source_line *lines;
 	int    		   nr_histograms;
 	int    		   sizeof_sym_hist;
+	struct sym_hist	   histograms[0];
+};
+
+struct annotation {
+	pthread_mutex_t		lock;
+	struct annotated_source *src;
 };
 
 struct sannotation {
@@ -53,7 +60,8 @@ struct sannotation {
 
 static inline struct sym_hist *annotation__histogram(struct annotation *notes, int idx)
 {
-	return ((void *)notes->histograms) + (notes->sizeof_sym_hist * idx);
+	return (((void *)&notes->src->histograms) +
+	 	(notes->src->sizeof_sym_hist * idx));
 }
 
 static inline struct annotation *symbol__annotation(struct symbol *sym)
@@ -67,14 +75,12 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 int symbol__alloc_hist(struct symbol *sym, int nevents);
 void symbol__annotate_zero_histograms(struct symbol *sym);
 
-int symbol__annotate(struct symbol *sym, struct map *map,
-		     struct list_head *head, size_t privsize);
-int symbol__annotate_printf(struct symbol *sym, struct map *map,
-			    struct list_head *head, int evidx, bool full_paths,
-			    int min_pcnt, int max_lines);
+int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize);
+int symbol__annotate_init(struct map *map __used, struct symbol *sym);
+int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
+			    bool full_paths, int min_pcnt, int max_lines);
 void symbol__annotate_zero_histogram(struct symbol *sym, int evidx);
-void symbol__annotate_decay_histogram(struct symbol *sym,
-				      struct list_head *head, int evidx);
+void symbol__annotate_decay_histogram(struct symbol *sym, int evidx);
 void objdump_line_list__purge(struct list_head *head);
 
 int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index bac5ab6..3f43723 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -955,10 +955,9 @@ int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 ip)
 	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, evidx, ip);
 }
 
-int hist_entry__annotate(struct hist_entry *he, struct list_head *head,
-			 size_t privsize)
+int hist_entry__annotate(struct hist_entry *he, size_t privsize)
 {
-	return symbol__annotate(he->ms.sym, he->ms.map, head, privsize);
+	return symbol__annotate(he->ms.sym, he->ms.map, privsize);
 }
 
 void hists__inc_nr_events(struct hists *self, u32 type)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2c6cdae..37c7908 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -78,8 +78,7 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 		      bool show_displacement, FILE *fp);
 
 int hist_entry__inc_addr_samples(struct hist_entry *self, int evidx, u64 addr);
-int hist_entry__annotate(struct hist_entry *self, struct list_head *head,
-			 size_t privsize);
+int hist_entry__annotate(struct hist_entry *self, size_t privsize);
 
 void hists__filter_by_dso(struct hists *self, const struct dso *dso);
 void hists__filter_by_thread(struct hists *self, const struct thread *thread);
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 62e3293..4f769f4 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -11,11 +11,6 @@
 struct perf_evlist;
 struct perf_evsel;
 
-struct sym_entry_source {
-	struct list_head	head;
-	pthread_mutex_t		lock;
-};
-
 struct sym_entry {
 	struct rb_node		rb_node;
 	struct list_head	node;
@@ -24,7 +19,6 @@ struct sym_entry {
 	int			skip;
 	u8			origin;
 	struct map		*map;
-	struct sym_entry_source	*src;
 	unsigned long		count[0];
 };
 
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 8d8a168..1aa3965 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -60,7 +60,6 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 }
 
 static double objdump_line__calc_percent(struct objdump_line *self,
-					 struct list_head *head,
 					 struct symbol *sym, int evidx)
 {
 	double percent = 0.0;
@@ -69,11 +68,12 @@ static double objdump_line__calc_percent(struct objdump_line *self,
 		int len = sym->end - sym->start;
 		unsigned int hits = 0;
 		struct annotation *notes = symbol__annotation(sym);
-		struct source_line *src_line = notes->src_line;
+		struct source_line *src_line = notes->src->lines;
 		struct sym_hist *h = annotation__histogram(notes, evidx);
 		s64 offset = self->offset;
-		struct objdump_line *next = objdump__get_next_ip_line(head, self);
+		struct objdump_line *next;
 
+		next = objdump__get_next_ip_line(&notes->src->source, self);
 		while (offset < (s64)len &&
 		       (next == NULL || offset < next->offset)) {
 			if (src_line) {
@@ -192,10 +192,10 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx)
 {
 	struct objdump_line *pos, *n;
 	struct objdump_line_rb_node *rbpos;
-	LIST_HEAD(head);
+	struct annotation *notes = symbol__annotation(sym);
 	struct annotate_browser browser = {
 		.b = {
-			.entries = &head,
+			.entries = &notes->src->source,
 			.refresh = ui_browser__list_head_refresh,
 			.seek	 = ui_browser__list_head_seek,
 			.write	 = annotate_browser__write,
@@ -210,20 +210,20 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx)
 	if (map->dso->annotate_warned)
 		return -1;
 
-	if (symbol__annotate(sym, map, &head, sizeof(*rbpos)) < 0) {
+	if (symbol__annotate(sym, map, sizeof(*rbpos)) < 0) {
 		ui__error_window(ui_helpline__last_msg);
 		return -1;
 	}
 
 	ui_helpline__push("Press <- or ESC to exit");
 
-	list_for_each_entry(pos, &head, node) {
+	list_for_each_entry(pos, &notes->src->source, node) {
 		size_t line_len = strlen(pos->line);
 		if (browser.b.width < line_len)
 			browser.b.width = line_len;
 		rbpos = objdump_line__rb(pos);
 		rbpos->idx = browser.b.nr_entries++;
-		rbpos->percent = objdump_line__calc_percent(pos, &head, sym, evidx);
+		rbpos->percent = objdump_line__calc_percent(pos, sym, evidx);
 		if (rbpos->percent < 0.01)
 			continue;
 		objdump__insert_line(&browser.entries, rbpos);
@@ -238,7 +238,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx)
 
 	browser.b.width += 18; /* Percentage */
 	ret = annotate_browser__run(&browser);
-	list_for_each_entry_safe(pos, n, &head, node) {
+	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
 		objdump_line__free(pos);
 	}
-- 
1.6.2.5

