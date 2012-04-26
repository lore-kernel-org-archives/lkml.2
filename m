Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab2DZFQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:16:33 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54562 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab2DZFQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:26 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-3e-4f98da276603
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 13/13] perf stat: Use perf_evlist__create_maps
Date: Thu, 26 Apr 2012 14:15:27 +0900
Message-Id: <1335417327-11796-14-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use same function with perf record and top to share the code
checks combinations of different switches.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-stat.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index d9ff24637eeb..e720ba7b801e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -175,7 +175,9 @@ static struct perf_event_attr very_very_detailed_attrs[] = {
 
 static struct perf_evlist	*evsel_list;
 
-static struct perf_target	target;
+static struct perf_target	target = {
+	.uid	= UINT_MAX,
+};
 
 static int			run_idx				=  0;
 static int			run_count			=  1;
@@ -1205,20 +1207,12 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	perf_target__validate(&target);
 
-	evsel_list->threads = thread_map__new_str(target.pid,
-						  target.tid, UINT_MAX);
-	if (evsel_list->threads == NULL) {
-		pr_err("Problems finding threads of monitor\n");
-		usage_with_options(stat_usage, options);
-	}
-
-	if (target.system_wide)
-		evsel_list->cpus = cpu_map__new(target.cpu_list);
-	else
-		evsel_list->cpus = cpu_map__dummy_new();
+	if (perf_evlist__create_maps(evsel_list, &target) < 0) {
+		if (!perf_target__no_task(&target))
+			pr_err("Problems finding threads of monitor\n");
+		if (!perf_target__no_cpu(&target))
+			perror("failed to parse CPUs map");
 
-	if (evsel_list->cpus == NULL) {
-		perror("failed to parse CPUs map");
 		usage_with_options(stat_usage, options);
 		return -1;
 	}
-- 
1.7.10

