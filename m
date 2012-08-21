Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2HUPY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:24:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2HUPYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:24:49 -0400
Date: Tue, 21 Aug 2012 08:24:28 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-2hsr1686epa9f0vx4yg7z2zj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Stop using pevent directly
Git-Commit-ID: 9782243353ec135327a80c76c63464e592949cd1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:24:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9782243353ec135327a80c76c63464e592949cd1
Gitweb:     http://git.kernel.org/tip/9782243353ec135327a80c76c63464e592949cd1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 7 Aug 2012 23:50:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 7 Aug 2012 23:50:21 -0300

perf script: Stop using pevent directly

We can get all that is needed using just event_format, that is available
via evsel->tp_format now.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2hsr1686epa9f0vx4yg7z2zj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c                        |   48 +++++++-------------
 .../perf/util/scripting-engines/trace-event-perl.c |   14 +++---
 .../util/scripting-engines/trace-event-python.c    |    5 +-
 tools/perf/util/trace-event-parse.c                |    4 +-
 tools/perf/util/trace-event-scripting.c            |    1 -
 tools/perf/util/trace-event.h                      |    3 +-
 6 files changed, 28 insertions(+), 47 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 8dba470..6425612 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -28,11 +28,6 @@ static bool			system_wide;
 static const char		*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
