Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2JEIlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:41:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2JEIlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:41:40 -0400
Date: Fri, 5 Oct 2012 01:41:20 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-eukt8bzp4t2n2z3s8ue5ofwb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script: Don'
 t use globals where not needed to
Git-Commit-ID: 69b6470e9ef3f6ea72b7e46e140d85970d8e1bc8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:41:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69b6470e9ef3f6ea72b7e46e140d85970d8e1bc8
Gitweb:     http://git.kernel.org/tip/69b6470e9ef3f6ea72b7e46e140d85970d8e1bc8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Oct 2012 15:20:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:30 -0300

perf script: Don't use globals where not needed to

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
 
