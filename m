Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1ATOau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:30:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:39196 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab1ATOaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:30:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=xe/wrkCJlLxoW3qdKLsXKJZNgY/d0Lx/fgozW06GyJZ5pjp5lKJorQTtI889HMd1bX
         jdKJbtMrHY2m/uE62OQQ==
Message-ID: <4d384706.c89cd80a.1e79.ffffa10d@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 20 Jan 2011 15:30:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 2/2] perf_events: add cgroup support to perf tool (v8)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to filter monitoring based on container groups
(cgroups) for both perf stat and perf record. It is possible to monitor
multiple cgroup in parallel. There is one cgroup per event. The cgroups to
monitor are passed via a new -G option followed by a comma separated list of
cgroup names.

The cgroup filesystem has to be mounted. Given a cgroup name, the perf tool
finds the corresponding directory in the cgroup filesystem and opens it. It
then passes that file descriptor to the kernel.

Example:
$ perf stat -B -a -e cycles:u,cycles:u,cycles:u -G test1,,test2 -- sleep 1
 Performance counter stats for 'sleep 1':

      2,368,667,414  cycles                   test1
      2,369,661,459  cycles                  
      <not counted>  cycles                   test2

        1.001856890  seconds time elapsed

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index e032716..5a520f8 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -137,6 +137,17 @@ Do not update the builid cache. This saves some overhead in situations
 where the information in the perf.data file (which includes buildids)
 is sufficient.
 
+-G name,...::
+--cgroup name,...::
+monitor only in the container (cgroup) called "name". This option is available only
+in per-cpu mode. The cgroup filesystem must be mounted. All threads belonging to
+container "name" are monitored when they run on the monitored CPUs. Multiple cgroups
+can be provided. Each cgroup is applied to the corresponding event, i.e., first cgroup
+to first event, second cgroup to second event and so on. It is possible to provide
+an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must have
+corresponding events, i.e., they always refer to events defined earlier on the command
+line.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index b6da7af..918cc38 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -83,6 +83,17 @@ This option is only valid in system-wide mode.
 print counts using a CSV-style output to make it easy to import directly into
 spreadsheets. Columns are separated by the string specified in SEP.
 
+-G name::
+--cgroup name::
+monitor only in the container (cgroup) called "name". This option is available only
+in per-cpu mode. The cgroup filesystem must be mounted. All threads belonging to
+container "name" are monitored when they run on the monitored CPUs. Multiple cgroups
+can be provided. Each cgroup is applied to the corresponding event, i.e., first cgroup
+to first event, second cgroup to second event and so on. It is possible to provide
+an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must have
+corresponding events, i.e., they always refer to events defined earlier on the command
+line.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2b5387d..ea8696e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -426,6 +426,7 @@ LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
 LIB_H += $(ARCH_INCLUDE)
+LIB_H += util/cgroup.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -475,6 +476,7 @@ LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/util.o
 LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
+LIB_OBJS += $(OUTPUT)util/cgroup.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fcd29e8..b0c60bf 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -23,6 +23,7 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/cpumap.h"
+#include "util/cgroup.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -234,9 +235,10 @@ static void create_counter(struct perf_evsel *evsel, int cpu)
 	char *filter = evsel->filter;
 	struct perf_event_attr *attr = &evsel->attr;
 	struct perf_header_attr *h_attr;
+	unsigned long flags = 0;
 	int track = !evsel->idx; /* only the first counter needs these */
 	int thread_index;
-	int ret;
+	int ret, pid = -1;
 	struct {
 		u64 count;
 		u64 time_enabled;
@@ -313,6 +315,11 @@ static void create_counter(struct perf_evsel *evsel, int cpu)
 		attr->wakeup_events = 1;
 	}
 
+	if (evsel->cgrp) {
+		flags = PERF_FLAG_PID_CGROUP;
+		pid = evsel->cgrp->fd;
+	}
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= !no_inherit;
@@ -325,7 +332,10 @@ retry_sample_id:
 
 	for (thread_index = 0; thread_index < threads->nr; thread_index++) {
 try_again:
-		FD(evsel, nr_cpu, thread_index) = sys_perf_event_open(attr, threads->map[thread_index], cpu, group_fd, 0);
+		if (!evsel->cgrp)
+			pid = threads->map[thread_index];
+
+		FD(evsel, nr_cpu, thread_index) = sys_perf_event_open(attr, pid, cpu, group_fd, flags);
 
 		if (FD(evsel, nr_cpu, thread_index) < 0) {
 			int err = errno;
@@ -884,6 +894,9 @@ const struct option record_options[] = {
 		    "do not update the buildid cache"),
 	OPT_BOOLEAN('B', "no-buildid", &no_buildid,
 		    "do not collect buildids in perf.data"),
+	OPT_CALLBACK('G', "cgroup", NULL, "name",
+		     "monitor event in cgroup name only",
+		     parse_cgroups),
 	OPT_END()
 };
 
@@ -908,6 +921,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		write_mode = WRITE_FORCE;
 	}
 
