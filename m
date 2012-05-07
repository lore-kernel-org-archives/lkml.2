Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2EGFLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:11:31 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49169 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2EGFKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:10:34 -0400
X-AuditID: 9c930197-b7badae000000cfd-f2-4fa759461922
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 7/7] perf stat: Use perf_evlist__create_maps
Date: Mon,  7 May 2012 14:09:04 +0900
Message-Id: <1336367344-28071-8-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
References: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use same function with perf record and top to share the code
checks combinations of different switches.

Reviewed-by: David Ahern <dsahern@gmail.com>
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
1.7.10.1

