Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab0FBUks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:40:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:56079 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712Ab0FBUkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:40:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf tools: Add the ability to specify list of cpus to monitor
Date: Wed,  2 Jun 2010 17:40:13 -0300
Message-Id: <1275511215-25703-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1275511215-25703-1-git-send-email-acme@infradead.org>
References: <1275511215-25703-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch adds a -C option to stat, record, top to designate a list of CPUs to
monitor. CPUs can be specified as a comma-separated list or ranges, no space
allowed.

Examples:
$ perf record -a -C0-1,4-7 sleep 1
$ perf top -C0-4
$ perf stat -a -C1,2,3,4 sleep 1

With perf record in per-thread mode with inherit mode on, samples are collected
only when the thread runs on the designated CPUs.

The -C option does not turn on system-wide mode automatically.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <4bff9496.d345d80a.41fe.7b00@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt |    7 ++++
 tools/perf/Documentation/perf-stat.txt   |    7 ++++
 tools/perf/Documentation/perf-top.txt    |    8 +++--
 tools/perf/builtin-record.c              |   23 +++++++-----
 tools/perf/builtin-stat.c                |   14 +++++--
 tools/perf/builtin-top.c                 |   16 +++++---
 tools/perf/util/cpumap.c                 |   57 +++++++++++++++++++++++++++++-
 tools/perf/util/cpumap.h                 |    2 +-
 8 files changed, 110 insertions(+), 24 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 34e255f..25576b4 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -103,6 +103,13 @@ OPTIONS
 --raw-samples::
 Collect raw sample records from all opened counters (default for tracepoint counters).
 
+-C::
+--cpu::
+Collect samples only on the list of cpus provided. Multiple CPUs can be provided as a
+comma-sperated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2.
+In per-thread mode with inheritance mode on (default), samples are captured only when
+the thread executes on the designated CPUs. Default is to monitor all CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 909fa76..4b3a2d4 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -46,6 +46,13 @@ OPTIONS
 -B::
         print large numbers with thousands' separators according to locale
 
+-C::
+--cpu=::
+Count only on the list of cpus provided. Multiple CPUs can be provided as a
+comma-sperated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2.
+In per-thread mode, this option is ignored. The -a option is still necessary
+to activate system-wide monitoring. Default is to count on all CPUs.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 785b9fc..1f96876 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -25,9 +25,11 @@ OPTIONS
 --count=<count>::
 	Event period to sample.
 
--C <cpu>::
---CPU=<cpu>::
-	CPU to profile.
+-C <cpu-list>::
+--cpu=<cpu>::
+Monitor only on the list of cpus provided. Multiple CPUs can be provided as a
+comma-sperated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2.
+Default is to monitor all CPUS.
 
 -d <seconds>::
 --delay=<seconds>::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9bc8905..e52023b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -49,7 +49,6 @@ static int			group				=      0;
 static int			realtime_prio			=      0;
 static bool			raw_samples			=  false;
 static bool			system_wide			=  false;
-static int			profile_cpu			=     -1;
 static pid_t			target_pid			=     -1;
 static pid_t			target_tid			=     -1;
 static pid_t			*all_tids			=      NULL;
@@ -74,6 +73,7 @@ static int			file_new			=      1;
 static off_t			post_processing_offset;
 
 static struct perf_session	*session;
