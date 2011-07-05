Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1GEM43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:56:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:59466 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab1GEM41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:56:27 -0400
Date: Tue, 5 Jul 2011 12:56:00 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Message-ID: <tip-5d67be97f8903d05ce53597fb5f3bc25a45e8026@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, anton@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110704215750.11647eb9@kryten>
References: <20110704215750.11647eb9@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report/annotate/script: Add option to specify a CPU range
Git-Commit-ID: 5d67be97f8903d05ce53597fb5f3bc25a45e8026
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:56:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d67be97f8903d05ce53597fb5f3bc25a45e8026
Gitweb:     http://git.kernel.org/tip/5d67be97f8903d05ce53597fb5f3bc25a45e8026
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Mon, 4 Jul 2011 21:57:50 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 Jul 2011 10:44:44 +0200

perf report/annotate/script: Add option to specify a CPU range

Add an option to perf report/annotate/script to specify which
CPUs to operate on. This enables us to take a single system wide
profile and analyse each CPU (or group of CPUs) in isolation.

This was useful when profiling a multiprocess workload where the
bottleneck was on one CPU but this was hidden in the overall
profile. Per process and per thread breakdowns didn't help
because multiple processes were running on each CPU and no
single process consumed an entire CPU.

The patch converts the list of CPUs returned by cpu_map__new
into a bitmap for fast lookup. I wanted to use -C to be
consistent with perf top/record/stat, but unfortunately perf
report already uses -C <comms>.

 v2: Incorporate suggestions from David Ahern:
	- Added -c to perf script
	- Check that SAMPLE_CPU is set when -c is used
	- Update documentation

 v3: Create perf_session__cpu_bitmap()

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Link: http://lkml.kernel.org/r/20110704215750.11647eb9@kryten
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-annotate.txt |    6 ++++
 tools/perf/Documentation/perf-report.txt   |    6 ++++
 tools/perf/Documentation/perf-script.txt   |    6 ++++
 tools/perf/builtin-annotate.c              |   15 +++++++++++
 tools/perf/builtin-report.c                |   15 +++++++++++
 tools/perf/builtin-script.c                |   13 +++++++++
 tools/perf/util/session.c                  |   38 ++++++++++++++++++++++++++++
 tools/perf/util/session.h                  |    3 ++
 8 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 6f5a498..85c5f02 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -66,6 +66,12 @@ OPTIONS
 	used. This interfaces starts by centering on the line with more
 	samples, TAB/UNTAB cycles through the lines with more samples.
 
+-c::
+--cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
+	be provided as a comma-separated list with no space: 0,1. Ranges of
+	CPUs are specified with -: 0-2. Default is to report samples on all
+	CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index cfa8e51..04253c0 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -128,6 +128,12 @@ OPTIONS
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
 
+-c::
+--cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
+	be provided as a comma-separated list with no space: 0,1. Ranges of
+	CPUs are specified with -: 0-2. Default is to report samples on all
+	CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index c6068cb..db01786 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -182,6 +182,12 @@ OPTIONS
 --hide-call-graph::
         When printing symbols do not display call chain.
 
+-c::
+--cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
+	be provided as a comma-separated list with no space: 0,1. Ranges of
+	CPUs are specified with -: 0-2. Default is to report samples on all
+	CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 7b139e1..555aefd 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -28,6 +28,8 @@
 #include "util/hist.h"
 #include "util/session.h"
 
+#include <linux/bitmap.h>
+
 static char		const *input_name = "perf.data";
 
 static bool		force, use_tui, use_stdio;
@@ -38,6 +40,9 @@ static bool		print_line;
 
 static const char *sym_hist_filter;
 
