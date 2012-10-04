Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2JDSJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:09:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:39726 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2JDSJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 38/42] perf tool: Add hpp interface to enable/disable hpp column
Date: Thu,  4 Oct 2012 15:08:38 -0300
Message-Id: <1349374122-27806-39-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding perf_hpp__column_enable function to enable/disable hists column
and removing diff command specific stuff 'need_pair and
show_displacement' from hpp code.

The diff command now enables/disables columns separately according to
the user arguments. This will be helpful in future patches where more
columns are added into diff output.

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
Link: http://lkml.kernel.org/r/1349354994-17853-6-git-send-email-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c      |   18 +++++++++++++++++-
 tools/perf/builtin-report.c    |    2 +-
 tools/perf/ui/browsers/hists.c |    2 +-
 tools/perf/ui/gtk/browser.c    |    2 +-
 tools/perf/ui/hist.c           |   15 ++++++---------
 tools/perf/ui/setup.c          |    2 +-
 tools/perf/util/hist.h         |    3 ++-
 7 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 413c65a..a0b531c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -256,6 +256,21 @@ static const struct option options[] = {
 	OPT_END()
 };
 
+static void ui_init(void)
+{
+	perf_hpp__init();
+
+	/* No overhead column. */
+	perf_hpp__column_enable(PERF_HPP__OVERHEAD, false);
+
+	/* Display baseline/delta/displacement columns. */
+	perf_hpp__column_enable(PERF_HPP__BASELINE, true);
+	perf_hpp__column_enable(PERF_HPP__DELTA, true);
+
+	if (show_displacement)
+		perf_hpp__column_enable(PERF_HPP__DISPL, true);
+}
+
 int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	sort_order = diff__default_sort_order;
@@ -278,7 +293,8 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (symbol__init() < 0)
 		return -1;
 
-	perf_hpp__init(true, show_displacement);
+	ui_init();
+
 	setup_sorting(diff_usage, options);
 	setup_pager();
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 95e7ea8..a61725d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -691,7 +691,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		setup_browser(true);
 	else {
 		use_browser = 0;
-		perf_hpp__init(false, false);
+		perf_hpp__init();
 	}
 
 	setup_sorting(report_usage, options);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a21f40b..bbd11c2 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -584,7 +584,7 @@ HPP__COLOR_FN(overhead_guest_us, period_guest_us)
 
 void hist_browser__init_hpp(void)
 {
-	perf_hpp__init(false, false);
+	perf_hpp__init();
 
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				hist_browser__hpp_color_overhead;
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 7ff99ec..2bc08f6 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -73,7 +73,7 @@ HPP__COLOR_FN(overhead_guest_us, period_guest_us)
 
 void perf_gtk__init_hpp(void)
 {
-	perf_hpp__init(false, false);
+	perf_hpp__init();
 
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				perf_gtk__hpp_color_overhead;
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 6b0138e..e8853f7 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -302,7 +302,7 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 #undef HPP__COLOR_PRINT_FNS
 #undef HPP__PRINT_FNS
 
-void perf_hpp__init(bool need_pair, bool show_displacement)
+void perf_hpp__init(void)
 {
 	if (symbol_conf.show_cpu_utilization) {
 		perf_hpp__format[PERF_HPP__OVERHEAD_SYS].cond = true;
@@ -319,15 +319,12 @@ void perf_hpp__init(bool need_pair, bool show_displacement)
 
 	if (symbol_conf.show_total_period)
 		perf_hpp__format[PERF_HPP__PERIOD].cond = true;
+}
 
-	if (need_pair) {
-		perf_hpp__format[PERF_HPP__OVERHEAD].cond = false;
-		perf_hpp__format[PERF_HPP__BASELINE].cond = true;
-		perf_hpp__format[PERF_HPP__DELTA].cond = true;
-
-		if (show_displacement)
-			perf_hpp__format[PERF_HPP__DISPL].cond = true;
-	}
+void perf_hpp__column_enable(unsigned col, bool enable)
+{
+	BUG_ON(col >= PERF_HPP__MAX_INDEX);
+	perf_hpp__format[col].cond = enable;
 }
 
 static inline void advance_hpp(struct perf_hpp *hpp, int inc)
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index bd7d460..ebb4cc1 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -30,7 +30,7 @@ void setup_browser(bool fallback_to_pager)
 		if (fallback_to_pager)
 			setup_pager();
 
-		perf_hpp__init(false, false);
+		perf_hpp__init();
 		break;
 	}
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index b83a226..a7f69d6 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -147,7 +147,8 @@ enum {
 	PERF_HPP__MAX_INDEX
 };
 
-void perf_hpp__init(bool need_pair, bool show_displacement);
+void perf_hpp__init(void);
+void perf_hpp__column_enable(unsigned col, bool enable);
 int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 				bool color);
 
-- 
1.7.1

