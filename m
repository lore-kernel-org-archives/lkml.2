Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab2KIVrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:47:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:38570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab2KIVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/21] perf diff: Move hists__match to the hists lib
Date: Fri,  9 Nov 2012 18:42:58 -0300
Message-Id: <1352497390-17716-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Its not 'diff' specific and will be useful for other use cases, like
bucketizing multiple events in a single session.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-o35urjgxfxxm70aw1wa81s4w@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c |   35 +----------------------------------
 tools/perf/util/hist.c    |   37 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h    |    2 ++
 3 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 8a9db38..e99fb3b 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -334,39 +334,6 @@ static void hists__name_resort(struct hists *self, bool sort)
 		self->entries = tmp;
 }
 
-static struct hist_entry *hists__find_entry(struct hists *self,
-					    struct hist_entry *he)
-{
-	struct rb_node *n = self->entries.rb_node;
-
-	while (n) {
-		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
-		int64_t cmp = hist_entry__cmp(he, iter);
-
-		if (cmp < 0)
-			n = n->rb_left;
-		else if (cmp > 0)
-			n = n->rb_right;
-		else
-			return iter;
-	}
-
-	return NULL;
-}
-
-static void hists__match(struct hists *older, struct hists *newer)
-{
-	struct rb_node *nd;
-
-	for (nd = rb_first(&newer->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *pos = rb_entry(nd, struct hist_entry, rb_node),
-				  *pair = hists__find_entry(older, pos);
-
-		if (pair)
-			hist__entry_add_pair(pos, pair);
-	}
-}
-
 static struct perf_evsel *evsel_match(struct perf_evsel *evsel,
 				      struct perf_evlist *evlist)
 {
@@ -520,7 +487,7 @@ static void hists__compute_resort(struct hists *hists)
 
 static void hists__process(struct hists *old, struct hists *new)
 {
-	hists__match(old, new);
+	hists__match(new, old);
 
 	if (show_baseline_only)
 		hists__baseline_only(new);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f42de79..c1de3b0 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -716,3 +716,40 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
 	++hists->stats.nr_events[0];
 	++hists->stats.nr_events[type];
 }
+
+static struct hist_entry *hists__find_entry(struct hists *hists,
+					    struct hist_entry *he)
+{
+	struct rb_node *n = hists->entries.rb_node;
+
+	while (n) {
+		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
+		int64_t cmp = hist_entry__cmp(he, iter);
+
+		if (cmp < 0)
+			n = n->rb_left;
+		else if (cmp > 0)
+			n = n->rb_right;
+		else
+			return iter;
+	}
+
+	return NULL;
+}
+
+/*
+ * Look for pairs to link to the leader buckets (hist_entries):
+ */
+void hists__match(struct hists *leader, struct hists *other)
+{
+	struct rb_node *nd;
+	struct hist_entry *pos, *pair;
+
+	for (nd = rb_first(&leader->entries); nd; nd = rb_next(nd)) {
+		pos  = rb_entry(nd, struct hist_entry, rb_node);
+		pair = hists__find_entry(other, pos);
+
+		if (pair)
+			hist__entry_add_pair(pos, pair);
+	}
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a4f45dd..ff1c396 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -115,6 +115,8 @@ bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len);
 void hists__reset_col_len(struct hists *hists);
 void hists__calc_col_len(struct hists *hists, struct hist_entry *he);
 
+void hists__match(struct hists *leader, struct hists *other);
+
 struct perf_hpp {
 	char *buf;
 	size_t size;
-- 
1.7.9.2.358.g22243

