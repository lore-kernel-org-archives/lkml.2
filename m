Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2LJIaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:30:07 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55008 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2LJIaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:30:04 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-34-50c59d888259
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        namhyung.kim@lge.com
Subject: [PATCH 3/4] perf diff: Use internal rb tree for compute resort
Date: Mon, 10 Dec 2012 17:29:56 +0900
Message-Id: <1355128197-18193-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355128197-18193-1-git-send-email-namhyung@kernel.org>
References: <1355128197-18193-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There's no reason to run hists_compute_resort() using output tree.
Convert it to use internal tree so that it can remove unnecessary
_output_resort.

Cc: Stephane Eranian <eranian@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 31 +++++++++++++++++++++----------
 tools/perf/util/hist.c    |  2 +-
 tools/perf/util/hist.h    |  1 +
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 8b896f5eded0..4af0b580b046 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -414,19 +414,30 @@ static void insert_hist_entry_by_compute(struct rb_root *root,
 
 static void hists__compute_resort(struct hists *hists)
 {
-	struct rb_root tmp = RB_ROOT;
-	struct rb_node *next = rb_first(&hists->entries);
+	struct rb_root *root;
+	struct rb_node *next;
+
+	if (sort__need_collapse)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
+
+	hists->entries = RB_ROOT;
+	next = rb_first(root);
+
+	hists->nr_entries = 0;
+	hists->stats.total_period = 0;
+	hists__reset_col_len(hists);
 
 	while (next != NULL) {
-		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *he;
 
-		next = rb_next(&he->rb_node);
+		he = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&he->rb_node_in);
 
-		rb_erase(&he->rb_node, &hists->entries);
-		insert_hist_entry_by_compute(&tmp, he, compute);
+		insert_hist_entry_by_compute(&hists->entries, he, compute);
+		hists__inc_nr_entries(hists, he);
 	}
-
-	hists->entries = tmp;
 }
 
 static void hists__process(struct hists *old, struct hists *new)
@@ -438,11 +449,11 @@ static void hists__process(struct hists *old, struct hists *new)
 	else
 		hists__link(new, old);
 
-	hists__output_resort(new);
-
 	if (sort_compute) {
 		hists__precompute(new);
 		hists__compute_resort(new);
+	} else {
+		hists__output_resort(new);
 	}
 
 	hists__fprintf(new, true, 0, 0, stdout);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 8ff3c2f8a5dd..37179af74409 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -251,7 +251,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return he;
 }
 
-static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
+void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 5b3b0075be64..d3664abea6d6 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -96,6 +96,7 @@ void hists__decay_entries_threaded(struct hists *hists, bool zap_user,
 				   bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
+void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *self, u32 type);
 size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
 
-- 
1.7.11.7

