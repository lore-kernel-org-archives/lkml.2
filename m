Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161407Ab2CPUE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:04:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34778 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab2CPUCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:02:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/13] perf stat: Fix event grouping on forked task
Date: Fri, 16 Mar 2012 17:02:04 -0300
Message-Id: <1331928130-16243-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1331928130-16243-1-git-send-email-acme@infradead.org>
References: <1331928130-16243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331887340-32448-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ea40e4e..c941bb6 100644
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
1.7.9.2.358.g22243

