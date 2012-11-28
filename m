Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2K1N5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:57:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab2K1Nxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:53:46 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 07/14] perf diff: Add callback to hists__match/hists__link functions
Date: Wed, 28 Nov 2012 14:52:42 +0100
Message-Id: <1354110769-2998-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible different users of hists__match/hists__link will need
specific processing of matching hists_entry data.

Adding callback to hists__match/hists__link functions to allow that.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 11 +++++++++--
 tools/perf/util/hist.c    | 24 +++++++++++++++++-------
 tools/perf/util/hist.h    |  8 ++++++--
 3 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d869029..6361b55 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -472,14 +472,21 @@ static void hists__compute_resort(struct hists *hists)
 	hists->entries = tmp;
 }
 
+static int match_cb(struct hist_entry *a, struct hist_entry *b,
+		    void *data __maybe_unused)
+{
+	hist__entry_add_pair(a, b);
+	return 0;
+}
+
 static void hists__process(struct hists *old, struct hists *new)
 {
-	hists__match(new, old);
+	hists__match(new, old, match_cb, NULL);
 
 	if (show_baseline_only)
 		hists__baseline_only(new);
 	else
-		hists__link(new, old);
+		hists__link(new, old, match_cb, NULL);
 
 	if (sort_compute) {
 		hists__precompute(new);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cb17e2a..0c5843b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -775,18 +775,24 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
 /*
  * Look for pairs to link to the leader buckets (hist_entries):
  */
-void hists__match(struct hists *leader, struct hists *other)
+int hists__match(struct hists *leader, struct hists *other,
+		 hists__entry_cb cb, void *data)
 {
 	struct rb_node *nd;
 	struct hist_entry *pos, *pair;
+	int ret = 0;
 
-	for (nd = rb_first(&leader->entries); nd; nd = rb_next(nd)) {
+	BUG_ON(!cb);
+
+	for (nd = rb_first(&leader->entries); nd && !ret; nd = rb_next(nd)) {
 		pos  = rb_entry(nd, struct hist_entry, rb_node);
 		pair = hists__find_entry(other, pos);
 
 		if (pair)
-			hist__entry_add_pair(pos, pair);
+			ret = cb(pos, pair, data);
 	}
+
+	return ret;
 }
 
 /*
@@ -794,21 +800,25 @@ void hists__match(struct hists *leader, struct hists *other)
  * we find them, just add a dummy entry on the leader hists, with period=0,
  * nr_events=0, to serve as the list header.
  */
-int hists__link(struct hists *leader, struct hists *other)
+int hists__link(struct hists *leader, struct hists *other,
+		hists__entry_cb cb, void *data)
 {
 	struct rb_node *nd;
 	struct hist_entry *pos, *pair;
+	int ret = 0;
 
-	for (nd = rb_first(&other->entries); nd; nd = rb_next(nd)) {
+	BUG_ON(!cb);
+
+	for (nd = rb_first(&other->entries); nd && !ret; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (!hist_entry__has_pairs(pos)) {
 			pair = hists__add_dummy_entry(leader, pos);
 			if (pair == NULL)
 				return -1;
-			hist__entry_add_pair(pair, pos);
+			ret = cb(pos, pair, data);
 		}
 	}
 
-	return 0;
+	return ret;
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 7f5cce8..eb4dc83 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -115,8 +115,12 @@ bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len);
 void hists__reset_col_len(struct hists *hists);
 void hists__calc_col_len(struct hists *hists, struct hist_entry *he);
 
-void hists__match(struct hists *leader, struct hists *other);
-int hists__link(struct hists *leader, struct hists *other);
+typedef int (hists__entry_cb)(struct hist_entry *a, struct hist_entry *b,
+			      void *data);
+int hists__match(struct hists *leader, struct hists *other,
+		 hists__entry_cb cb, void *data);
+int hists__link(struct hists *leader, struct hists *other,
+		hists__entry_cb cb, void *data);
 
 struct perf_hpp {
 	char *buf;
-- 
1.7.11.7

