Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1BUVCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:02:43 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:3740 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab1BUVCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:02:39 -0500
X-IronPort-AV: E=Sophos;i="4.62,202,1297036800"; 
   d="scan'208";a="267921616"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 3/4] perf events: add timehist option to record and report
Date: Mon, 21 Feb 2011 14:02:29 -0700
Message-Id: <1298322150-15505-4-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298322150-15505-1-git-send-email-daahern@cisco.com>
References: <1298322150-15505-1-git-send-email-daahern@cisco.com>
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
feature on older kernels without the need to modify the kernel
code).

Signed-off-by: David Ahern <daahern@cisco.com>
---
 include/linux/perf_event.h               |    1 +
 kernel/perf_event.c                      |   19 +++
 tools/perf/Documentation/perf-record.txt |    4 +
 tools/perf/Documentation/perf-report.txt |    6 +
 tools/perf/builtin-record.c              |  108 +++++++++++++++-
 tools/perf/builtin-report.c              |  208 +++++++++++++++++++++++++++++-
 tools/perf/util/event.c                  |    1 +
 tools/perf/util/event.h                  |    8 +
 tools/perf/util/evlist.c                 |    2 +-
 tools/perf/util/evlist.h                 |    2 +
 tools/perf/util/session.c                |    4 +
 tools/perf/util/session.h                |    3 +-
 12 files changed, 360 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 51a2f34..404b1ee 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -240,6 +240,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
+#define PERF_EVENT_IOC_RECORD_SAMPLE	_IO('$', 7)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 85f60c0..0e1053e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3231,6 +3231,7 @@ static struct perf_event *perf_fget_light(int fd, int *fput_needed)
 static int perf_event_set_output(struct perf_event *event,
 				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
+static int perf_event_generate_sample(struct perf_event *event);
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -3277,6 +3278,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
 
+	case PERF_EVENT_IOC_RECORD_SAMPLE:
+		return perf_event_generate_sample(event);
+
 	default:
 		return -ENOTTY;
 	}
@@ -4379,6 +4383,21 @@ exit:
 	rcu_read_unlock();
 }
 
+/* add a sample to the event stream based on user request */
+static int perf_event_generate_sample(struct perf_event *event)
+{
+	struct perf_sample_data data;
+	struct pt_regs regs;
+
+	perf_fetch_caller_regs(&regs);
+	event->pmu->read(event);
+	perf_sample_data_init(&data, 0);
+	data.period = event->hw.last_period;
+	perf_event_output(event, 0, &data, &regs);
+
+	return 0;
+}
+
 /*
  * read event_id
  */
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 5a520f8..437d041 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -148,6 +148,10 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
 corresponding events, i.e., they always refer to events defined earlier on the command
 line.
 
+--timehist::
+Collect data for time history report. This option adds reference time samples
+to the event stream for converting perf timestamps to time-of-day.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 8ba03d6..27b98e0 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -119,6 +119,12 @@ OPTIONS
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
 
+--timehist::
+        Generate time history output. This shows each sample with a wall-clock
+        timestamp and address to symbol conversions. The --timehist option
+        must be used with the record to get wall-clock timestamps.
+
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e39883e..dd06949 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -56,6 +56,8 @@ static bool			nodelay				=  false;
 static bool			raw_samples			=  false;
 static bool			sample_id_all_avail		=   true;
 static bool			system_wide			=  false;
+static bool			time_history			=  false;
+static bool			synth_reftime			=  false;
 static pid_t			target_pid			=     -1;
 static pid_t			target_tid			=     -1;
 static pid_t			child_pid			=     -1;
@@ -235,7 +237,7 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 
 	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
-	if (evlist->nr_entries > 1)
+	if ((evlist->nr_entries > 1) || time_history)
 		attr->sample_type |= PERF_SAMPLE_ID;
 
 	/*
@@ -280,6 +282,12 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (time_history) {
+		attr->sample_type   |= PERF_SAMPLE_TIME;
+		attr->sample_type   |= PERF_SAMPLE_CPU;
+		attr->sample_type   |= PERF_SAMPLE_READ;
+	}
+
 	if (nodelay) {
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
@@ -294,6 +302,86 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
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
+static void create_timehist_counter(void)
+{
+	int fd;
+	struct perf_event_attr attr;
+	struct perf_evsel *evsel;
+	/* only on 1 cpu */
+	struct cpu_map *cpus = cpu_map__new("0");
+	/* not associated with a process */
+	struct thread_map *threads = thread_map__new(-1, -1);
+
+	struct perf_evsel *first_evsel = list_entry(evsel_list->entries.next,
+			                 struct perf_evsel, node);
+
+	/* start with the attributes used for other events */
+	attr = first_evsel->attr;
+	attr.type = PERF_TYPE_SOFTWARE;
+	attr.config = PERF_COUNT_SW_REALTIME_CLOCK;
+	attr.sample_period = 3600 * NSEC_PER_SEC;
+
+	evsel = perf_evsel__new(&attr, evsel_list->nr_entries);
+	if (!evsel)
+		die("Error: Failed to allocate memory for time counter\n");
+
+	config_attr(evsel, evsel_list);
+
+	if (perf_evsel__open(evsel, cpus, threads, 0, 1) < 0) {
+		if (errno == EINVAL) {
+			synth_reftime = true;
+			return;
+		}
+		die("Failed to open realtime clock event\n");
+	}
+
+	if (perf_evsel__alloc_id(evsel, cpus->nr, threads->nr) < 0)
+		die("Failed to allocate an id for timehist event\n");
+
+	fd = FD(evsel, 0, 0);
+	if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, FD(first_evsel, 0, 0)) != 0)
+		die("ioctl failed for timehist event\n");
+
+	if (perf_evlist__id_hash(evsel_list, evsel, 0, 0, fd) < 0)
+		die("id_hash failed for timehist event\n");
+
+	create_counter(evsel, 0);
+
+	/* generate first sample - want a sample immediately so
+	 * that time conversions are avialable from the get-go.
+	 * Let user-specified rate take care of samples after that.
+	 */
+	if (ioctl(fd, PERF_EVENT_IOC_RECORD_SAMPLE) != 0)
+		error("failed to generate sample for realtime clock\n");
+
+	return;
+}
+
 static void open_counters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos;
