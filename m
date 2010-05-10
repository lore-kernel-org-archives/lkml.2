Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab0EJXYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:24:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:50158 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab0EJWxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 01/10] perf hist: Calculate max_sym name len and nr_entries
Date: Mon, 10 May 2010 19:52:59 -0300
Message-Id: <1273531987-28956-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273531987-28956-1-git-send-email-acme@infradead.org>
References: <1273531987-28956-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Better done when we are adding entries, be it initially of when we're
re-sorting the histograms.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    6 +++---
 tools/perf/util/hist.c      |   27 ++++++++++++++++++++-------
 tools/perf/util/hist.h      |    4 +++-
 tools/perf/util/symbol.c    |    5 +++--
 tools/perf/util/symbol.h    |    1 +
 5 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 53077fd..d7c7529 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -296,13 +296,13 @@ static int __cmd_report(void)
 	next = rb_first(&session->hists_tree);
 	while (next) {
 		struct hists *hists;
-		u64 nr_hists;
 
 		hists = rb_entry(next, struct hists, rb_node);
 		hists__collapse_resort(hists);
-		nr_hists = hists__output_resort(hists);
+		hists__output_resort(hists);
 		if (use_browser)
-			perf_session__browse_hists(&hists->entries, nr_hists,
+			perf_session__browse_hists(&hists->entries,
+						   hists->nr_entries,
 						   hists->stats.total, help,
 						   input_name);
 		else {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 410cf56..e34fd24 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -47,6 +47,13 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return self;
 }
 
+static void hists__inc_nr_entries(struct hists *self, struct hist_entry *entry)
+{
+	if (entry->ms.sym && self->max_sym_namelen < entry->ms.sym->namelen)
+		self->max_sym_namelen = entry->ms.sym->namelen;
+	++self->nr_entries;
+}
+
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *sym_parent, u64 count)
@@ -89,6 +96,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		return NULL;
 	rb_link_node(&he->rb_node, parent, p);
 	rb_insert_color(&he->rb_node, &self->entries);
+	hists__inc_nr_entries(self, he);
 out:
 	hist_entry__add_cpumode_count(he, al->cpumode, count);
 	return he;
@@ -137,7 +145,7 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */
 
-static void collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
+static bool collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
@@ -153,7 +161,7 @@ static void collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 		if (!cmp) {
 			iter->count += he->count;
 			hist_entry__free(he);
-			return;
+			return false;
 		}
 
 		if (cmp < 0)
@@ -164,6 +172,7 @@ static void collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 
 	rb_link_node(&he->rb_node, parent, p);
 	rb_insert_color(&he->rb_node, root);
+	return true;
 }
 
 void hists__collapse_resort(struct hists *self)
@@ -177,13 +186,16 @@ void hists__collapse_resort(struct hists *self)
 
 	tmp = RB_ROOT;
 	next = rb_first(&self->entries);
+	self->nr_entries = 0;
+	self->max_sym_namelen = 0;
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
 		rb_erase(&n->rb_node, &self->entries);
-		collapse__insert_entry(&tmp, n);
+		if (collapse__insert_entry(&tmp, n))
+			hists__inc_nr_entries(self, n);
 	}
 
 	self->entries = tmp;
@@ -219,30 +231,31 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 	rb_insert_color(&he->rb_node, entries);
 }
 
-u64 hists__output_resort(struct hists *self)
+void hists__output_resort(struct hists *self)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
 	struct hist_entry *n;
 	u64 min_callchain_hits;
-	u64 nr_hists = 0;
 
 	min_callchain_hits = self->stats.total * (callchain_param.min_percent / 100);
 
 	tmp = RB_ROOT;
 	next = rb_first(&self->entries);
 
+	self->nr_entries = 0;
+	self->max_sym_namelen = 0;
+
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
 		rb_erase(&n->rb_node, &self->entries);
 		__hists__insert_output_entry(&tmp, n, min_callchain_hits);
-		++nr_hists;
+		hists__inc_nr_entries(self, n);
 	}
 
 	self->entries = tmp;
-	return nr_hists;
 }
 
 static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index bdde81e..1b18d04 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -19,10 +19,12 @@ struct events_stats {
 struct hists {
 	struct rb_node		rb_node;
 	struct rb_root		entries;
+	u64			nr_entries;
 	struct events_stats	stats;
 	u64			config;
 	u64			event_stream;
 	u32			type;
+	u32			max_sym_namelen;
 };
 
 struct hist_entry *__hists__add_entry(struct hists *self,
@@ -38,7 +40,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
 			 long displacement, bool color, u64 total);
 void hist_entry__free(struct hist_entry *);
 
-u64 hists__output_resort(struct hists *self);
+void hists__output_resort(struct hists *self);
 void hists__collapse_resort(struct hists *self);
 size_t hists__fprintf(struct hists *self, struct hists *pair,
 		      bool show_displacement, FILE *fp);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 994efdb..ecccc8d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -130,8 +130,9 @@ static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 	if (symbol_conf.priv_size)
 		self = ((void *)self) + symbol_conf.priv_size;
 
-	self->start = start;
-	self->end   = len ? start + len - 1 : start;
+	self->start   = start;
+	self->end     = len ? start + len - 1 : start;
+	self->namelen = namelen - 1;
 
 	pr_debug4("%s: %s %#Lx-%#Lx\n", __func__, name, start, self->end);
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index edff866..6389d1a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -54,6 +54,7 @@ struct symbol {
 	struct rb_node	rb_node;
 	u64		start;
 	u64		end;
+	u16		namelen;
 	char		name[0];
 };
 
-- 
1.6.2.5

