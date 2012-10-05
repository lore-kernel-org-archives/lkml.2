Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2JEJCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:02:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab2JEJCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:02:38 -0400
Date: Fri, 5 Oct 2012 02:02:03 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-5395a04841fcdd9220177f2c21353fe6d4cd0729@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1349354994-17853-4-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf hists:
  Separate overhead and baseline columns
Git-Commit-ID: 5395a04841fcdd9220177f2c21353fe6d4cd0729
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 02:02:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5395a04841fcdd9220177f2c21353fe6d4cd0729
Gitweb:     http://git.kernel.org/tip/5395a04841fcdd9220177f2c21353fe6d4cd0729
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 4 Oct 2012 21:49:37 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 4 Oct 2012 13:28:49 -0300

perf hists: Separate overhead and baseline columns

Currently the overhead and baseline columns are handled within single
function and the distinction is made by 'baseline hists' pointer passed
by 'struct perf_hpp::ptr'.

Since hists pointer is now part of each hist_entry, it's possible to
locate paired hists pointer directly from the passed struct hist_entry
pointer.

Also separating those 2 columns makes the code more obvious.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1349354994-17853-4-git-send-email-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c       |   74 ++++++++++++++++++++++++++++---------------
 tools/perf/ui/stdio/hist.c |   11 +++++-
 tools/perf/util/hist.h     |    1 +
 3 files changed, 58 insertions(+), 28 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 55b9ca8..532a601 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -8,9 +8,7 @@
 /* hist period print (hpp) functions */
 static int hpp__header_overhead(struct perf_hpp *hpp)
 {
-	const char *fmt = hpp->ptr ? "Baseline" : "Overhead";
-
-	return scnprintf(hpp->buf, hpp->size, fmt);
+	return scnprintf(hpp->buf, hpp->size, "Overhead");
 }
 
 static int hpp__width_overhead(struct perf_hpp *hpp __maybe_unused)
@@ -22,17 +20,6 @@ static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period / hpp->total_period;
 
-	if (hpp->ptr) {
-		struct hists *old_hists = hpp->ptr;
-		u64 total_period = old_hists->stats.total_period;
-		u64 base_period = he->pair ? he->pair->period : 0;
-
-		if (total_period)
-			percent = 100.0 * base_period / total_period;
-		else
-			percent = 0.0;
-	}
-
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
 }
 
@@ -41,17 +28,6 @@ static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 	double percent = 100.0 * he->period / hpp->total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
-	if (hpp->ptr) {
-		struct hists *old_hists = hpp->ptr;
-		u64 total_period = old_hists->stats.total_period;
-		u64 base_period = he->pair ? he->pair->period : 0;
-
-		if (total_period)
-			percent = 100.0 * base_period / total_period;
-		else
-			percent = 0.0;
-	}
-
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
@@ -159,6 +135,47 @@ static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
+static int hpp__header_baseline(struct perf_hpp *hpp)
+{
+	return scnprintf(hpp->buf, hpp->size, "Baseline");
+}
+
+static int hpp__width_baseline(struct perf_hpp *hpp __maybe_unused)
+{
+	return 8;
+}
+
+static double baseline_percent(struct hist_entry *he)
+{
+	struct hist_entry *pair = he->pair;
+	struct hists *pair_hists = pair ? pair->hists : NULL;
+	double percent = 0.0;
+
+	if (pair) {
+		u64 total_period = pair_hists->stats.total_period;
+		u64 base_period  = pair->period;
+
+		percent = 100.0 * base_period / total_period;
+	}
+
+	return percent;
+}
+
+static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = baseline_percent(he);
+
+	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
+}
+
+static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = baseline_percent(he);
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, percent);
+}
+
 static int hpp__header_samples(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%11s";
@@ -269,6 +286,7 @@ static int hpp__entry_displ(struct perf_hpp *hpp,
 	.entry	= hpp__entry_ ## _name
 
 struct perf_hpp_fmt perf_hpp__format[] = {
+	{ .cond = false, HPP__COLOR_PRINT_FNS(baseline) },
 	{ .cond = true,  HPP__COLOR_PRINT_FNS(overhead) },
 	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_sys) },
 	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_us) },
@@ -302,6 +320,8 @@ void perf_hpp__init(bool need_pair, bool show_displacement)
 		perf_hpp__format[PERF_HPP__PERIOD].cond = true;
 
 	if (need_pair) {
+		perf_hpp__format[PERF_HPP__OVERHEAD].cond = false;
+		perf_hpp__format[PERF_HPP__BASELINE].cond = true;
 		perf_hpp__format[PERF_HPP__DELTA].cond = true;
 
 		if (show_displacement)
@@ -321,6 +341,7 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 	const char *sep = symbol_conf.field_sep;
 	char *start = hpp->buf;
 	int i, ret;
+	bool first = true;
 
 	if (symbol_conf.exclude_other && !he->parent)
 		return 0;
@@ -329,9 +350,10 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 		if (!perf_hpp__format[i].cond)
 			continue;
 
-		if (!sep || i > 0) {
+		if (!sep || !first) {
 			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
 			advance_hpp(hpp, ret);
+			first = false;
 		}
 
 		if (color && perf_hpp__format[i].color)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index d7405f0..0aa6776 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -353,6 +353,7 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		.size	= sizeof(bf),
 		.ptr	= pair,
 	};
+	bool first = true;
 
 	init_rem_hits();
 
@@ -364,8 +365,10 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		if (!perf_hpp__format[idx].cond)
 			continue;
 
-		if (idx)
+		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
+		else
+			first = false;
 
 		perf_hpp__format[idx].header(&dummy_hpp);
 		fprintf(fp, "%s", bf);
@@ -400,6 +403,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	if (sep)
 		goto print_entries;
 
+	first = true;
+
 	fprintf(fp, "# ");
 	for (idx = 0; idx < PERF_HPP__MAX_INDEX; idx++) {
 		unsigned int i;
@@ -407,8 +412,10 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		if (!perf_hpp__format[idx].cond)
 			continue;
 
-		if (idx)
+		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
+		else
+			first = false;
 
 		width = perf_hpp__format[idx].width(&dummy_hpp);
 		for (i = 0; i < width; i++)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index efb8fc8..b1a2b9d 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -133,6 +133,7 @@ struct perf_hpp_fmt {
 extern struct perf_hpp_fmt perf_hpp__format[];
 
 enum {
+	PERF_HPP__BASELINE,
 	PERF_HPP__OVERHEAD,
 	PERF_HPP__OVERHEAD_SYS,
 	PERF_HPP__OVERHEAD_US,
