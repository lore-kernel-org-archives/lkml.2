Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab1ACRVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:21:51 -0500
Received: from smtp-out.google.com ([216.239.44.51]:61322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258Ab1ACRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:21:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=SFmNHpfbMHLpQ3vH9nCWQxRIXLDXxag68cxDo1gzcvMJPJk1lF9Wsh2SWfcT3sN6t7
         PPmG5KPcugLtbFywLt8w==
Message-ID: <4d2205a8.0504d90a.1042.160c@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 3 Jan 2011 18:20:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 5/5] perf_events: add cgroup support to perf tool (v7)
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
index 52462ae..2ddd13b 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -134,6 +134,14 @@ Do not update the builid cache. This saves some overhead in situations
 where the information in the perf.data file (which includes buildids)
 is sufficient.
 
+-G name,...::
+--cgroup name,...::
+monitor only in the container (cgroup) called "name". This option is available only
+in per-cpu mode. The cgroup filesystem must be mounted. All threads belonging to
+container "name" are monitored when they run on the monitored CPUs. Multiple cgroups
+can be provided. Each cgroup is applied to the corresponding event, i.e., first cgroup
+to first event, second cgroup to second event and so on.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index b6da7af..a72251a 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -83,6 +83,14 @@ This option is only valid in system-wide mode.
 print counts using a CSV-style output to make it easy to import directly into
 spreadsheets. Columns are separated by the string specified in SEP.
 
+-G name::
+--cgroup name::
+monitor only in the container (cgroup) called "name". This option is available only
+in per-cpu mode. The cgroup filesystem must be mounted. All threads belonging to
+container "name" are monitored when they run on the monitored CPUs. Multiple cgroups
+can be provided. Each cgroup is applied to the corresponding event, i.e., first cgroup
+to first event, second cgroup to second event and so on.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ac6692c..3e91166 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -424,6 +424,7 @@ LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
 LIB_H += $(ARCH_INCLUDE)
+LIB_H += util/cgroup.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -471,6 +472,7 @@ LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/util.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
+LIB_OBJS += $(OUTPUT)util/cgroup.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 50efbd5..bc24acc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -22,6 +22,7 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/cpumap.h"
+#include "util/cgroup.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -234,6 +235,8 @@ static void create_counter(int counter, int cpu)
 	char *filter = filters[counter];
 	struct perf_event_attr *attr = attrs + counter;
 	struct perf_header_attr *h_attr;
+	unsigned long flags = 0;
+	int pid;
 	int track = !counter; /* only the first counter needs these */
 	int thread_index;
 	int ret;
@@ -308,6 +311,9 @@ static void create_counter(int counter, int cpu)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (cgroups[counter])
+		flags = PERF_FLAG_PID_CGROUP;
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= !no_inherit;
@@ -320,8 +326,13 @@ retry_sample_id:
 
 	for (thread_index = 0; thread_index < thread_num; thread_index++) {
 try_again:
+		if (cgroups[counter])
+			pid = cgroups_fd[counter];
+		else
+			pid = all_tids[thread_index];
+
 		fd[nr_cpu][counter][thread_index] = sys_perf_event_open(attr,
-				all_tids[thread_index], cpu, group_fd, 0);
+				pid, cpu, group_fd, flags);
 
 		if (fd[nr_cpu][counter][thread_index] < 0) {
 			int err = errno;
@@ -882,6 +893,9 @@ const struct option record_options[] = {
 		    "do not update the buildid cache"),
 	OPT_BOOLEAN('B', "no-buildid", &no_buildid,
 		    "do not collect buildids in perf.data"),
+	OPT_CALLBACK('G', "cgroup", NULL, "name",
+		     "monitor in cgroup name only",
+		     parse_cgroups),
 	OPT_END()
 };
 
@@ -905,6 +919,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		write_mode = WRITE_FORCE;
 	}
 
+	if (nr_cgroups && !system_wide) {
+		fprintf(stderr, "cgroup monitoring only available in "
+			" system-wide mode\n");
+		usage_with_options(record_usage, record_options);
+	}
+
 	symbol__init();
 
 	if (no_buildid_cache || no_buildid)
@@ -916,6 +936,9 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		attrs[0].config = PERF_COUNT_HW_CPU_CYCLES;
 	}
 
+	if (open_cgroups())
+		usage_with_options(record_usage, record_options);
+
 	if (target_pid != -1) {
 		target_tid = target_pid;
 		thread_num = find_all_tid(target_pid, &all_tids);
@@ -925,6 +948,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 			usage_with_options(record_usage, record_options);
 		}
 	} else {
+		err = -ENOMEM;
 		all_tids=malloc(sizeof(pid_t));
 		if (!all_tids)
 			goto out_symbol_exit;
@@ -976,5 +1000,6 @@ out_free_fd:
 	all_tids = NULL;
 out_symbol_exit:
 	symbol__exit();
+	close_cgroups();
 	return err;
 }
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7ff746d..51e3fe8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -47,6 +47,7 @@
 #include "util/header.h"
 #include "util/cpumap.h"
 #include "util/thread.h"
