Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1ADIZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:25:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:59171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab1ADIZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:25:04 -0500
Date: Tue, 4 Jan 2011 08:24:20 GMT
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
Subject: [tip:perf/core] perf tools: Refactor cpumap to hold nr and the map
Message-ID: <tip-60d567e2d9187379d642f6aba7c8a52b3fd5d261@git.kernel.org>
Git-Commit-ID: 60d567e2d9187379d642f6aba7c8a52b3fd5d261
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:24:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60d567e2d9187379d642f6aba7c8a52b3fd5d261
Gitweb:     http://git.kernel.org/tip/60d567e2d9187379d642f6aba7c8a52b3fd5d261
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 3 Jan 2011 17:49:48 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 4 Jan 2011 00:23:55 -0200

perf tools: Refactor cpumap to hold nr and the map

So that later, we can pass the cpu_map instance instead of (nr_cpus, cpu_map)
for things like perf_evsel__open and friends.

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
 tools/perf/builtin-record.c |   14 +++---
 tools/perf/builtin-stat.c   |   36 ++++++------
 tools/perf/builtin-top.c    |   22 ++++----
 tools/perf/util/cpumap.c    |  123 +++++++++++++++++++++++++++++++++----------
 tools/perf/util/cpumap.h    |   10 +++-
 5 files changed, 138 insertions(+), 67 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 052de17..220e6e7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -39,7 +39,7 @@ static u64			user_interval			= ULLONG_MAX;
 static u64			default_interval		=      0;
 static u64			sample_type;
 
-static int			nr_cpus				=      0;
+static struct cpu_map		*cpus;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			=    128;
 static unsigned int		user_freq 			= UINT_MAX;
@@ -670,8 +670,8 @@ static int __cmd_record(int argc, const char **argv)
 	if (!system_wide && no_inherit && !cpu_list) {
 		open_counters(-1);
 	} else {
-		for (i = 0; i < nr_cpus; i++)
-			open_counters(cpumap[i]);
+		for (i = 0; i < cpus->nr; i++)
+			open_counters(cpus->map[i]);
 	}
 
 	perf_session__set_sample_type(session, sample_type);
@@ -927,14 +927,14 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		thread_num = 1;
 	}
 
-	nr_cpus = read_cpu_map(cpu_list);
-	if (nr_cpus < 1) {
-		perror("failed to collect number of CPUs");
+	cpus = cpu_map__new(cpu_list);
+	if (cpus == NULL) {
+		perror("failed to parse CPUs map");
 		return -1;
 	}
 
 	list_for_each_entry(pos, &evsel_list, node) {
-		if (perf_evsel__alloc_fd(pos, nr_cpus, thread_num) < 0)
+		if (perf_evsel__alloc_fd(pos, cpus->nr, thread_num) < 0)
 			goto out_free_fd;
 	}
 	event_array = malloc(
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 065e79e..3f4a431 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -72,7 +72,7 @@ static struct perf_event_attr default_attrs[] = {
 };
 
 static bool			system_wide			=  false;
-static int			nr_cpus				=  0;
+static struct cpu_map		*cpus;
 static int			run_idx				=  0;
 
 static int			run_count			=  1;
@@ -167,7 +167,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, nr_cpus, cpumap);
+		return perf_evsel__open_per_cpu(evsel, cpus->nr, cpus->map);
 
 	attr->inherit = !no_inherit;
 	if (target_pid == -1 && target_tid == -1) {
@@ -200,7 +200,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	u64 *count = counter->counts->aggr.values;
 	int i;
 
-	if (__perf_evsel__read(counter, nr_cpus, thread_num, scale) < 0)
+	if (__perf_evsel__read(counter, cpus->nr, thread_num, scale) < 0)
 		return -1;
 
 	for (i = 0; i < 3; i++)
@@ -233,7 +233,7 @@ static int read_counter(struct perf_evsel *counter)
 	u64 *count;
 	int cpu;
 
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
+	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		if (__perf_evsel__read_on_cpu(counter, cpu, 0, scale) < 0)
 			return -1;
 
@@ -259,9 +259,6 @@ static int run_perf_stat(int argc __used, const char **argv)
 	const bool forks = (argc > 0);
 	char buf;
 
-	if (!system_wide)
-		nr_cpus = 1;
-
 	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
 		exit(1);
@@ -351,12 +348,12 @@ static int run_perf_stat(int argc __used, const char **argv)
 	if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list, node) {
 			read_counter(counter);
-			perf_evsel__close_fd(counter, nr_cpus, 1);
+			perf_evsel__close_fd(counter, cpus->nr, 1);
 		}
 	} else {
 		list_for_each_entry(counter, &evsel_list, node) {
 			read_counter_aggr(counter);
-			perf_evsel__close_fd(counter, nr_cpus, thread_num);
+			perf_evsel__close_fd(counter, cpus->nr, thread_num);
 		}
 	}
 
