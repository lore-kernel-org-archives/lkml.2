Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab1LEM5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:57:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab1LEM5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:57:14 -0500
Date: Mon, 5 Dec 2011 04:56:09 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-2eh2vi2nb5z3tg1lvoxv09xu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Group options in a struct
Git-Commit-ID: fa372aae335c6dfbe808d5a728fe10cd202dde45
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:56:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa372aae335c6dfbe808d5a728fe10cd202dde45
Gitweb:     http://git.kernel.org/tip/fa372aae335c6dfbe808d5a728fe10cd202dde45
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 17 Nov 2011 12:19:04 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:38:26 -0200

perf report: Group options in a struct

Paving the way to remove these globals when we change the perf_event_ops
to receive as a first parameter a pointer to a perf_event_ops that will
then provide access to perf_report via container_of.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2eh2vi2nb5z3tg1lvoxv09xu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |  111 +++++++++++++++++++++++--------------------
 1 files changed, 59 insertions(+), 52 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b7ab373..5d2e819 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -35,25 +35,25 @@
 
 #include <linux/bitmap.h>
 
-static char		const *input_name = "perf.data";
-
-static bool		force, use_tui, use_stdio;
-static bool		hide_unresolved;
-static bool		dont_use_callchains;
-static bool		show_full_info;
-
-static bool		show_threads;
-static struct perf_read_values	show_threads_values;
-
-static const char	default_pretty_printing_style[] = "normal";
-static const char	*pretty_printing_style = default_pretty_printing_style;
-
-static char		callchain_default_opt[] = "fractal,0.5,callee";
-static bool		inverted_callchain;
-static symbol_filter_t	annotate_init;
-
-static const char	*cpu_list;
-static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+static struct perf_report {
+	char const		*input_name;
+	bool			force, use_tui, use_stdio;
+	bool			hide_unresolved;
+	bool			dont_use_callchains;
+	bool			show_full_info;
+	bool			show_threads;
+	bool			inverted_callchain;
+	struct perf_read_values	show_threads_values;
+	const char		*pretty_printing_style;
+	symbol_filter_t		annotate_init;
+	const char		*cpu_list;
+	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+} report = {
+	.input_name	       = "perf.data",
+	.pretty_printing_style = "normal",
+}, *rep = &report;
+
+static char callchain_default_opt[] = "fractal,0.5,callee";
 
 static int perf_session__add_hist_entry(struct perf_session *session,
 					struct addr_location *al,
@@ -114,16 +114,16 @@ static int process_sample_event(union perf_event *event,
 	struct addr_location al;
 
 	if (perf_event__preprocess_sample(event, session, &al, sample,
-					  annotate_init) < 0) {
+					  rep->annotate_init) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
 
-	if (al.filtered || (hide_unresolved && al.sym == NULL))
+	if (al.filtered || (rep->hide_unresolved && al.sym == NULL))
 		return 0;
 
-	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
 	if (al.map != NULL)
@@ -143,9 +143,9 @@ static int process_read_event(union perf_event *event,
 {
 	struct perf_evsel *evsel = perf_evlist__id2evsel(session->evlist,
 							 event->read.id);
-	if (show_threads) {
+	if (rep->show_threads) {
 		const char *name = evsel ? event_name(evsel) : "unknown";
-		perf_read_values_add_value(&show_threads_values,
+		perf_read_values_add_value(&rep->show_threads_values,
 					   event->read.pid, event->read.tid,
 					   event->read.id,
 					   name,
@@ -173,7 +173,8 @@ static int perf_session__setup_sample_type(struct perf_session *self)
 				    "you call 'perf record' without -g?\n");
 			return -1;
 		}
-	} else if (!dont_use_callchains && callchain_param.mode != CHAIN_NONE &&
+	} else if (!rep->dont_use_callchains &&
+		   callchain_param.mode != CHAIN_NONE &&
 		   !symbol_conf.use_callchain) {
 			symbol_conf.use_callchain = true;
 			if (callchain_register_param(&callchain_param) < 0) {
@@ -241,11 +242,11 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 	    parent_pattern == default_parent_pattern) {
 		fprintf(stdout, "#\n# (%s)\n#\n", help);
 
-		if (show_threads) {
-			bool style = !strcmp(pretty_printing_style, "raw");
-			perf_read_values_display(stdout, &show_threads_values,
+		if (rep->show_threads) {
+			bool style = !strcmp(rep->pretty_printing_style, "raw");
+			perf_read_values_display(stdout, &rep->show_threads_values,
 						 style);
-			perf_read_values_destroy(&show_threads_values);
+			perf_read_values_destroy(&rep->show_threads_values);
 		}
 	}
 
@@ -264,21 +265,23 @@ static int __cmd_report(void)
 
 	signal(SIGINT, sig_handler);
 
-	session = perf_session__new(input_name, O_RDONLY, force, false, &event_ops);
+	session = perf_session__new(rep->input_name, O_RDONLY,
+				    rep->force, false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (cpu_list) {
-		ret = perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap);
+	if (rep->cpu_list) {
+		ret = perf_session__cpu_bitmap(session, rep->cpu_list,
+					       rep->cpu_bitmap);
 		if (ret)
 			goto out_delete;
 	}
 
 	if (use_browser <= 0)
-		perf_session__fprintf_info(session, stdout, show_full_info);
+		perf_session__fprintf_info(session, stdout, rep->show_full_info);
 
-	if (show_threads)
-		perf_read_values_init(&show_threads_values);
+	if (rep->show_threads)
+		perf_read_values_init(&rep->show_threads_values);
 
 	ret = perf_session__setup_sample_type(session);
 	if (ret)
@@ -327,7 +330,8 @@ static int __cmd_report(void)
 	}
 
 	if (nr_samples == 0) {
-		ui__warning("The %s file has no samples!\n", input_name);
+		ui__warning("The %s file has no samples!\n",
+			    rep->input_name);
 		goto out_delete;
 	}
 
@@ -364,7 +368,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 	 * --no-call-graph
 	 */
 	if (unset) {
-		dont_use_callchains = true;
+		rep->dont_use_callchains = true;
 		return 0;
 	}
 
@@ -439,7 +443,7 @@ static const char * const report_usage[] = {
 };
 
 static const struct option options[] = {
-	OPT_STRING('i', "input", &input_name, "file",
+	OPT_STRING('i', "input", &report.input_name, "file",
 		    "input file name"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
@@ -449,17 +453,18 @@ static const struct option options[] = {
 		   "file", "vmlinux pathname"),
 	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
 		   "file", "kallsyms pathname"),
-	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_BOOLEAN('f', "force", &report.force, "don't complain, do it"),
 	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-	OPT_BOOLEAN('T', "threads", &show_threads,
+	OPT_BOOLEAN('T', "threads", &report.show_threads,
 		    "Show per-thread event counters"),
-	OPT_STRING(0, "pretty", &pretty_printing_style, "key",
+	OPT_STRING(0, "pretty", &report.pretty_printing_style, "key",
 		   "pretty printing style key: normal raw"),
-	OPT_BOOLEAN(0, "tui", &use_tui, "Use the TUI interface"),
-	OPT_BOOLEAN(0, "stdio", &use_stdio, "Use the stdio interface"),
+	OPT_BOOLEAN(0, "tui", &report.use_tui, "Use the TUI interface"),
+	OPT_BOOLEAN(0, "stdio", &report.use_stdio,
+		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
@@ -471,7 +476,8 @@ static const struct option options[] = {
 	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent, call_order",
 		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold and callchain order. "
 		     "Default: fractal,0.5,callee", &parse_callchain_opt, callchain_default_opt),
-	OPT_BOOLEAN('G', "inverted", &inverted_callchain, "alias for inverted call graph"),
+	OPT_BOOLEAN('G', "inverted", &report.inverted_callchain,
+		    "alias for inverted call graph"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
@@ -484,12 +490,13 @@ static const struct option options[] = {
 	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
 		   "columns '.' is reserved."),
-	OPT_BOOLEAN('U', "hide-unresolved", &hide_unresolved,
+	OPT_BOOLEAN('U', "hide-unresolved", &report.hide_unresolved,
 		    "Only display entries resolved to a symbol"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
-	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
-	OPT_BOOLEAN('I', "show-info", &show_full_info,
+	OPT_STRING('c', "cpu", &report.cpu_list, "cpu",
+		   "list of cpus to profile"),
+	OPT_BOOLEAN('I', "show-info", &report.show_full_info,
 		    "Display extended information about perf.data file"),
 	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
 		    "Interleave source code with assembly code (default)"),
@@ -506,15 +513,15 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
-	if (use_stdio)
+	if (report.use_stdio)
 		use_browser = 0;
-	else if (use_tui)
+	else if (report.use_tui)
 		use_browser = 1;
 
-	if (inverted_callchain)
+	if (report.inverted_callchain)
 		callchain_param.order = ORDER_CALLER;
 
-	if (strcmp(input_name, "-") != 0)
+	if (strcmp(report.input_name, "-") != 0)
 		setup_browser(true);
 	else
 		use_browser = 0;
@@ -525,7 +532,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	 */
 	if (use_browser > 0) {
 		symbol_conf.priv_size = sizeof(struct annotation);
-		annotate_init	      = symbol__annotate_init;
+		report.annotate_init  = symbol__annotate_init;
 		/*
  		 * For searching by name on the "Browse map details".
  		 * providing it only in verbose mode not to bloat too
