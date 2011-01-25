Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1AYR1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:27:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1AYRWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:06 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 01/29] perf evsel: Introduce perf_evlist
Date: Tue, 25 Jan 2011 15:21:24 -0200
Message-Id: <1295976112-2796-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Killing two more perf wide global variables: nr_counters and evsel_list
as a list_head.

There are more operations that will need more fields in perf_evlist,
like the pollfd for polling all the fds in a list of evsel instances.

Use option->value to pass the evsel_list to parse_{events,filters}.

LKML-Reference: <new-submission>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                  |    2 +
 tools/perf/builtin-record.c          |   47 ++++++++++++++++-----------
 tools/perf/builtin-stat.c            |   34 +++++++++++--------
 tools/perf/builtin-top.c             |   60 +++++++++++++++++++--------------
 tools/perf/util/evlist.c             |   53 ++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h             |   19 +++++++++++
 tools/perf/util/header.c             |   17 ++++++----
 tools/perf/util/header.h             |    7 +++-
 tools/perf/util/include/linux/list.h |    1 +
 tools/perf/util/parse-events.c       |   51 +++++-----------------------
 tools/perf/util/parse-events.h       |    7 ----
 11 files changed, 180 insertions(+), 118 deletions(-)
 create mode 100644 tools/perf/util/evlist.c
 create mode 100644 tools/perf/util/evlist.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7141c42..f20bc6f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -402,6 +402,7 @@ LIB_H += util/debug.h
 LIB_H += util/debugfs.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
+LIB_H += util/evlist.h
 LIB_H += util/exec_cmd.h
 LIB_H += util/types.h
 LIB_H += util/levenshtein.h
@@ -440,6 +441,7 @@ LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/debugfs.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
+LIB_OBJS += $(OUTPUT)util/evlist.o
 LIB_OBJS += $(OUTPUT)util/evsel.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
 LIB_OBJS += $(OUTPUT)util/help.o
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b2f729f..252ace8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -18,6 +18,7 @@
 
 #include "util/header.h"
 #include "util/event.h"
+#include "util/evlist.h"
 #include "util/evsel.h"
 #include "util/debug.h"
 #include "util/session.h"
@@ -66,6 +67,7 @@ static bool			sample_address			=  false;
 static bool			sample_time			=  false;
 static bool			no_buildid			=  false;
 static bool			no_buildid_cache		=  false;
+static struct perf_evlist	*evsel_list;
 
 static long			samples				=      0;
 static u64			bytes_written			=      0;
@@ -229,7 +231,8 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 	return h_attr;
 }
 