+#include "util/cgroup.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -163,6 +164,8 @@ struct stats			walltime_nsecs_stats;
 static int create_perf_stat_counter(int counter, bool *perm_err)
 {
 	struct perf_event_attr *attr = attrs + counter;
+	unsigned long flags = 0;
+	int pid = -1;
 	int thread;
 	int ncreated = 0;
 
@@ -173,9 +176,13 @@ static int create_perf_stat_counter(int counter, bool *perm_err)
 	if (system_wide) {
 		int cpu;
 
+		if (cgroups[counter]) {
+			flags = PERF_FLAG_PID_CGROUP;
+			pid = cgroups_fd[counter];
+		}
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
 			fd[cpu][counter][0] = sys_perf_event_open(attr,
-					-1, cpumap[cpu], -1, 0);
+					pid, cpumap[cpu], -1, flags);
 			if (fd[cpu][counter][0] < 0) {
 				if (errno == EPERM || errno == EACCES)
 					*perm_err = true;
@@ -464,6 +471,9 @@ static void nsec_printout(int cpu, int counter, double avg)
 
 	fprintf(stderr, fmt, cpustr, msecs, csv_sep, event_name(counter));
 
+	if (cgroups[counter])
+		fprintf(stderr, "%s%s", csv_sep, cgroups[counter]);
+
 	if (csv_output)
 		return;
 
@@ -495,6 +505,9 @@ static void abs_printout(int cpu, int counter, double avg)
 
 	fprintf(stderr, fmt, cpustr, avg, csv_sep, event_name(counter));
 
+	if (cgroups[counter])
+		fprintf(stderr, "%s%s", csv_sep, cgroups[counter]);
+
 	if (csv_output)
 		return;
 
@@ -534,9 +547,17 @@ static void print_counter_aggr(int counter)
 	int scaled = event_scaled[counter];
 
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
+		if (cgroups[counter])
+			fprintf(stderr, "%s%s", csv_sep, cgroups[counter]);
+
+		fputc('\n', stderr);
 		return;
 	}
 
@@ -561,7 +582,6 @@ static void print_counter_aggr(int counter)
 		fprintf(stderr, "  (scaled from %.2f%%)",
 				100 * avg_running / avg_enabled);
 	}
-
 	fprintf(stderr, "\n");
 }
 
@@ -579,14 +599,18 @@ static void print_counter(int counter)
 		ena = cpu_counts[cpu][counter].ena;
 		run = cpu_counts[cpu][counter].run;
 		if (run == 0 || ena == 0) {
-			fprintf(stderr, "CPU%*d%s%*s%s%-24s",
+			fprintf(stderr, "CPU%*d%s%*s%s%*s",
 				csv_output ? 0 : -4,
 				cpumap[cpu], csv_sep,
 				csv_output ? 0 : 18,
 				"<not counted>", csv_sep,
+				csv_output ? 0 : -24,
 				event_name(counter));
 
-			fprintf(stderr, "\n");
+			if (cgroups[counter])
+				fprintf(stderr, "%s%s", csv_sep, cgroups[counter]);
+
+			fputc('\n', stderr);
 			continue;
 		}
 
@@ -603,7 +627,7 @@ static void print_counter(int counter)
 					100.0 * run / ena);
 			}
 		}
-		fprintf(stderr, "\n");
+		fputc('\n', stderr);
 	}
 }
 
@@ -715,6 +739,9 @@ static const struct option options[] = {
 		    "disable CPU count aggregation"),
 	OPT_STRING('x', "field-separator", &csv_sep, "separator",
 		   "print counts with custom separator"),
+	OPT_CALLBACK('G', "cgroup", NULL, "name",
+		     "monitor in cgroup name only",
+		     parse_cgroups),
 	OPT_END()
 };
 
@@ -752,13 +779,27 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(stat_usage, options);
 
 	/* no_aggr is for system-wide only */
-	if (no_aggr && !system_wide)
+	if ((no_aggr || nr_cgroups) && !system_wide) {
+		fprintf(stderr, "both cgroup and no-aggregation "
+			"modes only available in system-wide mode\n");
+
 		usage_with_options(stat_usage, options);
+	}
 
 	/* Set attrs and nr_counters if no event is selected and !null_run */
 	if (!null_run && !nr_counters) {
 		memcpy(attrs, default_attrs, sizeof(default_attrs));
 		nr_counters = ARRAY_SIZE(default_attrs);
+		if (nr_cgroups == 1) {
+			for (i = 1; i < nr_counters; i++) {
+				cgroups[i] = strdup(cgroups[0]);
+				if (!cgroups[i]) {
+					close_cgroups();
+					return -ENOMEM;
+				}
+				nr_cgroups++;
+			}
+		}
 	}
 
 	if (system_wide)
