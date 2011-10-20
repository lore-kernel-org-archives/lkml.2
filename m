Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1JTUjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 16:39:37 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43815 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1JTUjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 16:39:36 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf top: fix crash on annotate request
Date: Thu, 20 Oct 2011 14:39:28 -0600
Message-Id: <1319143168-14468-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Command:
  perf top -ag --sort comm,dso

crashes with signature:

    nr_events=1, timer=0x417220 <perf_top__sort_new_samples>, arg=0x751540, delay_secs=2)
    at util/ui/browsers/annotate.c:405
    evidx=<value optimized out>, nr_events=<value optimized out>, timer=<value optimized out>,
    arg=<value optimized out>, delay_secs=<value optimized out>)
    at util/ui/browsers/annotate.c:373
    helpline=<value optimized out>, ev_name=0x860b60 "cycles", left_exits=false,
    timer=0x417220 <perf_top__sort_new_samples>, arg=0x751540, delay_secs=2)
    at util/ui/browsers/hists.c:997
    help=0x502b30 "For a higher level overview, try: perf top --sort comm,dso",
    timer=0x417220 <perf_top__sort_new_samples>, arg=0x751540, delay_secs=2)
    at util/ui/browsers/hists.c:1204

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-annotate.c          |    7 ++++---
 tools/perf/builtin-top.c               |    2 +-
 tools/perf/util/annotate.c             |   24 +++++++++++++++++++-----
 tools/perf/util/annotate.h             |    5 +++--
 tools/perf/util/hist.c                 |    4 ++--
 tools/perf/util/hist.h                 |    3 ++-
 tools/perf/util/ui/browsers/annotate.c |    3 ++-
 7 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 3ea764a..2c8362a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -108,10 +108,11 @@ static int process_sample_event(union perf_event *event,
 	return 0;
 }
 
-static int hist_entry__tty_annotate(struct hist_entry *he, int evidx)
+static int hist_entry__tty_annotate(struct hist_entry *he, int evidx,
+				    int nr_events)
 {
 	return symbol__tty_annotate(he->ms.sym, he->ms.map, evidx,
-				    print_line, full_paths, 0, 0);
+				    print_line, full_paths, 0, 0, nr_events);
 }
 
 static void hists__find_annotations(struct hists *self, int evidx,
@@ -154,7 +155,7 @@ find_next:
 			if (next != NULL)
 				nd = next;
 		} else {
-			hist_entry__tty_annotate(he, evidx);
+			hist_entry__tty_annotate(he, evidx, nr_events);
 			nd = rb_next(nd);
 			/*
 			 * Since we have a hist_entry per IP for the same
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7a87171..b6e8353 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -177,7 +177,7 @@ static int parse_source(struct hist_entry *he)
 		return err;
 	}
 
-	err = symbol__annotate(sym, map, 0);
+	err = symbol__annotate(sym, map, 0, top.evlist->nr_entries);
 	if (err == 0) {
 out_assign:
 		top.sym_filter_entry = he;
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index bc8f477..c9090d8 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -197,7 +197,8 @@ static int objdump_line__print(struct objdump_line *oline, struct symbol *sym,
 }
 
 static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
-				      FILE *file, size_t privsize)
+				      FILE *file, size_t privsize,
+				      int nr_events)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct objdump_line *objdump_line;
@@ -253,12 +254,24 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 		free(line);
 		return -1;
 	}
+
+	pthread_mutex_lock(&notes->lock);
+	if (notes->src == NULL &&
+		symbol__alloc_hist(sym, nr_events) < 0) {
+		pthread_mutex_unlock(&notes->lock);
+		ui__warning("Not enough memory for annotating '%s' symbol!\n",
+			    sym->name);
+		return -1;
+	}
+	pthread_mutex_unlock(&notes->lock);
+
 	objdump__add_line(&notes->src->source, objdump_line);
 
 	return 0;
 }
 
-int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
+int symbol__annotate(struct symbol *sym, struct map *map,
+		     size_t privsize, int nr_events)
 {
 	struct dso *dso = map->dso;
 	char *filename = dso__build_id_filename(dso, NULL, 0);
@@ -343,7 +356,8 @@ fallback:
 		goto out_free_filename;
 
 	while (!feof(file))
-		if (symbol__parse_objdump_line(sym, map, file, privsize) < 0)
+		if (symbol__parse_objdump_line(sym, map, file,
+					       privsize, nr_events) < 0)
 			break;
 
 	pclose(file);
@@ -583,14 +597,14 @@ void objdump_line_list__purge(struct list_head *head)
 
 int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 bool print_lines, bool full_paths, int min_pcnt,
-			 int max_lines)
+			 int max_lines, int nr_events)
 {
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name;
 	struct rb_root source_line = RB_ROOT;
 	u64 len;
 
-	if (symbol__annotate(sym, map, 0) < 0)
+	if (symbol__annotate(sym, map, 0, nr_events) < 0)
 		return -1;
 
 	len = sym->end - sym->start;
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index d907252..1a7842d 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -75,7 +75,8 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 int symbol__alloc_hist(struct symbol *sym, int nevents);
 void symbol__annotate_zero_histograms(struct symbol *sym);
 
-int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize);
+int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize,
+		     int nr_events);
 int symbol__annotate_init(struct map *map __used, struct symbol *sym);
 int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 			    bool full_paths, int min_pcnt, int max_lines,
@@ -86,7 +87,7 @@ void objdump_line_list__purge(struct list_head *head);
 
 int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 bool print_lines, bool full_paths, int min_pcnt,
-			 int max_lines);
+			 int max_lines, int nr_events);
 
 #ifdef NO_NEWT_SUPPORT
 static inline int symbol__tui_annotate(struct symbol *sym __used,
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f6a9939..0ebfa3e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1180,9 +1180,9 @@ int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 ip)
 	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, evidx, ip);
 }
 
-int hist_entry__annotate(struct hist_entry *he, size_t privsize)
+int hist_entry__annotate(struct hist_entry *he, size_t privsize, int nr_events)
 {
-	return symbol__annotate(he->ms.sym, he->ms.map, privsize);
+	return symbol__annotate(he->ms.sym, he->ms.map, privsize, nr_events);
 }
 
 void hists__inc_nr_events(struct hists *hists, u32 type)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 575bcbc..99ead17 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -94,7 +94,8 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 		      int max_rows, int max_cols, FILE *fp);
 
 int hist_entry__inc_addr_samples(struct hist_entry *self, int evidx, u64 addr);
-int hist_entry__annotate(struct hist_entry *self, size_t privsize);
+int hist_entry__annotate(struct hist_entry *self, size_t privsize,
+			 int nr_events);
 
 void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 1a12d8f..4eb1faf 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -402,7 +402,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	if (map->dso->annotate_warned)
 		return -1;
 
-	if (symbol__annotate(sym, map, sizeof(struct objdump_line_rb_node)) < 0) {
+	if (symbol__annotate(sym, map, sizeof(struct objdump_line_rb_node),
+			     nr_events) < 0) {
 		ui__error_window(ui_helpline__last_msg);
 		return -1;
 	}
-- 
1.7.6.4

