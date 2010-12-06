Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0LFChk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 21:37:40 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45362 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab0LFCha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 21:37:30 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 3/3] perf record/report: Process events in order
Date: Mon,  6 Dec 2010 13:37:06 +1100
Message-Id: <1291603026-11785-4-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch changes perf report to ask for the ID info on all events be
default if recording from multiple CPUs.

Perf report will now process the events in order if the kernel is able
to provide timestamps on all events. This ensures that events such as
COMM and MMAP which are necessary to correctly interpret samples are
processed prior to those samples so that they are attributed correctly.

Before:
 # perf record ./cachetest
 # perf report

 # Events: 6K cycles
 #
 # Overhead  Command      Shared Object                           Symbol
 # ........  .......  .................  ...............................
 #
     74.11%    :3259  [unknown]          [k] 0x4a6c
      1.50%  cachetest  ld-2.11.2.so       [.] 0x1777c
      1.46%    :3259  [kernel.kallsyms]  [k] .perf_event_mmap_ctx
      1.25%    :3259  [kernel.kallsyms]  [k] restore
      0.74%    :3259  [kernel.kallsyms]  [k] ._raw_spin_lock
      0.71%    :3259  [kernel.kallsyms]  [k] .filemap_fault
      0.66%    :3259  [kernel.kallsyms]  [k] .memset
      0.54%  cachetest  [kernel.kallsyms]  [k] .sha_transform
      0.54%    :3259  [kernel.kallsyms]  [k] .copy_4K_page
      0.54%    :3259  [kernel.kallsyms]  [k] .find_get_page
      0.52%    :3259  [kernel.kallsyms]  [k] .trace_hardirqs_off
      0.50%    :3259  [kernel.kallsyms]  [k] .__do_fault
<SNIP>

After:
 # perf report

 # Events: 6K cycles
 #
 # Overhead  Command      Shared Object                           Symbol
 # ........  .......  .................  ...............................
 #
     44.28%  cachetest  cachetest          [.] sumArrayNaive
     22.53%  cachetest  cachetest          [.] sumArrayOptimal
      6.59%  cachetest  ld-2.11.2.so       [.] 0x1777c
      2.13%  cachetest  [unknown]          [k] 0x340
      1.46%  cachetest  [kernel.kallsyms]  [k] .perf_event_mmap_ctx
      1.25%  cachetest  [kernel.kallsyms]  [k] restore
      0.74%  cachetest  [kernel.kallsyms]  [k] ._raw_spin_lock
      0.71%  cachetest  [kernel.kallsyms]  [k] .filemap_fault
      0.66%  cachetest  [kernel.kallsyms]  [k] .memset
      0.54%  cachetest  [kernel.kallsyms]  [k] .copy_4K_page
      0.54%  cachetest  [kernel.kallsyms]  [k] .find_get_page
      0.54%  cachetest  [kernel.kallsyms]  [k] .sha_transform
      0.52%  cachetest  [kernel.kallsyms]  [k] .trace_hardirqs_off
      0.50%  cachetest  [kernel.kallsyms]  [k] .__do_fault
<SNIP>

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/builtin-record.c |    4 +-
 tools/perf/builtin-report.c |    1 +
 tools/perf/util/session.c   |  132 ++++++++++++++++++++++++-------------------
 3 files changed, 77 insertions(+), 60 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 699dd21..f208c2d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -285,7 +285,7 @@ static void create_counter(int counter, int cpu)
 	if (system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
-	if (sample_time)
+	if (sample_time || system_wide || !no_inherit || cpu_list)
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 
 	if (raw_samples) {
@@ -327,6 +327,8 @@ try_again:
 				 * Old kernel, no attr->sample_id_type_all field
 				 */
 				sample_id_all_avail = false;
+				if (!sample_time && !raw_samples)
+					attr->sample_type &= ~PERF_SAMPLE_TIME;
 				goto retry_sample_id;
 			}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 904519f..84d25fa 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -244,6 +244,7 @@ static struct perf_event_ops event_ops = {
 	.event_type = event__process_event_type,
 	.tracing_data = event__process_tracing_data,
 	.build_id = event__process_build_id,
+	.ordered_samples = true,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 596829f..f33d3b3 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -462,6 +462,45 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
 	}
 }
 
