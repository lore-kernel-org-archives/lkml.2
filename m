Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab1BRFyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 00:54:08 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:29254 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1BRFyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 00:54:04 -0500
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.62,185,1297036800"; 
   d="scan'208";a="265626821"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@ghostprotocols.net,
        paulus@samba.org, David Ahern <daahern@cisco.com>
Subject: [PATCH 3/3] perf events: add timehist option to record and report
Date: Thu, 17 Feb 2011 22:53:53 -0700
Message-Id: <1298008433-22911-4-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298008433-22911-1-git-send-email-daahern@cisco.com>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of the timehist option is to 'pretty-print' the samples
recorded rather than generating a histogram. This is done by
sampling the realtime clock event and correlating perf_clock time
stamps to wall-clock.

If the realtime-clock event is not available (e.g, older kernels)
fallback to a synthesized event. (I realize there is resistance
to new synthesized events, but it is a simple way to gain this
feature on older kernels without the new to modify the kernel
code).

NOTE: Commit ba3dd36 needs to be reverted else this causes the
system to spin. Ironically, ba3dd36 was created to resolve a
lockup.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/Documentation/perf-record.txt |    4 +
 tools/perf/Documentation/perf-report.txt |    6 +
 tools/perf/builtin-record.c              |   78 +++++++++++-
 tools/perf/builtin-report.c              |  208 +++++++++++++++++++++++++++++-
 tools/perf/util/event.c                  |    1 +
 tools/perf/util/event.h                  |    8 +
 tools/perf/util/parse-events.c           |    2 +
 tools/perf/util/session.c                |    4 +
 tools/perf/util/session.h                |    3 +-
 9 files changed, 310 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 5a520f8..8ae106b 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -148,6 +148,10 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
 corresponding events, i.e., they always refer to events defined earlier on the command
 line.
 
+--timehist::
+Collect data for time history report. This generates reference time samples
+which are used to convert perf timestamps to time-of-day.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 8ba03d6..aaaf035 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -119,6 +119,12 @@ OPTIONS
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
 
+--timehist::
+        Generate time history output. This shows each sample with a wall-clock
+        timestamp and address to symbol conversions. The samples are output in
+        the same order they exist in the perf.data file. The --timehist option
+        must be used with the record to get wall-clock timestamps.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a4aaadc..91d49a3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -55,6 +55,8 @@ static bool			nodelay				=  false;
 static bool			raw_samples			=  false;
 static bool			sample_id_all_avail		=   true;
 static bool			system_wide			=  false;
+static bool			time_history			=  false;
+static struct perf_evsel	*th_evsel			= NULL;
 static pid_t			target_pid			=     -1;
 static pid_t			target_tid			=     -1;
 static pid_t			child_pid			=     -1;
@@ -276,6 +278,11 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (time_history) {
+		attr->sample_type   |= PERF_SAMPLE_TIME;
+		attr->sample_type   |= PERF_SAMPLE_CPU;
+	}
+
 	if (nodelay) {
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
@@ -290,6 +297,56 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	}
 }
 
+static int perf_event__synthesize_reftime(perf_event__handler_t process,
+		struct perf_session *psession)
+{
+	union perf_event ev;
+	struct timespec tp;
+
+	memset(&ev, 0, sizeof(ev));
+
+	/* race here between successive calls, but should be close enough */
+	if (gettimeofday(&ev.reftime.tv, NULL) != 0) {
+		error("gettimeofday failed. Cannot generate reference time.\n");
+		return -1;
+	}
+	if (clock_gettime(CLOCK_MONOTONIC, &tp) != 0) {
+		error("clock_gettime failed. Cannot generate reference time.\n");
+		return -1;
+	}
+	ev.reftime.nsec = (u64) tp.tv_sec * NSEC_PER_SEC + (u64) tp.tv_nsec;
+
+	ev.header.type = PERF_RECORD_REFTIME;
+	ev.header.size = sizeof(ev.reftime);
+
+	return process(&ev, NULL, psession);
+}
+
+static struct perf_evsel *create_timehist_counter(void)
+{
+	struct perf_event_attr attr;
+	struct perf_evsel *evsel;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_SOFTWARE;
+	attr.config = PERF_COUNT_SW_REALTIME_CLOCK;
+
+	/* need raw to get realtime clock samples and want sample
+	 * time for correlating the two
+	 */
+	attr.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_ID | PERF_SAMPLE_TIME;
+	attr.read_format = PERF_FORMAT_ID;
+
+	/* TO-DO: make this time configurable */
+	attr.sample_period = 1 * NSEC_PER_SEC;
+
+	evsel = perf_evsel__new(&attr, evsel_list->nr_entries);
+	if (!evsel)
+		die("Error: Failed to allocate memory for time counter\n");
+
+	return evsel;
+}
+
 static void open_counters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos;
