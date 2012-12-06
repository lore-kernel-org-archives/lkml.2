Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423731Ab2LFPMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:12:02 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36311 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423702Ab2LFPL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:11:59 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/5] perf diff: Use internal rb tree for compute resort
Date: Fri,  7 Dec 2012 00:09:40 +0900
Message-Id: <1354806581-5316-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1354806581-5316-1-git-send-email-namhyung@kernel.org>
References: <1354806581-5316-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There's no reason to run hists_compute_resort() using output tree.
Convert it to use internal tree so that it can remove unnecessary
_output_resort.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 044ad99dcc90..f66968e9f853 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -414,19 +414,25 @@ static void insert_hist_entry_by_compute(struct rb_root *root,
 
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
 
 	while (next != NULL) {
-		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *he;
 
-		next = rb_next(&he->rb_node);
+		he = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&he->rb_node_in);
 
-		rb_erase(&he->rb_node, &hists->entries);
-		insert_hist_entry_by_compute(&tmp, he, compute);
+		insert_hist_entry_by_compute(&hists->entries, he, compute);
 	}
-
-	hists->entries = tmp;
 }
 
 static void hists__process(struct hists *old, struct hists *new)
@@ -438,11 +444,11 @@ static void hists__process(struct hists *old, struct hists *new)
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
-- 
1.7.9.2

