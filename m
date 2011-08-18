Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1HRUND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:13:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:46991 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab1HRUNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:13:00 -0400
Date: Thu, 18 Aug 2011 20:12:45 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Message-ID: <tip-43bece79796c2a39ec98998fd3f1071f04f3d8c3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1313577727.2754.5.camel@hp6530s>
References: <1313577727.2754.5.camel@hp6530s>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add group event scheduling option to perf record/stat
Git-Commit-ID: 43bece79796c2a39ec98998fd3f1071f04f3d8c3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Thu, 18 Aug 2011 20:12:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43bece79796c2a39ec98998fd3f1071f04f3d8c3
Gitweb:     http://git.kernel.org/tip/43bece79796c2a39ec98998fd3f1071f04f3d8c3
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Wed, 17 Aug 2011 18:42:07 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 18 Aug 2011 07:35:46 -0300

perf tools: Add group event scheduling option to perf record/stat

Group event scheduling command line option is missing in perf
record/stat.

Add it to perf record/stat, which is same as in perf top.

Reported-by: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1313577727.2754.5.camel@hp6530s
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
