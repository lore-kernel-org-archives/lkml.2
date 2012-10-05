Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2JEJBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:01:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32960 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2JEJBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:01:32 -0400
Date: Fri, 5 Oct 2012 02:01:06 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-dd464345f330c1103f93daad309e8b44845e96cf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1349354994-17853-3-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf diff:
  Refactor diff displacement possition info
Git-Commit-ID: dd464345f330c1103f93daad309e8b44845e96cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 02:01:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd464345f330c1103f93daad309e8b44845e96cf
Gitweb:     http://git.kernel.org/tip/dd464345f330c1103f93daad309e8b44845e96cf
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 4 Oct 2012 21:49:36 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 4 Oct 2012 13:27:56 -0300

perf diff: Refactor diff displacement possition info

Moving the position calculation into the diff command, so the position
as prepared inside struct hist_entry data and there's no need to compute
in the output display path.

Removing 'displacement' from struct perf_hpp as it is no longer needed.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1349354994-17853-3-git-send-email-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c   |   49 ++++++++++++++++++++++++++++---------------
 tools/perf/builtin-report.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/ui/hist.c        |    8 ++++--
 tools/perf/ui/stdio/hist.c  |   17 ++------------
 tools/perf/util/hist.h      |    4 +--
 tools/perf/util/sort.h      |    2 +-
 7 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 761f419..5cb577a 100644
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
 
+static void perf_evlist__resort_hists(struct perf_evlist *evlist, bool name)
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
+	perf_evlist__resort_hists(evlist_old, true);
+	perf_evlist__resort_hists(evlist_new, false);
 
 	list_for_each_entry(evsel, &evlist_new->entries, node) {
 		struct perf_evsel *evsel_old;
@@ -200,7 +215,7 @@ static int __cmd_diff(void)
 
 		hists__match(&evsel_old->hists, &evsel->hists);
 		hists__fprintf(&evsel->hists, &evsel_old->hists,
-			       show_displacement, true, 0, 0, stdout);
+			       true, 0, 0, stdout);
 	}
 
 out_delete:
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1da243d..6748cac 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -320,7 +320,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		const char *evname = perf_evsel__name(pos);
 
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
-		hists__fprintf(hists, NULL, false, true, 0, 0, stdout);
+		hists__fprintf(hists, NULL, true, 0, 0, stdout);
 		fprintf(stdout, "\n\n");
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f0c1c4f..3571158 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -316,7 +316,7 @@ static void perf_top__print_sym_table(struct perf_top *top)
 	hists__output_recalc_col_len(&top->sym_evsel->hists,
 				     top->winsize.ws_row - 3);
 	putchar('\n');
-	hists__fprintf(&top->sym_evsel->hists, NULL, false, false,
+	hists__fprintf(&top->sym_evsel->hists, NULL, false,
 		       top->winsize.ws_row - 4 - printed, win_width, stdout);
 }
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index e3f8cd4..55b9ca8 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -244,13 +244,15 @@ static int hpp__width_displ(struct perf_hpp *hpp __maybe_unused)
 }
 
 static int hpp__entry_displ(struct perf_hpp *hpp,
-			    struct hist_entry *he __maybe_unused)
+			    struct hist_entry *he)
 {
+	struct hist_entry *pair = he->pair;
+	long displacement = pair ? pair->position - he->position : 0;
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%6.6s";
 	char buf[32] = " ";
 
-	if (hpp->displacement)
-		scnprintf(buf, sizeof(buf), "%+4ld", hpp->displacement);
+	if (displacement)
+		scnprintf(buf, sizeof(buf), "%+4ld", displacement);
 
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 882461a..d7405f0 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -308,7 +308,7 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 
 static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 			       struct hists *hists, struct hists *pair_hists,
-			       long displacement, u64 total_period, FILE *fp)
+			       u64 total_period, FILE *fp)
 {
 	char bf[512];
 	int ret;
@@ -316,7 +316,6 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 		.buf		= bf,
 		.size		= size,
 		.total_period	= total_period,
-		.displacement	= displacement,
 		.ptr		= pair_hists,
 	};
 	bool color = !symbol_conf.field_sep;
@@ -337,15 +336,13 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 }
 
 size_t hists__fprintf(struct hists *hists, struct hists *pair,
-		      bool show_displacement, bool show_header, int max_rows,
+		      bool show_header, int max_rows,
 		      int max_cols, FILE *fp)
 {
 	struct sort_entry *se;
 	struct rb_node *nd;
 	size_t ret = 0;
 	u64 total_period;
-	unsigned long position = 1;
-	long displacement = 0;
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
 	const char *col_width = symbol_conf.col_width_list_str;
@@ -449,15 +446,7 @@ print_entries:
 		if (h->filtered)
 			continue;
 
-		if (show_displacement) {
-			if (h->pair != NULL)
-				displacement = ((long)h->pair->position -
-					        (long)position);
-			else
-				displacement = 0;
-			++position;
-		}
-		ret += hist_entry__fprintf(h, max_cols, hists, pair, displacement,
+		ret += hist_entry__fprintf(h, max_cols, hists, pair,
 					   total_period, fp);
 
 		if (max_rows && ++nr_rows >= max_rows)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 6ca7407..efb8fc8 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -99,8 +99,7 @@ void hists__inc_nr_events(struct hists *self, u32 type);
 size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
 
 size_t hists__fprintf(struct hists *self, struct hists *pair,
-		      bool show_displacement, bool show_header,
-		      int max_rows, int max_cols, FILE *fp);
+		      bool show_header, int max_rows, int max_cols, FILE *fp);
 
 int hist_entry__inc_addr_samples(struct hist_entry *self, int evidx, u64 addr);
 int hist_entry__annotate(struct hist_entry *self, size_t privsize);
@@ -120,7 +119,6 @@ struct perf_hpp {
 	size_t size;
 	u64 total_period;
 	const char *sep;
-	long displacement;
 	void *ptr;
 };
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index eb3959b..f070b52 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -73,8 +73,8 @@ struct hist_entry {
 	u8			filtered;
 	char			*srcline;
 	struct symbol		*parent;
+	unsigned long		position;
 	union {
-		unsigned long	  position;
 		struct hist_entry *pair;
 		struct rb_root	  sorted_chain;
 	};
