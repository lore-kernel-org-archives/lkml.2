Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab2JDST0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:19:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:39778 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2JDSJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/42] perf script: Don't use globals where not needed to
Date: Thu,  4 Oct 2012 15:08:14 -0300
Message-Id: <1349374122-27806-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Some variables were global but used in just one function, so move it to
where it belongs.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-eukt8bzp4t2n2z3s8ue5ofwb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   90 ++++++++++++++++++++-----------------------
 1 files changed, 42 insertions(+), 48 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1be843a..fb96250 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -24,7 +24,6 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
-static bool			show_full_info;
 static bool			system_wide;
 static const char		*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
@@ -473,8 +472,6 @@ static int cleanup_scripting(void)
 	return scripting_ops->stop_script();
 }
 
-static const char *input_name;
-
 static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -1156,20 +1153,40 @@ out:
 	return n_args;
 }
 
-static const char * const script_usage[] = {
-	"perf script [<options>]",
-	"perf script [<options>] record <script> [<record-options>] <command>",
-	"perf script [<options>] report <script> [script-args]",
-	"perf script [<options>] <script> [<record-options>] <command>",
-	"perf script [<options>] <top-script> [script-args]",
-	NULL
-};
+static int have_cmd(int argc, const char **argv)
+{
+	char **__argv = malloc(sizeof(const char *) * argc);
+
+	if (!__argv) {
+		pr_err("malloc failed\n");
+		return -1;
+	}
+
+	memcpy(__argv, argv, sizeof(const char *) * argc);
+	argc = parse_options(argc, (const char **)__argv, record_options,
+			     NULL, PARSE_OPT_STOP_AT_NON_OPTION);
+	free(__argv);
 
-static const struct option options[] = {
+	system_wide = (argc == 0);
+
+	return 0;
+}
+
+int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	bool show_full_info = false;
+	const char *input_name = NULL;
+	char *rec_script_path = NULL;
+	char *rep_script_path = NULL;
+	struct perf_session *session;
+	char *script_path = NULL;
+	const char **__argv;
+	int i, j, err;
+	const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose (show symbol address, etc)"),
+		 "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('L', "Latency", &latency_format,
 		    "show latency attributes (irqs/preemption disabled, etc)"),
 	OPT_CALLBACK_NOOPT('l', "list", NULL, NULL, "list available scripts",
@@ -1179,8 +1196,7 @@ static const struct option options[] = {
 		     parse_scriptname),
 	OPT_STRING('g', "gen-script", &generate_script_lang, "lang",
 		   "generate perf-script.xx script in specified language"),
-	OPT_STRING('i', "input", &input_name, "file",
-		    "input file name"),
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_BOOLEAN('d', "debug-mode", &debug_mode,
 		   "do various checks like samples ordering and lost events"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
@@ -1195,10 +1211,9 @@ static const struct option options[] = {
 		     "comma separated output fields prepend with 'type:'. "
 		     "Valid types: hw,sw,trace,raw. "
 		     "Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,"
-		     "addr,symoff",
-		     parse_output_fields),
+		     "addr,symoff", parse_output_fields),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
-		     "system-wide collection from all CPUs"),
+		    "system-wide collection from all CPUs"),
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
@@ -1208,37 +1223,16 @@ static const struct option options[] = {
 		    "display extended information from perf.data file"),
 	OPT_BOOLEAN('\0', "show-kernel-path", &symbol_conf.show_kernel_path,
 		    "Show the path of [kernel.kallsyms]"),
-
 	OPT_END()
-};
-
-static int have_cmd(int argc, const char **argv)
-{
-	char **__argv = malloc(sizeof(const char *) * argc);
-
-	if (!__argv) {
-		pr_err("malloc failed\n");
-		return -1;
-	}
-
-	memcpy(__argv, argv, sizeof(const char *) * argc);
-	argc = parse_options(argc, (const char **)__argv, record_options,
-			     NULL, PARSE_OPT_STOP_AT_NON_OPTION);
-	free(__argv);
-
-	system_wide = (argc == 0);
-
-	return 0;
-}
-
-int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
-{
-	char *rec_script_path = NULL;
-	char *rep_script_path = NULL;
-	struct perf_session *session;
-	char *script_path = NULL;
-	const char **__argv;
-	int i, j, err;
+	};
+	const char * const script_usage[] = {
+		"perf script [<options>]",
+		"perf script [<options>] record <script> [<record-options>] <command>",
+		"perf script [<options>] report <script> [script-args]",
+		"perf script [<options>] <script> [<record-options>] <command>",
+		"perf script [<options>] <top-script> [script-args]",
+		NULL
+	};
 
 	setup_scripting();
 
-- 
1.7.1

