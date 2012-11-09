Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2KIR3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:29:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab2KIR3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:29:04 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 08/13] perf annotate: Factor out struct source_line_percent
Date: Sat, 10 Nov 2012 02:27:19 +0900
Message-Id: <1352482044-3443-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The source_line_percent struct contains percentage value of the symbol
histogram.  This is a preparation of event group view change.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/annotate.c |    2 +-
 tools/perf/util/annotate.c        |   14 +++++++-------
 tools/perf/util/annotate.h        |    8 ++++++--
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index ad943164ece9..feea37ad37e9 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -250,7 +250,7 @@ static double disasm_line__calc_percent(struct disasm_line *dl, struct symbol *s
 		while (offset < (s64)len &&
 		       (next == NULL || offset < next->offset)) {
 			if (src_line) {
-				percent += src_line[offset].percent;
+				percent += src_line[offset].p[0].percent;
 			} else
 				hits += h->addr[offset];
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 5b44c3b1a166..42f8a9d8a9cf 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -654,7 +654,7 @@ static void disasm__calc_percent(struct symbol *sym, struct perf_evsel *evsel,
 			if (*path == NULL)
 				*path = src_line[offset].path;
 
-			*percent += src_line[offset].percent;
+			*percent += src_line[offset].p[0].percent;
 			++offset;
 		}
 	} else {
@@ -959,7 +959,7 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 
 		ret = strcmp(iter->path, src_line->path);
 		if (ret == 0) {
-			iter->percent_sum += src_line->percent;
+			iter->p[0].percent_sum += src_line->p[0].percent;
 			return;
 		}
 
@@ -969,7 +969,7 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 			p = &(*p)->rb_right;
 	}
 
-	src_line->percent_sum = src_line->percent;
+	src_line->p[0].percent_sum = src_line->p[0].percent;
 
 	rb_link_node(&src_line->node, parent, p);
 	rb_insert_color(&src_line->node, root);
@@ -985,7 +985,7 @@ static void __resort_source_line(struct rb_root *root, struct source_line *src_l
 		parent = *p;
 		iter = rb_entry(parent, struct source_line, node);
 
-		if (src_line->percent_sum > iter->percent_sum)
+		if (src_line->p[0].percent_sum > iter->p[0].percent_sum)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -1055,8 +1055,8 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 		u64 offset;
 		FILE *fp;
 
-		src_line[i].percent = 100.0 * h->addr[i] / h->sum;
-		if (src_line[i].percent <= 0.5)
+		src_line[i].p[0].percent = 100.0 * h->addr[i] / h->sum;
+		if (src_line[i].p[0].percent <= 0.5)
 			continue;
 
 		offset = start + i;
@@ -1103,7 +1103,7 @@ static void print_summary(struct rb_root *root, const char *filename)
 		char *path;
 
 		src_line = rb_entry(node, struct source_line, node);
-		percent = src_line->percent_sum;
+		percent = src_line->p[0].percent_sum;
 		color = get_percent_color(percent);
 		path = src_line->path;
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 5ce9ff3ffcd7..ca2badc07653 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -73,11 +73,15 @@ struct sym_hist {
 	u64		addr[0];
 };
 
-struct source_line {
-	struct rb_node	node;
+struct source_line_percent {
 	double		percent;
 	double		percent_sum;
+};
+
+struct source_line {
+	struct rb_node	node;
 	char		*path;
+	struct source_line_percent p[1];
 };
 
 /** struct annotated_source - symbols with hits have this attached as in sannotation
-- 
1.7.9.2