@@ -384,7 +381,7 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
-			cpumap[cpu], csv_sep);
+			cpus->map[cpu], csv_sep);
 
 	fprintf(stderr, fmt, cpustr, msecs, csv_sep, event_name(evsel));
 
@@ -412,7 +409,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
-			cpumap[cpu], csv_sep);
+			cpus->map[cpu], csv_sep);
 	else
 		cpu = 0;
 
@@ -498,14 +495,14 @@ static void print_counter(struct perf_evsel *counter)
 	u64 ena, run, val;
 	int cpu;
 
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
+	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		val = counter->counts->cpu[cpu].val;
 		ena = counter->counts->cpu[cpu].ena;
 		run = counter->counts->cpu[cpu].run;
 		if (run == 0 || ena == 0) {
 			fprintf(stderr, "CPU%*d%s%*s%s%-24s",
 				csv_output ? 0 : -4,
-				cpumap[cpu], csv_sep,
+				cpus->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
 				"<not counted>", csv_sep,
 				event_name(counter));
@@ -697,12 +694,15 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (system_wide)
-		nr_cpus = read_cpu_map(cpu_list);
+		cpus = cpu_map__new(cpu_list);
 	else
-		nr_cpus = 1;
+		cpus = cpu_map__dummy_new();
 
-	if (nr_cpus < 1)
+	if (cpus == NULL) {
+		perror("failed to parse CPUs map");
 		usage_with_options(stat_usage, options);
+		return -1;
+	}
 
 	if (target_pid != -1) {
 		target_tid = target_pid;
@@ -723,8 +723,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	list_for_each_entry(pos, &evsel_list, node) {
 		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
-		    perf_evsel__alloc_counts(pos, nr_cpus) < 0 ||
-		    perf_evsel__alloc_fd(pos, nr_cpus, thread_num) < 0)
+		    perf_evsel__alloc_counts(pos, cpus->nr) < 0 ||
+		    perf_evsel__alloc_fd(pos, cpus->nr, thread_num) < 0)
 			goto out_free_fd;
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 27b9c14..0e42666 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -71,7 +71,7 @@ static int			target_tid			=     -1;
 static pid_t			*all_tids			=      NULL;
 static int			thread_num			=      0;
 static bool			inherit				=  false;
-static int			nr_cpus				=      0;
+static struct cpu_map		*cpus;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
 static unsigned int		page_size;
@@ -564,12 +564,12 @@ static void print_sym_table(void)
 		printf(" (all");
 
 	if (cpu_list)
-		printf(", CPU%s: %s)\n", nr_cpus > 1 ? "s" : "", cpu_list);
+		printf(", CPU%s: %s)\n", cpus->nr > 1 ? "s" : "", cpu_list);
 	else {
 		if (target_tid != -1)
 			printf(")\n");
 		else
-			printf(", %d CPU%s)\n", nr_cpus, nr_cpus > 1 ? "s" : "");
+			printf(", %d CPU%s)\n", cpus->nr, cpus->nr > 1 ? "s" : "");
 	}
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
@@ -1197,7 +1197,7 @@ static void perf_session__mmap_read(struct perf_session *self)
 	struct perf_evsel *counter;
 	int i, thread_index;
 
-	for (i = 0; i < nr_cpus; i++) {
+	for (i = 0; i < cpus->nr; i++) {
 		list_for_each_entry(counter, &evsel_list, node) {
 			for (thread_index = 0;
 				thread_index < thread_num;
@@ -1221,7 +1221,7 @@ static void start_counter(int i, struct perf_evsel *evsel)
 	int thread_index;
 
 	if (target_tid == -1)
-		cpu = cpumap[i];
+		cpu = cpus->map[i];
 
 	attr = &evsel->attr;
 
@@ -1310,7 +1310,7 @@ static int __cmd_top(void)
 	else
 		event__synthesize_threads(event__process, session);
 
-	for (i = 0; i < nr_cpus; i++) {
+	for (i = 0; i < cpus->nr; i++) {
 		group_fd = -1;
 		list_for_each_entry(counter, &evsel_list, node)
 			start_counter(i, counter);
@@ -1460,16 +1460,16 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (target_tid != -1)
-		nr_cpus = 1;
+		cpus = cpu_map__dummy_new();
 	else
-		nr_cpus = read_cpu_map(cpu_list);
+		cpus = cpu_map__new(cpu_list);
 
-	if (nr_cpus < 1)
+	if (cpus == NULL)
 		usage_with_options(top_usage, options);
 
 	list_for_each_entry(pos, &evsel_list, node) {
-		if (perf_evsel__alloc_mmap_per_thread(pos, nr_cpus, thread_num) < 0 ||
-		    perf_evsel__alloc_fd(pos, nr_cpus, thread_num) < 0)
+		if (perf_evsel__alloc_mmap_per_thread(pos, cpus->nr, thread_num) < 0 ||
+		    perf_evsel__alloc_fd(pos, cpus->nr, thread_num) < 0)
 			goto out_free_fd;
 		/*
 		 * Fill in the ones not specifically initialized via -c:
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 0f9b8d7..3ccaa10 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -4,32 +4,53 @@
 #include <assert.h>
 #include <stdio.h>
 
-int cpumap[MAX_NR_CPUS];
-
-static int default_cpu_map(void)
+static struct cpu_map *cpu_map__default_new(void)
 {
-	int nr_cpus, i;
+	struct cpu_map *cpus;
+	int nr_cpus;
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
-	assert(nr_cpus <= MAX_NR_CPUS);
-	assert((int)nr_cpus >= 0);
+	if (nr_cpus < 0)
+		return NULL;
+
+	cpus = malloc(sizeof(*cpus) + nr_cpus * sizeof(int));
+	if (cpus != NULL) {
+		int i;
+		for (i = 0; i < nr_cpus; ++i)
+			cpus->map[i] = i;
 
-	for (i = 0; i < nr_cpus; ++i)
-		cpumap[i] = i;
+		cpus->nr = nr_cpus;
+	}
 
-	return nr_cpus;
+	return cpus;
 }
 
-static int read_all_cpu_map(void)
+static struct cpu_map *cpu_map__trim_new(int nr_cpus, int *tmp_cpus)
 {
+	size_t payload_size = nr_cpus * sizeof(int);
+	struct cpu_map *cpus = malloc(sizeof(*cpus) + payload_size);
+
+	if (cpus != NULL) {
+		cpus->nr = nr_cpus;
+		memcpy(cpus->map, tmp_cpus, payload_size);
+	}
+
+	return cpus;
+}
+
+static struct cpu_map *cpu_map__read_all_cpu_map(void)
+{
+	struct cpu_map *cpus = NULL;
 	FILE *onlnf;
 	int nr_cpus = 0;
+	int *tmp_cpus = NULL, *tmp;
+	int max_entries = 0;
 	int n, cpu, prev;
 	char sep;
 
 	onlnf = fopen("/sys/devices/system/cpu/online", "r");
 	if (!onlnf)
-		return default_cpu_map();
+		return cpu_map__default_new();
 
 	sep = 0;
 	prev = -1;
@@ -38,12 +59,28 @@ static int read_all_cpu_map(void)
 		if (n <= 0)
 			break;
 		if (prev >= 0) {
-			assert(nr_cpus + cpu - prev - 1 < MAX_NR_CPUS);
+			int new_max = nr_cpus + cpu - prev - 1;
+
+			if (new_max >= max_entries) {
+				max_entries = new_max + MAX_NR_CPUS / 2;
+				tmp = realloc(tmp_cpus, max_entries * sizeof(int));
+				if (tmp == NULL)
+					goto out_free_tmp;
+				tmp_cpus = tmp;
+			}
+
 			while (++prev < cpu)
-				cpumap[nr_cpus++] = prev;
+				tmp_cpus[nr_cpus++] = prev;
+		}
+		if (nr_cpus == max_entries) {
+			max_entries += MAX_NR_CPUS;
+			tmp = realloc(tmp_cpus, max_entries * sizeof(int));
+			if (tmp == NULL)
+				goto out_free_tmp;
+			tmp_cpus = tmp;
 		}
-		assert (nr_cpus < MAX_NR_CPUS);
-		cpumap[nr_cpus++] = cpu;
+
+		tmp_cpus[nr_cpus++] = cpu;
 		if (n == 2 && sep == '-')
 			prev = cpu;
 		else
@@ -51,24 +88,31 @@ static int read_all_cpu_map(void)
 		if (n == 1 || sep == '\n')
 			break;
 	}
-	fclose(onlnf);
-	if (nr_cpus > 0)
-		return nr_cpus;
 
-	return default_cpu_map();
+	if (nr_cpus > 0)
+		cpus = cpu_map__trim_new(nr_cpus, tmp_cpus);
+	else
+		cpus = cpu_map__default_new();
+out_free_tmp:
+	free(tmp_cpus);
+	fclose(onlnf);
+	return cpus;
 }
 
-int read_cpu_map(const char *cpu_list)
+struct cpu_map *cpu_map__new(const char *cpu_list)
 {
+	struct cpu_map *cpus = NULL;
 	unsigned long start_cpu, end_cpu = 0;
 	char *p = NULL;
 	int i, nr_cpus = 0;
+	int *tmp_cpus = NULL, *tmp;
+	int max_entries = 0;
 
 	if (!cpu_list)
-		return read_all_cpu_map();
+		return cpu_map__read_all_cpu_map();
 
 	if (!isdigit(*cpu_list))
-		goto invalid;
+		goto out;
 
 	while (isdigit(*cpu_list)) {
 		p = NULL;
@@ -94,21 +138,42 @@ int read_cpu_map(const char *cpu_list)
 		for (; start_cpu <= end_cpu; start_cpu++) {
 			/* check for duplicates */
 			for (i = 0; i < nr_cpus; i++)
-				if (cpumap[i] == (int)start_cpu)
+				if (tmp_cpus[i] == (int)start_cpu)
 					goto invalid;
 
-			assert(nr_cpus < MAX_NR_CPUS);
-			cpumap[nr_cpus++] = (int)start_cpu;
+			if (nr_cpus == max_entries) {
+				max_entries += MAX_NR_CPUS;
+				tmp = realloc(tmp_cpus, max_entries * sizeof(int));
+				if (tmp == NULL)
+					goto invalid;
+				tmp_cpus = tmp;
+			}
+			tmp_cpus[nr_cpus++] = (int)start_cpu;
 		}
 		if (*p)
 			++p;
 
 		cpu_list = p;
 	}
-	if (nr_cpus > 0)
-		return nr_cpus;
 
-	return default_cpu_map();
+	if (nr_cpus > 0)
+		cpus = cpu_map__trim_new(nr_cpus, tmp_cpus);
+	else
+		cpus = cpu_map__default_new();
 invalid:
-	return -1;
+	free(tmp_cpus);
+out:
+	return cpus;
+}
+
+struct cpu_map *cpu_map__dummy_new(void)
+{
+	struct cpu_map *cpus = malloc(sizeof(*cpus) + sizeof(int));
+
+	if (cpus != NULL) {
+		cpus->nr = 1;
+		cpus->map[0] = -1;
+	}
+
+	return cpus;
 }
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 3e60f56..f7a4f42 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -1,7 +1,13 @@
 #ifndef __PERF_CPUMAP_H
 #define __PERF_CPUMAP_H
 
-extern int read_cpu_map(const char *cpu_list);
-extern int cpumap[];
+struct cpu_map {
+	int nr;
+	int map[];
+};
+
+struct cpu_map *cpu_map__new(const char *cpu_list);
+struct cpu_map *cpu_map__dummy_new(void);
+void *cpu_map__delete(struct cpu_map *map);
 
 #endif /* __PERF_CPUMAP_H */
