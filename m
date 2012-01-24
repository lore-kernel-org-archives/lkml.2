Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2AXXIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:08:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:50949 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2AXXIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:08:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/9] perf tools: Introduce per user view
Date: Tue, 24 Jan 2012 21:07:54 -0200
Message-Id: <1327446481-5505-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327446481-5505-1-git-send-email-acme@infradead.org>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The new --uid command line option will show only the tasks for a given
user, using the proc interface to figure out the existing tasks.

Kernel work is needed to close races at startup, but this should already
be useful in many use cases.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-bdnspm000gw2l984a2t53o8z@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt |    4 +
 tools/perf/Documentation/perf-top.txt    |    4 +
 tools/perf/builtin-record.c              |   12 +++-
 tools/perf/builtin-stat.c                |    2 +-
 tools/perf/builtin-test.c                |    8 +-
 tools/perf/builtin-top.c                 |   22 ++++++-
 tools/perf/perf.h                        |    1 +
 tools/perf/util/evlist.c                 |    6 +-
 tools/perf/util/evlist.h                 |    2 +-
 tools/perf/util/hist.h                   |    1 +
 tools/perf/util/python.c                 |   10 ++--
 tools/perf/util/thread_map.c             |   98 +++++++++++++++++++++++++++++-
 tools/perf/util/thread_map.h             |    3 +-
 tools/perf/util/top.c                    |    3 +
 tools/perf/util/top.h                    |    2 +
 tools/perf/util/ui/browsers/hists.c      |    3 +
 tools/perf/util/usage.c                  |   39 ++++++++++++
 tools/perf/util/util.h                   |    2 +
 18 files changed, 200 insertions(+), 22 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 2937f7e..ff9a66e 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -58,6 +58,10 @@ OPTIONS
 --tid=::
         Record events on existing thread ID.
 
+-u::
+--uid=::
+        Record events in threads owned by uid. Name or number.
+
 -r::
 --realtime=::
 	Collect data with this RT SCHED_FIFO priority.
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index b1a5bbb..ab1454e 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -78,6 +78,10 @@ Default is to monitor all CPUS.
 --tid=<tid>::
         Profile events on existing thread ID.
 
