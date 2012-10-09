Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2JIR0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:26:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab2JIR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:26:14 -0400
Date: Tue, 9 Oct 2012 10:25:01 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-81d5f95819953321a2557b0656b24ea10af9629c@git.kernel.org>
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
In-Reply-To: <1349448287-18919-5-git-send-email-jolsa@redhat.com>
References: <1349448287-18919-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Add weighted diff computation way to compare hist entries
Git-Commit-ID: 81d5f95819953321a2557b0656b24ea10af9629c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:25:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81d5f95819953321a2557b0656b24ea10af9629c
Gitweb:     http://git.kernel.org/tip/81d5f95819953321a2557b0656b24ea10af9629c
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 5 Oct 2012 16:44:43 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 5 Oct 2012 14:10:42 -0300

perf diff: Add weighted diff computation way to compare hist entries

Adding 'wdiff' as new computation way to compare hist entries.

If specified the 'Weighted diff' column is displayed with value 'd'
computed as:

   d = B->period * WEIGHT-A - A->period * WEIGHT-B

  - A/B being matching hist entry from first/second file specified
    (or perf.data/perf.data.old) respectively.
  - period being the hist entry period value
  - WEIGHT-A/WEIGHT-B being user suplied weights in the the '-c' option
    behind ':' separator like '-c wdiff:1,2'.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349448287-18919-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |   15 ++++-
 tools/perf/builtin-diff.c              |  116 ++++++++++++++++++++++++++++++--
 tools/perf/ui/hist.c                   |   30 ++++++++
 tools/perf/util/hist.h                 |    2 +
 tools/perf/util/sort.h                 |    3 +
 5 files changed, 160 insertions(+), 6 deletions(-)

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
index e13cfac..d78e838 100644
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
+		pr_err("Failed: wrong weight data, use 'wdiff:w1,w2'\n");
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
+		pr_err("Failed: extra option specified '%s'", opt);
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
@@ -53,19 +110,37 @@ static int setup_compute(const struct option *opt, const char *str,
 
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
 
 	pr_err("Failed: '%s' is not computation method "
-	       "(use 'delta' or 'ratio').\n", str);
+	       "(use 'delta','ratio' or 'wdiff')\n", str);
 	return -EINVAL;
 }
 
@@ -97,6 +172,23 @@ double perf_diff__compute_ratio(struct hist_entry *he)
 	return he->diff.period_ratio;
 }
 
+s64 perf_diff__compute_wdiff(struct hist_entry *he)
+{
+	struct hist_entry *pair = he->pair;
+	u64 new_period = he->stat.period;
+	u64 old_period = pair ? pair->stat.period : 0;
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
@@ -275,6 +367,9 @@ static void hists__precompute(struct hists *hists)
 		case COMPUTE_RATIO:
 			perf_diff__compute_ratio(he);
 			break;
+		case COMPUTE_WEIGHTED_DIFF:
+			perf_diff__compute_wdiff(he);
+			break;
 		default:
 			BUG_ON(1);
 		}
@@ -310,6 +405,13 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
 
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
@@ -434,7 +536,8 @@ static const struct option options[] = {
 		    "Show position displacement relative to baseline"),
 	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
 		    "Show only items with match in baseline"),
-	OPT_CALLBACK('c', "compute", &compute, "delta,ratio (default delta)",
+	OPT_CALLBACK('c', "compute", &compute,
+		     "delta,ratio,wdiff:w1,w2 (default delta)",
 		     "Entries differential computation selection",
 		     setup_compute),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
@@ -475,6 +578,9 @@ static void ui_init(void)
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
index 659f2a2..522b4ec 100644
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
+	s64 wdiff;
+
+	if (he->diff.computed)
+		wdiff = he->diff.wdiff;
+	else
+		wdiff = perf_diff__compute_wdiff(he);
+
+	if (wdiff != 0)
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
index a7ea28a..ce76f36 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -142,6 +142,7 @@ enum {
 	PERF_HPP__PERIOD,
 	PERF_HPP__DELTA,
 	PERF_HPP__RATIO,
+	PERF_HPP__WEIGHTED_DIFF,
 	PERF_HPP__DISPL,
 
 	PERF_HPP__MAX_INDEX
@@ -207,4 +208,5 @@ unsigned int hists__sort_list_width(struct hists *self);
 
 double perf_diff__compute_delta(struct hist_entry *he);
 double perf_diff__compute_ratio(struct hist_entry *he);
+s64 perf_diff__compute_wdiff(struct hist_entry *he);
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 337aeef..13761d8 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -63,6 +63,9 @@ struct hist_entry_diff {
 
 	/* PERF_HPP__RATIO */
 	double	period_ratio;
+
+	/* HISTC_WEIGHTED_DIFF */
+	s64	wdiff;
 };
 
 /**
