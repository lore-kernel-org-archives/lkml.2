Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1CFWQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 17:16:15 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:43886 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1CFWQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 17:16:08 -0500
X-IronPort-AV: E=Sophos;i="4.62,272,1297036800"; 
   d="scan'208";a="340616029"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 2/2] perf script: support custom field selection for output
Date: Sun,  6 Mar 2011 15:16:35 -0700
Message-Id: <1299449795-12933-3-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299449795-12933-1-git-send-email-daahern@cisco.com>
References: <1299449795-12933-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a user to select which fields to print to stdout for event data.
Options include comm (command name), tid (thread id), pid (process id),
time (perf timestamp), cpu, event (for event name), trace (for trace
data), and sym (for IP, symbol name and DSO name).

This options allows dumping software events with symbols -- my primary
goal -- and also symbols for trace events if a so desired.

Default is set to maintain compatibility with current output.

Thanks to Frederic Weisbecker for detailed suggestions on this approach.


Examples (output compressed)

1. trace, default format

perf record -ga -e sched:sched_switch
perf script

swapper-0 [000]  534.955086: sched_switch: prev_comm=swapper prev_pid=0 ...
sshd-1678 [000]  534.955093: sched_switch: prev_comm=sshd prev_pid=1678 ...
sshd-1675 [001]  534.960353: sched_switch: prev_comm=sshd prev_pid=1675 ...

2. trace, custom format

perf record -ga -e sched:sched_switch
perf script -f comm,pid,time,trace,sym

swapper-0  534.955086: prev_comm=swapper prev_pid=0 prev_prio=120 ...
        ffffffff81030350 perf_trace_sched_switch ([kernel.kallsyms])
        ffffffff81382ac5 schedule ([kernel.kallsyms])
        ffffffff8100134a cpu_idle ([kernel.kallsyms])
        ffffffff81370b39 rest_init ([kernel.kallsyms])
        ffffffff81696c23 start_kernel ([kernel.kallsyms].init.text)
        ffffffff816962af x86_64_start_reservations ([kernel.kallsyms].init.text)
        ffffffff816963b9 x86_64_start_kernel ([kernel.kallsyms].init.text)

sshd-1678 534.955093: prev_comm=sshd prev_pid=1678 prev_prio=120 ...
        ffffffff81030350 perf_trace_sched_switch ([kernel.kallsyms])
        ffffffff81382ac5 schedule ([kernel.kallsyms])
        ffffffff81382fa0 schedule_timeout ([kernel.kallsyms])
        ffffffff81363f16 unix_stream_recvmsg ([kernel.kallsyms])
        ffffffff812e35b4 __sock_recvmsg ([kernel.kallsyms])
        ffffffff812e368b sock_aio_read ([kernel.kallsyms])
        ffffffff810fd2f2 do_sync_read ([kernel.kallsyms])
        ffffffff810fd978 vfs_read ([kernel.kallsyms])
        ffffffff810fda02 sys_read ([kernel.kallsyms])
        ffffffff81002bc2 system_call ([kernel.kallsyms])
            7f1647e51210 __GI___libc_read (/lib64/libc-2.12.90.so)

sshd-1675 534.960353: prev_comm=sshd prev_pid=1675 prev_prio=120 ...
        ffffffff81030350 perf_trace_sched_switch ([kernel.kallsyms])
        ffffffff81382ac5 schedule ([kernel.kallsyms])
        ffffffff81382fa0 schedule_timeout ([kernel.kallsyms])
        ffffffff81363f16 unix_stream_recvmsg ([kernel.kallsyms])
        ffffffff812e35b4 __sock_recvmsg ([kernel.kallsyms])
        ffffffff812e368b sock_aio_read ([kernel.kallsyms])
        ffffffff810fd2f2 do_sync_read ([kernel.kallsyms])
        ffffffff810fd978 vfs_read ([kernel.kallsyms])
        ffffffff810fda02 sys_read ([kernel.kallsyms])
        ffffffff81002bc2 system_call ([kernel.kallsyms])
            7f1647e51210 __GI___libc_read (/lib64/libc-2.12.90.so)

3. Software events

perf record -e cs -c 1 -gaT
perf script -f comm,tid,pid,time,sym