+-u::
+--uid=::
+        Record events in threads owned by uid. Name or number.
+
 -r <priority>::
 --realtime=<priority>::
 	Collect data with this RT SCHED_FIFO priority.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0abfb18..32870ee 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -44,6 +44,7 @@ struct perf_record {
 	struct perf_evlist	*evlist;
 	struct perf_session	*session;
 	const char		*progname;
+	const char		*uid_str;
 	int			output;
 	unsigned int		page_size;
 	int			realtime_prio;
@@ -727,6 +728,7 @@ const struct option record_options[] = {
 	OPT_CALLBACK('G', "cgroup", &record.evlist, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
+	OPT_STRING('u', "uid", &record.uid_str, "user", "user to profile"),
 	OPT_END()
 };
 
@@ -748,7 +750,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && rec->opts.target_pid == -1 && rec->opts.target_tid == -1 &&
-		!rec->opts.system_wide && !rec->opts.cpu_list)
+		!rec->opts.system_wide && !rec->opts.cpu_list && !rec->uid_str)
 		usage_with_options(record_usage, record_options);
 
 	if (rec->force && rec->append_file) {
@@ -788,11 +790,17 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
+	rec->opts.uid = parse_target_uid(rec->uid_str, rec->opts.target_tid,
+					 rec->opts.target_pid);
+	if (rec->uid_str != NULL && rec->opts.uid == UINT_MAX - 1)
+		goto out_free_fd;
+
 	if (rec->opts.target_pid != -1)
 		rec->opts.target_tid = rec->opts.target_pid;
 
 	if (perf_evlist__create_maps(evsel_list, rec->opts.target_pid,
-				     rec->opts.target_tid, rec->opts.cpu_list) < 0)
+				     rec->opts.target_tid, rec->opts.uid,
+				     rec->opts.cpu_list) < 0)
 		usage_with_options(record_usage, record_options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f5d2a63..459b862 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1201,7 +1201,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (target_pid != -1)
 		target_tid = target_pid;
 
-	evsel_list->threads = thread_map__new(target_pid, target_tid);
+	evsel_list->threads = thread_map__new(target_pid, target_tid, UINT_MAX);
 	if (evsel_list->threads == NULL) {
 		pr_err("Problems finding threads of monitor\n");
 		usage_with_options(stat_usage, options);
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 3854e86..3ce709e 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -276,7 +276,7 @@ static int test__open_syscall_event(void)
 		return -1;
 	}
 
-	threads = thread_map__new(-1, getpid());
+	threads = thread_map__new(-1, getpid(), UINT_MAX);
 	if (threads == NULL) {
 		pr_debug("thread_map__new\n");
 		return -1;
@@ -342,7 +342,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 		return -1;
 	}
 
-	threads = thread_map__new(-1, getpid());
+	threads = thread_map__new(-1, getpid(), UINT_MAX);
 	if (threads == NULL) {
 		pr_debug("thread_map__new\n");
 		return -1;
@@ -490,7 +490,7 @@ static int test__basic_mmap(void)
 		expected_nr_events[i] = random() % 257;
 	}
 
-	threads = thread_map__new(-1, getpid());
+	threads = thread_map__new(-1, getpid(), UINT_MAX);
 	if (threads == NULL) {
 		pr_debug("thread_map__new\n");
 		return -1;
@@ -1054,7 +1054,7 @@ static int test__PERF_RECORD(void)
 	 * we're monitoring, the one forked there.
 	 */
 	err = perf_evlist__create_maps(evlist, opts.target_pid,
-				       opts.target_tid, opts.cpu_list);
+				       opts.target_tid, UINT_MAX, opts.cpu_list);
 	if (err < 0) {
 		pr_debug("Not enough memory to create thread/cpu maps\n");
 		goto out_delete_evlist;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8f80df8..e8b033c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -64,7 +64,6 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-
 void get_term_dimensions(struct winsize *ws)
 {
 	char *s = getenv("LINES");
@@ -537,10 +536,20 @@ static void perf_top__sort_new_samples(void *arg)
 
 static void *display_thread_tui(void *arg)
 {
+	struct perf_evsel *pos;
 	struct perf_top *top = arg;
 	const char *help = "For a higher level overview, try: perf top --sort comm,dso";
 
 	perf_top__sort_new_samples(top);
+
+	/*
+	 * Initialize the uid_filter_str, in the future the TUI will allow
+	 * Zooming in/out UIDs. For now juse use whatever the user passed
+	 * via --uid.
+	 */
+	list_for_each_entry(pos, &top->evlist->entries, node)
+		pos->hists.uid_filter_str = top->uid_str;
+
 	perf_evlist__tui_browse_hists(top->evlist, help,
 				      perf_top__sort_new_samples,
 				      top, top->delay_secs);
@@ -949,7 +958,7 @@ static int __cmd_top(struct perf_top *top)
 	if (ret)
 		goto out_delete;
 
-	if (top->target_tid != -1)
+	if (top->target_tid != -1 || top->uid != UINT_MAX)
 		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
 						  perf_event__process,
 						  &top->session->host_machine);
@@ -1089,6 +1098,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		.delay_secs	     = 2,
 		.target_pid	     = -1,
 		.target_tid	     = -1,
+		.uid		     = UINT_MAX,
 		.freq		     = 1000, /* 1 KHz */
 		.sample_id_all_avail = true,
 		.mmap_pages	     = 128,
@@ -1162,6 +1172,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		    "Display raw encoding of assembly instructions (default)"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
+	OPT_STRING('u', "uid", &top.uid_str, "user", "user to profile"),
 	OPT_END()
 	};
 
@@ -1187,6 +1198,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	setup_browser(false);
 
+	top.uid = parse_target_uid(top.uid_str, top.target_tid, top.target_pid);
+	if (top.uid_str != NULL && top.uid == UINT_MAX - 1)
+		goto out_delete_evlist;
+
 	/* CPU and PID are mutually exclusive */
 	if (top.target_tid > 0 && top.cpu_list) {
 		printf("WARNING: PID switch overriding CPU\n");
@@ -1198,7 +1213,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		top.target_tid = top.target_pid;
 
 	if (perf_evlist__create_maps(top.evlist, top.target_pid,
-				     top.target_tid, top.cpu_list) < 0)
+				     top.target_tid, top.uid, top.cpu_list) < 0)
 		usage_with_options(top_usage, options);
 
 	if (!top.evlist->nr_entries &&
@@ -1262,6 +1277,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	status = __cmd_top(&top);
 
+out_delete_evlist:
 	perf_evlist__delete(top.evlist);
 
 	return status;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 64f8bee..92af168 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -188,6 +188,7 @@ void pthread__unblock_sigwinch(void);
 struct perf_record_opts {
 	pid_t	     target_pid;
 	pid_t	     target_tid;
+	uid_t	     uid;
 	bool	     call_graph;
 	bool	     group;
 	bool	     inherit_stat;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3f16e08..a6d50e3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -594,14 +594,14 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 }
 
 int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
-			     pid_t target_tid, const char *cpu_list)
+			     pid_t target_tid, uid_t uid, const char *cpu_list)
 {
-	evlist->threads = thread_map__new(target_pid, target_tid);
+	evlist->threads = thread_map__new(target_pid, target_tid, uid);
 
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (cpu_list == NULL && target_tid != -1)
+	if (uid != UINT_MAX || (cpu_list == NULL && target_tid != -1))
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(cpu_list);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 8922aee..9c51660 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -107,7 +107,7 @@ static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 }
 
 int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
