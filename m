Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2K1NyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:54:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab2K1NyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:54:21 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 14/14] perf diff: Add generic order option for compute sorting
Date: Wed, 28 Nov 2012 14:52:49 +0100
Message-Id: <1354110769-2998-15-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding option 'o' to allow sorting based on the
input file number.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-diff.txt |  4 +++
 tools/perf/builtin-diff.c              | 53 +++++++++++++++-------------------
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index ab5b79e..1402e14 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -91,6 +91,10 @@ OPTIONS
 --formula::
         Show formula for given computation.
 
+-o::
+--order::
+       Specify compute sorting column number.
+
 COMPARISON
 ----------
 The comparison is governed by the baseline file. The baseline perf.data
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b801d0c..1f98786 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -65,7 +65,7 @@ static bool show_displacement;
 static bool show_period;
 static bool show_formula;
 static bool show_baseline_only;
-static bool sort_compute;
+static unsigned int sort_compute;
 
 static s64 compute_wdiff_w1;
 static s64 compute_wdiff_w2;
@@ -191,13 +191,6 @@ static int setup_compute(const struct option *opt, const char *str,
 		return 0;
 	}
 
-	if (*str == '+') {
-		sort_compute = true;
-		cstr = (char *) ++str;
-		if (!*str)
-			return 0;
-	}
-
 	option = strchr(str, ':');
 	if (option) {
 		unsigned len = option++ - str;
@@ -533,31 +526,27 @@ static int64_t
 hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
 			int c)
 {
-	int i;
+	struct hist_entry **pairs_left  = left->pairs;
+	struct hist_entry **pairs_right = right->pairs;
+	struct hist_entry *p_right, *p_left;
+	static int64_t cmp;
 
-	for (i = 0; i < data_cnt; i++) {
-		struct hist_entry **pairs_left  = left->pairs;
-		struct hist_entry **pairs_right = right->pairs;
-		struct hist_entry *p_right, *p_left;
-		static int64_t cmp;
+	if (!pairs_left || !pairs_right)
+		return pairs_left ? -1 : 1;
 
-		if (!pairs_left || !pairs_right)
-			return pairs_right - pairs_left;
+	p_right = pairs_right[sort_compute];
+	p_left  = pairs_left[sort_compute];
 
-		p_right = pairs_right[i];
-		p_left  = pairs_left[i];
+	if (!p_left || !p_right)
+		return p_left ? -1 : 1;
 
-		if (!p_left || !p_right)
-			return p_right - p_left;
-
-		/*
-		 * If we differ, we are done, otherwise continue until all
-		 * is processed or we find a difference.
-		 */
-		cmp = __hist_entry__cmp_compute(p_left, p_right, c);
-		if (cmp)
-			return cmp;
-	}
+	/*
+	 * If we differ, we are done, otherwise continue until all
+	 * is processed or we find a difference.
+	 */
+	cmp = __hist_entry__cmp_compute(p_left, p_right, c);
+	if (cmp)
+		return cmp;
 
 	return 0;
 }
@@ -759,6 +748,7 @@ static const struct option options[] = {
 		   "columns '.' is reserved."),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
+	OPT_UINTEGER('o', "order", &sort_compute, "Specify compute sorting."),
 	OPT_END()
 };
 
@@ -1087,6 +1077,11 @@ static int data_init(int argc, const char **argv)
 		d->idx  = i;
 	}
 
+	if (sort_compute >= (unsigned int) data_cnt) {
+		pr_err("Order option out of limit.\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
1.7.11.7

