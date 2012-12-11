Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2LKWsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:48:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43830 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab2LKWsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 25/37] perf evsel: Update sample_size when setting sample_type bits
Date: Tue, 11 Dec 2012 19:48:11 -0300
Message-Id: <1355266103-17238-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We use evsel->sample_size to detect underflows in
perf_evsel__parse_sample, but we were failing to update it after
perf_evsel__init(), i.e. when we decide, after creating an evsel, that
we want some extra field bit set.

Fix it by introducing methods to set a bit that will take care of
correctly adjusting evsel->sample_size.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2ny5pzsing0dcth7hws48x9c@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    |    2 +-
 tools/perf/builtin-top.c       |   11 +++++-----
 tools/perf/tests/perf-record.c |    6 +++---
 tools/perf/util/evlist.c       |    2 +-
 tools/perf/util/evsel.c        |   45 ++++++++++++++++++++++++++++------------
 tools/perf/util/evsel.h        |   11 ++++++++++
 6 files changed, 54 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f3151d3..0be6605 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -286,7 +286,7 @@ try_again:
 					 */
 					opts->sample_id_all_missing = true;
 					if (!opts->sample_time && !opts->raw_samples && !time_needed)
-						attr->sample_type &= ~PERF_SAMPLE_TIME;
+						perf_evsel__reset_sample_bit(pos, TIME);
 
 					goto retry_sample_id;
 				}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 987e1b8..31a7c51 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -901,24 +901,25 @@ static void perf_top__start_counters(struct perf_top *top)
 	list_for_each_entry(counter, &evlist->entries, node) {
 		struct perf_event_attr *attr = &counter->attr;
 
-		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+		perf_evsel__set_sample_bit(counter, IP);
+		perf_evsel__set_sample_bit(counter, TID);
 
 		if (top->freq) {
-			attr->sample_type |= PERF_SAMPLE_PERIOD;
+			perf_evsel__set_sample_bit(counter, PERIOD);
 			attr->freq	  = 1;
 			attr->sample_freq = top->freq;
 		}
 
 		if (evlist->nr_entries > 1) {
-			attr->sample_type |= PERF_SAMPLE_ID;
+			perf_evsel__set_sample_bit(counter, ID);
 			attr->read_format |= PERF_FORMAT_ID;
 		}
 
 		if (perf_target__has_cpu(&top->target))
-			attr->sample_type |= PERF_SAMPLE_CPU;
+			perf_evsel__set_sample_bit(counter, CPU);
 
 		if (symbol_conf.use_callchain)
-			attr->sample_type |= PERF_SAMPLE_CALLCHAIN;
+			perf_evsel__set_sample_bit(counter, CALLCHAIN);
 
 		attr->mmap = 1;
 		attr->comm = 1;
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 70e0d44..5902772 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -103,9 +103,9 @@ int test__PERF_RECORD(void)
 	 * Config the evsels, setting attr->comm on the first one, etc.
 	 */
 	evsel = perf_evlist__first(evlist);
-	evsel->attr.sample_type |= PERF_SAMPLE_CPU;
-	evsel->attr.sample_type |= PERF_SAMPLE_TID;
-	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
+	perf_evsel__set_sample_bit(evsel, CPU);
+	perf_evsel__set_sample_bit(evsel, TID);
+	perf_evsel__set_sample_bit(evsel, TIME);
 	perf_evlist__config_attrs(evlist, &opts);
 
 	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d0e1e82..2655659 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -61,7 +61,7 @@ void perf_evlist__config_attrs(struct perf_evlist *evlist,
 		perf_evsel__config(evsel, opts);
 
 		if (evlist->nr_entries > 1)
-			evsel->attr.sample_type |= PERF_SAMPLE_ID;
+			perf_evsel__set_sample_bit(evsel, ID);
 	}
 }
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index bb58b05..fc80f5a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -50,6 +50,24 @@ void hists__init(struct hists *hists)
 	pthread_mutex_init(&hists->lock, NULL);
 }
 