@@ -331,7 +388,8 @@ try_again:
 				 * Old kernel, no attr->sample_id_type_all field
 				 */
 				sample_id_all_avail = false;
-				if (!sample_time && !raw_samples && !time_needed)
+				if (!sample_time && !raw_samples
+						&& !time_needed && !time_history)
 					attr->sample_type &= ~PERF_SAMPLE_TIME;
 
 				goto retry_sample_id;
@@ -612,6 +670,16 @@ static int __cmd_record(int argc, const char **argv)
 			return err;
 	}
 
+	if (time_history && !th_evsel) {
+		if (verbose)
+			warning ("REALTIME_CLOCK event failed. "
+		         	"falling back to synthesized clock events\n");
+
+		if (perf_event__synthesize_reftime(process_synthesized_event,
+		                                   session) != 0)
+			error("Failed to synthesize reftime event. SOL.\n");
+	}
+
 	post_processing_offset = lseek(output, 0, SEEK_CUR);
 
 	perf_session__set_sample_id_all(session, sample_id_all_avail);
@@ -810,6 +878,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
+	OPT_BOOLEAN(0, "timehist", &time_history,
+		    "collect data for time history report"),
 	OPT_END()
 };
 
@@ -855,6 +925,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
+	if (time_history) {
+		th_evsel = create_timehist_counter();
+		if (th_evsel)
+			perf_evlist__add(evsel_list, th_evsel);
+	}
+
 	if (target_pid != -1)
 		target_tid = target_pid;
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f9a99a1..59002d6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -36,6 +36,7 @@ static char		const *input_name = "perf.data";
 static bool		force, use_tui, use_stdio;
 static bool		hide_unresolved;
 static bool		dont_use_callchains;
+static bool		time_history;
 
 static bool		show_threads;
 static struct perf_read_values	show_threads_values;
@@ -46,6 +47,189 @@ static const char	*pretty_printing_style = default_pretty_printing_style;
 static char		callchain_default_opt[] = "fractal,0.5";
 static symbol_filter_t	annotate_init;
 
