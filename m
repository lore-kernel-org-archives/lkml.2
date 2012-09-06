Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab2IFPsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553Ab2IFPsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:48:04 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 12/12] perf diff: Add -F option for ratio computation
Date: Thu,  6 Sep 2012 17:47:06 +0200
Message-Id: <1346946426-13496-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The -F option displays the formula for specified computation.
Adding this support for weighted diff computation.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |  2 +-
 tools/perf/builtin-diff.c              | 19 +++++++++++++++++++
 tools/perf/ui/stdio/hist.c             |  8 ++++++++
 tools/perf/ui/stdio/hist.h             |  1 +
 tools/perf/util/hist.h                 |  1 +
 5 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 4d65407..1d416a5 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -89,7 +89,7 @@ OPTIONS
 
 -F::
 --formula::
-        Show formula for given computation (supported: wdiff)
+        Show formula for given computation (supported: wdiff,ratio)
 
 COMPARISON METHODS
 ------------------
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 9125eee..62ceda3 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -158,6 +158,22 @@ double perf_diff__compute_ratio(struct hist_entry *he)
 	return he->diff.period_ratio;
 }
 
+int perf_diff__formula_ratio(struct hist_entry *he, char *bf, size_t size)
+{
+	struct hist_entry *pair = he->pair;
+	double new_period = he->period;
+	double old_period = pair ? pair->period : 0;
+	char formula[100];
+
+	if (pair)
+		scnprintf(formula, 100, "%.0F / %.0F",
+			  new_period, old_period);
+	else
+		*formula = 0x0;
+
+	return scnprintf(bf, size, "%-50s", formula);
+}
+
 double perf_diff__compute_wdiff(struct hist_entry *he)
 {
 	struct hist_entry *pair = he->pair;
@@ -594,6 +610,9 @@ static void setup_ui_stdio(void)
 		case COMPUTE_WEIGHTED_DIFF:
 			hists_stdio_column__register_idx(HISTC_FORMULA_WEIGHTED_DIFF);
 			break;
+		case COMPUTE_RATIO:
+			hists_stdio_column__register_idx(HISTC_FORMULA_RATIO);
+			break;
 		default:
 			break;
 	};
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 8cf4ebd..c7ca7ed 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -157,6 +157,13 @@ hists_stdio_column__formula_wdiff_snprintf(struct hist_entry *he, char *bf,
 	return perf_diff__formula_wdiff(he, bf, size);
 }
 
+static int
+hists_stdio_column__formula_ratio_snprintf(struct hist_entry *he, char *bf,
+					   size_t size, unsigned int width __used)
+{
+	return perf_diff__formula_ratio(he, bf, size);
+}
+
 LIST_HEAD(hists_stdio_column__list);
 
 #define DEF_COLUMN(name, c, w, h)					\
@@ -182,6 +189,7 @@ DEF_COLUMN(delta, HISTC_DELTA, 8, "Delta")
 DEF_COLUMN(ratio, HISTC_RATIO, 14, "Ratio")
 DEF_COLUMN(wdiff, HISTC_WEIGHTED_DIFF, 13, "Weighted diff")
 DEF_COLUMN(displacement, HISTC_DISPLACEMENT, 5, "Displ")
+DEF_COLUMN(formula_ratio, HISTC_FORMULA_RATIO, 50, "Formula")
 DEF_COLUMN(formula_wdiff, HISTC_FORMULA_WEIGHTED_DIFF, 50, "Formula")
 };
 
diff --git a/tools/perf/ui/stdio/hist.h b/tools/perf/ui/stdio/hist.h
index 4f62224..dba1e64 100644
--- a/tools/perf/ui/stdio/hist.h
+++ b/tools/perf/ui/stdio/hist.h
@@ -21,5 +21,6 @@ double perf_diff__compute_delta(struct hist_entry *he);
 double perf_diff__compute_ratio(struct hist_entry *he);
 double perf_diff__compute_wdiff(struct hist_entry *he);
 
+int perf_diff__formula_ratio(struct hist_entry *he, char *bf, size_t size);
 int perf_diff__formula_wdiff(struct hist_entry *he, char *bf, size_t size);
 #endif /* __PERF_UI_STDIO_HIST_H */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index e1511cc..faa77ce 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -50,6 +50,7 @@ enum hist_column {
 	HISTC_RATIO,
 	HISTC_WEIGHTED_DIFF,
 	HISTC_DISPLACEMENT,
+	HISTC_FORMULA_RATIO,
 	HISTC_FORMULA_WEIGHTED_DIFF,
 
 	/* sorted (hist_entry__sort_list) */
-- 
1.7.11.4

