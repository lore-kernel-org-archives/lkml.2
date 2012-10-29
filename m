Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab2J2Qcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:32:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38683 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab2J2Qcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:32:51 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 6/9] perf stat: move user options to perf_record_opts
Date: Mon, 29 Oct 2012 10:31:46 -0600
Message-Id: <1351528309-87705-7-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
References: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for perf-stat to use perf_evlist__open_counters.
And move opts to a stack variable.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-stat.c |  167 +++++++++++++++++++++++++++------------------
 1 file changed, 101 insertions(+), 66 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 6888960..e12002b 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -67,12 +67,8 @@
 
 static struct perf_evlist	*evsel_list;
 
-static struct perf_target	target = {
-	.uid	= UINT_MAX,
-};
 
 static int			run_count			=  1;
-static bool			no_inherit			= false;
 static bool			scale				=  true;
 static bool			no_aggr				= false;
 static pid_t			child_pid			= -1;
@@ -82,7 +78,6 @@ static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
-static bool			group				= false;
 static FILE			*output				= NULL;
 static const char		*pre_cmd			= NULL;
 static const char		*post_cmd			= NULL;
@@ -106,14 +101,16 @@ static void perf_evsel__free_stat_priv(struct perf_evsel *evsel)
 	evsel->priv = NULL;
 }
 
-static inline struct cpu_map *perf_evsel__cpus(struct perf_evsel *evsel)
+static inline struct cpu_map *perf_evsel__cpus(struct perf_evsel *evsel,
+					       struct perf_target *target)
 {
-	return (evsel->cpus && !target.cpu_list) ? evsel->cpus : evsel_list->cpus;
+	return (evsel->cpus && !target->cpu_list) ? evsel->cpus : evsel_list->cpus;
 }
 
-static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel)
+static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel,
+				      struct perf_target *target)
 {
-	return perf_evsel__cpus(evsel)->nr;
+	return perf_evsel__cpus(evsel, target)->nr;
 }
 
 static struct stats runtime_nsecs_stats[MAX_NR_CPUS];
