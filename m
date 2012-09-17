Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab2IQRYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:24:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:46431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab2IQRS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/18] perf hists browser: Fix output for 100.00%
Date: Mon, 17 Sep 2012 14:17:59 -0300
Message-Id: <1347902292-14536-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current hpp format functions assume that the output will fit to 6
character including % sign (XX.YY%) so used "%5.2f%%" as a format
string.  However it might be the case if collapsing resulted in a single
entry which has 100.00% (7 character) of period. In this case the output
will be shifted by 1 character.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347431706-7839-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |    2 +-
 tools/perf/ui/gtk/browser.c    |    2 +-
 tools/perf/ui/hist.c           |   28 ++++++++++++++--------------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 5a5739b..1178317 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -571,7 +571,7 @@ static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
 {									\
 	double percent = 100.0 * he->_field / hpp->total_period;	\
 	*(double *)hpp->ptr = percent;					\
-	return scnprintf(hpp->buf, hpp->size, "%5.2f%%", percent);	\
+	return scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);	\
 }
 
 HPP__COLOR_FN(overhead, period)
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 55acba6..7ff99ec 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -56,7 +56,7 @@ static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
 	markup = perf_gtk__get_percent_color(percent);				\
 	if (markup)								\
 		ret += scnprintf(hpp->buf, hpp->size, "%s", markup);		\
-	ret += scnprintf(hpp->buf + ret, hpp->size - ret, "%5.2f%%", percent); 	\
+	ret += scnprintf(hpp->buf + ret, hpp->size - ret, "%6.2f%%", percent); 	\
 	if (markup)								\
 		ret += scnprintf(hpp->buf + ret, hpp->size - ret, "</span>"); 	\
 										\
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 407e855..e3f8cd4 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -33,13 +33,13 @@ static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 			percent = 0.0;
 	}
 
-	return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%%", percent);
+	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
 }
 
 static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period / hpp->total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : "  %5.2f%%";
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
 	if (hpp->ptr) {
 		struct hists *old_hists = hpp->ptr;
@@ -57,52 +57,52 @@ static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 
 static int hpp__header_overhead_sys(struct perf_hpp *hpp)
 {
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%6s";
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "sys");
 }
 
 static int hpp__width_overhead_sys(struct perf_hpp *hpp __maybe_unused)
 {
-	return 6;
+	return 7;
 }
 
 static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_sys / hpp->total_period;
-	return percent_color_snprintf(hpp->buf, hpp->size, "%5.2f%%", percent);
+	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
 
 static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_sys / hpp->total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%5.2f%%";
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
 static int hpp__header_overhead_us(struct perf_hpp *hpp)
 {
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%6s";
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "user");
 }
 
 static int hpp__width_overhead_us(struct perf_hpp *hpp __maybe_unused)
 {
-	return 6;
+	return 7;
 }
 
 static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_us / hpp->total_period;
-	return percent_color_snprintf(hpp->buf, hpp->size, "%5.2f%%", percent);
+	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
 
 static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_us / hpp->total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%5.2f%%";
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
@@ -121,14 +121,14 @@ static int hpp__color_overhead_guest_sys(struct perf_hpp *hpp,
 					 struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_guest_sys / hpp->total_period;
-	return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%% ", percent);
+	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
 
 static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
 					 struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_guest_sys / hpp->total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : "  %5.2f%% ";
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
@@ -147,14 +147,14 @@ static int hpp__color_overhead_guest_us(struct perf_hpp *hpp,
 					struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_guest_us / hpp->total_period;
-	return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%% ", percent);
+	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
 
 static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
 					struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_guest_us / hpp->total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : "  %5.2f%% ";
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
-- 
1.7.1

