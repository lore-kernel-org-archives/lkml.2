Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2BQJrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:47:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38610 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2BQJq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:46:57 -0500
Date: Fri, 17 Feb 2012 01:46:17 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-b52956c961be3a04182ae7b776623531601e0fb7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1328718772-16688-1-git-send-email-dsahern@gmail.com>
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Allow multiple threads or processes in record, stat, top
Git-Commit-ID: b52956c961be3a04182ae7b776623531601e0fb7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:46:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b52956c961be3a04182ae7b776623531601e0fb7
Gitweb:     http://git.kernel.org/tip/b52956c961be3a04182ae7b776623531601e0fb7
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 8 Feb 2012 09:32:52 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 22:54:11 -0200

perf tools: Allow multiple threads or processes in record, stat, top

Allow a user to collect events for multiple threads or processes
using a comma separated list.

e.g., collect data on a VM and its vhost thread:
  perf top -p 21483,21485
  perf stat -p 21483,21485 -ddd
  perf record -p 21483,21485

or monitoring vcpu threads
  perf top -t 21488,21489
  perf stat -t 21488,21489 -ddd
  perf record -t 21488,21489

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1328718772-16688-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt |    4 +-
 tools/perf/Documentation/perf-stat.txt   |    4 +-
 tools/perf/Documentation/perf-top.txt    |    4 +-
 tools/perf/builtin-record.c              |   10 +--
 tools/perf/builtin-stat.c                |   31 ++++----
 tools/perf/builtin-test.c                |    2 -
 tools/perf/builtin-top.c                 |   12 +--
 tools/perf/perf.h                        |    4 +-
 tools/perf/util/evlist.c                 |   10 +-
 tools/perf/util/evlist.h                 |    4 +-
 tools/perf/util/evsel.c                  |    2 +-
 tools/perf/util/python-ext-sources       |    2 +
 tools/perf/util/thread_map.c             |  128 ++++++++++++++++++++++++++++++
 tools/perf/util/thread_map.h             |    4 +
 tools/perf/util/top.c                    |   10 +-
 tools/perf/util/top.h                    |    2 +-
 tools/perf/util/usage.c                  |    6 +-
 tools/perf/util/util.h                   |    2 +-
 18 files changed, 185 insertions(+), 56 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index ff9a66e..a5766b4 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -52,11 +52,11 @@ OPTIONS
 
 -p::
 --pid=::
-	Record events on existing process ID.
+	Record events on existing process ID (comma separated list).
 
 -t::
 --tid=::
-        Record events on existing thread ID.
+        Record events on existing thread ID (comma separated list).
 
 -u::
 --uid=::
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 8966b9a..2fa173b 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -35,11 +35,11 @@ OPTIONS
         child tasks do not inherit counters
 -p::
 --pid=<pid>::
-        stat events on existing process id
+        stat events on existing process id (comma separated list)
 
 -t::
 --tid=<tid>::
-        stat events on existing thread id
+        stat events on existing thread id (comma separated list)
 
 
 -a::
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index ab1454e..4a5680c 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -72,11 +72,11 @@ Default is to monitor all CPUS.
 
 -p <pid>::
 --pid=<pid>::
-	Profile events on existing Process ID.
+	Profile events on existing Process ID (comma separated list).
 
 -t <tid>::
 --tid=<tid>::
