Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab1CBR3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:29:16 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:50167 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab1CBR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:29:14 -0500
X-IronPort-AV: E=Sophos;i="4.62,254,1297036800"; 
   d="scan'208";a="268108900"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 3/3] perf script: dump software events and samples from hardware-based profiling
Date: Wed,  2 Mar 2011 10:29:20 -0700
Message-Id: <1299086960-26964-4-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299086960-26964-1-git-send-email-daahern@cisco.com>
References: <1299086960-26964-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line format follows tracepoints precedent:

 comm-pid [cpu] secs.usecs: event: IP symbol dso

Example:
    perf record -v -ga -e cs -c 1 -- sleep 5
    perf script

(Line lengths wrapped):

sshd-794 [000] 2572.863440: context-switches: ffffffff810355de \
    perf_event_task_sched_out ([kernel.kallsyms])
sshd-794 [000] 2572.863440: context-switches: ffffffff81382b01 \
    schedule ([kernel.kallsyms])
sshd-794 [000] 2572.863440: context-switches: ffffffff8138380a \
    schedule_hrtimeout_range_clock ([kernel.kallsyms])
sshd-794 [000] 2572.863440: context-switches: ffffffff813838e6 \
    schedule_hrtimeout_range ([kernel.kallsyms])
sshd-794 [000] 2572.863440: context-switches: ffffffff8110c55d \
    poll_schedule_timeout ([kernel.kallsyms])
sshd-794 [000] 2572.863440: context-switches: ffffffff8110cd84 \
    do_select ([kernel.kallsyms])

or 'perf script -G'

    swapper-0   [001] 2572.863188: context-switches: ffffffff810355de ...
       sshd-794 [000] 2572.863440: context-switches: ffffffff810355de ...
kworker/0:1-10  [000] 2572.863451: context-switches: ffffffff810355de ...

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/Documentation/perf-script.txt |   19 +++++
 tools/perf/builtin-script.c              |   32 +++++++++
 tools/perf/util/session.c                |  113 ++++++++++++++++++++++++++++++
 tools/perf/util/session.h                |    6 ++
 4 files changed, 170 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 29ad942..99db652 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -112,6 +112,25 @@ OPTIONS
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
+        Do not display call chain.
+
+--
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index f59d482..f1cad74b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -19,6 +19,8 @@ static bool			debug_mode;
 static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
