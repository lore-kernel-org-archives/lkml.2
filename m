Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1HQKoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 06:44:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:7618 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1HQKoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 06:44:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,239,1312182000"; 
   d="scan'208";a="40513676"
Subject: [PATCH] perf tool: Add group event scheduling option to perf
 record/stat
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 17 Aug 2011 18:42:07 +0800
Message-ID: <1313577727.2754.5.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group event scheduling option is missing in perf record/stat.
Add it to perf record/stat, which is same as in perf top.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/builtin-record.c |    4 +++-
 tools/perf/builtin-stat.c   |    7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f6426b4..6b0519f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -45,7 +45,7 @@ static int			freq				=   1000;
 static int			output;
 static int			pipe_output			=      0;
 static const char		*output_name			= NULL;
-static int			group				=      0;
+static bool			group				=  false;
 static int			realtime_prio			=      0;
 static bool			nodelay				=  false;
 static bool			raw_samples			=  false;
@@ -753,6 +753,8 @@ const struct option record_options[] = {
 		    "child tasks do not inherit counters"),
 	OPT_UINTEGER('F', "freq", &user_freq, "profile at this frequency"),
 	OPT_UINTEGER('m', "mmap-pages", &mmap_pages, "number of mmap data pages"),
+	OPT_BOOLEAN(0, "group", &group,
+		    "put the counters into a counter group"),
 	OPT_BOOLEAN('g', "call-graph", &call_graph,
 		    "do call-graph (stack chain/backtrace) recording"),
 	OPT_INCR('v', "verbose", &verbose,
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1ad04ce..5deb17d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -193,6 +193,7 @@ static int			big_num_opt			=  -1;
 static const char		*cpu_list;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
+static bool			group				= false;
 
 static volatile int done = 0;
 
@@ -280,14 +281,14 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 	attr->inherit = !no_inherit;
 
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus, false);
+		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus, group);
 
 	if (target_pid == -1 && target_tid == -1) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, evsel_list->threads, false);
+	return perf_evsel__open_per_thread(evsel, evsel_list->threads, group);
 }
 
 /*
@@ -1043,6 +1044,8 @@ static const struct option options[] = {
 		    "stat events on existing thread id"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
+	OPT_BOOLEAN('g', "group", &group,
+		    "put the counters into a counter group"),
 	OPT_BOOLEAN('c', "scale", &scale,
 		    "scale/normalize counters"),
 	OPT_INCR('v', "verbose", &verbose,
-- 
1.7.3.1



