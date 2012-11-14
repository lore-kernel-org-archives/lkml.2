Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab2KNHhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:37:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2KNHhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:37:32 -0500
Date: Tue, 13 Nov 2012 23:37:10 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-o35urjgxfxxm70aw1wa81s4w@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Move hists__match to the hists lib
Git-Commit-ID: 95529be47855be6350dfd0b9cd09ea863ca7421f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:37:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95529be47855be6350dfd0b9cd09ea863ca7421f
Gitweb:     http://git.kernel.org/tip/95529be47855be6350dfd0b9cd09ea863ca7421f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 8 Nov 2012 17:54:33 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Nov 2012 17:57:37 -0300

perf diff: Move hists__match to the hists lib

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
