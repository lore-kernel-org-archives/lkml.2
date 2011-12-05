Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab1LEM7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:59:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57013 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab1LEM7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:59:37 -0500
Date: Mon, 5 Dec 2011 04:58:27 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-stua66dcscsezzrcdugvbmvd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Resolve machine earlier and pass it to perf_event_ops
Git-Commit-ID: 743eb868657bdb1b26c7b24077ca21c67c82c777
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:58:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  743eb868657bdb1b26c7b24077ca21c67c82c777
Gitweb:     http://git.kernel.org/tip/743eb868657bdb1b26c7b24077ca21c67c82c777
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 28 Nov 2011 07:56:39 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:39:12 -0200

perf tools: Resolve machine earlier and pass it to perf_event_ops

Reducing the exposure of perf_session further, so that we can use the
classes in cases where no perf.data file is created.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-stua66dcscsezzrcdugvbmvd@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c                      |    4 +-
 tools/perf/builtin-diff.c                          |    9 +-
 tools/perf/builtin-inject.c                        |   70 +++++----
 tools/perf/builtin-kmem.c                          |    4 +-
 tools/perf/builtin-lock.c                          |    4 +-
 tools/perf/builtin-record.c                        |   38 +++---
 tools/perf/builtin-report.c                        |   24 ++--
 tools/perf/builtin-sched.c                         |   70 +++++-----
 tools/perf/builtin-script.c                        |   26 ++--
 tools/perf/builtin-timechart.c                     |    8 +-
 tools/perf/builtin-top.c                           |   99 +++++++------
 tools/perf/util/build-id.c                         |   16 +-
 tools/perf/util/event.c                            |  151 ++++++++-----------
 tools/perf/util/event.h                            |   21 ++--
 tools/perf/util/header.c                           |   28 ++--
 tools/perf/util/header.h                           |   16 +--
 tools/perf/util/map.h                              |   10 ++
 .../perf/util/scripting-engines/trace-event-perl.c |    4 +-
 .../util/scripting-engines/trace-event-python.c    |    4 +-
 tools/perf/util/session.c                          |   91 +++++++-----
 tools/perf/util/session.h                          |   30 ++--
 tools/perf/util/thread.h                           |   14 +--
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |    8 +-
 24 files changed, 376 insertions(+), 375 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 483cb94..dff081a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -83,12 +83,12 @@ static int process_sample_event(struct perf_event_ops *ops,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
-				struct perf_session *session)
+				struct machine *machine)
 {
 	struct perf_annotate *ann = container_of(ops, struct perf_annotate, ops);
 	struct addr_location al;
 
-	if (perf_event__preprocess_sample(event, session, &al, sample,
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
 					  symbol__annotate_init) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 9a0872f..478b0ae 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -9,6 +9,7 @@
 #include "util/debug.h"
 #include "util/event.h"
 #include "util/hist.h"
+#include "util/evsel.h"
 #include "util/session.h"
 #include "util/sort.h"
 #include "util/symbol.h"
@@ -34,11 +35,11 @@ static int diff__process_sample_event(struct perf_event_ops *ops __used,
 				      union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_evsel *evsel __used,
-				      struct perf_session *session)
+				      struct machine *machine)
 {
 	struct addr_location al;
 
-	if (perf_event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample, NULL) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
@@ -47,12 +48,12 @@ static int diff__process_sample_event(struct perf_event_ops *ops __used,
 	if (al.filtered || al.sym == NULL)
 		return 0;
 
-	if (hists__add_entry(&session->hists, &al, sample->period)) {
+	if (hists__add_entry(&evsel->hists, &al, sample->period)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
 
-	session->hists.stats.total_period += sample->period;
+	evsel->hists.stats.total_period += sample->period;
 	return 0;
 }
 
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 6ce6d80..a5bcf81 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -18,7 +18,7 @@ static bool		inject_build_ids;
 
 static int perf_event__repipe_synth(struct perf_event_ops *ops __used,
 				    union perf_event *event,
-				    struct perf_session *session __used)
+				    struct machine *machine __used)
 {
 	uint32_t size;
 	void *buf = event;
@@ -37,10 +37,23 @@ static int perf_event__repipe_synth(struct perf_event_ops *ops __used,
 	return 0;
 }
 
+static int perf_event__repipe_op2_synth(struct perf_event_ops *ops,
+					union perf_event *event,
+					struct perf_session *session __used)
+{
+	return perf_event__repipe_synth(ops, event, NULL);
+}
+
+static int perf_event__repipe_event_type_synth(struct perf_event_ops *ops,
+					       union perf_event *event)
+{
+	return perf_event__repipe_synth(ops, event, NULL);
+}
+
 static int perf_event__repipe_tracing_data_synth(union perf_event *event,
-						 struct perf_session *session)
+						 struct perf_session *session __used)
 {
-	return perf_event__repipe_synth(NULL, event, session);
+	return perf_event__repipe_synth(NULL, event, NULL);
 }
 
 static int perf_event__repipe_attr(union perf_event *event,
@@ -52,29 +65,29 @@ static int perf_event__repipe_attr(union perf_event *event,
 static int perf_event__repipe(struct perf_event_ops *ops,
 			      union perf_event *event,
 			      struct perf_sample *sample __used,
-			      struct perf_session *session)
+			      struct machine *machine)
 {
-	return perf_event__repipe_synth(ops, event, session);
+	return perf_event__repipe_synth(ops, event, machine);
 }
 
 static int perf_event__repipe_sample(struct perf_event_ops *ops,
 				     union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct perf_evsel *evsel __used,
-			      struct perf_session *session)
+			      struct machine *machine)
 {
-	return perf_event__repipe_synth(ops, event, session);
+	return perf_event__repipe_synth(ops, event, machine);
 }
 
 static int perf_event__repipe_mmap(struct perf_event_ops *ops,
 				   union perf_event *event,
 				   struct perf_sample *sample,
-				   struct perf_session *session)
+				   struct machine *machine)
 {
 	int err;
 
-	err = perf_event__process_mmap(ops, event, sample, session);
-	perf_event__repipe(ops, event, sample, session);
+	err = perf_event__process_mmap(ops, event, sample, machine);
+	perf_event__repipe(ops, event, sample, machine);
 
 	return err;
 }
@@ -82,12 +95,12 @@ static int perf_event__repipe_mmap(struct perf_event_ops *ops,
 static int perf_event__repipe_task(struct perf_event_ops *ops,
 				   union perf_event *event,
 				   struct perf_sample *sample,
-				   struct perf_session *session)
+				   struct machine *machine)
 {
 	int err;
 
-	err = perf_event__process_task(ops, event, sample, session);
-	perf_event__repipe(ops, event, sample, session);
+	err = perf_event__process_task(ops, event, sample, machine);
+	perf_event__repipe(ops, event, sample, machine);
 
 	return err;
 }
@@ -97,7 +110,7 @@ static int perf_event__repipe_tracing_data(union perf_event *event,
 {
 	int err;
 
-	perf_event__repipe_synth(NULL, event, session);
+	perf_event__repipe_synth(NULL, event, NULL);
 	err = perf_event__process_tracing_data(event, session);
 
 	return err;
@@ -118,10 +131,9 @@ static int dso__read_build_id(struct dso *self)
 }
 
 static int dso__inject_build_id(struct dso *self, struct perf_event_ops *ops,
-				struct perf_session *session)
+				struct machine *machine)
 {
 	u16 misc = PERF_RECORD_MISC_USER;
-	struct machine *machine;
 	int err;
 
 	if (dso__read_build_id(self) < 0) {
@@ -129,17 +141,11 @@ static int dso__inject_build_id(struct dso *self, struct perf_event_ops *ops,
 		return -1;
 	}
 
-	machine = perf_session__find_host_machine(session);
-	if (machine == NULL) {
-		pr_err("Can't find machine for session\n");
-		return -1;
-	}
-
 	if (self->kernel)
 		misc = PERF_RECORD_MISC_KERNEL;
 
 	err = perf_event__synthesize_build_id(ops, self, misc, perf_event__repipe,
-					      machine, session);
+					      machine);
 	if (err) {
 		pr_err("Can't synthesize build_id event for %s\n", self->long_name);
 		return -1;
@@ -152,7 +158,7 @@ static int perf_event__inject_buildid(struct perf_event_ops *ops,
 				      union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_evsel *evsel __used,
-				      struct perf_session *session)
+				      struct machine *machine)
 {
 	struct addr_location al;
 	struct thread *thread;
@@ -160,21 +166,21 @@ static int perf_event__inject_buildid(struct perf_event_ops *ops,
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	thread = perf_session__findnew(session, event->ip.pid);
+	thread = machine__findnew_thread(machine, event->ip.pid);
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
 		goto repipe;
 	}
 
-	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
-			      event->ip.pid, event->ip.ip, &al);
+	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
+			      event->ip.ip, &al);
 
 	if (al.map != NULL) {
 		if (!al.map->dso->hit) {
 			al.map->dso->hit = 1;
 			if (map__load(al.map, NULL) >= 0) {
-				dso__inject_build_id(al.map->dso, ops, session);
+				dso__inject_build_id(al.map->dso, ops, machine);
 				/*
 				 * If this fails, too bad, let the other side
 				 * account this as unresolved.
@@ -187,7 +193,7 @@ static int perf_event__inject_buildid(struct perf_event_ops *ops,
 	}
 
 repipe:
-	perf_event__repipe(ops, event, sample, session);
+	perf_event__repipe(ops, event, sample, machine);
 	return 0;
 }
 
@@ -198,13 +204,13 @@ struct perf_event_ops inject_ops = {
 	.fork		= perf_event__repipe,
 	.exit		= perf_event__repipe,
 	.lost		= perf_event__repipe,
-	.read		= perf_event__repipe,
+	.read		= perf_event__repipe_sample,
 	.throttle	= perf_event__repipe,
 	.unthrottle	= perf_event__repipe,
 	.attr		= perf_event__repipe_attr,
-	.event_type	= perf_event__repipe_synth,
+	.event_type	= perf_event__repipe_event_type_synth,
 	.tracing_data	= perf_event__repipe_tracing_data_synth,
-	.build_id	= perf_event__repipe_synth,
+	.build_id	= perf_event__repipe_op2_synth,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 5d01218..27b2a15 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -307,9 +307,9 @@ static int process_sample_event(struct perf_event_ops *ops __used,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel __used,
-				struct perf_session *session)
+				struct machine *machine)
 {
-	struct thread *thread = perf_session__findnew(session, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index f06b0a4..99b032a 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -849,9 +849,9 @@ static int process_sample_event(struct perf_event_ops *ops __used,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel __used,
-				struct perf_session *s)
+				struct machine *machine)
 {
-	struct thread *thread = perf_session__findnew(s, sample->tid);
+	struct thread *thread = machine__findnew_thread(machine, sample->tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4642d38..0af598a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -79,7 +79,7 @@ static void write_output(struct perf_record *rec, void *buf, size_t size)
 static int process_synthesized_event(struct perf_event_ops *ops,
 				     union perf_event *event,
 				     struct perf_sample *sample __used,
-				     struct perf_session *self __used)
+				     struct machine *machine __used)
 {
 	struct perf_record *rec = container_of(ops, struct perf_record, ops);
 	write_output(rec, event, event->header.size);
@@ -320,8 +320,6 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 {
 	int err;
 	struct perf_event_ops *ops = data;
-	struct perf_record *rec = container_of(ops, struct perf_record, ops);
-	struct perf_session *psession = rec->session;
 
 	if (machine__is_host(machine))
 		return;
@@ -335,7 +333,7 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 	 *in module instead of in guest kernel.
 	 */
 	err = perf_event__synthesize_modules(ops, process_synthesized_event,
-					     psession, machine);
+					     machine);
 	if (err < 0)
 		pr_err("Couldn't record guest kernel [%d]'s reference"
 		       " relocation symbol.\n", machine->pid);
@@ -345,11 +343,10 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 	 * have no _text sometimes.
 	 */
 	err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
-						 psession, machine, "_text");
+						 machine, "_text");
 	if (err < 0)
 		err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
-							 psession, machine,
-							 "_stext");
+							 machine, "_stext");
 	if (err < 0)
 		pr_err("Couldn't record guest kernel [%d]'s reference"
 		       " relocation symbol.\n", machine->pid);
