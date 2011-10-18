Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1JRVpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:45:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43287 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab1JRVoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:44:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/7] perf hists: Don't format the percentage on hist_entry__snprintf
Date: Tue, 18 Oct 2011 19:44:04 -0200
Message-Id: <1318974247-6683-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318974247-6683-1-git-send-email-acme@infradead.org>
References: <1318974247-6683-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We can't have color correctly set there because in libslang (and in a future
GUI) the colors must be set on a separate function call, so move that part to a
separate function and make the stdio fprintf function call it.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jpgy42438ce9tgbqppm397lq@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c              |   29 ++++++++++++++++++++---------
 tools/perf/util/hist.h              |    4 +---
 tools/perf/util/ui/browsers/hists.c |    7 ++++---
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 48da373..8d15e9f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -707,12 +707,11 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows)
 	}
 }
 
-int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
-			 struct hists *hists, struct hists *pair_hists,
-			 bool show_displacement, long displacement,
-			 bool color, u64 session_total)
+static int hist_entry__pcnt_snprintf(struct hist_entry *self, char *s,
+				     size_t size, struct hists *pair_hists,
+				     bool show_displacement, long displacement,
+				     bool color, u64 session_total)
 {
-	struct sort_entry *se;
 	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
 	u64 nr_events;
 	const char *sep = symbol_conf.field_sep;
@@ -818,12 +817,22 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 		}
 	}
 
+	return ret;
+}
+
+int hist_entry__snprintf(struct hist_entry *he, char *s, size_t size,
+			 struct hists *hists)
+{
+	const char *sep = symbol_conf.field_sep;
+	struct sort_entry *se;
+	int ret = 0;
+
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
 
 		ret += snprintf(s + ret, size - ret, "%s", sep ?: "  ");
-		ret += se->se_snprintf(self, s + ret, size - ret,
+		ret += se->se_snprintf(he, s + ret, size - ret,
 				       hists__col_len(hists, se->se_width_idx));
 	}
 
@@ -835,13 +844,15 @@ int hist_entry__fprintf(struct hist_entry *he, size_t size, struct hists *hists,
 			long displacement, FILE *fp, u64 session_total)
 {
 	char bf[512];
+	int ret;
 
 	if (size == 0 || size > sizeof(bf))
 		size = sizeof(bf);
 
-	hist_entry__snprintf(he, bf, size, hists, pair_hists,
-			     show_displacement, displacement,
-			     true, session_total);
+	ret = hist_entry__pcnt_snprintf(he, bf, size, pair_hists,
+					show_displacement, displacement,
+					true, session_total);
+	hist_entry__snprintf(he, bf + ret, size - ret, hists);
 	return fprintf(fp, "%s\n", bf);
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ea96c1c..f338cb0 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -68,9 +68,7 @@ int hist_entry__fprintf(struct hist_entry *he, size_t size, struct hists *hists,
 			struct hists *pair_hists, bool show_displacement,
 			long displacement, FILE *fp, u64 session_total);
 int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
-			 struct hists *hists, struct hists *pair_hists,
-			 bool show_displacement, long displacement,
-			 bool color, u64 total);
+			 struct hists *hists);
 void hist_entry__free(struct hist_entry *);
 
 void hists__output_resort(struct hists *self);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 2d390b9..0eced19 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -547,7 +547,7 @@ static int hist_browser__show_entry(struct hist_browser *self,
 	char s[256];
 	double percent;
 	int printed = 0;
-	int width = self->b.width;
+	int width = self->b.width - 6; /* The percentage */
 	char folded_sign = ' ';
 	bool current_entry = ui_browser__is_current_entry(&self->b, row);
 	off_t row_offset = entry->row_offset;
@@ -563,8 +563,7 @@ static int hist_browser__show_entry(struct hist_browser *self,
 	}
 
 	if (row_offset == 0) {
-		hist_entry__snprintf(entry, s, sizeof(s), self->hists, NULL, false,
-				     0, false, self->hists->stats.total_period);
+		hist_entry__snprintf(entry, s, sizeof(s), self->hists);
 		percent = (entry->period * 100.0) / self->hists->stats.total_period;
 
 		ui_browser__set_percent_color(&self->b, percent, current_entry);
@@ -574,6 +573,8 @@ static int hist_browser__show_entry(struct hist_browser *self,
 			width -= 2;
 		}
 
+		slsmg_printf(" %5.2f%%", percent);
+
 		/* The scroll bar isn't being used */
 		if (!self->b.navkeypressed)
 			width += 1;
-- 
1.6.2.5

