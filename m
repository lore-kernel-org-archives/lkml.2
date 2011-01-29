Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1A2WTn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 17:19:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35651 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab1A2WTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 17:19:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 6/7] perf tools: Kill event_t typedef, use 'union perf_event' instead
Date: Sat, 29 Jan 2011 20:19:18 -0200
Message-Id: <1296339559-20914-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296339559-20914-1-git-send-email-acme@infradead.org>
References: <1296339559-20914-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And move the event_t methods to the perf_event__ namespace too.

No code changes, just namespace consistency.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c  |   11 ++-
 tools/perf/builtin-diff.c      |   14 ++--
 tools/perf/builtin-inject.c    |   82 +++++++++--------
 tools/perf/builtin-kmem.c      |   10 +-
 tools/perf/builtin-lock.c      |    6 +-
 tools/perf/builtin-record.c    |   56 +++++++------
 tools/perf/builtin-report.c    |   30 ++++---
 tools/perf/builtin-sched.c     |   15 ++--
 tools/perf/builtin-script.c    |   17 ++--
 tools/perf/builtin-test.c      |    6 +-
 tools/perf/builtin-timechart.c |   11 ++-
 tools/perf/builtin-top.c       |   33 ++++----
 tools/perf/util/build-id.c     |   19 ++--
 tools/perf/util/callchain.c    |    3 +-
 tools/perf/util/callchain.h    |    4 +-
 tools/perf/util/debug.c        |    2 +-
 tools/perf/util/debug.h        |    2 +-
 tools/perf/util/event.c        |  187 +++++++++++++++++++++-------------------
 tools/perf/util/event.h        |   69 ++++++++-------
 tools/perf/util/evlist.c       |    6 +-
 tools/perf/util/evlist.h       |    4 +-
 tools/perf/util/evsel.c        |   10 +-
 tools/perf/util/header.c       |   83 +++++++++---------
 tools/perf/util/header.h       |   50 ++++++------
 tools/perf/util/hist.c         |    2 +-
 tools/perf/util/session.c      |  165 ++++++++++++++++++-----------------
 tools/perf/util/session.h      |   13 ++--
 27 files changed, 473 insertions(+), 437 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index ef36751..7006786 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -58,12 +58,13 @@ static int hists__add_entry(struct hists *self, struct addr_location *al)
 	return hist_entry__inc_addr_samples(he, al->addr);
 }
 