+static const char		*cpu_list;
 
 struct mmap_data {
 	int			counter;
@@ -300,7 +300,7 @@ try_again:
 				die("Permission error - are you root?\n"
 					"\t Consider tweaking"
 					" /proc/sys/kernel/perf_event_paranoid.\n");
-			else if (err ==  ENODEV && profile_cpu != -1) {
+			else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
 			}
@@ -623,10 +623,15 @@ static int __cmd_record(int argc, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
-	if ((!system_wide && no_inherit) || profile_cpu != -1) {
-		open_counters(profile_cpu);
+	nr_cpus = read_cpu_map(cpu_list);
+	if (nr_cpus < 1) {
+		perror("failed to collect number of CPUs\n");
+		return -1;
+	}
+
+	if (!system_wide && no_inherit && !cpu_list) {
+		open_counters(-1);
 	} else {
-		nr_cpus = read_cpu_map();
 		for (i = 0; i < nr_cpus; i++)
 			open_counters(cpumap[i]);
 	}
@@ -705,7 +710,7 @@ static int __cmd_record(int argc, const char **argv)
 	if (perf_guest)
 		perf_session__process_machines(session, event__synthesize_guest_os);
 
-	if (!system_wide && profile_cpu == -1)
+	if (!system_wide && cpu_list)
 		event__synthesize_thread(target_tid, process_synthesized_event,
 					 session);
 	else
@@ -795,8 +800,8 @@ static const struct option options[] = {
 			    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('A', "append", &append_file,
 			    "append to the output file to do incremental profiling"),
-	OPT_INTEGER('C', "profile_cpu", &profile_cpu,
-			    "CPU to profile on"),
+	OPT_STRING('C', "cpu", &cpu_list, "cpu",
+		    "list of cpus to monitor"),
 	OPT_BOOLEAN('f', "force", &force,
 			"overwrite existing data file (deprecated)"),
 	OPT_U64('c', "count", &user_interval, "event period to sample"),
@@ -826,7 +831,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	argc = parse_options(argc, argv, options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target_pid == -1 && target_tid == -1 &&
-		!system_wide && profile_cpu == -1)
+		!system_wide && !cpu_list)
 		usage_with_options(record_usage, options);
 
 	if (force && append_file) {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9a39ca3..a6b4d44 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -69,7 +69,7 @@ static struct perf_event_attr default_attrs[] = {
 };
 
 static bool			system_wide			=  false;
-static unsigned int		nr_cpus				=  0;
+static int			nr_cpus				=  0;
 static int			run_idx				=  0;
 
 static int			run_count			=  1;
@@ -82,6 +82,7 @@ static int			thread_num			=  0;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static bool			big_num				=  false;
+static const char		*cpu_list;
 
 
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
@@ -158,7 +159,7 @@ static int create_perf_stat_counter(int counter)
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide) {
-		unsigned int cpu;
+		int cpu;
 
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
 			fd[cpu][counter][0] = sys_perf_event_open(attr,
@@ -208,7 +209,7 @@ static inline int nsec_counter(int counter)
 static void read_counter(int counter)
 {
 	u64 count[3], single_count[3];
-	unsigned int cpu;
+	int cpu;
 	size_t res, nv;
 	int scaled;
 	int i, thread;
@@ -542,6 +543,8 @@ static const struct option options[] = {
 		    "null run - dont start any counters"),
 	OPT_BOOLEAN('B', "big-num", &big_num,
 		    "print large numbers with thousands\' separators"),
+	OPT_STRING('C', "cpu", &cpu_list, "cpu",
+		    "list of cpus to monitor in system-wide"),
 	OPT_END()
 };
 
@@ -566,10 +569,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (system_wide)
-		nr_cpus = read_cpu_map();
+		nr_cpus = read_cpu_map(cpu_list);
 	else
 		nr_cpus = 1;
 
+	if (nr_cpus < 1)
+		usage_with_options(stat_usage, options);
+
 	if (target_pid != -1) {
 		target_tid = target_pid;
 		thread_num = find_all_tid(target_pid, &all_tids);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a66f427..45014ef 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -102,6 +102,7 @@ struct sym_entry		*sym_filter_entry_sched		=   NULL;
 static int			sym_pcnt_filter			=      5;
 static int			sym_counter			=      0;
 static int			display_weighted		=     -1;
+static const char		*cpu_list;
 
 /*
  * Symbols
@@ -1351,8 +1352,8 @@ static const struct option options[] = {
 		    "profile events on existing thread id"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 			    "system-wide collection from all CPUs"),
-	OPT_INTEGER('C', "CPU", &profile_cpu,
-		    "CPU to profile on"),
+	OPT_STRING('C', "cpu", &cpu_list, "cpu",
+		    "list of cpus to monitor"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 	OPT_BOOLEAN('K', "hide_kernel_symbols", &hide_kernel_symbols,
@@ -1428,10 +1429,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		return -ENOMEM;
 
 	/* CPU and PID are mutually exclusive */
-	if (target_tid > 0 && profile_cpu != -1) {
+	if (target_tid > 0 && cpu_list) {
 		printf("WARNING: PID switch overriding CPU\n");
 		sleep(1);
-		profile_cpu = -1;
+		cpu_list = NULL;
 	}
 
 	if (!nr_counters)
@@ -1469,10 +1470,13 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		attrs[counter].sample_period = default_interval;
 	}
 
-	if (target_tid != -1 || profile_cpu != -1)
+	if (target_tid != -1)
 		nr_cpus = 1;
 	else
-		nr_cpus = read_cpu_map();
+		nr_cpus = read_cpu_map(cpu_list);
+
+	if (nr_cpus < 1)
+		usage_with_options(top_usage, options);
 
 	get_term_dimensions(&winsize);
 	if (print_entries == 0) {
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 4e01490..0f9b8d7 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -20,7 +20,7 @@ static int default_cpu_map(void)
 	return nr_cpus;
 }
 
-int read_cpu_map(void)
+static int read_all_cpu_map(void)
 {
 	FILE *onlnf;
 	int nr_cpus = 0;
@@ -57,3 +57,58 @@ int read_cpu_map(void)
 
 	return default_cpu_map();
 }
+
+int read_cpu_map(const char *cpu_list)
+{
+	unsigned long start_cpu, end_cpu = 0;
+	char *p = NULL;
+	int i, nr_cpus = 0;
+
+	if (!cpu_list)
+		return read_all_cpu_map();
+
+	if (!isdigit(*cpu_list))
+		goto invalid;
+
+	while (isdigit(*cpu_list)) {
+		p = NULL;
+		start_cpu = strtoul(cpu_list, &p, 0);
+		if (start_cpu >= INT_MAX
+		    || (*p != '\0' && *p != ',' && *p != '-'))
+			goto invalid;
+
+		if (*p == '-') {
+			cpu_list = ++p;
+			p = NULL;
+			end_cpu = strtoul(cpu_list, &p, 0);
+
+			if (end_cpu >= INT_MAX || (*p != '\0' && *p != ','))
+				goto invalid;
+
+			if (end_cpu < start_cpu)
+				goto invalid;
+		} else {
+			end_cpu = start_cpu;
+		}
+
+		for (; start_cpu <= end_cpu; start_cpu++) {
+			/* check for duplicates */
+			for (i = 0; i < nr_cpus; i++)
+				if (cpumap[i] == (int)start_cpu)
+					goto invalid;
+
+			assert(nr_cpus < MAX_NR_CPUS);
+			cpumap[nr_cpus++] = (int)start_cpu;
+		}
+		if (*p)
+			++p;
+
+		cpu_list = p;
+	}
+	if (nr_cpus > 0)
+		return nr_cpus;
+
+	return default_cpu_map();
+invalid:
+	return -1;
+}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 86c78bb..3e60f56 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_CPUMAP_H
 #define __PERF_CPUMAP_H
 
-extern int read_cpu_map(void);
+extern int read_cpu_map(const char *cpu_list);
 extern int cpumap[];
 
 #endif /* __PERF_CPUMAP_H */
-- 
1.6.2.5

