Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab2JIR1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:27:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430Ab2JIR1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:27:00 -0400
Date: Tue, 9 Oct 2012 10:25:57 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-61949b212e7f6f8f31891236ba24033f9b7af8c3@git.kernel.org>
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
In-Reply-To: <1349448287-18919-6-git-send-email-jolsa@redhat.com>
References: <1349448287-18919-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Add -p option to display period values for hist entries
Git-Commit-ID: 61949b212e7f6f8f31891236ba24033f9b7af8c3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:26:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61949b212e7f6f8f31891236ba24033f9b7af8c3
Gitweb:     http://git.kernel.org/tip/61949b212e7f6f8f31891236ba24033f9b7af8c3
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 5 Oct 2012 16:44:44 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 5 Oct 2012 14:11:47 -0300

perf diff: Add -p option to display period values for hist entries

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
 4 files changed, 35 insertions(+), 1 deletions(-)

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