-struct perf_script {
-	struct perf_tool    tool;
-	struct perf_session *session;
-};
-
 enum perf_output_field {
 	PERF_OUTPUT_COMM            = 1U << 0,
 	PERF_OUTPUT_TID             = 1U << 1,
@@ -399,11 +394,8 @@ static void print_sample_bts(union perf_event *event,
 	printf("\n");
 }
 
-static void process_event(union perf_event *event __unused,
-			  struct pevent *pevent __unused,
-			  struct perf_sample *sample,
-			  struct perf_evsel *evsel,
-			  struct machine *machine,
+static void process_event(union perf_event *event, struct perf_sample *sample,
+			  struct perf_evsel *evsel, struct machine *machine,
 			  struct thread *thread)
 {
 	struct perf_event_attr *attr = &evsel->attr;
@@ -488,7 +480,6 @@ static int process_sample_event(struct perf_tool *tool __used,
 				struct machine *machine)
 {
 	struct addr_location al;
-	struct perf_script *scr = container_of(tool, struct perf_script, tool);
 	struct thread *thread = machine__findnew_thread(machine, event->ip.tid);
 
 	if (thread == NULL) {
@@ -520,27 +511,24 @@ static int process_sample_event(struct perf_tool *tool __used,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	scripting_ops->process_event(event, scr->session->pevent,
-				     sample, evsel, machine, thread);
+	scripting_ops->process_event(event, sample, evsel, machine, thread);
 
 	evsel->hists.stats.total_period += sample->period;
 	return 0;
 }
 
-static struct perf_script perf_script = {
-	.tool = {
-		.sample		 = process_sample_event,
-		.mmap		 = perf_event__process_mmap,
-		.comm		 = perf_event__process_comm,
-		.exit		 = perf_event__process_task,
-		.fork		 = perf_event__process_task,
-		.attr		 = perf_event__process_attr,
-		.event_type	 = perf_event__process_event_type,
-		.tracing_data	 = perf_event__process_tracing_data,
-		.build_id	 = perf_event__process_build_id,
-		.ordered_samples = true,
-		.ordering_requires_timestamps = true,
-	},
+static struct perf_tool perf_script = {
+	.sample		 = process_sample_event,
+	.mmap		 = perf_event__process_mmap,
+	.comm		 = perf_event__process_comm,
+	.exit		 = perf_event__process_task,
+	.fork		 = perf_event__process_task,
+	.attr		 = perf_event__process_attr,
+	.event_type	 = perf_event__process_event_type,
+	.tracing_data	 = perf_event__process_tracing_data,
+	.build_id	 = perf_event__process_build_id,
+	.ordered_samples = true,
+	.ordering_requires_timestamps = true,
 };
 
 extern volatile int session_done;
@@ -556,7 +544,7 @@ static int __cmd_script(struct perf_session *session)
 
 	signal(SIGINT, sig_handler);
 
-	ret = perf_session__process_events(session, &perf_script.tool);
+	ret = perf_session__process_events(session, &perf_script);
 
 	if (debug_mode)
 		pr_err("Misordered timestamps: %" PRIu64 "\n", nr_unordered);
@@ -1339,12 +1327,10 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		setup_pager();
 
 	session = perf_session__new(input_name, O_RDONLY, 0, false,
-				    &perf_script.tool);
+				    &perf_script);
 	if (session == NULL)
 		return -ENOMEM;
 
-	perf_script.session = session;
-
 	if (cpu_list) {
 		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
 			return -1;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index c266281..52580d0 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -258,7 +258,6 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
 }
 
 static void perl_process_tracepoint(union perf_event *perf_event __unused,
-				    struct pevent *pevent,
 				    struct perf_sample *sample,
 				    struct perf_evsel *evsel,
 				    struct machine *machine __unused,
@@ -284,7 +283,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 	if (!event)
 		die("ug! no event found for type %d", evsel->attr.config);
 
-	pid = trace_parse_common_pid(pevent, data);
+	pid = raw_field_value(event, "common_pid", data);
 
 	sprintf(handler, "%s::%s", event->system, event->name);
 
@@ -317,7 +316,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 				offset = field->offset;
 			XPUSHs(sv_2mortal(newSVpv((char *)data + offset, 0)));
 		} else { /* FIELD_IS_NUMERIC */
-			val = read_size(pevent, data + field->offset,
+			val = read_size(event, data + field->offset,
 					field->size);
 			if (field->flags & FIELD_IS_SIGNED) {
 				XPUSHs(sv_2mortal(newSViv(val)));
@@ -346,9 +345,9 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 	LEAVE;
 }
 
-static void perl_process_event_generic(union perf_event *pevent __unused,
+static void perl_process_event_generic(union perf_event *event,
 				       struct perf_sample *sample,
-				       struct perf_evsel *evsel __unused,
+				       struct perf_evsel *evsel,
 				       struct machine *machine __unused,
 				       struct thread *thread __unused)
 {
@@ -360,7 +359,7 @@ static void perl_process_event_generic(union perf_event *pevent __unused,
 	ENTER;
 	SAVETMPS;
 	PUSHMARK(SP);
-	XPUSHs(sv_2mortal(newSVpvn((const char *)pevent, pevent->header.size)));
+	XPUSHs(sv_2mortal(newSVpvn((const char *)event, event->header.size)));
 	XPUSHs(sv_2mortal(newSVpvn((const char *)&evsel->attr, sizeof(evsel->attr))));
 	XPUSHs(sv_2mortal(newSVpvn((const char *)sample, sizeof(*sample))));
 	XPUSHs(sv_2mortal(newSVpvn((const char *)sample->raw_data, sample->raw_size)));
@@ -373,13 +372,12 @@ static void perl_process_event_generic(union perf_event *pevent __unused,
 }
 
 static void perl_process_event(union perf_event *event,
-			       struct pevent *pevent,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
 			       struct thread *thread)
 {
-	perl_process_tracepoint(event, pevent, sample, evsel, machine, thread);
+	perl_process_tracepoint(event, sample, evsel, machine, thread);
 	perl_process_event_generic(event, sample, evsel, machine, thread);
 }
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 8006978..df7d33d 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -221,7 +221,6 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
 }
 
 static void python_process_event(union perf_event *perf_event __unused,
-				 struct pevent *pevent,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine __unused,
@@ -248,7 +247,7 @@ static void python_process_event(union perf_event *perf_event __unused,
 	if (!event)
 		die("ug! no event found for type %d", (int)evsel->attr.config);
 
-	pid = trace_parse_common_pid(pevent, data);
+	pid = raw_field_value(event, "common_pid", data);
 
 	sprintf(handler_name, "%s__%s", event->system, event->name);
 
@@ -293,7 +292,7 @@ static void python_process_event(union perf_event *perf_event __unused,
 				offset = field->offset;
 			obj = PyString_FromString((char *)data + offset);
 		} else { /* FIELD_IS_NUMERIC */
-			val = read_size(pevent, data + field->offset,
+			val = read_size(event, data + field->offset,
 					field->size);
 			if (field->flags & FIELD_IS_SIGNED) {
 				if ((long long)val >= LONG_MIN &&
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 1208834..4cb7f38 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -162,9 +162,9 @@ int trace_parse_common_pid(struct pevent *pevent, void *data)
 	return pevent_data_pid(pevent, &record);
 }
 
-unsigned long long read_size(struct pevent *pevent, void *ptr, int size)
+unsigned long long read_size(struct event_format *event, void *ptr, int size)
 {
-	return pevent_read_number(pevent, ptr, size);
+	return pevent_read_number(event->pevent, ptr, size);
 }
 
 void event_format__print(struct event_format *event,
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 474aa7a..aceb8ee 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -36,7 +36,6 @@ static int stop_script_unsupported(void)
 }
 
 static void process_event_unsupported(union perf_event *event __unused,
-				      struct pevent *pevent __unused,
 				      struct perf_sample *sample __unused,
 				      struct perf_evsel *evsel __unused,
 				      struct machine *machine __unused,
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 069d105..cee1635 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -58,7 +58,7 @@ int trace_parse_common_pid(struct pevent *pevent, void *data);
 
 struct event_format *trace_find_next_event(struct pevent *pevent,
 					   struct event_format *event);
-unsigned long long read_size(struct pevent *pevent, void *ptr, int size);
+unsigned long long read_size(struct event_format *event, void *ptr, int size);
 unsigned long long eval_flag(const char *flag);
 
 struct pevent_record *trace_read_data(struct pevent *pevent, int cpu);
@@ -81,7 +81,6 @@ struct scripting_ops {
 	int (*start_script) (const char *script, int argc, const char **argv);
 	int (*stop_script) (void);
 	void (*process_event) (union perf_event *event,
-			       struct pevent *pevent,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
