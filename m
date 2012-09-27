Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab2I0LLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:11:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab2I0LKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:10:42 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/14] perf diff: Add weighted diff computation way to compare hist entries
Date: Thu, 27 Sep 2012 13:09:31 +0200
Message-Id: <1348744175-11115-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding 'wdiff' as new computation way to compare hist entries.

If specified the 'Weighted diff' column is displayed with value 'd'
computed as:

   d = B->period * WEIGHT-A - A->period * WEIGHT-B

  - A/B being matching hist entry from first/second file specified
    (or perf.data/perf.data.old) respectively.
  - period being the hist entry period value
  - WEIGHT-A/WEIGHT-B being user suplied weights in the the '-c' option
    behind ':' separator like '-c wdiff:1,2'.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |  15 ++++-
 tools/perf/builtin-diff.c              | 114 +++++++++++++++++++++++++++++++--
 tools/perf/ui/hist.c                   |  30 +++++++++
 tools/perf/util/hist.h                 |   2 +
 tools/perf/util/sort.h                 |   3 +
 5 files changed, 159 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index cff3d9b..fa413ac 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -78,7 +78,7 @@ OPTIONS
 
 -c::
 --compute::
-        Differential computation selection - delta,ratio (default is delta).
+        Differential computation selection - delta,ratio,wdiff (default is delta).
         If '+' is specified as a first character, the output is sorted based
         on the computation results.
         See COMPARISON METHODS section for more info.
@@ -110,6 +110,19 @@ with:
 
   - period being the hist entry period value
 
+wdiff
+~~~~~
+If specified the 'Weighted diff' column is displayed with value 'd' computed as:
+
+   d = B->period * WEIGHT-A - A->period * WEIGHT-B
+
+  - A/B being matching hist entry from first/second file specified
+    (or perf.data/perf.data.old) respectively.
+
+  - period being the hist entry period value
+
+  - WEIGHT-A/WEIGHT-B being user suplied weights in the the '-c' option
+    behind ':' separator like '-c wdiff:1,2'.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 14bc244..b0a08aa 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -27,24 +27,81 @@ static bool show_displacement;
 static bool show_baseline_only;
 static bool sort_compute;
 
+static s64 compute_wdiff_w1;
+static s64 compute_wdiff_w2;
+
 enum {
 	COMPUTE_DELTA,
 	COMPUTE_RATIO,
+	COMPUTE_WEIGHTED_DIFF,
 	COMPUTE_MAX,
 };
 
 const char *compute_names[COMPUTE_MAX] = {
 	[COMPUTE_DELTA] = "delta",
 	[COMPUTE_RATIO] = "ratio",
+	[COMPUTE_WEIGHTED_DIFF] = "wdiff",
 };
 
 static int compute;
 
