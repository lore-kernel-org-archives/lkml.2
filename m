Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1BGAoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 19:44:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56736 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab1BGAny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 19:43:54 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/6] perf annotate: Config options for symbol__tty_annotate
Date: Sun,  6 Feb 2011 22:42:15 -0200
Message-Id: <1297039337-6690-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297039337-6690-1-git-send-email-acme@infradead.org>
References: <1297039337-6690-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Max line# that should be printed, minimum percentage filter, just like
'perf top', alas, due to it :-)

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
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/util/annotate.c    |   14 ++++++++++----
 tools/perf/util/annotate.h    |    3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index f3e4423..ea6a116 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -95,7 +95,7 @@ static int process_sample_event(union perf_event *event,
 static int hist_entry__tty_annotate(struct hist_entry *he, int evidx)
 {
 	return symbol__tty_annotate(he->ms.sym, he->ms.map, evidx,
-				    print_line, full_paths);
+				    print_line, full_paths, 0, 0);
 }
 
 static void hists__find_annotations(struct hists *self)
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7488fe9..072bc8d 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -87,7 +87,7 @@ struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
 
 static void objdump_line__print(struct objdump_line *oline,
 				struct list_head *head, struct symbol *sym,
-				int evidx, u64 len)
+				int evidx, u64 len, int min_pcnt)
 {
 	static const char *prev_line;
 	static const char *prev_color;
@@ -118,6 +118,9 @@ static void objdump_line__print(struct objdump_line *oline,
 		if (src_line == NULL && h->sum)
 			percent = 100.0 * hits / h->sum;
 
+		if (percent < min_pcnt)
+			return;
+
 		color = get_percent_color(percent);
 
 		/*
@@ -419,13 +422,15 @@ static void symbol__annotate_hits(struct symbol *sym, int evidx)
 }
 
 int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
-			 bool print_lines, bool full_paths)
+			 bool print_lines, bool full_paths, int min_pcnt,
+			 int max_lines)
 {
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name, *d_filename;
 	struct rb_root source_line = RB_ROOT;
 	struct objdump_line *pos, *n;
 	LIST_HEAD(head);
+	int printed = 2;
 	u64 len;
 
 	if (symbol__annotate(sym, map, &head, 0) < 0)
@@ -444,7 +449,6 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 		print_summary(&source_line, filename);
 	}
 
-	printf("\n\n------------------------------------------------\n");
 	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
 	printf("------------------------------------------------\n");
 
@@ -452,9 +456,11 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 		symbol__annotate_hits(sym, evidx);
 
 	list_for_each_entry_safe(pos, n, &head, node) {
-		objdump_line__print(pos, &head, sym, evidx, len);
+		objdump_line__print(pos, &head, sym, evidx, len, min_pcnt);
 		list_del(&pos->node);
 		objdump_line__free(pos);
+		if (max_lines && ++printed >= max_lines)
+			break;
 	}
 
 	if (print_lines)
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 0a5069c..6b70732 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -69,7 +69,8 @@ int symbol__annotate(struct symbol *sym, struct map *map,
 		     struct list_head *head, size_t privsize);
 
 int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
-			 bool print_lines, bool full_paths);
+			 bool print_lines, bool full_paths, int min_pcnt,
+			 int max_lines);
 
 #ifdef NO_NEWT_SUPPORT
 static inline int symbol__tui_annotate(symbol *sym __used,
-- 
1.6.2.5

