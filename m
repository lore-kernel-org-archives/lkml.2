Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab1JSSXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:23:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42626 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1JSSXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:23:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/7] perf hists browser: Apply the dso and thread filters when merging new batches
Date: Wed, 19 Oct 2011 16:23:33 -0200
Message-Id: <1319048618-9790-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319048618-9790-1-git-send-email-acme@infradead.org>
References: <1319048618-9790-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now that we dynamicly add entries on the timer we need to not only
traverse all entries when the user zooms into threads and/or DSOs, but
as well after that apply it to the new batches of hist entries in
hists__collapse_resort.

Reported-by: Mike Galbraith <efault@gmx.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zustn633c7hnrae94x6nld1p@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   55 ++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index fdff2a8..75526d1 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -6,6 +6,11 @@
 #include "sort.h"
 #include <math.h>
 
+static bool hists__filter_entry_by_dso(struct hists *hists,
+				       struct hist_entry *he);
+static bool hists__filter_entry_by_thread(struct hists *hists,
+					  struct hist_entry *he);
+
 enum hist_filter {
 	HIST_FILTER__DSO,
 	HIST_FILTER__THREAD,
@@ -338,6 +343,12 @@ static struct rb_root *hists__get_rotate_entries_in(struct hists *hists)
 	return root;
 }
 
+static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
+{
+	hists__filter_entry_by_dso(hists, he);
+	hists__filter_entry_by_thread(hists, he);
+}
+
 static void __hists__collapse_resort(struct hists *hists, bool threaded)
 {
 	struct rb_root *root;
@@ -356,8 +367,15 @@ static void __hists__collapse_resort(struct hists *hists, bool threaded)
 		next = rb_next(&n->rb_node_in);
 
 		rb_erase(&n->rb_node_in, root);
-		if (hists__collapse_insert_entry(hists, &hists->entries_collapsed, n))
+		if (hists__collapse_insert_entry(hists, &hists->entries_collapsed, n)) {
+			/*
+			 * If it wasn't combined with one of the entries already
+			 * collapsed, we need to apply the filters that may have
+			 * been set by, say, the hist_browser.
+			 */
+			hists__apply_filters(hists, n);
 			hists__inc_nr_entries(hists, n);
+		}
 	}
 }
 
@@ -1087,6 +1105,19 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	hists__calc_col_len(hists, h);
 }
 
+
+static bool hists__filter_entry_by_dso(struct hists *hists,
+				       struct hist_entry *he)
+{
+	if (hists->dso_filter != NULL &&
+	    (he->ms.map == NULL || he->ms.map->dso != hists->dso_filter)) {
+		he->filtered |= (1 << HIST_FILTER__DSO);
+		return true;
+	}
+
+	return false;
+}
+
 void hists__filter_by_dso(struct hists *hists)
 {
 	struct rb_node *nd;
@@ -1101,16 +1132,25 @@ void hists__filter_by_dso(struct hists *hists)
 		if (symbol_conf.exclude_other && !h->parent)
 			continue;
 
-		if (hists->dso_filter != NULL &&
-		    (h->ms.map == NULL || h->ms.map->dso != hists->dso_filter)) {
-			h->filtered |= (1 << HIST_FILTER__DSO);
+		if (hists__filter_entry_by_dso(hists, h))
 			continue;
-		}
 
 		hists__remove_entry_filter(hists, h, HIST_FILTER__DSO);
 	}
 }
 
+static bool hists__filter_entry_by_thread(struct hists *hists,
+					  struct hist_entry *he)
+{
+	if (hists->thread_filter != NULL &&
+	    he->thread != hists->thread_filter) {
+		he->filtered |= (1 << HIST_FILTER__THREAD);
+		return true;
+	}
+
+	return false;
+}
+
 void hists__filter_by_thread(struct hists *hists)
 {
 	struct rb_node *nd;
@@ -1122,11 +1162,8 @@ void hists__filter_by_thread(struct hists *hists)
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
-		if (hists->thread_filter != NULL &&
-		    h->thread != hists->thread_filter) {
-			h->filtered |= (1 << HIST_FILTER__THREAD);
+		if (hists__filter_entry_by_thread(hists, h))
 			continue;
-		}
 
 		hists__remove_entry_filter(hists, h, HIST_FILTER__THREAD);
 	}
-- 
1.6.2.5

