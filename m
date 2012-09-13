Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2IMH3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:29:36 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46467 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab2IMH1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:06 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-05-50518ac7f7aa
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 07/15] perf hists: Check if accumulated when adding a hist entry
Date: Thu, 13 Sep 2012 16:20:03 +0900
Message-Id: <1347520811-28150-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

To support callchain accumulation, @entry should be recognized if it's
accumulated or not when add_hist_entry() called.  The period of an
accumulated entry should be added to ->stat_acc but not ->stat. Add
@sample_self arg for that.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 62 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2802302e5904..46433a0830dd 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -234,26 +234,50 @@ void hists__decay_entries_threaded(struct hists *hists,
  * histogram, sorted on item, collects periods
  */
 
-static struct hist_entry *hist_entry__new(struct hist_entry *template)
+static struct hist_entry *hist_entry__new_callchain(struct hist_entry *template,
+						    bool sample_self)
 {
-	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
+	const size_t callchain_size = sizeof(struct callchain_root);
 	struct hist_entry *he = malloc(sizeof(*he) + callchain_size);
 
+	if (he == NULL)
+		return NULL;
+
+	*he = *template;
+
+	if (symbol_conf.cumulate_callchain) {
+		he->stat_acc = malloc(sizeof(he->stat));
+		if (he->stat_acc == NULL) {
+			free(he);
+			return NULL;
+		}
+		memcpy(he->stat_acc, &he->stat, sizeof(he->stat));
+		if (!sample_self)
+			memset(&he->stat, 0, sizeof(he->stat));
+	}
+
+	if (he->ms.map)
+		he->ms.map->referenced = true;
+
+	callchain_init(he->callchain);
+
+	return he;
+}
+
+static struct hist_entry *hist_entry__new(struct hist_entry *template,
+					  bool sample_self)
+{
+	struct hist_entry *he;
+
+	if (symbol_conf.use_callchain)
+		return hist_entry__new_callchain(template, sample_self);
+
+	he = malloc(sizeof(*he));
 	if (he != NULL) {
 		*he = *template;
-		if (symbol_conf.cumulate_callchain) {
-			he->stat_acc = malloc(sizeof(he->stat));
-			if (he->stat_acc == NULL) {
-				free(he);
-				return NULL;
-			}
-			memcpy(he->stat_acc, &he->stat, sizeof(he->stat));
-		}
 
 		if (he->ms.map)
 			he->ms.map->referenced = true;
-		if (symbol_conf.use_callchain)
-			callchain_init(he->callchain);
 	}
 
 	return he;
@@ -278,7 +302,7 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 static struct hist_entry *add_hist_entry(struct hists *hists,
 				      struct hist_entry *entry,
 				      struct addr_location *al,
-				      u64 period)
+				      u64 period, bool sample_self)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -296,7 +320,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(entry, he);
 
 		if (!cmp) {
-			hist_entry__add_period(&he->stat, period);
+			if (sample_self)
+				hist_entry__add_period(&he->stat, period);
 			if (symbol_conf.cumulate_callchain)
 				hist_entry__add_period(he->stat_acc, period);
 
@@ -320,14 +345,15 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 			p = &(*p)->rb_right;
 	}
 
-	he = hist_entry__new(entry);
+	he = hist_entry__new(entry, sample_self);
 	if (!he)
 		goto out_unlock;
 
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-	hist_entry__add_cpumode_period(&he->stat, al->cpumode, period);
+	if (sample_self)
+		hist_entry__add_cpumode_period(&he->stat, al->cpumode, period);
 	if (symbol_conf.cumulate_callchain)
 		hist_entry__add_cpumode_period(he->stat_acc, al->cpumode,
 					       period);
@@ -360,7 +386,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.branch_info = bi,
 	};
 
-	return add_hist_entry(self, &entry, al, period);
+	return add_hist_entry(self, &entry, al, period, true);
 }
 
 struct hist_entry *__hists__add_entry(struct hists *self,
@@ -384,7 +410,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.filtered = symbol__parent_filter(sym_parent),
 	};
 
-	return add_hist_entry(self, &entry, al, period);
+	return add_hist_entry(self, &entry, al, period, true);
 }
 
 int64_t
-- 
1.7.11.4

