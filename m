Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0EIQPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 12:15:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:45119 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab0EIQPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 12:15:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/3] perf hist: Simplify the insertion of new hist_entry instances
Date: Sun,  9 May 2010 13:14:57 -0300
Message-Id: <1273421697-30138-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273421697-30138-1-git-send-email-acme@infradead.org>
References: <1273421697-30138-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And with that fix at least one bug:

The first hit for an entry, the one that calls malloc to create a new
instance in __perf_session__add_hist_entry, wasn't adding the count to
the per cpumode (PERF_RECORD_MISC_USER, etc) total variable.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    9 +++------
 tools/perf/builtin-diff.c     |   14 +++-----------
 tools/perf/builtin-report.c   |   12 ++----------
 tools/perf/util/hist.c        |   36 +++++++++++++++++++++++-------------
 tools/perf/util/hist.h        |    5 +----
 5 files changed, 32 insertions(+), 44 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index ee154b5..c7ac45a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -72,8 +72,6 @@ static int annotate__hist_hit(struct hist_entry *he, u64 ip)
 	struct sym_priv *priv;
 	struct sym_hist *h;
 
-	he->count++;
-
 	if (!sym || !he->ms.map)
 		return 0;
 
@@ -99,9 +97,8 @@ static int annotate__hist_hit(struct hist_entry *he, u64 ip)
 }
 
 static int perf_session__add_hist_entry(struct perf_session *self,
-					struct addr_location *al, u64 count)
+					struct addr_location *al)
 {
-	bool hit;
 	struct hist_entry *he;
 
 	if (sym_hist_filter != NULL &&
@@ -115,7 +112,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 		return 0;
 	}
 
-	he = __perf_session__add_hist_entry(&self->hists, al, NULL, count, &hit);
+	he = __perf_session__add_hist_entry(&self->hists, al, NULL, 1);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -135,7 +132,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		return -1;
 	}
 
-	if (!al.filtered && perf_session__add_hist_entry(session, &al, 1)) {
+	if (!al.filtered && perf_session__add_hist_entry(session, &al)) {
 		pr_warning("problem incrementing symbol count, "
 			   "skipping event\n");
 		return -1;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4cce68f..613a5c4 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -25,17 +25,9 @@ static bool show_displacement;
 static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al, u64 count)
 {
-	bool hit;
-	struct hist_entry *he = __perf_session__add_hist_entry(&self->hists,
-							       al, NULL,
-							       count, &hit);
-	if (he == NULL)
-		return -ENOMEM;
-
-	if (hit)
-		__perf_session__add_count(he, al, count);
-
-	return 0;
+	if (__perf_session__add_hist_entry(&self->hists, al, NULL, count) != NULL)
+		return 0;
+	return -ENOMEM;
 }
 
 static int diff__process_sample_event(event_t *event, struct perf_session *session)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3a70c58..5e2f47f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -82,7 +82,6 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 {
 	struct map_symbol *syms = NULL;
 	struct symbol *parent = NULL;
-	bool hit;
 	int err = -ENOMEM;
 	struct hist_entry *he;
 	struct event_stat_id *stats;
@@ -103,19 +102,12 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	if (stats == NULL)
 		goto out_free_syms;
 	he = __perf_session__add_hist_entry(&stats->hists, al, parent,
-					    data->period, &hit);
+					    data->period);
 	if (he == NULL)
 		goto out_free_syms;
-
-	if (hit)
-		__perf_session__add_count(he, al,  data->period);
-
 	err = 0;
-	if (symbol_conf.use_callchain) {
-		if (!hit)
-			callchain_init(he->callchain);
+	if (symbol_conf.use_callchain)
 		err = append_chain(he->callchain, data->callchain, syms);
-	}
 out_free_syms:
 	free(syms);
 	return err;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index ad6b22d..e0c8a72 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -8,13 +8,10 @@ struct callchain_param	callchain_param = {
 	.min_percent = 0.5
 };
 
-void __perf_session__add_count(struct hist_entry *he,
-			struct addr_location *al,
-			u64 count)
+static void perf_session__add_cpumode_count(struct hist_entry *he,
+					    unsigned int cpumode, u64 count)
 {
-	he->count += count;
-
-	switch (al->cpumode) {
+	switch (cpumode) {
 	case PERF_RECORD_MISC_KERNEL:
 		he->count_sys += count;
 		break;
@@ -36,10 +33,24 @@ void __perf_session__add_count(struct hist_entry *he,
  * histogram, sorted on item, collects counts
  */
 
+static struct hist_entry *hist_entry__new(struct hist_entry *template)
+{
+	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_node) : 0;
+	struct hist_entry *self = malloc(sizeof(*self) + callchain_size);
+
+	if (self != NULL) {
+		*self = *template;
+		if (symbol_conf.use_callchain)
+			callchain_init(self->callchain);
+	}
+
+	return self;
+}
+
 struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 						  struct addr_location *al,
 						  struct symbol *sym_parent,
-						  u64 count, bool *hit)
+						  u64 count)
 {
 	struct rb_node **p = &hists->rb_node;
 	struct rb_node *parent = NULL;
@@ -64,8 +75,8 @@ struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 		cmp = hist_entry__cmp(&entry, he);
 
 		if (!cmp) {
-			*hit = true;
-			return he;
+			he->count += count;
+			goto out;
 		}
 
 		if (cmp < 0)
@@ -74,14 +85,13 @@ struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 			p = &(*p)->rb_right;
 	}
 
-	he = malloc(sizeof(*he) + (symbol_conf.use_callchain ?
-				    sizeof(struct callchain_node) : 0));
+	he = hist_entry__new(&entry);
 	if (!he)
 		return NULL;
-	*he = entry;
 	rb_link_node(&he->rb_node, parent, p);
 	rb_insert_color(&he->rb_node, hists);
-	*hit = false;
+out:
+	perf_session__add_cpumode_count(he, al->cpumode, count);
 	return he;
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 9df1c34..b49013a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -12,13 +12,10 @@ struct addr_location;
 struct symbol;
 struct rb_root;
 
-void __perf_session__add_count(struct hist_entry *he,
-			struct addr_location *al,
-			u64 count);
 struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 						  struct addr_location *al,
 						  struct symbol *parent,
-						  u64 count, bool *hit);
+						  u64 count);
 extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
 int hist_entry__fprintf(struct hist_entry *self,
-- 
1.6.2.5

