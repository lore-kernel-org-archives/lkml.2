Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2LEG5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 01:57:25 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44066 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2LEG4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 01:56:49 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-40-50bef02e5b70
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf diff: Use internal rb tree for compute resort
Date: Wed,  5 Dec 2012 15:56:43 +0900
Message-Id: <1354690603-31364-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
References: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There's no reason to run hists_compute_resort() using output tree.
Convert it to use internal tree so that it can remove unnecessary
_output_resort.  Also move position computation below the resort since
it changes the output ordering.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b52f5d8c4a6b..4e18cea7c845 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -435,19 +435,25 @@ static void insert_hist_entry_by_compute(struct rb_root *root,
 
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
@@ -459,16 +465,16 @@ static void hists__process(struct hists *old, struct hists *new)
 	else
 		hists__link(new, old);
 
-	hists__output_resort(new);
-
-	if (show_displacement)
-		hists__compute_position(new);
-
 	if (sort_compute) {
 		hists__precompute(new);
 		hists__compute_resort(new);
+	} else {
+		hists__output_resort(new);
 	}
 
+	if (show_displacement)
+		hists__compute_position(new);
+
 	hists__fprintf(new, true, 0, 0, stdout);
 }
 
-- 
1.7.11.7