@@ -497,6 +494,12 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	rec->post_processing_offset = lseek(output, 0, SEEK_CUR);
 
+	machine = perf_session__find_host_machine(session);
+	if (!machine) {
+		pr_err("Couldn't find native kernel information.\n");
+		return -1;
+	}
+
 	if (opts->pipe_output) {
 		err = perf_event__synthesize_attrs(ops, session,
 						   process_synthesized_event);
@@ -506,7 +509,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		}
 
 		err = perf_event__synthesize_event_types(ops, process_synthesized_event,
-							 session);
+							 machine);
 		if (err < 0) {
 			pr_err("Couldn't synthesize event_types.\n");
 			return err;
@@ -522,8 +525,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			 * propagate errors that now are calling die()
 			 */
 			err = perf_event__synthesize_tracing_data(ops, output, evsel_list,
-								  process_synthesized_event,
-								  session);
+								  process_synthesized_event);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
 				return err;
@@ -532,24 +534,18 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		}
 	}
 
-	machine = perf_session__find_host_machine(session);
-	if (!machine) {
-		pr_err("Couldn't find native kernel information.\n");
-		return -1;
-	}
-
 	err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
-						 session, machine, "_text");
+						 machine, "_text");
 	if (err < 0)
 		err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
-							 session, machine, "_stext");
+							 machine, "_stext");
 	if (err < 0)
 		pr_err("Couldn't record kernel reference relocation symbol\n"
 		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
 		       "Check /proc/kallsyms permission or run as root.\n");
 
 	err = perf_event__synthesize_modules(ops, process_synthesized_event,
-					     session, machine);
+					     machine);
 	if (err < 0)
 		pr_err("Couldn't record kernel module information.\n"
 		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
@@ -562,10 +558,10 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	if (!opts->system_wide)
 		perf_event__synthesize_thread_map(ops, evsel_list->threads,
 						  process_synthesized_event,
-						  session);
+						  machine);
 	else
 		perf_event__synthesize_threads(ops, process_synthesized_event,
-					       session);
+					       machine);
 
 	if (rec->realtime_prio) {
 		struct sched_param param;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8795520..ea64fbb 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -52,18 +52,18 @@ struct perf_report {
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
-static int perf_session__add_hist_entry(struct perf_session *session,
-					struct addr_location *al,
-					struct perf_sample *sample,
-					struct perf_evsel *evsel)
+static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
+				      struct addr_location *al,
+				      struct perf_sample *sample,
+				      struct machine *machine)
 {
 	struct symbol *parent = NULL;
 	int err = 0;
 	struct hist_entry *he;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
-		err = perf_session__resolve_callchain(session, evsel, al->thread,
-						      sample->callchain, &parent);
+		err = machine__resolve_callchain(machine, evsel, al->thread,
+						 sample->callchain, &parent);
 		if (err)
 			return err;
 	}
@@ -107,12 +107,12 @@ static int process_sample_event(struct perf_event_ops *ops,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
-				struct perf_session *session)
+				struct machine *machine)
 {
 	struct perf_report *rep = container_of(ops, struct perf_report, ops);
 	struct addr_location al;
 
-	if (perf_event__preprocess_sample(event, session, &al, sample,
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
 					  rep->annotate_init) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
@@ -128,7 +128,7 @@ static int process_sample_event(struct perf_event_ops *ops,
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
-	if (perf_session__add_hist_entry(session, &al, sample, evsel)) {
+	if (perf_evsel__add_hist_entry(evsel, &al, sample, machine)) {
 		pr_debug("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
@@ -139,11 +139,11 @@ static int process_sample_event(struct perf_event_ops *ops,
 static int process_read_event(struct perf_event_ops *ops,
 			      union perf_event *event,
 			      struct perf_sample *sample __used,
-			      struct perf_session *session)
+			      struct perf_evsel *evsel,
+			      struct machine *machine __used)
 {
 	struct perf_report *rep = container_of(ops, struct perf_report, ops);
-	struct perf_evsel *evsel = perf_evlist__id2evsel(session->evlist,
-							 event->read.id);
+
 	if (rep->show_threads) {
 		const char *name = evsel ? event_name(evsel) : "unknown";
 		perf_read_values_add_value(&rep->show_threads_values,
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index b11d628..6a771f8 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -724,21 +724,21 @@ struct trace_migrate_task_event {
 
 struct trace_sched_handler {
 	void (*switch_event)(struct trace_switch_event *,
-			     struct perf_session *,
+			     struct machine *,
 			     struct event *,
 			     int cpu,
 			     u64 timestamp,
 			     struct thread *thread);
 
 	void (*runtime_event)(struct trace_runtime_event *,
-			      struct perf_session *,
+			      struct machine *,
 			      struct event *,
 			      int cpu,
 			      u64 timestamp,
 			      struct thread *thread);
 
 	void (*wakeup_event)(struct trace_wakeup_event *,
-			     struct perf_session *,
+			     struct machine *,
 			     struct event *,
 			     int cpu,
 			     u64 timestamp,
@@ -751,7 +751,7 @@ struct trace_sched_handler {
 			   struct thread *thread);
 
 	void (*migrate_task_event)(struct trace_migrate_task_event *,
-			   struct perf_session *session,
+			   struct machine *machine,
 			   struct event *,
 			   int cpu,
 			   u64 timestamp,
@@ -761,7 +761,7 @@ struct trace_sched_handler {
 
 static void
 replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
-		    struct perf_session *session __used,
+		    struct machine *machine __used,
 		    struct event *event,
 		    int cpu __used,
 		    u64 timestamp __used,
@@ -788,7 +788,7 @@ static u64 cpu_last_switched[MAX_CPUS];
 
 static void
 replay_switch_event(struct trace_switch_event *switch_event,
-		    struct perf_session *session __used,
+		    struct machine *machine __used,
 		    struct event *event,
 		    int cpu,
 		    u64 timestamp,
@@ -1022,7 +1022,7 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 
 static void
 latency_switch_event(struct trace_switch_event *switch_event,
-		     struct perf_session *session,
+		     struct machine *machine,
 		     struct event *event __used,
 		     int cpu,
 		     u64 timestamp,
@@ -1046,8 +1046,8 @@ latency_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %" PRIu64 " < 0 ?\n", delta);
 
 
-	sched_out = perf_session__findnew(session, switch_event->prev_pid);
-	sched_in = perf_session__findnew(session, switch_event->next_pid);
+	sched_out = machine__findnew_thread(machine, switch_event->prev_pid);
+	sched_in = machine__findnew_thread(machine, switch_event->next_pid);
 
 	out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
 	if (!out_events) {
@@ -1075,13 +1075,13 @@ latency_switch_event(struct trace_switch_event *switch_event,
 
 static void
 latency_runtime_event(struct trace_runtime_event *runtime_event,
-		     struct perf_session *session,
+		     struct machine *machine,
 		     struct event *event __used,
 		     int cpu,
 		     u64 timestamp,
 		     struct thread *this_thread __used)
 {
-	struct thread *thread = perf_session__findnew(session, runtime_event->pid);
+	struct thread *thread = machine__findnew_thread(machine, runtime_event->pid);
 	struct work_atoms *atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
 
 	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
@@ -1098,7 +1098,7 @@ latency_runtime_event(struct trace_runtime_event *runtime_event,
 
 static void
 latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
-		     struct perf_session *session,
+		     struct machine *machine,
 		     struct event *__event __used,
 		     int cpu __used,
 		     u64 timestamp,
@@ -1112,7 +1112,7 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	if (!wakeup_event->success)
 		return;
 
-	wakee = perf_session__findnew(session, wakeup_event->pid);
+	wakee = machine__findnew_thread(machine, wakeup_event->pid);
 	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(wakee);
@@ -1146,7 +1146,7 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 
 static void
 latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
-		     struct perf_session *session,
+		     struct machine *machine,
 		     struct event *__event __used,
 		     int cpu __used,
 		     u64 timestamp,
@@ -1162,7 +1162,7 @@ latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
 	if (profile_cpu == -1)
 		return;
 
-	migrant = perf_session__findnew(session, migrate_task_event->pid);
+	migrant = machine__findnew_thread(machine, migrate_task_event->pid);
 	atoms = thread_atoms_search(&atom_root, migrant, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(migrant);
@@ -1357,7 +1357,7 @@ static void sort_lat(void)
 static struct trace_sched_handler *trace_handler;
 
 static void
-process_sched_wakeup_event(void *data, struct perf_session *session,
+process_sched_wakeup_event(void *data, struct machine *machine,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1374,7 +1374,7 @@ process_sched_wakeup_event(void *data, struct perf_session *session,
 	FILL_FIELD(wakeup_event, cpu, event, data);
 
 	if (trace_handler->wakeup_event)
-		trace_handler->wakeup_event(&wakeup_event, session, event,
+		trace_handler->wakeup_event(&wakeup_event, machine, event,
 					    cpu, timestamp, thread);
 }
 
@@ -1393,7 +1393,7 @@ static char next_shortname2 = '0';
 
 static void
 map_switch_event(struct trace_switch_event *switch_event,
-		 struct perf_session *session,
+		 struct machine *machine,
 		 struct event *event __used,
 		 int this_cpu,
 		 u64 timestamp,
@@ -1421,8 +1421,8 @@ map_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %" PRIu64 " < 0 ?\n", delta);
 
 
-	sched_out = perf_session__findnew(session, switch_event->prev_pid);
-	sched_in = perf_session__findnew(session, switch_event->next_pid);
+	sched_out = machine__findnew_thread(machine, switch_event->prev_pid);
+	sched_in = machine__findnew_thread(machine, switch_event->next_pid);
 
 	curr_thread[this_cpu] = sched_in;
 
@@ -1472,7 +1472,7 @@ map_switch_event(struct trace_switch_event *switch_event,
 
 
 static void
-process_sched_switch_event(void *data, struct perf_session *session,
+process_sched_switch_event(void *data, struct machine *machine,
 			   struct event *event,
 			   int this_cpu,
 			   u64 timestamp __used,
@@ -1499,14 +1499,14 @@ process_sched_switch_event(void *data, struct perf_session *session,
 			nr_context_switch_bugs++;
 	}
 	if (trace_handler->switch_event)
-		trace_handler->switch_event(&switch_event, session, event,
+		trace_handler->switch_event(&switch_event, machine, event,
 					    this_cpu, timestamp, thread);
 
 	curr_pid[this_cpu] = switch_event.next_pid;
 }
 
 static void
-process_sched_runtime_event(void *data, struct perf_session *session,
+process_sched_runtime_event(void *data, struct machine *machine,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1520,7 +1520,7 @@ process_sched_runtime_event(void *data, struct perf_session *session,
 	FILL_FIELD(runtime_event, vruntime, event, data);
 
 	if (trace_handler->runtime_event)
-		trace_handler->runtime_event(&runtime_event, session, event, cpu, timestamp, thread);
+		trace_handler->runtime_event(&runtime_event, machine, event, cpu, timestamp, thread);
 }
 
 static void
@@ -1555,7 +1555,7 @@ process_sched_exit_event(struct event *event,
 }
 
 static void
-process_sched_migrate_task_event(void *data, struct perf_session *session,
+process_sched_migrate_task_event(void *data, struct machine *machine,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1571,12 +1571,12 @@ process_sched_migrate_task_event(void *data, struct perf_session *session,
 	FILL_FIELD(migrate_task_event, cpu, event, data);
 
 	if (trace_handler->migrate_task_event)
-		trace_handler->migrate_task_event(&migrate_task_event, session,
+		trace_handler->migrate_task_event(&migrate_task_event, machine,
 						 event, cpu, timestamp, thread);
 }
 
 static void process_raw_event(union perf_event *raw_event __used,
-			      struct perf_session *session, void *data, int cpu,
+			      struct machine *machine, void *data, int cpu,
 			      u64 timestamp, struct thread *thread)
 {
 	struct event *event;
@@ -1587,33 +1587,33 @@ static void process_raw_event(union perf_event *raw_event __used,
 	event = trace_find_event(type);
 
 	if (!strcmp(event->name, "sched_switch"))
-		process_sched_switch_event(data, session, event, cpu, timestamp, thread);
+		process_sched_switch_event(data, machine, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_stat_runtime"))
-		process_sched_runtime_event(data, session, event, cpu, timestamp, thread);
+		process_sched_runtime_event(data, machine, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup"))
-		process_sched_wakeup_event(data, session, event, cpu, timestamp, thread);
+		process_sched_wakeup_event(data, machine, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup_new"))
-		process_sched_wakeup_event(data, session, event, cpu, timestamp, thread);
+		process_sched_wakeup_event(data, machine, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_process_fork"))
 		process_sched_fork_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_process_exit"))
 		process_sched_exit_event(event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_migrate_task"))
-		process_sched_migrate_task_event(data, session, event, cpu, timestamp, thread);
+		process_sched_migrate_task_event(data, machine, event, cpu, timestamp, thread);
 }
 
 static int process_sample_event(struct perf_event_ops *ops __used,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
-				struct perf_session *session)
+				struct machine *machine)
 {
 	struct thread *thread;
 
 	if (!(evsel->attr.sample_type & PERF_SAMPLE_RAW))
 		return 0;
 
-	thread = perf_session__findnew(session, sample->pid);
+	thread = machine__findnew_thread(machine, sample->pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -1625,7 +1625,7 @@ static int process_sample_event(struct perf_event_ops *ops __used,
 	if (profile_cpu != -1 && profile_cpu != (int)sample->cpu)
 		return 0;
 
-	process_raw_event(event, session, sample->raw_data, sample->cpu,
+	process_raw_event(event, machine, sample->raw_data, sample->cpu,
 			  sample->time, thread);
 
 	return 0;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 3b78206..31a8d14 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -315,7 +315,7 @@ static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
 
 static void print_sample_addr(union perf_event *event,
 			  struct perf_sample *sample,
-			  struct perf_session *session,
+			  struct machine *machine,
 			  struct thread *thread,
 			  struct perf_event_attr *attr)
 {
@@ -328,11 +328,11 @@ static void print_sample_addr(union perf_event *event,
 	if (!sample_addr_correlates_sym(attr))
 		return;
 
-	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
-			      event->ip.pid, sample->addr, &al);
+	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
+			      sample->addr, &al);
 	if (!al.map)
-		thread__find_addr_map(thread, session, cpumode, MAP__VARIABLE,
-				      event->ip.pid, sample->addr, &al);
+		thread__find_addr_map(thread, machine, cpumode, MAP__VARIABLE,
+				      sample->addr, &al);
 
 	al.cpu = sample->cpu;
 	al.sym = NULL;
@@ -362,7 +362,7 @@ static void print_sample_addr(union perf_event *event,
 static void process_event(union perf_event *event __unused,
 			  struct perf_sample *sample,
 			  struct perf_evsel *evsel,
-			  struct perf_session *session,
+			  struct machine *machine,
 			  struct thread *thread)
 {
 	struct perf_event_attr *attr = &evsel->attr;
@@ -377,15 +377,15 @@ static void process_event(union perf_event *event __unused,
 				  sample->raw_size);
 
 	if (PRINT_FIELD(ADDR))
-		print_sample_addr(event, sample, session, thread, attr);
+		print_sample_addr(event, sample, machine, thread, attr);
 
 	if (PRINT_FIELD(IP)) {
 		if (!symbol_conf.use_callchain)
 			printf(" ");
 		else
 			printf("\n");
-		perf_session__print_ip(event, evsel, sample, session,
-					      PRINT_FIELD(SYM), PRINT_FIELD(DSO));
+		perf_event__print_ip(event, sample, machine, evsel,
+				     PRINT_FIELD(SYM), PRINT_FIELD(DSO));
 	}
 
 	printf("\n");
@@ -438,9 +438,9 @@ static int process_sample_event(struct perf_event_ops *ops __used,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
-				struct perf_session *session)
+				struct machine *machine)
 {
-	struct thread *thread = perf_session__findnew(session, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -462,9 +462,9 @@ static int process_sample_event(struct perf_event_ops *ops __used,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	scripting_ops->process_event(event, sample, evsel, session, thread);
+	scripting_ops->process_event(event, sample, evsel, machine, thread);
 
-	session->hists.stats.total_period += sample->period;
+	evsel->hists.stats.total_period += sample->period;
 	return 0;
 }
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 62298a0..8e65396 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -277,7 +277,7 @@ static u64 cpus_pstate_state[MAX_CPUS];
 static int process_comm_event(struct perf_event_ops *ops __used,
 			      union perf_event *event,
 			      struct perf_sample *sample __used,
-			      struct perf_session *session __used)
+			      struct machine *machine __used)
 {
 	pid_set_comm(event->comm.tid, event->comm.comm);
 	return 0;
@@ -286,7 +286,7 @@ static int process_comm_event(struct perf_event_ops *ops __used,
 static int process_fork_event(struct perf_event_ops *ops __used,
 			      union perf_event *event,
 			      struct perf_sample *sample __used,
-			      struct perf_session *session __used)
+			      struct machine *machine __used)
 {
 	pid_fork(event->fork.pid, event->fork.ppid, event->fork.time);
 	return 0;
@@ -295,7 +295,7 @@ static int process_fork_event(struct perf_event_ops *ops __used,
 static int process_exit_event(struct perf_event_ops *ops __used,
 			      union perf_event *event,
 			      struct perf_sample *sample __used,
-			      struct perf_session *session __used)
+			      struct machine *machine __used)
 {
 	pid_exit(event->fork.pid, event->fork.time);
 	return 0;
@@ -494,7 +494,7 @@ static int process_sample_event(struct perf_event_ops *ops __used,
 				union perf_event *event __used,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
-				struct perf_session *session __used)
+				struct machine *machine __used)
 {
 	struct trace_entry *te;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e8e3320..31d4973 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -258,11 +258,9 @@ out_unlock:
 
 static const char		CONSOLE_CLEAR[] = "[H[2J";
 
-static struct hist_entry *
-	perf_session__add_hist_entry(struct perf_session *session,
-				     struct addr_location *al,
-				     struct perf_sample *sample,
-				     struct perf_evsel *evsel)
+static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
+						     struct addr_location *al,
+						     struct perf_sample *sample)
 {
 	struct hist_entry *he;
 
@@ -270,7 +268,7 @@ static struct hist_entry *
 	if (he == NULL)
 		return NULL;
 
-	session->hists.stats.total_period += sample->period;
+	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 	return he;
 }
@@ -675,44 +673,12 @@ static int symbol_filter(struct map *map __used, struct symbol *sym)
 static void perf_event__process_sample(const union perf_event *event,
 				       struct perf_evsel *evsel,
 				       struct perf_sample *sample,
-				       struct perf_session *session)
+				       struct machine *machine)
 {
 	struct symbol *parent = NULL;
 	u64 ip = event->ip.ip;
 	struct addr_location al;
-	struct machine *machine;
 	int err;
-	u8 origin = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-
-	++top.samples;
-
-	switch (origin) {
-	case PERF_RECORD_MISC_USER:
-		++top.us_samples;
-		if (top.hide_user_symbols)
-			return;
-		machine = perf_session__find_host_machine(session);
-		break;
-	case PERF_RECORD_MISC_KERNEL:
-		++top.kernel_samples;
-		if (top.hide_kernel_symbols)
-			return;
-		machine = perf_session__find_host_machine(session);
-		break;
-	case PERF_RECORD_MISC_GUEST_KERNEL:
-		++top.guest_kernel_samples;
-		machine = perf_session__find_machine(session, event->ip.pid);
-		break;
-	case PERF_RECORD_MISC_GUEST_USER:
-		++top.guest_us_samples;
-		/*
-		 * TODO: we don't process guest user from host side
-		 * except simple counting.
-		 */
-		return;
-	default:
-		return;
-	}
 
 	if (!machine && perf_guest) {
 		pr_err("Can't find guest [%d]'s kernel information\n",
@@ -723,7 +689,7 @@ static void perf_event__process_sample(const union perf_event *event,
 	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		top.exact_samples++;
 
-	if (perf_event__preprocess_sample(event, session, &al, sample,
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
 					  symbol_filter) < 0 ||
 	    al.filtered)
 		return;
@@ -777,13 +743,13 @@ static void perf_event__process_sample(const union perf_event *event,
 
 		if ((sort__has_parent || symbol_conf.use_callchain) &&
 		    sample->callchain) {
-			err = perf_session__resolve_callchain(session, evsel, al.thread,
-							      sample->callchain, &parent);
+			err = machine__resolve_callchain(machine, evsel, al.thread,
+							 sample->callchain, &parent);
 			if (err)
 				return;
 		}
 
-		he = perf_session__add_hist_entry(session, &al, sample, evsel);
+		he = perf_evsel__add_hist_entry(evsel, &al, sample);
 		if (he == NULL) {
 			pr_err("Problem incrementing symbol period, skipping event\n");
 			return;
@@ -808,6 +774,8 @@ static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 	struct perf_sample sample;
 	struct perf_evsel *evsel;
 	union perf_event *event;
+	struct machine *machine;
+	u8 origin;
 	int ret;
 
 	while ((event = perf_evlist__mmap_read(top.evlist, idx)) != NULL) {
@@ -820,11 +788,45 @@ static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 		evsel = perf_evlist__id2evsel(self->evlist, sample.id);
 		assert(evsel != NULL);
 
+		origin = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+
 		if (event->header.type == PERF_RECORD_SAMPLE)
-			perf_event__process_sample(event, evsel, &sample, self);
+			++top.samples;
+
+		switch (origin) {
+		case PERF_RECORD_MISC_USER:
+			++top.us_samples;
+			if (top.hide_user_symbols)
+				continue;
+			machine = perf_session__find_host_machine(self);
+			break;
+		case PERF_RECORD_MISC_KERNEL:
+			++top.kernel_samples;
+			if (top.hide_kernel_symbols)
+				continue;
+			machine = perf_session__find_host_machine(self);
+			break;
+		case PERF_RECORD_MISC_GUEST_KERNEL:
+			++top.guest_kernel_samples;
+			machine = perf_session__find_machine(self, event->ip.pid);
+			break;
+		case PERF_RECORD_MISC_GUEST_USER:
+			++top.guest_us_samples;
+			/*
+			 * TODO: we don't process guest user from host side
+			 * except simple counting.
+			 */
+			/* Fall thru */
+		default:
+			continue;
+		}
+
+
+		if (event->header.type == PERF_RECORD_SAMPLE)
+			perf_event__process_sample(event, evsel, &sample, machine);
 		else if (event->header.type < PERF_RECORD_MAX) {
 			hists__inc_nr_events(&evsel->hists, event->header.type);
-			perf_event__process(&top.ops, event, &sample, self);
+			perf_event__process(&top.ops, event, &sample, machine);
 		} else
 			++self->hists.stats.nr_unknown_events;
 	}
@@ -967,10 +969,11 @@ static int __cmd_top(void)
 
 	if (top.target_tid != -1)
 		perf_event__synthesize_thread_map(&top.ops, top.evlist->threads,
-						  perf_event__process, top.session);
+						  perf_event__process,
+						  &top.session->host_machine);
 	else
-		perf_event__synthesize_threads(&top.ops, perf_event__process, top.session);
-
+		perf_event__synthesize_threads(&top.ops, perf_event__process,
+					       &top.session->host_machine);
 	start_counters(top.evlist);
 	top.session->evlist = top.evlist;
 	perf_session__update_sample_type(top.session);
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 0e4de18..2f84c48 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -19,11 +19,11 @@ static int build_id__mark_dso_hit(struct perf_event_ops *ops __used,
 				  union perf_event *event,
 				  struct perf_sample *sample __used,
 				  struct perf_evsel *evsel __used,
-				  struct perf_session *session)
+				  struct machine *machine)
 {
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = perf_session__findnew(session, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
 
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
@@ -31,8 +31,8 @@ static int build_id__mark_dso_hit(struct perf_event_ops *ops __used,
 		return -1;
 	}
 
-	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
-			      event->ip.pid, event->ip.ip, &al);
+	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
+			      event->ip.ip, &al);
 
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
@@ -43,16 +43,16 @@ static int build_id__mark_dso_hit(struct perf_event_ops *ops __used,
 static int perf_event__exit_del_thread(struct perf_event_ops *ops __used,
 				       union perf_event *event,
 				       struct perf_sample *sample __used,
-				       struct perf_session *session)
+				       struct machine *machine)
 {
-	struct thread *thread = perf_session__findnew(session, event->fork.tid);
+	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
 
 	dump_printf("(%d:%d):(%d:%d)\n", event->fork.pid, event->fork.tid,
 		    event->fork.ppid, event->fork.ptid);
 
 	if (thread) {
-		rb_erase(&thread->rb_node, &session->host_machine.threads);
-		session->host_machine.last_match = NULL;
+		rb_erase(&thread->rb_node, &machine->threads);
+		machine->last_match = NULL;
 		thread__delete(thread);
 	}
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 4800f38..0cdc811 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1,7 +1,6 @@
 #include <linux/types.h>
 #include "event.h"
 #include "debug.h"
-#include "session.h"
 #include "sort.h"
 #include "string.h"
 #include "strlist.h"
@@ -47,7 +46,7 @@ static struct perf_sample synth_sample = {
 static pid_t perf_event__synthesize_comm(struct perf_event_ops *ops,
 					 union perf_event *event, pid_t pid,
 					 int full, perf_event__handler_t process,
-					 struct perf_session *session)
+					 struct machine *machine)
 {
 	char filename[PATH_MAX];
 	char bf[BUFSIZ];
@@ -93,14 +92,14 @@ out_race:
 
 	event->comm.header.type = PERF_RECORD_COMM;
 	size = ALIGN(size, sizeof(u64));
-	memset(event->comm.comm + size, 0, session->id_hdr_size);
+	memset(event->comm.comm + size, 0, machine->id_hdr_size);
 	event->comm.header.size = (sizeof(event->comm) -
 				(sizeof(event->comm.comm) - size) +
-				session->id_hdr_size);
+				machine->id_hdr_size);
 	if (!full) {
 		event->comm.tid = pid;
 
-		process(ops, event, &synth_sample, session);
+		process(ops, event, &synth_sample, machine);
 		goto out;
 	}
 
@@ -118,7 +117,7 @@ out_race:
 
 		event->comm.tid = pid;
 
-		process(ops, event, &synth_sample, session);
+		process(ops, event, &synth_sample, machine);
 	}
 
 	closedir(tasks);
@@ -132,7 +131,7 @@ static int perf_event__synthesize_mmap_events(struct perf_event_ops *ops,
 					      union perf_event *event,
 					      pid_t pid, pid_t tgid,
 					      perf_event__handler_t process,
-					      struct perf_session *session)
+					      struct machine *machine)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
@@ -195,12 +194,12 @@ static int perf_event__synthesize_mmap_events(struct perf_event_ops *ops,
 			event->mmap.len -= event->mmap.start;
 			event->mmap.header.size = (sizeof(event->mmap) -
 					        (sizeof(event->mmap.filename) - size));
-			memset(event->mmap.filename + size, 0, session->id_hdr_size);
-			event->mmap.header.size += session->id_hdr_size;
+			memset(event->mmap.filename + size, 0, machine->id_hdr_size);
+			event->mmap.header.size += machine->id_hdr_size;
 			event->mmap.pid = tgid;
 			event->mmap.tid = pid;
 
-			process(ops, event, &synth_sample, session);
+			process(ops, event, &synth_sample, machine);
 		}
 	}
 
@@ -210,13 +209,12 @@ static int perf_event__synthesize_mmap_events(struct perf_event_ops *ops,
 
 int perf_event__synthesize_modules(struct perf_event_ops *ops,
 				   perf_event__handler_t process,
-				   struct perf_session *session,
 				   struct machine *machine)
 {
 	struct rb_node *nd;
 	struct map_groups *kmaps = &machine->kmaps;
 	union perf_event *event = zalloc((sizeof(event->mmap) +
-					  session->id_hdr_size));
+					  machine->id_hdr_size));
 	if (event == NULL) {
 		pr_debug("Not enough memory synthesizing mmap event "
 			 "for kernel modules\n");
@@ -246,15 +244,15 @@ int perf_event__synthesize_modules(struct perf_event_ops *ops,
 		event->mmap.header.type = PERF_RECORD_MMAP;
 		event->mmap.header.size = (sizeof(event->mmap) -
 				        (sizeof(event->mmap.filename) - size));
-		memset(event->mmap.filename + size, 0, session->id_hdr_size);
-		event->mmap.header.size += session->id_hdr_size;
+		memset(event->mmap.filename + size, 0, machine->id_hdr_size);
+		event->mmap.header.size += machine->id_hdr_size;
 		event->mmap.start = pos->start;
 		event->mmap.len   = pos->end - pos->start;
 		event->mmap.pid   = machine->pid;
 
 		memcpy(event->mmap.filename, pos->dso->long_name,
 		       pos->dso->long_name_len + 1);
-		process(ops, event, &synth_sample, session);
+		process(ops, event, &synth_sample, machine);
 	}
 
 	free(event);
@@ -265,29 +263,29 @@ static int __event__synthesize_thread(union perf_event *comm_event,
 				      union perf_event *mmap_event,
 				      pid_t pid, perf_event__handler_t process,
 				      struct perf_event_ops *ops,
-				      struct perf_session *session)
+				      struct machine *machine)
 {
-	pid_t tgid = perf_event__synthesize_comm(ops, comm_event, pid, 1, process,
-					    session);
+	pid_t tgid = perf_event__synthesize_comm(ops, comm_event, pid, 1,
+						 process, machine);
 	if (tgid == -1)
 		return -1;
 	return perf_event__synthesize_mmap_events(ops, mmap_event, pid, tgid,
-					     process, session);
+						  process, machine);
 }
 
 int perf_event__synthesize_thread_map(struct perf_event_ops *ops,
 				      struct thread_map *threads,
 				      perf_event__handler_t process,
-				      struct perf_session *session)
+				      struct machine *machine)
 {
 	union perf_event *comm_event, *mmap_event;
 	int err = -1, thread;
 
-	comm_event = malloc(sizeof(comm_event->comm) + session->id_hdr_size);
+	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
 	if (comm_event == NULL)
 		goto out;
 
-	mmap_event = malloc(sizeof(mmap_event->mmap) + session->id_hdr_size);
+	mmap_event = malloc(sizeof(mmap_event->mmap) + machine->id_hdr_size);
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
@@ -295,7 +293,7 @@ int perf_event__synthesize_thread_map(struct perf_event_ops *ops,
 	for (thread = 0; thread < threads->nr; ++thread) {
 		if (__event__synthesize_thread(comm_event, mmap_event,
 					       threads->map[thread],
-					       process, ops, session)) {
+					       process, ops, machine)) {
 			err = -1;
 			break;
 		}
@@ -309,18 +307,18 @@ out:
 
 int perf_event__synthesize_threads(struct perf_event_ops *ops,
 				   perf_event__handler_t process,
-				   struct perf_session *session)
+				   struct machine *machine)
 {
 	DIR *proc;
 	struct dirent dirent, *next;
 	union perf_event *comm_event, *mmap_event;
 	int err = -1;
 
-	comm_event = malloc(sizeof(comm_event->comm) + session->id_hdr_size);
+	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
 	if (comm_event == NULL)
 		goto out;
 
-	mmap_event = malloc(sizeof(mmap_event->mmap) + session->id_hdr_size);
+	mmap_event = malloc(sizeof(mmap_event->mmap) + machine->id_hdr_size);
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
@@ -336,7 +334,7 @@ int perf_event__synthesize_threads(struct perf_event_ops *ops,
 			continue;
 
 		__event__synthesize_thread(comm_event, mmap_event, pid,
-					   process, ops, session);
+					   process, ops, machine);
 	}
 
 	closedir(proc);
@@ -373,7 +371,6 @@ static int find_symbol_cb(void *arg, const char *name, char type,
 
 int perf_event__synthesize_kernel_mmap(struct perf_event_ops *ops,
 				       perf_event__handler_t process,
-				       struct perf_session *session,
 				       struct machine *machine,
 				       const char *symbol_name)
 {
@@ -390,7 +387,7 @@ int perf_event__synthesize_kernel_mmap(struct perf_event_ops *ops,
 	 */
 	struct process_symbol_args args = { .name = symbol_name, };
 	union perf_event *event = zalloc((sizeof(event->mmap) +
-					  session->id_hdr_size));
+					  machine->id_hdr_size));
 	if (event == NULL) {
 		pr_debug("Not enough memory synthesizing mmap event "
 			 "for kernel modules\n");
@@ -424,13 +421,13 @@ int perf_event__synthesize_kernel_mmap(struct perf_event_ops *ops,
 	size = ALIGN(size, sizeof(u64));
 	event->mmap.header.type = PERF_RECORD_MMAP;
 	event->mmap.header.size = (sizeof(event->mmap) -
-			(sizeof(event->mmap.filename) - size) + session->id_hdr_size);
+			(sizeof(event->mmap.filename) - size) + machine->id_hdr_size);
 	event->mmap.pgoff = args.start;
 	event->mmap.start = map->start;
 	event->mmap.len   = map->end - event->mmap.start;
 	event->mmap.pid   = machine->pid;
 
-	err = process(ops, event, &synth_sample, session);
+	err = process(ops, event, &synth_sample, machine);
 	free(event);
 
 	return err;
@@ -439,9 +436,9 @@ int perf_event__synthesize_kernel_mmap(struct perf_event_ops *ops,
 int perf_event__process_comm(struct perf_event_ops *ops __used,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
-			     struct perf_session *session)
+			     struct machine *machine)
 {
-	struct thread *thread = perf_session__findnew(session, event->comm.tid);
+	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
 
 	dump_printf(": %s:%d\n", event->comm.comm, event->comm.tid);
 
@@ -456,11 +453,10 @@ int perf_event__process_comm(struct perf_event_ops *ops __used,
 int perf_event__process_lost(struct perf_event_ops *ops __used,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
-			     struct perf_session *session)
+			     struct machine *machine __used)
 {
 	dump_printf(": id:%" PRIu64 ": lost:%" PRIu64 "\n",
 		    event->lost.id, event->lost.lost);
-	session->hists.stats.total_lost += event->lost.lost;
 	return 0;
 }
 
@@ -479,20 +475,13 @@ static void perf_event__set_kernel_mmap_len(union perf_event *event,
 
 static int perf_event__process_kernel_mmap(struct perf_event_ops *ops __used,
 					   union perf_event *event,
-					   struct perf_session *session)
+					   struct machine *machine)
 {
 	struct map *map;
 	char kmmap_prefix[PATH_MAX];
-	struct machine *machine;
 	enum dso_kernel_type kernel_type;
 	bool is_kernel_mmap;
 
-	machine = perf_session__findnew_machine(session, event->mmap.pid);
-	if (!machine) {
-		pr_err("Can't find id %d's machine\n", event->mmap.pid);
-		goto out_problem;
-	}
-
 	machine__mmap_name(machine, kmmap_prefix, sizeof(kmmap_prefix));
 	if (machine__is_host(machine))
 		kernel_type = DSO_TYPE_KERNEL;
@@ -559,9 +548,9 @@ static int perf_event__process_kernel_mmap(struct perf_event_ops *ops __used,
 		 * time /proc/sys/kernel/kptr_restrict was non zero.
 		 */
 		if (event->mmap.pgoff != 0) {
-			perf_session__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps,
-								 symbol_name,
-								 event->mmap.pgoff);
+			maps__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps,
+							 symbol_name,
+							 event->mmap.pgoff);
 		}
 
 		if (machine__is_default_guest(machine)) {
@@ -580,9 +569,8 @@ out_problem:
 int perf_event__process_mmap(struct perf_event_ops *ops,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
-			     struct perf_session *session)
+			     struct machine *machine)
 {
-	struct machine *machine;
 	struct thread *thread;
 	struct map *map;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
@@ -594,16 +582,13 @@ int perf_event__process_mmap(struct perf_event_ops *ops,
 
 	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
 	    cpumode == PERF_RECORD_MISC_KERNEL) {
-		ret = perf_event__process_kernel_mmap(ops, event, session);
+		ret = perf_event__process_kernel_mmap(ops, event, machine);
 		if (ret < 0)
 			goto out_problem;
 		return 0;
 	}
 
-	machine = perf_session__find_host_machine(session);
-	if (machine == NULL)
-		goto out_problem;
-	thread = perf_session__findnew(session, event->mmap.pid);
+	thread = machine__findnew_thread(machine, event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
 	map = map__new(&machine->user_dsos, event->mmap.start,
@@ -624,16 +609,16 @@ out_problem:
 int perf_event__process_task(struct perf_event_ops *ops __used,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
-			     struct perf_session *session)
+			      struct machine *machine)
 {
-	struct thread *thread = perf_session__findnew(session, event->fork.tid);
-	struct thread *parent = perf_session__findnew(session, event->fork.ptid);
+	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
+	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
 
 	dump_printf("(%d:%d):(%d:%d)\n", event->fork.pid, event->fork.tid,
 		    event->fork.ppid, event->fork.ptid);
 
 	if (event->header.type == PERF_RECORD_EXIT) {
-		perf_session__remove_thread(session, thread);
+		machine__remove_thread(machine, thread);
 		return 0;
 	}
 
@@ -647,21 +632,21 @@ int perf_event__process_task(struct perf_event_ops *ops __used,
 }
 
 int perf_event__process(struct perf_event_ops *ops, union perf_event *event,
-			struct perf_sample *sample, struct perf_session *session)
+			struct perf_sample *sample, struct machine *machine)
 {
 	switch (event->header.type) {
 	case PERF_RECORD_COMM:
-		perf_event__process_comm(ops, event, sample, session);
+		perf_event__process_comm(ops, event, sample, machine);
 		break;
 	case PERF_RECORD_MMAP:
-		perf_event__process_mmap(ops, event, sample, session);
+		perf_event__process_mmap(ops, event, sample, machine);
 		break;
 	case PERF_RECORD_FORK:
 	case PERF_RECORD_EXIT:
-		perf_event__process_task(ops, event, sample, session);
+		perf_event__process_task(ops, event, sample, machine);
 		break;
 	case PERF_RECORD_LOST:
-		perf_event__process_lost(ops, event, sample, session);
+		perf_event__process_lost(ops, event, sample, machine);
 	default:
 		break;
 	}
@@ -670,36 +655,29 @@ int perf_event__process(struct perf_event_ops *ops, union perf_event *event,
 }
 
 void thread__find_addr_map(struct thread *self,
-			   struct perf_session *session, u8 cpumode,
-			   enum map_type type, pid_t pid, u64 addr,
+			   struct machine *machine, u8 cpumode,
+			   enum map_type type, u64 addr,
 			   struct addr_location *al)
 {
 	struct map_groups *mg = &self->mg;
-	struct machine *machine = NULL;
 
 	al->thread = self;
 	al->addr = addr;
 	al->cpumode = cpumode;
 	al->filtered = false;
 
+	if (machine == NULL) {
+		al->map = NULL;
+		return;
+	}
+
 	if (cpumode == PERF_RECORD_MISC_KERNEL && perf_host) {
 		al->level = 'k';
-		machine = perf_session__find_host_machine(session);
-		if (machine == NULL) {
-			al->map = NULL;
-			return;
-		}
 		mg = &machine->kmaps;
 	} else if (cpumode == PERF_RECORD_MISC_USER && perf_host) {
 		al->level = '.';
-		machine = perf_session__find_host_machine(session);
 	} else if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
 		al->level = 'g';
-		machine = perf_session__find_machine(session, pid);
-		if (machine == NULL) {
-			al->map = NULL;
-			return;
-		}
 		mg = &machine->kmaps;
 	} else {
 		/*
@@ -745,13 +723,12 @@ try_again:
 		al->addr = al->map->map_ip(al->map, al->addr);
 }
 
-void thread__find_addr_location(struct thread *self,
-				struct perf_session *session, u8 cpumode,
-				enum map_type type, pid_t pid, u64 addr,
+void thread__find_addr_location(struct thread *thread, struct machine *machine,
+				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al,
 				symbol_filter_t filter)
 {
-	thread__find_addr_map(self, session, cpumode, type, pid, addr, al);
+	thread__find_addr_map(thread, machine, cpumode, type, addr, al);
 	if (al->map != NULL)
 		al->sym = map__find_symbol(al->map, al->addr, filter);
 	else
@@ -759,13 +736,13 @@ void thread__find_addr_location(struct thread *self,
 }
 
 int perf_event__preprocess_sample(const union perf_event *event,
-				  struct perf_session *session,
+				  struct machine *machine,
 				  struct addr_location *al,
 				  struct perf_sample *sample,
 				  symbol_filter_t filter)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = perf_session__findnew(session, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
 
 	if (thread == NULL)
 		return -1;
@@ -776,18 +753,18 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 	/*
-	 * Have we already created the kernel maps for the host machine?
+	 * Have we already created the kernel maps for this machine?
 	 *
 	 * This should have happened earlier, when we processed the kernel MMAP
 	 * events, but for older perf.data files there was no such thing, so do
 	 * it now.
 	 */
 	if (cpumode == PERF_RECORD_MISC_KERNEL &&
-	    session->host_machine.vmlinux_maps[MAP__FUNCTION] == NULL)
-		machine__create_kernel_maps(&session->host_machine);
+	    machine->vmlinux_maps[MAP__FUNCTION] == NULL)
+		machine__create_kernel_maps(machine);
 
-	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
-			      event->ip.pid, event->ip.ip, al);
+	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
+			      event->ip.ip, al);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 669409d..1564877 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -142,56 +142,53 @@ union perf_event {
 void perf_event__print_totals(void);
 
 struct perf_event_ops;
-struct perf_session;
 struct thread_map;
 
 typedef int (*perf_event__handler_t)(struct perf_event_ops *ops,
 				     union perf_event *event,
 				     struct perf_sample *sample,
-				      struct perf_session *session);
+				     struct machine *machine);
 
 int perf_event__synthesize_thread_map(struct perf_event_ops *ops,
 				      struct thread_map *threads,
 				      perf_event__handler_t process,
-				      struct perf_session *session);
+				      struct machine *machine);
 int perf_event__synthesize_threads(struct perf_event_ops *ops,
 				   perf_event__handler_t process,
-				   struct perf_session *session);
+				   struct machine *machine);
 int perf_event__synthesize_kernel_mmap(struct perf_event_ops *ops,
 				       perf_event__handler_t process,
-				       struct perf_session *session,
 				       struct machine *machine,
 				       const char *symbol_name);
 
 int perf_event__synthesize_modules(struct perf_event_ops *ops,
 				   perf_event__handler_t process,
-				   struct perf_session *session,
 				   struct machine *machine);
 
 int perf_event__process_comm(struct perf_event_ops *ops,
 			     union perf_event *event,
 			     struct perf_sample *sample,
-			     struct perf_session *session);
+			     struct machine *machine);
 int perf_event__process_lost(struct perf_event_ops *ops,
 			     union perf_event *event,
 			     struct perf_sample *sample,
-			     struct perf_session *session);
+			     struct machine *machine);
 int perf_event__process_mmap(struct perf_event_ops *ops,
 			     union perf_event *event,
 			     struct perf_sample *sample,
-			     struct perf_session *session);
+			     struct machine *machine);
 int perf_event__process_task(struct perf_event_ops *ops,
 			     union perf_event *event,
 			     struct perf_sample *sample,
-			     struct perf_session *session);
+			     struct machine *machine);
 int perf_event__process(struct perf_event_ops *ops,
 			union perf_event *event,
 			struct perf_sample *sample,
-			struct perf_session *session);
+			struct machine *machine);
 
 struct addr_location;
 int perf_event__preprocess_sample(const union perf_event *self,
-				  struct perf_session *session,
+				  struct machine *machine,
 				  struct addr_location *al,
 				  struct perf_sample *sample,
 				  symbol_filter_t filter);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ab3a2b0..db280d6 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2072,8 +2072,7 @@ out_delete_evlist:
 
 int perf_event__synthesize_attr(struct perf_event_ops *ops,
 				struct perf_event_attr *attr, u16 ids, u64 *id,
-				perf_event__handler_t process,
-				struct perf_session *session)
+				perf_event__handler_t process)
 {
 	union perf_event *ev;
 	size_t size;
@@ -2095,7 +2094,7 @@ int perf_event__synthesize_attr(struct perf_event_ops *ops,
 	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
 	ev->attr.header.size = size;
 
-	err = process(ops, ev, NULL, session);
+	err = process(ops, ev, NULL, NULL);
 
 	free(ev);
 
@@ -2111,7 +2110,7 @@ int perf_event__synthesize_attrs(struct perf_event_ops *ops,
 
 	list_for_each_entry(attr, &session->evlist->entries, node) {
 		err = perf_event__synthesize_attr(ops, &attr->attr, attr->ids,
-						  attr->id, process, session);
+						  attr->id, process);
 		if (err) {
 			pr_debug("failed to create perf header attribute\n");
 			return err;
@@ -2161,7 +2160,7 @@ int perf_event__process_attr(union perf_event *event,
 int perf_event__synthesize_event_type(struct perf_event_ops *ops,
 				      u64 event_id, char *name,
 				      perf_event__handler_t process,
-				      struct perf_session *session)
+				      struct machine *machine)
 {
 	union perf_event ev;
 	size_t size = 0;
@@ -2179,14 +2178,14 @@ int perf_event__synthesize_event_type(struct perf_event_ops *ops,
 	ev.event_type.header.size = sizeof(ev.event_type) -
 		(sizeof(ev.event_type.event_type.name) - size);
 
-	err = process(ops, &ev, NULL, session);
+	err = process(ops, &ev, NULL, machine);
 
 	return err;
 }
 
 int perf_event__synthesize_event_types(struct perf_event_ops *ops,
 				       perf_event__handler_t process,
-				       struct perf_session *session)
+				       struct machine *machine)
 {
 	struct perf_trace_event_type *type;
 	int i, err = 0;
@@ -2196,7 +2195,7 @@ int perf_event__synthesize_event_types(struct perf_event_ops *ops,
 
 		err = perf_event__synthesize_event_type(ops, type->event_id,
 							type->name, process,
-							session);
+							machine);
 		if (err) {
 			pr_debug("failed to create perf header event type\n");
 			return err;
@@ -2207,8 +2206,7 @@ int perf_event__synthesize_event_types(struct perf_event_ops *ops,
 }
 
 int perf_event__process_event_type(struct perf_event_ops *ops __unused,
-				   union perf_event *event,
-				   struct perf_session *session __unused)
+				   union perf_event *event)
 {
 	if (perf_header__push_event(event->event_type.event_type.event_id,
 				    event->event_type.event_type.name) < 0)
@@ -2219,8 +2217,7 @@ int perf_event__process_event_type(struct perf_event_ops *ops __unused,
 
 int perf_event__synthesize_tracing_data(struct perf_event_ops *ops, int fd,
 					struct perf_evlist *evlist,
-					 perf_event__handler_t process,
-				   struct perf_session *session __unused)
+					perf_event__handler_t process)
 {
 	union perf_event ev;
 	struct tracing_data *tdata;
@@ -2251,7 +2248,7 @@ int perf_event__synthesize_tracing_data(struct perf_event_ops *ops, int fd,
 	ev.tracing_data.header.size = sizeof(ev.tracing_data);
 	ev.tracing_data.size = aligned_size;
 
-	process(ops, &ev, NULL, session);
+	process(ops, &ev, NULL, NULL);
 
 	/*
 	 * The put function will copy all the tracing data
@@ -2296,8 +2293,7 @@ int perf_event__process_tracing_data(union perf_event *event,
 int perf_event__synthesize_build_id(struct perf_event_ops *ops,
 				    struct dso *pos, u16 misc,
 				    perf_event__handler_t process,
-				    struct machine *machine,
-				    struct perf_session *session)
+				    struct machine *machine)
 {
 	union perf_event ev;
 	size_t len;
@@ -2317,7 +2313,7 @@ int perf_event__synthesize_build_id(struct perf_event_ops *ops,
 	ev.build_id.header.size = sizeof(ev.build_id) + len;
 	memcpy(&ev.build_id.filename, pos->long_name, pos->long_name_len);
 
-	err = process(ops, &ev, NULL, session);
+	err = process(ops, &ev, NULL, machine);
 
 	return err;
 }
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 54dae5f..a604962 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -99,8 +99,7 @@ int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 
 int perf_event__synthesize_attr(struct perf_event_ops *ops,
 				struct perf_event_attr *attr, u16 ids, u64 *id,
-				perf_event__handler_t process,
-				struct perf_session *session);
+				perf_event__handler_t process);
 int perf_event__synthesize_attrs(struct perf_event_ops *ops,
 				 struct perf_session *session,
 				 perf_event__handler_t process);
@@ -109,26 +108,23 @@ int perf_event__process_attr(union perf_event *event, struct perf_evlist **pevli
 int perf_event__synthesize_event_type(struct perf_event_ops *ops,
 				      u64 event_id, char *name,
 				      perf_event__handler_t process,
-				      struct perf_session *session);
+				      struct machine *machine);
 int perf_event__synthesize_event_types(struct perf_event_ops *ops,
 				       perf_event__handler_t process,
-				       struct perf_session *session);
+				       struct machine *machine);
 int perf_event__process_event_type(struct perf_event_ops *ops,
-				   union perf_event *event,
-				   struct perf_session *session);
+				   union perf_event *event);
 
 int perf_event__synthesize_tracing_data(struct perf_event_ops *ops,
 					int fd, struct perf_evlist *evlist,
-					perf_event__handler_t process,
-					struct perf_session *session);
+					perf_event__handler_t process);
 int perf_event__process_tracing_data(union perf_event *event,
 				     struct perf_session *session);
 
 int perf_event__synthesize_build_id(struct perf_event_ops *ops,
 				    struct dso *pos, u16 misc,
 				    perf_event__handler_t process,
-				    struct machine *machine,
-				    struct perf_session *session);
+				    struct machine *machine);
 int perf_event__process_build_id(struct perf_event_ops *ops,
 				 union perf_event *event,
 				 struct perf_session *session);
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index bde6835..2b8017f 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -18,9 +18,11 @@ enum map_type {
 extern const char *map_type__name[MAP__NR_TYPES];
 
 struct dso;
+struct ip_callchain;
 struct ref_reloc_sym;
 struct map_groups;
 struct machine;
+struct perf_evsel;
 
 struct map {
 	union {
@@ -61,6 +63,7 @@ struct map_groups {
 struct machine {
 	struct rb_node	  rb_node;
 	pid_t		  pid;
+	u16		  id_hdr_size;
 	char		  *root_dir;
 	struct rb_root	  threads;
 	struct list_head  dead_threads;
@@ -151,6 +154,13 @@ int machine__init(struct machine *self, const char *root_dir, pid_t pid);
 void machine__exit(struct machine *self);
 void machine__delete(struct machine *self);
 
+int machine__resolve_callchain(struct machine *machine,
+			       struct perf_evsel *evsel, struct thread *thread,
+			       struct ip_callchain *chain,
+			       struct symbol **parent);
+int maps__set_kallsyms_ref_reloc_sym(struct map **maps, const char *symbol_name,
+				     u64 addr);
+
 /*
  * Default guest kernel is defined by parameter --guestkallsyms
  * and --guestmodules
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 74350ff..a82ce43 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -27,6 +27,8 @@
 
 #include "../../perf.h"
 #include "../util.h"
+#include "../thread.h"
+#include "../event.h"
 #include "../trace-event.h"
 
 #include <EXTERN.h>
@@ -248,7 +250,7 @@ static inline struct event *find_cache_event(int type)
 static void perl_process_event(union perf_event *pevent __unused,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
-			       struct perf_session *session __unused,
+			       struct machine *machine __unused,
 			       struct thread *thread)
 {
 	struct format_field *field;
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 6ccf70e..0b2a487 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -29,6 +29,8 @@
 
 #include "../../perf.h"
 #include "../util.h"
+#include "../event.h"
+#include "../thread.h"
 #include "../trace-event.h"
 
 PyMODINIT_FUNC initperf_trace_context(void);
@@ -207,7 +209,7 @@ static inline struct event *find_cache_event(int type)
 static void python_process_event(union perf_event *pevent __unused,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel __unused,
-				 struct perf_session *session __unused,
+				 struct machine *machine __unused,
 				 struct thread *thread)
 {
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a36023a..be33606 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -84,6 +84,7 @@ void perf_session__update_sample_type(struct perf_session *self)
 	self->sample_size = __perf_evsel__sample_size(self->sample_type);
 	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	self->id_hdr_size = perf_evlist__id_hdr_size(self->evlist);
+	self->host_machine.id_hdr_size = self->id_hdr_size;
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
@@ -216,10 +217,10 @@ static bool symbol__match_parent_regex(struct symbol *sym)
 	return 0;
 }
 
-int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel *evsel,
-				    struct thread *thread,
-				    struct ip_callchain *chain,
-				    struct symbol **parent)
+int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
+			       struct thread *thread,
+			       struct ip_callchain *chain,
+			       struct symbol **parent)
 {
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	unsigned int i;
@@ -252,7 +253,7 @@ int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel
 
 		al.filtered = false;
 		thread__find_addr_location(thread, self, cpumode,
-				MAP__FUNCTION, thread->pid, ip, &al, NULL);
+					   MAP__FUNCTION, ip, &al, NULL);
 		if (al.sym != NULL) {
 			if (sort__has_parent && !*parent &&
 			    symbol__match_parent_regex(al.sym))
@@ -270,14 +271,6 @@ int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel
 	return 0;
 }
 
-static int process_event_synth_stub(struct perf_event_ops *ops __used,
-				    union perf_event *event __used,
-				    struct perf_session *session __used)
-{
-	dump_printf(": unhandled!\n");
-	return 0;
-}
-
 static int process_event_synth_tracing_data_stub(union perf_event *event __used,
 						 struct perf_session *session __used)
 {
@@ -296,7 +289,7 @@ static int process_event_sample_stub(struct perf_event_ops *ops __used,
 				     union perf_event *event __used,
 				     struct perf_sample *sample __used,
 				     struct perf_evsel *evsel __used,
-				     struct perf_session *session __used)
+				     struct machine *machine __used)
 {
 	dump_printf(": unhandled!\n");
 	return 0;
@@ -305,7 +298,7 @@ static int process_event_sample_stub(struct perf_event_ops *ops __used,
 static int process_event_stub(struct perf_event_ops *ops __used,
 			      union perf_event *event __used,
 			      struct perf_sample *sample __used,
-			      struct perf_session *session __used)
+			      struct machine *machine __used)
 {
 	dump_printf(": unhandled!\n");
 	return 0;
@@ -313,7 +306,14 @@ static int process_event_stub(struct perf_event_ops *ops __used,
 
 static int process_finished_round_stub(struct perf_event_ops *ops __used,
 				       union perf_event *event __used,
-				       struct perf_session *session __used)
+				       struct perf_session *perf_session __used)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
+static int process_event_type_stub(struct perf_event_ops *ops __used,
+				   union perf_event *event __used)
 {
 	dump_printf(": unhandled!\n");
 	return 0;
@@ -338,7 +338,7 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 	if (handler->lost == NULL)
 		handler->lost = perf_event__process_lost;
 	if (handler->read == NULL)
-		handler->read = process_event_stub;
+		handler->read = process_event_sample_stub;
 	if (handler->throttle == NULL)
 		handler->throttle = process_event_stub;
 	if (handler->unthrottle == NULL)
@@ -346,11 +346,11 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 	if (handler->attr == NULL)
 		handler->attr = process_event_synth_attr_stub;
 	if (handler->event_type == NULL)
-		handler->event_type = process_event_synth_stub;
+		handler->event_type = process_event_type_stub;
 	if (handler->tracing_data == NULL)
 		handler->tracing_data = process_event_synth_tracing_data_stub;
 	if (handler->build_id == NULL)
-		handler->build_id = process_event_synth_stub;
+		handler->build_id = process_finished_round_stub;
 	if (handler->finished_round == NULL) {
 		if (handler->ordered_samples)
 			handler->finished_round = process_finished_round;
@@ -734,6 +734,18 @@ static void dump_sample(struct perf_session *session, union perf_event *event,
 		callchain__printf(sample);
 }
 
+static struct machine *
+	perf_session__find_machine_for_cpumode(struct perf_session *session,
+					       union perf_event *event)
+{
+	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+
+	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest)
+		return perf_session__find_machine(session, event->ip.pid);
+
+	return perf_session__find_host_machine(session);
+}
+
 static int perf_session_deliver_event(struct perf_session *session,
 				      union perf_event *event,
 				      struct perf_sample *sample,
@@ -741,6 +753,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      u64 file_offset)
 {
 	struct perf_evsel *evsel;
+	struct machine *machine;
 
 	dump_event(session, event, file_offset, sample);
 
@@ -762,6 +775,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 		hists__inc_nr_events(&evsel->hists, event->header.type);
 	}
 
+	machine = perf_session__find_machine_for_cpumode(session, event);
+
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
 		dump_sample(session, event, sample);
@@ -769,23 +784,25 @@ static int perf_session_deliver_event(struct perf_session *session,
 			++session->hists.stats.nr_unknown_id;
 			return -1;
 		}
-		return ops->sample(ops, event, sample, evsel, session);
+		return ops->sample(ops, event, sample, evsel, machine);
 	case PERF_RECORD_MMAP:
-		return ops->mmap(ops, event, sample, session);
+		return ops->mmap(ops, event, sample, machine);
 	case PERF_RECORD_COMM:
-		return ops->comm(ops, event, sample, session);
+		return ops->comm(ops, event, sample, machine);
 	case PERF_RECORD_FORK:
-		return ops->fork(ops, event, sample, session);
+		return ops->fork(ops, event, sample, machine);
 	case PERF_RECORD_EXIT:
-		return ops->exit(ops, event, sample, session);
+		return ops->exit(ops, event, sample, machine);
 	case PERF_RECORD_LOST:
-		return ops->lost(ops, event, sample, session);
+		if (ops->lost == perf_event__process_lost)
+			session->hists.stats.total_lost += event->lost.lost;
+		return ops->lost(ops, event, sample, machine);
 	case PERF_RECORD_READ:
-		return ops->read(ops, event, sample, session);
+		return ops->read(ops, event, sample, evsel, machine);
 	case PERF_RECORD_THROTTLE:
-		return ops->throttle(ops, event, sample, session);
+		return ops->throttle(ops, event, sample, machine);
 	case PERF_RECORD_UNTHROTTLE:
-		return ops->unthrottle(ops, event, sample, session);
+		return ops->unthrottle(ops, event, sample, machine);
 	default:
 		++session->hists.stats.nr_unknown_events;
 		return -1;
@@ -823,7 +840,7 @@ static int perf_session__process_user_event(struct perf_session *session, union
 			perf_session__update_sample_type(session);
 		return err;
 	case PERF_RECORD_HEADER_EVENT_TYPE:
-		return ops->event_type(ops, event, session);
+		return ops->event_type(ops, event);
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
 		lseek(session->fd, file_offset, SEEK_SET);
@@ -1170,9 +1187,8 @@ bool perf_session__has_traces(struct perf_session *self, const char *msg)
 	return true;
 }
 
-int perf_session__set_kallsyms_ref_reloc_sym(struct map **maps,
-					     const char *symbol_name,
-					     u64 addr)
+int maps__set_kallsyms_ref_reloc_sym(struct map **maps,
+				     const char *symbol_name, u64 addr)
 {
 	char *bracket;
 	enum map_type i;
@@ -1264,17 +1280,16 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 	return NULL;
 }
 
-void perf_session__print_ip(union perf_event *event, struct perf_evsel *evsel,
-			    struct perf_sample *sample,
-			    struct perf_session *session,
-			    int print_sym, int print_dso)
+void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
+			  struct machine *machine, struct perf_evsel *evsel,
+			  int print_sym, int print_dso)
 {
 	struct addr_location al;
 	const char *symname, *dsoname;
 	struct callchain_cursor *cursor = &evsel->hists.callchain_cursor;
 	struct callchain_cursor_node *node;
 
-	if (perf_event__preprocess_sample(event, session, &al, sample,
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
 					  NULL) < 0) {
 		error("problem processing %d event, skipping it.\n",
 			event->header.type);
@@ -1283,7 +1298,7 @@ void perf_session__print_ip(union perf_event *event, struct perf_evsel *evsel,
 
 	if (symbol_conf.use_callchain && sample->callchain) {
 
-		if (perf_session__resolve_callchain(session, evsel, al.thread,
+		if (machine__resolve_callchain(machine, evsel, al.thread,
 						sample->callchain, NULL) != 0) {
 			if (verbose)
 				error("Failed to resolve callchain. Skipping\n");
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 6de3d13..1c5823c 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -58,32 +58,34 @@ struct perf_event_ops;
 
 typedef int (*event_sample)(struct perf_event_ops *ops,
 			    union perf_event *event, struct perf_sample *sample,
-			    struct perf_evsel *evsel, struct perf_session *session);
+			    struct perf_evsel *evsel, struct machine *machine);
 typedef int (*event_op)(struct perf_event_ops *ops, union perf_event *event,
 			struct perf_sample *sample,
-			struct perf_session *session);
+			struct machine *machine);
 typedef int (*event_synth_op)(union perf_event *self,
 			      struct perf_session *session);
 typedef int (*event_attr_op)(union perf_event *event,
 			     struct perf_evlist **pevlist);
+typedef int (*event_simple_op)(struct perf_event_ops *ops,
+			       union perf_event *event);
 typedef int (*event_op2)(struct perf_event_ops *ops, union perf_event *event,
 			 struct perf_session *session);
 
 struct perf_event_ops {
-	event_sample	sample;
+	event_sample	sample,
+			read;
 	event_op	mmap,
 			comm,
 			fork,
 			exit,
 			lost,
-			read,
 			throttle,
 			unthrottle;
 	event_attr_op	attr;
 	event_synth_op	tracing_data;
-	event_op2	event_type,
-			build_id,
-			finished_round;
+	event_simple_op	event_type;
+	event_op2	finished_round,
+			build_id;
 	bool		ordered_samples;
 	bool		ordering_requires_timestamps;
 };
@@ -108,10 +110,6 @@ int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel
 
 bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
-int perf_session__set_kallsyms_ref_reloc_sym(struct map **maps,
-					     const char *symbol_name,
-					     u64 addr);
-
 void mem_bswap_64(void *src, int byte_size);
 void perf_event__attr_swap(struct perf_event_attr *attr);
 
@@ -151,6 +149,9 @@ void perf_session__process_machines(struct perf_session *self,
 	return machines__process(&self->machines, process, ops);
 }
 
+struct thread *perf_session__findnew(struct perf_session *self, pid_t pid);
+size_t perf_session__fprintf(struct perf_session *self, FILE *fp);
+
 size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp);
 
 size_t perf_session__fprintf_dsos_buildid(struct perf_session *self,
@@ -171,10 +172,9 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
-void perf_session__print_ip(union perf_event *event, struct perf_evsel *evsel,
-				 struct perf_sample *sample,
-				 struct perf_session *session,
-				 int print_sym, int print_dso);
+void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
+			  struct machine *machine, struct perf_evsel *evsel,
+			  int print_sym, int print_dso);
 
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index e5f2401..70c2c13 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -18,16 +18,14 @@ struct thread {
 	int			comm_len;
 };
 
-struct perf_session;
+struct machine;
 
 void thread__delete(struct thread *self);
 
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
-struct thread *perf_session__findnew(struct perf_session *self, pid_t pid);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
-size_t perf_session__fprintf(struct perf_session *self, FILE *fp);
 
 static inline struct map *thread__find_map(struct thread *self,
 					   enum map_type type, u64 addr)
@@ -35,14 +33,12 @@ static inline struct map *thread__find_map(struct thread *self,
 	return self ? map_groups__find(&self->mg, type, addr) : NULL;
 }
 
-void thread__find_addr_map(struct thread *self,
-			   struct perf_session *session, u8 cpumode,
-			   enum map_type type, pid_t pid, u64 addr,
+void thread__find_addr_map(struct thread *thread, struct machine *machine,
+			   u8 cpumode, enum map_type type, u64 addr,
 			   struct addr_location *al);
 
-void thread__find_addr_location(struct thread *self,
-				struct perf_session *session, u8 cpumode,
-				enum map_type type, pid_t pid, u64 addr,
+void thread__find_addr_location(struct thread *thread, struct machine *machine,
+				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al,
 				symbol_filter_t filter);
 #endif	/* __PERF_THREAD_H */
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index c9dcbec..a3fdf55 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -39,7 +39,7 @@ static int stop_script_unsupported(void)
 static void process_event_unsupported(union perf_event *event __unused,
 				      struct perf_sample *sample __unused,
 				      struct perf_evsel *evsel __unused,
-				      struct perf_session *session __unused,
+				      struct machine *machine __unused,
 				      struct thread *thread __unused)
 {
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index a841008..58ae14c 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -3,7 +3,11 @@
 
 #include <stdbool.h>
 #include "parse-events.h"
-#include "session.h"
+
+struct machine;
+struct perf_sample;
+union perf_event;
+struct thread;
 
 #define __unused __attribute__((unused))
 
@@ -292,7 +296,7 @@ struct scripting_ops {
 	void (*process_event) (union perf_event *event,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
-			       struct perf_session *session,
+			       struct machine *machine,
 			       struct thread *thread);
 	int (*generate_script) (const char *outfile);
 };