+	if (nr_cgroups && !system_wide) {
+		fprintf(stderr, "cgroup monitoring only available in"
+			" system-wide mode\n");
+		usage_with_options(record_usage, record_options);
+	}
+
 	symbol__init();
 
 	if (no_buildid_cache || no_buildid)
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 0ff11d9..43a61f9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -48,6 +48,7 @@
 #include "util/header.h"
 #include "util/cpumap.h"
 #include "util/thread.h"
+#include "util/cgroup.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -386,6 +387,9 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 	fprintf(stderr, fmt, cpustr, msecs, csv_sep, event_name(evsel));
 
+	if (evsel->cgrp)
+		fprintf(stderr, "%s%s", csv_sep, evsel->cgrp->name);
+
 	if (csv_output)
 		return;
 
@@ -416,6 +420,9 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 	fprintf(stderr, fmt, cpustr, avg, csv_sep, event_name(evsel));
 
+	if (evsel->cgrp)
+		fprintf(stderr, "%s%s", csv_sep, evsel->cgrp->name);
+
 	if (csv_output)
 		return;
 
@@ -456,9 +463,17 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	int scaled = counter->counts->scaled;
 
 	if (scaled == -1) {
-		fprintf(stderr, "%*s%s%-24s\n",
+		fprintf(stderr, "%*s%s%*s",
 			csv_output ? 0 : 18,
-			"<not counted>", csv_sep, event_name(counter));
+			"<not counted>",
+			csv_sep,
+			csv_output ? 0 : -24,
+			event_name(counter));
+
+		if (counter->cgrp)
+			fprintf(stderr, "%s%s", csv_sep, counter->cgrp->name);
+
+		fputc('\n', stderr);
 		return;
 	}
 
@@ -483,7 +498,6 @@ static void print_counter_aggr(struct perf_evsel *counter)
 		fprintf(stderr, "  (scaled from %.2f%%)",
 				100 * avg_running / avg_enabled);
 	}
-
 	fprintf(stderr, "\n");
 }
 
@@ -501,14 +515,19 @@ static void print_counter(struct perf_evsel *counter)
 		ena = counter->counts->cpu[cpu].ena;
 		run = counter->counts->cpu[cpu].run;
 		if (run == 0 || ena == 0) {
-			fprintf(stderr, "CPU%*d%s%*s%s%-24s",
+			fprintf(stderr, "CPU%*d%s%*s%s%*s",
 				csv_output ? 0 : -4,
 				cpus->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
 				"<not counted>", csv_sep,
+				csv_output ? 0 : -24,
 				event_name(counter));
 
-			fprintf(stderr, "\n");
+			if (counter->cgrp)
+				fprintf(stderr, "%s%s", csv_sep,
+					counter->cgrp->name);
+
+			fputc('\n', stderr);
 			continue;
 		}
 
@@ -525,7 +544,7 @@ static void print_counter(struct perf_evsel *counter)
 					100.0 * run / ena);
 			}
 		}
-		fprintf(stderr, "\n");
+		fputc('\n', stderr);
 	}
 }
 
@@ -638,6 +657,9 @@ static const struct option options[] = {
 		    "disable CPU count aggregation"),
 	OPT_STRING('x', "field-separator", &csv_sep, "separator",
 		   "print counts with custom separator"),
+	OPT_CALLBACK('G', "cgroup", NULL, "name",
+		     "monitor event in cgroup name only",
+		     parse_cgroups),
 	OPT_END()
 };
 
