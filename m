Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2HUPVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:21:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59638 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2HUPVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:21:31 -0400
Date: Tue, 21 Aug 2012 08:20:46 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-txkvew2ckko0b594ae8fbnyk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org, efault@gmx.de,
        namhyung@gmail.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, avagin@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, efault@gmx.de, peterz@infradead.org,
        namhyung@gmail.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, avagin@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Cache associated event_format
Git-Commit-ID: fcf65bf149afa91b875ffde4455967cb63ee0be9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:20:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fcf65bf149afa91b875ffde4455967cb63ee0be9
Gitweb:     http://git.kernel.org/tip/fcf65bf149afa91b875ffde4455967cb63ee0be9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 7 Aug 2012 09:58:03 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 7 Aug 2012 23:43:37 -0300

perf evsel: Cache associated event_format

We already lookup the associated event_format when reading the perf.data
header, so that we can cache the tracepoint name in evsel->name, so do
it a little further and save the event_format itself, so that we can
avoid relookups in tools that need to access it.

Change the tools to take the most obvious advantage, when they were
using pevent_find_event directly. More work is needed for further
removing the need of a pointer to pevent, such as when asking for event
field values ("common_pid" and the other common fields and per
event_format fields).

This is something that was planned but only got actually done when
Andrey Wagin needed to do this lookup at perf_tool->sample() time, when
we don't have access to pevent (session->pevent) to use with
pevent_find_event().

Cc: Andrey Wagin <avagin@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/n/tip-txkvew2ckko0b594ae8fbnyk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c                          |   39 ++++++--------------
 tools/perf/builtin-lock.c                          |   15 +++-----
 tools/perf/builtin-sched.c                         |   37 +++++--------------
 tools/perf/builtin-script.c                        |   29 +++------------
 tools/perf/util/evsel.h                            |    1 +
 tools/perf/util/header.c                           |    1 +
 .../perf/util/scripting-engines/trace-event-perl.c |   13 +++----
 .../util/scripting-engines/trace-event-python.c    |   21 ++++++-----
 tools/perf/util/trace-event-parse.c                |   26 ++++++++------
 tools/perf/util/trace-event.h                      |    2 +
 10 files changed, 70 insertions(+), 114 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index ce35015..ffb93f4 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -1,6 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
+#include "util/evsel.h"
 #include "util/util.h"
 #include "util/cache.h"
 #include "util/symbol.h"
@@ -57,11 +58,6 @@ static unsigned long nr_allocs, nr_cross_allocs;
 
 #define PATH_SYS_NODE	"/sys/devices/system/node"
 
