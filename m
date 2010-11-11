Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0KKKjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:39:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45468 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab0KKKi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:38:58 -0500
Date: Thu, 11 Nov 2010 11:38:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20101111103837.GA16486@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Corey Ashford (1):
      perf: Fix usages of profile_cpu in builtin-top.c to use cpu_list

Cyrill Gorcunov (1):
      perf, ui: Eliminate stack-smashing protection compiler complaint

Peter Zijlstra (1):
      perf, amd: Use kmalloc_node(,__GFP_ZERO) for northbridge structure allocation

Stephane Eranian (1):
      perf_events: Fix time tracking in samples

Tom Zanussi (7):
      perf trace scripting: fix some small memory leaks and missing error checks
      perf trace scripting: remove system-wide param from shell scripts
      perf record: make the record options available outside perf record
      perf trace record: handle commands correctly
      perf trace: live-mode command-line cleanup
      perf trace: update Documentation with new perf trace variants
      perf trace: update usage


 arch/x86/kernel/cpu/perf_event_amd.c               |    4 +-
 include/linux/perf_event.h                         |   10 +
 kernel/perf_event.c                                |   42 ++++-
 tools/perf/Documentation/perf-trace.txt            |   57 +++++-
 tools/perf/builtin-record.c                        |   10 +-
 tools/perf/builtin-top.c                           |   12 +-
 tools/perf/builtin-trace.c                         |  209 ++++++++++++++------
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-record      |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +-
 tools/perf/scripts/perl/bin/rwtop-record           |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-record  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +-
 .../python/bin/failed-syscalls-by-pid-record       |    2 +-
 .../scripts/python/bin/futex-contention-record     |    2 +-
 tools/perf/scripts/python/bin/netdev-times-record  |    2 +-
 .../perf/scripts/python/bin/sched-migration-record |    2 +-
 tools/perf/scripts/python/bin/sctop-record         |    2 +-
 .../python/bin/syscall-counts-by-pid-record        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +-
 tools/perf/util/ui/util.c                          |    5 +-
 21 files changed, 271 insertions(+), 104 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 46d5844..e421b8c 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -280,11 +280,11 @@ static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
 	struct amd_nb *nb;
 	int i;
 
-	nb = kmalloc(sizeof(struct amd_nb), GFP_KERNEL);
+	nb = kmalloc_node(sizeof(struct amd_nb), GFP_KERNEL | __GFP_ZERO,
+			  cpu_to_node(cpu));
 	if (!nb)
 		return NULL;
 
-	memset(nb, 0, sizeof(*nb));
 	nb->nb_id = nb_id;
 
 	/*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 057bf22..40150f3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -747,6 +747,16 @@ struct perf_event {
 	u64				tstamp_running;
 	u64				tstamp_stopped;
 
+	/*
+	 * timestamp shadows the actual context timing but it can
+	 * be safely used in NMI interrupt context. It reflects the
+	 * context time as it was when the event was last scheduled in.
+	 *
+	 * ctx_time already accounts for ctx->timestamp. Therefore to
+	 * compute ctx_time for a sample, simply add perf_clock().
+	 */
+	u64				shadow_ctx_time;
+
 	struct perf_event_attr		attr;
 	struct hw_perf_event		hw;
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 517d827..cb6c0d2 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -674,6 +674,8 @@ event_sched_in(struct perf_event *event,
 
 	event->tstamp_running += ctx->time - event->tstamp_stopped;
 
+	event->shadow_ctx_time = ctx->time - ctx->timestamp;
+
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
@@ -3396,7 +3398,8 @@ static u32 perf_event_tid(struct perf_event *event, struct task_struct *p)
 }
 
 static void perf_output_read_one(struct perf_output_handle *handle,
-				 struct perf_event *event)
+				 struct perf_event *event,
+				 u64 enabled, u64 running)
 {
 	u64 read_format = event->attr.read_format;
 	u64 values[4];
@@ -3404,11 +3407,11 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 
 	values[n++] = perf_event_count(event);
 	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
-		values[n++] = event->total_time_enabled +
+		values[n++] = enabled +
 			atomic64_read(&event->child_total_time_enabled);
 	}
 	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