@@ -805,6 +846,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
 
+	if (open_cgroups())
+		usage_with_options(stat_usage, options);
+
 	status = 0;
 	for (run_idx = 0; run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
@@ -815,5 +859,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (status != -1)
 		print_stat(argc, argv);
 
+	close_cgroups();
+
 	return status;
 }
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
new file mode 100644
index 0000000..902f2c5
--- /dev/null
+++ b/tools/perf/util/cgroup.c
@@ -0,0 +1,123 @@
+#include "util.h"
+#include "../perf.h"
+#include "parse-options.h"
+#include "parse-events.h" /* for nr_counters */
+#include "cgroup.h"
+#include "debugfs.h" /* MAX_PATH, STR() */
+
+char *cgroups[MAX_COUNTERS];
+int cgroups_fd[MAX_COUNTERS];
+int nr_cgroups;
+
+static char cgroup_mountpoint[MAX_PATH+1];
+
+static const char *cgroupfs_find_mountpoint(void)
+{
+	FILE *fp;
+	int found = 0;
+	char type[64];
+
+	fp = fopen("/proc/mounts", "r");
+	if (!fp)
+		return NULL;
+
+	while (fscanf(fp, "%*s %"
+				STR(MAX_PATH)
+				"s %99s %*s %*d %*d\n",
+				cgroup_mountpoint, type) == 2) {
+
+		if (!strcmp(type, "cgroup")) {
+			found = 1;
+			break;
+		}
+	}
+	fclose(fp);
+
+	if (found == 0)
+		return NULL;
+
+	return cgroup_mountpoint;
+}
+
+int open_cgroups(void)
+{
+	char path[MAX_PATH+1];
+	const char *mnt;
+	int i;
+
+	if (!nr_cgroups)
+		return 0;
+
+	mnt = cgroupfs_find_mountpoint();
+	if (!mnt)
+		return -1;
+
+	for (i = 0; i < nr_counters; i++) {
+
+		if (!cgroups[i])
+			continue;
+
+		snprintf(path, MAX_PATH, "%s/%s",
+				mnt, cgroups[i]);
+
+		cgroups_fd[i] = open(path, O_RDONLY);
+		if (cgroups_fd[i] == -1) {
+			fprintf(stderr, "no access to cgroup %s\n", path);
+			return -1;
+		}
+	}
+	return 0;
+}
+
+void close_cgroups(void)
+{
+	int i;
+
+	if (!nr_cgroups)
+		return;
+
+	for (i = 0; i < nr_counters; i++) {
+		if (!cgroups[i])
+			continue;
+		if (cgroups_fd[i] != -1)
+			close(cgroups_fd[i]);
+		free(cgroups[i]);
+		cgroups[i] = NULL; /* catch errors */
+	}
+}
+
+int parse_cgroups(const struct option *opt __used, const char *str,
+		  int unset __used)
+{
+	const char *p, *e, *eos = str + strlen(str);
+	int n = 0;
+	for (;;) {
+		p = strchr(str, ',');
+		e = p ? p : eos;
+
+		if (n == MAX_COUNTERS)
+			goto error;
+		/* allow empty cgroups, i.e., skip */
+		if (e - str) {
+			/* termination added */
+			cgroups[n] = strndup(str, e - str);
+			if (!cgroups[n])
+				goto error;
+			nr_cgroups++;
+		} else {
+			cgroups[n] = NULL;
+		}
+		n++;
+		if (!p)
+			break;
+		str = p+1;
+	}
+	for (n = 0; n < MAX_COUNTERS; n++)
+		cgroups_fd[n] = -1;
+	return 0;
+error:
+	while (--n >= 0)
+		if (cgroups[n])
+			free(cgroups[n]);
+	return -1;
+}
diff --git a/tools/perf/util/cgroup.h b/tools/perf/util/cgroup.h
new file mode 100644
index 0000000..99a7426
--- /dev/null
+++ b/tools/perf/util/cgroup.h
@@ -0,0 +1,14 @@
+#ifndef __CGROUP_H__
+#define __CGROUP_H__
+
+struct option;
+
+extern char *cgroups[MAX_COUNTERS];
+extern int cgroups_fd[MAX_COUNTERS];
+extern int nr_cgroups; /* number of explicit cgroups defined */
+
+extern int open_cgroups(void);
+extern void close_cgroups(void);
+extern int parse_cgroups(const struct option *opt, const char *str, int unset);
+
+#endif /* __CGROUP_H__ */
