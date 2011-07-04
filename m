Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1GDL57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:57:59 -0400
Received: from ozlabs.org ([203.10.76.45]:56357 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1GDL5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:57:53 -0400
Date: Mon, 4 Jul 2011 21:57:50 +1000
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf report/annotate/script: Add option to specify a CPU
 range
Message-ID: <20110704215750.11647eb9@kryten>
In-Reply-To: <20110701111641.GE20990@elte.hu>
References: <20110629150739.49b25604@kryten>
	<4E0B69EC.70009@gmail.com>
	<20110630131639.253c6529@kryten>
	<4E0BF3D0.4010405@gmail.com>
	<20110701111641.GE20990@elte.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add an option to perf report/annotate/script to specify which CPUs
to operate on. This enables us to take a single system wide profile
and analyse each CPU (or group of CPUs) in isolation.

This was useful when profiling a multiprocess workload where the
bottleneck was on one CPU but this was hidden in the overall profile.
Per process and per thread breakdowns didn't help because multiple
processes were running on each CPU and no single process consumed
an entire CPU.

The patch converts the list of CPUs returned by cpu_map__new into a
bitmap for fast lookup. I wanted to use -C to be consistent with perf
top/record/stat, but unfortunately perf report already uses -C <comms>.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

v2: Incorporate suggestions from David Ahern:
	- Added -c to perf script
	- Check that SAMPLE_CPU is set when -c is used
	- Update documentation

v3: Create perf_session__cpu_bitmap

Index: linux-2.6-tip/tools/perf/builtin-report.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/builtin-report.c	2011-07-04 21:18:57.309390814 +1000
+++ linux-2.6-tip/tools/perf/builtin-report.c	2011-07-04 21:30:25.341547527 +1000
@@ -33,6 +33,8 @@
 #include "util/sort.h"
 #include "util/hist.h"
 
+#include <linux/bitmap.h>
+
 static char		const *input_name = "perf.data";
 
 static bool		force, use_tui, use_stdio;
@@ -49,6 +51,9 @@ static char		callchain_default_opt[] = "
 static bool		inverted_callchain;
 static symbol_filter_t	annotate_init;
 
+static const char	*cpu_list;
+static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+
 static int perf_session__add_hist_entry(struct perf_session *session,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -117,6 +122,9 @@ static int process_sample_event(union pe
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
 
Index: linux-2.6-tip/tools/perf/builtin-annotate.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/builtin-annotate.c	2011-07-04 21:08:03.877843210 +1000
+++ linux-2.6-tip/tools/perf/builtin-annotate.c	2011-07-04 21:30:07.151226616 +1000
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
@@ -90,6 +95,9 @@ static int process_sample_event(union pe
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
 
Index: linux-2.6-tip/tools/perf/builtin-script.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/builtin-script.c	2011-07-04 21:08:03.887843387 +1000
+++ linux-2.6-tip/tools/perf/builtin-script.c	2011-07-04 21:31:11.822367589 +1000
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
@@ -453,6 +456,10 @@ static int process_sample_event(union pe
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
@@ -1255,6 +1263,11 @@ int cmd_script(int argc, const char **ar
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
Index: linux-2.6-tip/tools/perf/Documentation/perf-annotate.txt
===================================================================
--- linux-2.6-tip.orig/tools/perf/Documentation/perf-annotate.txt	2011-07-04 21:08:03.927844094 +1000
+++ linux-2.6-tip/tools/perf/Documentation/perf-annotate.txt	2011-07-04 21:20:14.160749659 +1000
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
Index: linux-2.6-tip/tools/perf/Documentation/perf-report.txt
===================================================================
--- linux-2.6-tip.orig/tools/perf/Documentation/perf-report.txt	2011-07-04 21:18:57.309390814 +1000
+++ linux-2.6-tip/tools/perf/Documentation/perf-report.txt	2011-07-04 21:20:14.160749659 +1000
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
Index: linux-2.6-tip/tools/perf/Documentation/perf-script.txt
===================================================================
--- linux-2.6-tip.orig/tools/perf/Documentation/perf-script.txt	2011-07-04 21:08:03.907843741 +1000
+++ linux-2.6-tip/tools/perf/Documentation/perf-script.txt	2011-07-04 21:20:14.160749659 +1000
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
Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c	2011-07-04 21:21:01.901593861 +1000
+++ linux-2.6-tip/tools/perf/util/session.c	2011-07-04 21:32:09.443384298 +1000
@@ -12,6 +12,7 @@
 #include "session.h"
 #include "sort.h"
 #include "util.h"
+#include "cpumap.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -1282,3 +1283,40 @@ void perf_session__print_ip(union perf_e
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
Index: linux-2.6-tip/tools/perf/util/session.h
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.h	2011-07-04 21:21:01.921594213 +1000
+++ linux-2.6-tip/tools/perf/util/session.h	2011-07-04 21:32:21.253592699 +1000
@@ -172,4 +172,7 @@ void perf_session__print_ip(union perf_e
 				 struct perf_session *session,
 				 int print_sym, int print_dso);
 
+int perf_session__cpu_bitmap(struct perf_session *session,
+			     const char *cpu_list, unsigned long *cpu_bitmap);
+
 #endif /* __PERF_SESSION_H */