-		values[n++] = event->total_time_running +
+		values[n++] = running +
 			atomic64_read(&event->child_total_time_running);
 	}
 	if (read_format & PERF_FORMAT_ID)
@@ -3421,7 +3424,8 @@ static void perf_output_read_one(struct perf_output_handle *handle,
  * XXX PERF_FORMAT_GROUP vs inherited events seems difficult.
  */
 static void perf_output_read_group(struct perf_output_handle *handle,
-			    struct perf_event *event)
+			    struct perf_event *event,
+			    u64 enabled, u64 running)
 {
 	struct perf_event *leader = event->group_leader, *sub;
 	u64 read_format = event->attr.read_format;
@@ -3431,10 +3435,10 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	values[n++] = 1 + leader->nr_siblings;
 
 	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
-		values[n++] = leader->total_time_enabled;
+		values[n++] = enabled;
 
 	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
-		values[n++] = leader->total_time_running;
+		values[n++] = running;
 
 	if (leader != event)
 		leader->pmu->read(leader);
@@ -3459,13 +3463,35 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	}
 }
 
+#define PERF_FORMAT_TOTAL_TIMES (PERF_FORMAT_TOTAL_TIME_ENABLED|\
+				 PERF_FORMAT_TOTAL_TIME_RUNNING)
+
 static void perf_output_read(struct perf_output_handle *handle,
 			     struct perf_event *event)
 {
+	u64 enabled = 0, running = 0, now, ctx_time;
+	u64 read_format = event->attr.read_format;
+
+	/*
+	 * compute total_time_enabled, total_time_running
+	 * based on snapshot values taken when the event
+	 * was last scheduled in.
+	 *
+	 * we cannot simply called update_context_time()
+	 * because of locking issue as we are called in
+	 * NMI context
+	 */
+	if (read_format & PERF_FORMAT_TOTAL_TIMES) {
+		now = perf_clock();
+		ctx_time = event->shadow_ctx_time + now;
+		enabled = ctx_time - event->tstamp_enabled;
+		running = ctx_time - event->tstamp_running;
+	}
+
 	if (event->attr.read_format & PERF_FORMAT_GROUP)
-		perf_output_read_group(handle, event);
+		perf_output_read_group(handle, event, enabled, running);
 	else
-		perf_output_read_one(handle, event);
+		perf_output_read_one(handle, event, enabled, running);
 }
 
 void perf_output_sample(struct perf_output_handle *handle,
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 122ec9d..26aff6b 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -8,7 +8,11 @@ perf-trace - Read perf.data (created by perf record) and display trace output
 SYNOPSIS
 --------
 [verse]
-'perf trace' {record <script> | report <script> [args] }
+'perf trace' [<options>]
+'perf trace' [<options>] record <script> [<record-options>] <command>
+'perf trace' [<options>] report <script> [script-args]
+'perf trace' [<options>] <script> <required-script-args> [<record-options>] <command>
+'perf trace' [<options>] <top-script> [script-args]
 
 DESCRIPTION
 -----------
@@ -24,23 +28,53 @@ There are several variants of perf trace:
   available via 'perf trace -l').  The following variants allow you to
   record and run those scripts:
 
-  'perf trace record <script>' to record the events required for 'perf
-  trace report'.  <script> is the name displayed in the output of
-  'perf trace --list' i.e. the actual script name minus any language
-  extension.
+  'perf trace record <script> <command>' to record the events required
+  for 'perf trace report'.  <script> is the name displayed in the
+  output of 'perf trace --list' i.e. the actual script name minus any
+  language extension.  If <command> is not specified, the events are
+  recorded using the -a (system-wide) 'perf record' option.
 