@@ -335,7 +423,8 @@ try_again:
 				 * Old kernel, no attr->sample_id_type_all field
 				 */
 				sample_id_all_avail = false;
-				if (!sample_time && !raw_samples && !time_needed)
+				if (!sample_time && !raw_samples
+						&& !time_needed && !time_history)
 					attr->sample_type &= ~PERF_SAMPLE_TIME;
 
 				goto retry_sample_id;
@@ -378,6 +467,9 @@ try_again:
 		list_for_each_entry(pos, &evlist->entries, node)
 			create_counter(pos, cpu);
 	}
+
+	if (time_history)
+		create_timehist_counter();
 }
 
 static int process_buildids(void)
@@ -657,6 +749,16 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
+	if (synth_reftime) {
+		if (verbose)
+			warning(" ... fall back to synthesized reftime\n");
+
+		if (perf_event__synthesize_reftime(process_synthesized_event,
+	                                   session) != 0)
+			error("Failed to create reftime event. "
+			      "Cannot generate wall-clock timestamps\n");
+	}
+
 	machine = perf_session__find_host_machine(session);
 	if (!machine) {
 		pr_err("Couldn't find native kernel information.\n");
@@ -815,6 +917,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
+	OPT_BOOLEAN(0, "timehist", &time_history,
+		    "collect data for time history report"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index dddcc7e..83b5f24 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -36,6 +36,7 @@ static char		const *input_name = "perf.data";
 static bool		force, use_tui, use_stdio;
 static bool		hide_unresolved;
 static bool		dont_use_callchains;
+static bool		time_history;
 
 static bool		show_threads;
 static struct perf_read_values	show_threads_values;
@@ -46,6 +47,191 @@ static const char	*pretty_printing_style = default_pretty_printing_style;
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
+			if (verbose)
+			warning("Reference clock event not seen yet; "
+			        "Cannot generate wall-clock time strings until then.\n");
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
+		/* TO-DO: make timestr format configurable */
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
+	if (!(session->sample_type & PERF_SAMPLE_READ)) {
+		static bool show_msg = true;
+		if (show_msg) {
+			printf("rclk sample does not have event data.\n"
+			       "Was record done with --timehist option?\n");
+			show_msg = false;
+		}
+		return;
+	}
+
+	if (!(session->sample_type & PERF_SAMPLE_TIME)) {
+		printf("rclk sample does not have kernel sample time\n");
+		return;
+	}
+
+	/* convert raw sample to wall-clock reference time */
+	s = sample->values.value;
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
@@ -167,6 +353,13 @@ static int process_sample_event(union perf_event *event,
 	struct addr_location al;
 	struct perf_event_attr *attr;
 
+	attr = perf_header__find_attr(sample->id, &session->header);
+	if (time_history && attr &&
+	    (attr->type == PERF_TYPE_SOFTWARE) &&
+	    (attr->config == PERF_COUNT_SW_REALTIME_CLOCK)) {
+		perf_event__process_rclk(sample, session);
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
 
 	if (next == NULL) {
@@ -504,6 +706,8 @@ static const struct option options[] = {
 		    "Only display entries resolved to a symbol"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
+	OPT_BOOLEAN(0, "timehist", &time_history,
+		    "Dump time history of event samples"),
 	OPT_END()
 };
 
@@ -511,7 +715,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
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
index 512a1ca..d4810e0 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -99,6 +99,7 @@ enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_TRACING_DATA		= 66,
 	PERF_RECORD_HEADER_BUILD_ID		= 67,
 	PERF_RECORD_FINISHED_ROUND		= 68,
+	PERF_RECORD_REFTIME			= 69,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -125,6 +126,12 @@ struct tracing_data_event {
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
@@ -138,6 +145,7 @@ union perf_event {
 	struct event_type_event		event_type;
 	struct tracing_data_event	tracing_data;
 	struct build_id_event		build_id;
+	struct reftime_event		reftime;
 };
 
 void perf_event__print_totals(void);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 95b21fe..bb49243 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -106,7 +106,7 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 	evlist->nr_fds++;
 }
 
-static int perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *evsel,
+int perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			       int cpu, int thread, int fd)
 {
 	struct perf_sample_id *sid;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index c988405..bd73572 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -48,6 +48,8 @@ union perf_event *perf_evlist__read_on_cpu(struct perf_evlist *self, int cpu);
 int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
 int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
+int perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *evsel,
+					       int cpu, int thread, int fd);
 
 static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 					 struct cpu_map *cpus,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index dc0235b..1ef8e8a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -791,6 +791,10 @@ static int perf_session__process_user_event(struct perf_session *session, union
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
index 212f810..b46672a 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -78,7 +78,8 @@ struct perf_event_ops {
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

