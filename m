Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1BPNro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:47:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:39975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1BPNrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:47:42 -0500
Date: Wed, 16 Feb 2011 13:47:12 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4d590290.825bdf0a.7d0a.4890@mx.google.com>
References: <4d590290.825bdf0a.7d0a.4890@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tool: Add cgroup support
Message-ID: <tip-023695d96ee06f36cf5014e286edcd623e9fb847@git.kernel.org>
Git-Commit-ID: 023695d96ee06f36cf5014e286edcd623e9fb847
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 13:47:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  023695d96ee06f36cf5014e286edcd623e9fb847
Gitweb:     http://git.kernel.org/tip/023695d96ee06f36cf5014e286edcd623e9fb847
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 14 Feb 2011 11:20:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 13:30:48 +0100

perf tool: Add cgroup support

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4d590290.825bdf0a.7d0a.4890@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-record.txt |   11 ++
 tools/perf/Documentation/perf-stat.txt   |   11 ++
 tools/perf/Makefile                      |    2 +
 tools/perf/builtin-record.c              |    9 ++
 tools/perf/builtin-stat.c                |   40 ++++++--
 tools/perf/util/cgroup.c                 |  178 ++++++++++++++++++++++++++++++
 tools/perf/util/cgroup.h                 |   17 +++
 tools/perf/util/evsel.c                  |   16 +++-
 tools/perf/util/evsel.h                  |    2 +
 9 files changed, 276 insertions(+), 10 deletions(-)

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
index 94f73ab..bc4d9bf 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -442,6 +442,7 @@ LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
+LIB_H += util/cgroup.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -496,6 +497,7 @@ LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/util.o
 LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
+LIB_OBJS += $(OUTPUT)util/cgroup.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 12e0e41..a4aaadc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -807,6 +807,9 @@ const struct option record_options[] = {
 		    "do not update the buildid cache"),
 	OPT_BOOLEAN('B', "no-buildid", &no_buildid,
 		    "do not collect buildids in perf.data"),
+	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
+		     "monitor event in cgroup name only",
+		     parse_cgroups),
 	OPT_END()
 };
 
@@ -835,6 +838,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
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
index 806a999..21c0252 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -390,6 +390,9 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 	fprintf(stderr, fmt, cpustr, msecs, csv_sep, event_name(evsel));
 
+	if (evsel->cgrp)
+		fprintf(stderr, "%s%s", csv_sep, evsel->cgrp->name);
+
 	if (csv_output)
 		return;
 
@@ -420,6 +423,9 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 	fprintf(stderr, fmt, cpustr, avg, csv_sep, event_name(evsel));
 
+	if (evsel->cgrp)
+		fprintf(stderr, "%s%s", csv_sep, evsel->cgrp->name);
+
 	if (csv_output)
 		return;
 
@@ -460,9 +466,17 @@ static void print_counter_aggr(struct perf_evsel *counter)
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
 
@@ -487,7 +501,6 @@ static void print_counter_aggr(struct perf_evsel *counter)
 		fprintf(stderr, "  (scaled from %.2f%%)",
 				100 * avg_running / avg_enabled);
 	}
-
 	fprintf(stderr, "\n");
 }
 
@@ -505,14 +518,18 @@ static void print_counter(struct perf_evsel *counter)
 		ena = counter->counts->cpu[cpu].ena;
 		run = counter->counts->cpu[cpu].run;
 		if (run == 0 || ena == 0) {
-			fprintf(stderr, "CPU%*d%s%*s%s%-24s",
+			fprintf(stderr, "CPU%*d%s%*s%s%*s",
 				csv_output ? 0 : -4,
 				evsel_list->cpus->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
 				"<not counted>", csv_sep,
+				csv_output ? 0 : -24,
 				event_name(counter));
 
-			fprintf(stderr, "\n");
+			if (counter->cgrp)
+				fprintf(stderr, "%s%s", csv_sep, counter->cgrp->name);
+
+			fputc('\n', stderr);
 			continue;
 		}
 
@@ -529,7 +546,7 @@ static void print_counter(struct perf_evsel *counter)
 					100.0 * run / ena);
 			}
 		}
-		fprintf(stderr, "\n");
+		fputc('\n', stderr);
 	}
 }
 
@@ -642,6 +659,9 @@ static const struct option options[] = {
 		    "disable CPU count aggregation"),
 	OPT_STRING('x', "field-separator", &csv_sep, "separator",
 		   "print counts with custom separator"),
+	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
+		     "monitor event in cgroup name only",
+		     parse_cgroups),
 	OPT_END()
 };
 
