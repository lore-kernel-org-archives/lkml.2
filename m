Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2I1Ecp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:32:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:42307 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab2I1EcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:32:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="215093237"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 20/31] perf, tools: Add support for weight
Date: Thu, 27 Sep 2012 21:31:25 -0700
Message-Id: <1348806696-31170-21-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

perf record has a new option -W that enables weightened sampling.

Add sorting support in top/report for the average weight per sample and the
total weight sum. This allows to both compare relative cost per event
and the total cost over the measurement period.

Add the necessary glue to perf report, record and the library.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt |    6 +++
 tools/perf/builtin-annotate.c            |    2 +-
 tools/perf/builtin-diff.c                |    7 ++--
 tools/perf/builtin-record.c              |    2 +
 tools/perf/builtin-report.c              |    7 ++--
 tools/perf/builtin-top.c                 |    5 ++-
 tools/perf/perf.h                        |    1 +
 tools/perf/util/event.h                  |    1 +
 tools/perf/util/evsel.c                  |   10 ++++++
 tools/perf/util/hist.c                   |   20 ++++++++---
 tools/perf/util/hist.h                   |    8 +++-
 tools/perf/util/session.c                |    3 ++
 tools/perf/util/sort.c                   |   51 +++++++++++++++++++++++++++++-
 tools/perf/util/sort.h                   |    3 ++
 14 files changed, 108 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index b38a1f9..4930654 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -182,6 +182,12 @@ is enabled for all the sampling events. The sampled branch type is the same for
 The various filters must be specified as a comma separated list: --branch-filter any_ret,u,k
 Note that this feature may not be available on all processors.
 
+-W::
+--weight::
+Enable weightened sampling. When the event supports an additional weight per sample scale
+the histogram by this weight. This currently works for TSX abort events and some memory events
+in precise mode on modern Intel CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 67522cf..c522367 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -62,7 +62,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, 1);
+	he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d29d350..04c1d21 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -30,9 +30,10 @@ struct perf_diff {
 };
 
 static int hists__add_entry(struct hists *self,
-			    struct addr_location *al, u64 period)
+			    struct addr_location *al, u64 period,
+			    u64 weight)
 {
-	if (__hists__add_entry(self, al, NULL, period) != NULL)
+	if (__hists__add_entry(self, al, NULL, period, weight) != NULL)
 		return 0;
 	return -ENOMEM;
 }
@@ -56,7 +57,7 @@ static int diff__process_sample_event(struct perf_tool *tool,
 	if (al.filtered || al.sym == NULL)
 		return 0;
 
-	if (hists__add_entry(&session->hists, &al, sample->period)) {
+	if (hists__add_entry(&session->hists, &al, sample->period, sample->weight)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e851bf2..4dbdc4e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -836,6 +836,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('j', "branch-filter", &record.opts.branch_stack,
 		     "branch filter mask", "branch stack filter modes",
 		     parse_branch_stack),
+	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
+		    "sample by weight (on special events only)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8231cb1..2c73578 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -88,7 +88,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 		 * and not events sampled. Thus we use a pseudo period of 1.
 		 */
 		he = __hists__add_branch_entry(&evsel->hists, al, parent,
-				&bi[i], 1);
+				&bi[i], 1, 1);
 		if (he) {
 			struct annotation *notes;
 			err = -ENOMEM;
@@ -146,7 +146,8 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 			return err;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
+	he = __hists__add_entry(&evsel->hists, al, parent, sample->period,
+					sample->weight);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -595,7 +596,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
 		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
-		   " abort, intx"),
+		   " abort, intx,  weight, global_weight"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5ab2188..ee37ddc 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -269,7 +269,8 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 {
 	struct hist_entry *he;
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period);
+	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
+				sample->weight);
 	if (he == NULL)
 		return NULL;
 
@@ -1229,7 +1230,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
 		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
-		   " abort, intx"),
+		   " abort, intx, weight, global_weight"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top, "output_type,min_percent, call_order",
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 9147ffc..a98dcf2 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -222,6 +222,7 @@ struct perf_record_opts {
 	bool	     pipe_output;
 	bool	     raw_samples;
 	bool	     sample_address;
+	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     sample_id_all_missing;
 	bool	     exclude_guest_missing;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index d84870b..5ac79f3 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -77,6 +77,7 @@ struct perf_sample {
 	u64 id;
 	u64 stream_id;
 	u64 period;
+	u64 weight;
 	u32 cpu;
 	u32 raw_size;
 	void *raw_data;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index cda3805..ff084b0 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -377,6 +377,9 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 		attr->mmap_data = track;
 	}
 
+	if (opts->sample_weight)
+		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
+
 	if (opts->call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
@@ -755,6 +758,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
 	data->period = 1;
+	data->weight = 0;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!evsel->attr.sample_id_all)
@@ -826,6 +830,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
+	data->weight = 0;
+	if (type & PERF_SAMPLE_WEIGHT) {
+		data->weight = *array;
+		array++;
+	}
+
 	if (type & PERF_SAMPLE_READ) {
 		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
 		return -1;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f247ef2..566badc 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -236,13 +236,17 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 static struct hist_entry *add_hist_entry(struct hists *hists,
 				      struct hist_entry *entry,
 				      struct addr_location *al,
-				      u64 period)
+				      u64 period,
+				      u64 weight)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	int cmp;
 
+	if (weight == 0)
+		weight = 1;
+
 	pthread_mutex_lock(&hists->lock);
 
 	p = &hists->entries_in->rb_node;
@@ -255,7 +259,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 
 		if (!cmp) {
 			he->period += period;
-			++he->nr_events;
+			he->nr_events++;
+			he->weight += weight;
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -294,7 +299,8 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
 					     struct branch_info *bi,
-					     u64 period)
+					     u64 period,
+					     u64 weight)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -311,12 +317,13 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.branch_info = bi,
 	};
 
