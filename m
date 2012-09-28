Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2I1EcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:32:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:5232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab2I1Eb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="215093232"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 15/31] perf, tools: Support sorting by intx, abort branch flags
Date: Thu, 27 Sep 2012 21:31:20 -0700
Message-Id: <1348806696-31170-16-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Extend the perf branch sorting code to support sorting by intx
or abort qualifiers. Also print out those qualifiers.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-report.c |    3 +-
 tools/perf/builtin-top.c    |    4 ++-
 tools/perf/perf.h           |    4 ++-
 tools/perf/util/hist.h      |    2 +
 tools/perf/util/sort.c      |   55 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h      |    2 +
 6 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 7c88a24..8231cb1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -594,7 +594,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
-		   " dso_from, symbol_to, symbol_from, mispredict"),
+		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
+		   " abort, intx"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 68cd61e..5ab2188 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1227,7 +1227,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
+		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
+		   " abort, intx"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top, "output_type,min_percent, call_order",
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index f960ccb..9147ffc 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -188,7 +188,9 @@ struct ip_callchain {
 struct branch_flags {
 	u64 mispred:1;
 	u64 predicted:1;
-	u64 reserved:62;
+	u64 intx:1;
+	u64 abort:1;
+	u64 reserved:60;
 };
 
 struct branch_entry {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 0b096c2..71837aa 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -43,6 +43,8 @@ enum hist_column {
 	HISTC_PARENT,
 	HISTC_CPU,
 	HISTC_MISPREDICT,
+	HISTC_INTX,
+	HISTC_ABORT,
 	HISTC_SYMBOL_FROM,
 	HISTC_SYMBOL_TO,
 	HISTC_DSO_FROM,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 0f5a0a4..596b82c 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -467,6 +467,55 @@ struct sort_entry sort_mispredict = {
 	.se_width_idx	= HISTC_MISPREDICT,
 };
 
+static int64_t
+sort__abort_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return left->branch_info->flags.abort !=
+		right->branch_info->flags.abort;
+}
+
+static int hist_entry__abort_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	static const char *out = ".";
+
+	if (self->branch_info->flags.abort)
+		out = "A";
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
+struct sort_entry sort_abort = {
+	.se_header	= "Transaction abort",
+	.se_cmp		= sort__abort_cmp,
+	.se_snprintf	= hist_entry__abort_snprintf,
+	.se_width_idx	= HISTC_ABORT,
+};
+
+static int64_t
+sort__intx_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return left->branch_info->flags.intx !=
+		right->branch_info->flags.intx;
+}
+
+static int hist_entry__intx_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	static const char *out = ".";
+
+	if (self->branch_info->flags.intx)
+		out = "T";
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
+struct sort_entry sort_intx = {
+	.se_header	= "Branch in transaction",
+	.se_cmp		= sort__intx_cmp,
+	.se_snprintf	= hist_entry__intx_snprintf,
+	.se_width_idx	= HISTC_INTX,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -488,6 +537,8 @@ static struct sort_dimension sort_dimensions[] = {
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_MISPREDICT, "mispredict", sort_mispredict),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_ABORT, "abort", sort_abort),
+	DIM(SORT_INTX, "intx", sort_intx)
 };
 
 int sort_dimension__add(const char *tok)
@@ -540,6 +591,10 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_DSO_TO;
 			else if (!strcmp(sd->name, "mispredict"))
 				sort__first_dimension = SORT_MISPREDICT;
+			else if (!strcmp(sd->name, "intx"))
+				sort__first_dimension = SORT_INTX;
+			else if (!strcmp(sd->name, "abort"))
+				sort__first_dimension = SORT_ABORT;
 		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index e724b26..fdb033f 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -95,6 +95,8 @@ enum sort_type {
 	SORT_SYM_TO,
 	SORT_MISPREDICT,
 	SORT_SRCLINE,
+	SORT_ABORT,
+	SORT_INTX,
 };
 
 /*
-- 
1.7.7.6