-        Profile events on existing thread ID.
+        Profile events on existing thread ID (comma separated list).
 
 -u::
 --uid=::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d6d1c6c..08ed24b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -645,8 +645,6 @@ static const char * const record_usage[] = {
  */
 static struct perf_record record = {
 	.opts = {
-		.target_pid	     = -1,
-		.target_tid	     = -1,
 		.mmap_pages	     = UINT_MAX,
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
@@ -670,9 +668,9 @@ const struct option record_options[] = {
 		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &record.evlist, "filter",
 		     "event filter", parse_filter),
-	OPT_INTEGER('p', "pid", &record.opts.target_pid,
+	OPT_STRING('p', "pid", &record.opts.target_pid, "pid",
 		    "record events on existing process id"),
-	OPT_INTEGER('t', "tid", &record.opts.target_tid,
+	OPT_STRING('t', "tid", &record.opts.target_tid, "tid",
 		    "record events on existing thread id"),
 	OPT_INTEGER('r', "realtime", &record.realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
@@ -739,7 +737,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && rec->opts.target_pid == -1 && rec->opts.target_tid == -1 &&
+	if (!argc && !rec->opts.target_pid && !rec->opts.target_tid &&
 		!rec->opts.system_wide && !rec->opts.cpu_list && !rec->uid_str)
 		usage_with_options(record_usage, record_options);
 
@@ -785,7 +783,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (rec->uid_str != NULL && rec->opts.uid == UINT_MAX - 1)
 		goto out_free_fd;
 
-	if (rec->opts.target_pid != -1)
+	if (rec->opts.target_pid)
 		rec->opts.target_tid = rec->opts.target_pid;
 
 	if (perf_evlist__create_maps(evsel_list, rec->opts.target_pid,
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index d14b37a..ea40e4e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -182,8 +182,8 @@ static int			run_count			=  1;
 static bool			no_inherit			= false;
 static bool			scale				=  true;
 static bool			no_aggr				= false;
-static pid_t			target_pid			= -1;
-static pid_t			target_tid			= -1;
+static const char		*target_pid;
+static const char		*target_tid;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
@@ -296,7 +296,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 	if (system_wide)
 		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
 						group, group_fd);
-	if (target_pid == -1 && target_tid == -1) {
+	if (!target_pid && !target_tid) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
@@ -446,7 +446,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 			exit(-1);
 		}
 
-		if (target_tid == -1 && target_pid == -1 && !system_wide)
+		if (!target_tid && !target_pid && !system_wide)
 			evsel_list->threads->map[0] = child_pid;
 
 		/*
@@ -968,14 +968,14 @@ static void print_stat(int argc, const char **argv)
 	if (!csv_output) {
 		fprintf(output, "\n");
 		fprintf(output, " Performance counter stats for ");
-		if(target_pid == -1 && target_tid == -1) {
+		if (!target_pid && !target_tid) {
 			fprintf(output, "\'%s", argv[0]);
 			for (i = 1; i < argc; i++)
 				fprintf(output, " %s", argv[i]);
-		} else if (target_pid != -1)
-			fprintf(output, "process id \'%d", target_pid);
+		} else if (target_pid)
+			fprintf(output, "process id \'%s", target_pid);
 		else
-			fprintf(output, "thread id \'%d", target_tid);
+			fprintf(output, "thread id \'%s", target_tid);
 
 		fprintf(output, "\'");
 		if (run_count > 1)
@@ -1049,10 +1049,10 @@ static const struct option options[] = {
 		     "event filter", parse_filter),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
-	OPT_INTEGER('p', "pid", &target_pid,
-		    "stat events on existing process id"),
-	OPT_INTEGER('t', "tid", &target_tid,
-		    "stat events on existing thread id"),
+	OPT_STRING('p', "pid", &target_pid, "pid",
+		   "stat events on existing process id"),
+	OPT_STRING('t', "tid", &target_tid, "tid",
+		   "stat events on existing thread id"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('g', "group", &group,
@@ -1190,7 +1190,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && target_pid == -1 && target_tid == -1)
+	if (!argc && !target_pid && !target_tid)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
@@ -1206,10 +1206,11 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (add_default_attributes())
 		goto out;
 
-	if (target_pid != -1)
+	if (target_pid)
 		target_tid = target_pid;
 
-	evsel_list->threads = thread_map__new(target_pid, target_tid, UINT_MAX);
+	evsel_list->threads = thread_map__new_str(target_pid,
+						  target_tid, UINT_MAX);
 	if (evsel_list->threads == NULL) {
 		pr_err("Problems finding threads of monitor\n");
 		usage_with_options(stat_usage, options);
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 70c4eb2..0f15195 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1010,8 +1010,6 @@ realloc:
 static int test__PERF_RECORD(void)
 {
 	struct perf_record_opts opts = {
-		.target_pid = -1,
-		.target_tid = -1,
 		.no_delay   = true,
 		.freq	    = 10,
 		.mmap_pages = 256,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d869b21..94d55cb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -965,7 +965,7 @@ static int __cmd_top(struct perf_top *top)
 	if (ret)
 		goto out_delete;
 
-	if (top->target_tid != -1 || top->uid != UINT_MAX)
+	if (top->target_tid || top->uid != UINT_MAX)
 		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
 						  perf_event__process,
 						  &top->session->host_machine);
@@ -1103,8 +1103,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	struct perf_top top = {
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
-		.target_pid	     = -1,
-		.target_tid	     = -1,
 		.uid		     = UINT_MAX,
 		.freq		     = 1000, /* 1 KHz */
 		.sample_id_all_avail = true,
@@ -1118,9 +1116,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		     parse_events_option),
 	OPT_INTEGER('c', "count", &top.default_interval,
 		    "event period to sample"),
-	OPT_INTEGER('p', "pid", &top.target_pid,
+	OPT_STRING('p', "pid", &top.target_pid, "pid",
 		    "profile events on existing process id"),
-	OPT_INTEGER('t', "tid", &top.target_tid,
+	OPT_STRING('t', "tid", &top.target_tid, "tid",
 		    "profile events on existing thread id"),
 	OPT_BOOLEAN('a', "all-cpus", &top.system_wide,
 			    "system-wide collection from all CPUs"),
@@ -1210,13 +1208,13 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		goto out_delete_evlist;
 
 	/* CPU and PID are mutually exclusive */
-	if (top.target_tid > 0 && top.cpu_list) {
+	if (top.target_tid && top.cpu_list) {
 		printf("WARNING: PID switch overriding CPU\n");
 		sleep(1);
 		top.cpu_list = NULL;
 	}
 
-	if (top.target_pid != -1)
+	if (top.target_pid)
 		top.target_tid = top.target_pid;
 
 	if (perf_evlist__create_maps(top.evlist, top.target_pid,
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 92af168..deb17db 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -186,8 +186,8 @@ extern const char perf_version_string[];
 void pthread__unblock_sigwinch(void);
 
 struct perf_record_opts {
-	pid_t	     target_pid;
-	pid_t	     target_tid;
+	const char   *target_pid;
+	const char   *target_tid;
 	uid_t	     uid;
 	bool	     call_graph;
 	bool	     group;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a57a8cf..5c61dc5 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -593,15 +593,15 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
 }
 
-int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
-			     pid_t target_tid, uid_t uid, const char *cpu_list)
+int perf_evlist__create_maps(struct perf_evlist *evlist, const char *target_pid,
+			     const char *target_tid, uid_t uid, const char *cpu_list)
 {
-	evlist->threads = thread_map__new(target_pid, target_tid, uid);
+	evlist->threads = thread_map__new_str(target_pid, target_tid, uid);
 
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (uid != UINT_MAX || (cpu_list == NULL && target_tid != -1))
+	if (uid != UINT_MAX || (cpu_list == NULL && target_tid))
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(cpu_list);
@@ -820,7 +820,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		exit(-1);
 	}
 
-	if (!opts->system_wide && opts->target_tid == -1 && opts->target_pid == -1)
+	if (!opts->system_wide && !opts->target_tid && !opts->target_pid)
 		evlist->threads->map[0] = evlist->workload.pid;
 
 	close(child_ready_pipe[1]);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 1b4282b..21f1c9e 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -106,8 +106,8 @@ static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 	evlist->threads	= threads;
 }
 
-int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
-			     pid_t tid, uid_t uid, const char *cpu_list);
+int perf_evlist__create_maps(struct perf_evlist *evlist, const char *target_pid,
+			     const char *tid, uid_t uid, const char *cpu_list);
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
 int perf_evlist__set_filters(struct perf_evlist *evlist);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9a11f9e..f910f50 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -130,7 +130,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	attr->mmap = track;
 	attr->comm = track;
 
-	if (opts->target_pid == -1 && opts->target_tid == -1 && !opts->system_wide) {
+	if (!opts->target_pid && !opts->target_tid && !opts->system_wide) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index ff606f4..2884e67 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -15,3 +15,5 @@ util/util.c
 util/xyarray.c
 util/cgroup.c
 util/debugfs.c
+util/strlist.c
+../../lib/rbtree.c
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 3d4b6c5..e15983c 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -6,6 +6,8 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <unistd.h>
+#include "strlist.h"
+#include <string.h>
 #include "thread_map.h"
 
 /* Skip "." and ".." directories */
@@ -152,6 +154,132 @@ struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid)
 	return thread_map__new_by_tid(tid);
 }
 
+static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
+{
+	struct thread_map *threads = NULL, *nt;
+	char name[256];
+	int items, total_tasks = 0;
+	struct dirent **namelist = NULL;
+	int i, j = 0;
+	pid_t pid, prev_pid = INT_MAX;
+	char *end_ptr;
+	struct str_node *pos;
+	struct strlist *slist = strlist__new(false, pid_str);
+
+	if (!slist)
+		return NULL;
+
+	strlist__for_each(pos, slist) {
+		pid = strtol(pos->s, &end_ptr, 10);
+
+		if (pid == INT_MIN || pid == INT_MAX ||
+		    (*end_ptr != '\0' && *end_ptr != ','))
+			goto out_free_threads;
+
+		if (pid == prev_pid)
+			continue;
+
+		sprintf(name, "/proc/%d/task", pid);
+		items = scandir(name, &namelist, filter, NULL);
+		if (items <= 0)
+			goto out_free_threads;
+
+		total_tasks += items;
+		nt = realloc(threads, (sizeof(*threads) +
+				       sizeof(pid_t) * total_tasks));
+		if (nt == NULL)
+			goto out_free_threads;
+
+		threads = nt;
+
+		if (threads) {
+			for (i = 0; i < items; i++)
+				threads->map[j++] = atoi(namelist[i]->d_name);
+			threads->nr = total_tasks;
+		}
+
+		for (i = 0; i < items; i++)
+			free(namelist[i]);
+		free(namelist);
+
+		if (!threads)
+			break;
+	}
+
+out:
+	strlist__delete(slist);
+	return threads;
+
+out_free_threads:
+	free(threads);
+	threads = NULL;
+	goto out;
+}
+
+static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
+{
+	struct thread_map *threads = NULL, *nt;
+	int ntasks = 0;
+	pid_t tid, prev_tid = INT_MAX;
+	char *end_ptr;
+	struct str_node *pos;
+	struct strlist *slist;
+
+	/* perf-stat expects threads to be generated even if tid not given */
+	if (!tid_str) {
+		threads = malloc(sizeof(*threads) + sizeof(pid_t));
+		if (threads != NULL) {
+			threads->map[1] = -1;
+			threads->nr	= 1;
+		}
+		return threads;
+	}
+
+	slist = strlist__new(false, tid_str);
+	if (!slist)
+		return NULL;
+
+	strlist__for_each(pos, slist) {
+		tid = strtol(pos->s, &end_ptr, 10);
+
+		if (tid == INT_MIN || tid == INT_MAX ||
+		    (*end_ptr != '\0' && *end_ptr != ','))
+			goto out_free_threads;
+
+		if (tid == prev_tid)
+			continue;
+
+		ntasks++;
+		nt = realloc(threads, sizeof(*threads) + sizeof(pid_t) * ntasks);
+
+		if (nt == NULL)
+			goto out_free_threads;
+
+		threads = nt;
+		threads->map[ntasks - 1] = tid;
+		threads->nr		 = ntasks;
+	}
+out:
+	return threads;
+
+out_free_threads:
+	free(threads);
+	threads = NULL;
+	goto out;
+}
+
+struct thread_map *thread_map__new_str(const char *pid, const char *tid,
+				       uid_t uid)
+{
+	if (pid)
+		return thread_map__new_by_pid_str(pid);
+
+	if (!tid && uid != UINT_MAX)
+		return thread_map__new_by_uid(uid);
+
+	return thread_map__new_by_tid_str(tid);
+}
+
 void thread_map__delete(struct thread_map *threads)
 {
 	free(threads);
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index c75ddba..7da80f1 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -13,6 +13,10 @@ struct thread_map *thread_map__new_by_pid(pid_t pid);
 struct thread_map *thread_map__new_by_tid(pid_t tid);
 struct thread_map *thread_map__new_by_uid(uid_t uid);
 struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid);
+
+struct thread_map *thread_map__new_str(const char *pid,
+		const char *tid, uid_t uid);
+
 void thread_map__delete(struct thread_map *threads);
 
 size_t thread_map__fprintf(struct thread_map *threads, FILE *fp);
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index e4370ca..09fe579 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -69,11 +69,11 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 
 	ret += SNPRINTF(bf + ret, size - ret, "], ");
 
-	if (top->target_pid != -1)
-		ret += SNPRINTF(bf + ret, size - ret, " (target_pid: %d",
+	if (top->target_pid)
+		ret += SNPRINTF(bf + ret, size - ret, " (target_pid: %s",
 				top->target_pid);
-	else if (top->target_tid != -1)
-		ret += SNPRINTF(bf + ret, size - ret, " (target_tid: %d",
+	else if (top->target_tid)
+		ret += SNPRINTF(bf + ret, size - ret, " (target_tid: %s",
 				top->target_tid);
 	else if (top->uid_str != NULL)
 		ret += SNPRINTF(bf + ret, size - ret, " (uid: %s",
@@ -85,7 +85,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 		ret += SNPRINTF(bf + ret, size - ret, ", CPU%s: %s)",
 				top->evlist->cpus->nr > 1 ? "s" : "", top->cpu_list);
 	else {
-		if (top->target_tid != -1)
+		if (top->target_tid)
 			ret += SNPRINTF(bf + ret, size - ret, ")");
 		else
 			ret += SNPRINTF(bf + ret, size - ret, ", %d CPU%s)",
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index def3e53..49eb848 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -23,7 +23,7 @@ struct perf_top {
 	u64		   guest_us_samples, guest_kernel_samples;
 	int		   print_entries, count_filter, delay_secs;
 	int		   freq;
-	pid_t		   target_pid, target_tid;
+	const char	   *target_pid, *target_tid;
 	uid_t		   uid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	bool		   system_wide;
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index d0c0139..52bb07c 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -83,7 +83,7 @@ void warning(const char *warn, ...)
 	va_end(params);
 }
 
-uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
+uid_t parse_target_uid(const char *str, const char *tid, const char *pid)
 {
 	struct passwd pwd, *result;
 	char buf[1024];
@@ -91,8 +91,8 @@ uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
 	if (str == NULL)
 		return UINT_MAX;
 
-	/* CPU and PID are mutually exclusive */
-	if (tid > 0 || pid > 0) {
+	/* UID and PID are mutually exclusive */
+	if (tid || pid) {
 		ui__warning("PID/TID switch overriding UID\n");
 		sleep(1);
 		return UINT_MAX;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 232d17e..7917b09 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -245,7 +245,7 @@ struct perf_event_attr;
 
 void event_attr_init(struct perf_event_attr *attr);
 
-uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid);
+uid_t parse_target_uid(const char *str, const char *tid, const char *pid);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
