Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2KJBaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:30:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:41258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab2KJB2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:28:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="246777201"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 16/32] perf, tools: Add support for weight v3
Date: Fri,  9 Nov 2012 17:27:32 -0800
Message-Id: <1352510868-7911-17-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

perf record has a new option -W that enables weightened sampling.

Add sorting support in top/report for the average weight per sample and the
total weight sum. This allows to both compare relative cost per event
and the total cost over the measurement period.

Add the necessary glue to perf report, record and the library.

v2: Merge with new hist refactoring.
v3: Fix manpage. Remove value check.
Rename global_weight to weight and weight to local_weight.
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
 tools/perf/util/hist.c                   |   22 +++++++++----
 tools/perf/util/hist.h                   |    8 +++-
 tools/perf/util/session.c                |    3 ++
 tools/perf/util/sort.c                   |   51 +++++++++++++++++++++++++++++-
 tools/perf/util/sort.h                   |    3 ++
 14 files changed, 109 insertions(+), 19 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 159680e..fd4ac81 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -185,6 +185,12 @@ is enabled for all the sampling events. The sampled branch type is the same for
 The various filters must be specified as a comma separated list: --branch-filter any_ret,u,k
 Note that this feature may not be available on all processors.
 
+-W::
+--weight::
+Enable weightened sampling. An additional weight is recorded per sample and can be
+displayed with the weight and local_weight sort keys.  This currently works for TSX
+abort events and some memory events in precise mode on modern Intel CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index cb23476..0b9cd0f 100644
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
index 380683d..84cdbd1 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -248,9 +248,10 @@ int perf_diff__formula(char *buf, size_t size, struct hist_entry *he)
 }
 
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
@@ -272,7 +273,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 	if (al.filtered)
 		return 0;
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period)) {
+	if (hists__add_entry(&evsel->hists, &al, sample->period, sample->weight)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 067d8ee..5ed43f2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1044,6 +1044,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('j', "branch-filter", &record.opts.branch_stack,
 		     "branch filter mask", "branch stack filter modes",
 		     parse_branch_stack),
+	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
+		    "sample by weight (on special events only)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 836aa32..bd7bb66 100644
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
 
@@ -596,7 +597,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
 		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
-		   " abort, intx"),
+		   " abort, intx,  weight, local_weight"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 213bfeb..eb4ba1d5 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -271,7 +271,8 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 {
 	struct hist_entry *he;
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period);
+	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
+				sample->weight);
 	if (he == NULL)
 		return NULL;
 
@@ -1228,7 +1229,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
 		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
-		   " abort, intx"),
+		   " abort, intx, weight, local_weight"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top, "output_type,min_percent, call_order",
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index d106d5a..7d3173f 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -235,6 +235,7 @@ struct perf_record_opts {
 	bool	     pipe_output;
 	bool	     raw_samples;
 	bool	     sample_address;
+	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     sample_id_all_missing;
 	bool	     exclude_guest_missing;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 0d573ff..a97fbbe 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -88,6 +88,7 @@ struct perf_sample {
 	u64 id;
 	u64 stream_id;
 	u64 period;
+	u64 weight;
 	u32 cpu;
 	u32 raw_size;
 	void *raw_data;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 618d411..3800fb5 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -445,6 +445,9 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 		attr->mmap_data = track;
 	}
 
+	if (opts->sample_weight)
+		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
+
 	if (opts->call_graph) {
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
@@ -870,6 +873,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
 	data->period = 1;
+	data->weight = 0;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!evsel->attr.sample_id_all)
@@ -941,6 +945,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
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
index 277947a..cbedba7 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -151,9 +151,11 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
 	}
 }
 
-static void he_stat__add_period(struct he_stat *he_stat, u64 period)
+static void he_stat__add_period(struct he_stat *he_stat, u64 period,
+				u64 weight)
 {
 	he_stat->period		+= period;
+	he_stat->weight		+= weight;
 	he_stat->nr_events	+= 1;
 }
 
@@ -165,12 +167,14 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
 	dest->period_guest_sys	+= src->period_guest_sys;
 	dest->period_guest_us	+= src->period_guest_us;
 	dest->nr_events		+= src->nr_events;