+
+struct timeval tv_ref;
+u64 timestamp_ref;
+
+static const char *timestr(u64 timestamp)
+{
+	struct tm ltime;
+	u64 dt;
+	struct timeval tv_dt, tv_res;
+	static char tstr[64];
+
+	if (timestamp_ref == 0) {
+		static bool show_msg = true;
+		if (show_msg) {
+			fprintf(stderr, "Reference clock event not found in file; "
+			                "Cannot generate wall-clock time strings\n");
+			show_msg = false;
+		}
+		snprintf(tstr, sizeof(tstr), "%16" PRId64, timestamp);
+		return tstr;
+	} else if (timestamp == 0) {
+		snprintf(tstr, sizeof(tstr), "%16" PRId64, timestamp);
+		return tstr;
+	}
+	if (timestamp > timestamp_ref) {
+		dt = timestamp - timestamp_ref;
+		tv_dt.tv_sec = (time_t) (dt / NSEC_PER_SEC);
+		tv_dt.tv_usec = (dt - tv_dt.tv_sec * NSEC_PER_SEC) / 1000;
+		timeradd(&tv_ref, &tv_dt, &tv_res);
+	} else {
+		dt = timestamp_ref - timestamp;
+		tv_dt.tv_sec = (time_t) (dt / NSEC_PER_SEC);
+		tv_dt.tv_usec = (dt - tv_dt.tv_sec * NSEC_PER_SEC) / 1000;
+		timersub(&tv_ref, &tv_dt, &tv_res);
+	}
+
+	if (localtime_r(&tv_res.tv_sec, &ltime) == NULL) {
+		snprintf(tstr, sizeof(tstr), "00:00:00.000000 %16" PRId64, timestamp);
+	} else {
+		char date[64];
+		strftime(date, sizeof(date), "%H:%M:%S", &ltime);
+		snprintf(tstr, sizeof(tstr), "%s.%06ld %16" PRId64,
+		         date, tv_res.tv_usec, timestamp);
+	}
+
+	return tstr;
+}
+
+#define TIMEHIST_FMT  "%32s  %2d  %s  %s %d  %16" PRIx64 " %s (%s)\n"
+
+static void timehist_header(void)
+{
+	printf("%32s %s  %7s  %3s %5s  %16s %s (%s)\n\n",
+		   "  Time-of-Day   Kernel Timestamp",
+	       "cpu", "Event", "Command", "PID",
+	       "    IP    ", "Symbol Name", "DSO Name");
+}
+
+static int perf_event__process_reftime(union perf_event *event,
+                 struct perf_session *session __used)
+{
+	tv_ref = event->reftime.tv;
+	timestamp_ref = event->reftime.nsec;
+
+	return 0;
+}
+
+static void perf_event__process_rclk(struct perf_sample *sample,
+                 struct perf_session *session)
+{
+	u64 s;
+
+	if (!sample->raw_size) {
+		printf("rclk sample does not have raw data.\n");
+		return;
+	}
+
+	if (sample->raw_size != sizeof(u64)) {
+		printf("rclk sample has raw size %d; expected %ld.\n",
+		       sample->raw_size, sizeof(u64));
+		return;
+	}
+	if (!(session->sample_type & PERF_SAMPLE_TIME)) {
+		printf("rclk sample does not have kernel sample time\n");
+		return;
+	}
+
+	/* convert raw sample to wall-clock reference time */
+	s = *(u64*)sample->raw_data;
+	tv_ref.tv_sec = s / NSEC_PER_SEC;
+	tv_ref.tv_usec = (s - tv_ref.tv_sec * NSEC_PER_SEC) / 1000;
+	
+	/* match raw sample with kernel timestamp */
+	timestamp_ref = sample->time;
+}
+
+static void perf_session__print_sample(struct perf_session *session,
+					struct addr_location *al,
+					struct perf_sample *sample)
+{
+	static int show_timehist_error = 1;
+	struct callchain_cursor_node *node, *prev;
+	u64 timestamp = 0;
+	const char *tstr;
+	bool need_spacer = false;
+	struct perf_event_attr *attr;
+	const char *evname = NULL;
+	const char *symname = "", *dsoname = "";
+
+	if (show_timehist_error && ((sample->cpu == (u32) -1) ||
+		 !(session->sample_type & PERF_SAMPLE_TIME))) {
+		pr_err("Data for time history missing in perf event samples.\n"
+		       "Did you record with --timehist option?\n");
+		show_timehist_error = 0;
+	}
+
+	attr = perf_header__find_attr(sample->id, &session->header);
+	if (attr)
+   		evname = __event_name(attr->type, attr->config);
+
+	if (session->sample_type & PERF_SAMPLE_TIME)
+		timestamp = sample->time;
+
+	tstr = timestr(timestamp);
+
+	if ((symbol_conf.use_callchain) && sample->callchain) {
+
+		if (perf_session__resolve_callchain(session, al->thread,
+						   sample->callchain, NULL) != 0) {
+			fprintf(stderr, "failed to resolve callchain. skipping\n");
+			return;
+		}
+
+		node = session->callchain_cursor.first;
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
+			printf(TIMEHIST_FMT,
+			   tstr, sample->cpu, evname ? evname : "-",
+			   al->thread->comm_set ? al->thread->comm : "-",
+			   al->thread->pid,
+			   node->ip,
+			   symname, dsoname);
+
+			need_spacer = true;
+
+			prev = node;
+			node = node->next;
+		}
+
+	} else {
+		if (al->sym && al->sym->name)
+			symname = al->sym->name;
+
+		if (al->map && al->map->dso && al->map->dso->name)
+			dsoname = al->map->dso->name;
+
+		printf(TIMEHIST_FMT,
+			   tstr, sample->cpu, evname ? evname : "-",
+			   al->thread->comm_set ? al->thread->comm : "-",
+			   al->thread->pid, al->addr,
+			   symname, dsoname);
+
+		need_spacer = true;
+	}
+
+	/* put a gap between records */
+	if (need_spacer)
+		printf("\n");
+
+	return;
+}
+
+
 static struct hists *perf_session__hists_findnew(struct perf_session *self,
 						 u64 event_stream, u32 type,
 						 u64 config)
