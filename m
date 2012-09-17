Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2IQRT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:19:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:46453 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2IQRSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/18] perf stat: Check PMU cpumask file
Date: Mon, 17 Sep 2012 14:18:12 -0300
Message-Id: <1347902292-14536-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yan, Zheng <zheng.z.yan@intel.com>

If user doesn't explicitly specify CPU list, perf-stat only collects
events on CPUs listed in the PMU cpumask file.

Signed-off-by: "Yah, Zheng" <zheng.z.yan@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1347263631-23175-3-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c      |   30 ++++++++++++++++++++----------
 tools/perf/util/cpumap.c       |   22 +++++++++++++++-------
 tools/perf/util/cpumap.h       |    2 +-
 tools/perf/util/evsel.h        |    1 +
 tools/perf/util/parse-events.c |   18 ++++++++++++++----
 tools/perf/util/pmu.c          |   30 ++++++++++++++++++++++++++++++
 tools/perf/util/pmu.h          |    1 +
 7 files changed, 82 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3c43a35..e0f65fe 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -215,6 +215,16 @@ static void perf_evsel__free_stat_priv(struct perf_evsel *evsel)
 	evsel->priv = NULL;
 }
 
+static inline struct cpu_map *perf_evsel__cpus(struct perf_evsel *evsel)
+{
+	return (evsel->cpus && !target.cpu_list) ? evsel->cpus : evsel_list->cpus;
+}
+
+static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel)
+{
+	return perf_evsel__cpus(evsel)->nr;
+}
+
 static struct stats runtime_nsecs_stats[MAX_NR_CPUS];
 static struct stats runtime_cycles_stats[MAX_NR_CPUS];
 static struct stats runtime_stalled_cycles_front_stats[MAX_NR_CPUS];
@@ -246,7 +256,7 @@ retry:
 		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
 
 	if (perf_target__has_cpu(&target)) {
-		ret = perf_evsel__open_per_cpu(evsel, evsel_list->cpus);
+		ret = perf_evsel__open_per_cpu(evsel, perf_evsel__cpus(evsel));
 		if (ret)
 			goto check_ret;
 		return 0;
@@ -327,7 +337,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	u64 *count = counter->counts->aggr.values;
 	int i;
 
-	if (__perf_evsel__read(counter, evsel_list->cpus->nr,
+	if (__perf_evsel__read(counter, perf_evsel__nr_cpus(counter),
 			       evsel_list->threads->nr, scale) < 0)
 		return -1;
 
@@ -356,7 +366,7 @@ static int read_counter(struct perf_evsel *counter)
 	u64 *count;
 	int cpu;
 
-	for (cpu = 0; cpu < evsel_list->cpus->nr; cpu++) {
+	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
 		if (__perf_evsel__read_on_cpu(counter, cpu, 0, scale) < 0)
 			return -1;
 
@@ -495,12 +505,12 @@ static int run_perf_stat(int argc __maybe_unused, const char **argv)
 	if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			read_counter(counter);
-			perf_evsel__close_fd(counter, evsel_list->cpus->nr, 1);
+			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter), 1);
 		}
 	} else {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			read_counter_aggr(counter);
-			perf_evsel__close_fd(counter, evsel_list->cpus->nr,
+			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter),
 					     evsel_list->threads->nr);
 		}
 	}
@@ -538,7 +548,7 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
-			evsel_list->cpus->map[cpu], csv_sep);
+			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
 
 	fprintf(output, fmt, cpustr, msecs, csv_sep, perf_evsel__name(evsel));
 
@@ -750,7 +760,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
-			evsel_list->cpus->map[cpu], csv_sep);
+			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
 	else
 		cpu = 0;
 
@@ -911,14 +921,14 @@ static void print_counter(struct perf_evsel *counter)
 	u64 ena, run, val;
 	int cpu;
 
-	for (cpu = 0; cpu < evsel_list->cpus->nr; cpu++) {
+	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
 		val = counter->counts->cpu[cpu].val;
 		ena = counter->counts->cpu[cpu].ena;
 		run = counter->counts->cpu[cpu].run;
 		if (run == 0 || ena == 0) {
 			fprintf(output, "CPU%*d%s%*s%s%*s",
 				csv_output ? 0 : -4,
-				evsel_list->cpus->map[cpu], csv_sep,
+				perf_evsel__cpus(counter)->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
 				counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
 				csv_sep,
@@ -1217,7 +1227,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
 		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
-		    perf_evsel__alloc_counts(pos, evsel_list->cpus->nr) < 0)
+		    perf_evsel__alloc_counts(pos, perf_evsel__nr_cpus(pos)) < 0)
 			goto out_free_fd;
 	}
 
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index adc72f0..2b32ffa 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -38,24 +38,19 @@ static struct cpu_map *cpu_map__trim_new(int nr_cpus, int *tmp_cpus)
 	return cpus;
 }
 