-static int process_sample_event(event_t *event, struct perf_sample *sample,
+static int process_sample_event(union perf_event *event,
+				struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct addr_location al;
 
-	if (event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
+	if (perf_event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
@@ -372,9 +373,9 @@ find_next:
 
 static struct perf_event_ops event_ops = {
 	.sample	= process_sample_event,
-	.mmap	= event__process_mmap,
-	.comm	= event__process_comm,
-	.fork	= event__process_task,
+	.mmap	= perf_event__process_mmap,
+	.comm	= perf_event__process_comm,
+	.fork	= perf_event__process_task,
 	.ordered_samples = true,
 	.ordering_requires_timestamps = true,
 };
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 0822149..6b7d911 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -30,13 +30,13 @@ static int hists__add_entry(struct hists *self,
 	return -ENOMEM;
 }
 
-static int diff__process_sample_event(event_t *event,
+static int diff__process_sample_event(union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_session *session)
 {
 	struct addr_location al;
 
-	if (event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
+	if (perf_event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
@@ -56,11 +56,11 @@ static int diff__process_sample_event(event_t *event,
 
 static struct perf_event_ops event_ops = {
 	.sample	= diff__process_sample_event,
-	.mmap	= event__process_mmap,
-	.comm	= event__process_comm,
-	.exit	= event__process_task,
-	.fork	= event__process_task,
-	.lost	= event__process_lost,
+	.mmap	= perf_event__process_mmap,
+	.comm	= perf_event__process_comm,
+	.exit	= perf_event__process_task,
+	.fork	= perf_event__process_task,
+	.lost	= perf_event__process_lost,
 	.ordered_samples = true,
 	.ordering_requires_timestamps = true,
 };
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 4c9388c..e29f04e 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -16,8 +16,8 @@
 static char		const *input_name = "-";
 static bool		inject_build_ids;
 
-static int event__repipe_synth(event_t *event,
-			       struct perf_session *session __used)
+static int perf_event__repipe_synth(union perf_event *event,
+				    struct perf_session *session __used)
 {
 	uint32_t size;
 	void *buf = event;
@@ -36,41 +36,44 @@ static int event__repipe_synth(event_t *event,
 	return 0;
 }
 
-static int event__repipe(event_t *event, struct perf_sample *sample __used,
-			 struct perf_session *session)
+static int perf_event__repipe(union perf_event *event,
+			      struct perf_sample *sample __used,
+			      struct perf_session *session)
 {
-	return event__repipe_synth(event, session);
+	return perf_event__repipe_synth(event, session);
 }
 
-static int event__repipe_mmap(event_t *self, struct perf_sample *sample,
-			      struct perf_session *session)
+static int perf_event__repipe_mmap(union perf_event *event,
+				   struct perf_sample *sample,
+				   struct perf_session *session)
 {
 	int err;
 
-	err = event__process_mmap(self, sample, session);
-	event__repipe(self, sample, session);
+	err = perf_event__process_mmap(event, sample, session);
+	perf_event__repipe(event, sample, session);
 
 	return err;
 }
 
-static int event__repipe_task(event_t *self, struct perf_sample *sample,
-			      struct perf_session *session)
+static int perf_event__repipe_task(union perf_event *event,
+				   struct perf_sample *sample,
+				   struct perf_session *session)
 {
 	int err;
 
-	err = event__process_task(self, sample, session);
-	event__repipe(self, sample, session);
+	err = perf_event__process_task(event, sample, session);
+	perf_event__repipe(event, sample, session);
 
 	return err;
 }
 
-static int event__repipe_tracing_data(event_t *self,
-				      struct perf_session *session)
+static int perf_event__repipe_tracing_data(union perf_event *event,
+					   struct perf_session *session)
 {
 	int err;
 
-	event__repipe_synth(self, session);
-	err = event__process_tracing_data(self, session);
+	perf_event__repipe_synth(event, session);
+	err = perf_event__process_tracing_data(event, session);
 
 	return err;
 }
@@ -109,8 +112,8 @@ static int dso__inject_build_id(struct dso *self, struct perf_session *session)
 	if (self->kernel)
 		misc = PERF_RECORD_MISC_KERNEL;
 
-	err = event__synthesize_build_id(self, misc, event__repipe,
-					 machine, session);
+	err = perf_event__synthesize_build_id(self, misc, perf_event__repipe,
+					      machine, session);
 	if (err) {
 		pr_err("Can't synthesize build_id event for %s\n", self->long_name);
 		return -1;
@@ -119,8 +122,9 @@ static int dso__inject_build_id(struct dso *self, struct perf_session *session)
 	return 0;
 }
 
-static int event__inject_buildid(event_t *event, struct perf_sample *sample,
-				 struct perf_session *session)
+static int perf_event__inject_buildid(union perf_event *event,
+				      struct perf_sample *sample,
+				      struct perf_session *session)
 {
 	struct addr_location al;
 	struct thread *thread;
@@ -155,24 +159,24 @@ static int event__inject_buildid(event_t *event, struct perf_sample *sample,
 	}
 
 repipe:
-	event__repipe(event, sample, session);
+	perf_event__repipe(event, sample, session);
 	return 0;
 }
 
 struct perf_event_ops inject_ops = {
-	.sample		= event__repipe,
-	.mmap		= event__repipe,
-	.comm		= event__repipe,
-	.fork		= event__repipe,
-	.exit		= event__repipe,
-	.lost		= event__repipe,
-	.read		= event__repipe,
-	.throttle	= event__repipe,
-	.unthrottle	= event__repipe,
-	.attr		= event__repipe_synth,
-	.event_type 	= event__repipe_synth,
-	.tracing_data 	= event__repipe_synth,
-	.build_id 	= event__repipe_synth,
+	.sample		= perf_event__repipe,
+	.mmap		= perf_event__repipe,
+	.comm		= perf_event__repipe,
+	.fork		= perf_event__repipe,
+	.exit		= perf_event__repipe,
+	.lost		= perf_event__repipe,
+	.read		= perf_event__repipe,
+	.throttle	= perf_event__repipe,
+	.unthrottle	= perf_event__repipe,
+	.attr		= perf_event__repipe_synth,
+	.event_type 	= perf_event__repipe_synth,
+	.tracing_data 	= perf_event__repipe_synth,
+	.build_id 	= perf_event__repipe_synth,
 };
 
 extern volatile int session_done;
@@ -190,10 +194,10 @@ static int __cmd_inject(void)
 	signal(SIGINT, sig_handler);
 
 	if (inject_build_ids) {
-		inject_ops.sample	= event__inject_buildid;
-		inject_ops.mmap		= event__repipe_mmap;
-		inject_ops.fork		= event__repipe_task;
-		inject_ops.tracing_data	= event__repipe_tracing_data;
+		inject_ops.sample	= perf_event__inject_buildid;
+		inject_ops.mmap		= perf_event__repipe_mmap;
+		inject_ops.fork		= perf_event__repipe_task;
+		inject_ops.tracing_data	= perf_event__repipe_tracing_data;
 	}
 
 	session = perf_session__new(input_name, O_RDONLY, false, true, &inject_ops);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 3c1cdcf..7f618f4 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -275,9 +275,8 @@ static void process_free_event(void *data,
 	s_alloc->alloc_cpu = -1;
 }
 
-static void
-process_raw_event(event_t *raw_event __used, void *data,
-		  int cpu, u64 timestamp, struct thread *thread)
+static void process_raw_event(union perf_event *raw_event __used, void *data,
+			      int cpu, u64 timestamp, struct thread *thread)
 {
 	struct event *event;
 	int type;
@@ -304,7 +303,8 @@ process_raw_event(event_t *raw_event __used, void *data,
 	}
 }
 
-static int process_sample_event(event_t *event, struct perf_sample *sample,
+static int process_sample_event(union perf_event *event,
+				struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, event->ip.pid);
@@ -325,7 +325,7 @@ static int process_sample_event(event_t *event, struct perf_sample *sample,
 
 static struct perf_event_ops event_ops = {
 	.sample			= process_sample_event,
-	.comm			= event__process_comm,
+	.comm			= perf_event__process_comm,
 	.ordered_samples	= true,
 };
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index c3f5127..e00d938 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -834,14 +834,14 @@ static void dump_info(void)
 		die("Unknown type of information\n");
 }
 
-static int process_sample_event(event_t *self, struct perf_sample *sample,
+static int process_sample_event(union perf_event *event, struct perf_sample *sample,
 				struct perf_session *s)
 {
 	struct thread *thread = perf_session__findnew(s, sample->tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
-			self->header.type);
+			event->header.type);
 		return -1;
 	}
 
@@ -852,7 +852,7 @@ static int process_sample_event(event_t *self, struct perf_sample *sample,
 
 static struct perf_event_ops eops = {
 	.sample			= process_sample_event,
-	.comm			= event__process_comm,
+	.comm			= perf_event__process_comm,
 	.ordered_samples	= true,
 };
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5d3e4b3..edc3555 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -100,7 +100,7 @@ static void write_output(void *buf, size_t size)
 	}
 }
 
-static int process_synthesized_event(event_t *event,
+static int process_synthesized_event(union perf_event *event,
 				     struct perf_sample *sample __used,
 				     struct perf_session *self __used)
 {
@@ -404,7 +404,7 @@ static void atexit_header(void)
 	}
 }
 
-static void event__synthesize_guest_os(struct machine *machine, void *data)
+static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 {
 	int err;
 	struct perf_session *psession = data;
@@ -420,8 +420,8 @@ static void event__synthesize_guest_os(struct machine *machine, void *data)
 	 *method is used to avoid symbol missing when the first addr is
 	 *in module instead of in guest kernel.
 	 */
-	err = event__synthesize_modules(process_synthesized_event,
-					psession, machine);
+	err = perf_event__synthesize_modules(process_synthesized_event,
+					     psession, machine);
 	if (err < 0)
 		pr_err("Couldn't record guest kernel [%d]'s reference"
 		       " relocation symbol.\n", machine->pid);
@@ -430,11 +430,12 @@ static void event__synthesize_guest_os(struct machine *machine, void *data)
 	 * We use _stext for guest kernel because guest kernel's /proc/kallsyms
 	 * have no _text sometimes.
 	 */
-	err = event__synthesize_kernel_mmap(process_synthesized_event,
-					    psession, machine, "_text");
+	err = perf_event__synthesize_kernel_mmap(process_synthesized_event,
+						 psession, machine, "_text");
 	if (err < 0)
-		err = event__synthesize_kernel_mmap(process_synthesized_event,
-						    psession, machine, "_stext");
+		err = perf_event__synthesize_kernel_mmap(process_synthesized_event,
+							 psession, machine,
+							 "_stext");
 	if (err < 0)
 		pr_err("Couldn't record guest kernel [%d]'s reference"
 		       " relocation symbol.\n", machine->pid);
@@ -617,16 +618,16 @@ static int __cmd_record(int argc, const char **argv)
 	perf_session__set_sample_id_all(session, sample_id_all_avail);
 
 	if (pipe_output) {
-		err = event__synthesize_attrs(&session->header,
-					      process_synthesized_event,
-					      session);
+		err = perf_event__synthesize_attrs(&session->header,
+						   process_synthesized_event,
+						   session);
 		if (err < 0) {
 			pr_err("Couldn't synthesize attrs.\n");
 			return err;
 		}
 
-		err = event__synthesize_event_types(process_synthesized_event,
-						    session);
+		err = perf_event__synthesize_event_types(process_synthesized_event,
+							 session);
 		if (err < 0) {
 			pr_err("Couldn't synthesize event_types.\n");
 			return err;
@@ -641,9 +642,9 @@ static int __cmd_record(int argc, const char **argv)
 			 * return this more properly and also
 			 * propagate errors that now are calling die()
 			 */
-			err = event__synthesize_tracing_data(output, evsel_list,
-							     process_synthesized_event,
-							     session);
+			err = perf_event__synthesize_tracing_data(output, evsel_list,
+								  process_synthesized_event,
+								  session);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
 				return err;
@@ -658,31 +659,34 @@ static int __cmd_record(int argc, const char **argv)
 		return -1;
 	}
 
-	err = event__synthesize_kernel_mmap(process_synthesized_event,
-					    session, machine, "_text");
+	err = perf_event__synthesize_kernel_mmap(process_synthesized_event,
+						 session, machine, "_text");
 	if (err < 0)
-		err = event__synthesize_kernel_mmap(process_synthesized_event,
-						    session, machine, "_stext");
+		err = perf_event__synthesize_kernel_mmap(process_synthesized_event,
+							 session, machine, "_stext");
 	if (err < 0)
 		pr_err("Couldn't record kernel reference relocation symbol\n"
 		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
 		       "Check /proc/kallsyms permission or run as root.\n");
 
-	err = event__synthesize_modules(process_synthesized_event,
-					session, machine);
+	err = perf_event__synthesize_modules(process_synthesized_event,
+					     session, machine);
 	if (err < 0)
 		pr_err("Couldn't record kernel module information.\n"
 		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
 		       "Check /proc/modules permission or run as root.\n");
 
 	if (perf_guest)
-		perf_session__process_machines(session, event__synthesize_guest_os);
+		perf_session__process_machines(session,
+					       perf_event__synthesize_guest_os);
 
 	if (!system_wide)
-		event__synthesize_thread(target_tid, process_synthesized_event,
-					 session);
+		perf_event__synthesize_thread(target_tid,
+					      process_synthesized_event,
+					      session);
 	else
-		event__synthesize_threads(process_synthesized_event, session);
+		perf_event__synthesize_threads(process_synthesized_event,
+					       session);
 
 	if (realtime_prio) {
 		struct sched_param param;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bbbadcc..a6a4e54 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -149,13 +149,14 @@ static int add_event_total(struct perf_session *session,
 	return 0;
 }
 
-static int process_sample_event(event_t *event, struct perf_sample *sample,
+static int process_sample_event(union perf_event *event,
+				struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct addr_location al;
 	struct perf_event_attr *attr;
 
-	if (event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
+	if (perf_event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
@@ -179,7 +180,8 @@ static int process_sample_event(event_t *event, struct perf_sample *sample,
 	return 0;
 }
 
-static int process_read_event(event_t *event, struct perf_sample *sample __used,
+static int process_read_event(union perf_event *event,
+			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
 	struct perf_event_attr *attr;
@@ -232,17 +234,17 @@ static int perf_session__setup_sample_type(struct perf_session *self)
 }
 
 static struct perf_event_ops event_ops = {
-	.sample	= process_sample_event,
-	.mmap	= event__process_mmap,
-	.comm	= event__process_comm,
-	.exit	= event__process_task,
-	.fork	= event__process_task,
-	.lost	= event__process_lost,
-	.read	= process_read_event,
-	.attr	= event__process_attr,
-	.event_type = event__process_event_type,
-	.tracing_data = event__process_tracing_data,
-	.build_id = event__process_build_id,
+	.sample		 = process_sample_event,
+	.mmap		 = perf_event__process_mmap,
+	.comm		 = perf_event__process_comm,
+	.exit		 = perf_event__process_task,
+	.fork		 = perf_event__process_task,
+	.lost		 = perf_event__process_lost,
+	.read		 = process_read_event,
+	.attr		 = perf_event__process_attr,
+	.event_type	 = perf_event__process_event_type,
+	.tracing_data	 = perf_event__process_tracing_data,
+	.build_id	 = perf_event__process_build_id,
 	.ordered_samples = true,
 	.ordering_requires_timestamps = true,
 };
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index ff993c8..ae26211 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1580,9 +1580,9 @@ process_sched_migrate_task_event(void *data, struct perf_session *session,
 						 event, cpu, timestamp, thread);
 }
 
-static void
-process_raw_event(event_t *raw_event __used, struct perf_session *session,
-		  void *data, int cpu, u64 timestamp, struct thread *thread)
+static void process_raw_event(union perf_event *raw_event __used,
+			      struct perf_session *session, void *data, int cpu,
+			      u64 timestamp, struct thread *thread)
 {
 	struct event *event;
 	int type;
@@ -1607,7 +1607,8 @@ process_raw_event(event_t *raw_event __used, struct perf_session *session,
 		process_sched_migrate_task_event(data, session, event, cpu, timestamp, thread);
 }
 
-static int process_sample_event(event_t *event, struct perf_sample *sample,
+static int process_sample_event(union perf_event *event,
+				struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct thread *thread;
@@ -1635,9 +1636,9 @@ static int process_sample_event(event_t *event, struct perf_sample *sample,
 
 static struct perf_event_ops event_ops = {
 	.sample			= process_sample_event,
-	.comm			= event__process_comm,
-	.lost			= event__process_lost,
-	.fork			= event__process_task,
+	.comm			= perf_event__process_comm,
+	.lost			= perf_event__process_lost,
+	.fork			= perf_event__process_task,
 	.ordered_samples	= true,
 };
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 5c4c809..5f40df6 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -63,7 +63,8 @@ static int cleanup_scripting(void)
 
 static char const		*input_name = "perf.data";
 
-static int process_sample_event(event_t *event, struct perf_sample *sample,
+static int process_sample_event(union perf_event *event,
+				struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, event->ip.pid);
@@ -100,14 +101,14 @@ static int process_sample_event(event_t *event, struct perf_sample *sample,
 }
 
 static struct perf_event_ops event_ops = {
-	.sample	= process_sample_event,
-	.comm	= event__process_comm,
-	.attr	= event__process_attr,
-	.event_type = event__process_event_type,
-	.tracing_data = event__process_tracing_data,
-	.build_id = event__process_build_id,
-	.ordering_requires_timestamps = true,
+	.sample		 = process_sample_event,
+	.comm		 = perf_event__process_comm,
+	.attr		 = perf_event__process_attr,
+	.event_type	 = perf_event__process_event_type,
+	.tracing_data	 = perf_event__process_tracing_data,
+	.build_id	 = perf_event__process_build_id,
 	.ordered_samples = true,
+	.ordering_requires_timestamps = true,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index df62433..845b9bd 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -454,7 +454,7 @@ out_thread_map_delete:
 static int test__basic_mmap(void)
 {
 	int err = -1;
-	event_t *event;
+	union perf_event *event;
 	struct thread_map *threads;
 	struct cpu_map *cpus;
 	struct perf_evlist *evlist;
@@ -554,11 +554,11 @@ static int test__basic_mmap(void)
 
 		if (event->header.type != PERF_RECORD_SAMPLE) {
 			pr_debug("unexpected %s event\n",
-				 event__get_event_name(event->header.type));
+				 perf_event__name(event->header.type));
 			goto out_munmap;
 		}
 
-		event__parse_sample(event, attr.sample_type, false, &sample);
+		perf_event__parse_sample(event, attr.sample_type, false, &sample);
 		evsel = perf_evlist__id2evsel(evlist, sample.id);
 		if (evsel == NULL) {
 			pr_debug("event with id %" PRIu64
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 01cf0c3..0801275 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -276,21 +276,24 @@ static int cpus_cstate_state[MAX_CPUS];
 static u64 cpus_pstate_start_times[MAX_CPUS];
 static u64 cpus_pstate_state[MAX_CPUS];
 
-static int process_comm_event(event_t *event, struct perf_sample *sample __used,
+static int process_comm_event(union perf_event *event,
+			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
 	pid_set_comm(event->comm.tid, event->comm.comm);
 	return 0;
 }
 
-static int process_fork_event(event_t *event, struct perf_sample *sample __used,
+static int process_fork_event(union perf_event *event,
+			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
 	pid_fork(event->fork.pid, event->fork.ppid, event->fork.time);
 	return 0;
 }
 
-static int process_exit_event(event_t *event, struct perf_sample *sample __used,
+static int process_exit_event(union perf_event *event,
+			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
 	pid_exit(event->fork.pid, event->fork.time);
@@ -486,7 +489,7 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 }
 
 
-static int process_sample_event(event_t *event __used,
+static int process_sample_event(union perf_event *event __used,
 				struct perf_sample *sample,
 				struct perf_session *session)
 {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d923127..2f4d1f2 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -401,7 +401,7 @@ static void show_details(struct sym_entry *syme)
 }
 
 /*
- * Symbols will be added here in event__process_sample and will get out
+ * Symbols will be added here in perf_event__process_sample and will get out
  * after decayed.
  */
 static LIST_HEAD(active_symbols);
@@ -996,15 +996,15 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 	return 0;
 }
 
-static void event__process_sample(const event_t *self,
-				  struct perf_sample *sample,
-				  struct perf_session *session)
+static void perf_event__process_sample(const union perf_event *event,
+				       struct perf_sample *sample,
+				       struct perf_session *session)
 {
-	u64 ip = self->ip.ip;
+	u64 ip = event->ip.ip;
 	struct sym_entry *syme;
 	struct addr_location al;
 	struct machine *machine;
-	u8 origin = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	u8 origin = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 	++samples;
 
@@ -1023,7 +1023,7 @@ static void event__process_sample(const event_t *self,
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
 		++guest_kernel_samples;
-		machine = perf_session__find_machine(session, self->ip.pid);
+		machine = perf_session__find_machine(session, event->ip.pid);
 		break;
 	case PERF_RECORD_MISC_GUEST_USER:
 		++guest_us_samples;
@@ -1038,15 +1038,15 @@ static void event__process_sample(const event_t *self,
 
 	if (!machine && perf_guest) {
 		pr_err("Can't find guest [%d]'s kernel information\n",
-			self->ip.pid);
+			event->ip.pid);
 		return;
 	}
 
-	if (self->header.misc & PERF_RECORD_MISC_EXACT_IP)
+	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		exact_samples++;
 
-	if (event__preprocess_sample(self, session, &al, sample,
-				     symbol_filter) < 0 ||
+	if (perf_event__preprocess_sample(event, session, &al, sample,
+					  symbol_filter) < 0 ||
 	    al.filtered)
 		return;
 
@@ -1108,15 +1108,15 @@ static void event__process_sample(const event_t *self,
 static void perf_session__mmap_read_cpu(struct perf_session *self, int cpu)
 {
 	struct perf_sample sample;
-	event_t *event;
+	union perf_event *event;
 
 	while ((event = perf_evlist__read_on_cpu(evsel_list, cpu)) != NULL) {
 		perf_session__parse_sample(self, event, &sample);
 
 		if (event->header.type == PERF_RECORD_SAMPLE)
-			event__process_sample(event, &sample, self);
+			perf_event__process_sample(event, &sample, self);
 		else
-			event__process(event, &sample, self);
+			perf_event__process(event, &sample, self);
 	}
 }
 
@@ -1199,9 +1199,10 @@ static int __cmd_top(void)
 		return -ENOMEM;
 
 	if (target_tid != -1)
-		event__synthesize_thread(target_tid, event__process, session);
+		perf_event__synthesize_thread(target_tid, perf_event__process,
+					      session);
 	else
-		event__synthesize_threads(event__process, session);
+		perf_event__synthesize_threads(perf_event__process, session);
 
 	start_counters(evsel_list);
 	first = list_entry(evsel_list->entries.next, struct perf_evsel, node);
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index b184a7f..31f934a 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -14,7 +14,7 @@
 #include <linux/kernel.h>
 #include "debug.h"
 
-static int build_id__mark_dso_hit(event_t *event,
+static int build_id__mark_dso_hit(union perf_event *event,
 				  struct perf_sample *sample __used,
 				  struct perf_session *session)
 {
@@ -37,13 +37,14 @@ static int build_id__mark_dso_hit(event_t *event,
 	return 0;
 }
 
-static int event__exit_del_thread(event_t *self, struct perf_sample *sample __used,
-				  struct perf_session *session)
+static int perf_event__exit_del_thread(union perf_event *event,
+				       struct perf_sample *sample __used,
+				       struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, self->fork.tid);
+	struct thread *thread = perf_session__findnew(session, event->fork.tid);
 
-	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
-		    self->fork.ppid, self->fork.ptid);
+	dump_printf("(%d:%d):(%d:%d)\n", event->fork.pid, event->fork.tid,
+		    event->fork.ppid, event->fork.ptid);
 
 	if (thread) {
 		rb_erase(&thread->rb_node, &session->threads);
@@ -56,9 +57,9 @@ static int event__exit_del_thread(event_t *self, struct perf_sample *sample __us
 
 struct perf_event_ops build_id__mark_dso_hit_ops = {
 	.sample	= build_id__mark_dso_hit,
-	.mmap	= event__process_mmap,
-	.fork	= event__process_task,
-	.exit	= event__exit_del_thread,
+	.mmap	= perf_event__process_mmap,
+	.fork	= perf_event__process_task,
+	.exit	= perf_event__exit_del_thread,
 };
 
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index f8c66d1..9f7106a 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -18,7 +18,8 @@
 #include "util.h"
 #include "callchain.h"
 
-bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event)
+bool ip_callchain__valid(struct ip_callchain *chain,
+			 const union perf_event *event)
 {
 	unsigned int chain_size = event->header.size;
 	chain_size -= (unsigned long)&event->ip.__more_data - (unsigned long)event;
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 6713725..1a79df9 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -95,8 +95,8 @@ int callchain_append(struct callchain_root *root,
 int callchain_merge(struct callchain_cursor *cursor,
 		    struct callchain_root *dst, struct callchain_root *src);
 
-bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event);
-
+bool ip_callchain__valid(struct ip_callchain *chain,
+			 const union perf_event *event);
 /*
  * Initialize a cursor before adding entries inside, but keep
  * the previously allocated entries as a cache.
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 01bbe8e..d4536a9 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -57,7 +57,7 @@ void ui__warning(const char *format, ...)
 }
 #endif
 
-void trace_event(event_t *event)
+void trace_event(union perf_event *event)
 {
 	unsigned char *raw_event = (void *)event;
 	const char *color = PERF_COLOR_BLUE;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index ca35fd6..93516cf 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -9,7 +9,7 @@ extern int verbose;
 extern bool quiet, dump_trace;
 
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
-void trace_event(event_t *event);
+void trace_event(union perf_event *event);
 
 struct ui_progress;
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 5c886fb..731265f 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -7,7 +7,7 @@
 #include "strlist.h"
 #include "thread.h"
 
-static const char *event__name[] = {
+static const char *perf_event__names[] = {
 	[0]			 = "TOTAL",
 	[PERF_RECORD_MMAP]	 = "MMAP",
 	[PERF_RECORD_LOST]	 = "LOST",
@@ -25,13 +25,13 @@ static const char *event__name[] = {
 	[PERF_RECORD_FINISHED_ROUND]	 = "FINISHED_ROUND",
 };
 
-const char *event__get_event_name(unsigned int id)
+const char *perf_event__name(unsigned int id)
 {
-	if (id >= ARRAY_SIZE(event__name))
+	if (id >= ARRAY_SIZE(perf_event__names))
 		return "INVALID";
-	if (!event__name[id])
+	if (!perf_event__names[id])
 		return "UNKNOWN";
-	return event__name[id];
+	return perf_event__names[id];
 }
 
 static struct perf_sample synth_sample = {
@@ -43,9 +43,9 @@ static struct perf_sample synth_sample = {
 	.period	   = 1,
 };
 
-static pid_t event__synthesize_comm(event_t *event, pid_t pid, int full,
-				    event__handler_t process,
-				    struct perf_session *session)
+static pid_t perf_event__synthesize_comm(union perf_event *event, pid_t pid,
+					 int full, perf_event__handler_t process,
+					 struct perf_session *session)
 {
 	char filename[PATH_MAX];
 	char bf[BUFSIZ];
@@ -126,9 +126,10 @@ out:
 	return tgid;
 }
 
-static int event__synthesize_mmap_events(event_t *event, pid_t pid, pid_t tgid,
-					 event__handler_t process,
-					 struct perf_session *session)
+static int perf_event__synthesize_mmap_events(union perf_event *event,
+					      pid_t pid, pid_t tgid,
+					      perf_event__handler_t process,
+					      struct perf_session *session)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
@@ -199,14 +200,14 @@ static int event__synthesize_mmap_events(event_t *event, pid_t pid, pid_t tgid,
 	return 0;
 }
 
-int event__synthesize_modules(event__handler_t process,
-			      struct perf_session *session,
-			      struct machine *machine)
+int perf_event__synthesize_modules(perf_event__handler_t process,
+				   struct perf_session *session,
+				   struct machine *machine)
 {
 	struct rb_node *nd;
 	struct map_groups *kmaps = &machine->kmaps;
-	event_t *event = zalloc(sizeof(event->mmap) + session->id_hdr_size);
-
+	union perf_event *event = zalloc((sizeof(event->mmap) +
+					  session->id_hdr_size));
 	if (event == NULL) {
 		pr_debug("Not enough memory synthesizing mmap event "
 			 "for kernel modules\n");
@@ -251,22 +252,23 @@ int event__synthesize_modules(event__handler_t process,
 	return 0;
 }
 
-static int __event__synthesize_thread(event_t *comm_event, event_t *mmap_event,
-				      pid_t pid, event__handler_t process,
+static int __event__synthesize_thread(union perf_event *comm_event,
+				      union perf_event *mmap_event,
+				      pid_t pid, perf_event__handler_t process,
 				      struct perf_session *session)
 {
-	pid_t tgid = event__synthesize_comm(comm_event, pid, 1, process,
+	pid_t tgid = perf_event__synthesize_comm(comm_event, pid, 1, process,
 					    session);
 	if (tgid == -1)
 		return -1;
-	return event__synthesize_mmap_events(mmap_event, pid, tgid,
+	return perf_event__synthesize_mmap_events(mmap_event, pid, tgid,
 					     process, session);
 }
 
-int event__synthesize_thread(pid_t pid, event__handler_t process,
-			     struct perf_session *session)
+int perf_event__synthesize_thread(pid_t pid, perf_event__handler_t process,
+				  struct perf_session *session)
 {
-	event_t *comm_event, *mmap_event;
+	union perf_event *comm_event, *mmap_event;
 	int err = -1;
 
 	comm_event = malloc(sizeof(comm_event->comm) + session->id_hdr_size);
@@ -286,12 +288,12 @@ out:
 	return err;
 }
 
-int event__synthesize_threads(event__handler_t process,
-			      struct perf_session *session)
+int perf_event__synthesize_threads(perf_event__handler_t process,
+				   struct perf_session *session)
 {
 	DIR *proc;
 	struct dirent dirent, *next;
-	event_t *comm_event, *mmap_event;
+	union perf_event *comm_event, *mmap_event;
 	int err = -1;
 
 	comm_event = malloc(sizeof(comm_event->comm) + session->id_hdr_size);
@@ -349,10 +351,10 @@ static int find_symbol_cb(void *arg, const char *name, char type,
 	return 1;
 }
 
-int event__synthesize_kernel_mmap(event__handler_t process,
-				  struct perf_session *session,
-				  struct machine *machine,
-				  const char *symbol_name)
+int perf_event__synthesize_kernel_mmap(perf_event__handler_t process,
+				       struct perf_session *session,
+				       struct machine *machine,
+				       const char *symbol_name)
 {
 	size_t size;
 	const char *filename, *mmap_name;
@@ -366,8 +368,8 @@ int event__synthesize_kernel_mmap(event__handler_t process,
 	 * kernels.
 	 */
 	struct process_symbol_args args = { .name = symbol_name, };
-	event_t *event = zalloc(sizeof(event->mmap) + session->id_hdr_size);
-
+	union perf_event *event = zalloc((sizeof(event->mmap) +
+					  session->id_hdr_size));
 	if (event == NULL) {
 		pr_debug("Not enough memory synthesizing mmap event "
 			 "for kernel modules\n");
@@ -440,14 +442,15 @@ static int thread__set_comm_adjust(struct thread *self, const char *comm,
 	return 0;
 }
 
-int event__process_comm(event_t *self, struct perf_sample *sample __used,
-			struct perf_session *session)
+int perf_event__process_comm(union perf_event *event,
+			     struct perf_sample *sample __used,
+			     struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, self->comm.tid);
+	struct thread *thread = perf_session__findnew(session, event->comm.tid);
 
-	dump_printf(": %s:%d\n", self->comm.comm, self->comm.tid);
+	dump_printf(": %s:%d\n", event->comm.comm, event->comm.tid);
 
-	if (thread == NULL || thread__set_comm_adjust(thread, self->comm.comm,
+	if (thread == NULL || thread__set_comm_adjust(thread, event->comm.comm,
 						      &session->hists)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
 		return -1;
@@ -456,19 +459,21 @@ int event__process_comm(event_t *self, struct perf_sample *sample __used,
 	return 0;
 }
 
-int event__process_lost(event_t *self, struct perf_sample *sample __used,
-			struct perf_session *session)
+int perf_event__process_lost(union perf_event *event,
+			     struct perf_sample *sample __used,
+			     struct perf_session *session)
 {
 	dump_printf(": id:%" PRIu64 ": lost:%" PRIu64 "\n",
-		    self->lost.id, self->lost.lost);
-	session->hists.stats.total_lost += self->lost.lost;
+		    event->lost.id, event->lost.lost);
+	session->hists.stats.total_lost += event->lost.lost;
 	return 0;
 }
 
-static void event_set_kernel_mmap_len(struct map **maps, event_t *self)
+static void perf_event__set_kernel_mmap_len(union perf_event *event,
+					    struct map **maps)
 {
-	maps[MAP__FUNCTION]->start = self->mmap.start;
-	maps[MAP__FUNCTION]->end   = self->mmap.start + self->mmap.len;
+	maps[MAP__FUNCTION]->start = event->mmap.start;
+	maps[MAP__FUNCTION]->end   = event->mmap.start + event->mmap.len;
 	/*
 	 * Be a bit paranoid here, some perf.data file came with
 	 * a zero sized synthesized MMAP event for the kernel.
@@ -477,8 +482,8 @@ static void event_set_kernel_mmap_len(struct map **maps, event_t *self)
 		maps[MAP__FUNCTION]->end = ~0ULL;
 }
 
-static int event__process_kernel_mmap(event_t *self,
-			struct perf_session *session)
+static int perf_event__process_kernel_mmap(union perf_event *event,
+					   struct perf_session *session)
 {
 	struct map *map;
 	char kmmap_prefix[PATH_MAX];
@@ -486,9 +491,9 @@ static int event__process_kernel_mmap(event_t *self,
 	enum dso_kernel_type kernel_type;
 	bool is_kernel_mmap;
 
-	machine = perf_session__findnew_machine(session, self->mmap.pid);
+	machine = perf_session__findnew_machine(session, event->mmap.pid);
 	if (!machine) {
-		pr_err("Can't find id %d's machine\n", self->mmap.pid);
+		pr_err("Can't find id %d's machine\n", event->mmap.pid);
 		goto out_problem;
 	}
 
@@ -498,17 +503,17 @@ static int event__process_kernel_mmap(event_t *self,
 	else
 		kernel_type = DSO_TYPE_GUEST_KERNEL;
 
-	is_kernel_mmap = memcmp(self->mmap.filename,
+	is_kernel_mmap = memcmp(event->mmap.filename,
 				kmmap_prefix,
 				strlen(kmmap_prefix)) == 0;
-	if (self->mmap.filename[0] == '/' ||
-	    (!is_kernel_mmap && self->mmap.filename[0] == '[')) {
+	if (event->mmap.filename[0] == '/' ||
+	    (!is_kernel_mmap && event->mmap.filename[0] == '[')) {
 
 		char short_module_name[1024];
 		char *name, *dot;
 
-		if (self->mmap.filename[0] == '/') {
-			name = strrchr(self->mmap.filename, '/');
+		if (event->mmap.filename[0] == '/') {
+			name = strrchr(event->mmap.filename, '/');
 			if (name == NULL)
 				goto out_problem;
 
@@ -520,10 +525,10 @@ static int event__process_kernel_mmap(event_t *self,
 					"[%.*s]", (int)(dot - name), name);
 			strxfrchar(short_module_name, '-', '_');
 		} else
-			strcpy(short_module_name, self->mmap.filename);
+			strcpy(short_module_name, event->mmap.filename);
 
-		map = machine__new_module(machine, self->mmap.start,
-					  self->mmap.filename);
+		map = machine__new_module(machine, event->mmap.start,
+					  event->mmap.filename);
 		if (map == NULL)
 			goto out_problem;
 
@@ -533,9 +538,9 @@ static int event__process_kernel_mmap(event_t *self,
 
 		map->dso->short_name = name;
 		map->dso->sname_alloc = 1;
-		map->end = map->start + self->mmap.len;
+		map->end = map->start + event->mmap.len;
 	} else if (is_kernel_mmap) {
-		const char *symbol_name = (self->mmap.filename +
+		const char *symbol_name = (event->mmap.filename +
 				strlen(kmmap_prefix));
 		/*
 		 * Should be there already, from the build-id table in
@@ -550,10 +555,10 @@ static int event__process_kernel_mmap(event_t *self,
 		if (__machine__create_kernel_maps(machine, kernel) < 0)
 			goto out_problem;
 
-		event_set_kernel_mmap_len(machine->vmlinux_maps, self);
+		perf_event__set_kernel_mmap_len(event, machine->vmlinux_maps);
 		perf_session__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps,
 							 symbol_name,
-							 self->mmap.pgoff);
+							 event->mmap.pgoff);
 		if (machine__is_default_guest(machine)) {
 			/*
 			 * preload dso of guest kernel and modules
@@ -567,22 +572,23 @@ out_problem:
 	return -1;
 }
 
-int event__process_mmap(event_t *self, struct perf_sample *sample __used,
-			struct perf_session *session)
+int perf_event__process_mmap(union perf_event *event,
+			     struct perf_sample *sample __used,
+			     struct perf_session *session)
 {
 	struct machine *machine;
 	struct thread *thread;
 	struct map *map;
-	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	int ret = 0;
 
 	dump_printf(" %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64 "]: %s\n",
-			self->mmap.pid, self->mmap.tid, self->mmap.start,
-			self->mmap.len, self->mmap.pgoff, self->mmap.filename);
+			event->mmap.pid, event->mmap.tid, event->mmap.start,
+			event->mmap.len, event->mmap.pgoff, event->mmap.filename);
 
 	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
 	    cpumode == PERF_RECORD_MISC_KERNEL) {
-		ret = event__process_kernel_mmap(self, session);
+		ret = perf_event__process_kernel_mmap(event, session);
 		if (ret < 0)
 			goto out_problem;
 		return 0;
@@ -591,12 +597,12 @@ int event__process_mmap(event_t *self, struct perf_sample *sample __used,
 	machine = perf_session__find_host_machine(session);
 	if (machine == NULL)
 		goto out_problem;
-	thread = perf_session__findnew(session, self->mmap.pid);
+	thread = perf_session__findnew(session, event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
-	map = map__new(&machine->user_dsos, self->mmap.start,
-			self->mmap.len, self->mmap.pgoff,
-			self->mmap.pid, self->mmap.filename,
+	map = map__new(&machine->user_dsos, event->mmap.start,
+			event->mmap.len, event->mmap.pgoff,
+			event->mmap.pid, event->mmap.filename,
 			MAP__FUNCTION);
 	if (map == NULL)
 		goto out_problem;
@@ -609,16 +615,17 @@ out_problem:
 	return 0;
 }
 
-int event__process_task(event_t *self, struct perf_sample *sample __used,
-			struct perf_session *session)
+int perf_event__process_task(union perf_event *event,
+			     struct perf_sample *sample __used,
+			     struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, self->fork.tid);
-	struct thread *parent = perf_session__findnew(session, self->fork.ptid);
+	struct thread *thread = perf_session__findnew(session, event->fork.tid);
+	struct thread *parent = perf_session__findnew(session, event->fork.ptid);
 
-	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
-		    self->fork.ppid, self->fork.ptid);
+	dump_printf("(%d:%d):(%d:%d)\n", event->fork.pid, event->fork.tid,
+		    event->fork.ppid, event->fork.ptid);
 
-	if (self->header.type == PERF_RECORD_EXIT) {
+	if (event->header.type == PERF_RECORD_EXIT) {
 		perf_session__remove_thread(session, thread);
 		return 0;
 	}
@@ -632,22 +639,22 @@ int event__process_task(event_t *self, struct perf_sample *sample __used,
 	return 0;
 }
 
-int event__process(event_t *event, struct perf_sample *sample,
-		   struct perf_session *session)
+int perf_event__process(union perf_event *event, struct perf_sample *sample,
+			struct perf_session *session)
 {
 	switch (event->header.type) {
 	case PERF_RECORD_COMM:
-		event__process_comm(event, sample, session);
+		perf_event__process_comm(event, sample, session);
 		break;
 	case PERF_RECORD_MMAP:
-		event__process_mmap(event, sample, session);
+		perf_event__process_mmap(event, sample, session);
 		break;
 	case PERF_RECORD_FORK:
 	case PERF_RECORD_EXIT:
-		event__process_task(event, sample, session);
+		perf_event__process_task(event, sample, session);
 		break;
 	case PERF_RECORD_LOST:
-		event__process_lost(event, sample, session);
+		perf_event__process_lost(event, sample, session);
 	default:
 		break;
 	}
@@ -756,12 +763,14 @@ static void dso__calc_col_width(struct dso *self, struct hists *hists)
 	self->slen_calculated = 1;
 }
 
-int event__preprocess_sample(const event_t *self, struct perf_session *session,
-			     struct addr_location *al, struct perf_sample *sample,
-			     symbol_filter_t filter)
+int perf_event__preprocess_sample(const union perf_event *event,
+				  struct perf_session *session,
+				  struct addr_location *al,
+				  struct perf_sample *sample,
+				  symbol_filter_t filter)
 {
-	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = perf_session__findnew(session, self->ip.pid);
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct thread *thread = perf_session__findnew(session, event->ip.pid);
 
 	if (thread == NULL)
 		return -1;
@@ -783,7 +792,7 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 		machine__create_kernel_maps(&session->host_machine);
 
 	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
-			      self->ip.pid, self->ip.ip, al);
+			      event->ip.pid, event->ip.ip, al);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 84fd71f..eecb422 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -117,7 +117,7 @@ struct tracing_data_event {
 	u32 size;
 };
 
-typedef union event_union {
+union perf_event {
 	struct perf_event_header	header;
 	struct ip_event			ip;
 	struct mmap_event		mmap;
@@ -130,49 +130,52 @@ typedef union event_union {
 	struct event_type_event		event_type;
 	struct tracing_data_event	tracing_data;
 	struct build_id_event		build_id;
-} event_t;
+};
 
-void event__print_totals(void);
+void perf_event__print_totals(void);
 
 struct perf_session;
 
-typedef int (*event__handler_synth_t)(event_t *event, 
+typedef int (*perf_event__handler_synth_t)(union perf_event *event, 
+					   struct perf_session *session);
+typedef int (*perf_event__handler_t)(union perf_event *event,
+				     struct perf_sample *sample,
 				      struct perf_session *session);
-typedef int (*event__handler_t)(event_t *event, struct perf_sample *sample,
-				struct perf_session *session);
 
-int event__synthesize_thread(pid_t pid, event__handler_t process,
+int perf_event__synthesize_thread(pid_t pid, perf_event__handler_t process,
+				  struct perf_session *session);
+int perf_event__synthesize_threads(perf_event__handler_t process,
+				   struct perf_session *session);
+int perf_event__synthesize_kernel_mmap(perf_event__handler_t process,
+				       struct perf_session *session,
+				       struct machine *machine,
+				       const char *symbol_name);
+
+int perf_event__synthesize_modules(perf_event__handler_t process,
+				   struct perf_session *session,
+				   struct machine *machine);
+
+int perf_event__process_comm(union perf_event *event, struct perf_sample *sample,
 			     struct perf_session *session);
-int event__synthesize_threads(event__handler_t process,
-			      struct perf_session *session);
-int event__synthesize_kernel_mmap(event__handler_t process,
-				struct perf_session *session,
-				struct machine *machine,
-				const char *symbol_name);
-
-int event__synthesize_modules(event__handler_t process,
-			      struct perf_session *session,
-			      struct machine *machine);
-
-int event__process_comm(event_t *event, struct perf_sample *sample,
-			struct perf_session *session);
-int event__process_lost(event_t *event, struct perf_sample *sample,
-			struct perf_session *session);
-int event__process_mmap(event_t *event, struct perf_sample *sample,
-			struct perf_session *session);
-int event__process_task(event_t *event, struct perf_sample *sample,
+int perf_event__process_lost(union perf_event *event, struct perf_sample *sample,
+			     struct perf_session *session);
+int perf_event__process_mmap(union perf_event *event, struct perf_sample *sample,
+			     struct perf_session *session);
+int perf_event__process_task(union perf_event *event, struct perf_sample *sample,
+			     struct perf_session *session);
+int perf_event__process(union perf_event *event, struct perf_sample *sample,
 			struct perf_session *session);
-int event__process(event_t *event, struct perf_sample *sample,
-		   struct perf_session *session);
 
 struct addr_location;
-int event__preprocess_sample(const event_t *self, struct perf_session *session,
-			     struct addr_location *al, struct perf_sample *sample,
-			     symbol_filter_t filter);
+int perf_event__preprocess_sample(const union perf_event *self,
+				  struct perf_session *session,
+				  struct addr_location *al,
+				  struct perf_sample *sample,
+				  symbol_filter_t filter);
 
-const char *event__get_event_name(unsigned int id);
+const char *perf_event__name(unsigned int id);
 
-int event__parse_sample(const event_t *event, u64 type, bool sample_id_all,
-			struct perf_sample *sample);
+int perf_event__parse_sample(const union perf_event *event, u64 type,
+			     bool sample_id_all, struct perf_sample *sample);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b498eec..917fc18 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -107,7 +107,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	return NULL;
 }
 
-event_t *perf_evlist__read_on_cpu(struct perf_evlist *evlist, int cpu)
+union perf_event *perf_evlist__read_on_cpu(struct perf_evlist *evlist, int cpu)
 {
 	/* XXX Move this to perf.c, making it generally available */
 	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
@@ -115,7 +115,7 @@ event_t *perf_evlist__read_on_cpu(struct perf_evlist *evlist, int cpu)
 	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
-	event_t *event = NULL;
+	union perf_event *event = NULL;
 
 	if (evlist->overwrite) {
 		/*
@@ -140,7 +140,7 @@ event_t *perf_evlist__read_on_cpu(struct perf_evlist *evlist, int cpu)
 	if (old != head) {
 		size_t size;
 
-		event = (event_t *)&data[old & md->mask];
+		event = (union perf_event *)&data[old & md->mask];
 		size = event->header.size;
 
 		/*
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 2706ae4..022ae40 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -17,7 +17,7 @@ struct perf_evlist {
 	int		 nr_fds;
 	int		 mmap_len;
 	bool		 overwrite;
-	event_t		 event_copy;
+	union perf_event event_copy;
 	struct perf_mmap *mmap;
 	struct pollfd	 *pollfd;
 };
@@ -37,6 +37,6 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
-event_t *perf_evlist__read_on_cpu(struct perf_evlist *self, int cpu);
+union perf_event *perf_evlist__read_on_cpu(struct perf_evlist *self, int cpu);
 
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a134885..fddeb08 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -367,8 +367,8 @@ out_unmap:
 	return -1;
 }
 
-static int event__parse_id_sample(const event_t *event, u64 type,
-				  struct perf_sample *sample)
+static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
+				       struct perf_sample *sample)
 {
 	const u64 *array = event->sample.array;
 
@@ -405,8 +405,8 @@ static int event__parse_id_sample(const event_t *event, u64 type,
 	return 0;
 }
 
-int event__parse_sample(const event_t *event, u64 type, bool sample_id_all,
-			struct perf_sample *data)
+int perf_event__parse_sample(const union perf_event *event, u64 type,
+			     bool sample_id_all, struct perf_sample *data)
 {
 	const u64 *array;
 
@@ -416,7 +416,7 @@ int event__parse_sample(const event_t *event, u64 type, bool sample_id_all,
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!sample_id_all)
 			return 0;
-		return event__parse_id_sample(event, type, data);
+		return perf_event__parse_id_sample(event, type, data);
 	}
 
 	array = event->sample.array;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f0138d4..c0de5ec 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1000,11 +1000,11 @@ perf_header__find_attr(u64 id, struct perf_header *header)
 	return NULL;
 }
 
-int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
-			   event__handler_t process,
-			   struct perf_session *session)
+int perf_event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
+				perf_event__handler_t process,
+				struct perf_session *session)
 {
-	event_t *ev;
+	union perf_event *ev;
 	size_t size;
 	int err;
 
@@ -1031,8 +1031,9 @@ int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
 	return err;
 }
 
-int event__synthesize_attrs(struct perf_header *self, event__handler_t process,
-			    struct perf_session *session)
+int perf_event__synthesize_attrs(struct perf_header *self,
+				 perf_event__handler_t process,
+				 struct perf_session *session)
 {
 	struct perf_header_attr	*attr;
 	int i, err = 0;
@@ -1040,8 +1041,8 @@ int event__synthesize_attrs(struct perf_header *self, event__handler_t process,
 	for (i = 0; i < self->attrs; i++) {
 		attr = self->attr[i];
 
-		err = event__synthesize_attr(&attr->attr, attr->ids, attr->id,
-					     process, session);
+		err = perf_event__synthesize_attr(&attr->attr, attr->ids,
+						  attr->id, process, session);
 		if (err) {
 			pr_debug("failed to create perf header attribute\n");
 			return err;
@@ -1051,21 +1052,22 @@ int event__synthesize_attrs(struct perf_header *self, event__handler_t process,
 	return err;
 }
 
-int event__process_attr(event_t *self, struct perf_session *session)
+int perf_event__process_attr(union perf_event *event,
+			     struct perf_session *session)
 {
 	struct perf_header_attr *attr;
 	unsigned int i, ids, n_ids;
 
-	attr = perf_header_attr__new(&self->attr.attr);
+	attr = perf_header_attr__new(&event->attr.attr);
 	if (attr == NULL)
 		return -ENOMEM;
 
-	ids = self->header.size;
-	ids -= (void *)&self->attr.id - (void *)self;
+	ids = event->header.size;
+	ids -= (void *)&event->attr.id - (void *)event;
 	n_ids = ids / sizeof(u64);
 
 	for (i = 0; i < n_ids; i++) {
-		if (perf_header_attr__add_id(attr, self->attr.id[i]) < 0) {
+		if (perf_header_attr__add_id(attr, event->attr.id[i]) < 0) {
 			perf_header_attr__delete(attr);
 			return -ENOMEM;
 		}
@@ -1081,11 +1083,11 @@ int event__process_attr(event_t *self, struct perf_session *session)
 	return 0;
 }
 
-int event__synthesize_event_type(u64 event_id, char *name,
-				 event__handler_t process,
-				 struct perf_session *session)
+int perf_event__synthesize_event_type(u64 event_id, char *name,
+				      perf_event__handler_t process,
+				      struct perf_session *session)
 {
-	event_t ev;
+	union perf_event ev;
 	size_t size = 0;
 	int err = 0;
 
@@ -1106,8 +1108,8 @@ int event__synthesize_event_type(u64 event_id, char *name,
 	return err;
 }
 
-int event__synthesize_event_types(event__handler_t process,
-				  struct perf_session *session)
+int perf_event__synthesize_event_types(perf_event__handler_t process,
+				       struct perf_session *session)
 {
 	struct perf_trace_event_type *type;
 	int i, err = 0;
@@ -1115,8 +1117,9 @@ int event__synthesize_event_types(event__handler_t process,
 	for (i = 0; i < event_count; i++) {
 		type = &events[i];
 
-		err = event__synthesize_event_type(type->event_id, type->name,
-						   process, session);
+		err = perf_event__synthesize_event_type(type->event_id,
+							type->name, process,
+							session);
 		if (err) {
 			pr_debug("failed to create perf header event type\n");
 			return err;
@@ -1126,21 +1129,21 @@ int event__synthesize_event_types(event__handler_t process,
 	return err;
 }
 
-int event__process_event_type(event_t *self,
-			      struct perf_session *session __unused)
+int perf_event__process_event_type(union perf_event *event,
+				   struct perf_session *session __unused)
 {
-	if (perf_header__push_event(self->event_type.event_type.event_id,
-				    self->event_type.event_type.name) < 0)
+	if (perf_header__push_event(event->event_type.event_type.event_id,
+				    event->event_type.event_type.name) < 0)
 		return -ENOMEM;
 
 	return 0;
 }
 
-int event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
-				   event__handler_t process,
+int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
+					 perf_event__handler_t process,
 				   struct perf_session *session __unused)
 {
-	event_t ev;
+	union perf_event ev;
 	ssize_t size = 0, aligned_size = 0, padding;
 	int err = 0;
 
@@ -1163,10 +1166,10 @@ int event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 	return aligned_size;
 }
 
-int event__process_tracing_data(event_t *self,
-				struct perf_session *session)
+int perf_event__process_tracing_data(union perf_event *event,
+				     struct perf_session *session)
 {
-	ssize_t size_read, padding, size = self->tracing_data.size;
+	ssize_t size_read, padding, size = event->tracing_data.size;
 	off_t offset = lseek(session->fd, 0, SEEK_CUR);
 	char buf[BUFSIZ];
 
@@ -1192,12 +1195,12 @@ int event__process_tracing_data(event_t *self,
 	return size_read + padding;
 }
 
-int event__synthesize_build_id(struct dso *pos, u16 misc,
-			       event__handler_t process,
-			       struct machine *machine,
-			       struct perf_session *session)
+int perf_event__synthesize_build_id(struct dso *pos, u16 misc,
+				    perf_event__handler_t process,
+				    struct machine *machine,
+				    struct perf_session *session)
 {
-	event_t ev;
+	union perf_event ev;
 	size_t len;
 	int err = 0;
 
@@ -1220,11 +1223,11 @@ int event__synthesize_build_id(struct dso *pos, u16 misc,
 	return err;
 }
 
-int event__process_build_id(event_t *self,
-			    struct perf_session *session)
+int perf_event__process_build_id(union perf_event *event,
+				 struct perf_session *session)
 {
-	__event_process_build_id(&self->build_id,
-				 self->build_id.filename,
+	__event_process_build_id(&event->build_id,
+				 event->build_id.filename,
 				 session);
 	return 0;
 }
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 65afd7f..f042ceb 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -100,32 +100,32 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms);
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 
-int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
-			   event__handler_t process,
-			   struct perf_session *session);
-int event__synthesize_attrs(struct perf_header *self,
-			    event__handler_t process,
-			    struct perf_session *session);
-int event__process_attr(event_t *self, struct perf_session *session);
-
-int event__synthesize_event_type(u64 event_id, char *name,
-				 event__handler_t process,
+int perf_event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
+				perf_event__handler_t process,
+				struct perf_session *session);
+int perf_event__synthesize_attrs(struct perf_header *self,
+				 perf_event__handler_t process,
 				 struct perf_session *session);
-int event__synthesize_event_types(event__handler_t process,
-				  struct perf_session *session);
-int event__process_event_type(event_t *self,
-			      struct perf_session *session);
-
-int event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
-				   event__handler_t process,
+int perf_event__process_attr(union perf_event *event, struct perf_session *session);
+
+int perf_event__synthesize_event_type(u64 event_id, char *name,
+				      perf_event__handler_t process,
+				      struct perf_session *session);
+int perf_event__synthesize_event_types(perf_event__handler_t process,
+				       struct perf_session *session);
+int perf_event__process_event_type(union perf_event *event,
 				   struct perf_session *session);
-int event__process_tracing_data(event_t *self,
-				struct perf_session *session);
-
-int event__synthesize_build_id(struct dso *pos, u16 misc,
-			       event__handler_t process,
-			       struct machine *machine,
-			       struct perf_session *session);
-int event__process_build_id(event_t *self, struct perf_session *session);
 
+int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
+					perf_event__handler_t process,
+					struct perf_session *session);
+int perf_event__process_tracing_data(union perf_event *event,
+				     struct perf_session *session);
+
+int perf_event__synthesize_build_id(struct dso *pos, u16 misc,
+				    perf_event__handler_t process,
+				    struct machine *machine,
+				    struct perf_session *session);
+int perf_event__process_build_id(union perf_event *event,
+				 struct perf_session *session);
 #endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 02ed318..9588780 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1182,7 +1182,7 @@ size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
 	size_t ret = 0;
 
 	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
-		const char *name = event__get_event_name(i);
+		const char *name = perf_event__name(i);
 
 		if (!strcmp(name, "UNKNOWN"))
 			continue;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ee0b611..a3a871f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -165,7 +165,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	} else if (mode == O_WRONLY) {
 		/*
 		 * In O_RDONLY mode this will be performed when reading the
-		 * kernel MMAP event, in event__process_mmap().
+		 * kernel MMAP event, in perf_event__process_mmap().
 		 */
 		if (perf_session__create_kernel_maps(self) < 0)
 			goto out_delete;
@@ -291,14 +291,14 @@ int perf_session__resolve_callchain(struct perf_session *self,
 	return 0;
 }
 
-static int process_event_synth_stub(event_t *event __used,
+static int process_event_synth_stub(union perf_event *event __used,
 				    struct perf_session *session __used)
 {
 	dump_printf(": unhandled!\n");
 	return 0;
 }
 
-static int process_event_stub(event_t *event __used,
+static int process_event_stub(union perf_event *event __used,
 			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
@@ -306,7 +306,7 @@ static int process_event_stub(event_t *event __used,
 	return 0;
 }
 
-static int process_finished_round_stub(event_t *event __used,
+static int process_finished_round_stub(union perf_event *event __used,
 				       struct perf_session *session __used,
 				       struct perf_event_ops *ops __used)
 {
@@ -314,7 +314,7 @@ static int process_finished_round_stub(event_t *event __used,
 	return 0;
 }
 
-static int process_finished_round(event_t *event,
+static int process_finished_round(union perf_event *event,
 				  struct perf_session *session,
 				  struct perf_event_ops *ops);
 
@@ -331,7 +331,7 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 	if (handler->exit == NULL)
 		handler->exit = process_event_stub;
 	if (handler->lost == NULL)
-		handler->lost = event__process_lost;
+		handler->lost = perf_event__process_lost;
 	if (handler->read == NULL)
 		handler->read = process_event_stub;
 	if (handler->throttle == NULL)
@@ -365,98 +365,98 @@ void mem_bswap_64(void *src, int byte_size)
 	}
 }
 
-static void event__all64_swap(event_t *self)
+static void perf_event__all64_swap(union perf_event *event)
 {
-	struct perf_event_header *hdr = &self->header;
-	mem_bswap_64(hdr + 1, self->header.size - sizeof(*hdr));
+	struct perf_event_header *hdr = &event->header;
+	mem_bswap_64(hdr + 1, event->header.size - sizeof(*hdr));
 }
 
-static void event__comm_swap(event_t *self)
+static void perf_event__comm_swap(union perf_event *event)
 {
-	self->comm.pid = bswap_32(self->comm.pid);
-	self->comm.tid = bswap_32(self->comm.tid);
+	event->comm.pid = bswap_32(event->comm.pid);
+	event->comm.tid = bswap_32(event->comm.tid);
 }
 
-static void event__mmap_swap(event_t *self)
+static void perf_event__mmap_swap(union perf_event *event)
 {
-	self->mmap.pid	 = bswap_32(self->mmap.pid);
-	self->mmap.tid	 = bswap_32(self->mmap.tid);
-	self->mmap.start = bswap_64(self->mmap.start);
-	self->mmap.len	 = bswap_64(self->mmap.len);
-	self->mmap.pgoff = bswap_64(self->mmap.pgoff);
+	event->mmap.pid	  = bswap_32(event->mmap.pid);
+	event->mmap.tid	  = bswap_32(event->mmap.tid);
+	event->mmap.start = bswap_64(event->mmap.start);
+	event->mmap.len	  = bswap_64(event->mmap.len);
+	event->mmap.pgoff = bswap_64(event->mmap.pgoff);
 }
 
-static void event__task_swap(event_t *self)
+static void perf_event__task_swap(union perf_event *event)
 {
-	self->fork.pid	= bswap_32(self->fork.pid);
-	self->fork.tid	= bswap_32(self->fork.tid);
-	self->fork.ppid	= bswap_32(self->fork.ppid);
-	self->fork.ptid	= bswap_32(self->fork.ptid);
-	self->fork.time	= bswap_64(self->fork.time);
+	event->fork.pid	 = bswap_32(event->fork.pid);
+	event->fork.tid	 = bswap_32(event->fork.tid);
+	event->fork.ppid = bswap_32(event->fork.ppid);
+	event->fork.ptid = bswap_32(event->fork.ptid);
+	event->fork.time = bswap_64(event->fork.time);
 }
 
-static void event__read_swap(event_t *self)
+static void perf_event__read_swap(union perf_event *event)
 {
-	self->read.pid		= bswap_32(self->read.pid);
-	self->read.tid		= bswap_32(self->read.tid);
-	self->read.value	= bswap_64(self->read.value);
-	self->read.time_enabled	= bswap_64(self->read.time_enabled);
-	self->read.time_running	= bswap_64(self->read.time_running);
-	self->read.id		= bswap_64(self->read.id);
+	event->read.pid		 = bswap_32(event->read.pid);
+	event->read.tid		 = bswap_32(event->read.tid);
+	event->read.value	 = bswap_64(event->read.value);
+	event->read.time_enabled = bswap_64(event->read.time_enabled);
+	event->read.time_running = bswap_64(event->read.time_running);
+	event->read.id		 = bswap_64(event->read.id);
 }
 
-static void event__attr_swap(event_t *self)
+static void perf_event__attr_swap(union perf_event *event)
 {
 	size_t size;
 
-	self->attr.attr.type		= bswap_32(self->attr.attr.type);
-	self->attr.attr.size		= bswap_32(self->attr.attr.size);
-	self->attr.attr.config		= bswap_64(self->attr.attr.config);
-	self->attr.attr.sample_period	= bswap_64(self->attr.attr.sample_period);
-	self->attr.attr.sample_type	= bswap_64(self->attr.attr.sample_type);
-	self->attr.attr.read_format	= bswap_64(self->attr.attr.read_format);
-	self->attr.attr.wakeup_events	= bswap_32(self->attr.attr.wakeup_events);
-	self->attr.attr.bp_type		= bswap_32(self->attr.attr.bp_type);
-	self->attr.attr.bp_addr		= bswap_64(self->attr.attr.bp_addr);
-	self->attr.attr.bp_len		= bswap_64(self->attr.attr.bp_len);
-
-	size = self->header.size;
-	size -= (void *)&self->attr.id - (void *)self;
-	mem_bswap_64(self->attr.id, size);
+	event->attr.attr.type		= bswap_32(event->attr.attr.type);
+	event->attr.attr.size		= bswap_32(event->attr.attr.size);
+	event->attr.attr.config		= bswap_64(event->attr.attr.config);
+	event->attr.attr.sample_period	= bswap_64(event->attr.attr.sample_period);
+	event->attr.attr.sample_type	= bswap_64(event->attr.attr.sample_type);
+	event->attr.attr.read_format	= bswap_64(event->attr.attr.read_format);
+	event->attr.attr.wakeup_events	= bswap_32(event->attr.attr.wakeup_events);
+	event->attr.attr.bp_type	= bswap_32(event->attr.attr.bp_type);
+	event->attr.attr.bp_addr	= bswap_64(event->attr.attr.bp_addr);
+	event->attr.attr.bp_len		= bswap_64(event->attr.attr.bp_len);
+
+	size = event->header.size;
+	size -= (void *)&event->attr.id - (void *)event;
+	mem_bswap_64(event->attr.id, size);
 }
 
-static void event__event_type_swap(event_t *self)
+static void perf_event__event_type_swap(union perf_event *event)
 {
-	self->event_type.event_type.event_id =
-		bswap_64(self->event_type.event_type.event_id);
+	event->event_type.event_type.event_id =
+		bswap_64(event->event_type.event_type.event_id);
 }
 
-static void event__tracing_data_swap(event_t *self)
+static void perf_event__tracing_data_swap(union perf_event *event)
 {
-	self->tracing_data.size = bswap_32(self->tracing_data.size);
+	event->tracing_data.size = bswap_32(event->tracing_data.size);
 }
 
-typedef void (*event__swap_op)(event_t *self);
-
-static event__swap_op event__swap_ops[] = {
-	[PERF_RECORD_MMAP]   = event__mmap_swap,
-	[PERF_RECORD_COMM]   = event__comm_swap,
-	[PERF_RECORD_FORK]   = event__task_swap,
-	[PERF_RECORD_EXIT]   = event__task_swap,
-	[PERF_RECORD_LOST]   = event__all64_swap,
-	[PERF_RECORD_READ]   = event__read_swap,
-	[PERF_RECORD_SAMPLE] = event__all64_swap,
-	[PERF_RECORD_HEADER_ATTR]   = event__attr_swap,
-	[PERF_RECORD_HEADER_EVENT_TYPE]   = event__event_type_swap,
-	[PERF_RECORD_HEADER_TRACING_DATA]   = event__tracing_data_swap,
-	[PERF_RECORD_HEADER_BUILD_ID]   = NULL,
-	[PERF_RECORD_HEADER_MAX]    = NULL,
+typedef void (*perf_event__swap_op)(union perf_event *event);
+
+static perf_event__swap_op perf_event__swap_ops[] = {
+	[PERF_RECORD_MMAP]		  = perf_event__mmap_swap,
+	[PERF_RECORD_COMM]		  = perf_event__comm_swap,
+	[PERF_RECORD_FORK]		  = perf_event__task_swap,
+	[PERF_RECORD_EXIT]		  = perf_event__task_swap,
+	[PERF_RECORD_LOST]		  = perf_event__all64_swap,
+	[PERF_RECORD_READ]		  = perf_event__read_swap,
+	[PERF_RECORD_SAMPLE]		  = perf_event__all64_swap,
+	[PERF_RECORD_HEADER_ATTR]	  = perf_event__attr_swap,
+	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
+	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
+	[PERF_RECORD_HEADER_BUILD_ID]	  = NULL,
+	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
 struct sample_queue {
 	u64			timestamp;
 	u64			file_offset;
-	event_t			*event;
+	union perf_event	*event;
 	struct list_head	list;
 };
 
@@ -474,7 +474,7 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
 }
 
 static int perf_session_deliver_event(struct perf_session *session,
-				      event_t *event,
+				      union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_event_ops *ops,
 				      u64 file_offset);
@@ -552,7 +552,7 @@ static void flush_sample_queue(struct perf_session *s,
  *      Flush every events below timestamp 7
  *      etc...
  */
-static int process_finished_round(event_t *event __used,
+static int process_finished_round(union perf_event *event __used,
 				  struct perf_session *session,
 				  struct perf_event_ops *ops)
 {
@@ -609,7 +609,7 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
 
-static int perf_session_queue_event(struct perf_session *s, event_t *event,
+static int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 				    struct perf_sample *sample, u64 file_offset)
 {
 	struct ordered_samples *os = &s->ordered_samples;
@@ -662,7 +662,7 @@ static void callchain__printf(struct perf_sample *sample)
 }
 
 static void perf_session__print_tstamp(struct perf_session *session,
-				       event_t *event,
+				       union perf_event *event,
 				       struct perf_sample *sample)
 {
 	if (event->header.type != PERF_RECORD_SAMPLE &&
@@ -678,7 +678,7 @@ static void perf_session__print_tstamp(struct perf_session *session,
 		printf("%" PRIu64 " ", sample->time);
 }
 
-static void dump_event(struct perf_session *session, event_t *event,
+static void dump_event(struct perf_session *session, union perf_event *event,
 		       u64 file_offset, struct perf_sample *sample)
 {
 	if (!dump_trace)
@@ -693,10 +693,10 @@ static void dump_event(struct perf_session *session, event_t *event,
 		perf_session__print_tstamp(session, event, sample);
 
 	printf("%#" PRIx64 " [%#x]: PERF_RECORD_%s", file_offset,
-	       event->header.size, event__get_event_name(event->header.type));
+	       event->header.size, perf_event__name(event->header.type));
 }
 
-static void dump_sample(struct perf_session *session, event_t *event,
+static void dump_sample(struct perf_session *session, union perf_event *event,
 			struct perf_sample *sample)
 {
 	if (!dump_trace)
@@ -711,7 +711,7 @@ static void dump_sample(struct perf_session *session, event_t *event,
 }
 
 static int perf_session_deliver_event(struct perf_session *session,
-				      event_t *event,
+				      union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_event_ops *ops,
 				      u64 file_offset)
@@ -745,7 +745,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 }
 
 static int perf_session__preprocess_sample(struct perf_session *session,
-					   event_t *event, struct perf_sample *sample)
+					   union perf_event *event, struct perf_sample *sample)
 {
 	if (event->header.type != PERF_RECORD_SAMPLE ||
 	    !(session->sample_type & PERF_SAMPLE_CALLCHAIN))
@@ -760,7 +760,7 @@ static int perf_session__preprocess_sample(struct perf_session *session,
 	return 0;
 }
 
-static int perf_session__process_user_event(struct perf_session *session, event_t *event,
+static int perf_session__process_user_event(struct perf_session *session, union perf_event *event,
 					    struct perf_event_ops *ops, u64 file_offset)
 {
 	dump_event(session, event, file_offset, NULL);
@@ -785,15 +785,16 @@ static int perf_session__process_user_event(struct perf_session *session, event_
 }
 
 static int perf_session__process_event(struct perf_session *session,
-				       event_t *event,
+				       union perf_event *event,
 				       struct perf_event_ops *ops,
 				       u64 file_offset)
 {
 	struct perf_sample sample;
 	int ret;
 
-	if (session->header.needs_swap && event__swap_ops[event->header.type])
-		event__swap_ops[event->header.type](event);
+	if (session->header.needs_swap &&
+	    perf_event__swap_ops[event->header.type])
+		perf_event__swap_ops[event->header.type](event);
 
 	if (event->header.type >= PERF_RECORD_HEADER_MAX)
 		return -EINVAL;
@@ -845,7 +846,7 @@ static struct thread *perf_session__register_idle_thread(struct perf_session *se
 static void perf_session__warn_about_errors(const struct perf_session *session,
 					    const struct perf_event_ops *ops)
 {
-	if (ops->lost == event__process_lost &&
+	if (ops->lost == perf_event__process_lost &&
 	    session->hists.stats.total_lost != 0) {
 		ui__warning("Processed %" PRIu64 " events and LOST %" PRIu64
 			    "!\n\nCheck IO/CPU overload!\n\n",
@@ -877,7 +878,7 @@ volatile int session_done;
 static int __perf_session__process_pipe_events(struct perf_session *self,
 					       struct perf_event_ops *ops)
 {
-	event_t event;
+	union perf_event event;
 	uint32_t size;
 	int skip = 0;
 	u64 head;
@@ -958,7 +959,7 @@ int __perf_session__process_events(struct perf_session *session,
 	struct ui_progress *progress;
 	size_t	page_size, mmap_size;
 	char *buf, *mmaps[8];
-	event_t *event;
+	union perf_event *event;
 	uint32_t size;
 
 	perf_event_ops__fill_defaults(ops);
@@ -1003,7 +1004,7 @@ remap:
 	file_pos = file_offset + head;
 
 more:
-	event = (event_t *)(buf + head);
+	event = (union perf_event *)(buf + head);
 
 	if (session->header.needs_swap)
 		perf_event_header__bswap(&event->header);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 365bf53..977b3a1 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -57,10 +57,11 @@ struct perf_session {
 
 struct perf_event_ops;
 
-typedef int (*event_op)(event_t *self, struct perf_sample *sample,
+typedef int (*event_op)(union perf_event *self, struct perf_sample *sample,
 			struct perf_session *session);
-typedef int (*event_synth_op)(event_t *self, struct perf_session *session);
-typedef int (*event_op2)(event_t *self, struct perf_session *session,
+typedef int (*event_synth_op)(union perf_event *self,
+			      struct perf_session *session);
+typedef int (*event_op2)(union perf_event *self, struct perf_session *session,
 			 struct perf_event_ops *ops);
 
 struct perf_event_ops {
@@ -157,11 +158,11 @@ size_t perf_session__fprintf_nr_events(struct perf_session *self, FILE *fp)
 }
 
 static inline int perf_session__parse_sample(struct perf_session *session,
-					     const event_t *event,
+					     const union perf_event *event,
 					     struct perf_sample *sample)
 {
-	return event__parse_sample(event, session->sample_type,
-				   session->sample_id_all, sample);
+	return perf_event__parse_sample(event, session->sample_type,
+					session->sample_id_all, sample);
 }
 
 #endif /* __PERF_SESSION_H */
-- 
1.6.2.5

