Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab2HVFzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:55:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52603 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab2HVFz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:55:27 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-2e-5034744deb5f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/5] perf hists: Handle field separator properly
Date: Wed, 22 Aug 2012 14:48:34 +0900
Message-Id: <1345614517-5753-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1345614517-5753-1-git-send-email-namhyung@kernel.org>
References: <1345614517-5753-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When a field separator is given, the output format doesn't need to be
fancy like aligning to column length, coloring the percent value and
so on.  And since there's a slight difference to normal format, fix it
not to break backward compatibility.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c       | 75 ++++++++++++++++++++++++++++++----------------
 tools/perf/ui/stdio/hist.c |  3 +-
 2 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index c9a566cfd9c2..802a8659c15a 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -8,10 +8,9 @@
 /* hist period print (hpp) functions */
 static int hpp__header_overhead(struct perf_hpp *hpp)
 {
-	if (hpp->ptr)
-		return scnprintf(hpp->buf, hpp->size, "Baseline");
-	else
-		return scnprintf(hpp->buf, hpp->size, "Overhead");
+	const char *fmt = hpp->ptr ? "Baseline" : "Overhead";
+
+	return scnprintf(hpp->buf, hpp->size, fmt);
 }
 
 static int hpp__width_overhead(struct perf_hpp *hpp __used)
@@ -28,12 +27,16 @@ static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period / hpp->total_period;
-	return scnprintf(hpp->buf, hpp->size, "  %5.2f%%", percent);
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "  %5.2f%%";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
 static int hpp__header_overhead_sys(struct perf_hpp *hpp)
 {
-	return scnprintf(hpp->buf, hpp->size, " sys  ");
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%6s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, "sys");
 }
 
 static int hpp__width_overhead_sys(struct perf_hpp *hpp __used)
@@ -50,12 +53,16 @@ static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_sys / hpp->total_period;
-	return scnprintf(hpp->buf, hpp->size, "%5.2f%%", percent);
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%5.2f%%";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
 static int hpp__header_overhead_us(struct perf_hpp *hpp)
 {
-	return scnprintf(hpp->buf, hpp->size, " user ");
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%6s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, "user");
 }
 
 static int hpp__width_overhead_us(struct perf_hpp *hpp __used)
@@ -72,7 +79,9 @@ static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_us / hpp->total_period;
-	return scnprintf(hpp->buf, hpp->size, "%5.2f%%", percent);
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%5.2f%%";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
 static int hpp__header_overhead_guest_sys(struct perf_hpp *hpp)
@@ -96,7 +105,9 @@ static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
 					 struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_guest_sys / hpp->total_period;
-	return scnprintf(hpp->buf, hpp->size, "  %5.2f%% ", percent);
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "  %5.2f%% ";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
 static int hpp__header_overhead_guest_us(struct perf_hpp *hpp)
@@ -120,12 +131,16 @@ static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
 					struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_guest_us / hpp->total_period;
-	return scnprintf(hpp->buf, hpp->size, "  %5.2f%% ", percent);
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "  %5.2f%% ";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
 static int hpp__header_samples(struct perf_hpp *hpp)
 {
-	return scnprintf(hpp->buf, hpp->size, "  Samples  ");
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%11s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, "Samples");
 }
 
 static int hpp__width_samples(struct perf_hpp *hpp __used)
@@ -135,12 +150,16 @@ static int hpp__width_samples(struct perf_hpp *hpp __used)
 
 static int hpp__entry_samples(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	return scnprintf(hpp->buf, hpp->size, "%11" PRIu64, he->nr_events);
+	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%11" PRIu64;
+
+	return scnprintf(hpp->buf, hpp->size, fmt, he->nr_events);
 }
 
 static int hpp__header_period(struct perf_hpp *hpp)
 {
-	return scnprintf(hpp->buf, hpp->size, "   Period   ");
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, "Period");
 }
 
 static int hpp__width_period(struct perf_hpp *hpp __used)
@@ -150,12 +169,16 @@ static int hpp__width_period(struct perf_hpp *hpp __used)
 
 static int hpp__entry_period(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	return scnprintf(hpp->buf, hpp->size, "%12" PRIu64, he->period);
+	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
+
+	return scnprintf(hpp->buf, hpp->size, fmt, he->period);
 }
 
 static int hpp__header_delta(struct perf_hpp *hpp)
 {
-	return scnprintf(hpp->buf, hpp->size, " Delta ");
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, "Delta");
 }
 
 static int hpp__width_delta(struct perf_hpp *hpp __used)
@@ -169,7 +192,8 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 	u64 old_total, new_total;
 	double old_percent = 0, new_percent = 0;
 	double diff;
-	char buf[32];
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%7.7s";
+	char buf[32] = " ";
 
 	old_total = pair_hists->stats.total_period;
 	if (old_total > 0)
@@ -180,11 +204,10 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 		new_percent = 100.0 * he->period / new_total;
 
 	diff = new_percent - old_percent;
-	if (fabs(diff) < 0.01)
-		return scnprintf(hpp->buf, hpp->size, "       ");
+	if (fabs(diff) >= 0.01)
+		scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
 
-	scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
-	return scnprintf(hpp->buf, hpp->size, "%7.7s", buf);
+	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
 static int hpp__header_displ(struct perf_hpp *hpp)
@@ -199,13 +222,13 @@ static int hpp__width_displ(struct perf_hpp *hpp __used)
 
 static int hpp__entry_displ(struct perf_hpp *hpp, struct hist_entry *he __used)
 {
-	char buf[32];
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%6.6s";
+	char buf[32] = " ";
 
-	if (!hpp->displacement)
-		return scnprintf(hpp->buf, hpp->size, "     ");
+	if (hpp->displacement)
+		scnprintf(buf, sizeof(buf), "%+4ld", hpp->displacement);
 
-	scnprintf(buf, sizeof(buf), "%+4ld", hpp->displacement);
-	return scnprintf(hpp->buf, hpp->size, "%6.6s", buf);
+	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
 #define HPP__COLOR_PRINT_FNS(_name)		\
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 4228b4c6b72d..882461a42830 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -319,11 +319,12 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 		.displacement	= displacement,
 		.ptr		= pair_hists,
 	};
+	bool color = !symbol_conf.field_sep;
 
 	if (size == 0 || size > sizeof(bf))
 		size = hpp.size = sizeof(bf);
 
-	ret = hist_entry__period_snprintf(&hpp, he, true);
+	ret = hist_entry__period_snprintf(&hpp, he, color);
 	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
 
 	ret = fprintf(fp, "%s\n", bf);
-- 
1.7.11.4