@@ -674,9 +696,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
-	/* no_aggr is for system-wide only */
-	if (no_aggr && !system_wide)
+	/* no_aggr, cgroup are for system-wide only */
+	if ((no_aggr || nr_cgroups) && !system_wide) {
+		fprintf(stderr, "both cgroup and no-aggregation "
+			"modes only available in system-wide mode\n");
+
 		usage_with_options(stat_usage, options);
+	}
 
 	/* Set attrs and nr_counters if no event is selected and !null_run */
 	if (!null_run && !nr_counters) {
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
new file mode 100644
index 0000000..b407859
--- /dev/null
+++ b/tools/perf/util/cgroup.c
@@ -0,0 +1,161 @@
+#include "util.h"
+#include "../perf.h"
+#include "parse-options.h"
+#include "evsel.h"
+#include "cgroup.h"
+#include "debugfs.h" /* MAX_PATH, STR() */
+#include "parse-events.h" /* for evsel_list */
+
+int nr_cgroups;
+
+static char cgroup_mountpoint[MAX_PATH+1];
+static int found_cgroup_mnt;
+
+static void cgroupfs_find_mountpoint(void)
+{
+	FILE *fp;
+	char type[64];
+
+	fp = fopen("/proc/mounts", "r");
+	if (!fp)
+		return;
+
+	while (fscanf(fp, "%*s %"
+				STR(MAX_PATH)
+				"s %99s %*s %*d %*d\n",
+				cgroup_mountpoint, type) == 2) {
+
+		if (!strcmp(type, "cgroup")) {
+			found_cgroup_mnt = 1;
+			break;
+		}
+	}
+	fclose(fp);
+}
+
+static int open_cgroup(char *name)
+{
+	static int mnt_done;
+
+	char path[MAX_PATH+1];
+	int fd;
+
+	if (!mnt_done) {
+		cgroupfs_find_mountpoint();
+		mnt_done = 1;
+	}
+
+	if (!found_cgroup_mnt)
+		return -1;
+
+	snprintf(path, MAX_PATH, "%s/%s", cgroup_mountpoint, name);
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		fprintf(stderr, "no access to cgroup %s\n", path);
+
+	return fd;
+}
+
+static int add_cgroup(char *str)
+{
+	struct perf_evsel *counter;
+	struct cgroup_sel *cgrp = NULL;
+	int n;
+	/*
+	 * check if cgrp is already defined, if so we reuse it
+	 */
+	list_for_each_entry(counter, &evsel_list, node) {
+		cgrp = counter->cgrp;
+		if (!cgrp)
+			continue;
+		if (!strcmp(cgrp->name, str))
+			break;
+
+		cgrp = NULL;
+	}
+
+	if (!cgrp) {
+		cgrp = zalloc(sizeof(*cgrp));
+		if (!cgrp)
+			return -1;
+
+		cgrp->name = str;
+
+		cgrp->fd = open_cgroup(str);
+		if (cgrp->fd == -1) {
+			free(cgrp);
+			return -1;
+		}
+	}
+
+	/*
+	 * find corresponding event
+	 * if add cgroup N, then need to find event N
+	 */
+	n = 0;
+	list_for_each_entry(counter, &evsel_list, node) {
+		if (n == nr_cgroups)
+			goto found;
+		n++;
+	}
+	if (cgrp->refcnt == 0)
+		free(cgrp);
+
+	return -1;
+found:
+	cgrp->refcnt++;
+	counter->cgrp = cgrp;
+	return 0;
+}
+
+void close_cgroup(struct cgroup_sel *cgrp)
+{
+	if (!cgrp)
+		return;
+
+	/* XXX: not reentrant */
+	if (--cgrp->refcnt == 0) {
+		close(cgrp->fd);
+		free(cgrp->name);
+		free(cgrp);
+	}
+}
+
+int parse_cgroups(const struct option *opt __used, const char *str,
+		  int unset __used)
+{
+	const char *p, *e, *eos = str + strlen(str);
+	char *s;
+	int ret;
+
+	/* need to have some events defined first */
+	if (!nr_counters) {
+		fprintf(stderr, "must define events before cgroups\n");
+		return -1;
+	}
+
+	for (;;) {
+		p = strchr(str, ',');
+		e = p ? p : eos;
+
+		/* allow empty cgroups, i.e., skip */
+		if (e - str) {
+			/* termination added */
+			s = strndup(str, e - str);
+			if (!s)
+				return -1;
+			ret = add_cgroup(s);
+			if (ret) {
+				free(s);
+				return -1;
+			}
+		}
+		/* nr_cgroups is increased een for empty cgroups */
+		nr_cgroups++;
+		if (!p)
+			break;
+		str = p+1;
+	}
+	return 0;
+}
diff --git a/tools/perf/util/cgroup.h b/tools/perf/util/cgroup.h
new file mode 100644
index 0000000..89acd6d
--- /dev/null
+++ b/tools/perf/util/cgroup.h
@@ -0,0 +1,17 @@
+#ifndef __CGROUP_H__
+#define __CGROUP_H__
+
+struct option;
+
+struct cgroup_sel {
+	char *name;
+	int fd;
+	int refcnt;
+};
+
+
+extern int nr_cgroups; /* number of explicit cgroups defined */
+extern void close_cgroup(struct cgroup_sel *cgrp);
+extern int parse_cgroups(const struct option *opt, const char *str, int unset);
+
+#endif /* __CGROUP_H__ */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f5cfed6..65cab64 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -53,6 +53,7 @@ void perf_evsel__delete(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
 	xyarray__delete(evsel->fd);
+	close_cgroup(evsel->cgrp);
 	free(evsel);
 }
 
@@ -130,17 +131,28 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
-	int cpu, thread;
+	unsigned long flags = 0;
+	int cpu, thread, pid = -1;
 
 	if (evsel->fd == NULL &&
 	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
 		return -1;
 
+	if (evsel->cgrp) {
+		flags = PERF_FLAG_PID_CGROUP;
+		pid = evsel->cgrp->fd;
+	}
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		for (thread = 0; thread < threads->nr; thread++) {
+
+			if (!evsel->cgrp)
+				pid = threads->map[thread];
+
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
-								     threads->map[thread],
-								     cpus->map[cpu], -1, 0);
+								     pid,
+								     cpus->map[cpu],
+								     -1,
+								     flags);
 			if (FD(evsel, cpu, thread) < 0)
 				goto out_close;
 		}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index b2d755f..2e2beb1 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -6,6 +6,7 @@
 #include "../../../include/linux/perf_event.h"
 #include "types.h"
 #include "xyarray.h"
+#include "cgroup.h"
  
 struct perf_counts_values {
 	union {
@@ -32,6 +33,7 @@ struct perf_evsel {
 	struct perf_counts	*counts;
 	int			idx;
 	void			*priv;
+	struct cgroup_sel	*cgrp;
 };
 
 struct cpu_map;
