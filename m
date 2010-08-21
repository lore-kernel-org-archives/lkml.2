Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab0HUUTW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 16:19:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:50452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0HUUTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 16:19:20 -0400
Date: Sat, 21 Aug 2010 20:18:51 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        hch@infradead.org, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de, hch@infradead.org
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add --tui and --stdio to choose the UI
Message-ID: <tip-8b9e74eb8af808807192d16b76565c27154ae7ed@git.kernel.org>
Git-Commit-ID: 8b9e74eb8af808807192d16b76565c27154ae7ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 21 Aug 2010 20:18:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b9e74eb8af808807192d16b76565c27154ae7ed
Gitweb:     http://git.kernel.org/tip/8b9e74eb8af808807192d16b76565c27154ae7ed
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 21 Aug 2010 10:38:16 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 21 Aug 2010 10:49:46 -0300

perf tools: Add --tui and --stdio to choose the UI

Relying just on ~/.perfconfig or rebuilding the tool disabling support
for the TUI is too cumbersome, so allow specifying which UI to use and
make the command line switch override whatever is in ~/.perfconfig.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt |   11 +++++++++--
 tools/perf/Documentation/perf-report.txt   |    7 +++++++
 tools/perf/builtin-annotate.c              |    9 ++++++++-
 tools/perf/builtin-report.c                |   11 ++++++++++-
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 5164a65..b2c6330 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -8,7 +8,7 @@ perf-annotate - Read perf.data (created by perf record) and display annotated co
 SYNOPSIS
 --------
 [verse]
-'perf annotate' [-i <file> | --input=file] symbol_name
+'perf annotate' [-i <file> | --input=file] [symbol_name]
 
 DESCRIPTION
 -----------
@@ -24,6 +24,13 @@ OPTIONS
 --input=::
         Input file name. (default: perf.data)
 
+--stdio:: Use the stdio interface.
+
+--tui:: Use the TUI interface Use of --tui requires a tty, if one is not
+	present, as when piping to other commands, the stdio interface is
+	used. This interfaces starts by centering on the line with more
+	samples, TAB/UNTAB cycles thru the lines with more samples.
+
 SEE ALSO
 --------
-linkperf:perf-record[1]
+linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index abfabe9..12052c9 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -65,6 +65,13 @@ OPTIONS
 		 the tree is considered as a new profiled object. +
 	Default: fractal,0.5.
 
+--stdio:: Use the stdio interface.
+
+--tui:: Use the TUI interface, that is integrated with annotate and allows
+        zooming into DSOs or threads, among other features. Use of --tui
+	requires a tty, if one is not present, as when piping to other
+	commands, the stdio interface is used.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 20ee21d..6d5604d8d 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -28,7 +28,7 @@
 
 static char		const *input_name = "perf.data";
 
-static bool		force;
+static bool		force, use_tui, use_stdio;
 
 static bool		full_paths;
 
@@ -427,6 +427,8 @@ static const struct option options[] = {
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
+	OPT_BOOLEAN(0, "tui", &use_tui, "Use the TUI interface"),
+	OPT_BOOLEAN(0, "stdio", &use_stdio, "Use the stdio interface"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
@@ -442,6 +444,11 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
+	if (use_stdio)
+		use_browser = 0;
+	else if (use_tui)
+		use_browser = 1;
+
 	setup_browser();
 
 	symbol_conf.priv_size = sizeof(struct sym_priv);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 55fc1f4..7d35a71 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -32,7 +32,7 @@
 
 static char		const *input_name = "perf.data";
 
-static bool		force;
+static bool		force, use_tui, use_stdio;
 static bool		hide_unresolved;
 static bool		dont_use_callchains;
 
@@ -450,6 +450,8 @@ static const struct option options[] = {
 		    "Show per-thread event counters"),
 	OPT_STRING(0, "pretty", &pretty_printing_style, "key",
 		   "pretty printing style key: normal raw"),
+	OPT_BOOLEAN(0, "tui", &use_tui, "Use the TUI interface"),
+	OPT_BOOLEAN(0, "stdio", &use_stdio, "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
@@ -482,8 +484,15 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
+	if (use_stdio)
+		use_browser = 0;
+	else if (use_tui)
+		use_browser = 1;
+
 	if (strcmp(input_name, "-") != 0)
 		setup_browser();
+	else
+		use_browser = 0;
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
 	 * so don't allocate extra space that won't be used in the stdio
