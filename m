Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2JHWi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:38:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:41369 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab2JHWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/25] perf diff: Add -p option to display period values for hist entries
Date: Mon,  8 Oct 2012 19:32:33 -0300
Message-Id: <1349735570-19339-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding -p option to show period values for both compared hist entries.
Showing hist column PERF_HPP__PERIOD and newly added hist column
PERF_HPP__PERIOD_BASELINE.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349448287-18919-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |    4 ++++
 tools/perf/builtin-diff.c              |   10 +++++++++-
 tools/perf/ui/hist.c                   |   21 +++++++++++++++++++++
 tools/perf/util/hist.h                 |    1 +
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index fa413ac..21cc2ef 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -83,6 +83,10 @@ OPTIONS
         on the computation results.
         See COMPARISON METHODS section for more info.
 
+-p::
+--period::
+        Show period values for both compared hist entries.
+
 COMPARISON METHODS
 ------------------
 delta
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d78e838..2411dd1 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -24,6 +24,7 @@ static char const *input_old = "perf.data.old",
 static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
+static bool show_period;
 static bool show_baseline_only;
 static bool sort_compute;
 
@@ -540,6 +541,8 @@ static const struct option options[] = {
 		     "delta,ratio,wdiff:w1,w2 (default delta)",
 		     "Entries differential computation selection",
 		     setup_compute),
+	OPT_BOOLEAN('p', "period", &show_period,
+		    "Show period values."),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
@@ -568,7 +571,7 @@ static void ui_init(void)
 	/* No overhead column. */
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD, false);
 
-	/* Display baseline/delta/ratio/displacement columns. */
+	/* Display baseline/delta/ratio/displacement/periods columns. */
 	perf_hpp__column_enable(PERF_HPP__BASELINE, true);
 
 	switch (compute) {
@@ -587,6 +590,11 @@ static void ui_init(void)
 
 	if (show_displacement)
 		perf_hpp__column_enable(PERF_HPP__DISPL, true);
+
+	if (show_period) {
+		perf_hpp__column_enable(PERF_HPP__PERIOD, true);
+		perf_hpp__column_enable(PERF_HPP__PERIOD_BASELINE, true);
+	}
 }
 
 int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 522b4ec..2fadaff 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -228,6 +228,26 @@ static int hpp__entry_period(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
 }
 
+static int hpp__header_period_baseline(struct perf_hpp *hpp)
+{
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, "Period Base");
+}
+
+static int hpp__width_period_baseline(struct perf_hpp *hpp __maybe_unused)
+{
+	return 12;
+}
+
+static int hpp__entry_period_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	struct hist_entry *pair = he->pair;
+	u64 period = pair ? pair->stat.period : 0;
+	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
+
+	return scnprintf(hpp->buf, hpp->size, fmt, period);
+}
 static int hpp__header_delta(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
@@ -359,6 +379,7 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_guest_us) },
 	{ .cond = false, HPP__PRINT_FNS(samples) },
 	{ .cond = false, HPP__PRINT_FNS(period) },
+	{ .cond = false, HPP__PRINT_FNS(period_baseline) },
 	{ .cond = false, HPP__PRINT_FNS(delta) },
 	{ .cond = false, HPP__PRINT_FNS(ratio) },
 	{ .cond = false, HPP__PRINT_FNS(wdiff) },
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ce76f36..5604791 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -140,6 +140,7 @@ enum {
 	PERF_HPP__OVERHEAD_GUEST_US,
 	PERF_HPP__SAMPLES,
 	PERF_HPP__PERIOD,
+	PERF_HPP__PERIOD_BASELINE,
 	PERF_HPP__DELTA,
 	PERF_HPP__RATIO,
 	PERF_HPP__WEIGHTED_DIFF,
-- 
1.7.9.2.358.g22243

