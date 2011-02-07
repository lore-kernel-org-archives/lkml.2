Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1BGH5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:57:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:33086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab1BGH5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:57:18 -0500
Date: Mon, 7 Feb 2011 07:56:35 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Ditch private annotation code, share perf annotate's
Message-ID: <tip-36532461a0f60bb36c5470a0326f7394f19db23c@git.kernel.org>
Git-Commit-ID: 36532461a0f60bb36c5470a0326f7394f19db23c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 07 Feb 2011 07:56:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36532461a0f60bb36c5470a0326f7394f19db23c
Gitweb:     http://git.kernel.org/tip/36532461a0f60bb36c5470a0326f7394f19db23c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sun, 6 Feb 2011 14:54:44 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 6 Feb 2011 16:08:50 -0200

perf top: Ditch private annotation code, share perf annotate's

Next step: Live TUI annotation in perf top, just press enter on a symbol
line.

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
 tools/perf/builtin-top.c   |  181 ++++++++------------------------------------
 tools/perf/util/annotate.c |   76 ++++++++++++++++---
 tools/perf/util/annotate.h |   11 ++-
 tools/perf/util/top.h      |   11 +---
 4 files changed, 106 insertions(+), 173 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 154e088..716118a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -20,6 +20,7 @@
 
 #include "perf.h"
 
+#include "util/annotate.h"
 #include "util/cache.h"
 #include "util/color.h"
 #include "util/evlist.h"
@@ -140,10 +141,7 @@ static int parse_source(struct sym_entry *syme)
 	struct symbol *sym;
 	struct sym_entry_source *source;
 	struct map *map;
-	FILE *file;
-	char command[PATH_MAX*2];
-	const char *path;
-	u64 len;
+	int err = -1;
 
 	if (!syme)
 		return -1;
@@ -162,197 +160,80 @@ static int parse_source(struct sym_entry *syme)
 		if (syme->src == NULL)
 			return -1;
 		pthread_mutex_init(&syme->src->lock, NULL);
+		INIT_LIST_HEAD(&syme->src->head);
 	}
 
 	source = syme->src;
 
