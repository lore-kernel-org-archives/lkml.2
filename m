Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2KJB2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:28:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:41258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab2KJB17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:27:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="244848910"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/32] perf, tools: Support sorting by intx, abort branch flags
Date: Fri,  9 Nov 2012 17:27:27 -0800
Message-Id: <1352510868-7911-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
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
index f07eae7..836aa32 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -595,7 +595,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
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
index f2ecd49..213bfeb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1226,7 +1226,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
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
index 469fbf2..d106d5a 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -194,7 +194,9 @@ struct ip_callchain {
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
index b874609..d874bf5 100644
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
index cfd1c0f..a8d1f1a 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -476,6 +476,55 @@ struct sort_entry sort_mispredict = {
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
@@ -497,6 +546,8 @@ static struct sort_dimension sort_dimensions[] = {
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_MISPREDICT, "mispredict", sort_mispredict),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_ABORT, "abort", sort_abort),
+	DIM(SORT_INTX, "intx", sort_intx)
 };
 
 int sort_dimension__add(const char *tok)
@@ -553,6 +604,10 @@ int sort_dimension__add(const char *tok)
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
index 13761d8..7e439b9 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -118,6 +118,8 @@ enum sort_type {
 	SORT_SYM_TO,
 	SORT_MISPREDICT,
 	SORT_SRCLINE,
+	SORT_ABORT,
+	SORT_INTX,
 };
 
 /*
-- 
1.7.7.6

