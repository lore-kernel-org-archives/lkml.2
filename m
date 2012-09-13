Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab2IMH1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:27:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57860 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab2IMH1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:08 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-10-50518ac80782
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 12/15] perf ui/hist: Add support to accumulated hist stat
Date: Thu, 13 Sep 2012 16:20:08 +0900
Message-Id: <1347520811-28150-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Print accumulated stat of a hist entry if requested.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index d6ddeb10e678..7bf2999d2d17 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -22,6 +22,9 @@ static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->stat.period / hpp->total_period;
 
+	if (symbol_conf.cumulate_callchain)
+		percent = 100.0 * he->stat_acc->period / hpp->total_period;
+
 	if (hpp->ptr) {
 		struct hists *old_hists = hpp->ptr;
 		u64 total_period = old_hists->stats.total_period;
@@ -41,6 +44,9 @@ static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 	double percent = 100.0 * he->stat.period / hpp->total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
+	if (symbol_conf.cumulate_callchain)
+		percent = 100.0 * he->stat_acc->period / hpp->total_period;
+
 	if (hpp->ptr) {
 		struct hists *old_hists = hpp->ptr;
 		u64 total_period = old_hists->stats.total_period;
@@ -70,6 +76,10 @@ static int hpp__width_overhead_sys(struct perf_hpp *hpp __maybe_unused)
 static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->stat.period_sys / hpp->total_period;
+
+	if (symbol_conf.cumulate_callchain)
+		percent = 100.0 * he->stat_acc->period_sys / hpp->total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
 
@@ -78,6 +88,9 @@ static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 	double percent = 100.0 * he->stat.period_sys / hpp->total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
 
+	if (symbol_conf.cumulate_callchain)
+		percent = 100.0 * he->stat_acc->period_sys / hpp->total_period;
+
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
@@ -96,6 +109,10 @@ static int hpp__width_overhead_us(struct perf_hpp *hpp __maybe_unused)
 static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->stat.period_us / hpp->total_period;
+
+	if (symbol_conf.cumulate_callchain)
+		percent = 100.0 * he->stat_acc->period_us / hpp->total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
 
@@ -104,6 +121,9 @@ static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 	double percent = 100.0 * he->stat.period_us / hpp->total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
 
+	if (symbol_conf.cumulate_callchain)
+		percent = 100.0 * he->stat_acc->period_us / hpp->total_period;
+
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
@@ -121,6 +141,10 @@ static int hpp__color_overhead_guest_sys(struct perf_hpp *hpp,
 					 struct hist_entry *he)
 {
 	double percent = 100.0 * he->stat.period_guest_sys / hpp->total_period;
+
+	if (symbol_conf.cumulate_callchain)
+		percent = 100.0 * he->stat_acc->period_guest_sys / hpp->total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
 
@@ -130,6 +154,9 @@ static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
 	double percent = 100.0 * he->stat.period_guest_sys / hpp->total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
 
+	if (symbol_conf.cumulate_callchain)
+		percent = 100.0 * he->stat_acc->period_guest_sys / hpp->total_period;
+
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
@@ -147,6 +174,10 @@ static int hpp__color_overhead_guest_us(struct perf_hpp *hpp,
 					struct hist_entry *he)
 {
 	double percent = 100.0 * he->stat.period_guest_us / hpp->total_period;
+
+	if (symbol_conf.cumulate_callchain)
+		percent = 100.0 * he->stat_acc->period_guest_us / hpp->total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
 
@@ -156,6 +187,9 @@ static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
 	double percent = 100.0 * he->stat.period_guest_us / hpp->total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
 
+	if (symbol_conf.cumulate_callchain)
+		percent = 100.0 * he->stat_acc->period_guest_us / hpp->total_period;
+
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
@@ -174,8 +208,12 @@ static int hpp__width_samples(struct perf_hpp *hpp __maybe_unused)
 static int hpp__entry_samples(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%11" PRIu64;
+	u64 samples = he->stat.nr_events;
 
-	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.nr_events);
+	if (symbol_conf.cumulate_callchain)
+		samples = he->stat_acc->nr_events;
+
+	return scnprintf(hpp->buf, hpp->size, fmt, samples);
 }
 
 static int hpp__header_period(struct perf_hpp *hpp)
@@ -193,8 +231,12 @@ static int hpp__width_period(struct perf_hpp *hpp __maybe_unused)
 static int hpp__entry_period(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
+	u64 period = he->stat.period;
+
+	if (symbol_conf.cumulate_callchain)
+		period = he->stat_acc->period;
 
-	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
+	return scnprintf(hpp->buf, hpp->size, fmt, period);
 }
 
 static int hpp__header_delta(struct perf_hpp *hpp)
-- 
1.7.11.4

