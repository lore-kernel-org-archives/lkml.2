Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab2JBXvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:51:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:61637 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844Ab2JBXtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:49:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="200845779"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 22/31] perf, tools: Add support for record transaction flags
Date: Tue,  2 Oct 2012 16:48:42 -0700
Message-Id: <1349221731-15665-23-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
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
index 4930654..2ede9e6 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -182,12 +182,15 @@ is enabled for all the sampling events. The sampled branch type is the same for
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
index af4176b7..aa64744 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1007,6 +1007,8 @@ const struct option record_options[] = {
 		     parse_branch_stack),
 	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
 		    "sample by weight (on special events only)"),
+	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
+		    "sample transaction flags (special events only)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 6e1970e..4cc1569 100644
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
index da55f7e..f7801de 100644
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