-struct perf_kmem {
-	struct perf_tool    tool;
-	struct perf_session *session;
-};
-
 static void init_cpunode_map(void)
 {
 	FILE *fp;
@@ -283,16 +279,10 @@ static void process_free_event(void *data,
 	s_alloc->alloc_cpu = -1;
 }
 
-static void process_raw_event(struct perf_tool *tool,
-			      union perf_event *raw_event __used, void *data,
+static void process_raw_event(struct perf_evsel *evsel, void *data,
 			      int cpu, u64 timestamp, struct thread *thread)
 {
-	struct perf_kmem *kmem = container_of(tool, struct perf_kmem, tool);
-	struct event_format *event;
-	int type;
-
-	type = trace_parse_common_type(kmem->session->pevent, data);
-	event = pevent_find_event(kmem->session->pevent, type);
+	struct event_format *event = evsel->tp_format;
 
 	if (!strcmp(event->name, "kmalloc") ||
 	    !strcmp(event->name, "kmem_cache_alloc")) {
@@ -313,10 +303,10 @@ static void process_raw_event(struct perf_tool *tool,
 	}
 }
 
-static int process_sample_event(struct perf_tool *tool,
+static int process_sample_event(struct perf_tool *tool __used,
 				union perf_event *event,
 				struct perf_sample *sample,
-				struct perf_evsel *evsel __used,
+				struct perf_evsel *evsel,
 				struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
@@ -329,18 +319,16 @@ static int process_sample_event(struct perf_tool *tool,
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	process_raw_event(tool, event, sample->raw_data, sample->cpu,
+	process_raw_event(evsel, sample->raw_data, sample->cpu,
 			  sample->time, thread);
 
 	return 0;
 }
 
-static struct perf_kmem perf_kmem = {
-	.tool = {
-		.sample			= process_sample_event,
-		.comm			= perf_event__process_comm,
-		.ordered_samples	= true,
-	},
+static struct perf_tool perf_kmem = {
+	.sample		 = process_sample_event,
+	.comm		 = perf_event__process_comm,
+	.ordered_samples = true,
 };
 
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
@@ -497,13 +485,10 @@ static int __cmd_kmem(void)
 	int err = -EINVAL;
 	struct perf_session *session;
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false,
-				    &perf_kmem.tool);
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &perf_kmem);
 	if (session == NULL)
 		return -ENOMEM;
 
-	perf_kmem.session = session;
-
 	if (perf_session__create_kernel_maps(session) < 0)
 		goto out_delete;
 
@@ -511,7 +496,7 @@ static int __cmd_kmem(void)
 		goto out_delete;
 
 	setup_pager();
-	err = perf_session__process_events(session, &perf_kmem.tool);
+	err = perf_session__process_events(session, &perf_kmem);
 	if (err != 0)
 		goto out_delete;
 	sort_result();
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index b3c4285..142b303 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1,6 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
+#include "util/evsel.h"
 #include "util/util.h"
 #include "util/cache.h"
 #include "util/symbol.h"
@@ -718,14 +719,10 @@ process_lock_release_event(void *data,
 		trace_handler->release_event(&release_event, event, cpu, timestamp, thread);
 }
 
-static void
-process_raw_event(void *data, int cpu, u64 timestamp, struct thread *thread)
+static void process_raw_event(struct perf_evsel *evsel, void *data, int cpu,
+			      u64 timestamp, struct thread *thread)
 {
-	struct event_format *event;
-	int type;
-
-	type = trace_parse_common_type(session->pevent, data);
-	event = pevent_find_event(session->pevent, type);
+	struct event_format *event = evsel->tp_format;
 
 	if (!strcmp(event->name, "lock_acquire"))
 		process_lock_acquire_event(data, event, cpu, timestamp, thread);
@@ -849,7 +846,7 @@ static void dump_info(void)
 static int process_sample_event(struct perf_tool *tool __used,
 				union perf_event *event,
 				struct perf_sample *sample,
-				struct perf_evsel *evsel __used,
+				struct perf_evsel *evsel,
 				struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, sample->tid);
@@ -860,7 +857,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 		return -1;
 	}
 
-	process_raw_event(sample->raw_data, sample->cpu, sample->time, thread);
+	process_raw_event(evsel, sample->raw_data, sample->cpu, sample->time, thread);
 
 	return 0;
 }
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7a9ad2b..30ef82a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -43,11 +43,6 @@ static u64			sleep_measurement_overhead;
 
 static unsigned long		nr_tasks;
 
-struct perf_sched {
-	struct perf_tool    tool;
-	struct perf_session *session;
-};
-
 struct sched_atom;
 
 struct task_desc {
@@ -1596,14 +1591,12 @@ typedef void (*tracepoint_handler)(struct perf_tool *tool, struct event_format *
 				   struct machine *machine,
 				   struct thread *thread);
 
-static int perf_sched__process_tracepoint_sample(struct perf_tool *tool,
+static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __used,
 						 union perf_event *event __used,
 						 struct perf_sample *sample,
 						 struct perf_evsel *evsel,
 						 struct machine *machine)
 {
-	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
-	struct pevent *pevent = sched->session->pevent;
 	struct thread *thread = machine__findnew_thread(machine, sample->pid);
 
 	if (thread == NULL) {
@@ -1617,25 +1610,18 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool,
 
 	if (evsel->handler.func != NULL) {
 		tracepoint_handler f = evsel->handler.func;
-
-		if (evsel->handler.data == NULL)
-			evsel->handler.data = pevent_find_event(pevent,
-							  evsel->attr.config);
-
-		f(tool, evsel->handler.data, sample, machine, thread);
+		f(tool, evsel->tp_format, sample, machine, thread);
 	}
 
 	return 0;
 }
 
-static struct perf_sched perf_sched = {
-	.tool = {
-		.sample		 = perf_sched__process_tracepoint_sample,
-		.comm		 = perf_event__process_comm,
-		.lost		 = perf_event__process_lost,
-		.fork		 = perf_event__process_task,
-		.ordered_samples = true,
-	},
+static struct perf_tool perf_sched = {
+	.sample		 = perf_sched__process_tracepoint_sample,
+	.comm		 = perf_event__process_comm,
+	.lost		 = perf_event__process_lost,
+	.fork		 = perf_event__process_task,
+	.ordered_samples = true,
 };
 
 static void read_events(bool destroy, struct perf_session **psession)
@@ -1652,18 +1638,15 @@ static void read_events(bool destroy, struct perf_session **psession)
 	};
 	struct perf_session *session;
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false,
-				    &perf_sched.tool);
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &perf_sched);
 	if (session == NULL)
 		die("No Memory");
 
-	perf_sched.session = session;
-
 	err = perf_session__set_tracepoints_handlers(session, handlers);
 	assert(err == 0);
 
 	if (perf_session__has_traces(session, "record -R")) {
-		err = perf_session__process_events(session, &perf_sched.tool);
+		err = perf_session__process_events(session, &perf_sched);
 		if (err)
 			die("Failed to process events, error %d", err);
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1e60ab7..8dba470 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -262,14 +262,11 @@ static int perf_session__check_output_opt(struct perf_session *session)
 	return 0;
 }
 
-static void print_sample_start(struct pevent *pevent,
-			       struct perf_sample *sample,
+static void print_sample_start(struct perf_sample *sample,
 			       struct thread *thread,
 			       struct perf_evsel *evsel)
 {
-	int type;
 	struct perf_event_attr *attr = &evsel->attr;
-	struct event_format *event;
 	const char *evname = NULL;
 	unsigned long secs;
 	unsigned long usecs;
@@ -307,20 +304,7 @@ static void print_sample_start(struct pevent *pevent,
 	}
 
 	if (PRINT_FIELD(EVNAME)) {
-		if (attr->type == PERF_TYPE_TRACEPOINT) {
-			/*
-			 * XXX Do we really need this here?
-			 * perf_evlist__set_tracepoint_names should have done
-			 * this already
-			 */
-			type = trace_parse_common_type(pevent,
-						       sample->raw_data);
-			event = pevent_find_event(pevent, type);
-			if (event)
-				evname = event->name;
-		} else
-			evname = perf_evsel__name(evsel);
-
+		evname = perf_evsel__name(evsel);
 		printf("%s: ", evname ? evname : "[unknown]");
 	}
 }
@@ -416,7 +400,7 @@ static void print_sample_bts(union perf_event *event,
 }
 
 static void process_event(union perf_event *event __unused,
-			  struct pevent *pevent,
+			  struct pevent *pevent __unused,
 			  struct perf_sample *sample,
 			  struct perf_evsel *evsel,
 			  struct machine *machine,
@@ -427,7 +411,7 @@ static void process_event(union perf_event *event __unused,
 	if (output[attr->type].fields == 0)
 		return;
 
-	print_sample_start(pevent, sample, thread, evsel);
+	print_sample_start(sample, thread, evsel);
 
 	if (is_bts_event(attr)) {
 		print_sample_bts(event, sample, evsel, machine, thread);
@@ -435,9 +419,8 @@ static void process_event(union perf_event *event __unused,
 	}
 
 	if (PRINT_FIELD(TRACE))
-		print_trace_event(pevent, sample->cpu, sample->raw_data,
-				  sample->raw_size);
-
+		event_format__print(evsel->tp_format, sample->cpu,
+				    sample->raw_data, sample->raw_size);
 	if (PRINT_FIELD(ADDR))
 		print_sample_addr(event, sample, machine, thread, attr);
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index b559929..a56c457 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -56,6 +56,7 @@ struct perf_evsel {
 	int			ids;
 	struct hists		hists;
 	char			*name;
+	struct event_format	*tp_format;
 	union {
 		void		*priv;
 		off_t		id_offset;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e2b4864..b2da439 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2123,6 +2123,7 @@ static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel,
 	if (event->name == NULL)
 		return -1;
 
+	evsel->tp_format = event;
 	return 0;
 }
 
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 02dfa19..c266281 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -237,16 +237,16 @@ static void define_event_symbols(struct event_format *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline
-struct event_format *find_cache_event(struct pevent *pevent, int type)
+static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
 {
 	static char ev_name[256];
 	struct event_format *event;
+	int type = evsel->attr.config;
 
 	if (events[type])
 		return events[type];
 
-	events[type] = event = pevent_find_event(pevent, type);
+	events[type] = event = evsel->tp_format;
 	if (!event)
 		return NULL;
 
@@ -269,7 +269,6 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 	unsigned long long val;
 	unsigned long s, ns;
 	struct event_format *event;
-	int type;
 	int pid;
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
@@ -281,11 +280,9 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 	if (evsel->attr.type != PERF_TYPE_TRACEPOINT)
 		return;
 
-	type = trace_parse_common_type(pevent, data);
-
-	event = find_cache_event(pevent, type);
+	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %d", type);
+		die("ug! no event found for type %d", evsel->attr.config);
 
 	pid = trace_parse_common_pid(pevent, data);
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index ce4d1b0..8006978 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -27,6 +27,7 @@
 #include <errno.h>
 
 #include "../../perf.h"
+#include "../evsel.h"
 #include "../util.h"
 #include "../event.h"
 #include "../thread.h"
@@ -194,16 +195,21 @@ static void define_event_symbols(struct event_format *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline
-struct event_format *find_cache_event(struct pevent *pevent, int type)
+static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
 {
 	static char ev_name[256];
 	struct event_format *event;
+	int type = evsel->attr.config;
 
+	/*
+ 	 * XXX: Do we really need to cache this since now we have evsel->tp_format
+ 	 * cached already? Need to re-read this "cache" routine that as well calls
+ 	 * define_event_symbols() :-\
+ 	 */
 	if (events[type])
 		return events[type];
 
-	events[type] = event = pevent_find_event(pevent, type);
+	events[type] = event = evsel->tp_format;
 	if (!event)
 		return NULL;
 
@@ -217,7 +223,7 @@ struct event_format *find_cache_event(struct pevent *pevent, int type)
 static void python_process_event(union perf_event *perf_event __unused,
 				 struct pevent *pevent,
 				 struct perf_sample *sample,
-				 struct perf_evsel *evsel __unused,
+				 struct perf_evsel *evsel,
 				 struct machine *machine __unused,
 				 struct thread *thread)
 {
@@ -228,7 +234,6 @@ static void python_process_event(union perf_event *perf_event __unused,
 	unsigned long s, ns;
 	struct event_format *event;
 	unsigned n = 0;
-	int type;
 	int pid;
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
@@ -239,11 +244,9 @@ static void python_process_event(union perf_event *perf_event __unused,
 	if (!t)
 		Py_FatalError("couldn't create Python tuple");
 
-	type = trace_parse_common_type(pevent, data);
-
-	event = find_cache_event(pevent, type);
+	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %d", type);
+		die("ug! no event found for type %d", (int)evsel->attr.config);
 
 	pid = trace_parse_common_pid(pevent, data);
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0715c84..1208834 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -167,20 +167,11 @@ unsigned long long read_size(struct pevent *pevent, void *ptr, int size)
 	return pevent_read_number(pevent, ptr, size);
 }
 
-void print_trace_event(struct pevent *pevent, int cpu, void *data, int size)
+void event_format__print(struct event_format *event,
+			 int cpu, void *data, int size)
 {
-	struct event_format *event;
 	struct pevent_record record;
 	struct trace_seq s;
-	int type;
-
-	type = trace_parse_common_type(pevent, data);
-
-	event = pevent_find_event(pevent, type);
-	if (!event) {
-		warning("ug! no event found for type %d", type);
-		return;
-	}
 
 	memset(&record, 0, sizeof(record));
 	record.cpu = cpu;
@@ -192,6 +183,19 @@ void print_trace_event(struct pevent *pevent, int cpu, void *data, int size)
 	trace_seq_do_printf(&s);
 }
 
+void print_trace_event(struct pevent *pevent, int cpu, void *data, int size)
+{
+	int type = trace_parse_common_type(pevent, data);
+	struct event_format *event = pevent_find_event(pevent, type);
+
+	if (!event) {
+		warning("ug! no event found for type %d", type);
+		return;
+	}
+
+	event_format__print(event, cpu, data, size);
+}
+
 void print_event(struct pevent *pevent, int cpu, void *data, int size,
 		 unsigned long long nsecs, char *comm)
 {
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 8fef1d6..069d105 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -32,6 +32,8 @@ int bigendian(void);
 
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian);
 void print_trace_event(struct pevent *pevent, int cpu, void *data, int size);
+void event_format__print(struct event_format *event,
+			 int cpu, void *data, int size);
 
 void print_event(struct pevent *pevent, int cpu, void *data, int size,
 		 unsigned long long nsecs, char *comm);