+void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
+				  enum perf_event_sample_format bit)
+{
+	if (!(evsel->attr.sample_type & bit)) {
+		evsel->attr.sample_type |= bit;
+		evsel->sample_size += sizeof(u64);
+	}
+}
+
+void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
+				    enum perf_event_sample_format bit)
+{
+	if (evsel->attr.sample_type & bit) {
+		evsel->attr.sample_type &= ~bit;
+		evsel->sample_size -= sizeof(u64);
+	}
+}
+
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
 {
@@ -445,7 +463,8 @@ void perf_evsel__config(struct perf_evsel *evsel,
 			      PERF_FORMAT_TOTAL_TIME_RUNNING |
 			      PERF_FORMAT_ID;
 
-	attr->sample_type  |= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+	perf_evsel__set_sample_bit(evsel, IP);
+	perf_evsel__set_sample_bit(evsel, TID);
 
 	/*
 	 * We default some events to a 1 default interval. But keep
@@ -454,7 +473,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
 				     opts->user_interval != ULLONG_MAX)) {
 		if (opts->freq) {
-			attr->sample_type	|= PERF_SAMPLE_PERIOD;
+			perf_evsel__set_sample_bit(evsel, PERIOD);
 			attr->freq		= 1;
 			attr->sample_freq	= opts->freq;
 		} else {
@@ -469,16 +488,16 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->inherit_stat = 1;
 
 	if (opts->sample_address) {
-		attr->sample_type	|= PERF_SAMPLE_ADDR;
+		perf_evsel__set_sample_bit(evsel, ADDR);
 		attr->mmap_data = track;
 	}
 
 	if (opts->call_graph) {
-		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
+		perf_evsel__set_sample_bit(evsel, CALLCHAIN);
 
 		if (opts->call_graph == CALLCHAIN_DWARF) {
-			attr->sample_type |= PERF_SAMPLE_REGS_USER |
-					     PERF_SAMPLE_STACK_USER;
+			perf_evsel__set_sample_bit(evsel, REGS_USER);
+			perf_evsel__set_sample_bit(evsel, STACK_USER);
 			attr->sample_regs_user = PERF_REGS_MASK;
 			attr->sample_stack_user = opts->stack_dump_size;
 			attr->exclude_callchain_user = 1;
@@ -486,20 +505,20 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	}
 
 	if (perf_target__has_cpu(&opts->target))
-		attr->sample_type	|= PERF_SAMPLE_CPU;
+		perf_evsel__set_sample_bit(evsel, CPU);
 
 	if (opts->period)
-		attr->sample_type	|= PERF_SAMPLE_PERIOD;
+		perf_evsel__set_sample_bit(evsel, PERIOD);
 
 	if (!opts->sample_id_all_missing &&
 	    (opts->sample_time || !opts->no_inherit ||
 	     perf_target__has_cpu(&opts->target)))
-		attr->sample_type	|= PERF_SAMPLE_TIME;
+		perf_evsel__set_sample_bit(evsel, TIME);
 
 	if (opts->raw_samples) {
-		attr->sample_type	|= PERF_SAMPLE_TIME;
-		attr->sample_type	|= PERF_SAMPLE_RAW;
-		attr->sample_type	|= PERF_SAMPLE_CPU;
+		perf_evsel__set_sample_bit(evsel, TIME);
+		perf_evsel__set_sample_bit(evsel, RAW);
+		perf_evsel__set_sample_bit(evsel, CPU);
 	}
 
 	if (opts->no_delay) {
@@ -507,7 +526,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->wakeup_events = 1;
 	}
 	if (opts->branch_stack) {
-		attr->sample_type	|= PERF_SAMPLE_BRANCH_STACK;
+		perf_evsel__set_sample_bit(evsel, BRANCH_STACK);
 		attr->branch_sample_type = opts->branch_stack;
 	}
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3f7ff47..7398539 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -118,6 +118,17 @@ void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
+void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
+				  enum perf_event_sample_format bit);
+void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
+				    enum perf_event_sample_format bit);
+
+#define perf_evsel__set_sample_bit(evsel, bit) \
+	__perf_evsel__set_sample_bit(evsel, PERF_SAMPLE_##bit)
+
+#define perf_evsel__reset_sample_bit(evsel, bit) \
+	__perf_evsel__reset_sample_bit(evsel, PERF_SAMPLE_##bit)
+
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter);
 
-- 
1.7.9.2.358.g22243

