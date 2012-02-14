Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab2BNBEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:04:08 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61203 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2BNBEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:04:06 -0500
X-AuditID: 9c930197-b7cdbae000001518-16-4f39b3034271
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf stat: Fix event grouping on forked task
Date: Tue, 14 Feb 2012 10:20:32 +0900
Message-Id: <1329182432-15189-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <20120213184121.GJ15955@infradead.org>
References: <20120213184121.GJ15955@infradead.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When event group is enabled for forked task (i.e. no target task was
specified) all events were disabled and marked ->enable_on_exec.
However they are not counted at all since only group leader will be
enabled on exec actually. So the result looked like below:

 $ ./perf stat --group -- sleep 1

 Performance counter stats for 'sleep 1':

          0.554926 task-clock                #    0.001 CPUs utilized
     <not counted> context-switches
     <not counted> CPU-migrations
     <not counted> page-faults
     <not counted> cycles
   <not supported> stalled-cycles-frontend
   <not supported> stalled-cycles-backend
     <not counted> instructions
     <not counted> branches
     <not counted> branch-misses

       1.001228093 seconds time elapsed

Fix it by disabling group leader only.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-stat.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index d14b37ad7638..b2fa61e539c0 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -296,7 +296,8 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 	if (system_wide)
 		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
 						group, group_fd);
-	if (target_pid == -1 && target_tid == -1) {
+	if (target_pid == -1 && target_tid == -1 &&
+	    (!group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
-- 
1.7.9

