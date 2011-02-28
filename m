Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1B1Dwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 22:52:55 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:34937 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab1B1Dw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 22:52:28 -0500
X-IronPort-AV: E=Sophos;i="4.62,237,1297036800"; 
   d="scan'208";a="335905782"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 4/6] perf script: dump software events too
Date: Sun, 27 Feb 2011 20:52:29 -0700
Message-Id: <1298865151-23656-5-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298865151-23656-1-git-send-email-daahern@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call chain options mirror perf-report.  Line format follows
tracepoints precedent:

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

swapper-0 [001] 2572.863188: context-switches: ffffffff810355de ...
sshd-794  [000] 2572.863440: context-switches: ffffffff810355de ...
kworker/0:1-10 [000] 2572.863451: context-switches: ffffffff810355de ...

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-script.c |   65 +++++++++++++++++++++++++++--
 tools/perf/util/session.c   |   94 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h   |    3 +
 3 files changed, 157 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 5f40df6..4f4c63b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -19,6 +19,8 @@ static bool			debug_mode;
 static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
+static bool			hide_unresolved;
+static bool			no_callchain;
 
 static int default_start_script(const char *script __unused,
 				int argc __unused,
@@ -67,7 +69,11 @@ static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_session *session)
 {
+	struct perf_event_attr *attr;
+	struct addr_location al;
 	struct thread *thread = perf_session__findnew(session, event->ip.pid);
+	const char *evname = NULL;
+	static bool check_raw = true;
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -75,7 +81,31 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
-	if (session->sample_type & PERF_SAMPLE_RAW) {
+	attr = perf_header__find_attr(sample->id, &session->header);
+	if (!attr) {
+		pr_debug("No attributes found for sample id %" PRId64 ". "
+		         "skipping it.\n", sample->id);
+		return -1;
+	}
+
+	switch (attr->type) {
+	case PERF_TYPE_SOFTWARE:
+		if (perf_event__preprocess_sample(event, session, &al, sample,
+					  NULL) < 0) {
+			fprintf(stderr, "problem processing %d event, skipping it.\n",
+				event->header.type);
+			return -1;
+		}
+		perf_session__print_sample(session, &al, sample, hide_unresolved);
+		break;
+
+	case PERF_TYPE_TRACEPOINT:
+		if (check_raw) {
+			if (!perf_session__has_traces(session, "record -R"))
+				return -EINVAL;
+			check_raw = false;
+		}
+
 		if (debug_mode) {
 			if (sample->time < last_timestamp) {
 				pr_err("Samples misordered, previous: %" PRIu64
@@ -94,6 +124,13 @@ static int process_sample_event(union perf_event *event,
 		scripting_ops->process_event(sample->cpu, sample->raw_data,
 					     sample->raw_size,
 					     sample->time, thread->comm);
+		break;
+
+	default:
+   		evname = __event_name(attr->type, attr->config);
+		if (verbose)
+			warning("support for event %s not implemented. skipping\n",
+			evname ? evname : "(unknown)");
 	}
 
 	session->hists.stats.total_period += sample->period;
@@ -592,6 +629,16 @@ static const struct option options[] = {
 		    "input file name"),
 	OPT_BOOLEAN('d', "debug-mode", &debug_mode,
 		   "do various checks like samples ordering and lost events"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
+	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
+		   "file", "kallsyms pathname"),
+	OPT_BOOLEAN('G', "hide-call-graph", &no_callchain,
+		    "Do not display call chain"),
+	OPT_BOOLEAN('U', "hide-unresolved", &hide_unresolved,
+		    "Only display entries resolved to a symbol"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
 
 	OPT_END()
 };
@@ -735,6 +782,18 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
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
@@ -772,10 +831,6 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (strcmp(input_name, "-") &&
-	    !perf_session__has_traces(session, "record -R"))
-		return -EINVAL;
-
 	if (generate_script_lang) {
 		struct stat perf_stat;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1ef8e8a..7d46351 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -10,6 +10,7 @@
 #include "session.h"
 #include "sort.h"
 #include "util.h"
+#include "trace-event.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -1153,3 +1154,96 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
 	size_t ret = machine__fprintf_dsos_buildid(&self->host_machine, fp, with_hits);
 	return ret + machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
 }
+
+static inline void print_sample(const char *comm, pid_t pid, 
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
+void perf_session__print_sample(struct perf_session *session,
+				struct addr_location *al,
+				struct perf_sample *sample,
+				bool hide_unresolved)
+{
+	struct callchain_cursor_node *node, *prev;
+	struct perf_event_attr *attr;
+	const char *evname = NULL;
+	const char *symname = "", *dsoname = "";
+	const char *comm = al->thread->comm_set ? al->thread->comm : "-";
+	u32 cpu = -1;
+	u64 secs = 0, usecs = 0;
+
+	if (session->sample_type & PERF_SAMPLE_TIME) {
+		u64 nsecs = sample->time;
+		secs = nsecs / NSECS_PER_SEC;
+		nsecs -= secs * NSECS_PER_SEC;
+		usecs = nsecs / NSECS_PER_USEC;
+	}
+
+	attr = perf_header__find_attr(sample->id, &session->header);
+	if (attr)
+   		evname = __event_name(attr->type, attr->config);
+	
+	if  (!evname)
+		evname = "(unknown)";
+
+	if (attr && (attr->sample_type & PERF_SAMPLE_CPU))
+		cpu = sample->cpu;
+
+	if (symbol_conf.use_callchain && sample->callchain) {
+
+		if (perf_session__resolve_callchain(session, al->thread,
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
+
+			if (node->sym && node->sym->name)
+				symname = node->sym->name;
+			else if (hide_unresolved)
+				continue;
+
+			if (node->map && node->map->dso && node->map->dso->name)
+				dsoname = node->map->dso->name;
+			else if (hide_unresolved)
+				continue;
+
+			print_sample(comm, al->thread->pid, cpu, secs, usecs,
+			             evname, node->ip, symname, dsoname);
+
+			prev = node;
+			node = node->next;
+		}
+		/* put a spacer between samples when callchains are dumped */
+		printf("\n");
+
+	} else {
+		if (al->sym && al->sym->name)
+			symname = al->sym->name;
+
+		if (al->map && al->map->dso && al->map->dso->name)
+			dsoname = al->map->dso->name;
+
+		print_sample(comm, al->thread->pid, cpu, secs, usecs,
+		             evname, al->addr, symname, dsoname);
+	}
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index b46672a..ff8791d 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -170,4 +170,7 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					sample);
 }
 
+void perf_session__print_sample(struct perf_session *session,
+					struct addr_location *al, struct perf_sample *sample,
+					bool hide_unresolved);
 #endif /* __PERF_SESSION_H */
-- 
1.7.4

