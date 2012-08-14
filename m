Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2HNPXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:23:39 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27338 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab2HNPXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:23:37 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf: create a helper structure perf_event_context
Date: Tue, 14 Aug 2012 19:23:23 +0400
Message-Id: <1344957803-2635317-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A long list of arguments looks not good:
E.g: static int process_sample_event(struct perf_tool *tool,
				     union perf_event *event,
				     struct perf_sample *sample,
				     struct perf_evsel *evsel,
				     struct machine *machine)

That would make extension of the context easier as well in the
future.

Ingo Molnar suggested to refactor code by this way.

Cc: Ingo Molnar <mingo@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 tools/perf/builtin-annotate.c  |   15 +++----
 tools/perf/builtin-diff.c      |   14 +++----
 tools/perf/builtin-inject.c    |   87 +++++++++++++++-------------------------
 tools/perf/builtin-kmem.c      |   16 +++----
 tools/perf/builtin-lock.c      |   13 ++----
 tools/perf/builtin-record.c    |    9 +---
 tools/perf/builtin-report.c    |   29 +++++--------
 tools/perf/builtin-sched.c     |   12 ++---
 tools/perf/builtin-script.c    |   15 +++----
 tools/perf/builtin-timechart.c |   26 ++++--------
 tools/perf/builtin-top.c       |    8 +++-
 tools/perf/util/build-id.c     |   20 ++++-----
 tools/perf/util/build-id.h     |    8 +--
 tools/perf/util/event.c        |   86 +++++++++++++++++++++++----------------
 tools/perf/util/event.h        |   38 ++++++-----------
 tools/perf/util/header.c       |   26 ++++++++++--
 tools/perf/util/session.c      |   42 ++++++++++----------
 tools/perf/util/tool.h         |   13 ++----
 18 files changed, 222 insertions(+), 255 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 67522cf..df29f64 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -80,26 +80,23 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 	return ret;
 }
 
-static int process_sample_event(struct perf_tool *tool,
-				union perf_event *event,
-				struct perf_sample *sample,
-				struct perf_evsel *evsel,
-				struct machine *machine)
+static int process_sample_event(struct perf_event_context *ectx)
 {
-	struct perf_annotate *ann = container_of(tool, struct perf_annotate, tool);
+	struct perf_sample *sample = ectx->sample;
+	struct perf_annotate *ann = container_of(ectx->tool, struct perf_annotate, tool);
 	struct addr_location al;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
+	if (perf_event__preprocess_sample(ectx->event, ectx->machine, &al, sample,
 					  symbol__annotate_init) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
-			   event->header.type);
+			   ectx->event->header.type);
 		return -1;
 	}
 
 	if (ann->cpu_list && !test_bit(sample->cpu, ann->cpu_bitmap))
 		return 0;
 
-	if (!al.filtered && perf_evsel__add_sample(evsel, sample, &al, ann)) {
+	if (!al.filtered && perf_evsel__add_sample(ectx->evsel, sample, &al, ann)) {
 		pr_warning("problem incrementing symbol count, "
 			   "skipping event\n");
 		return -1;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d29d350..22c10df 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -37,19 +37,17 @@ static int hists__add_entry(struct hists *self,
 	return -ENOMEM;
 }
 
-static int diff__process_sample_event(struct perf_tool *tool,
-				      union perf_event *event,
-				      struct perf_sample *sample,
-				      struct perf_evsel *evsel __used,
-				      struct machine *machine)
+static int diff__process_sample_event(struct perf_event_context *ectx)
 {
-	struct perf_diff *_diff = container_of(tool, struct perf_diff, tool);
+	struct perf_diff *_diff = container_of(ectx->tool, struct perf_diff, tool);
 	struct perf_session *session = _diff->session;
 	struct addr_location al;
+	struct perf_sample *sample = ectx->sample;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample, NULL) < 0) {
+	if (perf_event__preprocess_sample(ectx->event, ectx->machine,
+						&al, sample, NULL) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
-			   event->header.type);
+			   ectx->event->header.type);
 		return -1;
 	}
 
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 11dc9cf..e444fc2 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -26,9 +26,7 @@ static u64		bytes_written;
 static bool		inject_build_ids;
 static bool		inject_sched_stat;
 
