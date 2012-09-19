Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2ISPO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:14:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52653 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab2ISPOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:14:23 -0400
Date: Wed, 19 Sep 2012 08:14:04 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-721b3112f5882a6de7b86b9bef5813c80d1223de@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1347431706-7839-1-git-send-email-namhyung@kernel.org>
References: <1347431706-7839-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser: Fix output for 100.00%
Git-Commit-ID: 721b3112f5882a6de7b86b9bef5813c80d1223de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:14:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  721b3112f5882a6de7b86b9bef5813c80d1223de
Gitweb:     http://git.kernel.org/tip/721b3112f5882a6de7b86b9bef5813c80d1223de
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 12 Sep 2012 15:35:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Sep 2012 15:49:45 -0300

perf hists browser: Fix output for 100.00%

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
