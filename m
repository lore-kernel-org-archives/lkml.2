Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2KIVni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:43:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48160 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab2KIVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/21] perf annotate: Merge same lines in summary view
Date: Fri,  9 Nov 2012 18:43:05 -0300
Message-Id: <1352497390-17716-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
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
     21.71 /home/namhyung/tmp/mcol.c:26
     20.66 /home/namhyung/tmp/mcol.c:25
      9.53 /home/namhyung/tmp/mcol.c:24
      7.68 /home/namhyung/tmp/mcol.c:25
      7.67 /home/namhyung/tmp/mcol.c:25
      7.66 /home/namhyung/tmp/mcol.c:26
      7.49 /home/namhyung/tmp/mcol.c:26
      6.92 /home/namhyung/tmp/mcol.c:25
      6.81 /home/namhyung/tmp/mcol.c:25
      1.07 /home/namhyung/tmp/mcol.c:26
      0.52 /home/namhyung/tmp/mcol.c:25
      0.51 /home/namhyung/tmp/mcol.c:25
      0.51 /home/namhyung/tmp/mcol.c:24

* after:

  Sorted summary for file /home/namhyung/bin/mcol
  ----------------------------------------------
     50.77 /home/namhyung/tmp/mcol.c:25
     37.94 /home/namhyung/tmp/mcol.c:26
     10.04 /home/namhyung/tmp/mcol.c:24

To do that, introduce percent_sum field so that the normal
line-by-line output doesn't get changed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352440729-21848-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   55 +++++++++++++++++++++++++++++++++++++++++---
 tools/perf/util/annotate.h |    1 +
 2 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 435bf6d..07aaeea 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -858,12 +858,41 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 	struct source_line *iter;
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
+	int ret;
 
 	while (*p != NULL) {
 		parent = *p;
 		iter = rb_entry(parent, struct source_line, node);
 
-		if (src_line->percent > iter->percent)
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
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct source_line, node);
+
+		if (src_line->percent_sum > iter->percent_sum)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -873,6 +902,24 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
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
@@ -897,6 +944,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	struct source_line *src_line;
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
+	struct rb_root tmp_root = RB_ROOT;
 
 	if (!h->sum)
 		return 0;
@@ -931,12 +979,13 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
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
 
@@ -960,7 +1009,7 @@ static void print_summary(struct rb_root *root, const char *filename)
 		char *path;
 
 		src_line = rb_entry(node, struct source_line, node);
-		percent = src_line->percent;
+		percent = src_line->percent_sum;
 		color = get_percent_color(percent);
 		path = src_line->path;
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index c627201..8eec943 100644
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
1.7.9.2.358.g22243

