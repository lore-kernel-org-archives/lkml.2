Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1CPNz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:55:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:35744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1CPNzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:55:42 -0400
Date: Wed, 16 Mar 2011 13:55:15 GMT
From: tip-bot for David Ahern <daahern@cisco.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
In-Reply-To: <1299734608-5223-6-git-send-email-daahern@cisco.com>
References: <1299734608-5223-6-git-send-email-daahern@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script: Add support for dumping symbols
Message-ID: <tip-c0230b2bfbd16e42d937c34aed99e5d6493eb5e4@git.kernel.org>
Git-Commit-ID: c0230b2bfbd16e42d937c34aed99e5d6493eb5e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:55:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0230b2bfbd16e42d937c34aed99e5d6493eb5e4
Gitweb:     http://git.kernel.org/tip/c0230b2bfbd16e42d937c34aed99e5d6493eb5e4
Author:     David Ahern <daahern@cisco.com>
AuthorDate: Wed, 9 Mar 2011 22:23:27 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Mar 2011 17:06:50 -0300

perf script: Add support for dumping symbols

Add option to dump symbols found in events.

e.g., perf script -f comm,pid,tid,time,trace,sym

swapper     0/0       537.037184: prev_comm=swapper prev_pid=0 prev_prio=120...
        ffffffff81030350 perf_trace_sched_switch ([kernel.kallsyms])
        ffffffff81382ac5 schedule ([kernel.kallsyms])
        ffffffff8100134a cpu_idle ([kernel.kallsyms])
        ffffffff81370b39 rest_init ([kernel.kallsyms])
        ffffffff81696c23 start_kernel ([kernel.kallsyms].init.text)
        ffffffff816962af x86_64_start_reservations ([kernel.kallsyms].init.text)
        ffffffff816963b9 x86_64_start_kernel ([kernel.kallsyms].init.text)

sshd  1675/1675    537.037309: prev_comm=sshd prev_pid=1675 prev_prio=120...
        ffffffff81030350 perf_trace_sched_switch ([kernel.kallsyms])
        ffffffff81382ac5 schedule ([kernel.kallsyms])
        ffffffff813837aa schedule_hrtimeout_range_clock ([kernel.kallsyms])
        ffffffff81383886 schedule_hrtimeout_range ([kernel.kallsyms])
        ffffffff8110c4f9 poll_schedule_timeout ([kernel.kallsyms])
        ffffffff8110cd20 do_select ([kernel.kallsyms])
        ffffffff8110ced8 core_sys_select ([kernel.kallsyms])
        ffffffff8110d00d sys_select ([kernel.kallsyms])
        ffffffff81002bc2 system_call ([kernel.kallsyms])
            7f1647e56e93 __GI_select (/lib64/libc-2.12.90.so)

netstat  1692/1692    537.038664: prev_comm=netstat prev_pid=1692 prev_prio=...
        ffffffff81030350 perf_trace_sched_switch ([kernel.kallsyms])
        ffffffff81382ac5 schedule ([kernel.kallsyms])
        ffffffff81002c3a sysret_careful ([kernel.kallsyms])
            7f7a6cd1b210 __GI___libc_read (/lib64/libc-2.12.90.so)

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1299734608-5223-6-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |   16 +++++++-
 tools/perf/builtin-script.c              |   31 +++++++++++++++-
 tools/perf/util/session.c                |   61 ++++++++++++++++++++++++++++++
 tools/perf/util/session.h                |    4 ++
 4 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index b73cf58..c64118a 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,7 +115,21 @@ OPTIONS
 -f::
 --fields
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace
+        comm, tid, pid, time, cpu, event, trace, sym
+
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
+-G::
+--hide-call-graph::
+        When printing symbols do not display call chain.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index c046e6e..b45b09c 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -19,6 +19,7 @@ static bool			debug_mode;
 static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
