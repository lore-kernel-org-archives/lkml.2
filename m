Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1K1XPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:15:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48746 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab1K1XO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/25] perf tools: make -C consistent across commands (for cpu list arg)
Date: Mon, 28 Nov 2011 21:14:24 -0200
Message-Id: <1322522066-21879-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Currently the meaning of -C varies by perf command: for perf-top,
perf-stat, perf-record it means cpu list. For perf-report it means comm
list. Then perf-annotate, perf-report and perf-script use -c for cpu
list.

Fix annotate, report and script to use -C for cpu list to be consistent
with top, stat and record. This means report needs to use -c for comm
list which does introduce a backward compatibility change.

v1 -> v2
- update perf-script.txt too

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1321209008-7004-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt |    2 +-
 tools/perf/Documentation/perf-report.txt   |    4 ++--
 tools/perf/Documentation/perf-script.txt   |    2 +-
 tools/perf/builtin-annotate.c              |    2 +-
 tools/perf/builtin-report.c                |    4 ++--
 tools/perf/builtin-script.c                |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index fe6762e..476029d 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -66,7 +66,7 @@ OPTIONS
 	used. This interfaces starts by centering on the line with more
 	samples, TAB/UNTAB cycles through the lines with more samples.
 
--c::
+-C::
 --cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
 	be provided as a comma-separated list with no space: 0,1. Ranges of
 	CPUs are specified with -: 0-2. Default is to report samples on all
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 212f24d..dc85392 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -39,7 +39,7 @@ OPTIONS
 -T::
 --threads::
 	Show per-thread event counters
--C::
+-c::
 --comms=::
 	Only consider symbols in these comms. CSV that understands
 	file://filename entries.
@@ -128,7 +128,7 @@ OPTIONS
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
 
--c::
+-C::
 --cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
 	be provided as a comma-separated list with no space: 0,1. Ranges of
 	CPUs are specified with -: 0-2. Default is to report samples on all
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index dec87ec..3613b0a 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -182,7 +182,7 @@ OPTIONS
 --hide-call-graph::
         When printing symbols do not display call chain.
 
--c::
+-C::
 --cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
 	be provided as a comma-separated list with no space: 0,1. Ranges of
 	CPUs are specified with -: 0-2. Default is to report samples on all
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index c01139f..d449645 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -274,7 +274,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 		    "print matching source lines (may be slow)"),
 	OPT_BOOLEAN('P', "full-paths", &annotate.full_paths,
 		    "Don't shorten the displayed pathnames"),
-	OPT_STRING('c', "cpu", &annotate.cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING('C', "cpu", &annotate.cpu_list, "cpu", "list of cpus to profile"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		   "Look for files with symbols relative to this directory"),
 	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index eef8e42..ece7c5d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -492,7 +492,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		    "alias for inverted call graph"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
-	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
+	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
 		   "only consider symbols in these comms"),
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
@@ -506,7 +506,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		    "Only display entries resolved to a symbol"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
-	OPT_STRING('c', "cpu", &report.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &report.cpu_list, "cpu",
 		   "list of cpus to profile"),
 	OPT_BOOLEAN('I', "show-info", &report.show_full_info,
 		    "Display extended information about perf.data file"),
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 5f8afc6..7731a09 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1085,7 +1085,7 @@ static const struct option options[] = {
 	OPT_CALLBACK('f', "fields", NULL, "str",
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
-	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_BOOLEAN('I', "show-info", &show_full_info,
 		    "display extended information from perf.data file"),
 	OPT_END()
-- 
1.7.8.rc0.35.gee6df

