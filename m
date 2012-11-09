Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2KIBK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 20:10:57 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56025 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab2KIBKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 20:10:40 -0500
X-AuditID: 9c93016f-b7bccae000000e33-74-509c580d012c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/3] perf annotate: Merge same lines in summary view
Date: Fri,  9 Nov 2012 10:10:11 +0900
Message-Id: <1352423412-4895-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352423412-4895-1-git-send-email-namhyung@kernel.org>
References: <1352423412-4895-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The --print-line option of perf annotate command shows summary for
each source line.  But it didn't merge same lines so that it can
appear multiple times.

* before:

Sorted summary for file /home/namhyung/bin/mcol
----------------------------------------------

   24.40 /home/namhyung/tmp/mcol.c:26
   21.58 /home/namhyung/tmp/mcol.c:25
   10.14 /home/namhyung/tmp/mcol.c:24
    8.59 /home/namhyung/tmp/mcol.c:25
    8.57 /home/namhyung/tmp/mcol.c:25
    8.42 /home/namhyung/tmp/mcol.c:26
    8.31 /home/namhyung/tmp/mcol.c:26
    8.30 /home/namhyung/tmp/mcol.c:25
    0.80 /home/namhyung/tmp/mcol.c:26

* after:

Sorted summary for file /home/namhyung/bin/mcol
----------------------------------------------

   41.93 /home/namhyung/tmp/mcol.c:26
   10.14 /home/namhyung/tmp/mcol.c:24
   47.04 /home/namhyung/tmp/mcol.c:25

To do that, introduce percent_sum field so that the normal
line-by-line output doesn't get changed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c | 53 ++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/annotate.h |  1 +
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 83b1078260e3..d604a90c60ef 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -887,6 +887,35 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 	struct source_line *iter;
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
+	int ret;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct source_line, node);
+
+		ret = strcmp(iter->path, src_line->path);
+		if (ret == 0) {
+			iter->percent_sum += src_line->percent;
+			return;
+		}
+
+		if (ret < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	src_line->percent_sum = src_line->percent;
+
+	rb_link_node(&src_line->node, parent, p);
+	rb_insert_color(&src_line->node, root);
+}
+
+static void __resort_source_line(struct rb_root *root, struct source_line *src_line)
+{
+	struct source_line *iter;
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
 
 	while (*p != NULL) {
 		parent = *p;
@@ -902,6 +931,24 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 	rb_insert_color(&src_line->node, root);
 }
 
+static void resort_source_line(struct rb_root *dest_root, struct rb_root *src_root)
+{
+	struct source_line *src_line;
+	struct rb_node *node;
+
+	node = rb_first(src_root);
+	while (node) {
+		struct rb_node *next;
+
+		src_line = rb_entry(node, struct source_line, node);
+		next = rb_next(node);
+		rb_erase(node, src_root);
+
+		__resort_source_line(dest_root, src_line);
+		node = next;
+	}
+}
+
 static void symbol__free_source_line(struct symbol *sym, int len)
 {
 	struct annotation *notes = symbol__annotation(sym);
@@ -926,6 +973,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	struct source_line *src_line;
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
+	struct rb_root tmp_root = RB_ROOT;
 
 	if (!h->sum)
 		return 0;
@@ -960,12 +1008,13 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 			goto next;
 
 		strcpy(src_line[i].path, path);
-		insert_source_line(root, &src_line[i]);
+		insert_source_line(&tmp_root, &src_line[i]);
 
 	next:
 		pclose(fp);
 	}
 
+	resort_source_line(root, &tmp_root);
 	return 0;
 }
 
@@ -989,7 +1038,7 @@ static void print_summary(struct rb_root *root, const char *filename)
 		char *path;
 
 		src_line = rb_entry(node, struct source_line, node);
-		percent = src_line->percent;
+		percent = src_line->percent_sum;
 		color = get_percent_color(percent);
 		path = src_line->path;
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index c6272011625a..8eec94358a4a 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -76,6 +76,7 @@ struct sym_hist {
 struct source_line {
 	struct rb_node	node;
 	double		percent;
+	double		percent_sum;
 	char		*path;
 };
 
-- 
1.7.11.7

