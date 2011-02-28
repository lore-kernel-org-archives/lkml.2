Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1B1Dwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 22:52:31 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:20613 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab1B1Dw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 22:52:27 -0500
X-IronPort-AV: E=Sophos;i="4.62,237,1297036800"; 
   d="scan'208";a="266102183"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 3/6] perf record: add time-of-day option
Date: Sun, 27 Feb 2011 20:52:28 -0700
Message-Id: <1298865151-23656-4-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298865151-23656-1-git-send-email-daahern@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable data collection for generating time-of-day strings when
printing individual perf samples. This is done by sampling the
realtime clock event with the perf_clock time stamps.

If the realtime-clock event is not available (e.g, older kernels)
fallback to a synthesized event. (I realize there is resistance
to new synthesized events, but it is a simple way to gain this
feature on older kernels without the need to modify the kernel
code).

Signed-off-by: David Ahern <daahern@cisco.com>
---
 include/linux/perf_event.h               |    1 +
 kernel/perf_event.c                      |   19 +++++
 tools/perf/Documentation/perf-record.txt |    5 ++
 tools/perf/builtin-record.c              |  110 +++++++++++++++++++++++++++++-
 tools/perf/util/event.c                  |    1 +
 tools/perf/util/event.h                  |    8 ++
 tools/perf/util/evlist.c                 |    2 +-
 tools/perf/util/evlist.h                 |    2 +
 tools/perf/util/session.c                |    4 +
 tools/perf/util/session.h                |    3 +-
 10 files changed, 151 insertions(+), 4 deletions(-)

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
index a25a63d..7999f55 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3250,6 +3250,7 @@ static struct perf_event *perf_fget_light(int fd, int *fput_needed)
 static int perf_event_set_output(struct perf_event *event,
 				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
+static int perf_event_generate_sample(struct perf_event *event);
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -3296,6 +3297,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
 
+	case PERF_EVENT_IOC_RECORD_SAMPLE:
+		return perf_event_generate_sample(event);
+
 	default:
 		return -ENOTTY;
 	}
@@ -4398,6 +4402,21 @@ exit:
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
index 5a520f8..8eb5b0a 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -148,6 +148,11 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
 corresponding events, i.e., they always refer to events defined earlier on the command
 line.
 
+--tod::
+Collect data for time-of-day strings when printing events. This option adds
+reference time samples to the event stream for converting perf timestamps to
+time-of-day.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e39883e..ac0717c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -56,6 +56,8 @@ static bool			nodelay				=  false;
 static bool			raw_samples			=  false;
 static bool			sample_id_all_avail		=   true;
 static bool			system_wide			=  false;
+static bool			want_tod_data			=  false;
+static bool			synth_reftime			=  false;
 static pid_t			target_pid			=     -1;
 static pid_t			target_tid			=     -1;
 static pid_t			child_pid			=     -1;
@@ -235,7 +237,7 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 
 	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
-	if (evlist->nr_entries > 1)
+	if ((evlist->nr_entries > 1) || want_tod_data)
 		attr->sample_type |= PERF_SAMPLE_ID;
 
 	/*
@@ -280,6 +282,12 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (want_tod_data) {
+		attr->sample_type   |= PERF_SAMPLE_TIME;
+		attr->sample_type   |= PERF_SAMPLE_CPU;
+		attr->sample_type   |= PERF_SAMPLE_READ;
+	}
+
 	if (nodelay) {
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
@@ -294,6 +302,88 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
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
+static void create_tod_counter(void)
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
+	attr = first_evsel->attr;
+	attr.type = PERF_TYPE_SOFTWARE;
+	attr.config = PERF_COUNT_SW_REALTIME_CLOCK;
+	attr.sample_period = 3600 * NSEC_PER_SEC;
+	attr.freq = 0;
+
+	evsel = perf_evsel__new(&attr, evsel_list->nr_entries);
+	if (!evsel)
+		die("Error: Failed to allocate memory for time counter\n");
+
+	config_attr(evsel, evsel_list);
+
+	if (perf_evsel__open(evsel, cpus, threads, 0, 1) < 0) {
+		if (errno == EINVAL) {
+			if (verbose)
+				warning("Failed to open realtime clock event\n");
+			synth_reftime = true;
+			return;
+		}
+		die("Failed to open realtime clock event\n");
+	}
+
+	if (perf_evsel__alloc_id(evsel, cpus->nr, threads->nr) < 0)
+		die("Failed to allocate an id for realtime-clock event\n");
+
+	fd = FD(evsel, 0, 0);
+	if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, FD(first_evsel, 0, 0)) != 0)
+		die("Failed to add realtime-clock event to output stream\n");
+
+	if (perf_evlist__id_hash(evsel_list, evsel, 0, 0, fd) < 0)
+		die("id_hash failed for realtime-clock event\n");
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
@@ -335,7 +425,8 @@ try_again:
 				 * Old kernel, no attr->sample_id_type_all field
 				 */
 				sample_id_all_avail = false;
-				if (!sample_time && !raw_samples && !time_needed)
+				if (!sample_time && !raw_samples
+						&& !time_needed && !want_tod_data)
 					attr->sample_type &= ~PERF_SAMPLE_TIME;
 
 				goto retry_sample_id;
@@ -378,6 +469,9 @@ try_again:
 		list_for_each_entry(pos, &evlist->entries, node)
 			create_counter(pos, cpu);
 	}
+
+	if (want_tod_data)
+		create_tod_counter();
 }
 
 static int process_buildids(void)
@@ -657,6 +751,16 @@ static int __cmd_record(int argc, const char **argv)
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
@@ -815,6 +919,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
+	OPT_BOOLEAN(0, "tod", &want_tod_data,
+		    "collect data for time-of-day strings"),
 	OPT_END()
 };
 
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
1.7.4