-  'perf trace report <script>' to run and display the results of
-  <script>.  <script> is the name displayed in the output of 'perf
+  'perf trace report <script> [args]' to run and display the results
+  of <script>.  <script> is the name displayed in the output of 'perf
   trace --list' i.e. the actual script name minus any language
   extension.  The perf.data output from a previous run of 'perf trace
   record <script>' is used and should be present for this command to
-  succeed.
+  succeed.  [args] refers to the (mainly optional) args expected by
+  the script.
+
+  'perf trace <script> <required-script-args> <command>' to both
+  record the events required for <script> and to run the <script>
+  using 'live-mode' i.e. without writing anything to disk.  <script>
+  is the name displayed in the output of 'perf trace --list' i.e. the
+  actual script name minus any language extension.  If <command> is
+  not specified, the events are recorded using the -a (system-wide)
+  'perf record' option.  If <script> has any required args, they
+  should be specified before <command>.  This mode doesn't allow for
+  optional script args to be specified; if optional script args are
+  desired, they can be specified using separate 'perf trace record'
+  and 'perf trace report' commands, with the stdout of the record step
+  piped to the stdin of the report script, using the '-o -' and '-i -'
+  options of the corresponding commands.
+
+  'perf trace <top-script>' to both record the events required for
+  <top-script> and to run the <top-script> using 'live-mode'
+  i.e. without writing anything to disk.  <top-script> is the name
+  displayed in the output of 'perf trace --list' i.e. the actual
+  script name minus any language extension; a <top-script> is defined
+  as any script name ending with the string 'top'.
+
+  [<record-options>] can be passed to the record steps of 'perf trace
+  record' and 'live-mode' variants; this isn't possible however for
+  <top-script> 'live-mode' or 'perf trace report' variants.
 
   See the 'SEE ALSO' section for links to language-specific
   information on how to write and run your own trace scripts.
 
 OPTIONS
 -------
+<command>...::
+	Any command you can specify in a shell.
+
 -D::
 --dump-raw-trace=::
         Display verbose dump of the trace data.
@@ -64,6 +98,13 @@ OPTIONS
         Generate perf-trace.[ext] starter script for given language,
         using current perf.data.
 
