Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2KIVrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:47:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:38569 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2KIVn1 (ORCPT
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
Subject: [PATCH 10/21] perf hists: Introduce hists__link
Date: Fri,  9 Nov 2012 18:42:59 -0300
Message-Id: <1352497390-17716-11-git-send-email-acme@infradead.org>
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

That given two hists will find the hist_entries (buckets) in the second
hists that are for the same bucket in the first and link them, then it
will look for all buckets in the second that don't have a counterpart in
the first and will create a dummy counterpart that will then be linked
to the entry in the second.

For multiple events this will be done pairing the leader with all the
other events in the group, so that in the end the leader will have all
the buckets in all the hists in a group, dummy or not while the other
hists will be left untouched.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-l9l9ieozqdhn9lieokd95okw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h |    1 +
 2 files changed, 61 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c1de3b0..7c6e73b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -717,6 +717,42 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
 	++hists->stats.nr_events[type];
 }
 
+static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
+						 struct hist_entry *pair)
+{
+	struct rb_node **p = &hists->entries.rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *he;
+	int cmp;
+
+	while (*p != NULL) {
+		parent = *p;
+		he = rb_entry(parent, struct hist_entry, rb_node);
+
+		cmp = hist_entry__cmp(pair, he);
+
+		if (!cmp)
+			goto out;
+
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	he = hist_entry__new(pair);
+	if (he) {
+		he->stat.nr_events = 0;
+		he->stat.period    = 0;
+		he->hists	   = hists;
+		rb_link_node(&he->rb_node, parent, p);
+		rb_insert_color(&he->rb_node, &hists->entries);
+		hists__inc_nr_entries(hists, he);
+	}
+out:
+	return he;
+}
+
 static struct hist_entry *hists__find_entry(struct hists *hists,
 					    struct hist_entry *he)
 {
@@ -753,3 +789,27 @@ void hists__match(struct hists *leader, struct hists *other)
 			hist__entry_add_pair(pos, pair);
 	}
 }
+
+/*
+ * Look for entries in the other hists that are not present in the leader, if
+ * we find them, just add a dummy entry on the leader hists, with period=0,
+ * nr_events=0, to serve as the list header.
+ */
+int hists__link(struct hists *leader, struct hists *other)
+{
+	struct rb_node *nd;
+	struct hist_entry *pos, *pair;
+
+	for (nd = rb_first(&other->entries); nd; nd = rb_next(nd)) {
+		pos = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (!hist_entry__has_pairs(pos)) {
+			pair = hists__add_dummy_entry(leader, pos);
+			if (pair == NULL)
+				return -1;
+			hist__entry_add_pair(pair, pos);
+		}
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ff1c396..1278c2c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -116,6 +116,7 @@ void hists__reset_col_len(struct hists *hists);
 void hists__calc_col_len(struct hists *hists, struct hist_entry *he);
 
 void hists__match(struct hists *leader, struct hists *other);
+int hists__link(struct hists *leader, struct hists *other);
 
 struct perf_hpp {
 	char *buf;
-- 
1.7.9.2.358.g22243

