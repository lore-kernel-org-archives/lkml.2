Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1BGAoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 19:44:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1BGAn5 (ORCPT
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
Subject: [PATCH 5/6] perf annotate: Separate objdump parsing from actual screen rendering
Date: Sun,  6 Feb 2011 22:42:16 -0200
Message-Id: <1297039337-6690-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297039337-6690-1-git-send-email-acme@infradead.org>
References: <1297039337-6690-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Because in 'perf top' we'll need to parse just once and then, as samples
come, render multiple times with evolving counter values.

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
 tools/perf/util/annotate.c |   62 ++++++++++++++++++++++++++++++-------------
 tools/perf/util/annotate.h |    4 +++
 2 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 072bc8d..10cdbad 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -421,21 +421,16 @@ static void symbol__annotate_hits(struct symbol *sym, int evidx)
 	printf("%*s: %" PRIu64 "\n", BITS_PER_LONG / 2, "h->sum", h->sum);
 }
 
-int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
-			 bool print_lines, bool full_paths, int min_pcnt,
-			 int max_lines)
+void symbol__annotate_printf(struct symbol *sym, struct map *map,
+			     struct list_head *head, int evidx, bool full_paths,
+			     int min_pcnt, int max_lines)
 {
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name, *d_filename;
-	struct rb_root source_line = RB_ROOT;
-	struct objdump_line *pos, *n;
-	LIST_HEAD(head);
+	struct objdump_line *pos;
 	int printed = 2;
 	u64 len;
 
-	if (symbol__annotate(sym, map, &head, 0) < 0)
-		return -1;
-
 	if (full_paths)
 		d_filename = filename;
 	else
@@ -443,28 +438,57 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	len = sym->end - sym->start;
 
-	if (print_lines) {
-		symbol__get_source_line(sym, map, evidx, &source_line,
-					len, filename);
-		print_summary(&source_line, filename);
-	}
-
 	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
 	printf("------------------------------------------------\n");
 
 	if (verbose)
 		symbol__annotate_hits(sym, evidx);
 
-	list_for_each_entry_safe(pos, n, &head, node) {
-		objdump_line__print(pos, &head, sym, evidx, len, min_pcnt);
-		list_del(&pos->node);
-		objdump_line__free(pos);
+	list_for_each_entry(pos, head, node) {
+		objdump_line__print(pos, head, sym, evidx, len, min_pcnt);
 		if (max_lines && ++printed >= max_lines)
 			break;
+
+	}
+}
+
+void objdump_line_list__purge(struct list_head *head)
+{
+	struct objdump_line *pos, *n;
+
+	list_for_each_entry_safe(pos, n, head, node) {
+		list_del(&pos->node);
+		objdump_line__free(pos);
+	}
+}
+
+int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
+			 bool print_lines, bool full_paths, int min_pcnt,
+			 int max_lines)
+{
+	struct dso *dso = map->dso;
+	const char *filename = dso->long_name;
+	struct rb_root source_line = RB_ROOT;
+	LIST_HEAD(head);
+	u64 len;
+
+	if (symbol__annotate(sym, map, &head, 0) < 0)
+		return -1;
+
+	len = sym->end - sym->start;
+
+	if (print_lines) {
+		symbol__get_source_line(sym, map, evidx, &source_line,
+					len, filename);
+		print_summary(&source_line, filename);
 	}
 
+	symbol__annotate_printf(sym, map, &head, evidx, full_paths,
+				min_pcnt, max_lines);
 	if (print_lines)
 		symbol__free_source_line(sym, len);
 
+	objdump_line_list__purge(&head);
+
 	return 0;
 }
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 6b70732..53dd92d 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -67,6 +67,10 @@ int symbol__alloc_hist(struct symbol *sym, int nevents);
 
 int symbol__annotate(struct symbol *sym, struct map *map,
 		     struct list_head *head, size_t privsize);
+void symbol__annotate_printf(struct symbol *sym, struct map *map,
+			     struct list_head *head, int evidx, bool full_paths,
+			     int min_pcnt, int max_lines);
+void objdump_line_list__purge(struct list_head *head);
 
 int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 bool print_lines, bool full_paths, int min_pcnt,
-- 
1.6.2.5

