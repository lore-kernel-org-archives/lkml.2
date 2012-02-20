Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2BTBq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:46:58 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64601 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab2BTBq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:46:56 -0500
X-AuditID: 9c930197-b7cdbae000001518-0d-4f41a60df49e
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf stat: Fix event grouping on forked task
Date: Mon, 20 Feb 2012 11:04:57 +0900
Message-Id: <1329703498-25192-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
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
 tools/perf/builtin-stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e54cbc9fc4fd..cda1e757ea87 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -296,7 +296,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 	if (system_wide)
 		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
 						group, group_fd);
-	if (!target_pid && !target_tid) {
+	if (!target_pid && !target_tid && (!group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
-- 
1.7.9

