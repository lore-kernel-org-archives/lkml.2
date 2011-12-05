Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1LEM6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:58:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56977 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab1LEM5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:57:51 -0500
Date: Mon, 5 Dec 2011 04:56:55 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-xduzibqrdg3h5cttmk6p5wwc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Group options in a struct
Git-Commit-ID: 7009cc34b964939815160d7de64cf0215cdbf8bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:57:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7009cc34b964939815160d7de64cf0215cdbf8bb
Gitweb:     http://git.kernel.org/tip/7009cc34b964939815160d7de64cf0215cdbf8bb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 17 Nov 2011 12:33:21 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:38:40 -0200

perf annotate: Group options in a struct

Paving the way to remove these globals when we change the perf_event_ops
to receive as a first parameter a pointer to a perf_event_ops that will
then provide access to perf_annotate via container_of.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xduzibqrdg3h5cttmk6p5wwc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   64 +++++++++++++++++++++--------------------
 1 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 8b9091b..4f0c3d9 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -30,18 +30,17 @@
 
 #include <linux/bitmap.h>
 
-static char		const *input_name = "perf.data";
-
-static bool		force, use_tui, use_stdio;
-
-static bool		full_paths;
-
-static bool		print_line;
-
-static const char *sym_hist_filter;
-
-static const char	*cpu_list;
-static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+static struct perf_annotate {
+	char const *input_name;
+	bool	   force, use_tui, use_stdio;
+	bool	   full_paths;
+	bool	   print_line;
+	const char *sym_hist_filter;
+	const char *cpu_list;
+	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+} annotate = {
+	.input_name = "perf.data",
+}, *ann = &annotate;
 
 static int perf_evsel__add_sample(struct perf_evsel *evsel,
 				  struct perf_sample *sample,
@@ -50,8 +49,9 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 	struct hist_entry *he;
 	int ret;
 
-	if (sym_hist_filter != NULL &&
-	    (al->sym == NULL || strcmp(sym_hist_filter, al->sym->name) != 0)) {
+	if (ann->sym_hist_filter != NULL &&
+	    (al->sym == NULL ||
+	     strcmp(ann->sym_hist_filter, al->sym->name) != 0)) {
 		/* We're only interested in a symbol named sym_hist_filter */
 		if (al->sym != NULL) {
 			rb_erase(&al->sym->rb_node,
@@ -93,7 +93,7 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
-	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+	if (ann->cpu_list && !test_bit(sample->cpu, ann->cpu_bitmap))
 		return 0;
 
 	if (!al.filtered && perf_evsel__add_sample(evsel, sample, &al)) {
@@ -108,7 +108,7 @@ static int process_sample_event(union perf_event *event,
 static int hist_entry__tty_annotate(struct hist_entry *he, int evidx)
 {
 	return symbol__tty_annotate(he->ms.sym, he->ms.map, evidx,
-				    print_line, full_paths, 0, 0);
+				    ann->print_line, ann->full_paths, 0, 0);
 }
 
 static void hists__find_annotations(struct hists *self, int evidx)
@@ -178,12 +178,14 @@ static int __cmd_annotate(void)
 	struct perf_evsel *pos;
 	u64 total_nr_samples;
 
-	session = perf_session__new(input_name, O_RDONLY, force, false, &event_ops);
+	session = perf_session__new(ann->input_name, O_RDONLY,
+				    ann->force, false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (cpu_list) {
-		ret = perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap);
+	if (ann->cpu_list) {
+		ret = perf_session__cpu_bitmap(session, ann->cpu_list,
+					       ann->cpu_bitmap);
 		if (ret)
 			goto out_delete;
 	}
@@ -217,7 +219,7 @@ static int __cmd_annotate(void)
 	}
 
 	if (total_nr_samples == 0) {
-		ui__warning("The %s file has no samples!\n", input_name);
+		ui__warning("The %s file has no samples!\n", ann->input_name);
 		goto out_delete;
 	}
 out_delete:
@@ -242,28 +244,28 @@ static const char * const annotate_usage[] = {
 };
 
 static const struct option options[] = {
-	OPT_STRING('i', "input", &input_name, "file",
+	OPT_STRING('i', "input", &annotate.input_name, "file",
 		    "input file name"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
-	OPT_STRING('s', "symbol", &sym_hist_filter, "symbol",
+	OPT_STRING('s', "symbol", &annotate.sym_hist_filter, "symbol",
 		    "symbol to annotate"),
-	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_BOOLEAN('f', "force", &annotate.force, "don't complain, do it"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
-	OPT_BOOLEAN(0, "tui", &use_tui, "Use the TUI interface"),
-	OPT_BOOLEAN(0, "stdio", &use_stdio, "Use the stdio interface"),
+	OPT_BOOLEAN(0, "tui", &annotate.use_tui, "Use the TUI interface"),
+	OPT_BOOLEAN(0, "stdio", &annotate.use_stdio, "Use the stdio interface"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
-	OPT_BOOLEAN('l', "print-line", &print_line,
+	OPT_BOOLEAN('l', "print-line", &annotate.print_line,
 		    "print matching source lines (may be slow)"),
-	OPT_BOOLEAN('P', "full-paths", &full_paths,
+	OPT_BOOLEAN('P', "full-paths", &annotate.full_paths,
 		    "Don't shorten the displayed pathnames"),
-	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING('c', "cpu", &annotate.cpu_list, "cpu", "list of cpus to profile"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		   "Look for files with symbols relative to this directory"),
 	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
@@ -279,9 +281,9 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
-	if (use_stdio)
+	if (annotate.use_stdio)
 		use_browser = 0;
-	else if (use_tui)
+	else if (annotate.use_tui)
 		use_browser = 1;
 
 	setup_browser(true);
@@ -302,7 +304,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 		if (argc > 1)
 			usage_with_options(annotate_usage, options);
 
-		sym_hist_filter = argv[0];
+		annotate.sym_hist_filter = argv[0];
 	}
 
 	if (field_sep && *field_sep == '.') {