sshd  1015/1015       328.654782
        ffffffff810355de perf_event_task_sched_out ([kernel.kallsyms])
        ffffffff81382aa1 schedule ([kernel.kallsyms])
        ffffffff813837aa schedule_hrtimeout_range_clock ([kernel.kallsyms])
        ffffffff81383886 schedule_hrtimeout_range ([kernel.kallsyms])
        ffffffff8110c4f9 poll_schedule_timeout ([kernel.kallsyms])
        ffffffff8110cd20 do_select ([kernel.kallsyms])
        ffffffff8110ced8 core_sys_select ([kernel.kallsyms])
        ffffffff8110d00d sys_select ([kernel.kallsyms])
        ffffffff81002bc2 system_call ([kernel.kallsyms])
            7fd685d30e93 __GI_select (/lib64/libc-2.12.90.so)

sshd  1629/1629       328.655460
        ffffffff810355de perf_event_task_sched_out ([kernel.kallsyms])
        ffffffff81382aa1 schedule ([kernel.kallsyms])
        ffffffff8103d4d7 __cond_resched ([kernel.kallsyms])
        ffffffff81382cc7 _cond_resched ([kernel.kallsyms])
        ffffffff81382d0a wait_for_common ([kernel.kallsyms])
        ffffffff81382e90 wait_for_completion ([kernel.kallsyms])
        ffffffff8108092e stop_one_cpu ([kernel.kallsyms])
        ffffffff8103b41d sched_exec ([kernel.kallsyms])
        ffffffff811035e0 do_execve ([kernel.kallsyms])
        ffffffff8100a5bd sys_execve ([kernel.kallsyms])
        ffffffff8100301c stub_execve ([kernel.kallsyms])
            7fd685d01f67 __execve (/lib64/libc-2.12.90.so)

4. generate a process list from a recorded session:

perf script -f comm,pid

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/Documentation/perf-script.txt |   24 ++++
 tools/perf/builtin-script.c              |  207 +++++++++++++++++++++++++++---
 tools/perf/util/output.h                 |   18 +++
 tools/perf/util/session.c                |   75 +++++++++++
 tools/perf/util/session.h                |    5 +
 tools/perf/util/trace-event-parse.c      |   71 ++++++++--
 6 files changed, 369 insertions(+), 31 deletions(-)
 create mode 100644 tools/perf/util/output.h

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 29ad942..f527287 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -112,6 +112,30 @@ OPTIONS
 --debug-mode::
         Do various checks like samples ordering and lost events.
 
+-k::
+--vmlinux=<file>::
+        vmlinux pathname
+
+--kallsyms=<file>::
+        kallsyms pathname
+
+--symfs=<directory>::
+        Look for files with symbols relative to this directory.
+
+-U::
+--show-unresolved::
+        Display all addresses including unresolved to a symbol.
+
+-G::
+--hide-call-graph::
+        When printing symbols do not display call chain.
+
+-f::
+--fields
+        Comma separated list of fields to print. Options are:
+        comm, tid, pid, time, cpu, sym, trace, event
+
+--
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 48bdf94..c6b9db1 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -12,6 +12,7 @@
 #include "util/trace-event.h"
 #include "util/parse-options.h"
 #include "util/util.h"
+#include "util/output.h"
 
 static char const		*script_name;
 static char const		*generate_script_lang;
@@ -19,6 +20,81 @@ static bool			debug_mode;
 static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