+static int perf_session__dispatch_event(event_t *event,
+					struct sample_data *sample,
+					struct perf_session *s,
+					struct perf_event_ops *ops)
+{
+	switch (event->header.type) {
+	case PERF_RECORD_SAMPLE:
+		return ops->sample(event, sample, s);
+	case PERF_RECORD_MMAP:
+		return ops->mmap(event, sample, s);
+	case PERF_RECORD_COMM:
+		return ops->comm(event, sample, s);
+	case PERF_RECORD_FORK:
+		return ops->fork(event, sample, s);
+	case PERF_RECORD_EXIT:
+		return ops->exit(event, sample, s);
+	case PERF_RECORD_LOST:
+		return ops->lost(event, sample, s);
+	case PERF_RECORD_READ:
+		return ops->read(event, sample, s);
+	case PERF_RECORD_THROTTLE:
+		return ops->throttle(event, sample, s);
+	case PERF_RECORD_UNTHROTTLE:
+		return ops->unthrottle(event, sample, s);
+	case PERF_RECORD_HEADER_ATTR:
+		return ops->attr(event, s);
+	case PERF_RECORD_HEADER_EVENT_TYPE:
+		return ops->event_type(event, s);
+	case PERF_RECORD_HEADER_TRACING_DATA:
+		return ops->tracing_data(event, s);
+	case PERF_RECORD_HEADER_BUILD_ID:
+		return ops->build_id(event, s);
+	case PERF_RECORD_FINISHED_ROUND:
+		return ops->finished_round(event, s, ops);
+	default:
+		return -1;
+	}
+}
+
 static void flush_sample_queue(struct perf_session *s,
 			       struct perf_event_ops *ops)
 {
@@ -482,8 +521,7 @@ static void flush_sample_queue(struct perf_session *s,
 		event__parse_sample(iter->event, s, &sample);
 
 		trace_event((event_t *)iter->event, iter->file_offset, s, &sample);
-
-		ops->sample(iter->event, &sample, s);
+		perf_session__dispatch_event(iter->event, &sample, s, ops);
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
@@ -548,8 +586,7 @@ static int process_finished_round(event_t *event __used,
 }
 
 /* The queue is ordered by time */
-static void __queue_sample_event(struct sample_queue *new,
-				 struct perf_session *s)
+static void __queue_event(struct sample_queue *new, struct perf_session *s)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct sample_queue *sample = os->last_sample;
@@ -595,12 +632,11 @@ static void __queue_sample_event(struct sample_queue *new,
 
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
 
-static int queue_sample_event(event_t *event, struct sample_data *data,
-			      struct perf_session *s, u64 file_offset)
+static int queue_event(event_t *event, u64 timestamp,
+		       struct perf_session *s, u64 file_offset)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *sc = &os->sample_cache;
-	u64 timestamp = data->time;
 	struct sample_queue *new;
 
 	if (timestamp < s->ordered_samples.last_flush) {
@@ -628,23 +664,28 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 	new->file_offset = file_offset;
 	new->event = event;
 
-	__queue_sample_event(new, s);
+	__queue_event(new, s);
 
 	return 0;
 }
 
-static int perf_session__process_sample(event_t *event,
-					struct sample_data *sample,
-					struct perf_session *s,
-					struct perf_event_ops *ops,
-					u64 file_offset)
+static int perf_session__process_timed(event_t *event,
+				       struct sample_data *sample,
+				       struct perf_session *s,
+				       struct perf_event_ops *ops,
+				       u64 file_offset)
 {
+	if (ops->ordered_samples && sample->time == -1ULL) {
+		dump_printf("Event missing timestamp, switching to unordered processing\n");
+		flush_sample_queue(s, ops);
+		ops->ordered_samples = false;
+	}
 	if (!ops->ordered_samples) {
 		trace_event(event, file_offset, s, sample);
-		return ops->sample(event, sample, s);
+		return perf_session__dispatch_event(event, sample, s, ops);
 	}
 
-	queue_sample_event(event, sample, s, file_offset);
+	queue_event(event, sample->time, s, file_offset);
 	return 0;
 }
 
@@ -664,57 +705,30 @@ static int perf_session__process_event(struct perf_session *self,
 
 	if (event->header.type < PERF_RECORD_HEADER_MAX)
 		hists__inc_nr_events(&self->hists, event->header.type);
+	else
+		++self->hists.stats.nr_unknown_events;
 
-	switch (event->header.type) {
-	case PERF_RECORD_SAMPLE:
-		if (self->sample_type & PERF_SAMPLE_CALLCHAIN &&
-		    !ip_callchain__valid(sample.callchain, event)) {
-			pr_debug("call-chain problem with event, "
-				 "skipping it.\n");
-			++self->hists.stats.nr_invalid_chains;
-			self->hists.stats.total_invalid_chains += sample.period;
-			return 0;
-		}
-
-		return perf_session__process_sample(event, &sample, self, ops, file_offset);
-	default: break;
+	if (event->header.type == PERF_RECORD_SAMPLE &&
+			self->sample_type & PERF_SAMPLE_CALLCHAIN &&
+			!ip_callchain__valid(sample.callchain, event)) {
+		pr_debug("call-chain problem with event, skipping it.\n");
+		++self->hists.stats.nr_invalid_chains;
+		self->hists.stats.total_invalid_chains += sample.period;
+		return 0;
 	}
 
+	if (event->header.type >= PERF_RECORD_MMAP &&
+	    event->header.type <= PERF_RECORD_SAMPLE)
+		return perf_session__process_timed(event, &sample, self, ops,
+						   file_offset);
+
 	trace_event(event, file_offset, self, &sample);
 
-	switch (event->header.type) {
-	case PERF_RECORD_MMAP:
-		return ops->mmap(event, &sample, self);
-	case PERF_RECORD_COMM:
-		return ops->comm(event, &sample, self);
-	case PERF_RECORD_FORK:
-		return ops->fork(event, &sample, self);
-	case PERF_RECORD_EXIT:
-		return ops->exit(event, &sample, self);
-	case PERF_RECORD_LOST:
-		return ops->lost(event, &sample, self);
-	case PERF_RECORD_READ:
-		return ops->read(event, &sample, self);
-	case PERF_RECORD_THROTTLE:
-		return ops->throttle(event, &sample, self);
-	case PERF_RECORD_UNTHROTTLE:
-		return ops->unthrottle(event, &sample, self);
-	case PERF_RECORD_HEADER_ATTR:
-		return ops->attr(event, self);
-	case PERF_RECORD_HEADER_EVENT_TYPE:
-		return ops->event_type(event, self);
-	case PERF_RECORD_HEADER_TRACING_DATA:
+	if (event->header.type == PERF_RECORD_HEADER_TRACING_DATA)
 		/* setup for reading amidst mmap */
 		lseek(self->fd, file_offset, SEEK_SET);
-		return ops->tracing_data(event, self);
-	case PERF_RECORD_HEADER_BUILD_ID:
-		return ops->build_id(event, self);
-	case PERF_RECORD_FINISHED_ROUND:
-		return ops->finished_round(event, self, ops);
-	default:
-		++self->hists.stats.nr_unknown_events;
-		return -1;
-	}
+
+	return perf_session__dispatch_event(event, &sample, self, ops);
 }
 
 void perf_event_header__bswap(struct perf_event_header *self)
-- 
1.7.2.3

