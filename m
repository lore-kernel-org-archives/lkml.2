Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0KJSL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:11:57 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37991 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab0KJSKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:10:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pQdPFPHS0rURJ9pdDDehP7aEN2tSPcFyGPLZH0z+NKMZavuWtu0nnHPgnMnDYPxc+S
         sAebBwENc4goEMFaOFFq60ZicLyPrV59lGDGGbJrvS0Ev1ZrV99wSDecaNf9cx2XPkLe
         HhH1tdP70Rs2VBNeNMzNmIqu+WC4Ep7psUvHU=
From: tzanussi@gmail.com
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com
Subject: [PATCH 5/7] perf trace: live-mode command-line cleanup
Date: Wed, 10 Nov 2010 12:10:22 -0600
Message-Id: <1289412624-4772-6-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
References: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

This patch attempts to make the perf trace command-line for live-mode
commands more user-friendly and consistent with other perf commands.

The main change it makes is to allow <commands> to be run as part of
perf trace live-mode commands, as other perf commands do, instead of
the system-wide traces they're currently hard-coded to by the shell
scripts.

With this patch, the following live-mode trace now works as expected:

 $ perf trace rw-by-pid ls -al

The previous system-wide behavior for this command would still be
available by explicitly specifying -a:

 $ perf trace rw-by-pid -a ls -al

and if no <command> is specified, the output is also system-wide:

 $ perf trace rw-by-pid

Because live-mode requires both record and report steps to be invoked,
it isn't always possible to know which args to send to the report and
which to send to the record steps - mainly this is the case for report
scripts with optional args - in those cases it would be necessary to
use separate 'perf trace record' and 'perf trace report' steps.

For example:

 $ perf trace syscall-counts ls

Here we can't decide whether ls should be passed as a param to the
syscall-counts script or whether we should invoke ls as a <command>.
In these cases, we just say that we'll ignore optional script params
and always interpret the extra arguments as a <command>.

If the user instead wants the other interpretation, that can be
accomplished by using separate record and report commands explicitly:

 $ perf trace record syscall-counts
 $ perf trace report syscall-counts ls

So the rules that this patch implements, which seem to make the most
intuitive sense for live-mode commands:

- for commands with optional args and commands with no args, no args
  are sent to the report script, all are sent to the record step

- for 'top' commands i.e. that end with 'top', <commands> can't be
  used - all extra args are send to the report script as params

- for commands with required args, the n required args are taken to be
  the first n args after the script name and sent to the report
  script, and the rest are sent to the record step

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Acked-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/builtin-trace.c |  165 +++++++++++++++++++++++++++++---------------
 1 files changed, 108 insertions(+), 57 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0de7fcb..0483e28 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -330,7 +330,7 @@ static struct script_desc *script_desc__new(const char *name)
 {
 	struct script_desc *s = zalloc(sizeof(*s));
 
-	if (s != NULL)
+	if (s != NULL && name)
 		s->name = strdup(name);
 
 	return s;
@@ -541,6 +541,34 @@ static char *get_script_path(const char *script_root, const char *suffix)
 	return path;
 }
 
