Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2IIIz4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 04:55:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2IIIzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 04:55:54 -0400
Date: Sun, 9 Sep 2012 01:55:35 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-9ffad987ff565999d91fc2783dd77f08094a743b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1346640790-17197-3-git-send-email-namhyung@kernel.org>
References: <1346640790-17197-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Handle field separator properly
Git-Commit-ID: 9ffad987ff565999d91fc2783dd77f08094a743b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 09 Sep 2012 01:55:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ffad987ff565999d91fc2783dd77f08094a743b
Gitweb:     http://git.kernel.org/tip/9ffad987ff565999d91fc2783dd77f08094a743b
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 3 Sep 2012 11:53:07 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 8 Sep 2012 13:19:55 -0300

perf hists: Handle field separator properly

When a field separator is given, the output format doesn't need to be
fancy like aligning to column length, coloring the percent value and so
on.  And since there's a slight difference to normal format, fix it not
to break backward compatibility.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346640790-17197-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c       |   74 ++++++++++++++++++++++++++++---------------
 tools/perf/ui/stdio/hist.c |    3 +-
 2 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 8ccd1f2..009adf20 100644
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
@@ -40,6 +39,7 @@ static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period / hpp->total_period;
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "  %5.2f%%";
 
 	if (hpp->ptr) {
 		struct hists *old_hists = hpp->ptr;
@@ -52,12 +52,14 @@ static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 			percent = 0.0;
 	}
 
-	return scnprintf(hpp->buf, hpp->size, "  %5.2f%%", percent);
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
@@ -74,12 +76,16 @@ static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
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
@@ -96,7 +102,9 @@ static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_us / hpp->total_period;
-	return scnprintf(hpp->buf, hpp->size, "%5.2f%%", percent);
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%5.2f%%";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
 static int hpp__header_overhead_guest_sys(struct perf_hpp *hpp)
@@ -120,7 +128,9 @@ static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
 					 struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_guest_sys / hpp->total_period;
-	return scnprintf(hpp->buf, hpp->size, "  %5.2f%% ", percent);
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "  %5.2f%% ";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
 static int hpp__header_overhead_guest_us(struct perf_hpp *hpp)
@@ -144,12 +154,16 @@ static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
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
@@ -159,12 +173,16 @@ static int hpp__width_samples(struct perf_hpp *hpp __used)
 
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
@@ -174,12 +192,16 @@ static int hpp__width_period(struct perf_hpp *hpp __used)
 
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
@@ -193,7 +215,8 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 	u64 old_total, new_total;
 	double old_percent = 0, new_percent = 0;
 	double diff;
-	char buf[32];
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%7.7s";
+	char buf[32] = " ";
 
 	old_total = pair_hists->stats.total_period;
 	if (old_total > 0 && he->pair)
@@ -204,11 +227,10 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
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
@@ -223,13 +245,13 @@ static int hpp__width_displ(struct perf_hpp *hpp __used)
 
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
index 4228b4c..882461a 100644
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
