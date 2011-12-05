Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1LENGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:06:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57157 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab1LENGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:06:01 -0500
Date: Mon, 5 Dec 2011 05:05:26 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-1kbzpl74lwi6lavpqke2u2p3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Save some loops using perf_evlist__id2evsel
Git-Commit-ID: ee29be625bd7b115d45eba4b0526ff3e24bf3ca0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:05:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee29be625bd7b115d45eba4b0526ff3e24bf3ca0
Gitweb:     http://git.kernel.org/tip/ee29be625bd7b115d45eba4b0526ff3e24bf3ca0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 28 Nov 2011 17:57:40 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 17:57:40 -0200

perf tools: Save some loops using perf_evlist__id2evsel

Since we already ask for PERF_SAMPLE_ID and use it to quickly find the
associated evsel, add handler func + data to struct perf_evsel to avoid
using chains of if(strcmp(event_name)) and also to avoid all the linear
list searches via trace_event_find.

To demonstrate the technique convert 'perf sched' to it:

 # perf sched record sleep 5m

And then:

 Performance counter stats for '/tmp/oldperf sched lat':

        646.929438 task-clock                #    0.999 CPUs utilized
                 9 context-switches          #    0.000 M/sec
                 0 CPU-migrations            #    0.000 M/sec
            20,901 page-faults               #    0.032 M/sec
     1,290,144,450 cycles                    #    1.994 GHz
   <not supported> stalled-cycles-frontend
   <not supported> stalled-cycles-backend
     1,606,158,439 instructions              #    1.24  insns per cycle
       339,088,395 branches                  #  524.151 M/sec
         4,550,735 branch-misses             #    1.34% of all branches

       0.647524759 seconds time elapsed

Versus:

 Performance counter stats for 'perf sched lat':

        473.564691 task-clock                #    0.999 CPUs utilized
                 9 context-switches          #    0.000 M/sec
                 0 CPU-migrations            #    0.000 M/sec
            20,903 page-faults               #    0.044 M/sec
       944,367,984 cycles                    #    1.994 GHz
   <not supported> stalled-cycles-frontend
   <not supported> stalled-cycles-backend
     1,442,385,571 instructions              #    1.53  insns per cycle
       308,383,106 branches                  #  651.195 M/sec
         4,481,784 branch-misses             #    1.45% of all branches

       0.474215751 seconds time elapsed

[root@emilia ~]#

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1kbzpl74lwi6lavpqke2u2p3@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c |  149 ++++++++++++++++++++++----------------------
 tools/perf/util/evlist.c   |   42 ++++++++++++
 tools/perf/util/evlist.h   |   11 +++
 tools/perf/util/evsel.h    |    4 +
 tools/perf/util/tool.h     |    5 ++
 5 files changed, 136 insertions(+), 75 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 0ee868e..6284ed2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2,6 +2,7 @@
 #include "perf.h"
 
 #include "util/util.h"
+#include "util/evlist.h"
 #include "util/cache.h"
 #include "util/evsel.h"
 #include "util/symbol.h"
@@ -1358,12 +1359,13 @@ static void sort_lat(void)
 static struct trace_sched_handler *trace_handler;
 
 static void
