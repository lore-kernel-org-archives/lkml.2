Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab1LEMsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:48:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab1LEMsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:48:14 -0500
Date: Mon, 5 Dec 2011 04:47:00 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-hzjqsgnte1esk90ytq0ap98v@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Introduce config attr method
Git-Commit-ID: 0f82ebc452f921590e216b28eee0b41f5e434a48
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:47:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f82ebc452f921590e216b28eee0b41f5e434a48
Gitweb:     http://git.kernel.org/tip/0f82ebc452f921590e216b28eee0b41f5e434a48
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 8 Nov 2011 14:41:57 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:25:31 -0200

perf evsel: Introduce config attr method

Out of the code in 'perf record', so that we can share option parsing,
etc. Eventually will be used by 'perf top', but first 'trace' will use
it.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-hzjqsgnte1esk90ytq0ap98v@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |  180 ++++++++++++-------------------------------
 tools/perf/perf.h           |   20 +++++
 tools/perf/util/evlist.c    |   16 ++++
 tools/perf/util/evlist.h    |    4 +
 tools/perf/util/evsel.c     |   70 +++++++++++++++++
 tools/perf/util/evsel.h     |    4 +
 6 files changed, 162 insertions(+), 132 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6ab58cc..c3ac541 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -35,32 +35,24 @@ enum write_mode_t {
 	WRITE_APPEND
 };
 
-static u64			user_interval			= ULLONG_MAX;
-static u64			default_interval		=      0;
+static struct perf_record_opts record_opts = {
+	.target_pid	     = -1,
+	.target_tid	     = -1,
+	.user_freq	     = UINT_MAX,
+	.user_interval	     = ULLONG_MAX,
+	.freq		     = 1000,
+	.sample_id_all_avail = true,
+};
 
 static unsigned int		page_size;
 static unsigned int		mmap_pages			= UINT_MAX;
-static unsigned int		user_freq 			= UINT_MAX;
-static int			freq				=   1000;
 static int			output;
 static int			pipe_output			=      0;
 static const char		*output_name			= NULL;
 static bool			group				=  false;
 static int			realtime_prio			=      0;
-static bool			nodelay				=  false;
-static bool			raw_samples			=  false;
-static bool			sample_id_all_avail		=   true;
-static bool			system_wide			=  false;
-static pid_t			target_pid			=     -1;
-static pid_t			target_tid			=     -1;
 static pid_t			child_pid			=     -1;
-static bool			no_inherit			=  false;
 static enum write_mode_t	write_mode			= WRITE_FORCE;
-static bool			call_graph			=  false;
-static bool			inherit_stat			=  false;
-static bool			no_samples			=  false;
-static bool			sample_address			=  false;
-static bool			sample_time			=  false;
 static bool			no_buildid			=  false;
 static bool			no_buildid_cache		=  false;
 static struct perf_evlist	*evsel_list;
@@ -72,7 +64,6 @@ static int			file_new			=      1;
 static off_t			post_processing_offset;
 
 static struct perf_session	*session;
-static const char		*cpu_list;
 static const char               *progname;
 
 static void advance_output(size_t size)
@@ -169,78 +160,6 @@ static void sig_atexit(void)
 	kill(getpid(), signr);
 }
 