@@ -167,6 +351,15 @@ static int process_sample_event(union perf_event *event,
 	struct addr_location al;
 	struct perf_event_attr *attr;
 
+	attr = perf_header__find_attr(sample->id, &session->header);
+	if (attr &&
+		(attr->type == PERF_TYPE_SOFTWARE) &&
+		(attr->config == PERF_COUNT_SW_REALTIME_CLOCK)) {
+		perf_event__process_rclk(sample, session);
+		if (time_history)
+			return 0;
+	}
+
 	if (perf_event__preprocess_sample(event, session, &al, sample,
 					  annotate_init) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
@@ -177,7 +370,9 @@ static int process_sample_event(union perf_event *event,
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
-	if (perf_session__add_hist_entry(session, &al, sample)) {
+	if (time_history) {
+		perf_session__print_sample(session, &al, sample);
+	} else if (perf_session__add_hist_entry(session, &al, sample)) {
 		pr_debug("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
@@ -257,6 +452,7 @@ static struct perf_event_ops event_ops = {
 	.event_type	 = perf_event__process_event_type,
 	.tracing_data	 = perf_event__process_tracing_data,
 	.build_id	 = perf_event__process_build_id,
+	.reftime	 = perf_event__process_reftime,
 	.ordered_samples = true,
 	.ordering_requires_timestamps = true,
 };
@@ -334,6 +530,9 @@ static int __cmd_report(void)
 	if (ret)
 		goto out_delete;
 
+	if (time_history)
+		timehist_header();
+
 	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
@@ -349,6 +548,9 @@ static int __cmd_report(void)
 	if (verbose > 2)
 		perf_session__fprintf_dsos(session, stdout);
 
+	if (time_history)
+		goto out_delete;
+
 	next = rb_first(&session->hists_tree);
 	while (next) {
 		struct hists *hists;
@@ -498,6 +700,8 @@ static const struct option options[] = {
 		    "Only display entries resolved to a symbol"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
+	OPT_BOOLEAN(0, "timehist", &time_history,
+		    "Dump time history of event samples"),
 	OPT_END()
 };
 
@@ -505,7 +709,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
-	if (use_stdio)
+	if (use_stdio || time_history)
 		use_browser = 0;
 	else if (use_tui)
 		use_browser = 1;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index fbf5754..6bbd551 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -24,6 +24,7 @@ static const char *perf_event__names[] = {
 	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
 	[PERF_RECORD_HEADER_BUILD_ID]	 = "BUILD_ID",
 	[PERF_RECORD_FINISHED_ROUND]	 = "FINISHED_ROUND",
+	[PERF_RECORD_REFTIME]		 = "REF_TIME",
 };
 
 const char *perf_event__name(unsigned int id)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 9c35170..4ba112d 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -91,6 +91,7 @@ enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_TRACING_DATA		= 66,
 	PERF_RECORD_HEADER_BUILD_ID		= 67,
 	PERF_RECORD_FINISHED_ROUND		= 68,
+	PERF_RECORD_REFTIME			= 69,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -117,6 +118,12 @@ struct tracing_data_event {
 	u32 size;
 };
 
+struct reftime_event {
+	struct perf_event_header header;
+	struct timeval tv;
+	u64 nsec;
+};
+
 union perf_event {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -130,6 +137,7 @@ union perf_event {
 	struct event_type_event		event_type;
 	struct tracing_data_event	tracing_data;
 	struct build_id_event		build_id;
+	struct reftime_event		reftime;
 };
 
 void perf_event__print_totals(void);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index cf082da..eb143a1 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -40,6 +40,7 @@ static struct event_symbol event_symbols[] = {
   { CHW(BUS_CYCLES),		"bus-cycles",		""		},
 
   { CSW(CPU_CLOCK),		"cpu-clock",		""		},
+  { CSW(REALTIME_CLOCK),	"realtime-clock",	"rclk"		},
   { CSW(TASK_CLOCK),		"task-clock",		""		},
   { CSW(PAGE_FAULTS),		"page-faults",		"faults"	},
   { CSW(PAGE_FAULTS_MIN),	"minor-faults",		""		},
@@ -78,6 +79,7 @@ static const char *sw_event_names[] = {
 	"major-faults",
 	"alignment-faults",
 	"emulation-faults",
+	"realtime-clock-msecs",
 };
 
 #define MAX_ALIASES 8
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a3a871f..a07d96f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -779,6 +779,10 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		return ops->build_id(event, session);
 	case PERF_RECORD_FINISHED_ROUND:
 		return ops->finished_round(event, session, ops);
+	case PERF_RECORD_REFTIME:
+		if (ops->reftime)
+			return ops->reftime(event, session);
+		return -EINVAL;
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 977b3a1..687d2b7 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -77,7 +77,8 @@ struct perf_event_ops {
 	event_synth_op	attr,
 			event_type,
 			tracing_data,
-			build_id;
+			build_id,
+			reftime;
 	event_op2	finished_round;
 	bool		ordered_samples;
 	bool		ordering_requires_timestamps;
-- 
1.7.3.4

