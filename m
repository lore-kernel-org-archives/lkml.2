Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2BMHLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:11:34 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49008 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2BMHLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:11:32 -0500
X-AuditID: 9c930197-b7cdbae000001518-53-4f38b7a0ca6b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] perf tools: Introduce struct perf_maps_opts
Date: Mon, 13 Feb 2012 16:27:33 +0900
Message-Id: <1329118064-9412-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_maps_opts struct will be used for taking care of cpu/thread
maps based on user's input. Since it is used on various subcommands
it'd be better factoring it out.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-record.c |   46 +++++++++++++++++++++++-------------------
 tools/perf/builtin-test.c   |   11 ++++++---
 tools/perf/perf.h           |   11 +++++++--
 tools/perf/util/evlist.c    |    3 +-
 tools/perf/util/evsel.c     |    9 ++++---
 5 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f8d9a545dd6e..7b50316136bf 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -44,7 +44,6 @@ struct perf_record {
 	struct perf_evlist	*evlist;
 	struct perf_session	*session;
 	const char		*progname;
-	const char		*uid_str;
 	int			output;
 	unsigned int		page_size;
 	int			realtime_prio;
@@ -215,7 +214,7 @@ try_again:
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				exit(EXIT_FAILURE);
-			} else if (err ==  ENODEV && opts->cpu_list) {
+			} else if (err ==  ENODEV && opts->maps.cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
 			} else if (err == EINVAL && opts->sample_id_all_avail) {
@@ -564,7 +563,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		perf_session__process_machines(session, tool,
 					       perf_event__synthesize_guest_os);
 
-	if (!opts->system_wide)
+	if (!opts->maps.system_wide)
 		perf_event__synthesize_thread_map(tool, evsel_list->threads,
 						  process_synthesized_event,
 						  machine);
@@ -645,8 +644,10 @@ static const char * const record_usage[] = {
  */
 static struct perf_record record = {
 	.opts = {
-		.target_pid	     = -1,
-		.target_tid	     = -1,
+		.maps = {
+			.target_pid	     = -1,
+			.target_tid	     = -1,
+		},
 		.mmap_pages	     = UINT_MAX,
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
@@ -670,9 +671,9 @@ const struct option record_options[] = {
 		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &record.evlist, "filter",
 		     "event filter", parse_filter),
-	OPT_INTEGER('p', "pid", &record.opts.target_pid,
+	OPT_INTEGER('p', "pid", &record.opts.maps.target_pid,
 		    "record events on existing process id"),
-	OPT_INTEGER('t', "tid", &record.opts.target_tid,
+	OPT_INTEGER('t', "tid", &record.opts.maps.target_tid,
 		    "record events on existing thread id"),
 	OPT_INTEGER('r', "realtime", &record.realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
@@ -680,11 +681,11 @@ const struct option record_options[] = {
 		    "collect data without buffering"),
 	OPT_BOOLEAN('R', "raw-samples", &record.opts.raw_samples,
 		    "collect raw sample records from all opened counters"),
-	OPT_BOOLEAN('a', "all-cpus", &record.opts.system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &record.opts.maps.system_wide,
 			    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('A', "append", &record.append_file,
 			    "append to the output file to do incremental profiling"),
-	OPT_STRING('C', "cpu", &record.opts.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &record.opts.maps.cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_BOOLEAN('f', "force", &record.force,
 			"overwrite existing data file (deprecated)"),
@@ -718,7 +719,7 @@ const struct option record_options[] = {
 	OPT_CALLBACK('G', "cgroup", &record.evlist, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
-	OPT_STRING('u', "uid", &record.uid_str, "user", "user to profile"),
+	OPT_STRING('u', "uid", &record.opts.maps.uid_str, "user", "user to profile"),
 	OPT_END()
 };
 
@@ -739,8 +740,10 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && rec->opts.target_pid == -1 && rec->opts.target_tid == -1 &&
-		!rec->opts.system_wide && !rec->opts.cpu_list && !rec->uid_str)
+	if (!argc && rec->opts.maps.target_pid == -1 &&
+	    rec->opts.maps.target_tid == -1 &&
+	    !rec->opts.maps.system_wide && !rec->opts.maps.cpu_list &&
+	    !rec->opts.maps.uid_str)
 		usage_with_options(record_usage, record_options);
 
 	if (rec->force && rec->append_file) {
@@ -753,7 +756,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		rec->write_mode = WRITE_FORCE;
 	}
 
-	if (nr_cgroups && !rec->opts.system_wide) {
+	if (nr_cgroups && !rec->opts.maps.system_wide) {
 		fprintf(stderr, "cgroup monitoring only available in"
 			" system-wide mode\n");
 		usage_with_options(record_usage, record_options);
@@ -780,17 +783,18 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
-	rec->opts.uid = parse_target_uid(rec->uid_str, rec->opts.target_tid,
-					 rec->opts.target_pid);
-	if (rec->uid_str != NULL && rec->opts.uid == UINT_MAX - 1)
+	rec->opts.maps.uid = parse_target_uid(rec->opts.maps.uid_str,
+					      rec->opts.maps.target_tid,
+					      rec->opts.maps.target_pid);
+	if (rec->opts.maps.uid_str && rec->opts.maps.uid == UINT_MAX - 1)
 		goto out_free_fd;
 
-	if (rec->opts.target_pid != -1)
-		rec->opts.target_tid = rec->opts.target_pid;
+	if (rec->opts.maps.target_pid != -1)
+		rec->opts.maps.target_tid = rec->opts.maps.target_pid;
 
-	if (perf_evlist__create_maps(evsel_list, rec->opts.target_pid,
-				     rec->opts.target_tid, rec->opts.uid,
-				     rec->opts.cpu_list) < 0)
+	if (perf_evlist__create_maps(evsel_list, rec->opts.maps.target_pid,
+				     rec->opts.maps.target_tid, rec->opts.maps.uid,
+				     rec->opts.maps.cpu_list) < 0)
 		usage_with_options(record_usage, record_options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 70c4eb2bdf72..da3c1c3f8524 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1010,8 +1010,10 @@ realloc:
 static int test__PERF_RECORD(void)
 {
 	struct perf_record_opts opts = {
-		.target_pid = -1,
-		.target_tid = -1,
+		.maps = {
+			.target_pid = -1,
+			.target_tid = -1,
+		},
 		.no_delay   = true,
 		.freq	    = 10,
 		.mmap_pages = 256,
@@ -1055,8 +1057,9 @@ static int test__PERF_RECORD(void)
 	 * perf_evlist__prepare_workload we'll fill in the only thread
 	 * we're monitoring, the one forked there.
 	 */
-	err = perf_evlist__create_maps(evlist, opts.target_pid,
-				       opts.target_tid, UINT_MAX, opts.cpu_list);
+	err = perf_evlist__create_maps(evlist, opts.maps.target_pid,
+				       opts.maps.target_tid, UINT_MAX,
+				       opts.maps.cpu_list);
 	if (err < 0) {
 		pr_debug("Not enough memory to create thread/cpu maps\n");
 		goto out_delete_evlist;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 92af1688bae4..972cd99fb509 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -185,10 +185,17 @@ extern const char perf_version_string[];
 
 void pthread__unblock_sigwinch(void);
 
-struct perf_record_opts {
+struct perf_maps_opts {
 	pid_t	     target_pid;
 	pid_t	     target_tid;
 	uid_t	     uid;
+	bool	     system_wide;
+	const char   *cpu_list;
+	const char   *uid_str;
+};
+
+struct perf_record_opts {
+	struct perf_maps_opts maps;
 	bool	     call_graph;
 	bool	     group;
 	bool	     inherit_stat;
@@ -200,14 +207,12 @@ struct perf_record_opts {
 	bool	     sample_address;
 	bool	     sample_time;
 	bool	     sample_id_all_avail;
-	bool	     system_wide;
 	bool	     period;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
 	u64	     default_interval;
 	u64	     user_interval;
-	const char   *cpu_list;
 };
 
 #endif
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a57a8cfc5d90..d7c3a2d5771c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -820,7 +820,8 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		exit(-1);
 	}
 
-	if (!opts->system_wide && opts->target_tid == -1 && opts->target_pid == -1)
+	if (!opts->maps.system_wide && opts->maps.target_tid == -1 &&
+	    opts->maps.target_pid == -1)
 		evlist->threads->map[0] = evlist->workload.pid;
 
 	close(child_ready_pipe[1]);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9a11f9edac12..6a4e97d5f6d5 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -105,15 +105,15 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	if (opts->call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
-	if (opts->system_wide)
+	if (opts->maps.system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
 	if (opts->period)
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 
 	if (opts->sample_id_all_avail &&
-	    (opts->sample_time || opts->system_wide ||
-	     !opts->no_inherit || opts->cpu_list))
+	    (opts->sample_time || opts->maps.system_wide ||
+	     !opts->no_inherit || opts->maps.cpu_list))
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 
 	if (opts->raw_samples) {
@@ -130,7 +130,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	attr->mmap = track;
 	attr->comm = track;
 
-	if (opts->target_pid == -1 && opts->target_tid == -1 && !opts->system_wide) {
+	if (opts->maps.target_pid == -1 && opts->maps.target_tid == -1 &&
+	    !opts->maps.system_wide) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
-- 
1.7.9

