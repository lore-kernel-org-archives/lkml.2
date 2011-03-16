Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab1CPN4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:56:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:35750 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab1CPNz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:55:56 -0400
Date: Wed, 16 Mar 2011 13:55:35 GMT
From: tip-bot for David Ahern <daahern@cisco.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
In-Reply-To: <1299734608-5223-7-git-send-email-daahern@cisco.com>
References: <1299734608-5223-7-git-send-email-daahern@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script: Add support for H/W and S/W events
Message-ID: <tip-1424dc96807909438282663079adc7f27c10b4a5@git.kernel.org>
Git-Commit-ID: 1424dc96807909438282663079adc7f27c10b4a5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:55:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1424dc96807909438282663079adc7f27c10b4a5
Gitweb:     http://git.kernel.org/tip/1424dc96807909438282663079adc7f27c10b4a5
Author:     David Ahern <daahern@cisco.com>
AuthorDate: Wed, 9 Mar 2011 22:23:28 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Mar 2011 17:07:20 -0300

perf script: Add support for H/W and S/W events

Custom fields set for each type by prepending field argument with type.
For file with multiple event types (e.g., trace and S/W) display of an
event type suppressed by setting output fields to "".

e.g.,
perf record -ga -e sched:sched_switch -e cpu-clock -c 10000000 -R -- sleep 1
perf script

openssl 11496 [000]  9711.807107: cpu-clock-msecs:
        ffffffff810c22dc arch_local_irq_restore ([kernel.kallsyms])
        ffffffff810c518c __alloc_pages_nodemask ([kernel.kallsyms])
        ffffffff810297b2 pte_alloc_one ([kernel.kallsyms])
        ffffffff810d8b98 __pte_alloc ([kernel.kallsyms])
        ffffffff810daf07 handle_mm_fault ([kernel.kallsyms])
        ffffffff8138763a do_page_fault ([kernel.kallsyms])
        ffffffff81384a65 page_fault ([kernel.kallsyms])
            7f6130507d70 asn1_check_tlen (/lib64/libcrypto.so.1.0.0c)
                       0  ()

         openssl 11496 [000]  9711.808042: sched_switch: prev_comm=openssl ...
     kworker/0:0     4 [000]  9711.808067: sched_switch: prev_comm=kworker/...
         swapper     0 [001]  9711.808090: sched_switch: prev_comm=kworker/...
            sshd 11451 [001]  9711.808185: sched_switch: prev_comm=sshd pre...
swapper     0 [001]  9711.816155: cpu-clock-msecs:
        ffffffff81023609 native_safe_halt ([kernel.kallsyms])
        ffffffff8100132a cpu_idle ([kernel.kallsyms])
        ffffffff8137cf9b start_secondary ([kernel.kallsyms])

openssl 11496 [000]  9711.817104: cpu-clock-msecs:
            7f61304ad723 AES_cbc_encrypt (/lib64/libcrypto.so.1.0.0c)
            7fff3402f950  ()
        12f0debc9a785634  ()

swapper     0 [001]  9711.826155: cpu-clock-msecs:
        ffffffff81023609 native_safe_halt ([kernel.kallsyms])
        ffffffff8100132a cpu_idle ([kernel.kallsyms])
        ffffffff8137cf9b start_secondary ([kernel.kallsyms])

To suppress trace events within the file and use default output for S/W events:
perf script -f trace:

or to suppress S/W events and do default display for trace events:
perf script -f sw:

Custom field selections:
perf script -f sw:comm,tid,time -f trace:time,trace

         openssl 11496  9711.797162:
         swapper     0  9711.807071:
         openssl 11496  9711.807107:
 9711.808042: prev_comm=openssl prev_pid=11496 prev_prio=120 prev_state=R ...
 9711.808067: prev_comm=kworker/0:0 prev_pid=4 prev_prio=120 prev_state=S ...
 9711.808090: prev_comm=kworker/0:0 prev_pid=0 prev_prio=120 prev_state=R ...
 9711.808185: prev_comm=sshd prev_pid=11451 prev_prio=120 prev_state=S ==>...
         swapper     0  9711.816155:
         openssl 11496  9711.817104:
         swapper     0  9711.826155:

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1299734608-5223-7-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |    5 +-
 tools/perf/builtin-script.c              |  155 +++++++++++++++++++++++-------
 tools/perf/util/parse-events.c           |   22 ++++
 tools/perf/util/parse-events.h           |    1 +
 4 files changed, 147 insertions(+), 36 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index c64118a..66f040b 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,7 +115,10 @@ OPTIONS
 -f::
 --fields
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, sym
+        comm, tid, pid, time, cpu, event, trace, sym. Field
+        list must be prepended with the type, trace, sw or hw,
+        to indicate to which event type the field list applies.
+        e.g., -f sw:comm,tid,time,sym  and -f trace:time,cpu,trace
 
 -k::
 --vmlinux=<file>::
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b45b09c..9f5fc54 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -12,6 +12,8 @@
 #include "util/trace-event.h"
 #include "util/parse-options.h"
 #include "util/util.h"
