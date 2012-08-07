Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2HGNUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:20:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34741 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab2HGNUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:20:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf tools: Initial bash completion support
Date: Tue,  7 Aug 2012 15:19:45 +0200
Message-Id: <1344345586-15068-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344345586-15068-1-git-send-email-fweisbec@gmail.com>
References: <1344345586-15068-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements bash completion for perf subcommands such
as record, report, script, probe, etc...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile        |    1 +
 tools/perf/bash_completion |   20 +++++++++++++
 tools/perf/perf.c          |   69 +++++++++++++++++++++++++-------------------
 3 files changed, 60 insertions(+), 30 deletions(-)
 create mode 100644 tools/perf/bash_completion

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 35655c3..4000d72 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -951,6 +951,7 @@ install: all
 	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
 	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
+	$(INSTALL) -m 755 bash_completion /etc/bash_completion.d/perf
 
 install-python_ext:
 	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
new file mode 100644
index 0000000..3547703
--- /dev/null
+++ b/tools/perf/bash_completion
@@ -0,0 +1,20 @@
+# perf completion
+
+have perf &&
+_perf()
+{
+	local cur
+
+	COMPREPLY=()
+	_get_comp_words_by_ref cur
+
+	# List perf subcommands
+	if [ $COMP_CWORD -eq 1 ]; then
+		cmds=$(perf --list-cmds)
+		COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
+	# Fall down to list regular files
+	else
+		_filedir
+	fi
+} &&
+complete -F _perf perf
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2b2e225..db37ee3 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -24,6 +24,37 @@ const char perf_more_info_string[] =
 int use_browser = -1;
 static int use_pager = -1;
 
+struct cmd_struct {
+	const char *cmd;
+	int (*fn)(int, const char **, const char *);
+	int option;
+};
+
+static struct cmd_struct commands[] = {
+	{ "buildid-cache", cmd_buildid_cache, 0 },
+	{ "buildid-list", cmd_buildid_list, 0 },
+	{ "diff",	cmd_diff,	0 },
+	{ "evlist",	cmd_evlist,	0 },
+	{ "help",	cmd_help,	0 },
+	{ "list",	cmd_list,	0 },
+	{ "record",	cmd_record,	0 },
+	{ "report",	cmd_report,	0 },
+	{ "bench",	cmd_bench,	0 },
+	{ "stat",	cmd_stat,	0 },
+	{ "timechart",	cmd_timechart,	0 },
+	{ "top",	cmd_top,	0 },
+	{ "annotate",	cmd_annotate,	0 },
+	{ "version",	cmd_version,	0 },
+	{ "script",	cmd_script,	0 },
+	{ "sched",	cmd_sched,	0 },
+	{ "probe",	cmd_probe,	0 },
+	{ "kmem",	cmd_kmem,	0 },
+	{ "lock",	cmd_lock,	0 },
+	{ "kvm",	cmd_kvm,	0 },
+	{ "test",	cmd_test,	0 },
+	{ "inject",	cmd_inject,	0 },
+};
+
 struct pager_config {
 	const char *cmd;
 	int val;
@@ -160,6 +191,14 @@ static int handle_options(const char ***argv, int *argc, int *envchanged)
 			fprintf(stderr, "dir: %s\n", debugfs_mountpoint);
 			if (envchanged)
 				*envchanged = 1;
+		} else if (!strcmp(cmd, "--list-cmds")) {
+			unsigned int i;
+
+			for (i = 0; i < ARRAY_SIZE(commands); i++) {
+				struct cmd_struct *p = commands+i;
+				printf("%s ", p->cmd);
+			}
+			exit(0);
 		} else {
 			fprintf(stderr, "Unknown option: %s\n", cmd);
 			usage(perf_usage_string);
@@ -245,12 +284,6 @@ const char perf_version_string[] = PERF_VERSION;
  */
 #define NEED_WORK_TREE	(1<<2)
 
-struct cmd_struct {
-	const char *cmd;
-	int (*fn)(int, const char **, const char *);
-	int option;
-};
-
 static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 {
 	int status;
@@ -296,30 +329,6 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 static void handle_internal_command(int argc, const char **argv)
 {
 	const char *cmd = argv[0];
-	static struct cmd_struct commands[] = {
-		{ "buildid-cache", cmd_buildid_cache, 0 },
-		{ "buildid-list", cmd_buildid_list, 0 },
-		{ "diff",	cmd_diff,	0 },
-		{ "evlist",	cmd_evlist,	0 },
-		{ "help",	cmd_help,	0 },
-		{ "list",	cmd_list,	0 },
-		{ "record",	cmd_record,	0 },
-		{ "report",	cmd_report,	0 },
-		{ "bench",	cmd_bench,	0 },
-		{ "stat",	cmd_stat,	0 },
-		{ "timechart",	cmd_timechart,	0 },
-		{ "top",	cmd_top,	0 },
-		{ "annotate",	cmd_annotate,	0 },
-		{ "version",	cmd_version,	0 },
-		{ "script",	cmd_script,	0 },
-		{ "sched",	cmd_sched,	0 },
-		{ "probe",	cmd_probe,	0 },
-		{ "kmem",	cmd_kmem,	0 },
-		{ "lock",	cmd_lock,	0 },
-		{ "kvm",	cmd_kvm,	0 },
-		{ "test",	cmd_test,	0 },
-		{ "inject",	cmd_inject,	0 },
-	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
 
-- 
1.7.5.4