+	dest->weight		+= src->weight;
 }
 
 static void hist_entry__decay(struct hist_entry *he)
 {
 	he->stat.period = (he->stat.period * 7) / 8;
 	he->stat.nr_events = (he->stat.nr_events * 7) / 8;
+	/* XXX need decay for weight too? */
 }
 
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
@@ -268,7 +272,8 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 static struct hist_entry *add_hist_entry(struct hists *hists,
 				      struct hist_entry *entry,
 				      struct addr_location *al,
-				      u64 period)
+				      u64 period,
+				      u64 weight)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -286,7 +291,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(entry, he);
 
 		if (!cmp) {
-			he_stat__add_period(&he->stat, period);
+			he_stat__add_period(&he->stat, period, weight);
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -314,6 +319,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
+	he->stat.weight += weight;
 out:
 	hist_entry__add_cpumode_period(he, al->cpumode, period);
 out_unlock:
@@ -325,7 +331,8 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
 					     struct branch_info *bi,
-					     u64 period)
+					     u64 period,
+					     u64 weight)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -346,12 +353,13 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.hists	= self,
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
@@ -371,7 +379,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.hists	= self,
 	};
 
-	return add_hist_entry(self, &entry, al, period);
+	return add_hist_entry(self, &entry, al, period, weight);
 }
 
 int64_t
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d874bf5..f8b4bca 100644
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
 int hist_entry__sort_snprintf(struct hist_entry *self, char *bf, size_t size,
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
index 15abe40..175dde3 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1006,6 +1006,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
+
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		printf("... weight: %" PRIu64 "\n", sample->weight);
 }
 
 static struct machine *
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a8d1f1a..a7a9691 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -525,6 +525,49 @@ struct sort_entry sort_intx = {
 	.se_width_idx	= HISTC_INTX,
 };
 
+static u64 he_weight(struct hist_entry *he)
+{
+	return he->stat.nr_events ? he->stat.weight / he->stat.nr_events : 0;
+}
+
+static int64_t
+sort__local_weight_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return he_weight(left) - he_weight(right);
+}
+
+static int hist_entry__local_weight_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*llu", width, he_weight(self));
+}
+
+struct sort_entry sort_local_weight = {
+	.se_header	= "Local Weight",
+	.se_cmp		= sort__local_weight_cmp,
+	.se_snprintf	= hist_entry__local_weight_snprintf,
+	.se_width_idx	= HISTC_WEIGHT,
+};
+
+static int64_t
+sort__global_weight_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return left->stat.weight - right->stat.weight;
+}
+
+static int hist_entry__global_weight_snprintf(struct hist_entry *self, char *bf,
+					      size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*llu", width, self->stat.weight);
+}
+
+struct sort_entry sort_global_weight = {
+	.se_header	= "Weight",
+	.se_cmp		= sort__global_weight_cmp,
+	.se_snprintf	= hist_entry__global_weight_snprintf,
+	.se_width_idx	= HISTC_GLOBAL_WEIGHT,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -547,7 +590,9 @@ static struct sort_dimension sort_dimensions[] = {
 	DIM(SORT_MISPREDICT, "mispredict", sort_mispredict),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
 	DIM(SORT_ABORT, "abort", sort_abort),
-	DIM(SORT_INTX, "intx", sort_intx)
+	DIM(SORT_INTX, "intx", sort_intx),
+	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
+	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 };
 
 int sort_dimension__add(const char *tok)
@@ -608,6 +653,10 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_INTX;
 			else if (!strcmp(sd->name, "abort"))
 				sort__first_dimension = SORT_ABORT;
+			else if (!strcmp(sd->name, "weight"))
+				sort__first_dimension = SORT_GLOBAL_WEIGHT;
+			else if (!strcmp(sd->name, "local_weight"))
+				sort__first_dimension = SORT_LOCAL_WEIGHT;
 		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 7e439b9..6628b42 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -49,6 +49,7 @@ struct he_stat {
 	u64			period_us;
 	u64			period_guest_sys;
 	u64			period_guest_us;
+	u64			weight;
 	u32			nr_events;
 };
 
@@ -120,6 +121,8 @@ enum sort_type {
 	SORT_SRCLINE,
 	SORT_ABORT,
 	SORT_INTX,
+	SORT_LOCAL_WEIGHT,
+	SORT_GLOBAL_WEIGHT,
 };
 
 /*
-- 
1.7.7.6