-static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
-{
-	struct perf_event_attr *attr = &evsel->attr;
-	int track = !evsel->idx; /* only the first counter needs these */
-
-	attr->disabled		= 1;
-	attr->inherit		= !no_inherit;
-	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
-				  PERF_FORMAT_TOTAL_TIME_RUNNING |
-				  PERF_FORMAT_ID;
-
-	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
-
-	if (evlist->nr_entries > 1)
-		attr->sample_type |= PERF_SAMPLE_ID;
-
-	/*
-	 * We default some events to a 1 default interval. But keep
-	 * it a weak assumption overridable by the user.
-	 */
-	if (!attr->sample_period || (user_freq != UINT_MAX &&
-				     user_interval != ULLONG_MAX)) {
-		if (freq) {
-			attr->sample_type	|= PERF_SAMPLE_PERIOD;
-			attr->freq		= 1;
-			attr->sample_freq	= freq;
-		} else {
-			attr->sample_period = default_interval;
-		}
-	}
-
-	if (no_samples)
-		attr->sample_freq = 0;
-
-	if (inherit_stat)
-		attr->inherit_stat = 1;
-
-	if (sample_address) {
-		attr->sample_type	|= PERF_SAMPLE_ADDR;
-		attr->mmap_data = track;
-	}
-
-	if (call_graph)
-		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
-
-	if (system_wide)
-		attr->sample_type	|= PERF_SAMPLE_CPU;
-
-	if (sample_id_all_avail &&
-	    (sample_time || system_wide || !no_inherit || cpu_list))
-		attr->sample_type	|= PERF_SAMPLE_TIME;
-
-	if (raw_samples) {
-		attr->sample_type	|= PERF_SAMPLE_TIME;
-		attr->sample_type	|= PERF_SAMPLE_RAW;
-		attr->sample_type	|= PERF_SAMPLE_CPU;
-	}
-
-	if (nodelay) {
-		attr->watermark = 0;
-		attr->wakeup_events = 1;
-	}
-
-	attr->mmap		= track;
-	attr->comm		= track;
-
-	if (target_pid == -1 && target_tid == -1 && !system_wide) {
-		attr->disabled = 1;
-		attr->enable_on_exec = 1;
-	}
-}
-
 static bool perf_evlist__equal(struct perf_evlist *evlist,
 			       struct perf_evlist *other)
 {
@@ -264,11 +183,10 @@ static void open_counters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos, *first;
 
-	if (evlist->cpus->map[0] < 0)
-		no_inherit = true;
-
 	first = list_entry(evlist->entries.next, struct perf_evsel, node);
 
+	perf_evlist__config_attrs(evlist, &record_opts);
+
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
 		struct xyarray *group_fd = NULL;
@@ -288,10 +206,8 @@ static void open_counters(struct perf_evlist *evlist)
 
 		if (group && pos != first)
 			group_fd = first->fd;
-
-		config_attr(pos, evlist);
 retry_sample_id:
-		attr->sample_id_all = sample_id_all_avail ? 1 : 0;
+		attr->sample_id_all = record_opts.sample_id_all_avail ? 1 : 0;
 try_again:
 		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, group,
 				     group_fd) < 0) {
@@ -300,15 +216,15 @@ try_again:
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				exit(EXIT_FAILURE);
-			} else if (err ==  ENODEV && cpu_list) {
+			} else if (err ==  ENODEV && record_opts.cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
-			} else if (err == EINVAL && sample_id_all_avail) {
+			} else if (err == EINVAL && record_opts.sample_id_all_avail) {
 				/*
 				 * Old kernel, no attr->sample_id_type_all field
 				 */
-				sample_id_all_avail = false;
-				if (!sample_time && !raw_samples && !time_needed)
+				record_opts.sample_id_all_avail = false;
+				if (!record_opts.sample_time && !record_opts.raw_samples && !time_needed)
 					attr->sample_type &= ~PERF_SAMPLE_TIME;
 
 				goto retry_sample_id;
@@ -482,13 +398,13 @@ static int __cmd_record(int argc, const char **argv)
 
 	if (!output_name) {
 		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
-			pipe_output = 1;
+			pipe_output = true;
 		else
 			output_name = "perf.data";
 	}
 	if (output_name) {
 		if (!strcmp(output_name, "-"))
-			pipe_output = 1;
+			pipe_output = true;
 		else if (!stat(output_name, &st) && st.st_size) {
 			if (write_mode == WRITE_FORCE) {
 				char oldname[PATH_MAX];
@@ -592,7 +508,7 @@ static int __cmd_record(int argc, const char **argv)
 			exit(-1);
 		}
 
-		if (!system_wide && target_tid == -1 && target_pid == -1)
+		if (!record_opts.system_wide && record_opts.target_tid == -1 && record_opts.target_pid == -1)
 			evsel_list->threads->map[0] = child_pid;
 
 		close(child_ready_pipe[1]);
@@ -689,7 +605,7 @@ static int __cmd_record(int argc, const char **argv)
 		perf_session__process_machines(session,
 					       perf_event__synthesize_guest_os);
 
-	if (!system_wide)
+	if (!record_opts.system_wide)
 		perf_event__synthesize_thread_map(evsel_list->threads,
 						  process_synthesized_event,
 						  session);
@@ -766,44 +682,44 @@ const struct option record_options[] = {
 		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
-	OPT_INTEGER('p', "pid", &target_pid,
+	OPT_INTEGER('p', "pid", &record_opts.target_pid,
 		    "record events on existing process id"),
-	OPT_INTEGER('t', "tid", &target_tid,
+	OPT_INTEGER('t', "tid", &record_opts.target_tid,
 		    "record events on existing thread id"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
-	OPT_BOOLEAN('D', "no-delay", &nodelay,
+	OPT_BOOLEAN('D', "no-delay", &record_opts.no_delay,
 		    "collect data without buffering"),
-	OPT_BOOLEAN('R', "raw-samples", &raw_samples,
+	OPT_BOOLEAN('R', "raw-samples", &record_opts.raw_samples,
 		    "collect raw sample records from all opened counters"),
-	OPT_BOOLEAN('a', "all-cpus", &system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &record_opts.system_wide,
 			    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('A', "append", &append_file,
 			    "append to the output file to do incremental profiling"),
-	OPT_STRING('C', "cpu", &cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &record_opts.cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_BOOLEAN('f', "force", &force,
 			"overwrite existing data file (deprecated)"),
-	OPT_U64('c', "count", &user_interval, "event period to sample"),
+	OPT_U64('c', "count", &record_opts.user_interval, "event period to sample"),
 	OPT_STRING('o', "output", &output_name, "file",
 		    "output file name"),
-	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
+	OPT_BOOLEAN('i', "no-inherit", &record_opts.no_inherit,
 		    "child tasks do not inherit counters"),
-	OPT_UINTEGER('F', "freq", &user_freq, "profile at this frequency"),
+	OPT_UINTEGER('F', "freq", &record_opts.user_freq, "profile at this frequency"),
 	OPT_UINTEGER('m', "mmap-pages", &mmap_pages, "number of mmap data pages"),
 	OPT_BOOLEAN(0, "group", &group,
 		    "put the counters into a counter group"),
-	OPT_BOOLEAN('g', "call-graph", &call_graph,
+	OPT_BOOLEAN('g', "call-graph", &record_opts.call_graph,
 		    "do call-graph (stack chain/backtrace) recording"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
-	OPT_BOOLEAN('s', "stat", &inherit_stat,
+	OPT_BOOLEAN('s', "stat", &record_opts.inherit_stat,
 		    "per thread counts"),
-	OPT_BOOLEAN('d', "data", &sample_address,
+	OPT_BOOLEAN('d', "data", &record_opts.sample_address,
 		    "Sample addresses"),
-	OPT_BOOLEAN('T', "timestamp", &sample_time, "Sample timestamps"),
-	OPT_BOOLEAN('n', "no-samples", &no_samples,
+	OPT_BOOLEAN('T', "timestamp", &record_opts.sample_time, "Sample timestamps"),
+	OPT_BOOLEAN('n', "no-samples", &record_opts.no_samples,
 		    "don't sample"),
 	OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid_cache,
 		    "do not update the buildid cache"),
@@ -828,8 +744,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1 && target_tid == -1 &&
-		!system_wide && !cpu_list)
+	if (!argc && record_opts.target_pid == -1 && record_opts.target_tid == -1 &&
+		!record_opts.system_wide && !record_opts.cpu_list)
 		usage_with_options(record_usage, record_options);
 
 	if (force && append_file) {
@@ -842,7 +758,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		write_mode = WRITE_FORCE;
 	}
 
-	if (nr_cgroups && !system_wide) {
+	if (nr_cgroups && !record_opts.system_wide) {
 		fprintf(stderr, "cgroup monitoring only available in"
 			" system-wide mode\n");
 		usage_with_options(record_usage, record_options);
@@ -869,11 +785,11 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
-	if (target_pid != -1)
-		target_tid = target_pid;
+	if (record_opts.target_pid != -1)
+		record_opts.target_tid = record_opts.target_pid;
 
-	if (perf_evlist__create_maps(evsel_list, target_pid,
-				     target_tid, cpu_list) < 0)
+	if (perf_evlist__create_maps(evsel_list, record_opts.target_pid,
+				     record_opts.target_tid, record_opts.cpu_list) < 0)
 		usage_with_options(record_usage, record_options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
@@ -887,18 +803,18 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (perf_evlist__alloc_pollfd(evsel_list) < 0)
 		goto out_free_fd;
 
-	if (user_interval != ULLONG_MAX)
-		default_interval = user_interval;
-	if (user_freq != UINT_MAX)
-		freq = user_freq;
+	if (record_opts.user_interval != ULLONG_MAX)
+		record_opts.default_interval = record_opts.user_interval;
+	if (record_opts.user_freq != UINT_MAX)
+		record_opts.freq = record_opts.user_freq;
 
 	/*
 	 * User specified count overrides default frequency.
 	 */
-	if (default_interval)
-		freq = 0;
-	else if (freq) {
-		default_interval = freq;
+	if (record_opts.default_interval)
+		record_opts.freq = 0;
+	else if (record_opts.freq) {
+		record_opts.default_interval = record_opts.freq;
 	} else {
 		fprintf(stderr, "frequency and count are zero, aborting\n");
 		err = -EINVAL;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 914c895..eb6a138 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -185,4 +185,24 @@ extern const char perf_version_string[];
 
 void pthread__unblock_sigwinch(void);
 
+struct perf_record_opts {
+	pid_t	     target_pid;
+	pid_t	     target_tid;
+	bool	     call_graph;
+	bool	     inherit_stat;
+	bool	     no_delay;
+	bool	     no_inherit;
+	bool	     no_samples;
+	bool	     raw_samples;
+	bool	     sample_address;
+	bool	     sample_time;
+	bool	     sample_id_all_avail;
+	bool	     system_wide;
+	unsigned int freq;
+	unsigned int user_freq;
+	u64	     default_interval;
+	u64	     user_interval;
+	const char   *cpu_list;
+};
+
 #endif
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3bc5a28..b774341 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -46,6 +46,22 @@ struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
 	return evlist;
 }
 
+void perf_evlist__config_attrs(struct perf_evlist *evlist,
+			       struct perf_record_opts *opts)
+{
+	struct perf_evsel *evsel;
+
+	if (evlist->cpus->map[0] < 0)
+		opts->no_inherit = true;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		perf_evsel__config(evsel, opts);
+
+		if (evlist->nr_entries > 1)
+			evsel->attr.sample_type |= PERF_SAMPLE_ID;
+	}
+}
+
 static void perf_evlist__purge(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos, *n;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index ec71c82..231c06f 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -10,6 +10,7 @@
 struct pollfd;
 struct thread_map;
 struct cpu_map;
+struct perf_record_opts;
 
 #define PERF_EVLIST__HLIST_BITS 8
 #define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
@@ -64,6 +65,9 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
 int perf_evlist__open(struct perf_evlist *evlist, bool group);
 
+void perf_evlist__config_attrs(struct perf_evlist *evlist,
+			       struct perf_record_opts *opts);
+
 int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
 int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e426264..b38eaa3 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -53,6 +53,76 @@ struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 	return evsel;
 }
 
+void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
+{
+	struct perf_event_attr *attr = &evsel->attr;
+	int track = !evsel->idx; /* only the first counter needs these */
+
+	attr->sample_id_all = opts->sample_id_all_avail ? 1 : 0;
+	attr->inherit	    = !opts->no_inherit;
+	attr->read_format   = PERF_FORMAT_TOTAL_TIME_ENABLED |
+			      PERF_FORMAT_TOTAL_TIME_RUNNING |
+			      PERF_FORMAT_ID;
+
+	attr->sample_type  |= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+
+	/*
+	 * We default some events to a 1 default interval. But keep
+	 * it a weak assumption overridable by the user.
+	 */
+	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
+				     opts->user_interval != ULLONG_MAX)) {
+		if (opts->freq) {
+			attr->sample_type	|= PERF_SAMPLE_PERIOD;
+			attr->freq		= 1;
+			attr->sample_freq	= opts->freq;
+		} else {
+			attr->sample_period = opts->default_interval;
+		}
+	}
+
+	if (opts->no_samples)
+		attr->sample_freq = 0;
+
+	if (opts->inherit_stat)
+		attr->inherit_stat = 1;
+
+	if (opts->sample_address) {
+		attr->sample_type	|= PERF_SAMPLE_ADDR;
+		attr->mmap_data = track;
+	}
+
+	if (opts->call_graph)
+		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
+
+	if (opts->system_wide)
+		attr->sample_type	|= PERF_SAMPLE_CPU;
+
+	if (opts->sample_id_all_avail &&
+	    (opts->sample_time || opts->system_wide ||
+	     !opts->no_inherit || opts->cpu_list))
+		attr->sample_type	|= PERF_SAMPLE_TIME;
+
+	if (opts->raw_samples) {
+		attr->sample_type	|= PERF_SAMPLE_TIME;
+		attr->sample_type	|= PERF_SAMPLE_RAW;
+		attr->sample_type	|= PERF_SAMPLE_CPU;
+	}
+
+	if (opts->no_delay) {
+		attr->watermark = 0;
+		attr->wakeup_events = 1;
+	}
+
+	attr->mmap = track;
+	attr->comm = track;
+
+	if (opts->target_pid == -1 && opts->target_tid == -1 && !opts->system_wide) {
+		attr->disabled = 1;
+		attr->enable_on_exec = 1;
+	}
+}
+
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	int cpu, thread;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index b1d15e6..6421c07 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -67,6 +67,7 @@ struct perf_evsel {
 struct cpu_map;
 struct thread_map;
 struct perf_evlist;
+struct perf_record_opts;
 
 struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx);
 void perf_evsel__init(struct perf_evsel *evsel,
@@ -74,6 +75,9 @@ void perf_evsel__init(struct perf_evsel *evsel,
 void perf_evsel__exit(struct perf_evsel *evsel);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
+void perf_evsel__config(struct perf_evsel *evsel,
+			struct perf_record_opts *opts);
+
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
