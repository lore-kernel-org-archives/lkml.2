Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab1AaV3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:29:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab1AaV3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:29:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/5] perf evlist: Store pointer to the cpu and thread maps
Date: Mon, 31 Jan 2011 19:29:19 -0200
Message-Id: <1296509362-28054-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296509362-28054-1-git-send-email-acme@infradead.org>
References: <1296509362-28054-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we don't have to pass it around to the several methods that
needs it, simplifying usage.

There is one case where we don't have the thread/cpu map in advance,
which is in the parsing routines used by top, stat, record, that we have
to wait till all options are parsed to know if a cpu or thread list was
passed to then create those maps.

For that case consolidate the cpu and thread map creation via
perf_evlist__create_maps() out of the code in top and record, while also
providing a perf_evlist__set_maps() for cases where multiple evlists
share maps or for when maps that represent CPU sockets, for instance,
get crafted out of topology information or subsets of threads in a
particular application are to be monitored, providing more granularity
in specifying which cpus and threads to monitor.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   44 ++++++++++------------------
 tools/perf/builtin-stat.c   |   45 ++++++++++++++---------------
 tools/perf/builtin-test.c   |    6 ++--
 tools/perf/builtin-top.c    |   47 ++++++++++++------------------
 tools/perf/python/twatch.py |    4 +-
 tools/perf/util/evlist.c    |   67 ++++++++++++++++++++++++++++++++-----------
 tools/perf/util/evlist.h    |   29 ++++++++++++++----
 tools/perf/util/python.c    |   25 +++++++++-------
 8 files changed, 148 insertions(+), 119 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index edc3555..07f8d6d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -42,7 +42,6 @@ static u64			user_interval			= ULLONG_MAX;
 static u64			default_interval		=      0;
 static u64			sample_type;
 
-static struct cpu_map		*cpus;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			=    128;
 static unsigned int		user_freq 			= UINT_MAX;
@@ -58,7 +57,6 @@ static bool			sample_id_all_avail		=   true;
 static bool			system_wide			=  false;
 static pid_t			target_pid			=     -1;
 static pid_t			target_tid			=     -1;
-static struct thread_map	*threads;
 static pid_t			child_pid			=     -1;
 static bool			no_inherit			=  false;
 static enum write_mode_t	write_mode			= WRITE_FORCE;
@@ -189,7 +187,7 @@ static void create_counter(struct perf_evsel *evsel, int cpu)
 	int thread_index;
 	int ret;
 