-			     pid_t target_tid, const char *cpu_list);
+			     pid_t tid, uid_t uid, const char *cpu_list);
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
 int perf_evlist__set_filters(struct perf_evlist *evlist);
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f55f0a8d..0d48613 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -55,6 +55,7 @@ struct hists {
 	u64			nr_entries;
 	const struct thread	*thread_filter;
 	const struct dso	*dso_filter;
+	const char		*uid_filter_str;
 	pthread_mutex_t		lock;
 	struct events_stats	stats;
 	u64			event_stream;
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 9dd47a4..e03b58a 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -425,14 +425,14 @@ struct pyrf_thread_map {
 static int pyrf_thread_map__init(struct pyrf_thread_map *pthreads,
 				 PyObject *args, PyObject *kwargs)
 {
-	static char *kwlist[] = { "pid", "tid", NULL };
-	int pid = -1, tid = -1;
+	static char *kwlist[] = { "pid", "tid", "uid", NULL };
+	int pid = -1, tid = -1, uid = UINT_MAX;
 
-	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|ii",
-					 kwlist, &pid, &tid))
+	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|iii",
+					 kwlist, &pid, &tid, &uid))
 		return -1;
 
-	pthreads->threads = thread_map__new(pid, tid);
+	pthreads->threads = thread_map__new(pid, tid, uid);
 	if (pthreads->threads == NULL)
 		return -1;
 	return 0;
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 894d52f..3d4b6c5 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -1,6 +1,11 @@
 #include <dirent.h>
+#include <limits.h>
+#include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
 #include "thread_map.h"
 
 /* Skip "." and ".." directories */
@@ -23,7 +28,7 @@ struct thread_map *thread_map__new_by_pid(pid_t pid)
 	sprintf(name, "/proc/%d/task", pid);
 	items = scandir(name, &namelist, filter, NULL);
 	if (items <= 0)
-                return NULL;
+		return NULL;
 
 	threads = malloc(sizeof(*threads) + sizeof(pid_t) * items);
 	if (threads != NULL) {
@@ -51,10 +56,99 @@ struct thread_map *thread_map__new_by_tid(pid_t tid)
 	return threads;
 }
 
-struct thread_map *thread_map__new(pid_t pid, pid_t tid)
+struct thread_map *thread_map__new_by_uid(uid_t uid)
+{
+	DIR *proc;
+	int max_threads = 32, items, i;
+	char path[256];
+	struct dirent dirent, *next, **namelist = NULL;
+	struct thread_map *threads = malloc(sizeof(*threads) +
+					    max_threads * sizeof(pid_t));
+	if (threads == NULL)
+		goto out;
+
+	proc = opendir("/proc");
+	if (proc == NULL)
+		goto out_free_threads;
+
+	threads->nr = 0;
+
+	while (!readdir_r(proc, &dirent, &next) && next) {
+		char *end;
+		bool grow = false;
+		struct stat st;
+		pid_t pid = strtol(dirent.d_name, &end, 10);
+
+		if (*end) /* only interested in proper numerical dirents */
+			continue;
+
+		snprintf(path, sizeof(path), "/proc/%s", dirent.d_name);
+
+		if (stat(path, &st) != 0)
+			continue;
+
+		if (st.st_uid != uid)
+			continue;
+
+		snprintf(path, sizeof(path), "/proc/%d/task", pid);
+		items = scandir(path, &namelist, filter, NULL);
+		if (items <= 0)
+			goto out_free_closedir;
+
+		while (threads->nr + items >= max_threads) {
+			max_threads *= 2;
+			grow = true;
+		}
+
+		if (grow) {
+			struct thread_map *tmp;
+
+			tmp = realloc(threads, (sizeof(*threads) +
+						max_threads * sizeof(pid_t)));
+			if (tmp == NULL)
+				goto out_free_namelist;
+
+			threads = tmp;
+		}
+
+		for (i = 0; i < items; i++)
+			threads->map[threads->nr + i] = atoi(namelist[i]->d_name);
+
+		for (i = 0; i < items; i++)
+			free(namelist[i]);
+		free(namelist);
+
+		threads->nr += items;
+	}
+
+out_closedir:
+	closedir(proc);
+out:
+	return threads;
+
+out_free_threads:
+	free(threads);
+	return NULL;
+
+out_free_namelist:
+	for (i = 0; i < items; i++)
+		free(namelist[i]);
+	free(namelist);
+
+out_free_closedir:
+	free(threads);
+	threads = NULL;
+	goto out_closedir;
+}
+
+struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid)
 {
 	if (pid != -1)
 		return thread_map__new_by_pid(pid);
+
+	if (tid == -1 && uid != UINT_MAX)
+		return thread_map__new_by_uid(uid);
+
 	return thread_map__new_by_tid(tid);
 }
 
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index 736ab4a26..c75ddba 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -11,7 +11,8 @@ struct thread_map {
 
 struct thread_map *thread_map__new_by_pid(pid_t pid);
 struct thread_map *thread_map__new_by_tid(pid_t tid);
-struct thread_map *thread_map__new(pid_t pid, pid_t tid);
+struct thread_map *thread_map__new_by_uid(uid_t uid);
+struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid);
 void thread_map__delete(struct thread_map *threads);
 
 size_t thread_map__fprintf(struct thread_map *threads, FILE *fp);
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 500471d..e4370ca 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -75,6 +75,9 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 	else if (top->target_tid != -1)
 		ret += SNPRINTF(bf + ret, size - ret, " (target_tid: %d",
 				top->target_tid);