+static bool is_top_script(const char *script_path)
+{
+	return ends_with((char *)script_path, "top") == NULL ? false : true;
+}
+
+static int has_required_arg(char *script_path)
+{
+	struct script_desc *desc;
+	int n_args = 0;
+	char *p;
+
+	desc = script_desc__new(NULL);
+
+	if (read_script_info(desc, script_path))
+		goto out;
+
+	if (!desc->args)
+		goto out;
+
+	for (p = desc->args; *p; p++)
+		if (*p == '<')
+			n_args++;
+out:
+	script_desc__delete(desc);
+
+	return n_args;
+}
+
 static const char * const trace_usage[] = {
 	"perf trace [<options>] <command>",
 	NULL
@@ -584,48 +612,65 @@ static bool have_cmd(int argc, const char **argv)
 
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
 {
+	char *rec_script_path = NULL;
+	char *rep_script_path = NULL;
 	struct perf_session *session;
-	const char *suffix = NULL;
+	char *script_path = NULL;
 	const char **__argv;
-	char *script_path;
-	int i, err;
+	bool system_wide;
+	int i, j, err;
 
-	if (argc >= 2 && strncmp(argv[1], "rec", strlen("rec")) == 0) {
-		if (argc < 3) {
-			fprintf(stderr,
-				"Please specify a record script\n");
-			return -1;
-		}
-		suffix = RECORD_SUFFIX;
+	setup_scripting();
+
+	argc = parse_options(argc, argv, options, trace_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+
+	if (argc > 1 && !strncmp(argv[0], "rec", strlen("rec"))) {
+		rec_script_path = get_script_path(argv[1], RECORD_SUFFIX);
+		if (!rec_script_path)
+			return cmd_record(argc, argv, NULL);
 	}
 
-	if (argc >= 2 && strncmp(argv[1], "rep", strlen("rep")) == 0) {
-		if (argc < 3) {
+	if (argc > 1 && !strncmp(argv[0], "rep", strlen("rep"))) {
+		rep_script_path = get_script_path(argv[1], REPORT_SUFFIX);
+		if (!rep_script_path) {
 			fprintf(stderr,
-				"Please specify a report script\n");
+				"Please specify a valid report script"
+				"(see 'perf trace -l' for listing)\n");
 			return -1;
 		}
-		suffix = REPORT_SUFFIX;
 	}
 
 	/* make sure PERF_EXEC_PATH is set for scripts */
 	perf_set_argv_exec_path(perf_exec_path());
 
-	if (!suffix && argc >= 2 && strncmp(argv[1], "-", strlen("-")) != 0) {
-		char *record_script_path, *report_script_path;
+	if (argc && !script_name && !rec_script_path && !rep_script_path) {
 		int live_pipe[2];
+		int rep_args;
 		pid_t pid;
 
-		record_script_path = get_script_path(argv[1], RECORD_SUFFIX);
-		if (!record_script_path) {
-			fprintf(stderr, "record script not found\n");
-			return -1;
+		rec_script_path = get_script_path(argv[0], RECORD_SUFFIX);
+		rep_script_path = get_script_path(argv[0], REPORT_SUFFIX);
+
+		if (!rec_script_path && !rep_script_path) {
+			fprintf(stderr, " Couldn't find script %s\n\n See perf"
+				" trace -l for available scripts.\n", argv[0]);
+			usage_with_options(trace_usage, options);
 		}
 
-		report_script_path = get_script_path(argv[1], REPORT_SUFFIX);
-		if (!report_script_path) {
-			fprintf(stderr, "report script not found\n");
-			return -1;
+		if (is_top_script(argv[0])) {
+			rep_args = argc - 1;
+		} else {
+			int rec_args;
+
+			rep_args = has_required_arg(rep_script_path);
+			rec_args = (argc - 1) - rep_args;
+			if (rec_args < 0) {
+				fprintf(stderr, " %s script requires options."
+					"\n\n See perf trace -l for available "
+					"scripts and options.\n", argv[0]);
+				usage_with_options(trace_usage, options);
+			}
 		}
 
 		if (pipe(live_pipe) < 0) {
@@ -640,19 +685,30 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		}
 
 		if (!pid) {
+			system_wide = true;
+			j = 0;
+
 			dup2(live_pipe[1], 1);
 			close(live_pipe[0]);
 
-			__argv = malloc(6 * sizeof(const char *));
+			if (!is_top_script(argv[0]))
+				system_wide = !have_cmd(argc - rep_args,
+							&argv[rep_args]);
+
+			__argv = malloc((argc + 6) * sizeof(const char *));
 			if (!__argv)
 				die("malloc");
 
-			__argv[0] = "/bin/sh";
-			__argv[1] = record_script_path;
-			__argv[2] = "-q";
-			__argv[3] = "-o";
-			__argv[4] = "-";
-			__argv[5] = NULL;
+			__argv[j++] = "/bin/sh";
+			__argv[j++] = rec_script_path;
+			if (system_wide)
+				__argv[j++] = "-a";
+			__argv[j++] = "-q";
+			__argv[j++] = "-o";
+			__argv[j++] = "-";
+			for (i = rep_args + 1; i < argc; i++)
+				__argv[j++] = argv[i];
+			__argv[j++] = NULL;
 
 			execvp("/bin/sh", (char **)__argv);
 			free(__argv);
@@ -662,43 +718,43 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		dup2(live_pipe[0], 0);
 		close(live_pipe[1]);
 
-		__argv = malloc((argc + 3) * sizeof(const char *));
+		__argv = malloc((argc + 4) * sizeof(const char *));
 		if (!__argv)
 			die("malloc");
-		__argv[0] = "/bin/sh";
-		__argv[1] = report_script_path;
-		for (i = 2; i < argc; i++)
-			__argv[i] = argv[i];
-		__argv[i++] = "-i";
-		__argv[i++] = "-";
-		__argv[i++] = NULL;
+		j = 0;
+		__argv[j++] = "/bin/sh";
+		__argv[j++] = rep_script_path;
+		for (i = 1; i < rep_args + 1; i++)
+			__argv[j++] = argv[i];
+		__argv[j++] = "-i";
+		__argv[j++] = "-";
+		__argv[j++] = NULL;
 
 		execvp("/bin/sh", (char **)__argv);
 		free(__argv);
 		exit(-1);
 	}
 
-	if (suffix) {
-		bool system_wide = false;
-		int j = 0;
+	if (rec_script_path)
+		script_path = rec_script_path;
+	if (rep_script_path)
+		script_path = rep_script_path;
 
-		script_path = get_script_path(argv[2], suffix);
-		if (!script_path) {
-			fprintf(stderr, "script not found\n");
-			return -1;
-		}
+	if (script_path) {
+		system_wide = false;
+		j = 0;
 
-		if (!strcmp(suffix, RECORD_SUFFIX))
-			system_wide = !have_cmd(argc - 2, &argv[2]);
+		if (rec_script_path)
+			system_wide = !have_cmd(argc - 1, &argv[1]);
 
-		__argv = malloc((argc + 1) * sizeof(const char *));
+		__argv = malloc((argc + 2) * sizeof(const char *));
 		if (!__argv)
 			die("malloc");
 		__argv[j++] = "/bin/sh";
 		__argv[j++] = script_path;
 		if (system_wide)
 			__argv[j++] = "-a";
-		for (i = 3; i < argc; i++)
+		for (i = 2; i < argc; i++)
 			__argv[j++] = argv[i];
 		__argv[j++] = NULL;
 
@@ -707,12 +763,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		exit(-1);
 	}
 
-	setup_scripting();
-
-	argc = parse_options(argc, argv, options, trace_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
-
 	if (symbol__init() < 0)
 		return -1;
 	if (!script_name)
-- 
Tom Zanussi, Intel Open Source Technology Center

