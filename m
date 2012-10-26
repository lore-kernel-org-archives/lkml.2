Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966226Ab2JZUfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:35:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:62124 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759081Ab2JZUa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,656,1344236400"; 
   d="scan'208";a="233093566"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 21/33] perf, tools: Add support for record transaction flags
Date: Fri, 26 Oct 2012 13:30:03 -0700
Message-Id: <1351283415-13170-22-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add the glue in the user tools to record transaction flags with
--transaction (-T was already taken) and dump them.

Followon patches will use them.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt |    5 ++++-
 tools/perf/builtin-record.c              |    2 ++
 tools/perf/perf.h                        |    1 +
 tools/perf/util/event.h                  |    1 +
 tools/perf/util/evsel.c                  |    9 +++++++++
 tools/perf/util/session.c                |    3 +++
 6 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 0ffb436..34f4f1a 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -185,12 +185,15 @@ is enabled for all the sampling events. The sampled branch type is the same for
 The various filters must be specified as a comma separated list: --branch-filter any_ret,u,k
 Note that this feature may not be available on all processors.
 
--W::
 --weight::
 Enable weightened sampling. When the event supports an additional weight per sample scale
 the histogram by this weight. This currently works for TSX abort events and some memory events
 in precise mode on modern Intel CPUs.
 
+-T::
+--transaction::
+Record transaction flags for transaction related events.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9a25116..49de48e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1008,6 +1008,8 @@ const struct option record_options[] = {
 		     parse_branch_stack),
 	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
 		    "sample by weight (on special events only)"),
+	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
+		    "sample transaction flags (special events only)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2365abf..395d216 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -246,6 +246,7 @@ struct perf_record_opts {
 	u64	     default_interval;
 	u64	     user_interval;
 	u16	     stack_dump_size;
+	bool	     sample_transaction;
 };
 
 #endif
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index d60015b..28fd2eb 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -88,6 +88,7 @@ struct perf_sample {
 	u64 stream_id;
 	u64 period;
 	u64 weight;
+	u64 transaction;
 	u32 cpu;
 	u32 raw_size;
 	void *raw_data;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 3800fb5..5c9790d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -448,6 +448,9 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 	if (opts->sample_weight)
 		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
 
+	if (opts->sample_transaction)
+		attr->sample_type	|= PERF_SAMPLE_TRANSACTION;
+
 	if (opts->call_graph) {
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
@@ -951,6 +954,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
+	data->transaction = 0;
+	if (type & PERF_SAMPLE_TRANSACTION) {
+		data->transaction = *array;
+		array++;
+	}
+
 	if (type & PERF_SAMPLE_READ) {
 		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
 		return -1;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 2009665..316dd91 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1009,6 +1009,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		printf("... weight: %" PRIu64 "\n", sample->weight);
+
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		printf("... transaction: %" PRIx64 "\n", sample->transaction);
 }
 
 static struct machine *
-- 
1.7.7.6