-	if (source->lines) {
+	if (symbol__annotation(sym)->histograms != NULL) {
 		pthread_mutex_lock(&source->lock);
 		goto out_assign;
 	}
-	path = map->dso->long_name;
-
-	len = sym->end - sym->start;
-
-	sprintf(command,
-		"objdump --start-address=%#0*" PRIx64 " --stop-address=%#0*" PRIx64 " -dS %s",
-		BITS_PER_LONG / 4, map__rip_2objdump(map, sym->start),
-		BITS_PER_LONG / 4, map__rip_2objdump(map, sym->end), path);
-
-	file = popen(command, "r");
-	if (!file)
-		return -1;
 
 	pthread_mutex_lock(&source->lock);
-	source->lines_tail = &source->lines;
-	while (!feof(file)) {
-		struct source_line *src;
-		size_t dummy = 0;
-		char *c, *sep;
-
-		src = malloc(sizeof(struct source_line));
-		assert(src != NULL);
-		memset(src, 0, sizeof(struct source_line));
-
-		if (getline(&src->line, &dummy, file) < 0)
-			break;
-		if (!src->line)
-			break;
-
-		c = strchr(src->line, '\n');
-		if (c)
-			*c = 0;
 
-		src->next = NULL;
-		*source->lines_tail = src;
-		source->lines_tail = &src->next;
-
-		src->eip = strtoull(src->line, &sep, 16);
-		if (*sep == ':')
-			src->eip = map__objdump_2ip(map, src->eip);
-		else /* this line has no ip info (e.g. source line) */
-			src->eip = 0;
+	if (symbol__alloc_hist(sym, top.evlist->nr_entries) < 0) {
+		pr_err("Not enough memory for annotating '%s' symbol!\n",
+		       sym->name);
+		goto out_unlock;
 	}
-	pclose(file);
+
+	err = symbol__annotate(sym, syme->map, &source->head, 0);
+	if (err == 0) {
 out_assign:
 	sym_filter_entry = syme;
+	}
+out_unlock:
 	pthread_mutex_unlock(&source->lock);
-	return 0;
+	return err;
 }
 
 static void __zero_source_counters(struct sym_entry *syme)
 {
-	int i;
-	struct source_line *line;
-
-	line = syme->src->lines;
-	while (line) {
-		for (i = 0; i < top.evlist->nr_entries; i++)
-			line->count[i] = 0;
-		line = line->next;
-	}
+	struct symbol *sym = sym_entry__symbol(syme);
+	symbol__annotate_zero_histograms(sym);
 }
 
 static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
 {
-	struct source_line *line;
-
 	if (syme != sym_filter_entry)
 		return;
 
 	if (pthread_mutex_trylock(&syme->src->lock))
 		return;
 
-	if (syme->src == NULL || syme->src->source == NULL)
-		goto out_unlock;
-
-	for (line = syme->src->lines; line; line = line->next) {
-		/* skip lines without IP info */
-		if (line->eip == 0)
-			continue;
-		if (line->eip == ip) {
-			line->count[counter]++;
-			break;
-		}
-		if (line->eip > ip)
-			break;
-	}
-out_unlock:
-	pthread_mutex_unlock(&syme->src->lock);
-}
-
-#define PATTERN_LEN		(BITS_PER_LONG / 4 + 2)
+	ip = syme->map->map_ip(syme->map, ip);
+	symbol__inc_addr_samples(sym_entry__symbol(syme), syme->map, counter, ip);
 
-static void lookup_sym_source(struct sym_entry *syme)
-{
-	struct symbol *symbol = sym_entry__symbol(syme);
-	struct source_line *line;
-	char pattern[PATTERN_LEN + 1];
-
-	sprintf(pattern, "%0*" PRIx64 " <", BITS_PER_LONG / 4,
-		map__rip_2objdump(syme->map, symbol->start));
-
-	pthread_mutex_lock(&syme->src->lock);
-	for (line = syme->src->lines; line; line = line->next) {
-		if (memcmp(line->line, pattern, PATTERN_LEN) == 0) {
-			syme->src->source = line;
-			break;
-		}
-	}
 	pthread_mutex_unlock(&syme->src->lock);
 }
 
-static void show_lines(struct source_line *queue, int count, int total)
-{
-	int i;
-	struct source_line *line;
-
-	line = queue;
-	for (i = 0; i < count; i++) {
-		float pcnt = 100.0*(float)line->count[top.sym_counter]/(float)total;
-
-		printf("%8li %4.1f%%\t%s\n", line->count[top.sym_counter], pcnt, line->line);
-		line = line->next;
-	}
-}
-
-#define TRACE_COUNT     3
-
 static void show_details(struct sym_entry *syme)
 {
 	struct symbol *symbol;
-	struct source_line *line;
-	struct source_line *line_queue = NULL;
-	int displayed = 0;
-	int line_queue_count = 0, total = 0, more = 0;
+	int more;
 
 	if (!syme)
 		return;
 
-	if (!syme->src->source)
-		lookup_sym_source(syme);
-
-	if (!syme->src->source)
+	symbol = sym_entry__symbol(syme);
+	if (!syme->src || symbol__annotation(symbol)->histograms == NULL)
 		return;
 
-	symbol = sym_entry__symbol(syme);
 	printf("Showing %s for %s\n", event_name(top.sym_evsel), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
 
 	pthread_mutex_lock(&syme->src->lock);
-	line = syme->src->source;
-	while (line) {
-		total += line->count[top.sym_counter];
-		line = line->next;
-	}
-
-	line = syme->src->source;
-	while (line) {
-		float pcnt = 0.0;
-
-		if (!line_queue_count)
-			line_queue = line;
-		line_queue_count++;
-
-		if (line->count[top.sym_counter])
-			pcnt = 100.0 * line->count[top.sym_counter] / (float)total;
-		if (pcnt >= (float)sym_pcnt_filter) {
-			if (displayed <= top.print_entries)
-				show_lines(line_queue, line_queue_count, total);
-			else more++;
-			displayed += line_queue_count;
-			line_queue_count = 0;
-			line_queue = NULL;
-		} else if (line_queue_count > TRACE_COUNT) {
-			line_queue = line_queue->next;
-			line_queue_count--;
-		}
-
-		line->count[top.sym_counter] = top.zero ? 0 : line->count[top.sym_counter] * 7 / 8;
-		line = line->next;
-	}
+	more = symbol__annotate_printf(symbol, syme->map, &syme->src->head,
+				       top.sym_evsel->idx, 0, sym_pcnt_filter,
+				       top.print_entries);
+	if (top.zero)
+		symbol__annotate_zero_histogram(symbol, top.sym_evsel->idx);
+	else
+		symbol__annotate_decay_histogram(symbol, &syme->src->head,
+						 top.sym_evsel->idx);
 	pthread_mutex_unlock(&syme->src->lock);
-	if (more)
+	if (more != 0)
 		printf("%d lines not displayed, maybe increase display entries [e]\n", more);
 }
 
@@ -1172,7 +1053,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
 
-	symbol_conf.priv_size = (sizeof(struct sym_entry) +
+	symbol_conf.priv_size = (sizeof(struct sym_entry) + sizeof(struct annotation) +
 				 (top.evlist->nr_entries + 1) * sizeof(unsigned long));
 
 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 10cdbad..2973376 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -22,9 +22,19 @@ int symbol__alloc_hist(struct symbol *sym, int nevents)
 	notes->sizeof_sym_hist = (sizeof(*notes->histograms) +
 				  (sym->end - sym->start) * sizeof(u64));
 	notes->histograms = calloc(nevents, notes->sizeof_sym_hist);
+	notes->nr_histograms = nevents;
 	return notes->histograms == NULL ? -1 : 0;
 }
 
+void symbol__annotate_zero_histograms(struct symbol *sym)
+{
+	struct annotation *notes = symbol__annotation(sym);
+
+	if (notes->histograms != NULL)
+		memset(notes->histograms, 0,
+		       notes->nr_histograms * notes->sizeof_sym_hist);
+}
+
 int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 			     int evidx, u64 addr)
 {
@@ -85,9 +95,10 @@ struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
 	return NULL;
 }
 
-static void objdump_line__print(struct objdump_line *oline,
-				struct list_head *head, struct symbol *sym,
-				int evidx, u64 len, int min_pcnt)
+static int objdump_line__print(struct objdump_line *oline,
+			       struct list_head *head, struct symbol *sym,
+			       int evidx, u64 len, int min_pcnt,
+			       int printed, int max_lines)
 {
 	static const char *prev_line;
 	static const char *prev_color;
@@ -119,7 +130,10 @@ static void objdump_line__print(struct objdump_line *oline,
 			percent = 100.0 * hits / h->sum;
 
 		if (percent < min_pcnt)
-			return;
+			return -1;
+
+		if (printed >= max_lines)
+			return 1;
 
 		color = get_percent_color(percent);
 
@@ -140,12 +154,16 @@ static void objdump_line__print(struct objdump_line *oline,
 		color_fprintf(stdout, color, " %7.2f", percent);
 		printf(" :	");
 		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", oline->line);
-	} else {
+	} else if (printed >= max_lines)
+		return 1;
+	else {
 		if (!*oline->line)
 			printf("         :\n");
 		else
 			printf("         :	%s\n", oline->line);
 	}
+
+	return 0;
 }
 
 static int symbol__parse_objdump_line(struct symbol *sym, struct map *map, FILE *file,
@@ -421,14 +439,15 @@ static void symbol__annotate_hits(struct symbol *sym, int evidx)
 	printf("%*s: %" PRIu64 "\n", BITS_PER_LONG / 2, "h->sum", h->sum);
 }
 
-void symbol__annotate_printf(struct symbol *sym, struct map *map,
-			     struct list_head *head, int evidx, bool full_paths,
-			     int min_pcnt, int max_lines)
+int symbol__annotate_printf(struct symbol *sym, struct map *map,
+			    struct list_head *head, int evidx, bool full_paths,
+			    int min_pcnt, int max_lines)
 {
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name, *d_filename;
 	struct objdump_line *pos;
 	int printed = 2;
+	int more = 0;
 	u64 len;
 
 	if (full_paths)
@@ -445,10 +464,47 @@ void symbol__annotate_printf(struct symbol *sym, struct map *map,
 		symbol__annotate_hits(sym, evidx);
 
 	list_for_each_entry(pos, head, node) {
-		objdump_line__print(pos, head, sym, evidx, len, min_pcnt);
-		if (max_lines && ++printed >= max_lines)
+		switch (objdump_line__print(pos, head, sym, evidx, len, min_pcnt,
+					    printed, max_lines)) {
+		case 0:
+			++printed;
+			break;
+		case 1:
+			/* filtered by max_lines */
+			++more;
 			break;
+		case -1:
+		default:
+			/* filtered by min_pcnt */
+			break;
+		}
+	}
+
+	return more;
+}
 
+void symbol__annotate_zero_histogram(struct symbol *sym, int evidx)
+{
+	struct annotation *notes = symbol__annotation(sym);
+	struct sym_hist *h = annotation__histogram(notes, evidx);
+
+	memset(h, 0, notes->sizeof_sym_hist);
+}
+
+void symbol__annotate_decay_histogram(struct symbol *sym,
+				      struct list_head *head, int evidx)
+{
+	struct annotation *notes = symbol__annotation(sym);
+	struct sym_hist *h = annotation__histogram(notes, evidx);
+	struct objdump_line *pos;
+
+	h->sum = 0;
+
+	list_for_each_entry(pos, head, node) {
+		if (pos->offset != -1) {
+			h->addr[pos->offset] = h->addr[pos->offset] * 7 / 8;
+			h->sum += h->addr[pos->offset];
+		}
 	}
 }
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 53dd92d..b1253aa 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -42,6 +42,7 @@ struct source_line {
 struct annotation {
 	struct source_line *src_line;
 	struct sym_hist	   *histograms;
+	int    		   nr_histograms;
 	int    		   sizeof_sym_hist;
 };
 
@@ -64,12 +65,16 @@ static inline struct annotation *symbol__annotation(struct symbol *sym)
 int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 			     int evidx, u64 addr);
 int symbol__alloc_hist(struct symbol *sym, int nevents);
+void symbol__annotate_zero_histograms(struct symbol *sym);
 
 int symbol__annotate(struct symbol *sym, struct map *map,
 		     struct list_head *head, size_t privsize);
-void symbol__annotate_printf(struct symbol *sym, struct map *map,
-			     struct list_head *head, int evidx, bool full_paths,
-			     int min_pcnt, int max_lines);
+int symbol__annotate_printf(struct symbol *sym, struct map *map,
+			    struct list_head *head, int evidx, bool full_paths,
+			    int min_pcnt, int max_lines);
+void symbol__annotate_zero_histogram(struct symbol *sym, int evidx);
+void symbol__annotate_decay_histogram(struct symbol *sym,
+				      struct list_head *head, int evidx);
 void objdump_line_list__purge(struct list_head *head);
 
 int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 5009508..fe44afb 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -11,17 +11,8 @@
 struct perf_evlist;
 struct perf_evsel;
 
-struct source_line {
-	u64			eip;
-	unsigned long		count[MAX_COUNTERS]; /* FIXME */
-	char			*line;
-	struct source_line	*next;
-};
-
 struct sym_entry_source {
-	struct source_line	*source;
-	struct source_line	*lines;
-	struct source_line	**lines_tail;
+	struct list_head	head;
 	pthread_mutex_t		lock;
 };
 
