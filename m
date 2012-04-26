Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2DZFT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:19:57 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54562 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2DZFQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:21 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-1a-4f98da226957
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 01/13] perf tools: Introduce struct perf_target
Date: Thu, 26 Apr 2012 14:15:15 +0900
Message-Id: <1335417327-11796-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_target struct will be used for taking care of cpu/thread
maps based on user's input. Since it is used on various subcommands
it'd better factoring it out.

Thanks to Arnaldo for suggesting the better name.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-record.c |   41 ++++++++++++++++++++++-------------------
 tools/perf/builtin-test.c   |    5 +++--
 tools/perf/perf.h           |   15 ++++++++++-----
 tools/perf/util/evlist.c    |    2 +-
 tools/perf/util/evsel.c     |   10 +++++-----
 5 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 10b1f1f25ed7..4dcf27057bd2 100644
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
@@ -218,7 +217,7 @@ try_again:
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				exit(EXIT_FAILURE);
-			} else if (err ==  ENODEV && opts->cpu_list) {
+			} else if (err ==  ENODEV && opts->target.cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
 			} else if (err == EINVAL) {
@@ -578,7 +577,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		perf_session__process_machines(session, tool,
 					       perf_event__synthesize_guest_os);
 
-	if (!opts->system_wide)
+	if (!opts->target.system_wide)
 		perf_event__synthesize_thread_map(tool, evsel_list->threads,
 						  process_synthesized_event,
 						  machine);
@@ -765,9 +764,9 @@ const struct option record_options[] = {
 		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &record.evlist, "filter",
 		     "event filter", parse_filter),
-	OPT_STRING('p', "pid", &record.opts.target_pid, "pid",
+	OPT_STRING('p', "pid", &record.opts.target.pid, "pid",
 		    "record events on existing process id"),
-	OPT_STRING('t', "tid", &record.opts.target_tid, "tid",
+	OPT_STRING('t', "tid", &record.opts.target.tid, "tid",
 		    "record events on existing thread id"),
 	OPT_INTEGER('r', "realtime", &record.realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
@@ -775,11 +774,11 @@ const struct option record_options[] = {
 		    "collect data without buffering"),
 	OPT_BOOLEAN('R', "raw-samples", &record.opts.raw_samples,
 		    "collect raw sample records from all opened counters"),
-	OPT_BOOLEAN('a', "all-cpus", &record.opts.system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &record.opts.target.system_wide,
 			    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('A', "append", &record.append_file,
 			    "append to the output file to do incremental profiling"),
-	OPT_STRING('C', "cpu", &record.opts.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &record.opts.target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_BOOLEAN('f', "force", &record.force,
 			"overwrite existing data file (deprecated)"),
@@ -813,7 +812,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('G', "cgroup", &record.evlist, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
-	OPT_STRING('u', "uid", &record.uid_str, "user", "user to profile"),
+	OPT_STRING('u', "uid", &record.opts.target.uid_str, "user",
+		   "user to profile"),
 
 	OPT_CALLBACK_NOOPT('b', "branch-any", &record.opts.branch_stack,
 		     "branch any", "sample any taken branches",
@@ -842,8 +842,9 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && !rec->opts.target_pid && !rec->opts.target_tid &&
-		!rec->opts.system_wide && !rec->opts.cpu_list && !rec->uid_str)
+	if (!argc && !rec->opts.target.pid && !rec->opts.target.tid &&
+	    !rec->opts.target.system_wide && !rec->opts.target.cpu_list &&
+	    !rec->opts.target.uid_str)
 		usage_with_options(record_usage, record_options);
 
 	if (rec->force && rec->append_file) {
@@ -856,7 +857,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		rec->write_mode = WRITE_FORCE;
 	}
 
-	if (nr_cgroups && !rec->opts.system_wide) {
+	if (nr_cgroups && !rec->opts.target.system_wide) {
 		fprintf(stderr, "cgroup monitoring only available in"
 			" system-wide mode\n");
 		usage_with_options(record_usage, record_options);
@@ -883,17 +884,19 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
-	rec->opts.uid = parse_target_uid(rec->uid_str, rec->opts.target_tid,
-					 rec->opts.target_pid);
-	if (rec->uid_str != NULL && rec->opts.uid == UINT_MAX - 1)
+	rec->opts.target.uid = parse_target_uid(rec->opts.target.uid_str,
+						rec->opts.target.tid,
+						rec->opts.target.pid);
+	if (rec->opts.target.uid_str != NULL &&
+	    rec->opts.target.uid == UINT_MAX - 1)
 		goto out_free_fd;
 
-	if (rec->opts.target_pid)
-		rec->opts.target_tid = rec->opts.target_pid;
+	if (rec->opts.target.pid)
+		rec->opts.target.tid = rec->opts.target.pid;
 
-	if (perf_evlist__create_maps(evsel_list, rec->opts.target_pid,
-				     rec->opts.target_tid, rec->opts.uid,
-				     rec->opts.cpu_list) < 0)
+	if (perf_evlist__create_maps(evsel_list, rec->opts.target.pid,
+				     rec->opts.target.tid, rec->opts.target.uid,
+				     rec->opts.target.cpu_list) < 0)
 		usage_with_options(record_usage, record_options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1c5b9801ac61..e9b256920da0 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1207,8 +1207,9 @@ static int test__PERF_RECORD(void)
 	 * perf_evlist__prepare_workload we'll fill in the only thread
 	 * we're monitoring, the one forked there.
 	 */
-	err = perf_evlist__create_maps(evlist, opts.target_pid,
-				       opts.target_tid, UINT_MAX, opts.cpu_list);
+	err = perf_evlist__create_maps(evlist, opts.target.pid,
+				       opts.target.tid, UINT_MAX,
+				       opts.target.cpu_list);
 	if (err < 0) {
 		pr_debug("Not enough memory to create thread/cpu maps\n");
 		goto out_delete_evlist;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 89e3355ab173..7e226c0e0e31 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -207,10 +207,17 @@ extern const char perf_version_string[];
 
 void pthread__unblock_sigwinch(void);
 
-struct perf_record_opts {
-	const char   *target_pid;
-	const char   *target_tid;
+struct perf_target {
+	const char   *pid;
+	const char   *tid;
+	const char   *cpu_list;
+	const char   *uid_str;
 	uid_t	     uid;
+	bool	     system_wide;
+};
+
+struct perf_record_opts {
+	struct perf_target target;
 	bool	     call_graph;
 	bool	     group;
 	bool	     inherit_stat;
@@ -223,7 +230,6 @@ struct perf_record_opts {
 	bool	     sample_time;
 	bool	     sample_id_all_missing;
 	bool	     exclude_guest_missing;
-	bool	     system_wide;
 	bool	     period;
 	unsigned int freq;
 	unsigned int mmap_pages;
@@ -231,7 +237,6 @@ struct perf_record_opts {
 	int	     branch_stack;
 	u64	     default_interval;
 	u64	     user_interval;
-	const char   *cpu_list;
 };
 
 #endif
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1986d8051bd1..7080901a2717 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -827,7 +827,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		exit(-1);
 	}
 
-	if (!opts->system_wide && !opts->target_tid && !opts->target_pid)
+	if (!opts->target.system_wide && !opts->target.tid && !opts->target.pid)
 		evlist->threads->map[0] = evlist->workload.pid;
 
 	close(child_ready_pipe[1]);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8c13dbcb84b9..d90598edcf1d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -106,15 +106,15 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 	if (opts->call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
-	if (opts->system_wide)
+	if (opts->target.system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
 	if (opts->period)
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 
 	if (!opts->sample_id_all_missing &&
-	    (opts->sample_time || opts->system_wide ||
-	     !opts->no_inherit || opts->cpu_list))
+	    (opts->sample_time || opts->target.system_wide ||
+	     !opts->no_inherit || opts->target.cpu_list))
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 
 	if (opts->raw_samples) {
@@ -135,8 +135,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 	attr->mmap = track;
 	attr->comm = track;
 
-	if (!opts->target_pid && !opts->target_tid && !opts->system_wide &&
-	    (!opts->group || evsel == first)) {
+	if (!opts->target.pid && !opts->target.tid &&
+	    !opts->target.system_wide && (!opts->group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
-- 
1.7.10