-process_sched_wakeup_event(void *data, struct machine *machine,
+process_sched_wakeup_event(struct perf_tool *tool __used,
 			   struct event *event,
-			   int cpu __used,
-			   u64 timestamp __used,
-			   struct thread *thread __used)
+			   struct perf_sample *sample,
+			   struct machine *machine,
+			   struct thread *thread)
 {
+	void *data = sample->raw_data;
 	struct trace_wakeup_event wakeup_event;
 
 	FILL_COMMON_FIELDS(wakeup_event, event, data);
@@ -1376,7 +1378,7 @@ process_sched_wakeup_event(void *data, struct machine *machine,
 
 	if (trace_handler->wakeup_event)
 		trace_handler->wakeup_event(&wakeup_event, machine, event,
-					    cpu, timestamp, thread);
+					    sample->cpu, sample->time, thread);
 }
 
 /*
@@ -1471,14 +1473,15 @@ map_switch_event(struct trace_switch_event *switch_event,
 	}
 }
 
-
 static void
-process_sched_switch_event(void *data, struct machine *machine,
+process_sched_switch_event(struct perf_tool *tool __used,
 			   struct event *event,
-			   int this_cpu,
-			   u64 timestamp __used,
-			   struct thread *thread __used)
+			   struct perf_sample *sample,
+			   struct machine *machine,
+			   struct thread *thread)
 {
+	int this_cpu = sample->cpu;
+	void *data = sample->raw_data;
 	struct trace_switch_event switch_event;
 
 	FILL_COMMON_FIELDS(switch_event, event, data);
@@ -1501,18 +1504,19 @@ process_sched_switch_event(void *data, struct machine *machine,
 	}
 	if (trace_handler->switch_event)
 		trace_handler->switch_event(&switch_event, machine, event,
-					    this_cpu, timestamp, thread);
+					    this_cpu, sample->time, thread);
 
 	curr_pid[this_cpu] = switch_event.next_pid;
 }
 
 static void
-process_sched_runtime_event(void *data, struct machine *machine,
-			   struct event *event,
-			   int cpu __used,
-			   u64 timestamp __used,
-			   struct thread *thread __used)
+process_sched_runtime_event(struct perf_tool *tool __used,
+			    struct event *event,
+			    struct perf_sample *sample,
+			    struct machine *machine,
+			    struct thread *thread)
 {
+	void *data = sample->raw_data;
 	struct trace_runtime_event runtime_event;
 
 	FILL_ARRAY(runtime_event, comm, event, data);
@@ -1521,16 +1525,18 @@ process_sched_runtime_event(void *data, struct machine *machine,
 	FILL_FIELD(runtime_event, vruntime, event, data);
 
 	if (trace_handler->runtime_event)
-		trace_handler->runtime_event(&runtime_event, machine, event, cpu, timestamp, thread);
+		trace_handler->runtime_event(&runtime_event, machine, event,
+					     sample->cpu, sample->time, thread);
 }
 
 static void
-process_sched_fork_event(void *data,
+process_sched_fork_event(struct perf_tool *tool __used,
 			 struct event *event,
-			 int cpu __used,
-			 u64 timestamp __used,
-			 struct thread *thread __used)
+			 struct perf_sample *sample,
+			 struct machine *machine __used,
+			 struct thread *thread)
 {
+	void *data = sample->raw_data;
 	struct trace_fork_event fork_event;
 
 	FILL_COMMON_FIELDS(fork_event, event, data);
@@ -1542,13 +1548,14 @@ process_sched_fork_event(void *data,
 
 	if (trace_handler->fork_event)
 		trace_handler->fork_event(&fork_event, event,
-					  cpu, timestamp, thread);
+					  sample->cpu, sample->time, thread);
 }
 
 static void
-process_sched_exit_event(struct event *event,
-			 int cpu __used,
-			 u64 timestamp __used,
+process_sched_exit_event(struct perf_tool *tool __used,
+			 struct event *event,
+			 struct perf_sample *sample __used,
+			 struct machine *machine __used,
 			 struct thread *thread __used)
 {
 	if (verbose)
@@ -1556,12 +1563,13 @@ process_sched_exit_event(struct event *event,
 }
 
 static void
-process_sched_migrate_task_event(void *data, struct machine *machine,
-			   struct event *event,
-			   int cpu __used,
-			   u64 timestamp __used,
-			   struct thread *thread __used)
+process_sched_migrate_task_event(struct perf_tool *tool __used,
+				 struct event *event,
+				 struct perf_sample *sample,
+				 struct machine *machine,
+				 struct thread *thread)
 {
+	void *data = sample->raw_data;
 	struct trace_migrate_task_event migrate_task_event;
 
 	FILL_COMMON_FIELDS(migrate_task_event, event, data);
@@ -1573,67 +1581,46 @@ process_sched_migrate_task_event(void *data, struct machine *machine,
 
 	if (trace_handler->migrate_task_event)
 		trace_handler->migrate_task_event(&migrate_task_event, machine,
-						 event, cpu, timestamp, thread);
+						  event, sample->cpu,
+						  sample->time, thread);
 }
 
-static void process_raw_event(union perf_event *raw_event __used,
-			      struct machine *machine, void *data, int cpu,
-			      u64 timestamp, struct thread *thread)
-{
-	struct event *event;
-	int type;
-
-
-	type = trace_parse_common_type(data);
-	event = trace_find_event(type);
-
-	if (!strcmp(event->name, "sched_switch"))
-		process_sched_switch_event(data, machine, event, cpu, timestamp, thread);
-	if (!strcmp(event->name, "sched_stat_runtime"))
-		process_sched_runtime_event(data, machine, event, cpu, timestamp, thread);
-	if (!strcmp(event->name, "sched_wakeup"))
-		process_sched_wakeup_event(data, machine, event, cpu, timestamp, thread);
-	if (!strcmp(event->name, "sched_wakeup_new"))
-		process_sched_wakeup_event(data, machine, event, cpu, timestamp, thread);
-	if (!strcmp(event->name, "sched_process_fork"))
-		process_sched_fork_event(data, event, cpu, timestamp, thread);
-	if (!strcmp(event->name, "sched_process_exit"))
-		process_sched_exit_event(event, cpu, timestamp, thread);
-	if (!strcmp(event->name, "sched_migrate_task"))
-		process_sched_migrate_task_event(data, machine, event, cpu, timestamp, thread);
-}
+typedef void (*tracepoint_handler)(struct perf_tool *tool, struct event *event,
+				   struct perf_sample *sample,
+				   struct machine *machine,
+				   struct thread *thread);
 
-static int process_sample_event(struct perf_tool *tool __used,
-				union perf_event *event,
-				struct perf_sample *sample,
-				struct perf_evsel *evsel,
-				struct machine *machine)
+static int perf_sched__process_tracepoint_sample(struct perf_tool *tool,
+						 union perf_event *event __used,
+						 struct perf_sample *sample,
+						 struct perf_evsel *evsel,
+						 struct machine *machine)
 {
-	struct thread *thread;
-
-	if (!(evsel->attr.sample_type & PERF_SAMPLE_RAW))
-		return 0;
+	struct thread *thread = machine__findnew_thread(machine, sample->pid);
 
-	thread = machine__findnew_thread(machine, sample->pid);
 	if (thread == NULL) {
-		pr_debug("problem processing %d event, skipping it.\n",
-			 event->header.type);
+		pr_debug("problem processing %s event, skipping it.\n",
+			 evsel->name);
 		return -1;
 	}
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+	evsel->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 
-	if (profile_cpu != -1 && profile_cpu != (int)sample->cpu)
-		return 0;
+	if (evsel->handler.func != NULL) {
+		tracepoint_handler f = evsel->handler.func;
 
-	process_raw_event(event, machine, sample->raw_data, sample->cpu,
-			  sample->time, thread);
+		if (evsel->handler.data == NULL)
+			evsel->handler.data = trace_find_event(evsel->attr.config);
+
+		f(tool, evsel->handler.data, sample, machine, thread);
+	}
 
 	return 0;
 }
 
 static struct perf_tool perf_sched = {
-	.sample			= process_sample_event,
+	.sample			= perf_sched__process_tracepoint_sample,
 	.comm			= perf_event__process_comm,
 	.lost			= perf_event__process_lost,
 	.fork			= perf_event__process_task,
@@ -1643,11 +1630,23 @@ static struct perf_tool perf_sched = {
 static void read_events(bool destroy, struct perf_session **psession)
 {
 	int err = -EINVAL;
+	const struct perf_evsel_str_handler handlers[] = {
+		{ "sched:sched_switch",	      process_sched_switch_event, },
+		{ "sched:sched_stat_runtime", process_sched_runtime_event, },
+		{ "sched:sched_wakeup",	      process_sched_wakeup_event, },
+		{ "sched:sched_wakeup_new",   process_sched_wakeup_event, },
+		{ "sched:sched_process_fork", process_sched_fork_event, },
+		{ "sched:sched_process_exit", process_sched_exit_event, },
+		{ "sched:sched_migrate_task", process_sched_migrate_task_event, },
+	};
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
 							 0, false, &perf_sched);
 	if (session == NULL)
 		die("No Memory");
 
+	err = perf_evlist__set_tracepoints_handlers_array(session->evlist, handlers);
+	assert(err == 0);
+
 	if (perf_session__has_traces(session, "record -R")) {
 		err = perf_session__process_events(session, &perf_sched);
 		if (err)
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d44e3df..b36f26f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -207,6 +207,48 @@ out_free_attrs:
 	return err;
 }
 
+static struct perf_evsel *
+	perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (evsel->attr.type   == PERF_TYPE_TRACEPOINT &&
+		    (int)evsel->attr.config == id)
+			return evsel;
+	}
+
+	return NULL;
+}
+
+int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
+					  const struct perf_evsel_str_handler *assocs,
+					  size_t nr_assocs)
+{
+	struct perf_evsel *evsel;
+	int err;
+	size_t i;
+
+	for (i = 0; i < nr_assocs; i++) {
+		err = trace_event__id(assocs[i].name);
+		if (err < 0)
+			goto out;
+
+		evsel = perf_evlist__find_tracepoint_by_id(evlist, err);
+		if (evsel == NULL)
+			continue;
+
+		err = -EEXIST;
+		if (evsel->handler.func != NULL)
+			goto out;
+		evsel->handler.func = assocs[i].handler;
+	}
+
+	err = 0;
+out:
+	return err;
+}
+
 void perf_evlist__disable(struct perf_evlist *evlist)
 {
 	int cpu, thread;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 2202e7b..f94ed7e 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -36,6 +36,11 @@ struct perf_evlist {
 	struct perf_evsel *selected;
 };
 
+struct perf_evsel_str_handler {
+	const char *name;
+	void	   *handler;
+};
+
 struct perf_evsel;
 
 struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
@@ -51,6 +56,9 @@ int perf_evlist__add_attrs(struct perf_evlist *evlist,
 			   struct perf_event_attr *attrs, size_t nr_attrs);
 int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
 				 const char *tracepoints[], size_t nr_tracepoints);
+int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
+					  const struct perf_evsel_str_handler *assocs,
+					  size_t nr_assocs);
 
 #define perf_evlist__add_attrs_array(evlist, array) \
 	perf_evlist__add_attrs(evlist, array, ARRAY_SIZE(array))
@@ -58,6 +66,9 @@ int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
 #define perf_evlist__add_tracepoints_array(evlist, array) \
 	perf_evlist__add_tracepoints(evlist, array, ARRAY_SIZE(array))
 
+#define perf_evlist__set_tracepoints_handlers_array(evlist, array) \
+	perf_evlist__set_tracepoints_handlers(evlist, array, ARRAY_SIZE(array))
+
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 6421c07..326b8e4 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -61,6 +61,10 @@ struct perf_evsel {
 		off_t		id_offset;
 	};
 	struct cgroup_sel	*cgrp;
+	struct {
+		void		*func;
+		void		*data;
+	} handler;
 	bool 			supported;
 };
 
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index 89ff1b5..b0e1aad 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -1,8 +1,13 @@
 #ifndef __PERF_TOOL_H
 #define __PERF_TOOL_H
 
+#include <stdbool.h>
+
 struct perf_session;
+union perf_event;
+struct perf_evlist;
 struct perf_evsel;
+struct perf_sample;
 struct perf_tool;
 struct machine;
 
