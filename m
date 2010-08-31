Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0HaPcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:32:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47669 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545Ab0HaPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:32:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=TQRr0glBHpnJoyNDdcYjdnbq+52/wuB2mbH086GsYoOhj9H9tf17iiFcG7CrxBVzr
	pqmUSWJJX8nSKHOoPlqow==
Message-ID: <4c7d207c.8eecd80a.6e3a.2dd6@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 31 Aug 2010 17:25:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com
Subject: [RFC PATCH 2/2] perf_events: add support for per-cpu per-cgroup monitoring
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This perf tool patch adds the ability to filter monitoring based on container
groups (cgroups) for both perf stat and perf record. The cgroup to monitor are
passed via a new -G option followed by a list of cgroups.

The cgroup filesystem has to be mounted. The tool will find it automatically,
open the right file and pass the descriptor to perf_events.

Example:
$ perf stat -a -e cycles:u -G test1 -- sleep 1
Performance counter stats for 'sleep 1':
	9528573157  cycles                   test1  (scaled from 24.97%)
       1.001702426  seconds time elapsed

The option is specified per event. It is possible to monitor different
cgroups in one run:
    
        $ perf stat -a -e cycles:u,cycles:u -G test1,test2 -- sleep 1
        Performance counter stats for 'sleep 1':
                9528573157  cycles                   test1  (scaled from 24.97%)
                9528574010  cycles                   test2  (scaled from 24.97%)
               1.001702426  seconds time elapsed
    
Signed-off-by: Stephane Eranian <eranian@google.com>
--

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 3ee27dc..0f9b8c8 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -116,6 +116,12 @@ Do not update the builid cache. This saves some overhead in situations
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
index fe1e307..9f670e7 100644
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
index ff77b80..604124e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -22,6 +22,7 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/cpumap.h"
+#include "util/cgroup.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -286,6 +287,11 @@ static void create_counter(int counter, int cpu)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (cgroups[counter]) {
+		attr->cgroup = 1;
+		attr->cgroup_fd = cgroups_fd[counter];
+	}
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= !no_inherit;
@@ -828,6 +834,9 @@ static const struct option options[] = {
 		    "don't sample"),
 	OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid,
 		    "do not update the buildid cache"),
+	OPT_CALLBACK('G', "cgroup", NULL, "name",
+		     "monitor in cgroup name only",
+		     parse_cgroups),
 	OPT_END()
 };
 
@@ -851,6 +860,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		write_mode = WRITE_FORCE;
 	}
 
+	if (nr_cgroups && !system_wide)
+		usage_with_options(record_usage, options);
+
+	if (open_cgroups())
+		usage_with_options(record_usage, options);
+
 	symbol__init();
 	if (no_buildid)
 		disable_buildid_cache();
@@ -870,6 +885,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 			usage_with_options(record_usage, options);
 		}
 	} else {
+		err = -ENOMEM;
 		all_tids=malloc(sizeof(pid_t));
 		if (!all_tids)
 			goto out_symbol_exit;
@@ -921,5 +937,6 @@ out_free_fd:
 	all_tids = NULL;
 out_symbol_exit:
 	symbol__exit();
+	close_cgroups();
 	return err;
 }
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a6b4d44..97c4284 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -47,6 +47,7 @@
 #include "util/header.h"
 #include "util/cpumap.h"
 #include "util/thread.h"
+#include "util/cgroup.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -161,6 +162,11 @@ static int create_perf_stat_counter(int counter)
 	if (system_wide) {
 		int cpu;
 
+		if (cgroups[counter]) {
+			attr->cgroup = 1;
+			attr->cgroup_fd = cgroups_fd[counter];
+		}
+
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
 			fd[cpu][counter][0] = sys_perf_event_open(attr,
 					-1, cpumap[cpu], -1, 0);
@@ -433,8 +439,13 @@ static void print_counter(int counter)
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
 
@@ -445,6 +456,9 @@ static void print_counter(int counter)
 
 	print_noise(counter, avg);
 
+	if (cgroups[counter])
+		fprintf(stderr, " %s", cgroups[counter]);
+
 	if (scaled) {
 		double avg_enabled, avg_running;
 
@@ -454,7 +468,6 @@ static void print_counter(int counter)
 		fprintf(stderr, "  (scaled from %.2f%%)",
 				100 * avg_running / avg_enabled);
 	}
-
 	fprintf(stderr, "\n");
 }
 
@@ -545,6 +558,9 @@ static const struct option options[] = {
 		    "print large numbers with thousands\' separators"),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu",
 		    "list of cpus to monitor in system-wide"),
+	OPT_CALLBACK('G', "cgroup", NULL, "name",
+		     "monitor in cgroup name only",
+		     parse_cgroups),
 	OPT_END()
 };
 
@@ -562,6 +578,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
+	if (nr_cgroups && !system_wide)
+		usage_with_options(stat_usage, options);
+
 	/* Set attrs and nr_counters if no event is selected and !null_run */
 	if (!null_run && !nr_counters) {
 		memcpy(attrs, default_attrs, sizeof(default_attrs));
@@ -612,6 +631,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
 
+	if (open_cgroups())
+		usage_with_options(stat_usage, options);
+
 	status = 0;
 	for (run_idx = 0; run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
@@ -622,5 +644,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (status != -1)
 		print_stat(argc, argv);
 
+	close_cgroups();
+
 	return status;
 }
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
new file mode 100644
index 0000000..eb76b31
--- /dev/null
+++ b/tools/perf/util/cgroup.c
@@ -0,0 +1,119 @@
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
+		snprintf(path, MAX_PATH, "%s/%s/perf_event.perf",
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
+		close(cgroups_fd[i]);
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
+		} else
+			cgroups[n] = NULL;
+		n++;
+		if (!p)
+			break;
+		str = p+1;
+	}
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
