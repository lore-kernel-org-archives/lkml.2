Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab1F3DQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 23:16:49 -0400
Received: from ozlabs.org ([203.10.76.45]:49324 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130Ab1F3DQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 23:16:41 -0400
Date: Thu, 30 Jun 2011 13:16:39 +1000
From: Anton Blanchard <anton@samba.org>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf report/annotate: Add option to specify a CPU range
Message-ID: <20110630131639.253c6529@kryten>
In-Reply-To: <4E0B69EC.70009@gmail.com>
References: <20110629150739.49b25604@kryten>
	<4E0B69EC.70009@gmail.com>
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

Index: linux-2.6-tip/tools/perf/builtin-report.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/builtin-report.c	2011-06-30 11:35:08.488417534 +1000
+++ linux-2.6-tip/tools/perf/builtin-report.c	2011-06-30 12:56:28.894807631 +1000
@@ -33,6 +33,9 @@
 #include "util/sort.h"
 #include "util/hist.h"
 
+#include <linux/bitmap.h>
+#include "util/cpumap.h"
+
 static char		const *input_name = "perf.data";
 
 static bool		force, use_tui, use_stdio;
@@ -48,6 +51,9 @@ static const char	*pretty_printing_style
 static char		callchain_default_opt[] = "fractal,0.5";
 static symbol_filter_t	annotate_init;
 
+static const char	*cpu_list;
+static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+
 static int perf_session__add_hist_entry(struct perf_session *session,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -116,6 +122,9 @@ static int process_sample_event(union pe
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
+	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+		return 0;
+
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
@@ -262,6 +271,41 @@ static int __cmd_report(void)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (cpu_list) {
+		int i;
+		struct cpu_map *map;
+
+		for (i = 0; i < PERF_TYPE_MAX; ++i) {
+			struct perf_evsel *evsel;
+
+			evsel = perf_session__find_first_evtype(session, i);
+			if (!evsel)
+				continue;
+
+			if (!(evsel->attr.sample_type & PERF_SAMPLE_CPU)) {
+				pr_err("File does not contain CPU events. "
+				       "Remove -c option to proceed.\n");
+				ret = -1;
+				goto out_delete;
+			}
+		}
+
+		map = cpu_map__new(cpu_list);
+
+		for (i = 0; i < map->nr; i++) {
+			int cpu = map->map[i];
+
+			if (cpu >= MAX_NR_CPUS) {
+				pr_err("Requested CPU %d too large. "
+				       "Consider raising MAX_NR_CPUS\n", cpu);
+				ret = -1;
+				goto out_delete;
+			}
+
+			set_bit(cpu, cpu_bitmap);
+		}
+	}
+
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
@@ -455,6 +499,7 @@ static const struct option options[] = {
 		    "Only display entries resolved to a symbol"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
+	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_END()
 };
 
Index: linux-2.6-tip/tools/perf/builtin-annotate.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/builtin-annotate.c	2011-06-30 11:35:08.468417177 +1000
+++ linux-2.6-tip/tools/perf/builtin-annotate.c	2011-06-30 12:56:35.514926037 +1000
@@ -28,6 +28,9 @@
 #include "util/hist.h"
 #include "util/session.h"
 
+#include <linux/bitmap.h>
+#include "util/cpumap.h"
+
 static char		const *input_name = "perf.data";
 
 static bool		force, use_tui, use_stdio;
@@ -38,6 +41,9 @@ static bool		print_line;
 
 static const char *sym_hist_filter;
 
+static const char	*cpu_list;
+static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+
 static int perf_evlist__add_sample(struct perf_evlist *evlist,
 				   struct perf_sample *sample,
 				   struct perf_evsel *evsel,
@@ -90,6 +96,9 @@ static int process_sample_event(union pe
 		return -1;
 	}
 
+	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+		return 0;
+
 	if (!al.filtered &&
 	    perf_evlist__add_sample(session->evlist, sample, evsel, &al)) {
 		pr_warning("problem incrementing symbol count, "
@@ -177,6 +186,41 @@ static int __cmd_annotate(void)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (cpu_list) {
+		int i;
+		struct cpu_map *map;
+
+		for (i = 0; i < PERF_TYPE_MAX; ++i) {
+			struct perf_evsel *evsel;
+
+			evsel = perf_session__find_first_evtype(session, i);
+			if (!evsel)
+				continue;
+
+			if (!(evsel->attr.sample_type & PERF_SAMPLE_CPU)) {
+				pr_err("File does not contain CPU events. "
+				       "Remove -c option to proceed.\n");
+				ret = -1;
+				goto out_delete;
+			}
+		}
+
+		map = cpu_map__new(cpu_list);
+
+		for (i = 0; i < map->nr; i++) {
+			int cpu = map->map[i];
+
+			if (cpu >= MAX_NR_CPUS) {
+				pr_err("Requested CPU %d too large. "
+				       "Consider raising MAX_NR_CPUS\n", cpu);
+				ret = -1;
+				goto out_delete;
+			}
+
+			set_bit(cpu, cpu_bitmap);
+		}
+	}
+
 	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
@@ -252,6 +296,7 @@ static const struct option options[] = {
 		    "print matching source lines (may be slow)"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the displayed pathnames"),
+	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_END()
 };
 
Index: linux-2.6-tip/tools/perf/builtin-script.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/builtin-script.c	2011-06-30 11:35:08.478417356 +1000
+++ linux-2.6-tip/tools/perf/builtin-script.c	2011-06-30 12:56:44.185081104 +1000
@@ -13,6 +13,8 @@
 #include "util/util.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
+#include <linux/bitmap.h>
+#include "util/cpumap.h"
 
 static char const		*script_name;
 static char const		*generate_script_lang;
@@ -21,6 +23,8 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
+static const char		*cpu_list;
+static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
 enum perf_output_field {
 	PERF_OUTPUT_COMM            = 1U << 0,
@@ -453,6 +457,10 @@ static int process_sample_event(union pe
 		last_timestamp = sample->time;
 		return 0;
 	}
+
+	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+		return 0;
+
 	scripting_ops->process_event(event, sample, evsel, session, thread);
 
 	session->hists.stats.total_period += sample->period;
@@ -1075,6 +1083,7 @@ static const struct option options[] = {
 	OPT_CALLBACK('f', "fields", NULL, "str",
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
+	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 
 	OPT_END()
 };
@@ -1255,6 +1264,38 @@ int cmd_script(int argc, const char **ar
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (cpu_list) {
+		struct cpu_map *map;
+
+		for (i = 0; i < PERF_TYPE_MAX; ++i) {
+			struct perf_evsel *evsel;
+
+			evsel = perf_session__find_first_evtype(session, i);
+			if (!evsel)
+				continue;
+
+			if (!(evsel->attr.sample_type & PERF_SAMPLE_CPU)) {
+				pr_err("File does not contain CPU events. "
+				       "Remove -c option to proceed.\n");
+				return -1;
+			}
+		}
+
+		map = cpu_map__new(cpu_list);
+
+		for (i = 0; i < map->nr; i++) {
+			int cpu = map->map[i];
+
+			if (cpu >= MAX_NR_CPUS) {
+				pr_err("Requested CPU %d too large. "
+				       "Consider raising MAX_NR_CPUS\n", cpu);
+				return -1;
+			}
+
+			set_bit(cpu, cpu_bitmap);
+		}
+	}
+
 	if (!no_callchain)
 		symbol_conf.use_callchain = true;
 	else
Index: linux-2.6-tip/tools/perf/Documentation/perf-annotate.txt
===================================================================
--- linux-2.6-tip.orig/tools/perf/Documentation/perf-annotate.txt	2011-06-30 11:35:17.768583314 +1000
+++ linux-2.6-tip/tools/perf/Documentation/perf-annotate.txt	2011-06-30 11:35:19.618616362 +1000
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
--- linux-2.6-tip.orig/tools/perf/Documentation/perf-report.txt	2011-06-30 11:35:17.768583314 +1000
+++ linux-2.6-tip/tools/perf/Documentation/perf-report.txt	2011-06-30 11:35:19.618616362 +1000
@@ -119,6 +119,12 @@ OPTIONS
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
--- linux-2.6-tip.orig/tools/perf/Documentation/perf-script.txt	2011-06-30 11:35:17.768583314 +1000
+++ linux-2.6-tip/tools/perf/Documentation/perf-script.txt	2011-06-30 11:35:19.618616362 +1000
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