@@ -682,9 +702,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
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
 	if (!null_run && !evsel_list->nr_entries) {
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
new file mode 100644
index 0000000..9fea755
--- /dev/null
+++ b/tools/perf/util/cgroup.c
@@ -0,0 +1,178 @@
+#include "util.h"
+#include "../perf.h"
+#include "parse-options.h"
+#include "evsel.h"
+#include "cgroup.h"
+#include "debugfs.h" /* MAX_PATH, STR() */
+#include "evlist.h"
+
+int nr_cgroups;
+
+static int
+cgroupfs_find_mountpoint(char *buf, size_t maxlen)
+{
+	FILE *fp;
+	char mountpoint[MAX_PATH+1], tokens[MAX_PATH+1], type[MAX_PATH+1];
+	char *token, *saved_ptr;
+	int found = 0;
+
+	fp = fopen("/proc/mounts", "r");
+	if (!fp)
+		return -1;
+
+	/*
+	 * in order to handle split hierarchy, we need to scan /proc/mounts
+	 * and inspect every cgroupfs mount point to find one that has
+	 * perf_event subsystem
+	 */
+	while (fscanf(fp, "%*s %"STR(MAX_PATH)"s %"STR(MAX_PATH)"s %"
+				STR(MAX_PATH)"s %*d %*d\n",
+				mountpoint, type, tokens) == 3) {
+
+		if (!strcmp(type, "cgroup")) {
+
+			token = strtok_r(tokens, ",", &saved_ptr);
+
+			while (token != NULL) {
+				if (!strcmp(token, "perf_event")) {
+					found = 1;
+					break;
+				}
+				token = strtok_r(NULL, ",", &saved_ptr);
+			}
+		}
+		if (found)
+			break;
+	}
+	fclose(fp);
+	if (!found)
+		return -1;
+
+	if (strlen(mountpoint) < maxlen) {
+		strcpy(buf, mountpoint);
+		return 0;
+	}
+	return -1;
+}
+
+static int open_cgroup(char *name)
+{
+	char path[MAX_PATH+1];
+	char mnt[MAX_PATH+1];
+	int fd;
+
+
+	if (cgroupfs_find_mountpoint(mnt, MAX_PATH+1))
+		return -1;
+
+	snprintf(path, MAX_PATH, "%s/%s", mnt, name);
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		fprintf(stderr, "no access to cgroup %s\n", path);
+
+	return fd;
+}
+
+static int add_cgroup(struct perf_evlist *evlist, char *str)
+{
+	struct perf_evsel *counter;
+	struct cgroup_sel *cgrp = NULL;
+	int n;
+	/*
+	 * check if cgrp is already defined, if so we reuse it
+	 */
+	list_for_each_entry(counter, &evlist->entries, node) {
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
+	list_for_each_entry(counter, &evlist->entries, node) {
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
+	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
+	const char *p, *e, *eos = str + strlen(str);
+	char *s;
+	int ret;
+
+	if (list_empty(&evlist->entries)) {
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
+			ret = add_cgroup(evlist, s);
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
index 211063e..c974e08 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -85,6 +85,7 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 void perf_evsel__delete(struct perf_evsel *evsel)
 {
 	perf_evsel__exit(evsel);
+	close_cgroup(evsel->cgrp);
 	free(evsel);
 }
 
@@ -163,21 +164,32 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads, bool group, bool inherit)
 {
 	int cpu, thread;
+	unsigned long flags = 0;
+	int pid = -1;
 
 	if (evsel->fd == NULL &&
 	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
 		return -1;
 
+	if (evsel->cgrp) {
+		flags = PERF_FLAG_PID_CGROUP;
+		pid = evsel->cgrp->fd;
+	}
+
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		int group_fd = -1;
 
 		evsel->attr.inherit = (cpus->map[cpu] < 0) && inherit;
 
 		for (thread = 0; thread < threads->nr; thread++) {
+
+			if (!evsel->cgrp)
+				pid = threads->map[thread];
+
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
-								     threads->map[thread],
+								     pid,
 								     cpus->map[cpu],
-								     group_fd, 0);
+								     group_fd, flags);
 			if (FD(evsel, cpu, thread) < 0)
 				goto out_close;
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index eecdc3a..1d3d5a3 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -6,6 +6,7 @@
 #include "../../../include/linux/perf_event.h"
 #include "types.h"
 #include "xyarray.h"
+#include "cgroup.h"
  
 struct perf_counts_values {
 	union {
@@ -45,6 +46,7 @@ struct perf_evsel {
 	struct perf_counts	*counts;
 	int			idx;
 	void			*priv;
+	struct cgroup_sel	*cgrp;
 };
 
 struct cpu_map;