+static bool			no_callchain;
 
 enum perf_output_field {
 	PERF_OUTPUT_COMM            = 1U << 0,
@@ -28,6 +29,7 @@ enum perf_output_field {
 	PERF_OUTPUT_CPU             = 1U << 4,
 	PERF_OUTPUT_EVNAME          = 1U << 5,
 	PERF_OUTPUT_TRACE           = 1U << 6,
+	PERF_OUTPUT_SYM             = 1U << 7,
 };
 
 struct output_option {
@@ -41,6 +43,7 @@ struct output_option {
 	{.str = "cpu",   .field = PERF_OUTPUT_CPU},
 	{.str = "event", .field = PERF_OUTPUT_EVNAME},
 	{.str = "trace", .field = PERF_OUTPUT_TRACE},
+	{.str = "sym",   .field = PERF_OUTPUT_SYM},
 };
 
 /* default set to maintain compatibility with current format */
@@ -65,6 +68,8 @@ static void print_sample_start(struct perf_sample *sample,
 	if (PRINT_FIELD(COMM)) {
 		if (latency_format)
 			printf("%8.8s ", thread->comm);
+		else if (PRINT_FIELD(SYM) && symbol_conf.use_callchain)
+			printf("%s ", thread->comm);
 		else
 			printf("%16s ", thread->comm);
 	}
@@ -112,6 +117,14 @@ static void process_event(union perf_event *event __unused,
 		print_trace_event(sample->cpu, sample->raw_data,
 				  sample->raw_size);
 
+	if (PRINT_FIELD(SYM)) {
+		if (!symbol_conf.use_callchain)
+			printf(" ");
+		else
+			printf("\n");
+		perf_session__print_symbols(event, sample, session);
+	}
+
 	printf("\n");
 }
 
@@ -190,7 +203,10 @@ static int process_sample_event(union perf_event *event,
 
 static struct perf_event_ops event_ops = {
 	.sample		 = process_sample_event,
+	.mmap		 = perf_event__process_mmap,
 	.comm		 = perf_event__process_comm,
+	.exit		 = perf_event__process_task,
+	.fork		 = perf_event__process_task,
 	.attr		 = perf_event__process_attr,
 	.event_type	 = perf_event__process_event_type,
 	.tracing_data	 = perf_event__process_tracing_data,
@@ -722,8 +738,16 @@ static const struct option options[] = {
 		    "input file name"),
 	OPT_BOOLEAN('d', "debug-mode", &debug_mode,
 		   "do various checks like samples ordering and lost events"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
+	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
+		   "file", "kallsyms pathname"),
+	OPT_BOOLEAN('G', "hide-call-graph", &no_callchain,
+		    "When printing symbols do not display call chain"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields. Options: comm,tid,pid,time,cpu,event,trace",
+		     "comma separated output fields. Options: comm,tid,pid,time,cpu,event,trace,sym",
 		     parse_output_fields),
 
 	OPT_END()
@@ -905,6 +929,11 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (!no_callchain && (session->sample_type & PERF_SAMPLE_CALLCHAIN))
+		symbol_conf.use_callchain = true;
+	else
+		symbol_conf.use_callchain = false;
+
 	if (strcmp(input_name, "-") &&
 	    !perf_session__has_traces(session, "record -R"))
 		return -EINVAL;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f26639f..c68cf40 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1134,3 +1134,64 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 
 	return ret;
 }
+
+void perf_session__print_symbols(union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_session *session)
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
+
+		while (1) {
+			node = callchain_cursor_current(cursor);
+			if (!node)
+				break;
+
+			if (node->sym && node->sym->name)
+				symname = node->sym->name;
+			else
+				symname = "";
+
+			if (node->map && node->map->dso && node->map->dso->name)
+				dsoname = node->map->dso->name;
+			else
+				dsoname = "";
+
+			printf("\t%16" PRIx64 " %s (%s)\n", node->ip, symname, dsoname);
+
+			callchain_cursor_advance(cursor);
+		}
+
+	} else {
+		if (al.sym && al.sym->name)
+			symname = al.sym->name;
+		else
+			symname = "";
+
+		if (al.map && al.map->dso && al.map->dso->name)
+			dsoname = al.map->dso->name;
+		else
+			dsoname = "";
+
+		printf("%16" PRIx64 " %s (%s)", al.addr, symname, dsoname);
+	}
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index b5b148b..0b3c9af 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -159,4 +159,8 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					session->sample_id_all, sample);
 }
 
+void perf_session__print_symbols(union perf_event *event,
+				 struct perf_sample *sample,
+				 struct perf_session *session);
+
 #endif /* __PERF_SESSION_H */
