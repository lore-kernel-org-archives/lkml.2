Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032336Ab2CPImH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:42:07 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61691 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965450Ab2CPIl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:41:59 -0400
X-AuditID: 9c930179-b7b27ae000000e38-cd-4f62fcd4f561
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND 1/2] perf stat: Fix event grouping on forked task
Date: Fri, 16 Mar 2012 17:42:19 +0900
Message-Id: <1331887340-32448-1-git-send-email-namhyung.kim@lge.com>
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
index ea40e4e8b227..c941bb640f49 100644
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

