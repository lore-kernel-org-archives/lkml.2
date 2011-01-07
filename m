Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1AGDKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:10:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:11683 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab1AGDKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:10:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,286,1291622400"; 
   d="scan'208";a="371278486"
Subject: [PATCH] perf tools: Pass whole attr to event selectors
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 11:11:09 +0800
Message-ID: <1294369869.20563.19.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 69aad6f1(perf tools: Introduce event selectors), only
perf_event_attr::type and ::config are passed to event selector, which
makes perf tool not work correctly.

For example, PEBS does not work because perf_event_attr::precise_ip is
not passed to the syscall.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/builtin-stat.c      |    3 +--
 tools/perf/builtin-test.c      |    6 +++++-
 tools/perf/util/evsel.c        |    5 ++---
 tools/perf/util/evsel.h        |    2 +-
 tools/perf/util/parse-events.c |   13 ++++++++++---
 5 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 02b2d80..2dfcb61 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -683,8 +683,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		nr_counters = ARRAY_SIZE(default_attrs);
 
 		for (c = 0; c < ARRAY_SIZE(default_attrs); ++c) {
-			pos = perf_evsel__new(default_attrs[c].type,
-					      default_attrs[c].config,
+			pos = perf_evsel__new(&default_attrs[c],
 					      nr_counters);
 			if (pos == NULL)
 				goto out;
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1c98434..e12753f 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -264,6 +264,7 @@ static int test__open_syscall_event(void)
 	int err = -1, fd;
 	struct thread_map *threads;
 	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
 	unsigned int nr_open_calls = 111, i;
 	int id = trace_event__id("sys_enter_open");
 
@@ -278,7 +279,10 @@ static int test__open_syscall_event(void)
 		return -1;
 	}
 
-	evsel = perf_evsel__new(PERF_TYPE_TRACEPOINT, id, 0);
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.config = id;
+	evsel = perf_evsel__new(&attr, 0);
 	if (evsel == NULL) {
 		pr_debug("perf_evsel__new\n");
 		goto out_thread_map_delete;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c95267e..1a5591d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -6,14 +6,13 @@
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
-struct perf_evsel *perf_evsel__new(u32 type, u64 config, int idx)
+struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 {
 	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
 
 	if (evsel != NULL) {
 		evsel->idx	   = idx;
-		evsel->attr.type   = type;
-		evsel->attr.config = config;
+		evsel->attr	   = *attr;
 		INIT_LIST_HEAD(&evsel->node);
 	}
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a0ccd69..b2d755f 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -37,7 +37,7 @@ struct perf_evsel {
 struct cpu_map;
 struct thread_map;
 
-struct perf_evsel *perf_evsel__new(u32 type, u64 config, int idx);
+struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 649083f..5dd04e7 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -824,7 +824,7 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 
 		if (ret != EVT_HANDLED_ALL) {
 			struct perf_evsel *evsel;
-			evsel = perf_evsel__new(attr.type, attr.config,
+			evsel = perf_evsel__new(&attr,
 						nr_counters);
 			if (evsel == NULL)
 				return -1;
@@ -1014,8 +1014,15 @@ void print_events(void)
 
 int perf_evsel_list__create_default(void)
 {
-	struct perf_evsel *evsel = perf_evsel__new(PERF_TYPE_HARDWARE,
-						   PERF_COUNT_HW_CPU_CYCLES, 0);
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_HARDWARE;
+	attr.config = PERF_COUNT_HW_CPU_CYCLES;
+
+	evsel = perf_evsel__new(&attr, 0);
+
 	if (evsel == NULL)
 		return -ENOMEM;
 