+static bool			show_unresolved;
+static bool			no_callchain;
+
+struct output_option {
+	const char *str;
+	enum perf_output_field field;
+} all_output_options [] = {
+	{.str = "comm",  .field = PERF_OUTPUT_COMM},
+	{.str = "tid",   .field = PERF_OUTPUT_TID},
+	{.str = "pid",   .field = PERF_OUTPUT_PID},
+	{.str = "time",  .field = PERF_OUTPUT_TIME},
+	{.str = "cpu",   .field = PERF_OUTPUT_CPU},
+	{.str = "sym",   .field = PERF_OUTPUT_SYM},
+	{.str = "trace", .field = PERF_OUTPUT_TRACE},
+	{.str = "event", .field = PERF_OUTPUT_EVNAME},
+};
+
+/* default set to maintain compatibility with current format */
+#define output_fields_default   (PERF_OUTPUT_COMM | PERF_OUTPUT_PID | \
+				PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
+				PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE)
+
+u64 output_fields = output_fields_default;
+
+static void print_sample_oneline(struct perf_sample *sample,
+			  struct perf_event_attr *attr,
+			  struct thread *thread)
+{
+	const char *evname;
+
+	if (PRINT_FIELD(COMM)) {
+		int n = 16;
+		if (PRINT_FIELD(SYM) && !no_callchain)
+			n = 1;
+		printf("%*s ", n, thread->comm);
+	}
+
+	if (PRINT_FIELD(PID) && PRINT_FIELD(TID))
+		printf("%5d/%-5d ", sample->pid, sample->tid);
+	else if (PRINT_FIELD(PID))
+		printf("%5d ", sample->pid);
+	else if (PRINT_FIELD(TID))
+		printf("%5d ", sample->tid);
+
+	if (PRINT_FIELD(CPU))
+		printf("[%03d] ", sample->cpu);
+
+	if (PRINT_FIELD(TIME)) {
+		unsigned long secs, usecs, nsecs;
+
+		nsecs = sample->time;
+		secs = nsecs / NSECS_PER_SEC;
+		nsecs -= secs * NSECS_PER_SEC;
+		usecs = nsecs / NSECS_PER_USEC;
+		printf("%8lu.%06lu ", secs, usecs);
+	}
+
+	if (PRINT_FIELD(EVNAME)) {
+		if (attr->type == PERF_TYPE_TRACEPOINT) {
+			struct event *event;
+			int type;
+
+			type = trace_parse_common_type(sample->raw_data);
+			event = trace_find_event(type);
+			if (event)
+				evname = event->name;
+		} else
+			evname = __event_name(attr->type, attr->config);
+
+		printf("%s ", evname ? evname : "(unknown)");
+	}
+
+	if (!no_callchain)
+		printf("\n");
+}
 
 static void process_event(union perf_event *event __unused,
 			  struct perf_sample *sample,
@@ -31,8 +107,15 @@ static void process_event(union perf_event *event __unused,
 	 * field, although it should be the same than this perf
 	 * event pid
 	 */
-	print_event(sample->cpu, sample->raw_data, sample->raw_size,
-		    sample->time, thread->comm);
+	if (PRINT_FIELD(TRACE))
+		print_event(sample->cpu, sample->raw_data,
+			    sample->raw_size, sample->time,
+			    thread->comm);
+	else
+		print_sample_oneline(sample, attr, thread);
+
+	if (PRINT_FIELD(SYM))
+		perf_session__print_symbols(event, sample, session, show_unresolved);
 }
 
 static int default_start_script(const char *script __unused,
@@ -98,20 +181,17 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
-	if (session->sample_type & PERF_SAMPLE_RAW) {
-		if (debug_mode) {
-			if (sample->time < last_timestamp) {
-				pr_err("Samples misordered, previous: %" PRIu64
-					" this: %" PRIu64 "\n", last_timestamp,
-					sample->time);
-				nr_unordered++;
-			}
-			last_timestamp = sample->time;
-			return 0;
+	if (debug_mode) {
+		if (sample->time < last_timestamp) {
+			pr_err("Samples misordered, previous: %" PRIu64
+				" this: %" PRIu64 "\n", last_timestamp,
+				sample->time);
+			nr_unordered++;
 		}
-		scripting_ops->process_event(event, sample, session,
-					     attr, thread);
+		last_timestamp = sample->time;
+		return 0;
 	}
+	scripting_ops->process_event(event, sample, session, attr, thread);
 
 	session->hists.stats.total_period += sample->period;
 	return 0;
@@ -119,7 +199,10 @@ static int process_sample_event(union perf_event *event,
 
 static struct perf_event_ops event_ops = {
 	.sample		 = process_sample_event,
+	.mmap		 = perf_event__process_mmap,
 	.comm		 = perf_event__process_comm,
+	.exit		 = perf_event__process_task,
+	.fork		 = perf_event__process_task,
 	.attr		 = perf_event__process_attr,
 	.event_type	 = perf_event__process_event_type,
 	.tracing_data	 = perf_event__process_tracing_data,
@@ -149,6 +232,39 @@ static int __cmd_script(struct perf_session *session)
 	return ret;
 }
 
+static int perf_session__check_attr(struct perf_session *session)
+{
+	if ((output_fields & PERF_OUTPUT_TRACE) && 
+		!perf_session__has_traces(session, "record -R"))
+		return -EINVAL;
+
+	if ((output_fields & PERF_OUTPUT_SYM) &&
+		!(session->sample_type & PERF_SAMPLE_IP)) {
+		pr_err("Samples do not contain IP data.\n");
+		return -EINVAL;
+	}
+
+	if ((output_fields & (PERF_OUTPUT_TID | PERF_OUTPUT_PID)) &&
+		!(session->sample_type & PERF_SAMPLE_TID)) {
+		pr_err("Samples do not contain TID/PID data.\n");
+		return -EINVAL;
+	}
+
+	if ((output_fields & PERF_OUTPUT_TIME) &&
+		!(session->sample_type & PERF_SAMPLE_TIME)) {
+		pr_err("Samples do not contain timestamps.\n");
+		return -EINVAL;
+	}
+
+	if ((output_fields & PERF_OUTPUT_CPU) &&
+		!(session->sample_type & PERF_SAMPLE_CPU)) {
+		pr_err("Samples do not contain cpu.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 struct script_spec {
 	struct list_head	node;
 	struct scripting_ops	*ops;
@@ -297,6 +413,43 @@ static int parse_scriptname(const struct option *opt __used,
 	return 0;
 }
 
+static int parse_output_fields(const struct option *opt __used,
+			    const char *arg, int unset __used)
+{
+	char *tok;
+	int i, imax = sizeof(all_output_options) / sizeof(struct output_option);
+	int rc = 0;
+	char *str = strdup(arg);
+
+	if (!str)
+		return -ENOMEM;
+
+	/* remove default */
+	output_fields = 0;
+
+	tok = strtok(str, ",");
+	while (1) {
+		for (i = 0; i < imax; ++i) {
+			if (strcmp(tok, all_output_options[i].str) == 0) {
+				output_fields |= all_output_options[i].field;
+				break;
+			}
+		}
+		if (i == imax) {
+			fprintf(stderr, "Invalid field requested.");
+			rc = -EINVAL;
+			break;
+		}
+	
+		tok = strtok(NULL, ",");
+		if (!tok)
+			break;
+	}
+
+	free(str);
+	return rc;
+}
+
 /* Helper function for filesystems that return a dent->d_type DT_UNKNOWN */
 static int is_directory(const char *base_path, const struct dirent *dent)
 {
@@ -609,6 +762,19 @@ static const struct option options[] = {
 		    "input file name"),
 	OPT_BOOLEAN('d', "debug-mode", &debug_mode,
 		   "do various checks like samples ordering and lost events"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
+	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
+		   "file", "kallsyms pathname"),
+	OPT_BOOLEAN('G', "hide-call-graph", &no_callchain,
+		    "When printing symbols do not display call chain"),
+	OPT_BOOLEAN('U', "show-unresolved", &show_unresolved,
+		    "Display all entries including unresolved to a symbol"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
+	OPT_CALLBACK('f', "fields", NULL, "str",
+		     "comma separated output fields. Options: comm,tid,pid,time,cpu,sym,trace,event",
+		     parse_output_fields),
 
 	OPT_END()
 };
@@ -752,6 +918,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		exit(-1);
 	}
 
+	symbol_conf.use_callchain = no_callchain ? false : true;
+
 	if (rec_script_path)
 		script_path = rec_script_path;
 	if (rep_script_path)
@@ -790,13 +958,20 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		return -ENOMEM;
 
 	if (strcmp(input_name, "-") &&
-	    !perf_session__has_traces(session, "record -R"))
+		(perf_session__check_attr(session) < 0))
 		return -EINVAL;
 
 	if (generate_script_lang) {
 		struct stat perf_stat;
+		int input;
+
+		if (output_fields != output_fields_default) {
+			fprintf(stderr,
+				"custom fields not supported for generated scripts");
+			return -1;
+		}
 
-		int input = open(input_name, O_RDONLY);
+		input = open(input_name, O_RDONLY);
 		if (input < 0) {
 			perror("failed to open file");
 			exit(-1);
diff --git a/tools/perf/util/output.h b/tools/perf/util/output.h
new file mode 100644
index 0000000..9d79852
--- /dev/null
+++ b/tools/perf/util/output.h
@@ -0,0 +1,18 @@
+#ifndef _PERF_OUTPUT_H
+#define _PERF_OUTPUT_H
+
+enum perf_output_field {
+    PERF_OUTPUT_COMM            = 1U << 0,
+    PERF_OUTPUT_TID             = 1U << 1,
+    PERF_OUTPUT_PID             = 1U << 2,
+    PERF_OUTPUT_TIME            = 1U << 3,
+    PERF_OUTPUT_CPU             = 1U << 4,
+    PERF_OUTPUT_SYM             = 1U << 5,
+    PERF_OUTPUT_TRACE           = 1U << 6,
+    PERF_OUTPUT_EVNAME          = 1U << 7,
+};
+
+extern u64 output_fields;
+#define PRINT_FIELD(x)  (output_fields & PERF_OUTPUT_##x)
+
+#endif
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a3a871f..c862a71 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -10,6 +10,7 @@
 #include "session.h"
 #include "sort.h"
 #include "util.h"
+#include "trace-event.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -1137,3 +1138,77 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
 	size_t ret = machine__fprintf_dsos_buildid(&self->host_machine, fp, with_hits);
 	return ret + machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
 }
+
+void perf_session__print_symbols(union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_session *session,
+				bool show_unresolved)
+{
+	struct addr_location al;
+	const char *symname, *dsoname;
+	struct callchain_cursor *cursor = &session->callchain_cursor;
+	struct callchain_cursor_node *node;
+
+	if (perf_event__preprocess_sample(event, session, &al, sample,
+					  NULL) < 0) {
+		error("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return;
+	}
+
+	if (symbol_conf.use_callchain && sample->callchain) {
+
+		if (perf_session__resolve_callchain(session, al.thread,
+						sample->callchain, NULL) != 0) {
+			if (verbose)
+				error("Failed to resolve callchain. Skipping\n");
+			return;
+		}
+		callchain_cursor_commit(cursor);
+		if (cursor->nr == 0)
+			return;
+
+		while (1) {
+			node = callchain_cursor_current(cursor);
+			if (!node)
+				break;
+
+			if (node->sym && node->sym->name)
+				symname = node->sym->name;
+			else if (show_unresolved)
+				symname = "";
+			else
+				goto next;
+
+			if (node->map && node->map->dso && node->map->dso->name)
+				dsoname = node->map->dso->name;
+			else if (show_unresolved)
+				dsoname = "";
+			else
+				goto next;
+
+			printf("\t%16" PRIx64 " %s (%s)\n", node->ip, symname, dsoname);
+
+next:
+			callchain_cursor_advance(cursor);
+		}
+		printf("\n");
+
+	} else {
+		if (al.sym && al.sym->name)
+			symname = al.sym->name;
+		else if (show_unresolved)
+			symname = "";
+		else
+			return;
+
+		if (al.map && al.map->dso && al.map->dso->name)
+			dsoname = al.map->dso->name;
+		else if (show_unresolved)
+			dsoname = "";
+		else
+			return;
+
+		printf("%16" PRIx64 " %s (%s)\n", al.addr, symname, dsoname);
+	}
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 977b3a1..d77a2fa 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -165,4 +165,9 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					session->sample_id_all, sample);
 }
 
+void perf_session__print_symbols(union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_session *session,
+				bool show_unresolved);
+
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index d8e622d..9ac6524 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -32,6 +32,7 @@
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
+#include "output.h"
 
 int header_page_ts_offset;
 int header_page_ts_size;
@@ -2683,13 +2684,18 @@ static void print_graph_proc(int pid, const char *comm)
 	/* sign + log10(MAX_INT) + '\0' */
 	char pid_str[11];
 	int spaces = 0;
-	int len;
+	int len = 0;
 	int i;
 
 	sprintf(pid_str, "%d", pid);
 
 	/* 1 stands for the "-" character */
-	len = strlen(comm) + strlen(pid_str) + 1;
+	if (PRINT_FIELD(COMM) && PRINT_FIELD(PID))
+		len = strlen(comm) + strlen(pid_str) + 1;
+	else if (PRINT_FIELD(COMM))
+		len = strlen(comm);
+	else if (PRINT_FIELD(PID))
+		len = strlen(pid_str);
 
 	if (len < TRACE_GRAPH_PROCINFO_LENGTH)
 		spaces = TRACE_GRAPH_PROCINFO_LENGTH - len;
@@ -2698,7 +2704,12 @@ static void print_graph_proc(int pid, const char *comm)
 	for (i = 0; i < spaces / 2; i++)
 		printf(" ");
 
-	printf("%s-%s", comm, pid_str);
+	if (PRINT_FIELD(COMM) && PRINT_FIELD(PID))
+		printf("%s-%s", comm, pid_str);
+	else if (PRINT_FIELD(COMM))
+		printf("%s", comm);
+	else if (PRINT_FIELD(PID))
+		printf("%s", pid_str);
 
 	/* Last spaces to align center */
 	for (i = 0; i < spaces - (spaces / 2); i++)
@@ -2884,10 +2895,14 @@ pretty_print_func_ent(void *data, int size, struct event *event,
 	void *copy_data;
 	unsigned long val;
 
-	printf("%5lu.%06lu |  ", secs, usecs);
+	if (PRINT_FIELD(TIME))
+		printf("%5lu.%06lu |  ", secs, usecs);
+
+	if (PRINT_FIELD(CPU))
+		print_graph_cpu(cpu);
 
-	print_graph_cpu(cpu);
-	print_graph_proc(pid, comm);
+	if (PRINT_FIELD(COMM) || PRINT_FIELD(PID))
+		print_graph_proc(pid, comm);
 
 	printf(" | ");
 
@@ -2932,10 +2947,14 @@ pretty_print_func_ret(void *data, int size __unused, struct event *event,
 	struct format_field *field;
 	int i;
 
-	printf("%5lu.%06lu |  ", secs, usecs);
+	if (PRINT_FIELD(TIME))
+		printf("%5lu.%06lu |  ", secs, usecs);
+
+	if (PRINT_FIELD(CPU))
+		print_graph_cpu(cpu);
 
-	print_graph_cpu(cpu);
-	print_graph_proc(pid, comm);
+	if (PRINT_FIELD(COMM) || PRINT_FIELD(PID))
+		print_graph_proc(pid, comm);
 
 	printf(" | ");
 
@@ -2989,7 +3008,7 @@ pretty_print_func_graph(void *data, int size, struct event *event,
 }
 
 void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm)
+		 char *comm)
 {
 	struct event *event;
 	unsigned long secs;
@@ -3016,13 +3035,35 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 					       pid, comm, secs, usecs);
 
 	if (latency_format) {
-		printf("%8.8s-%-5d %3d",
-		       comm, pid, cpu);
+		if (PRINT_FIELD(COMM) && PRINT_FIELD(PID))
+			printf("%8.8s-%-5d", comm, pid);
+		else if (PRINT_FIELD(COMM))
+			printf("%8.8s", comm);
+		else if (PRINT_FIELD(PID))
+			printf("%5d", pid);
+
+		if (PRINT_FIELD(CPU))
+			printf(" %3d", cpu);
+
 		print_lat_fmt(data, size);
-	} else
-		printf("%16s-%-5d [%03d]", comm, pid,  cpu);
+	} else {
+		if (PRINT_FIELD(COMM) && PRINT_FIELD(PID))
+			printf("%16s-%-5d", comm, pid);
+		else if (PRINT_FIELD(COMM))
+			printf("%16s", comm);
+		else if (PRINT_FIELD(PID))
+			printf("%5d", pid);
+
+		if (PRINT_FIELD(CPU))
+			printf(" [%03d]", cpu);
+	}
 
-	printf(" %5lu.%06lu: %s: ", secs, usecs, event->name);
+	if (PRINT_FIELD(TIME))
+		printf(" %5lu.%06lu:", secs, usecs);
+
+	if (PRINT_FIELD(EVNAME))
+		printf(" %s:", event->name);
+	printf(" ");
 
 	if (event->flags & EVENT_FL_FAILED) {
 		printf("EVENT '%s' FAILED TO PARSE\n",
-- 
1.7.4

