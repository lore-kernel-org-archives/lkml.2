Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1GOObU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:31:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:41991 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1GOOaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:30:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,535,1304319600"; 
   d="scan'208";a="26267130"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/6] perf tool: Allow system-wide 'perf stat' without 'command'
Date: Fri, 15 Jul 2011 14:35:02 +0000
Message-Id: <1310740503-15608-6-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are package level counters, for example Intel uncore counters,
can't be limited to process. So we should allow 'perf stat' to run without 'command'.

$ sudo perf stat -a -C 0 -e uncore:cycle
^C
 Performance counter stats for 'CPU 0':

        56,547,314 uncore:cycle

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/builtin-stat.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1d08c80..84546ff 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -958,7 +958,14 @@ static void print_stat(int argc, const char **argv)
 	if (!csv_output) {
 		fprintf(stderr, "\n");
 		fprintf(stderr, " Performance counter stats for ");
-		if(target_pid == -1 && target_tid == -1) {
+		if (system_wide) {
+			fprintf(stderr, "\'CPU ");
+			for (i = 0; i < evsel_list->cpus->nr; i++) {
+				fprintf(stderr, "%d", evsel_list->cpus->map[i]);
+				if (i < evsel_list->cpus->nr - 1)
+					fprintf(stderr, ",");
+			}
+		} else if (target_pid == -1 && target_tid == -1) {
 			fprintf(stderr, "\'%s", argv[0]);
 			for (i = 1; i < argc; i++)
 				fprintf(stderr, " %s", argv[i]);
@@ -1166,7 +1173,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && target_pid == -1 && target_tid == -1)
+	if (!system_wide && !argc && target_pid == -1 && target_tid == -1)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
-- 
1.7.5.1

