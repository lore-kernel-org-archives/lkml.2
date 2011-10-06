Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab1JFRYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:24:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50065 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775Ab1JFRWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/15] perf hists: Allow limiting the number of rows and columns in fprintf
Date: Thu,  6 Oct 2011 14:22:25 -0300
Message-Id: <1317921758-4154-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we can reuse hists__fprintf for in the new perf top tool.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-huazw48x05h8r9niz5cf63za@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c   |    2 +-
 tools/perf/builtin-report.c |    2 +-
 tools/perf/util/hist.c      |   33 +++++++++++++++++++++++++++------
 tools/perf/util/hist.h      |    7 ++++---
 4 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index e821999..b39f3a1 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -162,7 +162,7 @@ static int __cmd_diff(void)
 
 	hists__match(&session[0]->hists, &session[1]->hists);
 	hists__fprintf(&session[1]->hists, &session[0]->hists,
-		       show_displacement, stdout);
+		       show_displacement, true, 0, 0, stdout);
 out_delete:
 	for (i = 0; i < 2; ++i)
 		perf_session__delete(session[i]);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3d58334..b125742 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -232,7 +232,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		const char *evname = event_name(pos);
 
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
-		hists__fprintf(hists, NULL, false, stdout);
+		hists__fprintf(hists, NULL, false, true, 0, 0, stdout);
 		fprintf(stdout, "\n\n");
 	}
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index dd27789..24cca0a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -710,12 +710,16 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 	return ret;
 }
 
-int hist_entry__fprintf(struct hist_entry *self, struct hists *hists,
+int hist_entry__fprintf(struct hist_entry *he, size_t size, struct hists *hists,
 			struct hists *pair_hists, bool show_displacement,
 			long displacement, FILE *fp, u64 session_total)
 {
 	char bf[512];
-	hist_entry__snprintf(self, bf, sizeof(bf), hists, pair_hists,
+
+	if (size == 0 || size > sizeof(bf))
+		size = sizeof(bf);
+
+	hist_entry__snprintf(he, bf, size, hists, pair_hists,
 			     show_displacement, displacement,
 			     true, session_total);
 	return fprintf(fp, "%s\n", bf);
@@ -739,7 +743,8 @@ static size_t hist_entry__fprintf_callchain(struct hist_entry *self,
 }
 
 size_t hists__fprintf(struct hists *hists, struct hists *pair,
-		      bool show_displacement, FILE *fp)
+		      bool show_displacement, bool show_header, int max_rows,
+		      int max_cols, FILE *fp)
 {
 	struct sort_entry *se;
 	struct rb_node *nd;
@@ -749,9 +754,13 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
 	const char *col_width = symbol_conf.col_width_list_str;
+	int nr_rows = 0;
 
 	init_rem_hits();
 
+	if (!show_header)
+		goto print_entries;
+
 	fprintf(fp, "# %s", pair ? "Baseline" : "Overhead");
 
 	if (symbol_conf.show_nr_samples) {
@@ -814,7 +823,10 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 			width = hists__col_len(hists, se->se_width_idx);
 		fprintf(fp, "  %*s", width, se->se_header);
 	}
+
 	fprintf(fp, "\n");
+	if (max_rows && ++nr_rows >= max_rows)
+		goto out;
 
 	if (sep)
 		goto print_entries;
@@ -841,7 +853,13 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 			fprintf(fp, ".");
 	}
 
-	fprintf(fp, "\n#\n");
+	fprintf(fp, "\n");
+	if (max_rows && ++nr_rows >= max_rows)
+		goto out;
+
+	fprintf(fp, "#\n");
+	if (max_rows && ++nr_rows >= max_rows)
+		goto out;
 
 print_entries:
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -858,19 +876,22 @@ print_entries:
 				displacement = 0;
 			++position;
 		}
-		ret += hist_entry__fprintf(h, hists, pair, show_displacement,
+		ret += hist_entry__fprintf(h, max_cols, hists, pair, show_displacement,
 					   displacement, fp, hists->stats.total_period);
 
 		if (symbol_conf.use_callchain)
 			ret += hist_entry__fprintf_callchain(h, hists, fp,
 							     hists->stats.total_period);
+		if (max_rows && ++nr_rows >= max_rows)
+			goto out;
+
 		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(&h->thread->mg,
 						   MAP__FUNCTION, verbose, fp);
 			fprintf(fp, "%.10s end\n", graph_dotted_line);
 		}
 	}
-
+out:
 	free(rem_sq_bracket);
 
 	return ret;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 3beb97c..861ffc3 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -57,9 +57,9 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct symbol *parent, u64 period);
 extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
-int hist_entry__fprintf(struct hist_entry *self, struct hists *hists,
+int hist_entry__fprintf(struct hist_entry *he, size_t size, struct hists *hists,
 			struct hists *pair_hists, bool show_displacement,
-			long displacement, FILE *fp, u64 total);
+			long displacement, FILE *fp, u64 session_total);
 int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
 			 struct hists *hists, struct hists *pair_hists,
 			 bool show_displacement, long displacement,
@@ -73,7 +73,8 @@ void hists__inc_nr_events(struct hists *self, u32 type);
 size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
 
 size_t hists__fprintf(struct hists *self, struct hists *pair,
-		      bool show_displacement, FILE *fp);
+		      bool show_displacement, bool show_header,
+		      int max_rows, int max_cols, FILE *fp);
 
 int hist_entry__inc_addr_samples(struct hist_entry *self, int evidx, u64 addr);
 int hist_entry__annotate(struct hist_entry *self, size_t privsize);
-- 
1.6.2.5

