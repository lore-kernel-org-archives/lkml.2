Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2KJB2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:28:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:16972 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab2KJB2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:28:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="239778370"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 23/32] perf, tools: Add browser support for transaction flags v3
Date: Fri,  9 Nov 2012 17:27:39 -0800
Message-Id: <1352510868-7911-24-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add histogram support for the transaction flags. Each flags instance becomes
a separate histogram. Support sorting and displaying the flags in report
and top.

The patch is fairly large, but it's really mostly just plumbing to pass the
flags around.

v2: Increase column. Fix flags decoding. Use longer strings for flags
to be more user friendly.
v3: Fix WERROR=1 build. Tidy display
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-diff.c     |    8 +++--
 tools/perf/builtin-report.c   |    4 +-
 tools/perf/builtin-top.c      |    4 +-
 tools/perf/util/hist.c        |    3 +-
 tools/perf/util/hist.h        |    3 +-
 tools/perf/util/sort.c        |   61 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h        |    2 +
 8 files changed, 77 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0b9cd0f..5a27016 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -62,7 +62,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1);
+	he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1, 0);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 84cdbd1..aebff56 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -249,9 +249,10 @@ int perf_diff__formula(char *buf, size_t size, struct hist_entry *he)
 
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period,
-			    u64 weight)
+			    u64 weight, u64 transaction)
 {
-	if (__hists__add_entry(self, al, NULL, period, weight) != NULL)
+	if (__hists__add_entry(self, al, NULL, period, weight, transaction)
+	    != NULL)
 		return 0;
 	return -ENOMEM;
 }
@@ -273,7 +274,8 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 	if (al.filtered)
 		return 0;
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period, sample->weight)) {
+	if (hists__add_entry(&evsel->hists, &al, sample->period, sample->weight,
+			     sample->transaction)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bd7bb66..c3d3fb7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -147,7 +147,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	}
 
 	he = __hists__add_entry(&evsel->hists, al, parent, sample->period,
-					sample->weight);
+				sample->weight, sample->transaction);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -597,7 +597,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
 		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
-		   " abort, intx,  weight, local_weight"),
+		   " abort, intx,  weight, local_weight, transaction"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index eb4ba1d5..0d2a33d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -272,7 +272,7 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	struct hist_entry *he;
 
 	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
-				sample->weight);
+				sample->weight, sample->transaction);
 	if (he == NULL)
 		return NULL;
 
@@ -1229,7 +1229,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
 		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
-		   " abort, intx, weight, local_weight"),
+		   " abort, intx, weight, local_weight, transaction"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top, "output_type,min_percent, call_order",
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cbedba7..df79b9f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -359,7 +359,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *sym_parent, u64 period,
-				      u64 weight)
+				      u64 weight, u64 transaction)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -377,6 +377,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.hists	= self,
+		.transaction = transaction,
 	};
 
 	return add_hist_entry(self, &entry, al, period, weight);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f8b4bca..e70a58e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -52,6 +52,7 @@ enum hist_column {
 	HISTC_SRCLINE,
 	HISTC_WEIGHT,
 	HISTC_GLOBAL_WEIGHT,
+	HISTC_TRANSACTION,
 	HISTC_NR_COLS, /* Last entry */
 };
 
@@ -77,7 +78,7 @@ struct hists {
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *parent, u64 period,
-				      u64 weight);
+				      u64 weight, u64 transaction);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__sort_snprintf(struct hist_entry *self, char *bf, size_t size,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a7a9691..41ddcf8 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -568,6 +568,64 @@ struct sort_entry sort_global_weight = {
 	.se_width_idx	= HISTC_GLOBAL_WEIGHT,
 };
 
+static int64_t
+sort__transaction_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return left->transaction - right->transaction;
+}
+
+static inline char *add_str(char *p, const char *str)
+{
+	strcpy(p, str);
+	return p + strlen(str);
+}
+
+static struct txbit {
+	unsigned flag;
+	const char *name;
+} txbits[] = {
+	{ PERF_SAMPLE_TXN_ELISION,     "EL " },
+	{ PERF_SAMPLE_TXN_TRANSACTION, "TX " },
+	{ PERF_SAMPLE_TXN_SYNC,        "SYNC " },
+	{ PERF_SAMPLE_TXN_ASYNC,       "ASYNC " },
+	{ PERF_SAMPLE_TXN_RETRY,       "RETRY " },
+	{ PERF_SAMPLE_TXN_CONFLICT,    "CON " },
+	{ PERF_SAMPLE_TXN_CAPACITY,    "CAP " },
+	{ PERF_SAMPLE_TXN_MEMORY,      "MEM " },
+	{ PERF_SAMPLE_TXN_MISC,        "MISC " },
+	{ 0, NULL }
+};
+
+static int hist_entry__transaction_snprintf(struct hist_entry *self, char *bf,
+	 			    	    size_t size, unsigned int width)
+{
+	u64 t = self->transaction;
+	char buf[128];
+	char *p = buf;
+	int i;
+
+	for (i = 0; txbits[i].name; i++)
+		if (txbits[i].flag & t)
+			p = add_str(p, txbits[i].name);
+	if (t && !(t & (PERF_SAMPLE_TXN_SYNC|PERF_SAMPLE_TXN_ASYNC)))
+		p = add_str(p, "NEITHER ");
+	if (t & PERF_SAMPLE_TXN_ABORT_MASK) {
+		sprintf(p, ":%" PRIx64,
+			(t & PERF_SAMPLE_TXN_ABORT_MASK) >>
+			PERF_SAMPLE_TXN_ABORT_SHIFT);
+		p += strlen(p);
+	}
+
+	return repsep_snprintf(bf, size, "%-*s", width, buf);
+}
+
+struct sort_entry sort_transaction = {
+	.se_header	= "Transaction                ",
+	.se_cmp		= sort__transaction_cmp,
+	.se_snprintf	= hist_entry__transaction_snprintf,
+	.se_width_idx	= HISTC_TRANSACTION,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -593,6 +651,7 @@ static struct sort_dimension sort_dimensions[] = {
 	DIM(SORT_INTX, "intx", sort_intx),
 	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
 	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
+	DIM(SORT_TRANSACTION, "transaction", sort_transaction),
 };
 
 int sort_dimension__add(const char *tok)
@@ -657,6 +716,8 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_GLOBAL_WEIGHT;
 			else if (!strcmp(sd->name, "local_weight"))
 				sort__first_dimension = SORT_LOCAL_WEIGHT;
+			else if (!strcmp(sd->name, "transaction"))
+				sort__first_dimension = SORT_TRANSACTION;
 		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 6628b42..cbcc354 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -82,6 +82,7 @@ struct hist_entry {
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
+	u64			transaction;
 	s32			cpu;
 
 	struct hist_entry_diff	diff;
@@ -123,6 +124,7 @@ enum sort_type {
 	SORT_INTX,
 	SORT_LOCAL_WEIGHT,
 	SORT_GLOBAL_WEIGHT,
+	SORT_TRANSACTION,
 };
 
 /*
-- 
1.7.7.6

