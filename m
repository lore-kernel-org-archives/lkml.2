Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab2JIRXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:23:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60846 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab2JIRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:23:41 -0400
Date: Tue, 9 Oct 2012 10:23:08 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-7aaf6b35512382329c5b2dd46b42f2bf12a5fff0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1349448287-18919-3-git-send-email-jolsa@redhat.com>
References: <1349448287-18919-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Add ratio computation way to compare hist entries
Git-Commit-ID: 7aaf6b35512382329c5b2dd46b42f2bf12a5fff0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:23:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7aaf6b35512382329c5b2dd46b42f2bf12a5fff0
Gitweb:     http://git.kernel.org/tip/7aaf6b35512382329c5b2dd46b42f2bf12a5fff0
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 5 Oct 2012 16:44:41 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 5 Oct 2012 14:06:54 -0300

perf diff: Add ratio computation way to compare hist entries

Adding -c option to select computation method with the current 'Delta'
computation as default. Current possible values are of this option are:
'delta' and 'ratio'.

Adding 'ratio' as new computation way to compare hist entries.  If
specified the 'Ratio' column is displayed with value 'r' computed as:

  r = A->period / B->period

with:
  - A/B being matching hist entry from first/second file specified
    (or perf.data/perf.data.old) respectively.
  - period being the hist entry period value

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349448287-18919-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |   33 ++++++++++++++++++++
 tools/perf/builtin-diff.c              |   52 ++++++++++++++++++++++++++++++-
 tools/perf/ui/hist.c                   |   28 +++++++++++++++++
 tools/perf/util/hist.h                 |    1 +
 4 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 6ce9585..8fff061 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -76,6 +76,39 @@ OPTIONS
 --baseline-only::
         Show only items with match in baseline.
 
+-c::
+--compute::
+        Differential computation selection - delta,ratio (default is delta).
+        See COMPARISON METHODS section for more info.
+
+COMPARISON METHODS
+------------------
+delta
+~~~~~
+If specified the 'Delta' column is displayed with value 'd' computed as:
+
+  d = A->period_percent - B->period_percent
+
+with:
+  - A/B being matching hist entry from first/second file specified
+    (or perf.data/perf.data.old) respectively.
+
+  - period_percent being the % of the hist entry period value within
+    single data file
+
+ratio
+~~~~~
+If specified the 'Ratio' column is displayed with value 'r' computed as:
+
+  r = A->period / B->period
+
+with:
+  - A/B being matching hist entry from first/second file specified
+    (or perf.data/perf.data.old) respectively.
+
+  - period being the hist entry period value
+
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 1063c31..e90c06a 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -26,6 +26,41 @@ static bool  force;
 static bool show_displacement;
 static bool show_baseline_only;
 
+enum {
+	COMPUTE_DELTA,
+	COMPUTE_RATIO,
+	COMPUTE_MAX,
+};
+
+const char *compute_names[COMPUTE_MAX] = {
+	[COMPUTE_DELTA] = "delta",
+	[COMPUTE_RATIO] = "ratio",
+};
+
+static int compute;
+
+static int setup_compute(const struct option *opt, const char *str,
+			 int unset __maybe_unused)
+{
+	int *cp = (int *) opt->value;
+	unsigned i;
+
+	if (!str) {
+		*cp = COMPUTE_DELTA;
+		return 0;
+	}
+
+	for (i = 0; i < COMPUTE_MAX; i++)
+		if (!strcmp(str, compute_names[i])) {
+			*cp = i;
+			return 0;
+		}
+
+	pr_err("Failed: '%s' is not computation method "
+	       "(use 'delta' or 'ratio').\n", str);
+	return -EINVAL;
+}
+
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period)
 {
@@ -262,6 +297,9 @@ static const struct option options[] = {
 		    "Show position displacement relative to baseline"),
 	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
 		    "Show only items with match in baseline"),
+	OPT_CALLBACK('c', "compute", &compute, "delta,ratio (default delta)",
+		     "Entries differential computation selection",
+		     setup_compute),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
@@ -290,9 +328,19 @@ static void ui_init(void)
 	/* No overhead column. */
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD, false);
 
-	/* Display baseline/delta/displacement columns. */
+	/* Display baseline/delta/ratio/displacement columns. */
 	perf_hpp__column_enable(PERF_HPP__BASELINE, true);
-	perf_hpp__column_enable(PERF_HPP__DELTA, true);
+
+	switch (compute) {
+	case COMPUTE_DELTA:
+		perf_hpp__column_enable(PERF_HPP__DELTA, true);
+		break;
+	case COMPUTE_RATIO:
+		perf_hpp__column_enable(PERF_HPP__RATIO, true);
+		break;
+	default:
+		BUG_ON(1);
+	};
 
 	if (show_displacement)
 		perf_hpp__column_enable(PERF_HPP__DISPL, true);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index f5a1e4f..1b633a4 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -266,6 +266,33 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
+static int hpp__header_ratio(struct perf_hpp *hpp)
+{
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, "Ratio");
+}
+
+static int hpp__width_ratio(struct perf_hpp *hpp __maybe_unused)
+{
+	return 14;
+}
+
+static int hpp__entry_ratio(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	struct hist_entry *pair = he->pair;
+	double new_period = he->stat.period;
+	double old_period = pair ? pair->stat.period : 0;
+	double ratio = pair ? new_period / old_period : 0;
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
+	char buf[32] = " ";
+
+	if (ratio > 0.0)
+		scnprintf(buf, sizeof(buf), "%+14.6F", ratio);
+
+	return scnprintf(hpp->buf, hpp->size, fmt, buf);
+}
+
 static int hpp__header_displ(struct perf_hpp *hpp)
 {
 	return scnprintf(hpp->buf, hpp->size, "Displ.");
@@ -311,6 +338,7 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 	{ .cond = false, HPP__PRINT_FNS(samples) },
 	{ .cond = false, HPP__PRINT_FNS(period) },
 	{ .cond = false, HPP__PRINT_FNS(delta) },
+	{ .cond = false, HPP__PRINT_FNS(ratio) },
 	{ .cond = false, HPP__PRINT_FNS(displ) }
 };
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 66cb31f..7e4d4c2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -141,6 +141,7 @@ enum {
 	PERF_HPP__SAMPLES,
 	PERF_HPP__PERIOD,
 	PERF_HPP__DELTA,
+	PERF_HPP__RATIO,
 	PERF_HPP__DISPL,
 
 	PERF_HPP__MAX_INDEX
