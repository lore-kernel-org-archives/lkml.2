Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab1LFKdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:33:14 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:50656
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933262Ab1LFKdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:33:09 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVS2N4-02-F93-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 02/10] perf script: Implement option for system-wide profiling
Date: Tue, 6 Dec 2011 11:32:32 +0100
Message-ID: <1323167560-2282-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The option is documented in man perf-script but was not yet
implemented:

       -a
           Force system-wide collection. Scripts run without a
           <command> normally use -a by default, while scripts run
           with a <command> normally don't - this option allows the
           latter to be run in system-wide mode.

As with perf record you now can profile in system-wide mode for the
runtime of a given command, e.g.:

 # perf script -a syscall-counts sleep 2

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-script.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index bcfc00e..82cca10 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -23,6 +23,7 @@ static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
 static bool			show_full_info;
+static bool			system_wide;
 static const char		*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
@@ -1093,6 +1094,8 @@ static const struct option options[] = {
 	OPT_CALLBACK('f', "fields", NULL, "str",
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
+	OPT_BOOLEAN('a', "all-cpus", &system_wide,
+			    "system-wide collection from all CPUs"),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_BOOLEAN('I', "show-info", &show_full_info,
 		    "display extended information from perf.data file"),
@@ -1120,7 +1123,6 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	struct perf_session *session;
 	char *script_path = NULL;
 	const char **__argv;
-	bool system_wide;
 	int i, j, err;
 
 	setup_scripting();
@@ -1188,15 +1190,17 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
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
@@ -1244,10 +1248,11 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
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
-- 
1.7.7