-static int perf_event__repipe_synth(struct perf_tool *tool __used,
-				    union perf_event *event,
-				    struct machine *machine __used)
+static int perf_event__repipe_synth(union perf_event *event)
 {
 	uint32_t size;
 	void *buf = event;
@@ -49,23 +47,23 @@ static int perf_event__repipe_synth(struct perf_tool *tool __used,
 	return 0;
 }
 
-static int perf_event__repipe_op2_synth(struct perf_tool *tool,
+static int perf_event__repipe_op2_synth(struct perf_tool *tool __used,
 					union perf_event *event,
 					struct perf_session *session __used)
 {
-	return perf_event__repipe_synth(tool, event, NULL);
+	return perf_event__repipe_synth(event);
 }
 
-static int perf_event__repipe_event_type_synth(struct perf_tool *tool,
+static int perf_event__repipe_event_type_synth(struct perf_tool *tool __used,
 					       union perf_event *event)
 {
-	return perf_event__repipe_synth(tool, event, NULL);
+	return perf_event__repipe_synth(event);
 }
 
 static int perf_event__repipe_tracing_data_synth(union perf_event *event,
 						 struct perf_session *session __used)
 {
-	return perf_event__repipe_synth(NULL, event, NULL);
+	return perf_event__repipe_synth(event);
 }
 
 static int perf_event__repipe_attr(union perf_event *event,
@@ -76,48 +74,30 @@ static int perf_event__repipe_attr(union perf_event *event,
 	if (ret)
 		return ret;
 
-	return perf_event__repipe_synth(NULL, event, NULL);
+	return perf_event__repipe_synth(event);
 }
 
-static int perf_event__repipe(struct perf_tool *tool,
-			      union perf_event *event,
-			      struct perf_sample *sample __used,
-			      struct machine *machine)
+static int perf_event__repipe(struct perf_event_context *ectx)
 {
-	return perf_event__repipe_synth(tool, event, machine);
+	return perf_event__repipe_synth(ectx->event);
 }
 
-static int perf_event__repipe_sample(struct perf_tool *tool,
-				     union perf_event *event,
-			      struct perf_sample *sample __used,
-			      struct perf_evsel *evsel __used,
-			      struct machine *machine)
-{
-	return perf_event__repipe_synth(tool, event, machine);
-}
-
-static int perf_event__repipe_mmap(struct perf_tool *tool,
-				   union perf_event *event,
-				   struct perf_sample *sample,
-				   struct machine *machine)
+static int perf_event__repipe_mmap(struct perf_event_context *ectx)
 {
 	int err;
 
-	err = perf_event__process_mmap(tool, event, sample, machine);
-	perf_event__repipe(tool, event, sample, machine);
+	err = perf_event__process_mmap(ectx);
+	perf_event__repipe(ectx);
 
 	return err;
 }
 
-static int perf_event__repipe_task(struct perf_tool *tool,
-				   union perf_event *event,
-				   struct perf_sample *sample,
-				   struct machine *machine)
+static int perf_event__repipe_task(struct perf_event_context *ectx)
 {
 	int err;
 
-	err = perf_event__process_task(tool, event, sample, machine);
-	perf_event__repipe(tool, event, sample, machine);
+	err = perf_event__process_task(ectx);
+	perf_event__repipe(ectx);
 
 	return err;
 }
@@ -127,7 +107,7 @@ static int perf_event__repipe_tracing_data(union perf_event *event,
 {
 	int err;
 
-	perf_event__repipe_synth(NULL, event, NULL);
+	perf_event__repipe_synth(event);
 	err = perf_event__process_tracing_data(event, session);
 
 	return err;
@@ -171,12 +151,10 @@ static int dso__inject_build_id(struct dso *self, struct perf_tool *tool,
 	return 0;
 }
 
-static int perf_event__inject_buildid(struct perf_tool *tool,
-				      union perf_event *event,
-				      struct perf_sample *sample,
-				      struct perf_evsel *evsel __used,
-				      struct machine *machine)
+static int perf_event__inject_buildid(struct perf_event_context *ectx)
 {
+	union perf_event *event = ectx->event;
+	struct machine *machine = ectx->machine;
 	struct addr_location al;
 	struct thread *thread;
 	u8 cpumode;
@@ -197,7 +175,8 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 		if (!al.map->dso->hit) {
 			al.map->dso->hit = 1;
 			if (map__load(al.map, NULL) >= 0) {
-				dso__inject_build_id(al.map->dso, tool, machine);
+				dso__inject_build_id(al.map->dso,
+							ectx->tool, machine);
 				/*
 				 * If this fails, too bad, let the other side
 				 * account this as unresolved.
@@ -213,7 +192,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 	}
 
 repipe:
-	perf_event__repipe(tool, event, sample, machine);
+	perf_event__repipe(ectx);
 	return 0;
 }
 
@@ -225,12 +204,11 @@ struct event_entry {
 
 static LIST_HEAD(samples);
 
-static int perf_event__sched_stat(struct perf_tool *tool,
-				      union perf_event *event,
-				      struct perf_sample *sample,
-				      struct perf_evsel *evsel,
-				      struct machine *machine)
+static int perf_event__sched_stat(struct perf_event_context *ectx)
 {
+	union perf_event *event = ectx->event;
+	struct perf_sample *sample = ectx->sample;
+	struct perf_evsel *evsel = ectx->evsel;
 	const char *evname = NULL;
 	uint32_t size;
 	struct event_entry *ent;
@@ -286,24 +264,23 @@ static int perf_event__sched_stat(struct perf_tool *tool,
 		sample_sw.time = sample->time;
 		perf_evsel__synthesize_sample(evsel, event_sw, &sample_sw, false);
 
-		build_id__mark_dso_hit(tool, event_sw, &sample_sw, evsel, machine);
-		perf_event__repipe(tool, event_sw, &sample_sw, machine);
-		return 0;
+		ectx->sample = &sample_sw;
+		ectx->event = event_sw;
 	}
 
-	build_id__mark_dso_hit(tool, event, sample, evsel, machine);
-	perf_event__repipe(tool, event, sample, machine);
+	build_id__mark_dso_hit(ectx);
+	perf_event__repipe(ectx);
 
 	return 0;
 }
 struct perf_tool perf_inject = {
-	.sample		= perf_event__repipe_sample,
+	.sample		= perf_event__repipe,
 	.mmap		= perf_event__repipe,
 	.comm		= perf_event__repipe,
 	.fork		= perf_event__repipe,
 	.exit		= perf_event__repipe,
 	.lost		= perf_event__repipe,
-	.read		= perf_event__repipe_sample,
+	.read		= perf_event__repipe,
 	.throttle	= perf_event__repipe,
 	.unthrottle	= perf_event__repipe,
 	.attr		= perf_event__repipe_attr,
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index fc6607b..4c4f0ff 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -274,9 +274,10 @@ static void perf_evsel__process_free_event(struct perf_evsel *evsel,
 	s_alloc->alloc_cpu = -1;
 }
 
-static void perf_evsel__process_kmem_event(struct perf_evsel *evsel,
-					   struct perf_sample *sample)
+static void perf_evsel__process_kmem_event(struct perf_event_context *ectx)
 {
+	struct perf_evsel *evsel = ectx->evsel;
+	struct perf_sample *sample = ectx->sample;
 	struct event_format *event = evsel->tp_format;
 
 	if (!strcmp(event->name, "kmalloc") ||
@@ -298,13 +299,10 @@ static void perf_evsel__process_kmem_event(struct perf_evsel *evsel,
 	}
 }
 
-static int process_sample_event(struct perf_tool *tool __used,
-				union perf_event *event,
-				struct perf_sample *sample,
-				struct perf_evsel *evsel,
-				struct machine *machine)
+static int process_sample_event(struct perf_event_context *ectx)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	union perf_event *event = ectx->event;
+	struct thread *thread = machine__findnew_thread(ectx->machine, event->ip.pid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -314,7 +312,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	perf_evsel__process_kmem_event(evsel, sample);
+	perf_evsel__process_kmem_event(ectx);
 	return 0;
 }
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 585aae2..d3a1586 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -812,21 +812,18 @@ static void dump_info(void)
 		die("Unknown type of information\n");
 }
 
-static int process_sample_event(struct perf_tool *tool __used,
-				union perf_event *event,
-				struct perf_sample *sample,
-				struct perf_evsel *evsel,
-				struct machine *machine)
+static int process_sample_event(struct perf_event_context *ectx)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct perf_sample *sample = ectx->sample;
+	struct thread *thread = machine__findnew_thread(ectx->machine, sample->tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
-			event->header.type);
+			ectx->event->header.type);
 		return -1;
 	}
 
-	perf_evsel__process_lock_event(evsel, sample);
+	perf_evsel__process_lock_event(ectx->evsel, sample);
 	return 0;
 }
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 22dd05d..6cfe66e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -86,13 +86,10 @@ static void write_output(struct perf_record *rec, void *buf, size_t size)
 	}
 }
 
-static int process_synthesized_event(struct perf_tool *tool,
-				     union perf_event *event,
-				     struct perf_sample *sample __used,
-				     struct machine *machine __used)
+static int process_synthesized_event(struct perf_event_context *ectx)
 {
-	struct perf_record *rec = container_of(tool, struct perf_record, tool);
-	write_output(rec, event, event->header.size);
+	struct perf_record *rec = container_of(ectx->tool, struct perf_record, tool);
+	write_output(rec, ectx->event, ectx->event->header.size);
 	return 0;
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d618253..d00c4e9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -181,19 +181,16 @@ out:
 }
 
 
-static int process_sample_event(struct perf_tool *tool,
-				union perf_event *event,
-				struct perf_sample *sample,
-				struct perf_evsel *evsel,
-				struct machine *machine)
+static int process_sample_event(struct perf_event_context *ectx)
 {
-	struct perf_report *rep = container_of(tool, struct perf_report, tool);
+	struct perf_report *rep = container_of(ectx->tool, struct perf_report, tool);
+	struct perf_sample *sample = ectx->sample;
 	struct addr_location al;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
+	if (perf_event__preprocess_sample(ectx->event, ectx->machine, &al, sample,
 					  rep->annotate_init) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
-			event->header.type);
+			ectx->event->header.type);
 		return -1;
 	}
 
@@ -204,8 +201,8 @@ static int process_sample_event(struct perf_tool *tool,
 		return 0;
 
 	if (sort__branch_mode == 1) {
-		if (perf_report__add_branch_hist_entry(tool, &al, sample,
-						       evsel, machine)) {
+		if (perf_report__add_branch_hist_entry(ectx->tool, &al, sample,
+						       ectx->evsel, ectx->machine)) {
 			pr_debug("problem adding lbr entry, skipping event\n");
 			return -1;
 		}
@@ -213,7 +210,7 @@ static int process_sample_event(struct perf_tool *tool,
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
 
-		if (perf_evsel__add_hist_entry(evsel, &al, sample, machine)) {
+		if (perf_evsel__add_hist_entry(ectx->evsel, &al, sample, ectx->machine)) {
 			pr_debug("problem incrementing symbol period, skipping event\n");
 			return -1;
 		}
@@ -221,13 +218,11 @@ static int process_sample_event(struct perf_tool *tool,
 	return 0;
 }
 
-static int process_read_event(struct perf_tool *tool,
-			      union perf_event *event,
-			      struct perf_sample *sample __used,
-			      struct perf_evsel *evsel,
-			      struct machine *machine __used)
+static int process_read_event(struct perf_event_context *ectx)
 {
-	struct perf_report *rep = container_of(tool, struct perf_report, tool);
+	struct perf_report *rep = container_of(ectx->tool, struct perf_report, tool);
+	union perf_event *event = ectx->event;
+	struct perf_evsel *evsel = ectx->evsel;
 
 	if (rep->show_threads) {
 		const char *name = evsel ? perf_evsel__name(evsel) : "unknown";
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a25a023..418e0dc 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1552,13 +1552,11 @@ typedef void (*tracepoint_handler)(struct perf_tool *tool, struct event_format *
 				   struct machine *machine,
 				   struct thread *thread);
 
-static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __used,
-						 union perf_event *event __used,
-						 struct perf_sample *sample,
-						 struct perf_evsel *evsel,
-						 struct machine *machine)
+static int perf_sched__process_tracepoint_sample(struct perf_event_context *ectx)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->pid);
+	struct perf_sample *sample = ectx->sample;
+	struct perf_evsel *evsel = ectx->evsel;
+	struct thread *thread = machine__findnew_thread(ectx->machine, sample->pid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %s event, skipping it.\n",
@@ -1571,7 +1569,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __used,
 
 	if (evsel->handler.func != NULL) {
 		tracepoint_handler f = evsel->handler.func;
-		f(tool, evsel->tp_format, sample, machine, thread);
+		f(ectx->tool, evsel->tp_format, sample, ectx->machine, thread);
 	}
 
 	return 0;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 2d6e3b2..e1caa09 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -474,14 +474,13 @@ static int cleanup_scripting(void)
 
 static const char *input_name;
 
-static int process_sample_event(struct perf_tool *tool __used,
-				union perf_event *event,
-				struct perf_sample *sample,
-				struct perf_evsel *evsel,
-				struct machine *machine)
+static int process_sample_event(struct perf_event_context *ectx)
 {
-	struct addr_location al;
+	union perf_event *event = ectx->event;
+	struct perf_sample *sample = ectx->sample;
+	struct machine *machine = ectx->machine;
 	struct thread *thread = machine__findnew_thread(machine, event->ip.tid);
+	struct addr_location al;
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -512,9 +511,9 @@ static int process_sample_event(struct perf_tool *tool __used,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	scripting_ops->process_event(event, sample, evsel, machine, &al);
+	scripting_ops->process_event(event, sample, ectx->evsel, machine, &al);
 
-	evsel->hists.stats.total_period += sample->period;
+	ectx->evsel->hists.stats.total_period += ectx->sample->period;
 	return 0;
 }
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 3b75b2e..4b46d21 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -275,29 +275,23 @@ static int cpus_cstate_state[MAX_CPUS];
 static u64 cpus_pstate_start_times[MAX_CPUS];
 static u64 cpus_pstate_state[MAX_CPUS];
 
-static int process_comm_event(struct perf_tool *tool __used,
-			      union perf_event *event,
-			      struct perf_sample *sample __used,
-			      struct machine *machine __used)
+static int process_comm_event(struct perf_event_context *ectx)
 {
+	union perf_event *event = ectx->event;
 	pid_set_comm(event->comm.tid, event->comm.comm);
 	return 0;
 }
 
-static int process_fork_event(struct perf_tool *tool __used,
-			      union perf_event *event,
-			      struct perf_sample *sample __used,
-			      struct machine *machine __used)
+static int process_fork_event(struct perf_event_context *ectx)
 {
+	union perf_event *event = ectx->event;
 	pid_fork(event->fork.pid, event->fork.ppid, event->fork.time);
 	return 0;
 }
 
-static int process_exit_event(struct perf_tool *tool __used,
-			      union perf_event *event,
-			      struct perf_sample *sample __used,
-			      struct machine *machine __used)
+static int process_exit_event(struct perf_event_context *ectx)
 {
+	union perf_event *event = ectx->event;
 	pid_exit(event->fork.pid, event->fork.time);
 	return 0;
 }
@@ -491,13 +485,11 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 }
 
 
-static int process_sample_event(struct perf_tool *tool __used,
-				union perf_event *event __used,
-				struct perf_sample *sample,
-				struct perf_evsel *evsel,
-				struct machine *machine __used)
+static int process_sample_event(struct perf_event_context *ectx)
 {
 	struct trace_entry *te;
+	struct perf_sample *sample = ectx->sample;
+	struct perf_evsel *evsel = ectx->evsel;
 
 	if (evsel->attr.sample_type & PERF_SAMPLE_TIME) {
 		if (!first_time || first_time > sample->time)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e45a1ba..5ba0b5a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -869,8 +869,14 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			perf_event__process_sample(&top->tool, event, evsel,
 						   &sample, machine);
 		} else if (event->header.type < PERF_RECORD_MAX) {
+			struct perf_event_context ectx = {
+				.tool = &top->tool,
+				.event = event,
+				.sample = &sample,
+				.machine = machine,
+			};
 			hists__inc_nr_events(&evsel->hists, event->header.type);
-			perf_event__process(&top->tool, event, &sample, machine);
+			perf_event__process(&ectx);
 		} else
 			++session->hists.stats.nr_unknown_events;
 	}
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 9ce0e11..9dae3a3 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -16,15 +16,12 @@
 #include "session.h"
 #include "tool.h"
 
-int build_id__mark_dso_hit(struct perf_tool *tool __used,
-				  union perf_event *event,
-				  struct perf_sample *sample __used,
-				  struct perf_evsel *evsel __used,
-				  struct machine *machine)
+int build_id__mark_dso_hit(struct perf_event_context *ectx)
 {
 	struct addr_location al;
+	union perf_event *event = ectx->event;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(ectx->machine, event->ip.pid);
 
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
@@ -32,8 +29,8 @@ int build_id__mark_dso_hit(struct perf_tool *tool __used,
 		return -1;
 	}
 
-	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, &al);
+	thread__find_addr_map(thread, ectx->machine, cpumode, MAP__FUNCTION,
+			      ectx->event->ip.ip, &al);
 
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
@@ -41,11 +38,10 @@ int build_id__mark_dso_hit(struct perf_tool *tool __used,
 	return 0;
 }
 
-static int perf_event__exit_del_thread(struct perf_tool *tool __used,
-				       union perf_event *event,
-				       struct perf_sample *sample __used,
-				       struct machine *machine)
+static int perf_event__exit_del_thread(struct perf_event_context *ectx)
 {
+	union perf_event *event = ectx->event;
+	struct machine *machine = ectx->machine;
 	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
 
 	dump_printf("(%d:%d):(%d:%d)\n", event->fork.pid, event->fork.tid,
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 032a968..fe433f8 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -7,9 +7,7 @@ extern struct perf_tool build_id__mark_dso_hit_ops;
 
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
 
-int build_id__mark_dso_hit(struct perf_tool *tool __used,
-				  union perf_event *event,
-				  struct perf_sample *sample __used,
-				  struct perf_evsel *evsel __used,
-				  struct machine *machine);
+struct perf_event_context;
+int build_id__mark_dso_hit(struct perf_event_context *ectx);
+
 #endif
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3a0f1a5..032abfa 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -100,6 +100,12 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 	DIR *tasks;
 	struct dirent dirent, *next;
 	pid_t tgid;
+	struct perf_event_context ectx = {
+		.tool = tool,
+		.event = event,
+		.sample = &synth_sample,
+		.machine = machine,
+	};
 
 	memset(&event->comm, 0, sizeof(event->comm));
 
@@ -120,7 +126,7 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 	if (!full) {
 		event->comm.tid = pid;
 
-		process(tool, event, &synth_sample, machine);
+		process(&ectx);
 		goto out;
 	}
 
@@ -151,7 +157,7 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 
 		event->comm.tid = pid;
 
-		process(tool, event, &synth_sample, machine);
+		process(&ectx);
 	}
 
 	closedir(tasks);
@@ -165,6 +171,12 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 					      perf_event__handler_t process,
 					      struct machine *machine)
 {
+	struct perf_event_context ectx = {
+		.tool = tool,
+		.event = event,
+		.sample = &synth_sample,
+		.machine = machine,
+	};
 	char filename[PATH_MAX];
 	FILE *fp;
 
@@ -231,7 +243,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 			event->mmap.pid = tgid;
 			event->mmap.tid = pid;
 
-			process(tool, event, &synth_sample, machine);
+			process(&ectx);
 		}
 	}
 
@@ -247,6 +259,12 @@ int perf_event__synthesize_modules(struct perf_tool *tool,
 	struct map_groups *kmaps = &machine->kmaps;
 	union perf_event *event = zalloc((sizeof(event->mmap) +
 					  machine->id_hdr_size));
+	struct perf_event_context ectx = {
+		.tool = tool,
+		.event = event,
+		.sample = &synth_sample,
+		.machine = machine,
+	};
 	if (event == NULL) {
 		pr_debug("Not enough memory synthesizing mmap event "
 			 "for kernel modules\n");
@@ -284,7 +302,7 @@ int perf_event__synthesize_modules(struct perf_tool *tool,
 
 		memcpy(event->mmap.filename, pos->dso->long_name,
 		       pos->dso->long_name_len + 1);
-		process(tool, event, &synth_sample, machine);
+		process(&ectx);
 	}
 
 	free(event);
@@ -447,6 +465,12 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 	struct process_symbol_args args = { .name = symbol_name, };
 	union perf_event *event = zalloc((sizeof(event->mmap) +
 					  machine->id_hdr_size));
+	struct perf_event_context ectx = {
+		.tool = tool,
+		.event = event,
+		.sample = &synth_sample,
+		.machine = machine,
+	};
 	if (event == NULL) {
 		pr_debug("Not enough memory synthesizing mmap event "
 			 "for kernel modules\n");
@@ -486,7 +510,7 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 	event->mmap.len   = map->end - event->mmap.start;
 	event->mmap.pid   = machine->pid;
 
-	err = process(tool, event, &synth_sample, machine);
+	err = process(&ectx);
 	free(event);
 
 	return err;
@@ -497,12 +521,10 @@ size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp)
 	return fprintf(fp, ": %s:%d\n", event->comm.comm, event->comm.tid);
 }
 
-int perf_event__process_comm(struct perf_tool *tool __used,
-			     union perf_event *event,
-			     struct perf_sample *sample __used,
-			     struct machine *machine)
+int perf_event__process_comm(struct perf_event_context *ectx)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
+	union perf_event *event = ectx->event;
+	struct thread *thread = machine__findnew_thread(ectx->machine, event->comm.tid);
 
 	if (dump_trace)
 		perf_event__fprintf_comm(event, stdout);
@@ -515,11 +537,9 @@ int perf_event__process_comm(struct perf_tool *tool __used,
 	return 0;
 }
 
-int perf_event__process_lost(struct perf_tool *tool __used,
-			     union perf_event *event,
-			     struct perf_sample *sample __used,
-			     struct machine *machine __used)
+int perf_event__process_lost(struct perf_event_context *ectx)
 {
+	union perf_event *event = ectx->event;
 	dump_printf(": id:%" PRIu64 ": lost:%" PRIu64 "\n",
 		    event->lost.id, event->lost.lost);
 	return 0;
@@ -538,10 +558,10 @@ static void perf_event__set_kernel_mmap_len(union perf_event *event,
 		maps[MAP__FUNCTION]->end = ~0ULL;
 }
 
-static int perf_event__process_kernel_mmap(struct perf_tool *tool __used,
-					   union perf_event *event,
-					   struct machine *machine)
+static int perf_event__process_kernel_mmap(struct perf_event_context *ectx)
 {
+	struct machine *machine = ectx->machine;
+	union perf_event *event = ectx->event;
 	struct map *map;
 	char kmmap_prefix[PATH_MAX];
 	enum dso_kernel_type kernel_type;
@@ -638,11 +658,9 @@ size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 		       event->mmap.len, event->mmap.pgoff, event->mmap.filename);
 }
 
-int perf_event__process_mmap(struct perf_tool *tool,
-			     union perf_event *event,
-			     struct perf_sample *sample __used,
-			     struct machine *machine)
+int perf_event__process_mmap(struct perf_event_context *ectx)
 {
+	union perf_event *event = ectx->event;
 	struct thread *thread;
 	struct map *map;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
@@ -653,16 +671,16 @@ int perf_event__process_mmap(struct perf_tool *tool,
 
 	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
 	    cpumode == PERF_RECORD_MISC_KERNEL) {
-		ret = perf_event__process_kernel_mmap(tool, event, machine);
+		ret = perf_event__process_kernel_mmap(ectx);
 		if (ret < 0)
 			goto out_problem;
 		return 0;
 	}
 
-	thread = machine__findnew_thread(machine, event->mmap.pid);
+	thread = machine__findnew_thread(ectx->machine, event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
-	map = map__new(&machine->user_dsos, event->mmap.start,
+	map = map__new(&ectx->machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
 			event->mmap.pid, event->mmap.filename,
 			MAP__FUNCTION);
@@ -684,11 +702,10 @@ size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
 		       event->fork.ppid, event->fork.ptid);
 }
 
-int perf_event__process_task(struct perf_tool *tool __used,
-			     union perf_event *event,
-			     struct perf_sample *sample __used,
-			      struct machine *machine)
+int perf_event__process_task(struct perf_event_context *ectx)
 {
+	struct machine *machine = ectx->machine;
+	union perf_event *event = ectx->event;
 	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
 	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
 
@@ -732,22 +749,21 @@ size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 	return ret;
 }
 
-int perf_event__process(struct perf_tool *tool, union perf_event *event,
-			struct perf_sample *sample, struct machine *machine)
+int perf_event__process(struct perf_event_context *ectx)
 {
-	switch (event->header.type) {
+	switch (ectx->event->header.type) {
 	case PERF_RECORD_COMM:
-		perf_event__process_comm(tool, event, sample, machine);
+		perf_event__process_comm(ectx);
 		break;
 	case PERF_RECORD_MMAP:
-		perf_event__process_mmap(tool, event, sample, machine);
+		perf_event__process_mmap(ectx);
 		break;
 	case PERF_RECORD_FORK:
 	case PERF_RECORD_EXIT:
-		perf_event__process_task(tool, event, sample, machine);
+		perf_event__process_task(ectx);
 		break;
 	case PERF_RECORD_LOST:
-		perf_event__process_lost(tool, event, sample, machine);
+		perf_event__process_lost(ectx);
 	default:
 		break;
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 64383a7..d6ce964 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -158,11 +158,16 @@ void perf_event__print_totals(void);
 struct perf_tool;
 struct thread_map;
 
-typedef int (*perf_event__handler_t)(struct perf_tool *tool,
-				     union perf_event *event,
-				     struct perf_sample *sample,
-				     struct machine *machine);
+struct perf_event_context {
+	struct perf_tool *tool;
+	union perf_event *event;
+	struct perf_sample *sample;
+	struct perf_evsel *evsel;
+	struct machine *machine;
+};
+
 
+typedef int (*perf_event__handler_t)(struct perf_event_context *ectx);
 int perf_event__synthesize_thread_map(struct perf_tool *tool,
 				      struct thread_map *threads,
 				      perf_event__handler_t process,
@@ -179,26 +184,11 @@ int perf_event__synthesize_modules(struct perf_tool *tool,
 				   perf_event__handler_t process,
 				   struct machine *machine);
 
-int perf_event__process_comm(struct perf_tool *tool,
-			     union perf_event *event,
-			     struct perf_sample *sample,
-			     struct machine *machine);
-int perf_event__process_lost(struct perf_tool *tool,
-			     union perf_event *event,
-			     struct perf_sample *sample,
-			     struct machine *machine);
-int perf_event__process_mmap(struct perf_tool *tool,
-			     union perf_event *event,
-			     struct perf_sample *sample,
-			     struct machine *machine);
-int perf_event__process_task(struct perf_tool *tool,
-			     union perf_event *event,
-			     struct perf_sample *sample,
-			     struct machine *machine);
-int perf_event__process(struct perf_tool *tool,
-			union perf_event *event,
-			struct perf_sample *sample,
-			struct machine *machine);
+int perf_event__process_comm(struct perf_event_context *ectx);
+int perf_event__process_lost(struct perf_event_context *ectx);
+int perf_event__process_mmap(struct perf_event_context *ectx);
+int perf_event__process_task(struct perf_event_context *ectx);
+int perf_event__process(struct perf_event_context *ectx);
 
 struct addr_location;
 int perf_event__preprocess_sample(const union perf_event *self,
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7e7d34f..4a041cc 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2246,6 +2246,9 @@ int perf_event__synthesize_attr(struct perf_tool *tool,
 	union perf_event *ev;
 	size_t size;
 	int err;
+	struct perf_event_context ectx = {
+		.tool = tool,
+	};
 
 	size = sizeof(struct perf_event_attr);
 	size = ALIGN(size, sizeof(u64));
@@ -2257,13 +2260,14 @@ int perf_event__synthesize_attr(struct perf_tool *tool,
 	if (ev == NULL)
 		return -ENOMEM;
 
+	ectx.event = ev;
 	ev->attr.attr = *attr;
 	memcpy(ev->attr.id, id, ids * sizeof(u64));
 
 	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
 	ev->attr.header.size = size;
 
-	err = process(tool, ev, NULL, NULL);
+	err = process(&ectx);
 
 	free(ev);
 
@@ -2334,6 +2338,11 @@ int perf_event__synthesize_event_type(struct perf_tool *tool,
 	union perf_event ev;
 	size_t size = 0;
 	int err = 0;
+	struct perf_event_context ectx = {
+		.tool = tool,
+		.event = &ev,
+		.machine = machine,
+	};
 
 	memset(&ev, 0, sizeof(ev));
 
@@ -2347,7 +2356,7 @@ int perf_event__synthesize_event_type(struct perf_tool *tool,
 	ev.event_type.header.size = sizeof(ev.event_type) -
 		(sizeof(ev.event_type.event_type.name) - size);
 
-	err = process(tool, &ev, NULL, machine);
+	err = process(&ectx);
 
 	return err;
 }
@@ -2392,6 +2401,10 @@ int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
 	struct tracing_data *tdata;
 	ssize_t size = 0, aligned_size = 0, padding;
 	int err __used = 0;
+	struct perf_event_context ectx = {
+		.tool = tool,
+		.event = &ev,
+	};
 
 	/*
 	 * We are going to store the size of the data followed
@@ -2417,7 +2430,7 @@ int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
 	ev.tracing_data.header.size = sizeof(ev.tracing_data);
 	ev.tracing_data.size = aligned_size;
 
-	process(tool, &ev, NULL, NULL);
+	process(&ectx);
 
 	/*
 	 * The put function will copy all the tracing data
@@ -2467,6 +2480,11 @@ int perf_event__synthesize_build_id(struct perf_tool *tool,
 				    struct machine *machine)
 {
 	union perf_event ev;
+	struct perf_event_context ectx = {
+		.tool = tool,
+		.event = &ev,
+		.machine = machine,
+	};
 	size_t len;
 	int err = 0;
 
@@ -2484,7 +2502,7 @@ int perf_event__synthesize_build_id(struct perf_tool *tool,
 	ev.build_id.header.size = sizeof(ev.build_id) + len;
 	memcpy(&ev.build_id.filename, pos->long_name, pos->long_name_len);
 
-	err = process(tool, &ev, NULL, machine);
+	err = process(&ectx);
 
 	return err;
 }
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f7bb7ae..08333cd 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -18,6 +18,8 @@
 #include "perf_regs.h"
 #include "unwind.h"
 
+struct perf_event_context;
+
 static int perf_session__open(struct perf_session *self, bool force)
 {
 	struct stat input_stat;
@@ -408,20 +410,13 @@ static int process_event_synth_attr_stub(union perf_event *event __used,
 	return 0;
 }
 
-static int process_event_sample_stub(struct perf_tool *tool __used,
-				     union perf_event *event __used,
-				     struct perf_sample *sample __used,
-				     struct perf_evsel *evsel __used,
-				     struct machine *machine __used)
+static int process_event_sample_stub(struct perf_event_context *ectx __used)
 {
 	dump_printf(": unhandled!\n");
 	return 0;
 }
 
-static int process_event_stub(struct perf_tool *tool __used,
-			      union perf_event *event __used,
-			      struct perf_sample *sample __used,
-			      struct machine *machine __used)
+static int process_event_stub(struct perf_event_context *ectx __used)
 {
 	dump_printf(": unhandled!\n");
 	return 0;
@@ -1021,7 +1016,11 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      u64 file_offset)
 {
 	struct perf_evsel *evsel;
-	struct machine *machine;
+	struct perf_event_context ectx = {
+			.tool = tool,
+			.event = event,
+			.sample = sample,
+	};
 
 	dump_event(session, event, file_offset, sample);
 
@@ -1043,7 +1042,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 		hists__inc_nr_events(&evsel->hists, event->header.type);
 	}
 
-	machine = perf_session__find_machine_for_cpumode(session, event);
+	ectx.machine = perf_session__find_machine_for_cpumode(session, event);
+	ectx.evsel = evsel;
 
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
@@ -1052,29 +1052,29 @@ static int perf_session_deliver_event(struct perf_session *session,
 			++session->hists.stats.nr_unknown_id;
 			return 0;
 		}
-		if (machine == NULL) {
+		if (ectx.machine == NULL) {
 			++session->hists.stats.nr_unprocessable_samples;
 			return 0;
 		}
-		return tool->sample(tool, event, sample, evsel, machine);
+		return tool->sample(&ectx);
 	case PERF_RECORD_MMAP:
-		return tool->mmap(tool, event, sample, machine);
+		return tool->mmap(&ectx);
 	case PERF_RECORD_COMM:
-		return tool->comm(tool, event, sample, machine);
+		return tool->comm(&ectx);
 	case PERF_RECORD_FORK:
-		return tool->fork(tool, event, sample, machine);
+		return tool->fork(&ectx);
 	case PERF_RECORD_EXIT:
-		return tool->exit(tool, event, sample, machine);
+		return tool->exit(&ectx);
 	case PERF_RECORD_LOST:
 		if (tool->lost == perf_event__process_lost)
 			session->hists.stats.total_lost += event->lost.lost;
-		return tool->lost(tool, event, sample, machine);
+		return tool->lost(&ectx);
 	case PERF_RECORD_READ:
-		return tool->read(tool, event, sample, evsel, machine);
+		return tool->read(&ectx);
 	case PERF_RECORD_THROTTLE:
-		return tool->throttle(tool, event, sample, machine);
+		return tool->throttle(&ectx);
 	case PERF_RECORD_UNTHROTTLE:
-		return tool->unthrottle(tool, event, sample, machine);
+		return tool->unthrottle(&ectx);
 	default:
 		++session->hists.stats.nr_unknown_events;
 		return -1;
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index b0e1aad..46c6d6a 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -11,12 +11,7 @@ struct perf_sample;
 struct perf_tool;
 struct machine;
 
-typedef int (*event_sample)(struct perf_tool *tool, union perf_event *event,
-			    struct perf_sample *sample,
-			    struct perf_evsel *evsel, struct machine *machine);
-
-typedef int (*event_op)(struct perf_tool *tool, union perf_event *event,
-			struct perf_sample *sample, struct machine *machine);
+typedef int (*event_op)(struct perf_event_context *ectx);
 
 typedef int (*event_attr_op)(union perf_event *event,
 			     struct perf_evlist **pevlist);
@@ -29,9 +24,9 @@ typedef int (*event_op2)(struct perf_tool *tool, union perf_event *event,
 			 struct perf_session *session);
 
 struct perf_tool {
-	event_sample	sample,
-			read;
-	event_op	mmap,
+	event_op	sample,
+			read,
+			mmap,
 			comm,
 			fork,
 			exit,
-- 
1.7.1

