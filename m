Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1AIRuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 12:50:32 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:40354 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1AIRub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 12:50:31 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
From: David Ahern <daahern@cisco.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        David Ahern <daahern@cisco.com>
Subject: [PATCH] perf stat: fix scale option
Date: Sun,  9 Jan 2011 10:50:25 -0700
Message-Id: <1294595425-16791-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scale option defaults to true and the command line option only
allows it to be set to true. ie. the option is a no-op.

Changes the scale option to no_scale to maintain current default
of scaling enabled; no_scale set to true then disables scaling.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-stat.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 02b2d80..42dfeec 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -77,7 +77,7 @@ static int			run_idx				=  0;
 
 static int			run_count			=  1;
 static bool			no_inherit			= false;
-static bool			scale				=  true;
+static bool			no_scale			= false;
 static bool			no_aggr				= false;
 static pid_t			target_pid			= -1;
 static pid_t			target_tid			= -1;
@@ -161,7 +161,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 {
 	struct perf_event_attr *attr = &evsel->attr;
 
-	if (scale)
+	if (!no_scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
@@ -199,7 +199,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	u64 *count = counter->counts->aggr.values;
 	int i;
 
-	if (__perf_evsel__read(counter, cpus->nr, threads->nr, scale) < 0)
+	if (__perf_evsel__read(counter, cpus->nr, threads->nr, !no_scale) < 0)
 		return -1;
 
 	for (i = 0; i < 3; i++)
@@ -233,7 +233,7 @@ static int read_counter(struct perf_evsel *counter)
 	int cpu;
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		if (__perf_evsel__read_on_cpu(counter, cpu, 0, scale) < 0)
+		if (__perf_evsel__read_on_cpu(counter, cpu, 0, !no_scale) < 0)
 			return -1;
 
 		count = counter->counts->cpu[cpu].values;
@@ -619,8 +619,8 @@ static const struct option options[] = {
 		    "stat events on existing thread id"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
-	OPT_BOOLEAN('c', "scale", &scale,
-		    "scale/normalize counters"),
+	OPT_BOOLEAN('c', "no-scale", &no_scale,
+		    "disable scaling / normalization of counters"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_INTEGER('r', "repeat", &run_count,
-- 
1.7.3.4