@@ -130,8 +127,10 @@ static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
 static struct stats walltime_nsecs_stats;
 
 static int create_perf_stat_counter(struct perf_evsel *evsel,
-				    struct perf_evsel *first)
+				    struct perf_evsel *first,
+				    struct perf_record_opts *opts)
 {
+	struct perf_target *target = &opts->target;
 	struct perf_event_attr *attr = &evsel->attr;
 	bool exclude_guest_missing = false;
 	int ret;
@@ -140,20 +139,22 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
-	attr->inherit = !no_inherit;
+	attr->inherit = !opts->no_inherit;
 
 retry:
 	if (exclude_guest_missing)
 		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
 
-	if (perf_target__has_cpu(&target)) {
-		ret = perf_evsel__open_per_cpu(evsel, perf_evsel__cpus(evsel));
+	if (perf_target__has_cpu(target)) {
+		ret = perf_evsel__open_per_cpu(evsel,
+					       perf_evsel__cpus(evsel, target));
 		if (ret)
 			goto check_ret;
 		return 0;
 	}
 
-	if (!perf_target__has_task(&target) && (!group || evsel == first)) {
+	if (!perf_target__has_task(target) &&
+	    (!opts->group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
@@ -222,13 +223,15 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
  * Read out the results of a single counter:
  * aggregate counts across CPUs in system-wide mode
  */
-static int read_counter_aggr(struct perf_evsel *counter)
+static int read_counter_aggr(struct perf_evsel *counter,
+			     struct perf_record_opts *opts)
 {
+	struct perf_target *target = &opts->target;
 	struct perf_stat *ps = counter->priv;
 	u64 *count = counter->counts->aggr.values;
 	int i;
 
-	if (__perf_evsel__read(counter, perf_evsel__nr_cpus(counter),
+	if (__perf_evsel__read(counter, perf_evsel__nr_cpus(counter, target),
 			       evsel_list->threads->nr, scale) < 0)
 		return -1;
 
@@ -252,12 +255,14 @@ static int read_counter_aggr(struct perf_evsel *counter)
  * Read out the results of a single counter:
  * do not aggregate counts across CPUs in system-wide mode
  */
-static int read_counter(struct perf_evsel *counter)
+static int read_counter(struct perf_evsel *counter,
+			struct perf_record_opts *opts)
 {
+	struct cpu_map *cmap = perf_evsel__cpus(counter, &opts->target);
 	u64 *count;
 	int cpu;
 
-	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
+	for (cpu = 0; cpu < cmap->nr; cpu++) {
 		if (__perf_evsel__read_on_cpu(counter, cpu, 0, scale) < 0)
 			return -1;
 
@@ -269,10 +274,13 @@ static int read_counter(struct perf_evsel *counter)
 	return 0;
 }
 
-static int __run_perf_stat(int argc __maybe_unused, const char **argv)
+static int __run_perf_stat(int argc __maybe_unused,
+			   const char **argv,
+			   struct perf_record_opts *opts)
 {
 	unsigned long long t0, t1;
 	struct perf_evsel *counter, *first;
+	struct cpu_map *cmap;
 	int status = 0;
 	int child_ready_pipe[2], go_pipe[2];
 	const bool forks = (argc > 0);
@@ -316,7 +324,7 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 			exit(-1);
 		}
 
-		if (perf_target__none(&target))
+		if (perf_target__none(&opts->target))
 			evsel_list->threads->map[0] = child_pid;
 
 		/*
@@ -329,13 +337,13 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
-	if (group)
+	if (opts->group)
 		perf_evlist__set_leader(evsel_list);
 
 	first = perf_evlist__first(evsel_list);
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
-		if (create_perf_stat_counter(counter, first) < 0) {
+		if (create_perf_stat_counter(counter, first, opts) < 0) {
 			/*
 			 * PPC returns ENXIO for HW counters until 2.6.37
 			 * (behavior changed with commit b0a873e).
@@ -354,7 +362,7 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 				error("You may not have permission to collect %sstats.\n"
 				      "\t Consider tweaking"
 				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
-				      target.system_wide ? "system-wide " : "");
+				      opts->target.system_wide ? "system-wide " : "");
 			} else {
 				error("open_counter returned with %d (%s). "
 				      "/bin/dmesg may provide additional information.\n",
@@ -395,13 +403,15 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 
 	if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
-			read_counter(counter);
-			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter), 1);
+			cmap = perf_evsel__cpus(counter, &opts->target);
+			read_counter(counter, opts);
+			perf_evsel__close_fd(counter, cmap->nr, 1);
 		}
 	} else {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
-			read_counter_aggr(counter);
-			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter),
+			cmap = perf_evsel__cpus(counter, &opts->target);
+			read_counter_aggr(counter, opts);
+			perf_evsel__close_fd(counter, cmap->nr,
 					     evsel_list->threads->nr);
 		}
 	}
@@ -409,7 +419,9 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 	return WEXITSTATUS(status);
 }
 
-static int run_perf_stat(int argc __maybe_unused, const char **argv)
+static int run_perf_stat(int argc __maybe_unused,
+			 const char **argv,
+			 struct perf_record_opts *opts)
 {
 	int ret;
 
@@ -422,7 +434,7 @@ static int run_perf_stat(int argc __maybe_unused, const char **argv)
 	if (sync_run)
 		sync();
 
-	ret = __run_perf_stat(argc, argv);
+	ret = __run_perf_stat(argc, argv, opts);
 	if (ret)
 		return ret;
 
@@ -456,16 +468,20 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 	print_noise_pct(stddev_stats(&ps->res_stats[0]), avg);
 }
 
-static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
+static void nsec_printout(int cpu, struct perf_evsel *evsel,
+			  double avg, struct perf_record_opts *opts)
 {
 	double msecs = avg / 1e6;
 	char cpustr[16] = { '\0', };
 	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-25s";
+	struct cpu_map *cmap;
 
-	if (no_aggr)
+	if (no_aggr) {
+		cmap = perf_evsel__cpus(evsel, &opts->target);
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
-			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
+			cmap->map[cpu], csv_sep);
+	}
 
 	fprintf(output, fmt, cpustr, msecs, csv_sep, perf_evsel__name(evsel));
 
@@ -661,11 +677,13 @@ static void print_ll_cache_misses(int cpu,
 	fprintf(output, " of all LL-cache hits   ");
 }
 
-static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
+static void abs_printout(int cpu, struct perf_evsel *evsel,
+			  double avg, struct perf_record_opts *opts)
 {
 	double total, ratio = 0.0;
 	char cpustr[16] = { '\0', };
 	const char *fmt;
+	struct cpu_map *cmap;
 
 	if (csv_output)
 		fmt = "%s%.0f%s%s";
@@ -674,11 +692,12 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	else
 		fmt = "%s%18.0f%s%-25s";
 
-	if (no_aggr)
+	if (no_aggr) {
+		cmap = perf_evsel__cpus(evsel, &opts->target);
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
-			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
-	else
+			cmap->map[cpu], csv_sep);
+	} else
 		cpu = 0;
 
 	fprintf(output, fmt, cpustr, avg, csv_sep, perf_evsel__name(evsel));
@@ -785,7 +804,8 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
  * Print out the results of a single counter:
  * aggregated counts in system-wide mode
  */
-static void print_counter_aggr(struct perf_evsel *counter)
+static void print_counter_aggr(struct perf_evsel *counter,
+			       struct perf_record_opts *opts)
 {
 	struct perf_stat *ps = counter->priv;
 	double avg = avg_stats(&ps->res_stats[0]);
@@ -807,9 +827,9 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	}
 
 	if (nsec_counter(counter))
-		nsec_printout(-1, counter, avg);
+		nsec_printout(-1, counter, avg, opts);
 	else
-		abs_printout(-1, counter, avg);
+		abs_printout(-1, counter, avg, opts);
 
 	print_noise(counter, avg);
 
@@ -833,19 +853,21 @@ static void print_counter_aggr(struct perf_evsel *counter)
  * Print out the results of a single counter:
  * does not use aggregated count in system-wide
  */
-static void print_counter(struct perf_evsel *counter)
+static void print_counter(struct perf_evsel *counter,
+			  struct perf_record_opts *opts)
 {
+	struct cpu_map *cmap = perf_evsel__cpus(counter, &opts->target);
 	u64 ena, run, val;
 	int cpu;
 
-	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
+	for (cpu = 0; cpu < cmap->nr; cpu++) {
 		val = counter->counts->cpu[cpu].val;
 		ena = counter->counts->cpu[cpu].ena;
 		run = counter->counts->cpu[cpu].run;
 		if (run == 0 || ena == 0) {
 			fprintf(output, "CPU%*d%s%*s%s%*s",
 				csv_output ? 0 : -4,
-				perf_evsel__cpus(counter)->map[cpu], csv_sep,
+				cmap->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
 				counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
 				csv_sep,
@@ -861,9 +883,9 @@ static void print_counter(struct perf_evsel *counter)
 		}
 
 		if (nsec_counter(counter))
-			nsec_printout(cpu, counter, val);
+			nsec_printout(cpu, counter, val, opts);
 		else
-			abs_printout(cpu, counter, val);
+			abs_printout(cpu, counter, val, opts);
 
 		if (!csv_output) {
 			print_noise(counter, 1.0);
@@ -876,9 +898,11 @@ static void print_counter(struct perf_evsel *counter)
 	}
 }
 
-static void print_stat(int argc, const char **argv)
+static void print_stat(int argc, const char **argv,
+		       struct perf_record_opts *opts)
 {
 	struct perf_evsel *counter;
+	struct perf_target *target = &opts->target;
 	int i;
 
 	fflush(stdout);
@@ -886,14 +910,14 @@ static void print_stat(int argc, const char **argv)
 	if (!csv_output) {
 		fprintf(output, "\n");
 		fprintf(output, " Performance counter stats for ");
-		if (!perf_target__has_task(&target)) {
+		if (!perf_target__has_task(target)) {
 			fprintf(output, "\'%s", argv[0]);
 			for (i = 1; i < argc; i++)
 				fprintf(output, " %s", argv[i]);
-		} else if (target.pid)
-			fprintf(output, "process id \'%s", target.pid);
+		} else if (target->pid)
+			fprintf(output, "process id \'%s", target->pid);
 		else
-			fprintf(output, "thread id \'%s", target.tid);
+			fprintf(output, "thread id \'%s", target->tid);
 
 		fprintf(output, "\'");
 		if (run_count > 1)
@@ -903,10 +927,10 @@ static void print_stat(int argc, const char **argv)
 
 	if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter(counter);
+			print_counter(counter, opts);
 	} else {
 		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter_aggr(counter);
+			print_counter_aggr(counter, opts);
 	}
 
 	if (!csv_output) {
@@ -1102,21 +1126,31 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	bool append_file = false;
 	int output_fd = 0;
 	const char *output_name	= NULL;
+
+	struct perf_record_opts opts = {
+		.target = {
+			.uid	= UINT_MAX,
+		},
+		.no_inherit	= false,
+		.group		= false,
+	};
+	struct perf_target *target = &opts.target;
+
 	const struct option options[] = {
 	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
-	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
+	OPT_BOOLEAN('i', "no-inherit", &opts.no_inherit,
 		    "child tasks do not inherit counters"),
-	OPT_STRING('p', "pid", &target.pid, "pid",
+	OPT_STRING('p', "pid", &target->pid, "pid",
 		   "stat events on existing process id"),
-	OPT_STRING('t', "tid", &target.tid, "tid",
+	OPT_STRING('t', "tid", &target->tid, "tid",
 		   "stat events on existing thread id"),
-	OPT_BOOLEAN('a', "all-cpus", &target.system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &target->system_wide,
 		    "system-wide collection from all CPUs"),
-	OPT_BOOLEAN('g', "group", &group,
+	OPT_BOOLEAN('g', "group", &opts.group,
 		    "put the counters into a counter group"),
 	OPT_BOOLEAN('c', "scale", &scale, "scale/normalize counters"),
 	OPT_INCR('v', "verbose", &verbose,
@@ -1132,7 +1166,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
 			   "print large numbers with thousands\' separators",
 			   stat__set_big_num),
-	OPT_STRING('C', "cpu", &target.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &target->cpu_list, "cpu",
 		    "list of cpus to monitor in system-wide"),
 	OPT_BOOLEAN('A', "no-aggr", &no_aggr, "disable CPU count aggregation"),
 	OPT_STRING('x', "field-separator", &csv_sep, "separator",
@@ -1220,13 +1254,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && !perf_target__has_task(&target))
+	if (!argc && !perf_target__has_task(target))
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
 	/* no_aggr, cgroup are for system-wide only */
-	if ((no_aggr || nr_cgroups) && !perf_target__has_cpu(&target)) {
+	if ((no_aggr || nr_cgroups) && !perf_target__has_cpu(target)) {
 		fprintf(stderr, "both cgroup and no-aggregation "
 			"modes only available in system-wide mode\n");
 
@@ -1236,12 +1270,12 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (add_default_attributes())
 		goto out;
 
-	perf_target__validate(&target);
+	perf_target__validate(target);
 
-	if (perf_evlist__create_maps(evsel_list, &target) < 0) {
-		if (perf_target__has_task(&target))
+	if (perf_evlist__create_maps(evsel_list, target) < 0) {
+		if (perf_target__has_task(target))
 			pr_err("Problems finding threads of monitor\n");
-		if (perf_target__has_cpu(&target))
+		if (perf_target__has_cpu(target))
 			perror("failed to parse CPUs map");
 
 		usage_with_options(stat_usage, options);
@@ -1249,8 +1283,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
+		struct cpu_map *cmap = perf_evsel__cpus(pos, target);
 		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
-		    perf_evsel__alloc_counts(pos, perf_evsel__nr_cpus(pos)) < 0)
+		    perf_evsel__alloc_counts(pos, cmap->nr) < 0)
 			goto out_free_fd;
 	}
 
@@ -1271,11 +1306,11 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			fprintf(output, "[ perf stat: executing run #%d ... ]\n",
 				run_idx + 1);
 
-		status = run_perf_stat(argc, argv);
+		status = run_perf_stat(argc, argv, &opts);
 	}
 
 	if (status != -1)
-		print_stat(argc, argv);
+		print_stat(argc, argv, &opts);
 out_free_fd:
 	list_for_each_entry(pos, &evsel_list->entries, node)
 		perf_evsel__free_stat_priv(pos);
-- 
1.7.10.1