-	return add_hist_entry(self, &entry, al, period);
+	return add_hist_entry(self, &entry, al, period, weight);
 }
 
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
-				      struct symbol *sym_parent, u64 period)
+				      struct symbol *sym_parent, u64 period,
+				      u64 weight)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -332,7 +339,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.filtered = symbol__parent_filter(sym_parent),
 	};
 
-	return add_hist_entry(self, &entry, al, period);
+	return add_hist_entry(self, &entry, al, period, weight);
 }
 
 int64_t
@@ -396,6 +403,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __used,
 		if (!cmp) {
 			iter->period += he->period;
 			iter->nr_events += he->nr_events;
+			iter->weight += he->weight;
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
 				callchain_merge(&callchain_cursor,
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 71837aa..a02d068 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -50,6 +50,8 @@ enum hist_column {
 	HISTC_DSO_FROM,
 	HISTC_DSO_TO,
 	HISTC_SRCLINE,
+	HISTC_WEIGHT,
+	HISTC_GLOBAL_WEIGHT,
 	HISTC_NR_COLS, /* Last entry */
 };
 
@@ -74,7 +76,8 @@ struct hists {
 
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
-				      struct symbol *parent, u64 period);
+				      struct symbol *parent, u64 period,
+				      u64 weight);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
@@ -85,7 +88,8 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
 					     struct branch_info *bi,
-					     u64 period);
+					     u64 period,
+					     u64 weight);
 
 void hists__output_resort(struct hists *self);
 void hists__output_resort_threaded(struct hists *hists);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 2437fb0..84f000c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -916,6 +916,9 @@ static void dump_sample(struct perf_session *session, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_BRANCH_STACK)
 		branch_stack__printf(sample);
+
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		printf("... weight: %" PRIu64 "\n", sample->weight);
 }
 
 static struct machine *
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 596b82c..0fcbbcd 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -516,6 +516,49 @@ struct sort_entry sort_intx = {
 	.se_width_idx	= HISTC_INTX,
 };
 
+static u64 he_weight(struct hist_entry *he)
+{
+	return he->nr_events ? he->weight / he->nr_events : 0;
+}
+
+static int64_t
+sort__weight_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return he_weight(left) - he_weight(right);
+}
+
+static int hist_entry__weight_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*llu", width, he_weight(self));
+}
+
+struct sort_entry sort_weight = {
+	.se_header	= "Weight",
+	.se_cmp		= sort__weight_cmp,
+	.se_snprintf	= hist_entry__weight_snprintf,
+	.se_width_idx	= HISTC_WEIGHT,
+};
+
+static int64_t
+sort__global_weight_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return left->weight - right->weight;
+}
+
+static int hist_entry__global_weight_snprintf(struct hist_entry *self, char *bf,
+					      size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*llu", width, self->weight);
+}
+
+struct sort_entry sort_global_weight = {
+	.se_header	= "Total weight",
+	.se_cmp		= sort__global_weight_cmp,
+	.se_snprintf	= hist_entry__global_weight_snprintf,
+	.se_width_idx	= HISTC_GLOBAL_WEIGHT,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -538,7 +581,9 @@ static struct sort_dimension sort_dimensions[] = {
 	DIM(SORT_MISPREDICT, "mispredict", sort_mispredict),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
 	DIM(SORT_ABORT, "abort", sort_abort),
-	DIM(SORT_INTX, "intx", sort_intx)
+	DIM(SORT_INTX, "intx", sort_intx),
+	DIM(SORT_WEIGHT, "weight", sort_weight),
+	DIM(SORT_GLOBAL_WEIGHT, "global_weight", sort_global_weight),
 };
 
 int sort_dimension__add(const char *tok)
@@ -595,6 +640,10 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_INTX;
 			else if (!strcmp(sd->name, "abort"))
 				sort__first_dimension = SORT_ABORT;
+			else if (!strcmp(sd->name, "weight"))
+				sort__first_dimension = SORT_WEIGHT;
+			else if (!strcmp(sd->name, "global_weight"))
+				sort__first_dimension = SORT_GLOBAL_WEIGHT;
 		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index fdb033f..8b2c5ae 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -60,6 +60,7 @@ struct hist_entry {
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
+	u64			weight;
 	s32			cpu;
 	u32			nr_events;
 
@@ -97,6 +98,8 @@ enum sort_type {
 	SORT_SRCLINE,
 	SORT_ABORT,
 	SORT_INTX,
+	SORT_WEIGHT,
+	SORT_GLOBAL_WEIGHT,
 };
 
 /*
-- 
1.7.7.6

