Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab1ADIZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:25:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:59184 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1ADIZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:25:22 -0500
Date: Tue, 4 Jan 2011 08:24:48 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Refactor all_tids to hold nr and the map
Message-ID: <tip-5c98d466e49267a9221f30958d45cd06f794269a@git.kernel.org>
Git-Commit-ID: 5c98d466e49267a9221f30958d45cd06f794269a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:24:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c98d466e49267a9221f30958d45cd06f794269a
Gitweb:     http://git.kernel.org/tip/5c98d466e49267a9221f30958d45cd06f794269a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 3 Jan 2011 17:53:33 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 4 Jan 2011 00:24:16 -0200

perf tools: Refactor all_tids to hold nr and the map

So that later, we can pass the thread_map instance instead of
(thread_num, thread_map) for things like perf_evsel__open and friends,
just like was done with cpu_map.

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
 tools/perf/builtin-record.c |   39 +++++++++++++++------------------------
 tools/perf/builtin-stat.c   |   41 +++++++++++++++++------------------------
 tools/perf/builtin-top.c    |   35 +++++++++++++----------------------
 tools/perf/util/thread.c    |   43 +++++++++++++++++++++++++++++--------------
 tools/perf/util/thread.h    |   15 ++++++++++++++-
 5 files changed, 88 insertions(+), 85 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 220e6e7..7bc0490 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -54,8 +54,7 @@ static bool			sample_id_all_avail		=   true;
 static bool			system_wide			=  false;
 static pid_t			target_pid			=     -1;
 static pid_t			target_tid			=     -1;
-static pid_t			*all_tids			=      NULL;
-static int			thread_num			=      0;
+static struct thread_map	*threads;
 static pid_t			child_pid			=     -1;
 static bool			no_inherit			=  false;
 static enum write_mode_t	write_mode			= WRITE_FORCE;
@@ -318,9 +317,9 @@ static void create_counter(struct perf_evsel *evsel, int cpu)
 retry_sample_id:
 	attr->sample_id_all = sample_id_all_avail ? 1 : 0;
 