-	for (thread_index = 0; thread_index < threads->nr; thread_index++) {
+	for (thread_index = 0; thread_index < evsel_list->threads->nr; thread_index++) {
 		h_attr = get_header_attr(attr, evsel->idx);
 		if (h_attr == NULL)
 			die("nomem\n");
@@ -317,7 +315,8 @@ static void open_counters(struct perf_evlist *evlist)
 retry_sample_id:
 		attr->sample_id_all = sample_id_all_avail ? 1 : 0;
 try_again:
-		if (perf_evsel__open(pos, cpus, threads, group, !no_inherit) < 0) {
+		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, group,
+				     !no_inherit) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES)
@@ -368,10 +367,10 @@ try_again:
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, cpus, threads, mmap_pages, false) < 0)
+	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0)
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 
-	for (cpu = 0; cpu < cpus->nr; ++cpu) {
+	for (cpu = 0; cpu < evsel_list->cpus->nr; ++cpu) {
 		list_for_each_entry(pos, &evlist->entries, node)
 			create_counter(pos, cpu);
 	}
@@ -450,7 +449,7 @@ static void mmap_read_all(void)
 {
 	int i;
 
-	for (i = 0; i < cpus->nr; i++) {
+	for (i = 0; i < evsel_list->cpus->nr; i++) {
 		if (evsel_list->mmap[i].base)
 			mmap_read(&evsel_list->mmap[i]);
 	}
@@ -584,7 +583,7 @@ static int __cmd_record(int argc, const char **argv)
 		}
 
 		if (!system_wide && target_tid == -1 && target_pid == -1)
-			threads->map[0] = child_pid;
+			evsel_list->threads->map[0] = child_pid;
 
 		close(child_ready_pipe[1]);
 		close(go_pipe[0]);
@@ -718,12 +717,12 @@ static int __cmd_record(int argc, const char **argv)
 		}
 
 		if (done) {
-			for (i = 0; i < cpus->nr; i++) {
+			for (i = 0; i < evsel_list->cpus->nr; i++) {
 				struct perf_evsel *pos;
 
 				list_for_each_entry(pos, &evsel_list->entries, node) {
 					for (thread = 0;
-						thread < threads->nr;
+						thread < evsel_list->threads->nr;
 						thread++)
 						ioctl(FD(pos, i, thread),
 							PERF_EVENT_IOC_DISABLE);
@@ -816,7 +815,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	int err = -ENOMEM;
 	struct perf_evsel *pos;
 
-	evsel_list = perf_evlist__new();
+	evsel_list = perf_evlist__new(NULL, NULL);
 	if (evsel_list == NULL)
 		return -ENOMEM;
 
@@ -850,28 +849,19 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (target_pid != -1)
 		target_tid = target_pid;
 
-	threads = thread_map__new(target_pid, target_tid);
-	if (threads == NULL) {
-		pr_err("Problems finding threads of monitor\n");
-		usage_with_options(record_usage, record_options);
-	}
-
-	if (target_tid != -1)
-		cpus = cpu_map__dummy_new();
-	else
-		cpus = cpu_map__new(cpu_list);
-
-	if (cpus == NULL)
+	if (perf_evlist__create_maps(evsel_list, target_pid,
+				     target_tid, cpu_list) < 0)
 		usage_with_options(record_usage, record_options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
-		if (perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
+		if (perf_evsel__alloc_fd(pos, evsel_list->cpus->nr,
+					 evsel_list->threads->nr) < 0)
 			goto out_free_fd;
 		if (perf_header__push_event(pos->attr.config, event_name(pos)))
 			goto out_free_fd;
 	}
 
-	if (perf_evlist__alloc_pollfd(evsel_list, cpus->nr, threads->nr) < 0)
+	if (perf_evlist__alloc_pollfd(evsel_list) < 0)
 		goto out_free_fd;
 
 	if (user_interval != ULLONG_MAX)
@@ -893,10 +883,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	}
 
 	err = __cmd_record(argc, argv);
-
 out_free_fd:
-	thread_map__delete(threads);
-	threads = NULL;
+	perf_evlist__delete_maps(evsel_list);
 out_symbol_exit:
 	symbol__exit();
 	return err;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8906adf..e0f9575 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -76,7 +76,6 @@ static struct perf_event_attr default_attrs[] = {
 struct perf_evlist		*evsel_list;
 
 static bool			system_wide			=  false;
-static struct cpu_map		*cpus;
 static int			run_idx				=  0;
 
 static int			run_count			=  1;
@@ -85,7 +84,6 @@ static bool			scale				=  true;
 static bool			no_aggr				= false;
 static pid_t			target_pid			= -1;
 static pid_t			target_tid			= -1;
-static struct thread_map	*threads;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static bool			big_num				=  true;
@@ -170,7 +168,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, cpus, false, false);
+		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus, false, false);
 
 	attr->inherit = !no_inherit;
 	if (target_pid == -1 && target_tid == -1) {
@@ -178,7 +176,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, threads, false, false);
+	return perf_evsel__open_per_thread(evsel, evsel_list->threads, false, false);
 }
 
 /*
@@ -203,7 +201,8 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	u64 *count = counter->counts->aggr.values;
 	int i;
 
-	if (__perf_evsel__read(counter, cpus->nr, threads->nr, scale) < 0)
+	if (__perf_evsel__read(counter, evsel_list->cpus->nr,
+			       evsel_list->threads->nr, scale) < 0)
 		return -1;
 
 	for (i = 0; i < 3; i++)
@@ -236,7 +235,7 @@ static int read_counter(struct perf_evsel *counter)
 	u64 *count;
 	int cpu;
 
-	for (cpu = 0; cpu < cpus->nr; cpu++) {
+	for (cpu = 0; cpu < evsel_list->cpus->nr; cpu++) {
 		if (__perf_evsel__read_on_cpu(counter, cpu, 0, scale) < 0)
 			return -1;
 
@@ -301,7 +300,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 		}
 
 		if (target_tid == -1 && target_pid == -1 && !system_wide)
-			threads->map[0] = child_pid;
+			evsel_list->threads->map[0] = child_pid;
 
 		/*
 		 * Wait for the child to be ready to exec.
@@ -353,12 +352,13 @@ static int run_perf_stat(int argc __used, const char **argv)
 	if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			read_counter(counter);
-			perf_evsel__close_fd(counter, cpus->nr, 1);
+			perf_evsel__close_fd(counter, evsel_list->cpus->nr, 1);
 		}
 	} else {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			read_counter_aggr(counter);
-			perf_evsel__close_fd(counter, cpus->nr, threads->nr);
+			perf_evsel__close_fd(counter, evsel_list->cpus->nr,
+					     evsel_list->threads->nr);
 		}
 	}
 
@@ -386,7 +386,7 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
-			cpus->map[cpu], csv_sep);
+			evsel_list->cpus->map[cpu], csv_sep);
 
 	fprintf(stderr, fmt, cpustr, msecs, csv_sep, event_name(evsel));
 
@@ -414,7 +414,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
-			cpus->map[cpu], csv_sep);
+			evsel_list->cpus->map[cpu], csv_sep);
 	else
 		cpu = 0;
 
@@ -500,14 +500,14 @@ static void print_counter(struct perf_evsel *counter)
 	u64 ena, run, val;
 	int cpu;
 
-	for (cpu = 0; cpu < cpus->nr; cpu++) {
+	for (cpu = 0; cpu < evsel_list->cpus->nr; cpu++) {
 		val = counter->counts->cpu[cpu].val;
 		ena = counter->counts->cpu[cpu].ena;
 		run = counter->counts->cpu[cpu].run;
 		if (run == 0 || ena == 0) {
 			fprintf(stderr, "CPU%*d%s%*s%s%-24s",
 				csv_output ? 0 : -4,
-				cpus->map[cpu], csv_sep,
+				evsel_list->cpus->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
 				"<not counted>", csv_sep,
 				event_name(counter));
@@ -652,7 +652,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	setlocale(LC_ALL, "");
 
-	evsel_list = perf_evlist__new();
+	evsel_list = perf_evlist__new(NULL, NULL);
 	if (evsel_list == NULL)
 		return -ENOMEM;
 
@@ -701,18 +701,18 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (target_pid != -1)
 		target_tid = target_pid;
 
-	threads = thread_map__new(target_pid, target_tid);
-	if (threads == NULL) {
+	evsel_list->threads = thread_map__new(target_pid, target_tid);
+	if (evsel_list->threads == NULL) {
 		pr_err("Problems finding threads of monitor\n");
 		usage_with_options(stat_usage, options);
 	}
 
 	if (system_wide)
-		cpus = cpu_map__new(cpu_list);
+		evsel_list->cpus = cpu_map__new(cpu_list);
 	else
-		cpus = cpu_map__dummy_new();
+		evsel_list->cpus = cpu_map__dummy_new();
 
-	if (cpus == NULL) {
+	if (evsel_list->cpus == NULL) {
 		perror("failed to parse CPUs map");
 		usage_with_options(stat_usage, options);
 		return -1;
@@ -720,8 +720,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
 		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
-		    perf_evsel__alloc_counts(pos, cpus->nr) < 0 ||
-		    perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
+		    perf_evsel__alloc_counts(pos, evsel_list->cpus->nr) < 0 ||
+		    perf_evsel__alloc_fd(pos, evsel_list->cpus->nr, evsel_list->threads->nr) < 0)
 			goto out_free_fd;
 	}
 
@@ -750,7 +750,6 @@ out_free_fd:
 		perf_evsel__free_stat_priv(pos);
 	perf_evlist__delete(evsel_list);
 out:
-	thread_map__delete(threads);
-	threads = NULL;
+	perf_evlist__delete_maps(evsel_list);
 	return status;
 }
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 845b9bd..1b2106c 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -509,7 +509,7 @@ static int test__basic_mmap(void)
 		goto out_free_cpus;
 	}
 
-	evlist = perf_evlist__new();
+	evlist = perf_evlist__new(cpus, threads);
 	if (evlist == NULL) {
 		pr_debug("perf_evlist__new\n");
 		goto out_free_cpus;
@@ -537,7 +537,7 @@ static int test__basic_mmap(void)
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, cpus, threads, 128, true) < 0) {
+	if (perf_evlist__mmap(evlist, 128, true) < 0) {
 		pr_debug("failed to mmap events: %d (%s)\n", errno,
 			 strerror(errno));
 		goto out_close_fd;
@@ -579,7 +579,7 @@ static int test__basic_mmap(void)
 
 	err = 0;
 out_munmap:
-	perf_evlist__munmap(evlist, 1);
+	perf_evlist__munmap(evlist);
 out_close_fd:
 	for (i = 0; i < nsyscalls; ++i)
 		perf_evsel__close_fd(evsels[i], 1, threads->nr);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2f4d1f2..599036b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -73,9 +73,7 @@ static int			print_entries;
 
 static int			target_pid			=     -1;
 static int			target_tid			=     -1;
-static struct thread_map	*threads;
 static bool			inherit				=  false;
-static struct cpu_map		*cpus;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
 static unsigned int		page_size;
@@ -567,12 +565,13 @@ static void print_sym_table(struct perf_session *session)
 		printf(" (all");
 
 	if (cpu_list)
-		printf(", CPU%s: %s)\n", cpus->nr > 1 ? "s" : "", cpu_list);
+		printf(", CPU%s: %s)\n", evsel_list->cpus->nr > 1 ? "s" : "", cpu_list);
 	else {
 		if (target_tid != -1)
 			printf(")\n");
 		else
-			printf(", %d CPU%s)\n", cpus->nr, cpus->nr > 1 ? "s" : "");
+			printf(", %d CPU%s)\n", evsel_list->cpus->nr,
+			       evsel_list->cpus->nr > 1 ? "s" : "");
 	}
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
@@ -1124,7 +1123,7 @@ static void perf_session__mmap_read(struct perf_session *self)
 {
 	int i;
 
-	for (i = 0; i < cpus->nr; i++)
+	for (i = 0; i < evsel_list->cpus->nr; i++)
 		perf_session__mmap_read_cpu(self, i);
 }
 
@@ -1150,7 +1149,8 @@ static void start_counters(struct perf_evlist *evlist)
 
 		attr->mmap = 1;
 try_again:
-		if (perf_evsel__open(counter, cpus, threads, group, inherit) < 0) {
+		if (perf_evsel__open(counter, evsel_list->cpus,
+				     evsel_list->threads, group, inherit) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES)
@@ -1181,7 +1181,7 @@ try_again:
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, cpus, threads, mmap_pages, false) < 0)
+	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0)
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 }
 
@@ -1296,7 +1296,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	struct perf_evsel *pos;
 	int status = -ENOMEM;
 
-	evsel_list = perf_evlist__new();
+	evsel_list = perf_evlist__new(NULL, NULL);
 	if (evsel_list == NULL)
 		return -ENOMEM;
 
@@ -1306,15 +1306,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (argc)
 		usage_with_options(top_usage, options);
 
-	if (target_pid != -1)
-		target_tid = target_pid;
-
-	threads = thread_map__new(target_pid, target_tid);
-	if (threads == NULL) {
-		pr_err("Problems finding threads of monitor\n");
-		usage_with_options(top_usage, options);
-	}
-
 	/* CPU and PID are mutually exclusive */
 	if (target_tid > 0 && cpu_list) {
 		printf("WARNING: PID switch overriding CPU\n");
@@ -1322,6 +1313,13 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		cpu_list = NULL;
 	}
 
+	if (target_pid != -1)
+		target_tid = target_pid;
+
+	if (perf_evlist__create_maps(evsel_list, target_pid,
+				     target_tid, cpu_list) < 0)
+		usage_with_options(top_usage, options);
+
 	if (!evsel_list->nr_entries &&
 	    perf_evlist__add_default(evsel_list) < 0) {
 		pr_err("Not enough memory for event selector list\n");
@@ -1343,16 +1341,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		exit(EXIT_FAILURE);
 	}
 
-	if (target_tid != -1)
-		cpus = cpu_map__dummy_new();
-	else
-		cpus = cpu_map__new(cpu_list);
-
-	if (cpus == NULL)
-		usage_with_options(top_usage, options);
-
 	list_for_each_entry(pos, &evsel_list->entries, node) {
-		if (perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
+		if (perf_evsel__alloc_fd(pos, evsel_list->cpus->nr,
+					 evsel_list->threads->nr) < 0)
 			goto out_free_fd;
 		/*
 		 * Fill in the ones not specifically initialized via -c:
@@ -1363,8 +1354,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		pos->attr.sample_period = default_interval;
 	}
 
-	if (perf_evlist__alloc_pollfd(evsel_list, cpus->nr, threads->nr) < 0 ||
-	    perf_evlist__alloc_mmap(evsel_list, cpus->nr) < 0)
+	if (perf_evlist__alloc_pollfd(evsel_list) < 0 ||
+	    perf_evlist__alloc_mmap(evsel_list) < 0)
 		goto out_free_fd;
 
 	sym_evsel = list_entry(evsel_list->entries.next, struct perf_evsel, node);
diff --git a/tools/perf/python/twatch.py b/tools/perf/python/twatch.py
index 5e9f3b7..df638c4 100755
--- a/tools/perf/python/twatch.py
+++ b/tools/perf/python/twatch.py
@@ -23,9 +23,9 @@ def main():
 			   sample_id_all = 1,
 			   sample_type = perf.SAMPLE_PERIOD | perf.SAMPLE_TID | perf.SAMPLE_CPU | perf.SAMPLE_TID)
 	evsel.open(cpus = cpus, threads = threads);
-	evlist = perf.evlist()
+	evlist = perf.evlist(cpus, threads)
 	evlist.add(evsel)
-	evlist.mmap(cpus = cpus, threads = threads)
+	evlist.mmap()
 	while True:
 		evlist.poll(timeout = -1)
 		for cpu in cpus:
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index dcd5932..95b21fe 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -21,21 +21,24 @@
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define SID(e, x, y) xyarray__entry(e->id, x, y)
 
-void perf_evlist__init(struct perf_evlist *evlist)
+void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
+		       struct thread_map *threads)
 {
 	int i;
 
 	for (i = 0; i < PERF_EVLIST__HLIST_SIZE; ++i)
 		INIT_HLIST_HEAD(&evlist->heads[i]);
 	INIT_LIST_HEAD(&evlist->entries);
+	perf_evlist__set_maps(evlist, cpus, threads);
 }
 
-struct perf_evlist *perf_evlist__new(void)
+struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
+				     struct thread_map *threads)
 {
 	struct perf_evlist *evlist = zalloc(sizeof(*evlist));
 
 	if (evlist != NULL)
-		perf_evlist__init(evlist);
+		perf_evlist__init(evlist, cpus, threads);
 
 	return evlist;
 }
@@ -88,9 +91,9 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 	return 0;
 }
 
-int perf_evlist__alloc_pollfd(struct perf_evlist *evlist, int ncpus, int nthreads)
+int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
-	int nfds = ncpus * nthreads * evlist->nr_entries;
+	int nfds = evlist->cpus->nr * evlist->threads->nr * evlist->nr_entries;
 	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
 	return evlist->pollfd != NULL ? 0 : -ENOMEM;
 }
@@ -213,11 +216,11 @@ union perf_event *perf_evlist__read_on_cpu(struct perf_evlist *evlist, int cpu)
 	return event;
 }
 
-void perf_evlist__munmap(struct perf_evlist *evlist, int ncpus)
+void perf_evlist__munmap(struct perf_evlist *evlist)
 {
 	int cpu;
 
-	for (cpu = 0; cpu < ncpus; cpu++) {
+	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		if (evlist->mmap[cpu].base != NULL) {
 			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
 			evlist->mmap[cpu].base = NULL;
@@ -225,9 +228,9 @@ void perf_evlist__munmap(struct perf_evlist *evlist, int ncpus)
 	}
 }
 
-int perf_evlist__alloc_mmap(struct perf_evlist *evlist, int ncpus)
+int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 {
-	evlist->mmap = zalloc(ncpus * sizeof(struct perf_mmap));
+	evlist->mmap = zalloc(evlist->cpus->nr * sizeof(struct perf_mmap));
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
@@ -248,8 +251,6 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int cpu, int prot,
 /** perf_evlist__mmap - Create per cpu maps to receive events
  *
  * @evlist - list of events
- * @cpus - cpu map being monitored
- * @threads - threads map being monitored
  * @pages - map length in pages
  * @overwrite - overwrite older events?
  *
@@ -259,21 +260,22 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int cpu, int prot,
  *	unsigned int head = perf_mmap__read_head(m);
  *
  *	perf_mmap__write_tail(m, head)
+ *
+ * Using perf_evlist__read_on_cpu does this automatically.
  */
-int perf_evlist__mmap(struct perf_evlist *evlist, struct cpu_map *cpus,
-		      struct thread_map *threads, int pages, bool overwrite)
+int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 {
 	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
 	int mask = pages * page_size - 1, cpu;
 	struct perf_evsel *first_evsel, *evsel;
+	const struct cpu_map *cpus = evlist->cpus;
+	const struct thread_map *threads = evlist->threads;
 	int thread, prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
 
-	if (evlist->mmap == NULL &&
-	    perf_evlist__alloc_mmap(evlist, cpus->nr) < 0)
+	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
 
-	if (evlist->pollfd == NULL &&
-	    perf_evlist__alloc_pollfd(evlist, cpus->nr, threads->nr) < 0)
+	if (evlist->pollfd == NULL && perf_evlist__alloc_pollfd(evlist) < 0)
 		return -ENOMEM;
 
 	evlist->overwrite = overwrite;
@@ -315,3 +317,34 @@ out_unmap:
 	}
 	return -1;
 }
+
+int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
+			     pid_t target_tid, const char *cpu_list)
+{
+	evlist->threads = thread_map__new(target_pid, target_tid);
+
+	if (evlist->threads == NULL)
+		return -1;
+
+	if (target_tid != -1)
+		evlist->cpus = cpu_map__dummy_new();
+	else
+		evlist->cpus = cpu_map__new(cpu_list);
+
+	if (evlist->cpus == NULL)
+		goto out_delete_threads;
+
+	return 0;
+
+out_delete_threads:
+	thread_map__delete(evlist->threads);
+	return -1;
+}
+
+void perf_evlist__delete_maps(struct perf_evlist *evlist)
+{
+	cpu_map__delete(evlist->cpus);
+	thread_map__delete(evlist->threads);
+	evlist->cpus	= NULL;
+	evlist->threads = NULL;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 85aca6e..c988405 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -22,28 +22,43 @@ struct perf_evlist {
 	union perf_event event_copy;
 	struct perf_mmap *mmap;
 	struct pollfd	 *pollfd;
+	struct thread_map *threads;
+	struct cpu_map	  *cpus;
 };
 
 struct perf_evsel;
 
-struct perf_evlist *perf_evlist__new(void);
-void perf_evlist__init(struct perf_evlist *evlist);
+struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
+				     struct thread_map *threads);
+void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
+		       struct thread_map *threads);
 void perf_evlist__exit(struct perf_evlist *evlist);
 void perf_evlist__delete(struct perf_evlist *evlist);
 
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 
-int perf_evlist__alloc_pollfd(struct perf_evlist *evlist, int ncpus, int nthreads);
+int perf_evlist__alloc_pollfd(struct perf_evlist *evlist);
 void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 union perf_event *perf_evlist__read_on_cpu(struct perf_evlist *self, int cpu);
 
-int perf_evlist__alloc_mmap(struct perf_evlist *evlist, int ncpus);
-int perf_evlist__mmap(struct perf_evlist *evlist, struct cpu_map *cpus,
-		      struct thread_map *threads, int pages, bool overwrite);
-void perf_evlist__munmap(struct perf_evlist *evlist, int ncpus);
+int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
+int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite);
+void perf_evlist__munmap(struct perf_evlist *evlist);
+
+static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
+					 struct cpu_map *cpus,
+					 struct thread_map *threads)
+{
+	evlist->cpus	= cpus;
+	evlist->threads	= threads;
+}
+
+int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
+			     pid_t target_tid, const char *cpu_list);
+void perf_evlist__delete_maps(struct perf_evlist *evlist);
 
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 88d4789..d2d5217 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -553,7 +553,16 @@ struct pyrf_evlist {
 static int pyrf_evlist__init(struct pyrf_evlist *pevlist,
 			     PyObject *args, PyObject *kwargs)
 {
-	perf_evlist__init(&pevlist->evlist);
+	PyObject *pcpus = NULL, *pthreads = NULL;
+	struct cpu_map *cpus;
+	struct thread_map *threads;
+
+	if (!PyArg_ParseTuple(args, "OO", &pcpus, &pthreads))
+		return -1;
+
+	threads = ((struct pyrf_thread_map *)pthreads)->threads;
+	cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
+	perf_evlist__init(&pevlist->evlist, cpus, threads);
 	return 0;
 }
 
@@ -567,21 +576,15 @@ static PyObject *pyrf_evlist__mmap(struct pyrf_evlist *pevlist,
 				   PyObject *args, PyObject *kwargs)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
-	PyObject *pcpus = NULL, *pthreads = NULL;
-	struct cpu_map *cpus = NULL;
-	struct thread_map *threads = NULL;
-	static char *kwlist[] = {"cpus", "threads", "pages", "overwrite",
+	static char *kwlist[] = {"pages", "overwrite",
 				  NULL, NULL};
 	int pages = 128, overwrite = false;
 
-	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "OO|ii", kwlist,
-					 &pcpus, &pthreads, &pages, &overwrite))
+	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|ii", kwlist,
+					 &pages, &overwrite))
 		return NULL;
 
-	threads = ((struct pyrf_thread_map *)pthreads)->threads;
-	cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
-
-	if (perf_evlist__mmap(evlist, cpus, threads, pages, overwrite) < 0) {
+	if (perf_evlist__mmap(evlist, pages, overwrite) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
-- 
1.6.2.5