+-a::
+        Force system-wide collection.  Scripts run without a <command>
+        normally use -a by default, while scripts run with a <command>
+        normally don't - this option allows the latter to be run in
+        system-wide mode.
+
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-trace-perl[1],
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4e75583..93bd2ff 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -790,7 +790,7 @@ static const char * const record_usage[] = {
 
 static bool force, append_file;
 
-static const struct option options[] = {
+const struct option record_options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
@@ -839,16 +839,16 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
 	int i, j, err = -ENOMEM;
 
-	argc = parse_options(argc, argv, options, record_usage,
+	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target_pid == -1 && target_tid == -1 &&
 		!system_wide && !cpu_list)
-		usage_with_options(record_usage, options);
+		usage_with_options(record_usage, record_options);
 
 	if (force && append_file) {
 		fprintf(stderr, "Can't overwrite and append at the same time."
 				" You need to choose between -f and -A");
-		usage_with_options(record_usage, options);
+		usage_with_options(record_usage, record_options);
 	} else if (append_file) {
 		write_mode = WRITE_APPEND;
 	} else {
@@ -871,7 +871,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		if (thread_num <= 0) {
 			fprintf(stderr, "Can't find all threads of pid %d\n",
 					target_pid);
-			usage_with_options(record_usage, options);
+			usage_with_options(record_usage, record_options);
 		}
 	} else {
 		all_tids=malloc(sizeof(pid_t));
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b513e40..dd62580 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -69,7 +69,6 @@ static int			target_tid			=     -1;
 static pid_t			*all_tids			=      NULL;
 static int			thread_num			=      0;
 static bool			inherit				=  false;
-static int			profile_cpu			=     -1;
 static int			nr_cpus				=      0;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
@@ -558,13 +557,13 @@ static void print_sym_table(void)
 	else
 		printf(" (all");
 
-	if (profile_cpu != -1)
-		printf(", cpu: %d)\n", profile_cpu);
+	if (cpu_list)
+		printf(", CPU%s: %s)\n", nr_cpus > 1 ? "s" : "", cpu_list);
 	else {
 		if (target_tid != -1)
 			printf(")\n");
 		else
-			printf(", %d CPUs)\n", nr_cpus);
+			printf(", %d CPU%s)\n", nr_cpus, nr_cpus > 1 ? "s" : "");
 	}
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
@@ -1187,11 +1186,10 @@ int group_fd;
 static void start_counter(int i, int counter)
 {
 	struct perf_event_attr *attr;
-	int cpu;
+	int cpu = -1;
 	int thread_index;
 
-	cpu = profile_cpu;
-	if (target_tid == -1 && profile_cpu == -1)
+	if (target_tid == -1)
 		cpu = cpumap[i];
 
 	attr = attrs + counter;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2f8df45..86cfe38 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -10,6 +10,7 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/trace-event.h"
+#include "util/parse-options.h"
 #include "util/util.h"
 
 static char const		*script_name;
@@ -17,6 +18,7 @@ static char const		*generate_script_lang;
 static bool			debug_mode;
 static u64			last_timestamp;
 static u64			nr_unordered;
+extern const struct option	record_options[];
 
 static int default_start_script(const char *script __unused,
 				int argc __unused,
@@ -328,7 +330,7 @@ static struct script_desc *script_desc__new(const char *name)
 {
 	struct script_desc *s = zalloc(sizeof(*s));
 
-	if (s != NULL)
+	if (s != NULL && name)
 		s->name = strdup(name);
 
 	return s;
@@ -337,6 +339,8 @@ static struct script_desc *script_desc__new(const char *name)
 static void script_desc__delete(struct script_desc *s)
 {
 	free(s->name);
+	free(s->half_liner);
+	free(s->args);
 	free(s);
 }
 
@@ -537,8 +541,40 @@ static char *get_script_path(const char *script_root, const char *suffix)
 	return path;
 }
 
+static bool is_top_script(const char *script_path)
+{
+	return ends_with((char *)script_path, "top") == NULL ? false : true;
+}
+
+static int has_required_arg(char *script_path)
+{
+	struct script_desc *desc;
+	int n_args = 0;
+	char *p;
+
+	desc = script_desc__new(NULL);
+
+	if (read_script_info(desc, script_path))
+		goto out;
+
+	if (!desc->args)
+		goto out;
+
+	for (p = desc->args; *p; p++)
+		if (*p == '<')
+			n_args++;
+out:
+	script_desc__delete(desc);
+
+	return n_args;
+}
+
 static const char * const trace_usage[] = {
-	"perf trace [<options>] <command>",
+	"perf trace [<options>]",
+	"perf trace [<options>] record <script> [<record-options>] <command>",
+	"perf trace [<options>] report <script> [script-args]",
+	"perf trace [<options>] <script> [<record-options>] <command>",
+	"perf trace [<options>] <top-script> [script-args]",
 	NULL
 };
 
@@ -564,50 +600,81 @@ static const struct option options[] = {
 	OPT_END()
 };
 
+static bool have_cmd(int argc, const char **argv)
+{
+	char **__argv = malloc(sizeof(const char *) * argc);
+
+	if (!__argv)
+		die("malloc");
+	memcpy(__argv, argv, sizeof(const char *) * argc);
+	argc = parse_options(argc, (const char **)__argv, record_options,
+			     NULL, PARSE_OPT_STOP_AT_NON_OPTION);
+	free(__argv);
+
+	return argc != 0;
+}
+
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
 {
+	char *rec_script_path = NULL;
+	char *rep_script_path = NULL;
 	struct perf_session *session;
-	const char *suffix = NULL;
+	char *script_path = NULL;
 	const char **__argv;
-	char *script_path;
-	int i, err;
+	bool system_wide;
+	int i, j, err;
 
-	if (argc >= 2 && strncmp(argv[1], "rec", strlen("rec")) == 0) {
-		if (argc < 3) {
-			fprintf(stderr,
-				"Please specify a record script\n");
-			return -1;
-		}
-		suffix = RECORD_SUFFIX;
+	setup_scripting();
+
+	argc = parse_options(argc, argv, options, trace_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+
+	if (argc > 1 && !strncmp(argv[0], "rec", strlen("rec"))) {
+		rec_script_path = get_script_path(argv[1], RECORD_SUFFIX);
+		if (!rec_script_path)
+			return cmd_record(argc, argv, NULL);
 	}
 
-	if (argc >= 2 && strncmp(argv[1], "rep", strlen("rep")) == 0) {
-		if (argc < 3) {
+	if (argc > 1 && !strncmp(argv[0], "rep", strlen("rep"))) {
+		rep_script_path = get_script_path(argv[1], REPORT_SUFFIX);
+		if (!rep_script_path) {
 			fprintf(stderr,
-				"Please specify a report script\n");
+				"Please specify a valid report script"
+				"(see 'perf trace -l' for listing)\n");
 			return -1;
 		}
-		suffix = REPORT_SUFFIX;
 	}
 
 	/* make sure PERF_EXEC_PATH is set for scripts */
 	perf_set_argv_exec_path(perf_exec_path());
 
-	if (!suffix && argc >= 2 && strncmp(argv[1], "-", strlen("-")) != 0) {
-		char *record_script_path, *report_script_path;
+	if (argc && !script_name && !rec_script_path && !rep_script_path) {
 		int live_pipe[2];
+		int rep_args;
 		pid_t pid;
 
-		record_script_path = get_script_path(argv[1], RECORD_SUFFIX);
-		if (!record_script_path) {
-			fprintf(stderr, "record script not found\n");
-			return -1;
+		rec_script_path = get_script_path(argv[0], RECORD_SUFFIX);
+		rep_script_path = get_script_path(argv[0], REPORT_SUFFIX);
+
+		if (!rec_script_path && !rep_script_path) {
+			fprintf(stderr, " Couldn't find script %s\n\n See perf"
+				" trace -l for available scripts.\n", argv[0]);
+			usage_with_options(trace_usage, options);
 		}
 
-		report_script_path = get_script_path(argv[1], REPORT_SUFFIX);
-		if (!report_script_path) {
-			fprintf(stderr, "report script not found\n");
-			return -1;
+		if (is_top_script(argv[0])) {
+			rep_args = argc - 1;
+		} else {
+			int rec_args;
+
+			rep_args = has_required_arg(rep_script_path);
+			rec_args = (argc - 1) - rep_args;
+			if (rec_args < 0) {
+				fprintf(stderr, " %s script requires options."
+					"\n\n See perf trace -l for available "
+					"scripts and options.\n", argv[0]);
+				usage_with_options(trace_usage, options);
+			}
 		}
 
 		if (pipe(live_pipe) < 0) {
@@ -622,60 +689,84 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		}
 
 		if (!pid) {
+			system_wide = true;
+			j = 0;
+
 			dup2(live_pipe[1], 1);
 			close(live_pipe[0]);
 
-			__argv = malloc(6 * sizeof(const char *));
-			__argv[0] = "/bin/sh";
-			__argv[1] = record_script_path;
-			__argv[2] = "-q";
-			__argv[3] = "-o";
-			__argv[4] = "-";
-			__argv[5] = NULL;
+			if (!is_top_script(argv[0]))
+				system_wide = !have_cmd(argc - rep_args,
+							&argv[rep_args]);
+
+			__argv = malloc((argc + 6) * sizeof(const char *));
+			if (!__argv)
+				die("malloc");
+
+			__argv[j++] = "/bin/sh";
+			__argv[j++] = rec_script_path;
+			if (system_wide)
+				__argv[j++] = "-a";
+			__argv[j++] = "-q";
+			__argv[j++] = "-o";
+			__argv[j++] = "-";
+			for (i = rep_args + 1; i < argc; i++)
+				__argv[j++] = argv[i];
+			__argv[j++] = NULL;
 
 			execvp("/bin/sh", (char **)__argv);
+			free(__argv);
 			exit(-1);
 		}
 
 		dup2(live_pipe[0], 0);
 		close(live_pipe[1]);
 
-		__argv = malloc((argc + 3) * sizeof(const char *));
-		__argv[0] = "/bin/sh";
-		__argv[1] = report_script_path;
-		for (i = 2; i < argc; i++)
-			__argv[i] = argv[i];
-		__argv[i++] = "-i";
-		__argv[i++] = "-";
-		__argv[i++] = NULL;
+		__argv = malloc((argc + 4) * sizeof(const char *));
+		if (!__argv)
+			die("malloc");
+		j = 0;
+		__argv[j++] = "/bin/sh";
+		__argv[j++] = rep_script_path;
+		for (i = 1; i < rep_args + 1; i++)
+			__argv[j++] = argv[i];
+		__argv[j++] = "-i";
+		__argv[j++] = "-";
+		__argv[j++] = NULL;
 
 		execvp("/bin/sh", (char **)__argv);
+		free(__argv);
 		exit(-1);
 	}
 
-	if (suffix) {
-		script_path = get_script_path(argv[2], suffix);
-		if (!script_path) {
-			fprintf(stderr, "script not found\n");
-			return -1;
-		}
-
-		__argv = malloc((argc + 1) * sizeof(const char *));
-		__argv[0] = "/bin/sh";
-		__argv[1] = script_path;
-		for (i = 3; i < argc; i++)
-			__argv[i - 1] = argv[i];
-		__argv[argc - 1] = NULL;
+	if (rec_script_path)
+		script_path = rec_script_path;
+	if (rep_script_path)
+		script_path = rep_script_path;
+
+	if (script_path) {
+		system_wide = false;
+		j = 0;
+
+		if (rec_script_path)
+			system_wide = !have_cmd(argc - 1, &argv[1]);
+
+		__argv = malloc((argc + 2) * sizeof(const char *));
+		if (!__argv)
+			die("malloc");
+		__argv[j++] = "/bin/sh";
+		__argv[j++] = script_path;
+		if (system_wide)
+			__argv[j++] = "-a";
+		for (i = 2; i < argc; i++)
+			__argv[j++] = argv[i];
+		__argv[j++] = NULL;
 
 		execvp("/bin/sh", (char **)__argv);
+		free(__argv);
 		exit(-1);
 	}
 
-	setup_scripting();
-
-	argc = parse_options(argc, argv, options, trace_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
-
 	if (symbol__init() < 0)
 		return -1;
 	if (!script_name)
diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-record b/tools/perf/scripts/perl/bin/failed-syscalls-record
index eb5846b..8104895 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-record
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e raw_syscalls:sys_exit $@
+perf record -e raw_syscalls:sys_exit $@
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-record b/tools/perf/scripts/perl/bin/rw-by-file-record
index 5bfaae5..33efc86 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-record
+++ b/tools/perf/scripts/perl/bin/rw-by-file-record
@@ -1,3 +1,3 @@
 #!/bin/bash
-perf record -a -e syscalls:sys_enter_read -e syscalls:sys_enter_write $@
+perf record -e syscalls:sys_enter_read -e syscalls:sys_enter_write $@
 
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-record b/tools/perf/scripts/perl/bin/rw-by-pid-record
index 6e0b2f7..7cb9db2 100644
--- a/tools/perf/scripts/perl/bin/rw-by-pid-record
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
+perf record -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
diff --git a/tools/perf/scripts/perl/bin/rwtop-record b/tools/perf/scripts/perl/bin/rwtop-record
index 6e0b2f7..7cb9db2 100644
--- a/tools/perf/scripts/perl/bin/rwtop-record
+++ b/tools/perf/scripts/perl/bin/rwtop-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
+perf record -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-record b/tools/perf/scripts/perl/bin/wakeup-latency-record
index 9f2acaa..464251a 100644
--- a/tools/perf/scripts/perl/bin/wakeup-latency-record
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-record
@@ -1,5 +1,5 @@
 #!/bin/bash
-perf record -a -e sched:sched_switch -e sched:sched_wakeup $@
+perf record -e sched:sched_switch -e sched:sched_wakeup $@
 
 
 
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-record b/tools/perf/scripts/perl/bin/workqueue-stats-record
index 85301f2..8edda90 100644
--- a/tools/perf/scripts/perl/bin/workqueue-stats-record
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion $@
+perf record -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion $@
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
index eb5846b..8104895 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e raw_syscalls:sys_exit $@
+perf record -e raw_syscalls:sys_exit $@
diff --git a/tools/perf/scripts/python/bin/futex-contention-record b/tools/perf/scripts/python/bin/futex-contention-record
index 5ecbb43..b1495c9 100644
--- a/tools/perf/scripts/python/bin/futex-contention-record
+++ b/tools/perf/scripts/python/bin/futex-contention-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e syscalls:sys_enter_futex -e syscalls:sys_exit_futex $@
+perf record -e syscalls:sys_enter_futex -e syscalls:sys_exit_futex $@
diff --git a/tools/perf/scripts/python/bin/netdev-times-record b/tools/perf/scripts/python/bin/netdev-times-record
index d931a82..558754b 100644
--- a/tools/perf/scripts/python/bin/netdev-times-record
+++ b/tools/perf/scripts/python/bin/netdev-times-record
@@ -1,5 +1,5 @@
 #!/bin/bash
-perf record -a -e net:net_dev_xmit -e net:net_dev_queue		\
+perf record -e net:net_dev_xmit -e net:net_dev_queue		\
 		-e net:netif_receive_skb -e net:netif_rx		\
 		-e skb:consume_skb -e skb:kfree_skb			\
 		-e skb:skb_copy_datagram_iovec -e napi:napi_poll	\
diff --git a/tools/perf/scripts/python/bin/sched-migration-record b/tools/perf/scripts/python/bin/sched-migration-record
index 17a3e9b..7493fdd 100644
--- a/tools/perf/scripts/python/bin/sched-migration-record
+++ b/tools/perf/scripts/python/bin/sched-migration-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -m 16384 -a -e sched:sched_wakeup -e sched:sched_wakeup_new -e sched:sched_switch -e sched:sched_migrate_task $@
+perf record -m 16384 -e sched:sched_wakeup -e sched:sched_wakeup_new -e sched:sched_switch -e sched:sched_migrate_task $@
diff --git a/tools/perf/scripts/python/bin/sctop-record b/tools/perf/scripts/python/bin/sctop-record
index 1fc5998..4efbfaa 100644
--- a/tools/perf/scripts/python/bin/sctop-record
+++ b/tools/perf/scripts/python/bin/sctop-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e raw_syscalls:sys_enter $@
+perf record -e raw_syscalls:sys_enter $@
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
index 1fc5998..4efbfaa 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e raw_syscalls:sys_enter $@
+perf record -e raw_syscalls:sys_enter $@
diff --git a/tools/perf/scripts/python/bin/syscall-counts-record b/tools/perf/scripts/python/bin/syscall-counts-record
index 1fc5998..4efbfaa 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e raw_syscalls:sys_enter $@
+perf record -e raw_syscalls:sys_enter $@
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 9706d9d..056c695 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -104,9 +104,10 @@ out_destroy_form:
 	return rc;
 }
 
+static const char yes[] = "Yes", no[] = "No";
+
 bool ui__dialog_yesno(const char *msg)
 {
 	/* newtWinChoice should really be accepting const char pointers... */
-	char yes[] = "Yes", no[] = "No";
-	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
+	return newtWinChoice(NULL, (char *)yes, (char *)no, (char *)msg) == 1;
 }