-	for (thread_index = 0; thread_index < thread_num; thread_index++) {
+	for (thread_index = 0; thread_index < threads->nr; thread_index++) {
 try_again:
-		FD(evsel, nr_cpu, thread_index) = sys_perf_event_open(attr, all_tids[thread_index], cpu, group_fd, 0);
+		FD(evsel, nr_cpu, thread_index) = sys_perf_event_open(attr, threads->map[thread_index], cpu, group_fd, 0);
 
 		if (FD(evsel, nr_cpu, thread_index) < 0) {
 			int err = errno;
@@ -653,7 +652,7 @@ static int __cmd_record(int argc, const char **argv)
 		}
 
 		if (!system_wide && target_tid == -1 && target_pid == -1)
-			all_tids[0] = child_pid;
+			threads->map[0] = child_pid;
 
 		close(child_ready_pipe[1]);
 		close(go_pipe[0]);
@@ -793,7 +792,7 @@ static int __cmd_record(int argc, const char **argv)
 
 				list_for_each_entry(pos, &evsel_list, node) {
 					for (thread = 0;
-						thread < thread_num;
+						thread < threads->nr;
 						thread++)
 						ioctl(FD(pos, i, thread),
 							PERF_EVENT_IOC_DISABLE);
@@ -910,21 +909,13 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
-	if (target_pid != -1) {
+	if (target_pid != -1)
 		target_tid = target_pid;
-		thread_num = find_all_tid(target_pid, &all_tids);
-		if (thread_num <= 0) {
-			fprintf(stderr, "Can't find all threads of pid %d\n",
-					target_pid);
-			usage_with_options(record_usage, record_options);
-		}
-	} else {
-		all_tids=malloc(sizeof(pid_t));
-		if (!all_tids)
-			goto out_symbol_exit;
 
-		all_tids[0] = target_tid;
-		thread_num = 1;
+	threads = thread_map__new(target_pid, target_tid);
+	if (threads == NULL) {
+		pr_err("Problems finding threads of monitor\n");
+		usage_with_options(record_usage, record_options);
 	}
 
 	cpus = cpu_map__new(cpu_list);
@@ -934,11 +925,11 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	}
 
 	list_for_each_entry(pos, &evsel_list, node) {
-		if (perf_evsel__alloc_fd(pos, cpus->nr, thread_num) < 0)
+		if (perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
 			goto out_free_fd;
 	}
-	event_array = malloc(
-		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
+	event_array = malloc((sizeof(struct pollfd) * MAX_NR_CPUS *
+			      MAX_COUNTERS * threads->nr));
 	if (!event_array)
 		goto out_free_fd;
 
@@ -965,8 +956,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 out_free_event_array:
 	free(event_array);
 out_free_fd:
-	free(all_tids);
-	all_tids = NULL;
+	thread_map__delete(threads);
+	threads = NULL;
 out_symbol_exit:
 	symbol__exit();
 	return err;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3f4a431..6b9146c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -81,8 +81,7 @@ static bool			scale				=  true;
 static bool			no_aggr				= false;
 static pid_t			target_pid			= -1;
 static pid_t			target_tid			= -1;
-static pid_t			*all_tids			=  NULL;
-static int			thread_num			=  0;
+static struct thread_map	*threads;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static bool			big_num				=  true;
@@ -175,7 +174,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, thread_num, all_tids);
+	return perf_evsel__open_per_thread(evsel, threads->nr, threads->map);
 }
 
 /*
@@ -200,7 +199,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	u64 *count = counter->counts->aggr.values;
 	int i;
 
-	if (__perf_evsel__read(counter, cpus->nr, thread_num, scale) < 0)
+	if (__perf_evsel__read(counter, cpus->nr, threads->nr, scale) < 0)
 		return -1;
 
 	for (i = 0; i < 3; i++)
@@ -298,7 +297,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 		}
 
 		if (target_tid == -1 && target_pid == -1 && !system_wide)
-			all_tids[0] = child_pid;
+			threads->map[0] = child_pid;
 
 		/*
 		 * Wait for the child to be ready to exec.
@@ -353,7 +352,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 	} else {
 		list_for_each_entry(counter, &evsel_list, node) {
 			read_counter_aggr(counter);
-			perf_evsel__close_fd(counter, cpus->nr, thread_num);
+			perf_evsel__close_fd(counter, cpus->nr, threads->nr);
 		}
 	}
 
@@ -693,6 +692,15 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		}
 	}
 
+	if (target_pid != -1)
+		target_tid = target_pid;
+
+	threads = thread_map__new(target_pid, target_tid);
+	if (threads == NULL) {
+		pr_err("Problems finding threads of monitor\n");
+		usage_with_options(stat_usage, options);
+	}
+
 	if (system_wide)
 		cpus = cpu_map__new(cpu_list);
 	else
@@ -704,27 +712,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		return -1;
 	}
 
-	if (target_pid != -1) {
-		target_tid = target_pid;
-		thread_num = find_all_tid(target_pid, &all_tids);
-		if (thread_num <= 0) {
-			fprintf(stderr, "Can't find all threads of pid %d\n",
-					target_pid);
-			usage_with_options(stat_usage, options);
-		}
-	} else {
-		all_tids=malloc(sizeof(pid_t));
-		if (!all_tids)
-			return -ENOMEM;
-
-		all_tids[0] = target_tid;
-		thread_num = 1;
-	}
-
 	list_for_each_entry(pos, &evsel_list, node) {
 		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
 		    perf_evsel__alloc_counts(pos, cpus->nr) < 0 ||
-		    perf_evsel__alloc_fd(pos, cpus->nr, thread_num) < 0)
+		    perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
 			goto out_free_fd;
 	}
 
@@ -752,5 +743,7 @@ out_free_fd:
 	list_for_each_entry(pos, &evsel_list, node)
 		perf_evsel__free_stat_priv(pos);
 out:
+	thread_map__delete(threads);
+	threads = NULL;
 	return status;
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0e42666..1e67ab9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -68,8 +68,7 @@ static int			print_entries;
 
 static int			target_pid			=     -1;
 static int			target_tid			=     -1;
-static pid_t			*all_tids			=      NULL;
-static int			thread_num			=      0;
+static struct thread_map	*threads;
 static bool			inherit				=  false;
 static struct cpu_map		*cpus;
 static int			realtime_prio			=      0;
@@ -1200,7 +1199,7 @@ static void perf_session__mmap_read(struct perf_session *self)
 	for (i = 0; i < cpus->nr; i++) {
 		list_for_each_entry(counter, &evsel_list, node) {
 			for (thread_index = 0;
-				thread_index < thread_num;
+				thread_index < threads->nr;
 				thread_index++) {
 				perf_session__mmap_read_counter(self,
 					counter, i, thread_index);
@@ -1236,10 +1235,10 @@ static void start_counter(int i, struct perf_evsel *evsel)
 	attr->inherit		= (cpu < 0) && inherit;
 	attr->mmap		= 1;
 
-	for (thread_index = 0; thread_index < thread_num; thread_index++) {
+	for (thread_index = 0; thread_index < threads->nr; thread_index++) {
 try_again:
 		FD(evsel, i, thread_index) = sys_perf_event_open(attr,
-				all_tids[thread_index], cpu, group_fd, 0);
+				threads->map[thread_index], cpu, group_fd, 0);
 
 		if (FD(evsel, i, thread_index) < 0) {
 			int err = errno;
@@ -1410,25 +1409,17 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (argc)
 		usage_with_options(top_usage, options);
 
-	if (target_pid != -1) {
+	if (target_pid != -1)
 		target_tid = target_pid;
-		thread_num = find_all_tid(target_pid, &all_tids);
-		if (thread_num <= 0) {
-			fprintf(stderr, "Can't find all threads of pid %d\n",
-				target_pid);
-			usage_with_options(top_usage, options);
-		}
-	} else {
-		all_tids=malloc(sizeof(pid_t));
-		if (!all_tids)
-			return -ENOMEM;
 
-		all_tids[0] = target_tid;
-		thread_num = 1;
+	threads = thread_map__new(target_pid, target_tid);
+	if (threads == NULL) {
+		pr_err("Problems finding threads of monitor\n");
+		usage_with_options(top_usage, options);
 	}
 
-	event_array = malloc(
-		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
+	event_array = malloc((sizeof(struct pollfd) *
+			      MAX_NR_CPUS * MAX_COUNTERS * threads->nr));
 	if (!event_array)
 		return -ENOMEM;
 
@@ -1468,8 +1459,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(top_usage, options);
 
 	list_for_each_entry(pos, &evsel_list, node) {
-		if (perf_evsel__alloc_mmap_per_thread(pos, cpus->nr, thread_num) < 0 ||
-		    perf_evsel__alloc_fd(pos, cpus->nr, thread_num) < 0)
+		if (perf_evsel__alloc_mmap_per_thread(pos, cpus->nr, threads->nr) < 0 ||
+		    perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
 			goto out_free_fd;
 		/*
 		 * Fill in the ones not specifically initialized via -c:
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 8c72d88..00f4ead 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -16,35 +16,50 @@ static int filter(const struct dirent *dir)
 		return 1;
 }
 
-int find_all_tid(int pid, pid_t ** all_tid)
+struct thread_map *thread_map__new_by_pid(pid_t pid)
 {
+	struct thread_map *threads;
 	char name[256];
 	int items;
 	struct dirent **namelist = NULL;
-	int ret = 0;
 	int i;
 
 	sprintf(name, "/proc/%d/task", pid);
 	items = scandir(name, &namelist, filter, NULL);
 	if (items <= 0)
-                return -ENOENT;
-	*all_tid = malloc(sizeof(pid_t) * items);
-	if (!*all_tid) {
-		ret = -ENOMEM;
-		goto failure;
-	}
-
-	for (i = 0; i < items; i++)
-		(*all_tid)[i] = atoi(namelist[i]->d_name);
+                return NULL;
 
-	ret = items;
+	threads = malloc(sizeof(*threads) + sizeof(pid_t) * items);
+	if (threads != NULL) {
+		for (i = 0; i < items; i++)
+			threads->map[i] = atoi(namelist[i]->d_name);
+		threads->nr = items;
+	}
 
-failure:
 	for (i=0; i<items; i++)
 		free(namelist[i]);
 	free(namelist);
 
-	return ret;
+	return threads;
+}
+
+struct thread_map *thread_map__new_by_tid(pid_t tid)
+{
+	struct thread_map *threads = malloc(sizeof(*threads) + sizeof(pid_t));
+
+	if (threads != NULL) {
+		threads->map[0] = tid;
+		threads->nr	= 1;
+	}
+
+	return threads;
+}
+
+struct thread_map *thread_map__new(pid_t pid, pid_t tid)
+{
+	if (pid != -1)
+		return thread_map__new_by_pid(pid);
+	return thread_map__new_by_tid(tid);
 }
 
 static struct thread *thread__new(pid_t pid)
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 688500f..d757410 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -18,11 +18,24 @@ struct thread {
 	int			comm_len;
 };
 
+struct thread_map {
+	int nr;
+	int map[];
+};
+
 struct perf_session;
 
 void thread__delete(struct thread *self);
 
-int find_all_tid(int pid, pid_t ** all_tid);
+struct thread_map *thread_map__new_by_pid(pid_t pid);
+struct thread_map *thread_map__new_by_tid(pid_t tid);
+struct thread_map *thread_map__new(pid_t pid, pid_t tid);
+
+static inline void thread_map__delete(struct thread_map *threads)
+{
+	free(threads);
+}
+
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
 struct thread *perf_session__findnew(struct perf_session *self, pid_t pid);