+static const char	*cpu_list;
+static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+
 static int perf_evlist__add_sample(struct perf_evlist *evlist,
 				   struct perf_sample *sample,
 				   struct perf_evsel *evsel,
@@ -90,6 +95,9 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
+	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+		return 0;
+
 	if (!al.filtered &&
 	    perf_evlist__add_sample(session->evlist, sample, evsel, &al)) {
 		pr_warning("problem incrementing symbol count, "
@@ -177,6 +185,12 @@ static int __cmd_annotate(void)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (cpu_list) {
+		ret = perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap);
+		if (ret)
+			goto out_delete;
+	}
+
 	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
@@ -252,6 +266,7 @@ static const struct option options[] = {
 		    "print matching source lines (may be slow)"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the displayed pathnames"),
+	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5d43d01..f854efd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -33,6 +33,8 @@
 #include "util/sort.h"
 #include "util/hist.h"
 
+#include <linux/bitmap.h>
+
 static char		const *input_name = "perf.data";
 
 static bool		force, use_tui, use_stdio;
@@ -49,6 +51,9 @@ static char		callchain_default_opt[] = "fractal,0.5,callee";
 static bool		inverted_callchain;
 static symbol_filter_t	annotate_init;
 
+static const char	*cpu_list;
+static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+
 static int perf_session__add_hist_entry(struct perf_session *session,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -117,6 +122,9 @@ static int process_sample_event(union perf_event *event,
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
+	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+		return 0;
+
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
@@ -263,6 +271,12 @@ static int __cmd_report(void)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (cpu_list) {
+		ret = perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap);
+		if (ret)
+			goto out_delete;
+	}
+
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
@@ -473,6 +487,7 @@ static const struct option options[] = {
 		    "Only display entries resolved to a symbol"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
+	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 3056b45..09024ec 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -13,6 +13,7 @@
 #include "util/util.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
+#include <linux/bitmap.h>
 
 static char const		*script_name;
 static char const		*generate_script_lang;
@@ -21,6 +22,8 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
+static const char		*cpu_list;
+static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
 enum perf_output_field {
 	PERF_OUTPUT_COMM            = 1U << 0,
@@ -453,6 +456,10 @@ static int process_sample_event(union perf_event *event,
 		last_timestamp = sample->time;
 		return 0;
 	}
+
+	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+		return 0;
+
 	scripting_ops->process_event(event, sample, evsel, session, thread);
 
 	session->hists.stats.total_period += sample->period;
@@ -1075,6 +1082,7 @@ static const struct option options[] = {
 	OPT_CALLBACK('f', "fields", NULL, "str",
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
+	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 
 	OPT_END()
 };
@@ -1255,6 +1263,11 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (cpu_list) {
+		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
+			return -1;
+	}
+
 	if (!no_callchain)
 		symbol_conf.use_callchain = true;
 	else
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 558bcf9..080e533 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -12,6 +12,7 @@
 #include "session.h"
 #include "sort.h"
 #include "util.h"
+#include "cpumap.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -1282,3 +1283,40 @@ void perf_session__print_ip(union perf_event *event,
 		}
 	}
 }
+
+int perf_session__cpu_bitmap(struct perf_session *session,
+			     const char *cpu_list, unsigned long *cpu_bitmap)
+{
+	int i;
+	struct cpu_map *map;
+
+	for (i = 0; i < PERF_TYPE_MAX; ++i) {
+		struct perf_evsel *evsel;
+
+		evsel = perf_session__find_first_evtype(session, i);
+		if (!evsel)
+			continue;
+
+		if (!(evsel->attr.sample_type & PERF_SAMPLE_CPU)) {
+			pr_err("File does not contain CPU events. "
+			       "Remove -c option to proceed.\n");
+			return -1;
+		}
+	}
+
+	map = cpu_map__new(cpu_list);
+
+	for (i = 0; i < map->nr; i++) {
+		int cpu = map->map[i];
+
+		if (cpu >= MAX_NR_CPUS) {
+			pr_err("Requested CPU %d too large. "
+			       "Consider raising MAX_NR_CPUS\n", cpu);
+			return -1;
+		}
+
+		set_bit(cpu, cpu_bitmap);
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index de4178d..5de754f 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -172,4 +172,7 @@ void perf_session__print_ip(union perf_event *event,
 				 struct perf_session *session,
 				 int print_sym, int print_dso);
 
+int perf_session__cpu_bitmap(struct perf_session *session,
+			     const char *cpu_list, unsigned long *cpu_bitmap);
+
 #endif /* __PERF_SESSION_H */