+static int setup_compute_opt_wdiff(char *opt)
+{
+	char *w1_str = opt;
+	char *w2_str;
+
+	int ret = -EINVAL;
+
+	if (!opt)
+		goto out;
+
+	w2_str = strchr(opt, ',');
+	if (!w2_str)
+		goto out;
+
+	*w2_str++ = 0x0;
+	if (!*w2_str)
+		goto out;
+
+	compute_wdiff_w1 = strtol(w1_str, NULL, 10);
+	compute_wdiff_w2 = strtol(w2_str, NULL, 10);
+
+	if (!compute_wdiff_w1 || !compute_wdiff_w2)
+		goto out;
+
+	pr_debug("compute wdiff w1(%" PRId64 ") w2(%" PRId64 ")\n",
+		  compute_wdiff_w1, compute_wdiff_w2);
+
+	ret = 0;
+
+ out:
+	if (ret)
+		pr_err("Weight parsing failed.");
+
+	return ret;
+}
+
+static int setup_compute_opt(char *opt)
+{
+	if (compute == COMPUTE_WEIGHTED_DIFF)
+		return setup_compute_opt_wdiff(opt);
+
+	if (opt) {
+		pr_err("Extra option specified.");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int setup_compute(const struct option *opt, const char *str,
 			 int unset __maybe_unused)
 {
 	int *cp = (int *) opt->value;
+	char *cstr = (char *) str;
+	char buf[50];
 	unsigned i;
+	char *option;
 
 	if (!str) {
 		*cp = COMPUTE_DELTA;
@@ -53,15 +110,33 @@ static int setup_compute(const struct option *opt, const char *str,
 
 	if (*str == '+') {
 		sort_compute = true;
-		str++;
+		cstr = (char *) ++str;
 		if (!*str)
 			return 0;
 	}
 
+	option = strchr(str, ':');
+	if (option) {
+		unsigned len = option++ - str;
+
+		/*
+		 * The str data are not writeable, so we need
+		 * to use another buffer.
+		 */
+
+		/* No option value is longer. */
+		if (len >= sizeof(buf))
+			return -EINVAL;
+
+		strncpy(buf, str, len);
+		buf[len] = 0x0;
+		cstr = buf;
+	}
+
 	for (i = 0; i < COMPUTE_MAX; i++)
-		if (!strcmp(str, compute_names[i])) {
+		if (!strcmp(cstr, compute_names[i])) {
 			*cp = i;
-			return 0;
+			return setup_compute_opt(option);
 		}
 
 	pr_err("Failed to find valid compute string\n");
@@ -96,6 +171,23 @@ double perf_diff__compute_ratio(struct hist_entry *he)
 	return he->diff.period_ratio;
 }
 
+double perf_diff__compute_wdiff(struct hist_entry *he)
+{
+	struct hist_entry *pair = he->pair;
+	u64 new_period = he->period;
+	u64 old_period = pair ? pair->period : 0;
+
+	he->diff.computed = true;
+
+	if (!pair)
+		he->diff.wdiff = 0;
+	else
+		he->diff.wdiff = new_period * compute_wdiff_w2 -
+				 old_period * compute_wdiff_w1;
+
+	return he->diff.wdiff;
+}
+
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period)
 {
@@ -274,6 +366,9 @@ static void hists__precompute(struct hists *hists)
 		case COMPUTE_RATIO:
 			perf_diff__compute_ratio(he);
 			break;
+		case COMPUTE_WEIGHTED_DIFF:
+			perf_diff__compute_wdiff(he);
+			break;
 		default:
 			BUG_ON(1);
 		}
@@ -309,6 +404,13 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
 
 		return cmp_doubles(l, r);
 	}
+	case COMPUTE_WEIGHTED_DIFF:
+	{
+		s64 l = left->diff.wdiff;
+		s64 r = right->diff.wdiff;
+
+		return r - l;
+	}
 	default:
 		BUG_ON(1);
 	}
@@ -433,7 +535,8 @@ static const struct option options[] = {
 		    "Show position displacement relative to baseline"),
 	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
 		    "Show only items with match in baseline"),
-	OPT_CALLBACK('c', "compute", &compute, "delta,ratio (default delta)",
+	OPT_CALLBACK('c', "compute", &compute,
+		     "delta,ratio,wdiff:w1,w2 (default delta)",
 		     "Entries differential computation selection",
 		     setup_compute),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
@@ -474,6 +577,9 @@ static void ui_init(void)
 	case COMPUTE_RATIO:
 		perf_hpp__column_enable(PERF_HPP__RATIO, true);
 		break;
+	case COMPUTE_WEIGHTED_DIFF:
+		perf_hpp__column_enable(PERF_HPP__WEIGHTED_DIFF, true);
+		break;
 	default:
 		BUG_ON(1);
 	};
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 21b57a2..5980ca5 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -286,6 +286,35 @@ static int hpp__entry_ratio(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
+static int hpp__header_wdiff(struct perf_hpp *hpp)
+{
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, "Weighted diff");
+}
+
+static int hpp__width_wdiff(struct perf_hpp *hpp __maybe_unused)
+{
+	return 14;
+}
+
+static int hpp__entry_wdiff(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
+	char buf[32] = " ";
+	u64 wdiff;
+
+	if (he->diff.computed)
+		wdiff = he->diff.wdiff;
+	else
+		wdiff = perf_diff__compute_wdiff(he);
+
+	if (wdiff > 0)
+		scnprintf(buf, sizeof(buf), "%14ld", wdiff);
+
+	return scnprintf(hpp->buf, hpp->size, fmt, buf);
+}
+
 static int hpp__header_displ(struct perf_hpp *hpp)
 {
 	return scnprintf(hpp->buf, hpp->size, "Displ.");
@@ -332,6 +361,7 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 	{ .cond = false, HPP__PRINT_FNS(period) },
 	{ .cond = false, HPP__PRINT_FNS(delta) },
 	{ .cond = false, HPP__PRINT_FNS(ratio) },
+	{ .cond = false, HPP__PRINT_FNS(wdiff) },
 	{ .cond = false, HPP__PRINT_FNS(displ) }
 };
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2dbb340..27866b5 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -142,6 +142,7 @@ enum {
 	PERF_HPP__PERIOD,
 	PERF_HPP__DELTA,
 	PERF_HPP__RATIO,
+	PERF_HPP__WEIGHTED_DIFF,
 	PERF_HPP__DISPL,
 
 	PERF_HPP__MAX_INDEX
@@ -208,4 +209,5 @@ unsigned int hists__sort_list_width(struct hists *self);
 
 double perf_diff__compute_delta(struct hist_entry *he);
 double perf_diff__compute_ratio(struct hist_entry *he);
+double perf_diff__compute_wdiff(struct hist_entry *he);
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 2090670..19d68ee 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -54,6 +54,9 @@ struct hist_entry_diff {
 
 	/* PERF_HPP__RATIO */
 	double	period_ratio;
+
+	/* HISTC_WEIGHTED_DIFF */
+	s64	wdiff;
 };
 
 /**
-- 
1.7.11.4

