Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab2I1IlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:41:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:37094 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab2I1IhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:37:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,501,1344236400"; 
   d="scan'208";a="150188600"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v4 1/8] perf tool: Add a global variable "const char *input_name"
Date: Fri, 28 Sep 2012 16:30:33 +0800
Message-Id: <1348821040-9724-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
References: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently many perf commands annotate/evlist/report/script/lock etc
all support "-i" option to chose a specific perf data, and all
of them create a local "input_name" to save the file name for
that perf data.

Since most of these commands need it, we can add a global variable
for it, also it can some other benefits:
1. When calling script browser inside hists/annotation browser, it
needs to know the perf data file name to run that script.
2. For further feature like runtime switching to another perf data
file, this variable can also help.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/builtin-annotate.c     |    5 ++---
 tools/perf/builtin-buildid-list.c |    1 -
 tools/perf/builtin-evlist.c       |    5 ++---
 tools/perf/builtin-inject.c       |    3 +--
 tools/perf/builtin-kmem.c         |    2 --
 tools/perf/builtin-lock.c         |    2 --
 tools/perf/builtin-report.c       |   13 ++++++-------
 tools/perf/builtin-sched.c        |    5 ++---
 tools/perf/builtin-script.c       |    2 --
 tools/perf/builtin-timechart.c    |    2 --
 tools/perf/perf.c                 |    1 +
 tools/perf/perf.h                 |    1 +
 12 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 9ea3854..b3d60ae 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -33,7 +33,6 @@
 
 struct perf_annotate {
 	struct perf_tool tool;
-	char const *input_name;
 	bool	   force, use_tui, use_stdio;
 	bool	   full_paths;
 	bool	   print_line;
@@ -174,7 +173,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	struct perf_evsel *pos;
 	u64 total_nr_samples;
 
-	session = perf_session__new(ann->input_name, O_RDONLY,
+	session = perf_session__new(input_name, O_RDONLY,
 				    ann->force, false, &ann->tool);
 	if (session == NULL)
 		return -ENOMEM;
@@ -252,7 +251,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		},
 	};
 	const struct option options[] = {
-	OPT_STRING('i', "input", &annotate.input_name, "file",
+	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 1159fee..6940264 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -16,7 +16,6 @@
 #include "util/session.h"
 #include "util/symbol.h"
 
-static const char *input_name;
 static bool force;
 static bool show_kernel;
 static bool with_hits;
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 1fb1641..46420c0 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -48,12 +48,12 @@ static int __if_print(bool *first, const char *field, u64 value)
 
 #define if_print(field) __if_print(&first, #field, pos->attr.field)
 
-static int __cmd_evlist(const char *input_name, struct perf_attr_details *details)
+static int __cmd_evlist(const char *file_name, struct perf_attr_details *details)
 {
 	struct perf_session *session;
 	struct perf_evsel *pos;
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, NULL);
+	session = perf_session__new(file_name, O_RDONLY, 0, false, NULL);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -116,7 +116,6 @@ static const char * const evlist_usage[] = {
 int cmd_evlist(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_attr_details details = { .verbose = false, };
-	const char *input_name = NULL;
 	const struct option options[] = {
 		OPT_STRING('i', "input", &input_name, "file",
 			    "Input file name"),
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 1eaa661..307ad23 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -14,7 +14,6 @@
 
 #include "util/parse-options.h"
 
-static char		const *input_name = "-";
 static bool		inject_build_ids;
 
 static int perf_event__repipe_synth(struct perf_tool *tool __maybe_unused,
@@ -245,7 +244,7 @@ static int __cmd_inject(void)
 		perf_inject.tracing_data = perf_event__repipe_tracing_data;
 	}
 
-	session = perf_session__new(input_name, O_RDONLY, false, true, &perf_inject);
+	session = perf_session__new("-", O_RDONLY, false, true, &perf_inject);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index bc912c6..7c33b30 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -21,8 +21,6 @@
 struct alloc_stat;
 typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
 
-static const char		*input_name;
-
 static int			alloc_flag;
 static int			caller_flag;
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 7d6e099..b9368e7 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -335,8 +335,6 @@ alloc_failed:
 	return NULL;
 }
 
-static const char *input_name;
-
 struct trace_lock_handler {
 	int (*acquire_event)(struct perf_evsel *evsel,
 			     struct perf_sample *sample);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1da243d..e4b2246 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -39,7 +39,6 @@
 struct perf_report {
 	struct perf_tool	tool;
 	struct perf_session	*session;
-	char const		*input_name;
 	bool			force, use_tui, use_gtk, use_stdio;
 	bool			hide_unresolved;
 	bool			dont_use_callchains;
@@ -570,7 +569,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		.pretty_printing_style	 = "normal",
 	};
 	const struct option options[] = {
-	OPT_STRING('i', "input", &report.input_name, "file",
+	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
@@ -656,13 +655,13 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (report.inverted_callchain)
 		callchain_param.order = ORDER_CALLER;
 
-	if (!report.input_name || !strlen(report.input_name)) {
+	if (!input_name || !strlen(input_name)) {
 		if (!fstat(STDIN_FILENO, &st) && S_ISFIFO(st.st_mode))
-			report.input_name = "-";
+			input_name = "-";
 		else
-			report.input_name = "perf.data";
+			input_name = "perf.data";
 	}
-	session = perf_session__new(report.input_name, O_RDONLY,
+	session = perf_session__new(input_name, O_RDONLY,
 				    report.force, false, &report.tool);
 	if (session == NULL)
 		return -ENOMEM;
@@ -687,7 +686,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	}
 
-	if (strcmp(report.input_name, "-") != 0)
+	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
 	else {
 		use_browser = 0;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9b9e32e..72f1c51 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -120,7 +120,6 @@ struct trace_sched_handler {
 
 struct perf_sched {
 	struct perf_tool tool;
-	const char	 *input_name;
 	const char	 *sort_order;
 	unsigned long	 nr_tasks;
 	struct task_desc *pid_to_task[MAX_PID];
@@ -1460,7 +1459,7 @@ static int perf_sched__read_events(struct perf_sched *sched, bool destroy,
 	};
 	struct perf_session *session;
 
-	session = perf_session__new(sched->input_name, O_RDONLY, 0, false, &sched->tool);
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &sched->tool);
 	if (session == NULL) {
 		pr_debug("No Memory for session\n");
 		return -1;
@@ -1707,7 +1706,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_END()
 	};
 	const struct option sched_options[] = {
-	OPT_STRING('i', "input", &sched.input_name, "file",
+	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1be843a..4e2f10f 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -473,8 +473,6 @@ static int cleanup_scripting(void)
 	return scripting_ops->stop_script();
 }
 
-static const char *input_name;
-
 static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				union perf_event *event,
 				struct perf_sample *sample,
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index b1a8a3b..eecf7a2 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -37,8 +37,6 @@
 #define SUPPORT_OLD_POWER_EVENTS 1
 #define PWR_EVENT_EXIT -1
 
-
-static const char	*input_name;
 static const char	*output_name = "output.svg";
 
 static unsigned int	numcpus;
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index fc2f770..d439f31 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -24,6 +24,7 @@ const char perf_more_info_string[] =
 
 int use_browser = -1;
 static int use_pager = -1;
+const char *input_name;
 
 struct cmd_struct {
 	const char *cmd;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 87f4ec6..d754247 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -202,6 +202,7 @@ struct branch_stack {
 	struct branch_entry	entries[0];
 };
 
+extern const char *input_name;
 extern bool perf_host, perf_guest;
 extern const char perf_version_string[];
 
-- 
1.7.1

