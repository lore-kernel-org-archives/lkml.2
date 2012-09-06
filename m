Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab2IFPsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:48:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758601Ab2IFPsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:48:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 04/12] perf diff: Refactor diff displacement possition info
Date: Thu,  6 Sep 2012 17:46:58 +0200
Message-Id: <1346946426-13496-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving the position calculation into the diff command, so the position
is prepared inside hist_entry data and there's no need to compute in
the output display path.

It will be needed for next cleanup patches.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-diff.c  | 47 ++++++++++++++++++++++++++++++----------------
 tools/perf/ui/stdio/hist.c |  4 +---
 tools/perf/util/sort.h     |  2 +-
 3 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index e9933fd..4e63979 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -70,8 +70,8 @@ static struct perf_tool tool = {
 	.ordering_requires_timestamps = true,
 };
 
-static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
-						    struct hist_entry *he)
+static void insert_hist_entry_by_name(struct rb_root *root,
+				      struct hist_entry *he)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
@@ -90,7 +90,7 @@ static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
 	rb_insert_color(&he->rb_node, root);
 }
 
-static void hists__resort_entries(struct hists *self)
+static void hists__name_resort(struct hists *self, bool sort)
 {
 	unsigned long position = 1;
 	struct rb_root tmp = RB_ROOT;
@@ -100,12 +100,16 @@ static void hists__resort_entries(struct hists *self)
 		struct hist_entry *n = rb_entry(next, struct hist_entry, rb_node);
 
 		next = rb_next(&n->rb_node);
-		rb_erase(&n->rb_node, &self->entries);
 		n->position = position++;
-		perf_session__insert_hist_entry_by_name(&tmp, n);
+
+		if (sort) {
+			rb_erase(&n->rb_node, &self->entries);
+			insert_hist_entry_by_name(&tmp, n);
+		}
 	}
 
-	self->entries = tmp;
+	if (sort)
+		self->entries = tmp;
 }
 
 static struct hist_entry *hists__find_entry(struct hists *self,
@@ -121,7 +125,7 @@ static struct hist_entry *hists__find_entry(struct hists *self,
 			n = n->rb_left;
 		else if (cmp > 0)
 			n = n->rb_right;
-		else 
+		else
 			return iter;
 	}
 
@@ -150,6 +154,24 @@ static struct perf_evsel *evsel_match(struct perf_evsel *evsel,
 	return NULL;
 }
 
+static void resort_evlist(struct perf_evlist *evlist, bool name)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		struct hists *hists = &evsel->hists;
+
+		hists__output_resort(hists);
+
+		/*
+		 * The hists__name_resort only sets possition
+		 * if name is false.
+		 */
+		if (name || ((!name) && show_displacement))
+			hists__name_resort(hists, name);
+	}
+}
+
 static int __cmd_diff(void)
 {
 	int ret, i;
@@ -176,15 +198,8 @@ static int __cmd_diff(void)
 	evlist_old = older->evlist;
 	evlist_new = newer->evlist;
 
-	list_for_each_entry(evsel, &evlist_new->entries, node)
-		hists__output_resort(&evsel->hists);
-
-	list_for_each_entry(evsel, &evlist_old->entries, node) {
-		hists__output_resort(&evsel->hists);
-
-		if (show_displacement)
-			hists__resort_entries(&evsel->hists);
-	}
+	resort_evlist(evlist_old, true);
+	resort_evlist(evlist_new, false);
 
 	list_for_each_entry(evsel, &evlist_new->entries, node) {
 		struct perf_evsel *evsel_old;
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 9bf7e9e..4ae9ee5 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -472,7 +472,6 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	struct rb_node *nd;
 	size_t ret = 0;
 	u64 total_period;
-	unsigned long position = 1;
 	long displacement = 0;
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
@@ -607,10 +606,9 @@ print_entries:
 		if (show_displacement) {
 			if (h->pair != NULL)
 				displacement = ((long)h->pair->position -
-					        (long)position);
+					        (long)h->position);
 			else
 				displacement = 0;
-			++position;
 		}
 		ret += hist_entry__fprintf(h, max_cols, hists, pair, show_displacement,
 					   displacement, total_period, fp);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b0b4752..967d381 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -72,8 +72,8 @@ struct hist_entry {
 	u8			filtered;
 	char			*srcline;
 	struct symbol		*parent;
+	unsigned long		position;
 	union {
-		unsigned long	  position;
 		struct hist_entry *pair;
 		struct rb_root	  sorted_chain;
 	};
-- 
1.7.11.4