+	else if (top->uid_str != NULL)
+		ret += SNPRINTF(bf + ret, size - ret, " (uid: %s",
+				top->uid_str);
 	else
 		ret += SNPRINTF(bf + ret, size - ret, " (all");
 
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index a248f3c..def3e53 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -24,6 +24,7 @@ struct perf_top {
 	int		   print_entries, count_filter, delay_secs;
 	int		   freq;
 	pid_t		   target_pid, target_tid;
+	uid_t		   uid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	bool		   system_wide;
 	bool		   use_tui, use_stdio;
@@ -45,6 +46,7 @@ struct perf_top {
 	int		   realtime_prio;
 	int		   sym_pcnt_filter;
 	const char	   *sym_filter;
+	const char	   *uid_str;
 };
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 1212a38..7b6669d 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -841,6 +841,9 @@ static int hists__browser_title(struct hists *self, char *bf, size_t size,
 	nr_events = convert_unit(nr_events, &unit);
 	printed = snprintf(bf, size, "Events: %lu%c %s", nr_events, unit, ev_name);
 
+	if (self->uid_filter_str)
+		printed += snprintf(bf + printed, size - printed,
+				    ", UID: %s", self->uid_filter_str);
 	if (thread)
 		printed += snprintf(bf + printed, size - printed,
 				    ", Thread: %s(%d)",
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index d76d1c0..d0c0139 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -7,6 +7,7 @@
  * Copyright (C) Linus Torvalds, 2005
  */
 #include "util.h"
+#include "debug.h"
 
 static void report(const char *prefix, const char *err, va_list params)
 {
@@ -81,3 +82,41 @@ void warning(const char *warn, ...)
 	warn_routine(warn, params);
 	va_end(params);
 }
+
+uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
+{
+	struct passwd pwd, *result;
+	char buf[1024];
+
+	if (str == NULL)
+		return UINT_MAX;
+
+	/* CPU and PID are mutually exclusive */
+	if (tid > 0 || pid > 0) {
+		ui__warning("PID/TID switch overriding UID\n");
+		sleep(1);
+		return UINT_MAX;
+	}
+
+	getpwnam_r(str, &pwd, buf, sizeof(buf), &result);
+
+	if (result == NULL) {
+		char *endptr;
+		int uid = strtol(str, &endptr, 10);
+
+		if (*endptr != '\0') {
+			ui__error("Invalid user %s\n", str);
+			return UINT_MAX - 1;
+		}
+
+		getpwuid_r(uid, &pwd, buf, sizeof(buf), &result);
+
+		if (result == NULL) {
+			ui__error("Problems obtaining information for user %s\n",
+				  str);
+			return UINT_MAX - 1;
+		}
+	}
+
+	return result->pw_uid;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b9c530c..061dbf8 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -246,6 +246,8 @@ struct perf_event_attr;
 
 void event_attr_init(struct perf_event_attr *attr);
 
+uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid);
+
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-- 
1.7.9.rc2.1.g69204

