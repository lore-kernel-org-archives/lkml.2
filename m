Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1HVRCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 13:02:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:42086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab1HVRCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 13:02:20 -0400
Date: Mon, 22 Aug 2011 19:00:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110822170058.GA16562@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Mon, 22 Aug 2011 17:02:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Geunsik Lim (1):
      MAINTAINERS: Fix list of perf events source files

Josh Boyer (1):
      perf tools: Fix build against newer glibc

Lin Ming (1):
      perf tools: Add group event scheduling option to perf record/stat

Stephane Eranian (3):
      perf list: Fix exit value
      perf evlist: Fix missing event name init for default event
      perf tools: Fix error handling of unknown events


 MAINTAINERS                              |    2 +-
 tools/perf/builtin-record.c              |    4 +++-
 tools/perf/builtin-stat.c                |    7 +++++--
 tools/perf/util/evlist.c                 |   11 ++++++++++-
 tools/perf/util/include/linux/compiler.h |    2 ++
 tools/perf/util/parse-events.c           |    8 +++++---
 6 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d445f5..069ee3b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4971,7 +4971,7 @@ M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 S:	Supported
-F:	kernel/perf_event*.c
+F:	kernel/events/*
 F:	include/linux/perf_event.h
 F:	arch/*/kernel/perf_event*.c
 F:	arch/*/kernel/*/perf_event*.c
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
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index e03e7bc..c12bd47 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -85,10 +85,19 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 	struct perf_evsel *evsel = perf_evsel__new(&attr, 0);
 
 	if (evsel == NULL)
-		return -ENOMEM;
+		goto error;
+
+	/* use strdup() because free(evsel) assumes name is allocated */
+	evsel->name = strdup("cycles");
+	if (!evsel->name)
+		goto error_free;
 
 	perf_evlist__add(evlist, evsel);
 	return 0;
+error_free:
+	perf_evsel__delete(evsel);
+error:
+	return -ENOMEM;
 }
 
 void perf_evlist__disable(struct perf_evlist *evlist)
diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index 791f9dd..547628e 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -5,7 +5,9 @@
 #define __always_inline	inline
 #endif
 #define __user
+#ifndef __attribute_const__
 #define __attribute_const__
+#endif
 
 #define __used		__attribute__((__unused__))
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4ea7e19..928918b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -697,7 +697,11 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
-		*strp = str + n + 1;
+		const char *end = str + n + 1;
+		if (*end != '\0' && *end != ',' && *end != ':')
+			return EVT_FAILED;
+
+		*strp = end;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
 		return EVT_HANDLED;
@@ -1097,6 +1101,4 @@ void print_events(const char *event_glob)
 	printf("\n");
 
 	print_tracepoint_events(NULL, NULL);
-
-	exit(129);
 }
