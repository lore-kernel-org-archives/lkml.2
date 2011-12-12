Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1LLRfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:35:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40454 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab1LLRfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:35:17 -0500
Date: Mon, 12 Dec 2011 09:34:53 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-317df650c588bb9091b1fa0b5d726fe485aad88e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1322229925-10075-1-git-send-email-robert.richter@amd.com>
References: <1322229925-10075-1-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Implement option for system-wide profiling
Git-Commit-ID: 317df650c588bb9091b1fa0b5d726fe485aad88e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Dec 2011 09:35:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  317df650c588bb9091b1fa0b5d726fe485aad88e
Gitweb:     http://git.kernel.org/tip/317df650c588bb9091b1fa0b5d726fe485aad88e
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Fri, 25 Nov 2011 15:05:25 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Dec 2011 08:44:00 -0200

perf script: Implement option for system-wide profiling

The option is documented in man perf-script but was not yet implemented:

       -a
           Force system-wide collection. Scripts run without a
           <command> normally use -a by default, while scripts run
           with a <command> normally don't - this option allows the
           latter to be run in system-wide mode.

As with perf record you now can profile in system-wide mode for the
runtime of a given command, e.g.:

 # perf script -a syscall-counts sleep 2

Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/1322229925-10075-1-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ccbfd56..ea71c5e 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -24,6 +24,7 @@ static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
 static bool			show_full_info;
+static bool			system_wide;
 static const char		*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
@@ -1105,6 +1106,8 @@ static const struct option options[] = {
 	OPT_CALLBACK('f', "fields", NULL, "str",
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
+	OPT_BOOLEAN('a', "all-cpus", &system_wide,
+		     "system-wide collection from all CPUs"),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
 		   "only display events for these comms"),
@@ -1134,7 +1137,6 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	struct perf_session *session;
 	char *script_path = NULL;
 	const char **__argv;
-	bool system_wide;
 	int i, j, err;
 
 	setup_scripting();
@@ -1202,15 +1204,17 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		}
 
 		if (!pid) {
-			system_wide = true;
 			j = 0;
 
 			dup2(live_pipe[1], 1);
 			close(live_pipe[0]);
 
-			if (!is_top_script(argv[0]))
+			if (is_top_script(argv[0])) {
+				system_wide = true;
+			} else if (!system_wide) {
 				system_wide = !have_cmd(argc - rep_args,
 							&argv[rep_args]);
+			}
 
 			__argv = malloc((argc + 6) * sizeof(const char *));
 			if (!__argv)
@@ -1258,10 +1262,11 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		script_path = rep_script_path;
 
 	if (script_path) {
-		system_wide = false;
 		j = 0;
 
-		if (rec_script_path)
+		if (!rec_script_path)
+			system_wide = false;
+		else if (!system_wide)
 			system_wide = !have_cmd(argc - 1, &argv[1]);
 
 		__argv = malloc((argc + 2) * sizeof(const char *));
