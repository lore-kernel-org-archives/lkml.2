Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1BHWJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:09:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1BHWJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:09:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/3] perf annotate: Fix annotate context lines regression
Date: Tue,  8 Feb 2011 20:09:20 -0200
Message-Id: <1297202960-15269-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297202960-15269-1-git-send-email-acme@infradead.org>
References: <1297202960-15269-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The live annotation done in 'perf top' needs to limit the context before
lines that aren't filtered out by the min percent filter, if we don't do
that, the screen in a tty often is not enough for showing what is
interesting: lines with hits and a few source code lines before it.

Reported-by: Mike Galbraith <efault@gmx.de>
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
 tools/perf/builtin-top.c   |    2 +-
 tools/perf/util/annotate.c |   47 +++++++++++++++++++++++++++++++++++++------
 tools/perf/util/annotate.h |    3 +-
 3 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7dbf22d..210c736 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -231,7 +231,7 @@ static void show_details(struct sym_entry *syme)
 	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
 
 	more = symbol__annotate_printf(symbol, syme->map, top.sym_evsel->idx,
-				       0, sym_pcnt_filter, top.print_entries);
+				       0, sym_pcnt_filter, top.print_entries, 4);
 	if (top.zero)
 		symbol__annotate_zero_histogram(symbol, top.sym_evsel->idx);
 	else
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index c777bda..02976b8 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -111,7 +111,8 @@ struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
 
 static int objdump_line__print(struct objdump_line *oline, struct symbol *sym,
 			       int evidx, u64 len, int min_pcnt,
-			       int printed, int max_lines)
+			       int printed, int max_lines,
+			       struct objdump_line *queue)
 {
 	static const char *prev_line;
 	static const char *prev_color;
@@ -150,6 +151,15 @@ static int objdump_line__print(struct objdump_line *oline, struct symbol *sym,
 		if (max_lines && printed >= max_lines)
 			return 1;
 
+		if (queue != NULL) {
+			list_for_each_entry_from(queue, &notes->src->source, node) {
+				if (queue == oline)
+					break;
+				objdump_line__print(queue, sym, evidx, len,
+						    0, 0, 1, NULL);
+			}
+		}
+
 		color = get_percent_color(percent);
 
 		/*
@@ -172,6 +182,9 @@ static int objdump_line__print(struct objdump_line *oline, struct symbol *sym,
 	} else if (max_lines && printed >= max_lines)
 		return 1;
 	else {
+		if (queue)
+			return -1;
+
 		if (!*oline->line)
 			printf("         :\n");
 		else
@@ -452,13 +465,14 @@ static void symbol__annotate_hits(struct symbol *sym, int evidx)
 }
 
 int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
-			    bool full_paths, int min_pcnt, int max_lines)
+			    bool full_paths, int min_pcnt, int max_lines,
+			    int context)
 {
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name, *d_filename;
 	struct annotation *notes = symbol__annotation(sym);
-	struct objdump_line *pos;
-	int printed = 2;
+	struct objdump_line *pos, *queue = NULL;
+	int printed = 2, queue_len = 0;
 	int more = 0;
 	u64 len;
 
@@ -476,10 +490,20 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 		symbol__annotate_hits(sym, evidx);
 
 	list_for_each_entry(pos, &notes->src->source, node) {
+		if (context && queue == NULL) {
+			queue = pos;
+			queue_len = 0;
+		}
+
 		switch (objdump_line__print(pos, sym, evidx, len, min_pcnt,
-					    printed, max_lines)) {
+					    printed, max_lines, queue)) {
 		case 0:
 			++printed;
+			if (context) {
+				printed += queue_len;
+				queue = NULL;
+				queue_len = 0;
+			}
 			break;
 		case 1:
 			/* filtered by max_lines */
@@ -487,7 +511,16 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 			break;
 		case -1:
 		default:
-			/* filtered by min_pcnt */
+			/*
+			 * Filtered by min_pcnt or non IP lines when
+			 * context != 0
+			 */
+			if (!context)
+				break;
+			if (queue_len == context)
+				queue = list_entry(queue->node.next, typeof(*queue), node);
+			else
+				++queue_len;
 			break;
 		}
 	}
@@ -550,7 +583,7 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 	}
 
 	symbol__annotate_printf(sym, map, evidx, full_paths,
-				min_pcnt, max_lines);
+				min_pcnt, max_lines, 0);
 	if (print_lines)
 		symbol__free_source_line(sym, len);
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index b237c86..e848803 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -78,7 +78,8 @@ void symbol__annotate_zero_histograms(struct symbol *sym);
 int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize);
 int symbol__annotate_init(struct map *map __used, struct symbol *sym);
 int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
-			    bool full_paths, int min_pcnt, int max_lines);
+			    bool full_paths, int min_pcnt, int max_lines,
+			    int context);
 void symbol__annotate_zero_histogram(struct symbol *sym, int evidx);
 void symbol__annotate_decay_histogram(struct symbol *sym, int evidx);
 void objdump_line_list__purge(struct list_head *head);
-- 
1.6.2.5

