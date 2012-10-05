Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2JEJEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:04:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33014 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab2JEJEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:04:30 -0400
Date: Fri, 5 Oct 2012 02:03:57 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-1d77822ea6245e89149872405a3844e0778a004a@git.kernel.org>
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
In-Reply-To: <1349354994-17853-6-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tool: Add hpp interface to enable/
 disable hpp column
Git-Commit-ID: 1d77822ea6245e89149872405a3844e0778a004a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 02:04:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d77822ea6245e89149872405a3844e0778a004a
Gitweb:     http://git.kernel.org/tip/1d77822ea6245e89149872405a3844e0778a004a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 4 Oct 2012 21:49:39 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 4 Oct 2012 13:30:27 -0300

perf tool: Add hpp interface to enable/disable hpp column

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
index 413c65a1b..a0b531c 100644
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
 