+#include "util/evlist.h"
+#include "util/evsel.h"
 
 static char const		*script_name;
 static char const		*generate_script_lang;
@@ -47,16 +49,65 @@ struct output_option {
 };
 
 /* default set to maintain compatibility with current format */
-static u64 output_fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
-			   PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
-			   PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE;
+static u64 output_fields[PERF_TYPE_MAX] = {
+	[PERF_TYPE_HARDWARE] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
+			       PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
+			       PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+
+	[PERF_TYPE_SOFTWARE] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
+			       PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
+			       PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+
+	[PERF_TYPE_TRACEPOINT] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
+				 PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
+				 PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
+};
 
 static bool output_set_by_user;
 
-#define PRINT_FIELD(x)  (output_fields & PERF_OUTPUT_##x)
+#define PRINT_FIELD(x)  (output_fields[attr->type] & PERF_OUTPUT_##x)
+
+static int perf_session__check_attr(struct perf_session *session,
+				    struct perf_event_attr *attr)
+{
+	if (PRINT_FIELD(TRACE) &&
+		!perf_session__has_traces(session, "record -R"))
+		return -EINVAL;
+
+	if (PRINT_FIELD(SYM)) {
+		if (!(session->sample_type & PERF_SAMPLE_IP)) {
+			pr_err("Samples do not contain IP data.\n");
+			return -EINVAL;
+		}
+		if (!no_callchain &&
+		    !(session->sample_type & PERF_SAMPLE_CALLCHAIN))
+			symbol_conf.use_callchain = false;
+	}
+
+	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
+		!(session->sample_type & PERF_SAMPLE_TID)) {
+		pr_err("Samples do not contain TID/PID data.\n");
+		return -EINVAL;
+	}
+
+	if (PRINT_FIELD(TIME) &&
+		!(session->sample_type & PERF_SAMPLE_TIME)) {
+		pr_err("Samples do not contain timestamps.\n");
+		return -EINVAL;
+	}
+
+	if (PRINT_FIELD(CPU) &&
+		!(session->sample_type & PERF_SAMPLE_CPU)) {
+		pr_err("Samples do not contain cpu.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
 
 static void print_sample_start(struct perf_sample *sample,
-			       struct thread *thread)
+			       struct thread *thread,
+			       struct perf_event_attr *attr)
 {
 	int type;
 	struct event *event;
@@ -97,10 +148,13 @@ static void print_sample_start(struct perf_sample *sample,
 	}
 
 	if (PRINT_FIELD(EVNAME)) {
-		type = trace_parse_common_type(sample->raw_data);
-		event = trace_find_event(type);
-		if (event)
-			evname = event->name;
+		if (attr->type == PERF_TYPE_TRACEPOINT) {
+			type = trace_parse_common_type(sample->raw_data);
+			event = trace_find_event(type);
+			if (event)
+				evname = event->name;
+		} else
+			evname = __event_name(attr->type, attr->config);
 
 		printf("%s: ", evname ? evname : "(unknown)");
 	}
@@ -108,10 +162,27 @@ static void print_sample_start(struct perf_sample *sample,
 
 static void process_event(union perf_event *event __unused,
 			  struct perf_sample *sample,
-			  struct perf_session *session __unused,
+			  struct perf_session *session,
 			  struct thread *thread)
 {
-	print_sample_start(sample, thread);
+	struct perf_event_attr *attr;
+	struct perf_evsel *evsel;
+
+	evsel = perf_evlist__id2evsel(session->evlist, sample->id);
+	if (evsel == NULL) {
+		pr_err("Invalid data. Contains samples with id not in "
+		       "its header!\n");
+		return;
+	}
+	attr = &evsel->attr;
+
+	if (output_fields[attr->type] == 0)
+		return;
+
+	if (perf_session__check_attr(session, attr) < 0)
+		return;
+
+	print_sample_start(sample, thread, attr);
 
 	if (PRINT_FIELD(TRACE))
 		print_trace_event(sample->cpu, sample->raw_data,
@@ -183,19 +254,17 @@ static int process_sample_event(union perf_event *event,
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
-		scripting_ops->process_event(event, sample, session, thread);
+		last_timestamp = sample->time;
+		return 0;
 	}
+	scripting_ops->process_event(event, sample, session, thread);
 
 	session->hists.stats.total_period += sample->period;
 	return 0;
@@ -391,21 +460,40 @@ static int parse_output_fields(const struct option *opt __used,
 	int i, imax = sizeof(all_output_options) / sizeof(struct output_option);
 	int rc = 0;
 	char *str = strdup(arg);
+	int type = -1;
 
 	if (!str)
 		return -ENOMEM;
 
-	tok = strtok(str, ",");
+	tok = strtok(str, ":");
 	if (!tok) {
-		fprintf(stderr, "Invalid field string.");
+		fprintf(stderr,
+			"Invalid field string - not prepended with type.");
+		return -EINVAL;
+	}
+
+	/* first word should state which event type user
+	 * is specifying the fields
+	 */
+	if (!strcmp(tok, "hw"))
+		type = PERF_TYPE_HARDWARE;
+	else if (!strcmp(tok, "sw"))
+		type = PERF_TYPE_SOFTWARE;
+	else if (!strcmp(tok, "trace"))
+		type = PERF_TYPE_TRACEPOINT;
+	else {
+		fprintf(stderr, "Invalid event type in field string.");
 		return -EINVAL;
 	}
 
-	output_fields = 0;
+	output_fields[type] = 0;
 	while (1) {
+		tok = strtok(NULL, ",");
+		if (!tok)
+			break;
 		for (i = 0; i < imax; ++i) {
 			if (strcmp(tok, all_output_options[i].str) == 0) {
-				output_fields |= all_output_options[i].field;
+				output_fields[type] |= all_output_options[i].field;
 				break;
 			}
 		}
@@ -414,10 +502,11 @@ static int parse_output_fields(const struct option *opt __used,
 			rc = -EINVAL;
 			break;
 		}
+	}
 
-		tok = strtok(NULL, ",");
-		if (!tok)
-			break;
+	if (output_fields[type] == 0) {
+		pr_debug("No fields requested for %s type. "
+			 "Events will not be displayed\n", event_type(type));
 	}
 
 	output_set_by_user = true;
@@ -747,7 +836,7 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields. Options: comm,tid,pid,time,cpu,event,trace,sym",
+		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace. Fields: comm,tid,pid,time,cpu,event,trace,sym",
 		     parse_output_fields),
 
 	OPT_END()
@@ -929,15 +1018,11 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (!no_callchain && (session->sample_type & PERF_SAMPLE_CALLCHAIN))
+	if (!no_callchain)
 		symbol_conf.use_callchain = true;
 	else
 		symbol_conf.use_callchain = false;
 
-	if (strcmp(input_name, "-") &&
-	    !perf_session__has_traces(session, "record -R"))
-		return -EINVAL;
-
 	if (generate_script_lang) {
 		struct stat perf_stat;
 		int input;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 54a7e26..952b4ae 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -263,6 +263,28 @@ static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
 	return name;
 }
 
+const char *event_type(int type)
+{
+	switch (type) {
+	case PERF_TYPE_HARDWARE:
+		return "hardware";
+
+	case PERF_TYPE_SOFTWARE:
+		return "software";
+
+	case PERF_TYPE_TRACEPOINT:
+		return "tracepoint";
+
+	case PERF_TYPE_HW_CACHE:
+		return "hardware-cache";
+
+	default:
+		break;
+	}
+
+	return "unknown";
+}
+
 const char *event_name(struct perf_evsel *evsel)
 {
 	u64 config = evsel->attr.config;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 212f88e..746d3fc 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -20,6 +20,7 @@ struct tracepoint_path {
 extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 extern bool have_tracepoints(struct list_head *evlist);
 
+const char *event_type(int type);
 const char *event_name(struct perf_evsel *event);
 extern const char *__event_name(int type, u64 config);
 