-static void create_counter(struct perf_evsel *evsel, int cpu)
+static void create_counter(struct perf_evlist *evlist,
+			   struct perf_evsel *evsel, int cpu)
 {
 	char *filter = evsel->filter;
 	struct perf_event_attr *attr = &evsel->attr;
@@ -263,7 +266,7 @@ static void create_counter(struct perf_evsel *evsel, int cpu)
 
 	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
-	if (nr_counters > 1)
+	if (evlist->nr_entries > 1)
 		attr->sample_type |= PERF_SAMPLE_ID;
 
 	/*
@@ -410,7 +413,7 @@ try_again:
 
 		if (evsel->idx || thread_index) {
 			struct perf_evsel *first;
-			first = list_entry(evsel_list.next, struct perf_evsel, node);
+			first = list_entry(evlist->entries.next, struct perf_evsel, node);
 			ret = ioctl(FD(evsel, nr_cpu, thread_index),
 				    PERF_EVENT_IOC_SET_OUTPUT,
 				    FD(first, nr_cpu, 0));
@@ -449,14 +452,14 @@ try_again:
 		sample_type = attr->sample_type;
 }
 
-static void open_counters(int cpu)
+static void open_counters(struct perf_evlist *evlist, int cpu)
 {
 	struct perf_evsel *pos;
 
 	group_fd = -1;
 
-	list_for_each_entry(pos, &evsel_list, node)
-		create_counter(pos, cpu);
+	list_for_each_entry(pos, &evlist->entries, node)
+		create_counter(evlist, pos, cpu);
 
 	nr_cpu++;
 }
@@ -481,9 +484,9 @@ static void atexit_header(void)
 
 		if (!no_buildid)
 			process_buildids();
-		perf_header__write(&session->header, output, true);
+		perf_header__write(&session->header, evsel_list, output, true);
 		perf_session__delete(session);
-		perf_evsel_list__delete();
+		perf_evlist__delete(evsel_list);
 		symbol__exit();
 	}
 }
@@ -611,7 +614,7 @@ static int __cmd_record(int argc, const char **argv)
 			goto out_delete_session;
 	}
 
-	if (have_tracepoints(&evsel_list))
+	if (have_tracepoints(&evsel_list->entries))
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 
 	/*
@@ -674,10 +677,10 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (!system_wide && no_inherit && !cpu_list) {
-		open_counters(-1);
+		open_counters(evsel_list, -1);
 	} else {
 		for (i = 0; i < cpus->nr; i++)
-			open_counters(cpus->map[i]);
+			open_counters(evsel_list, cpus->map[i]);
 	}
 
 	perf_session__set_sample_type(session, sample_type);
@@ -687,7 +690,8 @@ static int __cmd_record(int argc, const char **argv)
 		if (err < 0)
 			return err;
 	} else if (file_new) {
-		err = perf_header__write(&session->header, output, false);
+		err = perf_header__write(&session->header, evsel_list,
+					 output, false);
 		if (err < 0)
 			return err;
 	}
@@ -712,7 +716,7 @@ static int __cmd_record(int argc, const char **argv)
 			return err;
 		}
 
-		if (have_tracepoints(&evsel_list)) {
+		if (have_tracepoints(&evsel_list->entries)) {
 			/*
 			 * FIXME err <= 0 here actually means that
 			 * there were no tracepoints so its not really
@@ -721,7 +725,7 @@ static int __cmd_record(int argc, const char **argv)
 			 * return this more properly and also
 			 * propagate errors that now are calling die()
 			 */
-			err = event__synthesize_tracing_data(output, &evsel_list,
+			err = event__synthesize_tracing_data(output, evsel_list,
 							     process_synthesized_event,
 							     session);
 			if (err <= 0) {
@@ -797,7 +801,7 @@ static int __cmd_record(int argc, const char **argv)
 			for (i = 0; i < nr_cpu; i++) {
 				struct perf_evsel *pos;
 
-				list_for_each_entry(pos, &evsel_list, node) {
+				list_for_each_entry(pos, &evsel_list->entries, node) {
 					for (thread = 0;
 						thread < threads->nr;
 						thread++)
@@ -838,10 +842,10 @@ static const char * const record_usage[] = {
 static bool force, append_file;
 
 const struct option record_options[] = {
-	OPT_CALLBACK('e', "event", NULL, "event",
+	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
-	OPT_CALLBACK(0, "filter", NULL, "filter",
+	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
 	OPT_INTEGER('p', "pid", &target_pid,
 		    "record events on existing process id"),
@@ -892,6 +896,10 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	int err = -ENOMEM;
 	struct perf_evsel *pos;
 
+	evsel_list = perf_evlist__new();
+	if (evsel_list == NULL)
+		return -ENOMEM;
+
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target_pid == -1 && target_tid == -1 &&
@@ -913,7 +921,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (no_buildid_cache || no_buildid)
 		disable_buildid_cache();
 
-	if (list_empty(&evsel_list) && perf_evsel_list__create_default() < 0) {
+	if (evsel_list->nr_entries == 0 &&
+	    perf_evlist__add_default(evsel_list) < 0) {
 		pr_err("Not enough memory for event selector list\n");
 		goto out_symbol_exit;
 	}
@@ -933,7 +942,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		return -1;
 	}
 
-	list_for_each_entry(pos, &evsel_list, node) {
+	list_for_each_entry(pos, &evsel_list->entries, node) {
 		if (perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
 			goto out_free_fd;
 		if (perf_header__push_event(pos->attr.config, event_name(pos)))
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a482a19..da90902 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -43,6 +43,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/event.h"
+#include "util/evlist.h"
 #include "util/evsel.h"
 #include "util/debug.h"
 #include "util/header.h"
@@ -71,6 +72,8 @@ static struct perf_event_attr default_attrs[] = {
 
 };
 
+struct perf_evlist		*evsel_list;
+
 static bool			system_wide			=  false;
 static struct cpu_map		*cpus;
 static int			run_idx				=  0;
@@ -309,7 +312,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
-	list_for_each_entry(counter, &evsel_list, node) {
+	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter) < 0) {
 			if (errno == -EPERM || errno == -EACCES) {
 				error("You may not have permission to collect %sstats.\n"
@@ -347,12 +350,12 @@ static int run_perf_stat(int argc __used, const char **argv)
 	update_stats(&walltime_nsecs_stats, t1 - t0);
 
 	if (no_aggr) {
-		list_for_each_entry(counter, &evsel_list, node) {
+		list_for_each_entry(counter, &evsel_list->entries, node) {
 			read_counter(counter);
 			perf_evsel__close_fd(counter, cpus->nr, 1);
 		}
 	} else {
-		list_for_each_entry(counter, &evsel_list, node) {
+		list_for_each_entry(counter, &evsel_list->entries, node) {
 			read_counter_aggr(counter);
 			perf_evsel__close_fd(counter, cpus->nr, threads->nr);
 		}
@@ -555,10 +558,10 @@ static void print_stat(int argc, const char **argv)
 	}
 
 	if (no_aggr) {
-		list_for_each_entry(counter, &evsel_list, node)
+		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter(counter);
 	} else {
-		list_for_each_entry(counter, &evsel_list, node)
+		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter_aggr(counter);
 	}
 
@@ -610,7 +613,7 @@ static int stat__set_big_num(const struct option *opt __used,
 }
 
 static const struct option options[] = {
-	OPT_CALLBACK('e', "event", NULL, "event",
+	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
@@ -648,6 +651,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	setlocale(LC_ALL, "");
 
+	evsel_list = perf_evlist__new();
+	if (evsel_list == NULL)
+		return -ENOMEM;
+
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
 
@@ -679,17 +686,14 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(stat_usage, options);
 
 	/* Set attrs and nr_counters if no event is selected and !null_run */
-	if (!null_run && !nr_counters) {
+	if (!null_run && !evsel_list->nr_entries) {
 		size_t c;
 
-		nr_counters = ARRAY_SIZE(default_attrs);
-
 		for (c = 0; c < ARRAY_SIZE(default_attrs); ++c) {
-			pos = perf_evsel__new(&default_attrs[c],
-					      nr_counters);
+			pos = perf_evsel__new(&default_attrs[c], c);
 			if (pos == NULL)
 				goto out;
-			list_add(&pos->node, &evsel_list);
+			perf_evlist__add(evsel_list, pos);
 		}
 	}
 
@@ -713,7 +717,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		return -1;
 	}
 
-	list_for_each_entry(pos, &evsel_list, node) {
+	list_for_each_entry(pos, &evsel_list->entries, node) {
 		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
 		    perf_evsel__alloc_counts(pos, cpus->nr) < 0 ||
 		    perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
@@ -741,9 +745,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (status != -1)
 		print_stat(argc, argv);
 out_free_fd:
-	list_for_each_entry(pos, &evsel_list, node)
+	list_for_each_entry(pos, &evsel_list->entries, node)
 		perf_evsel__free_stat_priv(pos);
-	perf_evsel_list__delete();
+	perf_evlist__delete(evsel_list);
 out:
 	thread_map__delete(threads);
 	threads = NULL;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b6998e0..216b62e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -21,6 +21,7 @@
 #include "perf.h"
 
 #include "util/color.h"
+#include "util/evlist.h"
 #include "util/evsel.h"
 #include "util/session.h"
 #include "util/symbol.h"
@@ -60,6 +61,8 @@
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
+struct perf_evlist		*evsel_list;
+
 static bool			system_wide			=  false;
 
 static int			default_interval		=      0;
@@ -267,7 +270,7 @@ static void __zero_source_counters(struct sym_entry *syme)
 
 	line = syme->src->lines;
 	while (line) {
-		for (i = 0; i < nr_counters; i++)
+		for (i = 0; i < evsel_list->nr_entries; i++)
 			line->count[i] = 0;
 		line = line->next;
 	}
@@ -414,7 +417,7 @@ static double sym_weight(const struct sym_entry *sym)
 	if (!display_weighted)
 		return weight;
 
-	for (counter = 1; counter < nr_counters-1; counter++)
+	for (counter = 1; counter < evsel_list->nr_entries - 1; counter++)
 		weight *= sym->count[counter];
 
 	weight /= (sym->count[counter] + 1);
@@ -501,7 +504,7 @@ static void print_sym_table(void)
 			rb_insert_active_sym(&tmp, syme);
 			sum_ksamples += syme->snap_count;
 
-			for (j = 0; j < nr_counters; j++)
+			for (j = 0; j < evsel_list->nr_entries; j++)
 				syme->count[j] = zero ? 0 : syme->count[j] * 7 / 8;
 		} else
 			list_remove_active_sym(syme);
@@ -535,9 +538,9 @@ static void print_sym_table(void)
 			esamples_percent);
 	}
 
-	if (nr_counters == 1 || !display_weighted) {
+	if (evsel_list->nr_entries == 1 || !display_weighted) {
 		struct perf_evsel *first;
-		first = list_entry(evsel_list.next, struct perf_evsel, node);
+		first = list_entry(evsel_list->entries.next, struct perf_evsel, node);
 		printf("%" PRIu64, (uint64_t)first->attr.sample_period);
 		if (freq)
 			printf("Hz ");
@@ -547,7 +550,7 @@ static void print_sym_table(void)
 
 	if (!display_weighted)
 		printf("%s", event_name(sym_evsel));
-	else list_for_each_entry(counter, &evsel_list, node) {
+	else list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (counter->idx)
 			printf("/");
 
@@ -606,7 +609,7 @@ static void print_sym_table(void)
 			sym_width = winsize.ws_col - dso_width - 29;
 	}
 	putchar('\n');
-	if (nr_counters == 1)
+	if (evsel_list->nr_entries == 1)
 		printf("             samples  pcnt");
 	else
 		printf("   weight    samples  pcnt");
@@ -615,7 +618,7 @@ static void print_sym_table(void)
 		printf("         RIP       ");
 	printf(" %-*.*s DSO\n", sym_width, sym_width, "function");
 	printf("   %s    _______ _____",
-	       nr_counters == 1 ? "      " : "______");
+	       evsel_list->nr_entries == 1 ? "      " : "______");
 	if (verbose)
 		printf(" ________________");
 	printf(" %-*.*s", sym_width, sym_width, graph_line);
@@ -634,7 +637,7 @@ static void print_sym_table(void)
 		pcnt = 100.0 - (100.0 * ((sum_ksamples - syme->snap_count) /
 					 sum_ksamples));
 
-		if (nr_counters == 1 || !display_weighted)
+		if (evsel_list->nr_entries == 1 || !display_weighted)
 			printf("%20.2f ", syme->weight);
 		else
 			printf("%9.1f %10ld ", syme->weight, syme->snap_count);
@@ -744,7 +747,7 @@ static void print_mapped_keys(void)
 	fprintf(stdout, "\t[d]     display refresh delay.             \t(%d)\n", delay_secs);
 	fprintf(stdout, "\t[e]     display entries (lines).           \t(%d)\n", print_entries);
 
-	if (nr_counters > 1)
+	if (evsel_list->nr_entries > 1)
 		fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(sym_evsel));
 
 	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", count_filter);
@@ -753,7 +756,7 @@ static void print_mapped_keys(void)
 	fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
 	fprintf(stdout, "\t[S]     stop annotation.\n");
 
-	if (nr_counters > 1)
+	if (evsel_list->nr_entries > 1)
 		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
 
 	fprintf(stdout,
@@ -783,7 +786,7 @@ static int key_mapped(int c)
 			return 1;
 		case 'E':
 		case 'w':
-			return nr_counters > 1 ? 1 : 0;
+			return evsel_list->nr_entries > 1 ? 1 : 0;
 		default:
 			break;
 	}
@@ -831,22 +834,22 @@ static void handle_keypress(struct perf_session *session, int c)
 				signal(SIGWINCH, SIG_DFL);
 			break;
 		case 'E':
-			if (nr_counters > 1) {
+			if (evsel_list->nr_entries > 1) {
 				fprintf(stderr, "\nAvailable events:");
 
-				list_for_each_entry(sym_evsel, &evsel_list, node)
+				list_for_each_entry(sym_evsel, &evsel_list->entries, node)
 					fprintf(stderr, "\n\t%d %s", sym_evsel->idx, event_name(sym_evsel));
 
 				prompt_integer(&sym_counter, "Enter details event counter");
 
-				if (sym_counter >= nr_counters) {
-					sym_evsel = list_entry(evsel_list.next, struct perf_evsel, node);
+				if (sym_counter >= evsel_list->nr_entries) {
+					sym_evsel = list_entry(evsel_list->entries.next, struct perf_evsel, node);
 					sym_counter = 0;
 					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(sym_evsel));
 					sleep(1);
 					break;
 				}
-				list_for_each_entry(sym_evsel, &evsel_list, node)
+				list_for_each_entry(sym_evsel, &evsel_list->entries, node)
 					if (sym_evsel->idx == sym_counter)
 						break;
 			} else sym_counter = 0;
@@ -1198,7 +1201,7 @@ static void perf_session__mmap_read(struct perf_session *self)
 	int i, thread_index;
 
 	for (i = 0; i < cpus->nr; i++) {
-		list_for_each_entry(counter, &evsel_list, node) {
+		list_for_each_entry(counter, &evsel_list->entries, node) {
 			for (thread_index = 0;
 				thread_index < threads->nr;
 				thread_index++) {
@@ -1312,7 +1315,7 @@ static int __cmd_top(void)
 
 	for (i = 0; i < cpus->nr; i++) {
 		group_fd = -1;
-		list_for_each_entry(counter, &evsel_list, node)
+		list_for_each_entry(counter, &evsel_list->entries, node)
 			start_counter(i, counter);
 	}
 
@@ -1354,7 +1357,7 @@ static const char * const top_usage[] = {
 };
 
 static const struct option options[] = {
-	OPT_CALLBACK('e', "event", NULL, "event",
+	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
 	OPT_INTEGER('c', "count", &default_interval,
@@ -1404,6 +1407,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	struct perf_evsel *pos;
 	int status = -ENOMEM;
 
+	evsel_list = perf_evlist__new();
+	if (evsel_list == NULL)
+		return -ENOMEM;
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	argc = parse_options(argc, argv, options, top_usage, 0);
@@ -1431,7 +1438,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		cpu_list = NULL;
 	}
 
-	if (!nr_counters && perf_evsel_list__create_default() < 0) {
+	if (!evsel_list->nr_entries &&
+	    perf_evlist__add_default(evsel_list) < 0) {
 		pr_err("Not enough memory for event selector list\n");
 		return -ENOMEM;
 	}
@@ -1459,7 +1467,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (cpus == NULL)
 		usage_with_options(top_usage, options);
 
-	list_for_each_entry(pos, &evsel_list, node) {
+	list_for_each_entry(pos, &evsel_list->entries, node) {
 		if (perf_evsel__alloc_mmap_per_thread(pos, cpus->nr, threads->nr) < 0 ||
 		    perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
 			goto out_free_fd;
@@ -1472,10 +1480,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		pos->attr.sample_period = default_interval;
 	}
 
-	sym_evsel = list_entry(evsel_list.next, struct perf_evsel, node);
+	sym_evsel = list_entry(evsel_list->entries.next, struct perf_evsel, node);
 
 	symbol_conf.priv_size = (sizeof(struct sym_entry) +
-				 (nr_counters + 1) * sizeof(unsigned long));
+				 (evsel_list->nr_entries + 1) * sizeof(unsigned long));
 
 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
 	if (symbol__init() < 0)
@@ -1489,9 +1497,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	status = __cmd_top();
 out_free_fd:
-	list_for_each_entry(pos, &evsel_list, node)
+	list_for_each_entry(pos, &evsel_list->entries, node)
 		perf_evsel__free_mmap(pos);
-	perf_evsel_list__delete();
+	perf_evlist__delete(evsel_list);
 
 	return status;
 }
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
new file mode 100644
index 0000000..7b4faec
--- /dev/null
+++ b/tools/perf/util/evlist.c
@@ -0,0 +1,53 @@
+#include "evlist.h"
+#include "evsel.h"
+#include "util.h"
+
+struct perf_evlist *perf_evlist__new(void)
+{
+	struct perf_evlist *evlist = zalloc(sizeof(*evlist));
+
+	if (evlist != NULL) {
+		INIT_LIST_HEAD(&evlist->entries);
+	}
+
+	return evlist;
+}
+
+static void perf_evlist__purge(struct perf_evlist *evlist)
+{
+	struct perf_evsel *pos, *n;
+
+	list_for_each_entry_safe(pos, n, &evlist->entries, node) {
+		list_del_init(&pos->node);
+		perf_evsel__delete(pos);
+	}
+
+	evlist->nr_entries = 0;
+}
+
+void perf_evlist__delete(struct perf_evlist *evlist)
+{
+	perf_evlist__purge(evlist);
+	free(evlist);
+}
+
+void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
+{
+	list_add_tail(&entry->node, &evlist->entries);
+	++evlist->nr_entries;
+}
+
+int perf_evlist__add_default(struct perf_evlist *evlist)
+{
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_HARDWARE,
+		.config = PERF_COUNT_HW_CPU_CYCLES,
+	};
+	struct perf_evsel *evsel = perf_evsel__new(&attr, 0);
+
+	if (evsel == NULL)
+		return -ENOMEM;
+
+	perf_evlist__add(evlist, evsel);
+	return 0;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
new file mode 100644
index 0000000..48db91a
--- /dev/null
+++ b/tools/perf/util/evlist.h
@@ -0,0 +1,19 @@
+#ifndef __PERF_EVLIST_H
+#define __PERF_EVLIST_H 1
+
+#include <linux/list.h>
+
+struct perf_evlist {
+	struct list_head entries;
+	int		 nr_entries;
+};
+
+struct perf_evsel;
+
+struct perf_evlist *perf_evlist__new(void);
+void perf_evlist__delete(struct perf_evlist *evlist);
+
+void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
+int perf_evlist__add_default(struct perf_evlist *evlist);
+
+#endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f6a929e..f0138d4 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -8,6 +8,7 @@
 #include <linux/list.h>
 #include <linux/kernel.h>
 
+#include "evlist.h"
 #include "util.h"
 #include "header.h"
 #include "../perf.h"
@@ -428,7 +429,8 @@ static bool perf_session__read_build_ids(struct perf_session *self, bool with_hi
 	return ret;
 }
 
-static int perf_header__adds_write(struct perf_header *self, int fd)
+static int perf_header__adds_write(struct perf_header *self,
+				   struct perf_evlist *evlist, int fd)
 {
 	int nr_sections;
 	struct perf_session *session;
@@ -463,7 +465,7 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 
 		/* Write trace info */
 		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
-		read_tracing_data(fd, &evsel_list);
+		read_tracing_data(fd, &evlist->entries);
 		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
 	}
 
@@ -513,7 +515,8 @@ int perf_header__write_pipe(int fd)
 	return 0;
 }
 
-int perf_header__write(struct perf_header *self, int fd, bool at_exit)
+int perf_header__write(struct perf_header *self, struct perf_evlist *evlist,
+		       int fd, bool at_exit)
 {
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
@@ -566,7 +569,7 @@ int perf_header__write(struct perf_header *self, int fd, bool at_exit)
 	self->data_offset = lseek(fd, 0, SEEK_CUR);
 
 	if (at_exit) {
-		err = perf_header__adds_write(self, fd);
+		err = perf_header__adds_write(self, evlist, fd);
 		if (err < 0)
 			return err;
 	}
@@ -1133,7 +1136,7 @@ int event__process_event_type(event_t *self,
 	return 0;
 }
 
-int event__synthesize_tracing_data(int fd, struct list_head *pattrs,
+int event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 				   event__handler_t process,
 				   struct perf_session *session __unused)
 {
@@ -1144,7 +1147,7 @@ int event__synthesize_tracing_data(int fd, struct list_head *pattrs,
 	memset(&ev, 0, sizeof(ev));
 
 	ev.tracing_data.header.type = PERF_RECORD_HEADER_TRACING_DATA;
-	size = read_tracing_data_size(fd, pattrs);
+	size = read_tracing_data_size(fd, &evlist->entries);
 	if (size <= 0)
 		return size;
 	aligned_size = ALIGN(size, sizeof(u64));
@@ -1154,7 +1157,7 @@ int event__synthesize_tracing_data(int fd, struct list_head *pattrs,
 
 	process(&ev, NULL, session);
 
-	err = read_tracing_data(fd, pattrs);
+	err = read_tracing_data(fd, &evlist->entries);
 	write_padded(fd, NULL, 0, padding);
 
 	return aligned_size;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 33f16be..65afd7f 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -65,8 +65,11 @@ struct perf_header {
 int perf_header__init(struct perf_header *self);
 void perf_header__exit(struct perf_header *self);
 
+struct perf_evlist;
+
 int perf_header__read(struct perf_session *session, int fd);
-int perf_header__write(struct perf_header *self, int fd, bool at_exit);
+int perf_header__write(struct perf_header *self, struct perf_evlist *evlist,
+		       int fd, bool at_exit);
 int perf_header__write_pipe(int fd);
 
 int perf_header__add_attr(struct perf_header *self,
@@ -113,7 +116,7 @@ int event__synthesize_event_types(event__handler_t process,
 int event__process_event_type(event_t *self,
 			      struct perf_session *session);
 
-int event__synthesize_tracing_data(int fd, struct list_head *pattrs,
+int event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 				   event__handler_t process,
 				   struct perf_session *session);
 int event__process_tracing_data(event_t *self,
diff --git a/tools/perf/util/include/linux/list.h b/tools/perf/util/include/linux/list.h
index f5ca26e..356c7e4 100644
--- a/tools/perf/util/include/linux/list.h
+++ b/tools/perf/util/include/linux/list.h
@@ -1,3 +1,4 @@
+#include <linux/kernel.h>
 #include "../../../../include/linux/list.h"
 
 #ifndef PERF_LIST_H
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 135f69b..d3086ce 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,6 +1,7 @@
 #include "../../../include/linux/hw_breakpoint.h"
 #include "util.h"
 #include "../perf.h"
+#include "evlist.h"
 #include "evsel.h"
 #include "parse-options.h"
 #include "parse-events.h"
@@ -11,10 +12,6 @@
 #include "header.h"
 #include "debugfs.h"
 
-int				nr_counters;
-
-LIST_HEAD(evsel_list);
-
 struct event_symbol {
 	u8		type;
 	u64		config;
@@ -778,8 +775,9 @@ modifier:
 	return ret;
 }
 
-int parse_events(const struct option *opt __used, const char *str, int unset __used)
+int parse_events(const struct option *opt, const char *str, int unset __used)
 {
+	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
 	struct perf_event_attr attr;
 	enum event_result ret;
 
@@ -794,12 +792,10 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 
 		if (ret != EVT_HANDLED_ALL) {
 			struct perf_evsel *evsel;
-			evsel = perf_evsel__new(&attr,
-						nr_counters);
+			evsel = perf_evsel__new(&attr, evlist->nr_entries);
 			if (evsel == NULL)
 				return -1;
-			list_add_tail(&evsel->node, &evsel_list);
-			++nr_counters;
+			perf_evlist__add(evlist, evsel);
 		}
 
 		if (*str == 0)
@@ -813,13 +809,14 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 	return 0;
 }
 
-int parse_filter(const struct option *opt __used, const char *str,
+int parse_filter(const struct option *opt, const char *str,
 		 int unset __used)
 {
+	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
 	struct perf_evsel *last = NULL;
 
-	if (!list_empty(&evsel_list))
-		last = list_entry(evsel_list.prev, struct perf_evsel, node);
+	if (evlist->nr_entries > 0)
+		last = list_entry(evlist->entries.prev, struct perf_evsel, node);
 
 	if (last == NULL || last->attr.type != PERF_TYPE_TRACEPOINT) {
 		fprintf(stderr,
@@ -981,33 +978,3 @@ void print_events(void)
 
 	exit(129);
 }
-
-int perf_evsel_list__create_default(void)
-{
-	struct perf_evsel *evsel;
-	struct perf_event_attr attr;
-
-	memset(&attr, 0, sizeof(attr));
-	attr.type = PERF_TYPE_HARDWARE;
-	attr.config = PERF_COUNT_HW_CPU_CYCLES;
-
-	evsel = perf_evsel__new(&attr, 0);
-
-	if (evsel == NULL)
-		return -ENOMEM;
-
-	list_add(&evsel->node, &evsel_list);
-	++nr_counters;
-	return 0;
-}
-
-void perf_evsel_list__delete(void)
-{
-	struct perf_evsel *pos, *n;
-
-	list_for_each_entry_safe(pos, n, &evsel_list, node) {
-		list_del_init(&pos->node);
-		perf_evsel__delete(pos);
-	}
-	nr_counters = 0;
-}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 458e3ec..cf7e94a 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -9,11 +9,6 @@
 struct list_head;
 struct perf_evsel;
 
-extern struct list_head evsel_list;
-
-int perf_evsel_list__create_default(void);
-void perf_evsel_list__delete(void);
-
 struct option;
 
 struct tracepoint_path {
@@ -25,8 +20,6 @@ struct tracepoint_path {
 extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 extern bool have_tracepoints(struct list_head *evlist);
 
-extern int			nr_counters;
-
 const char *event_name(struct perf_evsel *event);
 extern const char *__event_name(int type, u64 config);
 
-- 
1.6.2.5

