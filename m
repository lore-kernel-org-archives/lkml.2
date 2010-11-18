Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab0KRLlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:41:23 -0500
Received: from smtp-out.google.com ([74.125.121.35]:39349 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab0KRLlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:41:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=ioOPYNrTIvsGys2fOejwz3uZFnJqfLv6dy2tKhPMkKL9gpghswDHAOlgT/FXQIHPQW
         YYqjb27SY9pdfgPcu31w==
Message-ID: <4ce510db.04e7d80a.1a5d.10cd@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 18 Nov 2010 12:40:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 2/2] perf: add support for per-cpu per-cgroup monitoring (v5)
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
index a91f9f9..7804d95 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -120,6 +120,12 @@ Do not update the builid cache. This saves some overhead in situations
 where the information in the perf.data file (which includes buildids)
 is sufficient.
 
+-G name::
+--cgroup name::
+monitor only in the container called "name". This option is available only in per-cpu
+mode. The cgroup filesystem must be mounted. All threads belonging to container "name"
+are monitored when they run on the monitored CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 4b3a2d4..4115f77 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -53,6 +53,11 @@ comma-sperated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2
 In per-thread mode, this option is ignored. The -a option is still necessary
 to activate system-wide monitoring. Default is to count on all CPUs.
 
+-G name::
+--cgroup name::
+monitor only in the container called "name". This option is available only in per-cpu
+mode. The cgroup filesystem must be mounted. All threads belonging to container "name"
+are monitored when they run on the monitored CPUs.
 EXAMPLES
 --------
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1355bce..8179581 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -417,6 +417,7 @@ LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
+LIB_H += util/cgroup.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -464,6 +465,7 @@ LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/util.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
+LIB_OBJS += $(OUTPUT)util/cgroup.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 63a5ce3..bc8df51 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -23,6 +23,7 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/cpumap.h"
+#include "util/cgroup.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -230,6 +231,8 @@ static void create_counter(int counter, int cpu)
 	char *filter = filters[counter];
 	struct perf_event_attr *attr = attrs + counter;
 	struct perf_header_attr *h_attr;
+	unsigned long flags = 0;
+	int pid;
 	int track = !counter; /* only the first counter needs these */
 	int thread_index;
 	int ret;
@@ -287,6 +290,9 @@ static void create_counter(int counter, int cpu)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (cgroups[counter])
+		flags = PERF_FLAG_PID_CGROUP;
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= !no_inherit;
@@ -297,8 +303,13 @@ static void create_counter(int counter, int cpu)
 
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
@@ -885,6 +896,9 @@ const struct option record_options[] = {
 		    "don't sample"),
 	OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid,
 		    "do not update the buildid cache"),
+	OPT_CALLBACK('G', "cgroup", NULL, "name",
+		     "monitor in cgroup name only",
+		     parse_cgroups),
 	OPT_END()
 };
 
@@ -908,6 +922,9 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		write_mode = WRITE_FORCE;
 	}
 
+	if (nr_cgroups && !system_wide)
+		usage_with_options(record_usage, record_options);
+
 	symbol__init();
 	if (no_buildid)
 		disable_buildid_cache();
@@ -918,6 +935,9 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		attrs[0].config = PERF_COUNT_HW_CPU_CYCLES;
 	}
 
+	if (open_cgroups())
+		usage_with_options(record_usage, record_options);
+
 	if (target_pid != -1) {
 		target_tid = target_pid;
 		thread_num = find_all_tid(target_pid, &all_tids);
@@ -927,6 +947,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 			usage_with_options(record_usage, record_options);
 		}
 	} else {
+		err = -ENOMEM;
 		all_tids=malloc(sizeof(pid_t));
 		if (!all_tids)
 			goto out_symbol_exit;
@@ -978,5 +999,6 @@ out_free_fd:
 	all_tids = NULL;
 out_symbol_exit:
 	symbol__exit();
+	close_cgroups();
 	return err;
 }
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a6b4d44..2907937 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -47,6 +47,7 @@
 #include "util/header.h"
 #include "util/cpumap.h"
 #include "util/thread.h"
+#include "util/cgroup.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -151,6 +152,8 @@ struct stats			runtime_branches_stats;
 static int create_perf_stat_counter(int counter)
 {
 	struct perf_event_attr *attr = attrs + counter;
+	unsigned long flags = 0;
+	int pid = -1;
 	int thread;
 	int ncreated = 0;
 
@@ -161,9 +164,13 @@ static int create_perf_stat_counter(int counter)
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
 			if (fd[cpu][counter][0] < 0)
 				pr_debug(ERR_PERF_OPEN, counter,
 					 fd[cpu][counter][0], strerror(errno));
@@ -398,6 +405,9 @@ static void abs_printout(int counter, double avg)
 	else
 		fprintf(stderr, " %18.0f  %-24s", avg, event_name(counter));
 
+	if (cgroups[counter])
+		fprintf(stderr, " %s", cgroups[counter]);
+
 	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
 		total = avg_stats(&runtime_cycles_stats);
 
@@ -433,8 +443,13 @@ static void print_counter(int counter)
 	int scaled = event_scaled[counter];
 
 	if (scaled == -1) {
-		fprintf(stderr, " %18s  %-24s\n",
+		fprintf(stderr, " %18s  %-24s",
 			"<not counted>", event_name(counter));
+
+		if (cgroups[counter])
+			fprintf(stderr, " %s", cgroups[counter]);
+
+		fprintf(stderr, "\n");
 		return;
 	}
 
@@ -454,7 +469,6 @@ static void print_counter(int counter)
 		fprintf(stderr, "  (scaled from %.2f%%)",
 				100 * avg_running / avg_enabled);
 	}
-
 	fprintf(stderr, "\n");
 }
 
@@ -545,6 +559,9 @@ static const struct option options[] = {
 		    "print large numbers with thousands\' separators"),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu",
 		    "list of cpus to monitor in system-wide"),
+	OPT_CALLBACK('G', "cgroup", NULL, "name",
+		     "monitor in cgroup name only",
+		     parse_cgroups),
 	OPT_END()
 };
 
@@ -562,10 +579,23 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
+	if (nr_cgroups && !system_wide)
+		usage_with_options(stat_usage, options);
+
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
@@ -612,6 +642,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
 
+	if (open_cgroups())
+		usage_with_options(stat_usage, options);
+
 	status = 0;
 	for (run_idx = 0; run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
@@ -622,5 +655,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
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