+static bool			show_unresolved;
+static bool			no_callchain;
 
 static void process_event(union perf_event *event,
 			  struct perf_sample *sample,
@@ -57,6 +59,11 @@ static void process_event(union perf_event *event,
 		print_tracepoint_event(sample->cpu, sample->raw_data,
 				       sample->raw_size, sample->time,
 				       thread->comm);
+	} else if ((attr->type == PERF_TYPE_SOFTWARE) ||
+			((attr->type == PERF_TYPE_HARDWARE) && 
+			 (attr->config == PERF_COUNT_HW_CPU_CYCLES))) {
+		perf_session__print_sample(event, sample, session, attr,
+					   show_unresolved);
 	} else {
 		evname = __event_name(attr->type, attr->config);
 		if (verbose)
@@ -130,7 +137,10 @@ static int process_sample_event(union perf_event *event,
 
 static struct perf_event_ops event_ops = {
 	.sample		 = process_sample_event,
+	.mmap		 = perf_event__process_mmap,
 	.comm		 = perf_event__process_comm,
+	.exit		 = perf_event__process_task,
+	.fork		 = perf_event__process_task,
 	.attr		 = perf_event__process_attr,
 	.event_type	 = perf_event__process_event_type,
 	.tracing_data	 = perf_event__process_tracing_data,
@@ -620,6 +630,16 @@ static const struct option options[] = {
 		    "input file name"),
 	OPT_BOOLEAN('d', "debug-mode", &debug_mode,
 		   "do various checks like samples ordering and lost events"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
+	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
+		   "file", "kallsyms pathname"),
+	OPT_BOOLEAN('G', "hide-call-graph", &no_callchain,
+		    "Do not display call chain"),
+	OPT_BOOLEAN('U', "show-unresolved", &show_unresolved,
+		    "Display all entries including unresolved to a symbol"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
 
 	OPT_END()
 };
@@ -763,6 +783,18 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		exit(-1);
 	}
 
+	if (no_callchain)
+		symbol_conf.use_callchain = false;
+
+	else {
+		symbol_conf.use_callchain = true;
+		if (callchain_register_param(&callchain_param) < 0) {
+			error("Can't register callchain params\n");
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
 	if (rec_script_path)
 		script_path = rec_script_path;
 	if (rep_script_path)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a3a871f..a6c3a56 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -10,6 +10,7 @@
 #include "session.h"
 #include "sort.h"
 #include "util.h"
+#include "trace-event.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -1137,3 +1138,115 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
 	size_t ret = machine__fprintf_dsos_buildid(&self->host_machine, fp, with_hits);
 	return ret + machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
 }
+
+static inline void print_one_symbol(const char *comm, pid_t pid, 
+			u32 cpu, u64 secs, u64 usecs, const char *evname,
+			u64 addr, const char *symname, const char *dsoname)
+{
+	printf("%16s-%-5d ", comm, pid);
+
+	if (cpu != (u32) -1)
+		printf("[%03d]", cpu);
+
+	printf(" %5lu.%06lu: %s: ", secs, usecs, evname);
+
+	printf("%16" PRIx64 " %s (%s)\n",
+	       addr, symname, dsoname);
+
+	return;
+}
+
+void perf_session__print_sample(union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_session *session,
+				struct perf_event_attr *attr,
+				bool show_unresolved)
+{
+	struct callchain_cursor_node *node, *prev;
+	struct addr_location al;
+	const char *evname = NULL;
+	const char *comm;
+	const char *symname, *dsoname;
+	u32 cpu = -1;
+	u64 secs = 0, usecs = 0;
+
+	if (perf_event__preprocess_sample(event, session, &al, sample,
+					  NULL) < 0) {
+		error("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return;
+	}
+
+	if (session->sample_type & PERF_SAMPLE_TIME) {
+		u64 nsecs = sample->time;
+		secs = nsecs / NSECS_PER_SEC;
+		nsecs -= secs * NSECS_PER_SEC;
+		usecs = nsecs / NSECS_PER_USEC;
+	}
+
+   	evname = __event_name(attr->type, attr->config);
+	if  (!evname)
+		evname = "(unknown)";
+
+	comm = al.thread->comm_set ? al.thread->comm : "-";
+
+	if (attr->sample_type & PERF_SAMPLE_CPU)
+		cpu = sample->cpu;
+
+	if (symbol_conf.use_callchain && sample->callchain) {
+
+		if (perf_session__resolve_callchain(session, al.thread,
+						sample->callchain, NULL) != 0) {
+			if (verbose)
+				error("Failed to resolve callchain. Skipping\n");
+			return;
+		}
+
+		node = session->callchain_cursor.first;
+		if (!node)
+			return;
+
+		while (node) {
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
+			print_one_symbol(comm, al.thread->pid, cpu, secs, usecs,
+			             evname, node->ip, symname, dsoname);
+
+next:
+			prev = node;
+			node = node->next;
+		}
+		/* put a spacer between samples when callchains are dumped */
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
+		print_one_symbol(comm, al.thread->pid, cpu, secs, usecs,
+		             evname, al.addr, symname, dsoname);
+	}
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 977b3a1..3827048 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -165,4 +165,10 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					session->sample_id_all, sample);
 }
 
+void perf_session__print_sample(union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_session *session,
+				struct perf_event_attr *attr,
+				bool show_unresolved);
+
 #endif /* __PERF_SESSION_H */
-- 
1.7.4