-static struct cpu_map *cpu_map__read_all_cpu_map(void)
+struct cpu_map *cpu_map__read(FILE *file)
 {
 	struct cpu_map *cpus = NULL;
-	FILE *onlnf;
 	int nr_cpus = 0;
 	int *tmp_cpus = NULL, *tmp;
 	int max_entries = 0;
 	int n, cpu, prev;
 	char sep;
 
-	onlnf = fopen("/sys/devices/system/cpu/online", "r");
-	if (!onlnf)
-		return cpu_map__default_new();
-
 	sep = 0;
 	prev = -1;
 	for (;;) {
-		n = fscanf(onlnf, "%u%c", &cpu, &sep);
+		n = fscanf(file, "%u%c", &cpu, &sep);
 		if (n <= 0)
 			break;
 		if (prev >= 0) {
@@ -95,6 +90,19 @@ static struct cpu_map *cpu_map__read_all_cpu_map(void)
 		cpus = cpu_map__default_new();
 out_free_tmp:
 	free(tmp_cpus);
+	return cpus;
+}
+
+static struct cpu_map *cpu_map__read_all_cpu_map(void)
+{
+	struct cpu_map *cpus = NULL;
+	FILE *onlnf;
+
+	onlnf = fopen("/sys/devices/system/cpu/online", "r");
+	if (!onlnf)
+		return cpu_map__default_new();
+
+	cpus = cpu_map__read(onlnf);
 	fclose(onlnf);
 	return cpus;
 }
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index c415185..17b5264 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -11,7 +11,7 @@ struct cpu_map {
 struct cpu_map *cpu_map__new(const char *cpu_list);
 struct cpu_map *cpu_map__dummy_new(void);
 void cpu_map__delete(struct cpu_map *map);
-
+struct cpu_map *cpu_map__read(FILE *file);
 size_t cpu_map__fprintf(struct cpu_map *map, FILE *fp);
 
 #endif /* __PERF_CPUMAP_H */
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index dc40fe3..93876ba 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -66,6 +66,7 @@ struct perf_evsel {
 		void		*func;
 		void		*data;
 	} handler;
+	struct cpu_map		*cpus;
 	unsigned int		sample_size;
 	bool 			supported;
 	/* parse modifier helper */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 44afcf4..bf5d033 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -239,8 +239,11 @@ const char *event_type(int type)
 	return "unknown";
 }
 
-static int add_event(struct list_head **_list, int *idx,
-		     struct perf_event_attr *attr, char *name)
+
+
+static int __add_event(struct list_head **_list, int *idx,
+		       struct perf_event_attr *attr,
+		       char *name, struct cpu_map *cpus)
 {
 	struct perf_evsel *evsel;
 	struct list_head *list = *_list;
@@ -260,6 +263,7 @@ static int add_event(struct list_head **_list, int *idx,
 		return -ENOMEM;
 	}
 
+	evsel->cpus = cpus;
 	if (name)
 		evsel->name = strdup(name);
 	list_add_tail(&evsel->node, list);
@@ -267,6 +271,12 @@ static int add_event(struct list_head **_list, int *idx,
 	return 0;
 }
 
+static int add_event(struct list_head **_list, int *idx,
+		     struct perf_event_attr *attr, char *name)
+{
+	return __add_event(_list, idx, attr, name, NULL);
+}
+
 static int parse_aliases(char *str, const char *names[][PERF_EVSEL__MAX_ALIASES], int size)
 {
 	int i, j;
@@ -607,8 +617,8 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 	if (perf_pmu__config(pmu, &attr, head_config))
 		return -EINVAL;
 
-	return add_event(list, idx, &attr,
-			 pmu_event_name(head_config));
+	return __add_event(list, idx, &attr, pmu_event_name(head_config),
+			   pmu->cpus);
 }
 
 int parse_events__modifier_group(struct list_head *list,
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 6631d82..8a2229d 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -9,6 +9,7 @@
 #include "util.h"
 #include "pmu.h"
 #include "parse-events.h"
+#include "cpumap.h"
 
 #define EVENT_SOURCE_DEVICE_PATH "/bus/event_source/devices/"
 
@@ -253,6 +254,33 @@ static void pmu_read_sysfs(void)
 	closedir(dir);
 }
 
+static struct cpu_map *pmu_cpumask(char *name)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	const char *sysfs;
+	FILE *file;
+	struct cpu_map *cpus;
+
+	sysfs = sysfs_find_mountpoint();
+	if (!sysfs)
+		return NULL;
+
+	snprintf(path, PATH_MAX,
+		 "%s/bus/event_source/devices/%s/cpumask", sysfs, name);
+
+	if (stat(path, &st) < 0)
+		return NULL;
+
+	file = fopen(path, "r");
+	if (!file)
+		return NULL;
+
+	cpus = cpu_map__read(file);
+	fclose(file);
+	return cpus;
+}
+
 static struct perf_pmu *pmu_lookup(char *name)
 {
 	struct perf_pmu *pmu;
@@ -275,6 +303,8 @@ static struct perf_pmu *pmu_lookup(char *name)
 	if (!pmu)
 		return NULL;
 
+	pmu->cpus = pmu_cpumask(name);
+
 	pmu_aliases(name, &aliases);
 
 	INIT_LIST_HEAD(&pmu->format);
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 47f68d3..53c7794 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -28,6 +28,7 @@ struct perf_pmu__alias {
 struct perf_pmu {
 	char *name;
 	__u32 type;
+	struct cpu_map *cpus;
 	struct list_head format;
 	struct list_head aliases;
 	struct list_head list;
-- 
1.7.1

