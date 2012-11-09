Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2KIRar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:30:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab2KIR3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:29:00 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 07/13] perf annotate: Basic support for event group view
Date: Sat, 10 Nov 2012 02:27:18 +0900
Message-Id: <1352482044-3443-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add support for event group view when symbol_conf.event_group enabled.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c |   86 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 69 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f985866304ff..5b44c3b1a166 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -637,15 +637,17 @@ struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disa
 
 static void disasm__calc_percent(struct symbol *sym, struct perf_evsel *evsel,
 				 s64 from, s64 to, const char **path,
-				 double *percent)
+				 double *percent, int nr_percent)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct source_line *src_line = notes->src->lines;
 	struct sym_hist *h;
-	unsigned int hits = 0;
+	unsigned int hits;
 	s64 offset = from;
+	int evidx = evsel->idx;
+	int i;
 
-	*percent = 0.0;
+	memset(percent, 0, sizeof(percent) * nr_percent);
 
 	if (src_line) {
 		while (offset < to) {
@@ -656,14 +658,19 @@ static void disasm__calc_percent(struct symbol *sym, struct perf_evsel *evsel,
 			++offset;
 		}
 	} else {
-		h = annotation__histogram(notes, evsel->idx);
+		for (i = 0; i < nr_percent; i++) {
+			hits = 0;
+			offset = from;
+			h = annotation__histogram(notes, evidx + i);
+
+			while (offset < to) {
+				hits += h->addr[offset];
+				offset++;
+			}
 
-		while (offset < to) {
-			hits += h->addr[offset];
+			if (h->sum)
+				percent[i] = 100.0 * hits / h->sum;
 		}
-
-		if (h->sum)
-			*percent = 100.0 * hits / h->sum;
 	}
 }
 
@@ -677,19 +684,39 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 	if (dl->offset != -1) {
 		const char *path = NULL;
 		double percent = 0.0;
+		double percent_max = 0.0;
+		double *ppercents = &percent;
+		int i, nr_percents = 1;
 		const char *color;
 		struct annotation *notes = symbol__annotation(sym);
 		s64 offset = dl->offset;
 		const u64 addr = start + offset;
 		struct disasm_line *next;
 
+		if (symbol_conf.event_group) {
+			if (perf_evsel__is_group_leader(evsel) &&
+			    evsel->nr_members > 0) {
+				nr_percents = evsel->nr_members + 1;
+				ppercents = calloc(nr_percents, sizeof(double));
+				if (ppercents == NULL)
+					return -1;
+			}
+		}
+
 		next = disasm__get_next_ip_line(&notes->src->source, dl);
 
 		disasm__calc_percent(sym, evsel, offset,
 				     next ? next->offset : (s64) len,
-				     &path, &percent);
+				     &path, ppercents, nr_percents);
+
+		for (i = 0; i < nr_percents; i++) {
+			percent = ppercents[i];
+
+			if (percent > percent_max)
+				percent_max = percent;
+		}
 
-		if (percent < min_pcnt)
+		if (percent_max < min_pcnt)
 			return -1;
 
 		if (max_lines && printed >= max_lines)
@@ -704,7 +731,7 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 			}
 		}
 
-		color = get_percent_color(percent);
+		color = get_percent_color(percent_max);
 
 		/*
 		 * Also color the filename and line if needed, with
@@ -720,20 +747,35 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 			}
 		}
 
-		color_fprintf(stdout, color, " %7.2f", percent);
+		for (i = 0; i < nr_percents; i++) {
+			percent = ppercents[i];
+			color = get_percent_color(percent);
+			color_fprintf(stdout, color, " %7.2f", percent);
+		}
+
 		printf(" :	");
 		color_fprintf(stdout, PERF_COLOR_MAGENTA, "  %" PRIx64 ":", addr);
 		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", dl->line);
+
+		if (ppercents != &percent)
+			free(ppercents);
 	} else if (max_lines && printed >= max_lines)
 		return 1;
 	else {
+		int width = 8;
+
 		if (queue)
 			return -1;
 
+		if (symbol_conf.event_group) {
+			if (perf_evsel__is_group_leader(evsel))
+				width *= evsel->nr_members + 1;
+		}
+
 		if (!*dl->line)
-			printf("         :\n");
+			printf(" %*s:\n", width, " ");
 		else
-			printf("         :	%s\n", dl->line);
+			printf(" %*s:	%s\n", width, " ", dl->line);
 	}
 
 	return 0;
@@ -1096,6 +1138,8 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 	int printed = 2, queue_len = 0;
 	int more = 0;
 	u64 len;
+	int width = 8;
+	int namelen;
 
 	filename = strdup(dso->long_name);
 	if (!filename)
@@ -1108,8 +1152,16 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 
 	len = symbol__size(sym);
 
-	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
-	printf("------------------------------------------------\n");
+	if (symbol_conf.event_group) {
+		if (perf_evsel__is_group_leader(evsel))
+			width *= evsel->nr_members + 1;
+	}
+	namelen = strlen(d_filename);
+
+	printf(" %-*.*s|	Source code & Disassembly of %s\n",
+	       width, width, "Percent", d_filename);
+	printf("-%-*.*s-------------------------------------\n",
+	       width + namelen, width + namelen, graph_dotted_line);
 
 	if (verbose)
 		symbol__annotate_hits(sym, evsel);
-- 
1.7.9.2

