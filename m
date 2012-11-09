Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab2KIR35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:29:57 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab2KIR3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:29:13 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/13] perf annotate browser: Use disasm__calc_percent()
Date: Sat, 10 Nov 2012 02:27:22 +0900
Message-Id: <1352482044-3443-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The disasm_line__calc_percent() which was used by annotate
browser code almost duplicates disasm__calc_percent.  Since
the latter can handle multiple events properly, use it and
get rid of the code duplication.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/annotate.c |   50 +++++++++++--------------------------
 tools/perf/util/annotate.c        |    6 ++---
 tools/perf/util/annotate.h        |    3 +++
 3 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index a846fe36a26e..7df1fa990ec2 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -233,40 +233,6 @@ static unsigned int annotate_browser__refresh(struct ui_browser *browser)
 	return ret;
 }
 
-static double disasm_line__calc_percent(struct disasm_line *dl, struct symbol *sym, int evidx)
-{
-	double percent = 0.0;
-
-	if (dl->offset != -1) {
-		int len = sym->end - sym->start;
-		unsigned int hits = 0;
-		struct annotation *notes = symbol__annotation(sym);
-		struct source_line *src_line = notes->src->lines;
-		struct sym_hist *h = annotation__histogram(notes, evidx);
-		s64 offset = dl->offset;
-		struct disasm_line *next;
-
-		next = disasm__get_next_ip_line(&notes->src->source, dl);
-		while (offset < (s64)len &&
-		       (next == NULL || offset < next->offset)) {
-			if (src_line) {
-				percent += src_line[offset].p[0].percent;
-			} else
-				hits += h->addr[offset];
-
-			++offset;
-		}
-		/*
- 		 * If the percentage wasn't already calculated in
- 		 * symbol__get_source_line, do it now:
- 		 */
-		if (src_line == NULL && h->sum)
-			percent = 100.0 * hits / h->sum;
-	}
-
-	return percent;
-}
-
 static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_line *bdl)
 {
 	struct rb_node **p = &root->rb_node;
@@ -330,7 +296,8 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 	struct map_symbol *ms = browser->b.priv;
 	struct symbol *sym = ms->sym;
 	struct annotation *notes = symbol__annotation(sym);
-	struct disasm_line *pos;
+	struct disasm_line *pos, *next;
+	u64 len = sym->end - sym->start;
 
 	browser->entries = RB_ROOT;
 
@@ -338,7 +305,18 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct browser_disasm_line *bpos = disasm_line__browser(pos);
-		bpos->percent[0] = disasm_line__calc_percent(pos, sym, evsel->idx);
+
+		if (pos->offset == -1) {
+			RB_CLEAR_NODE(&bpos->rb_node);
+			continue;
+		}
+
+		next = disasm__get_next_ip_line(&notes->src->source, pos);
+
+		disasm__calc_percent(sym, evsel, pos->offset,
+				     next ? next->offset : (s64) len,
+				     NULL, bpos->percent, 1);
+
 		if (bpos->percent[0] < 0.01) {
 			RB_CLEAR_NODE(&bpos->rb_node);
 			continue;
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 28ac33e83bf3..41462f84feea 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -635,9 +635,9 @@ struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disa
 	return NULL;
 }
 
-static void disasm__calc_percent(struct symbol *sym, struct perf_evsel *evsel,
-				 s64 from, s64 to, const char **path,
-				 double *percent, int nr_percent)
+void disasm__calc_percent(struct symbol *sym, struct perf_evsel *evsel,
+			  s64 from, s64 to, const char **path,
+			  double *percent, int nr_percent)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct source_line *src_line = notes->src->lines;
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index fa74c09f0c70..6cbb333ad518 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -67,6 +67,9 @@ void disasm_line__free(struct disasm_line *dl);
 struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disasm_line *pos);
 int disasm_line__scnprintf(struct disasm_line *dl, char *bf, size_t size, bool raw);
 size_t disasm__fprintf(struct list_head *head, FILE *fp);
+void disasm__calc_percent(struct symbol *sym, struct perf_evsel *evsel,
+			  s64 from, s64 to, const char **path,
+			  double *percent, int nr_percent);
 
 struct sym_hist {
 	u64		sum;
-- 
1.7.9.2

